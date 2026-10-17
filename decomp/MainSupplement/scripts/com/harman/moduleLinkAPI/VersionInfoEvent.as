package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VersionInfoEvent extends Event
   {
      
      public static const VERSION_INFO:String = "versionInfo";
      
      public static const PARTNUMBER:String = "partnumber";
      
      public static const EQ_VERSION:String = "eq_version";
      
      public static const SERIAL_NUMBER:String = "serialnumber";
      
      public static const PRODUCT_VARIANT_ID:String = "productVariantID";
      
      public static const TRANSLATION_VERSION:String = "translationVersion";
      
      public static const FLAG_STATUS:String = "flagsToTouchInEnggMenu";
      
      public var mData:Object = null;
      
      public function VersionInfoEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

