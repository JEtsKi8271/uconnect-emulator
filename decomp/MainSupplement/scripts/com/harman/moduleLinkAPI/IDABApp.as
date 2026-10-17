package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDABApp extends IModule
   {
      
      function requestEnableICSTuning() : void;
      
      function requestDisableICSTuning() : void;
   }
}

