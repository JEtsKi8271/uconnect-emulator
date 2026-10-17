package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemTLWeatherSelectAreaButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var name_label:TextField;
      
      public function ListItemTLWeatherSelectAreaButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         if(this.name_label != null)
         {
            Skin.style.applyFont(this.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         }
         if(this.number_label != null)
         {
            Skin.style.applyFont(this.number_label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override protected function setButtonTextColors() : void
      {
         if(this.name_label != null)
         {
            Skin.style.applyStyle(this.name_label,Skin.style.currentTheme.primaryText);
         }
         if(this.number_label != null)
         {
            Skin.style.applyStyle(this.number_label,Skin.style.currentTheme.primaryText);
         }
      }
   }
}

