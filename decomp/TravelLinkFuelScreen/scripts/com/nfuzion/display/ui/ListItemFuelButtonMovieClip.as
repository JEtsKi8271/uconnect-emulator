package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemFuelButtonMovieClip extends ButtonMovieClip implements IMovieClip
   {
      
      public var brand_label:TextField;
      
      public var distance_label:TextField;
      
      public var price_label:TextField;
      
      public var date_label:TextField;
      
      public function ListItemFuelButtonMovieClip()
      {
         super();
      }
      
      override protected function setButtonFont() : void
      {
         Skin.style.applyFont(this.brand_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.distance_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.price_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.date_label,Skin.style.currentTheme.FONT_PRIMARY);
      }
      
      override protected function setButtonTextColors() : void
      {
         Skin.style.applyStyle(this.brand_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.distance_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.price_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.date_label,Skin.style.currentTheme.primaryText);
      }
   }
}

