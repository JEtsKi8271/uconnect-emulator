package com.nfuzion.moduleLinkAPI
{
   public interface IMediaPlayer extends IModule
   {
      
      function getDevices() : void;
      
      function get devices() : Vector.<MediaPlayerDevice>;
      
      function get devicesForAutoPlayOff() : Vector.<MediaPlayerDevice>;
      
      function deSelectActiveDevice() : void;
      
      function getDevice(param1:int = -1) : void;
      
      function getCurrentDevice() : void;
      
      function get currentDevice() : MediaPlayerDevice;
      
      function setBrowsePath(param1:MediaPlayerPath, param2:Boolean = true) : void;
      
      function getBrowsePath() : void;
      
      function get browsePath() : MediaPlayerPath;
      
      function set browsePath(param1:MediaPlayerPath) : void;
      
      function getAlphaJumpTable() : void;
      
      function startCharactersAvailable() : Vector.<String>;
      
      function indexFromStartCharacter(param1:String) : int;
      
      function getBrowseItems(param1:* = null, param2:int = -1) : void;
      
      function getPlayPath() : void;
      
      function get playPath() : MediaPlayerPath;
      
      function mediaFilterListShow(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void;
      
      function checkDevicePlayable(param1:String) : void;
      
      function mediaErrorCode() : int;
      
      function mediaErrorMSID() : int;
      
      function activeDeviceMSID() : int;
      
      function devicePlayable(param1:Boolean) : void;
      
      function get mediaFilterListShowErrorCode() : int;
      
      function get VRContext() : Number;
      
      function set VRContext(param1:Number) : void;
      
      function get VRMethodName() : String;
      
      function set VRMethodName(param1:String) : void;
      
      function get isTrackSliding() : Boolean;
      
      function setTrackSlidingStatus(param1:Boolean) : void;
      
      function goToRoot() : void;
      
      function getPlayItems(param1:* = null, param2:int = -1) : void;
      
      function getCurrentTrack() : void;
      
      function get currentTrack() : uint;
      
      function get currentTrackMsid() : int;
      
      function getCurrentTrackLength() : void;
      
      function getCurrentTrackInfo() : void;
      
      function get currentTrackInfo() : MediaPlayerTrackInfo;
      
      function getCurrentAlbumArtPath() : void;
      
      function get currentAlbumArtPath() : String;
      
      function get currentAlbumArtMSID() : int;
      
      function getMediaProperties() : void;
      
      function setTransportAction(param1:String) : void;
      
      function getTransportAction() : void;
      
      function get transportAction() : String;
      
      function setPlayTime(param1:uint) : void;
      
      function getPlayTime() : void;
      
      function get playTime() : uint;
      
      function setPlayDuration(param1:uint) : void;
      
      function getPlayDuration() : void;
      
      function get playDuration() : uint;
      
      function setSeekSpeed(param1:Number) : void;
      
      function getSeekSpeed() : void;
      
      function get seekSpeed() : Number;
      
      function setAuditionPeriod(param1:uint) : void;
      
      function getAuditionPeriod() : void;
      
      function get auditionPeriod() : uint;
      
      function setSkipThreshold(param1:uint) : void;
      
      function getSkipThreshold() : void;
      
      function get skipThreshold() : uint;
      
      function setRepeatMode(param1:String) : void;
      
      function getRepeatMode() : void;
      
      function get repeatMode() : String;
      
      function setRandomMode(param1:String) : void;
      
      function getRandomMode() : void;
      
      function get randomMode() : String;
      
      function getPlaylistCount() : void;
      
      function get playlistCount() : uint;
      
      function getSyncState() : void;
      
      function get syncState() : int;
      
      function get mediaError() : Object;
      
      function get readyToBrowse() : Boolean;
      
      function get readyToBrowseSrcMsid() : int;
      
      function get VRData() : Object;
      
      function set VRData(param1:Object) : void;
      
      function getItemsFilterText(param1:Number = 0, param2:int = 0, param3:int = -1) : void;
      
      function set SearchText(param1:String) : void;
      
      function get SearchText() : String;
      
      function SetmBrowseItemsRequestProcessing(param1:Boolean) : void;
      
      function activeDeviceMsid() : uint;
      
      function get vrArtistFilterId() : int;
      
      function get vrAlbumFilterId() : int;
      
      function get vrPlaylistFilterId() : int;
      
      function get vrGenreFilterId() : int;
      
      function get vrPodcastFilterId() : int;
      
      function get vrMediaType() : String;
      
      function setvrIdValues(param1:int) : void;
      
      function cancelSearch() : void;
      
      function cancelAlphaJump() : void;
      
      function get RandomDeviceSupport() : Boolean;
      
      function get RepeatDeviceSupport() : Boolean;
      
      function setBrowselistLevel(param1:Vector.<MediaPlayerPath>) : void;
      
      function get BrowselistLevelData() : Vector.<MediaPlayerPath>;
   }
}

