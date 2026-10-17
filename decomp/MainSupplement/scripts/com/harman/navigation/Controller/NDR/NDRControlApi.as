package com.harman.navigation.Controller.NDR
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class NDRControlApi
   {
      
      NavigationNamespace static var impl:NDRControl;
      
      public function NDRControlApi()
      {
         super();
      }
      
      public static function get api() : NDRControl
      {
         return impl;
      }
   }
}

