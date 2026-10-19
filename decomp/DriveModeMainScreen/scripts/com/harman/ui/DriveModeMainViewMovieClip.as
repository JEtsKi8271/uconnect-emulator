package com.harman.ui
{
   import core.locale.LocaleArchive;
   import skin.Skin;
   
   public dynamic class DriveModeMainViewMovieClip extends ScreenMovieClip
   {
      
      public function DriveModeMainViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.Warning_message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.Layer_SRT.buttons_group.key_buttons_popup.message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.Layer_SRT.Warning_message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.Layer_WK.Warning_message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.Layer_WK.track_off_message.track_message,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.Warning_message,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.Layer_SRT.buttons_group.key_buttons_popup.message,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.Layer_SRT.Warning_message,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.Layer_WK.Warning_message,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.Layer_WK.track_off_message.track_message,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         this.Layer_SRT.display_driveMode_status_group.updateAlignment();
         this.Layer_WK.display_driveMode_WK_status_group.updateAlignment();
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.Layer_SRT.buttons_group.key_buttons_popup.info_icon.x = 250;
         }
         else
         {
            this.Layer_SRT.buttons_group.key_buttons_popup.info_icon.x = 20;
         }
      }
   }
}

