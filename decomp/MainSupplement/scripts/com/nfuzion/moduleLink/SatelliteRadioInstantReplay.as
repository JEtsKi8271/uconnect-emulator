package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ISatelliteRadioInstantReplay;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioInstantReplayBufferEntry;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioInstantReplayBufferInfo;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioInstantReplayEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioInstantReplayPlayStatus;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class SatelliteRadioInstantReplay extends Module implements ISatelliteRadioInstantReplay
   {
      
      private static var instance:SatelliteRadioInstantReplay;
      
      private static const dbusIdentifier:String = "XMInstantReplay";
      
      private var mIRBufferInfo:SatelliteRadioInstantReplayBufferInfo = new SatelliteRadioInstantReplayBufferInfo();
      
      private var mIRPlayStatus:SatelliteRadioInstantReplayPlayStatus = new SatelliteRadioInstantReplayPlayStatus();
      
      private var mCurrentOffset:int = 0;
      
      private var mIRBufferEntryList:Vector.<SatelliteRadioInstantReplayBufferEntry> = new Vector.<SatelliteRadioInstantReplayBufferEntry>();
      
      private var mNumPlaylistItems:int = 0;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function SatelliteRadioInstantReplay()
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
         this.connection.addEventListener(ConnectionEvent.SATELLITE_RADIO_INSTANT_REPLAY,this.messageHandler);
         this.sendMultiSubscribeToId(["getProperties","replayBufferStatus","currentOffset","numPlaylistItems","replayPlayStatus","bufferWarning","bufferFull","playlist"]);
         this.sendGetAllProperties();
         this.mIRPlayStatus.isLive = true;
      }
      
      public static function getInstance() : SatelliteRadioInstantReplay
      {
         if(instance == null)
         {
            instance = new SatelliteRadioInstantReplay();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("replayBufferStatus");
            this.sendSubscribe("replayPlayStatus");
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function sendMultiSubscribeToId(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
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
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case SatelliteRadioInstantReplayEvent.CURRENT_OFFSET:
               this.sendSubscribe("currentOffset");
               break;
            case SatelliteRadioInstantReplayEvent.PLAYLIST_ITEM_COUNT:
               this.sendSubscribe("numPlaylistItems");
               break;
            case SatelliteRadioInstantReplayEvent.PAUSE_PLAY_MODE:
               break;
            case SatelliteRadioInstantReplayEvent.PLAYLIST:
               this.sendSubscribe("playlist");
               break;
            case SatelliteRadioInstantReplayEvent.BUFFER_WARNING:
               this.sendSubscribe("bufferWarning");
               break;
            case SatelliteRadioInstantReplayEvent.BUFFER_FULL:
               this.sendSubscribe("bufferFull");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case SatelliteRadioInstantReplayEvent.CURRENT_OFFSET:
               this.sendUnsubscribe("currentOffset");
               break;
            case SatelliteRadioInstantReplayEvent.PLAYLIST_ITEM_COUNT:
               this.sendUnsubscribe("numPlaylistItems");
               break;
            case SatelliteRadioInstantReplayEvent.PAUSE_PLAY_MODE:
               break;
            case SatelliteRadioInstantReplayEvent.PLAYLIST:
               this.sendUnsubscribe("playlist");
               break;
            case SatelliteRadioInstantReplayEvent.BUFFER_WARNING:
               this.sendUnsubscribe("bufferWarning");
               break;
            case SatelliteRadioInstantReplayEvent.BUFFER_FULL:
               this.sendUnsubscribe("bufferFull");
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function init() : void
      {
      }
      
      public function FFPress() : void
      {
         this.sendCommand("fastForwardPress",null,null);
      }
      
      public function FFRelease() : void
      {
         this.sendCommand("fastForwardRelease",null,null);
      }
      
      public function RWPress() : void
      {
         this.sendCommand("rewindPress",null,null);
      }
      
      public function RWRelease() : void
      {
         this.sendCommand("rewindRelease",null,null);
      }
      
      public function pausePlayPress() : void
      {
         this.sendCommand("pausePlayPress",null,null);
      }
      
      public function pausePlayRelease() : void
      {
         this.sendCommand("pausePlayRelease",null,null);
      }
      
      public function seekPrevious() : void
      {
         this.sendCommand("seekPrevious",null,null);
      }
      
      public function seekForward() : void
      {
         this.sendCommand("seekForward",null,null);
      }
      
      public function live() : void
      {
         this.sendCommand("live",null,null);
      }
      
      public function seekToPosition(usePercent:Boolean, percent:int = 0, offset:String = "00:00:00") : void
      {
         if(usePercent == true)
         {
            this.sendCommand("seekToPosition","percent",percent);
         }
         else
         {
            this.sendCommand("seekToPosition","time",offset);
         }
      }
      
      public function reqPlayList(startOffset:int, numEntries:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestPlaylist\": {\"startOffset\": " + startOffset + ", \"numEntries\":" + numEntries + "} } }";
         this.client.send(message);
      }
      
      public function playFromPlayList(offset:int) : void
      {
         this.sendCommand("playFromPlaylist","offset",offset);
      }
      
      public function scanPressed() : void
      {
         this.sendCommand("scanPressed",null,null);
      }
      
      public function setIRMode(mode:String) : void
      {
         this.sendCommand("setIRMode","mode",mode);
      }
      
      public function get IRBufferInfo() : SatelliteRadioInstantReplayBufferInfo
      {
         return this.mIRBufferInfo;
      }
      
      public function get IRPlayStatus() : SatelliteRadioInstantReplayPlayStatus
      {
         return this.mIRPlayStatus;
      }
      
      public function get IRBufferEntryList() : Vector.<SatelliteRadioInstantReplayBufferEntry>
      {
         return this.mIRBufferEntryList;
      }
      
      public function get currentOffset() : int
      {
         return this.mCurrentOffset;
      }
      
      public function get numPlaylistItems() : int
      {
         return this.mNumPlaylistItems;
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendGetAllProperties() : void
      {
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var IR:Object = e.data;
         if(IR.hasOwnProperty("replayBufferStatus"))
         {
            this.mIRBufferInfo.fillPercent = IR.replayBufferStatus.fillPct;
            this.mIRBufferInfo.playbackPercent = IR.replayBufferStatus.playbackPct;
            this.mIRBufferInfo.hours = IR.replayBufferStatus.hours;
            this.mIRBufferInfo.minutes = IR.replayBufferStatus.minutes;
            this.mIRBufferInfo.seconds = IR.replayBufferStatus.seconds;
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.BUFFER_INFO,this.mIRBufferInfo));
         }
         else if(IR.hasOwnProperty("replayPlayStatus"))
         {
            if(IR.replayPlayStatus.hasOwnProperty("pauseStatus"))
            {
               this.mIRPlayStatus.pauseStatus = IR.replayPlayStatus.pauseStatus;
            }
            if(IR.replayPlayStatus.hasOwnProperty("fastForwardActive"))
            {
               this.mIRPlayStatus.FFActive = IR.replayPlayStatus.fastForwardActive;
            }
            if(IR.replayPlayStatus.hasOwnProperty("rewindActive"))
            {
               this.mIRPlayStatus.RWActive = IR.replayPlayStatus.rewindActive;
            }
            if(IR.replayPlayStatus.hasOwnProperty("scanActive"))
            {
               this.mIRPlayStatus.scanActive = IR.replayPlayStatus.scanActive;
            }
            if(IR.replayPlayStatus.hasOwnProperty("isLive"))
            {
               this.mIRPlayStatus.isLive = IR.replayPlayStatus.isLive;
            }
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.PLAY_STATUS,this.mIRPlayStatus));
         }
         else if(IR.hasOwnProperty("numPlaylistItems"))
         {
            this.mNumPlaylistItems = IR.numPlaylistItems;
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.PLAYLIST_ITEM_COUNT,this.mNumPlaylistItems));
         }
         else if(IR.hasOwnProperty("currentOffset"))
         {
            this.mCurrentOffset = IR.currentOffset;
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.CURRENT_OFFSET,this.mCurrentOffset));
         }
         else if(IR.hasOwnProperty("playlist"))
         {
            this.decodePlayList(IR.playlist);
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.PLAYLIST,this.mIRBufferEntryList));
         }
         else if(IR.hasOwnProperty("bufferWarning"))
         {
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.BUFFER_WARNING));
         }
         else if(IR.hasOwnProperty("bufferFull"))
         {
            this.dispatchEvent(new SatelliteRadioInstantReplayEvent(SatelliteRadioInstantReplayEvent.BUFFER_FULL));
         }
      }
      
      private function decodePlayList(playlist:Object) : void
      {
         var newEntry:SatelliteRadioInstantReplayBufferEntry = null;
         var e:SatelliteRadioInstantReplayBufferEntry = null;
         while(this.mIRBufferEntryList.length > 0)
         {
            this.mIRBufferEntryList.pop();
         }
         for each(e in playlist)
         {
            newEntry.offset = e.offset;
            newEntry.artist = e.artist;
            newEntry.program = e.program;
            newEntry.composer = e.composer;
            newEntry.artistID = e.artistID;
            newEntry.programID = e.programID;
            this.mIRBufferEntryList.push(newEntry);
         }
         this.mIRBufferEntryList = this.mIRBufferEntryList.reverse();
      }
   }
}

