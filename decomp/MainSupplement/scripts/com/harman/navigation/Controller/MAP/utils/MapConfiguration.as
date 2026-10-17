package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.enums.EisTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.MAP.enums.MapViewPort;
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   
   public class MapConfiguration
   {
      
      public static const INIT:int = -1;
      
      public static const UNDEFINED:int = 0;
      
      public static const MAP_FULL:int = 1;
      
      public static const MAP_CONFIRM_ROUTE:int = 2;
      
      public static const MAP_HALF_MAP:int = 3;
      
      public static const MAP_ZOOM_TMC:int = 4;
      
      public static const MAP_SCROLLING:int = 5;
      
      public static const MAP_HALF_MAP_ZOOM_LOCATION:int = 6;
      
      public static const MAP_ZOOM_ROUTE_SEGMENT:int = 7;
      
      public static const MAP_MEDIA:int = 8;
      
      public static const MAP_CONFIRM_ROUTE_ANIMATED:int = 9;
      
      public static const MAP_GRAPHICAL_WEATHER:int = 10;
      
      public static const MAP_GARAGE:int = 11;
      
      public static const MAP_CONFIRM_TMC_REROUTE:int = 12;
      
      public static const MAP_HALF_LIKE_FULL_MAP:int = 13;
      
      public static const MAP_HALF_LIKE_FULL_MAP_LOW_FPS:int = 14;
      
      public static const MAP_ROUTE_OVERVIEW:int = 15;
      
      private static const PERS_FULL_MAP_ZOOMLEVEL:String = "FZ:";
      
      private static const PERS_FULL_MAP_HEADING:String = "FH:";
      
      private static const PERS_FULL_MAP_VIEWTYPE:String = "FV:";
      
      private static const PERS_FULL_MAP_AUTOZOOM:String = "AZ:";
      
      private static const PERS_WEATHER_MAP_ZOOMLEVEL:String = "WZ:";
      
      private var mMapSettings:Array = new Array();
      
      private var mCurrentActiveSettingindex:int = -1;
      
      public function MapConfiguration()
      {
         super();
         this.init();
         this.setDefaults();
      }
      
      public function getConfig(id:int) : MapSettings
      {
         return this.mMapSettings[id];
      }
      
      public function setActiveMapSettings(id:int) : void
      {
         this.mCurrentActiveSettingindex = id;
      }
      
      public function get activeMapSettingIndex() : int
      {
         return this.mCurrentActiveSettingindex;
      }
      
      public function get activeMapSetting() : MapSettings
      {
         return this.mMapSettings[this.mCurrentActiveSettingindex];
      }
      
      public function replaceMapSetting(id:int, setting:MapSettings) : void
      {
         this.mMapSettings.splice(id,1,setting);
      }
      
      public function isActive(id:int) : Boolean
      {
         if(this.mCurrentActiveSettingindex == id)
         {
            return true;
         }
         return false;
      }
      
      public function loadFromPersistence(persist:String) : void
      {
         var index:int = 0;
         index = persist.indexOf(PERS_FULL_MAP_ZOOMLEVEL) + PERS_FULL_MAP_ZOOMLEVEL.length;
         MapSettings(this.mMapSettings[MAP_FULL]).setZoomLevel(int(persist.substring(index,persist.indexOf(" ",index))));
         index = persist.indexOf(PERS_FULL_MAP_HEADING) + PERS_FULL_MAP_HEADING.length;
         MapSettings(this.mMapSettings[MAP_FULL]).setHeading(int(persist.substring(index,persist.indexOf(" ",index))));
         index = persist.indexOf(PERS_FULL_MAP_VIEWTYPE) + PERS_FULL_MAP_VIEWTYPE.length;
         MapSettings(this.mMapSettings[MAP_FULL]).setViewType(int(persist.substring(index,persist.indexOf(" ",index))));
         index = persist.indexOf(PERS_FULL_MAP_AUTOZOOM) + PERS_FULL_MAP_AUTOZOOM.length;
         MapSettings(this.mMapSettings[MAP_FULL]).setAutoZoomSetting(int(persist.substring(index,persist.indexOf(" ",index))));
         MapSettings(this.mMapSettings[MAP_MEDIA]).setAutoZoomSetting(int(persist.substring(index,persist.indexOf(" ",index))));
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP]).setAutoZoomSetting(int(persist.substring(index,persist.indexOf(" ",index))));
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP_LOW_FPS]).setAutoZoomSetting(int(persist.substring(index,persist.indexOf(" ",index))));
         index = persist.indexOf(PERS_WEATHER_MAP_ZOOMLEVEL) + PERS_FULL_MAP_HEADING.length;
         MapSettings(this.mMapSettings[MAP_GRAPHICAL_WEATHER]).setZoomLevel(int(persist.substring(index,persist.indexOf(" ",index))));
      }
      
      public function saveToPersistence() : String
      {
         var persistence:String = "";
         return " " + PERS_FULL_MAP_ZOOMLEVEL + MapSettings(this.mMapSettings[MAP_FULL]).zoomLevel + " " + PERS_FULL_MAP_HEADING + MapSettings(this.mMapSettings[MAP_FULL]).heading + " " + PERS_FULL_MAP_VIEWTYPE + MapSettings(this.mMapSettings[MAP_FULL]).viewType + " " + PERS_FULL_MAP_AUTOZOOM + MapSettings(this.mMapSettings[MAP_FULL]).autoZoomSetting + " " + PERS_WEATHER_MAP_ZOOMLEVEL + MapSettings(this.mMapSettings[MAP_GRAPHICAL_WEATHER]).zoomLevel + " ";
      }
      
      private function init() : void
      {
         this.mMapSettings.push(new MapSettings(UNDEFINED));
         this.mMapSettings.push(new MapSettings(MAP_FULL));
         this.mMapSettings.push(new MapSettings(MAP_CONFIRM_ROUTE));
         this.mMapSettings.push(new MapSettings(MAP_HALF_MAP));
         this.mMapSettings.push(new MapSettings(MAP_ZOOM_TMC));
         this.mMapSettings.push(new MapSettings(MAP_SCROLLING));
         this.mMapSettings.push(new MapSettings(MAP_HALF_MAP_ZOOM_LOCATION));
         this.mMapSettings.push(new MapSettings(MAP_ZOOM_ROUTE_SEGMENT));
         this.mMapSettings.push(new MapSettings(MAP_MEDIA));
         this.mMapSettings.push(new MapSettings(MAP_CONFIRM_ROUTE_ANIMATED));
         this.mMapSettings.push(new MapSettings(MAP_GRAPHICAL_WEATHER));
         this.mMapSettings.push(new MapSettings(MAP_GARAGE));
         this.mMapSettings.push(new MapSettings(MAP_CONFIRM_TMC_REROUTE));
         this.mMapSettings.push(new MapSettings(MAP_HALF_LIKE_FULL_MAP));
         this.mMapSettings.push(new MapSettings(MAP_HALF_LIKE_FULL_MAP_LOW_FPS));
         this.mMapSettings.push(new MapSettings(MAP_ROUTE_OVERVIEW));
      }
      
      private function setDefaults() : void
      {
         MapSettings(this.mMapSettings[MAP_FULL]).setAutoZoomSetting(NavGlobalSettings.MAP_AUTOZOOM_FACTORY_DEFAULT);
         MapSettings(this.mMapSettings[MAP_MEDIA]).setAutoZoomSetting(NavGlobalSettings.MAP_AUTOZOOM_FACTORY_DEFAULT);
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP]).setAutoZoomSetting(NavGlobalSettings.MAP_AUTOZOOM_FACTORY_DEFAULT);
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP_LOW_FPS]).setAutoZoomSetting(NavGlobalSettings.MAP_AUTOZOOM_FACTORY_DEFAULT);
         MapSettings(this.mMapSettings[MAP_FULL]).setup(Object({"value":MapZoomLevels.LEVEL_2}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_CAR_POSITION}),Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MR]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[UNDEFINED]).setup(Object({"value":null}),Object({"value":null}),Object({"value":null}),Object({"value":null}),Object({"value":MapSettingTypes.MAP_FRAMERATE_LOW}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MR]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_CONFIRM_ROUTE]).setup(Object({"value":null}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_MID}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_ROUTE_OVERVIEW]).setup(Object({"value":null}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_PREVIEW}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_MID}),Object({"value":MapViewPort.OVERVIEW_MAP[EisTypes.MP]}),Object({"value":MapViewPort.OVERVIEW_MAP[EisTypes.MR]}),Object({"value":MapViewPort.OVERVIEW_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.OVERVIEW_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_HALF_MAP]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,MapSettings(this.mMapSettings[MAP_FULL]).objDetachedFromVehicle,Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_ZOOM_TMC]).setup(Object({"value":MapZoomLevels.LEVEL_5}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.FULL_TMC_EVENT[EisTypes.MP]}),Object({"value":MapViewPort.FULL_TMC_EVENT[EisTypes.MR]}),Object({"value":MapViewPort.FULL_TMC_EVENT[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_TMC_EVENT[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_SCROLLING]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_SCROLLING}),Object({"value":MapViewPort.FULL_SCROLLING[EisTypes.MP]}),Object({"value":MapViewPort.FULL_SCROLLING[EisTypes.MR]}),Object({"value":MapViewPort.FULL_SCROLLING[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_SCROLLING[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_HALF_MAP_ZOOM_LOCATION]).setup(Object({"value":MapZoomLevels.LEVEL_2}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_ZOOM_ROUTE_SEGMENT]).setup(Object({"value":MapZoomLevels.LEVEL_2}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.FULL_SHOW_TURN[EisTypes.MP]}),Object({"value":MapViewPort.FULL_SHOW_TURN[EisTypes.MR]}),Object({"value":MapViewPort.FULL_SHOW_TURN[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_SHOW_TURN[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_MEDIA]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,MapSettings(this.mMapSettings[MAP_FULL]).objDetachedFromVehicle,Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.MEDIA_MAP[EisTypes.MP]}),Object({"value":MapViewPort.MEDIA_MAP[EisTypes.MR]}),Object({"value":MapViewPort.MEDIA_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.MEDIA_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,MapSettings(this.mMapSettings[MAP_FULL]).objDetachedFromVehicle,Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_HALF_LIKE_FULL_MAP_LOW_FPS]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,MapSettings(this.mMapSettings[MAP_FULL]).objDetachedFromVehicle,Object({"value":MapSettingTypes.MAP_FRAMERATE_PHONECALL}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_CONFIRM_ROUTE_ANIMATED]).setup(MapSettings(this.mMapSettings[MAP_FULL]).objZoomLevel,MapSettings(this.mMapSettings[MAP_FULL]).objHeading,MapSettings(this.mMapSettings[MAP_FULL]).objViewType,MapSettings(this.mMapSettings[MAP_FULL]).objDetachedFromVehicle,Object({"value":MapSettingTypes.MAP_FRAMERATE_MID}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_GRAPHICAL_WEATHER]).setup(Object({"value":MapZoomLevels.LEVEL_2}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_2D}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_HIGH}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MR]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.FULL_MAP[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_GARAGE]).setup(Object({"value":MapZoomLevels.LEVEL_2}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_GARAGE}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_GARAGE}),Object({"value":MapViewPort.GARAGE[EisTypes.MP]}),Object({"value":MapViewPort.GARAGE[EisTypes.MR]}),Object({"value":MapViewPort.GARAGE[EisTypes.MVP]}),Object({"value":MapViewPort.GARAGE[EisTypes.MVR]}));
         MapSettings(this.mMapSettings[MAP_CONFIRM_TMC_REROUTE]).setup(Object({"value":null}),Object({"value":MapSettingTypes.ORIENTATION_NORTH_UP}),Object({"value":MapSettingTypes.VIEW_TYPE_PREVIEW}),Object({"value":MapSettingTypes.SCROLL_MODE_DETACH_CAR}),Object({"value":MapSettingTypes.MAP_FRAMERATE_MID}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MR]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVP]}),Object({"value":MapViewPort.HALF_MAP[EisTypes.MVR]}));
      }
   }
}

