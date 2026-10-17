package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class BarGraphicMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public function BarGraphicMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.barGraphic);
      }
   }
}

