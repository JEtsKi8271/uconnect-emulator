package com.nfuzion.display.ui
{
   import com.harman.ui.ScreenMovieClip;
   import core.locale.LocaleArchive;
   import core.utils.Graphic;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.text.TextFormatAlign;
   import skin.Skin;
   
   public dynamic class AudioSettingsScreenViewMovieClip extends ScreenMovieClip
   {
      
      public var optionOverlays_group:MovieClip;
      
      public var mTrackMinY:int = 22;
      
      public var mTrackMaxY:int = 151;
      
      public var mTrackMinX:int = 22;
      
      public var mTrackMaxX:int = 151;
      
      private var mMouseX:int = 87;
      
      private var mMouseY:int = 87;
      
      public const CENTER_X:int = 87;
      
      public const CENTER_Y:int = 87;
      
      public const INC:Number = 7.222222222222222;
      
      public const TAB_POS:Array = [10,68,124,180,238];
      
      public const AUX_POS:Array = [81,113,145,162,179,208,240];
      
      public function AudioSettingsScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.bass_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.bassValue_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.mid_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.treble_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.midValue_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.equalizer_group.trebleValue_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.speedAdjustedVolume_group.description_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.surroundSound_group.description_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.loudness_group.description,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.auxVolumeOffset_group.title,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.auxVolumeOffset_group.value,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.auxVolumeOffset_group.description,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.autoOnRadio_group.description,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.optionOverlays_group.AutoPlayAudio_group.description,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.bass_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.bassValue_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.mid_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.treble_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.midValue_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.equalizer_group.trebleValue_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.speedAdjustedVolume_group.description_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.optionOverlays_group.surroundSound_group.description_translate,Skin.style.currentTheme.primaryText);
      }
      
      override protected function updateAlignment() : void
      {
         Graphic.mirror(this.back_button);
         Graphic.mirror(this.close_button);
         if(LocaleArchive.getInstance().isMirrored())
         {
            Text.align(this.displayTitle.labelValue,TextFormatAlign.RIGHT);
            this.back_button.x = 630;
            this.close_button.x = 98;
         }
         else
         {
            Text.align(this.displayTitle.labelValue,TextFormatAlign.LEFT);
            this.back_button.x = 10;
            this.close_button.x = 544;
         }
      }
   }
}

