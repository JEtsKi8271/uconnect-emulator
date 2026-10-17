package com.harman.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   import skin.StyleEvent;
   
   public dynamic class BaseMovieClip extends MovieClip implements IMovieClip
   {
      
      protected var mPreviousFrame:Object = null;
      
      public function BaseMovieClip()
      {
         this.stop();
         super();
         Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChangeEvent,false,0,true);
         this.updateTheme();
      }
      
      protected function updateTheme() : void
      {
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
      
      protected function onThemeChangeEvent(evt:StyleEvent) : void
      {
         this.updateTheme();
      }
   }
}

