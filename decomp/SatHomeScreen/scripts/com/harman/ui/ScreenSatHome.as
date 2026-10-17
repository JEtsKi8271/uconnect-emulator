package com.harman.ui
{
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class ScreenSatHome extends ScreenSource
   {
      
      public var replay:MovieClip;
      
      public var displaySat:MovieClip;
      
      public var displayPopupTitle:MovieClip;
      
      public var FIELD_X_DEFAULT:int = 244;
      
      public var FIELD_W_DEFAULT:int = 330;
      
      public var FIELD_X_INDENT:int = 275;
      
      public var FIELD_W_INDENT:int = 300;
      
      public var ICON_X_INDENT:int = 247;
      
      public var FAV_X_DEFAULT:int = 224;
      
      public var TAG_X_DEFAULT:int = 219;
      
      public var CHANNEL_ART_SIZE:int = 120;
      
      public function ScreenSatHome()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.replay.replay_scroller.thumb_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPopupTitle.labelA,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPopupTitle.labelB,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displayPopupTitle.labelC,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySat.labelChannelName,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySat.labelAlbumName,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySat.labelSongTitle,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.displaySat.labelGenre,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.displayPopupTitle.labelA,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.displayPopupTitle.labelB,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.displayPopupTitle.labelC,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.displaySat.labelChannelName,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.displaySat.labelAlbumName,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.displaySat.labelSongTitle,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.displaySat.labelGenre,Skin.style.currentTheme.primaryText);
      }
   }
}

