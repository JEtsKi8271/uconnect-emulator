package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.IAudioManager;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AudioManager extends Module implements IAudioManager
   {
      
      private static var instance:AudioManager;
      
      private static const dbusIdentifier:String = "Audio";
      
      private static const dbusIdentifierAudMixer:String = "AudioMixerManager";
      
      public static const sSOURCE_OFF:String = "off";
      
      public static const sSOURCE_FM:String = "fm";
      
      public static const sSOURCE_AM:String = "am";
      
      public static const sSOURCE_MW:String = "mw";
      
      public static const sSOURCE_LW:String = "lw";
      
      public static const sSOURCE_DAB:String = "dab";
      
      public static const sSOURCE_DMB:String = "dmb";
      
      public static const sSOURCE_SAT:String = "sat";
      
      public static const sSOURCE_VRM:String = "vrm";
      
      public static const sSOURCE_CD:String = "cd";
      
      public static const sSOURCE_AUX:String = "aux";
      
      public static const sSOURCE_DTV:String = "dtv";
      
      public static const sSOURCE_USB1:String = "usb1";
      
      public static const sSOURCE_USB2:String = "usb2";
      
      public static const sSOURCE_USB3:String = "usb3";
      
      public static const sSOURCE_USB4:String = "usb4";
      
      public static const sSOURCE_SDCARD:String = "sdcard";
      
      public static const sSOURCE_BLUETOOTH:String = "btsa";
      
      public static const sSOURCE_PHONE:String = "phone";
      
      public static const sSOURCE_HTTPSTREAMER1:String = "audioApp1";
      
      public static const sSOURCE_HTTPSTREAMER2:String = "audioApp2";
      
      public static const sSOURCE_HTTPSTREAMER3:String = "audioApp3";
      
      public static const sSOURCE_PROJECTION1:String = "projectionDevice1";
      
      public static const sSOURCE_PROJECTION2:String = "projectionDevice2";
      
      public static const sSOURCE_PROJECTION3:String = "projectionDevice3";
      
      public static const sSOURCE_REAR_AUX1:String = "aux1";
      
      public static const sSOURCE_REAR_AUX2:String = "aux2";
      
      public static const sSOURCE_REAR_HDMI1:String = "hdmi1";
      
      public static const sSOURCE_REAR_HDMI2:String = "hdmi2";
      
      public static const sALERT_FAVORITE:String = "favorites";
      
      public static const sALERT_GAME:String = "sports";
      
      public static const sALERT_TRAFFIC:String = "traffic";
      
      public static const sALERT_WEATHER:String = "weather";
      
      public static const sSOURCE_INFO1:String = "INFO1";
      
      public static const sSERVICE_HMI:String = "hmi";
      
      public static const sTYPE_IPOD:String = "ipod";
      
      public static const sTYPE_PFS:String = "PlaysForSure";
      
      public static const sAHA_EMBEDDED:String = "Aha";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mReady:Boolean;
      
      private var mMute:Boolean;
      
      private var mSource:String = "off";
      
      private var mSourceAvailable:Boolean;
      
      private var mLastRadioSource:String = "off";
      
      private var mLastMediaSource:String = "off";
      
      private var mSources:Object;
      
      private var mLastAudioAppName:String = "off";
      
      private var mSourceChangeCount:int = 0;
      
      private var mAudioManagerServiceAvailable:Boolean = false;
      
      private var mAudioMixerManagerServiceAvailable:Boolean = false;
      
      private var mlastMediaSourceMSID:int = 0;
      
      private var mAudioSourceService:String = "";
      
      public function AudioManager()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected(null);
         }
         this.connection.addEventListener(ConnectionEvent.AUDIO,this.onAudioManagerMessage);
         this.connection.addEventListener(ConnectionEvent.AUDIOMIXERMANAGER,this.onAudioMixerManagerMessage);
      }
      
      public static function getInstance() : AudioManager
      {
         if(instance == null)
         {
            instance = new AudioManager();
         }
         return instance;
      }
      
      public function get SOURCE_OFF() : String
      {
         return sSOURCE_OFF;
      }
      
      public function get SOURCE_FM() : String
      {
         return sSOURCE_FM;
      }
      
      public function get SOURCE_AM() : String
      {
         return sSOURCE_AM;
      }
      
      public function get SOURCE_MW() : String
      {
         return sSOURCE_MW;
      }
      
      public function get SOURCE_LW() : String
      {
         return sSOURCE_LW;
      }
      
      public function get SOURCE_DAB() : String
      {
         return sSOURCE_DAB;
      }
      
      public function get SOURCE_DMB() : String
      {
         return sSOURCE_DMB;
      }
      
      public function get SOURCE_SAT() : String
      {
         return sSOURCE_SAT;
      }
      
      public function get SOURCE_AHA() : String
      {
         return this.sSOURCE_AHA;
      }
      
      public function get SOURCE_VRM() : String
      {
         return sSOURCE_VRM;
      }
      
      public function get SOURCE_CD() : String
      {
         return sSOURCE_CD;
      }
      
      public function get SOURCE_AUX() : String
      {
         return sSOURCE_AUX;
      }
      
      public function get SOURCE_DTV() : String
      {
         return sSOURCE_DTV;
      }
      
      public function get SOURCE_USB1() : String
      {
         return sSOURCE_USB1;
      }
      
      public function get SOURCE_USB2() : String
      {
         return sSOURCE_USB2;
      }
      
      public function get SOURCE_USB3() : String
      {
         return sSOURCE_USB3;
      }
      
      public function get SOURCE_USB4() : String
      {
         return sSOURCE_USB4;
      }
      
      public function get SOURCE_SDCARD() : String
      {
         return sSOURCE_SDCARD;
      }
      
      public function get SOURCE_BLUETOOTH() : String
      {
         return sSOURCE_BLUETOOTH;
      }
      
      public function get SOURCE_PHONE() : String
      {
         return sSOURCE_PHONE;
      }
      
      public function get SOURCE_HTTPSTREAMER1() : String
      {
         return sSOURCE_HTTPSTREAMER1;
      }
      
      public function get SOURCE_HTTPSTREAMER2() : String
      {
         return sSOURCE_HTTPSTREAMER2;
      }
      
      public function get SOURCE_HTTPSTREAMER3() : String
      {
         return sSOURCE_HTTPSTREAMER3;
      }
      
      public function get SOURCE_PROJECTION1() : String
      {
         return sSOURCE_PROJECTION1;
      }
      
      public function get SOURCE_PROJECTION2() : String
      {
         return sSOURCE_PROJECTION2;
      }
      
      public function get SOURCE_PROJECTION3() : String
      {
         return sSOURCE_PROJECTION3;
      }
      
      public function get SOURCE_REAR_AUX1() : String
      {
         return sSOURCE_REAR_AUX1;
      }
      
      public function get SOURCE_REAR_AUX2() : String
      {
         return sSOURCE_REAR_AUX2;
      }
      
      public function get SOURCE_REAR_HDMI1() : String
      {
         return sSOURCE_REAR_HDMI1;
      }
      
      public function get SOURCE_REAR_HDMI2() : String
      {
         return sSOURCE_REAR_HDMI2;
      }
      
      public function get ALERT_FAVORITE() : String
      {
         return sALERT_FAVORITE;
      }
      
      public function get ALERT_GAME() : String
      {
         return sALERT_GAME;
      }
      
      public function get ALERT_TRAFFIC() : String
      {
         return sALERT_TRAFFIC;
      }
      
      public function get ALERT_WEATHER() : String
      {
         return sALERT_WEATHER;
      }
      
      public function get SOURCE_INFO1() : String
      {
         return sSOURCE_INFO1;
      }
      
      private function connected(e:Event) : void
      {
         this.sendAudioServiceAvailableRequest();
         this.sendAudioMixerServiceAvailableRequest();
         this.sendSubscribe("audioSource");
         this.sendSubscribe("userMuteState");
         this.sendSubscribe("availableAudioSources");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected) && this.mReady;
      }
      
      public function get isSourceMuted() : Boolean
      {
         return this.mMute;
      }
      
      public function get source() : String
      {
         return this.mSource;
      }
      
      public function getMSIdForSource(source:String) : int
      {
         if(this.mSources == null)
         {
            return -1;
         }
         if(this.mSources.hasOwnProperty(source))
         {
            if(this.mSources[source].hasOwnProperty("id"))
            {
               return this.mSources[source].id;
            }
            return -1;
         }
         return -1;
      }
      
      public function get sSOURCE_AHA() : String
      {
         if(this.mSources == null)
         {
            return "null";
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER1) && this.mSources[this.SOURCE_HTTPSTREAMER1].appId == sAHA_EMBEDDED)
         {
            return this.SOURCE_HTTPSTREAMER1;
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER2) && this.mSources[this.SOURCE_HTTPSTREAMER2].appId == sAHA_EMBEDDED)
         {
            return this.SOURCE_HTTPSTREAMER2;
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER3) && this.mSources[this.SOURCE_HTTPSTREAMER3].appId == sAHA_EMBEDDED)
         {
            return this.SOURCE_HTTPSTREAMER3;
         }
         return "null";
      }
      
      public function get audioSourceService() : String
      {
         return this.mAudioSourceService;
      }
      
      public function get lastRadioSource() : String
      {
         return this.mLastRadioSource;
      }
      
      public function get lastMediaSource() : String
      {
         return this.mLastMediaSource;
      }
      
      public function get lastAudioAppName() : String
      {
         return this.mLastAudioAppName;
      }
      
      public function get isRearAuxAvailable() : Boolean
      {
         return this.isHardwareAvailable(this.SOURCE_REAR_AUX1) || this.isHardwareAvailable(this.SOURCE_REAR_AUX2) || this.isHardwareAvailable(this.SOURCE_VRM);
      }
      
      public function getSource() : void
      {
         this.sendCommand("getAudioSource","","");
      }
      
      public function setSource(_source:String) : void
      {
         if(!_source || _source == "")
         {
            return;
         }
         this.cacheLastSourceDomain(_source);
         if(_source != this.mSource)
         {
            this.reportSourceChange(_source);
            this.sendSetAudioSource(_source);
         }
      }
      
      public function goToLastRadioSource() : void
      {
         this.sendCommand("setLastTunerSource","","");
      }
      
      public function goToLastMediaSource() : void
      {
         this.sendCommand("setLastMediaSource","","");
      }
      
      private function getDevicesOnUSBHub() : void
      {
         this.sendCommand("getDevicesOnUSBHub","","");
      }
      
      public function getAvailableSources() : void
      {
         this.sendCommand("getAvailableAudioSources","","");
      }
      
      public function isSourceAvailable(source:String) : Boolean
      {
         if(this.mSources != null && Boolean(this.mSources[source]))
         {
            if(this.mSources[source].hasOwnProperty("available"))
            {
               return this.mSources[source].available;
            }
            return this.mSources[source];
         }
         return false;
      }
      
      public function isHardwareAvailable(source:String) : Boolean
      {
         return null != this.mSources && this.mSources.hasOwnProperty(source);
      }
      
      public function getSourceType() : String
      {
         return this.mSources[this.source].hasOwnProperty("type") ? this.mSources[this.source].type : this.source;
      }
      
      public function isSourceRSE(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return source == this.SOURCE_CD || source == this.SOURCE_REAR_AUX1 || source == this.SOURCE_REAR_AUX2 || source == this.SOURCE_REAR_HDMI1 || source == this.SOURCE_REAR_HDMI2 || source == this.SOURCE_DTV;
      }
      
      public function isSourceUSB(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return source == this.SOURCE_USB1 || source == this.SOURCE_USB2 || source == this.SOURCE_USB3 || source == this.SOURCE_USB4;
      }
      
      public function isSourceIPod(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return this.mSources != null && this.mSources[source] != null && Boolean(this.mSources[source].hasOwnProperty("type")) && this.mSources[source].type == sTYPE_IPOD;
      }
      
      public function isSourcePFS(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return this.mSources[source] != null && this.mSources[source].type == sTYPE_PFS;
      }
      
      public function isSourceMediaService(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return source == this.SOURCE_USB1 || source == this.SOURCE_USB2 || source == this.SOURCE_USB3 || source == this.SOURCE_USB4 || source == this.SOURCE_SDCARD || source == this.SOURCE_BLUETOOTH;
      }
      
      public function isSourceRadio(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return source == this.SOURCE_AM || source == this.SOURCE_FM || source == this.SOURCE_MW || source == this.SOURCE_LW || source == this.SOURCE_SAT || source == this.SOURCE_DAB || source == this.SOURCE_DMB || source == this.SOURCE_AHA;
      }
      
      public function isSourceMedia(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return this.isSourceMediaService(source) || this.isSourceRSE(source) || source == this.SOURCE_AUX || source == this.SOURCE_CD || source == this.SOURCE_DTV;
      }
      
      public function isSOURCE_HTTPSTREAMER(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return !this.isSourceEmbeddedApp(source) && (source == sSOURCE_HTTPSTREAMER1 || source == sSOURCE_HTTPSTREAMER2 || source == sSOURCE_HTTPSTREAMER3);
      }
      
      public function isSourceAha(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return this.mSources != null && this.mSources.hasOwnProperty(source) && Boolean(this.mSources[source].hasOwnProperty("name")) && this.mSources[source].name == sAHA_EMBEDDED;
      }
      
      public function isSourceEmbeddedApp(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return this.mSources != null && this.mSources.hasOwnProperty(source) && Boolean(this.mSources[source].hasOwnProperty("name")) && this.mSources[source].name == sAHA_EMBEDDED;
      }
      
      public function isSourceProjection(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         return source == this.SOURCE_PROJECTION1 || source == this.SOURCE_PROJECTION2 || source == this.SOURCE_PROJECTION3;
      }
      
      public function isSourceCarPlay(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         if(this.mSources == null || !this.mSources.hasOwnProperty(source))
         {
            return false;
         }
         return Boolean(this.mSources[source].hasOwnProperty("type")) && this.mSources[source].type == 2;
      }
      
      public function isSourceGAL(source:String = "") : Boolean
      {
         if(source == "")
         {
            source = this.mSource;
         }
         if(this.mSources == null || !this.mSources.hasOwnProperty(source))
         {
            return false;
         }
         return Boolean(this.mSources[source].hasOwnProperty("type")) && this.mSources[source].type == 3;
      }
      
      public function get radioSources() : Vector.<String>
      {
         var availableSrcs:Vector.<String> = new Vector.<String>();
         if(this.mSources.hasOwnProperty(this.SOURCE_AM) && Boolean(this.mSources.am.available))
         {
            availableSrcs.push(this.SOURCE_AM);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_MW) && Boolean(this.mSources.mw.available))
         {
            availableSrcs.push(this.SOURCE_MW);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_DAB) && Boolean(this.mSources.dab.available))
         {
            availableSrcs.push(this.SOURCE_DAB);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_FM) && Boolean(this.mSources.fm.available))
         {
            availableSrcs.push(this.SOURCE_FM);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_SAT) && Boolean(this.mSources.sat.available))
         {
            availableSrcs.push(this.SOURCE_SAT);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_LW) && Boolean(this.mSources.lw.available))
         {
            availableSrcs.push(this.SOURCE_LW);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_DMB) && Boolean(this.mSources.dmb.available))
         {
            availableSrcs.push(this.SOURCE_DMB);
         }
         if(Boolean(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER1)) && Boolean(this.mSources.audioApp1.available) && this.isSourceAha(this.SOURCE_HTTPSTREAMER1))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER1);
         }
         if(Boolean(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER2)) && Boolean(this.mSources.audioApp2.available) && this.isSourceAha(this.SOURCE_HTTPSTREAMER2))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER2);
         }
         if(Boolean(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER3)) && Boolean(this.mSources.audioApp3.available) && this.isSourceAha(this.SOURCE_HTTPSTREAMER3))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER3);
         }
         return availableSrcs;
      }
      
      public function get mediaSources() : Vector.<String>
      {
         var availableSrcs:Vector.<String> = new Vector.<String>();
         if(this.isHardwareAvailable(this.SOURCE_CD))
         {
            availableSrcs.push(this.SOURCE_CD);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB1))
         {
            availableSrcs.push(this.SOURCE_USB1);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB2))
         {
            availableSrcs.push(this.SOURCE_USB2);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB3))
         {
            availableSrcs.push(this.SOURCE_USB3);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB4))
         {
            availableSrcs.push(this.SOURCE_USB4);
         }
         if(this.isHardwareAvailable(this.SOURCE_AUX))
         {
            availableSrcs.push(this.SOURCE_AUX);
         }
         if(this.isHardwareAvailable(this.SOURCE_BLUETOOTH))
         {
            availableSrcs.push(this.SOURCE_BLUETOOTH);
         }
         if(this.isHardwareAvailable(this.SOURCE_SDCARD))
         {
            availableSrcs.push(this.SOURCE_SDCARD);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_AUX1))
         {
            availableSrcs.push(this.SOURCE_REAR_AUX1);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_AUX2))
         {
            availableSrcs.push(this.SOURCE_REAR_AUX2);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_HDMI1))
         {
            availableSrcs.push(this.SOURCE_REAR_HDMI1);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_HDMI2))
         {
            availableSrcs.push(this.SOURCE_REAR_HDMI2);
         }
         if(this.isHardwareAvailable(this.SOURCE_DTV))
         {
            availableSrcs.push(this.SOURCE_DTV);
         }
         return availableSrcs;
      }
      
      public function get availableSources() : Vector.<String>
      {
         var availableSrcs:Vector.<String> = new Vector.<String>();
         if(this.mSources.hasOwnProperty(this.SOURCE_AM) && Boolean(this.mSources.am.available))
         {
            availableSrcs.push(this.SOURCE_AM);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_MW) && Boolean(this.mSources.mw.available))
         {
            availableSrcs.push(this.SOURCE_MW);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_DAB) && Boolean(this.mSources.dab.available))
         {
            availableSrcs.push(this.SOURCE_DAB);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_FM) && Boolean(this.mSources.fm.available))
         {
            availableSrcs.push(this.SOURCE_FM);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_SAT) && Boolean(this.mSources.sat.available))
         {
            availableSrcs.push(this.SOURCE_SAT);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_LW) && Boolean(this.mSources.lw.available))
         {
            availableSrcs.push(this.SOURCE_LW);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_DMB) && Boolean(this.mSources.dmb.available))
         {
            availableSrcs.push(this.SOURCE_DMB);
         }
         if(this.isHardwareAvailable(this.SOURCE_CD))
         {
            availableSrcs.push(this.SOURCE_CD);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB1))
         {
            availableSrcs.push(this.SOURCE_USB1);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB2))
         {
            availableSrcs.push(this.SOURCE_USB2);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB3))
         {
            availableSrcs.push(this.SOURCE_USB3);
         }
         if(this.isHardwareAvailable(this.SOURCE_USB4))
         {
            availableSrcs.push(this.SOURCE_USB4);
         }
         if(this.isHardwareAvailable(this.SOURCE_AUX))
         {
            availableSrcs.push(this.SOURCE_AUX);
         }
         if(this.isHardwareAvailable(this.SOURCE_BLUETOOTH))
         {
            availableSrcs.push(this.SOURCE_BLUETOOTH);
         }
         if(this.isHardwareAvailable(this.SOURCE_SDCARD))
         {
            availableSrcs.push(this.SOURCE_SDCARD);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_AUX1))
         {
            availableSrcs.push(this.SOURCE_REAR_AUX1);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_AUX2))
         {
            availableSrcs.push(this.SOURCE_REAR_AUX2);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_HDMI1))
         {
            availableSrcs.push(this.SOURCE_REAR_HDMI1);
         }
         if(this.isHardwareAvailable(this.SOURCE_REAR_HDMI2))
         {
            availableSrcs.push(this.SOURCE_REAR_HDMI2);
         }
         if(this.isHardwareAvailable(this.SOURCE_DTV))
         {
            availableSrcs.push(this.SOURCE_DTV);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER1) && Boolean(this.mSources.audioApp1.available))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER1);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER2) && Boolean(this.mSources.audioApp2.available))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER2);
         }
         if(this.mSources.hasOwnProperty(this.SOURCE_HTTPSTREAMER3) && Boolean(this.mSources.audioApp3.available))
         {
            availableSrcs.push(this.SOURCE_HTTPSTREAMER3);
         }
         return availableSrcs;
      }
      
      public function get sourceChanges() : int
      {
         return this.mSourceChangeCount;
      }
      
      public function onAudioManagerMessage(e:ConnectionEvent) : void
      {
         var _getSource:String = null;
         var _source:String = null;
         var audio:Object = e.data;
         if(audio.hasOwnProperty("dBusServiceAvailable"))
         {
            if(audio.dBusServiceAvailable == "true" && this.mAudioManagerServiceAvailable == false)
            {
               this.mAudioManagerServiceAvailable = true;
               this.getProperties();
               this.getAvailableSources();
               this.getSource();
            }
            else if(audio.dBusServiceAvailable == "false")
            {
               this.mAudioManagerServiceAvailable = false;
            }
         }
         else if(audio.hasOwnProperty("userMuteState"))
         {
            this.mMute = audio.userMuteState.state;
            this.dispatchEvent(new AudioEvent(AudioEvent.SOURCE_MUTE));
         }
         else if(audio.hasOwnProperty("getProperties"))
         {
            if(audio.getProperties.hasOwnProperty("lastTunerMode"))
            {
               if(audio.getProperties.lastTunerMode.hasOwnProperty("sourceType"))
               {
                  this.mLastRadioSource = audio.getProperties.lastTunerMode.sourceType;
               }
            }
            if(audio.getProperties.hasOwnProperty("lastMediaMode"))
            {
               if(audio.getProperties.lastMediaMode.hasOwnProperty("sourceType"))
               {
                  this.mLastMediaSource = audio.getProperties.lastMediaMode.sourceType;
               }
            }
         }
         else if(audio.hasOwnProperty("getAudioSource"))
         {
            if(audio.getAudioSource.hasOwnProperty("source"))
            {
               _getSource = audio.getAudioSource.source;
               this.cacheLastSourceDomain(_getSource);
               this.reportSourceChange(_getSource);
               if(!this.mReady)
               {
                  this.mReady = true;
                  this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               }
            }
         }
         else if(audio.hasOwnProperty("audioSource"))
         {
            _source = audio.audioSource.source;
            this.mAudioSourceService = audio.audioSource.service;
            if(this.isSOURCE_HTTPSTREAMER(_source))
            {
               this.mLastAudioAppName = audio.audioSource[_source].name;
            }
            if(!audio.audioSource.hasOwnProperty("service") || audio.audioSource.service != sSERVICE_HMI)
            {
               this.checkSourceChange(_source);
            }
            if(audio.audioSource.hasOwnProperty(_source))
            {
               if(audio.audioSource[_source].id != null)
               {
                  this.mlastMediaSourceMSID = audio.audioSource[_source].id;
               }
               else
               {
                  this.mlastMediaSourceMSID = 0;
               }
            }
         }
         else if(audio.hasOwnProperty("getAvailableAudioSources"))
         {
            this.mSources = audio.getAvailableAudioSources;
            this.dispatchEvent(new AudioEvent(AudioEvent.AVAILABILITY));
         }
         else if(audio.hasOwnProperty("availableAudioSources"))
         {
            this.mSources = audio.availableAudioSources;
            this.dispatchEvent(new AudioEvent(AudioEvent.AVAILABILITY));
            this.checkSourceChange(this.mSource);
         }
      }
      
      private function checkSourceChange(_source:String) : void
      {
         this.cacheLastSourceDomain(_source);
         if(_source != this.mSource || this.mSourceAvailable != this.isSourceAvailable(this.mSource))
         {
            this.reportSourceChange(_source);
         }
      }
      
      private function cacheLastSourceDomain(_source:String) : void
      {
         if(this.isSourceRadio(_source))
         {
            this.mLastRadioSource = _source;
         }
         if(this.isSourceMedia(_source))
         {
            this.mLastMediaSource = _source;
         }
      }
      
      private function reportSourceChange(_source:String) : void
      {
         if(_source != this.mSource || this.mSourceAvailable != this.isSourceAvailable(this.mSource))
         {
            ++this.mSourceChangeCount;
            this.mSource = _source;
            this.mSourceAvailable = this.isSourceAvailable(this.mSource);
            this.dispatchEvent(new AudioEvent(AudioEvent.SOURCE));
         }
      }
      
      public function onAudioMixerManagerMessage(e:ConnectionEvent) : void
      {
         var message:String = null;
         var audio:Object = e.data;
         if(audio.hasOwnProperty("dBusServiceAvailable"))
         {
            if(audio.dBusServiceAvailable == "true" && this.mAudioMixerManagerServiceAvailable == false)
            {
               this.mAudioMixerManagerServiceAvailable = true;
               this.client.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifierAudMixer + "\", \"Signal\": \"" + "activeAudioSrc" + "\"}");
            }
            else if(audio.dBusServiceAvailable == "false")
            {
               this.mAudioMixerManagerServiceAvailable = false;
            }
         }
         else if(audio.hasOwnProperty("getProperties"))
         {
            if(Boolean(audio.getProperties.hasOwnProperty("activeAudioSrc")) && Boolean(audio.getProperties.hasOwnProperty("volumeLevel")))
            {
               AudioSettings.getInstance().volumeConfirmationValue = audio.getProperties.volumeLevel.FRONT_L_SPKR[audio.getProperties.activeAudioSrc];
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.ACTIVEAUDIOSOURCE));
         }
         else if(audio.hasOwnProperty("activeAudioSrc"))
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"AudioMixerManager\", \"packet\": { \"getProperties\": { \"props\":[\"activeAudioSrc\",\"volumeLevel\"]}}}";
            this.client.send(message);
         }
      }
      
      public function refreshSource() : void
      {
         this.dispatchEvent(new AudioEvent(AudioEvent.SOURCE_REFRESH));
      }
      
      private function sendAudioServiceAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendAudioMixerServiceAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifierAudMixer + "\"}";
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
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
      
      private function getProperties() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"props\":[\"lastTunerMode\", \"lastMediaMode\"]}}}";
         this.client.send(message);
      }
      
      public function sendAudioBeep() : void
      {
         this.sendCommand("sendAudioBeep","","");
      }
      
      private function sendSetAudioSource(_source:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setAudioSource\": { \"source\": \"" + _source + "\", \"service\": \"" + sSERVICE_HMI + "\"}}}";
         this.client.send(message);
      }
      
      public function sendAlertTone(tone:String) : void
      {
         this.sendCommand("informationAlert","type",tone);
      }
      
      public function lastMediaSourceMSID() : int
      {
         return this.mlastMediaSourceMSID;
      }
   }
}

