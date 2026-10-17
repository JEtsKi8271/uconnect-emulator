package com.harman.navigation.Controller.MAP
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class MapControllerApi
   {
      
      NavigationNamespace static var impl:MapController;
      
      public function MapControllerApi()
      {
         super();
      }
      
      public static function get api() : IMapControl
      {
         return impl;
      }
   }
}

