package com.nfuzion.moduleLinkAPI
{
   public interface IAudioManager extends IModule
   {
      
      function get SOURCE_OFF() : String;
      
      function get SOURCE_FM() : String;
      
      function get SOURCE_AM() : String;
      
      function get SOURCE_MW() : String;
      
      function get SOURCE_LW() : String;
      
      function get SOURCE_DAB() : String;
      
      function get SOURCE_DMB() : String;
      
      function get SOURCE_SAT() : String;
      
      function get SOURCE_AHA() : String;
      
      function get SOURCE_VRM() : String;
      
      function get SOURCE_CD() : String;
      
      function get SOURCE_AUX() : String;
      
      function get SOURCE_DTV() : String;
      
      function get SOURCE_USB1() : String;
      
      function get SOURCE_USB2() : String;
      
      function get SOURCE_USB3() : String;
      
      function get SOURCE_USB4() : String;
      
      function get SOURCE_SDCARD() : String;
      
      function get SOURCE_BLUETOOTH() : String;
      
      function get SOURCE_PHONE() : String;
      
      function get SOURCE_HTTPSTREAMER1() : String;
      
      function get SOURCE_HTTPSTREAMER2() : String;
      
      function get SOURCE_HTTPSTREAMER3() : String;
      
      function get SOURCE_PROJECTION1() : String;
      
      function get SOURCE_PROJECTION2() : String;
      
      function get SOURCE_PROJECTION3() : String;
      
      function get SOURCE_REAR_AUX1() : String;
      
      function get SOURCE_REAR_AUX2() : String;
      
      function get SOURCE_REAR_HDMI1() : String;
      
      function get SOURCE_REAR_HDMI2() : String;
      
      function get ALERT_FAVORITE() : String;
      
      function get ALERT_GAME() : String;
      
      function get ALERT_TRAFFIC() : String;
      
      function get ALERT_WEATHER() : String;
      
      function get SOURCE_INFO1() : String;
      
      function get isSourceMuted() : Boolean;
      
      function get source() : String;
      
      function getMSIdForSource(param1:String) : int;
      
      function get audioSourceService() : String;
      
      function get lastRadioSource() : String;
      
      function get lastMediaSource() : String;
      
      function get lastAudioAppName() : String;
      
      function get isRearAuxAvailable() : Boolean;
      
      function get radioSources() : Vector.<String>;
      
      function get mediaSources() : Vector.<String>;
      
      function get availableSources() : Vector.<String>;
      
      function getSource() : void;
      
      function setSource(param1:String) : void;
      
      function goToLastRadioSource() : void;
      
      function goToLastMediaSource() : void;
      
      function getAvailableSources() : void;
      
      function isSourceAvailable(param1:String) : Boolean;
      
      function isHardwareAvailable(param1:String) : Boolean;
      
      function isSourceRSE(param1:String = "") : Boolean;
      
      function isSourceUSB(param1:String = "") : Boolean;
      
      function isSourceIPod(param1:String = "") : Boolean;
      
      function isSourcePFS(param1:String = "") : Boolean;
      
      function isSourceMediaService(param1:String = "") : Boolean;
      
      function isSourceRadio(param1:String = "") : Boolean;
      
      function isSourceMedia(param1:String = "") : Boolean;
      
      function isSOURCE_HTTPSTREAMER(param1:String = "") : Boolean;
      
      function isSourceAha(param1:String = "") : Boolean;
      
      function isSourceEmbeddedApp(param1:String = "") : Boolean;
      
      function isSourceProjection(param1:String = "") : Boolean;
      
      function isSourceCarPlay(param1:String = "") : Boolean;
      
      function isSourceGAL(param1:String = "") : Boolean;
      
      function sendAudioBeep() : void;
      
      function sendAlertTone(param1:String) : void;
      
      function refreshSource() : void;
      
      function get sourceChanges() : int;
      
      function getSourceType() : String;
      
      function lastMediaSourceMSID() : int;
   }
}

