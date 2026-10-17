package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IRse extends IModule
   {
      
      function get externalSourceStatus() : String;
      
      function get dvdoutstatstatus() : String;
      
      function get repeatstatus() : String;
      
      function get shufflestatus() : String;
      
      function get rseplaytime() : uint;
      
      function get rseplayduration() : uint;
      
      function get rsecurrentTrackLength() : uint;
      
      function get rseCurrentTrackName() : String;
      
      function get rseCurrentTrackNumber() : String;
      
      function get rseCurrentArtist() : String;
      
      function get rseCurrentAlbum() : String;
      
      function get discErrorValue() : String;
      
      function get no_of_records() : int;
      
      function get browseListData() : Object;
      
      function get getVideoLockoutStatus() : Boolean;
      
      function get dvdDiscStatValue() : String;
      
      function get startDiscPlayStatus() : Boolean;
      
      function get fullScreenButtonPresent() : Boolean;
      
      function get listSyncStatus() : Boolean;
      
      function get rearSource() : String;
      
      function get rdc2VideoStatus() : String;
      
      function get browsePath() : Object;
      
      function get rearVideoStatus() : Boolean;
      
      function get frontSideCameraAvailable() : Boolean;
      
      function get isShuffleRepeatAvailable() : Boolean;
      
      function get rdc2Mode() : String;
      
      function get prevRdc2Mode() : String;
      
      function get vrmRequestICSTuning() : String;
      
      function get vrmAvailable() : Boolean;
      
      function get accessibilityAvailable() : Boolean;
      
      function setstartDiscPlayStatus(param1:Boolean) : void;
      
      function setdvdoutstat(param1:String) : void;
      
      function nextTrack(param1:uint) : void;
      
      function previousTrack(param1:uint) : void;
      
      function seeknext() : void;
      
      function seekback() : void;
      
      function buttonRelease() : void;
      
      function fastforward() : void;
      
      function fastrewind() : void;
      
      function setRepeatState(param1:String) : void;
      
      function setShuffleState(param1:String) : void;
      
      function resetDiscCurrentTrackName() : void;
      
      function discstop() : void;
      
      function startRdc2Video(param1:String) : void;
      
      function switchToVrmParentalControls() : void;
      
      function requestExitFullScreen(param1:String) : void;
      
      function getBrowseItems(param1:int = 0, param2:int = -1) : void;
      
      function getAccessibilitySupportStatus() : void;
      
      function getdvdDiscStatValue() : void;
      
      function playItem(param1:int) : void;
      
      function reportStatus() : void;
      
      function getstartDiscPlayValue() : void;
      
      function getCurrentTrackInfo() : void;
      
      function getRepeatShuffleStatus() : void;
      
      function getFullScreenButtonStat(param1:String) : void;
      
      function getListSyncStatus() : void;
      
      function setBrowsePath(param1:Object) : void;
      
      function muteExternalModule(param1:String) : void;
   }
}

