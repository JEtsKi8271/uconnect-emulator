package com.harman.navigation.Controller.Interchange
{
   import flash.events.EventDispatcher;
   
   public class InterchangeImpl extends EventDispatcher
   {
      
      private static var mInterchangeInstance:InterchangeController;
      
      public function InterchangeImpl()
      {
         super();
      }
      
      public static function create() : InterchangeController
      {
         if(mInterchangeInstance == null)
         {
            return mInterchangeInstance = new InterchangeController();
         }
         return mInterchangeInstance;
      }
      
      public static function get instance() : InterchangeController
      {
         return mInterchangeInstance;
      }
      
      public static function erase() : void
      {
         mInterchangeInstance = null;
      }
   }
}

