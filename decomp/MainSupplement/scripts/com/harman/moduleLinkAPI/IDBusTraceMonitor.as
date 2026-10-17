package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDBusTraceMonitor extends IModule
   {
      
      function getCurrentScopes() : void;
      
      function setCurrentScopes(param1:Object) : void;
      
      function get CurrentScopes() : Array;
      
      function get UNCHANGED_SCOPES() : String;
      
      function get ENABLE_MIXED_SCOPES() : String;
      
      function get ENABLE_ALL_SCOPES() : String;
      
      function get DISABLE_ALL_SCOPES() : String;
   }
}

