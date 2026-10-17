package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PresetPersistencyManagerEvent extends Event
   {
      
      public static const SAVE_COMPLETE:String = "saveComplete";
      
      public static const PRESETS:String = "presets";
      
      public static const DRIVER_AB:String = "driverab";
      
      public var mData:* = null;
      
      public function PresetPersistencyManagerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

