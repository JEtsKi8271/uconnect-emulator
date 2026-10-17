package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IRemoteStart extends IModule
   {
      
      function requestRemoteStartActive() : void;
      
      function get remoteStartActive() : Boolean;
   }
}

