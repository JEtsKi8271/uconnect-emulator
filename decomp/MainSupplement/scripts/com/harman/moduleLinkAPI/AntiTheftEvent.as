package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AntiTheftEvent extends Event
   {
      
      public static const ANTI_THEFT_STATE_LOCKED:String = "locked";
      
      public static const ANTI_THEFT_STATE_WAITFORVIN:String = "waitForVIN";
      
      public static const ANTI_THEFT_STATE_ENTERPIN:String = "enterPIN";
      
      public static const ANTI_THEFT_STATE_UNLOCKED:String = "unlocked";
      
      public static const ANTI_THEFT_STATE_WRONGPIN:String = "wrongPIN";
      
      public static const ANTI_THEFT_STATE_FORCED_FOTA_UPDATE:String = "forcedFotaUpdate";
      
      public static const ANTI_THEFT_LOCK_TIME:String = "antiTheftLockTime";
      
      public static const ANTI_THEFT_BATTERY_DISCONNECT:String = "antiTheftBatteryDisconnect";
      
      public static const ANTI_THEFT_IGNITION_STATE:String = "ignState";
      
      public static const ANTI_THEFT_CLOSE_SCREEN_OFF:String = "closeScreenOff";
      
      public static const ANTI_THEFT_POWER_MODE_STATE:String = "powerModeState";
      
      public static const ANTI_THEFT_SHUTDOWN_REQUEST:String = "shutdownRequest";
      
      public static const ANTI_THEFT_WAKEUPREASON:String = "wakeupReason";
      
      public function AntiTheftEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

