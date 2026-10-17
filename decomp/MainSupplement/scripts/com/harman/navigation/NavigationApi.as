package com.harman.navigation
{
   use namespace NavigationNamespace;
   
   public class NavigationApi
   {
      
      NavigationNamespace static var impl:INavigation;
      
      public function NavigationApi()
      {
         super();
      }
      
      public static function get api() : INavigation
      {
         return impl;
      }
   }
}

