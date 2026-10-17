package com.nfuzion.moduleLinkAPI
{
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Distance;
   
   public interface ITravelLinkMovies extends IModule
   {
      
      function requestServiceStatus() : void;
      
      function get serviceStatus() : String;
      
      function requestCurrentLocation() : void;
      
      function get currentLocation() : Coordinates;
      
      function requestClosestTheathers() : void;
      
      function getClosestTheathers(param1:String) : TravelLinkMoviesTheaterList;
      
      function requestClosestMovies() : void;
      
      function getClosestMovies(param1:String) : TravelLinkMoviesMovieList;
      
      function requestMovieListings(param1:uint) : void;
      
      function getMovieListings(param1:String) : TravelLinkMoviesMovieListing;
      
      function requestTheathersForMovie(param1:uint) : void;
      
      function getTheathersForMovie(param1:String) : TravelLinkMoviesTheaterList;
      
      function requestTheaterDetails(param1:uint) : void;
      
      function getTheaterDetails() : TravelLinkMoviesTheaterDetails;
      
      function requestMovieDetails(param1:uint) : void;
      
      function getMovieDetails() : TravelLinkMoviesMovieDetails;
      
      function requestFavoriteTheater() : void;
      
      function setFavoriteTheater(param1:uint) : void;
      
      function deleteFavoriteTheater(param1:uint) : void;
      
      function get favoriteTheaterIdList() : Vector.<int>;
      
      function setRouteToTheater(param1:uint) : void;
      
      function setCoordinates(param1:Coordinates) : void;
      
      function get coordinates() : Coordinates;
      
      function setSearchRadius(param1:Distance) : void;
      
      function get searchRadius() : Distance;
   }
}

