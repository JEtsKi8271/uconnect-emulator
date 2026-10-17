package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVicsDSRCEtcDiagHMI extends IModule
   {
      
      function get EtcDeviceFailed() : Boolean;
      
      function get EtcDeviceStatus() : uint;
      
      function get EtcAntennaFailed() : Boolean;
      
      function requestEtcDeviceFailed() : void;
      
      function requestEtcDeviceStatus() : void;
      
      function requestEtcAntennaFailed() : void;
      
      function requestSelfTestVICSBeacon() : void;
      
      function requestSelfTestETC() : void;
      
      function requestSelfTestVICSFM(param1:uint) : void;
   }
}

