package com.harman.navigation
{
   import com.harman.navigation.Controller.LiveServices.LocalSearchResultList;
   import com.harman.navigation.Controller.LiveServices.SpeedCameraAlertSettingTypes;
   import com.harman.navigation.Controller.LiveServices.WeatherTypes;
   
   public class NavGlobalSettingsCommon
   {
      
      public static const TTLS_ENABLE_SIMULATION_DATA:Boolean = false;
      
      public static const TTLS_LOCAL_SEARCH_RADIUS:int = 10;
      
      public static const TTLS_LOCAL_SEARCH_SORT_OREDER_DEFAULT:int = LocalSearchResultList.SO_BY_DISTANCE;
      
      public static const TTLS_LOCAL_SEARCH_RESULT_COUNT:int = 20;
      
      public static const TTLS_SERVICE_FUNCTIONAL_TIMEOUT:int = 10000;
      
      public static const LS_REPORT_SPEED_CAM_SPEED_DEFAULT_MPH:int = 50;
      
      public static const LS_REPORT_SPEED_CAM_SPEED_DEFAULT_KMH:int = 80;
      
      public static const LS_REPORT_SPEED_CAM_SPEED_MAX_KMH:int = 200;
      
      public static const LS_REPORT_SPEED_CAM_SPEED_MAX_MPH:int = 120;
      
      public static const LS_REPORT_SPEED_CAM_SPEED_MIN:int = 0;
      
      public static const LS_REPORT_SPEED_CAM_REPORT_NO_SPEED:Array = new Array(SpeedCameraAlertSettingTypes.SCAS_TRAFFIC_LIGHT_CAMERAS,SpeedCameraAlertSettingTypes.SCAS_TOLL_ROAD_CAMERA);
      
      public static const LS_WEATHER_ELEMENT_PRIORITY:Array = new Array(WeatherTypes.ELEMENT_TYPE_HAZARDS,WeatherTypes.ELEMENT_TYPE_STORM_ELEMENTS,WeatherTypes.ELEMENT_TYPE_SLEET_HAIL_ELEMENTS,WeatherTypes.ELEMENT_TYPE_SNOW_ELEMENT,WeatherTypes.ELEMENT_TYPE_FROST_ELEMENTS,WeatherTypes.ELEMENT_TYPE_RAIN_ELEMENTS,WeatherTypes.ELEMENT_TYPE_FOG_ELEMENTS,WeatherTypes.ELEMENT_TYPE_SUNSHINE_CLOUD,WeatherTypes.ELEMENT_TYPE_TEMPERATURE_ELEMENTS,WeatherTypes.ELEMENT_TYPE_WIND_ELEMENTS);
      
      public function NavGlobalSettingsCommon()
      {
         super();
      }
   }
}

