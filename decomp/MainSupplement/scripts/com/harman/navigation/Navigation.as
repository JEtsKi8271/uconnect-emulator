package com.harman.navigation
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.authentication.AuthenticationServiceManager;
   import com.harman.navigation.authentication.authenticationManager;
   import com.harman.navigation.dbService.DBItem;
   import com.harman.navigation.dbService.DBServiceManager;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceEventDispatcherEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.graphicalWeather.GraphicalWeatherManager;
   import com.harman.navigation.instrumentCluster.instrumentClusterManager;
   import com.harman.navigation.liveServices.LiveServicesManager;
   import com.harman.navigation.locationInput.LocationInputManager;
   import com.harman.navigation.map.MapManager;
   import com.harman.navigation.overTheAirUpdate.OverTheAirUpdateManager;
   import com.harman.navigation.poi.PoiManager;
   import com.harman.navigation.position.PositionManager;
   import com.harman.navigation.routeCalculation.RouteCalculationManager;
   import com.harman.navigation.tmc.TmcManager;
   import com.harman.navigation.trail.TrailManager;
   import com.harman.navigation.utils.DeferredPersistenceHandler;
   import com.harman.navigation.utils.DemoModeHelper;
   import com.harman.navigation.voiceGuidance.VoiceGuidanceManager;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class Navigation extends NavigationBase implements INavigation
   {
      
      private static const dbusIdentifier:String = "Navigation";
      
      public static const dbusAuthenticationIdentifier:String = "Authentication";
      
      private static const dbusNavigationClusterIdentifier:String = "NavigationCluster";
      
      private static const dbusNavigationGraphicalWeatherIdentifier:String = "graphicalWeather";
      
      public static const dbusNavigationTrailInfoIdentifier:String = "NavTrailInfo";
      
      public static const dbusNavigationDBServiceIdentifier:String = "NavigationDBService";
      
      private static const dbusPlatformDbusIdentifier:String = "platform";
      
      public static const dbusUConnectACNDbusIdentifier:String = "UConnectACN";
      
      public static const dbusTomTomLiveServiceDbusIdentifier:String = "ttls";
      
      private var mNavIsReadyState:int = 0;
      
      private var mGuidanceRestarterInterval:uint = 0;
      
      private var mNavVersions:Object = new Object();
      
      private var localDemoModeEnabled:Boolean = false;
      
      private var localDemoModeEnabledRequest:Boolean = false;
      
      private var localDemoModeCoordinate:String = "";
      
      private var localNavLicenseActivated:Boolean = true;
      
      private var mDeferredPersistenceHandler:DeferredPersistenceHandler = null;
      
      private var connection:Connection;
      
      private var mWatchdog:Watchdog = null;
      
      private var name:String = "FiatDemoClient";
      
      private var client:Client;
      
      private var mInterval:uint = 999;
      
      private var mActivationInterval:uint = 999;
      
      public function Navigation()
      {
         super();
         mAuthenticationManager = new authenticationManager(this);
         mAuthenticationServiceManager = new AuthenticationServiceManager(this);
         mInstrumentClusterManager = new instrumentClusterManager(this);
         mGraphicalWeatherManager = new GraphicalWeatherManager(this);
         mTrailManager = new TrailManager(this);
         mDBServiceManager = new DBServiceManager(this);
         mMapManager = new MapManager(this);
         this.mWatchdog = new Watchdog(this);
         mLiveServicesManger = new LiveServicesManager(this);
         this.mDeferredPersistenceHandler = new DeferredPersistenceHandler(this);
         this.connection = Connection.share();
         this.client = this.connection.span;
         if(this.client.connected)
         {
            this.isConnected();
         }
         else
         {
            this.client.addEventListener(Event.CONNECT,this.connected);
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.NAVIGATION,this.navigationMessageHandler);
         this.connection.addEventListener(ConnectionEvent.NAVIGATION_CLUSTER,mInstrumentClusterManager.instrumentClusterMessageHandler);
         this.connection.addEventListener(ConnectionEvent.GRAPHICAL_WEATHER,mGraphicalWeatherManager.graphicalWeatherMessageHandler);
         this.connection.addEventListener(ConnectionEvent.NAV_TRAIL_INFO,mTrailManager.trailInfoMessageHandler);
         this.connection.addEventListener(ConnectionEvent.NAVIGATION_DB_SERVICE,mDBServiceManager.dbServiceMessageHandler);
         this.connection.addEventListener(ConnectionEvent.PLATFORM,this.platformMessageHandler);
         this.connection.addEventListener(ConnectionEvent.NAVIGATION_AUTHENTICATION,mAuthenticationServiceManager.authenticationMessageHandler);
         this.connection.addEventListener(ConnectionEvent.UCONNECT_ACN,mLiveServicesManger.liveServicesMessageHandlerACN);
         this.connection.addEventListener(ConnectionEvent.TOMTOM_LIVE_SERVICE,mLiveServicesManger.liveServicesMessageHandlerTTLS);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.isConnected();
      }
      
      private function isConnected() : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               Framework.Trace("INavigation.CONNECTED");
               if(this.mNavIsReadyState < StartupState.CONNECTED)
               {
                  this.mNavIsReadyState = StartupState.CONNECTED;
                  this.getProperty("ETC_IsActivated");
                  if(this.mActivationInterval == 999)
                  {
                     this.mActivationInterval = setInterval(this.onActivationInterval,3000);
                  }
                  if(mRouteCalculationManager == null)
                  {
                     mRouteCalculationManager = new RouteCalculationManager(this);
                  }
                  this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
                  this.sendEvent(NavigationEvent.NAV_STARTUP_STATE);
               }
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function timerListener() : void
      {
         this.getProperty("ETC_IsOperable");
      }
      
      private function onActivationInterval() : void
      {
         this.getProperty("ETC_IsActivated");
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         this.name = this.connection.configuration.@name.toString();
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function createManagers() : void
      {
         mPoiManager = new PoiManager(this);
         mPositionManager = new PositionManager(this);
         mLocationInputManager = new LocationInputManager(this);
         mOverTheAirUpdateManager = new OverTheAirUpdateManager(this);
         mDemoModeHelper = new DemoModeHelper(this);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(false == hasEventListener(type))
         {
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(false == hasEventListener(type))
         {
         }
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return true;
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
      
      public function setDemoMode(enable:Boolean) : void
      {
         var message:String = null;
         Framework.Trace("Navigation: setDemoMode: " + enable.toString());
         this.localDemoModeEnabledRequest = enable;
         if(this.localDemoModeCoordinate != "")
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {\"ETC_SetDemoMode\":{\"enableDemoMode\":" + this.localDemoModeEnabledRequest.toString() + ", \"startLocation\":\"<GEO>" + this.localDemoModeCoordinate + "<*>\"}}}";
            this.client.send(message);
         }
         else
         {
            NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.addEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig,false,0,true);
            VServiceGlobalSettings.getNavMarketConfig();
         }
      }
      
      public function onMarketConfig(e:VServiceEventDispatcherEvent) : void
      {
         var message:String = null;
         Framework.Trace("Navigation.onMarketConfig( " + VServiceGlobalSettings.navMarketConfig + " )");
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
               NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.removeEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig);
               message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {\"ETC_SetDemoMode\":{\"enableDemoMode\":" + this.localDemoModeEnabledRequest.toString() + ", \"startLocation\":\"<GEO>" + NavGlobalSettings.DEMO_MODE_COORDINATE_EUROPE + "<*>\"}}}";
               this.client.send(message);
               break;
            case VServiceGlobalSettings.MARKET_ROW:
               NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.removeEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig);
               message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {\"ETC_SetDemoMode\":{\"enableDemoMode\":" + this.localDemoModeEnabledRequest.toString() + ", \"startLocation\":\"<GEO>" + NavGlobalSettings.DEMO_MODE_COORDINATE_ROW + "<*>\"}}}";
               this.client.send(message);
               break;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.removeEventListener(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG,this.onMarketConfig);
               message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {\"ETC_SetDemoMode\":{\"enableDemoMode\":" + this.localDemoModeEnabledRequest.toString() + ", \"startLocation\":\"<GEO>" + NavGlobalSettings.DEMO_MODE_COORDINATE_NORTH_AMERICA + "<*>\"}}}";
               this.client.send(message);
               break;
            default:
               Framework.Trace("MarketConfig not supported: Fallback to MARKET_NORTH_AMERICA");
               message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {\"ETC_SetDemoMode\":{\"enableDemoMode\":" + this.localDemoModeEnabledRequest.toString() + ", \"startLocation\":\"<GEO>" + NavGlobalSettings.DEMO_MODE_COORDINATE_NORTH_AMERICA + "<*>\"}}}";
         }
      }
      
      public function getDemoMode() : void
      {
         var message:String = null;
         Framework.Trace("getDemoMode()");
         message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"ETC_IsDemoModeEnabled\"]}}}";
         this.client.send(message);
      }
      
      public function get demoMode() : Boolean
      {
         return false;
      }
      
      public function navigationMessageHandler(e:ConnectionEvent) : void
      {
         var info:String = null;
         var outprop:Object = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("POS_PositionInformation"))
         {
            if(mPositionManager != null)
            {
               mPositionManager.setPositionInfo(resp.POS_PositionInformation);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_HighwayModeUpdate"))
         {
            if(mPositionManager != null)
            {
               mPositionManager.setHighwayModeUpdate(resp.ETC_HighwayModeUpdate);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_NextHighwayManeuverInfo"))
         {
            if(mPositionManager != null)
            {
               mPositionManager.updateHighwayList(resp.RT_NextHighwayManeuverInfo);
            }
            return;
         }
         if(resp.hasOwnProperty("ADA_PromptReady") || resp.hasOwnProperty("ADA_ActiveAudioSource") || resp.hasOwnProperty("ADA_IsEnabled"))
         {
            mVoiceGudanceManager.onPromptReady(resp);
            return;
         }
         if(resp.hasOwnProperty("ADA_PlayPrompt"))
         {
            return;
         }
         if(resp.hasOwnProperty("MAP_Controls"))
         {
            mMapManager.setMapControlsInfo(resp);
            return;
         }
         if(resp.hasOwnProperty("MAP_PositionInfo"))
         {
            mMapManager.setMapPositionInfo(resp);
            return;
         }
         if(resp.hasOwnProperty("MAP_SetWorldElementProperties"))
         {
            mMapManager.setMAP_SetWorldElementProperties(resp);
            return;
         }
         if(resp.hasOwnProperty("Info_GetAvailableInformation"))
         {
            if(resp.Info_GetAvailableInformation.hasOwnProperty("respEIS"))
            {
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>LI<*>") >= 0)
               {
                  mLocationInputManager.onInfo_GetAvailableInformation(resp);
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>POI<*>") >= 0)
               {
                  mPoiManager.setResponseInfo(resp);
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>RT<*>") >= 0)
               {
                  mRouteCalculationManager.onInfo_GetAvailableInformation(resp);
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>MAP<*>") >= 0)
               {
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>TMC<*>") >= 0)
               {
                  mTmcManager.onInfo_GetAvailableInformation(resp);
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>DB<*>") >= 0)
               {
                  this.parseDbVersions(resp);
                  return;
               }
               if(resp.Info_GetAvailableInformation.respEIS.indexOf("<IFT>HWM<*>") >= 0)
               {
                  mPositionManager.onInfo_GetAvailableInformation(resp);
                  return;
               }
            }
            return;
         }
         if(resp.hasOwnProperty("Info_GetDetails"))
         {
            if(resp.Info_GetDetails.hasOwnProperty("respEIS"))
            {
               if(resp.Info_GetDetails.respEIS.indexOf("<IFT>LI<*>") >= 0)
               {
                  mLocationInputManager.onInfo_GetDetails(resp);
                  return;
               }
               if(resp.Info_GetDetails.respEIS.indexOf("<IFT>POI<*>") >= 0)
               {
                  mPoiManager.setResponseInfo(resp);
                  return;
               }
               if(resp.Info_GetDetails.respEIS.indexOf("<IFT>RT<*>") >= 0)
               {
                  mRouteCalculationManager.onInfo_GetDetails(resp);
                  return;
               }
               if(resp.Info_GetDetails.respEIS.indexOf("<IFT>MAP<*>") >= 0)
               {
                  mMapManager.onInfo_GetDetails(resp);
                  return;
               }
               if(resp.Info_GetDetails.respEIS.indexOf("<IFT>TMC<*>") >= 0)
               {
                  mTmcManager.onInfo_GetDetails(resp);
                  return;
               }
            }
            return;
         }
         if(resp.hasOwnProperty("Info_GetList"))
         {
            if(resp.Info_GetList.hasOwnProperty("respEIS"))
            {
               if(resp.Info_GetList.respEIS.indexOf("<IFT>HWM<*>") >= 0)
               {
                  mPositionManager.onInfo_GetList(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>LI<*>") >= 0)
               {
                  mLocationInputManager.onInfo_GetList(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>POI<*>") >= 0)
               {
                  mPoiManager.setResponseInfo(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>RT<*>") >= 0)
               {
                  mRouteCalculationManager.onInfo_GetList(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>MAP<*>") >= 0)
               {
                  mMapManager.onInfo_GetList(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>TMC<*>") >= 0)
               {
                  mTmcManager.onInfo_GetList(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>DB<*>") >= 0)
               {
                  this.parseDbVersions(resp);
                  return;
               }
               if(resp.Info_GetList.respEIS.indexOf("<IFT>OTA<*>") >= 0)
               {
                  mOverTheAirUpdateManager.onInfo_GetList(resp);
                  return;
               }
            }
            return;
         }
         if(resp.hasOwnProperty("Info_GetSpell"))
         {
            if(resp.Info_GetSpell.hasOwnProperty("respEIS"))
            {
               if(resp.Info_GetSpell.respEIS.indexOf("<IFT>LI<*>") >= 0)
               {
                  mLocationInputManager.onInfo_GetSpell(resp);
                  return;
               }
               if(resp.Info_GetSpell.respEIS.indexOf("<IFT>POI<*>") >= 0)
               {
                  mPoiManager.setResponseInfo(resp);
                  return;
               }
               if(resp.Info_GetSpell.respEIS.indexOf("<IFT>RT<*>") >= 0)
               {
                  mRouteCalculationManager.onInfo_GetSpell(resp);
                  return;
               }
               if(resp.Info_GetSpell.respEIS.indexOf("<IFT>MAP<*>") >= 0)
               {
                  return;
               }
               if(resp.Info_GetSpell.respEIS.indexOf("<IFT>TMC<*>") >= 0)
               {
                  mTmcManager.onInfo_GetSpell(resp);
                  return;
               }
            }
            return;
         }
         if(resp.hasOwnProperty("RT_NewTrip"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_NewTrip(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_NewTripFile"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_NewTripFile(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_BlockRoute"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_BlockRoute(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_StartGuidance"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_StartGuidance(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_DestroyTrip"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_DestroyTrip(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_CalculationState"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_CalculationState(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_ActiveRouteDescription"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_ActiveRouteDescription(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_NextManeuverInfo"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_NextManeuverInfo(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_NextDestinationInfo"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_NextDestinationInfo(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_DestinationReached"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_DestinationReached(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_RequestChangeTrip"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_RequestChangeTrip(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("JSON_GetProperties"))
         {
            if(resp.JSON_GetProperties.hasOwnProperty("outprop"))
            {
               this.distribute_JSON_Prop(resp.JSON_GetProperties.outprop);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_EventsNew"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onTmcEventsUpdate(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_SetTMCInfoNotification"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onSetTMCInfoNotification(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_SetTMCRouteMode"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onSetTMCRouteMode(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_RoutesAvailable"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onRoutesAvailable(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_RoutesDeleted"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onRoutesDeleted(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_RouteAccepted"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onRouteAccepted(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_EventsNew"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onSignal(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_EventsDeleted"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onSignal(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_InfoChanged"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onSignal(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_AvoidMode"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onAvoidMode(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_TuningMode"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onTuningMode(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("TMC_SetTMCTuningMode"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onTuningMode(resp);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_StartRecording"))
         {
            if(mTrailManager != null)
            {
               mTrailManager.onStartRecording(resp.RT_StartRecording);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_RecordingActive"))
         {
            if(mTrailManager != null)
            {
               mTrailManager.onRecordingActive(resp.RT_RecordingActive);
            }
            return;
         }
         if(resp.hasOwnProperty("RT_RecordingComplete"))
         {
            if(mTrailManager != null)
            {
               mTrailManager.onRecordingComplete(resp.RT_RecordingComplete);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_IsOperable"))
         {
            Framework.Trace("Navigation.hasOwnProperty -> ETC_IsOperable");
            if(resp.ETC_IsOperable.isEnabled)
            {
               Framework.Trace(" -> signal ETC_IsOperable: " + resp.ETC_IsOperable.isEnabled);
               this.setNavOperable();
            }
            else
            {
               this.sendSubscribe("\"ETC_IsOperable\"");
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_IsActivated"))
         {
            Framework.Trace("Navigation.hasOwnProperty -> ETC_IsActivated (" + resp.ETC_IsActivated.isActivated + ")");
            outprop = new Object();
            if(resp.ETC_IsActivated.isActivated == 1)
            {
               outprop = true;
            }
            else
            {
               outprop = false;
            }
            this.parseETC_IsActivated(outprop);
            return;
         }
         if(resp.hasOwnProperty("ADA_SetEnabled"))
         {
            if(resp.ADA_SetEnabled.hasOwnProperty("enable"))
            {
               Framework.Trace(" -> ADA_SetEnabled: " + resp.ADA_SetEnabled.enable);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_SetVehicleSpeedWarningMode"))
         {
            if(Boolean(resp.ETC_SetVehicleSpeedWarningMode.hasOwnProperty("mode")) && Boolean(resp.ETC_SetVehicleSpeedWarningMode.hasOwnProperty("speed")))
            {
               Framework.Trace(" -> ETC_SetVehicleSpeedWarningMode: " + resp.ETC_SetVehicleSpeedWarningMode.mode + " speed: " + resp.ETC_SetVehicleSpeedWarningMode.speed);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_IsDemoModeEnabled"))
         {
            if(resp.ETC_IsDemoModeEnabled.hasOwnProperty("isEnabled"))
            {
               Framework.Trace(" -> ETC_IsDemoModeEnabled: " + resp.ETC_IsDemoModeEnabled.isEnabled);
            }
            return;
         }
         if(resp.hasOwnProperty("UPD_ActivationCheck"))
         {
            mAuthenticationManager.onActivationCheck(resp.UPD_ActivationCheck);
            return;
         }
         if(resp.hasOwnProperty("UPD_SetActivationCode"))
         {
            mAuthenticationManager.onSetAuthenticationCodeResponse(resp);
            return;
         }
         if(resp.hasOwnProperty("ETC_SetDemoMode"))
         {
            if(resp.ETC_SetDemoMode.hasOwnProperty("enableDemoMode"))
            {
               Framework.Trace(" -> enableDemoMode: " + resp.ETC_SetDemoMode.enableDemoMode + " loc: " + resp.ETC_SetDemoMode.startLocation);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_SetMetricSystem"))
         {
            Framework.Trace(" -> ETC_SetMetricSystem: " + resp.ETC_SetMetricSystem.metricSystem);
            return;
         }
         if(resp.hasOwnProperty("ETC_SetLanguage"))
         {
            if(mVoiceGudanceManager != null)
            {
               mVoiceGudanceManager.onSetLanguage(resp.ETC_SetLanguage);
            }
            return;
         }
         if(resp.hasOwnProperty("ETC_LanguageInfo"))
         {
            if(mVoiceGudanceManager != null)
            {
               mVoiceGudanceManager.onLanguageInfo(resp.ETC_LanguageInfo);
            }
            return;
         }
         if(resp.hasOwnProperty("OTA_DownloadUpdatePackage"))
         {
            if(mOverTheAirUpdateManager != null)
            {
               mOverTheAirUpdateManager.responseDownloadUpdatePackage(resp.OTA_DownloadUpdatePackage);
            }
            return;
         }
         if(resp.hasOwnProperty("OTA_DownloadUpdateStatus"))
         {
            mOverTheAirUpdateManager.informDownloadUpdateStatus(resp.OTA_DownloadUpdateStatus);
            return;
         }
         if(resp.hasOwnProperty("OTA_DownloadUpdateReady"))
         {
            mOverTheAirUpdateManager.informDownloadUpdateReady(resp.OTA_DownloadUpdateReady);
            return;
         }
         if(resp.hasOwnProperty("ETC_SetSafetyCameraMode"))
         {
            mVoiceGudanceManager.informSafetyCameraMode(resp.ETC_SetSafetyCameraMode);
            return;
         }
         if(resp.hasOwnProperty("ETC_SetAlertProperties"))
         {
            mLiveServicesManger.informSetAlertProperties(resp.ETC_SetAlertProperties);
            return;
         }
         Framework.Trace(" Navigation.as -> You should not read this!\nUnhandled Events:");
         for(info in resp)
         {
            Framework.Trace(" -" + info + " not handled!");
         }
      }
      
      public function platformMessageHandler(e:ConnectionEvent) : void
      {
         var tmp:Object = null;
         var info:Object = e.data;
         tmp = null;
         if(info.hasOwnProperty("factory_reset"))
         {
            Framework.Trace("Navigation.factory_reset");
            this.performFactoryReset();
            this.sendEvent(NavigationEvent.NAV_FACTORY_RESET);
         }
      }
      
      private function distribute_JSON_Prop(outprop:Object) : void
      {
         if(outprop.hasOwnProperty("POS_PositionInformation"))
         {
            if(mPositionManager != null)
            {
               mPositionManager.setPositionInfo(outprop);
            }
            return;
         }
         if(outprop.hasOwnProperty("ETC_HighwayModeUpdate"))
         {
            if(mPositionManager != null)
            {
               mPositionManager.setHighwayModeProperty(outprop);
            }
            return;
         }
         if(outprop.hasOwnProperty("TMC_TuningMode"))
         {
            if(mTmcManager != null)
            {
               mTmcManager.onTuningMode(outprop);
            }
            return;
         }
         if(outprop.hasOwnProperty("RT_CalculationState"))
         {
            if(mRouteCalculationManager != null)
            {
               mRouteCalculationManager.onRT_CalculationState(outprop.RT_CalculationState);
            }
            return;
         }
         if(outprop.hasOwnProperty("ETC_SoftwareVersion"))
         {
            this.parseDbVersions(outprop);
            return;
         }
         if(outprop.hasOwnProperty("ETC_DatabaseVersion"))
         {
            this.parseDbVersions(outprop);
            return;
         }
         if(outprop.hasOwnProperty("ETC_IsOperable"))
         {
            this.parseETC_IsOperable(outprop.ETC_IsOperable);
            return;
         }
         if(outprop.hasOwnProperty("ETC_IsActivated"))
         {
            this.parseETC_IsActivated(outprop.ETC_IsActivated);
            return;
         }
         if(outprop.hasOwnProperty("UPD_ActivationCheck"))
         {
            this.parseUPD_ActivationCheck(outprop.UPD_ActivationCheck);
            return;
         }
      }
      
      public function sendServiceCommand(dbusIdentifier:String, command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": {" + command + "}}";
         this.client.send(message);
         Framework.Trace(dbusIdentifier + ".sendCommand: " + command);
         if(this.mNavIsReadyState < StartupState.INIT)
         {
            reportWarning("CmdSentBeforeRDY: " + message);
         }
      }
      
      public function sendServiceCommandObject(command:Object) : void
      {
         if(command != null)
         {
            this.connection.send(command);
         }
      }
      
      public function sendServiceSubscribe(dbusIdentifier:String, signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signal + "\"}";
         this.client.send(message);
         Framework.Trace(dbusIdentifier + ".sendSubscribe: " + signal);
      }
      
      public function sendServiceUnsubscribe(dbusIdentifier:String, signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signal + "\"}";
         this.client.send(message);
         Framework.Trace(dbusIdentifier + ".sendUnsubscribe: " + signal);
      }
      
      public function sendCommand(command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": {" + command + "}}";
         this.client.send(message);
         Framework.Trace("Navigation.sendCommand: " + command);
         if(this.mNavIsReadyState < StartupState.INIT)
         {
            reportWarning("CmdSentBeforeRDY: " + message);
         }
      }
      
      public function sendSubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"Navigation\", \"Signal\":" + signal + "}";
         this.client.send(message);
         Framework.Trace("Navigation.sendSubscribe: " + signal);
      }
      
      public function sendUnsubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"Navigation\", \"Signal\":" + signal + "}";
         this.client.send(message);
         Framework.Trace("Navigation.sendUnsubscribe: " + signal);
      }
      
      public function sendCommandNavCluster(command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusNavigationClusterIdentifier + "\", \"packet\": {" + command + "}}";
         this.client.send(message);
         Framework.Trace("NavigationCluster.sendCommand: " + command);
      }
      
      public function getPropertyNavCluster(property:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusNavigationClusterIdentifier + "\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"" + property + "\"]}}}";
         this.client.send(message);
      }
      
      public function sendSubscribeGW(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusNavigationGraphicalWeatherIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function sendUnsubscribeGW(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusNavigationGraphicalWeatherIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function sendCommandNavGW(command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusNavigationGraphicalWeatherIdentifier + "\", \"packet\": {" + command + "}}";
         this.client.send(message);
         Framework.Trace("GraphicalWeather.sendCommand: " + command);
      }
      
      public function getPropertyNavGW(property:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusNavigationGraphicalWeatherIdentifier + "\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"" + property + "\"]}}}";
         this.client.send(message);
      }
      
      public function getProperty(property:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"" + property + "\"]}}}";
         this.client.send(message);
      }
      
      public function sendEvent(eventType:String, payload:Object = null) : void
      {
         dispatchEvent(new NavigationEvent(eventType,payload));
      }
      
      public function performDoubleQuoteCheck(input:String) : String
      {
         return input.split("\"").join("\\\"");
      }
      
      public function get voiceGudanceManager() : VoiceGuidanceManager
      {
         return mVoiceGudanceManager;
      }
      
      public function get tmcManager() : TmcManager
      {
         return mTmcManager;
      }
      
      public function navGetIsReady() : void
      {
         this.sendEvent(NavigationEvent.NAV_IS_READY);
      }
      
      public function get navIsReady() : Boolean
      {
         if(this.mNavIsReadyState == StartupState.PARTIALLY_READY || this.mNavIsReadyState == StartupState.FULLY_READY)
         {
            return true;
         }
         return false;
      }
      
      public function navGetIsActivated() : void
      {
         this.sendEvent(NavigationEvent.NAV_ACTIVATION);
      }
      
      public function get navIsActivated() : Boolean
      {
         return this.localNavLicenseActivated;
      }
      
      public function navFakeLicenseExpiration() : void
      {
         this.localNavLicenseActivated = false;
      }
      
      public function navGetStartupState() : void
      {
         this.sendEvent(NavigationEvent.NAV_STARTUP_STATE);
      }
      
      public function get navStartupState() : int
      {
         return this.mNavIsReadyState;
      }
      
      private function parseETC_IsOperable(outprop:Object) : void
      {
         if(String(outprop) == "true")
         {
            this.setNavOperable();
         }
      }
      
      private function parseUPD_ActivationCheck(outprop:Object) : void
      {
         if(outprop.hasOwnProperty("skuEIS"))
         {
            if(mAuthenticationManager != null)
            {
               mAuthenticationManager.setDeviceID(outprop.skuEIS as Array);
            }
         }
      }
      
      private function parseETC_IsActivated(outprop:Object) : void
      {
         Framework.Trace("Navigation.parseETC_IsActivated( " + String(outprop) + " )");
         clearInterval(this.mActivationInterval);
         if(String(outprop) == "true")
         {
            this.getProperty("ETC_IsOperable");
            if(this.mInterval == 999)
            {
               this.mInterval = setInterval(this.timerListener,8000);
            }
            this.localNavLicenseActivated = true;
         }
         else
         {
            this.sendSubscribe("\"ETC_IsActivated\"");
            this.mNavIsReadyState = StartupState.LOCKED;
            this.sendEvent(NavigationEvent.NAV_STARTUP_STATE);
            this.localNavLicenseActivated = false;
         }
         this.sendEvent(NavigationEvent.NAV_ACTIVATION);
      }
      
      public function navGetDemoMode() : void
      {
         this.sendEvent(NavigationEvent.NAV_DEMO_MODE);
      }
      
      public function get navDemoMode() : Boolean
      {
         return this.localDemoModeEnabled;
      }
      
      public function navSetDemoMode(enable:Boolean) : void
      {
         this.localDemoModeEnabled = enable;
         this.setDemoMode(this.localDemoModeEnabled);
         this.savePersistence();
         this.sendEvent(NavigationEvent.NAV_DEMO_MODE);
      }
      
      public function navSetDemoModePosition(enable:Boolean, position:String, sendToDMPositionHelper:Boolean = false) : void
      {
         this.localDemoModeEnabled = enable;
         this.localDemoModeCoordinate = position;
         this.setDemoMode(this.localDemoModeEnabled);
         this.savePersistence();
         this.sendEvent(NavigationEvent.NAV_DEMO_MODE);
         if(sendToDMPositionHelper)
         {
            mDemoModeHelper.renamePosition(position,position);
         }
      }
      
      public function get navDemoModePosition() : String
      {
         return this.localDemoModeCoordinate;
      }
      
      public function navAdaRepeat() : void
      {
         if(mVoiceGudanceManager)
         {
            mVoiceGudanceManager.adaRepeat();
         }
      }
      
      public function navGetAdaState() : void
      {
         if(mVoiceGudanceManager)
         {
            mVoiceGudanceManager.getAdaState();
         }
      }
      
      public function get navAdaState() : Boolean
      {
         return mVoiceGudanceManager.adaGetState();
      }
      
      public function navSetAdaState(enable:Boolean) : void
      {
         if(mVoiceGudanceManager)
         {
            mVoiceGudanceManager.setAdaState(enable);
         }
      }
      
      public function navGetAdaSpeaking() : Boolean
      {
         return mVoiceGudanceManager.adaGetSpeaking();
      }
      
      public function navGetNavVersions() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"Navigation\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"ETC_SoftwareVersion\", \"ETC_DatabaseVersion\"]}}}");
      }
      
      public function get navVersions() : Object
      {
         var simplifiedString:String = null;
         var semiColonStartIndex:int = 0;
         var semiColonEndIndex:int = 0;
         var appendage:String = null;
         var yearIndex:int = 0;
         var year:int = 0;
         var QStringIndex:int = 0;
         var QString:String = null;
         if(this.mNavVersions.hasOwnProperty("ETC_DatabaseVersion") && this.mNavVersions.hasOwnProperty("ETC_SimpleDatabaseVersion") == false)
         {
            semiColonStartIndex = int(this.mNavVersions["ETC_DatabaseVersion"].indexOf(";"));
            semiColonEndIndex = int(this.mNavVersions["ETC_DatabaseVersion"].lastIndexOf(";"));
            if(semiColonStartIndex != -1 && semiColonEndIndex != -1 && semiColonStartIndex < semiColonEndIndex)
            {
               simplifiedString = this.mNavVersions["ETC_DatabaseVersion"].substring(0,semiColonEndIndex);
               appendage = simplifiedString.substring(semiColonStartIndex + 1);
               if(appendage.length >= 4)
               {
                  yearIndex = appendage.search(/[0-9]{4}/);
                  if(yearIndex != -1)
                  {
                     year = int(appendage.substr(yearIndex,4));
                     year = (year - 2012) * 2;
                     QStringIndex = appendage.search(/Q[0-9]/);
                     if(QStringIndex != -1)
                     {
                        QString = appendage.substr(QStringIndex,2);
                        if(QString == "Q3" || QString == "Q4")
                        {
                           year += 1;
                        }
                     }
                     this.mNavVersions["ETC_SimpleDatabaseVersion"] = simplifiedString.substring(0,semiColonStartIndex + 1) + "V" + year.toString(10);
                  }
                  else
                  {
                     this.mNavVersions["ETC_SimpleDatabaseVersion"] = "Undefined";
                  }
               }
               else
               {
                  this.mNavVersions["ETC_SimpleDatabaseVersion"] = simplifiedString;
               }
            }
         }
         return this.mNavVersions;
      }
      
      private function parseDbVersions(resp:Object) : void
      {
         this.mNavVersions = resp;
         this.sendEvent(NavigationEvent.NAV_VERSIONS);
      }
      
      public function get dbServiceState() : int
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.state;
         }
         return StartupState.UNDEFINED;
      }
      
      public function get isDbServiceReady() : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.isReady;
         }
         return false;
      }
      
      public function getDestinationList() : Vector.<DBItem>
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.getDestinationList();
         }
         return null;
      }
      
      public function getHome() : DBItem
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.getHome();
         }
         return null;
      }
      
      public function getDBCounts(type:String) : int
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.getCounts(type);
         }
         return -1;
      }
      
      public function getDBMaxLimits(type:String) : int
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.getMaxLimit(type);
         }
         return -1;
      }
      
      public function addDestination(type:String, item:FavoriteDestination) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.addDestination(type,item);
         }
         return false;
      }
      
      public function removeDestination(type:String, index:int) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.removeDestination(type,index);
         }
         return false;
      }
      
      public function removeAllDestinations(type:String) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.deleteAll(type);
         }
         return false;
      }
      
      public function requestItems(type:String, startId:int = 0, numberOfItems:int = -1) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.requestItems(type,startId,numberOfItems);
         }
         return false;
      }
      
      public function moveDestination(type:String, item:FavoriteDestination, moveOperation:String) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.moveDestination(type,item,moveOperation);
         }
         return false;
      }
      
      public function updateDestination(type:String, newFavorite:FavoriteDestination) : Boolean
      {
         if(mDBServiceManager != null)
         {
            return mDBServiceManager.updateDestination(type,newFavorite);
         }
         return false;
      }
      
      public function sendTestCall() : void
      {
      }
      
      private function setNavOperable() : void
      {
         if(this.mNavIsReadyState == StartupState.CONNECTED || this.mNavIsReadyState == StartupState.LOCKED)
         {
            Framework.Trace("Navigation ETC_IsOperable");
            clearInterval(this.mInterval);
            this.sendServiceSubscribe(dbusPlatformDbusIdentifier,"factory_reset");
            this.startupPhaseTwo();
            this.sendEvent(NavigationEvent.NAV_STARTUP_STATE);
            this.sendEvent(NavigationEvent.NAV_IS_READY);
            if(mDBServiceManager.isReady == false)
            {
               mDBServiceManager.init();
            }
         }
         else
         {
            Framework.Trace("Navigation setNavOperable() called while in state \'" + this.mNavIsReadyState + "\'");
         }
      }
      
      private function startupPhaseTwo() : void
      {
         this.mGuidanceRestarterInterval = setInterval(this.onGuidanceRestarterTimeout,NavGlobalSettings.GUIDANCE_RESTARTER_TIMEOUT);
         this.mNavIsReadyState = StartupState.INIT;
         mAuthenticationManager.init();
         mVoiceGudanceManager = new VoiceGuidanceManager(this);
         mTmcManager = new TmcManager(this);
         this.requestPersistence();
      }
      
      public function reportGuidanceRestarterFinished() : void
      {
         Framework.Trace("Navigation reportGuidanceRestarterFinished");
         this.startupPhaseThree();
      }
      
      private function onGuidanceRestarterTimeout() : void
      {
         Framework.Trace("Navigation onGuidanceRestarterTimeout");
         this.startupPhaseThree();
      }
      
      private function startupPhaseThree() : void
      {
         if(this.mGuidanceRestarterInterval != 9999)
         {
            clearInterval(this.mGuidanceRestarterInterval);
            this.mGuidanceRestarterInterval = 9999;
            this.setNavPartiallyReady();
         }
      }
      
      private function setNavPartiallyReady() : void
      {
         if(this.mNavIsReadyState == StartupState.INIT)
         {
            Framework.Trace("Navigation NAV_STATE_PARTIALLY_READY");
            this.createManagers();
            this.mNavIsReadyState = StartupState.PARTIALLY_READY;
            if(this.mWatchdog)
            {
               this.mWatchdog.init();
            }
            this.sendEvent(NavigationEvent.NAV_STARTUP_STATE);
            this.sendEvent(NavigationEvent.NAV_IS_READY);
            if(mDBServiceManager.isReady == false)
            {
               mDBServiceManager.init();
            }
            mAuthenticationServiceManager.getProductID();
            mAuthenticationServiceManager.getProductDeviceID();
         }
         else
         {
            Framework.Trace("Navigation setNavPartiallyReady() called while in state \'" + this.mNavIsReadyState + "\'");
         }
      }
      
      private function requestPersistence() : void
      {
         PersistenceApi.impl = PersistenceImpl.create();
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.NAV_COMMON);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var processedSpeedWarning:Boolean = false;
         var processedTmcSettings:Boolean = false;
         var i:String = null;
         var tmp:String = PersistenceApi.api.dataLoaded;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.NAV_COMMON)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.NAV_COMMON,true);
            if(res != null)
            {
               processedSpeedWarning = false;
               processedTmcSettings = false;
               for(i in res)
               {
                  if(i == "DM")
                  {
                     this.localDemoModeEnabled = false;
                  }
                  if(i == "ADA")
                  {
                     mVoiceGudanceManager.setAdaState(res[i] == "true" ? true : false,false);
                  }
                  if(i == "SLW_E" || i == "SLW_S")
                  {
                     if(!processedSpeedWarning)
                     {
                        processedSpeedWarning = true;
                     }
                     else
                     {
                        mVoiceGudanceManager.setSpeedWarningsSettings(res["SLW_E"] == "true" ? true : false,Number(res["SLW_S"]),false);
                     }
                  }
                  if(i == "SCM")
                  {
                     mVoiceGudanceManager.navSetSafetyCameraMode(int(res[i]),false);
                  }
                  if(i == "TMC_RM" || i == "TMC_DT")
                  {
                     if(!processedTmcSettings)
                     {
                        processedTmcSettings = true;
                     }
                     else
                     {
                        mTmcManager.setTMCRouteMode(int(res["TMC_RM"]),false,false);
                        mTmcManager.setTMCDelayTime(int(res["TMC_DT"]),false);
                     }
                  }
                  if(i == "IC_E")
                  {
                     mInstrumentClusterManager.setInstrumentClusterEnabledNoPersistCall(res[i] == "true" ? true : false);
                  }
               }
               this.mDeferredPersistenceHandler.setNavPersistence(res);
            }
            else
            {
               this.localDemoModeEnabled = false;
               mVoiceGudanceManager.setAdaState(NavGlobalSettings.VOICE_GUIDANCE_ANNOUNCEMENTS_DEFAULT);
               mVoiceGudanceManager.setSpeedWarningsSettings(NavGlobalSettings.SPEED_LIMIT_WARNING_ENABLED_DEFAULT,NavGlobalSettings.SPEED_LIMIT_WARNING_SPEED_DEFAULT);
               mVoiceGudanceManager.navSetSafetyCameraMode(NavGlobalSettings.SAFETY_CAMERA_MODE);
            }
            this.sendEvent(NavigationEvent.NAV_DEMO_MODE);
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      public function savePersistence() : void
      {
         var obj:Object = new Object();
         obj["DM"] = false;
         if(mVoiceGudanceManager != null)
         {
            obj["ADA"] = mVoiceGudanceManager.adaGetState();
            obj["SLW_E"] = mVoiceGudanceManager.navSpeedWarningEnabled;
            obj["SLW_S"] = mVoiceGudanceManager.navSpeedWarningSpeedLimit;
            obj["SCM"] = mVoiceGudanceManager.safetyCameraMode;
         }
         if(mTmcManager != null)
         {
            obj["TMC_RM"] = mTmcManager.TMCRouteMode;
            obj["TMC_DT"] = mTmcManager.TMCDelayTime;
         }
         if(mInstrumentClusterManager != null)
         {
            obj["IC_E"] = mInstrumentClusterManager.instrumentClusterEnabled;
         }
         PersistenceApi.api.saveData(PersistenceKeys.NAV_COMMON,obj);
      }
      
      private function performFactoryReset() : void
      {
         this.setDemoMode(false);
         if(mInstrumentClusterManager)
         {
            mInstrumentClusterManager.setInstrumentClusterEnabledNoPersistCall(true);
         }
         if(mVoiceGudanceManager)
         {
            mVoiceGudanceManager.setSpeedWarningsEnabled(false);
            mVoiceGudanceManager.setAdaState(true);
         }
         if(mTmcManager)
         {
            mTmcManager.setTMCRouteMode(NavGlobalSettings.TMC_DEFAULT_ROUTE_MODE);
            mTmcManager.setTMCDelayTime(NavGlobalSettings.TMC_DEFAULT_DELAY_TIME);
         }
         if(mGraphicalWeatherManager)
         {
            mGraphicalWeatherManager.factoryReset();
         }
      }
   }
}

