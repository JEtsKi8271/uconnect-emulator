package com.harman.navigation.Controller.RouteCalculation
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class RouteCalculationApi
   {
      
      NavigationNamespace static var impl:IRouteCalculation;
      
      public function RouteCalculationApi()
      {
         super();
      }
      
      public static function get api() : IRouteCalculation
      {
         return impl;
      }
   }
}

