package com.harman.navigation.Controller.POI
{
   import flash.events.EventDispatcher;
   
   public class PoiInputImpl extends EventDispatcher
   {
      
      private static var mPoiInputInstance:PoiInputController;
      
      public function PoiInputImpl()
      {
         super();
      }
      
      public static function create() : PoiInputController
      {
         if(mPoiInputInstance == null)
         {
            return mPoiInputInstance = new PoiInputController();
         }
         return mPoiInputInstance;
      }
      
      public static function get instance() : PoiInputController
      {
         return mPoiInputInstance;
      }
      
      public static function erase() : void
      {
         mPoiInputInstance = null;
      }
   }
}

