package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class HeatButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function HeatButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonIconColor() : void
      {
         Skin.style.applyStyle(this.icon,Skin.style.currentTheme.heatIcon);
      }
   }
}

