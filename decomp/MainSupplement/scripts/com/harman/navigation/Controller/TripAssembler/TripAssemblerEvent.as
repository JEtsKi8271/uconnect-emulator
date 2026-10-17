package com.harman.navigation.Controller.TripAssembler
{
   import flash.events.Event;
   
   public class TripAssemblerEvent extends Event
   {
      
      public static const TRIP_ACTIVE_MENU:String = "TRIP_Active_Menu";
      
      public static const TRIP_ACTIVE_MENU_REPEAT:String = "TRIP_Active_Menu_Repeat";
      
      public static const TRIP_DESTINATIONS:String = "TRIP_Destinations";
      
      public static const TRIP_TRAIL_NAME:String = "TRIP_TrailName";
      
      public static const TRIP_ROUTE_MODE:String = "TRIP_RouteMode";
      
      public static const TRIP_ACTIVE_ROUTE_MODE:String = "TRIP_ActiveRouteMode";
      
      public static const TRIP_CALCULATION_PROGRESS:String = "TRIP_CalculationProgress";
      
      public static const TRIP_IS_RE_CALCULATION_IN_PROGRESS:String = "TRIP_IsReCalculationInProgress";
      
      public static const TRIP_ROUTE_ALTERATION_IN_PROGRESS:String = "TRIP_RouteAlterationInProgress";
      
      public static const TRIP_CALCULATION_FAILED:String = "TRIP_CalculationFailed";
      
      public static const TRIP_ROUND_TRIP_MODE:String = "TRIP_RoundTripMode";
      
      public static const POI_SEARCH_AREA_CITY_INVALID:String = "TRIP_Poi_SearchArea";
      
      public function TripAssemblerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

