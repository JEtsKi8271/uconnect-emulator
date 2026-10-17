package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ListItemRadioSatJumpHeaderButtonMovieClip extends ListButtonMovieClip implements IMovieClip
   {
      
      public function ListItemRadioSatJumpHeaderButtonMovieClip()
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

