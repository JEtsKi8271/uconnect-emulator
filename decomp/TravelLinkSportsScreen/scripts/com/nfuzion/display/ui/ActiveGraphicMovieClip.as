package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class ActiveGraphicMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public function ActiveGraphicMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.activeGraphic);
      }
   }
}

