package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VicsDSRCEtcDiagHMIEvent extends Event
   {
      
      public static const SELF_TEST_VICS_BEACON:String = "EventSelfTestVICSBeacon";
      
      public static const SELF_TEST_ETC:String = "EventSelfTestETC";
      
      public static const SELF_TEST_VICS_FM:String = "EventSelfTestVICSFM";
      
      public static const ETC_DEVICE_FAILED:String = "EventDeviceFailed";
      
      public static const ETC_DEVICE_STATUS:String = "EventDeviceStatus";
      
      public static const ETC_ANTENNA_FAILED:String = "EventAntennaFailed";
      
      public var mData:Object = null;
      
      public function VicsDSRCEtcDiagHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

