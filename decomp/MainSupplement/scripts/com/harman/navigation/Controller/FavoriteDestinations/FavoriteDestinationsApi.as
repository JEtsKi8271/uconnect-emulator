package com.harman.navigation.Controller.FavoriteDestinations
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class FavoriteDestinationsApi
   {
      
      NavigationNamespace static var impl:IFavoriteDestinations;
      
      public function FavoriteDestinationsApi()
      {
         super();
      }
      
      public static function get api() : IFavoriteDestinations
      {
         return impl;
      }
   }
}

