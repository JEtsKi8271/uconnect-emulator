package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TLShowtimeButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var title_label:TextField;
      
      public var showTime_label:TextField;
      
      public function TLShowtimeButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.title_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.showTime_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.title_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.showTime_label,Skin.style.currentTheme.primaryText);
      }
   }
}

