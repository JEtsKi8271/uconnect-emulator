package com.harman.navigation.Controller.Interchange
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class InterchangeApi
   {
      
      NavigationNamespace static var impl:InterchangeController;
      
      public function InterchangeApi()
      {
         super();
      }
      
      public static function get api() : InterchangeController
      {
         return impl;
      }
   }
}

