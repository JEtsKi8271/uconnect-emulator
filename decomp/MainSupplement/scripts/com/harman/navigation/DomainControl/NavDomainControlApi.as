package com.harman.navigation.DomainControl
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class NavDomainControlApi
   {
      
      NavigationNamespace static var impl:INavDomain;
      
      public function NavDomainControlApi()
      {
         super();
      }
      
      public static function get api() : INavDomain
      {
         return impl;
      }
   }
}

