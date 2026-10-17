package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemRadioSatAllButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var channelNumber_label:TextField;
      
      public var name_label:TextField;
      
      public var genre_label:TextField;
      
      public function ListItemRadioSatAllButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.channelNumber_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.genre_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.channelNumber_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.genre_label,Skin.style.currentTheme.primaryText);
      }
   }
}

