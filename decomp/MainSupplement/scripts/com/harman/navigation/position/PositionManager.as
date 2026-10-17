package com.harman.navigation.position
{
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.HighWayModeList;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.NavGateKeeper;
   
   public class PositionManager
   {
      
      private var mNavService:Navigation;
      
      private var mPositionInformation:LocationDetails = new LocationDetails();
      
      private var mPositionInformationString:String = "";
      
      private var mCompassHeading:String = "";
      
      private var mJunctionViewCheck:Function;
      
      private var mJunctionViewAvailable:Boolean = false;
      
      private var mInIpdArea:Boolean = false;
      
      private var mHighwayModeEnabled:Boolean = false;
      
      private var mHighwayExits:HighWayModeList = new HighWayModeList(null);
      
      private var mGatekeeper:NavGateKeeper = new NavGateKeeper(VServiceGlobalSettings.HMI_DISPATCH_TIMEOUT);
      
      public function PositionManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.init();
      }
      
      private function init() : void
      {
         this.sendPosUpdateInterval(NavGlobalSettings.POS_POSITION_UPDATE_LOW);
         this.mNavService.sendSubscribe("\"POS_PositionInformation\"");
         this.mNavService.getProperty("POS_PositionInformation");
         NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onGuidanceActiveStateChange,false,0,true);
         if(NavigationPackage.peripheral.navigation.navMapControl != null)
         {
            this.enableHighwayModeUpdate(NavigationPackage.peripheral.navigation.navMapControl.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_HIGHWAY_MODE));
         }
      }
      
      public function posGetPositionInformation() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POS_POSITIONINFORMATION);
      }
      
      public function posPositionInformation() : LocationDetails
      {
         return this.mPositionInformation;
      }
      
      public function posPositionInformationString() : String
      {
         return this.mPositionInformationString;
      }
      
      public function posGetCompass() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POS_COMPASS);
      }
      
      public function posCompass() : String
      {
         return this.mCompassHeading;
      }
      
      public function posGetJunctionViewState() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POS_JUNCTION_VIEW_AVAILABLE);
      }
      
      public function get posJunctionViewState() : Boolean
      {
         return this.mJunctionViewAvailable;
      }
      
      public function posGetIPDAreaState() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POS_IPD_AREA);
      }
      
      public function get posIPDAreaState() : Boolean
      {
         return this.mInIpdArea;
      }
      
      public function enableHighwayModeUpdate(enable:Boolean) : void
      {
         this.mHighwayModeEnabled = enable;
         this.mNavService.sendCommand("\"RT_SetHighwayMode\":{\"mode\":" + (enable ? 1 : 0) + "}");
         this.setHighwayModeUpdateState(this.mHighwayModeEnabled);
         this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_MODE_ENABLED);
      }
      
      public function getHighwayModeEnabled() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_MODE_ENABLED);
      }
      
      public function get highwayModeEnabled() : Boolean
      {
         return this.mHighwayModeEnabled;
      }
      
      public function enableHighwayModeUpdateTemporary(enable:Boolean) : void
      {
         this.setHighwayModeUpdateState(enable);
      }
      
      private function setHighwayModeUpdateState(enable:Boolean) : void
      {
         if(this.mHighwayModeEnabled || enable)
         {
            this.mNavService.sendSubscribe("\"ETC_HighwayModeUpdate\"");
            this.mNavService.sendSubscribe("\"RT_NextHighwayManeuverInfo\"");
            this.mNavService.getProperty("ETC_HighwayModeUpdate");
         }
         else
         {
            this.mNavService.sendUnsubscribe("\"ETC_HighwayModeUpdate\"");
            this.mNavService.sendUnsubscribe("\"RT_NextHighwayManeuverInfo\"");
            this.mHighwayExits = new HighWayModeList(null);
            this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE);
         }
      }
      
      public function get posNextHighwayExits() : HighWayModeList
      {
         return this.mHighwayExits;
      }
      
      public function setPositionInfo(resp:Object) : void
      {
         if(resp.hasOwnProperty("posInfo"))
         {
            this.mPositionInformationString = resp.posInfo;
         }
         else
         {
            if(!resp.hasOwnProperty("POS_PositionInformation"))
            {
               return;
            }
            this.mPositionInformationString = resp.POS_PositionInformation;
         }
         this.mPositionInformation = new LocationDetails();
         this.mPositionInformation.addEisStringPosPosition(this.mPositionInformationString);
         if(this.calculateCompassHeading(int(this.mPositionInformation.getType("<DIR>"))))
         {
            this.mNavService.sendEvent(NavigationEvent.POS_COMPASS);
         }
         if(this.mJunctionViewCheck != null)
         {
            this.mJunctionViewCheck();
            this.checkIpdArea();
         }
         if(this.mGatekeeper.running == false)
         {
            this.mGatekeeper.start();
            this.mNavService.sendEvent(NavigationEvent.POS_POSITIONINFORMATION);
         }
      }
      
      public function setHighwayModeProperty(resp:Object) : void
      {
         this.updateHighwayMode(int(resp.ETC_HighwayModeUpdate));
      }
      
      public function setHighwayModeUpdate(resp:Object) : void
      {
         this.updateHighwayMode(int(resp.mode));
      }
      
      public function updateHighwayList(resp:Object) : void
      {
         if(this.mHighwayExits.itemCount == 0)
         {
            return;
         }
         this.mHighwayExits.setFacilityInfo(int(resp.distance),int(resp.time));
         this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE);
      }
      
      private function updateHighwayMode(mode:int) : void
      {
         if(mode == 1)
         {
            this.mNavService.sendCommand("\"Info_GetAvailableInformation\":{\"inputEIS\":\"<IFT>HWM<*>\"}");
         }
         else
         {
            this.mHighwayExits = new HighWayModeList(null);
            this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE);
         }
      }
      
      public function onInfo_GetList(resp:Object) : void
      {
         var i:int = 0;
         if(resp.hasOwnProperty("Info_GetList"))
         {
            if(Boolean(resp.Info_GetList.hasOwnProperty("resultCode")) && Boolean(resp.Info_GetList.hasOwnProperty("itemList")) && int(resp.Info_GetList.resultCode) == 1)
            {
               for(i = 0; i < resp.Info_GetList.itemList.length; i++)
               {
                  while(String(resp.Info_GetList.itemList[i]).indexOf("Āi") != -1 || String(resp.Info_GetList.itemList[i]).indexOf("Āj") != -1)
                  {
                     resp.Info_GetList.itemList[i] = String(resp.Info_GetList.itemList[i]).replace("Āi","");
                     resp.Info_GetList.itemList[i] = String(resp.Info_GetList.itemList[i]).replace("Āj","");
                  }
               }
               this.mHighwayExits = new HighWayModeList(resp.Info_GetList.itemList);
            }
            else
            {
               this.mHighwayExits = new HighWayModeList(null);
            }
         }
         this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE);
      }
      
      public function onInfo_GetAvailableInformation(resp:Object) : void
      {
         var i:int = 0;
         var amount:String = null;
         var requestAmount:int = 0;
         var hwmFound:Boolean = false;
         if(resp.hasOwnProperty("Info_GetAvailableInformation"))
         {
            if(resp.Info_GetAvailableInformation.hasOwnProperty("availableTypes"))
            {
               for(i = 0; i < resp.Info_GetAvailableInformation.availableTypes.length; i++)
               {
                  amount = EisHelper.getValueOfType(String(resp.Info_GetAvailableInformation.availableTypes[i]),"<EXT>");
                  requestAmount = int(amount);
                  if(requestAmount > 3)
                  {
                     requestAmount = 3;
                  }
                  if(amount != "" && requestAmount >= 1)
                  {
                     hwmFound = true;
                     this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + "<IFT>HWM<*><EXT><*>" + "\"" + ",\"inresultCount\":" + requestAmount + ",\"insortOption\":\"Default\"" + ",\"instartIndex\":1" + ",\"requestedFields\":[\"<ALL>\"]" + ",\"cancelPreviousRequest\":true}");
                  }
               }
            }
         }
         if(!hwmFound)
         {
            this.mHighwayExits = new HighWayModeList(null);
            this.mNavService.sendEvent(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE);
         }
      }
      
      private function onGuidanceActiveStateChange(e:RouteCalculationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            this.mJunctionViewCheck = this.checkJunctionViewAvailable;
         }
         else
         {
            this.mJunctionViewAvailable = false;
            this.mJunctionViewCheck = null;
         }
      }
      
      private function checkJunctionViewAvailable() : void
      {
         if(this.mPositionInformationString.indexOf("<JVA>1<*>") != -1)
         {
            if(this.mJunctionViewAvailable == false)
            {
               this.mJunctionViewAvailable = true;
               this.mNavService.sendEvent(NavigationEvent.POS_JUNCTION_VIEW_AVAILABLE);
               this.sendPosUpdateInterval(NavGlobalSettings.POS_POSITION_UPDATE_HIGH);
            }
         }
         else if(this.mJunctionViewAvailable == true)
         {
            this.mJunctionViewAvailable = false;
            this.mNavService.sendEvent(NavigationEvent.POS_JUNCTION_VIEW_AVAILABLE);
            this.sendPosUpdateInterval(NavGlobalSettings.POS_POSITION_UPDATE_LOW);
         }
      }
      
      private function checkIpdArea() : void
      {
         if(this.mPositionInformationString.indexOf("<IPD>1<*>") != -1)
         {
            if(this.mInIpdArea == false)
            {
               this.mInIpdArea = true;
               this.mNavService.sendEvent(NavigationEvent.POS_IPD_AREA);
            }
         }
         else if(this.mInIpdArea == true)
         {
            this.mInIpdArea = false;
            this.mNavService.sendEvent(NavigationEvent.POS_IPD_AREA);
         }
      }
      
      public function calculateCompassHeading(heading:int) : Boolean
      {
         if(heading < 16 || heading > 239)
         {
            this.mCompassHeading = "N";
         }
         else if(heading < 48)
         {
            this.mCompassHeading = "NW";
         }
         else if(heading < 80)
         {
            this.mCompassHeading = "W";
         }
         else if(heading < 112)
         {
            this.mCompassHeading = "SW";
         }
         else if(heading < 144)
         {
            this.mCompassHeading = "S";
         }
         else if(heading < 176)
         {
            this.mCompassHeading = "SE";
         }
         else if(heading < 208)
         {
            this.mCompassHeading = "E";
         }
         else
         {
            this.mCompassHeading = "NE";
         }
         return true;
      }
      
      private function sendPosUpdateInterval(interval:int) : void
      {
         this.mNavService.sendCommand("\"POS_PositionInformation\":{\"updateMode\":2, \"updateInterval\":" + interval + "}");
      }
      
      private function compareHighWayModeList(highwayExits1:HighWayModeList, index1:uint, highwayExits2:HighWayModeList, index2:uint) : Boolean
      {
         var id1:String = null;
         var id2:String = null;
         if(highwayExits1 == null || highwayExits2 == null)
         {
            return false;
         }
         if(highwayExits1.itemCount - index1 != highwayExits2.itemCount - index2)
         {
            return false;
         }
         for(var i:uint = index1; i < highwayExits1.itemCount; i++)
         {
            id1 = highwayExits1.getIDForListIndex(i) + highwayExits1.getGeoForListIndex(i);
            id2 = highwayExits2.getIDForListIndex(i + index2 - index1) + highwayExits2.getGeoForListIndex(i + index2 - index1);
            if(id1 != id2)
            {
               return false;
            }
         }
         return true;
      }
   }
}

