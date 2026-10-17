package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DriverABEvent extends Event
   {
      
      public static const SAVE:String = "DriverABEvent.SAVE";
      
      public static const RECALL:String = "DriverABEvent.RECALL";
      
      public var mData:* = null;
      
      public function DriverABEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

