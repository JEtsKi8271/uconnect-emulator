package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPhoneProjection extends IModule
   {
      
      function get sessionActive() : Boolean;
      
      function get ShortCutName() : String;
      
      function get sessionType() : String;
      
      function get TYPE_CARPLAY() : String;
      
      function get TYPE_GAL() : String;
      
      function get BacktoCar() : Boolean;
      
      function startProjection(param1:String) : void;
      
      function queryDeviceList() : void;
      
      function get videoStatus() : String;
      
      function IsCarPlayShortCut() : Boolean;
      
      function IsGalShortCut() : Boolean;
      
      function get ERROR_CARPLAY_CINEMO_START() : int;
      
      function get ERROR_CARPLAY_CINEMO_STOP() : int;
      
      function get ERROR_GAL_START_TIMEOUT() : int;
      
      function get INTERNAL_ERROR() : String;
      
      function get errorCode() : int;
      
      function get sessionStatus() : String;
   }
}

