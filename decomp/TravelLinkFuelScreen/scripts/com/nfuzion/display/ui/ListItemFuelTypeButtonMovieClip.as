package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemFuelTypeButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public function ListItemFuelTypeButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
      }
   }
}

