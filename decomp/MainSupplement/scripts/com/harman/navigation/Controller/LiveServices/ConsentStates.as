package com.harman.navigation.Controller.LiveServices
{
   public class ConsentStates
   {
      
      public static const CONSENT_STATE_UNKNOWN:int = 0;
      
      public static const CONSENT_STATE_LIVE_SERVICE_NOT_SUPPORTED:int = 1;
      
      public static const CONSENT_STATE_WAITING:int = 2;
      
      public static const CONSENT_STATE_EXPIRED:int = 3;
      
      public static const CONSENT_STATE_UNDEFINED:int = 4;
      
      public static const CONSENT_STATE_CONFIRMED:int = 5;
      
      public static const CONSENT_STATE_DECLINED:int = 6;
      
      public function ConsentStates()
      {
         super();
      }
      
      public static function toString(state:int) : String
      {
         switch(state)
         {
            case CONSENT_STATE_UNKNOWN:
               return "Unknown";
            case CONSENT_STATE_LIVE_SERVICE_NOT_SUPPORTED:
               return "TTLS not supported";
            case CONSENT_STATE_WAITING:
               return "Waiting";
            case CONSENT_STATE_EXPIRED:
               return "Expired";
            case CONSENT_STATE_UNDEFINED:
               return "Undefined";
            case CONSENT_STATE_CONFIRMED:
               return "Confirmed";
            case CONSENT_STATE_DECLINED:
               return "Declined";
            default:
               return "Not defined";
         }
      }
   }
}

