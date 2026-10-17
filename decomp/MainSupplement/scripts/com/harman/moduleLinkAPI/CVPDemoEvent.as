package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class CVPDemoEvent extends Event
   {
      
      public static const WAKEUP_REASON:String = "wakeupReason";
      
      public static const FIRMWARE_VERSIONS:String = "firmwareVersions";
      
      public static const EMB_PHONE_CALLSTATE:String = "embPhoneCallState";
      
      public static const EMB_PHONE_CALL_CDMA_SYSTEM_STATUS:String = "embPhoneCallCdmaSystemStatus";
      
      public static const SIGNAL_QUALITY:String = "EmbeddedCell.SignalQuality";
      
      public static const NETWORK:String = "EmbeddedCell.Network";
      
      public static const EMB_PHONE_DEBUGAT_ANSWER:String = "embPhoneDebugATResponse";
      
      public static const EMB_PHONE_AT_STATUS:String = "embPhoneATStatus";
      
      public static const EMB_PHONE_EMG_NUM:String = "embPhoneEmergencyNumbers";
      
      public static const EMB_PHONE_AT_SET_VALUE_STATUS:String = "embPhoneATSetValueStatus";
      
      public static const EMB_PHONE_AT_SET_PROFILE_STATUS:String = "embPhoneATSetProfileStatus";
      
      public static const EMB_PHONE_AT_CHECK_MSL_STATUS:String = "embPhoneATCheckMSLStatus";
      
      public static const EMB_PHONE_AT_COMMIT_CHANGES_STATUS:String = "embPhoneATCommitChangesStatus";
      
      public static const PA_TEMP_CHANGED:String = "paTempChanged";
      
      public static const DEVICE_SERVICE_STATUS:String = "deviceServiceState";
      
      public static const EMB_PHONE_STATUS:String = "embeddedPhoneStatus";
      
      public var mData:Object = null;
      
      public function CVPDemoEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

