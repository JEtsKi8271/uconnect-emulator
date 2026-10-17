package com.nfuzion.moduleLinkAPI
{
   public interface ISatelliteRadioInstantReplay extends IModule
   {
      
      function init() : void;
      
      function FFPress() : void;
      
      function FFRelease() : void;
      
      function RWPress() : void;
      
      function RWRelease() : void;
      
      function pausePlayPress() : void;
      
      function pausePlayRelease() : void;
      
      function seekPrevious() : void;
      
      function seekForward() : void;
      
      function live() : void;
      
      function seekToPosition(param1:Boolean, param2:int = 0, param3:String = "00:00:00") : void;
      
      function reqPlayList(param1:int, param2:int) : void;
      
      function playFromPlayList(param1:int) : void;
      
      function scanPressed() : void;
      
      function setIRMode(param1:String) : void;
      
      function get IRBufferInfo() : SatelliteRadioInstantReplayBufferInfo;
      
      function get IRBufferEntryList() : Vector.<SatelliteRadioInstantReplayBufferEntry>;
      
      function get IRPlayStatus() : SatelliteRadioInstantReplayPlayStatus;
      
      function get currentOffset() : int;
      
      function get numPlaylistItems() : int;
   }
}

