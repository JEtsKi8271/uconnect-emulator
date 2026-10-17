package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AudioMixerManagerEvent;
   import com.harman.moduleLinkAPI.IAudioMixerManager;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AudioMixerManager extends Module implements IAudioMixerManager
   {
      
      private static var instance:AudioMixerManager;
      
      private static const dbusIdentifier:String = "AudioMixerManager";
      
      private static const dbusInterruptSrc:String = "interruptSrc";
      
      private static const registerMuteClientCommand:String = "registerMuteClient";
      
      private static const setEntertainmentSrcMuteCommand:String = "setEntertainmentSrcMute";
      
      private static const INVALID_CLIENT_ID:int = 65535;
      
      public static const sTONE_NORMAL:String = "CONF_1";
      
      public static const sTONE_REJECTION:String = "CONF_2";
      
      public static const sTONE_SET:String = "CONF_3";
      
      private static const sAMM_SOURCE_SIGNAL:String = "signal";
      
      private static const sAMM_SOURCE_NONE:String = "none";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mBusy:Boolean = true;
      
      private var mConnected:Boolean = false;
      
      private var mNavPromptVolume:int = 0;
      
      private var mDabMuxSource:Boolean = false;
      
      private var mMuteClientId:int = 65535;
      
      private var mInterruptSource:String;
      
      private var mMuteStatus:Boolean = false;
      
      private var mMicMuteStatus:Boolean = false;
      
      private var mAuxVolumeOffset:int = 0;
      
      private var mTouchScreenBeep:Boolean = false;
      
      private var mAudioMixerManagerServiceAvailable:Boolean = false;
      
      public function AudioMixerManager()
      {
         this.mInterruptSource = this.AMM_SOURCE_NONE;
         super();
         this.init();
      }
      
      public static function getInstance() : AudioMixerManager
      {
         if(instance == null)
         {
            instance = new AudioMixerManager();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.mBusy = true;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.AUDIOMIXERMANAGER,this.ammMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.mConnected = true;
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"volumeLevel\"}");
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"abortInformationSource\"}");
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"dabSource\"}");
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + dbusInterruptSrc + "\"}");
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"gainOffset\"}");
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"shfMicMute\"}");
               this.sendAudioMixerServiceAvailableRequest();
               this.sendEvent(AudioMixerManagerEvent.AMM_BUSY);
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendRegisterCommand(valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + registerMuteClientCommand + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendMuteCommand(valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + setEntertainmentSrcMuteCommand + "\": {\"id\":" + this.mMuteClientId + ", \"mute\":" + "true" + ", \"" + valueName + "\":\"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendUnmuteCommand(valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + setEntertainmentSrcMuteCommand + "\": {\"id\":" + this.mMuteClientId + ", \"mute\":" + "false" + ", \"" + valueName + "\":\"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new AudioMixerManagerEvent(eventType));
      }
      
      private function sendAudioMixerServiceAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function getMuxSource() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"dabSource\"]}}}";
         this.client.send(message);
      }
      
      public function get TONE_NORMAL() : String
      {
         return sTONE_NORMAL;
      }
      
      public function get TONE_REJECTION() : String
      {
         return sTONE_REJECTION;
      }
      
      public function get TONE_SET() : String
      {
         return sTONE_SET;
      }
      
      public function getAMMBusy() : void
      {
         this.sendEvent(AudioMixerManagerEvent.AMM_BUSY);
      }
      
      public function get AMMBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function get dabfmMuxSource() : Boolean
      {
         return this.mDabMuxSource;
      }
      
      public function requestInformationSource(source:String, exclusive:Boolean) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestInformationSource\": { \"source\": \"" + source + "\",\"exclusive\":" + exclusive + "}}}";
         this.client.send(message);
      }
      
      public function releaseInformationSource(source:String) : void
      {
         this.sendCommand("releaseInformationSource","source",source);
      }
      
      public function sendConfirmationTone(tone:String) : void
      {
         if(this.mTouchScreenBeep)
         {
            this.sendCommand("confirmationTone","type",tone);
         }
      }
      
      public function sendInformationAlert(tone:String) : void
      {
         this.sendCommand("informationAlert","type",tone);
      }
      
      public function get AMM_SOURCE_SIGNAL() : String
      {
         return sAMM_SOURCE_SIGNAL;
      }
      
      public function get AMM_SOURCE_NONE() : String
      {
         return sAMM_SOURCE_NONE;
      }
      
      public function get interruptSource() : String
      {
         return this.mInterruptSource;
      }
      
      public function adjustNavPromptVolume(direction:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"adjustVolume\": { \"user\":\"driver\", \"source\":\"NAV\", \"direction\":\"" + direction + "\"}}}";
         this.client.send(message);
      }
      
      public function getNavPromptVolume() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"volumeLevel\"]}}}");
      }
      
      public function get navPromptVolume() : int
      {
         return this.mNavPromptVolume;
      }
      
      public function registerMuteClient(serviceName:String) : void
      {
         this.sendRegisterCommand("serviceName",serviceName);
      }
      
      public function setEntertainmentSrcMute(input:String) : Boolean
      {
         var result:Boolean = false;
         if(this.mMuteClientId != INVALID_CLIENT_ID)
         {
            this.sendMuteCommand("input",input);
            result = true;
         }
         return result;
      }
      
      public function setEntertainmentSrcUnmute(input:String) : Boolean
      {
         var result:Boolean = false;
         if(this.mMuteClientId != INVALID_CLIENT_ID)
         {
            this.sendUnmuteCommand("input",input);
            result = true;
         }
         return result;
      }
      
      public function setTouchScreenEnable(isEnabled:Boolean) : void
      {
         this.mTouchScreenBeep = isEnabled;
      }
      
      public function get phoneMuteStatus() : Boolean
      {
         return this.mMuteStatus;
      }
      
      public function get phoneMicMuteStatus() : Boolean
      {
         return this.mMicMuteStatus;
      }
      
      public function setAuxVolumeOffset(offset:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setSourceOffset\": { \"source\": \"aux\", \"offset\": " + offset + "}}}";
         this.client.send(message);
      }
      
      public function getAuxVolumeOffset() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"gainOffset\"]}}}");
      }
      
      public function get AuxVolumeOffset() : int
      {
         return this.mAuxVolumeOffset;
      }
      
      public function sendPhoneMute(mute:Boolean) : void
      {
         this.client.send("{\"Type\":\"Command\",\"Dest\":\"" + dbusIdentifier + "\",\"packet\":" + "{\"setMixerMute\":" + "{\"id\":0,\"mute\":" + mute + ",\"input\":\"PHONE\"}}}");
      }
      
      public function ammMessageHandler(e:ConnectionEvent) : void
      {
         var ACTION:String = null;
         var SOURCE:String = null;
         var data:Object = null;
         var action:String = null;
         var source:String = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mAudioMixerManagerServiceAvailable == false)
            {
               this.mAudioMixerManagerServiceAvailable = true;
               this.getMuxSource();
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mAudioMixerManagerServiceAvailable = false;
            }
         }
         else if(resp.hasOwnProperty("requestInformationSource"))
         {
            if(resp.requestInformationSource.hasOwnProperty("allowed"))
            {
               if(String(resp.requestInformationSource.allowed) == "true" && String(resp.requestInformationSource.action) == "added")
               {
                  this.sendEvent(AudioMixerManagerEvent.AMM_INFORMATION_REQUEST_GRANTED);
               }
            }
         }
         else if(resp.hasOwnProperty("abortInformationSource"))
         {
            if(resp.abortInformationSource.hasOwnProperty("source"))
            {
               if(String(resp.abortInformationSource.source) == "nav")
               {
                  this.sendEvent(AudioMixerManagerEvent.AMM_ABORT_NAV_AUDIO_INTERUPT);
               }
            }
         }
         else if(resp.hasOwnProperty("volumeLevel"))
         {
            if(resp.volumeLevel.hasOwnProperty("source"))
            {
               if(String(resp.volumeLevel.source) == "NAV")
               {
                  if(Boolean(resp.volumeLevel.hasOwnProperty("Level")) && Boolean(resp.volumeLevel.hasOwnProperty("output")))
                  {
                     if(String(resp.volumeLevel.output) == "FRONT_L_SPKR")
                     {
                        this.mNavPromptVolume = int(resp.volumeLevel.Level);
                        this.sendEvent(AudioMixerManagerEvent.AMM_NAV_PROMPT_VOLUME_CHANGE);
                     }
                  }
               }
            }
         }
         else if(resp.hasOwnProperty("dabSource"))
         {
            this.mDabMuxSource = resp.dabSource.dabSource == "TUN" ? true : false;
            this.sendEvent(AudioMixerManagerEvent.AMM_DAB_TO_FM_FOLLOWING);
         }
         else if(resp.hasOwnProperty("registerMuteClient"))
         {
            if(resp.registerMuteClient.hasOwnProperty("id"))
            {
               this.mMuteClientId = resp.registerMuteClient.id;
            }
         }
         else if(resp.hasOwnProperty(dbusInterruptSrc))
         {
            ACTION = "action";
            SOURCE = "source";
            data = resp[dbusInterruptSrc];
            if(data.hasOwnProperty(ACTION) && data.hasOwnProperty(SOURCE))
            {
               action = data[ACTION];
               source = data[SOURCE];
               if(action == "removed")
               {
                  this.mInterruptSource = this.AMM_SOURCE_NONE;
               }
               else if(action == "added")
               {
                  this.mInterruptSource = source;
               }
               dispatchEvent(new AudioMixerManagerEvent(AudioMixerManagerEvent.AMM_INTERRUPT_SRC));
            }
         }
         else if(resp.hasOwnProperty("setSourceOffset"))
         {
            if(resp.setSourceOffset.hasOwnProperty("gainOffset"))
            {
               if(resp.setSourceOffset.gainOffset.source == "aux")
               {
                  this.mAuxVolumeOffset = resp.setSourceOffset.gainOffset.offset;
                  dispatchEvent(new AudioMixerManagerEvent(AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET));
               }
            }
         }
         else if(resp.hasOwnProperty("gainOffset"))
         {
            if(resp.gainOffset.source == "aux")
            {
               this.mAuxVolumeOffset = resp.gainOffset.offset;
               dispatchEvent(new AudioMixerManagerEvent(AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET));
            }
         }
         else if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("volumeLevel"))
            {
               if(resp.getProperties.volumeLevel.hasOwnProperty("FRONT_L_SPKR"))
               {
                  if(resp.getProperties.volumeLevel.FRONT_L_SPKR.hasOwnProperty("NAV"))
                  {
                     this.mNavPromptVolume = int(resp.getProperties.volumeLevel.FRONT_L_SPKR.NAV);
                     this.sendEvent(AudioMixerManagerEvent.AMM_NAV_PROMPT_VOLUME_CHANGE);
                  }
               }
            }
            if(resp.getProperties.hasOwnProperty("gainOffset"))
            {
               if(resp.getProperties.gainOffset.hasOwnProperty("aux"))
               {
                  this.mAuxVolumeOffset = resp.getProperties.gainOffset.aux;
                  dispatchEvent(new AudioMixerManagerEvent(AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET));
               }
            }
            if(resp.getProperties.hasOwnProperty("dabSource"))
            {
               if(resp.getProperties.dabSource.hasOwnProperty("dabSource"))
               {
                  this.mDabMuxSource = resp.getProperties.dabSource.dabSource == "TUN" ? true : false;
               }
               else
               {
                  this.mDabMuxSource = resp.getProperties.dabSource == "TUN" ? true : false;
               }
               this.sendEvent(AudioMixerManagerEvent.AMM_DAB_TO_FM_FOLLOWING);
            }
         }
         else if(resp.hasOwnProperty("setMixerMute"))
         {
            if(resp.setMixerMute.hasOwnProperty("mute"))
            {
               this.mMuteStatus = resp.setMixerMute.mute;
               this.dispatchEvent(new AudioEvent(AudioEvent.INTERRUPT_MUTE));
            }
         }
         else if(resp.hasOwnProperty("shfMicMute"))
         {
            this.mMicMuteStatus = resp.shfMicMute.mute;
            this.dispatchEvent(new AudioEvent(AudioEvent.HFMIC));
         }
      }
   }
}

