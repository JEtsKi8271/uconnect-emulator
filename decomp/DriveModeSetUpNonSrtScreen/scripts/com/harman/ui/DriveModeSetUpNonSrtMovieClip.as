package com.harman.ui
{
   import skin.Skin;
   
   public dynamic class DriveModeSetUpNonSrtMovieClip extends ScreenMovieClip
   {
      
      public function DriveModeSetUpNonSrtMovieClip()
      {
         super();
      }
      
      override protected function updateAlignment() : void
      {
         this.drive_mode_group.updateAlignment();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.Warning_message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.Warning_message,Skin.style.currentTheme.primaryText);
      }
   }
}

