package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DBusTraceMonitorEvent extends Event
   {
      
      public static const SCOPES_RECEIVED:String = "Scopes_received";
      
      public static const SCOPES_CHANGED:String = "Scopes_changed";
      
      public function DBusTraceMonitorEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

