package com.nfuzion.moduleLinkAPI
{
   import com.harman.moduleLinkAPI.Time;
   
   public interface IClock extends IModule
   {
      
      function getTime() : void;
      
      function setTime(param1:Date) : void;
      
      function adjustYear(param1:Number) : void;
      
      function adjustMonth(param1:Number) : void;
      
      function adjustManualOffset(param1:Number) : void;
      
      function get time() : Date;
      
      function set _time(param1:Time) : void;
      
      function get _time() : Time;
      
      function get formattedHours() : String;
      
      function get formattedMinutes() : String;
      
      function get formattedTime() : String;
      
      function setDaylightSavings(param1:Boolean) : void;
      
      function get timeZone() : String;
      
      function get timeZoneOffset() : Number;
      
      function get daylightOffset() : Number;
      
      function get manualOffset() : Number;
      
      function setSyncWithGPSTime(param1:Boolean) : void;
      
      function requestSyncWithGPSTime() : void;
      
      function get GPSTime() : Boolean;
      
      function setTwelveHourTimeFormat(param1:Boolean) : void;
      
      function requestTwelveHourTimeFormat() : void;
      
      function get twelveHourTimeFormat() : Boolean;
      
      function setTimeInStatusBarEnabled(param1:Boolean) : void;
      
      function requestTimeInStatusBarEnabled() : void;
      
      function get EnableClock() : Boolean;
   }
}

