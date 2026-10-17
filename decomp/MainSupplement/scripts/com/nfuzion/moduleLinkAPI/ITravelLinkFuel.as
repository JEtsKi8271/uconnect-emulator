package com.nfuzion.moduleLinkAPI
{
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Distance;
   
   public interface ITravelLinkFuel extends IModule
   {
      
      function getServiceStatus() : void;
      
      function get serviceStatus() : String;
      
      function getFuelTypes() : void;
      
      function get fuelTypes() : Vector.<String>;
      
      function getDefaultFuelType() : void;
      
      function setDefaultFuelType(param1:String) : void;
      
      function get defaultFuelType() : String;
      
      function getSearchRadius() : void;
      
      function setSearchRadius(param1:Distance) : void;
      
      function get searchRadius() : Distance;
      
      function getFavoriteStation() : void;
      
      function setFavoriteStation(param1:FuelStation) : void;
      
      function get favoriteStation() : FuelStation;
      
      function clearFavoriteStation(param1:FuelStation) : void;
      
      function getStationSortField() : void;
      
      function setStationSortField(param1:String) : void;
      
      function get stationSortField() : String;
      
      function getStationsCount() : void;
      
      function get stationsCount() : uint;
      
      function getStations(param1:uint, param2:uint) : void;
      
      function getStationDetails(param1:FuelStation) : void;
      
      function getNearestStations() : void;
      
      function getCoordinates() : void;
      
      function setCoordinates(param1:Coordinates) : void;
      
      function get coordinates() : Coordinates;
   }
}

