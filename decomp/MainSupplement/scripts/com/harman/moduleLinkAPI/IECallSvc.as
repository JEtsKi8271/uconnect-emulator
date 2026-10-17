package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IECallSvc extends IModule
   {
      
      function get CurrentECallState() : Object;
      
      function get progress() : int;
      
      function exitECall() : void;
      
      function startECall() : void;
      
      function setECallRetryState(param1:int) : void;
      
      function moveLogToUSB() : void;
      
      function logMessageToEcallLog(param1:String) : void;
      
      function setLEDStatus(param1:int) : void;
   }
}

