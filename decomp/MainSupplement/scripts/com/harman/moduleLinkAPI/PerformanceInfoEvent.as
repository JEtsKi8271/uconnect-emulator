package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PerformanceInfoEvent extends Event
   {
      
      public static const PERFORMANCE_INFO:String = "performanceInfo";
      
      public var mData:Object = null;
      
      public function PerformanceInfoEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

