package com.harman.navigation.Controller.LiveServices
{
   import flash.events.Event;
   
   public class LiveServicesEvent extends Event
   {
      
      public static const LS_LIVE_SERVICES_ENABLED:String = "LS_LiveServiceEnabled";
      
      public static const LS_SERVICE_STATUS_UPDATE:String = "LS_ServiceStatusUpdate";
      
      public static const LS_USER_CONSENT_UPDATE:String = "LS_UserConsentUpdate";
      
      public static const LS_LOCAL_SEARCH_UPDATE:String = "LS_LocalSearchResultUpdate";
      
      public static const LS_LOCAL_SEARCH_UPDATE_FAIL:String = "LS_LocalSearchResultUpdateFail";
      
      public static const LS_WEATHER_UPDATE:String = "LS_WeatherUpdate";
      
      public static const LS_SPEED_CAMERA_ALERT_SETTINGS:String = "LS_SpeedCameraAlertSettings";
      
      public static const LS_SPEED_CAMERA_REPORTED:String = "LS_SpeedCameraReported";
      
      public static const TTLS_REQUEST_BLOCKED:String = "TTLS_RequestBlocked";
      
      public static const TTLS_REQUEST_SENT:String = "TTLS_RequestSent";
      
      public function LiveServicesEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

