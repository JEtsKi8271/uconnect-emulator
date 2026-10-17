package com.nfuzion.moduleLink
{
   import com.harman.moduleLink.DABTunerStation;
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DABPreset;
   import com.harman.moduleLinkAPI.IDABTunerStation;
   import com.nfuzion.moduleLinkAPI.IPresetPersistencyManager;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.Preset;
   import com.nfuzion.moduleLinkAPI.PresetPersistencyConstants;
   import com.nfuzion.moduleLinkAPI.PresetPersistencyManagerEvent;
   import com.nfuzion.moduleLinkAPI.TunerBand;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class PresetPersistencyManager extends Module implements IPresetPersistencyManager
   {
      
      private static var instance:PresetPersistencyManager;
      
      private const mDBusSatPreset:String = "XMPresets";
      
      private const mDBusTunerPreset:String = "Tuner";
      
      private const mDbusDriverAB:String = "DriverAB";
      
      private var connection:Connection;
      
      private var name:String = "unknown";
      
      private var span:Client;
      
      private var mPresets:Vector.<Preset> = new Vector.<Preset>(PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS,true);
      
      private var mReady:Boolean = false;
      
      private var mInitComplete:Boolean = false;
      
      private var mRegion:String = "North America";
      
      private var mXMAppServiceAvailable:Boolean = false;
      
      private var mTunerServiceAvailable:Boolean = false;
      
      public function PresetPersistencyManager()
      {
         super();
         this.connection = Connection.share();
         this.span = this.connection.span;
         this.span.addEventListener(Event.CONNECT,this.connected);
         if(this.span.connected)
         {
            this.connected();
         }
         this.span.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_PRESETS,this.SatMessageHandler);
         this.connection.addEventListener(ConnectionEvent.TUNER,this.TunerMessageHandler);
         this.DABTuner.addEventListener(DABEvent.DAB_PRESET_LIST,this.onDABPresets);
      }
      
      public static function getInstance() : PresetPersistencyManager
      {
         if(instance == null)
         {
            instance = new PresetPersistencyManager();
         }
         return instance;
      }
      
      private function get DABTuner() : IDABTunerStation
      {
         return DABTunerStation.getInstance();
      }
      
      public function init(region:String) : void
      {
         var j:int = 0;
         var k:int = 0;
         var newPreset:Preset = null;
         this.mRegion = region;
         for(j = 0; j < PresetPersistencyConstants.MAX_NUMBER_OF_BANDS; j++)
         {
            for(k = 0; k < PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND; k++)
            {
               newPreset = new Preset();
               switch(j)
               {
                  case 0:
                     if(this.mRegion == TunerRegion.NORTH_AMERICA)
                     {
                        newPreset.Band = AudioManager.sSOURCE_AM;
                     }
                     else
                     {
                        newPreset.Band = AudioManager.sSOURCE_MW;
                     }
                     newPreset.Freq_Channel = 720;
                     newPreset.Genre = null;
                     newPreset.Position = k;
                     newPreset.StationName = null;
                     newPreset.SubChannel = 1;
                     newPreset.Active = false;
                     this.mPresets[j * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + k] = newPreset;
                     break;
                  case 1:
                     newPreset.Band = AudioManager.sSOURCE_FM;
                     newPreset.Freq_Channel = 102900;
                     newPreset.Genre = null;
                     newPreset.Position = k;
                     newPreset.StationName = null;
                     newPreset.SubChannel = 1;
                     newPreset.Active = false;
                     this.mPresets[j * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + k] = newPreset;
                     break;
                  case 2:
                     if(this.mRegion == TunerRegion.NORTH_AMERICA)
                     {
                        newPreset.Band = AudioManager.sSOURCE_SAT;
                        newPreset.Freq_Channel = -1;
                     }
                     else
                     {
                        newPreset.Band = AudioManager.sSOURCE_DAB;
                        newPreset.Freq_Channel = 155;
                     }
                     newPreset.Genre = null;
                     newPreset.Position = k;
                     newPreset.StationName = null;
                     newPreset.SubChannel = 1;
                     newPreset.Active = false;
                     this.mPresets[j * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + k] = newPreset;
               }
            }
         }
         this.connected(null);
      }
      
      public function get AllPresets() : Vector.<Preset>
      {
         return this.mPresets;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.span.connected) && this.mReady;
      }
      
      private function TunerMessageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var presetInfo:Object = null;
         var newPreset:Preset = null;
         var message:Object = e.data;
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.mTunerServiceAvailable == false)
            {
               this.mTunerServiceAvailable = true;
               this.tunerRequestPresetEvents();
               this.tunerRequestAllPresets();
            }
            else if(message.dBusServiceAvailable == "false")
            {
               this.mTunerServiceAvailable = false;
            }
         }
         else if(message.hasOwnProperty("presetList"))
         {
            this["presetList"] = message.presetList;
            this.dispatchReady();
         }
         else if(message.hasOwnProperty("presetUpdate"))
         {
            if(message.presetUpdate.hasOwnProperty("presetData"))
            {
               presetInfo = message.presetUpdate.presetData;
               newPreset = new Preset();
               newPreset.updatePreset(presetInfo);
               this.UpdatePresets(newPreset);
               this.dispatchEvent(new PresetPersistencyManagerEvent(PresetPersistencyManagerEvent.PRESETS));
            }
         }
         else if(message.hasOwnProperty("getProperties"))
         {
            if(message.getProperties.hasOwnProperty("presetList"))
            {
               this["presetList"] = message.getProperties.presetList;
               this.dispatchReady();
            }
         }
      }
      
      private function dispatchReady() : void
      {
         if(!this.mInitComplete)
         {
            this.mReady = true;
            this.mInitComplete = true;
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendTunerAvailableRequest();
         this.sendXMAppAvailableRequest();
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function hello() : void
      {
      }
      
      public function getFilteredPresets(band:String, startPos:int = 0, length:int = 0) : Vector.<Preset>
      {
         var rtn:Vector.<Preset> = null;
         var i:int = 0;
         var newPreset:Preset = null;
         var j:int = 0;
         var max:int = 0;
         rtn = new Vector.<Preset>();
         max = int(PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND);
         if(length > PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND)
         {
            length = int(PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND);
         }
         if(length == 0)
         {
            length = max;
         }
         switch(band)
         {
            case AudioManager.sSOURCE_AM:
            case AudioManager.sSOURCE_MW:
               startPos += 0 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND;
               rtn = this.mPresets.slice(startPos,startPos + length);
               break;
            case AudioManager.sSOURCE_FM:
               startPos += 1 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND;
               rtn = this.mPresets.slice(startPos,startPos + length);
               break;
            case AudioManager.sSOURCE_SAT:
            case AudioManager.sSOURCE_DAB:
               startPos += 2 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND;
               rtn = this.mPresets.slice(startPos,startPos + length);
               break;
            default:
               i = startPos;
               while(i < max && length > 0)
               {
                  newPreset = new Preset();
                  newPreset = this.mPresets[i];
                  rtn.push(newPreset);
                  i++;
                  length--;
               }
         }
         return rtn;
      }
      
      public function save(presets:Vector.<Preset>) : Boolean
      {
         var message:String = null;
         var key:String = null;
         var presetStr:String = null;
         for(var i:int = 0; i < presets.length; i++)
         {
            if(presets[i].Band == TunerBand.UNKNOWN || presets[i].Position == -1)
            {
               return false;
            }
            if(presets[i].Band == AudioManager.sSOURCE_SAT)
            {
               this.satPresetStore(presets[i].Position,presets[i].Freq_Channel);
               this.UpdatePresets(presets[i]);
            }
            else if(presets[i].Band == AudioManager.sSOURCE_AM || presets[i].Band == AudioManager.sSOURCE_FM || presets[i].Band == AudioManager.sSOURCE_MW)
            {
               if(presets[i].Active)
               {
                  this.tunerPresetStore(presets[i].Position);
               }
               else
               {
                  this.tunerPresetClear(presets[i].Position);
               }
               this.UpdatePresets(presets[i]);
            }
            else if(presets[i].Band == AudioManager.sSOURCE_DAB)
            {
               this.UpdatePresets(presets[i]);
               if(presets[i].Active)
               {
                  this.DABTuner.storePreset(presets[i].Position);
               }
               else
               {
                  this.DABTuner.clearPreset(presets[i].Position);
               }
            }
         }
         return true;
      }
      
      private function UpdatePresets(newPreset:Preset) : void
      {
         switch(newPreset.Band)
         {
            case AudioManager.sSOURCE_AM:
            case AudioManager.sSOURCE_MW:
               this.mPresets[0 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + newPreset.Position] = newPreset;
               break;
            case AudioManager.sSOURCE_FM:
               this.mPresets[1 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + newPreset.Position] = newPreset;
               break;
            case AudioManager.sSOURCE_SAT:
            case AudioManager.sSOURCE_DAB:
               this.mPresets[2 * PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND + newPreset.Position] = newPreset;
         }
      }
      
      protected function sendGetPropertiesToId(id:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "props" + "\": [\"" + value + "\"]}}}";
         this.span.send(message);
      }
      
      private function sendCommandToId(id:String, commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.span.send(message);
      }
      
      private function satPresetStore(location:int, channelNumber:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"";
         message += this.mDBusSatPreset + "\", \"packet\": { \"";
         message += "presetStore" + "\": { \"" + "presetNum" + "\": " + location.toString();
         message += ", \"channelNum\": " + channelNumber.toString() + "}}}";
         this.span.send(message);
      }
      
      private function satPresetRecall(location:int) : void
      {
         this.sendCommandToId(this.mDBusSatPreset,"presetRecall","presetNum",location);
      }
      
      private function formatCommandHelper(commandName:String, commandParamName:String, pos:int) : Object
      {
         var message:Object = {
            "Type":"Command",
            "Dest":this.mDBusTunerPreset,
            "packet":{}
         };
         message.packet[commandName] = {};
         message.packet[commandName][commandParamName] = pos;
         return message;
      }
      
      private function tunerPresetStore(pos:int) : void
      {
         var message:Object = null;
         message = this.formatCommandHelper("requestStorePreset","Position",pos);
         this.connection.send(message);
      }
      
      private function tunerPresetClear(pos:int) : void
      {
         var message:Object = null;
         message = this.formatCommandHelper("requestClearPreset","Position",pos);
         this.connection.send(message);
      }
      
      public function satRequestAllPresets() : void
      {
         this.sendGetPropertiesToId(this.mDBusSatPreset,"localXMPresetList");
      }
      
      public function tunerRequestAllPresets() : void
      {
         this.sendGetPropertiesToId(this.mDBusTunerPreset,"presetList");
      }
      
      public function satRequestPresetEvents() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.mDBusSatPreset + "\", \"Signal\": \"" + "localXMPresetList" + "\"}";
         this.span.send(message);
      }
      
      public function tunerRequestPresetEvents() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.mDBusTunerPreset + "\", \"Signal\": \"" + "presetList" + "\"}";
         this.span.send(message);
      }
      
      private function sendSubscribe(busName:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + busName + "\", \"Signal\": \"" + signalName + "\"}";
         this.span.send(message);
      }
      
      private function SatMessageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var message:Object = e.data;
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.mXMAppServiceAvailable == false)
            {
               this.mXMAppServiceAvailable = true;
               this.satRequestPresetEvents();
               this.satRequestAllPresets();
            }
            else if(message.dBusServiceAvailable == "false")
            {
               this.mXMAppServiceAvailable = false;
            }
         }
         else if(message.hasOwnProperty("localXMPresetList"))
         {
            this["localXMPresetList"] = message.localXMPresetList;
         }
         else if(message.hasOwnProperty("getProperties"))
         {
            if(message.getProperties.hasOwnProperty("localXMPresetList"))
            {
               this["localXMPresetList"] = message.getProperties.localXMPresetList;
            }
         }
      }
      
      private function set localXMPresetList(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.decodeLocalPresets(eventObj);
         }
      }
      
      private function set presetList(eventObj:Object) : void
      {
         var wb:Object = null;
         var tmpPreset:Object = null;
         var newPreset:Preset = null;
         if(null != eventObj)
         {
            if(eventObj.hasOwnProperty("value"))
            {
               eventObj = eventObj.value;
            }
            for each(wb in eventObj)
            {
               for each(tmpPreset in wb)
               {
                  newPreset = new Preset();
                  newPreset.updatePreset(tmpPreset);
                  this.UpdatePresets(newPreset);
               }
            }
            this.dispatchEvent(new PresetPersistencyManagerEvent(PresetPersistencyManagerEvent.PRESETS));
         }
      }
      
      private function decodeLocalPresets(localXMPresetList:Object) : void
      {
         var preset:Preset = null;
         var newPreset:Object = null;
         var count:* = 0;
         for each(newPreset in localXMPresetList)
         {
            preset = new Preset();
            preset.Position = count++;
            preset.Band = AudioManager.sSOURCE_SAT;
            preset.Freq_Channel = newPreset.channelID;
            preset.StationName = newPreset.text;
            if(preset.Freq_Channel != 65535 && preset.StationName.charAt(0) != "0")
            {
               preset.Active = true;
            }
            if(preset.Position < PresetPersistencyConstants.MAX_NUMBER_OF_PRESETS_PER_BAND)
            {
               this.UpdatePresets(preset);
            }
         }
         this.dispatchEvent(new PresetPersistencyManagerEvent(PresetPersistencyManagerEvent.PRESETS));
      }
      
      private function sendXMAppAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.mDBusSatPreset + "\"}";
         this.span.send(message);
      }
      
      private function sendTunerAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.mDBusTunerPreset + "\"}";
         this.span.send(message);
      }
      
      private function onDABPresets(e:DABEvent) : void
      {
         var dabPreset:DABPreset = null;
         var preset:Preset = null;
         var dabPresets:Array = this.DABTuner.Presets;
         if(dabPresets != null)
         {
            for each(dabPreset in dabPresets)
            {
               preset = new Preset();
               preset.Position = dabPreset.id;
               preset.StationName = dabPreset.name;
               preset.Genre = dabPreset.genre;
               preset.Band = AudioManager.sSOURCE_DAB;
               preset.Active = dabPreset.name.length > 0;
               this.UpdatePresets(preset);
            }
            this.dispatchEvent(new PresetPersistencyManagerEvent(PresetPersistencyManagerEvent.PRESETS));
         }
      }
   }
}

