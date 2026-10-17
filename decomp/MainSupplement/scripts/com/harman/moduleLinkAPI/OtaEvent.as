package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class OtaEvent extends Event
   {
      
      public static const OTA_INSTALL_CONFIRM:String = "ota_scomo_ins_confirm_ui";
      
      public static const OTA_UPDATE_NOW:String = "updateNow";
      
      public static const OTA_SCHEDULED_UPDATE_TIME:String = "scheduledUpdateTime";
      
      public static const OTA_INSTALL_DONE:String = "ota_scomo_install_done";
      
      public static const OTA_DISMISS_POPUP:String = "popupDismiss";
      
      public var mData:* = null;
      
      public function OtaEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

