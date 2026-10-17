package com.harman.navigation
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface INavigationCommon extends IModule
   {
      
      function getAuthenticationDeviceID() : void;
      
      function get authenticationDeviceID() : String;
      
      function setAuthenticationCode(param1:String) : void;
      
      function get authenticationResponse() : Boolean;
      
      function requestPreviousVP3ActivationCode() : void;
      
      function get previousVP3ActivationCode() : String;
      
      function navGetInstrumentClusterEnabled() : void;
      
      function get navInstrumentClusterEnabled() : Boolean;
      
      function navSetInstrumentClusterEnabled(param1:Boolean) : void;
      
      function setGWRenderingEnable(param1:Boolean) : void;
      
      function getGWRenderingEnabled() : void;
      
      function get gwRenderingEnabled() : Boolean;
      
      function setGWProductVisibility(param1:int) : void;
      
      function getGWProductVisibility() : void;
      
      function get gwProductVisibility() : int;
      
      function setGWNowradTransparancy(param1:int) : void;
      
      function getGWNowradTransparancy() : void;
      
      function get gwNowradTransparancy() : int;
      
      function setGWZoomLevelIndex(param1:int) : void;
      
      function getGWZoomLevelIndex() : void;
      
      function get gwZoomLevelIndex() : int;
      
      function getGWProductTimeStamp() : void;
      
      function get gwProductUpdateTime() : String;
      
      function get gwProductUpdateDate() : String;
      
      function gwCenterOnCurrentPosition() : void;
      
      function get gwAlertPopupInfo() : Object;
      
      function get gwShowAlertButton() : Boolean;
      
      function trailRecordingStart() : void;
      
      function trailRecordingStop(param1:String) : void;
      
      function trailRename(param1:int, param2:String) : void;
      
      function trailDelete(param1:int) : void;
      
      function trailDeleteAll() : void;
      
      function getTrailrecordingActive() : void;
      
      function get trailrecordingActive() : Boolean;
      
      function getTrailList() : void;
      
      function get trailList() : Array;
      
      function getTrailPath(param1:int) : String;
      
      function getTrailServiceReady() : void;
      
      function get trailServiceReady() : Boolean;
      
      function extractTrailNameFromPath(param1:String) : String;
      
      function getNavSpecialFeatureActive(param1:String) : Boolean;
      
      function setNavSpecialFeatureFlag(param1:String, param2:Boolean) : void;
      
      function setForceSoftwareUpdateMode() : void;
      
      function setForceDeleteNaviServerPersistence() : void;
      
      function setForceSendConsoleCommand(param1:String) : void;
      
      function readObjectFromFile(param1:String) : Object;
      
      function writeObjectToFile(param1:String, param2:Object) : Boolean;
      
      function getExecuteSuccessful() : Boolean;
      
      function requestOTAUAvailablePackages() : void;
      
      function getOTAUAvailablePackages() : void;
      
      function get oTAUavailablePackages() : Array;
      
      function requestOTAUDownloadUpdatePackages() : void;
      
      function requestOTAUStopAllDownloads() : void;
      
      function requestOTAUInstallPackages() : void;
      
      function getOTAUpdateState() : void;
      
      function get oTAUpdateState() : int;
      
      function requestOTAUStateReset() : void;
      
      function get lsAuthenticationStatus() : Object;
      
      function lsRequestLocalSearch(param1:String, param2:String, param3:int, param4:int) : void;
      
      function lsRequestWeatherData(param1:String) : void;
      
      function lsReportSpeedCamera(param1:int, param2:String, param3:int, param4:int) : void;
      
      function lsSetSpeedCameraAlertSettings(param1:Object) : void;
      
      function lsSetServerCommunicationEnable(param1:Boolean) : void;
      
      function get lsServiceTurnedOn() : Boolean;
      
      function get lsServiceStatus() : int;
      
      function get lsServicesAvailable() : int;
      
      function set lsDataSimulationEnabled(param1:Boolean) : void;
      
      function get lsDataSimulationEnabled() : Boolean;
   }
}

