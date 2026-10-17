package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPerformanceInfo extends IModule
   {
      
      function getPerformanceInfo() : void;
      
      function get freeMemory() : String;
   }
}

