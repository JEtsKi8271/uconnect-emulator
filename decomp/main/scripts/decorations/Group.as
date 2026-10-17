package decorations
{
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public dynamic class Group extends Simple
   {
      
      private var mGroup:MovieClip;
      
      private var mExclusiveChildren:Boolean = false;
      
      private var mRadioButtons:Boolean = false;
      
      private var mRequireSelection:Boolean = false;
      
      private var currentMovieClip:MovieClip = null;
      
      private var mEventsRequireChange:Boolean = true;
      
      public function Group(group:MovieClip)
      {
         super(group);
         this.mGroup = group;
      }
      
      public function setExclusiveChildren(exclusiveChildren:Boolean) : void
      {
         this.mExclusiveChildren = exclusiveChildren;
         if(exclusiveChildren)
         {
            this.mGroup.addEventListener(WidgetEvent.VISIBILITY,this.onVisibility,false,0,true);
         }
         else
         {
            this.mGroup.removeEventListener(WidgetEvent.VISIBILITY,this.onVisibility);
         }
         if(exclusiveChildren)
         {
            this.onVisibility();
         }
      }
      
      public function getExclusiveChildren() : Boolean
      {
         return this.mExclusiveChildren;
      }
      
      public function setRadioButtons(radioButtons:Boolean) : void
      {
         var movieClip:MovieClip = null;
         this.mRadioButtons = radioButtons;
         var found:Boolean = false;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
            {
               if(radioButtons)
               {
                  movieClip.addEventListener(MouseEvent.CLICK,this.onButtonClick,false,0,true);
                  if(found)
                  {
                     movieClip.setSelected(false);
                  }
                  else if(movieClip.getHighlight())
                  {
                     found = true;
                  }
               }
               else
               {
                  movieClip.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
               }
            }
         }
      }
      
      public function getRadioButtons() : Boolean
      {
         return this.mRadioButtons;
      }
      
      public function setRequireSelection(requireSelection:Boolean) : void
      {
         var index:int = 0;
         var movieClip:MovieClip = null;
         this.mRequireSelection = requireSelection;
         var selectedButton:MovieClip = null;
         if(requireSelection)
         {
            for(index = 0; index < this.mGroup.numChildren; index++)
            {
               movieClip = this.mGroup.getChildAt(index) as MovieClip;
               if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
               {
                  if(selectedButton == null)
                  {
                     selectedButton = movieClip;
                  }
                  if(movieClip.getHighlight())
                  {
                     selectedButton = movieClip;
                     break;
                  }
               }
            }
            if(selectedButton != null)
            {
               this.setSelection(selectedButton.name);
            }
         }
      }
      
      public function getRequireSelection() : Boolean
      {
         return this.mRequireSelection;
      }
      
      public function setSelection(selection:String, doEventDispatch:Boolean = true) : void
      {
         var movieClip:MovieClip = null;
         var found:Boolean = false;
         var noChange:Boolean = false;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
            {
               if(found || movieClip.name != selection)
               {
                  movieClip.setSelected(false);
               }
               else
               {
                  found = true;
                  if(movieClip.getHighlight())
                  {
                     if(movieClip.name == selection)
                     {
                        noChange = true;
                     }
                  }
                  else
                  {
                     movieClip.setSelected(true);
                  }
               }
            }
         }
         if((!noChange || !this.mEventsRequireChange) && doEventDispatch)
         {
            this.mGroup.dispatchEvent(new WidgetEvent(WidgetEvent.SELECT,{"targetName":(found ? selection : null)},true));
         }
      }
      
      public function getSelection() : String
      {
         var movieClip:MovieClip = null;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
            {
               if(movieClip.getHighlight())
               {
                  return movieClip.name;
               }
            }
         }
         return null;
      }
      
      public function hideChildren(e:Event = null) : void
      {
         var movieClip:MovieClip = null;
         var found:Boolean = false;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && Boolean(movieClip.decoratorType))
            {
               movieClip.visible = false;
            }
         }
      }
      
      private function onVisibility(e:WidgetEvent = null) : void
      {
         var movieClip:MovieClip = null;
         var found:Boolean = false;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && Boolean(movieClip.decoratorType))
            {
               if(movieClip.visible)
               {
                  if(!found)
                  {
                     if(movieClip != this.currentMovieClip)
                     {
                        if(this.currentMovieClip != null)
                        {
                           this.currentMovieClip.visible = false;
                        }
                        this.currentMovieClip = movieClip;
                        found = true;
                     }
                  }
                  else
                  {
                     movieClip.visible = false;
                  }
               }
            }
         }
      }
      
      private function onButtonClick(e:MouseEvent) : void
      {
         if(!e.currentTarget.getHighlight())
         {
            if(e.currentTarget.getEnabled())
            {
               this.setSelection(e.currentTarget.name);
            }
            else
            {
               this.mGroup.dispatchEvent(new WidgetEvent(WidgetEvent.SELECT,{"targetName":e.currentTarget.name},true));
            }
         }
         else if(!this.mRequireSelection)
         {
            this.setSelection(null);
         }
         else
         {
            this.setSelection(e.currentTarget.name);
         }
      }
      
      override public function setEnabled(enable:Boolean) : void
      {
         var movieClip:MovieClip = null;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && Boolean(movieClip.decoratorType))
            {
               movieClip.setEnabled(enable);
            }
         }
         super.setEnabled(enable);
      }
      
      override public function setInteractive(interactive:Boolean) : void
      {
         super.setInteractive(interactive);
      }
      
      public function nextSelection() : void
      {
         var movieClip:MovieClip = null;
         var found:Boolean = false;
         var newSelection:String = null;
         for(var index:int = 0; index < this.mGroup.numChildren; index++)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
            {
               if(newSelection == null)
               {
                  newSelection = movieClip.name;
               }
               if(found)
               {
                  newSelection = movieClip.name;
                  break;
               }
               if(movieClip.getSelected())
               {
                  found = true;
               }
            }
         }
         if(newSelection != null)
         {
            this.setSelection(newSelection);
         }
      }
      
      public function previousSelection() : void
      {
         var movieClip:MovieClip = null;
         var found:Boolean = false;
         var newSelection:String = null;
         for(var index:* = int(this.mGroup.numChildren - 1); index >= 0; index--)
         {
            movieClip = this.mGroup.getChildAt(index) as MovieClip;
            if(movieClip != null && (movieClip.decoratorType == "button" || movieClip.decoratorType == "button_ui"))
            {
               if(newSelection == null)
               {
                  newSelection = movieClip.name;
               }
               if(found)
               {
                  newSelection = movieClip.name;
                  break;
               }
               if(movieClip.getSelected())
               {
                  found = true;
               }
            }
         }
         if(newSelection != null)
         {
            this.setSelection(newSelection);
         }
      }
      
      public function setEventsRequireChange(value:Boolean) : void
      {
         this.mEventsRequireChange = value;
      }
      
      public function getEventsRequireChange() : Boolean
      {
         return this.mEventsRequireChange;
      }
   }
}

