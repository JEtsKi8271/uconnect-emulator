package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ListButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function ListButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         Skin.style.applyStyle(this.btnUp,Skin.style.currentTheme.upStateList);
         Skin.style.applyStyle(this.btnDown,Skin.style.currentTheme.downStateList);
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.activeStateList);
         Skin.style.applyStyle(this.btnDisabled,Skin.style.currentTheme.disabledStateList);
      }
   }
}

