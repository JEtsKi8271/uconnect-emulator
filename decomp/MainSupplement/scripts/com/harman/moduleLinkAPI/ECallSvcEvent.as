package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ECallSvcEvent extends Event
   {
      
      public static const ECALL_EVENT:String = "ecallEvent";
      
      public var mData:* = null;
      
      public function ECallSvcEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

