package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class IPAddressInfoEvent extends Event
   {
      
      public static const IPADDRESS_INFO:String = "ipaddressInfo";
      
      public static const TEMPERATURE_INFO:String = "temperatureUpdated";
      
      public static const QXDM_CONN_STATUS:String = "QXDMConnStatus";
      
      public static const DISPLAY_HOT_WARNING:String = "displayHotWarning";
      
      public var mData:Object = null;
      
      public function IPAddressInfoEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

