package com.harman.navigation.Controller.MAP
{
   import com.harman.navigation.Controller.MAP.enums.CpmPosition;
   import com.harman.navigation.Controller.MAP.enums.EisTypes;
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.Controller.MAP.utils.CommandTransmitterControls;
   import com.harman.navigation.Controller.MAP.utils.CommandTransmitterWorldElements;
   import com.harman.navigation.Controller.MAP.utils.HelperCommandControlBuilder;
   import com.harman.navigation.Controller.MAP.utils.HelperCommandWorldElementBuilder;
   import com.harman.navigation.Controller.MAP.utils.HelperMapThemes;
   import com.harman.navigation.Controller.MAP.utils.HelperPoiVisibility;
   import com.harman.navigation.Controller.MAP.utils.HelperVehicleIcons;
   import com.harman.navigation.Controller.MAP.utils.MapConfiguration;
   import com.harman.navigation.Controller.MAP.utils.MapSettings;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationApi;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationImpl;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.PickInfoDetails;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLinkAPI.BluetoothCall;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import com.nfuzion.span.Client;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class MapController extends EventDispatcher implements IMapControl
   {
      
      private static var mConfirmRouteInterval:uint = 999;
      
      public static var sPhonecallMapRenderingLimit:Boolean = false;
      
      public static var sVoiceRecoMapRenderingLimit:Boolean = false;
      
      private static var mZoomLevelFramerateTimer:Timer = null;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mMapConfigurations:MapConfiguration;
      
      private var mTransmitterControls:CommandTransmitterControls = new CommandTransmitterControls();
      
      private var mCommandTransmitterWorldElements:CommandTransmitterWorldElements = new CommandTransmitterWorldElements();
      
      private var mHelperCommandControlBuilder:HelperCommandControlBuilder;
      
      private var mHelperCommandWorldBuilder:HelperCommandWorldElementBuilder;
      
      private var mHelperVehicleIcon:HelperVehicleIcons;
      
      private var mHelperPoiVisibility:HelperPoiVisibility;
      
      private var mHelperMapThemes:HelperMapThemes;
      
      private var mJunctionViewActive:Boolean;
      
      private var mJunctionViewManualOveride:Boolean = false;
      
      private var mMapAppearanceStyle:int = MapSettingTypes.APPEARANCE_STYLE_DAY;
      
      private var mConfirmRouteHandlesAllHandlesAvailable:Boolean = false;
      
      private var mConfirmRouteHandlesAllHandlesPlanned:Boolean = false;
      
      private var mMapAppearance:MapAppearanceTypes = new MapAppearanceTypes();
      
      private var mAutoZoomOverideDirection:int = 1;
      
      private var mWorldTmcEvent:String = "";
      
      private var mTmcVisibility:int = 3;
      
      private var mMapVisible:int = 0;
      
      private var mScrollMode:int = 4;
      
      private var mPickInfoDetails:PickInfoDetails = new PickInfoDetails();
      
      private var mDestinationInfoSetting:int = 2;
      
      private var mDestinationReachedScreenTimeout:int = -1;
      
      private var mConfirmDestinationAutoAcceptTimeout:int = -1;
      
      private var mZoomLevelChangeTimer:Timer = null;
      
      private var mAutoZoomOverideTimeout:Timer = null;
      
      private var mTmcZoomChangeTimer:Timer = null;
      
      public function MapController()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
         PersistenceApi.impl = PersistenceImpl.create();
         RouteCalculationApi.impl = RouteCalculationImpl.create();
         this.mZoomLevelChangeTimer = new Timer(NavGlobalSettings.MAP_ZOOM_LEVEL_CHANGE_ABUSE_THRESHOLD,1);
         this.mZoomLevelChangeTimer.addEventListener(TimerEvent.TIMER,this.onZoomLevelChangeTimer,false,0,true);
         mZoomLevelFramerateTimer = new Timer(NavGlobalSettings.MAP_ZOOM_LEVEL_FRAMERATE_RAISE_TIMEOUT,1);
         mZoomLevelFramerateTimer.addEventListener(TimerEvent.TIMER,this.onZoomLevelFramerateTimer,false,0,true);
         this.mAutoZoomOverideTimeout = new Timer(NavGlobalSettings.MAP_AUTOZOOM_OVERIDE_TIME_OUT,1);
         this.mAutoZoomOverideTimeout.addEventListener(TimerEvent.TIMER,this.onAutoZoomOverideTimeout,false,0,true);
         this.mTmcZoomChangeTimer = new Timer(NavGlobalSettings.MAP_TMC_EVENT_ZOOM_CHANGE_ABUSE_THRESHOLD,1);
         this.mTmcZoomChangeTimer.addEventListener(TimerEvent.TIMER,this.onTmcEventZoomTimeout,false,0,true);
         this.mHelperVehicleIcon = new HelperVehicleIcons(this);
         this.mHelperPoiVisibility = new HelperPoiVisibility(this);
         this.mHelperMapThemes = new HelperMapThemes(this);
         this.mHelperCommandControlBuilder = new HelperCommandControlBuilder(this);
         this.mHelperCommandWorldBuilder = new HelperCommandWorldElementBuilder(this);
         this.mMapConfigurations = new MapConfiguration();
         NavigationApi.api.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState,false,0,true);
         RouteCalculationApi.api.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onNavGuidanceActive,false,0,true);
         NavigationApi.api.navGetStartupState();
         NavigationApi.api.addEventListener(NavigationEvent.MAP_VEHICLE_ICONS,this.mHelperVehicleIcon.onMapVehicleIconsUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_POI_VISIBILITY,this.mHelperPoiVisibility.onMapPoiVisibilityUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_THEMES,this.mHelperMapThemes.onMapThemesUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_UPDATED_WORLD_ELEMENT_CMD,this.onWorldElementUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_UPDATED_CONTROLS_CMD,this.onControlsCmdUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_PICK_INFO_UPDATE,this.onMapPickInfoUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.MAP_DETAILS,this.onMapGetCurrentZoomLevel,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.POS_JUNCTION_VIEW_AVAILABLE,this.onJunctionViewUpdate,false,0,true);
         RouteCalculationApi.api.addEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE,this.onPlannedRoutes,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.POS_HIGHWAY_EXIT_UPDATE,this.onHighwayModeUpdate,false,0,true);
         NavigationPackage.peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISPLAYMODE,this.onDayNightModeUpdate,false,0,true);
         NavigationPackage.peripheral.personalConfig.getDisplayMode();
         NavigationPackage.peripheral.bluetoothPhone.addEventListener(BluetoothEvent.CALL_STATE,this.onPhonecallEvent,false,0,true);
         NavigationPackage.peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveEvent,false,0,true);
      }
      
      public static function get temporaryZoomLevelChangeFramerateIncreaseEngaged() : Boolean
      {
         Framework.Trace("MapController.temporaryZoomLevelChangeFramerateIncreaseEngaged()" + mZoomLevelFramerateTimer.running);
         return mZoomLevelFramerateTimer.running;
      }
      
      private function onPhonecallEvent(e:BluetoothEvent) : void
      {
         var calls:Vector.<BluetoothCall> = NavigationPackage.peripheral.bluetoothPhone.currentCalls;
         Framework.Trace("CallInfo:" + calls.length);
         for(var i:int = 0; i < calls.length; i++)
         {
            switch(calls[i].callState)
            {
               case BluetoothCall.mCallStateActive:
               case BluetoothCall.mCallStateDialing:
               case BluetoothCall.mCallStateOnHold:
               case BluetoothCall.mCallStateRinging:
               case BluetoothCall.mCallStateWaiting:
                  if(!sPhonecallMapRenderingLimit)
                  {
                     sPhonecallMapRenderingLimit = true;
                     this.activateConfigurationCommands();
                  }
                  return;
            }
         }
         if(sPhonecallMapRenderingLimit)
         {
            sPhonecallMapRenderingLimit = false;
            this.activateConfigurationCommands();
         }
      }
      
      private function onVRDialogActiveEvent(evt:VoiceRecognitionEvent) : void
      {
         if(evt != null && evt.mData != null)
         {
            if(Boolean(evt.mData.vrDialogActive.state))
            {
               sVoiceRecoMapRenderingLimit = true;
               this.activateConfigurationCommands();
            }
            else if(sVoiceRecoMapRenderingLimit)
            {
               sVoiceRecoMapRenderingLimit = false;
               this.activateConfigurationCommands();
            }
         }
      }
      
      public function selectConfiguration(config:int) : void
      {
         Framework.Trace("MapController.selectConfiguration(" + config + ")");
         if(this.mMapConfigurations.activeMapSettingIndex == MapConfiguration.UNDEFINED && config == MapConfiguration.UNDEFINED)
         {
            Framework.Trace(" -blocked, as Configuration already set.");
            return;
         }
         if(config == MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED)
         {
            if(!this.mMapConfigurations.isActive(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED))
            {
               mConfirmRouteInterval = setInterval(this.zoomOnFullRoute,NavGlobalSettings.MAP_CONFIRM_DESTINATION_ZOOM_TIMEOUT);
            }
         }
         else
         {
            clearInterval(mConfirmRouteInterval);
         }
         if(config == MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED || config == MapConfiguration.MAP_CONFIRM_ROUTE)
         {
            this.mConfirmRouteHandlesAllHandlesAvailable = false;
            this.mConfirmRouteHandlesAllHandlesPlanned = false;
         }
         if(this.isAutoZoomCapableMapConfigActive() && MapConfiguration.MAP_SCROLLING == config && this.mMapConfigurations.activeMapSetting.autoZoomSetting != MapZoomLevels.LEVEL_AUTO_OFF)
         {
            Framework.Trace("start AutoZoomOverideTimer");
            this.mAutoZoomOverideTimeout.reset();
            this.mAutoZoomOverideTimeout.start();
            if(this.mMapConfigurations.activeMapSetting.autoZoomOveride == false)
            {
               this.mMapConfigurations.setActiveMapSettings(config);
               NavigationApi.api.mapRequestMapDetails(new Array("<" + EisTypes.MZ + ">"));
               return;
            }
         }
         if(config == MapConfiguration.MAP_FULL && !this.mMapConfigurations.isActive(MapConfiguration.MAP_CONFIRM_ROUTE) && !this.mMapConfigurations.isActive(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED))
         {
            this.mTransmitterControls.clearHistory();
         }
         this.mMapConfigurations.setActiveMapSettings(config);
         this.activateConfigurationCommands();
         this.activateConfigurationWorldElements();
         this.sendEvent(MapControllerEvent.MAP_CONFIGURATION);
      }
      
      private function activateConfigurationCommands() : void
      {
         this.mTransmitterControls.sendCommands(this.mHelperCommandControlBuilder.controlCommands);
      }
      
      private function activateConfigurationWorldElements() : void
      {
         this.mCommandTransmitterWorldElements.sendWorldElements(this.mHelperCommandWorldBuilder.controlWorldElements);
      }
      
      public function setPosition(pos:String, mapConfigurationID:int) : void
      {
         Framework.Trace("MapController.setPosition( " + pos + ", " + mapConfigurationID + " )");
         this.mMapConfigurations.getConfig(mapConfigurationID).setGeoCoordinate(pos);
         if(this.mMapConfigurations.isActive(mapConfigurationID))
         {
            this.activateConfigurationWorldElements();
         }
      }
      
      public function get position() : String
      {
         return "<GEO>0,0<*>";
      }
      
      public function setZoomLevel(lvl:int) : void
      {
         mZoomLevelFramerateTimer.reset();
         mZoomLevelFramerateTimer.start();
         if(this.isAutoZoomCapableMapConfigActive() && this.mMapConfigurations.activeMapSetting.autoZoomSetting != MapZoomLevels.LEVEL_AUTO_OFF)
         {
            Framework.Trace("start AutoZoomOverideTimer");
            this.mAutoZoomOverideTimeout.reset();
            this.mAutoZoomOverideTimeout.start();
            if(this.mMapConfigurations.activeMapSetting.autoZoomOveride == true)
            {
               this.mMapConfigurations.activeMapSetting.setZoomLevel(lvl);
               this.mZoomLevelChangeTimer.reset();
               this.mZoomLevelChangeTimer.start();
            }
            else
            {
               this.mAutoZoomOverideDirection = this.mMapConfigurations.activeMapSetting.zoomLevel < lvl ? 1 : -1;
               NavigationApi.api.mapRequestMapDetails(new Array("<" + EisTypes.MZ + ">"));
            }
         }
         else if(MapZoomLevels.currentZoomLevels[lvl] != null)
         {
            this.mMapConfigurations.activeMapSetting.setZoomLevel(lvl);
            this.mZoomLevelChangeTimer.reset();
            this.mZoomLevelChangeTimer.start();
         }
         else
         {
            Framework.Trace("MapController.setZoomLevel( " + lvl + " ): unspecified lvl!");
         }
      }
      
      public function setTmcSetting(tmcSetting:int) : void
      {
         this.mTmcVisibility = tmcSetting;
         this.persistData();
      }
      
      public function getMapConfiguration() : void
      {
         this.sendEvent(MapControllerEvent.MAP_CONFIGURATION);
      }
      
      public function getZoomLevel() : void
      {
         this.sendEvent(MapControllerEvent.MAP_ZOOM_LEVEL);
      }
      
      public function getTmcSetting() : void
      {
         this.sendEvent(MapControllerEvent.MAP_TMC_SETTING);
      }
      
      public function getZoomLevelForMapConfiguration(id:int) : int
      {
         return this.mMapConfigurations.getConfig(id).zoomLevel;
      }
      
      public function setZoomLevelForMapConfiguration(id:int, level:int) : void
      {
         this.mMapConfigurations.getConfig(id).setZoomLevel(level);
         if(id == this.mapConfiguration)
         {
            this.activateConfigurationCommands();
         }
         this.persistData();
      }
      
      public function setAutoZoomSetting(zoomLevel:int) : void
      {
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL).setAutoZoomSetting(zoomLevel);
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_MEDIA).setAutoZoomSetting(zoomLevel);
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_HALF_LIKE_FULL_MAP).setAutoZoomSetting(zoomLevel);
         this.sendEvent(MapControllerEvent.MAP_AUTO_ZOOM_LEVEL);
         this.persistData();
      }
      
      public function getAutoZoomSetting() : void
      {
         this.sendEvent(MapControllerEvent.MAP_AUTO_ZOOM_LEVEL);
      }
      
      public function get autoZoomSetting() : int
      {
         return this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL).autoZoomSetting;
      }
      
      public function get zoomLevel() : int
      {
         return this.mMapConfigurations.activeMapSetting.zoomLevel;
      }
      
      public function get heading() : int
      {
         return this.mMapConfigurations.activeMapSetting.heading;
      }
      
      public function get viewType() : int
      {
         return this.mMapConfigurations.activeMapSetting.viewType;
      }
      
      public function get appearanceStyle() : int
      {
         return this.mMapAppearanceStyle;
      }
      
      public function get tmcSetting() : int
      {
         return this.mTmcVisibility;
      }
      
      public function get mapConfiguration() : int
      {
         return this.mMapConfigurations.activeMapSettingIndex;
      }
      
      public function getMapSettings(configuration:int) : MapSettings
      {
         return this.mMapConfigurations.getConfig(configuration);
      }
      
      public function setMapSettings(configuration:int, settings:MapSettings) : void
      {
         this.mMapConfigurations.replaceMapSetting(configuration,settings);
         if(this.mMapConfigurations.isActive(configuration))
         {
            this.activateConfigurationCommands();
         }
         this.persistData();
      }
      
      public function getPoiVisibilities() : void
      {
         this.mHelperPoiVisibility.getPoiVisibilities();
      }
      
      public function get poiVisibilities() : Array
      {
         return this.mHelperPoiVisibility.PoiVisibilities;
      }
      
      public function setPoiVisibility(id:String, visible:Boolean) : void
      {
         NavigationApi.api.mapSetPoiVisibility(id,visible);
      }
      
      public function getVehicleIcons() : void
      {
         NavigationApi.api.mapGetVehicleIcons();
      }
      
      public function get vehicleIcons() : Array
      {
         return this.mHelperVehicleIcon.availableVehicleIcons;
      }
      
      public function setVehicleIcon(vehicleIcon:VisibleObject) : void
      {
         this.mHelperVehicleIcon.setActiveVehicleIconID(vehicleIcon);
         this.persistData();
      }
      
      public function get activeVehicleIconID() : String
      {
         return this.mHelperVehicleIcon.activeVehicleIconID;
      }
      
      public function get activeVehicleIconName() : String
      {
         return this.mHelperVehicleIcon.activeVehicleIconName;
      }
      
      public function getMapThemes() : void
      {
         NavigationApi.api.mapGetMapThemes();
      }
      
      public function get mapThemes() : Array
      {
         return this.mHelperMapThemes.availableMapThemes;
      }
      
      public function setMapTheme(theme:VisibleObject) : void
      {
         this.mHelperMapThemes.setActiveMapThemeID(theme);
         this.persistData();
      }
      
      public function get activeMapThemeID() : String
      {
         return this.mHelperMapThemes.activeMapThemeID;
      }
      
      public function get activeMapThemeName() : String
      {
         return this.mHelperMapThemes.activeMapThemeName;
      }
      
      public function getMapAppearanceSettings() : void
      {
         this.sendEvent(MapControllerEvent.MAP_APPEARANCE);
      }
      
      public function get mapAppearanceSettings() : MapAppearanceTypes
      {
         return this.mMapAppearance;
      }
      
      public function toggleMapAppearance(type:int) : void
      {
         this.mMapAppearance.toggleAppearance(type);
         switch(type)
         {
            case MapAppearanceTypes.SHOW_POI_ICONS:
               this.mHelperPoiVisibility.handleGeneralPoiVisibility();
               break;
            case MapAppearanceTypes.SHOW_PARK_AREAS:
            case MapAppearanceTypes.SHOW_RAILROADS:
            case MapAppearanceTypes.SHOW_CITY_AREAS:
            case MapAppearanceTypes.SHOW_RIVER_NAMES:
            case MapAppearanceTypes.SHOW_3D_LANDMARKS:
            case MapAppearanceTypes.SHOW_3D_TERRAIN:
            case MapAppearanceTypes.SHOW_3D_CITY:
            case MapAppearanceTypes.SHOW_JUNCTION_VIEW:
            case MapAppearanceTypes.SHOW_LANE_RECOMMENDATION:
            case MapAppearanceTypes.SHOW_SAFETY_CAMERA:
            case MapAppearanceTypes.SHOW_FOREST_AREAS:
               if(this.mMapConfigurations.isActive(MapConfiguration.MAP_FULL))
               {
                  this.activateConfigurationCommands();
               }
               break;
            case MapAppearanceTypes.SHOW_HIGHWAY_MODE:
               NavigationPackage.peripheral.navigation.navigation.posEnableHighwayModeUpdate(this.mMapAppearance.isSet(MapAppearanceTypes.SHOW_HIGHWAY_MODE));
         }
         this.persistData();
         this.sendEvent(MapControllerEvent.MAP_APPEARANCE);
      }
      
      public function getMapDestinationInfoSetting() : void
      {
         this.sendEvent(MapControllerEvent.MAP_DESTINATION_INFO_SETTING);
      }
      
      public function get mapDestinationInfoSetting() : int
      {
         return this.mDestinationInfoSetting;
      }
      
      public function setMapDestinationInfoSetting(setting:int) : void
      {
         this.mDestinationInfoSetting = setting;
         this.sendEvent(MapControllerEvent.MAP_DESTINATION_INFO_SETTING);
         this.persistData();
      }
      
      public function getMapDestinationReachedScreenTimeout() : void
      {
         this.sendEvent(MapControllerEvent.MAP_DESTINATION_REACHED_SCREEN_TIMEOUT);
      }
      
      public function get mapDestinationReachedScreenTimeout() : int
      {
         return this.mDestinationReachedScreenTimeout;
      }
      
      public function setMapDestinationReachedScreenTimeout(timeout:int) : void
      {
         this.mDestinationReachedScreenTimeout = timeout;
         this.sendEvent(MapControllerEvent.MAP_DESTINATION_REACHED_SCREEN_TIMEOUT);
         this.persistData();
      }
      
      public function getMapConfirmDestinationAutoAcceptTimeout() : void
      {
         this.sendEvent(MapControllerEvent.MAP_CONFIRM_DESTINATION_AUTO_ACCEPT_TIMEOUT);
      }
      
      public function get mapConfirmDestinationAutoAcceptTimeout() : int
      {
         return this.mConfirmDestinationAutoAcceptTimeout;
      }
      
      public function setMapConfirmDestinationAutoAcceptTimeout(timeout:int) : void
      {
         this.mConfirmDestinationAutoAcceptTimeout = timeout;
         this.sendEvent(MapControllerEvent.MAP_CONFIRM_DESTINATION_AUTO_ACCEPT_TIMEOUT);
         this.persistData();
      }
      
      public function junctionViewOveride() : void
      {
         this.mJunctionViewManualOveride = true;
         if(this.mMapConfigurations.isActive(MapConfiguration.MAP_FULL))
         {
            this.activateConfigurationCommands();
         }
      }
      
      public function get junctionViewActive() : Boolean
      {
         return this.mJunctionViewActive;
      }
      
      public function get junctionViewManualOverideActive() : Boolean
      {
         return this.mJunctionViewManualOveride;
      }
      
      public function cttSumOverride() : void
      {
      }
      
      public function get cttSumActive() : Boolean
      {
         return false;
      }
      
      public function scrollingScrollToDirection(angle:int, speed:int) : void
      {
         NavigationApi.api.mapSendControlCmd("<MID>map<*><MSD>" + angle % 360 + "<*><MSM>" + MapSettingTypes.SCROLL_MODE_START + "<*><MSS>" + speed + "<*>");
      }
      
      public function scrollingStop() : void
      {
         NavigationApi.api.mapSendControlCmd("<MID>map<*><MSM>" + MapSettingTypes.SCROLL_MODE_STOP + "<*>");
      }
      
      public function scrollingRequestPickInfo(x:int, y:int, worldElementTypes:int, radius:int) : void
      {
         NavigationApi.api.mapRequestPickInfo("map",x,y,worldElementTypes,radius);
      }
      
      public function getScrollingPickInfo() : void
      {
         this.sendEvent(MapControllerEvent.MAP_SCROLLING_PICK_INFO);
      }
      
      public function get scrollingPickInfo() : PickInfoDetails
      {
         return this.mPickInfoDetails;
      }
      
      public function setTmcZoomEventInfo(info:String) : void
      {
         Framework.Trace("MapController.setTmcZoomEventID( " + info + " )");
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_ZOOM_TMC).setGeoCoordinate(EisHelper.getValueOfType(info,"<GEO>"));
         if(this.mapConfiguration == MapConfiguration.MAP_ZOOM_TMC)
         {
            this.mTmcZoomChangeTimer.reset();
            this.mTmcZoomChangeTimer.start();
         }
      }
      
      private function onTmcEventZoomTimeout(e:TimerEvent) : void
      {
         if(this.mapConfiguration == MapConfiguration.MAP_ZOOM_TMC)
         {
            this.activateConfigurationWorldElements();
         }
      }
      
      public function reinitializeMap() : void
      {
         Framework.Trace("MapController.reinitializeMap()");
         this.mTransmitterControls.clearHistory();
         this.initializeMap();
      }
      
      public function factoryReset() : void
      {
         Framework.Trace("MapController.factoryReset()");
         this.mDestinationInfoSetting = NavGlobalSettings.MAP_DESTINATION_INFO_FATOCRY_DEFAULT;
         this.mMapAppearance.fromPersistence(NavGlobalSettings.MAP_APPEARANCE_FACTORY_DEFAULT);
         this.getMapSettings(MapConfiguration.MAP_FULL).setAutoZoomSetting(NavGlobalSettings.MAP_AUTOZOOM_FACTORY_DEFAULT);
         this.getMapSettings(MapConfiguration.MAP_FULL).setZoomLevel(NavGlobalSettings.MAP_DEFAULT_ZOOM_LEVEL_MAP_FULL);
         this.persistData();
      }
      
      public function updateJunctionViewVisibleState(visible:Boolean) : void
      {
         if(this.mJunctionViewActive != visible)
         {
            this.mJunctionViewActive = visible;
            this.sendEvent(MapControllerEvent.MAP_JUNCTION_VIEW_ACTIVE);
         }
      }
      
      public function onWorldElementUpdate(e:NavigationEvent) : void
      {
      }
      
      public function onControlsCmdUpdate(e:NavigationEvent) : void
      {
      }
      
      private function onMapPickInfoUpdate(e:NavigationEvent) : void
      {
         this.mPickInfoDetails = NavigationApi.api.mapPickInfo;
         this.sendEvent(MapControllerEvent.MAP_SCROLLING_PICK_INFO);
      }
      
      private function onMapGetCurrentZoomLevel(e:NavigationEvent) : void
      {
         var currentLevel:int = int(EisHelper.getValueOfType(NavigationApi.api.mapDetails,"<MZ>"));
         var i:int = 0;
         if(this.isAutoZoomCapableMapConfigActive())
         {
            this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL).setAutoZoomOveride(true);
            this.mMapConfigurations.getConfig(MapConfiguration.MAP_MEDIA).setAutoZoomOveride(true);
            this.mMapConfigurations.getConfig(MapConfiguration.MAP_HALF_LIKE_FULL_MAP).setAutoZoomOveride(true);
            for(i = MapZoomLevels.LEVEL_1; i < MapZoomLevels.TOTAL_LEVELS; i++)
            {
               if(currentLevel < MapZoomLevels.mLevels_Metric[i])
               {
                  if(this.mAutoZoomOverideDirection > 0)
                  {
                     Framework.Trace("MapController.onMapGetCurrentZoomLevel() " + MapZoomLevels.mLevels_Metric[i]);
                     this.mMapConfigurations.activeMapSetting.setZoomLevel(i);
                  }
                  else
                  {
                     Framework.Trace("MapController.onMapGetCurrentZoomLevel() " + MapZoomLevels.mLevels_Metric[i]);
                     this.mMapConfigurations.activeMapSetting.setZoomLevel(i - 1);
                  }
                  break;
               }
            }
            this.activateConfigurationCommands();
            this.sendEvent(MapControllerEvent.MAP_ZOOM_LEVEL);
         }
         else if(this.mMapConfigurations.activeMapSettingIndex == MapConfiguration.MAP_SCROLLING)
         {
            for(i = MapZoomLevels.LEVEL_1; i < MapZoomLevels.TOTAL_LEVELS; i++)
            {
               if(currentLevel < MapZoomLevels.mLevels_Metric[i])
               {
                  if(currentLevel - MapZoomLevels.mLevels_Metric[i] > MapZoomLevels.mLevels_Metric[i - 1] - currentLevel)
                  {
                     this.mMapConfigurations.activeMapSetting.setZoomLevel(i - 1);
                  }
                  else
                  {
                     this.mMapConfigurations.activeMapSetting.setZoomLevel(i);
                  }
                  break;
               }
            }
            this.activateConfigurationCommands();
            this.activateConfigurationWorldElements();
            this.sendEvent(MapControllerEvent.MAP_CONFIGURATION);
            this.sendEvent(MapControllerEvent.MAP_ZOOM_LEVEL);
         }
      }
      
      private function onNavStartupState(e:NavigationEvent) : void
      {
         if(NavigationApi.api.navStartupState >= StartupState.INIT)
         {
            this.loadPersistence();
            NavigationApi.api.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState);
         }
      }
      
      private function onJunctionViewUpdate(e:NavigationEvent) : void
      {
         this.mJunctionViewManualOveride = false;
         if(NavigationPackage.peripheral.navigation.navigation.posJunctionViewState == false)
         {
            this.updateJunctionViewVisibleState(false);
         }
         if(this.mMapConfigurations.isActive(MapConfiguration.MAP_FULL))
         {
            this.activateConfigurationCommands();
         }
      }
      
      private function onPlannedRoutes(e:RouteCalculationEvent) : void
      {
         var plannedRoutes:Array = null;
         var i:int = 0;
         if(this.mMapConfigurations.isActive(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED) || this.mMapConfigurations.isActive(MapConfiguration.MAP_CONFIRM_ROUTE))
         {
            plannedRoutes = NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip.routes;
            i = 0;
            if(!this.mConfirmRouteHandlesAllHandlesAvailable)
            {
               for(i = 0; i < plannedRoutes.length; i++)
               {
                  if(Route(plannedRoutes[i]).routeHandle <= 0)
                  {
                     this.activateConfigurationWorldElements();
                     return;
                  }
               }
               this.mConfirmRouteHandlesAllHandlesAvailable = true;
               this.activateConfigurationWorldElements();
            }
            else if(!this.mConfirmRouteHandlesAllHandlesPlanned)
            {
               for(i = 0; i < plannedRoutes.length; i++)
               {
                  if(Route(plannedRoutes[i]).calculationState < RouteCalculationState.Planned)
                  {
                     return;
                  }
               }
               if(plannedRoutes.length == 0)
               {
                  return;
               }
               this.mConfirmRouteHandlesAllHandlesPlanned = true;
               this.activateConfigurationWorldElements();
            }
         }
      }
      
      private function onHighwayModeUpdate(e:NavigationEvent) : void
      {
         if(this.mMapConfigurations.isActive(MapConfiguration.MAP_FULL))
         {
            this.activateConfigurationCommands();
         }
      }
      
      private function onNavGuidanceActive(e:RouteCalculationEvent) : void
      {
         if(this.mMapConfigurations.isActive(MapConfiguration.MAP_FULL))
         {
            this.mTransmitterControls.clearHistoryValue(EisTypes.MZ);
            this.activateConfigurationCommands();
         }
      }
      
      private function onZoomLevelChangeTimer(e:TimerEvent) : void
      {
         Framework.Trace("MapController.onZoomLevelChangeTimer()");
         this.activateConfigurationCommands();
         this.persistData();
         this.sendEvent(MapControllerEvent.MAP_ZOOM_LEVEL);
      }
      
      private function onZoomLevelFramerateTimer(e:TimerEvent) : void
      {
         Framework.Trace("MapController.onZoomLevelFramerateTimer()");
         mZoomLevelFramerateTimer.stop();
         this.activateConfigurationCommands();
      }
      
      private function onAutoZoomOverideTimeout(e:TimerEvent) : void
      {
         Framework.Trace("MapController.onAutoZoomOverideTimeout()");
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL).setAutoZoomOveride(false);
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_MEDIA).setAutoZoomOveride(false);
         this.mMapConfigurations.getConfig(MapConfiguration.MAP_HALF_LIKE_FULL_MAP).setAutoZoomOveride(false);
         if(this.isAutoZoomCapableMapConfigActive())
         {
            this.mTransmitterControls.clearHistoryValue(EisTypes.MEV);
            this.mTransmitterControls.clearHistoryValue(EisTypes.MH);
            this.activateConfigurationCommands();
            this.sendEvent(MapControllerEvent.MAP_ZOOM_LEVEL);
         }
      }
      
      private function onDayNightModeUpdate(e:PersonalConfigEvent) : void
      {
         Framework.Trace("MapController.onDayNightModeUpdate( " + NavigationPackage.peripheral.personalConfig.displayMode + " )");
         switch(NavigationPackage.peripheral.personalConfig.displayMode)
         {
            case "day":
               this.mMapAppearanceStyle = MapSettingTypes.APPEARANCE_STYLE_DAY;
               break;
            case "night":
               this.mMapAppearanceStyle = MapSettingTypes.APPEARANCE_STYLE_NIGHT;
               break;
            case "auto":
            default:
               Framework.Trace(" -Illegal displayMode received! ( " + NavigationPackage.peripheral.personalConfig.displayMode + " )");
         }
         if(this.mMapConfigurations.activeMapSettingIndex != MapConfiguration.INIT)
         {
            this.mTransmitterControls.sendCommands({"MAS":this.mMapAppearanceStyle});
         }
         if(this.mMapConfigurations.activeMapSettingIndex == MapConfiguration.UNDEFINED)
         {
            this.mTransmitterControls.clearHistoryValue(EisTypes.MAS);
         }
      }
      
      public function sendEvent(eventType:String) : void
      {
         dispatchEvent(new MapControllerEvent(eventType));
      }
      
      private function zoomOnFullRoute() : void
      {
         Framework.Trace("MapController.zoomOnFullRoute()");
         clearInterval(mConfirmRouteInterval);
         this.selectConfiguration(MapConfiguration.MAP_CONFIRM_ROUTE);
      }
      
      private function isAutoZoomCapableMapConfigActive() : Boolean
      {
         switch(this.mMapConfigurations.activeMapSettingIndex)
         {
            case MapConfiguration.MAP_FULL:
            case MapConfiguration.MAP_MEDIA:
            case MapConfiguration.MAP_HALF_LIKE_FULL_MAP:
               return true;
            default:
               return false;
         }
      }
      
      private function initializeMap() : void
      {
         var presetCommand:Object = {"PRE":1};
         this.mTransmitterControls.sendCommands(presetCommand);
         var initCommands:Object = this.getMapSettings(MapConfiguration.MAP_FULL).transmissionCommandObject;
         initCommands[EisTypes.MR] = this.getMapSettings(MapConfiguration.MAP_FULL).resolution;
         initCommands[EisTypes.MVI] = "" + MapSettingTypes.ENABLED;
         if(this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL))
         {
            initCommands[EisTypes.MVT] = "" + this.mMapConfigurations.getConfig(MapConfiguration.MAP_FULL).viewType;
         }
         initCommands[EisTypes.SDF] = "" + MapSettingTypes.MAP_FRAMERATE_LOW;
         initCommands[EisTypes.MAS] = "" + this.mMapAppearanceStyle;
         initCommands[EisTypes.MP] = this.getMapSettings(MapConfiguration.MAP_FULL).position;
         initCommands[EisTypes.MJV] = "" + MapSettingTypes.ENABLED;
         initCommands[EisTypes.MEV] = "" + 0;
         initCommands[EisTypes.MEP] = "" + (this.getMapSettings(MapConfiguration.MAP_FULL).heading == MapSettingTypes.ORIENTATION_NORTH_UP == true) ? CpmPosition.FULL_NORTH_UP_IN_ROUTE : CpmPosition.FULL_HEADING_UP;
         initCommands[EisTypes.MVT] = "" + this.getMapSettings(MapConfiguration.MAP_FULL).viewType;
         initCommands[EisTypes.MPI_NNG] = "" + (this.activeVehicleIconID == "-1" ? 0 : this.activeVehicleIconID);
         if(this.getMapSettings(MapConfiguration.MAP_FULL).autoZoomSetting != MapZoomLevels.LEVEL_AUTO_OFF)
         {
            initCommands[EisTypes.MZ] = "" + this.getMapSettings(MapConfiguration.MAP_FULL).autoZoomSetting;
         }
         else
         {
            initCommands[EisTypes.MZ] = "" + MapZoomLevels.currentZoomLevels[int(this.getMapSettings(MapConfiguration.MAP_FULL).zoomLevel)];
         }
         this.mTransmitterControls.sendCommands(initCommands);
      }
      
      private function loadPersistence() : void
      {
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.MAP_SETTINGS);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         var vehicleIcon:VisibleObject = null;
         var mapTheme:VisibleObject = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.MAP_SETTINGS)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.MAP_SETTINGS,true);
            if(res != null)
            {
               if(res["MGC_NO"] == null || res["MGC_NO"] != NavGlobalSettings.MAP_MAGIC_NUMBER)
               {
                  Framework.Trace("MapController.onPersistence() Persistence is outdated. old\'" + res["MGC_NO"] + "\' new\'" + NavGlobalSettings.MAP_MAGIC_NUMBER + "\'");
               }
               else
               {
                  for(i in res)
                  {
                     if(i == "MC")
                     {
                        Framework.Trace("MC:" + res[i]);
                        this.mMapConfigurations.loadFromPersistence(res[i]);
                     }
                     else if(i == "VH_ID")
                     {
                        Framework.Trace("VH_ID: " + res[i]);
                        vehicleIcon = new VisibleObject();
                        vehicleIcon.setID(String(res[i]));
                        this.mHelperVehicleIcon.setActiveVehicleIconID(vehicleIcon,false);
                     }
                     else if(i == "THEME")
                     {
                        Framework.Trace("THEME: " + res[i]);
                        mapTheme = new VisibleObject();
                        mapTheme.setID(String(res[i]));
                        this.mHelperMapThemes.setActiveMapThemeID(mapTheme);
                     }
                     else if(i == "M_APP")
                     {
                        this.mMapAppearance.fromPersistence(int(res[i]));
                        NavigationPackage.peripheral.navigation.navigation.posEnableHighwayModeUpdate(this.mMapAppearance.isSet(MapAppearanceTypes.SHOW_HIGHWAY_MODE));
                     }
                     else if(i == "TMC")
                     {
                        this.mTmcVisibility = int(res[i]);
                     }
                     else if(i == "DIS")
                     {
                        this.mDestinationInfoSetting = int(res[i]);
                     }
                     else if(i == "DRSTO")
                     {
                        this.mDestinationReachedScreenTimeout = int(res[i]);
                     }
                     else if(i == "CDAAT")
                     {
                        this.mConfirmDestinationAutoAcceptTimeout = int(res[i]);
                     }
                  }
               }
               PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
            }
            else
            {
               this.mHelperMapThemes.setDefaultMapThemeNasedOnVehicleConfig();
               this.mHelperVehicleIcon.setDefaultVehicleIconBasedOnVehicleConfig();
            }
            this.initializeMap();
         }
      }
      
      private function persistData() : void
      {
         var obj:Object = new Object();
         obj["MGC_NO"] = NavGlobalSettings.MAP_MAGIC_NUMBER;
         obj["MC"] = this.mMapConfigurations.saveToPersistence();
         obj["VH_ID"] = this.mHelperVehicleIcon.activeVehicleIconID;
         obj["THEME"] = this.mHelperMapThemes.activeMapThemeID;
         obj["M_APP"] = this.mMapAppearance.toPersistence();
         obj["TMC"] = this.mTmcVisibility;
         obj["DIS"] = this.mDestinationInfoSetting;
         obj["DRSTO"] = this.mDestinationReachedScreenTimeout;
         obj["CDAAT"] = this.mConfirmDestinationAutoAcceptTimeout;
         PersistenceApi.api.saveData(PersistenceKeys.MAP_SETTINGS,obj);
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
   }
}

