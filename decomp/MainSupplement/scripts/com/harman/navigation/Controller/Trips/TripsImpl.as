package com.harman.navigation.Controller.Trips
{
   import flash.events.EventDispatcher;
   
   public class TripsImpl extends EventDispatcher
   {
      
      private static var mTripsInstance:TripsController;
      
      public function TripsImpl()
      {
         super();
      }
      
      public static function create() : TripsController
      {
         if(mTripsInstance == null)
         {
            return mTripsInstance = new TripsController();
         }
         return mTripsInstance;
      }
      
      public static function get instance() : TripsController
      {
         return mTripsInstance;
      }
      
      public static function erase() : void
      {
         mTripsInstance = null;
      }
   }
}

