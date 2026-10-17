package com.nfuzion.display.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TravelLinkWeatherScreenViewMovieClip extends BaseMovieClip
   {
      
      public var views_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var list_scroller:ScrollbarComponent;
      
      public var displayTitle:DisplayTitleMovieClip;
      
      public var back_button:ButtonMovieClip;
      
      public var travelLink_button:NoIconButtonMovieClip;
      
      public var viewButtons_group:MovieClip;
      
      public var favorites_button:ButtonMovieClip;
      
      public var refresh_button:ButtonMovieClip;
      
      public var headers_group:MovieClip;
      
      public function TravelLinkWeatherScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.views_group.message_group.message_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.changeLocationMethods_group.select_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.skiInfo_group.conditions_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.skiInfo_group.timestamp_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.skiInfo_group.location_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.location_group.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.weather_group.weatherViews_group.currentOverview_group.temperature_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.weather_group.weatherViews_group.currentOverview_group.condition_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.weather_group.weatherViews_group.currentOverview_group.highLow_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.weather_group.location_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.weather_group.timestamp_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.views_group.changeLocationMethods_group.select_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.message_group.message_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.skiInfo_group.conditions_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.skiInfo_group.timestamp_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.skiInfo_group.location_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.location_group.value_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.views_group.weather_group.weatherViews_group.currentOverview_group.temperature_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.weather_group.weatherViews_group.currentOverview_group.condition_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.weather_group.weatherViews_group.currentOverview_group.highLow_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.weather_group.location_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.weather_group.timestamp_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
      }
   }
}

