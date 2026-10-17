package com.harman.moduleLinkAPI
{
   public class AntiTheftStates
   {
      
      public static const WAIT_FOR_VIN:String = "waitForVIN";
      
      public static const ENTER_PIN:String = "enterPIN";
      
      public static const WRONG_PIN:String = "wrongPIN";
      
      public static const UNLOCKED:String = "unlocked";
      
      public static const LOCKED:String = "locked";
      
      public static const FORCED_FOTA_UPDATE:String = "forcedFotaUpdate";
      
      public function AntiTheftStates()
      {
         super();
      }
   }
}

