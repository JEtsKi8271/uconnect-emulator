package com.harman.ui
{
   import flash.display.IMovieClip;
   import skin.Skin;
   
   public dynamic class GraphicBarHighlight extends BaseMovieClip implements IMovieClip
   {
      
      public function GraphicBarHighlight()
      {
         this.mouseEnabled = false;
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.barGraphic);
      }
   }
}

