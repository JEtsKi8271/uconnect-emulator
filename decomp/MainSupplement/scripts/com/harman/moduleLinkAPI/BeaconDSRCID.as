package com.harman.moduleLinkAPI
{
   public class BeaconDSRCID
   {
      
      public static const BEACON_HISTORY_MAX:uint = 6;
      
      public static const SOURCETYPE_EXPRESS:uint = 0;
      
      public static const SOURCETYPE_PUBLIC:uint = 1;
      
      public static const TOGGLECAPTION_PLAY:uint = 0;
      
      public static const TOGGLECAPTION_STOP:uint = 1;
      
      public static const BEACON_TEXT:uint = 0;
      
      public static const BEACON_DIAG:uint = 1;
      
      public static const CLEAR_TEXT:uint = 0;
      
      public static const CLEAR_DIAG:uint = 1;
      
      public static const INTERPRIO_HIGHEST:uint = 0;
      
      public static const INTERPRIO_HIGH:uint = 1;
      
      public static const INTERPRIO_GENERAL:uint = 2;
      
      public static const DISPLAY_5SEC:uint = 0;
      
      public static const DISPLAY_10SEC:uint = 1;
      
      public static const DISPLAY_15SEC:uint = 2;
      
      public var PUB_TEXT_RECEIVED_TIME:BeaconDSRCTime = new BeaconDSRCTime();
      
      public var PUB_DIAG_RECEIVED_TIME:BeaconDSRCTime = new BeaconDSRCTime();
      
      public var EXP_TEXT_RECEIVED_TIME:Vector.<BeaconDSRCTime> = new Vector.<BeaconDSRCTime>();
      
      public var EXP_DIAG_RECEIVED_TIME:Vector.<BeaconDSRCTime> = new Vector.<BeaconDSRCTime>();
      
      public var PUB_TEXT_AVAILABLE:Boolean = false;
      
      public var PUB_DIAG_AVAILABLE:Boolean = false;
      
      public var EXP_TEXT_AVAILABLE:Boolean = false;
      
      public var EXP_DIAG_AVAILABLE:Boolean = false;
      
      public var PREV_PAGE_AVAILABLE:Boolean = false;
      
      public var NEXT_PAGE_AVAILABLE:Boolean = false;
      
      public var TOGGLE_TTS_AVAILABLE:Boolean = false;
      
      public var TOGGLE_TTS_CAPTION:uint = 0;
      
      public function BeaconDSRCID()
      {
         super();
      }
      
      public function copyMenuDataState(value:Object) : BeaconDSRCID
      {
         if(value != null)
         {
            this.PUB_TEXT_AVAILABLE = value.pubTextAvailable;
            this.PUB_DIAG_AVAILABLE = value.pubDiagAvailable;
            this.EXP_TEXT_AVAILABLE = value.expTextAvailable;
            this.EXP_DIAG_AVAILABLE = value.expDiagAvailable;
         }
         return this;
      }
      
      public function copyButtonDataState(value:Object) : BeaconDSRCID
      {
         if(value != null)
         {
            this.PREV_PAGE_AVAILABLE = value.prevPageAvaileble;
            this.NEXT_PAGE_AVAILABLE = value.nextPageAvaileble;
            this.TOGGLE_TTS_AVAILABLE = value.toggleTtsAvailable;
            this.TOGGLE_TTS_CAPTION = value.toggleTtsCaption;
         }
         return this;
      }
      
      public function copyPubTextTime(value:Object) : BeaconDSRCID
      {
         if(value != null)
         {
            this.PUB_TEXT_RECEIVED_TIME.MONTH = value.Month;
            this.PUB_TEXT_RECEIVED_TIME.DAY = value.Day;
            this.PUB_TEXT_RECEIVED_TIME.HOUR = value.Hour;
            this.PUB_TEXT_RECEIVED_TIME.MINUTE = value.Minute;
         }
         return this;
      }
      
      public function copyPubDiagTime(value:Object) : BeaconDSRCID
      {
         if(value != null)
         {
            this.PUB_DIAG_RECEIVED_TIME.MONTH = value.Month;
            this.PUB_DIAG_RECEIVED_TIME.DAY = value.Day;
            this.PUB_DIAG_RECEIVED_TIME.HOUR = value.Hour;
            this.PUB_DIAG_RECEIVED_TIME.MINUTE = value.Minute;
         }
         return this;
      }
      
      public function copyExpTextTime(value:Object) : BeaconDSRCID
      {
         var newBeaconDSRCTime:BeaconDSRCTime = null;
         if(this.EXP_TEXT_RECEIVED_TIME.length < BEACON_HISTORY_MAX)
         {
            newBeaconDSRCTime = new BeaconDSRCTime();
            newBeaconDSRCTime.MONTH = value.Month;
            newBeaconDSRCTime.DAY = value.Day;
            newBeaconDSRCTime.HOUR = value.Hour;
            newBeaconDSRCTime.MINUTE = value.Minute;
            if(value.Month + value.Day + value.Hour + value.Minute != 0)
            {
               this.EXP_TEXT_RECEIVED_TIME.push(newBeaconDSRCTime);
            }
         }
         return this;
      }
      
      public function copyExpDiagTime(value:Object) : BeaconDSRCID
      {
         var newBeaconDSRCTime:BeaconDSRCTime = null;
         if(this.EXP_DIAG_RECEIVED_TIME.length < BEACON_HISTORY_MAX)
         {
            newBeaconDSRCTime = new BeaconDSRCTime();
            newBeaconDSRCTime.MONTH = value.Month;
            newBeaconDSRCTime.DAY = value.Day;
            newBeaconDSRCTime.HOUR = value.Hour;
            newBeaconDSRCTime.MINUTE = value.Minute;
            if(value.Month + value.Day + value.Hour + value.Minute != 0)
            {
               this.EXP_DIAG_RECEIVED_TIME.push(newBeaconDSRCTime);
            }
         }
         return this;
      }
      
      public function clearExpTextTime() : BeaconDSRCID
      {
         var length:uint = this.EXP_TEXT_RECEIVED_TIME.length;
         for(var count:int = 0; count < length; count++)
         {
            this.EXP_TEXT_RECEIVED_TIME.pop();
         }
         return this;
      }
      
      public function clearExpDiagTime() : BeaconDSRCID
      {
         var length:uint = this.EXP_DIAG_RECEIVED_TIME.length;
         for(var count:int = 0; count < length; count++)
         {
            this.EXP_DIAG_RECEIVED_TIME.pop();
         }
         return this;
      }
   }
}

