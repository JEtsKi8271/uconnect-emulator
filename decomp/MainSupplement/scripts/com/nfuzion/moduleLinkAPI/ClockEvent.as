package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ClockEvent extends Event
   {
      
      public static const TIME_UPDATE:String = "clockTime";
      
      public static const DAYLIGHT_SAVINGS:String = "daylightSavings";
      
      public static const TIME_ZONE:String = "timeZone";
      
      public static const TWELVE_HOUR_MODE:String = "TwelveHourMode";
      
      public static const GPS_TIME:String = "GpsTime";
      
      public static const MANUAL_OFFSET:String = "manualOffset";
      
      public static const DAYLIGHT_OFFSET:String = "daylightOffset";
      
      public static const TIMEZONE_OFFSET:String = "timeZoneOffset";
      
      public static const ENABLE_CLOCK:String = "EnableClock";
      
      public function ClockEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

