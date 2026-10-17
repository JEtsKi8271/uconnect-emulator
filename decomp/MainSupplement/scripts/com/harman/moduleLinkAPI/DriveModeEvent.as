package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DriveModeEvent extends Event
   {
      
      public static const ECO_MODE:String = "ecoMode";
      
      public static const ENGINE_LOCKOUT:String = "engineLockOut";
      
      public static const GLOBAL_LOCKOUT:String = "globalLockOut";
      
      public static const GLOBAL_MODE_UPDATE:String = "globalModeUpdate";
      
      public static const LAUNCH_RPM:String = "launchRPM";
      
      public static const LAUNCH_STATUS:String = "launchStatus";
      
      public static const RPM_UPDATE:String = "rpmUpdate";
      
      public static const SCREEN_UPDATE:String = "screenUpdate";
      
      public static const SET_UP_UPDATE:String = "setUpUpdate";
      
      public static const SHIFT_INDICATION:String = "shiftIndication";
      
      public static const SHOW_VALET_KEYPAD:String = "showValetKeypad";
      
      public static const SNA_RECOVERY:String = "snaRecovery";
      
      public static const SRT_HARDKEY:String = "srtHardkey";
      
      public static const STEERING_LOCKOUT:String = "steeringLockOut";
      
      public static const TERRAIN_MODE:String = "terrainMode";
      
      public static const THROTTLE_LOCKOUT:String = "throttleLockOut";
      
      public static const VALET_LOCKOUT:String = "valetLockOut";
      
      public static const VALET_UNLOCKED:String = "valetUnlocked";
      
      public static const LEGACY_DRIVE_MODE:String = "legacyDriveMode";
      
      public var mData:* = null;
      
      public function DriveModeEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

