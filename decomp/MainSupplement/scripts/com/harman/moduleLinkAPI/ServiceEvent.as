package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ServiceEvent extends Event
   {
      
      public static const SERVICE:String = "service";
      
      public var mData:* = null;
      
      public function ServiceEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

