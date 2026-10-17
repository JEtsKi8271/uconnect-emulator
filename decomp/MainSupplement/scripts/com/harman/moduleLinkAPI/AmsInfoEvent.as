package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AmsInfoEvent extends Event
   {
      
      public static const AMS_FILE_INFO:String = "AmsFileInfo";
      
      public var mData:Object = null;
      
      public function AmsInfoEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

