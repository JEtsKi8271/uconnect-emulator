package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class HvacEvent extends Event
   {
      
      public static const HVAC_AVAILABLE:String = "hvacAvailable";
      
      public static const HVAC_VFS:String = "hvacVehicleFeatureSet";
      
      public static const HVAC_F_CLIMATE_STATE:String = "hvacFrClimateState";
      
      public static const HVAC_R_CLIMATE_STATE:String = "hvacRrClimateState";
      
      public static const HVAC_AC_STATE:String = "hvacAcState";
      
      public static const HVAC_MAX_AC_STATE:String = "hvacMaxAcState";
      
      public static const HVAC_RECIRC_STATE:String = "hvacRecircState";
      
      public static const HVAC_AIRQUALITY_STATE:String = "hvacAirQualState";
      
      public static const HVAC_AUTO_STATE:String = "hvacAutoState";
      
      public static const HVAC_DEFROSTER_STATE:String = "hvacDefrosterState";
      
      public static const HVAC_LOCK_STATE:String = "hvacLockState";
      
      public static const HVAC_SYNC_STATE:String = "hvacSyncState";
      
      public static const HVAC_R_SYNC_STATE:String = "hvacRSyncState";
      
      public static const HVAC_VENT_MODE:String = "hvacVentMode";
      
      public static const HVAC_F_FAN_SPEED:String = "hvacFrtFanSpeed";
      
      public static const HVAC_R_FAN_SPEED:String = "hvacRrFanSpeed";
      
      public static const HVAC_ZONE_TEMP:String = "hvacZoneTemp";
      
      public static const HVAC_ZONE_FRONT_LEFT_TEMP:String = "hvacZoneFrontLeftTemp";
      
      public static const HVAC_ZONE_FRONT_RIGHT_TEMP:String = "hvacZoneFrontRightTemp";
      
      public var data:*;
      
      public function HvacEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
   }
}

