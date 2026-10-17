package com.harman.navigation.Controller.TripAssembler
{
   import flash.events.EventDispatcher;
   
   public class TripAssemblerImpl extends EventDispatcher
   {
      
      private static var mTripAssembler:TripAssemblerController;
      
      public function TripAssemblerImpl()
      {
         super();
      }
      
      public static function create() : TripAssemblerController
      {
         if(mTripAssembler == null)
         {
            return mTripAssembler = new TripAssemblerController();
         }
         return mTripAssembler;
      }
      
      public static function get instance() : TripAssemblerController
      {
         return mTripAssembler;
      }
      
      public static function erase() : void
      {
         mTripAssembler = null;
      }
   }
}

