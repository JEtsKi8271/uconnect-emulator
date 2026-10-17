package com.nfuzion.display.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class ListItemTLWeatherHourlyWeatherItem extends BaseMovieClip
   {
      
      public var condition_icon:MovieClip;
      
      public var title_label:TextField;
      
      public var temperature_label:TextField;
      
      public var pop_label:TextField;
      
      public function ListItemTLWeatherHourlyWeatherItem()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.title_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.temperature_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.pop_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.title_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.temperature_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.pop_label,Skin.style.currentTheme.primaryText);
      }
   }
}

