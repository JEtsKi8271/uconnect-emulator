package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
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
   import core.events.PopupManagerEvent;
   import decorators.ScrollerDecorator;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SatHomeScreen extends GenericScreen
   {
      
      private static const mMuteServiceName:String = "sdars";
      
      private static const mAudioMixerManagerInput:String = "SDARS1";
      
      private static var muteClientRegistered:Boolean = false;
      
      private static const APPSTATUS_NOTREADY:String = "NOT_READY";
      
      private static const APPSTATUS_READY:String = "READY";
      
      private static const APPSTATUS_COMM_ERROR:String = "COMM_ERROR";
      
      private static const APPSTATUS_FATAL_ERROR:String = "FATAL_ERROR";
      
      private static const APPSTATUS_SHUTDOWN_PENDING:String = "SHUTDOWN_PENDING";
      
      private static const APPSTATUS_SHUTDOWN_COMPLETE:String = "SHUTDOWN_COMPLETE";
      
      private static const REPLAY_TRANSPORT_LIVE:String = "live";
      
      private static const REPLAY_TRANSPORT_PLAY:String = "play";
      
      private static const REPLAY_TRANSPORT_PAUSED:String = "paused";
      
      private static const REPLAY_LABEL_LIVE:String = "live";
      
      private static const REPLAY_LABEL_PAUSED:String = "paused";
      
      private var assets:C_SatHome = new C_SatHome();
      
      private var mPresets:Vector.<Preset> = new Vector.<Preset>();
      
      private var mPresetsConverted:Array = new Array();
      
      private var mScreenFocusObject:FocusObject = null;
      
      public var mInReplayMode:Boolean = false;
      
      public var mCurrentSatChannelSID:int = -1;
      
      private var mReplayTransport:String = "live";
      
      private var mReplayThumbStatus:String = "";
      
      private var mChannelArtPath:String = "";
      
      private var mChannelArtLoader:Loader = new Loader();
      
      private var mCurrentSATPreset:int = -1;
      
      private var mError:Boolean = false;
      
      private var mFFActive:Boolean = false;
      
      private var mRWActive:Boolean = false;
      
      private var mSkippedChannel:Boolean = false;
      
      private var mChannelsAvailable:Boolean = false;
      
      private var mChannelArtTimer:Timer;
      
      private var mChannelArtToLoad:String = "";
      
      private var channelArt:Bitmap;
      
      public function SatHomeScreen()
      {
         mView = this.assets;
         cache = true;
         mView.doNotDecorate = true;
         super();
         this.assets.map.visible = false;
         this.assets.map_button.visible = false;
         this.assets.tag_button.visible = false;
         this.assets.favorites_button.visible = false;
         this.assets.displaySat.songTagIcon.visible = false;
         this.assets.displaySat.artistFavoriteIcon.visible = false;
         this.assets.displaySat.songFavoriteIcon.visible = false;
         this.assets.presets.nextPrevious_button.icon.gotoAndStop(1);
         this.assets.replay.visible = false;
         this.assets.replay.seekBackward_button.delay = Style.PlayerHomeScreen.PLAYER_LONG_PRESS_DELAY;
         this.assets.replay.seekForward_button.delay = Style.PlayerHomeScreen.PLAYER_LONG_PRESS_DELAY;
         this.assets.group_sources.button_aha.visible = Peripheral.audioManager.SOURCE_AHA != "null";
      }
      
      override protected function get persistentProperties() : Array
      {
         return ["mInReplayMode","mCurrentSatChannelSID","mReplayTransport"];
      }
      
      override public function screenIn() : void
      {
         this.mChannelArtTimer = new Timer(100,1);
         this.mChannelArtTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChannelArtTimerTimeout);
         this.registerMuteClient();
         super.screenIn();
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_DIRECT_TUNE);
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_SAT_FAV);
         Framework.popupManager.dequeue(DynamicPopupNames.SMALL);
         if(Framework.popupManager.active == DynamicPopupNames.RADIO_SAT_NOTREADY)
         {
            Framework.popupManager.taskComplete(null);
         }
         Framework.popupManager.dequeue(DynamicPopupNames.RADIO_SAT_NOTREADY);
         this.mChannelArtTimer.reset();
         this.mChannelArtTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onChannelArtTimerTimeout);
         this.checkSeekingState();
         this.mCurrentSATPreset = -1;
         this.mChannelArtToLoad = "";
         this.removeChannelArt();
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(this.assets.group_sources,WidgetEvent.CLICK,this.onSourceCLICK);
         attachListener(this.assets.map_button,WidgetEvent.CLICK,this.onMap);
         attachListener(this.assets.favorites_button,WidgetEvent.CLICK,this.onFavorites);
         attachListener(this.assets.browse_button,WidgetEvent.CLICK,this.onBrowse);
         attachListener(this.assets.replay_button,WidgetEvent.CLICK,this.onReplay);
         attachListener(this.assets.tune_button,WidgetEvent.CLICK,this.onTune);
         attachListener(this.assets.traffic_button,WidgetEvent.CLICK,this.onTraffic);
         attachListener(this.assets.audio_button,WidgetEvent.CLICK,this.onAudio);
         attachListener(this.assets.seekBackward_button,WidgetEvent.PRESS,this.onSatSeekDownButtonPress);
         attachListener(this.assets.seekBackward_button,WidgetEvent.RELEASE,this.onSatSeekUpDownButtonsRelease);
         attachListener(this.assets.seekForward_button,WidgetEvent.PRESS,this.onSatSeekUpButtonPress);
         attachListener(this.assets.seekForward_button,WidgetEvent.RELEASE,this.onSatSeekUpDownButtonsRelease);
         attachListener(this.assets.replay.playPause_button,WidgetEvent.CLICK,this.onPlayPause);
         attachListener(this.assets.replay.live_button,WidgetEvent.CLICK,this.onLive);
         attachListener(this.assets.replay.replay_scroller,WidgetEvent.POSITION,this.onReplayPosition);
         attachListener(this.assets.replay.replay_scroller,WidgetEvent.RELEASE,this.onReplayRelease);
         attachListener(this.assets.replay.seekBackward_button,WidgetEvent.CLICK,this.onReplaySeekBackward);
         attachListener(this.assets.replay.seekBackward_button,WidgetEvent.LONG_PRESS,this.onReplaySeekBackward);
         attachListener(this.assets.replay.seekBackward_button,WidgetEvent.RELEASE,this.onReplaySeekBackward);
         attachListener(this.assets.replay.seekForward_button,WidgetEvent.CLICK,this.onReplaySeekForward);
         attachListener(this.assets.replay.seekForward_button,WidgetEvent.LONG_PRESS,this.onReplaySeekForward);
         attachListener(this.assets.replay.seekForward_button,WidgetEvent.RELEASE,this.onReplaySeekForward);
         attachListener(Peripheral.satelliteRadioIR,SatelliteRadioInstantReplayEvent.PLAY_STATUS,this.onPlayStatus);
         attachListener(Peripheral.satelliteRadioIR,SatelliteRadioInstantReplayEvent.BUFFER_INFO,this.onBufferInfo);
         attachListener(Peripheral.satelliteRadioIR,SatelliteRadioInstantReplayEvent.BUFFER_WARNING,this.onBufferWarning);
         attachListener(Peripheral.satelliteRadioIR,SatelliteRadioInstantReplayEvent.BUFFER_FULL,this.onBufferFull);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.APP_STATUS,this.onSatAppStatus);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ADVISORY_MESSAGE,this.onAdvisoryMessage);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.CURRENT_CHANNEL,this.onCurrentChannel);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.AVAILABLE_CHANNELS,this.onAvailableChannel);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.TRAFFIC,this.onTrafficAlert);
         attachListener(Peripheral.audioManager,AudioEvent.AVAILABILITY,this.onSourceAvailability);
         attachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_INTERRUPT_SRC,this.onAudioInterruptSource);
         attachListener(this.assets.presets.nextPrevious_button,WidgetEvent.CLICK,this.onPresetPreviousNextButtonsClick);
         attachListener(this.assets.presets,WidgetEvent.LONG_PRESS,this.onPresetButtonLongPress);
         attachListener(this.assets.presets,WidgetEvent.CLICK,this.onPresetButtonClick);
         attachListener(Peripheral.presetPersistencyManager,PresetPersistencyManagerEvent.PRESETS,this.onPresets);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,this.onSelect);
         attachListener(Framework.popupManager,PopupManagerEvent.CLOSE,this.onPopupManagerClose);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Peripheral.satelliteRadio.removeInterest(SatelliteRadioEvent.ALL_AUDIO_FAVORITES);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.mScreenFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[this.assets.presets.item0_button,this.assets.presets.item1_button,this.assets.presets.item2_button,this.assets.presets.item3_button,this.assets.presets.item4_button,this.assets.presets.item5_button,this.assets.presets.nextPrevious_button,this.assets.replay.playPause_button,this.assets.replay.seekBackward_button,this.assets.replay.seekForward_button,this.assets.replay.live_button,this.assets.map_button,this.assets.favorites_button,this.assets.audio_button,this.assets.traffic_button,this.assets.seekForward_button,this.assets.tune_button,this.assets.seekBackward_button,this.assets.replay_button,this.assets.browse_button,this.assets.group_sources.button_aha,this.assets.group_sources.button_sxm,this.assets.group_sources.button_fm,this.assets.group_sources.button_am]);
         this.assets.favorites_button.visible = true;
         this.assets.tag_button.visible = false;
         this.assets.tag_button.setEnabled(false);
         this.assets.replay.replay_scroller.decoration = new ScrollerDecorator().decorate(this.assets.replay.replay_scroller);
         this.assets.replay.replay_scroller.setInteractive(true);
         this.assets.replay.replay_scroller.setEnabled(true);
         this.assets.replay.replay_scroller.setProgressTracksThumb(false);
         this.assets.replay.replay_scroller.setMaximum(100);
         this.assets.replay.replay_scroller.setPageSize(0);
         this.assets.replay.replay_scroller.setReportingPeriod(0);
         this.assets.presets.position = 0;
         this.assets.map.visible = false;
         this.assets.displaySat.songTagIcon.visible = false;
         this.assets.displaySat.songFavoriteIcon.visible = false;
         this.assets.displaySat.artistFavoriteIcon.visible = false;
         this.assets.group_sources.button_sxm.setHighlight(true);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mChannelsAvailable = Peripheral.satelliteRadio.channelNumberList.length > 0;
         this.showReplayPositionInfo();
         this.configureReplay(this.mInReplayMode,true);
         this.advisoryMessageHandler();
         this.onBufferInfo(null);
         Peripheral.appStateManager.lastSource = Peripheral.audioManager.SOURCE_SAT;
         Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_SAT);
         Peripheral.satelliteRadio.addInterest(SatelliteRadioEvent.ALL_AUDIO_FAVORITES);
         this.getPresets();
         this.mFFActive = false;
         this.mRWActive = false;
         this.assets.map_button.visible = Global.navActivated;
         if(!Global.navActivated)
         {
            attachListener(Peripheral.navigation.navDomainControl,NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavigationOperable,false,0,true);
         }
         this.map = Peripheral.appStateManager.splitScreenSource == "map";
         this.onAudioInterruptSource();
         Framework.structure.setExit();
         if(Peripheral.satelliteRadio.wasActiveChannelUnsubscribed)
         {
            Peripheral.satelliteRadio.wasActiveChannelUnsubscribed = false;
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SIRIUS_AUDIO_CHANNEL_NOT_SUBSCRIBED);
         }
         var curAppStatus:String = Peripheral.satelliteRadio.appStatus;
         switch(curAppStatus)
         {
            case APPSTATUS_NOTREADY:
            case APPSTATUS_READY:
               Peripheral.satelliteRadio.requestAppStatus();
               break;
            case APPSTATUS_COMM_ERROR:
            case APPSTATUS_FATAL_ERROR:
            case APPSTATUS_SHUTDOWN_PENDING:
            case APPSTATUS_SHUTDOWN_COMPLETE:
            default:
               this.handleAppStatus(curAppStatus);
         }
         Peripheral.appStateManager.recordSplitScreen();
         Framework.focusManager.addFocus(this.mScreenFocusObject);
      }
      
      private function showSatInitializingPopup() : void
      {
         t(this.assets.displaySat.labelGenre,"");
         t(this.assets.displaySat.labelChannelName,"");
         t(this.assets.displaySat.labelAlbumName,"");
         t(this.assets.displaySat.labelSongTitle,"");
         t(this.assets.displayPopupTitle.labelB,"");
         t(this.assets.displayPopupTitle.labelC,"");
         t(this.assets.displayPopupTitle.labelA,"");
         this.onErrorEntry();
         if(this.mInReplayMode)
         {
            this.configureReplay(false);
         }
         Framework.popupManager.show(DynamicPopupNames.RADIO_SAT_NOTREADY,"errorpopupscreen",{
            "type":PopupType.SECONDARY,
            "timeout":0,
            "body":T.STRB_SXM_NOT_AVAILABLE_PW,
            "background":false,
            "showClose":false
         });
         this.assets.replay_button.setEnabled(false);
         Framework.focusManager.refresh();
      }
      
      private function enablePresets(enabled:Boolean) : void
      {
         this.assets.presets.item0_button.setEnabled(enabled);
         this.assets.presets.item1_button.setEnabled(enabled);
         this.assets.presets.item2_button.setEnabled(enabled);
         this.assets.presets.item3_button.setEnabled(enabled);
         this.assets.presets.item4_button.setEnabled(enabled);
         this.assets.presets.item5_button.setEnabled(enabled);
         this.assets.presets.nextPrevious_button.setEnabled(enabled);
         this.assets.presets.noSignal = !enabled;
         this.updatePresets();
         Framework.focusManager.refresh();
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
         t(this.assets.map_button.label,T.STRB_MAP_2);
         t(this.assets.favorites_button.label,T.STRB_FAV);
         t(this.assets.group_sources.button_am.label,T.STRB_AM);
         t(this.assets.group_sources.button_fm.label,T.STRB_FM);
         t(this.assets.replay.seekBackward_button.label,T.STRB_RW);
         t(this.assets.replay.seekForward_button.label,T.STRB_FF);
         t(this.assets.replay.live_button.label,T.STRB_LIVE);
         t(this.assets.browse_button.label,T.STRB_BROWSE_SAT);
         t(this.assets.replay_button.label,T.STRB_REPLAY);
         t(this.assets.tune_button.label,T.STRB_TUNE_1);
         t(this.assets.audio_button.label,T.STRB_AUDIO_1);
         if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_PENDING")
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_PENDING);
         }
         else
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
         }
      }
      
      private function onSourceCLICK(e:WidgetEvent) : void
      {
         switch(e.data.name)
         {
            case "button_am":
               Peripheral.presetManager.allowPresetPageUpdate = true;
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_AM);
               break;
            case "button_fm":
               Peripheral.presetManager.allowPresetPageUpdate = true;
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_FM);
               break;
            case "button_sxm":
               break;
            case "button_aha":
               Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_AHA);
         }
      }
      
      private function onMap(e:WidgetEvent) : void
      {
         Peripheral.appStateManager.splitScreenSource = Peripheral.appStateManager.splitScreenSource == "map" ? "none" : "map";
         this.map = !this.assets.map.visible;
      }
      
      private function onFavorites(e:WidgetEvent) : void
      {
         Framework.popupManager.show(DynamicPopupNames.RADIO_SAT_FAV,"satfavpopupscreen",{
            "type":PopupType.OPTIONS,
            "timeout":Style.RadioHomeScreen.POPUP_TIMEOUT
         });
         this.assets.favorites_button.setHighlight(false);
      }
      
      private function onBrowse(e:WidgetEvent = null) : void
      {
         Framework.structure.goto(Screens.BROWSE_SAT);
      }
      
      private function onReplay(e:WidgetEvent = null) : void
      {
         if(this.mInReplayMode)
         {
            Peripheral.satelliteRadioIR.live();
         }
         this.advisoryMessageHandler();
         this.configureReplay(!this.mInReplayMode);
      }
      
      private function onAudio(e:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.SETTINGS_AUDIO);
      }
      
      private function onPlayPause(e:WidgetEvent) : void
      {
         if(Peripheral.satelliteRadioIR.IRPlayStatus.pauseStatus == "PAUSE")
         {
            this.replayPlay();
         }
         else
         {
            this.replayPause();
         }
         Peripheral.satelliteRadioIR.pausePlayRelease();
      }
      
      private function onBufferFull(e:SatelliteRadioInstantReplayEvent) : void
      {
         if(Peripheral.satelliteRadioIR.IRPlayStatus.pauseStatus == "PAUSE")
         {
            this.replayPlay();
            Peripheral.satelliteRadioIR.pausePlayRelease();
         }
      }
      
      private function replayPlay() : void
      {
         this.assets.replay.playPause_button.icon.gotoAndStop("playing");
         this.unmuteAudio();
         this.updateReplayText(this.getBufferPositionTimeText());
      }
      
      private function replayPause() : void
      {
         this.muteAudio();
         this.assets.replay.playPause_button.icon.gotoAndStop("pause");
         this.updateReplayText(REPLAY_LABEL_PAUSED);
      }
      
      private function onTune(e:WidgetEvent) : void
      {
         Framework.popupManager.show(DynamicPopupNames.RADIO_DIRECT_TUNE,"radiodirecttunepopup",{
            "type":PopupType.TUNE,
            "timeout":Style.RadioHomeScreen.POPUP_TIMEOUT
         });
      }
      
      private function onLive(e:WidgetEvent) : void
      {
         Peripheral.satelliteRadioIR.live();
      }
      
      private function onTraffic(e:WidgetEvent) : void
      {
         if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_MARKET_NOT_SELECTED")
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.TRAFFIC_AND_WEATHER_JUMP_UNDEFINED);
         }
         Peripheral.satelliteRadio.trafficJumpButtonPress();
      }
      
      private function onSatSeekDownButtonPress(e:WidgetEvent) : void
      {
         Peripheral.satelliteRadio.seekDown();
      }
      
      private function onSatSeekUpButtonPress(e:WidgetEvent) : void
      {
         Peripheral.satelliteRadio.seekUp();
      }
      
      private function onSatSeekUpDownButtonsRelease(e:WidgetEvent) : void
      {
         Peripheral.satelliteRadio.seekRelease();
      }
      
      private function onReplayPosition(e:WidgetEvent) : void
      {
         var scrollerPosition:Number = NaN;
         if(e != null)
         {
            scrollerPosition = Number(e.data);
            if(this.assets.replay.replay_scroller.getThumbDown())
            {
               Peripheral.satelliteRadioIR.seekToPosition(true,scrollerPosition);
            }
         }
         if(!this.assets.replay.replay_scroller.getThumbDown())
         {
            this.showReplayPositionInfo();
         }
      }
      
      private function showReplayPositionInfo() : void
      {
         var bufferPositionLabel:String = null;
         var isLive:Boolean = false;
         switch(this.mReplayTransport)
         {
            case REPLAY_TRANSPORT_PAUSED:
               bufferPositionLabel = REPLAY_LABEL_PAUSED;
               break;
            case REPLAY_TRANSPORT_LIVE:
               bufferPositionLabel = REPLAY_LABEL_LIVE;
               isLive = true;
               break;
            case REPLAY_TRANSPORT_PLAY:
               bufferPositionLabel = this.getBufferPositionTimeText();
         }
         this.updateReplayText(bufferPositionLabel);
         this.updateLiveButtonState(isLive);
      }
      
      private function updateLiveButtonState(isLive:Boolean) : void
      {
         this.assets.replay.live_button.setHighlight(isLive);
         this.assets.replay.live_button.mouseEnabled = !isLive;
      }
      
      private function getBufferPositionTimeText(bufferInfo:SatelliteRadioInstantReplayBufferInfo = null) : String
      {
         var bufferPositionText:String = "";
         if(bufferInfo == null)
         {
            bufferInfo = Peripheral.satelliteRadioIR.IRBufferInfo;
         }
         if(bufferInfo != null)
         {
            bufferPositionText = "-" + Format.timeDelta(((bufferInfo.hours * 60 + bufferInfo.minutes) * 60 + bufferInfo.seconds) * 1000);
         }
         return bufferPositionText;
      }
      
      private function onReplayRelease(e:WidgetEvent) : void
      {
         var scrollerPosition:Number = Number(this.assets.replay.replay_scroller.getHValue());
         Peripheral.satelliteRadioIR.seekToPosition(true,scrollerPosition);
      }
      
      private function onReplaySeekBackward(e:WidgetEvent) : void
      {
         if(e.type == WidgetEvent.LONG_PRESS)
         {
            this.muteAudio();
            Peripheral.satelliteRadioIR.RWPress();
            this.mRWActive = true;
         }
         else if(e.type == WidgetEvent.RELEASE)
         {
            Peripheral.satelliteRadioIR.RWRelease();
            this.unmuteAudio();
            this.mRWActive = false;
         }
         else if(e.type == WidgetEvent.CLICK)
         {
            if(Peripheral.satelliteRadioIR.IRBufferInfo.playbackPercent == 0)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
            Peripheral.satelliteRadioIR.seekPrevious();
         }
      }
      
      private function onReplaySeekForward(e:WidgetEvent) : void
      {
         if(e.type == WidgetEvent.LONG_PRESS)
         {
            if(Peripheral.satelliteRadioIR.IRPlayStatus.isLive)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
            else
            {
               this.muteAudio();
               Peripheral.satelliteRadioIR.FFPress();
               this.mFFActive = true;
            }
         }
         else if(e.type == WidgetEvent.RELEASE)
         {
            Peripheral.satelliteRadioIR.FFRelease();
            this.unmuteAudio();
            this.mFFActive = false;
         }
         else if(e.type == WidgetEvent.CLICK)
         {
            if(Peripheral.satelliteRadioIR.IRPlayStatus.isLive)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
            else
            {
               Peripheral.satelliteRadioIR.seekForward();
            }
         }
      }
      
      private function onPresets(e:PresetPersistencyManagerEvent) : void
      {
         this.getPresets();
      }
      
      private function getPresets() : void
      {
         var preset:Preset = null;
         this.mPresets.length = 0;
         this.mPresetsConverted.length = 0;
         this.mPresets = Peripheral.presetPersistencyManager.getFilteredPresets(Peripheral.audioManager.SOURCE_SAT);
         for each(preset in this.mPresets)
         {
            this.mPresetsConverted.push(preset);
         }
         this.updatePresets();
      }
      
      private function updatePresets() : void
      {
         this.assets.presets.selected = Peripheral.satelliteRadio.currentChannel.presetNum;
         this.assets.presets.data = this.mPresetsConverted.slice(this.assets.presets.position,this.assets.presets.position + this.assets.presets.LENGTH);
         Framework.focusManager.refresh();
      }
      
      private function onPresetPreviousNextButtonsClick(e:WidgetEvent = null) : void
      {
         this.assets.presets.position = this.assets.presets.position == 0 ? this.assets.presets.LENGTH : 0;
         this.updatePresets();
      }
      
      private function onPresetButtonClick(e:WidgetEvent) : void
      {
         var preset:Preset = this.mPresets[e.data.id];
         if(preset != null)
         {
            if(!preset.Active)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
            else
            {
               Peripheral.satelliteRadio.presetRecall(preset.Position);
            }
         }
      }
      
      private function onPresetButtonLongPress(e:WidgetEvent) : void
      {
         var presetId:int = int(e.data.id);
         this.mPresets[presetId].StationName = Peripheral.satelliteRadio.currentChannel.shortName;
         this.mPresets[presetId].Band = "sat";
         this.mPresets[presetId].Freq_Channel = Peripheral.satelliteRadio.currentChannel.number;
         this.mPresets[presetId].Active = true;
         var subSet:Vector.<Preset> = new Vector.<Preset>();
         subSet.push(this.mPresets[presetId]);
         var rtn:Boolean = Boolean(Peripheral.presetPersistencyManager.save(subSet));
         this.updatePresets();
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
      }
      
      private function onBufferWarning(e:SatelliteRadioInstantReplayEvent) : void
      {
         Ancillary.definedDynamicPopups.show(DynamicPopupNames.MAXIMUM_TIME_FOR_RADIO_PAUSE);
      }
      
      private function onBufferInfo(e:SatelliteRadioInstantReplayEvent) : void
      {
         var isThumbDown:Boolean = Boolean(this.assets.replay.replay_scroller.getThumbDown());
         if(!isThumbDown)
         {
            this.updateReplayFromBufferInfo(Peripheral.satelliteRadioIR.IRBufferInfo);
         }
         this.showReplayPositionInfo();
      }
      
      private function updateReplayFromBufferInfo(bufferInfo:SatelliteRadioInstantReplayBufferInfo) : void
      {
         this.assets.replay.replay_scroller.setValue(bufferInfo.playbackPercent);
         this.assets.replay.replay_scroller.setProgress(bufferInfo.fillPercent);
         this.assets.replay.replay_scroller.setHLimit(100 - bufferInfo.fillPercent);
      }
      
      private function onPlayStatus(e:SatelliteRadioInstantReplayEvent) : void
      {
         var playStatus:SatelliteRadioInstantReplayPlayStatus = e.mData as SatelliteRadioInstantReplayPlayStatus;
         if(this.mFFActive && Boolean(playStatus.isLive))
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
         if(playStatus.pauseStatus == "PLAY")
         {
            this.assets.replay.playPause_button.icon.gotoAndStop("playing");
            if(this.mReplayTransport != REPLAY_TRANSPORT_PLAY)
            {
               this.mReplayTransport = REPLAY_TRANSPORT_PLAY;
               if(!playStatus.RWActive)
               {
                  this.replayPlay();
               }
            }
            if(this.mInReplayMode && !this.mRWActive && !this.mFFActive)
            {
               this.unmuteAudio();
            }
         }
         else
         {
            this.mReplayTransport = REPLAY_TRANSPORT_PAUSED;
            this.assets.replay.playPause_button.icon.gotoAndStop("paused");
            this.updateReplayText(REPLAY_LABEL_PAUSED);
            if(this.mInReplayMode)
            {
               this.muteAudio();
            }
         }
         this.assets.replay.live_button.setHighlight(playStatus.isLive);
         this.assets.replay.live_button.mouseEnabled = !playStatus.isLive;
         if(playStatus.isLive)
         {
            this.mReplayTransport = REPLAY_TRANSPORT_LIVE;
            this.updateReplayText(REPLAY_LABEL_LIVE);
         }
         if(this.mRWActive)
         {
            if(playStatus.RWActive == false)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               this.mRWActive = false;
               if(Peripheral.satelliteRadioIR.IRBufferInfo.playbackPercent == 0)
               {
                  Peripheral.satelliteRadioIR.RWRelease();
                  this.unmuteAudio();
               }
            }
         }
      }
      
      private function onNavigationOperable(e:NavDomainControllerEvent) : void
      {
         this.map = Peripheral.appStateManager.splitScreenSource == "map";
      }
      
      private function set map(enable:Boolean) : void
      {
         this.assets.map_button.setHighlight(enable);
         this.assets.map.visible = enable;
         this.assets.displayPopupTitle.visible = enable;
         this.assets.displaySat.visible = !enable;
         Peripheral.personalConfig.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPLITSCREEN,{"mode":(enable ? "SPLIT" : "NORMAL")}));
         Framework.focusManager.refresh();
      }
      
      public function onSelect(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         if(!this.assets.replay.visible && !this.mError && Peripheral.bluetoothPhone.getRingingCall() == null)
         {
            this.onBrowse();
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
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
         Framework.focusManager.refresh();
      }
      
      private function onSatAppStatus(e:SatelliteRadioEvent) : void
      {
         var curAppStatus:String = e.data as String;
         Framework.Trace("AppStatus is now " + curAppStatus);
         this.handleAppStatus(curAppStatus);
      }
      
      private function handleAppStatus(appStatus:String) : void
      {
         switch(appStatus)
         {
            case APPSTATUS_READY:
               if(Framework.popupManager.active == DynamicPopupNames.RADIO_SAT_NOTREADY)
               {
                  Framework.popupManager.taskComplete(null);
               }
               Framework.popupManager.dequeue(DynamicPopupNames.RADIO_SAT_NOTREADY);
               this.advisoryMessageHandler();
               break;
            case APPSTATUS_SHUTDOWN_PENDING:
            case APPSTATUS_SHUTDOWN_COMPLETE:
               this.onErrorEntry();
               if(this.mInReplayMode)
               {
                  this.configureReplay(false);
               }
               this.assets.replay_button.setEnabled(false);
               break;
            case APPSTATUS_NOTREADY:
            case APPSTATUS_COMM_ERROR:
            case APPSTATUS_FATAL_ERROR:
            default:
               this.showSatInitializingPopup();
         }
      }
      
      private function onAvailableChannel(e:SatelliteRadioEvent) : void
      {
         this.mChannelsAvailable = true;
      }
      
      private function onCurrentChannel(e:SatelliteRadioEvent) : void
      {
         var channelArtToLoad:String = null;
         var currentChannel:SatelliteRadioChannel = null;
         if(e != null)
         {
            currentChannel = e.data as SatelliteRadioChannel;
         }
         if(currentChannel == null)
         {
            currentChannel = Peripheral.satelliteRadio.currentChannel;
         }
         if(currentChannel == null)
         {
            return;
         }
         var channelHasChanged:Boolean = this.mCurrentSatChannelSID != currentChannel.sid;
         if(channelHasChanged)
         {
            if(!Peripheral.satelliteRadioIR.IRPlayStatus.isLive || this.mInReplayMode)
            {
               this.configureReplay(false);
            }
            this.updatePresets();
            this.mCurrentSatChannelSID = currentChannel.sid;
            this.mReplayTransport = REPLAY_TRANSPORT_LIVE;
         }
         if(this.mError == false || this.mInReplayMode || Peripheral.satelliteRadio.currentChannel.number == 0)
         {
            this.assets.replay_button.setEnabled(this.isChannelReplayAvailable());
            this.assets.displaySat.labelSongTitle.x = this.assets.FIELD_X_DEFAULT;
            this.assets.displaySat.labelSongTitle.width = this.assets.FIELD_W_DEFAULT;
            t(this.assets.displaySat.labelAlbumName,currentChannel.artist);
            t(this.assets.displaySat.labelSongTitle,currentChannel.title);
            t(this.assets.displaySat.labelGenre,currentChannel.category);
            t(this.assets.displayPopupTitle.labelB,currentChannel.artist);
            t(this.assets.displayPopupTitle.labelC,currentChannel.title);
            if(currentChannel.name.length > 0)
            {
               t(this.assets.displaySat.labelChannelName,String(currentChannel.number + " " + currentChannel.name),TRUNCATE_WORDS);
               t(this.assets.displayPopupTitle.labelA,String(currentChannel.number + " " + currentChannel.name));
            }
            else
            {
               t(this.assets.displaySat.labelChannelName,"");
               t(this.assets.displayPopupTitle.labelA,"");
            }
            this.mChannelArtPath = currentChannel.logoUrl;
            channelArtToLoad = this.mChannelArtPath;
            if(this.mChannelArtPath.charAt(0) == "/" && this.mChannelArtPath.charAt(1) != "/")
            {
               channelArtToLoad = "/" + this.mChannelArtPath;
            }
            else if(this.mChannelArtPath.search("channelart") < 0)
            {
               channelArtToLoad = "//fs/mmc0/sdars/channelart/" + this.mChannelArtPath;
            }
            if(channelArtToLoad != this.mChannelArtToLoad || this.assets.displaySat.channelArt.numChildren == 0)
            {
               this.mChannelArtTimer.reset();
               this.mChannelArtToLoad = channelArtToLoad;
               this.assets.displaySat.channelArt.visible = false;
               this.mChannelArtTimer.start();
            }
            if(currentChannel.isArtistFavorite == true && Peripheral.satelliteRadio.appStatus == APPSTATUS_READY)
            {
               this.assets.displaySat.artistFavoriteIcon.visible = true;
            }
            else
            {
               this.assets.displaySat.artistFavoriteIcon.visible = false;
            }
            if(currentChannel.isSongFavorite == true && Peripheral.satelliteRadio.appStatus == APPSTATUS_READY)
            {
               this.showIconForTextfield(this.assets.displaySat.songFavoriteIcon,this.assets.displaySat.labelSongTitle);
               this.assets.displaySat.songFavoriteIcon.visible = true;
            }
            else
            {
               this.assets.displaySat.songFavoriteIcon.visible = false;
            }
            if(this.mCurrentSATPreset != currentChannel.presetNum)
            {
               this.mCurrentSATPreset = currentChannel.presetNum;
               this.ShowPresetBlock(this.mCurrentSATPreset);
            }
            if(channelHasChanged)
            {
               if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_PENDING")
               {
                  t(this.assets.traffic_button.label,T.STRB_TRAFFIC_PENDING);
               }
               else
               {
                  t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
               }
               if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_PENDING" || Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_IN_PROGRESS" || Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_COMPLETED")
               {
                  this.assets.traffic_button.setHighlight(true);
               }
               else
               {
                  this.assets.traffic_button.setHighlight(false);
               }
            }
         }
         else
         {
            this.advisoryMessageHandler();
         }
         Framework.focusManager.refresh();
      }
      
      private function onChannelArtTimerTimeout(e:TimerEvent) : void
      {
         if(System.freeMemory < 1500000)
         {
            System.gc();
         }
         this.mChannelArtTimer.stop();
         try
         {
            this.mChannelArtLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onChannelArtLoaded,false,0,true);
            this.mChannelArtLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onChannelArtError,false,0,true);
            this.mChannelArtLoader.load(new URLRequest(this.mChannelArtToLoad));
         }
         catch(err:Error)
         {
         }
      }
      
      private function ShowPresetBlock(presetIndex:int) : void
      {
         if(Peripheral.presetManager.isPresetPageUpdateAllowed == true)
         {
            Peripheral.presetManager.allowPresetPageUpdate = false;
            if(presetIndex != -1)
            {
               if(this.assets.presets.LENGTH <= presetIndex && this.assets.presets.position == 0)
               {
                  this.onPresetPreviousNextButtonsClick();
               }
               else if(this.assets.presets.LENGTH > presetIndex && this.assets.presets.position == this.assets.presets.LENGTH)
               {
                  this.onPresetPreviousNextButtonsClick();
               }
            }
         }
         this.updatePresets();
      }
      
      private function onTrafficAlert(e:SatelliteRadioEvent) : void
      {
         if(e.mData == SatelliteRadioEvent.TRAFFIC_ALERT_NO_MARKET)
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
            this.assets.traffic_button.setHighlight(false);
         }
         else if(e.mData == SatelliteRadioEvent.TRAFFIC_ALERT_PENDING)
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_PENDING);
            this.assets.traffic_button.setHighlight(true);
         }
         else if(e.mData == SatelliteRadioEvent.TRAFFIC_ALERT_IDLE)
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
            this.assets.traffic_button.setHighlight(false);
         }
         else if(e.mData == SatelliteRadioEvent.TRAFFIC_ALERT_START)
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
            this.assets.traffic_button.setHighlight(true);
         }
         else if(e.mData == SatelliteRadioEvent.TRAFFIC_ALERT_END)
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
            this.assets.traffic_button.setHighlight(true);
         }
      }
      
      private function onAdvisoryMessage(e:SatelliteRadioEvent) : void
      {
         this.advisoryMessageHandler();
      }
      
      private function advisoryMessageHandler() : void
      {
         this.mError = true;
         switch(Peripheral.satelliteRadio.advisoryMessage)
         {
            case SatAdvisoryMessageTypes.sNO_SIGNAL:
            case SatAdvisoryMessageTypes.sCHECK_ANTENNA:
               if(!this.isReplaying())
               {
                  this.onErrorEntry(true);
               }
               break;
            case SatAdvisoryMessageTypes.sSUPPRESSED_ANTENNA_ERROR:
               this.onErrorEntry(false);
               break;
            case SatAdvisoryMessageTypes.sSUBSCRIPTION_UPDATING:
               this.onErrorEntry();
               break;
            case SatAdvisoryMessageTypes.sCH_NOT_SUBSCRIBED:
            case SatAdvisoryMessageTypes.sACTIVE_CH_BECAME_UNSUBSCRIBED:
               Peripheral.satelliteRadio.wasActiveChannelUnsubscribed = false;
               break;
            case SatAdvisoryMessageTypes.sNO_ERROR:
            case SatAdvisoryMessageTypes.sSUBSCRIPTION_UPDATED:
               this.mError = false;
               this.onErrorExit();
         }
      }
      
      private function isReplaying() : Boolean
      {
         var replaying:Boolean = false;
         if(this.mInReplayMode && Peripheral.satelliteRadioIR.IRPlayStatus.isLive == false)
         {
            replaying = true;
         }
         return replaying;
      }
      
      private function onPopupManagerClose(e:PopupManagerEvent) : void
      {
         if(e.vars.id == DynamicPopupNames.SIRIUS_AUDIO_SKIPPED_CHANNEL)
         {
            this.mSkippedChannel = true;
         }
         else if(this.mSkippedChannel)
         {
            this.mSkippedChannel = false;
            this.mError = false;
            this.onCurrentChannel(null);
         }
      }
      
      private function onErrorEntry(allowReplay:Boolean = false) : void
      {
         this.assets.favorites_button.setEnabled(false);
         this.assets.replay_button.setEnabled(allowReplay);
         this.assets.browse_button.setEnabled(false);
         this.assets.seekBackward_button.setEnabled(false);
         this.assets.seekForward_button.setEnabled(false);
         this.assets.traffic_button.setEnabled(false);
         this.assets.displaySat.artistFavoriteIcon.visible = false;
         this.assets.displaySat.songFavoriteIcon.visible = false;
         this.assets.displaySat.songTagIcon.visible = false;
         this.enablePresets(false);
         Framework.focusManager.refresh();
      }
      
      private function onErrorExit() : void
      {
         this.onCurrentChannel(null);
         this.assets.favorites_button.setEnabled(true);
         this.enablePresets(true);
         if(this.mChannelsAvailable == true)
         {
            this.assets.browse_button.setEnabled(!this.mInReplayMode);
            this.assets.replay_button.setEnabled(this.isChannelReplayAvailable());
            this.assets.seekBackward_button.setEnabled(!this.mInReplayMode);
            this.assets.seekForward_button.setEnabled(!this.mInReplayMode);
            this.assets.traffic_button.setEnabled(!this.mInReplayMode);
         }
         if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_PENDING")
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_PENDING);
         }
         else
         {
            t(this.assets.traffic_button.label,T.STRB_TRAFFIC_AND_WEATHER);
         }
         if(Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_PENDING" || Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_IN_PROGRESS" || Peripheral.satelliteRadio.trafficJumpStatus == "JUMP_COMPLETED")
         {
            this.assets.traffic_button.setHighlight(true);
         }
         else
         {
            this.assets.traffic_button.setHighlight(false);
         }
         Framework.focusManager.refresh();
      }
      
      private function configureReplay(active:Boolean, restoring:Boolean = false) : void
      {
         this.mInReplayMode = this.isChannelReplayAvailable() ? active : false;
         this.assets.replay.visible = this.mInReplayMode;
         this.assets.presets.visible = !this.mInReplayMode;
         this.assets.replay_button.setHighlight(this.mInReplayMode);
         if(!this.mError)
         {
            this.assets.seekBackward_button.setEnabled(!this.mInReplayMode);
            this.assets.seekForward_button.setEnabled(!this.mInReplayMode);
            this.assets.traffic_button.setEnabled(!this.mInReplayMode);
            this.assets.tune_button.setEnabled(!this.mInReplayMode && this.mChannelsAvailable);
            this.assets.browse_button.setEnabled(!this.mInReplayMode && this.mChannelsAvailable);
         }
         else
         {
            this.assets.seekBackward_button.setEnabled(false);
            this.assets.seekForward_button.setEnabled(false);
            this.assets.tune_button.setEnabled(!this.mInReplayMode);
            this.assets.traffic_button.setEnabled(false);
            this.assets.browse_button.setEnabled(false);
         }
         if(this.mInReplayMode)
         {
            Peripheral.satelliteRadio.trafficJumpCancel();
            if(!restoring)
            {
               if(Peripheral.audioManager.isSourceMuted)
               {
                  Peripheral.satelliteRadioIR.pausePlayRelease();
                  this.assets.replay.playPause_button.icon.gotoAndStop("paused");
               }
               else
               {
                  Peripheral.satelliteRadioIR.live();
               }
            }
            else if(this.mReplayTransport == REPLAY_TRANSPORT_PAUSED)
            {
               this.assets.replay.playPause_button.icon.gotoAndStop("paused");
            }
            else
            {
               this.assets.replay.playPause_button.icon.gotoAndStop("playing");
            }
         }
         else if(restoring)
         {
            this.updateReplayText(REPLAY_LABEL_LIVE);
         }
         this.updateReplayFromBufferInfo(Peripheral.satelliteRadioIR.IRBufferInfo);
         this.showReplayPositionInfo();
         Framework.focusManager.refresh();
      }
      
      private function updateReplayText(text:String = null) : void
      {
         var scroller:MovieClip = this.assets.replay.replay_scroller;
         if(text != null)
         {
            switch(text)
            {
               case REPLAY_LABEL_LIVE:
                  t(scroller.thumb_label,T.STRB_LIVE_THUMB);
                  break;
               case REPLAY_LABEL_PAUSED:
                  t(scroller.thumb_label,T.STRB_PAUSED);
                  break;
               default:
                  t(scroller.thumb_label,text);
            }
            this.mReplayThumbStatus = text;
         }
         var textWidth:Number = Number(scroller.thumb_label.textWidth);
         var textPosition:Number = scroller.thumb.x + scroller.thumb.width / 2 - textWidth / 2;
         if(textPosition < scroller.track.x + Style.RadioHomeScreen.REPLAY_TEXT_PADDING)
         {
            textPosition = scroller.track.x + Style.RadioHomeScreen.REPLAY_TEXT_PADDING;
         }
         if(textPosition > scroller.track.x + scroller.track.width - Style.RadioHomeScreen.REPLAY_TEXT_PADDING - textWidth)
         {
            textPosition = scroller.track.x + scroller.track.width - Style.RadioHomeScreen.REPLAY_TEXT_PADDING - textWidth;
         }
         textPosition -= scroller.thumb_label.width / 2 - textWidth / 2;
         scroller.thumb_label.x = textPosition;
      }
      
      private function isChannelReplayAvailable() : Boolean
      {
         return Peripheral.satelliteRadio.appStatus == APPSTATUS_READY && Peripheral.satelliteRadio.currentChannel.number != 0;
      }
      
      private function showIconForTextfield(icon:MovieClip, textfield:TextField) : void
      {
         icon.visible = true;
         if(Boolean(this.assets.displaySat.songFavoriteIcon.visible) && Boolean(this.assets.displaySat.songTagIcon.visible))
         {
            this.assets.displaySat.songTagIcon.x = this.assets.ICON_X_INDENT;
            textfield.x = this.assets.FIELD_X_INDENT;
            textfield.width = this.assets.FIELD_W_INDENT;
            t(textfield,textfield.text);
         }
         else
         {
            icon.x = icon == this.assets.displaySat.songFavoriteIcon ? this.assets.FAV_X_DEFAULT : this.assets.TAG_X_DEFAULT;
            textfield.x = this.assets.FIELD_X_DEFAULT;
            textfield.width = this.assets.FIELD_W_DEFAULT;
            t(textfield,textfield.text);
         }
      }
      
      private function onChannelArtError(e:IOErrorEvent) : void
      {
         this.mChannelArtLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onChannelArtLoaded);
         this.mChannelArtLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onChannelArtError);
         Framework.Trace("ERROR: Could not load SDARS channel art : " + e.toString());
      }
      
      private function onChannelArtLoaded(e:Event) : void
      {
         var outOfBounds:Number = NaN;
         var scale:Number = NaN;
         this.mChannelArtLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onChannelArtLoaded);
         this.mChannelArtLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onChannelArtError);
         this.removeChannelArt();
         if(this.channelArt)
         {
            this.channelArt.bitmapData.dispose();
            this.channelArt = null;
         }
         this.channelArt = new Bitmap(e.target.content.bitmapData);
         this.mChannelArtLoader.unloadAndStop(true);
         if(this.channelArt.width > this.assets.CHANNEL_ART_SIZE || this.channelArt.height > this.assets.CHANNEL_ART_SIZE)
         {
            outOfBounds = this.channelArt.width > this.channelArt.height ? this.channelArt.width : this.channelArt.height;
            scale = this.assets.CHANNEL_ART_SIZE / outOfBounds;
            this.channelArt.scaleY = scale;
            this.channelArt.scaleX = scale;
            this.channelArt.smoothing = true;
         }
         this.channelArt.y = this.channelArt.height / -2;
         this.channelArt.x = this.channelArt.width / -2;
         this.assets.displaySat.channelArt.addChild(this.channelArt);
         this.assets.displaySat.channelArt.visible = true;
      }
      
      private function removeChannelArt() : void
      {
         while(this.assets.displaySat.channelArt.numChildren > 0)
         {
            this.assets.displaySat.channelArt.removeChildAt(0);
         }
      }
      
      private function registerMuteClient() : void
      {
         if(muteClientRegistered == false)
         {
            Peripheral.audioMixerManager.registerMuteClient(mMuteServiceName);
            muteClientRegistered = true;
         }
      }
      
      private function muteAudio() : void
      {
         Peripheral.audioMixerManager.setEntertainmentSrcMute(mAudioMixerManagerInput);
      }
      
      private function unmuteAudio() : void
      {
         Peripheral.audioMixerManager.setEntertainmentSrcUnmute(mAudioMixerManagerInput);
      }
      
      private function checkSeekingState() : void
      {
         if(Peripheral.satelliteRadio.seekStatus)
         {
            Peripheral.satelliteRadio.seekRelease();
         }
      }
   }
}

