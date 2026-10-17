package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AppManagerEvent extends Event
   {
      
      public static const APP_MANAGER_STATUS:String = "appManagerStatus";
      
      public static const REFRESH_APPLICATIONS:String = "refreshApplications";
      
      public static const APPLIST:String = "appList";
      
      public static const GET_APP_LIST:String = "getAppList";
      
      public static const INVOKE_BACK:String = "invokeBack";
      
      public static const APP_ICON_AVAILABLE:String = "appIconAvailable";
      
      public static const APP_VR_IN_FOCUS:String = "appVRinFocus";
      
      public static const OPER_STATUS_UPDATE:String = "operStatusUpdate";
      
      public static const CLOSE:String = "close";
      
      public static const DRM_VERIFICATION:String = "DRM_Verification";
      
      public static const STOP_START_APP:String = "stopStartApp";
      
      public static const APP_STOPPED_STARTED:String = "appStoppedStarted";
      
      public static const APP_PACKAGE_INFO:String = "appPackageInfo";
      
      public static const START_XLET_ERROR:String = "startXletError";
      
      public static const XLET_ACTION_CANCELED:String = "xletActionCanceled";
      
      public static const APP_PAUSED:String = "appPaused";
      
      public static const APP_REQUEST_RUNNING_SCREEN:String = "gotoRunningAppsScreen";
      
      public static const ASSIST_REQUEST:String = "assistRequest";
      
      public static const APP_VR_BAR_STATUS:String = "appVRBarStatus";
      
      public static const TOO_MANY_APPS:String = "tooManyApps";
      
      public static const APP_PAUSE_CALLED:String = "appPauseCalled";
      
      public static const GET_XLETS_DIR:String = "getXletsDir";
      
      public static const START_RUNNING_APP:String = "startRunningApp";
      
      public var mData:* = null;
      
      public function AppManagerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

