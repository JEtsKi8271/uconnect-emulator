package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TunerEvent extends Event
   {
      
      public static const AVAILABLE:String = "available";
      
      public static const AVAILABLE_STATIONS:String = "dtStationsFreq";
      
      public static const BAND:String = "band";
      
      public static const REGION:String = "region";
      
      public static const SEEK:String = "seek";
      
      public static const STATION_STEREO:String = "stationStereo";
      
      public static const STATION_TEXT:String = "stationText";
      
      public static const STATION_INFO:String = "stationInfo";
      
      public static const TA_MODE:String = "tpEnabled";
      
      public static const REG_MODE:String = "REGEnabled";
      
      public static const AF_MODE:String = "afEnabled";
      
      public static const ADVISORY_MSG_ANNOUNCEMENT:String = "advisoryMsgAnnouncement";
      
      public static const TP_NOTIFY:String = "tpNotify";
      
      public static const RDS_DIAG_DATA:String = "rdsDiagData";
      
      public static const DIAG_FIELD_STRENGTH_DATA:String = "diagFieldStrengthData";
      
      public static const PRESET_UPDATE:String = "presetUpdate";
      
      public static const TMC_STATIONS:String = "tmcStations";
      
      public static const PARTINFO_DATA:String = "diagPartInfo";
      
      public static const RSQ_DIAG_DATA:String = "diagRSQInfo";
      
      public static const ACF_DIAG_DATA:String = "diagACFInfo";
      
      public static const FUNCINFO_DATA:String = "diagFuncInfo";
      
      public static const RT_PLUS_TEXT:String = "RadioTextPlus";
      
      public static const CONF_FILE_VERSION:String = "TunerConfigFileVersion";
      
      public static const ENG_DATA_BASIC:String = "engDataBasic";
      
      public var mData:* = null;
      
      public function TunerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

