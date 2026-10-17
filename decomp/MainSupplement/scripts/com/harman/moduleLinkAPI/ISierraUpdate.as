package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ISierraUpdate extends IModule
   {
      
      function sierraupdatemode(param1:String) : void;
      
      function get progress() : Number;
      
      function get status() : String;
      
      function get errorMsg() : String;
   }
}

