package com.nfuzion.display.ui
{
   import skin.Skin;
   
   public dynamic class AlertCautionGraphicMovieClip extends BaseMovieClip
   {
      
      public function AlertCautionGraphicMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyStyle(this,Skin.style.currentTheme.alertCautionIcon);
      }
   }
}

