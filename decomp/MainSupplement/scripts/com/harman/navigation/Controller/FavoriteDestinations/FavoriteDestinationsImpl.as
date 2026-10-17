package com.harman.navigation.Controller.FavoriteDestinations
{
   import flash.events.EventDispatcher;
   
   public class FavoriteDestinationsImpl extends EventDispatcher
   {
      
      private static var mFavoriteDestinationsInstance:FavoriteDestinationsController;
      
      public function FavoriteDestinationsImpl()
      {
         super();
      }
      
      public static function create() : FavoriteDestinationsController
      {
         if(mFavoriteDestinationsInstance == null)
         {
            return mFavoriteDestinationsInstance = new FavoriteDestinationsController();
         }
         return mFavoriteDestinationsInstance;
      }
      
      public static function get instance() : FavoriteDestinationsController
      {
         return mFavoriteDestinationsInstance;
      }
      
      public static function erase() : void
      {
         mFavoriteDestinationsInstance = null;
      }
   }
}

