package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PersistencyEvent extends Event
   {
      
      public var value:Object = null;
      
      public function PersistencyEvent(type:String, _value:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.value = _value;
      }
   }
}

