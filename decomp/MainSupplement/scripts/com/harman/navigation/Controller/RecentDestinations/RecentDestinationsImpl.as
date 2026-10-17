package com.harman.navigation.Controller.RecentDestinations
{
   import flash.events.EventDispatcher;
   
   public class RecentDestinationsImpl extends EventDispatcher
   {
      
      private static var mRecentDestinationsInstance:RecentDestinationsController;
      
      public function RecentDestinationsImpl()
      {
         super();
      }
      
      public static function create() : RecentDestinationsController
      {
         if(mRecentDestinationsInstance == null)
         {
            return mRecentDestinationsInstance = new RecentDestinationsController();
         }
         return mRecentDestinationsInstance;
      }
      
      public static function get instance() : RecentDestinationsController
      {
         return mRecentDestinationsInstance;
      }
      
      public static function erase() : void
      {
         mRecentDestinationsInstance = null;
      }
   }
}

