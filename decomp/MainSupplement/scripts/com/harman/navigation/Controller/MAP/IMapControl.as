package com.harman.navigation.Controller.MAP
{
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.MAP.utils.MapSettings;
   import com.harman.navigation.utils.PickInfoDetails;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IMapControl extends IModule
   {
      
      function selectConfiguration(param1:int) : void;
      
      function getMapConfiguration() : void;
      
      function get mapConfiguration() : int;
      
      function setPosition(param1:String, param2:int) : void;
      
      function get position() : String;
      
      function getZoomLevelForMapConfiguration(param1:int) : int;
      
      function setZoomLevelForMapConfiguration(param1:int, param2:int) : void;
      
      function setAutoZoomSetting(param1:int) : void;
      
      function getAutoZoomSetting() : void;
      
      function get autoZoomSetting() : int;
      
      function setZoomLevel(param1:int) : void;
      
      function getZoomLevel() : void;
      
      function get zoomLevel() : int;
      
      function getMapSettings(param1:int) : MapSettings;
      
      function setMapSettings(param1:int, param2:MapSettings) : void;
      
      function getPoiVisibilities() : void;
      
      function get poiVisibilities() : Array;
      
      function setPoiVisibility(param1:String, param2:Boolean) : void;
      
      function getVehicleIcons() : void;
      
      function get vehicleIcons() : Array;
      
      function setVehicleIcon(param1:VisibleObject) : void;
      
      function get activeVehicleIconID() : String;
      
      function get activeVehicleIconName() : String;
      
      function getMapThemes() : void;
      
      function get mapThemes() : Array;
      
      function setMapTheme(param1:VisibleObject) : void;
      
      function get activeMapThemeID() : String;
      
      function get activeMapThemeName() : String;
      
      function getMapAppearanceSettings() : void;
      
      function get mapAppearanceSettings() : MapAppearanceTypes;
      
      function toggleMapAppearance(param1:int) : void;
      
      function getMapDestinationInfoSetting() : void;
      
      function get mapDestinationInfoSetting() : int;
      
      function setMapDestinationInfoSetting(param1:int) : void;
      
      function getMapDestinationReachedScreenTimeout() : void;
      
      function get mapDestinationReachedScreenTimeout() : int;
      
      function setMapDestinationReachedScreenTimeout(param1:int) : void;
      
      function getMapConfirmDestinationAutoAcceptTimeout() : void;
      
      function get mapConfirmDestinationAutoAcceptTimeout() : int;
      
      function setMapConfirmDestinationAutoAcceptTimeout(param1:int) : void;
      
      function junctionViewOveride() : void;
      
      function get junctionViewActive() : Boolean;
      
      function cttSumOverride() : void;
      
      function get cttSumActive() : Boolean;
      
      function setTmcSetting(param1:int) : void;
      
      function getTmcSetting() : void;
      
      function get tmcSetting() : int;
      
      function scrollingScrollToDirection(param1:int, param2:int) : void;
      
      function scrollingStop() : void;
      
      function scrollingRequestPickInfo(param1:int, param2:int, param3:int, param4:int) : void;
      
      function getScrollingPickInfo() : void;
      
      function get scrollingPickInfo() : PickInfoDetails;
      
      function setTmcZoomEventInfo(param1:String) : void;
      
      function reinitializeMap() : void;
      
      function factoryReset() : void;
   }
}

