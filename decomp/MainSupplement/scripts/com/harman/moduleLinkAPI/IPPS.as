package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPPS extends IModule
   {
      
      function getPPSBusy() : void;
      
      function get PPSBusy() : Boolean;
      
      function getNavigationMarketConfiguration() : void;
      
      function get navigationMarketConfiguration() : int;
      
      function getHardwarePartNum() : void;
      
      function get HardwarePartNum() : String;
   }
}

