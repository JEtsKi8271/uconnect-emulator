package com.harman.navigation.tmc
{
   public class TmcTypes
   {
      
      public static const INFO_TYPE_DISABLE:int = 0;
      
      public static const INFO_TYPE_ON_ROUTE:int = 1 << 0;
      
      public static const INFO_TYPE_SIGNIFICENT:int = 1 << 1;
      
      public static const INFO_TYPE_NON_SIGNIFICENT:int = 1 << 2;
      
      public static const INFO_TYPE_ALL_MESSAGES:int = 1 << 3;
      
      public static const INFO_TYPE_AVOIDED:int = 1 << 4;
      
      public static const INFO_TYPE_IGNORED:int = 1 << 5;
      
      public static const INFO_TYPE_STRING_ON_ROUTE:String = "on_route";
      
      public static const INFO_TYPE_STRING_SIGNIFICENT:String = "significant";
      
      public static const INFO_TYPE_STRING_ALL_MESSAGES:String = "all";
      
      public static const UPDATE_MODE_DISABLE:int = 0;
      
      public static const UPDATE_MODE_ONCE:int = 1 << 0;
      
      public static const UPDATE_MODE_ON_CHANGE:int = 1 << 1;
      
      public static const UPDATE_MODE_FREQUENCY:int = 1 << 2;
      
      public static const MAP_ALL_DISABLED:int = 0;
      
      public static const MAP_SHOW_TMC_ONLY:int = 1;
      
      public static const MAP_SHOW_SPEED_AND_FLOW_ONLY:int = 2;
      
      public static const MAP_SHOW_ALL:int = 3;
      
      public static const MAP_SHOW_PARKING_ONLY:int = 4;
      
      public static const MAP_SHOW_INCIDENT_ONLY:int = 5;
      
      public static const MAP_SHOW_PARKING_AND_INCIDENT_ONLY:int = 6;
      
      public static const MAP_SHOW_PARKING_AND_SPEED_ONLY:int = 7;
      
      public static const MAP_SHOW_INCIDENT_AND_SPEED_ONLY:int = 8;
      
      public static const SHOW_TMC_EVENT:int = 1 << 0;
      
      public static const SHOW_SPEED_AND_FLOW:int = 1 << 1;
      
      public static const SHOW_INCIDENT_EVENT:int = 1 << 2;
      
      public static const SHOW_PARKING_EVENT:int = 1 << 3;
      
      public static const SHOW_EXPRESSWAY_FLOW:int = 1 << 4;
      
      public static const SHOW_PUBLIC_ROAD_FLOW:int = 1 << 5;
      
      public static const SHOW_FREE_FLOW:int = 1 << 6;
      
      public static const SHOW_JAM_FLOW:int = 1 << 7;
      
      public static const AVOID_MODE_AUTO:int = 0;
      
      public static const AVOID_MODE_AVOID:int = 1;
      
      public static const AVOID_MODE_IGNORE:int = 2;
      
      public static const ROUTE_MODE_OFF:int = 0;
      
      public static const ROUTE_MODE_AUTO:int = 1;
      
      public static const ROUTE_MODE_MANUAL:int = 2;
      
      public static const ROUTE_MODE_DELAY:int = 4;
      
      public static const TUNING_MODE_AUTO:int = 1;
      
      public static const TUNING_MODE_MANUAL:int = 2;
      
      public function TmcTypes()
      {
         super();
      }
   }
}

