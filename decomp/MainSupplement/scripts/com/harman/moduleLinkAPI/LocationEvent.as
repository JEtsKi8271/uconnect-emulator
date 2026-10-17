package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class LocationEvent extends Event
   {
      
      public static const COMPASS_HEADING:String = "compassHeading";
      
      public var mData:Object = null;
      
      public function LocationEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

