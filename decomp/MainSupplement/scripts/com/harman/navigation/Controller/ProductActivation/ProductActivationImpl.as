package com.harman.navigation.Controller.ProductActivation
{
   import flash.events.EventDispatcher;
   
   public class ProductActivationImpl extends EventDispatcher
   {
      
      private static var mProductActivationInstance:ProductActivationController;
      
      public function ProductActivationImpl()
      {
         super();
      }
      
      public static function create() : ProductActivationController
      {
         if(mProductActivationInstance == null)
         {
            return mProductActivationInstance = new ProductActivationController();
         }
         return mProductActivationInstance;
      }
      
      public static function get instance() : ProductActivationController
      {
         return mProductActivationInstance;
      }
   }
}

