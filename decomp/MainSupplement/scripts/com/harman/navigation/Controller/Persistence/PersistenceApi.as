package com.harman.navigation.Controller.Persistence
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class PersistenceApi
   {
      
      NavigationNamespace static var impl:PersistenceController;
      
      public function PersistenceApi()
      {
         super();
      }
      
      public static function get api() : PersistenceController
      {
         return impl;
      }
   }
}

