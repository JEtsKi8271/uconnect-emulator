package com.harman.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class GraphicMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public function GraphicMovieClip()
      {
         this.mouseEnabled = false;
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.activeGraphic);
      }
   }
}

