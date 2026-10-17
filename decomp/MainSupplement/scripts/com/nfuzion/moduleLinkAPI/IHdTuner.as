package com.nfuzion.moduleLinkAPI
{
   public interface IHdTuner extends ITuner
   {
      
      function setHdFrequency(param1:uint, param2:Number) : void;
      
      function setHdMode(param1:uint) : void;
      
      function setHdBERMode(param1:uint) : void;
      
      function setHdPerformanceMode(param1:Boolean) : void;
      
      function get hdMode() : uint;
      
      function get hdBERMode() : uint;
      
      function get hdBerInfo() : Object;
      
      function get hdPerformanceInfo() : Object;
      
      function get currentHdSubchannel() : int;
      
      function requestHDStatusInfo() : void;
      
      function requestHDStationInfo() : void;
      
      function get programsAvailable() : Vector.<int>;
      
      function requestHdSwVersion() : void;
      
      function get hdPTY() : String;
      
      function get hdStationLongName() : String;
      
      function get hdStationShortName() : String;
      
      function get hdArtistName() : String;
      
      function get hdSongTitle() : String;
      
      function get hdAlbumName() : String;
      
      function get hdStatusMsg() : String;
      
      function get hdSwVersion() : String;
      
      function get currentHDProgramAvailable() : Boolean;
   }
}

