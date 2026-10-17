package com.harman.navigation.tmc
{
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.enums.SortOption;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.EisHelper;
   import com.nfuzion.framework.global.Framework;
   
   public class TmcManager
   {
      
      private static const REQUEST_TYPE_GROUP:String = "<IFT>TMC<*><RQT>group<*><GRP><*>";
      
      private static const REQUEST_TYPE_STATIONS:String = "<IFT>TMC<*><RQT>stations<*><TSN><*>";
      
      private static const REQUEST_TYPE_DELAY_ON_ROUTE:String = "<IFT>TMC<*><RQT>event<*><TET>tmcOnRoute<*>";
      
      private static const GROUP_TYPES_DEFAULT:Boolean = true;
      
      private var mNavService:Navigation;
      
      private var mLocalInfoType:int = 0;
      
      private var mLocalEventList:TmcEventList;
      
      private var mLastDeletedEventIDs:Array = new Array();
      
      private var mTrafficGroupTypes:Object = new Object();
      
      private var tmcEventDetails:Object;
      
      private var mManualRouteAlternatives:Object;
      
      private var tmcAvoidMode:int = 0;
      
      private var tmcAvoidModeItems:Object = new Object();
      
      private var mTMCRouteMode:int = 2;
      
      private var mTMCDelayTime:int = 5;
      
      private var mTuningMode:int = 1;
      
      private var mTuningStation:String = "";
      
      private var mTuningStationsList:Array = new Array();
      
      private var mDelayTimeRequestedRouteHandles:Array = new Array();
      
      private var mRouteHandleDelayTimes:Object = new Object();
      
      public function TmcManager(naviService:Navigation)
      {
         super();
         this.mLocalEventList = new TmcEventList();
         this.mNavService = naviService;
         this.mNavService.sendSubscribe("\"TMC_RoutesAvailable\"");
         this.mNavService.sendSubscribe("\"TMC_RoutesDeleted\"");
         this.mNavService.sendSubscribe("\"TMC_RouteAccepted\"");
         this.mNavService.sendSubscribe("\"TMC_TuningMode\"");
         this.mNavService.getProperty("TMC_TuningMode");
         this.getTMCGroupTypes();
         if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_EUROPE || VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_ROW)
         {
            PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
            PersistenceApi.api.loadData(PersistenceKeys.TMC_TUNING);
         }
      }
      
      public function tmcGetEventsList(infoType:int) : void
      {
         if(this.mLocalInfoType != infoType)
         {
            this.mLocalInfoType = infoType;
            if(infoType == TmcTypes.INFO_TYPE_DISABLE)
            {
               this.mNavService.sendUnsubscribe("\"TMC_EventsNew\"");
               this.mNavService.sendUnsubscribe("\"TMC_EventsDeleted\"");
               this.mNavService.sendCommand("\"TMC_SetTMCInfoNotification\":{" + "\"tmcInfo\":" + TmcTypes.INFO_TYPE_DISABLE + "," + "\"updateMode\":" + TmcTypes.UPDATE_MODE_DISABLE + "}");
               this.mLocalEventList.setInfoType(TmcTypes.INFO_TYPE_DISABLE);
            }
            else
            {
               this.mNavService.sendSubscribe("\"TMC_EventsNew\"");
               this.mNavService.sendSubscribe("\"TMC_EventsDeleted\"");
               this.mNavService.sendCommand("\"TMC_SetTMCInfoNotification\":{" + "\"tmcInfo\":" + infoType + "," + "\"updateMode\":" + TmcTypes.UPDATE_MODE_ON_CHANGE + "}");
            }
         }
         else
         {
            this.mNavService.sendEvent(NavigationEvent.TMC_EVENT_LIST);
         }
      }
      
      public function getTmcEventsList() : TmcEventList
      {
         return this.mLocalEventList;
      }
      
      public function getTmcEventDetails(eventID:String) : void
      {
         this.mNavService.sendCommand("\"Info_GetDetails\":{\"inputEIS\":" + "\"<IFT>TMC<*>" + "<RQT>event<*>" + "<TEV>" + eventID + "<*>" + "\"," + "\"requestedFields\":[\"<ALL>\"]" + "}");
      }
      
      public function get tmdEventDetails() : Object
      {
         return this.tmcEventDetails;
      }
      
      public function getTmcLastDeletedEventIDs() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TMC_EVENTS_DELETED);
      }
      
      public function get tmcLastDeletedEventIDs() : Array
      {
         return this.mLastDeletedEventIDs;
      }
      
      public function tmcAvoidTmcEventByEventID(tev:int) : void
      {
         Framework.Trace("TmcManager.tmcAvoidTmcEventByEventID( " + tev + " )");
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == false)
         {
            Framework.Trace(" Can\'t avoid -> no active Guidance!");
            return;
         }
         for(var i:int = 0; i < this.mLocalEventList.length; i++)
         {
            if(TmcEvent(this.mLocalEventList.getEvent(i)).getType("<TEV>") == String(tev))
            {
               if((int(TmcEvent(this.mLocalEventList.getEvent(i)).getType("<INF>")) & TmcTypes.INFO_TYPE_ON_ROUTE) == true)
               {
                  this.avoidEvent(TmcEvent(this.mLocalEventList.getEvent(i)));
                  return;
               }
               Framework.Trace(" Can\'t avoid -> Event not on Route!");
               return;
            }
         }
         Framework.Trace(" Can\'t avoid -> Event not found!");
      }
      
      public function getTMCRouteMode() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TMC_ROUTE_MODE);
      }
      
      public function get TMCRouteMode() : int
      {
         return this.mTMCRouteMode;
      }
      
      public function setTMCRouteMode(tmcRouteMode:int, transmitToNav:Boolean = true, saveToPersistence:Boolean = true) : void
      {
         Framework.Trace("Nav.TmcManager.setTMCRouteMode( " + tmcRouteMode + " )");
         this.mTMCRouteMode = tmcRouteMode;
         if(transmitToNav)
         {
            this.sendRouteMode();
            this.mNavService.sendEvent(NavigationEvent.TMC_ROUTE_MODE);
         }
         if(saveToPersistence)
         {
            this.mNavService.savePersistence();
         }
      }
      
      public function getTMCDelayTime() : void
      {
         this.mNavService.sendEvent(NavigationEvent.TMC_DELAY_TIME);
      }
      
      public function get TMCDelayTime() : int
      {
         return this.mTMCDelayTime;
      }
      
      public function setTMCDelayTime(tmcDelayTime:int, saveToPersistence:Boolean = true) : void
      {
         Framework.Trace("Nav.TmcManager.setTMCDelayTime( " + tmcDelayTime + " )");
         this.mTMCDelayTime = tmcDelayTime;
         this.sendRouteMode();
         this.mNavService.sendEvent(NavigationEvent.TMC_DELAY_TIME);
         if(saveToPersistence)
         {
            this.mNavService.savePersistence();
         }
      }
      
      public function getTmcStationsList() : void
      {
         this.requestTmcStations();
      }
      
      public function get tmcStationsList() : Array
      {
         return this.mTuningStationsList;
      }
      
      public function setTmcTuningMode(mode:int) : void
      {
         this.mTuningMode = mode;
         this.sendTuningMode();
      }
      
      public function get tmcTuningMode() : int
      {
         return this.mTuningMode;
      }
      
      public function getTmcTuningStation() : void
      {
         this.mNavService.getProperty("TMC_TuningMode");
      }
      
      public function setTmcTuningStation(station:String) : void
      {
         this.mTuningStation = station;
         this.mTuningMode = TmcTypes.TUNING_MODE_MANUAL;
         this.sendTuningMode();
      }
      
      public function get tmcTuningStation() : String
      {
         return this.mTuningStation;
      }
      
      public function tmcQuerDelayTimeForRouteHandles(enable:Boolean) : void
      {
         if(enable)
         {
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE,this.onRouteCalculationStateUpdate,false,0,true);
         }
         else
         {
            this.mRouteHandleDelayTimes = new Object();
            this.mDelayTimeRequestedRouteHandles.splice(0,this.mDelayTimeRequestedRouteHandles.length);
            NavigationPackage.peripheral.navigation.navRouteCalculation.removeEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE,this.onRouteCalculationStateUpdate);
         }
      }
      
      public function delayTimesByRouteHandle() : Object
      {
         return this.mRouteHandleDelayTimes;
      }
      
      private function onRouteCalculationStateUpdate(e:RouteCalculationEvent) : void
      {
         var routes:Array = NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip.routes;
         var i:int = 0;
         while(i < routes.length && i < 3)
         {
            if(Route(routes[i]).calculationState == RouteCalculationState.Calculated)
            {
               if(this.mDelayTimeRequestedRouteHandles.indexOf(Route(routes[i]).routeHandle) == -1)
               {
                  this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":" + "\"" + REQUEST_TYPE_DELAY_ON_ROUTE + "<RTH>" + Route(routes[i]).routeHandle + "<*><TMC><*>\"" + ",\"inresultCount\":" + 99 + ",\"insortOption\":" + SortOption.NEAR_FIRST + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}");
                  this.mDelayTimeRequestedRouteHandles.push(Route(routes[i]).routeHandle);
               }
            }
            i++;
         }
      }
      
      public function onTmcEventsUpdate(resp:Object) : void
      {
         Framework.Trace("TmcManager.onTmcEventsUpdate()");
         this.getTmcEventListUpdate();
      }
      
      public function onSetTMCInfoNotification(resp:Object) : void
      {
         if(resp.TMC_SetTMCInfoNotification.tmcInfo != TmcTypes.INFO_TYPE_DISABLE)
         {
            this.getTmcEventListUpdate();
         }
      }
      
      public function onSetTMCRouteMode(resp:Object) : void
      {
         if(resp.TMC_SetTMCRouteMode.tmcRouteMode != this.mTMCRouteMode)
         {
            Framework.Trace("Nav.TmcManager.onSetTMCRouteMode() routeMode differs: " + this.mTMCRouteMode + " : " + resp.TMC_SetTMCRouteMode.tmcRouteMode);
         }
         if(resp.TMC_SetTMCRouteMode.minutes != this.mTMCDelayTime)
         {
            Framework.Trace("Nav.TmcManager.onSetTMCRouteMode() delayTime differs: " + this.mTMCDelayTime + " : " + resp.TMC_SetTMCRouteMode.minutes);
         }
      }
      
      public function onInfo_GetList(resp:Object) : void
      {
         var j:int = 0;
         var i:int = 0;
         var newEvent:TmcEvent = null;
         if(resp.hasOwnProperty("Info_GetList"))
         {
            if(resp.Info_GetList.hasOwnProperty("resultCode"))
            {
               if(int(resp.Info_GetList.resultCode) != 1)
               {
                  Framework.Trace("TmcManager.onInfo_GetList() resultCode: " + resp.Info_GetList.resultCode);
                  return;
               }
               if(resp.Info_GetList.hasOwnProperty("respEIS"))
               {
                  if(String(resp.Info_GetList.respEIS).indexOf(REQUEST_TYPE_STATIONS) != -1)
                  {
                     if(resp.Info_GetList.hasOwnProperty("itemList"))
                     {
                        Framework.Trace("Received " + REQUEST_TYPE_STATIONS);
                        this.mTuningStationsList = resp.Info_GetList.itemList as Array;
                        this.mNavService.sendEvent(NavigationEvent.TMC_STATIONS_LIST);
                     }
                  }
                  if(String(resp.Info_GetList.respEIS).indexOf(REQUEST_TYPE_GROUP) != -1)
                  {
                     if(resp.Info_GetList.hasOwnProperty("itemList"))
                     {
                        this.mTrafficGroupTypes = new Object();
                        for(j = 0; j < (resp.Info_GetList.itemList as Array).length; j++)
                        {
                           this.mTrafficGroupTypes[(resp.Info_GetList.itemList as Array)[j]] = GROUP_TYPES_DEFAULT;
                        }
                        this.mNavService.sendEvent(NavigationEvent.TMC_GROUP_TYPES);
                     }
                     PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
                     PersistenceApi.api.loadData(PersistenceKeys.TMC_SETTINGS);
                  }
                  if(String(resp.Info_GetList.respEIS).indexOf(REQUEST_TYPE_DELAY_ON_ROUTE) != -1)
                  {
                     if(resp.Info_GetList.hasOwnProperty("outputEIS"))
                     {
                        this.mRouteHandleDelayTimes[EisHelper.getValueOfType(resp.Info_GetList.outputEIS,"<RTH>")] = EisHelper.getValueOfType(resp.Info_GetList.outputEIS,"<MIN>");
                        this.mNavService.sendEvent(NavigationEvent.TMC_DELAY_ON_ROUTE);
                     }
                  }
                  else
                  {
                     this.mLocalEventList.clear();
                     this.mLocalEventList.setInfoType(this.mLocalInfoType);
                     for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                     {
                        newEvent = new TmcEvent(String(resp.Info_GetList.itemList[i]));
                        this.mLocalEventList.addEvent(newEvent);
                     }
                     this.mNavService.sendEvent(NavigationEvent.TMC_EVENT_LIST);
                  }
               }
            }
         }
      }
      
      public function onInfo_GetSpell(resp:Object) : void
      {
         Framework.Trace("TmcManager.onInfo_GetSpell()");
      }
      
      public function onInfo_GetAvailableInformation(resp:Object) : void
      {
         Framework.Trace("TmcManager.onInfo_GetAvailableInformation()");
      }
      
      public function onInfo_GetDetails(resp:Object) : void
      {
         Framework.Trace("TmcManager.onInfo_GetDetails()");
         if(resp.hasOwnProperty("Info_GetDetails") && resp.Info_GetDetails.resultCode == 1)
         {
            this.tmcEventDetails = resp.Info_GetDetails.outputEIS;
            this.mNavService.sendEvent(NavigationEvent.TMC_EVENT_DETAILS);
         }
      }
      
      public function onSignal(resp:Object) : void
      {
         var i:String = null;
         if(resp.hasOwnProperty("TMC_InfoChanged"))
         {
            Framework.Trace("TmcManager.onSignal( TMC_InfoChanged )");
         }
         else if(resp.hasOwnProperty("TMC_EventsDeleted"))
         {
            if(resp.TMC_EventsDeleted.hasOwnProperty("tmcEvents"))
            {
               this.mLastDeletedEventIDs.splice(0,this.mLastDeletedEventIDs.length);
               for(i in resp.TMC_EventsDeleted.tmcEvents)
               {
                  if(String(resp.TMC_EventsDeleted.tmcEvents[i]).indexOf("<TEV>") == 0)
                  {
                     Framework.Trace("TmcManager.onSignal( TMC_EventsDeleted )" + String(resp.TMC_EventsDeleted.tmcEvents[i]));
                     this.mLastDeletedEventIDs.push(String(resp.TMC_EventsDeleted.tmcEvents[i]).substring(5,String(resp.TMC_EventsDeleted.tmcEvents[i]).lastIndexOf("<*>")));
                  }
               }
               this.mNavService.sendEvent(NavigationEvent.TMC_EVENTS_DELETED);
            }
         }
         else if(resp.hasOwnProperty("TMC_EventsNew"))
         {
            Framework.Trace("TmcManager.onSignal( TMC_EventsNew )");
         }
         else
         {
            Framework.Trace("TmcManager. unknown signal()");
         }
      }
      
      public function onAvoidMode(resp:Object) : void
      {
         if(Boolean(resp.TMC_AvoidMode.hasOwnProperty("avoidMode")) && Boolean(resp.TMC_AvoidMode.hasOwnProperty("tmcItems")))
         {
            this.tmcAvoidMode = int(resp.TMC_AvoidMode.avoidMode);
            this.tmcAvoidModeItems = resp.TMC_AvoidMode.tmcItems;
         }
         if(!resp.TMC_AvoidMode.hasOwnProperty("tmcIgnore"))
         {
         }
         if(!resp.TMC_AvoidMode.hasOwnProperty("tmcAvoid"))
         {
         }
         if(!resp.TMC_AvoidMode.hasOwnProperty("tmcAuto"))
         {
         }
      }
      
      public function onTuningMode(resp:Object) : void
      {
         if(resp.TMC_SetTMCTuningMode != null)
         {
            Framework.Trace("TmcManager.onTuningMode(" + " mode:" + resp.TMC_SetTMCTuningMode.tmcTuningMode + ", params:" + resp.TMC_SetTMCTuningMode.tuningParameters + " )");
            this.mTuningMode = resp.TMC_SetTMCTuningMode.tmcTuningMode;
            this.mTuningStation = EisHelper.getValueOfType(resp.TMC_SetTMCTuningMode.tuningParameters,"<PICODE>");
         }
         if(resp.TMC_TuningMode != null)
         {
            Framework.Trace("TmcManager.onTuningMode(" + " mode:" + resp.TMC_TuningMode.tmcTuningMode + ", params:" + resp.TMC_TuningMode.tuningParameters + " )");
            this.mTuningMode = resp.TMC_TuningMode.tmcTuningMode;
            this.mTuningStation = EisHelper.getValueOfType(resp.TMC_TuningMode.tuningParameters,"<PICODE>");
         }
         this.mNavService.sendEvent(NavigationEvent.TMC_STATION);
      }
      
      public function onRoutesDeleted(resp:Object) : void
      {
         var j:int = 0;
         Framework.Trace("TmcManager.onRoutesDeleted( " + resp.TMC_RoutesDeleted.routeList.length + " )");
         if(this.mManualRouteAlternatives == null)
         {
            return;
         }
         for(var i:int = 0; i < resp.TMC_RoutesDeleted.routeList.length; i++)
         {
            for(j = 0; j < this.mManualRouteAlternatives.routeList.length; j++)
            {
               if(String(this.mManualRouteAlternatives.routeList[j]) == String(resp.TMC_RoutesDeleted.routeList[i]))
               {
                  Framework.Trace(" -Removing " + this.mManualRouteAlternatives.routeList[j]);
                  this.mManualRouteAlternatives.routeList.splice(j,1);
               }
            }
         }
         this.mNavService.sendEvent(NavigationEvent.TMC_MANUAL_REROUTE);
      }
      
      public function onRoutesAvailable(resp:Object) : void
      {
         var i:String = null;
         Framework.Trace("TmcManager.onRoutesAvailable( " + resp.TMC_RoutesAvailable.routeList.length + " )");
         if(resp.TMC_RoutesAvailable.hasOwnProperty("routeList"))
         {
            for(i in resp.TMC_RoutesAvailable.routeList)
            {
               Framework.Trace("Nav.TmcManager.onRoutesAvailable ( " + i + ", " + resp.TMC_RoutesAvailable.routeList[i] + " )");
            }
            this.mManualRouteAlternatives = resp.TMC_RoutesAvailable;
            this.mNavService.sendEvent(NavigationEvent.TMC_MANUAL_REROUTE);
         }
      }
      
      public function onRouteAccepted(resp:Object) : void
      {
         Framework.Trace("TmcManager.onRouteAccepted()");
      }
      
      private function getTmcEventListUpdate() : void
      {
         var distanceFilter:int = NavGlobalSettings.TMC_DISTANCE_FIILTER_DEFAULT;
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               distanceFilter = NavGlobalSettings.TMC_DISTANCE_FIILTER_NA;
               break;
            case VServiceGlobalSettings.MARKET_EUROPE:
               distanceFilter = NavGlobalSettings.TMC_DISTANCE_FIILTER_EU;
               break;
            case VServiceGlobalSettings.MARKET_ROW:
               distanceFilter = NavGlobalSettings.TMC_DISTANCE_FIILTER_ROW;
               break;
            default:
               distanceFilter = NavGlobalSettings.TMC_DISTANCE_FIILTER_DEFAULT;
         }
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":" + "\"<IFT>TMC<*>" + "<RFD>" + distanceFilter + "<*>" + "<RQT>event<*>" + "<TET>" + this.getTmcInfoTypeString() + "<*><TMC><*>" + "\"" + ",\"inresultCount\":" + 100 + ",\"insortOption\":" + SortOption.NEAR_FIRST + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}");
      }
      
      private function getTmcInfoTypeString() : String
      {
         switch(this.mLocalInfoType)
         {
            case TmcTypes.INFO_TYPE_ALL_MESSAGES:
               return TmcTypes.INFO_TYPE_STRING_ALL_MESSAGES;
            case TmcTypes.INFO_TYPE_ON_ROUTE:
               return TmcTypes.INFO_TYPE_STRING_ON_ROUTE;
            case TmcTypes.INFO_TYPE_SIGNIFICENT:
               return TmcTypes.INFO_TYPE_STRING_SIGNIFICENT;
            default:
               return TmcTypes.INFO_TYPE_STRING_ALL_MESSAGES;
         }
      }
      
      public function getTmcInfoType() : int
      {
         return this.mLocalInfoType;
      }
      
      private function avoidEvent(event:TmcEvent) : void
      {
         var info:String = "";
         if(event.getType("<TMC>") != null)
         {
            info += "<TMC>" + event.getType("<TMC>") + "<*>";
         }
         if(event.getType("<TEV>") != null)
         {
            info += "<TEV>" + event.getType("<TEV>") + "<*>";
         }
         if(event.getType("<GEO>") != null)
         {
            info += "<GEO>" + event.getType("<GEO>") + "<*>";
         }
         if(event.getType("<TID>") != null)
         {
            info += "<TID>" + event.getType("<TID>") + "<*>";
         }
         this.mNavService.sendCommand("\"TMC_AvoidMode\":{" + "\"avoidMode\":" + TmcTypes.AVOID_MODE_AVOID + "," + "\"tmcItems\":[" + "\"" + info + "\"" + "]}");
      }
      
      private function sendRouteMode() : void
      {
         this.mNavService.sendCommand("\"TMC_SetTMCRouteMode\":{" + "\"tmcRouteMode\":" + this.mTMCRouteMode + "," + "\"minutes\":" + this.mTMCDelayTime + "}");
         switch(this.mTMCRouteMode)
         {
            case TmcTypes.ROUTE_MODE_AUTO:
               this.setAvoidanceGroupsAuto();
               break;
            case TmcTypes.ROUTE_MODE_DELAY:
               this.setAvoidanceGroupsAuto();
               break;
            case TmcTypes.ROUTE_MODE_MANUAL:
               this.setAvoidanceGroupsManual();
               break;
            case TmcTypes.ROUTE_MODE_OFF:
               this.setAvoidanceGroupsIgnoreAll();
         }
      }
      
      public function get manualReRouteAlternatives() : Object
      {
         return this.mManualRouteAlternatives;
      }
      
      public function manualReRouteAccept(routeHandle:String) : void
      {
         Framework.Trace("Nav.TmcManager.manualReRouteAccept( " + routeHandle + " )");
         for(var i:int = 0; i < this.mManualRouteAlternatives.routeList.length; i++)
         {
            if(this.mManualRouteAlternatives.routeList[i] == routeHandle)
            {
               NavigationPackage.peripheral.navigation.navRouteCalculation.startTmcRelatedReroute(int(routeHandle));
               return;
            }
         }
         Framework.Trace(" -Can\'t avoid - RouteHandle no longer available!");
      }
      
      private function getEventTEV(txt:String) : int
      {
         var info:String = "";
         var tmcStart:int = txt.indexOf("TEV") + 4;
         var tmcEnd:int = txt.indexOf("<*>",tmcStart);
         info = txt.substring(tmcStart,tmcEnd);
         return int(info);
      }
      
      public function manualReRouteDecline(routeHandle:String) : void
      {
         Framework.Trace("Nav.TmcManager.manualReRouteDecline()");
         NavigationPackage.peripheral.navigation.navRouteCalculation.killRejectedTmcReroute(int(routeHandle));
      }
      
      private function requestTmcGroups() : void
      {
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":" + "\"" + REQUEST_TYPE_GROUP + "\"" + ",\"inresultCount\":" + 100 + ",\"insortOption\":" + SortOption.DEFAULT + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}");
      }
      
      private function requestTmcStations() : void
      {
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":" + "\"" + REQUEST_TYPE_STATIONS + "\"" + ",\"inresultCount\":" + 100 + ",\"insortOption\":" + SortOption.DEFAULT + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}");
      }
      
      public function getTMCGroupTypes() : void
      {
         var i:String = null;
         var found:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:* = this.mTrafficGroupTypes;
         for(i in _loc4_)
         {
            found = true;
         }
         if(found)
         {
            this.mNavService.sendEvent(NavigationEvent.TMC_GROUP_TYPES);
         }
         else
         {
            this.requestTmcGroups();
         }
      }
      
      public function get tmcGroupTypes() : Object
      {
         return this.mTrafficGroupTypes;
      }
      
      public function tmcSetGroupTypesSelected(types:Object) : void
      {
         Framework.Trace("TmcManager.tmcGroupTypesSelectedSelect()");
         this.mTrafficGroupTypes = types;
         this.mNavService.sendEvent(NavigationEvent.TMC_GROUP_TYPES);
         this.setAvoidanceGroupsManual();
         this.saveGroupsToPersistence();
      }
      
      private function setAvoidanceGroupsManual() : void
      {
         var avoid:String = null;
         var ignore:String = null;
         var i:String = null;
         if(this.mTMCRouteMode == TmcTypes.ROUTE_MODE_MANUAL)
         {
            avoid = "";
            ignore = "";
            for(i in this.mTrafficGroupTypes)
            {
               if(Boolean(this.mTrafficGroupTypes[i]) == true)
               {
                  if(avoid.length > 0)
                  {
                     avoid += ",";
                  }
                  avoid += "\"" + i + "\"";
               }
               else
               {
                  if(ignore.length > 0)
                  {
                     ignore += ",";
                  }
                  ignore += "\"" + i + "\"";
               }
            }
            this.mNavService.sendCommand("\"TMC_AvoidMode\":{" + "\"tmcIgnore\":[" + ignore + "], " + "\"tmcAvoid\":[" + avoid + "]}");
         }
         else
         {
            Framework.Trace("NAv.TmcManager.setAvoidanceGroupsManual() blocked! ( " + this.mTMCRouteMode + " )");
         }
      }
      
      private function setAvoidanceGroupsAuto() : void
      {
         var i:String = null;
         var auto:String = "";
         for(i in this.mTrafficGroupTypes)
         {
            if(Boolean(this.mTrafficGroupTypes[i]) == true)
            {
               if(auto.length > 0)
               {
                  auto += ",";
               }
               auto += "\"" + i + "\"";
            }
         }
         this.mNavService.sendCommand("\"TMC_AvoidMode\":{" + "\"tmcAuto\":[" + auto + "]}");
      }
      
      private function setAvoidanceGroupsIgnoreAll() : void
      {
         var i:String = null;
         var ignore:String = "";
         for(i in this.mTrafficGroupTypes)
         {
            if(Boolean(this.mTrafficGroupTypes[i]) == true)
            {
               if(ignore.length > 0)
               {
                  ignore += ",";
               }
               ignore += "\"" + i + "\"";
            }
         }
         this.mNavService.sendCommand("\"TMC_AvoidMode\":{" + "\"tmcIgnore\":[" + ignore + "]}");
      }
      
      private function sendTuningMode() : void
      {
         Framework.Trace("TmcManager.sendTuningMode( " + this.mTuningMode + ", " + this.mTuningStation + " )");
         this.mNavService.sendCommand("\"TMC_SetTMCTuningMode\":{" + "\"tmcTuningMode\":" + this.mTuningMode + ", \"tuningParameters\":\"<PICODE>" + this.mTuningStation + "<*>\"}");
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.TMC_TUNING)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TMC_TUNING,true);
            if(res != null)
            {
               for(i in res)
               {
                  switch(res[i])
                  {
                     case "TM":
                        Framework.Trace("TM:" + res[i]);
                        this.mTuningMode = int(res[i]);
                     case "TS":
                        Framework.Trace("TS:" + res[i]);
                        this.mTuningStation = String(res[i]);
                  }
               }
            }
            this.sendTuningMode();
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.TMC_SETTINGS)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TMC_SETTINGS,true);
            if(res != null && this.getChildrenCount(res) > 0)
            {
               this.mTrafficGroupTypes = res;
               for(i in this.mTrafficGroupTypes)
               {
                  this.mTrafficGroupTypes[i] = String(this.mTrafficGroupTypes[i]).indexOf("true",0) == -1 ? false : true;
               }
               PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
               this.mNavService.sendEvent(NavigationEvent.TMC_GROUP_TYPES);
               this.setAvoidanceGroupsManual();
            }
         }
      }
      
      public function getChildrenCount(obj:Object) : Object
      {
         var child:Object = null;
         var count:int = 0;
         for(child in obj)
         {
            count++;
         }
         if(count == 0)
         {
            Framework.Trace("PersistenceController: zero children in persistence object");
         }
         return count;
      }
      
      public function saveGroupsToPersistence() : void
      {
         var pers:Object = new Object();
         if(this.mTrafficGroupTypes != null)
         {
            PersistenceApi.api.saveData(PersistenceKeys.TMC_SETTINGS,this.mTrafficGroupTypes);
         }
         else
         {
            Framework.Trace("Nav.TmcManager.saveGroupsToPersistence() FAILED");
         }
      }
      
      public function saveStationSettingsToPersistence() : void
      {
         var pers:Object = new Object();
         pers["TM"] = this.mTuningMode;
         pers["TS"] = this.mTuningStation;
         PersistenceApi.api.saveData(PersistenceKeys.TMC_TUNING,pers);
      }
   }
}

