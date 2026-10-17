package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ModuleEvent extends Event
   {
      
      public static const READY:String = "ready";
      
      public static const NOT_READY:String = "notReady";
      
      public static const HELLO:String = "hello";
      
      public function ModuleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

