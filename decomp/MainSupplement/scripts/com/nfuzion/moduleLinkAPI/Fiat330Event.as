package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class Fiat330Event extends Event
   {
      
      public static const TEMPUNIT:String = "tempUnit";
      
      public static const DISTANCEUNIT:String = "distanceUnit";
      
      public static const CONSUMPTIONUNIT:String = "consumptionUnit";
      
      public static const SPEEDLOCK:String = "speedlockEnable";
      
      public static const RAINLEVEL:String = "rainsensorLevel";
      
      public static const TRIPBENABLE:String = "tripbEnable";
      
      public static const AFSENABLE:String = "afsEnable";
      
      public static const AUTOONRADIO:String = "autoOnRadio";
      
      public static const TRIP_A_TIME:String = "TripATime";
      
      public static const TRIP_A_DISTANCE:String = "TripADistance";
      
      public static const TRIP_A_CONSUMPTION:String = "TripAConsumption";
      
      public static const TRIP_A_SPEED:String = "TripBSpeed";
      
      public static const TRIP_B_TIME:String = "TripBTime";
      
      public static const TRIP_B_DISTANCE:String = "TripBDistance";
      
      public static const TRIP_B_CONSUMPTION:String = "TripBConsumption";
      
      public static const TRIP_B_SPEED:String = "TripBSpeed";
      
      public static const TRIP_RANGE:String = "TripRange";
      
      public static const TRIP_CONSUMPTION:String = "TripConsumption";
      
      public var mData:Object = null;
      
      public function Fiat330Event(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

