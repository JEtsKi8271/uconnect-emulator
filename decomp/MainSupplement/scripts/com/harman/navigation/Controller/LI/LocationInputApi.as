package com.harman.navigation.Controller.LI
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class LocationInputApi
   {
      
      NavigationNamespace static var impl:ILocationInput;
      
      public function LocationInputApi()
      {
         super();
      }
      
      public static function get api() : ILocationInput
      {
         return impl;
      }
   }
}

