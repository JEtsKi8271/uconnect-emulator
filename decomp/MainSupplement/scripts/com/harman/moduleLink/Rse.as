package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IRse;
   import com.harman.moduleLinkAPI.RSEConstants;
   import com.harman.moduleLinkAPI.RseEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.MediaPlayerItem;
   import com.nfuzion.moduleLinkAPI.MediaPlayerItemList;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Rse extends Module implements IRse
   {
      
      private static var instance:Rse;
      
      private static const mDbusIdentifier:String = "Rse";
      
      private var m_Ready:Boolean = false;
      
      private var m_externalSourcePresentStatus:String = "";
      
      private var m_dvdOutStatValue:String;
      
      private var m_shuffleValue:String;
      
      private var m_discErrorValue:String;
      
      private var m_repeatValue:String;
      
      private var m_currentTrackName:String = "";
      
      private var m_currentTrackNumber:String = "";
      
      private var m_videoLockoutStatus:Boolean;
      
      private var localPlayTime:uint = 0;
      
      private var localPlayDuration:uint = 0;
      
      private var localCurrentTrackLength:uint;
      
      private var m_no_of_records:int = 0;
      
      private var requested_offset:uint = 0;
      
      private var mBrowseItemsRequests:Array = new Array();
      
      private var browseItems:MediaPlayerItemList = null;
      
      private var m_dvdDiscStatValue:String = "mechNP";
      
      private var m_startDiscPlayStatus:Boolean = false;
      
      private var m_fullScreenButtonPresent:Boolean = false;
      
      private var m_currentArtist:String = "";
      
      private var m_currentAlbum:String = "";
      
      private var mTrackInfoFlag:Boolean = false;
      
      private var mCurrentTrkInfo:Object;
      
      private var m_listSyncStatus:Boolean = false;
      
      private var m_audioSource:String = "";
      
      private var m_branchOnFullScreenExit:Boolean = false;
      
      private var mLocalBrowsePath:Object = new Object();
      
      private var m_rdc2VideoStatus:String = "";
      
      private var m_rearVideoStatus:Boolean = true;
      
      private var m_frontSideCameraAvailable:Boolean = false;
      
      private var m_vrmAvailable:Boolean = false;
      
      private var m_accessibilitySupportStatus:Boolean = false;
      
      private var m_rdc2Mode:String = "";
      
      private var m_prevRdc2Mode:String = "";
      
      private var m_requestICSTuning:String = "";
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function Rse()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.RSE,this.MessageHandler);
      }
      
      public static function getInstance() : Rse
      {
         if(instance == null)
         {
            instance = new Rse();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.sendMultiSubscribe(["startDiscPlay","externalSourceStatus","dvdOutStatValue","dvdDiscStatValue","discErrorValue","shuffleValue","repeatValue","playTimeValue","currentTrackInfo","noOfRecords","VideoLockoutEnable","fullScreenButton","cdSyncComplete","rseTrackState","exitFullScreen","startingRdc2Video","rearVideoStatus","rdc2ModeStarted","accessibilitySupport"]);
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function setBrowsePath(data:Object) : void
      {
         this.sendSelectItemRequest(data);
      }
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var Rse:Object = e.data;
         if(Rse.hasOwnProperty("dBusServiceAvailable"))
         {
            if(Rse.dBusServiceAvailable == "true")
            {
               this.dispatchEvent(new RseEvent(RseEvent.RSE_STATUS));
            }
         }
         if(Rse.hasOwnProperty("externalSourceStatus"))
         {
            this.m_externalSourcePresentStatus = Rse.externalSourceStatus.cd;
            this.m_frontSideCameraAvailable = Rse.externalSourceStatus.cam == "true";
            this.m_vrmAvailable = Rse.externalSourceStatus.vrm == "true";
            this.dispatchEvent(new RseEvent(RseEvent.VRM_AVAILABILITY));
            if(this.m_frontSideCameraAvailable)
            {
               this.dispatchEvent(new RseEvent(RseEvent.CAM_AVAILABILITY));
            }
         }
         if(Rse.hasOwnProperty("accessibilitySupport"))
         {
            this.m_accessibilitySupportStatus = Rse.accessibilitySupport.status;
         }
         if(Rse.hasOwnProperty("startDiscPlay"))
         {
            this.m_startDiscPlayStatus = Rse.startDiscPlay.startDiscPlay;
            this.mLocalBrowsePath = new Object();
            this.mLocalBrowsePath.path = "";
            if(this.m_startDiscPlayStatus == true)
            {
               this.dispatchEvent(new RseEvent(RseEvent.START_DISC_PLAY_STATUS));
            }
         }
         if(Rse.hasOwnProperty("cdSyncComplete"))
         {
            this.m_listSyncStatus = Rse.cdSyncComplete.cdSyncComplete;
            this.dispatchEvent(new RseEvent(RseEvent.ACTIVATE_BROWSE_BUTTON));
         }
         if(Rse.hasOwnProperty("rseTrackState"))
         {
            this.m_currentTrackNumber = Rse.rseTrackState.currentTrack;
            this.m_no_of_records = Rse.rseTrackState.totalCount;
            this.dispatchEvent(new RseEvent(RseEvent.RSE_CURRENT_TRACK));
         }
         if(Rse.hasOwnProperty("exitFullScreen"))
         {
            this.m_branchOnFullScreenExit = Rse.exitFullScreen.exitFullScreen;
            if(this.m_branchOnFullScreenExit)
            {
               this.dispatchEvent(new RseEvent(RseEvent.BRANCH_ON_EXIT_FULL_SCREEN));
            }
         }
         if(Rse.hasOwnProperty("startingRdc2Video"))
         {
            this.m_rdc2VideoStatus = Rse.startingRdc2Video.status;
            this.dispatchEvent(new RseEvent(RseEvent.RDC2_VIDEO_STATUS));
         }
         if(Rse.hasOwnProperty("selectItem"))
         {
            this.mLocalBrowsePath.path = Rse.selectItem.path;
            this.mLocalBrowsePath.count = Rse.selectItem.count;
            this.dispatchEvent(new RseEvent(RseEvent.BROWSE_PATH));
         }
         if(Rse.hasOwnProperty("rearVideoStatus"))
         {
            this.m_rearVideoStatus = Rse.rearVideoStatus.rearVideoStatus;
            this.dispatchEvent(new RseEvent(RseEvent.REAR_VIDEO_STATUS));
         }
         if(Rse.hasOwnProperty("rdc2ModeStarted"))
         {
            this.m_prevRdc2Mode = this.m_rdc2Mode;
            this.m_rdc2Mode = Rse.rdc2ModeStarted.rdc2Mode;
            this.dispatchEvent(new RseEvent(RseEvent.RDC2_MODE_STARTED));
         }
         if(Rse.hasOwnProperty("requestICSTuning"))
         {
            this.m_requestICSTuning = Rse.requestICSTuning.requestICSTuning;
            this.dispatchEvent(new RseEvent(RseEvent.REQUEST_ICS_TUNING));
         }
         if(Rse.hasOwnProperty("getProperties"))
         {
            if(Rse.getProperties.hasOwnProperty("dvdOutStatValue"))
            {
               this.m_dvdOutStatValue = Rse.getProperties.dvdOutStatValue;
               this.dispatchEvent(new RseEvent(RseEvent.DVD_OUT_STAT));
            }
            if(Rse.getProperties.hasOwnProperty("dvdDiscStatValue"))
            {
               this.m_dvdDiscStatValue = Rse.getProperties.dvdDiscStatValue;
               this.dispatchEvent(new RseEvent(RseEvent.DVD_DISC_STAT));
            }
            if(Rse.getProperties.hasOwnProperty("startDiscPlay"))
            {
               this.m_startDiscPlayStatus = Rse.getProperties.startDiscPlay;
               if(this.m_startDiscPlayStatus == true)
               {
                  this.dispatchEvent(new RseEvent(RseEvent.START_DISC_PLAY_STATUS));
                  this.getTotalAndCurrentTrackInfo();
               }
            }
            if(Rse.getProperties.hasOwnProperty("totalNumRecords"))
            {
               this.m_no_of_records = Rse.getProperties.totalNumRecords;
            }
            if(Rse.getProperties.hasOwnProperty("currentTrackNumber"))
            {
               this.m_currentTrackNumber = Rse.getProperties.currentTrackNumber;
               this.dispatchEvent(new RseEvent(RseEvent.RSE_CURRENT_TRACK));
            }
            if(Rse.getProperties.hasOwnProperty("currentTrkInfo"))
            {
               this.mCurrentTrkInfo = Rse.getProperties.currentTrkInfo;
               this.m_currentTrackName = this.mCurrentTrkInfo.currentTrackName;
               this.m_currentArtist = this.mCurrentTrkInfo.currentArtist;
               this.m_currentAlbum = this.mCurrentTrkInfo.currentAlbum;
               this.dispatchEvent(new RseEvent(RseEvent.CURRENT_TRACK_INFO));
            }
            if(Rse.getProperties.hasOwnProperty("repeatStatus"))
            {
               this.m_repeatValue = Rse.getProperties.repeatStatus;
               this.dispatchEvent(new RseEvent(RseEvent.REPEAT_STATUS));
            }
            if(Rse.getProperties.hasOwnProperty("shuffleStatus"))
            {
               this.m_shuffleValue = Rse.getProperties.shuffleStatus;
               this.dispatchEvent(new RseEvent(RseEvent.SHUFFLE_STATUS));
            }
            if(Rse.getProperties.hasOwnProperty("cdSyncComplete"))
            {
               this.m_listSyncStatus = Rse.getProperties.cdSyncComplete;
               this.dispatchEvent(new RseEvent(RseEvent.ACTIVATE_BROWSE_BUTTON));
            }
         }
         else if(Rse.hasOwnProperty("getAccessibilitySupport"))
         {
            this.m_accessibilitySupportStatus = Rse.getAccessibilitySupport.status;
         }
         else if(Rse.hasOwnProperty("dvdDiscStatValue"))
         {
            this.m_dvdDiscStatValue = Rse.dvdDiscStatValue.dvdDiscStatValue;
            if(this.m_dvdDiscStatValue == "13")
            {
               this.localPlayDuration = 0;
               this.localPlayTime = 0;
               this.localCurrentTrackLength = 0;
               this.mTrackInfoFlag = false;
            }
            this.dispatchEvent(new RseEvent(RseEvent.DVD_DISC_STAT));
         }
         else if(Rse.hasOwnProperty("dvdOutStatValue"))
         {
            this.m_dvdOutStatValue = Rse.dvdOutStatValue.dvdOutStatValue;
            if(this.m_dvdOutStatValue == "4")
            {
               this.m_startDiscPlayStatus = false;
               this.m_fullScreenButtonPresent = false;
            }
            this.dispatchEvent(new RseEvent(RseEvent.DVD_OUT_STAT));
         }
         else if(Rse.hasOwnProperty("discErrorValue"))
         {
            this.m_discErrorValue = Rse.discErrorValue.discErrorValue;
            this.dispatchEvent(new RseEvent(RseEvent.DISC_ERROR_VALUE));
         }
         else if(Rse.hasOwnProperty("shuffleValue"))
         {
            this.m_shuffleValue = Rse.shuffleValue.shuffleValue;
            this.dispatchEvent(new RseEvent(RseEvent.SHUFFLE_STATUS));
         }
         else if(Rse.hasOwnProperty("repeatValue"))
         {
            this.m_repeatValue = Rse.repeatValue.repeatValue;
            this.dispatchEvent(new RseEvent(RseEvent.REPEAT_STATUS));
         }
         else if(Rse.hasOwnProperty("playTimeValue"))
         {
            if(Rse.playTimeValue == null)
            {
               return;
            }
            this.localPlayTime = uint(Rse.playTimeValue.timevalue) * 1000;
            this.localPlayDuration = uint(Rse.playTimeValue.playDurationValue) * 1000;
            this.dispatchEvent(new RseEvent(RseEvent.PLAY_TIME));
            this.localCurrentTrackLength = uint(Rse.playTimeValue.playDurationValue) * 1000;
            dispatchEvent(new RseEvent(RseEvent.CURRENT_TRACK_LENGTH));
         }
         else if(Rse.hasOwnProperty("currentTrackInfo"))
         {
            this.m_currentTrackName = Rse.currentTrackInfo.currentTrackName;
            this.m_currentArtist = Rse.currentTrackInfo.currentArtist;
            this.m_currentAlbum = Rse.currentTrackInfo.currentAlbum;
            this.dispatchEvent(new RseEvent(RseEvent.CURRENT_TRACK_INFO));
         }
         else if(!Rse.hasOwnProperty("noOfRecords"))
         {
            if(Rse.hasOwnProperty("getItems"))
            {
               if(Rse.getItems.hasOwnProperty("items"))
               {
                  this.processBrowseItems(Rse.getItems.items);
               }
            }
            else if(Rse.hasOwnProperty("VideoLockoutEnable"))
            {
               if(Rse.VideoLockoutEnable.status == "true")
               {
                  this.m_videoLockoutStatus = true;
               }
               else
               {
                  this.m_videoLockoutStatus = false;
               }
               this.dispatchEvent(new RseEvent(RseEvent.VIDEO_LOCKOUT_STATUS));
            }
            else if(Rse.hasOwnProperty("fullScreenButton"))
            {
               this.m_fullScreenButtonPresent = Rse.fullScreenButton.fullScreenButton;
               this.m_audioSource = Rse.fullScreenButton.source;
               this.dispatchEvent(new RseEvent(RseEvent.FULL_SCREEN_BUTTON_STATUS));
            }
            else if(Rse.hasOwnProperty("getFullScreenButtonStat"))
            {
               this.m_fullScreenButtonPresent = Rse.getFullScreenButtonStat.fullScreenButton;
               this.m_audioSource = Rse.getFullScreenButtonStat.source;
               this.dispatchEvent(new RseEvent(RseEvent.FULL_SCREEN_BUTTON_STATUS));
            }
         }
      }
      
      public function processBrowseItems(ItemList:Object) : void
      {
         var hbItem:Object = null;
         var item:MediaPlayerItem = null;
         var list:Vector.<MediaPlayerItem> = new Vector.<MediaPlayerItem>();
         for each(hbItem in ItemList)
         {
            item = new MediaPlayerItem();
            item.id = int(hbItem.id);
            item.type = hbItem.type;
            if(hbItem.name == null)
            {
               item.name = "Track " + item.id;
            }
            else
            {
               item.name = hbItem.name;
            }
            list.push(item);
         }
         this.browseItems = new MediaPlayerItemList(this.requested_offset,list);
         dispatchEvent(new RseEvent(RseEvent.BROWSE_ITEMS));
      }
      
      public function get browseListData() : Object
      {
         return this.browseItems;
      }
      
      public function get externalSourceStatus() : String
      {
         return this.m_externalSourcePresentStatus;
      }
      
      public function get dvdoutstatstatus() : String
      {
         return this.m_dvdOutStatValue;
      }
      
      public function get shufflestatus() : String
      {
         return this.m_shuffleValue;
      }
      
      public function get repeatstatus() : String
      {
         return this.m_repeatValue;
      }
      
      public function get rseplaytime() : uint
      {
         return this.localPlayTime;
      }
      
      public function get rseplayduration() : uint
      {
         return this.localPlayDuration;
      }
      
      public function get rsecurrentTrackLength() : uint
      {
         return this.localCurrentTrackLength;
      }
      
      public function get rseCurrentTrackName() : String
      {
         return this.m_currentTrackName;
      }
      
      public function get rseCurrentTrackNumber() : String
      {
         return this.m_currentTrackNumber;
      }
      
      public function get discErrorValue() : String
      {
         return this.m_discErrorValue;
      }
      
      public function get no_of_records() : int
      {
         return this.m_no_of_records;
      }
      
      public function get getVideoLockoutStatus() : Boolean
      {
         return this.m_videoLockoutStatus;
      }
      
      public function get dvdDiscStatValue() : String
      {
         return this.m_dvdDiscStatValue;
      }
      
      public function get startDiscPlayStatus() : Boolean
      {
         return this.m_startDiscPlayStatus;
      }
      
      public function get fullScreenButtonPresent() : Boolean
      {
         return this.m_fullScreenButtonPresent;
      }
      
      public function get rearSource() : String
      {
         return this.m_audioSource;
      }
      
      public function get rdc2VideoStatus() : String
      {
         return this.m_rdc2VideoStatus;
      }
      
      public function get rearVideoStatus() : Boolean
      {
         return this.m_rearVideoStatus;
      }
      
      public function get frontSideCameraAvailable() : Boolean
      {
         return this.m_frontSideCameraAvailable;
      }
      
      public function get vrmAvailable() : Boolean
      {
         return this.m_vrmAvailable;
      }
      
      public function get accessibilityAvailable() : Boolean
      {
         return this.m_accessibilitySupportStatus;
      }
      
      public function get isShuffleRepeatAvailable() : Boolean
      {
         return this.dvdDiscStatValue == RSEConstants.DVD_MD_CD_AUDIO || this.dvdDiscStatValue == RSEConstants.DVD_MD_MP3 || this.dvdDiscStatValue == RSEConstants.DVD_MD_WMA;
      }
      
      public function get listSyncStatus() : Boolean
      {
         return this.m_listSyncStatus;
      }
      
      public function get rseCurrentArtist() : String
      {
         return this.m_currentArtist;
      }
      
      public function get rseCurrentAlbum() : String
      {
         return this.m_currentAlbum;
      }
      
      public function get browsePath() : Object
      {
         return this.mLocalBrowsePath;
      }
      
      public function setstartDiscPlayStatus(value:Boolean) : void
      {
         this.m_startDiscPlayStatus = value;
      }
      
      public function resetDiscCurrentTrackName() : void
      {
         this.m_currentTrackName = "";
      }
      
      public function get rdc2Mode() : String
      {
         return this.m_rdc2Mode;
      }
      
      public function get prevRdc2Mode() : String
      {
         return this.m_prevRdc2Mode;
      }
      
      public function get vrmRequestICSTuning() : String
      {
         return this.m_requestICSTuning;
      }
      
      public function getAccessibilitySupportStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getAccessibilitySupport\":{}}}");
      }
      
      public function getdvdDiscStatValue() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "dvdDiscStatValue" + "\"] }}}");
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "dvdOutStatValue" + "\"] }}}");
      }
      
      public function getstartDiscPlayValue() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "startDiscPlay" + "\"] }}}");
      }
      
      public function getCurrentTrackInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "currentTrkInfo" + "\"] }}}");
      }
      
      private function getTotalAndCurrentTrackInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "totalNumRecords" + "\"] }}}");
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "currentTrackNumber" + "\"] }}}");
      }
      
      public function getRepeatShuffleStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "repeatStatus" + "\"] }}}");
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "shuffleStatus" + "\"] }}}");
      }
      
      public function getFullScreenButtonStat(source:String) : void
      {
         this.sendCommand("getFullScreenButtonStat","source",source);
      }
      
      public function setdvdoutstat(state:String) : void
      {
         this.sendCommand("setPlayPause","state",state);
      }
      
      public function getListSyncStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\": [ \"" + "cdSyncComplete" + "\"] }}}");
      }
      
      public function nextTrack(count:uint) : void
      {
         this.sendCommand("nextTrack","count",String(count));
      }
      
      public function previousTrack(count:uint) : void
      {
         this.sendCommand("previousTrack","count",String(count));
      }
      
      public function seeknext() : void
      {
         this.sendCommand("seeknext","","");
      }
      
      public function seekback() : void
      {
         this.sendCommand("seekback","","");
      }
      
      public function buttonRelease() : void
      {
         this.sendCommand("buttonRelease","","");
      }
      
      public function fastforward() : void
      {
         this.sendCommand("fastforward","","");
      }
      
      public function fastrewind() : void
      {
         this.sendCommand("fastrewind","","");
      }
      
      public function setShuffleState(state:String) : void
      {
         this.sendCommand("setShuffleState","state",state);
      }
      
      public function setRepeatState(state:String) : void
      {
         this.sendCommand("setRepeatState","state",state);
      }
      
      public function discstop() : void
      {
         this.sendCommand("discstop","","");
      }
      
      public function startRdc2Video(type:String) : void
      {
         this.sendCommand("startRdc2Video","type",type);
      }
      
      public function switchToVrmParentalControls() : void
      {
         this.sendCommand("switchToVrmParentalControls","","");
      }
      
      public function requestExitFullScreen(type:String) : void
      {
         this.sendCommand("requestExitFullScreen","type",type);
      }
      
      public function playItem(trackIdNum:int) : void
      {
         var trackId:String = null;
         trackId = String(trackIdNum);
         this.sendCommand("playTrack","trackId",trackId);
      }
      
      public function muteExternalModule(state:String) : void
      {
         this.sendCommand("muteExternalModule","state",state);
      }
      
      private function sendSelectItemRequest(obj:Object) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"selectItem":{
               "path":obj.path,
               "type":obj.type
            }}
         };
         this.connection.send(message);
      }
      
      public function reportStatus() : void
      {
         if(this.m_no_of_records > 0)
         {
         }
      }
      
      public function getBrowseItems(firstIndex:int = 0, lastIndex:int = -1) : void
      {
         firstIndex++;
         lastIndex++;
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getItems":{}}
         };
         if(lastIndex > 0)
         {
            message.packet.getItems.lastIndex = lastIndex;
         }
         if(firstIndex > 0)
         {
            message.packet.getItems.firstIndex = firstIndex;
            this.requested_offset = firstIndex - 1;
         }
         this.connection.send(message);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"Rse\"}";
         this.client.send(message);
      }
   }
}

