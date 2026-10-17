package com.harman.navigation.DomainControl.menuStack
{
   import com.harman.navigation.Controller.LI.LocationInputApi;
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.Controller.LI.LocationInputImpl;
   import com.harman.navigation.Controller.MAP.MapControllerApi;
   import com.harman.navigation.Controller.MAP.MapControllerImpl;
   import com.harman.navigation.Controller.POI.PoiInputApi;
   import com.harman.navigation.Controller.POI.PoiInputEvent;
   import com.harman.navigation.Controller.POI.PoiInputImpl;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerApi;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerEvent;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.LocationInputMenu;
   import com.harman.navigation.enums.PoiInputMenu;
   import com.harman.navigation.enums.TripAssemblerMenu;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.nfuzion.framework.global.Framework;
   import flash.display.Sprite;
   
   use namespace NavigationNamespace;
   
   public class NavMenus
   {
      
      public static var mWindow:Sprite;
      
      public static var isVRSupported:Boolean = false;
      
      public static const UNDEFINED:int = 0;
      
      public static const MENU_STACK_SWITCH_MARKER:int = 33;
      
      public static const MENU_DOMAIN_RETURN_SWITCH_MARKER:int = 60;
      
      public static const MENU_MAIN:int = 1;
      
      public static const MENU_WHERE_TO:int = 2;
      
      public static const MENU_INFORMATION:int = 7;
      
      public static const MENU_MY_DESTINATIONS:int = 3;
      
      public static const MENU_FAVORITE_DESTINATIONS_LIST:int = 54;
      
      public static const MENU_FAVORITE_DESTINATIONS_RENAME:int = 55;
      
      public static const MENU_FAVORITE_DESTINATIONS_PHONE:int = 56;
      
      public static const MENU_FAVORITE_DESTINATIONS_SAVE_CURRENT:int = 57;
      
      public static const MENU_FAVORITE_DESTINATIONS_ADD_DEST:int = 58;
      
      public static const MENU_FAVORITE_DESTINATIONS_ADD_DEST_SPELLER:int = 59;
      
      public static const MENU_FAVORITE_DESTINATIONS_ADD_CONTACT:int = 61;
      
      public static const MENU_FAVORITE_DESTINATIONS_ADD_CONTACT_SPELLER:int = 62;
      
      public static const MENU_FAVORITE_YOMI_RENAME:int = 98;
      
      public static const MENU_HOME_ADD_DESTINATION:int = 4;
      
      public static const MENU_VR_DESTINATION_ENTRY:int = 53;
      
      public static const MENU_WHERE_AM_I:int = 5;
      
      public static const MENU_WHERE_AM_I_SAVE:int = 26;
      
      public static const MENU_ADVANCED:int = 6;
      
      public static const MENU_EMERGENCY:int = 8;
      
      public static const MENU_TRAFFIC:int = 9;
      
      public static const MENU_TRIP_COMPUTER:int = 50;
      
      public static const MENU_TRIPS_ALL_TRIPS:int = 10;
      
      public static const MENU_TRIPS_DESTINATIONS:int = 39;
      
      public static const MENU_TRIPS_ADD_DESTINATION:int = 40;
      
      public static const MENU_TRIPS_SPELLER_NEW_TRIP:int = 11;
      
      public static const MENU_TRIPS_SPELLER_RENAME_TRIP:int = 42;
      
      public static const MENU_TRIPS_SPELLER_RENAME_DESTINATION:int = 43;
      
      public static const MENU_TRIPS_SPELLER_PHONE_DESTINATION:int = 44;
      
      public static const MENU_SPEED_CAMERA:int = 13;
      
      public static const MENU_STOP_ROUTING:int = 15;
      
      public static const MENU_GEO_SPELLER:int = 48;
      
      public static const MENU_LANGUAGE_CHANGE_POPUP:int = 84;
      
      public static const MENU_SETTINGS:int = 14;
      
      public static const MENU_SETTINGS_GUIDANCE:int = 30;
      
      public static const MENU_SETTINGS_GUIDANCE_TMC_DELAY:int = 71;
      
      public static const MENU_SETTINGS_SPEED_LIMIT:int = 51;
      
      public static const MENU_SETTINGS_SPEED_SPELLER:int = 52;
      
      public static const MENU_SETTINGS_MAP:int = 20;
      
      public static const MENU_SETTINGS_MAP_POI_VISIBILITY:int = 23;
      
      public static const MENU_SETTINGS_MAP_VEHICLE_ICONS:int = 24;
      
      public static const MENU_SETTINGS_TMC_AVOIDANCE_TYPE:int = 73;
      
      public static const MENU_SETTINGS_MAP_THEMES:int = 93;
      
      public static const MENU_SETTINGS_TMC_STATIONS_LIST:int = 82;
      
      public static const MENU_SETTINGS_SECRETS:int = 78;
      
      public static const MENU_SETTINGS_SECRETS_NDR_INFO:int = 86;
      
      public static const MENU_SETTINGS_EASTER_HMI_SETTINGS:int = 87;
      
      public static const MENU_SETTINGS_EASTER_NAVISERVER:int = 88;
      
      public static const MENU_SETTINGS_EASTER_POSITIONING:int = 89;
      
      public static const MENU_SETTINGS_EASTER_SYSTEM:int = 90;
      
      public static const MENU_SETTINGS_EASTER_VEHICLE_SETTINGS:int = 91;
      
      public static const MENU_SETTINGS_EASTER_LIVE_SERVICES:int = 231;
      
      public static const MENU_SETTINGS_EASTER_DEMO_POSITIONS:int = 94;
      
      public static const MENU_SETTINGS_EASTER_DEMO_POSITION_NAME:int = 95;
      
      public static const MENU_SETTINGS_DEMO_MODE_COORD_SPELL:int = 83;
      
      public static const MENU_SETTINGS_OTA_UPDATE:int = 85;
      
      public static const MENU_CONFIRM_ROUTE_SAVE:int = 25;
      
      public static const MENU_AVOID_IN_ROUTE_LIST:int = 36;
      
      public static const MENU_OPTIONS_IN_ROUTE_LIST:int = 92;
      
      public static const MENU_MY_DESTINATIONS_RENAME:int = 17;
      
      public static const MENU_MY_DESTINATIONS_PHONE_NUMBER:int = 18;
      
      public static const MENU_MAP_MAIN:int = 19;
      
      public static const MENU_MAP_DESTINATION_INFO:int = 27;
      
      public static const MENU_MAP_DESTINATION_INFO_SAVE:int = 37;
      
      public static const MENU_MAP_DESTINATION_REACHED:int = 28;
      
      public static const MENU_MAP_TURN_LIST:int = 29;
      
      public static const MENU_MAP_TURN_LIST_DETOUR:int = 81;
      
      public static const MENU_MAP_TURN_LIST_INTERCHANGE:int = 232;
      
      public static const MENU_MAP_MANEUVER_ZOOM:int = 38;
      
      public static const MENU_MAP_SCROLLING:int = 31;
      
      public static const MENU_MAP_SCROLLING_POI_LIST:int = 32;
      
      public static const MENU_MAP_DEMO_MODE_LOCATION_PICKER:int = 97;
      
      public static const MENU_MAP_ROUTE_OVERVIEW:int = 248;
      
      public static const MENU_TMC_EVENTS_LIST:int = 63;
      
      public static const MENU_TMC_EVENTS_ZOOM:int = 69;
      
      public static const MENU_TMC_SETTINGS:int = 70;
      
      public static const MENU_TMC_ROUTE_PREVIEW:int = 74;
      
      public static const MENU_TMC_EVENT_ZOOM_MAP:int = 80;
      
      public static const MENU_TMC_MY_TRAFFIC:int = 96;
      
      public static const MENU_TRAIL_LIST:int = 72;
      
      public static const MENU_TRAIL_SPELLER_SAVE:int = 75;
      
      public static const MENU_TRAIL_SPELLER_RENAME:int = 76;
      
      public static const MENU_NAV_READY_ANNOUNCEMENT:int = 64;
      
      public static const MENU_NAV_READY_SPELLER:int = 65;
      
      public static const MENU_NAV_READY_ACCEPTED:int = 66;
      
      public static const MENU_NAV_READY_DECLINED:int = 67;
      
      public static const MENU_NAV_READY_WAIT:int = 68;
      
      public static const MENU_NAV_READY_PUNISHMENT:int = 79;
      
      public static const MENU_FLOW_INPUT_LOCATION:int = 100;
      
      public static const MENU_FLOW_INPUT_POI:int = 101;
      
      public static const MENU_FLOW_TRIP_ASSEMBLER:int = 102;
      
      public static const MENU_VICS:int = 200;
      
      public static const MENU_VICS_DARC:int = 201;
      
      public static const MENU_VICS_DARC_MENU:int = 202;
      
      public static const MENU_VICS_MSG_LIST:int = 203;
      
      public static const MENU_VICS_BEACON:int = 204;
      
      public static const MENU_VICS_INTSCREEN:int = 205;
      
      public static const MENU_VICS_SETTINGS:int = 213;
      
      public static const MENU_VICS_SETTINGS_PREF:int = 214;
      
      public static const MENU_SETTINGS_ETC:int = 215;
      
      public static const MENU_SETTINGS_ETC_HISTORY:int = 216;
      
      public static const MENU_VICS_PARKING_ZOOM_MAP:int = 220;
      
      public static const MENU_KANJI_LIST:int = 217;
      
      public static const MENU_LIVE_SERVICES_CONSENT_DISCLAIMER:int = 221;
      
      public static const MENU_LIVE_SERVICES_CONSENT_REVIEW:int = 247;
      
      public static const MENU_LIVE_SERVICES_CONSENT_INFORMATION:int = 222;
      
      public static const MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN:int = 223;
      
      public static const MENU_LIVE_SERVICES_HDT_ADD_HOME:int = 224;
      
      public static const MENU_LIVE_SERVICES_HDT_ADD_WORK:int = 225;
      
      public static const MENU_LIVE_SERVICES_HDT_CHANGE_HOME_WORK:int = 226;
      
      public static const MENU_LIVE_SERVICES_LS_SPEED_CAMERAS:int = 227;
      
      public static const MENU_LIVE_SERVICES_LS_SPEED_CAM_ALERT_SETTINGS:int = 228;
      
      public static const MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_LIST:int = 229;
      
      public static const MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_MAP:int = 230;
      
      public static const MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_SPEED:int = 245;
      
      public static const MENU_LIVE_SERVICES_LS_TRAFFIC_ENTRY_MAP:int = 233;
      
      public static const MENU_LIVE_SERVICES_LS_TRAFFIC_MAP:int = 234;
      
      public static const MENU_LIVE_SERVICES_TMC_EVENT_ENTRY_LIST:int = 236;
      
      public static const MENU_LIVE_SERVICES_LS_WEATHER:int = 237;
      
      public static const MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:int = 238;
      
      public static const MENU_LIVE_SERVICES_LS_WEATHER_DETAILS:int = 239;
      
      public static const MENU_LIVE_SERVICES_DESTINATION_LIST_WEATHER:int = 240;
      
      public static const MENU_LIVE_SERVICES_DESTINATION_LIST_LOCALSEARCH:int = 241;
      
      public static const MENU_LIVE_SERVICES_LS_LOCAL_SEARCH:int = 242;
      
      public static const MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:int = 243;
      
      public static const MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER:int = 244;
      
      public static const MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST:int = 246;
      
      private static var mMenuMain:String = "mainbackground/menu/navmainmenuscreen";
      
      private static var mMenuWhereTo:String = "mainbackground/menu/navmenuwheretoscreen";
      
      private static var mMenuAdvanced:String = "mainbackground/menu/navadvancedscreen";
      
      private static var mMenuEntryAddress:String = "mainbackground/menu/navaddressscreen";
      
      private static var mMenuGeoCoordinateSpeller:String = "mainbackground/menu/navgeospellerscreen";
      
      private static var mMenuNavList:String = "mainbackground/menu/navlistscreen";
      
      private static var mMenuPoiNavList:String = "mainbackground/menu/navpoilistscreen";
      
      private static var mMenuTmcEventList:String = "mainbackground/menu/navtmceventlistscreen";
      
      private static var mMenuNavTabList:String = "mainbackground/menu/navtablistscreen";
      
      private static var mMenuNavSpeller:String = "mainbackground/menu/navspellerscreen";
      
      private static var mMenuPoiMain:String = "mainbackground/menu/navpoimenuscreen";
      
      private static var mMenuNavListJP:String = "mainbackground/menu/navlistscreenjp";
      
      private static var mMenuPoiSearchArea:String = "mainbackground/menu/navpopup4itemscreen";
      
      private static var mMenuPoiByPhoneSpeller:String = "mainbackground/menu/navphonespellerscreen";
      
      private static var mMenuGenericPopup:String = "mainbackground/menu/navpopupgenericscreen";
      
      private static var mMenuThreeItemPopup:String = "mainbackground/menu/navpopup3itemscreen";
      
      private static var mMenuWeatherDetails:String = "mainbackground/menu/navweatherdetailsscreen";
      
      private static var mMenuSetCameraSpeed:String = "mainbackground/menu/navsetcameraspeedscreen";
      
      private static var mMenuScrollingPopup:String = "mainbackground/menu/scrollingpopup";
      
      private static var mMenuInformationSharing:String = "mainbackground/menu/informationsharingscreen";
      
      private static var mMenuPopupFullScreen3Item:String = "popupfullscreen3item";
      
      private static var mMenuMapMain:String = "mainbackground/menu/navmapmainscreen";
      
      private static var mMenuMapScrolling:String = "mainbackground/menu/navmapscrollingscreen";
      
      private static var mMenuConfirmDestination:String = "mainbackground/menu/navconfirmdestinationscreen";
      
      private static var mMenuAlternativeRoutes:String = "mainbackground/menu/navalternativeroutesscreen";
      
      private static var mMenuMapDestinationReached:String = "mainbackground/menu/navdestinationreachedscreen";
      
      private static var mMenuManeuverZoom:String = "mainbackground/menu/navmaneuverzoomscreen";
      
      private static var mMenuEmergency:String = "mainbackground/menu/navemergencyscreen";
      
      private static var mMenuMapEventZoom:String = "mainbackground/menu/navmapeventzoomscreen";
      
      private static var mMenuVehicleIcons:String = "NavVehicleIconsScreen.swf";
      
      private static var mMenuMapLocationPicker:String = "mainbackground/menu/navmaplocationpickerscreen";
      
      private static var mMenuRouteOverview:String = "mainbackground/menu/navrouteoverviewscreen";
      
      private static var mMenuNavReadyPopup:String = "mainbackground/menu/navreadypopupscreen";
      
      private static var mMenuVics:String = "mainbackground/menu/navvicsmainscreen";
      
      private static var mMenuVICSDarc:String = "mainbackground/menu/navvicsdarcscreen";
      
      private static var mMenuVICSDarcMenu:String = "mainbackground/menu/navvicsdarcmenuscreen";
      
      private static var mMenuVICSBeacon:String = "mainbackground/menu/navvicsbeaconscreen";
      
      private static var mMenuVICSInterruptScreen:String = "mainbackground/menu/navvicsinterrupt";
      
      private static var mLocationInputMenu:int = -1;
      
      private static var mPoiInputMenu:int = -1;
      
      private var mMenuStack:MenuStack;
      
      private var mDomainSwitchScreenName:Object = null;
      
      private var isBack:Boolean = false;
      
      public function NavMenus(menuStack:MenuStack)
      {
         super();
         this.mMenuStack = menuStack;
         LocationInputApi.impl = LocationInputImpl.create();
         PoiInputApi.impl = PoiInputImpl.create();
         MapControllerApi.impl = MapControllerImpl.create();
      }
      
      public function activateMenu(menu:int) : void
      {
         Framework.Trace("NavMenus.activateMenu:" + menu);
         var goToAddress:String = "";
         var goToObject:Object = new Object();
         switch(menu)
         {
            case MENU_MAIN:
               goToAddress = mMenuMain;
               break;
            case MENU_ADVANCED:
               goToAddress = mMenuAdvanced;
               break;
            case MENU_EMERGENCY:
               goToAddress = mMenuEmergency;
               break;
            case MENU_FLOW_INPUT_LOCATION:
               this.activateLocationIputFlow(true);
               break;
            case MENU_FLOW_INPUT_POI:
               this.activatePoiIputFlow(true);
               break;
            case MENU_FLOW_TRIP_ASSEMBLER:
               this.activateTripAssmblerFlow(true);
               break;
            case MENU_MAP_MAIN:
               goToAddress = mMenuMapMain;
               break;
            case MENU_MAP_SCROLLING:
               goToAddress = mMenuMapScrolling;
               break;
            case MENU_MAP_DESTINATION_REACHED:
               goToAddress = mMenuMapDestinationReached;
               break;
            case MENU_MAP_MANEUVER_ZOOM:
               goToAddress = mMenuManeuverZoom;
               break;
            case MENU_LANGUAGE_CHANGE_POPUP:
               goToAddress = mMenuGenericPopup;
               break;
            case MENU_MAP_DEMO_MODE_LOCATION_PICKER:
               goToAddress = mMenuMapLocationPicker;
               goToObject.ext = NavMenus.MENU_MAP_DEMO_MODE_LOCATION_PICKER;
               break;
            case MENU_TMC_EVENTS_LIST:
               goToAddress = mMenuTmcEventList;
               goToObject.ext = NavMenus.MENU_TMC_EVENTS_LIST;
               break;
            case MENU_LIVE_SERVICES_TMC_EVENT_ENTRY_LIST:
               goToAddress = mMenuTmcEventList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_TMC_EVENT_ENTRY_LIST;
               break;
            case MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_MAP:
               goToAddress = mMenuMapLocationPicker;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_MAP;
               break;
            case MENU_LIVE_SERVICES_LS_TRAFFIC_ENTRY_MAP:
               goToAddress = mMenuMapLocationPicker;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_TRAFFIC_ENTRY_MAP;
               break;
            case MENU_LIVE_SERVICES_LS_TRAFFIC_MAP:
               goToAddress = mMenuMapLocationPicker;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_TRAFFIC_MAP;
               break;
            case MENU_VR_DESTINATION_ENTRY:
               goToAddress = mMenuConfirmDestination;
               goToObject.ext = NavMenus.MENU_VR_DESTINATION_ENTRY;
               break;
            case MENU_WHERE_AM_I:
               goToAddress = mMenuConfirmDestination;
               goToObject.ext = NavMenus.MENU_WHERE_AM_I;
               break;
            case MENU_TMC_ROUTE_PREVIEW:
               goToAddress = mMenuConfirmDestination;
               goToObject.ext = NavMenus.MENU_TMC_ROUTE_PREVIEW;
               break;
            case MENU_MAP_DESTINATION_INFO:
               goToAddress = mMenuConfirmDestination;
               goToObject.ext = NavMenus.MENU_MAP_DESTINATION_INFO;
               break;
            case MENU_TMC_SETTINGS:
               goToAddress = mMenuNavList;
               break;
            case MENU_TRIPS_ALL_TRIPS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_TRIPS_ALL_TRIPS;
               break;
            case MENU_TRIPS_DESTINATIONS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_TRIPS_DESTINATIONS;
               break;
            case MENU_STOP_ROUTING:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_STOP_ROUTING;
               break;
            case MENU_MY_DESTINATIONS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_MY_DESTINATIONS;
               break;
            case MENU_FAVORITE_DESTINATIONS_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_LIST;
               break;
            case MENU_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS;
               break;
            case MENU_SETTINGS_GUIDANCE:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_GUIDANCE;
               break;
            case MENU_SETTINGS_SPEED_LIMIT:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_SPEED_LIMIT;
               break;
            case MENU_SETTINGS_MAP:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_MAP;
               break;
            case MENU_SETTINGS_MAP_POI_VISIBILITY:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_MAP_POI_VISIBILITY;
               break;
            case MENU_SETTINGS_TMC_AVOIDANCE_TYPE:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_TMC_AVOIDANCE_TYPE;
               break;
            case MENU_SETTINGS_TMC_STATIONS_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_TMC_STATIONS_LIST;
               break;
            case MENU_SETTINGS_SECRETS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_SECRETS;
               break;
            case MENU_SETTINGS_SECRETS_NDR_INFO:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_SECRETS_NDR_INFO;
               break;
            case MENU_SETTINGS_EASTER_HMI_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_HMI_SETTINGS;
               break;
            case MENU_SETTINGS_EASTER_NAVISERVER:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_NAVISERVER;
               break;
            case MENU_SETTINGS_EASTER_POSITIONING:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_POSITIONING;
               break;
            case MENU_SETTINGS_EASTER_SYSTEM:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_SYSTEM;
               break;
            case MENU_SETTINGS_EASTER_VEHICLE_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_VEHICLE_SETTINGS;
               break;
            case MENU_SETTINGS_EASTER_LIVE_SERVICES:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_LIVE_SERVICES;
               break;
            case MENU_SETTINGS_EASTER_DEMO_POSITIONS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_DEMO_POSITIONS;
               break;
            case MENU_SETTINGS_OTA_UPDATE:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_OTA_UPDATE;
               break;
            case MENU_SETTINGS_MAP_THEMES:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_MAP_THEMES;
               break;
            case MENU_TRIP_COMPUTER:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_TRIP_COMPUTER;
               break;
            case MENU_AVOID_IN_ROUTE_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_AVOID_IN_ROUTE_LIST;
               break;
            case MENU_OPTIONS_IN_ROUTE_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_OPTIONS_IN_ROUTE_LIST;
               break;
            case MENU_MAP_TURN_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_MAP_TURN_LIST;
               break;
            case MENU_MAP_TURN_LIST_DETOUR:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_MAP_TURN_LIST_DETOUR;
               break;
            case MENU_MAP_TURN_LIST_INTERCHANGE:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_MAP_TURN_LIST_INTERCHANGE;
               break;
            case MENU_TRAIL_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_TRAIL_LIST;
               break;
            case MENU_TMC_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_TMC_SETTINGS;
               break;
            case MENU_MAP_SCROLLING_POI_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_MAP_SCROLLING_POI_LIST;
               break;
            case MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST:
               goToAddress = mMenuNavTabList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST;
               break;
            case MENU_LIVE_SERVICES_DESTINATION_LIST_WEATHER:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_DESTINATION_LIST_WEATHER;
               break;
            case MENU_LIVE_SERVICES_DESTINATION_LIST_LOCALSEARCH:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_DESTINATION_LIST_LOCALSEARCH;
               break;
            case MENU_LIVE_SERVICES_LS_SPEED_CAM_ALERT_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAM_ALERT_SETTINGS;
               break;
            case MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_LIST;
               break;
            case MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_SPEED:
               goToAddress = mMenuSetCameraSpeed;
               break;
            case MENU_TRIPS_SPELLER_NEW_TRIP:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRIPS_SPELLER_NEW_TRIP;
               break;
            case MENU_TRIPS_SPELLER_RENAME_TRIP:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRIPS_SPELLER_RENAME_TRIP;
               break;
            case MENU_TRIPS_SPELLER_RENAME_DESTINATION:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRIPS_SPELLER_RENAME_DESTINATION;
               break;
            case MENU_TRIPS_SPELLER_PHONE_DESTINATION:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRIPS_SPELLER_PHONE_DESTINATION;
               break;
            case MENU_CONFIRM_ROUTE_SAVE:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_CONFIRM_ROUTE_SAVE;
               break;
            case MENU_MY_DESTINATIONS_RENAME:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_MY_DESTINATIONS_RENAME;
               break;
            case MENU_MY_DESTINATIONS_PHONE_NUMBER:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_MY_DESTINATIONS_PHONE_NUMBER;
               break;
            case MENU_FAVORITE_DESTINATIONS_RENAME:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_RENAME;
               break;
            case MENU_FAVORITE_DESTINATIONS_PHONE:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_PHONE;
               break;
            case MENU_FAVORITE_DESTINATIONS_SAVE_CURRENT:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_SAVE_CURRENT;
               break;
            case MENU_FAVORITE_DESTINATIONS_ADD_DEST_SPELLER:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_DEST_SPELLER;
               break;
            case MENU_FAVORITE_DESTINATIONS_ADD_CONTACT_SPELLER:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_CONTACT_SPELLER;
               break;
            case MENU_WHERE_AM_I_SAVE:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_WHERE_AM_I_SAVE;
               break;
            case MENU_TRAIL_SPELLER_SAVE:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRAIL_SPELLER_SAVE;
               break;
            case MENU_TRAIL_SPELLER_RENAME:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_TRAIL_SPELLER_RENAME;
               break;
            case MENU_MAP_DESTINATION_INFO_SAVE:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_MAP_DESTINATION_INFO_SAVE;
               break;
            case MENU_SETTINGS_EASTER_DEMO_POSITION_NAME:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_SETTINGS_EASTER_DEMO_POSITION_NAME;
               break;
            case MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER;
               break;
            case MENU_WHERE_TO:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_WHERE_TO;
               break;
            case MENU_INFORMATION:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_INFORMATION;
               break;
            case MENU_HOME_ADD_DESTINATION:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_HOME_ADD_DESTINATION;
               break;
            case MENU_TRIPS_ADD_DESTINATION:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_TRIPS_ADD_DESTINATION;
               break;
            case MENU_FAVORITE_DESTINATIONS_ADD_DEST:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_DEST;
               break;
            case MENU_FAVORITE_DESTINATIONS_ADD_CONTACT:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_CONTACT;
               break;
            case MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN;
               break;
            case MENU_LIVE_SERVICES_HDT_ADD_HOME:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME;
               break;
            case MENU_LIVE_SERVICES_HDT_ADD_WORK:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK;
               break;
            case MENU_LIVE_SERVICES_LS_SPEED_CAMERAS:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS;
               break;
            case MENU_LIVE_SERVICES_LS_WEATHER:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_WEATHER;
               break;
            case MENU_LIVE_SERVICES_LS_LOCAL_SEARCH:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH;
               break;
            case MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO;
               break;
            case MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:
               goToAddress = mMenuWhereTo;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO;
               break;
            case MENU_LIVE_SERVICES_HDT_CHANGE_HOME_WORK:
               goToAddress = mMenuEntryAddress;
               goToObject.ext = NavMenus.MENU_LIVE_SERVICES_HDT_CHANGE_HOME_WORK;
               break;
            case MENU_LIVE_SERVICES_LS_WEATHER_DETAILS:
               goToAddress = mMenuWeatherDetails;
               break;
            case MENU_SETTINGS_GUIDANCE_TMC_DELAY:
               goToAddress = mMenuPoiByPhoneSpeller;
               goToObject.ext = NavMenus.MENU_SETTINGS_GUIDANCE_TMC_DELAY;
               break;
            case MENU_SETTINGS_SPEED_SPELLER:
               goToAddress = mMenuPoiByPhoneSpeller;
               goToObject.ext = NavMenus.MENU_SETTINGS_SPEED_SPELLER;
               break;
            case MENU_GEO_SPELLER:
               goToAddress = mMenuGeoCoordinateSpeller;
               goToObject.ext = NavMenus.MENU_GEO_SPELLER;
               break;
            case MENU_SETTINGS_DEMO_MODE_COORD_SPELL:
               goToAddress = mMenuGeoCoordinateSpeller;
               goToObject.ext = NavMenus.MENU_SETTINGS_DEMO_MODE_COORD_SPELL;
               break;
            case MENU_TMC_EVENTS_ZOOM:
               goToAddress = mMenuMapEventZoom;
               goToObject.ext = NavMenus.MENU_TMC_EVENTS_ZOOM;
               break;
            case MENU_TMC_EVENT_ZOOM_MAP:
               goToAddress = mMenuMapEventZoom;
               goToObject.ext = NavMenus.MENU_TMC_EVENT_ZOOM_MAP;
               break;
            case MENU_VICS_PARKING_ZOOM_MAP:
               goToAddress = mMenuMapEventZoom;
               goToObject.ext = NavMenus.MENU_VICS_PARKING_ZOOM_MAP;
               break;
            case MENU_TMC_MY_TRAFFIC:
               goToAddress = mMenuMapEventZoom;
               goToObject.ext = NavMenus.MENU_TMC_EVENT_ZOOM_MAP;
               break;
            case MENU_SETTINGS_MAP_VEHICLE_ICONS:
               goToAddress = mMenuVehicleIcons;
               break;
            case MENU_NAV_READY_ANNOUNCEMENT:
               goToAddress = mMenuNavReadyPopup;
               break;
            case MENU_NAV_READY_SPELLER:
               goToAddress = mMenuNavSpeller;
               goToObject.ext = NavMenus.MENU_NAV_READY_SPELLER;
               break;
            case MENU_NAV_READY_ACCEPTED:
               goToAddress = mMenuNavReadyPopup;
               break;
            case MENU_NAV_READY_DECLINED:
               goToAddress = mMenuNavReadyPopup;
               break;
            case MENU_NAV_READY_WAIT:
               goToAddress = mMenuNavReadyPopup;
               break;
            case MENU_NAV_READY_PUNISHMENT:
               goToAddress = mMenuNavReadyPopup;
               break;
            case MENU_LIVE_SERVICES_CONSENT_DISCLAIMER:
               goToAddress = mMenuPopupFullScreen3Item;
               break;
            case MENU_LIVE_SERVICES_CONSENT_REVIEW:
               goToAddress = mMenuInformationSharing;
               break;
            case MENU_VICS:
               goToAddress = mMenuVics;
               break;
            case MENU_VICS_DARC:
               goToAddress = mMenuVICSDarc;
               break;
            case MENU_VICS_DARC_MENU:
               goToAddress = mMenuVICSDarcMenu;
               break;
            case MENU_VICS_BEACON:
               goToAddress = mMenuVICSBeacon;
               break;
            case MENU_VICS_INTSCREEN:
               goToAddress = mMenuVICSInterruptScreen;
               break;
            case MENU_VICS_MSG_LIST:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_VICS_MSG_LIST;
               break;
            case MENU_VICS_SETTINGS:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_VICS_SETTINGS;
               break;
            case MENU_VICS_SETTINGS_PREF:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_VICS_SETTINGS_PREF;
               break;
            case MENU_SETTINGS_ETC:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_ETC;
               break;
            case MENU_SETTINGS_ETC_HISTORY:
               goToAddress = mMenuNavList;
               goToObject.ext = NavMenus.MENU_SETTINGS_ETC_HISTORY;
               break;
            case MENU_KANJI_LIST:
               goToAddress = mMenuNavList;
               break;
            case MENU_MAP_ROUTE_OVERVIEW:
               goToAddress = mMenuRouteOverview;
               break;
            case MENU_DOMAIN_RETURN_SWITCH_MARKER:
               if(this.mDomainSwitchScreenName != null)
               {
                  Framework.Trace("NavMenus.MENU_DOMAIN_RETURN_SWITCH_MARKER -> \'" + this.mDomainSwitchScreenName["screenName"] + "\' \'" + this.mDomainSwitchScreenName["show"] + "\'");
                  if(this.mDomainSwitchScreenName["show"] != null)
                  {
                     goToAddress = this.mDomainSwitchScreenName["screenName"];
                     goToObject.show = String(this.mDomainSwitchScreenName["show"]);
                  }
                  else
                  {
                     goToAddress = this.mDomainSwitchScreenName["screenName"];
                  }
               }
               else
               {
                  Framework.Trace("NavMenus.MENU_DOMAIN_RETURN_SWITCH_MARKER -> NO RETURN SCREEN DECLARED!");
               }
               break;
            default:
               Framework.Trace("NavMenus.activateMenu() DO NOT KNOW WHAT MENU TO ACTIVATE.");
         }
         if(this.isBack)
         {
            goToObject.isBack = true;
            this.isBack = false;
         }
         if(goToAddress != "")
         {
            Framework.structure.goto(goToAddress,goToObject);
         }
      }
      
      public function deactivateMenu(menu:int, sendFLowBack:Boolean) : Boolean
      {
         Framework.Trace("NavMenus.deactivateMenu:" + menu + " flowBack:" + sendFLowBack);
         if(menu == 19)
         {
            Framework.Trace("deactivateMenu catch");
         }
         switch(menu)
         {
            case MENU_FLOW_INPUT_LOCATION:
               this.activateLocationIputFlow(false);
               if(sendFLowBack)
               {
                  LocationInputApi.api.liOnBack();
               }
               return false;
            case MENU_FLOW_INPUT_POI:
               this.activatePoiIputFlow(false);
               if(sendFLowBack)
               {
                  PoiInputApi.api.poiOnBack();
               }
               return false;
            case MENU_FLOW_TRIP_ASSEMBLER:
               this.activateTripAssmblerFlow(false);
               if(sendFLowBack)
               {
                  TripAssemblerApi.api.onBack();
               }
               return false;
            default:
               return true;
         }
      }
      
      public function setDomainSwitchScreenName(returnScreen:Object) : void
      {
         this.mDomainSwitchScreenName = returnScreen;
      }
      
      public function setBackFlag() : void
      {
         this.isBack = true;
      }
      
      public function activateLocationIputFlow(activate:Boolean) : void
      {
         if(activate)
         {
            LocationInputApi.api.addEventListener(LocationInputEvent.LI_ACTIVE_MENU,this.onLI_InputMenu,false,0,true);
            LocationInputApi.api.liGetActiveMenu();
         }
         else
         {
            LocationInputApi.api.removeEventListener(LocationInputEvent.LI_ACTIVE_MENU,this.onLI_InputMenu);
            this.deactivateCurrentLocationInputScreen();
         }
      }
      
      public function activatePoiIputFlow(activate:Boolean) : void
      {
         if(activate)
         {
            PoiInputApi.api.addEventListener(PoiInputEvent.POI_ACTIVE_MENU,this.onPOI_InputMenu,false,0,true);
            PoiInputApi.api.poiGetActiveMenu();
         }
         else
         {
            PoiInputApi.api.removeEventListener(PoiInputEvent.POI_ACTIVE_MENU,this.onPOI_InputMenu);
            this.deactivateCurrentPoiInputScreen();
         }
      }
      
      public function activateTripAssmblerFlow(activate:Boolean) : void
      {
         if(activate)
         {
            TripAssemblerApi.api.addEventListener(TripAssemblerEvent.TRIP_ACTIVE_MENU,this.onTripAssembler_Menu,false,0,true);
            TripAssemblerApi.api.getActiveMenu();
         }
         else
         {
            TripAssemblerApi.api.removeEventListener(TripAssemblerEvent.TRIP_ACTIVE_MENU,this.onTripAssembler_Menu);
         }
      }
      
      private function onLI_InputMenu(e:LocationInputEvent) : void
      {
         Framework.Trace("NavMenus.onLI_InputMenu:" + LocationInputApi.api.liActiveMenu);
         if(this.mMenuStack.currentMenu != MENU_FLOW_INPUT_LOCATION)
         {
            Framework.Trace(" -During menu " + this.mMenuStack.currentMenu);
            return;
         }
         this.deactivateCurrentLocationInputScreen();
         mLocationInputMenu = int(LocationInputApi.api.liActiveMenu);
         switch(mLocationInputMenu)
         {
            case LocationInputMenu.UNDEFINED:
               this.mMenuStack.removeLastMenuNoDeactivate();
               break;
            case LocationInputMenu.SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_INPUT_LOCATION});
               break;
            case LocationInputMenu.LIST:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_INPUT_LOCATION});
               break;
            case LocationInputMenu.ENTRY_STREET_ADDRESS:
               Framework.structure.goto(mMenuEntryAddress,{"ext":NavMenus.MENU_FLOW_INPUT_LOCATION});
               break;
            case LocationInputMenu.ENTRY_INTERSECTION:
               Framework.structure.goto(mMenuEntryAddress,{"ext":NavMenus.MENU_FLOW_INPUT_LOCATION});
               break;
            case LocationInputMenu.GEO_SPELLER:
               Framework.structure.goto(mMenuGeoCoordinateSpeller,{"ext":NavMenus.MENU_FLOW_INPUT_LOCATION});
               break;
            default:
               Framework.Trace("harman.navigation.DomainControl.menuStack.NavMenus.onLI_InputMenu( " + mLocationInputMenu + " ) unknown Menu !!! ");
         }
      }
      
      private function deactivateCurrentLocationInputScreen() : void
      {
         Framework.Trace("NavMenus.deactivateCurrentLocationInputScreen:" + mLocationInputMenu);
      }
      
      private function onPOI_InputMenu(e:PoiInputEvent) : void
      {
         Framework.Trace("NavMenus.onPOI_InputMenu:" + PoiInputApi.api.poiActiveMenu);
         if(this.mMenuStack.currentMenu != MENU_FLOW_INPUT_POI)
         {
            Framework.Trace(" -During menu " + this.mMenuStack.currentMenu);
            return;
         }
         this.deactivateCurrentPoiInputScreen();
         mPoiInputMenu = int(PoiInputApi.api.poiActiveMenu);
         switch(mPoiInputMenu)
         {
            case PoiInputMenu.UNDEFINED:
               this.mMenuStack.removeLastMenuNoDeactivate();
               break;
            case PoiInputMenu.SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_INPUT_POI});
               break;
            case PoiInputMenu.MAIN:
               Framework.structure.goto(mMenuPoiMain);
               break;
            case PoiInputMenu.SEARCH_AREA:
               Framework.structure.goto(mMenuPoiSearchArea);
               break;
            case PoiInputMenu.EMERGENCY_LIST:
               Framework.structure.goto(mMenuPoiNavList);
               break;
            case PoiInputMenu.PHONE_SPELLER:
               Framework.structure.goto(mMenuPoiByPhoneSpeller,{"ext":NavMenus.MENU_FLOW_INPUT_POI});
               break;
            case PoiInputMenu.PHONE_LIST:
               Framework.structure.goto(mMenuPoiNavList);
               break;
            case PoiInputMenu.POI_LIST:
               Framework.structure.goto(mMenuPoiNavList);
               break;
            case PoiInputMenu.DESTINATION_LIST:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_INPUT_POI});
               break;
            default:
               Framework.Trace("NavMenus.onPOI_InputMenu() !!! unknown Menu!");
         }
      }
      
      private function deactivateCurrentPoiInputScreen() : void
      {
         Framework.Trace("NavMenus.deactivateCurrentPoiInputScreen:" + mPoiInputMenu);
      }
      
      private function onTripAssembler_Menu(e:TripAssemblerEvent) : void
      {
         Framework.Trace("NavMenus.onTripAssembler_Menu:" + TripAssemblerApi.api.activeMenu);
         if(this.mMenuStack.currentMenu != MENU_FLOW_TRIP_ASSEMBLER)
         {
            Framework.Trace(" -During menu " + this.mMenuStack.currentMenu);
            return;
         }
         switch(TripAssemblerApi.api.activeMenu)
         {
            case TripAssemblerMenu.UNDEFINED:
               this.mMenuStack.removeLastMenuNoDeactivate();
               break;
            case TripAssemblerMenu.DESTINATION_LIST_PRE_ORDER:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.DESTINATION_LIST_POST_ORDER:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.DESTINATION_LIST_OPTIONS:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.DESTINATION_LIST_AVOIDANCE_TYPES:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.DESTINATION_LIST_CHANGE_INTERCHANGE:
               Framework.structure.goto(mMenuNavList,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_ROUTE:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_EXTERNAL_DESTINATION:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_TRAIL:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_HOME_SET:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_HOME_ROUTE:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_TRIP_ADD_CONFIRM:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_DESTINATION_REORDER_INFO:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_LIVE_SERVICES_HOME:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.CONFIRM_LIVE_SERVICES_WORK:
               Framework.structure.goto(mMenuConfirmDestination,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.FAVORITE_WHERE_TO_SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.FAVORITE_CONTACT_SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.FAVORITE_SAVE_AS_SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.SAVE_AS_TRIP_SPELLER:
               Framework.structure.goto(mMenuNavSpeller,{"ext":NavMenus.MENU_FLOW_TRIP_ASSEMBLER});
               break;
            case TripAssemblerMenu.ROUTE_ALTERNATIVES:
               Framework.structure.goto(mMenuAlternativeRoutes,{"ext":TripAssemblerMenu.ROUTE_ALTERNATIVES});
               break;
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_HOME:
               Framework.structure.goto(mMenuAlternativeRoutes,{"ext":TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_HOME});
               break;
            case TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_WORK:
               Framework.structure.goto(mMenuAlternativeRoutes,{"ext":TripAssemblerMenu.CONFIRM_ROUTE_LIVE_SERVICES_WORK});
               break;
            default:
               Framework.Trace("NavMenus.onTripAssembler_Menu() !!! unknown Menu!");
         }
      }
      
      public function get isVRSupported() : Boolean
      {
         var region:int = VServiceGlobalSettings.navMarketConfig;
         if(region == VServiceGlobalSettings.MARKET_CHINA || region == VServiceGlobalSettings.MARKET_KOREA || region == VServiceGlobalSettings.MARKET_JAPAN)
         {
            return true;
         }
         return this.isVRSupported;
      }
   }
}

