package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ProductPriceTextMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var product_label:TextField;
      
      public var price_label:TextField;
      
      public function ProductPriceTextMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.product_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.price_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.product_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.price_label,Skin.style.currentTheme.primaryText);
      }
   }
}

