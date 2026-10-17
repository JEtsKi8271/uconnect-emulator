package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class MovieTimesMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var movie_label:TextField;
      
      public var showTimes_label:TextField;
      
      public function MovieTimesMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.movie_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.showTimes_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.movie_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.showTimes_label,Skin.style.currentTheme.primaryText);
      }
   }
}

