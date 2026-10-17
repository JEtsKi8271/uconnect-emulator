package com.harman.navigation.Controller.GeoCoordinate
{
   import flash.events.Event;
   
   public class GeoCoordinateEvent extends Event
   {
      
      public static const GEO_FORMAT:String = "GEO_Format";
      
      public static const GEO_CURRENT_ENTRY:String = "GEO_Current_Entry";
      
      public static const GEO_CURRENT_COORDINATE_TYPE:String = "GEO_Current_Coordinate_Type";
      
      public static const GEO_CURSOR_POSITION:String = "GEO_Cursor_Position";
      
      public static const GEO_AVAILABLE_CHARACTERS:String = "GEO_Available_Characters";
      
      public static const GEO_COORDINATE_IS_VALID:String = "GEO_Coordinate_Is_Valid";
      
      public function GeoCoordinateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

