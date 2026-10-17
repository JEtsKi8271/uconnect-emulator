package com.harman.navigation
{
   import flash.events.EventDispatcher;
   
   public class NavigationImpl extends EventDispatcher
   {
      
      private static var navigationInstance:Navigation;
      
      public function NavigationImpl()
      {
         super();
      }
      
      public static function create() : Navigation
      {
         if(navigationInstance == null)
         {
            return navigationInstance = new Navigation();
         }
         return navigationInstance;
      }
      
      public static function get instance() : Navigation
      {
         return navigationInstance;
      }
      
      public static function erase() : void
      {
         navigationInstance = null;
      }
   }
}

