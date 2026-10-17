package com.harman.navigation.DomainControl
{
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.enums.SafetyCameraMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.graphicalWeather.GraphicalWeatherTypes;
   import com.harman.navigation.tmc.TmcTypes;
   import com.nfuzion.framework.global.Framework;
   
   public class NavGlobalSettings
   {
      
      public static const LIST_SIZE:int = 999;
      
      public static const LIST_SIZE_CLOSEST_CITIES:int = 12;
      
      public static const POI_PRESET_LIST_SIZE:int = 30;
      
      public static const LIST_ITEMS_PER_PAGE:int = 6;
      
      public static const RECENT_DESTINATIONS_MAX:int = 60;
      
      public static const RECENT_DESTINATIONS_PINNED_MAX:int = 48;
      
      public static const MAX_DESTINATION_NAME_LENGTH:int = 30;
      
      public static const MAX_PHONE_NUMBER_LENGTH:int = 25;
      
      public static const PHONE_NUMBER_SPELLER_CHARACTERS:String = "0123456789() +-#*";
      
      public static const FAVORITE_DESTINATIONS_MAX:int = 60;
      
      public static const POI_BY_PHONE_LIST_ENABLE_MIN:int = 30;
      
      public static const POI_BY_NAME_MAX_CHARACTERS:int = 30;
      
      public static const POI_BY_PHONE_DIGITS_MIN:int = 3;
      
      public static const UNDEFINED:int = 900;
      
      public static const IS_PC_SIM:Boolean = false;
      
      private static const ICON_PATH_PREFIX_PC_SIM:String = ".";
      
      private static const ICON_PATH_PREFIX_TARGET:String = "./../../../";
      
      public static const DATABASE_UPDATE_CHECK_TIMEOUT:int = 40000;
      
      public static const PERSISTENCE_WRITE_FAIL_RETRY_MAX:int = 5;
      
      public static var TMC_DISTANCE_FIILTER_DEFAULT:int = 72000;
      
      public static var TMC_DISTANCE_FIILTER_NA:int = 72000;
      
      public static var TMC_DISTANCE_FIILTER_EU:int = 250000;
      
      public static var TMC_DISTANCE_FIILTER_ROW:int = 150000;
      
      public static const TMC_DEFAULT_ROUTE_MODE:int = TmcTypes.ROUTE_MODE_MANUAL;
      
      public static const TMC_DEFAULT_DELAY_TIME:int = 5;
      
      public static const TMC_DEFAULT_TUNING_MODE:int = TmcTypes.TUNING_MODE_AUTO;
      
      public static const INSTRUMENT_CLUSTER_ENABLED_DEFAULT:Boolean = true;
      
      public static const MAP_DEFAULT_ZOOM_LEVEL_MAP_FULL:int = MapZoomLevels.LEVEL_5;
      
      public static const MAP_AUTO_NORTH_UP_LEVEL:int = MapZoomLevels.LEVEL_17;
      
      public static const MAP_CONFIRM_DESTINATION_ZOOM_TIMEOUT:int = 6000;
      
      public static const MAP_APPEARANCE_FACTORY_DEFAULT:int = MapAppearanceTypes.SHOW_STREET_CURRENT | MapAppearanceTypes.SHOW_RAILROADS | MapAppearanceTypes.SHOW_CITY_AREAS | MapAppearanceTypes.SHOW_JUNCTION_VIEW | MapAppearanceTypes.SHOW_LANE_RECOMMENDATION | MapAppearanceTypes.SHOW_SCROLLING_SCREEN_DISTANCE | MapAppearanceTypes.MAP_SHOW_MANEUVER_AUTO_JUMP_TO_NEXT;
      
      public static const MAP_DESTINATION_INFO_FATOCRY_DEFAULT:int = MapSettingTypes.DESTINATION_INFO_TIME_TO_DESTINATION;
      
      public static const MAP_ZOOM_LEVEL_CHANGE_ABUSE_THRESHOLD:int = 300;
      
      public static const MAP_ZOOM_LEVEL_FRAMERATE_RAISE_TIMEOUT:int = 5000;
      
      public static const MAP_AUTOZOOM_OVERIDE_TIME_OUT:int = 30000;
      
      public static const MAP_FULL_ROUTE_MINIMUM_TIME_THRESHOLD:int = 500;
      
      public static const MAP_AUTOZOOM_FACTORY_DEFAULT:int = MapZoomLevels.LEVEL_AUTO_NORMAL;
      
      public static const MAP_TMC_EVENT_ZOOM_CHANGE_ABUSE_THRESHOLD:int = 300;
      
      public static const MAP_DISABLE_TIMEROUT:int = 200;
      
      public static const MAP_OFFROAD_MANEUVER_DELAY:int = 2000;
      
      public static const MAP_OPTIONS_POPUP_AUTO_CLOSE_DELAY:int = 30000;
      
      public static const MAP_DESTINATION_REACHED_AUTO_CLOSE_DELAY:int = -1;
      
      public static const MAP_CONFIRM_DESTINATION_AUTO_ACCEPT_DELAY_DEFAULT:int = -1;
      
      public static const MAP_ZOOM_LEVEL_REDUCED_FRAMERATE_THRESHOLD:int = 1000;
      
      public static const MAP_SPEED_LIMIT_ICON_POSITION_X_NO_HIGHWAY_MODE:int = Framework.resolution == Framework.RES_800_600 ? 700 : 576;
      
      public static const MAP_SPEED_LIMIT_ICON_POSITION_X_HIGHWAY_MODE:int = Framework.resolution == Framework.RES_800_600 ? 358 : 302;
      
      public static const MAP_MAGIC_NUMBER:int = 2;
      
      public static const POI_BY_NAME_ICON_LOCATION:String = "./img/nav_poi_by_name.bmp";
      
      public static const POI_MAIN_CATEGORY_ICON_SIZE:String = "100,100";
      
      public static const TRIPS_MAX_TRIPS:int = 11;
      
      public static const TRIPS_MAX_DESTINATIONS:int = 6;
      
      public static const TRIPS_ALLOW_DUPLICATE_NAMES:Boolean = true;
      
      public static const TRIPS_EXPORT_DIRECTORY:String = "/fs/usb0/CMC_Trips/";
      
      public static const TRIPS_EXPORT_BASE_NAME:String = "Trips_";
      
      public static const TRIPS_EXPORT_NAME_EXTENSION:String = ".trp";
      
      public static const TRIPS_EXPORT_ENABLE_KEY:String = "NavPressDriveImport";
      
      public static const TRAILS_MAX_TRAILS:int = 6;
      
      public static const TRAILS_NAME_LENGTH:int = 40;
      
      public static const TRAILS_SERVICE_REREQUEST_TIME:int = 20000;
      
      public static const FILE_TO_OBJECT_CRC_EXTENSION:String = ".chk";
      
      public static const ROUTE_GUIDANCE_MAX_DESTINATIONS:int = 8;
      
      public static const ROUTE_BLOCK_AHEAD_DISTANCES:Array = new Array(1,2,5,15,25);
      
      public static const DEFAULT_ROUTE_MODE:int = RouteMode.ROUTE_FASTEST | RouteMode.AVOID_SEASONALRESTRICTED | RouteMode.AVOID_TIMERESTRICTED | RouteMode.AVOID_UNPAVED;
      
      public static const GUIDANCE_RESTART_MIN_DISTANCE_US:int = 250;
      
      public static const GUIDANCE_RESTART_MIN_DISTANCE_ECE:int = 500;
      
      public static const GUIDANCE_RESTART_MIN_DISTANCE_ROW:int = 500;
      
      public static const GUIDANCE_RESTARTER_TIMEOUT:int = 20000;
      
      public static const GRAPHICAL_WEATHER_TRANSPARENCY_HIGH:int = 80;
      
      public static const GRAPHICAL_WEATHER_TRANSPARENCY_LOW:int = 40;
      
      public static const GRAPHICAL_WEATHER_TRANSPARENCY_DEFAULT:int = GRAPHICAL_WEATHER_TRANSPARENCY_HIGH;
      
      public static const GRAPHICAL_WEATHER_PRODUCT_VISIBILITY_DEFAULT:int = GraphicalWeatherTypes.STORM_POSITIONS | GraphicalWeatherTypes.STORM_WATCHBOXES | GraphicalWeatherTypes.WSI_NOWRAD;
      
      public static const GRAPHICAL_WEATHER_US_CENTER_COORDINATE:String = "-99.156616 39.099323";
      
      public static const POS_POSITION_UPDATE_HIGH:int = 1000;
      
      public static const POS_POSITION_UPDATE_LOW:int = 5000;
      
      public static const DEMO_MODE_COORDINATE_NORTH_AMERICA:String = "-083.462961 +42.391210";
      
      public static const DEMO_MODE_COORDINATE_EUROPE:String = "+009.972585 +48.399248";
      
      public static const DEMO_MODE_COORDINATE_ROW:String = "+117.887436 -35.001102";
      
      public static const DEMO_MODE_PERSISTENCE_LOCATION:String = "/fs/etfs/navDemoCoordinates.obj";
      
      public static const VOICE_GUIDANCE_ANNOUNCEMENTS_DEFAULT:Boolean = true;
      
      public static const SPEED_LIMIT_WARNING_ENABLED_DEFAULT:Boolean = false;
      
      public static const SPEED_LIMIT_WARNING_SPEED_DEFAULT:int = 0;
      
      public static const SAFETY_CAMERA_MODE:int = SafetyCameraMode.WARNING_OFF;
      
      public static const EXTERNAL_DESTINATION_ON_BACK_SCREEN:String = "NavMainMenu.swf";
      
      public static const GEO_COORDINATE_SPELLER_DEFAULT_FORMAT:int = GeoFormats.FORMAT_DMS;
      
      public static const VR_ACCEPT_PROP_LD_RESPONSE_TIME:int = 2000;
      
      public static const NAV_MAX_WARNING_REPORTS:int = 30;
      
      public static const NAV_TOOLS_ENABLE:String = "NavEastereggsON";
      
      public static const NAV_TOOLS_DISABLE:String = "NavEastereggsOFF";
      
      public static const NAV_TESTING_ENABLE:String = "NavVehTestON";
      
      public static const NAV_TESTING_DISABLE:String = "NavVehTestOFF";
      
      public static const NAV_SERVICE_ENABLE:String = "NavServiceON";
      
      public static const LI_LANGUAGE_CHANGE_POPUP_TIMEOUT:int = 3000;
      
      public static const CONFIRM_DESTINATION_SVE_HOME_POPUP_TIMEOUT:int = 2000;
      
      public static const NAV_WATCHDOG_MAX_RESTARTS:int = 5;
      
      public static const NAV_WATCHDOG_INTERVAL:int = 10000;
      
      public static const NAV_WATCHDOG_PATH_SERVICE:String = "/dev/serv-mon/com.harman.service.Navigation";
      
      public static const NAV_WATCHDOG_PATH_IPC:String = "/dev/name/local/navigation";
      
      public static const NAV_WATCHDOG_DISABLE_FLAG:String = "/fs/etfs/NAV_WATCHDOG_DISABLE";
      
      public static const TRACE_MAP_CONTROLLER:Boolean = true;
      
      public function NavGlobalSettings()
      {
         super();
      }
      
      public static function get POI_BY_PHONE_DIGITS_MAX() : int
      {
         switch(NavigationPackage.peripheral.versionInfo.productVariantID.VARIANT_MARKET)
         {
            case "ECE":
            case "TU":
            case "ROW":
               return 17;
            case "NA":
         }
         return 10;
      }
      
      public static function get ICON_PATH_PREFIX() : String
      {
         if(IS_PC_SIM)
         {
            return ICON_PATH_PREFIX_PC_SIM;
         }
         return ICON_PATH_PREFIX_TARGET;
      }
   }
}

