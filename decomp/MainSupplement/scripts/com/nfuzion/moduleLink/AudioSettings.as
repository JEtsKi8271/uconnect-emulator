package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.IAudioSettings;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AudioSettings extends Module implements IAudioSettings
   {
      
      private static var instance:AudioSettings;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private const dbusIdentifier:String = "AudioSettings";
      
      private const dBusVolume:String = "volume";
      
      private const dBusSBRMute:String = "sbrMute";
      
      private const dBusLoudness:String = "loudness";
      
      private const dBusEqualizer:String = "equalizer";
      
      private const dbusMuteValue:String = "MuteValue";
      
      private const dBusSetVolume:String = "setVolume";
      
      private const dBusBalanceFade:String = "balanceFade";
      
      private const dBusInterrruptStatus:String = "interruptStatus";
      
      private const dBusTeenKeyVolumeCap:String = "teenKeyVolumeCap";
      
      private const dBusAudioSpeedVolume:String = "speedAdjustedVolume";
      
      private const dBusAudioSurroundSoundStatus:String = "surroundSoundStatus";
      
      private const dBusAudioSurroundSoundAvailable:String = "surroundSoundAvailable";
      
      private const dBusAudioSystemNotification:String = "audioSystemNotification";
      
      private const dBusReady:String = "ready";
      
      private const dBusGetReady:String = "getReady";
      
      private const dBusGetProperties:String = "getProperties";
      
      private const dBusApiGetAllProperties:String = "getAllProperties";
      
      private const dBusGetVolume:String = "getVolume";
      
      private const dBusGetLoudness:String = "getLoudness";
      
      private const dBusGetEqualizer:String = "getEqualizer";
      
      private const dBusGetBoosterAmp:String = "getBoosterAmp";
      
      private const dBusGetTwoChannel:String = "getTwoChannel";
      
      private const dbusGetBalanceFade:String = "getBalanceFade";
      
      private const dBusGetSpeedAdjustedVolume:String = "getSpeedAdjustedVolume";
      
      private const dBusGetSurroundSoundStatus:String = "getSurroundSoundStatus";
      
      private const dBusGetSurroundSoundAvailable:String = "getSurroundSoundAvailable";
      
      private const dbusIdentifier_AudioPAL:String = "AudioPAL";
      
      private const dBusGetAutoPlayStatus:String = "autoplay";
      
      private const mSourceAutoPlay:String = "usb";
      
      private const SCALE_BALANCE_FADE:uint = 10;
      
      private const SCALE_EQ:uint = 9;
      
      private const SCALE_SPEED_VOLUME:uint = 4;
      
      private var mAudioSettingRead:Boolean = false;
      
      private var mBalance:Number = 0;
      
      private var mFade:Number = 0;
      
      private var mVolumeRaw:Number = 0;
      
      private var mVolumeConfirmation:Number = 0;
      
      private var mSeatBeltMute:Boolean;
      
      private var mTeenKeyVolumeCap:Boolean;
      
      private var mSHFMicMute:Boolean = false;
      
      private var mSurroundSoundAvailable:Boolean = false;
      
      private var mSurroundSoundStatus:Boolean = false;
      
      private var mSpeedVolume:Number;
      
      private var mLoudness:Boolean;
      
      private var mVolumeCapped:Number = 38;
      
      private var mInterruptStatus:Boolean = false;
      
      private var mSuppressVolumeUpdates:Boolean = false;
      
      private var mBass:Number;
      
      private var mMid:Number;
      
      private var mTreble:Number;
      
      private var mTwoChannelMode:Boolean = false;
      
      private var mBoosterAmpPresent:Boolean = false;
      
      private var mWaitTimerForInitReady:Timer = new Timer(5000,1);
      
      private var mAudioAutoPlayStatus:String = "";
      
      private var mServiceAvailable:Boolean = false;
      
      public function AudioSettings()
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
         this.connection.addEventListener(ConnectionEvent.AUDIOSETTINGS,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.AUDIOPAL,this.messageHandler_AudioPAL);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : AudioSettings
      {
         if(instance == null)
         {
            instance = new AudioSettings();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function set HWVolumeRelative(step:int) : void
      {
         this.mVolumeRaw = this.checkWithCap(this.mVolumeRaw + step);
         this.mVolumeConfirmation = this.mVolumeRaw;
         if(!this.mSeatBeltMute)
         {
            this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
         }
         else
         {
            this.dispatchEvent(new AudioEvent(AudioEvent.SEATBELT_MUTE));
         }
      }
      
      public function get volumeRaw() : Number
      {
         return this.mVolumeRaw;
      }
      
      public function set volumeRaw(value:Number) : void
      {
         value = this.checkWithCap(value);
         this.sendCommand(this.dBusSetVolume,"volume",value);
      }
      
      public function setSHFMicMute(status:Boolean) : void
      {
         if(status && !this.mSHFMicMute)
         {
            this.sendCommand("setSHFMicMute","mute",true);
         }
         else if(!status && this.mSHFMicMute)
         {
            this.sendCommand("setSHFMicMute","mute",false);
         }
      }
      
      public function get SHFMicMute() : Boolean
      {
         return this.mSHFMicMute;
      }
      
      public function get seatbeltMute() : Boolean
      {
         return this.mSeatBeltMute;
      }
      
      public function get teenKeyVolumeCap() : Boolean
      {
         return this.mTeenKeyVolumeCap;
      }
      
      public function setBalance(balance:Number) : void
      {
         var oldHw:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mBalance = this.limitFullRange(this.roundToPrecision(balance,2));
         var hwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         if(oldHw != hwBalance)
         {
            this.sendCommand("setBalanceFade","balance",hwBalance);
         }
      }
      
      private function setHWBalance(balance:int) : void
      {
         this.mBalance = this.checkWithScale(balance,this.mBalance,this.SCALE_BALANCE_FADE);
      }
      
      public function get balance() : Number
      {
         return this.mBalance;
      }
      
      public function setBalanceFade(balance:Number, fade:Number) : void
      {
         var message:String = null;
         var oldHwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         var oldHwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mBalance = this.limitFullRange(this.roundToPrecision(balance,2));
         var hwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mFade = this.limitFullRange(this.roundToPrecision(fade,2));
         var hwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         if(hwFade != oldHwFade || hwBalance != oldHwBalance)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setBalanceFade";
            message += "\": { \"" + "balance" + "\": " + hwBalance.toString();
            message += ", \"" + "fade" + "\": " + hwFade.toString() + "}}}";
            this.client.send(message);
         }
      }
      
      public function setFade(fade:Number) : void
      {
         var oldHw:int = this.mFade * this.SCALE_BALANCE_FADE;
         this.mFade = this.limitFullRange(this.roundToPrecision(fade,2));
         var hwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         if(oldHw != hwFade)
         {
            this.sendCommand("setBalanceFade","fade",hwFade);
         }
      }
      
      public function setLoudness(status:Boolean) : void
      {
         this.sendCommand("setLoudness","loudness",status);
      }
      
      public function get Loudness() : Boolean
      {
         return this.mLoudness;
      }
      
      private function roundToPrecision(numberVal:Number, precision:int = 0) : Number
      {
         var decimalPlaces:Number = Math.pow(10,precision);
         return Math.round(decimalPlaces * numberVal) / decimalPlaces;
      }
      
      private function setHWFade(fade:int) : void
      {
         this.mFade = this.checkWithScale(fade,this.mFade,this.SCALE_BALANCE_FADE);
      }
      
      public function get fade() : Number
      {
         return this.mFade;
      }
      
      public function setBass(bass:Number) : void
      {
         var oldHw:int = this.mBass * this.SCALE_EQ;
         this.mBass = this.limitFullRange(bass);
         var hwBass:int = this.mBass * this.SCALE_EQ;
         if(oldHw != hwBass)
         {
            this.sendCommand("setEqualizer","bass",hwBass);
         }
      }
      
      private function setHWBass(bass:uint) : void
      {
         this.mBass = this.checkWithScale(bass,this.mBass,this.SCALE_EQ);
      }
      
      public function get bass() : Number
      {
         return this.mBass;
      }
      
      public function setTreble(treble:Number) : void
      {
         var oldHw:int = this.mTreble * this.SCALE_EQ;
         this.mTreble = this.limitFullRange(treble);
         var hwTreble:int = this.mTreble * this.SCALE_EQ;
         if(oldHw != hwTreble)
         {
            this.sendCommand("setEqualizer","treble",hwTreble);
         }
      }
      
      private function setHWTreble(treble:uint) : void
      {
         this.mTreble = this.checkWithScale(treble,this.mTreble,this.SCALE_EQ);
      }
      
      public function get treble() : Number
      {
         return this.mTreble;
      }
      
      public function setMid(mid:Number) : void
      {
         var oldHw:int = this.mMid * this.SCALE_EQ;
         this.mMid = this.limitFullRange(mid);
         var hwMid:int = this.mMid * this.SCALE_EQ;
         if(oldHw != hwMid)
         {
            this.sendCommand("setEqualizer","mid",hwMid);
         }
      }
      
      private function setHWMid(mid:uint) : void
      {
         this.mMid = this.checkWithScale(mid,this.mMid,this.SCALE_EQ);
      }
      
      public function get mid() : Number
      {
         return this.mMid;
      }
      
      private function requestGetProperties() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\":\"" + this.dBusAudioSystemNotification + "\"}}}");
      }
      
      private function requestGetAllProperties() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      public function setSurroundSoundAvailable(avail:Boolean) : void
      {
         var message:String = null;
         if(false == avail)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundAvailable";
            message += "\": { \"" + "on" + "\": " + false + "}}}";
            this.client.send(message);
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundAvailable";
            message += "\": { \"" + "on" + "\": " + true + "}}}";
            this.client.send(message);
         }
      }
      
      public function setSurroundSoundStatus(status:Boolean) : void
      {
         var message:String = null;
         if(false == status)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundStatus";
            message += "\": { \"" + "on" + "\": " + false + "}}}";
            this.client.send(message);
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundStatus";
            message += "\": { \"" + "on" + "\": " + true + "}}}";
            this.client.send(message);
         }
      }
      
      public function set audioAutoPlayStatus(_state:String) : void
      {
         var message:String = "";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier_AudioPAL;
         message += "\", \"packet\": { \"setProperties\": { \"props\": {\"";
         message += this.dBusGetAutoPlayStatus + "\":[{\"source\":\"" + this.mSourceAutoPlay + "\",\"value\":\"" + _state + "\"}]}}}}";
         this.client.send(message);
         this.autoplayStatusAvail = _state;
      }
      
      public function get audioAutoPlayStatus() : String
      {
         return this.mAudioAutoPlayStatus;
      }
      
      private function GetAutoPlayStatus() : void
      {
         var message:String = "";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier_AudioPAL;
         message += "\", \"packet\": { \"getProperties\": { \"props\": [{\"prop\":\"";
         message += this.dBusGetAutoPlayStatus + "\",\"source\":[\"" + this.mSourceAutoPlay + "\"]}]}}}";
         this.client.send(message);
      }
      
      private function set autoplayStatusAvail(_state:String) : void
      {
         if(this.mAudioAutoPlayStatus != _state)
         {
            this.mAudioAutoPlayStatus = _state;
            this.dispatchEvent(new AudioEvent(AudioEvent.AUTOPLAYSTATUS));
            this.GetAutoPlayStatus();
         }
      }
      
      private function setSurroundSoundAvail(avail:Boolean) : void
      {
         this.mSurroundSoundAvailable = avail;
         this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDAVAILABLE));
      }
      
      public function get surroundSoundAvailable() : Boolean
      {
         return this.mSurroundSoundAvailable;
      }
      
      private function setSurroundSound(on:Boolean) : void
      {
         this.mSurroundSoundStatus = on;
         this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDSTATUS));
      }
      
      public function get surroundSoundStatus() : Boolean
      {
         return this.mSurroundSoundStatus;
      }
      
      public function setSpeedVolume(percent:Number) : void
      {
         var message:String = null;
         var oldHw:uint = this.mSpeedVolume * this.SCALE_SPEED_VOLUME;
         this.mSpeedVolume = this.limitHalfRange(percent);
         var hwSetting:uint = this.mSpeedVolume * this.SCALE_SPEED_VOLUME;
         if(oldHw != hwSetting)
         {
            if(0 == this.mSpeedVolume)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
               message += "\", \"packet\": { \"" + "setSpeedAdjustedVolume";
               message += "\": { \"" + "on" + "\": " + false;
               message += ", \"" + "variance" + "\": 0 }}}";
               this.client.send(message);
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
               message += "\", \"packet\": { \"" + "setSpeedAdjustedVolume";
               message += "\": { \"" + "on" + "\": " + true;
               message += ", \"" + "variance" + "\": " + hwSetting.toString() + "}}}";
               this.client.send(message);
            }
         }
      }
      
      public function get twoChannelMode() : Boolean
      {
         return this.mTwoChannelMode;
      }
      
      public function get boosterAmpPresent() : Boolean
      {
         return this.mBoosterAmpPresent;
      }
      
      private function setHWSpeedVolume(on:Boolean, variance:uint) : void
      {
         if(on)
         {
            this.mSpeedVolume = this.checkWithScale(variance,this.mSpeedVolume,this.SCALE_SPEED_VOLUME);
         }
         else
         {
            this.mSpeedVolume = 0;
         }
      }
      
      public function get speedVolume() : Number
      {
         return this.mSpeedVolume;
      }
      
      public function get interruptStatus() : Boolean
      {
         return this.mInterruptStatus;
      }
      
      private function checkWithScale(value:int, oldValue:Number, scale:int) : Number
      {
         var scaledOld:int = oldValue * scale;
         if(value != scaledOld)
         {
            return Number(value / scale);
         }
         return oldValue;
      }
      
      private function checkWithCap(value:Number) : Number
      {
         if(value < 0)
         {
            return 0;
         }
         if(value > this.mVolumeCapped)
         {
            if(this.mTeenKeyVolumeCap)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME_LIMIT_REACHED));
            }
            return this.mVolumeCapped;
         }
         return value;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendMultiSubscribe([this.dBusReady,this.dBusVolume,this.dBusLoudness,this.dBusEqualizer,this.dbusMuteValue,this.dBusBalanceFade,this.dBusAudioSpeedVolume,this.dBusInterrruptStatus,this.dBusAudioSystemNotification,this.dBusAudioSurroundSoundStatus,this.dBusAudioSurroundSoundAvailable]);
            this.sendCommand(this.dBusGetReady);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendAvailableRequest();
            this.mWaitTimerForInitReady.addEventListener(TimerEvent.TIMER,this.onInitWaitTimer,false,0,true);
            this.mWaitTimerForInitReady.start();
         }
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
      
      private function limitFullRange(val:Number) : Number
      {
         if(val > 1)
         {
            return 1;
         }
         if(val < -1)
         {
            return -1;
         }
         return val;
      }
      
      private function limitHalfRange(val:Number) : Number
      {
         if(val > 1)
         {
            return 1;
         }
         if(val < 0)
         {
            return 0;
         }
         return val;
      }
      
      private function sendCommand(commandName:String, valueName:String = "", value:Object = "") : void
      {
         var message:String = null;
         if(value is String)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
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
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.dbusIdentifier_AudioPAL + "\"}";
         this.client.send(message);
      }
      
      public function set volumeConfirmationValue(value:Number) : void
      {
         this.mVolumeConfirmation = value;
         if(this.mSuppressVolumeUpdates == false)
         {
            this.mVolumeRaw = this.mVolumeConfirmation;
         }
      }
      
      public function set volumePopupIsActive(active:Boolean) : void
      {
         if(this.mSuppressVolumeUpdates != active)
         {
            if(true != active)
            {
               this.mVolumeRaw = this.mVolumeConfirmation;
            }
            this.mSuppressVolumeUpdates = active;
         }
      }
      
      private function onInitWaitTimer(e:TimerEvent) : void
      {
         this.initAudioSettings();
      }
      
      private function initAudioSettings() : void
      {
         if(!this.mAudioSettingRead)
         {
            this.sendCommand(this.dBusGetVolume);
            this.sendCommand(this.dBusGetLoudness);
            this.sendCommand(this.dBusGetEqualizer);
            this.sendCommand(this.dBusGetBoosterAmp);
            this.sendCommand(this.dBusGetTwoChannel);
            this.sendCommand(this.dbusGetBalanceFade);
            this.sendCommand(this.dBusGetSpeedAdjustedVolume);
            this.sendCommand(this.dBusGetSurroundSoundStatus);
            this.sendCommand(this.dBusGetSurroundSoundAvailable);
            this.requestGetProperties();
         }
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var bass:Number = NaN;
         var mid:Number = NaN;
         var treb:Number = NaN;
         var audioSetting:Object = e.data;
         if(audioSetting.hasOwnProperty(this.dBusReady))
         {
            if(audioSetting.ready.ready == "true")
            {
               this.mWaitTimerForInitReady.removeEventListener(TimerEvent.TIMER,this.onInitWaitTimer);
               this.mWaitTimerForInitReady.reset();
               this.initAudioSettings();
               this.mAudioSettingRead = true;
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetProperties))
         {
            this.getPropertiesHandler(audioSetting.getProperties);
         }
         else if(audioSetting.hasOwnProperty(this.dBusApiGetAllProperties))
         {
            this.getPropertiesHandler(audioSetting.getAllProperties);
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetVolume))
         {
            if(audioSetting.getVolume.hasOwnProperty("cap"))
            {
               this.mVolumeCapped = audioSetting.volume.cap;
            }
            if(audioSetting.getVolume.hasOwnProperty("volume"))
            {
               this.mVolumeRaw = this.checkWithCap(audioSetting.getVolume.volume);
            }
            this.mVolumeConfirmation = this.mVolumeRaw;
            if(!this.mSeatBeltMute)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
            }
            else
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.SEATBELT_MUTE));
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetLoudness))
         {
            this.mLoudness = audioSetting.getLoudness.loudness;
            dispatchEvent(new AudioEvent(AudioEvent.LOUDNESS));
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetEqualizer))
         {
            bass = this.mBass;
            mid = this.mMid;
            treb = this.mTreble;
            this.setHWBass(audioSetting.getEqualizer.bass);
            this.setHWMid(audioSetting.getEqualizer.mid);
            this.setHWTreble(audioSetting.getEqualizer.treble);
            if(bass != this.mBass || this.mMid != mid || this.mTreble != treb)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.EQUALIZER));
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetBoosterAmp))
         {
            this.mBoosterAmpPresent = audioSetting.getBoosterAmp.booster_amp;
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetTwoChannel))
         {
            this.mTwoChannelMode = audioSetting.getTwoChannel.two_channel;
         }
         else if(audioSetting.hasOwnProperty(this.dbusGetBalanceFade))
         {
            this.setHWBalance(audioSetting.getBalanceFade.balance);
            this.setHWFade(audioSetting.getBalanceFade.fade);
            this.dispatchEvent(new AudioEvent(AudioEvent.BALANCEFADE));
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetSpeedAdjustedVolume))
         {
            if(0 == audioSetting.getSpeedAdjustedVolume.variance || false == audioSetting.getSpeedAdjustedVolume.on)
            {
               this.setHWSpeedVolume(false,0);
            }
            else
            {
               this.setHWSpeedVolume(audioSetting.getSpeedAdjustedVolume.on,audioSetting.getSpeedAdjustedVolume.variance);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SPEED));
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetSurroundSoundStatus))
         {
            if(audioSetting.getSurroundSoundStatus.on != null)
            {
               this.setSurroundSound(audioSetting.getSurroundSoundStatus.on);
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetSurroundSoundAvailable))
         {
            if(audioSetting.getSurroundSoundAvailable.on != null)
            {
               this.setSurroundSoundAvail(audioSetting.getSurroundSoundAvailable.on);
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSpeedVolume))
         {
            if(0 == audioSetting.speedAdjustedVolume.variance || false == audioSetting.speedAdjustedVolume.on)
            {
               this.setHWSpeedVolume(false,0);
            }
            else
            {
               this.setHWSpeedVolume(audioSetting.speedAdjustedVolume.on,audioSetting.speedAdjustedVolume.variance);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SPEED));
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSurroundSoundAvailable))
         {
            if(false == audioSetting.surroundSoundAvailable.on)
            {
               this.setSurroundSoundAvail(false);
            }
            else
            {
               this.setSurroundSoundAvail(true);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDAVAILABLE));
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSurroundSoundStatus))
         {
            if(false == audioSetting.surroundSoundStatus.on)
            {
               this.setSurroundSound(false);
            }
            else
            {
               this.setSurroundSound(true);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDSTATUS));
         }
         if(audioSetting.hasOwnProperty(this.dBusBalanceFade))
         {
            if(audioSetting.balanceFade.hasOwnProperty("balance"))
            {
               this.setHWBalance(audioSetting.balanceFade.balance);
            }
            if(audioSetting.balanceFade.hasOwnProperty("fade"))
            {
               this.setHWFade(audioSetting.balanceFade.fade);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.BALANCEFADE));
         }
         if(audioSetting.hasOwnProperty(this.dBusEqualizer))
         {
            bass = this.mBass;
            mid = this.mMid;
            treb = this.mTreble;
            if(audioSetting.equalizer.hasOwnProperty("bass"))
            {
               this.setHWBass(audioSetting.equalizer.bass);
            }
            if(audioSetting.equalizer.hasOwnProperty("mid"))
            {
               this.setHWMid(audioSetting.equalizer.mid);
            }
            if(audioSetting.equalizer.hasOwnProperty("treble"))
            {
               this.setHWTreble(audioSetting.equalizer.treble);
            }
            if(this.mBass != bass || this.mMid != mid || this.mTreble != treb)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.EQUALIZER));
            }
         }
         if(audioSetting.hasOwnProperty(this.dBusVolume))
         {
            if(audioSetting.volume.hasOwnProperty("cap"))
            {
               this.mVolumeCapped = audioSetting.volume.cap;
            }
            if(audioSetting.volume.hasOwnProperty("volume"))
            {
               this.mVolumeRaw = this.checkWithCap(audioSetting.volume.volume);
            }
            this.mVolumeConfirmation = this.mVolumeRaw;
            if(!this.mSeatBeltMute)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
            }
            else
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.SEATBELT_MUTE));
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusLoudness))
         {
            this.mLoudness = audioSetting.loudness.loudness;
            dispatchEvent(new AudioEvent(AudioEvent.LOUDNESS));
         }
         if(audioSetting.hasOwnProperty(this.dbusMuteValue))
         {
            this.mSHFMicMute = audioSetting.MuteValue.mutevalue;
            this.dispatchEvent(new AudioEvent(AudioEvent.HFMIC));
         }
         if(audioSetting.hasOwnProperty(this.dBusAudioSystemNotification))
         {
            this.getPropertiesHandler(audioSetting);
         }
         if(audioSetting.hasOwnProperty(this.dBusInterrruptStatus))
         {
            this.mInterruptStatus = audioSetting.interruptStatus.active;
            this.dispatchEvent(new AudioEvent(AudioEvent.INTERRUPT_STATUS));
         }
      }
      
      private function getPropertiesHandler(msg:Object) : void
      {
         if(msg.hasOwnProperty(this.dBusReady))
         {
            this.initAudioSettings();
            this.mAudioSettingRead = msg.ready == "true";
         }
         if(msg.hasOwnProperty(this.dBusAudioSystemNotification))
         {
            if(msg.audioSystemNotification.hasOwnProperty(this.dBusSBRMute))
            {
               this.mSeatBeltMute = msg.audioSystemNotification.sbrMute;
               this.dispatchEvent(new AudioEvent(AudioEvent.SEATBELT_MUTE));
            }
            if(msg.audioSystemNotification.hasOwnProperty(this.dBusTeenKeyVolumeCap))
            {
               this.mTeenKeyVolumeCap = msg.audioSystemNotification.teenKeyVolumeCap;
            }
         }
         if(msg.hasOwnProperty(this.dBusSBRMute))
         {
            this.mSeatBeltMute = msg.sbrMute;
            this.dispatchEvent(new AudioEvent(AudioEvent.SEATBELT_MUTE));
         }
         if(msg.hasOwnProperty(this.dBusTeenKeyVolumeCap))
         {
            this.mTeenKeyVolumeCap = msg.teenKeyVolumeCap;
         }
      }
      
      private function messageHandler_AudioPAL(msg:ConnectionEvent) : void
      {
         var AudioPAL:Object = msg.data;
         if(AudioPAL.hasOwnProperty("dBusServiceAvailable"))
         {
            if(AudioPAL.dBusServiceAvailable == "true" && this.mServiceAvailable == false)
            {
               this.mServiceAvailable = true;
               this.GetAutoPlayStatus();
            }
            else if(AudioPAL.dBusServiceAvailable == "false")
            {
               this.mServiceAvailable = false;
            }
         }
         else if(AudioPAL.hasOwnProperty(this.dBusGetProperties))
         {
            if(AudioPAL.getProperties.hasOwnProperty(this.dBusGetAutoPlayStatus))
            {
               if(AudioPAL.getProperties.autoplay[0].hasOwnProperty("source"))
               {
                  this.autoplayStatusAvail = AudioPAL.getProperties.autoplay[0].value;
               }
               else if(AudioPAL.getProperties.autoplay[0].hasOwnProperty("error"))
               {
                  this.autoplayStatusAvail = "error";
               }
               else
               {
                  this.autoplayStatusAvail = "";
               }
            }
         }
      }
   }
}

