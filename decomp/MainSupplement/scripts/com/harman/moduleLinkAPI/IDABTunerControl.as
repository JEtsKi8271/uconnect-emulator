package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDABTunerControl extends IModule
   {
      
      function requestGetFirmwareVersions() : void;
      
      function requestGetFrequencyLabel() : void;
      
      function requestGetPoolVersion() : void;
      
      function requestGetRequiredFirmwareVersion() : void;
      
      function requestSetDAB2DABLinkingSwitch(param1:Boolean) : void;
      
      function requestGetDAB2DABLinkingSwitch() : void;
      
      function requestGetDeviceState() : void;
      
      function get firmwareVersions() : Vector.<DABTunerControlVersions>;
      
      function get tunerPoolVersion() : DABTunerControlVersions;
      
      function get requiredFirmwareVersion() : DABTunerControlVersions;
      
      function get lable() : String;
      
      function get deviceState() : Boolean;
      
      function get dAB2DABLinkingSwitch() : Boolean;
   }
}

