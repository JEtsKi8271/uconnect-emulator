package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   import com.nfuzion.moduleLinkAPI.SignalStats;
   
   public interface IDiagnostics extends IModule
   {
      
      function set taMode(param1:String) : void;
      
      function enterXMDiagMode() : void;
      
      function exitXMDiagMode() : void;
      
      function requestXMHwVersion() : void;
      
      function requestXMSwVersion() : void;
      
      function restoreX65ToFactoryState() : void;
      
      function requestAntennaSignalInfo() : void;
      
      function requestDetailedSignalStats() : void;
      
      function requestDetailedOverlaySignalStats() : void;
      
      function requestSignalQuality() : void;
      
      function get xmHwVersion() : String;
      
      function get xmSwVersion() : String;
      
      function get xmModuleType() : String;
      
      function get xmAntennaStatus() : String;
      
      function get xmCompositeSignal() : String;
      
      function get xmSatelliteSignal() : String;
      
      function get xmTerrestrialSignal() : String;
      
      function get xmSignalState() : String;
      
      function get detailedSignalStats() : Vector.<SignalStats>;
      
      function get detailedOverlaySignalStats() : Vector.<SignalStats>;
   }
}

