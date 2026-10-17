package peripheral
{
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DABIndexIdHelper;
   import com.harman.moduleLinkAPI.DABPreset;
   import com.harman.moduleLinkAPI.DABTunerStationInstance;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.HdStatus;
   import com.nfuzion.moduleLinkAPI.Preset;
   import com.nfuzion.moduleLinkAPI.PresetPersistencyManagerEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import events.PresetManagerEvent;
   
   public class PresetManager
   {
      
      private static var mCurrentDABPreset:uint;
      
      private static var mLastDABPresetSent:DABPreset;
      
      private static const PRESET_POSITION_NONE:uint = 255;
      
      private static var mAllowPresetPageUpdate:Boolean = true;
      
      public function PresetManager()
      {
         super();
         Peripheral.dabTunerStation.addEventListener(DABEvent.DAB_INFO_CURRENT_STATION,this.onDabInfoCurrentStationUpdate);
         Peripheral.presetPersistencyManager.addEventListener(PresetPersistencyManagerEvent.PRESETS,this.onPresetPersistencyManagerReady);
         if(mLastDABPresetSent == null)
         {
            mLastDABPresetSent = new DABPreset();
         }
      }
      
      public function deletePreset(band:String, presetId:int) : void
      {
         var rtn:Boolean = false;
         var preset:Vector.<Preset> = Peripheral.presetPersistencyManager.getFilteredPresets(band,presetId,1);
         if(preset.length > 0)
         {
            preset[0].Active = false;
            if(band == Peripheral.audioManager.SOURCE_SAT)
            {
               preset[0].Freq_Channel = 65535;
            }
            else
            {
               preset[0].Freq_Channel = 0;
            }
            preset[0].SubChannel = 0;
            preset[0].StationName = "";
            preset[0].DAB_EnsembleIDs = new Vector.<uint>(3,true);
            rtn = Peripheral.presetPersistencyManager.save(preset);
            preset[0] = null;
         }
      }
      
      public function storeCurrentChannelAsPreset(presetId:int) : Boolean
      {
         var currentDABStationInfo:DABTunerStationInstance = null;
         var rtn:Boolean = false;
         var retVal:Boolean = true;
         var preset:Vector.<Preset> = Peripheral.presetPersistencyManager.getFilteredPresets(Peripheral.audioManager.source,presetId,1);
         if(preset.length > 0)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT)
            {
               preset[0].Band = Peripheral.audioManager.source;
               preset[0].Freq_Channel = Peripheral.satelliteRadio.currentChannel.number;
               preset[0].StationName = Peripheral.satelliteRadio.currentChannel.shortName;
               preset[0].Active = true;
               preset[0].Position = presetId;
            }
            else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DAB)
            {
               currentDABStationInfo = Peripheral.dabTunerStation.currentStation;
               if(currentDABStationInfo.frequency != 0 && currentDABStationInfo.id[DABIndexIdHelper.DAB_ENSEMBLE_ID] != 0 && currentDABStationInfo.id[DABIndexIdHelper.DAB_SERVICE_ID] != 0)
               {
                  preset[0].Band = Peripheral.audioManager.source;
                  preset[0].Freq_Channel = currentDABStationInfo.frequency;
                  preset[0].DAB_EnsembleIDs[DABIndexIdHelper.DAB_ENSEMBLE_ID] = currentDABStationInfo.id[DABIndexIdHelper.DAB_ENSEMBLE_ID];
                  preset[0].DAB_EnsembleIDs[DABIndexIdHelper.DAB_SERVICE_ID] = currentDABStationInfo.id[DABIndexIdHelper.DAB_SERVICE_ID];
                  preset[0].DAB_EnsembleIDs[DABIndexIdHelper.DAB_COMPONENT_ID] = 0;
                  preset[0].StationName = currentDABStationInfo.names[DABIndexIdHelper.DAB_SERVICE_LONG_LBL_IDX];
                  preset[0].Genre = currentDABStationInfo.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX];
                  preset[0].Active = true;
                  preset[0].Position = presetId;
               }
               else
               {
                  retVal = false;
               }
            }
            else
            {
               preset[0].Band = Peripheral.audioManager.source;
               preset[0].Freq_Channel = Peripheral.tuner.frequency;
               preset[0].Genre = Peripheral.tuner.stationProgramType;
               preset[0].Active = true;
               preset[0].Position = presetId;
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
               {
                  preset[0].StationName = Peripheral.tuner.stationName;
                  if(Peripheral.tuner.hdStatusMsg != HdStatus.HD_UNINITIALIZED && Peripheral.tuner.hdStatusMsg != HdStatus.HD_ANALOG_AUDIO)
                  {
                     preset[0].SubChannel = Peripheral.tuner.currentHdSubchannel;
                  }
                  else
                  {
                     preset[0].SubChannel = 0;
                  }
               }
               else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AM)
               {
                  if(Global.market == TunerRegion.JAPAN)
                  {
                     preset[0].StationName = Peripheral.tuner.stationName;
                  }
                  else
                  {
                     preset[0].StationName = "";
                  }
               }
            }
            if(retVal)
            {
               rtn = Peripheral.presetPersistencyManager.save(preset);
               preset[0] = null;
            }
         }
         preset = null;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DAB)
         {
            return retVal;
         }
         return true;
      }
      
      public function storePreset(band:String, presetId:int, frequency:uint, stationName:String = "") : void
      {
         var rtn:Boolean = false;
         var preset:Vector.<Preset> = Peripheral.presetPersistencyManager.getFilteredPresets(band,presetId,1);
         if(preset.length > 0)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
            {
               preset[0].StationName = Peripheral.tuner.stationName;
            }
            else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AM)
            {
               preset[0].StationName = "";
            }
            preset[0].Band = band;
            preset[0].Freq_Channel = frequency;
            preset[0].Active = true;
            preset[0].Position = presetId;
            rtn = Peripheral.presetPersistencyManager.save(preset);
            preset[0] = null;
         }
         preset = null;
      }
      
      public function onSWCPresetAdvance() : void
      {
         if(Peripheral.audioManager.isSourceRadio(Peripheral.audioManager.source) == true)
         {
            if(this.haveActivePresets)
            {
               mAllowPresetPageUpdate = true;
            }
            else
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
      }
      
      private function get haveActivePresets() : Boolean
      {
         var preset:Preset = null;
         var mPresets:Vector.<Preset> = new Vector.<Preset>();
         mPresets = Peripheral.presetPersistencyManager.getFilteredPresets(Peripheral.audioManager.source);
         for each(preset in mPresets)
         {
            if(preset.Active == true)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get currentDABPreset() : int
      {
         return mCurrentDABPreset;
      }
      
      public function set currentDABPreset(p:int) : void
      {
         mLastDABPresetSent.clear();
         mCurrentDABPreset = p;
      }
      
      public function get isPresetPageUpdateAllowed() : Boolean
      {
         return mAllowPresetPageUpdate;
      }
      
      public function set allowPresetPageUpdate(b:Boolean) : void
      {
         mAllowPresetPageUpdate = b;
      }
      
      public function get presetPositionNone() : int
      {
         return PRESET_POSITION_NONE;
      }
      
      private function onDabInfoCurrentStationUpdate(e:DABEvent) : void
      {
         this.findPresetIndex();
      }
      
      private function findPresetIndex() : void
      {
         var curPreset:DABPreset = null;
         var i:int = 0;
         var j:int = int(mCurrentDABPreset);
         var idFound:Boolean = false;
         var numPresets:uint = Peripheral.dabTunerStation.Presets.length;
         for(i = 0; i < numPresets; i++)
         {
            if(j >= numPresets)
            {
               j = 0;
            }
            if(Peripheral.dabTunerStation.Presets[j].selected == true)
            {
               mCurrentDABPreset = j;
               idFound = true;
               break;
            }
            j++;
         }
         if(idFound == false)
         {
            mCurrentDABPreset = PRESET_POSITION_NONE;
         }
         if(mCurrentDABPreset != PRESET_POSITION_NONE)
         {
            curPreset = Peripheral.dabTunerStation.Presets[mCurrentDABPreset];
         }
         if(!mLastDABPresetSent.isEqual(curPreset))
         {
            mLastDABPresetSent.copyFrom(curPreset);
            Framework.messenger.dispatchEvent(new PresetManagerEvent(PresetManagerEvent.DAB_PRESET_UPDATE));
         }
      }
      
      private function onPresetPersistencyManagerReady(e:PresetPersistencyManagerEvent) : void
      {
         this.findPresetIndex();
      }
   }
}

