package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   import skin.StyleEvent;
   
   public dynamic class BaseMovieClip extends MovieClip implements IMovieClip
   {
      
      protected var mIsChangingFrame:Boolean = false;
      
      public function BaseMovieClip()
      {
         super();
         this.stop();
         if(Skin.style != null)
         {
            Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChangeEvent,false,0,true);
            this.updateTheme();
         }
      }
      
      protected function updateTheme() : void
      {
      }
      
      override public function gotoAndStop(frame:Object, scene:String = null) : void
      {
         super.gotoAndStop(frame,scene);
         this.mIsChangingFrame = true;
         this.updateTheme();
         this.mIsChangingFrame = false;
      }
      
      protected function onThemeChangeEvent(evt:StyleEvent) : void
      {
         this.updateTheme();
      }
   }
}

