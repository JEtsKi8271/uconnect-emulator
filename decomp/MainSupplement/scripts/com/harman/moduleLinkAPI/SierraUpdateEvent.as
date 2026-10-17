package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SierraUpdateEvent extends Event
   {
      
      public static const SIERRA_PERCENT_UPDATE:String = "SierraPercentUpdate";
      
      public static const SIERRA_STATUS_UPDATE:String = "SierraStatusUpdate";
      
      public var mData:Object = null;
      
      public function SierraUpdateEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

