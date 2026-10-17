package com.harman.navigation.Controller.RouteCalculation
{
   import flash.events.EventDispatcher;
   
   public class RouteCalculationImpl extends EventDispatcher
   {
      
      private static var mRouteCalculation:RouteCalculation;
      
      public function RouteCalculationImpl()
      {
         super();
      }
      
      public static function create() : RouteCalculation
      {
         if(mRouteCalculation == null)
         {
            return mRouteCalculation = new RouteCalculation();
         }
         return mRouteCalculation;
      }
      
      public static function get instance() : RouteCalculation
      {
         return mRouteCalculation;
      }
      
      public static function erase() : void
      {
         mRouteCalculation = null;
      }
   }
}

