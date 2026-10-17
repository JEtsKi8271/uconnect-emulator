package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TLMovieTitleMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var movie_label:TextField;
      
      public var date_label:TextField;
      
      public var bgClip:MovieClip;
      
      public function TLMovieTitleMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.movie_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.date_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.movie_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.date_label,Skin.style.currentTheme.primaryText);
         if(this.bgClip != null)
         {
            Skin.style.applyStyle(this.bgClip,Skin.style.currentTheme.activeGraphic);
         }
      }
   }
}

