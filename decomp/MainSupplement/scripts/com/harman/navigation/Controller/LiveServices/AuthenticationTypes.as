package com.harman.navigation.Controller.LiveServices
{
   public class AuthenticationTypes
   {
      
      public static const UC_AUTH_AUTHORIZED:int = 0;
      
      public static const UC_AUTH_CONNECTION_NOT_AVAILABLE:int = 1;
      
      public static const UC_AUTH_UNAUTHORIZED:int = 2;
      
      public static const UC_AUTH_GENERAL_ERROR:int = 3;
      
      public static const UC_CONNECTED_NOT_AVAILABLE:int = -1;
      
      public static const UC_CONNECTED:int = 0;
      
      public static const UC_CONNECTED_2G:int = 1;
      
      public static const UC_CONNECTED_EDGE:int = 2;
      
      public static const UC_CONNECTED_3G:int = 3;
      
      public static const UC_CONNECTED_4G:int = 4;
      
      public static const UC_CONNECTED_WIFI:int = 5;
      
      public static const UC_CONNECTED_ROAMING:int = 6;
      
      public static const SUBS_TYPE_LOCAL_SEARCH:String = "TT.LOCALSEARCH";
      
      public static const SUBS_TYPE_TRAFFIC:String = "TT.TEC";
      
      public static const SUBS_TYPE_WEATHER:String = "TT.WEA";
      
      public static const SUBS_TYPE_SPEEDCAM_INFO:String = "TT.SAA";
      
      public static const SUBS_TYPE_SPEEDCAM_FEEDBACK:String = "TT.SAAFL";
      
      public static const TTLS_SIGNAL_STATUS_UNAVAILABLE:int = 0;
      
      public static const TTLS_SIGNAL_STATUS_AVAILABLE:int = 1;
      
      public static const TTLS_TOMTOM_SERVICE_READY:int = 2;
      
      public static const TTLS_TOMTOM_SERVICE_NOT_READY:int = 3;
      
      public static const TTLS_SERVICE_LOCALSEARCH:int = 1 << 0;
      
      public static const TTLS_SERVICE_TRAFFIC:int = 1 << 1;
      
      public static const TTLS_SERVICE_WEATHER:int = 1 << 2;
      
      public static const TTLS_SERVICE_SPEEDCAM:int = 1 << 3;
      
      public static const TTLS_SERVICE_SPEEDCAM_FEEDBACK:int = 1 << 4;
      
      private static var SUBSCRIPTION_LIST_P:Object = null;
      
      public function AuthenticationTypes()
      {
         super();
      }
      
      public static function get SUBSCRIPTION_LIST() : Object
      {
         if(SUBSCRIPTION_LIST_P == null)
         {
            SUBSCRIPTION_LIST_P = new Object();
            SUBSCRIPTION_LIST_P["TT.LOCALSEARCH"] = "LOCALSEARCH";
            SUBSCRIPTION_LIST_P["TT.TEC"] = "TEC";
            SUBSCRIPTION_LIST_P["TT.WEA"] = "WEA";
            SUBSCRIPTION_LIST_P["TT.SAA"] = "SAA";
            SUBSCRIPTION_LIST_P["TT.SAAFL"] = "SAAFL";
         }
         return SUBSCRIPTION_LIST_P;
      }
      
      public static function connectionStatusToString(status:int) : String
      {
         switch(status)
         {
            case UC_CONNECTED_NOT_AVAILABLE:
               return "Connection not available ";
            case UC_CONNECTED:
               return "Connected";
            case UC_CONNECTED_2G:
               return "Connected 2G";
            case UC_CONNECTED_EDGE:
               return "Connected Edge";
            case UC_CONNECTED_3G:
               return "Connected 3G";
            case UC_CONNECTED_4G:
               return "Connected 4G";
            case UC_CONNECTED_WIFI:
               return "Connected WIFI";
            case UC_CONNECTED_ROAMING:
               return "Connected Roaming";
            default:
               return "Unknown";
         }
      }
      
      public static function authenticationStatusToString(status:int) : String
      {
         switch(status)
         {
            case UC_AUTH_AUTHORIZED:
               return "Authorized";
            case UC_AUTH_CONNECTION_NOT_AVAILABLE:
               return "Connection not available";
            case UC_AUTH_UNAUTHORIZED:
               return "Unauthorized";
            case UC_AUTH_GENERAL_ERROR:
               return "General Error";
            default:
               return "Unknown";
         }
      }
      
      public static function ttlsSignalStatusToString(status:int) : String
      {
         switch(status)
         {
            case TTLS_SIGNAL_STATUS_UNAVAILABLE:
               return "unavailable";
            case TTLS_SIGNAL_STATUS_AVAILABLE:
               return "available";
            case TTLS_TOMTOM_SERVICE_READY:
               return "ready";
            case TTLS_TOMTOM_SERVICE_NOT_READY:
               return "not ready";
            default:
               return "Unknown (" + status + ")";
         }
      }
      
      public static function ttlsServicesAvailableToString(status:int) : String
      {
         if(status == 0)
         {
            return "None";
         }
         var erg:String = "";
         if(status & TTLS_SERVICE_LOCALSEARCH)
         {
            erg += "LS ";
         }
         if(status & TTLS_SERVICE_TRAFFIC)
         {
            erg += "TEC ";
         }
         if(status & TTLS_SERVICE_WEATHER)
         {
            erg += "WEA ";
         }
         if(status & TTLS_SERVICE_SPEEDCAM)
         {
            erg += "SAA ";
         }
         if(status & TTLS_SERVICE_SPEEDCAM_FEEDBACK)
         {
            erg += "SAAFL";
         }
         return erg;
      }
   }
}

