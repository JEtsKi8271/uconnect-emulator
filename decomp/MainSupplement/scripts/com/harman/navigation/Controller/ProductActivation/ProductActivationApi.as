package com.harman.navigation.Controller.ProductActivation
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class ProductActivationApi
   {
      
      NavigationNamespace static var impl:IProductActivation;
      
      public function ProductActivationApi()
      {
         super();
      }
      
      public static function get api() : IProductActivation
      {
         return impl;
      }
   }
}

