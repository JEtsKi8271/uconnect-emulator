package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DABEvent extends Event
   {
      
      public static const AVAILABLE:String = "Available";
      
      public static const DAB_GET_FIRMWARE_VERSIONS:String = "Firmware Versions";
      
      public static const DAB_GET_FREQUENCY_LABEL:String = "Frequency Label";
      
      public static const DAB_GET_POOL_VERSION:String = "Pool Version";
      
      public static const DAB_GET_REQ_FIRMWARE_VERSION:String = "Req firmware version";
      
      public static const DAB_DEVICE_STATE:String = "Device State";
      
      public static const DAB_TO_DAB_LINKING_SWITCH:String = "DAB to DAB linking switch";
      
      public static const DAB_FOLLOWING_SWITCH:String = "Following switch";
      
      public static const DAB_FOLLOWING_STATE:String = "Following state";
      
      public static const DAB_INFO_CURRENT_STATION:String = "Current station";
      
      public static const DAB_INFO_STATION_LIST:String = "Station list";
      
      public static const ENSEMBLE_LIST:String = "Ensemble List";
      
      public static const DAB_PRESET_LIST:String = "Preset list";
      
      public function DABEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

