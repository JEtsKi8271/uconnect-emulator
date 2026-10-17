package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemBluetoothSettingsButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public var number_label:TextField;
      
      public var name_label:TextField;
      
      public var status_label:TextField;
      
      public function ListItemBluetoothSettingsButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.number_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.status_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.number_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
      }
   }
}

