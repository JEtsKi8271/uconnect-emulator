package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IConnectionManager extends IModule
   {
      
      function connectInternet(param1:String, param2:String, param3:String) : void;
      
      function disconnectInternet(param1:String) : void;
      
      function disconnectInternetImmediately(param1:String) : void;
      
      function setPrecedence(param1:String) : void;
      
      function setAccessPoint(param1:Object) : void;
      
      function getAccessPoint(param1:String) : void;
      
      function getCurConnectionMethod() : String;
      
      function getPrecedenceList() : void;
      
      function switchEmbeddedPhoneUsage(param1:String) : void;
   }
}

