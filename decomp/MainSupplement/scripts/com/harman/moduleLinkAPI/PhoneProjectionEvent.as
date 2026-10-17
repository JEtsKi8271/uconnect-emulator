package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PhoneProjectionEvent extends Event
   {
      
      public static const PROJECTIONDEVICE_READY:String = "projectiondeviceready";
      
      public static const PROJECTIONDEVICE_NOTREADY:String = "projectiondevicenotready";
      
      public static const PROJECTION_STATUS:String = "projectionStatus";
      
      public static const PROJECTION_DEVICE_STATUS:String = "projectionDeviceStatus";
      
      public static const PROJECTION_BACKTO_CAR:String = "projectionBackToCar";
      
      public static const PROJECTION_STATUS_BAR:String = "projectionStatusBar";
      
      public static const PROJECTION_DEVICE_LIST:String = "projectionDeviceList";
      
      public var mData:* = null;
      
      public function PhoneProjectionEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

