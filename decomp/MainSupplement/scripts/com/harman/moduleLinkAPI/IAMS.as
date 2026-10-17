package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAMS extends IModule
   {
      
      function getAppIds(param1:String) : void;
      
      function getPackageInfo(param1:String) : void;
      
      function extractResource(param1:Object) : void;
   }
}

