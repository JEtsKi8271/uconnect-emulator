package com.harman.navigation.trail
{
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.CRC32;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class TrailManager
   {
      
      private static const TRAIL_FILE_EXTENSION:String = ".gpx";
      
      private static const NAV_SECRETS:String = "NAV_SECRETS";
      
      private static var mShowNavSecrets:Boolean = false;
      
      private static const GPS_ONLY:String = "GPS_ONLY";
      
      private static var mGpsOnlyActive:Boolean = false;
      
      private static const GPS_DOT:String = "GPS_DOT";
      
      private static var mGpsDotActive:Boolean = false;
      
      private static const GNLOG_MSD:String = "GNLOG_MSD";
      
      private static var mGnLogMsdActive:Boolean = false;
      
      private static const NO_GPS:String = "NO_GPS";
      
      private static var mNoGpsActive:Boolean = false;
      
      private static const LOGGING:String = "LOGGING";
      
      private static var mLoggingActive:Boolean = false;
      
      private static const NAV_DEV_MODE:String = "navDevMode";
      
      private static var mNavDevMode:Boolean = false;
      
      private static const NAV_FILTER_DISABLE:String = "navFWD";
      
      private static var mNavFilterDisable:Boolean = false;
      
      private static const DEMO_MODE:String = "demoMode";
      
      private static var mDemoModeActive:Boolean = false;
      
      private static const DISABLE_SPEED_LOCKOUT:String = "disable_SpeedLockout";
      
      private static var mWatchdogDisabled:Boolean = false;
      
      private static const DISABLE_NAV_WATCHDOG:String = "NAV_WATCHDOG_DISABLE";
      
      private static var mWeatherAlertDisabled:Boolean = false;
      
      private static const DISABLE_NAV_WEATHER_ALERTS:String = "NAV_WEATHER_ALERTS_DISABLE";
      
      private var mNavService:Navigation;
      
      private var mRecordingActive:Boolean = false;
      
      private var mTrailsRecorded:Array = new Array();
      
      private var mNewTrailName:String = "";
      
      private var mTrailsPath:String = "";
      
      private var mTrailServiceReady:Boolean = false;
      
      private var mExecuteSuccessful:Boolean = false;
      
      private var mPersistInterval:uint = 0;
      
      private var mTrailServiceInterval:uint = 0;
      
      public function TrailManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.mPersistInterval = setInterval(this.onPersistInterval,NavGlobalSettings.TRAILS_SERVICE_REREQUEST_TIME);
         this.mTrailServiceInterval = setInterval(this.onTrailServiceInterval,NavGlobalSettings.TRAILS_SERVICE_REREQUEST_TIME);
      }
      
      private function onPersistInterval() : void
      {
         if(NavigationPackage.peripheral.navigation.navPersistence != null)
         {
            clearInterval(this.mPersistInterval);
            this.mNavService.sendSubscribe("\"RT_RecordingActive\"");
            this.mNavService.sendSubscribe("\"RT_RecordingComplete\"");
         }
      }
      
      private function onTrailServiceInterval() : void
      {
         if(!this.mTrailServiceReady)
         {
            this.requestTrailList();
            this.requestTrailFolder();
            this.checkFlagPresents();
         }
         else
         {
            clearInterval(this.mTrailServiceInterval);
         }
      }
      
      public function onRecordingActive(resp:Object) : void
      {
         if(resp.hasOwnProperty("routeRecordingActive"))
         {
            Framework.Trace("Nav.TrailManager.onRecordingActive( " + resp.routeRecordingActive + " )");
            this.mRecordingActive = resp.routeRecordingActive == 1 ? true : false;
            this.mNavService.sendEvent(NavigationEvent.TRAIL_RECORDING_ACTIVE);
            this.requestTrailList();
         }
      }
      
      public function onRecordingComplete(resp:Object) : void
      {
         if(resp.hasOwnProperty("routeRecordingComplete"))
         {
            Framework.Trace("Nav.TrailManager.onRecordingComplete( " + resp.routeRecordingComplete + " )");
         }
         Framework.Trace("Nav.TrailManager.onRecordingComplete()");
      }
      
      public function onStartRecording(resp:Object) : void
      {
         if(resp.hasOwnProperty("resultCode"))
         {
            Framework.Trace("Nav.TrailManager.onStartRecording( " + resp.resultCode + " ) confirmation");
            this.mRecordingActive = resp.resultCode == 1 ? true : false;
            this.mNavService.sendEvent(NavigationEvent.TRAIL_RECORDING_ACTIVE);
         }
      }
      
      public function getTrailServiceReady() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TRAIL_SERVICE_READY);
      }
      
      public function get trailServiceReady() : Boolean
      {
         return this.mTrailServiceReady;
      }
      
      public function trailInfoMessageHandler(e:ConnectionEvent) : void
      {
         if(e.hasOwnProperty("data"))
         {
            if(e.data.hasOwnProperty("ls_userTracks"))
            {
               if(e.data.ls_userTracks.hasOwnProperty("status"))
               {
                  this.createUserTracksFolder();
               }
               else if(e.data.ls_userTracks.hasOwnProperty("listing"))
               {
                  this.parseTrailList(e.data.ls_userTracks.listing);
                  if(!this.mTrailServiceReady)
                  {
                     clearInterval(this.mTrailServiceInterval);
                     this.mTrailServiceReady = true;
                     this.mNavService.sendEvent(NavigationEvent.TRAIL_SERVICE_READY);
                  }
               }
            }
            else if(e.data.hasOwnProperty("mkUserTracksFolder"))
            {
               if(e.data.mkUserTracksFolder.hasOwnProperty("result"))
               {
                  Framework.Trace("TrailManager.mkUserTracksFolder( " + e.data.mkUserTracksFolder.result + " )");
               }
            }
            else if(e.data.hasOwnProperty("mvTrack"))
            {
               Framework.Trace("TrailManager.message.mvTrack()");
               this.requestTrailList();
            }
            else if(e.data.hasOwnProperty("rmTrack"))
            {
               Framework.Trace("TrailManager.message.rmTrack()");
               this.requestTrailList();
            }
            else if(e.data.hasOwnProperty("getTracksFolder"))
            {
               if(e.data.getTracksFolder.hasOwnProperty("result"))
               {
                  this.mTrailsPath = String(e.data.getTracksFolder.result);
               }
            }
            else if(e.data.hasOwnProperty("ls"))
            {
               if(e.data.ls.hasOwnProperty("listing"))
               {
                  this.parseListing(e.data.ls.listing);
               }
            }
            else if(e.data.hasOwnProperty("execute"))
            {
               if(e.data.execute.hasOwnProperty("result"))
               {
                  if(e.data.execute.result == 0)
                  {
                     Framework.Trace("trailInfoMessageHandler: mExecuteSuccessful= true");
                     this.mExecuteSuccessful = true;
                  }
                  else
                  {
                     Framework.Trace("trailInfoMessageHandler: mExecuteSuccessful= false");
                     this.mExecuteSuccessful = false;
                  }
               }
               this.mNavService.sendEvent(NavigationEvent.TRAIL_SERVICE_EXECUTE);
            }
         }
      }
      
      private function parseTrailList(list:Object) : void
      {
         var i:String = null;
         this.mTrailsRecorded.splice(0,this.mTrailsRecorded.length);
         if(list != null)
         {
            for(i in list)
            {
               if(String(i).indexOf(TRAIL_FILE_EXTENSION) != -1)
               {
                  this.mTrailsRecorded.push(String(i).substr(0,String(i).indexOf(TRAIL_FILE_EXTENSION)));
               }
            }
         }
         this.mNavService.sendEvent(NavigationEvent.TRAIL_LIST_UPDATE);
      }
      
      public function recordingStart() : void
      {
         if(this.mRecordingActive)
         {
            Framework.Trace("Nav.TrailManager.recordingStart() blocked! (recording already active)");
         }
         else if(this.mTrailsRecorded.length >= NavGlobalSettings.TRAILS_MAX_TRAILS)
         {
            Framework.Trace("Nav.TrailManager.recordingStart() blocked! (" + this.mTrailsRecorded.length + "of" + NavGlobalSettings.TRAILS_MAX_TRAILS + ")");
         }
         else
         {
            Framework.Trace("Nav.TrailManager.recordingStart()");
            this.mNavService.sendCommand("\"RT_StartRecording\":\"\"");
         }
      }
      
      public function recordingStop(trailName:String) : void
      {
         if(this.mRecordingActive)
         {
            this.mNewTrailName = this.checkForDuplicateNames(trailName,-1);
            this.mNavService.sendCommand("\"RT_StopRecording\":\"\"");
         }
         else
         {
            Framework.Trace("Nav.TrailManager.recordingStop() blocked! (No recording active)");
         }
      }
      
      public function renameTrail(index:int, newTrailName:String) : void
      {
         Framework.Trace("Nav.TrailManager.renameTrail( " + index + ", " + newTrailName + " )");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"mvTrack\":{\"filenameOld\":\"" + String(this.mTrailsRecorded[index]) + TRAIL_FILE_EXTENSION + "\",\"filenameNew\":\"" + this.checkForDuplicateNames(newTrailName,index) + TRAIL_FILE_EXTENSION + "\"}");
         this.requestTrailList();
      }
      
      public function trailDelete(index:int) : void
      {
         Framework.Trace("Nav.TrailManager.trailDelete( " + index + " )");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"rmTrack\":{\"filename\":\"" + String(this.mTrailsRecorded[index]) + TRAIL_FILE_EXTENSION + "\"}");
      }
      
      public function trailDeleteAll() : void
      {
         Framework.Trace("Nav.TrailManager.trailDeleteAll()");
         for(var i:int = 0; i < this.mTrailsRecorded.length; i++)
         {
            this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"rmTrack\":{\"filename\":\"" + String(this.mTrailsRecorded[i]) + TRAIL_FILE_EXTENSION + "\"}");
         }
      }
      
      public function getRecordingActive() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TRAIL_RECORDING_ACTIVE);
      }
      
      public function get recordingActive() : Boolean
      {
         return this.mRecordingActive;
      }
      
      public function getList() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TRAIL_RECORDING_ACTIVE);
      }
      
      public function get list() : Array
      {
         return this.mTrailsRecorded;
      }
      
      public function get executeSuccessful() : Boolean
      {
         return this.mExecuteSuccessful;
      }
      
      public function getTrailPath(index:int) : String
      {
         return this.mTrailsPath + this.mTrailsRecorded[index] + TRAIL_FILE_EXTENSION;
      }
      
      public function extractTrailNameFromPath(path:String) : String
      {
         var erg:String = path.replace(this.mTrailsPath,"");
         return erg.replace(TRAIL_FILE_EXTENSION,"");
      }
      
      private function requestTrailList() : void
      {
         Framework.Trace("TrailManager.requestTrailList()");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls_userTracks\":\"\"");
      }
      
      private function requestTrailFolder() : void
      {
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"getTracksFolder\":\"\"");
      }
      
      private function createUserTracksFolder() : void
      {
         Framework.Trace("TrailManager.createUserTracksFolder()");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"mkUserTracksFolder\":\"\"");
      }
      
      private function checkForDuplicateNames(name:String, index:int) : String
      {
         if(name == "")
         {
            name += "i";
         }
         for(var i:int = 0; i < this.mTrailsRecorded.length; i++)
         {
            if(String(this.mTrailsRecorded[i]) == name && i != index)
            {
               Framework.Trace("TrailManager.checkForDuplicateNames( " + name + " ) -> " + i);
               name += "i";
               i = 0;
            }
         }
         return name;
      }
      
      private function checkFlagPresents() : void
      {
         Framework.Trace("TrailManager.checkFlagPresents()");
         mShowNavSecrets = false;
         mGpsOnlyActive = false;
         mGpsDotActive = false;
         mGnLogMsdActive = false;
         mNoGpsActive = false;
         mLoggingActive = false;
         mNavDevMode = false;
         mNavFilterDisable = false;
         mDemoModeActive = false;
         mWatchdogDisabled = false;
         mWeatherAlertDisabled = false;
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls\":{\"path\":\"/fs/etfs/\", \"pattern\":\"\"}");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls\":{\"path\":\"/fs/mmc1/\", \"pattern\":\"\"}");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls\":{\"path\":\"/fs/mmc1/flags/\", \"pattern\":\"\"}");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls\":{\"path\":\"/fs/mmc0/nav/\", \"pattern\":\"\"}");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"ls\":{\"path\":\"/fs/data/flags/nav/\", \"pattern\":\"\"}");
      }
      
      private function parseListing(list:Object) : void
      {
         var i:String = null;
         if(list != null)
         {
            for(i in list)
            {
               if(i == NAV_SECRETS)
               {
                  mShowNavSecrets = true;
               }
               else if(i == GPS_ONLY)
               {
                  mGpsOnlyActive = true;
               }
               else if(i == GPS_DOT)
               {
                  mGpsDotActive = true;
               }
               else if(i == GNLOG_MSD)
               {
                  mGnLogMsdActive = true;
               }
               else if(i == NO_GPS)
               {
                  mNoGpsActive = true;
               }
               else if(i == LOGGING)
               {
                  mLoggingActive = true;
               }
               else if(i == NAV_DEV_MODE)
               {
                  mNavDevMode = true;
               }
               else if(i == NAV_FILTER_DISABLE)
               {
                  mNavFilterDisable = true;
                  this.setForceSendConsoleCommand("pf" + "ctl -" + "d");
               }
               else if(i == DEMO_MODE)
               {
                  this.mNavService.setDemoMode(true);
                  mDemoModeActive = true;
               }
               else if(i == DISABLE_SPEED_LOCKOUT)
               {
                  Framework.Trace("NavigationPackage.peripheral.vehicleStatus.speedLockOutFeature " + NavigationPackage.peripheral.vehicleStatus.speedLockOutFeature);
                  if(NavigationPackage.peripheral.vehicleStatus.speedLockOutFeature.toLowerCase() == "on" || NavigationPackage.peripheral.vehicleStatus.speedLockOutFeature.toLowerCase() == "undefined")
                  {
                     NavigationPackage.peripheral.vehicleStatus.toggleSpeedLockOutFeature();
                  }
               }
               else if(i == DISABLE_NAV_WATCHDOG)
               {
                  mWatchdogDisabled = true;
               }
               else if(i == DISABLE_NAV_WEATHER_ALERTS)
               {
                  mWeatherAlertDisabled = true;
               }
            }
            this.mNavService.sendEvent(NavigationEvent.SPECIAL_FEATURES);
         }
      }
      
      public function getNavSpecialFeatureActive(feature:String) : Boolean
      {
         switch(feature)
         {
            case NAV_SECRETS:
               return mShowNavSecrets;
            case GPS_ONLY:
               return mGpsOnlyActive;
            case GPS_DOT:
               return mGpsDotActive;
            case GNLOG_MSD:
               return mGnLogMsdActive;
            case NO_GPS:
               return mNoGpsActive;
            case LOGGING:
               return mLoggingActive;
            case NAV_DEV_MODE:
               return mNavDevMode;
            case NAV_FILTER_DISABLE:
               return mNavFilterDisable;
            case DEMO_MODE:
               return mDemoModeActive;
            case DISABLE_NAV_WATCHDOG:
               return mWatchdogDisabled;
            case DISABLE_NAV_WEATHER_ALERTS:
               return mWeatherAlertDisabled;
            default:
               return false;
         }
      }
      
      public function setNavSpecialFeatureFlag(feature:String, enable:Boolean) : void
      {
         Framework.Trace("TrailManager.setNavSpecialFeatureFlag( " + feature + ", " + enable + " )");
         switch(feature)
         {
            case GNLOG_MSD:
               this.setForceSendConsoleCommand("mount -uw /fs/mmc1");
               if(enable)
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"touch /fs/mmc1/flags/" + feature + "\"}");
               }
               else
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"rm /fs/mmc1/flags/" + feature + "\"}");
               }
               break;
            case LOGGING:
               this.setForceSendConsoleCommand("mount -uw /fs/mmc1");
               if(enable)
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"touch /fs/mmc1/flags/LOGGING\"}");
               }
               else
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"rm /fs/mmc1/flags/LOGGING\"}");
               }
               break;
            default:
               if(enable)
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"touch /fs/etfs/" + feature + "\"}");
               }
               else
               {
                  this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"rm /fs/etfs/" + feature + "\"}");
               }
         }
         this.checkFlagPresents();
      }
      
      public function setForceSoftwareUpdateMode() : void
      {
         Framework.Trace("TrailManager.setForceSoftwareUpdateMode()");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\". /tmp/envars.sh\"}");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"dbus-send --print-reply --type=method_call --dest=\'com.harman.service.SoftwareUpdate\'  /com/harman/service/SoftwareUpdate com.harman.ServiceIpc.Invoke  string:beginUpdate  string:\'{}\' &\"}");
      }
      
      public function setForceDeleteNaviServerPersistence() : void
      {
         Framework.Trace("TrailManager.setForceDeleteNaviServerPersistence()");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"rm -r /fs/etfs/usr/NNG_save/save\"}");
      }
      
      public function setForceSendConsoleCommand(command:String) : void
      {
         Framework.Trace("TrailManager.setForceSendConsoleCommand( " + command + " )");
         this.mNavService.sendServiceCommand(Navigation.dbusNavigationTrailInfoIdentifier,"\"execute\":{\"cmd\":\"" + command + "\"}");
      }
      
      public function readObjectFromFile(fileName:String) : Object
      {
         var fileCrc:File;
         var obj:Object = null;
         var readCrc:uint = 0;
         var fileStream:FileStream = new FileStream();
         var file:File = new File("file://" + fileName);
         try
         {
            fileStream.open(file,FileMode.READ);
            obj = fileStream.readObject();
            fileStream.close();
         }
         catch(err:Error)
         {
            Framework.Trace("Error while Reading Object!");
            obj = null;
         }
         fileCrc = new File("file://" + fileName + NavGlobalSettings.FILE_TO_OBJECT_CRC_EXTENSION);
         try
         {
            fileStream.open(fileCrc,FileMode.READ);
            readCrc = uint(fileStream.readUnsignedInt());
            fileStream.close();
         }
         catch(err:Error)
         {
            Framework.Trace("Error while Reading CRC!");
            obj = null;
         }
         if(1)
         {
            return obj;
         }
         Framework.Trace("Error while checking CRC (" + fileName + ").");
         return null;
      }
      
      public function writeObjectToFile(fileName:String, object:Object) : Boolean
      {
         var crcChk:CRC32;
         var fileCrc:File;
         var fileStream:FileStream = new FileStream();
         var file:File = new File("file://" + fileName);
         try
         {
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeObject(object);
            fileStream.close();
         }
         catch(err:Error)
         {
            Framework.Trace("Error while Writing Object!");
            return false;
         }
         crcChk = new CRC32();
         fileCrc = new File("file://" + fileName + NavGlobalSettings.FILE_TO_OBJECT_CRC_EXTENSION);
         try
         {
            fileStream.open(fileCrc,FileMode.WRITE);
            fileStream.writeUnsignedInt(crcChk.getCrcFromObject(object));
            fileStream.close();
         }
         catch(err:Error)
         {
            Framework.Trace("Error while Writing CRC!");
            return false;
         }
         return true;
      }
   }
}

