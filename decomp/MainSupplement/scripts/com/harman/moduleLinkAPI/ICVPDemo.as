package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ICVPDemo extends IModule
   {
      
      function get WakeupReason() : String;
      
      function get phoneMeid() : String;
      
      function get phoneImsi() : String;
      
      function get phoneMdn() : String;
      
      function get phoneNai() : String;
      
      function get phonePrlVersion() : String;
      
      function get phoneRssi() : String;
      
      function get phonePaCurrent() : String;
      
      function get phonePaMax() : String;
      
      function get phonePmicCurrent() : String;
      
      function get phonePmicMax() : String;
      
      function get phoneHwVersion() : String;
      
      function get phoneSwVersion() : String;
      
      function get phoneBtVersion() : String;
      
      function get phoneUsbPorts() : Array;
      
      function get callstate() : Object;
      
      function get signalQuality() : int;
      
      function get network() : String;
      
      function getFWVersions() : void;
      
      function getMeid() : void;
      
      function getModel() : void;
      
      function getImsi() : void;
      
      function getMdn() : void;
      
      function getNai() : void;
      
      function getPrlVersion() : void;
      
      function getRssi() : void;
      
      function getTemperature() : void;
      
      function getPaTemperature() : void;
      
      function getUsbPorts() : void;
      
      function getCdmaSystemStatus() : void;
      
      function sendDebugAT(param1:String) : void;
      
      function getMDN() : void;
      
      function getPri() : void;
      
      function getReverseTunneling() : void;
      
      function getHspi() : void;
      
      function getAspi() : void;
      
      function getMobileStationIp() : void;
      
      function getPrimaryHaAddress() : void;
      
      function getSecondaryHaAddress() : void;
      
      function getServingSystem() : void;
      
      function getAccessOverloadClass() : void;
      
      function getSlotCycleIndex() : void;
      
      function getNAI() : void;
      
      function getEmergencyNumbers() : void;
      
      function setSpc(param1:String) : void;
      
      function commitChanges(param1:int) : void;
      
      function setImsi(param1:String) : void;
      
      function setAccessOverloadClass(param1:String) : void;
      
      function setNai(param1:String) : void;
      
      function setReverseTunneling(param1:String) : void;
      
      function setHspi(param1:String) : void;
      
      function setAspi(param1:String) : void;
      
      function setPrimaryHaAddress(param1:String) : void;
      
      function setSecondaryHaAddress(param1:String) : void;
      
      function setMnHaSharedSecrets(param1:String) : void;
      
      function setMnAaaSharedSecrets(param1:String) : void;
      
      function selectProfile(param1:int) : void;
   }
}

