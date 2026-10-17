package com.nfuzion.moduleLinkAPI
{
   public interface ITextToSpeech extends IModule
   {
      
      function get READOUT_TYPE_ACCFR() : String;
      
      function get READOUT_TYPE_EMAIL() : String;
      
      function get READOUT_TYPE_NAVI() : String;
      
      function get READOUT_TYPE_SMS() : String;
      
      function get READOUT_TYPE_TMC() : String;
      
      function get READOUT_TYPE_PLAIN() : String;
      
      function get READOUT_TYPE_PMSG() : String;
      
      function readout(param1:String, param2:String) : void;
      
      function readoutAdv(param1:String, param2:Array = null) : void;
      
      function abort(param1:String) : void;
      
      function get playState() : String;
      
      function requestPlayState() : void;
      
      function get isTTSPlaying() : Boolean;
      
      function requestAvailable() : void;
      
      function get available() : Boolean;
   }
}

