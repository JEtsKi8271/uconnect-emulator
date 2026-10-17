package com.harman.moduleLinkAPI
{
   public class AhaState
   {
      
      public static const SERVICE_CRASHED:int = -4;
      
      public static const ERROR_CONNECTING:int = -3;
      
      public static const NOT_RUNNING:int = -2;
      
      public static const CONNECTING:int = -1;
      
      public static const RUNNING:int = 0;
      
      public static const SERVER_CONNECTION_LOST:int = 1;
      
      public static const PHONE_CONNECTION_LOST:int = 3;
      
      public static const SERVER_DOWN_FOR_MAINTENANCE:int = 2;
      
      public static const NOT_LOGGED_IN:int = 7;
      
      public static const LOGIN_FAILED:int = 8;
      
      public static const PHONE_NOT_CONNECTED:int = 45;
      
      public static const LS_NO_CONNECTION:int = 0;
      
      public static const LS_LOADING:int = 1;
      
      public static const LS_LOADING_PRESETS:int = 2;
      
      public static const LS_NO_ACTIVE_STATION:int = 3;
      
      public static const LS_STATION_DEACTIVATED:int = 4;
      
      public static const LS_COMPLETE:int = 5;
      
      public static const LS_CHANGING_STATION:int = 6;
      
      public static const LS_CHANGING_CONTENT:int = 7;
      
      public static const PLAYBACK_STOPPED:int = 0;
      
      public static const PLAYBACK_PAUSED:int = 1;
      
      public static const PLAYBACK_PLAYING:int = 2;
      
      public static const PLAYBACK_BUFFERING:int = 3;
      
      public function AhaState()
      {
         super();
      }
   }
}

