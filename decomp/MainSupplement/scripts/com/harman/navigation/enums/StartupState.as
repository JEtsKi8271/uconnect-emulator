package com.harman.navigation.enums
{
   public class StartupState
   {
      
      public static const UNDEFINED:int = 0;
      
      public static const WAITING:int = 1;
      
      public static const LOCKED:int = 2;
      
      public static const CONNECTED:int = 3;
      
      public static const INIT:int = 4;
      
      public static const PARTIALLY_READY:int = 5;
      
      public static const FULLY_READY:int = 6;
      
      public function StartupState()
      {
         super();
      }
   }
}

