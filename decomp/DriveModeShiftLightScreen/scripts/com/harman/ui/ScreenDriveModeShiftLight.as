package com.harman.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ScreenDriveModeShiftLight extends BaseMovieClip implements IMovieClip
   {
      
      public function ScreenDriveModeShiftLight()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.shiftlight_text,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.shiftlight_text,Skin.style.currentTheme.primaryText);
      }
   }
}

