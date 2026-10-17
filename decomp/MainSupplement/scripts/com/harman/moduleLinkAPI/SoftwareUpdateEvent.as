package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SoftwareUpdateEvent extends Event
   {
      
      public static const SW_UPDATE_STATUS:String = "softwareUpdateStatus";
      
      public static const SW_UPDATE_PROGRESS:String = "softwareUpdateProgress";
      
      public static const SW_UPDATE_ERROR:String = "softwareUpdateError";
      
      public static const SW_UPDATE_BOOT_DONE:String = "softwareUpdateBootDone";
      
      public static const NAV_DB_UPDATE_STATE:String = "NavDbUpdateState";
      
      public static const NAV_DB_ACTIVATION_CODE_ACCEPT:String = "NavDbActivationCodeAccept";
      
      public var mData:Object = null;
      
      public function SoftwareUpdateEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

