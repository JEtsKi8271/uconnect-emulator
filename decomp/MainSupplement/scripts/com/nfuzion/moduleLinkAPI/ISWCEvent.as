package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ISWCEvent extends Event
   {
      
      public static const PRESET_ADVANCE:String = "presetAdvance";
      
      public static const SEEK_PLUS:String = "seekPlus";
      
      public static const SEEK_MINUS:String = "seekMinus";
      
      public static const VOLUME:String = "volume";
      
      public static const MODE_ADVANCE:String = "modeAdvance";
      
      public static const PTT_PRESS:String = "PttPress";
      
      public static const PHONE_PRESS:String = "Phone_Press";
      
      public static const PHONE_HANGUP:String = "Phone_Hangup";
      
      public var mData:Object = null;
      
      public function ISWCEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
   }
}

