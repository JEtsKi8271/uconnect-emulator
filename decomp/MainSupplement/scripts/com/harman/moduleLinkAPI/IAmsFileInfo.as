package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAmsFileInfo extends IModule
   {
      
      function getAmsFileInfo() : void;
      
      function doAmsFileInstall(param1:String) : void;
      
      function doAmsFileReinstall(param1:String, param2:String) : void;
      
      function doAmsFileUnInstall(param1:String) : void;
      
      function get amsNumFiles() : int;
      
      function get amsPath() : String;
      
      function get amsFiles() : Array;
   }
}

