package com.harman.navigation
{
   import com.harman.navigation.authentication.AuthenticationServiceManager;
   import com.harman.navigation.authentication.authenticationManager;
   import com.harman.navigation.graphicalWeather.GraphicalWeatherManager;
   import com.harman.navigation.instrumentCluster.instrumentClusterManager;
   import com.harman.navigation.liveServices.LiveServicesManager;
   import com.harman.navigation.overTheAirUpdate.OverTheAirUpdateManager;
   import com.harman.navigation.trail.TrailManager;
   import flash.events.EventDispatcher;
   
   public class NavigationBaseCommon extends EventDispatcher
   {
      
      protected var mAuthenticationManager:authenticationManager;
      
      protected var mAuthenticationServiceManager:AuthenticationServiceManager;
      
      protected var mGraphicalWeatherManager:GraphicalWeatherManager;
      
      protected var mInstrumentClusterManager:instrumentClusterManager;
      
      protected var mLiveServicesManger:LiveServicesManager;
      
      protected var mOverTheAirUpdateManager:OverTheAirUpdateManager;
      
      protected var mTrailManager:TrailManager;
      
      public function NavigationBaseCommon()
      {
         super();
      }
      
      public function getAuthenticationDeviceID() : void
      {
         if(this.mAuthenticationManager)
         {
            this.mAuthenticationManager.getAuthenticationDeviceID();
         }
      }
      
      public function get authenticationDeviceID() : String
      {
         return this.mAuthenticationManager.authenticationDeviceID;
      }
      
      public function setAuthenticationCode(code:String) : void
      {
         if(this.mAuthenticationManager)
         {
            this.mAuthenticationManager.setAuthenticationCode(code);
         }
      }
      
      public function get authenticationResponse() : Boolean
      {
         return this.mAuthenticationManager.authenticationResponse;
      }
      
      public function requestPreviousVP3ActivationCode() : void
      {
         if(this.mAuthenticationManager)
         {
            this.mAuthenticationManager.requestPreviousVP3ActivationCode();
         }
      }
      
      public function get previousVP3ActivationCode() : String
      {
         return this.mAuthenticationManager.previousVP3ActivationCode;
      }
      
      public function getProductDeviceID() : void
      {
         if(this.mAuthenticationServiceManager)
         {
            this.mAuthenticationServiceManager.getProductDeviceID();
         }
      }
      
      public function get productDeviceID() : String
      {
         return this.mAuthenticationServiceManager.productDeviceID;
      }
      
      public function getProductID() : void
      {
         if(this.mAuthenticationServiceManager)
         {
            this.mAuthenticationServiceManager.getProductID();
         }
      }
      
      public function get productID() : String
      {
         return this.mAuthenticationServiceManager.productID;
      }
      
      public function isProduct(id:String) : Boolean
      {
         return this.mAuthenticationServiceManager.isProduct(id);
      }
      
      public function navGetInstrumentClusterEnabled() : void
      {
         if(this.mInstrumentClusterManager)
         {
            this.mInstrumentClusterManager.getInstrumentClusterEnabled();
         }
      }
      
      public function get navInstrumentClusterEnabled() : Boolean
      {
         return this.mInstrumentClusterManager.instrumentClusterEnabled;
      }
      
      public function navSetInstrumentClusterEnabled(enable:Boolean) : void
      {
         if(this.mInstrumentClusterManager)
         {
            this.mInstrumentClusterManager.setInstrumentClusterEnabled(enable);
         }
      }
      
      public function setGWProductVisibility(vis:int) : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.setProductVisibility(vis);
         }
      }
      
      public function getGWProductVisibility() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.getProductVisibility();
         }
      }
      
      public function get gwProductVisibility() : int
      {
         return this.mGraphicalWeatherManager.productVisibility;
      }
      
      public function setGWNowradTransparancy(percent:int) : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.setNowradTransparancy(percent);
         }
      }
      
      public function getGWNowradTransparancy() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.getNowradTransparancy();
         }
      }
      
      public function get gwNowradTransparancy() : int
      {
         return this.mGraphicalWeatherManager.nowradTransparancy;
      }
      
      public function setGWZoomLevelIndex(index:int) : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.setZoomLevelIndex(index);
         }
      }
      
      public function getGWZoomLevelIndex() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.getZoomLevelIndex();
         }
      }
      
      public function get gwZoomLevelIndex() : int
      {
         return this.mGraphicalWeatherManager.zoomLevelIndex;
      }
      
      public function getGWProductTimeStamp() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.getProductTimeStamp();
         }
      }
      
      public function get gwProductUpdateTime() : String
      {
         return this.mGraphicalWeatherManager.productUpdateTime;
      }
      
      public function get gwProductUpdateDate() : String
      {
         return this.mGraphicalWeatherManager.productUpdateDate;
      }
      
      public function gwCenterOnCurrentPosition() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.centerOnCurrentPosition();
         }
      }
      
      public function setGWRenderingEnable(enable:Boolean) : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.setRenderingEnable(enable);
         }
      }
      
      public function getGWRenderingEnabled() : void
      {
         if(this.mGraphicalWeatherManager)
         {
            this.mGraphicalWeatherManager.getRenderingEnabled();
         }
      }
      
      public function get gwRenderingEnabled() : Boolean
      {
         return this.mGraphicalWeatherManager.renderingEnabled;
      }
      
      public function get gwAlertPopupInfo() : Object
      {
         return this.mGraphicalWeatherManager.alertPopupInfo;
      }
      
      public function get gwShowAlertButton() : Boolean
      {
         return this.mGraphicalWeatherManager.showAlertButton;
      }
      
      public function trailRecordingStart() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.recordingStart();
         }
      }
      
      public function trailRecordingStop(trailName:String) : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.recordingStop(trailName);
         }
      }
      
      public function trailRename(index:int, newTrailName:String) : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.renameTrail(index,newTrailName);
         }
      }
      
      public function trailDelete(index:int) : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.trailDelete(index);
         }
      }
      
      public function trailDeleteAll() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.trailDeleteAll();
         }
      }
      
      public function getTrailrecordingActive() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.getRecordingActive();
         }
      }
      
      public function get trailrecordingActive() : Boolean
      {
         return this.mTrailManager.recordingActive;
      }
      
      public function getTrailList() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.getList();
         }
      }
      
      public function get trailList() : Array
      {
         return this.mTrailManager.list;
      }
      
      public function getTrailPath(index:int) : String
      {
         return this.mTrailManager.getTrailPath(index);
      }
      
      public function getTrailServiceReady() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.getTrailServiceReady();
         }
      }
      
      public function get trailServiceReady() : Boolean
      {
         return this.mTrailManager.trailServiceReady;
      }
      
      public function extractTrailNameFromPath(path:String) : String
      {
         return this.mTrailManager.extractTrailNameFromPath(path);
      }
      
      public function getNavSpecialFeatureActive(feature:String) : Boolean
      {
         return this.mTrailManager.getNavSpecialFeatureActive(feature);
      }
      
      public function setNavSpecialFeatureFlag(feature:String, enable:Boolean) : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.setNavSpecialFeatureFlag(feature,enable);
         }
      }
      
      public function setForceSoftwareUpdateMode() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.setForceSoftwareUpdateMode();
         }
      }
      
      public function setForceDeleteNaviServerPersistence() : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.setForceDeleteNaviServerPersistence();
         }
      }
      
      public function setForceSendConsoleCommand(command:String) : void
      {
         if(this.mTrailManager)
         {
            this.mTrailManager.setForceSendConsoleCommand(command);
         }
      }
      
      public function readObjectFromFile(fileName:String) : Object
      {
         return this.mTrailManager.readObjectFromFile(fileName);
      }
      
      public function writeObjectToFile(fileName:String, object:Object) : Boolean
      {
         return this.mTrailManager.writeObjectToFile(fileName,object);
      }
      
      public function getExecuteSuccessful() : Boolean
      {
         return this.mTrailManager.executeSuccessful;
      }
      
      public function requestOTAUAvailablePackages() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.requestAvailablePackages();
         }
      }
      
      public function getOTAUAvailablePackages() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.getAvailablePackages();
         }
      }
      
      public function get oTAUavailablePackages() : Array
      {
         return this.mOverTheAirUpdateManager.availablePackages;
      }
      
      public function requestOTAUDownloadUpdatePackages() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.requestDownloadUpdatePackages();
         }
      }
      
      public function requestOTAUStopAllDownloads() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.requestStopAllDownloads();
         }
      }
      
      public function getOTAUpdateState() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.getUpdateState();
         }
      }
      
      public function get oTAUpdateState() : int
      {
         return this.mOverTheAirUpdateManager.updateState;
      }
      
      public function requestOTAUStateReset() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.requestStateReset();
         }
      }
      
      public function requestOTAUInstallPackages() : void
      {
         if(this.mOverTheAirUpdateManager)
         {
            this.mOverTheAirUpdateManager.requestInstallPackages();
         }
      }
      
      public function get lsAuthenticationStatus() : Object
      {
         return this.mLiveServicesManger.lsAuthenticationStatus;
      }
      
      public function lsRequestLocalSearch(search:String, geo:String, radius:int, results:int) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.requestLocalSearch(search,geo,radius,results);
         }
      }
      
      public function lsRequestWeatherData(geo:String) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.requestWeatherData(geo);
         }
      }
      
      public function lsReportSpeedCamera(cameraType:int, geo:String, speed:int, direction:int) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.reportSpeedCamera(cameraType,geo,speed,direction);
         }
      }
      
      public function lsSetSpeedCameraAlertSettings(settings:Object) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.setSpeedCameraAlertSettings(settings);
         }
      }
      
      public function lsSetServerCommunicationEnable(enable:Boolean) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.setServerCommunicationEnable(enable);
         }
      }
      
      public function get lsServiceTurnedOn() : Boolean
      {
         return this.mLiveServicesManger.ttlsTurnedOn;
      }
      
      public function get lsServiceStatus() : int
      {
         return this.mLiveServicesManger.ttlsStatus;
      }
      
      public function get lsServicesAvailable() : int
      {
         return this.mLiveServicesManger.ttlsAvailableServices;
      }
      
      public function set lsDataSimulationEnabled(enable:Boolean) : void
      {
         if(this.mLiveServicesManger)
         {
            this.mLiveServicesManger.lsDataSimulationEnabled = enable;
         }
      }
      
      public function get lsDataSimulationEnabled() : Boolean
      {
         return this.mLiveServicesManger.lsDataSimulationEnabled;
      }
   }
}

