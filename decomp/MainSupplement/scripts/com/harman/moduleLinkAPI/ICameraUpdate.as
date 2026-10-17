package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ICameraUpdate extends IModule
   {
      
      function getgearStatus() : String;
      
      function requestStartUpStatus() : void;
   }
}

