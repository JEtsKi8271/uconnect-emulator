package com.nfuzion.display.ui
{
   import skin.Skin;
   
   public dynamic class AnswerButtonMovieClip extends CallButtonMovieClip
   {
      
      public function AnswerButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonImageColors() : void
      {
         super.setButtonImageColors();
         Skin.style.applyStyle(this.btnActive,Skin.style.currentTheme.alertNoneIcon);
      }
   }
}

