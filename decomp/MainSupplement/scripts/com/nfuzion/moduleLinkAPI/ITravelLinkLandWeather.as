package com.nfuzion.moduleLinkAPI
{
   import com.nfuzion.geographic.Coordinates;
   
   public interface ITravelLinkLandWeather extends IModule
   {
      
      function getCoordinates() : void;
      
      function setCoordinates(param1:Coordinates) : void;
      
      function get coordinates() : Coordinates;
      
      function setStationSelectionMode(param1:String, param2:int = -1) : void;
      
      function getStationSelectionMode() : void;
      
      function get stationSelectionMode() : String;
      
      function getStation() : void;
      
      function get station() : WeatherLocation;
      
      function getCondition() : void;
      
      function get condition() : WeatherCondition;
      
      function getFavoriteStation() : void;
      
      function setFavoriteStation(param1:int) : void;
      
      function get favoriteStation() : int;
      
      function setSkiSelectionMode(param1:String, param2:int = -1) : void;
      
      function getSkiSelectionMode() : void;
      
      function get skiSelectionMode() : String;
      
      function getSki() : void;
      
      function get ski() : WeatherLocation;
      
      function getSkiCondition() : void;
      
      function get skiCondition() : WeatherCondition;
      
      function forceRefresh() : void;
      
      function getStationStateCount() : void;
      
      function get stationStateCount() : int;
      
      function getStationStates(param1:int, param2:int) : void;
      
      function getStationStatesAlphaJumpList() : void;
      
      function get stationStatesAlphaJumpList() : Vector.<AlphaJumpIndex>;
      
      function setStationState(param1:String) : void;
      
      function getStationState() : void;
      
      function get stationState() : String;
      
      function getStationCount() : void;
      
      function get stationCount() : int;
      
      function getStations(param1:int, param2:int) : void;
      
      function getStationsAlphaJumpList() : void;
      
      function get stationsAlphaJumpList() : Vector.<AlphaJumpIndex>;
      
      function getSkiStateCount() : void;
      
      function get skiStateCount() : int;
      
      function getSkiStates(param1:int, param2:int) : void;
      
      function getSkiStatesAlphaJumpList() : void;
      
      function get skiStatesAlphaJumpList() : Vector.<AlphaJumpIndex>;
      
      function setSkiState(param1:String) : void;
      
      function getSkiState() : void;
      
      function get skiState() : String;
      
      function getSkiResortCount() : void;
      
      function get skiResortCount() : int;
      
      function getSkiResorts(param1:int, param2:int) : void;
      
      function getSkiResortsAlphaJumpList() : void;
      
      function get skiResortsAlphaJumpList() : Vector.<AlphaJumpIndex>;
      
      function setStationAsLastViewedStation(param1:int) : void;
      
      function setNearestAsLastViewedStation() : void;
      
      function get lastViewedStation() : int;
      
      function get lastViewedStationIsNearest() : Boolean;
      
      function get CURRENT_FORECAST() : String;
      
      function get MAIN_FORECAST() : String;
      
      function get EXTENDED_FORECAST() : String;
      
      function get FIVEDAY_FORECAST() : String;
      
      function get SKI_INFO() : String;
   }
}

