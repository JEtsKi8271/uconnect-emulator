package com.harman.navigation.map
{
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.PickInfoDetails;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MapManager
   {
      
      private static const REQUEST_POI_VISIBILITY:String = "<IFT>MAP<*><CAT><*>";
      
      private static const REQUEST_VEHICLE_ICONS:String = "<IFT>MAP<*><MPI><*>";
      
      private static const REQUEST_MAP_THEMES:String = "<IFT>MAP<*><MST><*>";
      
      private var mNavService:Navigation;
      
      private var mLocalMapVisibility:Boolean = false;
      
      private var mLocalMapAppearanceStyle:int = 1;
      
      private var mLocalMapZoomLevel:int = 0;
      
      private var mLocalPoiVisibilities:Array = new Array();
      
      private var mLocalVehicleIcons:Array = new Array();
      
      private var mLocalPickInfo:PickInfoDetails = new PickInfoDetails();
      
      private var mLocalMapDetails:String = "";
      
      private var mLocalMapThemes:Array = new Array();
      
      private var mLocalCurrentMapTheme:String = "";
      
      private var mDisableMapTimer:Timer = null;
      
      public function MapManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.init();
      }
      
      public function sendControlCmd(mapEIS:String) : void
      {
         this.mNavService.sendCommand("\"MAP_Controls\":{\"mapEIS\":\"" + mapEIS + "\"}");
         var sdf:String = EisHelper.getValueOfType(mapEIS,"<SDF>");
         if(sdf != "" && Number(sdf) > MapSettingTypes.MAP_FRAMERATE_LOW)
         {
            this.mDisableMapTimer.stop();
            NavigationPackage.peripheral.displayManager.requestDisplay("map",true);
         }
         else if(sdf != "" && Number(sdf) <= MapSettingTypes.MAP_FRAMERATE_LOW)
         {
            this.mDisableMapTimer.start();
         }
      }
      
      public function sendWorldElementlCmd(weFunction:int, itemList:Array) : void
      {
         Framework.Trace("MapManager: sendWorldElementlCmd: \"" + weFunction + "\" " + itemList);
         var tmpStr:String = "[";
         for(var i:int = 0; i < itemList.length; i++)
         {
            if(i > 0)
            {
               tmpStr += ",";
            }
            tmpStr += "\"" + itemList[i] + "\"";
         }
         tmpStr += "]";
         this.mNavService.sendCommand("\"MAP_SetWorldElementProperties\":" + "{" + "\"mapEIS\":\"<MID>map<*>\"" + "," + "\"weFunction\":" + weFunction + "," + "\"itemList\":" + tmpStr + "}");
      }
      
      public function mapRequestMapDetails(eisArray:Array) : void
      {
         var req:String = "";
         for(var i:int = 0; i < eisArray.length; i++)
         {
            if(req.length > 0)
            {
               req += ",";
            }
            req += "\"" + String(eisArray[i]) + "\"";
         }
         if(req.length > 0)
         {
            this.mNavService.sendCommand("\"Info_GetDetails\":{\"inputEIS\":\"<IFT>MAP<*><MID>map<*>" + "\"," + "\"requestedFields\":[" + req + "]}");
         }
         else
         {
            Framework.Trace("MapManager.mapGetMapDetails() blocked sending empty request!");
         }
      }
      
      public function getMapVisible() : void
      {
         Framework.Trace("getMapVisible()");
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.MAP_VISIBILITY));
      }
      
      public function mapVisible() : Boolean
      {
         return this.mLocalMapVisibility;
      }
      
      public function getMapPoiVisibilitieslistCount(reqVis:String = null) : void
      {
      }
      
      public function setMapAppearanceStyle(style:int) : void
      {
         Framework.Trace("MapManager: setMapAppearanceStyle: " + style.toString());
         this.mNavService.sendCommand("\"MAP_Controls\":{\"mapEIS\":\"<MID>map<*><MAS>" + style.toString() + "<*>\"}");
         this.mLocalMapAppearanceStyle = style;
      }
      
      public function getMapAppearanceStyle() : void
      {
      }
      
      public function mapAppearanceStyle() : int
      {
         return this.mLocalMapAppearanceStyle;
      }
      
      public function setMapZoomLevel(level:int) : void
      {
         Framework.Trace("MapManager: setMapZoomLevel: " + level.toString());
         this.mNavService.sendCommand("\"MAP_Controls\":{\"mapEIS\":\"<MID>map<*><MZ>" + level.toString() + "<*>\"}");
         this.mLocalMapZoomLevel = level;
      }
      
      public function getMapZoomLevel() : void
      {
      }
      
      public function mapZoomLevel() : int
      {
         return this.mLocalMapZoomLevel;
      }
      
      public function getMapPoiVisibilities(reqVis:String = null) : void
      {
         if(1)
         {
            this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + REQUEST_POI_VISIBILITY + "\"" + ",\"inresultCount\":-1" + "," + "\"insortOption\":0" + ",\"instartIndex\":1" + ",\"cancelPreviousRequest\":false}");
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.MAP_POI_VISIBILITY);
         }
      }
      
      public function mapPoiVisibilities() : Array
      {
         return this.mLocalPoiVisibilities;
      }
      
      public function mapPoiVisListCount() : Array
      {
         return new Array();
      }
      
      public function mapSetPoiVisibility(id:String, visible:Boolean) : void
      {
         var tmdCat:String = "";
         for(var i:int = 0; i < this.mLocalPoiVisibilities.length; i++)
         {
            if(VisibleObject(this.mLocalPoiVisibilities[i]).id == id)
            {
               tmdCat = VisibleObject(this.mLocalPoiVisibilities[i]).name;
               break;
            }
         }
         this.mNavService.sendCommand("\"MAP_SetWorldElementProperties\":" + "{" + "\"mapEIS\":\"<MID>map<*>\"" + "," + "\"weFunction\":" + MapSettingTypes.WORLD_ELEMENT_FUNCTION_SET_ITEM_VISIBILITIES + "," + "\"itemList\":[\"<CAT>" + tmdCat + "<*>" + "<CAT_NNG>" + id + "<*><VIS>" + (visible == true ? "1" : "0") + "<*>\"]" + "}");
      }
      
      public function mapSetPoiVisibilities(idArrayString:String) : void
      {
         this.mNavService.sendCommand("\"MAP_SetWorldElementProperties\":" + "{" + "\"mapEIS\":\"<MID>map<*>\"" + "," + "\"weFunction\":" + MapSettingTypes.WORLD_ELEMENT_FUNCTION_SET_ITEM_VISIBILITIES + "," + "\"itemList\":[" + idArrayString + "]" + "}");
      }
      
      public function getMapVehicleIcons() : void
      {
         if(1)
         {
            this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + REQUEST_VEHICLE_ICONS + "\"" + ",\"inresultCount\":-1" + "," + "\"insortOption\":0" + ",\"instartIndex\":1" + ",\"cancelPreviousRequest\":false}");
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.MAP_VEHICLE_ICONS);
         }
      }
      
      public function mapVehicleIcons() : Array
      {
         return this.mLocalVehicleIcons;
      }
      
      public function getMapThemes() : void
      {
         if(1)
         {
            this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + REQUEST_MAP_THEMES + "\"" + ",\"inresultCount\":-1" + "," + "\"insortOption\":0" + ",\"instartIndex\":1" + ",\"cancelPreviousRequest\":false}");
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.MAP_THEMES);
         }
      }
      
      public function mapThemes() : Array
      {
         return this.mLocalMapThemes;
      }
      
      public function mapRequestGetPickInfo(mapEIS:String, xCoord:int, yCoord:int, worldElements:int, radius:int) : void
      {
         this.mNavService.sendCommand("\"MAP_PositionInfo\":" + "{" + "\"mapEIS\":\"<MID>" + mapEIS + "<*>\"" + "," + "\"infoParameters\":" + worldElements + "," + "\"x\":" + xCoord + "," + "\"y\":" + yCoord + "," + "\"radius\":" + radius + "}");
      }
      
      public function getPickInfo() : PickInfoDetails
      {
         return this.mLocalPickInfo;
      }
      
      public function getMapDetails() : String
      {
         return this.mLocalMapDetails;
      }
      
      public function setMapPositionInfo(response:Object) : void
      {
         var i:int = 0;
         this.mLocalPickInfo = new PickInfoDetails();
         if(response.MAP_PositionInfo.hasOwnProperty("lat"))
         {
            this.mLocalPickInfo.latitude = Number(Number(response.MAP_PositionInfo.lat).toFixed(6));
         }
         if(response.MAP_PositionInfo.hasOwnProperty("lon"))
         {
            this.mLocalPickInfo.longitude = Number(Number(response.MAP_PositionInfo.lon).toFixed(6));
         }
         if(response.MAP_PositionInfo.hasOwnProperty("posInfo"))
         {
            if(response.MAP_PositionInfo.posInfo != null)
            {
               for(i = 0; i < response.MAP_PositionInfo.posInfo.length; i++)
               {
                  if(String(response.MAP_PositionInfo.posInfo[i]).indexOf("<IFT>POI<*>") != -1)
                  {
                     this.mLocalPickInfo.addPOI(String(response.MAP_PositionInfo.posInfo[i]));
                  }
                  else if(String(response.MAP_PositionInfo.posInfo[i]).indexOf("<IFT>LI<*>") != -1)
                  {
                     this.mLocalPickInfo.setLocation(String(response.MAP_PositionInfo.posInfo[i]));
                  }
                  else if(String(response.MAP_PositionInfo.posInfo[i]).indexOf("<IFT>TMC<*>") != -1)
                  {
                     this.mLocalPickInfo.addTMC(String(response.MAP_PositionInfo.posInfo[i]));
                  }
               }
            }
         }
         this.mNavService.sendEvent(NavigationEvent.MAP_PICK_INFO_UPDATE);
      }
      
      public function setMapControlsInfo(response:Object) : void
      {
         var sdf:String = null;
         var evt:NavigationEvent = null;
         if(Boolean(response.MAP_Controls.hasOwnProperty("resultCode")) && Boolean(response.MAP_Controls.hasOwnProperty("outmapControls")))
         {
            Framework.Trace("MAP_Controls resp: " + response.MAP_Controls.outmapControls + " (" + response.MAP_Controls.resultCode + ")");
            if(response.MAP_Controls.resultCode == 1)
            {
               if(String(response.MAP_Controls.outmapControls).indexOf("<MID>map<*><MPI_NNG>") != -1)
               {
                  this.mNavService.sendEvent(NavigationEvent.MAP_VEHICLE_ICON_CHANGE);
               }
               if(String(response.MAP_Controls.outmapControls).indexOf("<MID>map<*><MST>") != -1)
               {
                  this.mNavService.sendEvent(NavigationEvent.MAP_THEMES_CHANGE);
               }
               sdf = EisHelper.getValueOfType(String(response.MAP_Controls.outmapControls),"<SDF>");
               if(sdf != "" && Number(sdf) > MapSettingTypes.MAP_FRAMERATE_LOW)
               {
                  this.mLocalMapVisibility = true;
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.MAP_VISIBILITY));
               }
               else if(Number(sdf) <= MapSettingTypes.MAP_FRAMERATE_LOW)
               {
                  this.mLocalMapVisibility = false;
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.MAP_VISIBILITY));
               }
               evt = new NavigationEvent(NavigationEvent.MAP_UPDATED_CONTROLS_CMD);
               evt.data = response.MAP_Controls.outmapControls;
               this.mNavService.dispatchEvent(evt);
            }
            else
            {
               this.mNavService.reportWarning("MapMgr.setMAP_SetCtrls (" + response.MAP_Controls.resultCode + " " + response.MAP_Controls.outmapControls + ")");
               Framework.Trace("### ERROR ### MapManager.setMapControlsInfo: " + response.MAP_Controls.resultCode + " " + response.MAP_Controls.outmapControls);
            }
         }
      }
      
      public function setMAP_SetWorldElementProperties(response:Object) : void
      {
         if(response.MAP_SetWorldElementProperties.hasOwnProperty("resultCode"))
         {
            Framework.Trace("MapManager.setMAP_SetWorldElementProperties resp: " + response.MAP_SetWorldElementProperties.resultCode + " " + response.MAP_SetWorldElementProperties.mapEIS + " " + response.MAP_SetWorldElementProperties.weFunctions + " " + response.MAP_SetWorldElementProperties.itemList[0]);
            if(response.MAP_SetWorldElementProperties.resultCode == 1)
            {
               if(response.MAP_SetWorldElementProperties.hasOwnProperty("weFunctions"))
               {
                  if(response.MAP_SetWorldElementProperties.weFunctions == MapSettingTypes.WORLD_ELEMENT_FUNCTION_SET_ITEM_VISIBILITIES)
                  {
                     this.getMapPoiVisibilities();
                     return;
                  }
                  if(int(response.MAP_SetWorldElementProperties.weFunctions) == MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE || int(response.MAP_SetWorldElementProperties.weFunctions) == (MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE | MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM))
                  {
                     if(Boolean(response.MAP_SetWorldElementProperties.hasOwnProperty("mapEIS")) && Boolean(response.MAP_SetWorldElementProperties.hasOwnProperty("itemList")))
                     {
                        if(response.MAP_SetWorldElementProperties.itemList.length > 0)
                        {
                           if(String(response.MAP_SetWorldElementProperties.itemList[0]).indexOf("<RTH>") >= 0 && String(response.MAP_SetWorldElementProperties.itemList[0]).indexOf("<RGB>") >= 0)
                           {
                              NavigationPackage.peripheral.navigation.navRouteCalculation.setRouteColorForRouteHandle(response.MAP_SetWorldElementProperties.itemList);
                           }
                        }
                     }
                  }
               }
               this.mNavService.sendEvent(NavigationEvent.MAP_UPDATED_WORLD_ELEMENT_CMD);
            }
            else
            {
               if(Boolean(response.MAP_SetWorldElementProperties.hasOwnProperty("outweFunction")) && Boolean(response.MAP_SetWorldElementProperties.hasOwnProperty("outitemList")))
               {
                  Framework.Trace("### ERROR ### MapManager.setMAP_SetWorldElementProperties:" + " rc:" + response.MAP_SetWorldElementProperties.resultCode + " wf:" + response.MAP_SetWorldElementProperties.outweFunction + " il:" + response.MAP_SetWorldElementProperties.outitemList);
                  this.mNavService.reportWarning("MapMgr.setMAP_SetWEP (" + response.MAP_SetWorldElementProperties.resultCode + ", " + response.MAP_SetWorldElementProperties.outweFunction + ", " + response.MAP_SetWorldElementProperties.outitemList + ")");
               }
               else
               {
                  this.mNavService.reportWarning("MapMgr.setMAP_SetWEP (" + response.MAP_SetWorldElementProperties.resultCode + ", " + response.MAP_SetWorldElementProperties.outweFunction + ")");
                  Framework.Trace("### ERROR ### MapManager.setMAP_SetWorldElementProperties: resultCode:" + response.MAP_SetWorldElementProperties.resultCode);
               }
               this.mNavService.sendEvent(NavigationEvent.MAP_UPDATED_WORLD_ELEMENT_CMD);
            }
         }
         else
         {
            this.mNavService.reportWarning("### ERROR ### MapManager.setMAP_SetWorldElementProperties: communication error");
            Framework.Trace("### ERROR ### MapManager.setMAP_SetWorldElementProperties: communication error");
         }
      }
      
      public function onInfo_GetAvailableInformation(resp:Object) : void
      {
      }
      
      public function onInfo_GetList(response:Object) : void
      {
         var i:int = 0;
         if(response.hasOwnProperty("Info_GetList"))
         {
            if(response.Info_GetList.hasOwnProperty("resultCode"))
            {
               if(response.Info_GetList.resultCode == 1)
               {
                  if(response.Info_GetList.hasOwnProperty("itemList"))
                  {
                     if(response.Info_GetList.hasOwnProperty("respEIS"))
                     {
                        i = 0;
                        if(response.Info_GetList.respEIS == REQUEST_POI_VISIBILITY)
                        {
                           for(this.mLocalPoiVisibilities.splice(0,this.mLocalPoiVisibilities.length); i < response.Info_GetList.itemList.length; )
                           {
                              this.mLocalPoiVisibilities.push(this.parsePoiVisibility(String(response.Info_GetList.itemList[i])));
                              i++;
                           }
                           this.mNavService.sendEvent(NavigationEvent.MAP_POI_VISIBILITY);
                        }
                        else if(response.Info_GetList.respEIS == REQUEST_VEHICLE_ICONS)
                        {
                           for(this.mLocalVehicleIcons.splice(0,this.mLocalVehicleIcons.length); i < response.Info_GetList.itemList.length; )
                           {
                              this.mLocalVehicleIcons.push(this.parseVehicleIcon(String(response.Info_GetList.itemList[i])));
                              i++;
                           }
                           this.separateMaseratiIcons();
                           this.separateRUIcons();
                           this.mNavService.sendEvent(NavigationEvent.MAP_VEHICLE_ICONS);
                        }
                        else if(response.Info_GetList.respEIS == REQUEST_MAP_THEMES)
                        {
                           for(this.mLocalMapThemes.splice(0,this.mLocalMapThemes.length); i < response.Info_GetList.itemList.length; )
                           {
                              this.mLocalMapThemes.push(this.parseMapTheme(String(response.Info_GetList.itemList[i])));
                              i++;
                           }
                           this.mNavService.sendEvent(NavigationEvent.MAP_THEMES);
                        }
                     }
                  }
               }
               else
               {
                  this.mNavService.reportWarning("MapMgr.onInfo_GetList (" + response.Info_GetList.resultCode + ", " + response.Info_GetList.respEIS + ")");
                  Framework.Trace("### ERROR ### MapManager.onInfo_GetList: " + response.Info_GetList.resultCode);
               }
            }
         }
      }
      
      public function onInfo_GetDetails(response:Object) : void
      {
         if(response.hasOwnProperty("Info_GetDetails"))
         {
            if(response.Info_GetDetails.hasOwnProperty("outputEIS"))
            {
               this.mLocalMapDetails = String(response.Info_GetDetails.outputEIS);
               Framework.Trace("MapManager.onInfo_GetDetails: \'" + this.mLocalMapDetails + "\'");
               this.mNavService.sendEvent(NavigationEvent.MAP_DETAILS);
            }
         }
      }
      
      private function parseVehicleIcon(data:String) : VisibleObject
      {
         var tmp:VisibleObject = new VisibleObject();
         var startIndex:int = data.indexOf("<MPI>");
         tmp.setName(data.substring(startIndex + 5,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<MPI_NNG>");
         tmp.setID(data.substring(startIndex + 9,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<ICON>");
         tmp.setIconPath(data.substring(startIndex + 6,data.indexOf("<*>",startIndex)));
         tmp.setVisible(false);
         return tmp;
      }
      
      private function parseMapTheme(data:String) : VisibleObject
      {
         var tmp:VisibleObject = new VisibleObject();
         var startIndex:int = data.indexOf("<MST>");
         tmp.setName(data.substring(startIndex + 5,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<MST_NNG>");
         tmp.setID(data.substring(startIndex + 9,data.indexOf("<*>",startIndex)));
         tmp.setVisible(false);
         return tmp;
      }
      
      private function parsePoiVisibility(data:String) : VisibleObject
      {
         var tmp:VisibleObject = new VisibleObject();
         var startIndex:int = data.indexOf("<CAT>");
         tmp.setName(data.substring(startIndex + 5,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<CAT_NNG>");
         tmp.setID(data.substring(startIndex + 9,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<ICON>");
         tmp.setIconPath(data.substring(startIndex + 6,data.indexOf("<*>",startIndex)));
         startIndex = data.indexOf("<VIS>");
         if(parseInt(data.substring(startIndex + 5,data.indexOf("<*>",startIndex))) == 1)
         {
            tmp.setVisible(true);
         }
         else
         {
            tmp.setVisible(false);
         }
         return tmp;
      }
      
      private function init() : void
      {
         this.mDisableMapTimer = new Timer(NavGlobalSettings.MAP_DISABLE_TIMEROUT,1);
         this.mDisableMapTimer.addEventListener(TimerEvent.TIMER,this.onDisableMapTimer,false,0,true);
      }
      
      private function onDisableMapTimer(e:TimerEvent) : void
      {
         NavigationPackage.peripheral.displayManager.requestDisplay("map",false);
      }
      
      private function separateMaseratiIcons() : void
      {
         var carName:String = null;
         var newName:String = null;
         var maseratiIcons:Array = new Array();
         for(var i:* = 0; i < this.mLocalVehicleIcons.length; i++)
         {
            carName = this.mLocalVehicleIcons[i].name;
            if(carName.substr(0,8).toLowerCase() == "maserati")
            {
               newName = carName.substr(9,carName.length - 9);
               trace(newName);
               VisibleObject(this.mLocalVehicleIcons[i]).setName(newName);
               maseratiIcons.push(this.mLocalVehicleIcons.splice(i,1)[0]);
               i--;
            }
         }
         if(NavigationPackage.peripheral.vehConfig.vehicleBrand == 11)
         {
            this.mLocalVehicleIcons = maseratiIcons;
         }
      }
      
      private function separateRUIcons() : void
      {
         var carName:String = null;
         var NonRUIcons:Array = new Array();
         for(var i:int = 0; i < this.mLocalVehicleIcons.length; i++)
         {
            carName = this.mLocalVehicleIcons[i].name;
            if(carName.substr(carName.length - "pacifica".length,carName.length - 1).toLowerCase() != "pacifica")
            {
               NonRUIcons.push(this.mLocalVehicleIcons[i]);
            }
         }
         if(NavigationPackage.peripheral.vehConfig.vehicleLine != "RU")
         {
            this.mLocalVehicleIcons = NonRUIcons;
         }
      }
   }
}

