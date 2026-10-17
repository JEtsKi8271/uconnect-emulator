package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ClimateEvent extends Event
   {
      
      public static const DRIVER_TEMP:String = "driverTemp";
      
      public static const OUTSIDE_TEMP:String = "outsideTemp";
      
      public static const INSIDE_TEMP:String = "insideTemp";
      
      public static const PASSENGER_TEMP:String = "passengerTemp";
      
      public var mData:Object = null;
      
      public function ClimateEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

