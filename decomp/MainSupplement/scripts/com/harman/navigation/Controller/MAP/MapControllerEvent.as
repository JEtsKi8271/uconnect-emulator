package com.harman.navigation.Controller.MAP
{
   import flash.events.Event;
   
   public class MapControllerEvent extends Event
   {
      
      public static const MAP_CONFIGURATION:String = "MAP_Configuration";
      
      public static const MAP_ZOOM_LEVEL:String = "MAP_ZoomLevel";
      
      public static const MAP_AUTO_ZOOM_LEVEL:String = "MAP_AutoZoomLevel";
      
      public static const MAP_APPEARANCE_STYLE:String = "MAP_AppearanceStyle";
      
      public static const MAP_POI_VISIBILITY:String = "MAP_Poi_Visibility";
      
      public static const MAP_VEHICLE_ICONS:String = "MAP_Vehicle_Icons";
      
      public static const MAP_THEMES:String = "MAP_Themes";
      
      public static const MAP_APPEARANCE:String = "MAP_Appearance";
      
      public static const MAP_JUNCTION_VIEW_ACTIVE:String = "MAP_JunctionView_Active";
      
      public static const MAP_SCROLLING_PICK_INFO:String = "MAP_Scrolling_Pick_Info";
      
      public static const MAP_TMC_SETTING:String = "MAP_TMC_Setting";
      
      public static const MAP_DESTINATION_INFO_SETTING:String = "MAP_Destiantion_Info_Setting";
      
      public static const MAP_DESTINATION_REACHED_SCREEN_TIMEOUT:String = "MAP_Destiantion_Reached_Screen_Timeout";
      
      public static const MAP_CONFIRM_DESTINATION_AUTO_ACCEPT_TIMEOUT:String = "MAP_Confirm_Destiantion_Auto_Accept_Timeout";
      
      public static const MAP_CTT_SUM_ACTIVE:String = "MAP_CTTSum_Active";
      
      public static const MAP_POI_VIS_LISTCOUNT:String = "MAP_Poi_Vis_Listcount";
      
      public function MapControllerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

