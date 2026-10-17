package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VicsTunerHMIEvent extends Event
   {
      
      public static const START_TUNE:String = "EventStartTune";
      
      public static const STATE:String = "EventState";
      
      public static const TUNING_TYPE:String = "EventTuningType";
      
      public static const FREQUENCY:String = "EventFrequency";
      
      public static const PREFECTURE_MANUAL:String = "EventPrefectureManual";
      
      public static const PREFECTURE_AUTO:String = "EventPrefectureAuto";
      
      public var mData:Object = null;
      
      public function VicsTunerHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

