package com.harman.navigation.Controller.MAP
{
   import flash.events.EventDispatcher;
   
   public class MapControllerImpl extends EventDispatcher
   {
      
      private static var mMapControllerInstance:MapController;
      
      public function MapControllerImpl()
      {
         super();
      }
      
      public static function create() : MapController
      {
         if(mMapControllerInstance == null)
         {
            return mMapControllerInstance = new MapController();
         }
         return mMapControllerInstance;
      }
      
      public static function get instance() : MapController
      {
         return mMapControllerInstance;
      }
      
      public static function erase() : void
      {
         mMapControllerInstance = null;
      }
   }
}

