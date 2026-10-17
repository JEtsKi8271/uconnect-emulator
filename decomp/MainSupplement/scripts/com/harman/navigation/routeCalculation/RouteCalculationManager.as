package com.harman.navigation.routeCalculation
{
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.enums.SortOption;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.utils.EisHelper;
   import com.nfuzion.framework.global.Framework;
   
   public class RouteCalculationManager
   {
      
      private static const REQUEST_LIST_OPTIONS_STD_ALL:String = "\"inresultCount\":-1,\"insortOption\":\"Default\",\"instartIndex\":1,\"cancelPreviousRequest\":false";
      
      private var mNavService:Navigation;
      
      private var mListInterchangeCurrent:Array = new Array();
      
      private var mListInterchangeAlternatives:Array = new Array();
      
      private var mListInterchangeDirections:Array = new Array();
      
      public function RouteCalculationManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.mNavService.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState,false,0,true);
         this.mNavService.navGetStartupState();
      }
      
      private function onNavStartupState(evt:NavigationEvent) : void
      {
         if(this.mNavService.navStartupState >= StartupState.INIT)
         {
            this.mNavService.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState);
            this.init();
         }
      }
      
      public function createNewTrip(trip:TripRoute) : void
      {
         Framework.Trace("RouteCalculationManager.createNewTrip( " + trip.Destinations.length + " destination(s), " + trip.RouteModes.length + " alternative(s) )");
         this.mNavService.sendCommand("\"RT_NewTrip\":" + trip.toEisString());
      }
      
      public function createNewTrail(trail:String, mode:int) : void
      {
         Framework.Trace("RouteCalculationManager.createNewTrail( " + trail + ", " + mode + " )");
         this.mNavService.sendCommand("\"RT_NewTripFile\":{\"pathEIS\":\"<PATH>" + this.mNavService.performDoubleQuoteCheck(trail) + "<*>\",\"routeOptions\":[" + mode + "]}");
      }
      
      public function startGuidanceForRouteHandle(routeHandle:int) : void
      {
         Framework.Trace("RouteCalculationManager.startGuidanceForRouteHandle( " + routeHandle + " )");
         this.mNavService.sendCommand("\"RT_StartGuidance\":{\"routeHandle\":" + routeHandle + "}");
      }
      
      public function requestTurnListForRouteHandle(routeHandle:int) : void
      {
         Framework.Trace("RouteCalculationManager.requestTurnListForRouteHandle( " + routeHandle + " )");
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"<IFT>RT<*>" + "<RTH>" + routeHandle + "<*>" + "<RTE><*><RSG><*>" + "\"," + REQUEST_LIST_OPTIONS_STD_ALL + "}");
      }
      
      public function requestRouteElementsInfo(routeHandle:int) : void
      {
         Framework.Trace("RouteCalculationManager.requestRouteOptions( " + routeHandle + " )");
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"<IFT>RT<*>" + "<RTH>" + routeHandle + "<*>" + "<RTE><*>" + "\"," + REQUEST_LIST_OPTIONS_STD_ALL + "}");
      }
      
      public function requestRouteOptionsForRouteHandle(routeHandle:int) : void
      {
         Framework.Trace("RouteCalculationManager.requestAvoidanceTypes( " + routeHandle + " )");
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"<IFT>RT<*>" + "<RTH>" + routeHandle + "<*>" + "<RTO><*>" + "\"," + REQUEST_LIST_OPTIONS_STD_ALL + "}");
      }
      
      public function stopGuidance() : void
      {
         Framework.Trace("RouteCalculationManager.rgStopGuidance()");
         this.mNavService.sendCommand("\"RT_StopGuidance\":{}");
      }
      
      public function destroyRoutesForRouteHandles(routeHandles:String) : void
      {
         Framework.Trace("RouteCalculationManager.destroyRouteForRouteHandle( " + routeHandles + " )");
         this.mNavService.sendCommand("\"RT_DestroyTrip\":{\"handles\":[" + routeHandles + "]}");
      }
      
      public function blockRouteSegment(routeHandle:int, routeElement:int, routeSegment:int) : void
      {
         this.mNavService.sendCommand("\"RT_BlockRoute\":{\"operation\":0" + "," + "\"items\":[" + "\"<IFT>RT<*>" + "<RTH>" + routeHandle + "<*>" + "<RTE>" + routeElement + "<*>" + "<RSG>" + routeSegment + "<*>\"" + "]}");
      }
      
      public function rgBlockRouteAhead(routeHandle:int, distance:int) : void
      {
         Framework.Trace("RouteCalculationManager.rgBlockRouteAhead( " + routeHandle + " " + distance + " )");
         this.mNavService.sendCommand("\"RT_BlockRoute\":{\"operation\":0" + "," + "\"items\":[" + "\"<IFT>RT<*>" + "<RTH>" + routeHandle + "<*>" + "<RRD>" + distance + "<*>\"" + "]}");
      }
      
      public function rgChangeTrip(routeHandle:int, elementList:Array) : void
      {
         Framework.Trace("RouteCalculationManager.rgChangeTrip( " + routeHandle + ", " + elementList.length + " )");
         var tmp:String = new String();
         for(var i:int = 0; i < elementList.length; i++)
         {
            if(tmp.length > 0)
            {
               tmp += ",";
            }
            tmp += "{\"hard\":\"" + String(elementList[i]) + "\"}";
         }
         this.mNavService.sendCommand("\"RT_RequestChangeTrip\":{\"routeHandle\":" + routeHandle + ",\"destinations\":[" + tmp + "]," + "\"routeMode\":" + RouteMode.USE_ALTERNATIVE_IC + "}");
      }
      
      public function rtGetInterchangeList(request:String) : void
      {
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + this.mNavService.performDoubleQuoteCheck(request) + "\"" + ",\"inresultCount\":" + -1 + ",\"insortOption\":" + SortOption.DEFAULT + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}");
      }
      
      public function getInterchangeCurrent() : Array
      {
         return this.mListInterchangeCurrent;
      }
      
      public function getInterchangeAlternatives() : Array
      {
         return this.mListInterchangeAlternatives;
      }
      
      public function getInterchangeDirections() : Array
      {
         return this.mListInterchangeDirections;
      }
      
      public function onRT_NewTrip(resp:Object) : void
      {
         var handles:String = "";
         for(var i:int = 0; i < (resp.RT_NewTrip.handles as Array).length; i++)
         {
            handles += (resp.RT_NewTrip.handles as Array)[i] + " ";
         }
         Framework.Trace("RouteCalculationManager.onRT_NewTrip:\n" + " -handles:    " + handles + "\n" + " -resultCode: " + resp.RT_NewTrip.resultCode);
         if(resp.RT_NewTrip.resultCode == 1)
         {
            this.mNavService.sendEvent(NavigationEvent.RT_NEW_TRIP,resp.RT_NewTrip);
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.RT_NEW_TRIP_FAIL);
         }
      }
      
      public function onRT_NewTripFile(resp:Object) : void
      {
         var handles:String = "";
         for(var i:int = 0; i < (resp.RT_NewTripFile.handles as Array).length; i++)
         {
            handles += (resp.RT_NewTripFile.handles as Array)[i] + " ";
         }
         Framework.Trace("RouteCalculationManager.onRT_NewTripFile:" + "\n" + " -handles:    " + handles + "\n" + " -pathEIS:    " + resp.RT_NewTripFile.pathEIS + "\n" + " -resultCode: " + resp.RT_NewTripFile.resultCode);
         if(resp.RT_NewTripFile.resultCode == 1)
         {
            this.mNavService.sendEvent(NavigationEvent.RT_NEW_TRIP_FILE,resp.RT_NewTripFile);
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.RT_NEW_TRIP_FILE_FAIL);
         }
      }
      
      public function onRT_StartGuidance(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_StartGuidance:" + "\n" + " -handle: " + resp.RT_StartGuidance.routeHandle);
         this.mNavService.sendEvent(NavigationEvent.RT_START_GUIDANCE,resp.RT_StartGuidance);
      }
      
      public function onRT_BlockRoute(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_BlockRoute:\n" + " resultCode::" + resp.RT_BlockRoute.resultCode);
         this.mNavService.sendEvent(NavigationEvent.RT_BLOCK_ROUTE,resp.RT_BlockRoute.resultCode);
      }
      
      public function onRT_DestroyTrip(resp:Object) : void
      {
         var handles:String = "";
         for(var i:int = 0; i < (resp.RT_DestroyTrip.handles as Array).length; i++)
         {
            handles += (resp.RT_DestroyTrip.handles as Array)[i] + " ";
         }
         Framework.Trace("RouteCalculationManager.onRT_DestroyTrip:\n" + " -handles: " + handles);
         this.mNavService.sendEvent(NavigationEvent.RT_DESTROY_TRIP,resp.RT_DestroyTrip);
      }
      
      public function onRT_CalculationState(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_CalculationState:\n" + " -calcPercent: " + resp.RT_CalculationState.calcPercent + "\n" + " -calcState:   " + resp.RT_CalculationState.calcState + "\n" + " -handle:      " + resp.RT_CalculationState.routeHandle);
         this.mNavService.sendEvent(NavigationEvent.RT_CALCULATION_STATE,resp.RT_CalculationState);
      }
      
      public function onRT_ActiveRouteDescription(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_ActiveRouteDescription:\n" + " -handle:  " + resp.RT_ActiveRouteDescription.handle + "\n" + " -element: " + resp.RT_ActiveRouteDescription.element + "\n" + " -segment: " + resp.RT_ActiveRouteDescription.segment);
         this.mNavService.sendEvent(NavigationEvent.RT_ACTIVE_ROUTE_DESCRIPTION,resp.RT_ActiveRouteDescription);
      }
      
      public function onRT_NextManeuverInfo(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_NextManeuverInfo:\n" + " -bargraph:     " + resp.RT_NextManeuverInfo.bargraph + "\n" + " -direction:    " + resp.RT_NextManeuverInfo.direction + "\n" + " -distance:     " + resp.RT_NextManeuverInfo.distance + "\n" + " -showManeuver: " + resp.RT_NextManeuverInfo.showManeuver + "\n" + " -time:         " + resp.RT_NextManeuverInfo.time);
         this.mNavService.sendEvent(NavigationEvent.RT_NEXT_MANEUVER_INFO,resp.RT_NextManeuverInfo);
      }
      
      public function onRT_NextDestinationInfo(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_NextDestinationInfo:\n" + " -distance: " + resp.RT_NextDestinationInfo.distance + "\n" + " -time:     " + resp.RT_NextDestinationInfo.time);
         this.mNavService.sendEvent(NavigationEvent.RT_NEXT_DESTINATION_INFO,resp.RT_NextDestinationInfo);
      }
      
      public function onRT_DestinationReached(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_DestinationReached:\n" + " -destEIS: " + resp.RT_DestinationReached.destEIS + "\n" + " -destCount: " + resp.RT_DestinationReached.destCount + "\n" + " -destElement: " + resp.RT_DestinationReached.destElement);
         this.mNavService.sendEvent(NavigationEvent.RT_DESTINATION_REACHED,resp.RT_DestinationReached);
      }
      
      public function onInfo_GetList(resp:Object) : void
      {
         var rth:String = null;
         var rte:String = null;
         var rsg:String = null;
         Framework.Trace("RouteCalculationManager.onInfo_GetList:");
         var i:int = 0;
         if(resp.Info_GetList.resultCode == 1)
         {
            rth = EisHelper.getValueOfType(resp.Info_GetList.respEIS,"<RTH>");
            rte = EisHelper.getValueOfType(resp.Info_GetList.respEIS,"<RTE>");
            rsg = EisHelper.getValueOfType(resp.Info_GetList.respEIS,"<RSG>");
            if(resp.Info_GetList.respEIS.indexOf("<IC><*>") != -1)
            {
               this.mListInterchangeCurrent.splice(0,this.mListInterchangeCurrent.length);
               for(i = 0; i < resp.Info_GetList.itemList.length; i++)
               {
                  this.mListInterchangeCurrent.push(String(resp.Info_GetList.itemList[i]));
               }
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_CURRENT);
               return;
            }
            if(resp.Info_GetList.respEIS.indexOf("<ICT><*>") != -1)
            {
               this.mListInterchangeAlternatives.splice(0,this.mListInterchangeAlternatives.length);
               for(i = 0; i < resp.Info_GetList.itemList.length; i++)
               {
                  this.mListInterchangeAlternatives.push(String(resp.Info_GetList.itemList[i]));
               }
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_ALTERNATIVES);
               return;
            }
            if(resp.Info_GetList.respEIS.indexOf("<ICD><*>") != -1)
            {
               this.mListInterchangeDirections.splice(0,this.mListInterchangeAlternatives.length);
               for(i = 0; i < resp.Info_GetList.itemList.length; i++)
               {
                  this.mListInterchangeDirections.push(String(resp.Info_GetList.itemList[i]));
               }
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_DIRECTIONS);
               return;
            }
            if(String(resp.Info_GetList.respEIS).indexOf("<RTE>") != -1)
            {
               if(String(resp.Info_GetList.respEIS).indexOf("<RSG>") != -1)
               {
                  this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_TURN_LIST,resp.Info_GetList);
               }
               else
               {
                  this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_ROUTE_ELEMENT,resp.Info_GetList);
               }
               if(String(resp.Info_GetList.itemList[0]).indexOf("<BCC>") != -1)
               {
                  if(int(EisHelper.getValueOfType(String(resp.Info_GetList.itemList[0]),"<BCC>")) > 1)
                  {
                     this.mNavService.sendEvent(NavigationEvent.RT_BORDER_CROSS_COUNT,resp.Info_GetList);
                  }
               }
            }
            else if(String(resp.Info_GetList.respEIS).indexOf("<RTO>") != -1)
            {
               this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_AVOIDANCE_TYPES,resp.Info_GetList);
            }
         }
         else
         {
            Framework.Trace(" -ERROR resultCode(" + resp.Info_GetList.respEIS + ", " + resp.Info_GetList.resultCode + ")");
            if(resp.Info_GetList.respEIS.indexOf("<IC><*>") != -1)
            {
               this.mListInterchangeCurrent = new Array();
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_CUR_FAILED);
               return;
            }
            if(resp.Info_GetList.respEIS.indexOf("<ICT><*>") != -1)
            {
               this.mListInterchangeAlternatives = new Array();
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_ALT_FAILED);
               return;
            }
            if(resp.Info_GetList.respEIS.indexOf("<ICD><*>") != -1)
            {
               this.mListInterchangeDirections = new Array();
               this.mNavService.sendEvent(NavigationEvent.RT_INTERCHANGE_DIR_FAILED);
               return;
            }
            if(String(resp.Info_GetList.respEIS).indexOf("<RTE>") != -1)
            {
               if(String(resp.Info_GetList.respEIS).indexOf("<RSG>") != -1)
               {
                  this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_TURN_LIST,null);
               }
               else
               {
                  this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_ROUTE_ELEMENT,null);
               }
            }
            else if(String(resp.Info_GetList.respEIS).indexOf("<RTO>") != -1)
            {
               this.mNavService.sendEvent(NavigationEvent.RT_UPDATE_AVOIDANCE_TYPES,null);
            }
         }
      }
      
      public function onInfo_GetSpell(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onInfo_GetSpell:");
      }
      
      public function onInfo_GetAvailableInformation(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onInfo_GetAvailableInformation:");
      }
      
      public function onInfo_GetDetails(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onInfo_GetDetails:");
      }
      
      public function onRT_RequestChangeTrip(resp:Object) : void
      {
         Framework.Trace("RouteCalculationManager.onRT_RequestChangeTrip:\n" + " -changed: " + Boolean(resp.RT_RequestChangeTrip.changed) + "\n" + " -pathEIS: " + int(resp.RT_RequestChangeTrip.pathEIS) + "\n" + " -routeMode: " + int(resp.RT_RequestChangeTrip.routeMode));
         this.mNavService.sendEvent(NavigationEvent.RT_CHANGE_TRIP_RESPONSE,resp.RT_RequestChangeTrip);
      }
      
      private function init() : void
      {
         this.mNavService.sendSubscribe("\"RT_CalculationState\"");
         this.mNavService.sendSubscribe("\"RT_ActiveRouteDescription\"");
         this.mNavService.sendSubscribe("\"RT_NextManeuverInfo\"");
         this.mNavService.sendSubscribe("\"RT_NextDestinationInfo\"");
         this.mNavService.sendSubscribe("\"RT_DestinationReached\"");
      }
   }
}

