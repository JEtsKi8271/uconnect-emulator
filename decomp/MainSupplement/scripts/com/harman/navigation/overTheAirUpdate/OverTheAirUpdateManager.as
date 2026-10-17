package com.harman.navigation.overTheAirUpdate
{
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class OverTheAirUpdateManager
   {
      
      private static const REQUEST_DOWNLOAD_UPDATE_PACKAGE:String = "OTA_DownloadUpdatePackage";
      
      private static const REQUEST_CANCEL_DOWNLOAD_UPDATE:String = "OTA_CancelDownloadUpdate";
      
      private static const INFORM_DOWNLOAD_UPDATE_STATUS:String = "OTA_DownloadUpdateStatus";
      
      private static const INFORM_DOWNLOAD_UPDATE_READY:String = "OTA_DownloadUpdateReady";
      
      private static const OTA_INSTALL_SCRIPT_LOCATION:String = "/fs/mmc0/app/bin/ota_install.sh";
      
      private static const DEMO:Boolean = false;
      
      private var mParent:Navigation;
      
      private var mOTAUpdateState:int = 0;
      
      private var mAvailablePackages:Array = new Array();
      
      private var mUpdatePackageDemoTimer:Timer = null;
      
      public function OverTheAirUpdateManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
         this.init();
         if(DEMO)
         {
            this.mUpdatePackageDemoTimer = new Timer(10000,1);
            this.mUpdatePackageDemoTimer.addEventListener(TimerEvent.TIMER,this.onUpdatePackageDemoTimer,false,0,true);
         }
      }
      
      private function init() : void
      {
         this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_PACKAGES_NOT_REQUESTED;
         this.mParent.sendSubscribe("\"" + INFORM_DOWNLOAD_UPDATE_STATUS + "\"");
         this.mParent.sendSubscribe("\"" + INFORM_DOWNLOAD_UPDATE_READY + "\"");
      }
      
      public function requestAvailablePackages() : void
      {
         var getListRequest:String = null;
         if(this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_REQUESTING_PACKAGES && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_DOWNLOAD_INITIALIZED && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_DOWNLOADING)
         {
            if(DEMO)
            {
               this.mUpdatePackageDemoTimer.start();
            }
            getListRequest = "\"Info_GetList\":{\"inputEIS\":\"<IFT>OTA<*><TYPE><*>\"" + ",\"inresultCount\":" + 999 + ",\"insortOption\":0" + ",\"instartIndex\":1" + ",\"cancelPreviousRequest\":false}";
            this.mParent.sendCommand(getListRequest);
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_REQUESTING_PACKAGES;
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
         else
         {
            Framework.Trace("OverTheAirUpdateManager.requestAvailablePackages() blocked (" + this.mOTAUpdateState + ")!");
         }
      }
      
      public function requestDownloadUpdatePackages() : void
      {
         var request:String = null;
         var i:int = 0;
         Framework.Trace("OverTheAirUpdateManager.requestDownloadUpdatePackages()");
         if(this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_UNDEFINED && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_GENERAL_ERROR && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_PACKAGES_NOT_REQUESTED && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_REQUESTING_PACKAGES && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_PACKAGES_AVAILABLE && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_DOWNLOAD_INITIALIZED && this.mOTAUpdateState != OverTheAirUpdateState.OTA_STATE_DOWNLOADING)
         {
            Framework.Trace(" -Not ready to start download! (" + this.mOTAUpdateState + ")");
         }
         else if(this.arePackagesSelectedForDownload())
         {
            request = "\"" + REQUEST_DOWNLOAD_UPDATE_PACKAGE + "\":{\"packages\":[";
            for(i = 0; i < this.mAvailablePackages.length; i++)
            {
               if(UpdatePackage(this.mAvailablePackages[i]).selectedForDownload)
               {
                  request += "\"<URL>" + UpdatePackage(this.mAvailablePackages[i]).url + "<*>\",";
               }
            }
            request = request.substring(0,request.length - 1);
            request += "]}";
            this.mParent.sendCommand(request);
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_DOWNLOAD_INITIALIZED;
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
         else
         {
            Framework.Trace(" -NO packages selected for download!");
         }
      }
      
      public function requestStopAllDownloads() : void
      {
         var info:String = null;
         var i:int = 0;
         if(this.mOTAUpdateState == OverTheAirUpdateState.OTA_STATE_DOWNLOADING)
         {
            info = "";
            for(i = 0; i < this.mAvailablePackages.length; i++)
            {
               if(UpdatePackage(this.mAvailablePackages[i]).downloadHandle != -1)
               {
                  info += i + ",";
               }
            }
            info = info.substring(0,info.length - 1);
            Framework.Trace("OverTheAirUpdateManager.requestStopAllDownloads(" + info + ")");
         }
         else
         {
            Framework.Trace("OverTheAirUpdateManager.requestStopAllDownloads() No Download in progress! (" + this.mOTAUpdateState + ")");
         }
      }
      
      public function requestInstallPackages() : void
      {
         if(this.mOTAUpdateState == OverTheAirUpdateState.OTA_STATE_DOWNLOAD_FINISHED)
         {
            Framework.Trace("OverTheAirUpdateManager.requestInstallPackages()");
            this.mParent.setForceSendConsoleCommand(OTA_INSTALL_SCRIPT_LOCATION + " &");
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_INSTALLING;
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
         else
         {
            Framework.Trace("OverTheAirUpdateManager.requestInstallPackages() Package downloads not finished! (" + this.mOTAUpdateState + ")");
         }
      }
      
      public function requestStateReset() : void
      {
         if(this.mOTAUpdateState == OverTheAirUpdateState.OTA_STATE_DOWNLOAD_ERROR)
         {
            this.mAvailablePackages.splice(0,this.mAvailablePackages.length);
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_PACKAGES_NOT_REQUESTED;
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
      }
      
      public function getAvailablePackages() : void
      {
         this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
      }
      
      public function get availablePackages() : Array
      {
         return this.mAvailablePackages;
      }
      
      public function getUpdateState() : void
      {
         this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
      }
      
      public function get updateState() : int
      {
         return this.mOTAUpdateState;
      }
      
      public function onInfo_GetList(resp:Object) : void
      {
         var i:int = 0;
         if(resp.hasOwnProperty("Info_GetList"))
         {
            this.mAvailablePackages.splice(0,this.mAvailablePackages.length);
            if(resp.Info_GetList.hasOwnProperty("resultCode"))
            {
               if(int(resp.Info_GetList.resultCode) == 1)
               {
                  for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                  {
                     this.mAvailablePackages.push(new UpdatePackage(String(resp.Info_GetList.itemList[i])));
                  }
                  if(this.mAvailablePackages.length > 0)
                  {
                     this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_PACKAGES_AVAILABLE;
                  }
                  else
                  {
                     this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_PACKAGES_NOT_AVAILABLE;
                  }
               }
               else
               {
                  Framework.Trace("OverTheAirUpdateManager.onInfo_GetList() ERROR resultCode: " + resp.Info_GetList.resultCode);
                  this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_GENERAL_ERROR;
               }
            }
            else
            {
               this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_GENERAL_ERROR;
            }
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
      }
      
      public function responseDownloadUpdatePackage(resp:Object) : void
      {
         var i:int = 0;
         var j:int = 0;
         var found:Boolean = false;
         Framework.Trace("OverTheAirUpdateManager.responseDownloadUpdatePackage()");
         if(1)
         {
            if(1)
            {
               i = 0;
               j = 0;
               for(i = 0; i < resp.handles.length; i++)
               {
                  found = false;
                  for(j = 0; j < this.mAvailablePackages.length; j++)
                  {
                     if(UpdatePackage(this.mAvailablePackages[j]).selectedForDownload == true && UpdatePackage(this.mAvailablePackages[j]).downloadHandle == -1)
                     {
                        UpdatePackage(this.mAvailablePackages[j]).setDownloadHandle(int(resp.handles[i]));
                        found = true;
                        break;
                     }
                  }
                  if(!found)
                  {
                     Framework.Trace(" -no available package found for Handle \'" + String(resp.handles[i]) + "\'");
                  }
               }
               for(j = 0; j < this.mAvailablePackages.length; j++)
               {
                  if(UpdatePackage(this.mAvailablePackages[j]).selectedForDownload == true && UpdatePackage(this.mAvailablePackages[j]).downloadHandle == -1)
                  {
                     Framework.Trace(" -no downloadHandle received for \'" + UpdatePackage(this.mAvailablePackages[j]).url + "\'");
                  }
               }
               this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_DOWNLOADING;
            }
            else
            {
               Framework.Trace(" -ERROR resultCode: " + resp.resultCode);
               this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_DOWNLOAD_ERROR;
            }
         }
         else
         {
            Framework.Trace(" -ERROR! " + resp.status);
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_DOWNLOAD_ERROR;
         }
         this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
      }
      
      public function informDownloadUpdateStatus(resp:Object) : void
      {
         var i:String = null;
         var found:Boolean = false;
         var j:int = 0;
         Framework.Trace("OverTheAirUpdateManager.informDownloadUpdateStatus()");
         for(i in resp)
         {
            found = false;
            for(j = 0; j < this.mAvailablePackages.length; j++)
            {
               if(UpdatePackage(this.mAvailablePackages[j]).downloadHandle == int(i))
               {
                  UpdatePackage(this.mAvailablePackages[j]).setDownloadStatus(int(resp[i].status));
                  UpdatePackage(this.mAvailablePackages[j]).setDownloadProgress(int(resp[i].progress));
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               Framework.Trace(" -no match found for: \'" + i + "\'");
               Framework.Trace("  -handle \'" + resp.handle + "\'");
               Framework.Trace("  -status \'" + resp.status + "\'");
               Framework.Trace("  -progress \'" + resp.progress + "\'");
            }
            else
            {
               this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
            }
         }
      }
      
      public function informDownloadUpdateReady(resp:Object) : void
      {
         var i:String = null;
         var downloadsFinished:Boolean = false;
         var found:Boolean = false;
         Framework.Trace("OverTheAirUpdateManager.informDownloadUpdateReady()");
         var j:int = 0;
         for(i in resp)
         {
            found = false;
            for(j = 0; j < this.mAvailablePackages.length; j++)
            {
               if(UpdatePackage(this.mAvailablePackages[j]).downloadHandle == int(i))
               {
                  UpdatePackage(this.mAvailablePackages[j]).setImagePath(String(resp[i].path));
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               Framework.Trace(" -no match found for: \'" + i + "\'");
               Framework.Trace("  -path \'" + resp.path + "\'");
            }
            else
            {
               this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
            }
         }
         downloadsFinished = true;
         for(j = 0; j < this.mAvailablePackages.length; j++)
         {
            if(UpdatePackage(this.mAvailablePackages[j]).imagePath == "")
            {
               downloadsFinished = false;
               break;
            }
         }
         if(downloadsFinished)
         {
            this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_DOWNLOAD_FINISHED;
            this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
         }
      }
      
      private function arePackagesSelectedForDownload() : Boolean
      {
         for(var i:int = 0; i < this.mAvailablePackages.length; i++)
         {
            if(UpdatePackage(this.mAvailablePackages[i]).selectedForDownload)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onUpdatePackageDemoTimer(e:TimerEvent) : void
      {
         Framework.Trace("OverTheAirUpdateManager.onUpdatePackageDemoTimer()");
         this.mAvailablePackages.splice(0,this.mAvailablePackages.length);
         this.mAvailablePackages.push(new UpdatePackage("<TYPE>map<*><NAME>Michigan<*><VER>2012Q4<*><DATE>12/31/12<*><URL>nng.com/updates/2012Q4/MI.iso<*><SIZE>203123<*>"));
         this.mAvailablePackages.push(new UpdatePackage("<TYPE>map<*><NAME>Illinois<*><VER>2012Q4<*><DATE>12/31/12<*><URL>nng.com/updates/2012Q4/IL.iso<*><SIZE>189321<*>"));
         this.mAvailablePackages.push(new UpdatePackage("<TYPE>full<*><NAME>North America<*><VER>2013Q1<*><DATE>01/01/13<*><URL>nng.com/updates/2012Q4/full.iso<*><SIZE>4333465<*>"));
         this.mAvailablePackages.push(new UpdatePackage("<TYPE>vehicle<*><NAME>Oscar Mayer W.M.<*><VER>1.0<*><DATE>01/01/13<*><URL>nng.com/updates/vehicles/omwm.iso<*><SIZE>423<*>"));
         this.mOTAUpdateState = OverTheAirUpdateState.OTA_STATE_PACKAGES_AVAILABLE;
         this.mParent.sendEvent(NavigationEvent.NAV_OTA_AVAILABLE_PACKAGES);
         this.mParent.sendEvent(NavigationEvent.NAV_OTA_STATE_CHANGE);
      }
   }
}

