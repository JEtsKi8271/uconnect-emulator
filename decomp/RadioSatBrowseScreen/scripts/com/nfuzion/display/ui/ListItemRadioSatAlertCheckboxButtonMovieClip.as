package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ListItemRadioSatAlertCheckboxButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public function ListItemRadioSatAlertCheckboxButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
      }
   }
}

