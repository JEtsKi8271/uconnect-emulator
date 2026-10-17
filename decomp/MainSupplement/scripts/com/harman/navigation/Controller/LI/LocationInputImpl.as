package com.harman.navigation.Controller.LI
{
   import flash.events.EventDispatcher;
   
   public class LocationInputImpl extends EventDispatcher
   {
      
      private static var mLocationInputInstance:LocationInputController;
      
      public function LocationInputImpl()
      {
         super();
      }
      
      public static function create() : LocationInputController
      {
         if(mLocationInputInstance == null)
         {
            return mLocationInputInstance = new LocationInputController();
         }
         return mLocationInputInstance;
      }
      
      public static function get instance() : LocationInputController
      {
         return mLocationInputInstance;
      }
      
      public static function erase() : void
      {
         mLocationInputInstance = null;
      }
   }
}

