package com.harman.navigation.Controller.Persistence
{
   import flash.events.EventDispatcher;
   
   public class PersistenceImpl extends EventDispatcher
   {
      
      private static var mPersistenceInstance:PersistenceController;
      
      public function PersistenceImpl()
      {
         super();
      }
      
      public static function create() : PersistenceController
      {
         if(mPersistenceInstance == null)
         {
            return mPersistenceInstance = new PersistenceController();
         }
         return mPersistenceInstance;
      }
      
      public static function get instance() : PersistenceController
      {
         return mPersistenceInstance;
      }
      
      public static function erase() : void
      {
         mPersistenceInstance = null;
      }
   }
}

