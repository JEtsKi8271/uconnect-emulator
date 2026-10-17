package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.moduleLinkAPI.*;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import events.HardControlEvent;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   import skin.Skin;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class FMHomeScreen extends GenericScreen
   {
      
      private var assets:C_FMHomeScreen = new C_FMHomeScreen();
      
      private var mBrowseLock:Boolean = false;
      
      private var mSourceChangeInProgress:Boolean = false;
      
      private var mDirectTunePopupDelayTimer:Timer;
      
      private const mDirectTunePopupDelayTime:Number = 250;
      
      private var mPresetsPosition:Object = new Object();
      
      public function FMHomeScreen()
      {
         mView = this.assets;
         cache = true;
         mView.doNotDecorate = true;
         super();
         this.assets.group_sources.button_aha.visible = Peripheral.audioManager.SOURCE_AHA != "null";
      }
      
      override protected function get persistentProperties() : Array
      {
         return ["source"];
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_DIRECT_TUNE);
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_AF);
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_SAT_FAV);
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(this.assets.group_sources,WidgetEvent.CLICK,this.onSourceCLICK);
         attachListener(this.assets.map_button,WidgetEvent.CLICK,this.onMap);
         attachListener(this.assets.hd_button,WidgetEvent.CLICK,this.onHD);
         attachListener(this.assets.browse_button,WidgetEvent.CLICK,this.onBrowse);
         attachListener(this.assets.tune_button,WidgetEvent.CLICK,this.onTune);
         attachListener(this.assets.audio_button,WidgetEvent.CLICK,this.onAudio);
         attachListener(this.assets.seekForward_button,WidgetEvent.PRESS,this.onTunerSeekUpButtonPress);
         attachListener(this.assets.seekBackward_button,WidgetEvent.PRESS,this.onTunerSeekDownButtonPress);
         attachListener(this.assets.seekForward_button,WidgetEvent.RELEASE,this.onTunerSeekUpDownButtonsRelease);
         attachListener(this.assets.seekBackward_button,WidgetEvent.RELEASE,this.onTunerSeekUpDownButtonsRelease);
         attachListener(Peripheral.versionInfo,VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate);
         attachListener(this.assets.presets.nextPrevious_button,WidgetEvent.CLICK,this.onPresetPreviousNextButtonsClick);
         attachListener(this.assets.presets,WidgetEvent.LONG_PRESS,this.onPresetButtonLongPress);
         attachListener(this.assets.presets,WidgetEvent.CLICK,this.onPresetButtonClick);
         attachListener(Peripheral.presetPersistencyManager,PresetPersistencyManagerEvent.PRESETS,this.onPresets);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,this.onSelect);
         attachListener(Peripheral.tuner,TunerEvent.STATION_STEREO,this.onStationStereo,false,0,true);
         attachListener(Peripheral.tuner,TunerEvent.STATION_INFO,this.onStationInfo,false,0,true);
         attachListener(Peripheral.tuner,HdTunerEvent.HD_STATUS,this.onHdStatus,false,0,true);
         attachListener(Peripheral.tuner,HdTunerEvent.HD_STATION,this.onHdStationInfo,false,0,true);
         attachListener(Peripheral.tuner,TunerEvent.SEEK,this.onSeek,false,0,true);
         attachListener(Peripheral.tuner,HdTunerEvent.HD_TUNE,this.onHDTune,false,0,true);
         attachListener(Peripheral.tuner,HdTunerEvent.HD_PROGRAM_AVAIL,this.onHDProgramAvailability,false,0,true);
         attachListener(Peripheral.tuner,TunerEvent.PRESET_UPDATE,this.onPresetUpdate,false,0,true);
         attachListener(Peripheral.audioManager,AudioEvent.SOURCE,this.onSource);
         attachListener(Peripheral.audioManager,AudioEvent.AVAILABILITY,this.onSourceAvailability);
         attachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_INTERRUPT_SRC,this.onAudioInterruptSource);
         attachListener(Peripheral.vehConfig,VehConfigEvent.AVAILABLE,this.onVehicleConfigAvailable,false,0,true);
         attachListener(Peripheral.navigation.navDomainControl,NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavIsOperable,false,0,true);
         Peripheral.tuner.addEventListener(TunerEvent.STATION_TEXT,this.onStationText,false,0,true);
      }
      
      override protected function initView() : void
      {
         var button:MovieClip = null;
         super.initView();
         Peripheral.versionInfo.requestProductVariantID();
         this.assets.display.displayHD.visible = false;
         this.assets.tag_button.visible = false;
         this.assets.hd_button.visible = true;
         this.assets.presets.position = 0;
         var numPresetButtons:int = int(this.assets.presets.LENGTH);
         for(var i:int = 0; i < numPresetButtons; i++)
         {
            button = this.assets.presets["item" + i + "_button"];
            button.labelHoldToSet.visible = false;
            button.hd.visible = false;
         }
         this.mPresetsPosition[Peripheral.audioManager.SOURCE_FM] = 0;
         this.mPresetsPosition[Peripheral.audioManager.SOURCE_AM] = 0;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Framework.structure.setExit();
         Peripheral.appStateManager.lastSource = Peripheral.audioManager.source;
         this.assets.hd_button.visible = Peripheral.tuner.isHdAvailable;
         t(this.assets.display.labelFrequency,"");
         this.clearText();
         this.onSource(null);
         this.showHideSatButton();
         this.onAudioInterruptSource();
         this.assets.map_button.visible = Global.navActivated || Peripheral.appStateManager.splitScreenSource == "map";
         this.map = Peripheral.appStateManager.splitScreenSource == "map";
         Peripheral.appStateManager.recordSplitScreen();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[this.assets.presets.item0_button,this.assets.presets.item1_button,this.assets.presets.item2_button,this.assets.presets.item3_button,this.assets.presets.item4_button,this.assets.presets.item5_button,this.assets.presets.nextPrevious_button,this.assets.map_button,this.assets.tag_button,this.assets.hd_button,this.assets.audio_button,this.assets.seekForward_button,this.assets.tune_button,this.assets.seekBackward_button,this.assets.browse_button,this.assets.group_sources.button_aha,this.assets.group_sources.button_sxm,this.assets.group_sources.button_fm,this.assets.group_sources.button_am]));
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(this.assets.presets.item0_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.presets.item1_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.presets.item2_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.presets.item3_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.presets.item4_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.presets.item5_button.labelHoldToSet,T.STRB_HOLD_TO_SET_RADIOHOME);
         t(this.assets.display.displayHD.status_buffering,T.STRB_BUFFERING_2);
         t(this.assets.display.displayHD.status_stereo,T.STRB_ST);
         t(this.assets.display.displayHD.live,T.STRB_LIVE);
         t(this.assets.map_button.label,T.STRB_MAP_2);
         t(this.assets.group_sources.button_am.label,T.STRB_AM);
         t(this.assets.group_sources.button_fm.label,T.STRB_FM);
         t(this.assets.browse_button.label,T.STRB_BROWSE);
         t(this.assets.tune_button.label,T.STRB_TUNE_1);
         t(this.assets.audio_button.label,T.STRB_AUDIO_1);
      }
      
      private function onSourceCLICK(e:WidgetEvent) : void
      {
         switch(e.data.name)
         {
            case "button_am":
               this.mSourceChangeInProgress = true;
               Peripheral.presetManager.allowPresetPageUpdate = true;
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_AM);
               this.showCurrentSource(Peripheral.audioManager.SOURCE_AM);
               break;
            case "button_fm":
               this.mSourceChangeInProgress = true;
               Peripheral.presetManager.allowPresetPageUpdate = true;
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_FM);
               this.showCurrentSource(Peripheral.audioManager.SOURCE_FM);
               break;
            case "button_sxm":
               Peripheral.presetManager.allowPresetPageUpdate = true;
               Framework.structure.goto(Screens.MAIN_SAT);
               break;
            case "button_aha":
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_AHA);
         }
      }
      
      private function showCurrentSource(source:String) : void
      {
         switch(source)
         {
            case Peripheral.audioManager.SOURCE_AM:
               this.highlightModeButton("am");
               break;
            case Peripheral.audioManager.SOURCE_FM:
               Peripheral.tuner.getStationStereo();
               this.highlightModeButton("fm");
               break;
            default:
               return;
         }
         this.clearText();
         this.assets.display.displayHD.visible = false;
         this.updatePresets();
         this.onStationInfo(null);
         this.updateHDIconStatus();
      }
      
      private function onMap(e:WidgetEvent) : void
      {
         Peripheral.appStateManager.splitScreenSource = Peripheral.appStateManager.splitScreenSource == "map" ? "none" : "map";
         this.map = !this.assets.map.visible;
      }
      
      private function onHdButtonClick(e:WidgetEvent) : void
      {
         if(Peripheral.tuner.hdMode)
         {
            Peripheral.tuner.setHdMode(0);
         }
         else
         {
            Peripheral.tuner.setHdMode(1);
         }
      }
      
      private function onBrowse(e:WidgetEvent = null) : void
      {
         if(this.mBrowseLock == false)
         {
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
            Framework.structure.goto(Screens.BROWSE_FM);
         }
      }
      
      private function onTune(e:WidgetEvent) : void
      {
         if(this.mSourceChangeInProgress == false)
         {
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP_ON_STATION);
            this.openDirectTunePopup();
         }
         else
         {
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP_ON_STATION);
            this.mDirectTunePopupDelayTimer = new Timer(this.mDirectTunePopupDelayTime,1);
            this.mDirectTunePopupDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.directTunePopupDelayTimerTimeout);
            this.mDirectTunePopupDelayTimer.start();
         }
      }
      
      private function onAudio(e:WidgetEvent) : void
      {
         Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP_ON_STATION);
         Framework.structure.goto(Screens.SETTINGS_AUDIO);
      }
      
      private function onHD(e:WidgetEvent) : void
      {
         if(Peripheral.tuner.hdMode)
         {
            this.clearText();
            Peripheral.tuner.setHdMode(0);
         }
         else
         {
            Peripheral.tuner.setHdMode(1);
         }
      }
      
      private function onTunerSeekUpButtonPress(e:WidgetEvent) : void
      {
         Peripheral.tuner.setSeekPress(TunerSeek.sAUTO_UP);
      }
      
      private function onTunerSeekDownButtonPress(e:WidgetEvent) : void
      {
         Peripheral.tuner.setSeekPress(TunerSeek.sAUTO_DOWN);
      }
      
      private function onTunerSeekUpDownButtonsRelease(e:WidgetEvent) : void
      {
         Peripheral.tuner.setSeekRelease();
      }
      
      private function onPresets(e:PresetPersistencyManagerEvent) : void
      {
         this.updatePresets();
      }
      
      private function onPresetUpdate(e:TunerEvent) : void
      {
         this.ShowPresetBlock(this.getCurrentPresetPosition());
      }
      
      private function updatePresets() : void
      {
         var i:int = 0;
         var button:MovieClip = null;
         var preset:Preset = null;
         var band:String = Peripheral.audioManager.lastRadioSource;
         var start:int = int(this.mPresetsPosition[band]);
         var len:int = int(this.assets.presets.LENGTH);
         this.assets.presets.position = start;
         var curPreset:int = this.getCurrentPresetPosition();
         var presets:Vector.<Preset> = Peripheral.presetPersistencyManager.getFilteredPresets(band,start,len);
         if(Boolean(presets) && presets.length > 0)
         {
            for(i = 0; i < presets.length; i++)
            {
               button = this.assets.presets["item" + i + "_button"];
               preset = presets[i];
               if(preset.Active)
               {
                  button.beep = true;
                  button.hd.visible = false;
                  button.labelName.visible = true;
                  button.labelHoldToSet.visible = false;
                  if(preset.Band == "fm")
                  {
                     t(button.labelName,(preset.Freq_Channel * 0.001).toFixed(1));
                     if(preset.SubChannel > 1)
                     {
                        button.hd.visible = true;
                        t(button.labelName,button.labelName.text + "-" + preset.SubChannel);
                     }
                     else if(preset.Freq_Channel == Peripheral.tuner.frequency && (Peripheral.tuner.hdStatusMsg == HdStatus.HD_DIGITAL_AUDIO || Peripheral.tuner.hdStatusMsg == HdStatus.HD_BALLGAME_MODE))
                     {
                        button.hd.visible = true;
                     }
                  }
                  else if(preset.Band == "am")
                  {
                     t(button.labelName,String(preset.Freq_Channel));
                     button.hd.visible = Peripheral.tuner.hdStatusMsg == HdStatus.HD_DIGITAL_AUDIO && preset.Freq_Channel == Peripheral.tuner.frequency;
                  }
                  button.setHighlight(preset.Position == curPreset);
                  Skin.style.applyStyle(button.labelNbr,Skin.style.currentTheme.primaryText);
               }
               else
               {
                  button.beep = false;
                  button.hd.visible = false;
                  button.labelName.visible = false;
                  button.labelHoldToSet.visible = true;
                  button.setHighlight(false);
                  Skin.style.applyStyle(button.labelNbr,Skin.style.currentTheme.disabledText);
               }
            }
         }
      }
      
      private function onPresetPreviousNextButtonsClick(e:WidgetEvent = null) : void
      {
         var band:String = Peripheral.audioManager.lastRadioSource;
         var curPresetPosition:int = int(this.mPresetsPosition[band]);
         this.mPresetsPosition[band] = curPresetPosition == 0 ? this.assets.presets.LENGTH : 0;
         this.updatePresets();
      }
      
      private function onPresetButtonClick(e:WidgetEvent) : void
      {
         if(Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP) == true)
         {
            return;
         }
         var source:String = Peripheral.audioManager.lastRadioSource;
         var presets:Vector.<Preset> = Peripheral.presetPersistencyManager.getFilteredPresets(source);
         var preset:Preset = presets[e.data.id];
         var curPresetPosition:int = this.getCurrentPresetPosition();
         if(preset != null && Boolean(preset.Active) && preset.Position != curPresetPosition)
         {
            Peripheral.tuner.requestRecallPreset(preset.Position);
         }
         else if(preset == null || preset.Active == false)
         {
            Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
         }
      }
      
      private function onPresetButtonLongPress(e:WidgetEvent) : void
      {
         var presetId:int = 0;
         var preset:Preset = null;
         var subSet:Vector.<Preset> = null;
         var rtn:Boolean = false;
         if(Peripheral.tuner.seek != TunerSeek.sSTOP)
         {
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP_ON_STATION);
         }
         else
         {
            presetId = int(e.data.id);
            preset = new Preset();
            preset.StationName = Peripheral.tuner.stationName;
            preset.Band = Peripheral.audioManager.source;
            preset.Freq_Channel = Peripheral.tuner.frequency;
            preset.Genre = Peripheral.tuner.stationProgramType;
            preset.SubChannel = Peripheral.tuner.hdStatusMsg != HdStatus.HD_ANALOG_AUDIO && Peripheral.tuner.hdStatusMsg != HdStatus.HD_UNINITIALIZED ? int(Peripheral.tuner.currentHdSubchannel) : 0;
            preset.Active = true;
            preset.Position = presetId;
            subSet = new Vector.<Preset>();
            subSet.push(preset);
            rtn = Boolean(Peripheral.presetPersistencyManager.save(subSet));
            this.updatePresets();
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         }
      }
      
      private function setSeekState(seek:String) : void
      {
         if(seek == TunerSeek.sSTOP)
         {
            this.assets.seekForward_button.setHighlight(false);
            this.assets.seekBackward_button.setHighlight(false);
            this.updateHDIconStatus();
         }
         else if(seek == TunerSeek.sAUTO_UP)
         {
            this.clearText();
            this.assets.seekForward_button.setHighlight(false);
            this.assets.seekBackward_button.setHighlight(false);
         }
         else if(seek == TunerSeek.sAUTO_DOWN)
         {
            this.clearText();
            this.assets.seekForward_button.setHighlight(false);
            this.assets.seekBackward_button.setHighlight(false);
         }
      }
      
      private function updateHDIconStatus() : void
      {
         switch(Peripheral.tuner.hdStatusMsg)
         {
            case HdStatus.HD_UNINITIALIZED:
               Framework.Trace("<FMHomeScreen>.HD() : HD_UNINITIALIZED \n");
               this.assets.hd_button.setEnabled(false);
               this.onStationStereo();
               break;
            case HdStatus.HD_ANALOG_AUDIO:
               Framework.Trace("<FMHomeScreen>.HD() : HD_ANALOG_AUDIO \n");
               this.assets.hd_button.setEnabled(false);
               this.onStationStereo();
               break;
            case HdStatus.HD_MODE_OFF:
               Framework.Trace("<FMHomeScreen>.HD() : HD_MODE_OFF \n");
               this.assets.hd_button.setEnabled(true);
               this.assets.hd_button.setHighlight(false);
               this.onStationStereo();
               break;
            case HdStatus.HD_BUFFERING:
               Framework.Trace("<FMHomeScreen>.HD() : HD_BUFFERING \n");
               this.assets.display.displayHD.status_stereo.visible = false;
               this.assets.display.displayHD.status_buffering.visible = true;
               this.assets.display.displayHD.icon.visible = true;
               this.assets.display.displayHD.hd.visible = false;
               this.assets.display.displayHD.visible = true;
               this.assets.display.displayHD.live.visible = false;
               this.assets.hd_button.setEnabled(true);
               this.assets.hd_button.setHighlight(true);
               break;
            case HdStatus.HD_DIGITAL_AUDIO:
               Framework.Trace("<FMHomeScreen>.HD() : HD_DIGITAL_AUDIO \n");
               this.assets.display.displayHD.status_buffering.visible = false;
               this.assets.display.displayHD.status_stereo.visible = false;
               this.assets.display.displayHD.icon.visible = true;
               this.assets.display.displayHD.live.visible = false;
               this.assets.hd_button.setEnabled(true);
               this.assets.hd_button.setHighlight(true);
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
               {
                  if(Peripheral.tuner.programsAvailable.length != 0)
                  {
                     this.updateSPS(Peripheral.tuner.currentHdSubchannel);
                  }
               }
               else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AM)
               {
                  this.assets.display.displayHD.hd.visible = false;
                  this.assets.display.displayHD.visible = true;
               }
               break;
            case HdStatus.HD_BALLGAME_MODE:
               Framework.Trace("<FMHomeScreen>.HD() : HD_BALLGAME_MODE \n");
               this.assets.display.displayHD.status_buffering.visible = false;
               this.assets.display.displayHD.live.visible = true;
               this.assets.hd_button.setHighlight(true);
               break;
            default:
               Framework.Trace("<FMHomeScreen>.HD() : ERROR... hdStatusMsg:" + Peripheral.tuner.hdStatusMsg);
         }
      }
      
      private function onNavIsOperable(e:NavDomainControllerEvent) : void
      {
         this.assets.map_button.visible = Global.navActivated;
         this.map = Peripheral.appStateManager.splitScreenSource == "map";
      }
      
      private function onVehicleConfigAvailable(e:VehConfigEvent) : void
      {
         this.showHideSatButton();
      }
      
      private function onSource(e:AudioEvent) : void
      {
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_FM:
               Peripheral.tuner.requestStationInfo();
               Peripheral.tuner.requestHDStationInfo();
               Peripheral.tuner.requestHDStatusInfo();
               this.showCurrentSource(Peripheral.audioManager.source);
         }
      }
      
      private function onSourceAvailability(e:AudioEvent) : void
      {
         this.assets.group_sources.button_aha.visible = Peripheral.audioManager.SOURCE_AHA != "null";
      }
      
      private function onAudioInterruptSource(e:AudioMixerManagerEvent = null) : void
      {
         var allowed:Boolean = true;
         var amm:IAudioMixerManager = Peripheral.audioMixerManager;
         if(amm.interruptSource == amm.AMM_SOURCE_SIGNAL)
         {
            allowed = false;
         }
         this.assets.audio_button.setEnabled(allowed);
      }
      
      private function onStationInfo(evt:TunerEvent) : void
      {
         var band:String = Peripheral.tuner.band;
         var audioMngrBand:String = Peripheral.audioManager.source;
         if(band != Peripheral.tuner.translateAudioManagerBandToTunerBand(audioMngrBand))
         {
            t(this.assets.display.labelFrequency,"");
            this.clearText();
            Framework.popupManager.dequeue(DynamicPopupNames.RADIO_DIRECT_TUNE);
            this.assets.hd_button.setEnabled(false);
            this.assets.display.displayHD.visible = false;
            return;
         }
         var frequency:uint = uint(Peripheral.tuner.frequency);
         var frequencyString:String = "";
         var hdActive:Boolean = false;
         if(this.mSourceChangeInProgress == true)
         {
            this.mSourceChangeInProgress = false;
         }
         hdActive = Peripheral.tuner.hdStatusMsg == HdStatus.HD_DIGITAL_AUDIO || Peripheral.tuner.hdStatusMsg == HdStatus.HD_BUFFERING || Peripheral.tuner.hdStatusMsg == HdStatus.HD_BALLGAME_MODE;
         switch(band)
         {
            case TunerBand.AM:
               if(frequency > 0)
               {
                  frequencyString = String(frequency);
                  t(this.assets.display.labelFrequency,frequencyString);
                  t(this.assets.displaySplit.labelB,frequencyString);
               }
               if(hdActive)
               {
                  if(Peripheral.tuner.hdArtistName.length < 2)
                  {
                     t(this.assets.display.labelStationText,Peripheral.tuner.hdStationLongName);
                  }
                  else
                  {
                     t(this.assets.display.labelStationText,Peripheral.tuner.hdArtistName);
                     t(this.assets.displaySplit.labelA,Peripheral.tuner.hdPTY);
                  }
                  if(Peripheral.tuner.hdStationShortName.length > 2)
                  {
                     t(this.assets.display.labelStationName,Peripheral.tuner.hdStationShortName);
                     t(this.assets.displaySplit.labelB,Peripheral.tuner.hdStationShortName);
                  }
                  else
                  {
                     t(mView.display.labelStationName,"");
                  }
                  t(this.assets.display.labelStationText2,Peripheral.tuner.hdSongTitle);
                  t(this.assets.displaySplit.labelC,Peripheral.tuner.hdSongTitle);
                  if(Peripheral.tuner.hdPTY.length > 2)
                  {
                     t(this.assets.display.labelProgramType,Peripheral.tuner.hdPTY);
                  }
                  else
                  {
                     t(this.assets.display.labelProgramType,"");
                  }
               }
               else
               {
                  t(this.assets.display.labelProgramType,Peripheral.tuner.stationProgramType,TRUNCATE_WORDS);
                  t(this.assets.display.labelStationName,Peripheral.tuner.stationName,TRUNCATE_WORDS);
                  t(this.assets.display.labelStationText,Peripheral.tuner.stationText,TRUNCATE_WORDS);
                  t(this.assets.displaySplit.labelA,Peripheral.tuner.stationProgramType);
                  t(this.assets.displaySplit.labelC,Peripheral.tuner.stationText);
               }
               break;
            case TunerBand.FM:
               if(frequency > 0)
               {
                  frequencyString = Number(frequency * 0.001).toFixed(1);
                  t(this.assets.display.labelFrequency,frequencyString);
                  if(this.stripSpaces(Peripheral.tuner.stationName) == "")
                  {
                     t(this.assets.displaySplit.labelB,frequencyString);
                  }
                  if(!Peripheral.tuner.currentHDProgramAvailable)
                  {
                     this.showHdStationNotAvailable();
                     return;
                  }
               }
               if(hdActive)
               {
                  if(Peripheral.tuner.hdArtistName.length < 2)
                  {
                     t(this.assets.display.labelStationText,Peripheral.tuner.hdStationLongName);
                  }
                  else
                  {
                     t(this.assets.display.labelStationText,Peripheral.tuner.hdArtistName);
                     t(this.assets.displaySplit.labelA,Peripheral.tuner.hdPTY);
                  }
                  t(this.assets.display.labelStationText2,Peripheral.tuner.hdSongTitle);
                  t(this.assets.displaySplit.labelC,Peripheral.tuner.hdSongTitle);
                  if(Peripheral.tuner.hdStationShortName.length > 2)
                  {
                     t(this.assets.display.labelStationName,Peripheral.tuner.hdStationShortName);
                     t(this.assets.displaySplit.labelB,Peripheral.tuner.hdStationShortName);
                  }
                  else
                  {
                     t(this.assets.display.labelStationName,"");
                  }
                  if(Peripheral.tuner.hdPTY.length > 2)
                  {
                     t(this.assets.display.labelProgramType,Peripheral.tuner.hdPTY);
                  }
                  else
                  {
                     t(this.assets.display.labelProgramType,Peripheral.tuner.stationProgramType);
                  }
               }
               else
               {
                  t(this.assets.display.labelProgramType,Peripheral.tuner.stationProgramType,TRUNCATE_WORDS);
                  t(this.assets.displaySplit.labelA,Peripheral.tuner.stationProgramType);
                  t(this.assets.display.labelStationName,Peripheral.tuner.stationName,TRUNCATE_WORDS);
                  t(this.assets.display.labelStationText,Peripheral.tuner.stationText,TRUNCATE_WORDS);
                  if(this.stripSpaces(Peripheral.tuner.stationName) != "")
                  {
                     t(this.assets.displaySplit.labelB,Peripheral.tuner.stationName,TRUNCATE_WORDS);
                  }
                  if(this.stripSpaces(Peripheral.tuner.stationText).length != 0)
                  {
                     t(this.assets.displaySplit.labelC,Peripheral.tuner.stationText);
                  }
                  else
                  {
                     t(this.assets.displaySplit.labelC,Peripheral.tuner.stationText);
                  }
                  t(this.assets.display.labelStationText2,"");
               }
         }
         if(evt != null)
         {
            this.ShowPresetBlock(this.getCurrentPresetPosition());
         }
      }
      
      private function onStationStereo(evt:TunerEvent = null) : void
      {
         if(Peripheral.tuner.seek != TunerSeek.sSTOP)
         {
            this.assets.display.displayHD.visible = false;
            return;
         }
         if(Peripheral.tuner.hdStatusMsg != HdStatus.HD_BUFFERING && Peripheral.tuner.hdStatusMsg != HdStatus.HD_DIGITAL_AUDIO)
         {
            if(Peripheral.tuner.stationStereo == true && Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
            {
               this.assets.display.displayHD.status_stereo.visible = true;
               this.assets.display.displayHD.icon.visible = false;
               this.assets.display.displayHD.hd.visible = false;
               this.assets.display.displayHD.live.visible = false;
               this.assets.display.displayHD.status_buffering.visible = false;
               this.assets.display.displayHD.visible = true;
            }
            else
            {
               this.assets.display.displayHD.visible = false;
            }
         }
      }
      
      private function onSeek(evt:TunerEvent) : void
      {
         this.setSeekState(Peripheral.tuner.seek);
      }
      
      private function onHdStatus(e:HdTunerEvent) : void
      {
         this.updateHDIconStatus();
         this.updatePresets();
      }
      
      private function onHdStationInfo(e:HdTunerEvent) : void
      {
         if(Peripheral.tuner.programsAvailable.length > 0 && Peripheral.tuner.hdStatusMsg == HdStatus.HD_DIGITAL_AUDIO)
         {
            this.updateSPS(Peripheral.tuner.currentHdSubchannel);
            this.updatePresets();
         }
         this.onStationInfo(null);
      }
      
      private function onHDTune(e:HdTunerEvent) : void
      {
         this.clearText();
      }
      
      private function onHDProgramAvailability(e:HdTunerEvent) : void
      {
         if(!Peripheral.tuner.currentHDProgramAvailable)
         {
            this.showHdStationNotAvailable();
         }
         else
         {
            this.updateHDIconStatus();
         }
      }
      
      private function showHdStationNotAvailable() : void
      {
         this.updateSPS(Peripheral.tuner.currentHdSubchannel);
         this.clearText();
         t(this.assets.display.labelStationText,T.STRB_ERROR_BODY_HD_STATION_NA);
      }
      
      public function onSelect(e:HardControlEvent) : void
      {
         if(Peripheral.bluetoothPhone.getRingingCall() == null)
         {
            e.stopImmediatePropagation();
            this.onBrowse();
         }
      }
      
      private function set map(enable:Boolean) : void
      {
         this.assets.map_button.setHighlight(enable);
         this.assets.map.visible = enable;
         this.assets.displaySplit.visible = enable;
         this.assets.display.visible = !enable;
         Peripheral.personalConfig.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPLITSCREEN,{"mode":(enable ? "SPLIT" : "NORMAL")}));
      }
      
      private function onProductIDUpdate(e:VersionInfoEvent) : void
      {
         this.assets.hd_button.visible = Peripheral.tuner.isHdAvailable;
         this.showHideSatButton();
      }
      
      private function clearText() : void
      {
         t(this.assets.displaySplit.labelA,"");
         t(this.assets.displaySplit.labelB,"");
         t(this.assets.displaySplit.labelC,"");
         t(this.assets.display.labelStationText,"");
         t(this.assets.display.labelStationText2,"");
         t(this.assets.display.labelProgramType,"");
         t(this.assets.display.labelStationName,"");
      }
      
      private function highlightModeButton(audioMode:String) : void
      {
         if(audioMode == "fm")
         {
            this.assets.group_sources.button_am.setHighlight(false);
            this.assets.group_sources.button_fm.setHighlight(true);
         }
         else if(audioMode == "am")
         {
            this.assets.group_sources.button_am.setHighlight(true);
            this.assets.group_sources.button_fm.setHighlight(false);
         }
      }
      
      private function showHideSatButton() : void
      {
         this.assets.group_sources.button_sxm.visible = Peripheral.satelliteRadio.isAvailable;
      }
      
      private function directTunePopupDelayTimerTimeout(e:TimerEvent) : void
      {
         this.mSourceChangeInProgress = false;
         this.openDirectTunePopup();
      }
      
      private function openDirectTunePopup() : void
      {
         Framework.popupManager.show(DynamicPopupNames.RADIO_DIRECT_TUNE,"radiodirecttunepopup",{
            "type":PopupType.TUNE,
            "timeout":Style.RadioHomeScreen.POPUP_TIMEOUT
         });
      }
      
      private function updateSPS(spsChannel:int) : void
      {
         var programs:Vector.<int> = Peripheral.tuner.programsAvailable;
         var retval:int = programs.indexOf(spsChannel);
         if(retval != -1 && Boolean(Peripheral.tuner.currentHDProgramAvailable))
         {
            this.assets.display.displayHD.status_buffering.visible = false;
            this.assets.display.displayHD.visible = true;
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM && Peripheral.tuner.hdStatusMsg != HdStatus.HD_MODE_OFF)
            {
               this.assets.display.displayHD.hd.visible = true;
               this.assets.display.displayHD.hd.channels = Peripheral.tuner.programsAvailable;
               this.assets.display.displayHD.hd.active = spsChannel;
            }
            else
            {
               this.assets.display.displayHD.hd.visible = false;
            }
         }
         else if(retval == -1 && !Peripheral.tuner.currentHDProgramAvailable)
         {
            this.assets.display.displayHD.status_buffering.visible = false;
            this.assets.display.displayHD.visible = false;
         }
         else
         {
            this.assets.display.displayHD.status_stereo.visible = false;
            this.assets.display.displayHD.status_buffering.visible = true;
            this.assets.display.displayHD.hd.visible = false;
         }
      }
      
      private function ShowPresetBlock(presetPosition:int) : void
      {
         if(Peripheral.presetManager.isPresetPageUpdateAllowed == true && this.mSourceChangeInProgress == false)
         {
            Peripheral.presetManager.allowPresetPageUpdate = false;
            if(presetPosition != Peripheral.tuner.presetPositionNone)
            {
               if(this.assets.presets.LENGTH <= presetPosition && this.assets.presets.position == 0)
               {
                  this.onPresetPreviousNextButtonsClick();
               }
               else if(this.assets.presets.LENGTH > presetPosition && this.assets.presets.position == this.assets.presets.LENGTH)
               {
                  this.onPresetPreviousNextButtonsClick();
               }
            }
         }
         this.updatePresets();
      }
      
      private function getCurrentPresetPosition() : int
      {
         var audioManagerBand:String = Peripheral.audioManager.lastRadioSource;
         var tunerBand:String = Peripheral.tuner.translateAudioManagerBandToTunerBand(audioManagerBand);
         return int(Peripheral.tuner.bandPresetPosition(tunerBand));
      }
      
      private function stripSpaces(originalstring:String) : String
      {
         var original:Array = originalstring.split(" ");
         return original.join("");
      }
      
      private function onStationText(e:TunerEvent) : void
      {
         if(Peripheral.tuner.supportRDS)
         {
            t(mView.displayFm.labelStationText,Peripheral.tuner.stationText,TRUNCATE_WORDS);
            t(mView.displayPopupTitle.labelB,Peripheral.tuner.stationName);
            t(mView.displayPopupTitle.labelC,Peripheral.tuner.stationText);
            t(mView.displayFm.labelStationText2,"");
         }
      }
   }
}

