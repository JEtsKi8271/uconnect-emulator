package com.harman.navigation.Controller.HomeAddress
{
   import flash.events.EventDispatcher;
   
   public class HomeAddressImpl extends EventDispatcher
   {
      
      private static var mHomeAddressControllerInstance:HomeAddressController;
      
      public function HomeAddressImpl()
      {
         super();
      }
      
      public static function create() : HomeAddressController
      {
         if(mHomeAddressControllerInstance == null)
         {
            return mHomeAddressControllerInstance = new HomeAddressController();
         }
         return mHomeAddressControllerInstance;
      }
      
      public static function get instance() : HomeAddressController
      {
         return mHomeAddressControllerInstance;
      }
      
      public static function erase() : void
      {
         mHomeAddressControllerInstance = null;
      }
   }
}

