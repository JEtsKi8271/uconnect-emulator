package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VehicleStatusEvent extends Event
   {
      
      public static const SPEED_LOCK_OUT:String = "VehicleSpeedLockOut";
      
      public static const SPEED_LOCK_OUT_FEATURE:String = "SpeedLockOutFeature";
      
      public static const HEADLIGHTS_ON:String = "VehicleHeadlightsOn";
      
      public static const LANGUAGE:String = "Language";
      
      public static const TEST_TOOL_PRESENT:String = "TestToolPresent";
      
      public static const THEME_OVERRIDE:String = "ThemeFileOverride";
      
      public static const SELECTERRAIN_MODE_STATUS:String = "SelecTerrainModeStatus";
      
      public static const LANG_UNIT_MST_OVERRIDE:String = "LangUnitMstrOverride";
      
      public static const IGNITION_STATE:String = "IgnitionState";
      
      public static const VEHICLE_IN_PARK:String = "VehicleInPark";
      
      public static const TEEN_KEY_PRESENT:String = "TeenKeyIsPresent";
      
      public static const RESUME_MODE_TIMEOUT:String = "ResumeModeTimeout";
      
      public static const VEHICLE_MOVING:String = "isVehicleMoving";
      
      public static const GEAR_UPDATE:String = "gearUpdate";
      
      public static const DRV_DR_STATUS_UPDATE:String = "driverDoorStatusUpdate";
      
      public static const VEH_IN_MOTION_UPDATE:String = "vehicleInMotionUpdate";
      
      public static const EPB_SERVICE_ACTIVE_ALERT:String = "EPBServiceActivePopup";
      
      public static const SVC_SPEED_LOCKOUT_STATUS:String = "SurroundCameraSpeedLockout";
      
      public static const KEYSENSE_TIMER_VALUE:String = "KeySenseTimerValue";
      
      public static const GEAR_DISPLAY_UPDATE:String = "gearDisplay";
      
      public var mData:* = null;
      
      public function VehicleStatusEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

