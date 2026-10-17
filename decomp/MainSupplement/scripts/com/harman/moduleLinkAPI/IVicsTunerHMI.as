package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVicsTunerHMI extends IModule
   {
      
      function get State() : uint;
      
      function get TuningType() : uint;
      
      function get Frequency() : uint;
      
      function get PrefectureManual() : uint;
      
      function get PrefectureAuto() : uint;
      
      function PrefectureStringJpn(param1:uint) : String;
      
      function PrefectureStringEng(param1:uint) : String;
      
      function requestStartTune() : void;
      
      function requestFinishTune() : void;
      
      function requestSetTuneTypeAuto() : void;
      
      function requestSetTuneTypePref(param1:uint) : void;
      
      function requestSetTuneTypeManual() : void;
      
      function requestTuneUp() : void;
      
      function requestTuneDown() : void;
      
      function requestStartTuneUp() : void;
      
      function requestStartTuneDown() : void;
      
      function requestEndTuneUpDown() : void;
      
      function requestState() : void;
      
      function requestTuningType() : void;
      
      function requestFrequency() : void;
      
      function requestPrefectureManual() : void;
      
      function requestPrefectureAuto() : void;
   }
}

