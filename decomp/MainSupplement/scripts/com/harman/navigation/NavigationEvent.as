package com.harman.navigation
{
   import flash.events.Event;
   
   public class NavigationEvent extends Event
   {
      
      public static const NAV_IS_READY:String = "Nav_IsReady";
      
      public static const NAV_ACTIVATION:String = "Nav_Activation";
      
      public static const NAV_ACTIVATION_RESPONSE:String = "Nav_Activation_Response";
      
      public static const NAV_PREVIOUS_ACTIVATION_CODE:String = "Nav_Previous_Activation_Code";
      
      public static const NAV_STARTUP_STATE:String = "Nav_StartupState";
      
      public static const NAV_DEMO_MODE:String = "Nav_DemoMode";
      
      public static const NAV_ADA_ENABLED:String = "Nav_AdaEnabled";
      
      public static const NAV_SPEED_WARNINGS:String = "Nav_SpeedWarnings";
      
      public static const NAV_SAFETY_CAMERA_MODE:String = "Nav_SafetyCameraMode";
      
      public static const NAV_VERSIONS:String = "Nav_Versions";
      
      public static const NAV_DEVICE_ID:String = "Nav_Device_ID";
      
      public static const NAV_INSTRUMENT_CLUSTER:String = "Nav_InstrumentCluster";
      
      public static const NAV_FACTORY_RESET:String = "Nav_FactoryReset";
      
      public static const PRODUCT_DEVICE_ID:String = "Product_Device_ID";
      
      public static const PRODUCT_ID:String = "Product_ID";
      
      public static const SPECIAL_FEATURES:String = "SpecialFeatures";
      
      public static const DEMO_MODE_POS_LIST_UPDATE:String = "DemoModePositionUpdate";
      
      public static const MAP_VISIBILITY:String = "MAP_Visibility";
      
      public static const MAP_POI_VISIBILITY:String = "MAP_Poi_Visibility";
      
      public static const MAP_POI_VIS_LISTCOUNT:String = "MAP_Poi_Vis_Listcount";
      
      public static const MAP_VEHICLE_ICONS:String = "MAP_Vehicle_Icons";
      
      public static const MAP_VEHICLE_ICON_CHANGE:String = "MAP_Vehicle_IconChange";
      
      public static const MAP_THEMES:String = "MAP_THEMES";
      
      public static const MAP_THEMES_CHANGE:String = "MAP_THEMES_CHANGE";
      
      public static const MAP_UPDATED_CONTROLS_CMD:String = "MAP_Updated_Controls_Cmd";
      
      public static const MAP_UPDATED_WORLD_ELEMENT_CMD:String = "MAP_Updated_World_Element_Cmd";
      
      public static const MAP_PICK_INFO_UPDATE:String = "MAP_Pick_Info_Update";
      
      public static const MAP_DETAILS:String = "MAP_Details";
      
      public static const POI_SEARCHAREA_CURRENT:String = "POI_SearchAreaCurrent";
      
      public static const POI_SEARCHAREA_DEFAULT:String = "POI_SearchAreaDefault";
      
      public static const POI_SEARCHAREA_RESTRICTION:String = "POI_SearchAreaRestriction";
      
      public static const POI_SEARCH_CITY:String = "POI_SearchCity";
      
      public static const POI_SEARCH_NEAR_DESTINATION:String = "POI_SearchNearDestination";
      
      public static const POI_SEARCHCATEGORIES:String = "POI_SearchCategories";
      
      public static const POI_CHARSAVAILABLE:String = "POI_CharactersAvailable";
      
      public static const POI_LIST:String = "POI_List";
      
      public static const POI_LISTCOUNT:String = "POI_ListCount";
      
      public static const POI_CHARSENTERED:String = "POI_CharactersEntered";
      
      public static const POI_EMPTY_CHARSENTERED:String = "POI_EmptyCharactersEntered";
      
      public static const POI_DETAILS:String = "POI_Details";
      
      public static const POI_PRESETS:String = "POI_Presets";
      
      public static const POI_PHONE_NUMBER_SPELL:String = "POI_Phone_Number_Spell";
      
      public static const POI_KEYBOARD_SPELL:String = "POI_Keyboard_Spell";
      
      public static const LI_GETSPELL:String = "LI_GetSpell";
      
      public static const LI_GETSPELL_FAILED:String = "LI_GetSpellFailed";
      
      public static const LI_GETLIST:String = "LI_GetList";
      
      public static const LI_GETDETAILS:String = "LI_GetDetails";
      
      public static const LI_GETDETAILS_FAILED:String = "LI_GetDetails_Failed";
      
      public static const LI_GETAVAILABLEINFO:String = "LI_GetAvailableInfo";
      
      public static const LI_GETAVAILABLE_INFORMATION:String = "LI_GetAvailableInformation";
      
      public static const LI_GETLISTCOUNT:String = "LI_GetListCount";
      
      public static const LI_GETALPHAJUMP:String = "LI_GetAlphaJump";
      
      public static const POS_POSITIONINFORMATION:String = "POS_PositionInformation";
      
      public static const POS_COMPASS:String = "POS_Compass";
      
      public static const POS_JUNCTION_VIEW_AVAILABLE:String = "POS_JunctionViewAvailable";
      
      public static const POS_CTT_SUM_AVAILABLE:String = "POS_CTTSumAvailable";
      
      public static const POS_IPD_AREA:String = "POS_IpdArea";
      
      public static const POS_HIGHWAY_EXIT_UPDATE:String = "POS_HighwayExitUpdate";
      
      public static const POS_HIGHWAY_MODE_ENABLED:String = "POS_HighwayModeEnabled";
      
      public static const NAV_DBUS_AVAILABLE_STATE:String = "DBusServiceAvailable";
      
      public static const RT_UPDATE_TURN_LIST:String = "RT_TurnList";
      
      public static const RT_UPDATE_ROUTE_ELEMENT:String = "RT_RouteElement";
      
      public static const RT_UPDATE_AVOIDANCE_TYPES:String = "RT_AvoidanceTypes";
      
      public static const RT_DESTROY_TRIP:String = "RT_DestroyTrip";
      
      public static const RT_BLOCK_ROUTE:String = "RT_BlockRoute";
      
      public static const RT_START_GUIDANCE:String = "RT_StartGuidance";
      
      public static const RT_NEW_TRIP:String = "RT_NewTrip";
      
      public static const RT_NEW_TRIP_FAIL:String = "RT_NewTripFail";
      
      public static const RT_NEW_TRIP_FILE:String = "RT_NewTripFile";
      
      public static const RT_NEW_TRIP_FILE_FAIL:String = "RT_NewTripFileFail";
      
      public static const RT_CALCULATION_STATE:String = "RT_CalculationState";
      
      public static const RT_NEXT_MANEUVER_INFO:String = "RT_NextManeuverInfo";
      
      public static const RT_DESTINATION_REACHED:String = "RT_DestinationReached";
      
      public static const RT_NEXT_DESTINATION_INFO:String = "RT_NextDestiantionInfo";
      
      public static const RT_ACTIVE_ROUTE_DESCRIPTION:String = "RT_ActiveRouteDescription";
      
      public static const RG_GUIDANCE_AVOIDANCE_INFO:String = "RG_GuidanceAvoidanceInfo";
      
      public static const RT_CHANGE_TRIP_RESPONSE:String = "RG_ChangeTripResponse";
      
      public static const RT_UPDATE_TMC_ALTERNATIVE_ROUTE_INFO:String = "RT_UpdateTMCAlternativeRouteInfo";
      
      public static const RT_INTERCHANGE_CURRENT:String = "RT_InterchangeCurrent";
      
      public static const RT_INTERCHANGE_CUR_FAILED:String = "RT_InterchangeCurrentFailed";
      
      public static const RT_INTERCHANGE_ALTERNATIVES:String = "RT_InterchangeAlternatives";
      
      public static const RT_INTERCHANGE_ALT_FAILED:String = "RT_InterchangeAlternativesFailed";
      
      public static const RT_INTERCHANGE_DIRECTIONS:String = "RT_InterchangeDirections";
      
      public static const RT_INTERCHANGE_DIR_FAILED:String = "RT_InterchangeDirectionsFailed";
      
      public static const RT_BORDER_CROSS_COUNT:String = "RT_BorderCrossCount";
      
      public static const GW_RENDERING_ENABLED:String = "GW_Rendering_Enabled";
      
      public static const GW_VISIBILITY:String = "GW_Visibility";
      
      public static const GW_NOWRAD_TRANSPARENCY:String = "GW_Nowrad_Transparency";
      
      public static const GW_ZOOM_LEVEL_INDEX:String = "GW_ZoomLevelIndex";
      
      public static const GW_PRODUCT_TIMESTAMP:String = "GW_ProductTimeStamp";
      
      public static const GW_ALERT_POPUP:String = "GW_AlertPopup";
      
      public static const GW_SHOW_ALERT_BUTTON:String = "GW_ShowAlertButton";
      
      public static const DB_SERVICE_READY:String = "DB_Service_ready";
      
      public static const DB_SERVICE_NOT_BUSY:String = "DB_Service_not_busy";
      
      public static const DB_FAVORITE_CHANGED:String = "DB_NAV_Favorite_Changed";
      
      public static const DB_FAVORITE_LIST_READY:String = "DB_NAV_Favorite_List_Ready";
      
      public static const DB_HOME_CHANGED:String = "DB_NAV_Home_Changed";
      
      public static const DB_HOME_READY:String = "DB_NAV_Home_Ready";
      
      public static const DB_RECENT_CHANGED:String = "DB_NAV_Recent_Changed";
      
      public static const DB_RECENT_LIST_READY:String = "DB_NAV_Recent_List_Ready";
      
      public static const TMC_EVENT_LIST:String = "TMC_Event_List";
      
      public static const TMC_EVENT_DETAILS:String = "TMC_Event_Details";
      
      public static const TMC_EVENTS_DELETED:String = "TMC_Events_Deleted";
      
      public static const TMC_ROUTE_MODE:String = "TMC_Route_Mode";
      
      public static const TMC_DELAY_TIME:String = "TMC_Delay_Time";
      
      public static const TMC_GROUP_TYPES:String = "TMC_Group_Types";
      
      public static const TMC_STATIONS_LIST:String = "TMC_Stations_List";
      
      public static const TMC_MANUAL_REROUTE:String = "TMC_Manual_Reroute";
      
      public static const TMC_STATION:String = "TMC_Station";
      
      public static const TMC_PREVIEW:String = "TMC_Preview";
      
      public static const TMC_DELAY_ON_ROUTE:String = "TMC_DelayOnRoute";
      
      public static const TRIP_COMPUTER:String = "Trip_Computer";
      
      public static const TRAIL_RECORDING_ACTIVE:String = "Trail_Recording_Active";
      
      public static const TRAIL_LIST_UPDATE:String = "Trail_List_Update";
      
      public static const TRAIL_SERVICE_READY:String = "Trail_Service_Ready";
      
      public static const TRAIL_SERVICE_EXECUTE:String = "Trail_Service_Execute";
      
      public static const NAV_LANGUAGE_CHANGED:String = "NavLanguageChanged";
      
      public static const NAV_OTA_AVAILABLE_PACKAGES:String = "NavOTAUAvailablePackages";
      
      public static const NAV_OTA_STATE_CHANGE:String = "NavOTAUStateChange";
      
      public static const TTLS_AUTHENTICATION_STATUS:String = "TTLS_AuthenticationStatus";
      
      public static const TTLS_LOCAL_SEARCH_UPDATE:String = "TTLS_LocalSearchUpdate";
      
      public static const TTLS_LOCAL_SEARCH_UPDATE_FAIL:String = "TTLS_LocalSearchUpdateFail";
      
      public static const TTLS_WEATHER_UPDATE:String = "TTLS_WeatherUpdate";
      
      public static const TTLS_WEATHER_UPDATE_FAIL:String = "TTLS_WeatherUpdateFail";
      
      public static const TTLS_SERVER_COMMUNICATION_UPDATE:String = "TTLS_ServerCommunicationUpdate";
      
      public static const TTLS_SERVICE_READY_UPDATE:String = "TTLS_ServiceReadyUpdate";
      
      public static const TTLS_TURN_ON_OFF_UPDATE:String = "TTLS_TurnOnOffStatus";
      
      public static const TTLS_SPEEDCAM_FEEDBACK_UPDATE:String = "TTLS_SpeedcamFeedbackUpdate";
      
      private var _reqId:int = -1;
      
      private var mData:Object = new Object();
      
      public function NavigationEvent(type:String, data:Object = null, reqId:int = -1, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._reqId = reqId;
         this.mData = data;
      }
      
      public function get reqId() : int
      {
         return this._reqId;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
      
      public function set data(data:Object) : void
      {
         this.mData = data;
      }
   }
}

