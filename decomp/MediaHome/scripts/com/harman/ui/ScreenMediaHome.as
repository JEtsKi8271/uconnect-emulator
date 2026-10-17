package com.harman.ui
{
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.text.TextFormatAlign;
   import skin.Skin;
   
   public dynamic class ScreenMediaHome extends ScreenMovieClip
   {
      
      public const ALBUM_ART_WIDTH:int = 120;
      
      public const ALBUM_ART_HEIGHT:int = 120;
      
      public const ONELINE_ERROR:int = 194;
      
      public const TWOLINE_ERROR:int = 168;
      
      public function ScreenMediaHome()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.textSplit.album,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textSplit.album,Skin.style.currentTheme.secondaryText);
         Skin.style.applyFont(this.textSplit.title,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textSplit.title,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.textSplit.artist,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textSplit.artist,Skin.style.currentTheme.secondaryText);
         Skin.style.applyFont(this.textFull.album,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textFull.album,Skin.style.currentTheme.secondaryText);
         Skin.style.applyFont(this.textFull.title,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textFull.title,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.textFull.artist,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textFull.artist,Skin.style.currentTheme.secondaryText);
         Skin.style.applyFont(this.textFull.error,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.textFull.error,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.track_group.songnumber,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.track_group.songnumber,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.track_group.timeduration,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.track_group.timeduration,Skin.style.currentTheme.secondaryText);
         Skin.style.applyFont(this.info.trackvalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.artistvalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.titlevalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.albumvalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.composervalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.genrevalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.yearvalue,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.info.trackvalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.artistvalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.titlevalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.albumvalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.composervalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.genrevalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.info.yearvalue,Skin.style.currentTheme.primaryText);
         Skin.style.applyFont(this.info.track,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.artist,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.title,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.album,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.composer,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.genre,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.info.year,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.info.track,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.artist,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.title,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.album,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.composer,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.genre,Skin.style.currentTheme.secondaryText);
         Skin.style.applyStyle(this.info.year,Skin.style.currentTheme.secondaryText);
      }
      
      override protected function updateAlignment() : void
      {
         this.formatListItem(this.tracks_group.tracks_list.row_0_group.row_button);
         this.formatListItem(this.tracks_group.tracks_list.row_1_group.row_button);
         this.formatListItem(this.tracks_group.tracks_list.row_2_group.row_button);
         this.formatListItem(this.tracks_group.tracks_list.row_3_group.row_button);
         this.formatListItem(this.tracks_group.tracks_list.row_4_group.row_button);
         this.formatListItem(this.tracks_group.tracks_list.row_5_group.row_button);
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.tracks_group.tracks_list.x = 48;
            this.tracks_group.tracks_scroller.x = 7;
            this.info.track.x = 267;
            this.info.artist.x = 267;
            this.info.title.x = 267;
            this.info.album.x = 267;
            this.info.composer.x = 267;
            this.info.genre.x = 267;
            this.info.year.x = 267;
            this.info.trackvalue.x = 8;
            this.info.artistvalue.x = 8;
            this.info.titlevalue.x = 8;
            this.info.albumvalue.x = 8;
            this.info.composervalue.x = 8;
            this.info.genrevalue.x = 8;
            this.info.yearvalue.x = 8;
            Text.align(this.info.track,TextFormatAlign.LEFT);
            Text.align(this.info.artist,TextFormatAlign.LEFT);
            Text.align(this.info.title,TextFormatAlign.LEFT);
            Text.align(this.info.album,TextFormatAlign.LEFT);
            Text.align(this.info.composer,TextFormatAlign.LEFT);
            Text.align(this.info.genre,TextFormatAlign.LEFT);
            Text.align(this.info.year,TextFormatAlign.LEFT);
            Text.align(this.info.trackvalue,TextFormatAlign.RIGHT);
            Text.align(this.info.artistvalue,TextFormatAlign.RIGHT);
            Text.align(this.info.titlevalue,TextFormatAlign.RIGHT);
            Text.align(this.info.albumvalue,TextFormatAlign.RIGHT);
            Text.align(this.info.composervalue,TextFormatAlign.RIGHT);
            Text.align(this.info.genrevalue,TextFormatAlign.RIGHT);
            Text.align(this.info.yearvalue,TextFormatAlign.RIGHT);
         }
         else
         {
            this.tracks_group.tracks_list.x = 8;
            this.tracks_group.tracks_scroller.x = 332;
            this.info.track.x = 8;
            this.info.artist.x = 8;
            this.info.title.x = 8;
            this.info.album.x = 8;
            this.info.composer.x = 8;
            this.info.genre.x = 8;
            this.info.year.x = 8;
            this.info.trackvalue.x = 117;
            this.info.artistvalue.x = 117;
            this.info.titlevalue.x = 117;
            this.info.albumvalue.x = 117;
            this.info.composervalue.x = 117;
            this.info.genrevalue.x = 117;
            this.info.yearvalue.x = 117;
            Text.align(this.info.track,TextFormatAlign.RIGHT);
            Text.align(this.info.artist,TextFormatAlign.RIGHT);
            Text.align(this.info.title,TextFormatAlign.RIGHT);
            Text.align(this.info.album,TextFormatAlign.RIGHT);
            Text.align(this.info.composer,TextFormatAlign.RIGHT);
            Text.align(this.info.genre,TextFormatAlign.RIGHT);
            Text.align(this.info.year,TextFormatAlign.RIGHT);
            Text.align(this.info.trackvalue,TextFormatAlign.LEFT);
            Text.align(this.info.artistvalue,TextFormatAlign.LEFT);
            Text.align(this.info.titlevalue,TextFormatAlign.LEFT);
            Text.align(this.info.albumvalue,TextFormatAlign.LEFT);
            Text.align(this.info.composervalue,TextFormatAlign.LEFT);
            Text.align(this.info.genrevalue,TextFormatAlign.LEFT);
            Text.align(this.info.yearvalue,TextFormatAlign.LEFT);
         }
      }
      
      private function formatListItem(_button:MovieClip) : void
      {
         if(LocaleArchive.getInstance().isMirrored())
         {
            _button.playIcon.x = 307;
            _button.name_label.x = 0;
            Text.align(_button.name_label,TextFormatAlign.RIGHT);
         }
         else
         {
            _button.playIcon.x = 2;
            _button.name_label.x = 20;
            Text.align(_button.name_label,TextFormatAlign.LEFT);
         }
      }
   }
}

