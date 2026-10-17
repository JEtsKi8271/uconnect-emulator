package com.harman.navigation.Controller.GeoCoordinate
{
   import flash.events.EventDispatcher;
   
   public class GeoCoordinateImpl extends EventDispatcher
   {
      
      private static var mGeoCoordinateControllerInstance:GeoCoordinateController;
      
      public function GeoCoordinateImpl()
      {
         super();
      }
      
      public static function create() : GeoCoordinateController
      {
         if(mGeoCoordinateControllerInstance == null)
         {
            return mGeoCoordinateControllerInstance = new GeoCoordinateController();
         }
         return mGeoCoordinateControllerInstance;
      }
      
      public static function get instance() : GeoCoordinateController
      {
         return mGeoCoordinateControllerInstance;
      }
      
      public static function erase() : void
      {
         mGeoCoordinateControllerInstance = null;
      }
   }
}

