package com.nfuzion.moduleLink
{
   import com.adobe.serialization.json.JSON;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.IMediaPlayer;
   import com.nfuzion.moduleLinkAPI.MediaPlayerDevice;
   import com.nfuzion.moduleLinkAPI.MediaPlayerEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerItem;
   import com.nfuzion.moduleLinkAPI.MediaPlayerItemList;
   import com.nfuzion.moduleLinkAPI.MediaPlayerPath;
   import com.nfuzion.moduleLinkAPI.MediaPlayerRandomMode;
   import com.nfuzion.moduleLinkAPI.MediaPlayerRepeatMode;
   import com.nfuzion.moduleLinkAPI.MediaPlayerSyncState;
   import com.nfuzion.moduleLinkAPI.MediaPlayerTrackInfo;
   import com.nfuzion.moduleLinkAPI.MediaPlayerTransportAction;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class MediaPlayer extends Module implements IMediaPlayer
   {
      
      private static var instance:MediaPlayer;
      
      private static const ITEMS_REQUEST_TIMEOUT:uint = 50000;
      
      private static const DBUS_DESTINATION:String = "Media";
      
      private static const ALBUM_ART_PATH:String = "/tmp";
      
      private static const AUX_ID:int = 245;
      
      private static const FILE_READING_ERROR_TIMEOUT:uint = 5000;
      
      private var mAudioManager:AudioManager;
      
      private const DEBUG:Boolean = true;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mLocalDevices:Dictionary = new Dictionary(false);
      
      private var mLocalDevicesAutoplayOff:Dictionary = new Dictionary(false);
      
      private var mPendingGetDevice:int = -1;
      
      private var mLocalCurrentDevice:MediaPlayerDevice = null;
      
      private var mLocalCurrentDeviceID:int = -1;
      
      private var mLocalCurrentDeviceHandle:int = 0;
      
      private var mLocalBrowsePath:MediaPlayerPath;
      
      private var mTargetBrowsePath:String = null;
      
      private var mLocalPlayPath:MediaPlayerPath = new MediaPlayerPath();
      
      private var mLocalTransportAction:String;
      
      private var localSeekSpeed:Number = 10;
      
      private var localAuditionPeriod:uint = 5000;
      
      private var localSkipThreshold:uint = 2000;
      
      private var mLocalRepeatMode:String;
      
      private var mLocalRandomMode:String;
      
      private var mLocalPlayTime:uint = 0;
      
      private var mLocalPlaylistCount:uint = 0;
      
      private var mLocalPlayDuration:uint = 0;
      
      private var mLocalCurrentTrack:uint = 0;
      
      private var mLocalCurrentTrackMsid:int = 0;
      
      private var mLocalTrackInfo:MediaPlayerTrackInfo;
      
      private var mMediaError:Object = null;
      
      private var mMediaErrorCode:int = 0;
      
      private var mMediaFilterListShowErrorCode:int = 0;
      
      private var mMediaErrorMSID:int = 0;
      
      private var mTrackSlidingStatus:Boolean = false;
      
      private var mBrowseItems:MediaPlayerItemList = null;
      
      private var mLocalCurrentAlbumArtPath:String = null;
      
      private var mLocalCurrentAlbumArtMSID:int = -1;
      
      private var mOutstandingBrowseItemsRequests:int = 0;
      
      private var mOutstandingBrowsePathRequests:int = 0;
      
      private var mGenerateAlphaTable:Boolean = false;
      
      private var mCharList:Vector.<MediaPlayerItemList>;
      
      private var mFolderLevelList:Vector.<MediaPlayerPath>;
      
      private var mRequestItemChar:String = "0";
      
      private var mBrowseItemsRequests:Array = new Array();
      
      private var mBrowseItemsRequestTimer:Timer = new Timer(ITEMS_REQUEST_TIMEOUT);
      
      public var mBrowseItemsRequestProcessing:Boolean = false;
      
      public var mSearchText:String = "";
      
      private var mPlayItemsRequests:Array = new Array();
      
      private var mPlayItemsRequestTimer:Timer = new Timer(ITEMS_REQUEST_TIMEOUT);
      
      private var mPlayItemsRequestProcessing:Boolean = false;
      
      private var mOutstandingPlayItemRequests:int = 0;
      
      private var mOutstandingPlayItemResponseIgnore:int = 0;
      
      private var mSyncState:Object = new Object();
      
      private var mReadyToBrowse:Object = new Object();
      
      private var mReadyToBrowseSrcMsid:int = 0;
      
      private var mVRMediaType:String = "";
      
      private var mVrArtistFilterId:int = -1;
      
      private var mVrAlbumFilterId:int = -1;
      
      private var mVrGenreFilterId:int = -1;
      
      private var mVrTitleFilterId:int = -1;
      
      private var mVrPlaylistFilterId:int = -1;
      
      private var mVrPodcastFilterId:int = -1;
      
      private var mDevicePlayable:Boolean = true;
      
      private var mPlayNextValidTrackTimer:Timer = new Timer(FILE_READING_ERROR_TIMEOUT);
      
      private var mRepeatRandomSupport:Boolean = true;
      
      private var mRepeatDeviceSupport:Boolean = false;
      
      private var mRandomDeviceSupport:Boolean = false;
      
      private var mTrackListErrorCode:int = -1;
      
      private var mTrackListStart:int = -1;
      
      private var mTrackListCount:int = -1;
      
      private var mTrackListRequestError:Boolean = false;
      
      private var mMediaSearchActive:Boolean = false;
      
      private var mMediaServiceAvailable:Boolean = false;
      
      private var _VRContext:Number;
      
      private var mMethodName:String = "";
      
      private var _VRData:Object;
      
      public function MediaPlayer()
      {
         super();
         this.mLocalBrowsePath = new MediaPlayerPath();
         this.mLocalBrowsePath.path = "";
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.MEDIA_PLAYER,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.mPlayItemsRequestTimer.addEventListener(TimerEvent.TIMER,this.timeoutPlayItems);
         this.mBrowseItemsRequestTimer.addEventListener(TimerEvent.TIMER,this.timeoutBrowseItems);
         this.mPlayNextValidTrackTimer.addEventListener(TimerEvent.TIMER,this.timeoutErrorTrack);
         this.mAudioManager = AudioManager.getInstance();
         this.mAudioManager.addEventListener(ModuleEvent.READY,this.audioManagerReady);
         if(this.mAudioManager.isReady())
         {
            this.audioManagerReady();
         }
      }
      
      public static function getInstance() : MediaPlayer
      {
         if(instance == null)
         {
            instance = new MediaPlayer();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendSubscribe("activeDevice");
         this.sendSubscribe("trackState");
         var trackInfo:MediaPlayerTrackInfo = new MediaPlayerTrackInfo();
         trackInfo.album = "";
         trackInfo.artist = "";
         trackInfo.composer = "";
         trackInfo.filename = "";
         trackInfo.genre = "";
         trackInfo.title = "";
         trackInfo.year = 0;
         trackInfo.msid = 0;
         this.mLocalTrackInfo = trackInfo;
         this.sendSubscribe("nowPlaying");
         this.sendSubscribe("deviceState");
         this.sendSubscribe("readyToBrowse");
         this.getDevices();
         this.mLocalPlayTime = 0;
         this.mLocalPlayDuration = 0;
         this.sendSubscribe("playTime");
         this.mLocalRandomMode = MediaPlayerRandomMode.OFF;
         this.sendSubscribe("random");
         this.mLocalRepeatMode = MediaPlayerRepeatMode.OFF;
         this.sendSubscribe("repeat");
         this.mLocalTransportAction = MediaPlayerTransportAction.PAUSE;
         this.sendSubscribe("playState");
         this.sendSubscribe("alphaJumpResult");
         this.sendSubscribe("syncState");
         this.sendSubscribe("mediaError");
         this.sendSubscribe("devicePlayable");
         this.sendSubscribe("filterTextResult");
         this.sendSubscribe("DeviceCapability");
         addInterest(MediaPlayerEvent.DEVICE);
         addInterest(MediaPlayerEvent.DEVICES);
         addInterest(MediaPlayerEvent.CURRENT_DEVICE);
         addInterest(MediaPlayerEvent.CURRENT_TRACK);
         addInterest(MediaPlayerEvent.PLAY_TIME);
         addInterest(MediaPlayerEvent.RANDOM_MODE);
         addInterest(MediaPlayerEvent.REPEAT_MODE);
         addInterest(MediaPlayerEvent.CURRENT_TRACK_INFO);
         addInterest(MediaPlayerEvent.TRANSPORT_ACTION);
         addInterest(MediaPlayerEvent.SYNC_STATE);
         addInterest(MediaPlayerEvent.MEDIA_ERROR);
         addInterest(MediaPlayerEvent.DEVICE_READY_TO_BROWSE);
         addInterest(MediaPlayerEvent.DEVICE_CAPABILITY);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function audioManagerReady(e:Event = null) : void
      {
         if(this.mAudioManager.isReady())
         {
            this.mAudioManager.addEventListener(AudioEvent.AVAILABILITY,this.audioSources);
            this.mAudioManager.addEventListener(AudioEvent.SOURCE,this.audioCurrentSource);
            this.audioSources();
            this.audioCurrentSource();
         }
      }
      
      public function devicePlayable(value:Boolean) : void
      {
         this.mDevicePlayable = value;
      }
      
      public function checkDevicePlayable(deviceName:String) : void
      {
         var browseType:String = null;
         this.mDevicePlayable = true;
         var currId:int = this.findDeviceIdFromName(deviceName);
         if(currId != -1)
         {
            browseType = "metadata";
            this.hbDevicePlayable(currId,"devicePlayable");
         }
      }
      
      private function findDeviceIdFromName(deviceName:String) : int
      {
         var dev:MediaPlayerDevice = null;
         var currId:int = -1;
         var found:Boolean = false;
         for each(dev in this.mLocalDevices)
         {
            if(dev.type == deviceName)
            {
               found = true;
               return dev.id;
            }
         }
         return currId;
      }
      
      private function audioSources(e:AudioEvent = null) : void
      {
         var aux:Object = new Object();
         var d:Object = new Object();
         if(this.mAudioManager.isSourceAvailable(this.mAudioManager.SOURCE_AUX))
         {
            if(this.mLocalDevices[AUX_ID] == null)
            {
               d.id = AUX_ID;
               d.name = "AUX";
               d.type = MediaPlayerDevice.AUX;
               aux.device = d;
               aux.available = true;
               this.processDevice(aux);
            }
         }
         else if(this.mLocalDevices[AUX_ID] != null)
         {
            d.id = AUX_ID;
            d.name = "AUX";
            d.type = MediaPlayerDevice.AUX;
            aux.device = d;
            aux.available = false;
            this.processDevice(aux);
         }
      }
      
      private function audioCurrentSource(e:AudioEvent = null) : void
      {
         var d:Object = new Object();
         if(this.mAudioManager.source == this.mAudioManager.SOURCE_AUX)
         {
            d.id = AUX_ID;
            d.name = "AUX";
            d.type = MediaPlayerDevice.AUX;
            this.processActiveDevice(d);
         }
         if(Boolean(e) && Boolean(this.mMediaErrorCode != 0) && (this.mAudioManager.source == this.mAudioManager.SOURCE_AUX || this.mAudioManager.source == this.mAudioManager.SOURCE_CD || this.mAudioManager.source == this.mAudioManager.SOURCE_DTV || this.mAudioManager.source == this.mAudioManager.SOURCE_REAR_AUX1 || this.mAudioManager.source == this.mAudioManager.SOURCE_REAR_AUX2 || this.mAudioManager.source == this.mAudioManager.SOURCE_REAR_HDMI1 || this.mAudioManager.source == this.mAudioManager.SOURCE_REAR_HDMI2))
         {
            this.mMediaErrorCode = 0;
         }
      }
      
      override protected function subscribe(signalName:String) : void
      {
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
      }
      
      public function deeptrace(obj:*, level:int = 0) : void
      {
         var prop:String = null;
         var tabs:String = "";
         for(var i:int = 0; i < level; i++)
         {
            tabs += "\t";
         }
         for(prop in obj)
         {
            this.traceout(tabs + "[" + prop + "] -> " + obj[prop]);
            this.deeptrace(obj[prop],level + 1);
         }
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var VRResult:Object = null;
         var GotoTarget:String = null;
         var processed:Boolean = false;
         var mediaPlayer:Object = e.data;
         if(mediaPlayer.hasOwnProperty("dBusServiceAvailable"))
         {
            if(mediaPlayer.dBusServiceAvailable == "true" && this.mMediaServiceAvailable == false)
            {
               this.mMediaServiceAvailable = true;
               this.hbGetProperties("activeDevice");
               this.getMediaProperties();
            }
            else if(mediaPlayer.dBusServiceAvailable == "false")
            {
               this.mMediaServiceAvailable = false;
            }
         }
         if(mediaPlayer.hasOwnProperty("repeat"))
         {
            this.processRepeat(mediaPlayer.repeat);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("random"))
         {
            this.processRandom(mediaPlayer.random);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("deviceState"))
         {
            this.processDevice(mediaPlayer.deviceState);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("trackState"))
         {
            this.processTrackState(mediaPlayer.trackState);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("nowPlaying"))
         {
            this.processNowPlaying(mediaPlayer.nowPlaying);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("playState"))
         {
            this.processPlayState(mediaPlayer.playState);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("playTime"))
         {
            this.processPlayTime(mediaPlayer.playTime);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("syncState"))
         {
            this.processSyncState(mediaPlayer.syncState);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("scan"))
         {
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("mediaError"))
         {
            this.processMediaError(mediaPlayer.mediaError);
            if(this.mMediaErrorCode == MediaErrorCodes.UNEXPECTED_STOP_WITH_ERROR)
            {
               this.mMediaErrorCode = 0;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("devicePlayable"))
         {
            if(mediaPlayer.devicePlayable)
            {
               this.mDevicePlayable = mediaPlayer.devicePlayable.devicePlayable;
               if(!this.mDevicePlayable)
               {
                  dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MEDIA_UNPLAYABLE));
               }
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("readyToBrowse"))
         {
            this.processReadyToBrowse(mediaPlayer.readyToBrowse);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("serviceState"))
         {
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("availablePreset"))
         {
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("activeDevice"))
         {
            this.mMediaErrorCode = 0;
            if(null != mediaPlayer.activeDevice && (null == this.mLocalCurrentDevice || this.mLocalCurrentDevice.id != mediaPlayer.activeDevice.device.id) && Boolean(mediaPlayer.activeDevice.hasOwnProperty("device")))
            {
               this.processActiveDevice(mediaPlayer.activeDevice.device);
               --this.mOutstandingBrowsePathRequests;
            }
            if(this.mTrackListErrorCode == MediaErrorCodes.NO_MEDIA_DEVICE)
            {
               this.mTrackListRequestError = true;
               this.mPlayItemsRequestProcessing = false;
               this.getPlayItems(this.mTrackListStart,this.mTrackListCount);
               this.mTrackListErrorCode = -1;
            }
            else
            {
               this.mTrackListRequestError = false;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("mediaEcoFilesAvailable"))
         {
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("filterTextResult"))
         {
            this.traceout("getItemsFilterTextreturn. items Count: " + mediaPlayer.filterTextResult.count);
            this.traceout("getItemsFilterTextreturn. items: " + com.adobe.serialization.json.JSON.encode(mediaPlayer.filterTextResult));
            if(!this.mMediaSearchActive)
            {
               processed = true;
               return;
            }
            if(mediaPlayer.filterTextResult.filterList == null)
            {
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.SEARCH_COUNT,mediaPlayer.filterTextResult.count));
            }
            else if(mediaPlayer.filterTextResult.filterList != null)
            {
               --this.mOutstandingBrowseItemsRequests;
               if(this.mOutstandingBrowseItemsRequests <= 0)
               {
                  this.processBrowseItems(mediaPlayer.filterTextResult.filterList);
                  this.mOutstandingBrowseItemsRequests = 0;
               }
            }
            else
            {
               this.mBrowseItemsRequestTimer.reset();
               this.mOutstandingBrowseItemsRequests = 0;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("alphaJumpResult"))
         {
            if(this.mGenerateAlphaTable == true)
            {
               this.getItemsCharIndexTable = mediaPlayer.alphaJumpResult;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("DeviceCapability"))
         {
            this.mRandomDeviceSupport = mediaPlayer.DeviceCapability.randomSupported;
            this.mRepeatDeviceSupport = mediaPlayer.DeviceCapability.repeatSupported;
            processed = true;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DEVICE_CAPABILITY));
         }
         if(mediaPlayer.hasOwnProperty("getProperties"))
         {
            if(mediaPlayer.getProperties.hasOwnProperty("repeat"))
            {
               this.processRepeat(mediaPlayer.getProperties.repeat);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("random"))
            {
               this.processRandom(mediaPlayer.getProperties.random);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("deviceState"))
            {
               this.processDevice(mediaPlayer.getProperties.deviceState);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("trackState"))
            {
               this.processTrackState(mediaPlayer.getProperties.trackState);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("nowPlaying"))
            {
               this.processNowPlaying(mediaPlayer.getProperties.nowPlaying);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("devicePlayable"))
            {
               processed = true;
               if(mediaPlayer.getProperties.devicePlayable)
               {
                  this.mDevicePlayable = mediaPlayer.getProperties.devicePlayable.devicePlayable;
                  if(!this.mDevicePlayable)
                  {
                     dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MEDIA_UNPLAYABLE));
                  }
               }
            }
            if(mediaPlayer.getProperties.hasOwnProperty("playState"))
            {
               this.processPlayState(mediaPlayer.getProperties.playState);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("playTime"))
            {
               this.processPlayTime(mediaPlayer.getProperties.playTime);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("syncState"))
            {
               this.processSyncState(mediaPlayer.getProperties.syncState);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("scan"))
            {
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("mediaError"))
            {
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("serviceState"))
            {
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("availablePreset"))
            {
               processed = true;
            }
            if(Boolean(mediaPlayer.getProperties.hasOwnProperty("activeDevice")) && Boolean(null != mediaPlayer.getProperties.activeDevice) && Boolean(mediaPlayer.getProperties.activeDevice.hasOwnProperty("device")))
            {
               this.processActiveDevice(mediaPlayer.getProperties.activeDevice.device);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("readyToBrowse"))
            {
               this.processReadyToBrowse(mediaPlayer.getProperties.readyToBrowse);
               processed = true;
            }
            if(mediaPlayer.getProperties.hasOwnProperty("mediaEcoFilesAvailable"))
            {
               processed = true;
            }
         }
         if(mediaPlayer.hasOwnProperty("getDevices"))
         {
            this.processDevices(mediaPlayer.getDevices.devices);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("getPlaylistsCount"))
         {
            this.processPlaylistCount(mediaPlayer.getPlaylistsCount);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("selectDevice"))
         {
            if(!mediaPlayer.selectDevice.description)
            {
               --this.mOutstandingBrowsePathRequests;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("gotoRoot"))
         {
            this.processSelection(mediaPlayer.gotoRoot);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("selectAll"))
         {
            this.processSelection(mediaPlayer.selectAll);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("gotoPrevious"))
         {
            this.processSelection(mediaPlayer.gotoPrevious);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("seekToTime"))
         {
            this.setTransportAction(MediaPlayerTransportAction.RESUME);
            this.mTrackSlidingStatus = false;
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("selectItem"))
         {
            this.processSelection(mediaPlayer.selectItem);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("selection"))
         {
            this.processSelection(mediaPlayer.selection);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("getItems"))
         {
            if(mediaPlayer.getItems.request == "getItems" && mediaPlayer.getItems.items != null)
            {
               --this.mOutstandingBrowseItemsRequests;
               if(this.mOutstandingBrowseItemsRequests <= 0)
               {
                  this.processBrowseItems(mediaPlayer.getItems.items);
                  this.mOutstandingBrowseItemsRequests = 0;
               }
            }
            else
            {
               this.mBrowseItemsRequestTimer.reset();
               this.mOutstandingBrowseItemsRequests = 0;
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("getItemsChar"))
         {
            if(this.mGenerateAlphaTable == true)
            {
               this.getItemsChar = mediaPlayer.getItemsChar;
            }
            else
            {
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_MATCH_ITEMS,mediaPlayer.getItemsChar.items));
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("getCurrentTrackList"))
         {
            if(this.mOutstandingPlayItemResponseIgnore > 0)
            {
               --this.mOutstandingPlayItemResponseIgnore;
            }
            else
            {
               --this.mOutstandingPlayItemRequests;
               this.processPlayItems(mediaPlayer.getCurrentTrackList.items);
               if(mediaPlayer.getCurrentTrackList.hasOwnProperty("code"))
               {
                  this.mTrackListErrorCode = mediaPlayer.getCurrentTrackList.code;
               }
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("getAlbumArt"))
         {
            this.processAlbumArt(mediaPlayer.getAlbumArt);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("pause"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("play"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("playAll"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("resume"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("stop"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("next"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("previous"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("fastForward"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("fastReverse"))
         {
            this.processTransportMethodReturn(mediaPlayer);
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("mediaFilterListShow"))
         {
            VRResult = {
               "Context":this.VRContext,
               "methodName":this.VRMethodName,
               "Result":false
            };
            if(Boolean(mediaPlayer.mediaFilterListShow.code) && (mediaPlayer.mediaFilterListShow.code == 20 || mediaPlayer.mediaFilterListShow.code == 25))
            {
               this.mMediaFilterListShowErrorCode = mediaPlayer.mediaFilterListShow.code;
               VRResult.Result = "invalid";
            }
            else
            {
               this.mMediaFilterListShowErrorCode = 0;
            }
            if(mediaPlayer.mediaFilterListShow.request == "mediaFilterListShow")
            {
               if(mediaPlayer.mediaFilterListShow.alphaJumpAvailable != null && mediaPlayer.mediaFilterListShow.itemsCount != null)
               {
                  this.VRData = {
                     "count":mediaPlayer.mediaFilterListShow.itemsCount,
                     "alphaJumpAvailable":mediaPlayer.mediaFilterListShow.alphaJumpAvailable
                  };
               }
               if(mediaPlayer.mediaFilterListShow.itemsCount != null && mediaPlayer.mediaFilterListShow.items.length == 0)
               {
                  this.VRData = {"count":mediaPlayer.mediaFilterListShow.itemsCount};
                  GotoTarget = "mediaBrowse";
                  switch(this.mVRMediaType)
                  {
                     case "genre":
                        GotoTarget = "mediaGenre";
                        break;
                     case "artist":
                        GotoTarget = "mediaArtist";
                        break;
                     case "album":
                        GotoTarget = "mediaAlbum";
                        break;
                     case "title":
                        GotoTarget = "mediaTitle";
                        break;
                     case "playlist":
                        GotoTarget = "mediaPlaylist";
                        break;
                     case "audiobook":
                        GotoTarget = "mediaAudiobook";
                        break;
                     case "podcast":
                        GotoTarget = "mediaPodcast";
                  }
                  if(!(this.vrGenreFilterId > 0 || this.vrArtistFilterId > 0 || this.vrAlbumFilterId > 0 || this.vrPlaylistFilterId > -1 || this.mVrPodcastFilterId > -1))
                  {
                     this.VRData = null;
                  }
                  VRResult = {
                     "Context":this.VRContext,
                     "methodName":this.VRMethodName,
                     "Result":true
                  };
                  dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.VR_COUNT,mediaPlayer.mediaFilterListShow.itemsCount));
                  dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_GOTO,{"videoScreen":GotoTarget}));
               }
               else
               {
                  VRResult = null;
                  this.processBrowseItems(mediaPlayer.mediaFilterListShow.items);
               }
            }
            if(VRResult)
            {
               dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_RESULT,VRResult));
            }
            processed = true;
         }
         if(mediaPlayer.hasOwnProperty("setProperties"))
         {
            if(mediaPlayer.setProperties.hasOwnProperty("failed"))
            {
               if(mediaPlayer.setProperties.failed == "repeat" || mediaPlayer.setProperties.failed == "random")
               {
                  this.mRepeatRandomSupport = false;
               }
            }
            processed = true;
         }
         if(!processed)
         {
            this.deeptrace(mediaPlayer);
         }
      }
      
      public function get VRContext() : Number
      {
         return this._VRContext;
      }
      
      public function set VRContext(Value:Number) : void
      {
         this._VRContext = Value;
      }
      
      public function get VRMethodName() : String
      {
         return this.mMethodName;
      }
      
      public function set VRMethodName(methodName:String) : void
      {
         this.mMethodName = methodName;
      }
      
      private function processTransportMethodReturn(transportMethod:Object) : void
      {
         if(transportMethod.hasOwnProperty("pause"))
         {
            if(transportMethod.pause.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.PAUSE;
            }
         }
         if(transportMethod.hasOwnProperty("play"))
         {
            if(transportMethod.play.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.PLAY;
            }
         }
         if(transportMethod.hasOwnProperty("playAll"))
         {
            if(transportMethod.playAll.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.PLAY;
            }
         }
         if(transportMethod.hasOwnProperty("resume"))
         {
            if(transportMethod.resume.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.PLAY;
            }
         }
         if(transportMethod.hasOwnProperty("stop"))
         {
            if(transportMethod.stop.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.STOP;
            }
         }
         if(transportMethod.hasOwnProperty("fastForward"))
         {
            if(transportMethod.fastForward.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.FAST_FORWARD;
            }
         }
         if(transportMethod.hasOwnProperty("fastReverse"))
         {
            if(transportMethod.fastReverse.description == "success")
            {
               this.mLocalTransportAction = MediaPlayerTransportAction.FAST_REVERSE;
            }
         }
         if(transportMethod.hasOwnProperty("next"))
         {
         }
         if(transportMethod.hasOwnProperty("previous"))
         {
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.TRANSPORT_ACTION));
      }
      
      private function set getItemsChar(list:Object) : void
      {
         var item:MediaPlayerItem = null;
         var vec:Vector.<MediaPlayerItem> = null;
         if(this.mLocalCurrentDevice.type != MediaPlayerDevice.IPOD && list.hasOwnProperty("index") && list.index == 0 && list.hasOwnProperty("items") && list.items.length == 0)
         {
            this.mGenerateAlphaTable = false;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
            return;
         }
         var code:Number = 0;
         var previous:Number = this.mRequestItemChar.charCodeAt(0);
         if(list.hasOwnProperty("items") && list.items.length > 0)
         {
            item = new MediaPlayerItem();
            item.name = list.items[0].name.charAt(0);
            vec = new Vector.<MediaPlayerItem>();
            vec.push(item);
            this.mCharList.push(new MediaPlayerItemList(list.index,vec));
            code = item.name.charCodeAt(0);
            if(code < previous)
            {
               this.mGenerateAlphaTable = false;
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
               return;
            }
         }
         else
         {
            code = this.mRequestItemChar.charCodeAt(0);
         }
         if(90 == code)
         {
            code = 96;
         }
         if(57 == code)
         {
            code = 64;
         }
         code++;
         if(code < 123)
         {
            this.hbGetItemsChar(String.fromCharCode(code),1);
            return;
         }
         this.mGenerateAlphaTable = false;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
      }
      
      private function set getItemsCharIndexTable(list:Object) : void
      {
         var i:int = 0;
         var item:MediaPlayerItem = null;
         var vec:Vector.<MediaPlayerItem> = null;
         if(this.mLocalCurrentDevice.type != MediaPlayerDevice.IPOD && list.hasOwnProperty("alphaJumpList") && list.alphaJumpList.length == 0)
         {
            this.mGenerateAlphaTable = false;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
            return;
         }
         if(list.hasOwnProperty("alphaJumpList") && list.alphaJumpList.length > 0)
         {
            for(i = 0; i < list.alphaJumpList.length; i++)
            {
               item = new MediaPlayerItem();
               item.name = list.alphaJumpList[i].key;
               vec = new Vector.<MediaPlayerItem>();
               vec.push(item);
               this.mCharList.push(new MediaPlayerItemList(list.alphaJumpList[i].index,vec));
            }
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
            return;
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_CHARLIST,this.mCharList));
      }
      
      public function startCharactersAvailable() : Vector.<String>
      {
         var availableChars:Vector.<String> = new Vector.<String>();
         if(null == this.mCharList)
         {
            return availableChars;
         }
         var index:uint = 0;
         while(index < this.mCharList.length)
         {
            availableChars.push(this.mCharList[index].list[0].name.charAt(0));
            index++;
         }
         return availableChars;
      }
      
      public function indexFromStartCharacter(char:String) : int
      {
         if(null == this.mCharList)
         {
            return -1;
         }
         var index:uint = 0;
         while(index < this.mCharList.length)
         {
            if(this.mCharList[index].list[0].name.charAt(0).toUpperCase() == char.toUpperCase())
            {
               return this.mCharList[index].offset - 1;
            }
            index++;
         }
         return -1;
      }
      
      private function processTrackState(trackState:Object) : void
      {
         if(trackState != null && this.mDevicePlayable)
         {
            this.mLocalPlayPath.itemCount = trackState.totalTracks;
            this.mLocalPlayPath.id = trackState.fid;
            this.mLocalCurrentTrack = trackState.track;
            this.mLocalCurrentTrackMsid = trackState.msid;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.CURRENT_TRACK));
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY_PATH));
            this.mPlayNextValidTrackTimer.stop();
         }
      }
      
      private function processNowPlaying(nowPlaying:Object) : void
      {
         var trackInfo:MediaPlayerTrackInfo = null;
         if(this.mAudioManager.source == this.mAudioManager.SOURCE_HTTPSTREAMER1 || this.mAudioManager.source == this.mAudioManager.SOURCE_HTTPSTREAMER2 || this.mAudioManager.source == this.mAudioManager.SOURCE_HTTPSTREAMER3)
         {
            return;
         }
         if(nowPlaying != null && nowPlaying.msid != this.mAudioManager.getMSIdForSource(this.mAudioManager.source))
         {
            return;
         }
         var msid:String = "";
         if(nowPlaying != null && this.mDevicePlayable)
         {
            this.mMediaErrorCode = 0;
            trackInfo = new MediaPlayerTrackInfo();
            trackInfo.album = nowPlaying.album;
            trackInfo.artist = nowPlaying.artist;
            trackInfo.composer = nowPlaying.composer;
            trackInfo.filename = nowPlaying.filename;
            trackInfo.genre = nowPlaying.genre;
            trackInfo.title = nowPlaying.title;
            trackInfo.year = nowPlaying.year;
            trackInfo.msid = nowPlaying.msid;
            this.mLocalTrackInfo = trackInfo;
            msid = nowPlaying.msid;
            this.getCurrentAlbumArtPath();
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.CURRENT_TRACK_INFO,msid));
      }
      
      private function processRandom(random:Object) : void
      {
         if(null != random && random.hasOwnProperty("mode"))
         {
            this.mLocalRandomMode = random.mode;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.RANDOM_MODE,this.mRepeatRandomSupport));
         }
      }
      
      private function processRepeat(repeat:Object) : void
      {
         if(null != repeat && repeat.hasOwnProperty("mode"))
         {
            this.mLocalRepeatMode = repeat.mode;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.REPEAT_MODE,this.mRepeatRandomSupport));
         }
      }
      
      private function processAlbumArt(albumArt:Object) : void
      {
         this.mLocalCurrentAlbumArtPath = albumArt.path;
         this.mLocalCurrentAlbumArtMSID = albumArt.msid;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.CURRENT_ALBUM_ART_PATH));
      }
      
      private function processReadyToBrowse(device:Object) : void
      {
         if(device != null)
         {
            if(this.mLocalDevices[device.id] != null)
            {
               this.mLocalDevices[device.id].readyToBrowse = device.status == true ? true : false;
            }
            this.mReadyToBrowse[device.id] = device.status == true ? true : false;
            this.mReadyToBrowseSrcMsid = device.id;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DEVICE_READY_TO_BROWSE));
         }
      }
      
      private function processPlaylistCount(getPlaylistsCount:Object) : void
      {
         this.mLocalPlaylistCount = getPlaylistsCount.playListsCount;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAYLIST_COUNT));
      }
      
      private function processDevices(devices:Object) : void
      {
         var dev:MediaPlayerDevice = null;
         var id:int = 0;
         var device:Object = null;
         for each(device in devices)
         {
            dev = new MediaPlayerDevice();
            id = new int();
            id = int(device.device.id);
            if(this.mLocalDevices == null || this.mLocalDevices[id] == null)
            {
               dev.syncState = MediaPlayerSyncState.NONE;
               dev.readyToBrowse = false;
            }
            dev.id = id;
            dev.available = device.available;
            dev.name = device.device.name;
            switch(device.device.type)
            {
               case MediaPlayerDevice.BLUETOOTH:
               case MediaPlayerDevice.USB:
               case MediaPlayerDevice.IPOD:
               case MediaPlayerDevice.AUX:
               case MediaPlayerDevice.PFS:
               case MediaPlayerDevice.SDCARD:
                  dev.type = device.device.type;
                  dev.autoplayOff = 0;
                  break;
               default:
                  dev.type = MediaPlayerDevice.OTHER;
            }
            if(this.mPendingGetDevice == dev.id)
            {
               this.mLocalCurrentDeviceID = dev.id;
               this.mLocalCurrentDevice = dev;
               this.mPendingGetDevice = -1;
            }
            if(dev.type != MediaPlayerDevice.OTHER)
            {
               this.mLocalDevices[id] = dev;
               this.mLocalDevicesAutoplayOff[id] = dev;
            }
         }
         this.dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DEVICES));
      }
      
      private function processActiveDevice(device:Object) : void
      {
         var dev:MediaPlayerDevice = new MediaPlayerDevice();
         dev.available = true;
         dev.id = device.id;
         dev.name = device.name;
         switch(device.type)
         {
            case MediaPlayerDevice.BLUETOOTH:
            case MediaPlayerDevice.USB:
            case MediaPlayerDevice.IPOD:
            case MediaPlayerDevice.AUX:
            case MediaPlayerDevice.PFS:
            case MediaPlayerDevice.SDCARD:
               dev.type = device.type;
               break;
            default:
               dev.type = MediaPlayerDevice.OTHER;
         }
         if(this.mLocalCurrentDeviceID != dev.id)
         {
            this.initializeAllVariablesAndStates();
         }
         dev.autoplayOff = 1;
         this.mLocalDevices[dev.id] = dev;
         this.mLocalCurrentDevice = dev;
         this.mLocalCurrentDeviceID = dev.id;
         this.mLocalCurrentDeviceHandle = device.handle;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DEVICE_ACTIVE,device.handle));
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.SYNC_STATE));
      }
      
      private function processDevice(deviceState:Object) : void
      {
         var dev:MediaPlayerDevice = new MediaPlayerDevice();
         if(deviceState.device.id != null)
         {
            dev.id = deviceState.device.id;
            dev.available = Boolean(deviceState.available) == true ? true : false;
            dev.name = deviceState.device.name;
            dev.syncState = MediaPlayerSyncState.NONE;
            dev.readyToBrowse = false;
            switch(deviceState.device.type)
            {
               case MediaPlayerDevice.BLUETOOTH:
               case MediaPlayerDevice.USB:
               case MediaPlayerDevice.IPOD:
               case MediaPlayerDevice.AUX:
               case MediaPlayerDevice.PFS:
               case MediaPlayerDevice.SDCARD:
                  dev.type = deviceState.device.type;
                  break;
               default:
                  dev.type = MediaPlayerDevice.OTHER;
            }
            if(dev.id == this.mLocalCurrentDeviceID)
            {
               if(dev.available == false)
               {
                  this.initializeLocalTrackInfo();
                  this.mLocalDevices[dev.id] = null;
                  this.mLocalDevicesAutoplayOff[dev.id] = null;
                  delete this.mLocalDevices[dev.id];
                  delete this.mLocalDevicesAutoplayOff[dev.id];
                  this.mLocalCurrentDeviceID = -1;
                  this.mLocalCurrentDeviceHandle = 0;
                  this.mReadyToBrowse[dev.id] = false;
                  this.mSyncState[dev.id] = MediaPlayerSyncState.NONE;
                  this.mLocalPlayPath = new MediaPlayerPath();
                  this.mLocalPlayPath.itemCount = 0;
                  this.setNextValidMediaSourceToCurrent();
               }
            }
            else if(dev.available == true)
            {
               if(dev.type != MediaPlayerDevice.OTHER)
               {
                  dev.autoplayOff = 1;
                  this.mLocalDevices[dev.id] = dev;
                  this.mLocalDevicesAutoplayOff[dev.id] = dev;
               }
            }
            else
            {
               this.mLocalDevices[dev.id] = null;
               this.mLocalDevicesAutoplayOff[dev.id] = null;
               delete this.mLocalDevices[dev.id];
               delete this.mLocalDevicesAutoplayOff[dev.id];
               this.mReadyToBrowse[dev.id] = false;
               this.mSyncState[dev.id] = MediaPlayerSyncState.NONE;
               if(this.mediaError != null && this.mediaError.msid == dev.id)
               {
                  this.mMediaErrorCode = 0;
               }
            }
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.DEVICE,dev));
         }
      }
      
      private function setNextValidMediaSourceToCurrent() : void
      {
         var dev:MediaPlayerDevice = null;
         var found:Boolean = false;
         for each(dev in this.mLocalDevices)
         {
            if(dev != null)
            {
               found = true;
               break;
            }
         }
         if(found)
         {
            this.mLocalCurrentDevice = dev;
            this.mLocalCurrentDeviceID = dev.id;
         }
         else
         {
            this.initializeAllVariablesAndStates();
         }
      }
      
      private function initializeLocalTrackInfo() : void
      {
         this.mLocalTrackInfo.album = "";
         this.mLocalTrackInfo.artist = "";
         this.mLocalTrackInfo.composer = "";
         this.mLocalTrackInfo.filename = "";
         this.mLocalTrackInfo.genre = "";
         this.mLocalTrackInfo.title = "";
         this.mLocalTrackInfo.year = 0;
         this.mLocalTrackInfo.msid = 0;
         this.mLocalCurrentAlbumArtPath = "";
      }
      
      private function initializeAllVariablesAndStates() : void
      {
         this.mBrowseItems = null;
         this.mLocalDevices = new Dictionary(false);
         this.mLocalCurrentAlbumArtPath = "";
         this.mLocalCurrentAlbumArtMSID = -1;
         this.mLocalCurrentDevice = null;
         this.mLocalCurrentDeviceID = -1;
         this.mLocalCurrentDeviceHandle = 0;
         this.mLocalCurrentTrack = 0;
         this.mLocalCurrentTrackMsid = 0;
         this.mLocalPlayDuration = 0;
         this.mLocalPlayTime = 0;
         this.mPendingGetDevice = -1;
         this.mTargetBrowsePath = new String();
         this.mLocalTransportAction = MediaPlayerTransportAction.PAUSE;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.TRANSPORT_ACTION));
         this.mLocalRepeatMode = MediaPlayerRepeatMode.OFF;
         this.mLocalRandomMode = MediaPlayerRandomMode.OFF;
         this.mOutstandingBrowseItemsRequests = 0;
         this.mOutstandingBrowsePathRequests = 0;
         this.mMediaFilterListShowErrorCode = 0;
         this.mBrowseItemsRequests = new Array();
         this.mBrowseItemsRequestProcessing = false;
         this.mBrowseItemsRequestTimer.reset();
         this.mPlayItemsRequests = new Array();
         this.mPlayItemsRequestProcessing = false;
         if(this.mOutstandingPlayItemRequests > 0)
         {
            this.mOutstandingPlayItemResponseIgnore += this.mOutstandingPlayItemRequests;
         }
         this.mOutstandingPlayItemRequests = 0;
         this.mPlayItemsRequestTimer.reset();
         this.initializeLocalTrackInfo();
         this.mLocalBrowsePath = new MediaPlayerPath();
         this.mLocalBrowsePath.path = "";
         this.mLocalPlayPath = new MediaPlayerPath();
         this.mLocalPlayPath.itemCount = 0;
         this.mSyncState = new Object();
         this.mReadyToBrowse = new Object();
         this.mPlayNextValidTrackTimer.stop();
         this.mRepeatRandomSupport = true;
         this.mRandomDeviceSupport = false;
         this.mRepeatDeviceSupport = false;
      }
      
      private function processSelection(selection:Object) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         --this.mOutstandingBrowsePathRequests;
         if(selection.hasOwnProperty("description"))
         {
            return;
         }
         if(this.mOutstandingBrowsePathRequests <= 0)
         {
            this.mOutstandingBrowsePathRequests = 0;
            if(selection == null)
            {
               return;
            }
            this.mLocalBrowsePath.id = int(selection.track);
            this.mLocalBrowsePath.itemCount = int(selection.count);
            this.mLocalBrowsePath.name = selection.name;
            this.mLocalBrowsePath.type = selection.type;
            this.mLocalBrowsePath.alphaJumpAvailable = selection.alphaJumpAvailable == "true" || selection.alphaJumpAvailable == true ? true : false;
            this.mBrowseItems = null;
            if(this.mTargetBrowsePath == null)
            {
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_PATH));
            }
            else
            {
               data.path = this.mTargetBrowsePath;
               if(this.mLocalBrowsePath.path.search(MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.FOLDERS) != -1)
               {
                  data.type = "directory";
               }
               this.setBrowsePath(data,false);
            }
         }
      }
      
      public function processBrowseItems(hbItemList:Object) : void
      {
         var list:Vector.<MediaPlayerItem> = null;
         var hbItem:Object = null;
         var browseItem:Object = null;
         var item:MediaPlayerItem = null;
         var data:MediaPlayerPath = new MediaPlayerPath();
         if(hbItemList != null && this.mBrowseItemsRequestProcessing)
         {
            list = new Vector.<MediaPlayerItem>();
            for each(hbItem in hbItemList)
            {
               item = new MediaPlayerItem();
               item.id = int(hbItem.id);
               item.type = hbItem.type;
               item.name = hbItem.name;
               item.browsable = hbItem.browsable;
               item.nowPlaying = false;
               switch(item.type)
               {
                  case MediaPlayerItem.AUDIOBOOK:
                  case MediaPlayerItem.CHAPTER:
                     item.playable = hbItem.playable;
                     break;
                  case MediaPlayerItem.EPISODE:
                  case MediaPlayerItem.FILE:
                  case MediaPlayerItem.SONG:
                     item.playable = true;
                     break;
                  default:
                     item.playable = false;
               }
               if(hbItem.nowPlaying)
               {
                  item.nowPlaying = true;
               }
               list.push(item);
            }
            browseItem = this.mBrowseItemsRequests.shift();
            if(this.browsePath.itemCount <= 0 || list.length == this.browsePath.itemCount)
            {
               this.mBrowseItems = new MediaPlayerItemList(browseItem.offset,list);
            }
            if(this.mTargetBrowsePath == null)
            {
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_ITEMS,new MediaPlayerItemList(browseItem.firstItem,list)));
            }
         }
         this.mBrowseItemsRequestProcessing = false;
         this.mBrowseItemsRequestTimer.reset();
         this.processBrowseItemsRequest();
         if(this.mTargetBrowsePath != null)
         {
            data.path = this.mTargetBrowsePath;
            data.name = null;
            this.setBrowsePath(data,false);
         }
      }
      
      public function processPlayItems(hbItemList:Object) : void
      {
         var list:Vector.<MediaPlayerItem> = null;
         var hbItem:Object = null;
         var request:Object = null;
         var playItems:MediaPlayerItemList = null;
         var item:MediaPlayerItem = null;
         if(hbItemList != null && this.mPlayItemsRequestProcessing)
         {
            list = new Vector.<MediaPlayerItem>();
            for each(hbItem in hbItemList)
            {
               item = new MediaPlayerItem();
               item.id = int(hbItem.id);
               item.type = hbItem.type;
               item.name = hbItem.name;
               list.push(item);
            }
            request = this.mPlayItemsRequests.shift();
            this.mPlayItemsRequestProcessing = false;
            this.mPlayItemsRequestTimer.reset();
            playItems = new MediaPlayerItemList(request.firstItem,list);
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY_ITEMS,playItems));
         }
         this.processPlayItemsRequest();
      }
      
      private function processPlayTime(playTime:Object) : void
      {
         if(playTime == null)
         {
            return;
         }
         this.mLocalPlayTime = uint(playTime.time) * 1000;
         this.mLocalPlayDuration = uint(playTime.duration) * 1000;
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY_TIME,playTime.msid));
      }
      
      private function processPlayState(playState:Object) : void
      {
         var device:MediaPlayerDevice = null;
         if(null == playState)
         {
            return;
         }
         var playStateHandle:int = int(playState.handle);
         if(playStateHandle != 0 && playStateHandle != this.mLocalCurrentDeviceHandle)
         {
            return;
         }
         switch(playState.state)
         {
            case "playing":
               this.mLocalTransportAction = MediaPlayerTransportAction.PLAY;
               for each(device in this.mLocalDevicesAutoplayOff)
               {
                  if(device.id == playState.msid)
                  {
                     device.autoplayOff = 2;
                     break;
                  }
               }
               break;
            case "paused":
               this.mLocalTransportAction = MediaPlayerTransportAction.PAUSE;
               break;
            case "stopped":
               this.mLocalTransportAction = MediaPlayerTransportAction.PAUSE;
               break;
            case "fastforward":
               this.mLocalTransportAction = MediaPlayerTransportAction.FAST_FORWARD;
               break;
            case "fastreverse":
               this.mLocalTransportAction = MediaPlayerTransportAction.FAST_REVERSE;
               break;
            case "slowforward":
            case "slowreverse":
            case "error":
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.TRANSPORT_ACTION));
      }
      
      private function processSyncState(syncState:Object) : void
      {
         var newSyncState:int = MediaPlayerSyncState.NONE;
         if(syncState != null)
         {
            switch(syncState.state)
            {
               case "unsynced":
                  newSyncState = MediaPlayerSyncState.NONE;
                  break;
               case "start":
                  newSyncState = MediaPlayerSyncState.FILE;
                  break;
               case "complete":
                  newSyncState = MediaPlayerSyncState.METADATA;
                  break;
               case "complete_extdb":
                  newSyncState = MediaPlayerSyncState.EXTENDED;
            }
            this.mSyncState[syncState.id] = newSyncState;
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.SYNC_STATE));
         }
      }
      
      private function processMediaError(mediaError:Object) : void
      {
         var deviceType:String = null;
         if(mediaError.msid != this.mAudioManager.getMSIdForSource(this.mAudioManager.source))
         {
            return;
         }
         this.mMediaError = mediaError;
         this.mMediaErrorCode = mediaError.code;
         this.mMediaErrorMSID = mediaError.msid;
         if(this.mMediaErrorCode == MediaErrorCodes.UNEXPECTED_STOP_WITH_ERROR)
         {
            if(this.currentDevice.type != MediaPlayerDevice.PFS)
            {
               return;
            }
            this.initializeLocalTrackInfo();
            this.mPlayNextValidTrackTimer.start();
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.MEDIA_ERROR,mediaError));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function getDevices() : void
      {
         this.hbSimpleCommand("getDevices");
      }
      
      public function deSelectActiveDevice() : void
      {
         this.hbSimpleCommand("deSelectActiveDevice");
         this.initializeAllVariablesAndStates();
      }
      
      public function get devices() : Vector.<MediaPlayerDevice>
      {
         var dev:MediaPlayerDevice = null;
         var devsss:Vector.<MediaPlayerDevice> = new Vector.<MediaPlayerDevice>();
         for each(dev in this.mLocalDevices)
         {
            if(dev != null)
            {
               devsss.push(dev);
            }
         }
         return devsss;
      }
      
      public function get devicesForAutoPlayOff() : Vector.<MediaPlayerDevice>
      {
         var dev:MediaPlayerDevice = null;
         var devsss:Vector.<MediaPlayerDevice> = new Vector.<MediaPlayerDevice>();
         for each(dev in this.mLocalDevicesAutoplayOff)
         {
            if(dev != null)
            {
               devsss.push(dev);
            }
         }
         return devsss;
      }
      
      public function getDevice(deviceId:int = -1) : void
      {
         if(deviceId < 0)
         {
            this.hbGetProperties("activeDevice");
         }
         else
         {
            this.mPendingGetDevice = deviceId;
            this.getDevices();
         }
      }
      
      private function selectCurrentDeviceById(device:int) : void
      {
         var browseType:String = null;
         if(this.mLocalBrowsePath.path.substr(0,MediaPlayerPath.METADATA_ROOT.length) == MediaPlayerPath.METADATA_ROOT)
         {
            browseType = "metadata";
            this.mLocalBrowsePath = new MediaPlayerPath();
            this.mLocalBrowsePath.path = MediaPlayerPath.METADATA_ROOT;
         }
         else
         {
            browseType = "files";
            this.mLocalBrowsePath = new MediaPlayerPath();
            this.mLocalBrowsePath.path = MediaPlayerPath.FILE_ROOT;
         }
      }
      
      public function getCurrentDevice() : void
      {
         this.hbGetProperties("activeDevice");
      }
      
      public function get currentDevice() : MediaPlayerDevice
      {
         return this.mLocalCurrentDevice;
      }
      
      public function setBrowsePath(data:MediaPlayerPath, force:Boolean = true) : void
      {
         var i:int = 0;
         var idm:Object = null;
         var step:String = null;
         var id:int = 0;
         if(this.mLocalCurrentDevice == null || this.mLocalCurrentDevice.type == MediaPlayerDevice.OTHER || data.path == null || data.path == "")
         {
            return;
         }
         data.path = this.cleanPath(data.path);
         this.mTargetBrowsePath = data.path;
         if(this.mBrowseItemsRequestProcessing)
         {
            while(this.mBrowseItemsRequests.length > 1)
            {
               this.mBrowseItemsRequests.pop();
            }
         }
         var newArray:Array = data.path.split("/");
         var currentArray:Array = this.mLocalBrowsePath.path.split("/");
         var nextStepIndex:int = this.findDifferentElement(newArray,currentArray);
         var nextStep:String = newArray[nextStepIndex];
         if(nextStepIndex < currentArray.length && !this.isRelativePath(newArray[0]))
         {
            this.mLocalBrowsePath = new MediaPlayerPath();
            this.mLocalBrowsePath.path = newArray[0];
            this.gotoRoot();
            nextStepIndex = 0;
         }
         else if(nextStepIndex >= newArray.length)
         {
            if(this.mOutstandingBrowseItemsRequests <= 1)
            {
               dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_PATH));
            }
         }
         else
         {
            switch(nextStep)
            {
               case MediaPlayerPath.ALL:
                  this.hbSimpleCommand("selectAll");
                  ++this.mOutstandingBrowsePathRequests;
                  this.mLocalBrowsePath.path += "/*";
                  break;
               case MediaPlayerPath.BACK:
                  this.mTargetBrowsePath = null;
                  return;
               case MediaPlayerPath.FORWARD:
                  this.mTargetBrowsePath = null;
                  return;
               case MediaPlayerPath.UP:
                  this.hbSimpleCommand("gotoPrevious");
                  ++this.mOutstandingBrowsePathRequests;
                  currentArray.pop();
                  this.mLocalBrowsePath = new MediaPlayerPath();
                  this.mLocalBrowsePath.path = "";
                  for each(step in currentArray)
                  {
                     if(this.mLocalBrowsePath.path != "")
                     {
                        this.mLocalBrowsePath.path += "/";
                     }
                     this.mLocalBrowsePath.path += step;
                  }
                  this.mTargetBrowsePath = null;
                  return;
               default:
                  idm = new Object();
                  idm.name = data.type;
                  if(nextStep.charAt(0) == MediaPlayerPath.ITEM)
                  {
                     idm.id = int(nextStep.substr(1));
                     nextStep = MediaPlayerPath.ITEM + idm.id.toString();
                  }
                  else
                  {
                     if(this.mBrowseItems == null)
                     {
                        this.updateBrowseItems();
                        return;
                     }
                     id = this.getItemId(nextStep);
                     if(id <= 0)
                     {
                        this.mTargetBrowsePath = null;
                        return;
                     }
                     idm.id = id;
                  }
                  this.mLocalBrowsePath.path += "/" + nextStep;
                  this.hbSelectItem(idm);
            }
         }
         this.mTargetBrowsePath = "";
         nextStepIndex++;
         while(nextStepIndex < newArray.length)
         {
            this.mTargetBrowsePath += newArray[nextStepIndex] + "/";
            nextStepIndex++;
         }
         if(this.mTargetBrowsePath == "")
         {
            this.mTargetBrowsePath = null;
         }
      }
      
      private function gotoRoot() : void
      {
         this.hbSimpleCommand("gotoRoot");
         ++this.mOutstandingBrowsePathRequests;
      }
      
      private function getItemId(desiredItemName:String) : int
      {
         var item:MediaPlayerItem = null;
         for each(item in this.mBrowseItems.list)
         {
            if(item.name == desiredItemName)
            {
               return item.id;
            }
         }
         return 0;
      }
      
      private function cleanPath(path:String) : String
      {
         path = path.replace(/\/+/g,"/");
         if(path.charAt(path.length - 1) == "/")
         {
            path = path.substr(0,path.length - 1);
         }
         return path;
      }
      
      private function findDifferentElement(newArray:Array, currentArray:Array) : int
      {
         var i:int = 0;
         while(i < newArray.length && newArray[i] == currentArray[i])
         {
            i++;
         }
         return i;
      }
      
      private function isRelativePath(path:String) : Boolean
      {
         if(path.substr(0,MediaPlayerPath.METADATA_ROOT.length) == MediaPlayerPath.METADATA_ROOT || path.substr(0,MediaPlayerPath.FILE_ROOT.length) == MediaPlayerPath.FILE_ROOT)
         {
            return false;
         }
         return true;
      }
      
      public function getBrowsePath() : void
      {
         if(this.mOutstandingBrowsePathRequests <= 0)
         {
            dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_PATH));
         }
      }
      
      public function get browsePath() : MediaPlayerPath
      {
         return this.mLocalBrowsePath;
      }
      
      public function set browsePath(path:MediaPlayerPath) : void
      {
         this.mLocalBrowsePath = path;
      }
      
      private function updateBrowseItems() : void
      {
         this.getBrowseItems();
      }
      
      public function getAlphaJumpTable() : void
      {
         this.mGenerateAlphaTable = true;
         this.getCurrentDevice();
         this.mCharList = new Vector.<MediaPlayerItemList>();
         this.hbGetItemsCharIndexTable();
      }
      
      public function getBrowseItems(firstItem:* = 0, length:int = -1) : void
      {
         if(firstItem is int || firstItem is uint || firstItem is String)
         {
            this.addBrowseItemsRequest(firstItem,length);
         }
      }
      
      private function addBrowseItemsRequest(firstItem:*, length:int) : void
      {
         var request:Object = null;
         var requestExists:Boolean = false;
         for each(request in this.mBrowseItemsRequests)
         {
            if(request.firstItem == firstItem && request.length == length)
            {
               requestExists = true;
            }
         }
         if(!requestExists)
         {
            this.mBrowseItemsRequests.push({
               "firstItem":firstItem,
               "length":length
            });
         }
         this.processBrowseItemsRequest();
      }
      
      private function processBrowseItemsRequest() : void
      {
         var request:Object = null;
         if(!this.mBrowseItemsRequestProcessing && this.mBrowseItemsRequests.length > 0)
         {
            request = this.mBrowseItemsRequests[0];
            if(this.VRData != null && request.length != -1 && this.mSearchText == "")
            {
               this.hbMediaFilterShow(request.firstItem,request.length,false);
               this.mBrowseItemsRequestProcessing = true;
            }
            else if(this.mSearchText != "" && request.length != -1)
            {
               this.hbGetItemsFilterText(this.mSearchText,request.firstItem,request.length);
               this.mBrowseItemsRequestProcessing = true;
            }
            else if(request.firstItem is int || request.firstItem is uint)
            {
               this.mBrowseItemsRequestProcessing = true;
               this.hbGetItems(request.firstItem,request.length);
            }
            else if(request.firstItem is String)
            {
               this.mBrowseItemsRequestProcessing = true;
               this.hbGetItemsChar(request.firstItem,request.length);
            }
            if(this.mBrowseItemsRequestProcessing)
            {
               this.mBrowseItemsRequestTimer.start();
            }
         }
      }
      
      private function timeoutBrowseItems(e:TimerEvent) : void
      {
         this.mBrowseItemsRequestProcessing = false;
         this.mBrowseItemsRequestTimer.reset();
         this.processBrowseItemsRequest();
      }
      
      private function processMatchItems(hbItemList:Object) : void
      {
         var matchFound:Boolean = true;
         if(hbItemList.length < 0)
         {
            matchFound = false;
         }
         else
         {
            matchFound = true;
         }
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.BROWSE_MATCH_ITEMS,matchFound));
      }
      
      public function getPlayPath() : void
      {
      }
      
      public function get playPath() : MediaPlayerPath
      {
         return this.mLocalPlayPath;
      }
      
      public function getPlayItems(firstItem:* = -1, length:int = -1) : void
      {
         if(firstItem is int || firstItem is uint)
         {
            this.mTrackListStart = firstItem;
            this.mTrackListCount = length;
            this.addPlayItemsRequest(firstItem,length);
         }
      }
      
      private function addPlayItemsRequest(firstItem:int, length:int) : void
      {
         var request:Object = null;
         var requestExists:Boolean = false;
         for each(request in this.mPlayItemsRequests)
         {
            if(request.firstItem == firstItem && request.length == length && !this.mTrackListRequestError)
            {
               requestExists = true;
            }
         }
         if(!requestExists)
         {
            this.mPlayItemsRequests.push({
               "firstItem":firstItem,
               "length":length
            });
         }
         this.processPlayItemsRequest();
      }
      
      private function processPlayItemsRequest() : void
      {
         var request:Object = null;
         if(!this.mPlayItemsRequestProcessing && this.mPlayItemsRequests.length > 0)
         {
            request = this.mPlayItemsRequests[0];
            this.hbGetCurrentTrackList(request.firstItem,request.length);
            ++this.mOutstandingPlayItemRequests;
            this.mPlayItemsRequestTimer.start();
            this.mPlayItemsRequestProcessing = true;
            this.mTrackListRequestError = false;
         }
      }
      
      private function timeoutPlayItems(e:TimerEvent) : void
      {
         this.mPlayItemsRequestProcessing = false;
         this.mPlayItemsRequestTimer.reset();
         this.processPlayItemsRequest();
      }
      
      public function getCurrentTrack() : void
      {
         this.hbGetProperties("trackState");
      }
      
      public function get currentTrack() : uint
      {
         return this.mLocalCurrentTrack;
      }
      
      public function get currentTrackMsid() : int
      {
         return this.mLocalCurrentTrackMsid;
      }
      
      public function getCurrentTrackLength() : void
      {
         this.hbGetProperties("playTime");
      }
      
      public function getCurrentTrackInfo() : void
      {
         this.hbGetProperties("nowPlaying");
      }
      
      public function get currentTrackInfo() : MediaPlayerTrackInfo
      {
         return this.mLocalTrackInfo;
      }
      
      public function getMediaProperties() : void
      {
         this.hbGetProperties("activeDevice","trackState","playTime","random","repeat","nowPlaying","playState","syncState","readyToBrowse");
      }
      
      public function getCurrentAlbumArtPath() : void
      {
         this.hbGetAlbumArt();
      }
      
      public function get currentAlbumArtPath() : String
      {
         return this.mLocalCurrentAlbumArtPath;
      }
      
      public function get currentAlbumArtMSID() : int
      {
         return this.mLocalCurrentAlbumArtMSID;
      }
      
      public function get mediaFilterListShowErrorCode() : int
      {
         return this.mMediaFilterListShowErrorCode;
      }
      
      public function setTransportAction(transportAction:String) : void
      {
         switch(transportAction)
         {
            case MediaPlayerTransportAction.FAST_FORWARD:
               this.hbFastForward(this.localSeekSpeed);
               break;
            case MediaPlayerTransportAction.FAST_REVERSE:
               this.hbFastReverse(this.localSeekSpeed);
               break;
            case MediaPlayerTransportAction.PAUSE:
               this.hbSimpleCommand("pause");
               break;
            case MediaPlayerTransportAction.PLAY_SINGLE:
            case MediaPlayerTransportAction.PLAY:
               this.hbSimpleCommand("play");
               break;
            case MediaPlayerTransportAction.PLAY_ALL:
               this.hbSimpleCommand("playAll");
               break;
            case MediaPlayerTransportAction.PREVIOUS:
               this.hbPrevious(1,this.localSkipThreshold / 1000);
               break;
            case MediaPlayerTransportAction.RESUME:
               this.hbSimpleCommand("resume");
               break;
            case MediaPlayerTransportAction.SCAN:
               this.hbScan("on",this.localAuditionPeriod / 1000);
               break;
            case MediaPlayerTransportAction.SKIP_BACKWARD:
               this.hbPrevious(1,65535);
               break;
            case MediaPlayerTransportAction.SKIP_FORWARD:
               this.hbNext(1);
               break;
            case MediaPlayerTransportAction.STOP:
               this.hbSimpleCommand("stop");
         }
      }
      
      public function getTransportAction() : void
      {
         this.hbGetProperties("playState");
      }
      
      public function get transportAction() : String
      {
         return this.mLocalTransportAction;
      }
      
      public function setPlayTime(time:uint) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"seekToTime":{"sec":Math.round(time / 1000)}}
         };
         this.connection.send(message);
      }
      
      public function getPlayTime() : void
      {
         this.hbGetProperties("playTime");
      }
      
      public function get playTime() : uint
      {
         return this.mLocalPlayTime;
      }
      
      public function activeDeviceMsid() : uint
      {
         return this.mLocalCurrentDeviceID;
      }
      
      public function setPlayDuration(time:uint) : void
      {
      }
      
      public function getPlayDuration() : void
      {
         this.hbGetProperties("playTime");
      }
      
      public function get playDuration() : uint
      {
         return this.mLocalPlayDuration;
      }
      
      public function get mediaError() : Object
      {
         return this.mMediaError;
      }
      
      public function mediaErrorCode() : int
      {
         return this.mMediaErrorCode;
      }
      
      public function mediaErrorMSID() : int
      {
         return this.mMediaErrorMSID;
      }
      
      public function activeDeviceMSID() : int
      {
         return this.mLocalCurrentDeviceID;
      }
      
      public function get isTrackSliding() : Boolean
      {
         return this.mTrackSlidingStatus;
      }
      
      public function setTrackSlidingStatus(trackSlidingStatus:Boolean) : void
      {
         this.mTrackSlidingStatus = trackSlidingStatus;
      }
      
      public function setSeekSpeed(seekSpeed:Number) : void
      {
         this.localSeekSpeed = seekSpeed;
         this.getSeekSpeed();
      }
      
      public function getSeekSpeed() : void
      {
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.SEEK_SPEED));
      }
      
      public function get seekSpeed() : Number
      {
         return this.localSeekSpeed;
      }
      
      public function setAuditionPeriod(auditionPeriod:uint) : void
      {
         this.localAuditionPeriod = auditionPeriod;
         this.getAuditionPeriod();
      }
      
      public function getAuditionPeriod() : void
      {
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.AUDITION_PERIOD));
      }
      
      public function get auditionPeriod() : uint
      {
         return this.localAuditionPeriod;
      }
      
      public function setSkipThreshold(skipThreshold:uint) : void
      {
         this.localSkipThreshold = skipThreshold;
         this.getSkipThreshold();
      }
      
      public function getSkipThreshold() : void
      {
         dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.SKIP_THRESHOLD));
      }
      
      public function get skipThreshold() : uint
      {
         return this.localSkipThreshold;
      }
      
      public function setRepeatMode(repeatMode:String) : void
      {
         this.mRepeatRandomSupport = true;
         this.hbSetRepeat(repeatMode);
      }
      
      public function getRepeatMode() : void
      {
         this.hbGetProperties("repeat");
      }
      
      public function get repeatMode() : String
      {
         return this.mLocalRepeatMode;
      }
      
      public function setRandomMode(randomMode:String) : void
      {
         this.mRepeatRandomSupport = true;
         this.hbSetRandom(randomMode);
      }
      
      public function getRandomMode() : void
      {
         this.hbGetProperties("random");
      }
      
      public function get randomMode() : String
      {
         return this.mLocalRandomMode;
      }
      
      public function getSyncState() : void
      {
         this.hbGetProperties("syncState");
      }
      
      public function getPlaylistCount() : void
      {
         this.hbGetPlaylistsCount(this.mLocalCurrentDeviceID);
      }
      
      public function get playlistCount() : uint
      {
         return this.mLocalPlaylistCount;
      }
      
      public function get syncState() : int
      {
         if(this.mLocalCurrentDevice != null)
         {
            return this.mSyncState[this.mLocalCurrentDevice.id];
         }
         return MediaPlayerSyncState.NONE;
      }
      
      public function get readyToBrowse() : Boolean
      {
         if(this.mLocalCurrentDevice != null)
         {
            return this.mReadyToBrowse[this.mLocalCurrentDevice.id];
         }
         return false;
      }
      
      public function get readyToBrowseSrcMsid() : int
      {
         return this.mReadyToBrowseSrcMsid;
      }
      
      public function cancelAlphaJump() : void
      {
         this.hbCancelAlphaJump();
      }
      
      public function goToRoot() : void
      {
         this.gotoRoot();
      }
      
      private function hbGetProperties(... properties) : void
      {
         var property:String = null;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getProperties":{"props":[]}}
         };
         for each(property in properties)
         {
            message.packet.getProperties.props.push(property);
         }
         this.connection.send(message);
      }
      
      private function hbDevicePlayable(deviceId:int, ... properties) : void
      {
         var property:String = null;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getProperties":{"props":[]}}
         };
         for each(property in properties)
         {
            message.packet.getProperties.props.push(property);
            message.packet.getProperties.msid = deviceId;
         }
         this.connection.send(message);
      }
      
      private function hbSetRandom(mode:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"setProperties":{"props":{"random":mode}}}
         };
         this.connection.send(message);
      }
      
      private function hbSetRepeat(mode:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"setProperties":{"props":{"repeat":mode}}}
         };
         this.connection.send(message);
      }
      
      private function hbSimpleCommand(commandName:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{}
         };
         message.packet[commandName] = {"":""};
         this.connection.send(message);
      }
      
      private function hbSelectDevice(deviceId:int, browseType:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"selectDevice":{
               "id":deviceId,
               "browseType":browseType
            }}
         };
         ++this.mOutstandingBrowsePathRequests;
         this.connection.send(message);
      }
      
      private function hbSelectItem(idm:Object) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"selectItem":{"id":idm.id}}
         };
         if(idm.name != null)
         {
            message.packet.selectItem.name = idm.name;
         }
         ++this.mOutstandingBrowsePathRequests;
         this.connection.send(message);
      }
      
      private function hbGetItemsChar(filter:String, count:int = -1) : void
      {
         this.mRequestItemChar = filter;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getItemsChar":{}}
         };
         message.packet.getItemsChar.filter = filter;
         if(count >= 0)
         {
            message.packet.getItemsChar.count = count;
         }
         this.connection.send(message);
      }
      
      private function hbGetItemsCharIndexTable() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getItemsCharIndexTable":{}}
         };
         this.connection.send(message);
      }
      
      private function hbGetItems(start:int = 0, count:int = -1) : void
      {
         start++;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getItems":{}}
         };
         if(count > 0)
         {
            message.packet.getItems.count = count;
         }
         if(start > 0)
         {
            message.packet.getItems.start = start;
         }
         ++this.mOutstandingBrowseItemsRequests;
         this.connection.send(message);
      }
      
      private function hbGetItemsFilterText(searchText:String, start:int = 0, count:int = -1, countFlag:Number = 0) : void
      {
         this.mMediaSearchActive = true;
         this.traceout("PCZZ >>>>hbGetItemsFilterText>>>>>>>  searchText:" + searchText + "  start: " + start + "  count: " + count);
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getItemsFilterText":{}}
         };
         if(count > 0)
         {
            message.packet.getItemsFilterText.count = count;
         }
         if(start > 0)
         {
            message.packet.getItemsFilterText.start = start;
         }
         message.packet.getItemsFilterText.filtertext = searchText;
         message.packet.getItemsFilterText.itemsCountFlag = countFlag;
         if(countFlag != 1)
         {
            ++this.mOutstandingBrowseItemsRequests;
         }
         this.connection.send(message);
      }
      
      private function hbCancelFilterTextRequest() : void
      {
         this.mMediaSearchActive = false;
         this.mOutstandingBrowseItemsRequests = 0;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"cancelFilterTextRequest":{}}
         };
         this.connection.send(message);
      }
      
      private function hbGetCurrentTrackList(start:int = 0, count:int = 0) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getCurrentTrackList":{}}
         };
         if(start > 0)
         {
            message.packet.getCurrentTrackList.start = start + 1;
         }
         if(count > 0)
         {
            message.packet.getCurrentTrackList.count = count;
         }
         if(count > 0 && start >= 0)
         {
            this.connection.send(message);
         }
         else
         {
            message = null;
         }
      }
      
      private function hbGetPlaylistsCount(id:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getPlaylistsCount":{"id":id}}
         };
         this.connection.send(message);
      }
      
      private function hbMediaFilterShow(start:int, count:int, countFlag:Boolean) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":"Media",
            "packet":{"mediaFilterListShow":{
               "mediaType":this.mVRMediaType,
               "artistFilterID":this.mVrArtistFilterId,
               "albumFilterID":this.mVrAlbumFilterId,
               "genreFilterID":this.mVrGenreFilterId,
               "titleFilterID":-1,
               "playlistFilterID":this.mVrPlaylistFilterId,
               "audiobookFilterID":-1,
               "podcastFilterID":this.mVrPodcastFilterId,
               "start":start,
               "count":count,
               "itemsCountFlag":countFlag
            }}
         };
         this.connection.send(message);
      }
      
      private function hbCancelAlphaJump() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"cancelAlphaJumpRequest":{}}
         };
         this.connection.send(message);
      }
      
      public function mediaFilterListShow(mediaType:String, artistFilterID:Number, albumFilterID:Number, genreFilterID:Number, titleFilterID:Number, playListFilterID:Number, audiobookFilterID:Number, podcastFilterID:Number) : void
      {
         this.mLocalBrowsePath.path = "";
         this.SetmBrowseItemsRequestProcessing(false);
         this.mVRMediaType = mediaType;
         this.mVrPlaylistFilterId = playListFilterID;
         this.mVrGenreFilterId = genreFilterID;
         this.mVrArtistFilterId = artistFilterID;
         this.mVrAlbumFilterId = albumFilterID;
         this.mVrPodcastFilterId = podcastFilterID;
         this.hbMediaFilterShow(-1,-1,true);
      }
      
      public function getItemsFilterText(countFlag:Number = 0, start:int = 0, count:int = -1) : void
      {
         this.hbGetItemsFilterText(this.SearchText,start,count,countFlag);
      }
      
      public function get vrArtistFilterId() : int
      {
         return this.mVrArtistFilterId;
      }
      
      public function get vrAlbumFilterId() : int
      {
         return this.mVrAlbumFilterId;
      }
      
      public function get vrGenreFilterId() : int
      {
         return this.mVrGenreFilterId;
      }
      
      public function get vrPlaylistFilterId() : int
      {
         return this.mVrPlaylistFilterId;
      }
      
      public function get vrPodcastFilterId() : int
      {
         return this.mVrPodcastFilterId;
      }
      
      public function get vrMediaType() : String
      {
         return this.mVRMediaType;
      }
      
      public function setvrIdValues(id:int) : void
      {
         this.mVrPlaylistFilterId = id;
         this.mVrGenreFilterId = id;
         this.mVrAlbumFilterId = id;
         this.mVrArtistFilterId = id;
         this.mVrPodcastFilterId = id;
      }
      
      private function hbNext(step:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"next":{"step":step}}
         };
         this.connection.send(message);
      }
      
      private function hbPrevious(step:int, threshold:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"previous":{
               "threshold":threshold,
               "step":step
            }}
         };
         this.connection.send(message);
      }
      
      private function hbScan(mode:String, interval:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"scan":{
               "mode":mode,
               "interval":interval
            }}
         };
         this.connection.send(message);
      }
      
      private function hbFastForward(speed:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"fastForward":{"speed":speed}}
         };
         this.connection.send(message);
      }
      
      private function hbFastReverse(speed:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"fastReverse":{"speed":speed}}
         };
         this.connection.send(message);
      }
      
      private function hbGetAlbumArt() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"getAlbumArt":{"path":ALBUM_ART_PATH}}
         };
         this.connection.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:Object = {
            "Type":"Subscribe",
            "Dest":DBUS_DESTINATION,
            "Signal":signalName
         };
         this.connection.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:Object = {
            "Type":"Unsubscribe",
            "Dest":DBUS_DESTINATION,
            "Signal":signalName
         };
         this.connection.send(message);
      }
      
      public function get VRData() : Object
      {
         return this._VRData;
      }
      
      public function set VRData(Value:Object) : void
      {
         this._VRData = Value;
      }
      
      public function SetmBrowseItemsRequestProcessing(value:Boolean) : void
      {
         this.mBrowseItemsRequestProcessing = value;
         if(!value)
         {
            this.mBrowseItemsRequests = new Array();
         }
      }
      
      public function set SearchText(value:String) : void
      {
         this.mSearchText = value;
      }
      
      public function get SearchText() : String
      {
         return this.mSearchText;
      }
      
      public function cancelSearch() : void
      {
         this.hbCancelFilterTextRequest();
      }
      
      private function traceout(Message:String) : void
      {
         if(this.DEBUG)
         {
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"Media\"}";
         this.client.send(message);
      }
      
      private function timeoutErrorTrack(e:TimerEvent) : void
      {
         this.mPlayNextValidTrackTimer.stop();
         this.hbPlayNextValidTrack();
      }
      
      private function hbPlayNextValidTrack() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DESTINATION,
            "packet":{"playNextValidTrack":{}}
         };
         this.connection.send(message);
      }
      
      public function get RandomDeviceSupport() : Boolean
      {
         return this.mRandomDeviceSupport;
      }
      
      public function get RepeatDeviceSupport() : Boolean
      {
         return this.mRepeatDeviceSupport;
      }
      
      public function setBrowselistLevel(mDataList:Vector.<MediaPlayerPath>) : void
      {
         if(mDataList != null)
         {
            this.mFolderLevelList = mDataList;
         }
         else
         {
            this.traceout("setBrowselistLevel null received");
         }
      }
      
      public function get BrowselistLevelData() : Vector.<MediaPlayerPath>
      {
         return this.mFolderLevelList;
      }
   }
}

