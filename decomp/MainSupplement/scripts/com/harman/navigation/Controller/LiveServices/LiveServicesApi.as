package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class LiveServicesApi
   {
      
      NavigationNamespace static var impl:ILiveServices;
      
      public function LiveServicesApi()
      {
         super();
      }
      
      public static function get api() : ILiveServices
      {
         return impl;
      }
   }
}

