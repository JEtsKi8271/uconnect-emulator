package com.harman.navigation.overTheAirUpdate
{
   public class OverTheAirUpdateState
   {
      
      public static const OTA_STATE_UNDEFINED:int = 0;
      
      public static const OTA_STATE_PACKAGES_NOT_REQUESTED:int = 1;
      
      public static const OTA_STATE_REQUESTING_PACKAGES:int = 2;
      
      public static const OTA_STATE_PACKAGES_NOT_AVAILABLE:int = 3;
      
      public static const OTA_STATE_PACKAGES_AVAILABLE:int = 4;
      
      public static const OTA_STATE_DOWNLOAD_INITIALIZED:int = 5;
      
      public static const OTA_STATE_DOWNLOADING:int = 6;
      
      public static const OTA_STATE_DOWNLOAD_ABORTED:int = 7;
      
      public static const OTA_STATE_DOWNLOAD_ERROR:int = 8;
      
      public static const OTA_STATE_DOWNLOAD_FINISHED:int = 9;
      
      public static const OTA_STATE_INSTALLING:int = 10;
      
      public static const OTA_STATE_GENERAL_ERROR:int = 11;
      
      public function OverTheAirUpdateState()
      {
         super();
      }
   }
}

