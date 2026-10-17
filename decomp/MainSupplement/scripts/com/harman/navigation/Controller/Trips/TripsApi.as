package com.harman.navigation.Controller.Trips
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class TripsApi
   {
      
      NavigationNamespace static var impl:ITrips;
      
      public function TripsApi()
      {
         super();
      }
      
      public static function get api() : ITrips
      {
         return impl;
      }
   }
}

