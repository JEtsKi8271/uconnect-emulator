package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemRadioSatJumpButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var noItems_label:TextField;
      
      public var channelNumber_label:TextField;
      
      public var location_label:TextField;
      
      public function ListItemRadioSatJumpButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.noItems_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.channelNumber_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.location_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.noItems_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.channelNumber_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.location_label,Skin.style.currentTheme.primaryText);
      }
   }
}

