package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.moduleLink.AppManager;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.Controller.LiveServices.SpeedCameraAlertSettingTypes;
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   
   public class SpeedCamera extends Helper
   {
      
      private var mSpeedCameraAlertSettings:Object = new Object();
      
      private var mReportSpeedCameraCamType:int = 0;
      
      private var mReportSpeedCameraSpeedLimit:int = 0;
      
      private var mReportSpeedCameraLocation:String = "";
      
      private var mSendPastCameraReport:Boolean = false;
      
      private var mVehicleDirection:int = 0;
      
      private var mPersData:String = "";
      
      public function SpeedCamera()
      {
         super();
         this.mSpeedCameraAlertSettings[SpeedCameraAlertSettingTypes.SCAS_FIXED_CAMERAS] = SpeedCameraAlertSettingTypes.SCAS_OFF;
         this.mSpeedCameraAlertSettings[SpeedCameraAlertSettingTypes.SCAS_TRAFFIC_LIGHT_CAMERAS] = SpeedCameraAlertSettingTypes.SCAS_OFF;
         this.mSpeedCameraAlertSettings[SpeedCameraAlertSettingTypes.SCAS_AVERAGE_SPEED_CHECK] = SpeedCameraAlertSettingTypes.SCAS_OFF;
         this.mSpeedCameraAlertSettings[SpeedCameraAlertSettingTypes.SCAS_ACCIDENT_BLACKSPOTS] = SpeedCameraAlertSettingTypes.SCAS_OFF;
         mController.addEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onServiceUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_SPEEDCAM_FEEDBACK_UPDATE,this.onSpeedcamFeedbackUpdate,false,0,true);
      }
      
      public function get alertSettings() : Object
      {
         return this.mSpeedCameraAlertSettings;
      }
      
      public function set alertSettings(settings:Object) : void
      {
         this.mSpeedCameraAlertSettings = settings;
         NavigationApi.api.lsSetSpeedCameraAlertSettings(this.mSpeedCameraAlertSettings);
         sendEvent(LiveServicesEvent.LS_SPEED_CAMERA_ALERT_SETTINGS);
      }
      
      public function reportSpeedCameraType(type:int) : void
      {
         this.mReportSpeedCameraCamType = type;
      }
      
      public function speedCameraTypeRequiresSpeedLimit() : Boolean
      {
         for(var i:int = 0; i < NavGlobalSettingsCommon.LS_REPORT_SPEED_CAM_REPORT_NO_SPEED.length; i++)
         {
            if(NavGlobalSettingsCommon.LS_REPORT_SPEED_CAM_REPORT_NO_SPEED[i] == this.mReportSpeedCameraCamType)
            {
               return false;
            }
         }
         return true;
      }
      
      public function reportSpeedCameraSpeed(speed:int) : void
      {
         this.mReportSpeedCameraSpeedLimit = speed;
      }
      
      public function reportSpeedCameraLocation(geo:String) : void
      {
         this.mReportSpeedCameraLocation = geo;
      }
      
      public function requestReportSpeedCamera() : void
      {
         this.mVehicleDirection = this.vehicleDirection;
         this.reportSpeedCamera();
      }
      
      private function reportSpeedCamera() : void
      {
         if(mController.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_SPEEDCAM_FEEDBACK))
         {
            NavigationApi.api.lsReportSpeedCamera(this.mReportSpeedCameraCamType,this.mReportSpeedCameraLocation,this.speedCameraTypeRequiresSpeedLimit() ? this.mReportSpeedCameraSpeedLimit : 0,this.mVehicleDirection);
         }
         else
         {
            this.mSendPastCameraReport = true;
            mController.toPersistence();
         }
         sendEvent(LiveServicesEvent.LS_SPEED_CAMERA_REPORTED);
      }
      
      public function get speedCameraType() : int
      {
         return this.mReportSpeedCameraCamType;
      }
      
      public function get speedCameraSpeed() : int
      {
         return this.mReportSpeedCameraSpeedLimit;
      }
      
      public function onGetAppExistSignal() : void
      {
         if(AppManager.getInstance().getAppsExist() == "true")
         {
            this.persistencyData = this.mPersData;
            AppManager.getInstance().removeEventListener(ModuleEvent.READY,this.onGetAppExistSignal);
         }
      }
      
      public function get persistencyData() : String
      {
         var i:String = null;
         var pers:String = "";
         for(i in this.mSpeedCameraAlertSettings)
         {
            pers += i + ":" + this.mSpeedCameraAlertSettings[i] + ";";
         }
         return pers;
      }
      
      public function set persistencyData(pers:String) : void
      {
         while(pers.length > 0)
         {
            if(pers.indexOf(":") == 1 && pers.indexOf(";") == 3)
            {
               this.mSpeedCameraAlertSettings[int(pers.charAt(0))] = int(pers.charAt(2));
            }
            pers = pers.substring(4,pers.length);
         }
         if(mController.ttlsSserviceIsSupportedBySystem)
         {
            if(mController.ttlsUConnectACNAvailable)
            {
               NavigationApi.api.lsSetSpeedCameraAlertSettings(this.mSpeedCameraAlertSettings);
            }
            else
            {
               this.mPersData = pers;
               mController.addEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServicesEnabled);
            }
         }
         else
         {
            this.mPersData = pers;
            if(AppManager.getInstance().getAppsExist() != "true")
            {
               AppManager.getInstance().addEventListener(ModuleEvent.READY,this.onGetAppExistSignal);
            }
         }
      }
      
      public function get persistencyReportData() : String
      {
         var pers:String = "";
         pers += this.mSendPastCameraReport + ";";
         pers += this.mReportSpeedCameraCamType + ";";
         pers += this.mReportSpeedCameraLocation + ";";
         pers += this.mReportSpeedCameraSpeedLimit + ";";
         return pers + this.mVehicleDirection;
      }
      
      public function set persistencyReportData(pers:String) : void
      {
         var array:Array = pers.split(";");
         if(array.length >= 5)
         {
            this.mSendPastCameraReport = String(array[0]) == "true" ? true : false;
            this.mReportSpeedCameraCamType = int(array[1]);
            this.mReportSpeedCameraLocation = String(array[2]);
            this.mReportSpeedCameraSpeedLimit = int(array[3]);
            this.mVehicleDirection = int(array[4]);
         }
      }
      
      public function checkSendPastCameraReport() : void
      {
         if(this.mSendPastCameraReport)
         {
            this.reportSpeedCamera();
            this.clearPastCameraReportData();
         }
      }
      
      public function clearPastCameraReportData() : void
      {
         this.mSendPastCameraReport = false;
         mController.toPersistence();
      }
      
      private function onServiceUpdate(e:LiveServicesEvent) : void
      {
         if(mController.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_SPEEDCAM_FEEDBACK))
         {
            this.checkSendPastCameraReport();
         }
      }
      
      private function onLiveServicesEnabled(e:LiveServicesEvent) : void
      {
         if(mController.ttlsUConnectACNAvailable)
         {
            this.persistencyData = this.mPersData;
            mController.removeEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServicesEnabled);
         }
      }
      
      private function onSpeedcamFeedbackUpdate(e:NavigationEvent) : void
      {
         Framework.Trace("SpeedCamera.onSpeedcamFeedbackUpdate( " + int(e.data) + " )");
      }
      
      private function get vehicleDirection() : int
      {
         var dir:int = 0;
         if(NavigationApi.api.posPositionInformation.getType("<DIR>") != "")
         {
            dir = int(NavigationApi.api.posPositionInformation.getType("<DIR>"));
         }
         dir = dir % 256 * 360 / 256;
         dir = (dir - 360) * -1;
         dir %= 360;
         if(dir < 0)
         {
            dir *= -1;
         }
         return dir;
      }
   }
}

