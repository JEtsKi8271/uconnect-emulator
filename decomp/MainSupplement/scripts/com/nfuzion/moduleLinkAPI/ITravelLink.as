package com.nfuzion.moduleLinkAPI
{
   public interface ITravelLink extends IModule
   {
      
      function get isAvailable() : Boolean;
      
      function get fuel() : ITravelLinkFuel;
      
      function get landWeather() : ITravelLinkLandWeather;
      
      function get movies() : ITravelLinkMovies;
      
      function get sports() : ITravelLinkSports;
      
      function get TLFuel() : String;
      
      function get TLLandWeather() : String;
      
      function get TLMovies() : String;
      
      function get TLSports() : String;
      
      function get addFavorite() : String;
      
      function get replaceFavorite() : String;
      
      function get deleteFavorite() : String;
      
      function get reportFavoritesFull() : String;
   }
}

