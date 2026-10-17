package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IIPAddressInfo extends IModule
   {
      
      function clearThermalHistory() : void;
      
      function enableTemperatureBroadCast() : void;
      
      function disableTemperatureBroadCast() : void;
      
      function getIPAddressInfo() : void;
      
      function get ipAddress() : String;
      
      function get QXDMConnStatus() : String;
      
      function get temperatures() : Object;
      
      function get displayHotWarning() : Boolean;
      
      function connectQXDM() : void;
      
      function disconnectQXDM() : void;
   }
}

