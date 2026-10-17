package decorations
{
   import events.WidgetEvent;
   import flash.display.MovieClip;
   
   public dynamic class Simple
   {
      
      private var mSimple:MovieClip;
      
      public function Simple(simple:MovieClip)
      {
         super();
         this.mSimple = simple;
      }
      
      public function show() : void
      {
         if(!this.mSimple.visible)
         {
            this.mSimple.visible = true;
            this.mSimple.dispatchEvent(new WidgetEvent(WidgetEvent.VISIBILITY,null,true));
         }
      }
      
      public function hide() : void
      {
         if(this.mSimple.visible)
         {
            this.mSimple.visible = false;
            this.mSimple.dispatchEvent(new WidgetEvent(WidgetEvent.VISIBILITY,null,true));
         }
      }
      
      public function getEnabled() : Boolean
      {
         return this.mSimple.enabled;
      }
      
      public function setEnabled(enable:Boolean) : void
      {
         this.mSimple.enabled = enable;
         this.update();
      }
      
      public function getInteractive() : Boolean
      {
         return this.mSimple.mouseEnabled;
      }
      
      public function setInteractive(interactive:Boolean) : void
      {
         this.mSimple.mouseEnabled = interactive;
         this.mSimple.mouseChildren = interactive;
      }
      
      public function update() : void
      {
      }
   }
}

