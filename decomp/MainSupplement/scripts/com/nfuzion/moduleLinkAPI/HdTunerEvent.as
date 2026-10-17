package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class HdTunerEvent extends Event
   {
      
      public static const HD_STATUS:String = "hdStatusInfo";
      
      public static const HD_STATION:String = "hdStationInfo";
      
      public static const HD_BER_DIAGNOSTICS:String = "hdBERErrorRate";
      
      public static const HD_PERFORMANCE:String = "hdPerformance";
      
      public static const HD_FW_VERSION:String = "hdSwVersion";
      
      public static const HD_TUNE:String = "hdTune";
      
      public static const HD_PROGRAM_AVAIL:String = "currentHdProgramAvailable";
      
      public var mData:* = null;
      
      public function HdTunerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

