package com.harman.navigation.Controller.MAP.enums
{
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   
   public class MapAppearanceTypes
   {
      
      public static const SHOW_STREET_CURRENT:int = 1 << 0;
      
      public static const SHOW_STREET_MANEUVER:int = 1 << 1;
      
      public static const SHOW_FOREST_AREAS:int = 1 << 2;
      
      public static const SHOW_POI_ICONS:int = 1 << 3;
      
      public static const SHOW_PARK_AREAS:int = 1 << 4;
      
      public static const SHOW_RAILROADS:int = 1 << 5;
      
      public static const SHOW_CITY_AREAS:int = 1 << 6;
      
      public static const SHOW_RIVER_NAMES:int = 1 << 7;
      
      public static const SHOW_3D_LANDMARKS:int = 1 << 8;
      
      public static const SHOW_3D_TERRAIN:int = 1 << 9;
      
      public static const SHOW_3D_CITY:int = 1 << 10;
      
      public static const SHOW_JUNCTION_VIEW:int = 1 << 11;
      
      public static const SHOW_LANE_RECOMMENDATION:int = 1 << 12;
      
      public static const SHOW_SAFETY_CAMERA:int = 1 << 13;
      
      public static const MAP_FULL_FPS:int = 1 << 14;
      
      public static const MAP_REAL_2D:int = 1 << 15;
      
      public static const INSTRUMENT_CLUSTER_OPTION_OVERRIDE:int = 1 << 16;
      
      public static const SHOW_HIGHWAY_MODE:int = 1 << 17;
      
      public static const SHOW_SCROLLING_SCREEN_DISTANCE:int = 1 << 18;
      
      public static const MAP_SHOW_MANEUVER_AUTO_JUMP_TO_NEXT:int = 1 << 19;
      
      public static const SHOW_HIGHWAY_MODE_IN_SETTINGS:int = 1 << 20;
      
      public static const MAP_CALIBRATION_MESSAGE_REMOVE:int = 1 << 21;
      
      public static const TRACE_SHOW_POS_ERRORS_ON_MAP:int = 1 << 22;
      
      public static const SHOW_MY_TRAFFIC:int = 1 << 23;
      
      public static const SHOW_MAP_GRID:int = 1 << 24;
      
      private var mSettings:int = NavGlobalSettings.MAP_APPEARANCE_FACTORY_DEFAULT;
      
      public function MapAppearanceTypes()
      {
         super();
      }
      
      public function toPersistence() : int
      {
         return this.mSettings;
      }
      
      public function fromPersistence(settings:int) : void
      {
         this.mSettings = settings;
      }
      
      public function toggleAppearance(type:int) : void
      {
         this.mSettings ^= type;
      }
      
      public function isSet(type:int) : Boolean
      {
         return (this.mSettings & type) == type ? true : false;
      }
   }
}

