package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AMSEvent extends Event
   {
      
      public static const QUERY_APP_IDS:String = "queryAppIds";
      
      public static const PACKAGE_INFO:String = "packageInfo";
      
      public static const EXTRACT_RESOURCE:String = "extractResource";
      
      public static const APP_INSTALLED:String = "appInstalled";
      
      public static const APP_UNINSTALLED:String = "appUninstalled";
      
      public static const GET_FAVORITE_APPS:String = "getFavoriteApps";
      
      public var mData:* = null;
      
      public function AMSEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

