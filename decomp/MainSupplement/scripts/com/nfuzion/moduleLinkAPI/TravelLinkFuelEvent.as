package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TravelLinkFuelEvent extends Event
   {
      
      public static const SERVICE_STATUS:String = "TravelLinkFuelEvent.serviceStatus";
      
      public static const FUEL_TYPES:String = "TravelLinkFuelEvent.fuelTypes";
      
      public static const DEFAULT_FUEL_TYPE:String = "TravelLinkFuelEvent.defaultFuelType";
      
      public static const SEARCH_RADIUS:String = "TravelLinkFuelEvent.searchRadius";
      
      public static const FAVORITE_STATION:String = "TravelLinkFuelEvent.favoriteStation";
      
      public static const STATION_SORT_FIELD:String = "TravelLinkFuelEvent.stationSortField";
      
      public static const STATIONS:String = "TravelLinkFuelEvent.stations";
      
      public static const STATIONS_COUNT:String = "TravelLinkFuelEvent.stationsCount";
      
      public static const STATION_DETAILS:String = "TravelLinkFuelEvent.stationDetails";
      
      public static const COORDINATES:String = "TravelLinkFuelEvent.coordinates";
      
      private var mData:Object = null;
      
      public function TravelLinkFuelEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
   }
}

