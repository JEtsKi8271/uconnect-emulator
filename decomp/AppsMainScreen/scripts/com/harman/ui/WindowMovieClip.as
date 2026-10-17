package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class WindowMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var mFocus:Boolean;
      
      public var mSelected:int = 0;
      
      public var mSelectTarget:ButtonMovieClip = null;
      
      public function WindowMovieClip()
      {
         super();
         this.mSelectTarget = this["item" + this.mSelected + "_button"];
      }
      
      public function set selected(select:int) : void
      {
         this.mSelected = select;
         this.selectTarget = this["item" + select + "_button"];
      }
      
      public function get selected() : int
      {
         return this.mSelected;
      }
      
      public function set selectTarget(selectTarget:ButtonMovieClip) : void
      {
         if(this.mSelectTarget)
         {
            this.mSelectTarget.setHighlight(false);
         }
         this.setCursorVisibility(false);
         this.mSelectTarget = selectTarget;
         if(this.mSelectTarget)
         {
            this.mSelectTarget.setHighlight(true);
         }
         this.setCursorVisibility(true);
      }
      
      public function get selectTarget() : ButtonMovieClip
      {
         return this.mSelectTarget;
      }
      
      public function ellipses(textField:TextField, text:String, ellipsis:String = "…") : void
      {
         textField.text = text;
         while(textField.numLines == 1 && textField.textWidth > textField.width - 4 || textField.numLines > 1 && textField.textHeight > textField.height - 4)
         {
            text = text.substring(0,text.length - 2);
            textField.text = text + ellipsis;
         }
      }
      
      protected function setCursorVisibility(_visible:Boolean) : void
      {
         if(Boolean(this.mSelectTarget) && Boolean(this.mSelectTarget.hasOwnProperty("cursor")))
         {
            if(this.mFocus && _visible)
            {
               this.mSelectTarget.cursor.visible = true;
            }
            else
            {
               this.mSelectTarget.cursor.visible = false;
            }
         }
      }
      
      public function get cursor() : MovieClip
      {
         return this.mSelectTarget.cursor;
      }
      
      public function set focus(_focus:Boolean) : void
      {
         this.mFocus = _focus;
         if(this.mSelectTarget)
         {
            this.mSelectTarget.cursor.visible = this.mFocus;
         }
      }
   }
}

