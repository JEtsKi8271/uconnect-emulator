package com.nfuzion.moduleLinkAPI
{
   public class WeatherCondition
   {
      
      public var currentDataStatus:int = 0;
      
      public var updateTime:String;
      
      public var currentTemperature:int = -2147483648;
      
      public var lowTemperature:int = -2147483648;
      
      public var highTemperature:int = -2147483648;
      
      public var currentCondition:String;
      
      public var currentDescription:String;
      
      public var currentDetailsDataStatus:int = 0;
      
      public var currentDetails:Vector.<WeatherDetail>;
      
      public var twelveHourDataStatus:int = 0;
      
      public var twelveHourForecast:Vector.<WeatherForecastHour>;
      
      public var fiveDayDataStatus:int = 0;
      
      public var fiveDayForecast:Vector.<WeatherForecastDay>;
      
      public function WeatherCondition()
      {
         super();
      }
   }
}

