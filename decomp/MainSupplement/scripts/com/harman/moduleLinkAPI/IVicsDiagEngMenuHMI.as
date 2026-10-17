package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVicsDiagEngMenuHMI extends IModule
   {
      
      function get AccessingSDCard() : Boolean;
      
      function get DeviceStatus() : vicsDiagEngMenuID;
      
      function requestJrcDeviceLogSave() : void;
   }
}

