package com.harman.navigation.DomainControl
{
   import flash.events.EventDispatcher;
   
   public class NavDomainControlImpl extends EventDispatcher
   {
      
      private static var mNavDomainControllerInstance:NavDomainController;
      
      public function NavDomainControlImpl()
      {
         super();
      }
      
      public static function create() : NavDomainController
      {
         if(mNavDomainControllerInstance == null)
         {
            return mNavDomainControllerInstance = new NavDomainController();
         }
         return mNavDomainControllerInstance;
      }
      
      public static function get instance() : NavDomainController
      {
         return mNavDomainControllerInstance;
      }
      
      public static function erase() : void
      {
         mNavDomainControllerInstance = null;
      }
   }
}

