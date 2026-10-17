package com.harman.navigation.Controller.TripAssembler
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class TripAssemblerApi
   {
      
      NavigationNamespace static var impl:ITripAssembler;
      
      public function TripAssemblerApi()
      {
         super();
      }
      
      public static function get api() : ITripAssembler
      {
         return impl;
      }
   }
}

