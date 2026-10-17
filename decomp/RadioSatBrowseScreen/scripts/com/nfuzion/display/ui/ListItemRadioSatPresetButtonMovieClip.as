package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemRadioSatPresetButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var hold_label:TextField;
      
      public var number_label:TextField;
      
      public var channelNumber_label:TextField;
      
      public var name_label:TextField;
      
      public function ListItemRadioSatPresetButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.hold_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.number_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.channelNumber_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.hold_label,Skin.style.currentTheme.disabledText);
         Skin.style.applyStyle(this.number_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.channelNumber_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
      }
   }
}

