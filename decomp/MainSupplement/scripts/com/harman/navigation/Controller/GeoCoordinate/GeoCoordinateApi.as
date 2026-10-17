package com.harman.navigation.Controller.GeoCoordinate
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class GeoCoordinateApi
   {
      
      NavigationNamespace static var impl:IGeoCoordinate;
      
      public function GeoCoordinateApi()
      {
         super();
      }
      
      public static function get api() : IGeoCoordinate
      {
         return impl;
      }
   }
}

