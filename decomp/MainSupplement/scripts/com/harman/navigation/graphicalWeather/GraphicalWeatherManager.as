package com.harman.navigation.graphicalWeather
{
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.Controller.MAP.utils.MapConfiguration;
   import com.harman.navigation.Controller.NDR.util.GPSInfo;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.EisHelper;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class GraphicalWeatherManager
   {
      
      private static const NAV_INTERVAL_TIME:int = 100;
      
      private var mParent:Navigation;
      
      private var mNowradTransparancy:int = 80;
      
      private var mProductVisibility:int = NavGlobalSettings.GRAPHICAL_WEATHER_PRODUCT_VISIBILITY_DEFAULT;
      
      private var mZoomLevelIndex:int = 0;
      
      private var mRenderingEnabled:Boolean = false;
      
      private var mAlertButton:Boolean = false;
      
      private var mAlertType:String = null;
      
      private var mUpdateTime:String = "--:--";
      
      private var mUpdateDate:String = "--/--/--";
      
      private var mDisplayTime:String = "--:--";
      
      private var mDisplayDate:String = "--/--/--";
      
      private var mIgnoreWeatherAlerts:Boolean = false;
      
      private var mLocalAlert:Object;
      
      private var mWatchboxes:Object = new Object();
      
      private var mWatchBoxPositionMatchID:String = "";
      
      private var mPersistInterval:uint = 0;
      
      public function GraphicalWeatherManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
         this.mPersistInterval = setInterval(this.onPersistInterval,NAV_INTERVAL_TIME);
         this.mParent.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
         this.mParent.addEventListener(NavigationEvent.SPECIAL_FEATURES,this.onCheckForWeatherAlertDisable,false,0,true);
         this.mParent.navGetIsReady();
      }
      
      private function onPersistInterval() : void
      {
         if(NavigationPackage.peripheral.navigation.navPersistence != null)
         {
            clearInterval(this.mPersistInterval);
            NavigationPackage.peripheral.navigation.navPersistence.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
            NavigationPackage.peripheral.navigation.navPersistence.loadData(PersistenceKeys.WEATHER);
         }
      }
      
      public function setRenderingEnable(enable:Boolean) : void
      {
         if(this.mRenderingEnabled != enable)
         {
            this.mRenderingEnabled = enable;
            this.setupAll();
            this.mParent.sendEvent(NavigationEvent.GW_RENDERING_ENABLED);
         }
      }
      
      public function getRenderingEnabled() : void
      {
         this.mParent.sendEvent(NavigationEvent.GW_RENDERING_ENABLED);
      }
      
      public function get renderingEnabled() : Boolean
      {
         return this.mRenderingEnabled;
      }
      
      public function setProductVisibility(vis:int) : void
      {
         this.mProductVisibility = vis;
         this.sendProductVisibility();
         this.mParent.sendEvent(NavigationEvent.GW_VISIBILITY);
         this.persistData();
      }
      
      public function getProductVisibility() : void
      {
         this.mParent.sendEvent(NavigationEvent.GW_VISIBILITY);
      }
      
      public function get productVisibility() : int
      {
         return this.mProductVisibility;
      }
      
      public function setNowradTransparancy(percent:int) : void
      {
         this.mNowradTransparancy = percent;
         this.sendProductTransparency();
         this.mParent.sendEvent(NavigationEvent.GW_NOWRAD_TRANSPARENCY);
         this.persistData();
      }
      
      public function getNowradTransparancy() : void
      {
         this.mParent.sendEvent(NavigationEvent.GW_NOWRAD_TRANSPARENCY);
      }
      
      public function get nowradTransparancy() : int
      {
         return this.mNowradTransparancy;
      }
      
      public function setZoomLevelIndex(index:int) : void
      {
         this.mZoomLevelIndex = index;
         this.sendZoomLevel();
         this.mParent.sendEvent(NavigationEvent.GW_ZOOM_LEVEL_INDEX);
         this.persistData();
      }
      
      public function getZoomLevelIndex() : void
      {
         this.mParent.sendEvent(NavigationEvent.GW_ZOOM_LEVEL_INDEX);
      }
      
      public function get zoomLevelIndex() : int
      {
         return this.mZoomLevelIndex;
      }
      
      public function getProductTimeStamp() : void
      {
         this.mParent.sendEvent(NavigationEvent.GW_PRODUCT_TIMESTAMP);
      }
      
      public function get productUpdateTime() : String
      {
         return this.mDisplayTime;
      }
      
      public function get productUpdateDate() : String
      {
         return this.mDisplayDate;
      }
      
      public function centerOnCurrentPosition() : void
      {
         this.centerOnVehicle();
      }
      
      public function get alertPopupInfo() : Object
      {
         return this.mLocalAlert;
      }
      
      public function graphicalWeatherMessageHandler(e:ConnectionEvent) : void
      {
         if(e.hasOwnProperty("data"))
         {
            if(e.data.hasOwnProperty("Info_SetProductVisibility"))
            {
               Framework.Trace("Nav.graphicalWeatherMessageHandler.Info_SetProductVisibility( " + e.data.Info_SetProductVisibility + " )");
            }
            if(e.data.hasOwnProperty("JSON_GetProperties"))
            {
               if(e.data.JSON_GetProperties.hasOwnProperty("outprop"))
               {
                  if(e.data.JSON_GetProperties.outprop.hasOwnProperty("Info_UpdateTimes"))
                  {
                     this.refreshUpdateTimes(e.data.JSON_GetProperties.outprop.Info_UpdateTimes);
                  }
                  if(e.data.JSON_GetProperties.outprop.hasOwnProperty("Info_StormWatchBoxes"))
                  {
                     Framework.Trace("GW.Info_StormWatchBoxes \'" + e.data.JSON_GetProperties.outprop.Info_StormWatchBoxes.length + "\'");
                     this.mWatchboxes = e.data.JSON_GetProperties.outprop.Info_StormWatchBoxes;
                  }
                  if(e.data.JSON_GetProperties.outprop.hasOwnProperty("Info_LocalAlert"))
                  {
                     if(!this.mIgnoreWeatherAlerts)
                     {
                        this.setShowAlertButton(e.data.JSON_GetProperties.outprop.Info_LocalAlert);
                        this.mParent.sendEvent(NavigationEvent.GW_SHOW_ALERT_BUTTON,this.mAlertButton);
                     }
                  }
               }
            }
            if(e.data.hasOwnProperty("Info_UpdateTimes"))
            {
               this.refreshUpdateTimes(e.data.Info_UpdateTimes);
            }
            if(e.data.hasOwnProperty("Info_LocalAlert"))
            {
               if(!this.mIgnoreWeatherAlerts)
               {
                  this.setShowAlertButton(e.data.Info_LocalAlert);
                  this.mParent.sendEvent(NavigationEvent.GW_SHOW_ALERT_BUTTON,this.mAlertButton);
               }
            }
         }
      }
      
      private function refreshUpdateTimes(resp:Object) : void
      {
         var i:String = null;
         var hrs:int = 0;
         var min:int = 0;
         var month:int = 0;
         var day:int = 0;
         var year:int = 0;
         var offsetMin:int = 0;
         var offsetMilliSecFrom1970:Number = NaN;
         var newDate:Date = null;
         var tzo:int = 0;
         var dso:int = 0;
         var tmpDate:String = "";
         var tmpTime:String = "";
         if(resp != null)
         {
            Framework.Trace("GW: " + tmpDate + " " + tmpTime + " " + i);
            for(i in resp)
            {
               tmpDate = String(resp[i].date);
               tmpTime = String(resp[i].time);
               Framework.Trace("GW: " + tmpDate + " " + tmpTime + " " + i);
               if(tmpTime != "--:--" && tmpDate != "--/--/----")
               {
                  hrs = int(tmpTime.substring(0,tmpTime.indexOf(":")));
                  min = int(tmpTime.substring(tmpTime.indexOf(":") + 1,tmpTime.length));
                  month = int(tmpDate.substring(0,2));
                  day = int(tmpDate.substring(3,5));
                  year = int(tmpDate.substring(6,10));
                  if(tmpTime > this.mUpdateTime || tmpDate > this.mUpdateDate)
                  {
                     this.mUpdateTime = tmpTime;
                     this.mUpdateDate = tmpDate;
                     offsetMin = NavigationPackage.peripheral.clock.timeZoneOffset + NavigationPackage.peripheral.clock.daylightOffset;
                     Framework.Trace("Timezone data TZoffset:" + NavigationPackage.peripheral.clock.timeZoneOffset + " DLoffset:" + NavigationPackage.peripheral.clock.daylightOffset + "  offsetMin:" + offsetMin);
                     if(offsetMin == 0)
                     {
                        tzo = int(EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navigation.posPositionInformationString,"<TZO>"));
                        dso = int(EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navigation.posPositionInformationString,"<DSO>"));
                        if(tzo != -1 && dso != -1)
                        {
                           offsetMin = tzo + dso;
                           Framework.Trace("TimezoneData Emergency Override: " + tzo + " " + dso + " " + offsetMin);
                        }
                     }
                     if(offsetMin < 0)
                     {
                        offsetMin *= -1;
                     }
                     offsetMilliSecFrom1970 = Date.parse(month + "/" + day + "/" + year + " " + hrs + ":" + min + " " + "UTC" + offsetMin / 60);
                     newDate = new Date(offsetMilliSecFrom1970);
                     this.mDisplayDate = String(newDate.getMonth() + 1 + "/" + newDate.getDate() + "/" + newDate.getFullYear());
                     this.mDisplayDate = this.trimDate(this.mDisplayDate);
                     hrs -= offsetMin / 60;
                     if(NavigationPackage.peripheral.clock.twelveHourTimeFormat)
                     {
                        while(hrs > 12)
                        {
                           hrs -= 12;
                        }
                        while(hrs < 1)
                        {
                           hrs += 12;
                        }
                     }
                     else
                     {
                        while(hrs > 23)
                        {
                           hrs -= 24;
                        }
                        while(hrs < 0)
                        {
                           hrs += 24;
                        }
                     }
                     if(offsetMin == 0)
                     {
                        this.mDisplayTime = "--:--";
                     }
                     else
                     {
                        this.mDisplayTime = String(hrs + ":" + (min < 10 ? "0" : "") + min);
                     }
                     Framework.Trace("Nav.GWMgr mUpdateDate & mUpdateTime:" + this.mUpdateDate + " " + this.mUpdateTime + " Display" + this.mDisplayDate + " " + this.mDisplayTime);
                     this.mParent.sendEvent(NavigationEvent.GW_PRODUCT_TIMESTAMP);
                  }
               }
            }
         }
      }
      
      public function setShowAlertButton(e:Object) : void
      {
         if(e.type)
         {
            this.mAlertButton = true;
         }
         else
         {
            this.mAlertButton = false;
         }
         if(e.type)
         {
            if(e.type != this.mAlertType)
            {
               this.mLocalAlert = e;
               this.mParent.sendEvent(NavigationEvent.GW_ALERT_POPUP);
               this.mAlertType = e.type;
            }
         }
         else if(this.mAlertType != null)
         {
            this.mAlertType = null;
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.TL_WEATHER_ALERT);
         }
      }
      
      public function get showAlertButton() : Boolean
      {
         return this.mAlertButton;
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         if(this.mParent.navIsReady)
         {
            this.mParent.removeEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady);
            this.mParent.sendSubscribeGW("Info_LocalAlert");
         }
      }
      
      private function onCheckForWeatherAlertDisable(e:NavigationEvent) : void
      {
         this.mIgnoreWeatherAlerts = this.mParent.getNavSpecialFeatureActive("NAV_WEATHER_ALERTS_DISABLE");
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         if(NavigationPackage.peripheral.navigation.navPersistence.dataLoaded == PersistenceKeys.WEATHER)
         {
            res = NavigationPackage.peripheral.navigation.navPersistence.getDataLoaded(PersistenceKeys.WEATHER,true);
            if(res != null)
            {
               for(i in res)
               {
                  if(i == "trans")
                  {
                     this.mNowradTransparancy = res[i];
                  }
                  if(i == "vis")
                  {
                     this.mProductVisibility = res[i];
                  }
                  if(i == "zoom")
                  {
                     this.mZoomLevelIndex = res[i];
                  }
               }
               Framework.Trace("Nav_GW:" + this.mNowradTransparancy + " " + this.mProductVisibility + " " + this.mZoomLevelIndex);
               this.checkVisibilityInconsistencies();
            }
         }
      }
      
      private function persistData() : void
      {
         var obj:Object = new Object();
         obj["trans"] = this.mNowradTransparancy;
         obj["vis"] = this.mProductVisibility;
         obj["zoom"] = this.mZoomLevelIndex;
         NavigationPackage.peripheral.navigation.navPersistence.saveData(PersistenceKeys.WEATHER,obj);
      }
      
      private function checkVisibilityInconsistencies() : void
      {
         if((this.mProductVisibility & GraphicalWeatherTypes.STORM_POSITIONS) == GraphicalWeatherTypes.STORM_POSITIONS != ((this.mProductVisibility & GraphicalWeatherTypes.STORM_WATCHBOXES) == GraphicalWeatherTypes.STORM_WATCHBOXES))
         {
            Framework.Trace("GraphicalWeatherManager.checkVisibilityInconsistencies()  MISMATCH!");
            this.mProductVisibility ^= GraphicalWeatherTypes.STORM_WATCHBOXES;
         }
      }
      
      private function setupAll() : void
      {
         this.sendEnable();
         this.subscribeSignals();
         if(this.mRenderingEnabled == true)
         {
            this.sendZoomLevel();
            switch(this.mZoomLevelIndex)
            {
               case 0:
                  this.centerOnUS();
                  break;
               default:
                  this.centerOnVehicle();
            }
            this.sendProductVisibility();
            this.sendProductTransparency();
            this.mParent.getPropertyNavGW("Info_UpdateTimes");
            this.mParent.getPropertyNavGW("Info_StormWatchBoxes");
            this.mParent.getPropertyNavGW("Info_LocalAlert");
         }
      }
      
      private function sendProductVisibility() : void
      {
         this.mParent.sendCommandNavGW("\"Info_SetProductVisibility\":{\"visibility\":" + this.mProductVisibility + "}");
      }
      
      private function sendProductTransparency() : void
      {
         this.mParent.sendCommandNavGW("\"Info_SetTransparency\":{\"transparency\":" + this.mNowradTransparancy + "}");
      }
      
      private function sendEnable() : void
      {
         this.mParent.sendCommandNavGW("\"Info_SetVisible\":{\"visible\":" + (this.mRenderingEnabled == true ? "true" : "false") + "}");
      }
      
      private function subscribeSignals() : void
      {
         if(this.mRenderingEnabled)
         {
            this.mParent.sendSubscribeGW("Info_UpdateTimes");
         }
         else
         {
            this.mParent.sendUnsubscribeGW("Info_UpdateTimes");
         }
      }
      
      private function sendZoomLevel() : void
      {
         switch(this.mZoomLevelIndex)
         {
            case 0:
               NavigationPackage.peripheral.navigation.navMapControl.setZoomLevelForMapConfiguration(MapConfiguration.MAP_GRAPHICAL_WEATHER,MapZoomLevels.LEVEL_21);
               break;
            case 1:
               NavigationPackage.peripheral.navigation.navMapControl.setZoomLevelForMapConfiguration(MapConfiguration.MAP_GRAPHICAL_WEATHER,MapZoomLevels.LEVEL_19);
               break;
            case 2:
               NavigationPackage.peripheral.navigation.navMapControl.setZoomLevelForMapConfiguration(MapConfiguration.MAP_GRAPHICAL_WEATHER,MapZoomLevels.LEVEL_18);
               break;
            case 3:
               NavigationPackage.peripheral.navigation.navMapControl.setZoomLevelForMapConfiguration(MapConfiguration.MAP_GRAPHICAL_WEATHER,MapZoomLevels.LEVEL_17);
               break;
            default:
               Framework.Trace("Nav.GWManager.sendZoomLevel unsupported ZoomLevel( " + this.mZoomLevelIndex + " )");
         }
      }
      
      private function centerOnVehicle() : void
      {
         var data:GPSInfo = null;
         if(this.mParent.posPositionInformation.getType("<GEO>") != "")
         {
            NavigationPackage.peripheral.navigation.navMapControl.setPosition(this.mParent.posPositionInformation.getType("<GEO>"),MapConfiguration.MAP_GRAPHICAL_WEATHER);
         }
         else
         {
            data = NavigationPackage.peripheral.navigation.navNDR.GpsInfo;
            NavigationPackage.peripheral.navigation.navMapControl.setPosition(String(data.mLongitude / 1000000) + " " + String(data.mLatitude / 1000000),MapConfiguration.MAP_GRAPHICAL_WEATHER);
         }
      }
      
      private function centerOnUS() : void
      {
         NavigationPackage.peripheral.navigation.navMapControl.setPosition(NavGlobalSettings.GRAPHICAL_WEATHER_US_CENTER_COORDINATE,MapConfiguration.MAP_GRAPHICAL_WEATHER);
      }
      
      private function trimDate(date:String) : String
      {
         var tmp:String = date.substring(date.lastIndexOf("/"),date.length);
         tmp.replace(" ","");
         if(tmp.length > 2)
         {
            tmp = tmp.substr(tmp.length - 2,tmp.length);
            date = date.substr(0,date.lastIndexOf("/") + 1) + tmp;
         }
         return date;
      }
      
      public function factoryReset() : void
      {
         Framework.Trace("GraphicalWeatherController.factoryReset()");
         this.mNowradTransparancy = NavGlobalSettings.GRAPHICAL_WEATHER_TRANSPARENCY_DEFAULT;
         this.mProductVisibility = NavGlobalSettings.GRAPHICAL_WEATHER_PRODUCT_VISIBILITY_DEFAULT;
         this.persistData();
      }
   }
}

