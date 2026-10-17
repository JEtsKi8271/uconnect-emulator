package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VicsDiagEngMenuHMIEvent extends Event
   {
      
      public static const ACCESSING_SD_CARD:String = "EventAccessingSDCard";
      
      public static const STATUS_ETCDSRC:String = "EventStatusEtcDsrc";
      
      public var mData:Object = null;
      
      public function VicsDiagEngMenuHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

