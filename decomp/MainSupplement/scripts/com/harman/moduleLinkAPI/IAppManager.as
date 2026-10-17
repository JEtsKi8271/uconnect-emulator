package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAppManager extends IModule
   {
      
      function get applications() : Array;
      
      function getAllApplications() : Array;
      
      function get status() : String;
      
      function get running() : Array;
      
      function get sortingMethod() : String;
      
      function set sortingMethod(param1:String) : void;
      
      function get activeCategory() : int;
      
      function set activeCategory(param1:int) : void;
      
      function set closedAppId(param1:String) : void;
      
      function get closedAppId() : String;
      
      function set driveModeApp(param1:Applet) : void;
      
      function set rearMediaPresent(param1:Boolean) : void;
      
      function get favoriteAppsFull() : Boolean;
      
      function get update_statusText() : String;
      
      function get update_statusType() : int;
      
      function get superAppSourceLabel() : String;
      
      function set superAppSourceLabel(param1:String) : void;
      
      function get superAppSourceIcon() : String;
      
      function set superAppSourceIcon(param1:String) : void;
      
      function get moreScreenSourceIcon() : String;
      
      function set moreScreenSourceIcon(param1:String) : void;
      
      function isUpdateTypeFinish(param1:int) : Boolean;
      
      function saveAppCategory(param1:String) : void;
      
      function getAppList(param1:int) : void;
      
      function setFavorite(param1:String, param2:Boolean) : void;
      
      function startXlet(param1:String, param2:String = "") : void;
      
      function stopXlet(param1:String) : void;
      
      function pauseXlet(param1:String) : void;
      
      function isAppVRFocus() : void;
      
      function startEmbedded(param1:String) : void;
      
      function getRunningAppId() : String;
      
      function getLastRunningAppId() : String;
      
      function getAppLaunchedFromCategory(param1:String) : int;
      
      function isDaemonApp(param1:String) : Boolean;
      
      function appHasGUI(param1:String) : Boolean;
      
      function setAppMenuActive(param1:Boolean) : void;
      
      function verifyDRM(param1:String, param2:String) : void;
      
      function xletReturnToNew() : void;
      
      function getAppPackageInfo(param1:String) : void;
      
      function getAppsExist() : String;
      
      function getIsSuperAppSystem() : Boolean;
      
      function getSuperAppId() : String;
      
      function startLastAudioApp() : void;
      
      function startAudioApp(param1:String, param2:String = "") : void;
      
      function startLastPausedApp(param1:String = "") : Boolean;
      
      function isAudioAppRunning() : Boolean;
      
      function get isSuperAppInAppsList() : Boolean;
      
      function isSuperAppReady() : Boolean;
      
      function checkSuperAppInAppsList(param1:Array) : void;
      
      function isAppInFocus(param1:String) : Boolean;
      
      function isAppRunning(param1:String) : Boolean;
      
      function confirmedStartAssist() : void;
      
      function getPendingPause() : Boolean;
      
      function startDaemonXlet(param1:String) : void;
      
      function pauseDaemonXlet(param1:String) : void;
      
      function stopDaemonXlet(param1:String) : void;
      
      function setDriveModeName(param1:String) : void;
      
      function getPPId() : String;
      
      function getXletsDir() : String;
   }
}

