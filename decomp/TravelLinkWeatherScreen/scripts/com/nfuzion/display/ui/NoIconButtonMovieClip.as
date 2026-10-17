package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   
   public dynamic class NoIconButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public function NoIconButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonIconColor() : void
      {
      }
   }
}

