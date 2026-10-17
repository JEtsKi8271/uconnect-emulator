package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IOtaService extends IModule
   {
      
      function get installType() : Number;
      
      function get installSuccess() : Number;
      
      function get errorCode() : Number;
      
      function get whatsNew() : String;
      
      function updateNow() : void;
      
      function scheduledUpdateTime(param1:Time) : void;
   }
}

