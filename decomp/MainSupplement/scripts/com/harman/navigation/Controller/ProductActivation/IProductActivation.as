package com.harman.navigation.Controller.ProductActivation
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IProductActivation extends IModule
   {
      
      function activate() : void;
      
      function getProductRequestCode() : void;
      
      function get productRequestCode() : String;
      
      function get productActivationCode() : String;
      
      function gotoActivationCodeSpeller() : void;
      
      function submitActivationCode(param1:String) : void;
      
      function onBackToRequestCodeScreen() : void;
      
      function onRetryActivationCodeEntry() : void;
   }
}

