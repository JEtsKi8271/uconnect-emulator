package com.harman.navigation.Controller.MAP.enums
{
   import com.nfuzion.framework.global.Framework;
   
   public class MapSettingTypes
   {
      
      public static const DISABLED:int = 0;
      
      public static const ENABLED:int = 1;
      
      public static const ORIENTATION_NORTH_UP:int = 1 << 0;
      
      public static const ORIENTATION_HEADING_UP:int = 1 << 1;
      
      public static const ORIENTATION_DESTINATION_UP:int = 1 << 2;
      
      public static const VIEW_TYPE_2D:int = 1 << 0;
      
      public static const VIEW_TYPE_3D:int = 1 << 1;
      
      public static const VIEW_TYPE_BIRD:int = 1 << 2;
      
      public static const VIEW_TYPE_GARAGE:int = 1 << 3;
      
      public static const VIEW_TYPE_PREVIEW:int = 1 << 4;
      
      public static const APPEARANCE_STYLE_DAY:int = 1 << 0;
      
      public static const APPEARANCE_STYLE_NIGHT:int = 1 << 1;
      
      public static const APPEARANCE_STYLE_AUTO:int = 1 << 2;
      
      public static const SCROLL_MODE_START:int = 1;
      
      public static const SCROLL_MODE_STOP:int = 2;
      
      public static const SCROLL_MODE_CAR_POSITION:int = 4;
      
      public static const SCROLL_MODE_DETACH_CAR:int = 8;
      
      public static const MAP_ITEM_VISIBILITY_NOT_VISIBLE:int = 0;
      
      public static const MAP_ITEM_VISIBILITY_FULLY_VISIBLE:int = 1;
      
      public static const MAP_ITEM_VISIBILITY_PARTIALLY_VISIBLE:int = 2;
      
      public static const LANE_RECOMMENDATION_MODE_OFF:int = 0;
      
      public static const LANE_RECOMMENDATION_MODE_ON:int = 1;
      
      public static const LANE_RECOMMENDATION_MODE_SHOW_IF_NO_SIGNPOST:int = 2;
      
      public static const WORLD_ELEMENT_GEO_COORDINATE:int = 1 << 0;
      
      public static const WORLD_ELEMENT_LOCATION_DETAILS:int = 1 << 1;
      
      public static const WORLD_ELEMENT_POI_DATA:int = 1 << 2;
      
      public static const WORLD_ELEMENT_TMC_DATA:int = 1 << 3;
      
      public static const WORLD_ELEMENT_WEATHER_DATA:int = 1 << 4;
      
      public static const WORLD_ELEMENT_FUNCTION_HIDE:int = 0;
      
      public static const WORLD_ELEMENT_FUNCTION_ZOOM:int = 1;
      
      public static const WORLD_ELEMENT_FUNCTION_HIGHLIGHT:int = 2;
      
      public static const WORLD_ELEMENT_FUNCTION_VISIBLE:int = 4;
      
      public static const WORLD_ELEMENT_FUNCTION_SET_ITEM_VISIBILITIES:int = 8;
      
      public static const WORLD_ELEMENT_FUNCTION_SET_TEMPORARY_ITEMS:int = 16;
      
      public static const WORLD_ELEMENT_FUNCTION_ZOOM_ROUTE_DIFFERENCES:int = 256;
      
      public static const DESTINATION_INFO_DISABLED:int = 0;
      
      public static const DESTINATION_INFO_TIME_OF_ARRIVAL:int = 1;
      
      public static const DESTINATION_INFO_TIME_TO_DESTINATION:int = 2;
      
      public static const DESTINATION_INFO_DISTANCE_TO_DESTINATION:int = 3;
      
      public static const MAP_FRAMERATE_LOW:Number = 0.25;
      
      public static const MAP_FRAMERATE_MID:int = Framework.resolution != Framework.RES_640_480 ? 10 : 2;
      
      public static const MAP_FRAMERATE_HIGH:int = Framework.resolution != Framework.RES_640_480 ? 30 : 10;
      
      public static const MAP_FRAMERATE_ZOOM_OUT:int = Framework.resolution != Framework.RES_640_480 ? 10 : 2;
      
      public static const MAP_FRAMERATE_GARAGE:int = 20;
      
      public static const MAP_FRAMERATE_PHONECALL:int = Framework.resolution != Framework.RES_640_480 ? 10 : 4;
      
      public static const MAP_FRAMERATE_VR_SESSION:Number = 1.11;
      
      public static const MAP_FRAMERATE_SCROLLING:int = Framework.resolution != Framework.RES_640_480 ? 30 : 20;
      
      public function MapSettingTypes()
      {
         super();
      }
   }
}

