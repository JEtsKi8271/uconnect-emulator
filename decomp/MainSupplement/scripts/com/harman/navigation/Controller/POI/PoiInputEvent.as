package com.harman.navigation.Controller.POI
{
   import flash.events.Event;
   
   public class PoiInputEvent extends Event
   {
      
      public static const POI_BUSY:String = "POI_Busy";
      
      public static const POI_INPUT_PATH:String = "POI_InputPath";
      
      public static const POI_ACTIVE_MENU:String = "POI_ActiveMenu";
      
      public static const POI_LIST_UPDATE:String = "POI_ListUpdate";
      
      public static const POI_LIST_SIZE_TOTAL:String = "POI_ListSizeTotal";
      
      public static const POI_LIST_START_INDEX:String = "POI_ListStartIndex";
      
      public static const POI_CATEGORIES:String = "POI_Categories";
      
      public static const POI_SEARCHED_NAME:String = "POI_Searched_Name";
      
      public static const POI_SEARCHED_REMAINING_COUNT:String = "POI_Searched_Remaining_Count:";
      
      public static const POI_SEARCH_AREA_DEFAULT:String = "POI_Search_Area_Default";
      
      public static const POI_SEARCH_AREA_CURRENT:String = "POI_Search_Area_Current";
      
      public static const POI_SEARCH_AREA_RESTICTED:String = "POI_Search_Area_Restricted";
      
      public static const POI_SEARCH_CITY:String = "POI_Search_City";
      
      public static const POI_GET_DETAILS:String = "POI_Get_Details";
      
      public static const POI_PRESET:String = "POI_Preset";
      
      public static const POI_PHONE_SPELLER:String = "POI_Phone_Speller";
      
      public function PoiInputEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

