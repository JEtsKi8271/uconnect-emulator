package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class PoiInputApi
   {
      
      NavigationNamespace static var impl:IPoiInput;
      
      public function PoiInputApi()
      {
         super();
      }
      
      public static function get api() : IPoiInput
      {
         return impl;
      }
   }
}

