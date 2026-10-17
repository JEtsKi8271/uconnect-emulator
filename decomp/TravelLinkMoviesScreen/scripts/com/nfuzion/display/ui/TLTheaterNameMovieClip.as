package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TLTheaterNameMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var theater_label:TextField;
      
      public var date_label:TextField;
      
      public var bgClip:MovieClip;
      
      public function TLTheaterNameMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.theater_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.date_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.theater_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.date_label,Skin.style.currentTheme.primaryText);
         if(this.bgClip != null)
         {
            Skin.style.applyStyle(this.bgClip,Skin.style.currentTheme.activeGraphic);
         }
      }
   }
}

