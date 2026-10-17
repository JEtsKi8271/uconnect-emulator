package com.harman.navigation.routeCalculation
{
   import com.harman.navigation.Controller.NDR.NDRControlEvent;
   import com.harman.navigation.Controller.NDR.util.GPSInfo;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculation;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceEventDispatcherEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class GuidanceRestarter
   {
      
      private static const NAV_INTERVAL_TIME:int = 100;
      
      private var mManager:RouteCalculation;
      
      private var mLoadedRoute:TripRoute = new TripRoute();
      
      private var mPosLat:Number = 0;
      
      private var mPosLong:Number = 0;
      
      private var mStartupInterval:uint = 0;
      
      private var mPersistenceDelayTimer:Timer = null;
      
      private var mPersistenceDelayActivated:Boolean = false;
      
      public function GuidanceRestarter(manager:RouteCalculation)
      {
         super();
         this.mManager = manager;
         PersistenceApi.impl = PersistenceImpl.create();
         this.mStartupInterval = setInterval(this.onInterval,NAV_INTERVAL_TIME);
         this.mPersistenceDelayTimer = new Timer(1000,1);
         this.mPersistenceDelayTimer.addEventListener(TimerEvent.TIMER,this.onPersistenceDelayTimer,false,0,true);
      }
      
      private function onInterval() : void
      {
         if(NavigationPackage.peripheral.navigation != null)
         {
            if(NavigationPackage.peripheral.navigation.navigation != null)
            {
               clearInterval(this.mStartupInterval);
               NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState,false,0,true);
               NavigationPackage.peripheral.navigation.navigation.navGetStartupState();
            }
         }
      }
      
      public function persistRoute(route:Route) : void
      {
         var i:int = 0;
         Framework.Trace("GuidanceRestarter.persistRoute()");
         var pers:Object = new Object();
         for(var r:int = 0; r < route.Destinations.length; r++)
         {
            Framework.Trace("Saved Route: (" + r + ":" + Destination(route.Destinations[r]).toString());
         }
         pers["mode"] = route.routeMode;
         if((route.trailMode == RouteMode.TRAIL_GUIDANCE || route.trailMode == RouteMode.TRAIL_GUIDANCE_FROM_END) && route.trailFilePath != "")
         {
            pers["mode"] = route.trailMode;
            pers["trail"] = route.trailFilePath;
         }
         else
         {
            for(i = 0; i < route.Destinations.length; i++)
            {
               pers[i + "_pri"] = Destination(route.Destinations[i]).hardDestination.getPrimaryLocation().getPersistenceString();
               pers[i + "_sec"] = Destination(route.Destinations[i]).hardDestination.getSecondaryLocation().getPersistenceString();
            }
         }
         NavigationPackage.peripheral.navigation.navPersistence.saveData(PersistenceKeys.ACTIVE_GUIDANCE,pers);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var index:int = 0;
         var i:String = null;
         var r:int = 0;
         var locDet1:LocationDetails = null;
         var tmp1:LocationDescription = null;
         var locDet2:LocationDetails = null;
         var tmp2:LocationDescription = null;
         var modes:Array = null;
         var newMode:RouteMode = null;
         if(NavigationPackage.peripheral.navigation.navPersistence.dataLoaded == PersistenceKeys.ACTIVE_GUIDANCE)
         {
            NavigationPackage.peripheral.navigation.navPersistence.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
            res = NavigationPackage.peripheral.navigation.navPersistence.getDataLoaded(PersistenceKeys.ACTIVE_GUIDANCE,true);
            if(res != null)
            {
               index = 0;
               for(i in res)
               {
                  index = int(i.substr(0,i.indexOf("_")));
                  if(i.indexOf("_pri") != -1)
                  {
                     locDet1 = new LocationDetails();
                     locDet1.setFromPersistenceString(res[i]);
                     while(Destination(this.mLoadedRoute.Destinations[index]) == null)
                     {
                        this.mLoadedRoute.addDestination(new Destination());
                     }
                     tmp1 = LocationDescription(Destination(this.mLoadedRoute.Destinations[index]).hardDestination);
                     if(tmp1 == null)
                     {
                        tmp1 = new LocationDescription();
                     }
                     tmp1.setPrimaryLocation(locDet1);
                  }
                  else if(i.indexOf("_sec") != -1)
                  {
                     locDet2 = new LocationDetails();
                     locDet2.setFromPersistenceString(res[i]);
                     while(Destination(this.mLoadedRoute.Destinations[index]) == null)
                     {
                        this.mLoadedRoute.addDestination(new Destination());
                     }
                     tmp2 = LocationDescription(Destination(this.mLoadedRoute.Destinations[index]).hardDestination);
                     if(tmp2 == null)
                     {
                        tmp2 = new LocationDescription();
                     }
                     tmp2.setSecondaryLocation(locDet2);
                  }
                  else if(i.indexOf("mode") != -1)
                  {
                     modes = new Array();
                     newMode = new RouteMode();
                     newMode.overwrite(int(res[i]));
                     modes.push(newMode);
                     this.mLoadedRoute.setRouteModes(modes);
                  }
                  else if(i.indexOf("trail") != -1)
                  {
                     this.mLoadedRoute.setTrailPath(String(res[i]));
                  }
               }
               for(r = 0; r < this.mLoadedRoute.Destinations.length; r++)
               {
                  Framework.Trace("GuidanceRestarter Loaded Route: (" + r + ":" + Destination(this.mLoadedRoute.Destinations[r]).toString());
               }
               if(this.mLoadedRoute.Destinations.length > 0)
               {
                  NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.addEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig,false,0,true);
                  VServiceGlobalSettings.getNavMarketConfig();
               }
               else if(this.mLoadedRoute.trailPath != "")
               {
                  this.mManager.startupTrailRestart(this.mLoadedRoute.trailPath,RouteMode(this.mLoadedRoute.RouteModes[0]).routeMode);
               }
               else
               {
                  Framework.Trace("GuidanceRestarter -> No destinations.");
                  this.mManager.startupGuidanceRestart(null);
                  this.unregisterEvents();
               }
            }
            else
            {
               Framework.Trace("GuidanceRestarter -> destinations=null");
               if(!this.mPersistenceDelayActivated)
               {
                  this.mPersistenceDelayTimer.start();
                  this.mPersistenceDelayActivated = true;
               }
            }
         }
      }
      
      private function onPersistenceDelayTimer(e:TimerEvent) : void
      {
         Framework.Trace("GuidanceRestarter -> onPersistenceDelayTimer");
         this.mPersistenceDelayTimer.stop();
         this.mPersistenceDelayTimer.removeEventListener(TimerEvent.TIMER,this.onPersistenceDelayTimer);
         NavigationPackage.peripheral.navigation.navPersistence.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         NavigationPackage.peripheral.navigation.navPersistence.loadData(PersistenceKeys.ACTIVE_GUIDANCE);
      }
      
      private function onNavStartupState(evt:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navigation.navStartupState >= StartupState.INIT)
         {
            NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState);
            NavigationPackage.peripheral.navigation.navPersistence.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
            NavigationPackage.peripheral.navigation.navPersistence.loadData(PersistenceKeys.ACTIVE_GUIDANCE);
         }
      }
      
      private function onPositionUpdate(evt:NDRControlEvent) : void
      {
         var data:GPSInfo = NavigationPackage.peripheral.navigation.navNDR.GpsInfo;
         this.mPosLat = Number(String(data.mLatitude / 1000000));
         this.mPosLong = Number(String(data.mLongitude / 1000000));
         Framework.Trace("Pos: lat:" + this.mPosLat + " long:" + this.mPosLong);
         this.checkFirstDestinationDistance();
      }
      
      private function onMarketConfig(evt:VServiceEventDispatcherEvent) : void
      {
         Framework.Trace("GuidanceRestarter.onMarketConfig (" + VServiceGlobalSettings.navMarketConfig + " )");
         if(VServiceGlobalSettings.navMarketConfig != VServiceGlobalSettings.MARKET_UNDEFINED)
         {
            if(NavigationPackage.peripheral.navigation.navNDR != null)
            {
               NavigationPackage.peripheral.navigation.navNDR.enableSubscriptions(true);
               NavigationPackage.peripheral.navigation.navNDR.addEventListener(NDRControlEvent.NDR_GPS_INFO,this.onPositionUpdate,false,0,true);
            }
            else
            {
               Framework.Trace("Nav.GuidanceRestarter.onMarketConfig() NDR-Controller is null! ");
            }
         }
      }
      
      private function checkFirstDestinationDistance() : void
      {
         var destGeo:String = null;
         var distanceReal:Number = NaN;
         var posLong:Number = NaN;
         var posLat:Number = NaN;
         var vehLong:Number = NaN;
         var vehLat:Number = NaN;
         var persRoute:Route = null;
         var dests:Array = null;
         var distanceMin:int = 0;
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
               distanceMin = NavGlobalSettings.GUIDANCE_RESTART_MIN_DISTANCE_ECE;
               break;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               distanceMin = NavGlobalSettings.GUIDANCE_RESTART_MIN_DISTANCE_US;
               break;
            case VServiceGlobalSettings.MARKET_ROW:
               distanceMin = NavGlobalSettings.GUIDANCE_RESTART_MIN_DISTANCE_ROW;
               break;
            default:
               Framework.Trace("Nav.GuidanceRestarter.checkFirstDestinationDistance() No MarketConfig! (Fallback GUIDANCE_RESTART_MIN_DISTANCE_US)");
               distanceMin = NavGlobalSettings.GUIDANCE_RESTART_MIN_DISTANCE_US;
         }
         if(this.mLoadedRoute.Destinations.length > 0)
         {
            destGeo = Destination(this.mLoadedRoute.Destinations[0]).hardDestination.getSecondaryLocation().getType("<GEO>");
            distanceReal = 0;
            posLong = Math.PI / 180 * Number(destGeo.substring(0,destGeo.indexOf(" ")));
            posLat = Math.PI / 180 * Number(destGeo.substring(destGeo.indexOf(" ") + 1,destGeo.length - 1));
            vehLong = Math.PI / 180 * Number(this.mPosLong);
            vehLat = Math.PI / 180 * Number(this.mPosLat);
            distanceReal = Math.cos(posLat) * Math.cos(vehLat) * Math.cos(vehLong - posLong) + Math.sin(posLat) * Math.sin(vehLat);
            if(distanceReal < 0)
            {
               distanceReal *= -1;
            }
            distanceReal = Math.acos(distanceReal) * 6371000;
            Framework.Trace("GuidanceRestarter.checkFirstDestinationDistance() Distance: real(" + distanceReal + ") min(" + distanceMin + ")");
            this.unregisterEvents();
            if(distanceReal < distanceMin)
            {
               Framework.Trace("GuidanceRestart: Removing first Destination due to distance (" + distanceReal + ").");
               this.mLoadedRoute.Destinations.splice(0,1);
               persRoute = new Route();
               dests = new Array();
               persRoute.setRouteMode(RouteMode(this.mLoadedRoute.RouteModes[0]).routeMode);
               persRoute.setDestinations(this.mLoadedRoute.Destinations);
               this.persistRoute(persRoute);
            }
            if(this.mLoadedRoute.Destinations.length > 0)
            {
               this.mManager.startupGuidanceRestart(this.mLoadedRoute);
            }
            else
            {
               this.mManager.startupGuidanceRestart(null);
            }
            return;
         }
         Framework.Trace("GuidanceRestarter.checkFirstDestinationDistance() No destinations");
         this.unregisterEvents();
         this.mManager.startupGuidanceRestart(null);
      }
      
      private function unregisterEvents() : void
      {
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.removeEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig);
         NavigationPackage.peripheral.navigation.navNDR.removeEventListener(NDRControlEvent.NDR_GPS_INFO,this.onPositionUpdate);
         NavigationPackage.peripheral.navigation.navNDR.enableSubscriptions(false);
      }
   }
}

