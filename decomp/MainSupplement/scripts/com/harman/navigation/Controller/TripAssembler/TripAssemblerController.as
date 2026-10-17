package com.harman.navigation.Controller.TripAssembler
{
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.navigation.Controller.LiveServices.SearchAreaTypes;
   import com.harman.navigation.Controller.MAP.MapControllerApi;
   import com.harman.navigation.Controller.MAP.MapControllerImpl;
   import com.harman.navigation.Controller.MAP.utils.MapConfiguration;
   import com.harman.navigation.Controller.POI.PoiInputApi;
   import com.harman.navigation.Controller.POI.PoiInputImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationApi;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationImpl;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.DomainControl.ExternalDestinationsHandler;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.enums.TripAssemblerMenu;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.enums.VoicePrompts;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.span.Client;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class TripAssemblerController extends EventDispatcher implements ITripAssembler
   {
      
      private static var mRoundTripModeEnabled:Boolean = false;
      
      private static var mRoundTripLocation:LocationDescription = new LocationDescription();
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mNewDestinations:Array = new Array();
      
      private var mPrimaryMode:int = 0;
      
      private var mSecondaryMode:int = 0;
      
      private var mMenuStack:Array = new Array(TripAssemblerMenu.UNDEFINED);
      
      private var mRouteModeSingle:Array = new Array();
      
      private var mRouteModeAlternatives:Array = new Array();
      
      private var mCalculationProgress:int = 0;
      
      private var mReCalculationInProgress:Boolean = false;
      
      private var mRouteAlterationFlagInProgress:Boolean = false;
      
      private var mRouteCalculationFailed:Boolean = false;
      
      private var mStartRouteGuidanceIndex:int = 0;
      
      private var mPreviousRoute:Route = new Route();
      
      private var mPreviousRouteElement:int = -1;
      
      private var mLastAddedLocationDescription:LocationDescription = new LocationDescription();
      
      private var mLastAddedLocationIndex:int = 0;
      
      private var mHmiRequestModuleInterval:uint = 0;
      
      private var mHmiRequestStartGuidanceOnCalculated:Boolean = false;
      
      private var mTrailIndex:int = -1;
      
      private var mTrailMode:int = -1;
      
      public function TripAssemblerController()
      {
         super();
         PoiInputApi.impl = PoiInputImpl.instance;
         NavigationApi.impl = NavigationImpl.create();
         MapControllerApi.impl = MapControllerImpl.create();
         RouteCalculationApi.impl = RouteCalculationImpl.create();
         RouteCalculationApi.api.addEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE,this.onPlannedRouteUpdate,false,0,true);
         RouteCalculationApi.api.addEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED,this.onCalculationFailed,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_FACTORY_RESET,this.onFactoryReset,false,0,true);
         this.mHmiRequestModuleInterval = setInterval(this.onHmiRequestModuleInterval,5000);
         this.init();
      }
      
      public function addLocationDescription(loc:LocationDescription) : void
      {
         NavigationPackage.peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU,this.onBackToNavMainMenu,false,0,true);
         NavigationPackage.peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE,this.onLeavingNavDomain,false,0,true);
         this.mLastAddedLocationDescription = loc;
         this.prepareForNewCalculation();
         this.resetMenuStack();
         NavigationPackage.peripheral.navigation.navMapControl.setPosition(loc.getSecondaryLocation().getType("<GEO>"),MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
         switch(this.mSecondaryMode)
         {
            case TripAssemblerMode.POI_SEARCH_AREA:
               if(loc.getSecondaryLocation().getType("<GEO>") != "" || loc.getPrimaryLocation().getType("<GEO>") != "")
               {
                  PoiInputApi.api.poiSetSearchInCity(loc);
                  PoiInputApi.api.poiSelectDefaultSearchArea(PoiSearchArea.IN_A_CITY);
               }
               else
               {
                  this.sendEvent(TripAssemblerEvent.POI_SEARCH_AREA_CITY_INVALID);
               }
               this.mSecondaryMode = TripAssemblerMode.UNDEFINED;
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            default:
               this.mCalculationProgress = 0;
               switch(this.mPrimaryMode)
               {
                  case TripAssemblerMode.DESTINATION_ROUTE_TO:
                  case TripAssemblerMode.DESTINATION_SET_HOME:
                  case TripAssemblerMode.DESTINATION_ROUTE_HOME:
                  case TripAssemblerMode.DESTINATION_SET_EXTERNAL:
                     this.clearNewDestinationsList();
                     if(this.retrieveOutstandingActiveDestinations())
                     {
                        NavigationPackage.peripheral.navigation.navVServices.screenHelper.setDestinationPreOrderPage(1);
                        this.mMenuStack.push(TripAssemblerMenu.DESTINATION_LIST_PRE_ORDER);
                        this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     }
                     else
                     {
                        this.positionSelectOnlyDestination();
                     }
                     break;
                  case TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_HOME:
                     this.clearNewDestinationsList();
                     this.mNewDestinations.push(this.mLastAddedLocationDescription);
                     this.mLastAddedLocationIndex = 0;
                     this.calculateRoute(3);
                     this.mMenuStack.push(TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_HOME);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_WORK:
                     this.clearNewDestinationsList();
                     this.mNewDestinations.push(this.mLastAddedLocationDescription);
                     this.mLastAddedLocationIndex = 0;
                     this.calculateRoute(3);
                     this.mMenuStack.push(TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_WORK);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.DESTINATION_VOICE_RECKONED:
                     NavigationPackage.peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                     this.clearNewDestinationsList();
                     if(this.retrieveOutstandingActiveDestinations())
                     {
                        this.positionSelectFirstStopover();
                     }
                     else
                     {
                        this.positionSelectOnlyDestination();
                     }
                     break;
                  case TripAssemblerMode.DESTINATION_TRIP:
                     this.mMenuStack.push(TripAssemblerMenu.CONFIRM_TRIP_ADD_CONFIRM);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.DESTINATION_ADD_TO_FAVORITES:
                     this.mMenuStack.push(TripAssemblerMenu.FAVORITE_WHERE_TO_SPELLER);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.CONTACT_ADD_TO_FAVORITES:
                     this.mMenuStack.push(TripAssemblerMenu.FAVORITE_CONTACT_SPELLER);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.DESTINATION_ROUTE_TRIP:
                     Framework.Trace("TripAssemblerController.addLocationDescription: DESTINATION_ROUTE_TRIP is not supported with this function.");
                     break;
                  case TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_HOME:
                     this.mMenuStack.push(TripAssemblerMenu.CONFIRM_LIVE_SERVICES_HOME);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_WORK:
                     this.mMenuStack.push(TripAssemblerMenu.CONFIRM_LIVE_SERVICES_WORK);
                     this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
                     break;
                  case TripAssemblerMode.LOCATION_LIVE_SERVICES_LOCAL_SEARCH:
                     this.startGuidanceInternal(0,false);
                     break;
                  case TripAssemblerMode.LOCATION_LIVE_SERVICES_WEATHER:
                     this.startGuidanceInternal(0,false);
                     break;
                  case TripAssemblerMode.UNDEFINED:
                  default:
                     Framework.Trace("TripAssemblerController.addLocationDescription: Do not know what to add destination to primaryMode \"" + this.mPrimaryMode + "\" secondaryMode \"" + this.mSecondaryMode + "\"");
               }
               NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_TRIP_ASSEMBLER);
         }
      }
      
      public function setTrailDestination(trailIndex:int, routeMode:int) : void
      {
         var trailTrip:TripRoute = null;
         Framework.Trace("TrapAssemblerController.setTrailDestination( " + trailIndex + ", " + routeMode + " )");
         if(routeMode == RouteMode.TRAIL_GUIDANCE || routeMode == RouteMode.TRAIL_GUIDANCE_FROM_END)
         {
            NavigationPackage.peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU,this.onBackToNavMainMenu,false,0,true);
            NavigationPackage.peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE,this.onLeavingNavDomain,false,0,true);
            this.mTrailIndex = trailIndex;
            this.mTrailMode = routeMode;
            this.mCalculationProgress = 0;
            this.resetMenuStack();
            this.sendEvent(TripAssemblerEvent.TRIP_TRAIL_NAME);
            mRoundTripModeEnabled = false;
            this.clearNewDestinationsList();
            this.mRouteCalculationFailed = false;
            trailTrip = new TripRoute();
            trailTrip.setTrailPath(NavigationPackage.peripheral.navigation.navigation.getTrailPath(this.mTrailIndex));
            trailTrip.setTrailMode(this.mTrailMode);
            NavigationPackage.peripheral.navigation.navRouteCalculation.createNewTripTrail(trailTrip);
            this.mMenuStack.push(TripAssemblerMenu.CONFIRM_TRAIL);
            NavigationPackage.peripheral.navigation.navMapControl.setPosition(NavigationApi.api.posPositionInformation.getType("<GEO>"),MapConfiguration.MAP_CONFIRM_ROUTE);
            NavigationPackage.peripheral.navigation.navMapControl.selectConfiguration(MapConfiguration.MAP_CONFIRM_ROUTE);
            this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_TRIP_ASSEMBLER);
         }
         else
         {
            Framework.Trace(" -Can\'t start calculating Trail guidance!");
         }
      }
      
      public function positionSelectOnlyDestination() : void
      {
         Framework.Trace("TrapAssemblerController.positionSelectOnlyDestination()");
         this.clearNewDestinationsList();
         this.mNewDestinations.push(this.mLastAddedLocationDescription);
         this.mLastAddedLocationIndex = this.mNewDestinations.length - 1;
         this.sendEvent(TripAssemblerEvent.TRIP_DESTINATIONS);
         this.switchToConfirmationScreenWithOneRoute();
      }
      
      public function positionSelectFirstStopover() : void
      {
         Framework.Trace("TrapAssemblerController.positionSelectFirstStopover()");
         this.positionAddDestinationAtIndex(0);
      }
      
      public function positionSelectLastStopover() : void
      {
         Framework.Trace("TrapAssemblerController.positionSelectLastStopover()");
         this.positionAddDestinationAtIndex(this.mNewDestinations.length);
      }
      
      public function positionSelectStopoverIndex(index:int) : void
      {
         Framework.Trace("TrapAssemblerController.positionSelectStopoverIndex( " + index + " )");
         this.positionAddDestinationAtIndex(index);
      }
      
      private function positionAddDestinationAtIndex(index:int) : void
      {
         Framework.Trace("TrapAssemblerController.positionAddDestinationAtIndex( " + index + " )");
         this.clearNewDestinationsList();
         this.retrieveOutstandingActiveDestinations();
         if(index > this.mNewDestinations.length || index < 0)
         {
            Framework.Trace("TrapAssemblerController.positionAddDestinationAtIndex( " + index + " ) -> ILLEGAL index (" + this.mNewDestinations.length + " previous Destinations)");
            return;
         }
         this.mNewDestinations.splice(index,0,this.mLastAddedLocationDescription);
         this.mLastAddedLocationIndex = index;
         this.switchToConfirmationScreenWithOneRoute();
      }
      
      private function switchToConfirmationScreenWithOneRoute() : void
      {
         switch(this.mPrimaryMode)
         {
            case TripAssemblerMode.DESTINATION_SET_HOME:
               this.mMenuStack.push(TripAssemblerMenu.CONFIRM_HOME_SET);
               break;
            case TripAssemblerMode.DESTINATION_ROUTE_HOME:
               this.mMenuStack.push(TripAssemblerMenu.CONFIRM_HOME_ROUTE);
               break;
            case TripAssemblerMode.DESTINATION_VOICE_RECKONED:
               this.mMenuStack.push(TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION);
               break;
            case TripAssemblerMode.DESTINATION_ROUTE_TO:
            case TripAssemblerMode.DESTINATION_SET_EXTERNAL:
               this.mMenuStack.push(TripAssemblerMenu.CONFIRM_ROUTE);
         }
         this.calculateRoute(1);
         NavigationPackage.peripheral.navigation.navMapControl.selectConfiguration(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      public function get positionSelectActiveRoute() : Array
      {
         return this.mNewDestinations;
      }
      
      public function positionReplaceStopoverIndex(index:int) : void
      {
         Framework.Trace("TrapAssemblerController.positionReplaceStopoverIndex( " + index + " )");
         this.clearNewDestinationsList();
         this.retrieveOutstandingActiveDestinations();
         if(index > this.mNewDestinations.length - 1 || index < 0)
         {
            Framework.Trace("TrapAssemblerController.positionAddDestinationAtIndex( " + index + " ) -> ILLEGAL index (" + this.mNewDestinations.length + " previous Destinations)");
            return;
         }
         if(index < NavGlobalSettings.ROUTE_GUIDANCE_MAX_DESTINATIONS)
         {
            this.mNewDestinations.splice(index,1,this.mLastAddedLocationDescription);
            this.mLastAddedLocationIndex = index;
         }
         else
         {
            Framework.Trace("TrapAssemblerController.positionReplaceStopoverIndex( " + index + " ) -> ILLEGAL index (" + this.mNewDestinations.length + " previous Destinations)");
         }
         this.switchToConfirmationScreenWithOneRoute();
      }
      
      private function prepareForNewCalculation() : void
      {
         this.mHmiRequestStartGuidanceOnCalculated = false;
         mRoundTripModeEnabled = false;
         this.clearReCalculationFlag();
         this.clearRouteAlterationFlag();
      }
      
      public function setTripAsDestination(locs:Array) : void
      {
         Framework.Trace("TripAssemblerController.setTripAsDestination(" + locs.length + ")");
         this.prepareForNewCalculation();
         this.mLastAddedLocationDescription = LocationDescription(locs[locs.length - 1]);
         this.mLastAddedLocationIndex = locs.length;
         this.mNewDestinations.splice(0,this.mNewDestinations.length);
         for(var i:int = 0; i < locs.length; i++)
         {
            this.mNewDestinations.push(LocationDescription(locs[i]));
         }
         this.mMenuStack.push(TripAssemblerMenu.CONFIRM_ROUTE);
         this.calculateRoute(1);
         NavigationPackage.peripheral.navigation.navMapControl.selectConfiguration(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
         NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_TRIP_ASSEMBLER);
      }
      
      public function setDestinationMode(mode:int) : void
      {
         Framework.Trace("TripAssemblerController.setDestinationMode(" + mode + ")");
         this.mNewDestinations = new Array();
         this.resetMenuStack();
         this.resetTrailParameters();
         this.mPrimaryMode = mode;
         if(mode == TripAssemblerMode.DESTINATION_ROUTE_TO)
         {
            mRoundTripModeEnabled = false;
         }
         else if(mode == TripAssemblerMode.DESTINATION_ROUTE_TRIP)
         {
            mRoundTripModeEnabled = false;
         }
         else if(mode == TripAssemblerMode.DESTINATION_ROUTE_HOME || mode == TripAssemblerMode.DESTINATION_SET_HOME || mode == TripAssemblerMode.DESTINATION_ROUTE_TRIP || mode == TripAssemblerMode.DESTINATION_VOICE_RECKONED || mode == TripAssemblerMode.DESTINATION_SET_EXTERNAL || mode == TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_HOME || mode == TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_WORK)
         {
            mRoundTripModeEnabled = false;
         }
      }
      
      public function get destinationMode() : int
      {
         return this.mPrimaryMode;
      }
      
      public function setSecondaryMode(mode:int) : void
      {
         this.mSecondaryMode = mode;
      }
      
      public function onBack() : void
      {
         var i:int = 0;
         Framework.Trace("TripAssemblerController.onBack()");
         switch(this.getLastMenuStackItem())
         {
            case TripAssemblerMenu.CONFIRM_HOME_SET:
            case TripAssemblerMenu.CONFIRM_HOME_ROUTE:
            case TripAssemblerMenu.CONFIRM_ROUTE:
            case TripAssemblerMenu.CONFIRM_TRAIL:
            case TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION:
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_HOME:
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_WORK:
               NavigationPackage.peripheral.navigation.navRouteCalculation.destroyTrips();
               break;
            case TripAssemblerMenu.ROUTE_ALTERNATIVES:
               this.setReCalculationFlag();
               this.calculateRoute(1);
               break;
            case TripAssemblerMenu.DESTINATION_LIST_OPTIONS:
            case TripAssemblerMenu.DESTINATION_LIST_POST_ORDER:
            case TripAssemblerMenu.CONFIRM_DESTINATION_REORDER_INFO:
            case TripAssemblerMenu.FAVORITE_SAVE_AS_SPELLER:
            case TripAssemblerMenu.DESTINATION_LIST_AVOIDANCE_TYPES:
            case TripAssemblerMenu.CONFIRM_TRIP_ADD_CONFIRM:
            case TripAssemblerMenu.FAVORITE_WHERE_TO_SPELLER:
            case TripAssemblerMenu.SAVE_AS_TRIP_SPELLER:
            case TripAssemblerMenu.DESTINATION_LIST_CHANGE_INTERCHANGE:
               break;
            case TripAssemblerMenu.UNDEFINED:
            default:
               Framework.Trace(" -Back-Function not supported in menu( " + this.getLastMenuStackItem() + " )");
         }
         this.removeLastMenuStackItem();
         if(this.getLastMenuStackItem() == TripAssemblerMenu.DESTINATION_LIST_PRE_ORDER)
         {
            for(i = 0; i < this.mNewDestinations.length; i++)
            {
               if(LocationDescription(this.mNewDestinations[i]) == this.mLastAddedLocationDescription)
               {
                  Framework.Trace(" -Remove lastAddedDestination @" + i);
                  this.mNewDestinations.splice(i,1);
               }
               if(mRoundTripModeEnabled == true && LocationDescription(this.mNewDestinations[i]) == mRoundTripLocation)
               {
                  mRoundTripModeEnabled = false;
                  this.mNewDestinations.splice(i,1);
               }
            }
         }
         if(this.getLastMenuStackItem() == TripAssemblerMenu.UNDEFINED)
         {
            if(this.mPrimaryMode == TripAssemblerMode.DESTINATION_SET_EXTERNAL)
            {
               Framework.Trace(" -> CONFIRM_EXTERNAL_DESTINATION -> \"" + ExternalDestinationsHandler.backFunction + "\"");
               NavigationPackage.peripheral.navigation.navDomainControl.clearMenuStack(0);
               NavigationPackage.peripheral.navigation.navDomainControl.clearMenuStack(1);
               if(ExternalDestinationsHandler.backFunction != "")
               {
                  Framework.structure.goto(ExternalDestinationsHandler.backFunction);
               }
               else
               {
                  Framework.Trace("NavConfirmExternalDestination.onBack() -> no BackFunction defined! (useing default)");
                  Framework.structure.goto(NavGlobalSettings.EXTERNAL_DESTINATION_ON_BACK_SCREEN);
               }
               return;
            }
         }
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      public function onClose() : void
      {
         Framework.Trace("TripAssemblerController.onClose()");
         switch(this.getLastMenuStackItem())
         {
            case TripAssemblerMenu.CONFIRM_ROUTE:
            case TripAssemblerMenu.CONFIRM_HOME_SET:
            case TripAssemblerMenu.CONFIRM_HOME_ROUTE:
            case TripAssemblerMenu.CONFIRM_TRAIL:
            case TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION:
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_HOME:
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_WORK:
               NavigationPackage.peripheral.navigation.navRouteCalculation.destroyTrips();
               NavigationPackage.peripheral.navigation.navDomainControl.onCancelButtonPress();
               break;
            case TripAssemblerMenu.DESTINATION_LIST_PRE_ORDER:
               NavigationPackage.peripheral.navigation.navRouteCalculation.destroyTrips();
               this.resetMenuStack();
               break;
            case TripAssemblerMenu.ROUTE_ALTERNATIVES:
               this.setReCalculationFlag();
               this.calculateRoute(1);
               while(this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_ROUTE && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_HOME_SET && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_HOME_ROUTE && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_EXTERNAL_DESTINATION && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_TRAIL)
               {
                  this.removeLastMenuStackItem();
               }
               break;
            case TripAssemblerMenu.DESTINATION_LIST_OPTIONS:
            case TripAssemblerMenu.DESTINATION_LIST_POST_ORDER:
            case TripAssemblerMenu.CONFIRM_DESTINATION_REORDER_INFO:
            case TripAssemblerMenu.FAVORITE_SAVE_AS_SPELLER:
            case TripAssemblerMenu.DESTINATION_LIST_AVOIDANCE_TYPES:
            case TripAssemblerMenu.SAVE_AS_TRIP_SPELLER:
            case TripAssemblerMenu.DESTINATION_LIST_CHANGE_INTERCHANGE:
               while(this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_ROUTE && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_HOME_SET && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_HOME_ROUTE && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_EXTERNAL_DESTINATION && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION && this.getLastMenuStackItem() != TripAssemblerMenu.CONFIRM_TRAIL && this.mMenuStack.length > 0)
               {
                  this.removeLastMenuStackItem();
               }
               break;
            case TripAssemblerMenu.CONFIRM_TRIP_ADD_CONFIRM:
               this.resetMenuStack();
               break;
            case TripAssemblerMenu.FAVORITE_WHERE_TO_SPELLER:
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
               break;
            case TripAssemblerMenu.UNDEFINED:
            default:
               Framework.Trace(" -Close-Function not supported in menu( " + this.getLastMenuStackItem() + " )");
         }
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      public function forceBackToNavMainMenu() : void
      {
         NavigationPackage.peripheral.navigation.navRouteCalculation.destroyTrips();
         NavigationPackage.peripheral.navigation.navDomainControl.onCancelButtonPress();
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      private function onBackToNavMainMenu(e:NavDomainControllerEvent) : void
      {
         if(this.mRouteAlterationFlagInProgress == false)
         {
            NavigationPackage.peripheral.navigation.navRouteCalculation.destroyTrips();
            NavigationPackage.peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU,this.onBackToNavMainMenu);
            NavigationPackage.peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE,this.onLeavingNavDomain);
         }
      }
      
      private function onLeavingNavDomain(e:NavDomainControllerEvent) : void
      {
      }
      
      public function getActiveMenu() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      public function getActiveMenuRepeat() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU_REPEAT);
      }
      
      public function get activeMenu() : int
      {
         return this.getLastMenuStackItem();
      }
      
      public function switchToMenu(menuID:int) : void
      {
         Framework.Trace("TripAssemblerController.switchToMenu( " + menuID + " )");
         switch(menuID)
         {
            case TripAssemblerMenu.ROUTE_ALTERNATIVES:
               this.setReCalculationFlag();
               this.calculateRoute(3);
         }
         this.mMenuStack.push(menuID);
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_MENU);
      }
      
      public function setRouteMode(mode:RouteMode, startProcessing:Boolean) : void
      {
         this.mRouteModeSingle.splice(0,this.mRouteModeSingle.length);
         this.mRouteModeSingle.push(mode);
         if(startProcessing)
         {
            Framework.Trace("TripAssemblerController.setRouteMode to ( " + mode.toString() + " ), process)");
            this.setReCalculationFlag();
            this.calculateRoute(1);
         }
         else
         {
            Framework.Trace("TripAssemblerController.setRouteMode to ( " + mode.toString() + " ), wait)");
         }
         this.toPersistence();
      }
      
      public function startGuidance(index:int, resetTripComputer:Boolean = true) : void
      {
         this.startGuidanceInternal(index,resetTripComputer);
      }
      
      private function startGuidanceInternal(index:int, resetTripComputer:Boolean = true, overwriteRoutemode:int = -1) : void
      {
         var geo:String = null;
         Framework.Trace("TripAssemblerController.startGuidance( " + index + " )");
         this.mStartRouteGuidanceIndex = index;
         switch(this.mPrimaryMode)
         {
            case TripAssemblerMode.DESTINATION_TRIP:
               NavigationPackage.peripheral.navigation.navTrips.destinationAdd(NavigationPackage.peripheral.navigation.navTrips.selectedTrip,this.mLastAddedLocationDescription);
               this.mSecondaryMode = TripAssemblerMode.UNDEFINED;
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_TRIPS_DESTINATIONS);
               break;
            case TripAssemblerMode.DESTINATION_ROUTE_TRIP:
               NavigationPackage.peripheral.navigation.navRouteCalculation.startGuidance(this.findRouteHandleByIndex(index),true,overwriteRoutemode);
               this.switchToMapMenuStack();
               break;
            case TripAssemblerMode.DESTINATION_SET_HOME:
               NavigationPackage.peripheral.navigation.navHomeAddress.setHomeAddress(this.mLastAddedLocationDescription);
               NavigationPackage.peripheral.navigation.navRouteCalculation.startGuidance(this.findRouteHandleByIndex(index),this.mNewDestinations.length > 1 || resetTripComputer == false ? false : true,overwriteRoutemode);
               this.switchToMapMenuStack();
               break;
            case TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_HOME:
               NavigationPackage.peripheral.navigation.navLiveServices.homeAddress = this.mLastAddedLocationDescription;
               this.mSecondaryMode = TripAssemblerMode.UNDEFINED;
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN);
               break;
            case TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_WORK:
               NavigationPackage.peripheral.navigation.navLiveServices.workAddress = this.mLastAddedLocationDescription;
               this.mSecondaryMode = TripAssemblerMode.UNDEFINED;
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN);
               break;
            case TripAssemblerMode.LOCATION_LIVE_SERVICES_LOCAL_SEARCH:
               geo = this.mLastAddedLocationDescription.getSecondaryLocation().getType("<GEO>");
               if(geo != "")
               {
                  NavigationPackage.peripheral.navigation.navLiveServices.setLocalSearchSearchArea(SearchAreaTypes.SA_OTHER_LOCATION,geo);
                  NavigationPackage.peripheral.navigation.navVServices.spellerGeneric.setFollowUpMenuID(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST);
                  NavigationPackage.peripheral.navigation.navVServices.spellerGeneric.setInputPreset("");
                  NavigationPackage.peripheral.navigation.navVServices.spellerGeneric.setMaxCharacters(NavGlobalSettings.POI_BY_NAME_MAX_CHARACTERS);
                  NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER);
               }
               break;
            case TripAssemblerMode.LOCATION_LIVE_SERVICES_WEATHER:
               NavigationPackage.peripheral.navigation.navLiveServices.setWeatherSearchArea(SearchAreaTypes.SA_OTHER_LOCATION,this.mLastAddedLocationDescription);
               NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_DETAILS);
               break;
            default:
               if(this.mTrailIndex == -1 && this.mTrailMode == -1)
               {
                  NavigationPackage.peripheral.navigation.navRecentDestinations.addDestination(this.mLastAddedLocationDescription);
               }
               NavigationPackage.peripheral.navigation.navRouteCalculation.startGuidance(this.findRouteHandleByIndex(index),this.mNewDestinations.length > 1 || resetTripComputer == false ? false : true,overwriteRoutemode);
               this.switchToMapMenuStack();
         }
         NavigationPackage.peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU,this.onBackToNavMainMenu);
         NavigationPackage.peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE,this.onLeavingNavDomain);
      }
      
      private function switchToMapMenuStack() : void
      {
         NavigationPackage.peripheral.navigation.navDomainControl.clearMenuStack(0);
         NavigationPackage.peripheral.navigation.navDomainControl.clearMenuStack(1);
         if(NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
         {
            if(NavigationPackage.peripheral.navigation.navDomainControl.mapMenuStackIsActive)
            {
               NavigationPackage.peripheral.navigation.navDomainControl.moveBackToMenu(NavMenus.MENU_MAP_MAIN);
            }
            else
            {
               NavigationPackage.peripheral.navigation.navDomainControl.toggleMenus();
            }
         }
         else
         {
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenuStackPassive(1);
         }
      }
      
      private function findRouteHandleByIndex(index:int) : int
      {
         var tr:TripRoute = NavigationPackage.peripheral.navigation.navRouteCalculation.lastCreatedTripRoute;
         if(tr != null)
         {
            if(index < tr.routes.length)
            {
               return Route(tr.routes[index]).routeHandle;
            }
            Framework.Trace("TripAssemblerController.findRouteHandleByIndex( " + index + " ) Invalid index! (" + tr.routes.length + ")");
            return -1;
         }
         Framework.Trace("TripAssemblerController.findRouteHandleByIndex( " + index + " ) No TripRoute found!");
         return -1;
      }
      
      public function removeDestinationFromActiveRoute(index:int) : void
      {
         Framework.Trace("TripAssemblerController.removeDestinationFromActiveRoute(" + index + ")");
         this.clearNewDestinationsList();
         this.retrieveOutstandingActiveDestinations();
         this.mNewDestinations.splice(index,1);
         this.mHmiRequestStartGuidanceOnCalculated = true;
         this.calculateRoute(1);
         this.setRouteAlterationFlag();
      }
      
      public function enableRoundTrip(enable:Boolean) : void
      {
         var currentLoc:LocationDescription = null;
         var geo:String = null;
         Framework.Trace("TripAssemblerController.enableRoundTrip(" + enable + ")");
         if(mRoundTripModeEnabled != enable)
         {
            mRoundTripModeEnabled = enable;
            if(mRoundTripModeEnabled == true)
            {
               currentLoc = new LocationDescription();
               currentLoc.setPrimaryLocation(NavigationApi.api.posPositionInformation);
               currentLoc.setSecondaryLocation(NavigationApi.api.posPositionInformation);
               geo = currentLoc.getPrimaryLocation().getType("<GEO>");
               if(int(geo.substr(0,geo.lastIndexOf(" "))) == 0)
               {
                  if(NavigationPackage.peripheral.navigation.navNDR.GpsInfo.mLongitude != 0 && NavigationPackage.peripheral.navigation.navNDR.GpsInfo.mLatitude != 0)
                  {
                     geo = String(NavigationPackage.peripheral.navigation.navNDR.GpsInfo.mLongitude / 1000000) + " " + String(NavigationPackage.peripheral.navigation.navNDR.GpsInfo.mLatitude / 1000000);
                     currentLoc.getPrimaryLocation().addType("<GEO>",geo);
                     currentLoc.getSecondaryLocation().addType("<GEO>",geo);
                     Framework.Trace("RoundTripPosition NDR fallback \'" + geo + "\'");
                  }
                  else
                  {
                     Framework.Trace("RoundTripPosition NDR fallback not available");
                  }
               }
               else
               {
                  Framework.Trace("RoundTripPosition \'" + geo + "\'");
               }
               if(this.mNewDestinations.length > NavGlobalSettings.ROUTE_GUIDANCE_MAX_DESTINATIONS)
               {
                  this.mNewDestinations.splice(this.mNewDestinations.length - 1,1,currentLoc);
               }
               else if(currentLoc.getPrimaryLocation().getType("<GEO>") != this.mNewDestinations[this.mNewDestinations.length - 1].getPrimaryLocation().getType("<GEO>"))
               {
                  this.mNewDestinations.push(currentLoc);
               }
               mRoundTripLocation = currentLoc;
            }
            else
            {
               this.mNewDestinations.splice(this.mNewDestinations.length - 1,1);
            }
            this.setReCalculationFlag();
            this.calculateRoute(1);
            this.sendEvent(TripAssemblerEvent.TRIP_ROUND_TRIP_MODE);
         }
         else
         {
            Framework.Trace(" -RoundTrip has not changed.");
         }
      }
      
      public function getRoundTripMode() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ROUND_TRIP_MODE);
      }
      
      public function get roundTripMode() : Boolean
      {
         return mRoundTripModeEnabled;
      }
      
      public function getDestinations() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_DESTINATIONS);
      }
      
      public function getRouteMode() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ROUTE_MODE);
      }
      
      public function getCalculationProgress() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS);
      }
      
      public function getCalculationFailed() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_CALCULATION_FAILED);
      }
      
      public function getIsRecalculation() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_IS_RE_CALCULATION_IN_PROGRESS);
      }
      
      public function getIsAlteringRoute() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ROUTE_ALTERATION_IN_PROGRESS);
      }
      
      public function get destinations() : Array
      {
         return this.mNewDestinations;
      }
      
      public function get routeMode() : RouteMode
      {
         if(RouteMode(this.mRouteModeSingle[0]).routeMode != 0)
         {
            return this.mRouteModeSingle[0];
         }
         Framework.Trace("Empty routeMode");
         return new RouteMode();
      }
      
      public function get calculationProgress() : int
      {
         return this.mCalculationProgress;
      }
      
      public function get calculationFailed() : Boolean
      {
         return this.mRouteCalculationFailed;
      }
      
      public function get isRecalculation() : Boolean
      {
         return this.mReCalculationInProgress;
      }
      
      public function get isAlteringRoute() : Boolean
      {
         return this.mRouteAlterationFlagInProgress;
      }
      
      public function setNewDestinationOrder(newOrder:Array) : void
      {
         if(newOrder.length != this.mNewDestinations.length)
         {
            Framework.Trace("TripAssemblerController.setNewDestinationOrder( " + newOrder.length + " ) Invalid array length! -> " + this.mNewDestinations.length);
            return;
         }
         var tmpArray:Array = new Array();
         for(var i:int = 0; i < newOrder.length; i++)
         {
            tmpArray.push(this.mNewDestinations[int(newOrder[i])]);
         }
         this.mNewDestinations = tmpArray;
         this.setReCalculationFlag();
         this.calculateRoute(1);
      }
      
      public function get lastAddedLocationDescription() : LocationDescription
      {
         return this.mLastAddedLocationDescription;
      }
      
      public function get lastAddedLocationIndex() : int
      {
         return this.mLastAddedLocationIndex;
      }
      
      public function getActiveRouteMode() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_ACTIVE_ROUTE_MODE);
      }
      
      public function get activeRouteMode() : RouteMode
      {
         var mode:RouteMode = new RouteMode();
         mode.overwrite(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeMode);
         return mode;
      }
      
      public function setActiveRouteMode(mode:RouteMode) : void
      {
         Framework.Trace("TripAssemblerController.setActiveRouteMode( " + mode.toString() + " )");
         Framework.Trace(" -Previous mode:\'" + RouteMode(this.mRouteModeSingle[0]).toString() + "\'");
         RouteMode(this.mRouteModeSingle[0]).overwrite(mode.routeMode);
         this.clearNewDestinationsList();
         if(this.retrieveOutstandingActiveDestinations())
         {
            this.mHmiRequestStartGuidanceOnCalculated = true;
            this.calculateRoute(1);
            this.setRouteAlterationFlag();
         }
         this.toPersistence();
      }
      
      private function onCalculationFailed(e:RouteCalculationEvent) : void
      {
         Framework.Trace("TripAssemblerController.onCalculationFailed()!");
         this.mCalculationProgress = 0;
         this.mRouteCalculationFailed = true;
         this.sendEvent(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS);
         this.sendEvent(TripAssemblerEvent.TRIP_CALCULATION_FAILED);
         this.setDefaultRouteMode();
         if(this.mHmiRequestStartGuidanceOnCalculated == true)
         {
            NavigationPackage.peripheral.hmiRequest.navStartGuidanceReturnResult(false);
            this.clearRouteAlterationFlag();
         }
      }
      
      private function onPlannedRouteUpdate(e:RouteCalculationEvent) : void
      {
         this.mCalculationProgress = NavigationPackage.peripheral.navigation.navRouteCalculation.newRouteCalculationPercentage;
         if(this.mCalculationProgress == 100)
         {
            this.clearReCalculationFlag();
            if(this.mHmiRequestStartGuidanceOnCalculated == true)
            {
               this.mHmiRequestStartGuidanceOnCalculated = false;
               this.startGuidanceInternal(0,false,RouteMode(this.mRouteModeSingle[0]).routeMode);
               NavigationPackage.peripheral.hmiRequest.navStartGuidanceReturnResult(true);
               this.clearRouteAlterationFlag();
            }
         }
         this.sendEvent(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new TripAssemblerEvent(eventType));
      }
      
      private function clearNewDestinationsList() : void
      {
         Framework.Trace("TripAssemblerController.clearNewDestinationsList()");
         this.mNewDestinations = new Array();
      }
      
      private function retrieveOutstandingActiveDestinations() : Boolean
      {
         var i:int = 0;
         Framework.Trace("TripAssemblerController.retrieveOutstandingActiveDestinations()");
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute != null)
            {
               if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.trailFilePath != "")
               {
                  return false;
               }
               for(i = NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeElement - 1; i < NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.Destinations.length; i++)
               {
                  if(i < 0)
                  {
                     i = 0;
                  }
                  this.mNewDestinations.push(Destination(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.Destinations[i]).hardDestination);
               }
               if(this.mNewDestinations.length > 0)
               {
                  Framework.Trace(" -found " + this.mNewDestinations.length + " active Destinations");
                  return true;
               }
            }
         }
         return false;
      }
      
      private function calculateRoute(alternatives:int) : void
      {
         var newDestination:Destination = null;
         Framework.Trace("TripAssemblerController.calculateRoute(" + alternatives + " )");
         this.mCalculationProgress = 0;
         if(this.mNewDestinations.length == 0)
         {
            Framework.Trace(" -FAILED - no destinations! ToDo: DIE GRACEFULLY !!!");
            this.clearReCalculationFlag();
         }
         var newTrip:TripRoute = new TripRoute();
         for(var i:int = 0; i < this.mNewDestinations.length; i++)
         {
            newDestination = new Destination();
            newDestination.setHardDestination(LocationDescription(this.mNewDestinations[i]));
            newTrip.addDestination(newDestination);
         }
         if(alternatives > 1)
         {
            newTrip.setRouteModes(this.mRouteModeAlternatives);
         }
         else
         {
            newTrip.setRouteModes(this.mRouteModeSingle);
         }
         this.mRouteCalculationFailed = false;
         if(this.mSecondaryMode != TripAssemblerMode.DESTINATION_VOICE_RECKONED)
         {
            NavigationPackage.peripheral.navigation.navigation.navAdaPlayPrompt(VoicePrompts.ROUTE_IS_BEING_CALCULATED);
         }
         NavigationPackage.peripheral.navigation.navRouteCalculation.createNewTrip(newTrip,true);
      }
      
      private function getLastMenuStackItem() : int
      {
         if(this.mMenuStack.length == 0)
         {
            Framework.Trace("TripAssemblerController.getLastMenuStackItem() EMPTY MENU STACK !");
            return TripAssemblerMenu.UNDEFINED;
         }
         return this.mMenuStack[this.mMenuStack.length - 1];
      }
      
      private function removeLastMenuStackItem() : void
      {
         this.mMenuStack.splice(this.mMenuStack.length - 1);
      }
      
      private function resetMenuStack() : void
      {
         this.mMenuStack.splice(0,this.mMenuStack.length - 1);
         this.mMenuStack.push(TripAssemblerMenu.UNDEFINED);
      }
      
      private function setReCalculationFlag() : void
      {
         if(this.mReCalculationInProgress != true)
         {
            this.mReCalculationInProgress = true;
            this.sendEvent(TripAssemblerEvent.TRIP_IS_RE_CALCULATION_IN_PROGRESS);
         }
      }
      
      private function clearReCalculationFlag() : void
      {
         if(this.mReCalculationInProgress != false)
         {
            this.mReCalculationInProgress = false;
            this.sendEvent(TripAssemblerEvent.TRIP_IS_RE_CALCULATION_IN_PROGRESS);
         }
      }
      
      private function setRouteAlterationFlag() : void
      {
         if(this.mRouteAlterationFlagInProgress != true)
         {
            this.mRouteAlterationFlagInProgress = true;
         }
         this.sendEvent(TripAssemblerEvent.TRIP_ROUTE_ALTERATION_IN_PROGRESS);
      }
      
      private function clearRouteAlterationFlag() : void
      {
         if(this.mRouteAlterationFlagInProgress != false)
         {
            this.mRouteAlterationFlagInProgress = false;
         }
         this.sendEvent(TripAssemblerEvent.TRIP_ROUTE_ALTERATION_IN_PROGRESS);
      }
      
      private function onHmiRequestModuleInterval() : void
      {
         if(NavigationPackage.peripheral.hmiRequest != null)
         {
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.START_GUIDANCE,this.onHmiRequestStartGuidance,false,0,true);
            clearInterval(this.mHmiRequestModuleInterval);
         }
      }
      
      private function onHmiRequestStartGuidance(e:HMIRequestEvent) : void
      {
         Framework.Trace("TripAssemblerController.onHmiRequestStartGuidance()");
         if(this.mCalculationProgress == 100)
         {
            this.startGuidance(0);
            NavigationPackage.peripheral.hmiRequest.navStartGuidanceReturnResult(true);
         }
         else
         {
            this.mHmiRequestStartGuidanceOnCalculated = true;
         }
      }
      
      public function getTrailName() : void
      {
         this.sendEvent(TripAssemblerEvent.TRIP_TRAIL_NAME);
      }
      
      public function get trailName() : String
      {
         if(NavigationPackage.peripheral.navigation.navigation.trailList.length > this.mTrailIndex)
         {
            return String(NavigationPackage.peripheral.navigation.navigation.trailList[this.mTrailIndex]);
         }
         return "";
      }
      
      public function calculateTrailRoute() : void
      {
         Framework.Trace("Nav.TripAssemblerController.calculateTrailRoute()");
      }
      
      private function resetTrailParameters() : void
      {
         this.mTrailIndex = -1;
         this.mTrailMode = -1;
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
      
      private function init() : void
      {
         var modeSet:RouteMode = new RouteMode();
         modeSet.enableMode(RouteMode.ROUTE_FASTEST);
         this.mRouteModeAlternatives.push(modeSet);
         var modeSett:RouteMode = new RouteMode();
         modeSett.enableMode(RouteMode.ROUTE_SHORTEST);
         this.mRouteModeAlternatives.push(modeSett);
         var modeSettt:RouteMode = new RouteMode();
         modeSettt.enableMode(RouteMode.ROUTE_ECO);
         this.mRouteModeAlternatives.push(modeSettt);
         this.setDefaultRouteMode();
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.TRIP_ASSEMBLER);
      }
      
      private function setDefaultRouteMode() : void
      {
         var modeSetSingle:RouteMode = new RouteMode();
         modeSetSingle.enableMode(NavGlobalSettings.DEFAULT_ROUTE_MODE);
         this.mRouteModeSingle = new Array();
         this.mRouteModeSingle.push(modeSetSingle);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var index:int = 0;
         var i:String = null;
         var modeSetSingle:RouteMode = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.TRIP_ASSEMBLER)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.TRIP_ASSEMBLER,true);
            if(res != null)
            {
               index = 0;
               for(i in res)
               {
                  if(i.indexOf("mode") != -1)
                  {
                     Framework.Trace("TripAssemblerController.onPersistence " + int(res[i]));
                     modeSetSingle = new RouteMode();
                     modeSetSingle.overwrite(int(res[i]));
                     modeSetSingle.enableMode(RouteMode.AVOID_TIMERESTRICTED);
                     modeSetSingle.enableMode(RouteMode.AVOID_SEASONALRESTRICTED);
                     this.mRouteModeSingle = new Array();
                     this.mRouteModeSingle.push(modeSetSingle);
                  }
               }
            }
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      public function toPersistence() : void
      {
         var pers:Object = new Object();
         if(this.mRouteModeSingle.length >= 1)
         {
            Framework.Trace("TripAssemblerController.toPersistence " + RouteMode(this.mRouteModeSingle[0]).routeMode);
            pers["mode"] = RouteMode(this.mRouteModeSingle[0]).routeMode;
         }
         PersistenceApi.api.saveData(PersistenceKeys.TRIP_ASSEMBLER,pers);
      }
      
      private function onFactoryReset(e:NavigationEvent) : void
      {
         this.setDefaultRouteMode();
         this.toPersistence();
      }
   }
}

