package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemMovieTheaterButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public var distance_label:TextField;
      
      public function ListItemMovieTheaterButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.distance_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.distance_label,Skin.style.currentTheme.primaryText);
      }
   }
}

