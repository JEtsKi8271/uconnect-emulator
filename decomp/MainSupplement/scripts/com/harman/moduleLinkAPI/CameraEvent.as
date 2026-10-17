package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class CameraEvent extends Event
   {
      
      public static const CAMERA_UPDATE:String = "Camera";
      
      public static const PRND_CANCEL:String = "prndcancel";
      
      public var mData:Object = null;
      
      public function CameraEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

