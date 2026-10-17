package com.nfuzion.display.ui
{
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemTLWeatherSkiDetailsItem extends BaseMovieClip
   {
      
      public var label_translate:TextField;
      
      public var value_label:TextField;
      
      public function ListItemTLWeatherSkiDetailsItem()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.label_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.label_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.value_label,Skin.style.currentTheme.primaryText);
      }
   }
}

