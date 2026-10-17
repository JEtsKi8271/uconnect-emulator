package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVersionInfo extends IModule
   {
      
      function requestVersionInfo() : void;
      
      function requestPartNumber() : void;
      
      function requestEQVersion() : void;
      
      function requestSerialNumber() : void;
      
      function setDisplayStatus(param1:Boolean) : void;
      
      function requestProductVariantID() : void;
      
      function requestServiceFlags() : void;
      
      function doFactoryReset() : void;
      
      function doTouchScreenCalibrate() : void;
      
      function restoreDefaultSettings() : void;
      
      function clearPersonalData() : void;
      
      function startTestColorPattern() : void;
      
      function requestTranslationVersion() : void;
      
      function get appVersion() : String;
      
      function get eqVersion() : String;
      
      function get navVersion() : String;
      
      function get v850AppVersion() : String;
      
      function get v850BootVersion() : String;
      
      function get partNumber() : String;
      
      function get serialNumber() : String;
      
      function get productVariantID() : ProductVariantID;
      
      function get serviceMenu() : Boolean;
      
      function get translationVersion() : String;
      
      function setLoggingFlag(param1:String, param2:Boolean) : void;
   }
}

