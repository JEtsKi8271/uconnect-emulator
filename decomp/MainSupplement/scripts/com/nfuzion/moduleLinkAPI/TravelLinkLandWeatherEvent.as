package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TravelLinkLandWeatherEvent extends Event
   {
      
      public static const COORDINATES:String = "TravelLinkLandWeatherEvent.coordinates";
      
      public static const STATION_SELECTION_MODE:String = "TravelLinkLandWeatherEvent.stationSelectionMode";
      
      public static const STATION:String = "TravelLinkLandWeatherEvent.station";
      
      public static const CONDITION:String = "TravelLinkLandWeatherEvent.condition";
      
      public static const SKI_SELECTION_MODE:String = "TravelLinkLandWeatherEvent.skiSelectionMode";
      
      public static const SKI:String = "TravelLinkLandWeatherEvent.ski";
      
      public static const SKI_CONDITION:String = "TravelLinkLandWeatherEvent.skiCondition";
      
      public static const STATION_STATE_COUNT:String = "TravelLinkLandWeatherEvent.stationStateCount";
      
      public static const STATION_STATES:String = "TravelLinkLandWeatherEvent.stationStates";
      
      public static const STATION_STATES_ALPHA_JUMP_LIST:String = "TravelLinkLandWeatherEvent.stationStatesAlphaJumpList";
      
      public static const STATION_STATE:String = "TravelLinkLandWeatherEvent.stationState";
      
      public static const STATION_COUNT:String = "TravelLinkLandWeatherEvent.stationCount";
      
      public static const STATIONS:String = "TravelLinkLandWeatherEvent.stations";
      
      public static const STATIONS_ALPHA_JUMP_LIST:String = "TravelLinkLandWeatherEvent.stationsAlphaJumpList";
      
      public static const SKI_STATE_COUNT:String = "TravelLinkLandWeatherEvent.skiStateCount";
      
      public static const SKI_STATES:String = "TravelLinkLandWeatherEvent.skiStates";
      
      public static const SKI_STATES_ALPHA_JUMP_LIST:String = "TravelLinkLandWeatherEvent.skiStatesAlphaJumpList";
      
      public static const SKI_STATE:String = "TravelLinkLandWeatherEvent.skiState";
      
      public static const SKI_RESORT_COUNT:String = "TravelLinkLandWeatherEvent.skiResortCount";
      
      public static const SKI_RESORTS:String = "TravelLinkLandWeatherEvent.skiResorts";
      
      public static const SKI_RESORTS_ALPHA_JUMP_LIST:String = "TravelLinkLandWeatherEvent.skiResortsAlphaJumpList";
      
      public static const FAVORITE:String = "TravelLinkLandWeatherEvent.favorite";
      
      public var data:* = null;
      
      public function TravelLinkLandWeatherEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
   }
}

