package com.harman.navigation.Controller.LiveServices
{
   import flash.events.EventDispatcher;
   
   public class LiveServicesImpl extends EventDispatcher
   {
      
      private static var mLiveServices:LiveServicesController;
      
      public function LiveServicesImpl()
      {
         super();
      }
      
      public static function create() : LiveServicesController
      {
         if(mLiveServices == null)
         {
            return mLiveServices = new LiveServicesController();
         }
         return mLiveServices;
      }
      
      public static function get instance() : LiveServicesController
      {
         return mLiveServices;
      }
      
      public static function erase() : void
      {
         mLiveServices = null;
      }
   }
}

