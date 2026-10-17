package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DisplayManagerEvent extends Event
   {
      
      public static const DISPLAY_REQUEST_RESPONSE:String = "DISPLAY_request_response";
      
      public static const DISPLAY_REARCAMERA_STATUS:String = "DISPLAY_rearcamera_status";
      
      public static const DISPLAY_VISIBILITY_CHANGE:String = "DISPLAY_visibility_change";
      
      public static const DISPLAY_LAYER_CHANGE:String = "DISPLAY_layer_change";
      
      public var mData:Object = null;
      
      public function DisplayManagerEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

