package core.widgets
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   import skin.StyleEvent;
   
   public dynamic class WidgetBase extends MovieClip implements IMovieClip
   {
      
      protected var mPreviousFrame:Object = null;
      
      public function WidgetBase()
      {
         this.stop();
         super();
         this.updateTheme();
         this.interactiveChildren();
         this.addListeners();
      }
      
      override public function gotoAndStop(frame:Object, scene:String = null) : void
      {
         if(frame != this.mPreviousFrame)
         {
            super.gotoAndStop(frame,scene);
            this.updateTheme();
         }
         this.mPreviousFrame = frame;
      }
      
      protected function interactiveChildren() : void
      {
      }
      
      protected function updateTheme() : void
      {
      }
      
      protected function addListeners() : void
      {
         Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChangeEvent,false,0,true);
      }
      
      protected function onThemeChangeEvent(e:StyleEvent) : void
      {
         this.updateTheme();
      }
   }
}

