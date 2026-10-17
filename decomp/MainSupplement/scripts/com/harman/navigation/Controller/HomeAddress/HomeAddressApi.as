package com.harman.navigation.Controller.HomeAddress
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class HomeAddressApi
   {
      
      NavigationNamespace static var impl:IHomeAddress;
      
      public function HomeAddressApi()
      {
         super();
      }
      
      public static function get api() : IHomeAddress
      {
         return impl;
      }
   }
}

