package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPersistency extends IModule
   {
      
      function read(param1:String) : void;
      
      function write(param1:String, param2:Object) : void;
      
      function getValue(param1:String) : *;
   }
}

