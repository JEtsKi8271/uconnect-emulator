package com.nfuzion.display.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemTLWeatherDailyWeatherItem extends BaseMovieClip
   {
      
      public var title_label:TextField;
      
      public var highLow_label:TextField;
      
      public var pop_label:TextField;
      
      public var condition_icon:MovieClip;
      
      public function ListItemTLWeatherDailyWeatherItem()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.title_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.highLow_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.pop_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.title_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.highLow_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.pop_label,Skin.style.currentTheme.primaryText);
      }
   }
}

