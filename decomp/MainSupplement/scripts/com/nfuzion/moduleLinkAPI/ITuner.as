package com.nfuzion.moduleLinkAPI
{
   public interface ITuner extends IModule
   {
      
      function setRegion(param1:String) : void;
      
      function get isHdAvailable() : Boolean;
      
      function get supportRDS() : Boolean;
      
      function get supportTP() : Boolean;
      
      function setMarket(param1:String) : void;
      
      function get tunerVersionInfo() : Object;
      
      function getRegion() : void;
      
      function get region() : String;
      
      function getBand() : void;
      
      function get band() : String;
      
      function get available() : Boolean;
      
      function setFrequency(param1:uint) : void;
      
      function requestStationInfo() : void;
      
      function get frequency() : uint;
      
      function get frequencyMin() : uint;
      
      function get frequencyMax() : uint;
      
      function get frequencyStepSize() : uint;
      
      function setSeekPress(param1:String = "") : void;
      
      function setSeekRelease() : void;
      
      function get seek() : String;
      
      function get stationQuality() : uint;
      
      function getStationStereo() : void;
      
      function get stationStereo() : Boolean;
      
      function get stationName() : String;
      
      function get dabfmStationName() : String;
      
      function get stationProgramType() : String;
      
      function getStationText() : void;
      
      function get stationText() : String;
      
      function get availableStations() : Vector.<Object>;
      
      function get availableGenres() : Vector.<String>;
      
      function tunerSeekInteruptHdlr(param1:String) : Boolean;
      
      function requestAfFreqencyStatus() : void;
      
      function setAfFreqencyStatus(param1:Boolean) : void;
      
      function requestRegionalizationStatus() : void;
      
      function setRegionalizationStatus(param1:Boolean) : void;
      
      function requestTPEnabled() : void;
      
      function setTPEnabled(param1:Boolean) : void;
      
      function get afStatus() : Boolean;
      
      function get regStatus() : Boolean;
      
      function get tpEnabled() : Boolean;
      
      function get isTP() : Boolean;
      
      function setTuneKnobEnabled(param1:Boolean) : void;
      
      function get stationListSortType() : String;
      
      function set stationListSortType(param1:String) : void;
      
      function getItemFromStationList(param1:int, param2:String) : String;
      
      function requestSetDiagModeOn() : void;
      
      function requestSetDiagModeOff() : void;
      
      function requestSetDiagFrequency() : void;
      
      function requestRDSData() : void;
      
      function requestEngDataBasic() : void;
      
      function get engDataBasic() : Object;
      
      function requestSetEngModeOn() : void;
      
      function requestSetEngModeOff() : void;
      
      function get tunerDiagRDSInfo() : Object;
      
      function requestDiagFieldStrength() : void;
      
      function get tunerDiagFieldStrengthInfo() : Object;
      
      function requestTrafficAnnouncementStatus() : void;
      
      function requestDiagFuncInfo() : void;
      
      function get tunerDiagFuncInfo() : Object;
      
      function requestRSQData() : void;
      
      function get tunerDiagRSQInfo() : Object;
      
      function requestACFData() : void;
      
      function get tunerDiagACFInfo() : Object;
      
      function requestDiagPartInfo() : void;
      
      function get tunerDiagPartInfo() : Object;
      
      function requestTmcStations() : void;
      
      function get tmcStations() : Array;
      
      function get presetPositionNone() : int;
      
      function bandPresetPosition(param1:String) : int;
      
      function translateAudioManagerBandToTunerBand(param1:String) : String;
      
      function translateTunerBandToAudioManagerBand(param1:String) : String;
      
      function requestRecallPreset(param1:int) : void;
      
      function requestStorePreset(param1:int) : void;
      
      function requestClearPreset(param1:int) : void;
      
      function requestPresetPosition() : void;
      
      function get radioTextPlus() : Object;
      
      function requestTunerConfVersion(param1:String) : void;
      
      function get pi() : int;
      
      function get advisoryMessageType() : String;
      
      function get stationNameField() : String;
      
      function get stationGenreField() : String;
      
      function setPIFreq(param1:uint, param2:uint) : void;
   }
}

