package com.harman.navigation.Controller.RecentDestinations
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class RecentDestinationsApi
   {
      
      NavigationNamespace static var impl:IRecentDestinations;
      
      public function RecentDestinationsApi()
      {
         super();
      }
      
      public static function get api() : IRecentDestinations
      {
         return impl;
      }
   }
}

