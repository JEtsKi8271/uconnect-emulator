package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DiagnosticsEvent extends Event
   {
      
      public static const XM_HW_VERSION:String = "xmHwVersion";
      
      public static const XM_SW_VERSION:String = "xmSwVersion";
      
      public static const XM_ANTENNA_SIGNAL_INFO:String = "";
      
      public static const XM_DETAILED_SIGNAL_STATS:String = "xmDetailedSignalStats";
      
      public static const XM_DETAILED_OVERLAY_SIGNAL_STATS:String = "xmDetailedOverlaySignalStats";
      
      public static const XM_SIGNAL_STATE:String = "xmSignalState";
      
      public var mData:* = null;
      
      public function DiagnosticsEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

