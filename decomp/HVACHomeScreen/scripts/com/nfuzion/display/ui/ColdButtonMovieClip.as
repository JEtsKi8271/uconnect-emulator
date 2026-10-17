package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ColdButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function ColdButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonIconColor() : void
      {
         Skin.style.applyStyle(this.icon,Skin.style.currentTheme.coldIcon);
      }
   }
}

