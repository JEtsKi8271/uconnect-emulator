package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AudioMixerManagerEvent;
   import com.harman.moduleLinkAPI.IAudioMixerManager;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.utils.Text;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class AudioSettingScreen extends GenericScreen
   {
      
      private static var mButtonListFocusObject:FocusObject = null;
      
      private static var mOptionListFocusObject:FocusObject = null;
      
      private static var mEQTrackFocusObject:FocusObject = null;
      
      private var mIgnoreAudioBalanceFade:Boolean = false;
      
      private var mIgnoreBalanceFadeTimer:Timer = new Timer(2000);
      
      private var mReportBalanceFadeTimer:Timer = new Timer(400);
      
      private var mBalance:int = 9;
      
      private var mFade:int = 9;
      
      private const LEVELS:Array = [-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
      
      private const AUX_VOL:Array = ["-3","-2","-1","0","+1","+2","+3"];
      
      private const MID_RANGE:int = 9;
      
      private const TREB_RANGE:int = 9;
      
      private const BASS_RANGE:int = 9;
      
      private const AUX_RANGE:int = 3;
      
      private var prevOptionName:String = "off_button";
      
      private var mIndex:int = 0;
      
      private var mSettingShown:int = 0;
      
      private var mSettings:Array = new Array();
      
      private var mButtons:Array = new Array();
      
      private var mButtonDownValue:int = 0;
      
      public function AudioSettingScreen()
      {
         mView = new C_AudioSettingsScreenView();
         super();
      }
      
      override protected function initView() : void
      {
         var name:String = null;
         var auxScroller:MovieClip = null;
         var aScroller:MovieClip = null;
         super.initView();
         var _nbrOfSeats:String = "four";
         if(Peripheral.vehConfig.bodyStyle == "6" && (Peripheral.vehConfig.vehicleLine == "DS" || Peripheral.vehConfig.vehicleLine == "DJ" || Peripheral.vehConfig.vehicleLine == "DD" || Peripheral.vehConfig.vehicleLine == "DP" || Peripheral.vehConfig.vehicleLine == "D2" || Peripheral.vehConfig.vehicleLine == "DX" || Peripheral.vehConfig.vehicleLine == "DF") || Peripheral.vehConfig.vehicleLine == "ZD")
         {
            _nbrOfSeats = "two";
         }
         else if(Peripheral.vehConfig.vehicleLine == "RU")
         {
            _nbrOfSeats = "seven";
         }
         mView.optionOverlays_group.balanceFade_group.seats.gotoAndStop(_nbrOfSeats);
         mView.optionOverlays_group.balanceFade_group.upArrow.auto = 200;
         mView.optionOverlays_group.balanceFade_group.leftArrow.auto = 200;
         mView.optionOverlays_group.balanceFade_group.downArrow.auto = 200;
         mView.optionOverlays_group.balanceFade_group.rightArrow.auto = 200;
         mView.optionOverlays_group.equalizer_group.bass_scroller.setValue(-Peripheral.audioSettings.bass * this.BASS_RANGE);
         mView.optionOverlays_group.equalizer_group.mid_scroller.setValue(-Peripheral.audioSettings.mid * this.MID_RANGE);
         mView.optionOverlays_group.equalizer_group.treble_scroller.setValue(-Peripheral.audioSettings.treble * this.TREB_RANGE);
         this.updateBass();
         this.updateMid();
         this.updateTreble();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_AUDIO_BREADCRUMB,Breadcrumb.INERT));
         for each(name in ["bass_scroller","mid_scroller","treble_scroller"])
         {
            aScroller = mView.optionOverlays_group.equalizer_group[name];
            aScroller.setMinimum(-9.5);
            aScroller.setMaximum(10.49999999);
            aScroller.setPageSize(1);
            aScroller.setSensitiveTrack(true);
            aScroller.setReportingPeriod(500);
            aScroller.setValue(0);
         }
         auxScroller = mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller;
         auxScroller.setMinimum(0);
         auxScroller.setMaximum(this.AUX_VOL.length);
         auxScroller.setPageSize(1);
         auxScroller.setSensitiveTrack(true);
         auxScroller.setReportingPeriod(500);
         auxScroller.setValue(0);
         mView.optionOverlays_group.speedAdjustedVolume_group.setRadioButtons(true);
         mView.optionOverlays_group.speedAdjustedVolume_group.setRequireSelection(true);
         mView.optionOverlays_group.surroundSound_group.setRadioButtons(true);
         mView.optionOverlays_group.surroundSound_group.seats.gotoAndStop(_nbrOfSeats);
         this.mSettings.push(T.STRB_AS_BALANCE_FADE);
         this.mSettings.push(T.STRB_AS_EQUALIZER);
         if(!Peripheral.audioSettings.boosterAmpPresent)
         {
            this.mSettings.push(T.STRB_AS_SPEED_ADJ_VOL);
         }
         if(!Peripheral.audioSettings.boosterAmpPresent && Boolean(Peripheral.vehConfig.hasAmp) && Boolean(Peripheral.vehConfig.hasSurroundSound))
         {
            this.mSettings.push(T.STRB_AS_SURROUND);
         }
         this.mSettings.push(T.STRB_AUX_VOLUME_OFFSET_BASE);
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            this.mSettings.push(T.STRB_SETTINGS_AUTO_ON_RADIO);
         }
         this.mSettings.push(T.STRB_AUTO_PLAY);
         this.mButtons.push(mView.optionButtons_group.setting0_button);
         this.mButtons.push(mView.optionButtons_group.setting1_button);
         this.mButtons.push(mView.optionButtons_group.setting2_button);
         this.mButtons.push(mView.optionButtons_group.setting3_button);
         if(this.mSettings.length < 6)
         {
            mView.page_button.visible = false;
            this.mButtons.push(mView.optionButtons_group.setting4_button);
         }
         else
         {
            mView.page_button.visible = true;
            mView.optionButtons_group.setting4_button.visible = false;
         }
         this.mSettingShown = T.STRB_AS_BALANCE_FADE;
      }
      
      override public function screenOut() : void
      {
         this.mIgnoreBalanceFadeTimer.reset();
         this.mReportBalanceFadeTimer.reset();
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.close_button,MouseEvent.CLICK,close,false,0,true);
         attachListener(mView.back_button,MouseEvent.CLICK,this.back,false,0,true);
         attachListener(mView.page_button,WidgetEvent.CLICK,this.onPageButton,false,0,true);
         attachListener(mView.optionButtons_group.setting0_button,WidgetEvent.CLICK,this.onOptionButton,false,0,true);
         attachListener(mView.optionButtons_group.setting1_button,WidgetEvent.CLICK,this.onOptionButton,false,0,true);
         attachListener(mView.optionButtons_group.setting2_button,WidgetEvent.CLICK,this.onOptionButton,false,0,true);
         attachListener(mView.optionButtons_group.setting3_button,WidgetEvent.CLICK,this.onOptionButton,false,0,true);
         attachListener(mView.optionButtons_group.setting4_button,WidgetEvent.CLICK,this.onOptionButton,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.upArrow,WidgetEvent.CLICK,this.onBalanceFadeFront,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.downArrow,WidgetEvent.CLICK,this.onBalanceFadeRear,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.leftArrow,WidgetEvent.CLICK,this.onBalanceFadeLeft,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.rightArrow,WidgetEvent.CLICK,this.onBalanceFadeRight,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.track,MouseEvent.MOUSE_DOWN,this.onBalanceFadeDown,false,0,true);
         attachListener(mView.optionOverlays_group.balanceFade_group.center_button,WidgetEvent.CLICK,this.onBalanceFadeCenter,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller,MouseEvent.CLICK,this.onScrollerSelected,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller,WidgetEvent.POSITION,this.setBass,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller.track,MouseEvent.MOUSE_DOWN,this.startEqualizer,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller,MouseEvent.CLICK,this.onScrollerSelected,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller,WidgetEvent.POSITION,this.setMid);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller.track,MouseEvent.MOUSE_DOWN,this.startEqualizer,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller,MouseEvent.CLICK,this.onScrollerSelected,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller,WidgetEvent.POSITION,this.setTreble);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller.track,MouseEvent.MOUSE_DOWN,this.startEqualizer,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller.upArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller.downArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller.upArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller.downArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller.upArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller.downArrow_button,WidgetEvent.CLICK,this.setLastEQVal,false,0,true);
         attachListener(mView.optionOverlays_group.speedAdjustedVolume_group,WidgetEvent.SELECT,this.setSpeedAdjustedVolume);
         attachListener(mView.optionOverlays_group.surroundSound_group,WidgetEvent.SELECT,this.setSurroundSound);
         attachListener(mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller,WidgetEvent.POSITION,this.setAuxVolumeOffset);
         attachListener(mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.track,MouseEvent.MOUSE_DOWN,this.startAuxVolumeOffset,false,0,true);
         attachListener(mView.optionOverlays_group.autoOnRadio_group.on_button,WidgetEvent.CLICK,this.setAutoOnRadio);
         attachListener(mView.optionOverlays_group.autoOnRadio_group.off_button,WidgetEvent.CLICK,this.setAutoOnRadio);
         attachListener(mView.optionOverlays_group.autoOnRadio_group.recall_button,WidgetEvent.CLICK,this.setAutoOnRadio);
         attachListener(mView.optionOverlays_group.AutoPlayAudio_group.on_button,WidgetEvent.CLICK,this.setAutoPlayOn);
         attachListener(mView.optionOverlays_group.AutoPlayAudio_group.off_button,WidgetEvent.CLICK,this.setAutoPlayOff);
         attachListener(Peripheral.audioSettings,AudioEvent.AUTOPLAYSTATUS,this.onAudioEventAutoPlayStatus,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.INTERRUPT_STATUS,this.audioInterruptStatus,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.SPEED,this.onAudioEventSpeed,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.EQUALIZER,this.onAudioEventEqualizer,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.BALANCEFADE,this.onAudioEventBalanceFade,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.SURROUNDSOUNDSTATUS,this.onAudioEventSurroundSoundStatus,false,0,true);
         attachListener(Peripheral.audioSettings,AudioEvent.SURROUNDSOUNDAVAILABLE,this.onAudioEventSurroundSoundAvailable,false,0,true);
         attachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET,this.onAMMAuxVolumeOffset,false,0,true);
         attachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_INTERRUPT_SRC,this.onAudioInterruptSource,false,0,true);
         attachListener(this.mIgnoreBalanceFadeTimer,TimerEvent.TIMER,this.onIgnoreBalanceFadeTimer,false,0,true);
         attachListener(this.mReportBalanceFadeTimer,TimerEvent.TIMER,this.onReportBalanceFadeTimer,false,0,true);
         attachListener(Peripheral.personalConfig,PersonalConfigEvent.AUTOSWITCH,this.onAutoOnRadio,false,0,true);
      }
      
      override protected function back(e:Event = null) : void
      {
         if(Framework.structure.historyIndexOf(Screens.SETTINGS_SCREEN) == 1)
         {
            Peripheral.listController.usePreviousIndex();
         }
         Framework.structure.back();
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         Text.format(mView.optionOverlays_group.surroundSound_group.on_button.value_label,T.STRB_AS_ON);
         Text.format(mView.optionOverlays_group.surroundSound_group.off_button.value_label,T.STRB_AS_OFF);
         Text.format(mView.optionOverlays_group.speedAdjustedVolume_group.off_button.value_label,T.STRB_AS_OFF);
         Text.format(mView.optionOverlays_group.speedAdjustedVolume_group.level1_button.value_label,"1");
         Text.format(mView.optionOverlays_group.speedAdjustedVolume_group.level2_button.value_label,"2");
         Text.format(mView.optionOverlays_group.speedAdjustedVolume_group.level3_button.value_label,"3");
         Text.format(mView.optionOverlays_group.balanceFade_group.upArrow.label,T.STRB_AS_FRONT);
         Text.format(mView.optionOverlays_group.balanceFade_group.leftArrow.label,T.STRB_AS_LEFT);
         Text.format(mView.optionOverlays_group.balanceFade_group.downArrow.label,T.STRB_AS_REAR);
         Text.format(mView.optionOverlays_group.balanceFade_group.rightArrow.label,T.STRB_AS_RIGHT);
         Text.format(mView.optionOverlays_group.balanceFade_group.center_button.value_label,T.STRB_AS_C);
         Text.format(mView.optionOverlays_group.speedAdjustedVolume_group.description_translate,T.STRB_AS_INCREASES_VOL);
         Text.format(mView.optionOverlays_group.surroundSound_group.description_translate,T.STRB_AS_SURROUND_NOT_AVAIL);
         Text.format(mView.optionOverlays_group.equalizer_group.bass_translate,T.STRB_AS_BASS);
         Text.format(mView.optionOverlays_group.equalizer_group.mid_translate,T.STRB_AS_MID);
         Text.format(mView.optionOverlays_group.equalizer_group.treble_translate,T.STRB_AS_TREB);
         Text.format(mView.optionOverlays_group.auxVolumeOffset_group.title,T.STRB_AUX_VOLUME_OFFSET_BASE);
         Text.format(mView.optionOverlays_group.auxVolumeOffset_group.description,T.STRB_AUX_VOLUME_OFFSET_DESC_BASE);
         Text.format(mView.optionOverlays_group.autoOnRadio_group.on_button.value_label,T.STRB_AS_ON);
         Text.format(mView.optionOverlays_group.autoOnRadio_group.off_button.value_label,T.STRB_AS_OFF);
         Text.format(mView.optionOverlays_group.autoOnRadio_group.recall_button.value_label,T.STRB_RECALL_LAST);
         Text.format(mView.optionOverlays_group.autoOnRadio_group.description,T.STRB_AUTO_ON_RADIO_DESCRIPTION);
         Text.format(mView.optionOverlays_group.AutoPlayAudio_group.on_button.value_label,T.STRB_AS_ON);
         Text.format(mView.optionOverlays_group.AutoPlayAudio_group.off_button.value_label,T.STRB_AS_OFF);
         Text.format(mView.optionOverlays_group.AutoPlayAudio_group.description,T.STRB_AUTO_PLAY_EXPLANATION);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mIgnoreAudioBalanceFade = false;
         this.onAudioEventSurroundSoundAvailable(null);
         this.onAudioEventSurroundSoundStatus(null);
         this.onAudioEventBalanceFade(null);
         this.onAudioEventEqualizer(null);
         this.onAudioEventSpeed(null);
         this.onAudioEventAutoPlayStatus(null);
         this.onAutoOnRadio(null);
         Peripheral.audioMixerManager.getAuxVolumeOffset();
         if(!Peripheral.voiceRecognition.VRSessionInProgress)
         {
            mView.optionOverlays_group.balanceFade_group.setInteractive(true);
            mView.optionOverlays_group.balanceFade_group.downArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.upArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.leftArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.rightArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.center_button.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.center_button.setInteractive(true);
            mView.optionOverlays_group.equalizer_group.setInteractive(true);
         }
         this.mSettingShown = T.STRB_AS_BALANCE_FADE;
         this.setIndex(0);
         if(mView.page_button.visible == true)
         {
            mView.page_button.icon.gotoAndStop(1);
         }
         this.mBalance = this.LEVELS.indexOf(Peripheral.audioSettings.balance);
         this.mFade = this.LEVELS.indexOf(-Peripheral.audioSettings.fade);
         mView.mMouseX = this.mBalance * mView.INC + mView.mTrackMinX;
         mView.mMouseY = this.mFade * mView.INC + mView.mTrackMinY;
         this.updateCoordinates(mView.mMouseX,mView.mMouseY);
         this.initSetFocus();
      }
      
      private function initSetFocus() : void
      {
         var mFocusArray:Array = new Array();
         mFocusArray.push(mView.optionOverlays_group.balanceFade_group.upArrow);
         mFocusArray.push(mView.optionOverlays_group.balanceFade_group.rightArrow);
         mFocusArray.push(mView.optionOverlays_group.balanceFade_group.downArrow);
         mFocusArray.push(mView.optionOverlays_group.balanceFade_group.leftArrow);
         mFocusArray.push(mView.optionOverlays_group.equalizer_group.bass_scroller);
         mFocusArray.push(mView.optionOverlays_group.equalizer_group.mid_scroller);
         mFocusArray.push(mView.optionOverlays_group.equalizer_group.treble_scroller);
         mFocusArray.push(mView.optionOverlays_group.speedAdjustedVolume_group.off_button);
         mFocusArray.push(mView.optionOverlays_group.speedAdjustedVolume_group.level1_button);
         mFocusArray.push(mView.optionOverlays_group.speedAdjustedVolume_group.level2_button);
         mFocusArray.push(mView.optionOverlays_group.speedAdjustedVolume_group.level3_button);
         mFocusArray.push(mView.optionOverlays_group.surroundSound_group.on_button);
         mFocusArray.push(mView.optionOverlays_group.surroundSound_group.off_button);
         mFocusArray.push(mView.optionOverlays_group.loudness_group.on_button);
         mFocusArray.push(mView.optionOverlays_group.loudness_group.off_button);
         mFocusArray.push(mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.leftArrow_button);
         mFocusArray.push(mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.rightArrow_button);
         mFocusArray.push(mView.optionOverlays_group.autoOnRadio_group.on_button);
         mFocusArray.push(mView.optionOverlays_group.autoOnRadio_group.off_button);
         mFocusArray.push(mView.optionOverlays_group.autoOnRadio_group.recall_button);
         mFocusArray.push(mView.optionOverlays_group.AutoPlayAudio_group.on_button);
         mFocusArray.push(mView.optionOverlays_group.AutoPlayAudio_group.off_button);
         mOptionListFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,mFocusArray);
         Framework.focusManager.addFocus(mOptionListFocusObject);
         var mOptionBtnFocusArray:Array = new Array();
         mOptionBtnFocusArray.push(mView.optionButtons_group.setting0_button);
         mOptionBtnFocusArray.push(mView.optionButtons_group.setting1_button);
         mOptionBtnFocusArray.push(mView.optionButtons_group.setting2_button);
         mOptionBtnFocusArray.push(mView.optionButtons_group.setting3_button);
         mOptionBtnFocusArray.push(mView.optionButtons_group.setting4_button);
         mOptionBtnFocusArray.push(mView.page_button);
         mButtonListFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,mOptionBtnFocusArray);
         Framework.focusManager.addFocus(mButtonListFocusObject);
      }
      
      private function setIndex(_index:int) : void
      {
         this.mIndex = _index;
         var k:int = _index;
         for(var i:int = 0; i < this.mButtons.length; i++)
         {
            if(k < this.mSettings.length)
            {
               this.mButtons[i].visible = true;
               this.mButtons[i].id = this.mSettings[k];
               Text.format(this.mButtons[i].value_label,this.mSettings[k]);
            }
            else
            {
               this.mButtons[i].id = -1;
               this.mButtons[i].visible = false;
            }
            k++;
         }
         this.onSetting(this.mSettingShown);
      }
      
      private function onPageButton(e:WidgetEvent) : void
      {
         if(this.mIndex == 0)
         {
            mView.page_button.icon.gotoAndStop(2);
            this.setIndex(4);
            if(mEQTrackFocusObject != null)
            {
               Framework.focusManager.delFocus(mEQTrackFocusObject);
            }
            Framework.focusManager.delFocus(mButtonListFocusObject);
            mButtonListFocusObject.priority = FocusPriority.REGULAR;
            Framework.focusManager.addFocus(mButtonListFocusObject);
         }
         else
         {
            mView.page_button.icon.gotoAndStop(1);
            this.setIndex(0);
            if(mEQTrackFocusObject != null)
            {
               Framework.focusManager.delFocus(mEQTrackFocusObject);
            }
            Framework.focusManager.delFocus(mButtonListFocusObject);
            mButtonListFocusObject.priority = FocusPriority.REGULAR;
            Framework.focusManager.addFocus(mButtonListFocusObject);
         }
      }
      
      private function onOptionButton(e:WidgetEvent) : void
      {
         this.onSetting(e.data.id);
         mButtonListFocusObject.priority = FocusPriority.MINIMUM;
         Framework.focusManager.delFocus(mButtonListFocusObject);
         mOptionListFocusObject.priority = FocusPriority.REGULAR;
         Framework.focusManager.addFocus(mButtonListFocusObject);
         Framework.focusManager.addFocus(mOptionListFocusObject);
      }
      
      private function setLastEQVal(e:WidgetEvent) : void
      {
         this.mButtonDownValue = mView.optionOverlays_group.equalizer_group[e.target.parent.name].getValue();
      }
      
      private function onScrollerSelected(e:Event) : void
      {
         if(!isNaN(e["localX"]))
         {
            return;
         }
         switch(e.currentTarget.name)
         {
            case "bass_scroller":
               mEQTrackFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.optionOverlays_group.equalizer_group.bass_scroller.track],this.onFocusCallBack);
               break;
            case "mid_scroller":
               mEQTrackFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.optionOverlays_group.equalizer_group.mid_scroller.track],this.onFocusCallBack);
               break;
            case "treble_scroller":
               mEQTrackFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.optionOverlays_group.equalizer_group.treble_scroller.track],this.onFocusCallBack);
               break;
            default:
               return;
         }
         Framework.focusManager.addFocus(mEQTrackFocusObject);
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      public function onFocusCallBack(_object:Object) : void
      {
         var _focusObject:FocusObject = null;
         var name:String = null;
         if(_object.type == "rotary")
         {
            _focusObject = Framework.focusManager.getFocus();
            name = _focusObject.objects[0].parent.name;
            if(name != "bass_scroller" && name != "treble_scroller" && name != "mid_scroller")
            {
               return;
            }
            if(_object.value == 1)
            {
               this.mButtonDownValue = mView.optionOverlays_group.equalizer_group[name].getValue();
               --this.mButtonDownValue;
               mView.optionOverlays_group.equalizer_group[name].setValue(this.mButtonDownValue);
               switch(name)
               {
                  case "bass_scroller":
                     this.setBass(null);
                     break;
                  case "mid_scroller":
                     this.setMid(null);
                     break;
                  case "treble_scroller":
                     this.setTreble(null);
               }
            }
            else if(_object.value == -1)
            {
               this.mButtonDownValue = mView.optionOverlays_group.equalizer_group[name].getValue();
               ++this.mButtonDownValue;
               mView.optionOverlays_group.equalizer_group[name].setValue(this.mButtonDownValue);
               this.setMid(null);
               switch(name)
               {
                  case "bass_scroller":
                     this.setBass(null);
                     break;
                  case "mid_scroller":
                     this.setMid(null);
                     break;
                  case "treble_scroller":
                     this.setTreble(null);
               }
            }
         }
         else if(_object.type == "enter_release" || _object.type == "enter_down")
         {
            Framework.focusManager.setFocus(FocusPriority.REGULAR);
            if(_object.value.parent.name != "bass_scroller" && _object.value.parent.name != "treble_scroller" && _object.value.parent.name != "mid_scroller")
            {
               return;
            }
            mView.optionOverlays_group.equalizer_group[_object.value.parent.name].setValue(this.mButtonDownValue);
            switch(_object.value.parent.name)
            {
               case "bass_scroller":
                  this.setBass(null);
                  break;
               case "mid_scroller":
                  this.setMid(null);
                  Framework.focusManager.rotaryTriggered(1);
                  break;
               case "treble_scroller":
                  this.setTreble(null);
                  Framework.focusManager.rotaryTriggered(1);
                  Framework.focusManager.rotaryTriggered(1);
            }
         }
      }
      
      private function onSetting(_id:int) : void
      {
         var status:Boolean = false;
         this.mSettingShown = _id;
         mView.optionButtons_group.arrow.visible = false;
         for(var i:int = 0; i < this.mButtons.length; i++)
         {
            if(this.mButtons[i].id == this.mSettingShown)
            {
               mView.optionButtons_group.arrow.visible = true;
               mView.optionButtons_group.arrow.y = mView.TAB_POS[i];
               this.mButtons[i].setSelected(true);
            }
            else
            {
               this.mButtons[i].setSelected(false);
            }
         }
         mView.optionOverlays_group.balanceFade_group.visible = false;
         mView.optionOverlays_group.equalizer_group.visible = false;
         mView.optionOverlays_group.speedAdjustedVolume_group.visible = false;
         mView.optionOverlays_group.surroundSound_group.visible = false;
         mView.optionOverlays_group.loudness_group.visible = false;
         mView.optionOverlays_group.auxVolumeOffset_group.visible = false;
         mView.optionOverlays_group.autoOnRadio_group.visible = false;
         mView.optionOverlays_group.AutoPlayAudio_group.visible = false;
         switch(this.mSettingShown)
         {
            case T.STRB_AS_BALANCE_FADE:
               mView.optionOverlays_group.balanceFade_group.visible = true;
               break;
            case T.STRB_AS_EQUALIZER:
               this.onAudioEventEqualizer(null);
               mView.optionOverlays_group.equalizer_group.visible = true;
               break;
            case T.STRB_AS_SPEED_ADJ_VOL:
               mView.optionOverlays_group.speedAdjustedVolume_group.visible = true;
               break;
            case T.STRB_AS_SURROUND:
               if(Peripheral.audioSettings.surroundSoundAvailable == true)
               {
                  this.prevOptionName = "on_button";
                  status = Boolean(Peripheral.audioSettings.surroundSoundStatus);
                  mView.optionOverlays_group.surroundSound_group.setEnabled(true);
                  mView.optionOverlays_group.surroundSound_group.on_button.setHighlight(status);
                  mView.optionOverlays_group.surroundSound_group.off_button.setHighlight(!status);
                  mView.optionOverlays_group.surroundSound_group.surroundsound.visible = status;
               }
               else
               {
                  mView.optionOverlays_group.surroundSound_group.setEnabled(false);
               }
               mView.optionOverlays_group.surroundSound_group.visible = true;
               break;
            case T.STRB_AUX_VOLUME_OFFSET_BASE:
               mView.optionOverlays_group.auxVolumeOffset_group.visible = true;
               break;
            case T.STRB_SETTINGS_AUTO_ON_RADIO:
               mView.optionOverlays_group.autoOnRadio_group.visible = true;
               break;
            case T.STRB_AUTO_PLAY:
               mView.optionOverlays_group.AutoPlayAudio_group.visible = true;
         }
      }
      
      private function onBalanceFadeFront(e:WidgetEvent) : void
      {
         this.ignoreAudioBalanceFade();
         if(this.mFade > 0)
         {
            --this.mFade;
            Peripheral.audioSettings.setFade(-this.LEVELS[this.mFade]);
            this.updateBalanceFade();
         }
      }
      
      private function onBalanceFadeRear(e:WidgetEvent) : void
      {
         this.ignoreAudioBalanceFade();
         if(this.mFade < this.LEVELS.length - 1)
         {
            ++this.mFade;
            Peripheral.audioSettings.setFade(-this.LEVELS[this.mFade]);
            this.updateBalanceFade();
         }
      }
      
      private function onBalanceFadeLeft(e:WidgetEvent) : void
      {
         this.ignoreAudioBalanceFade();
         if(this.mBalance > 0)
         {
            --this.mBalance;
            Peripheral.audioSettings.setBalance(this.LEVELS[this.mBalance]);
            this.updateBalanceFade();
         }
      }
      
      private function onBalanceFadeRight(e:WidgetEvent) : void
      {
         this.ignoreAudioBalanceFade();
         if(this.mBalance < this.LEVELS.length - 1)
         {
            ++this.mBalance;
            Peripheral.audioSettings.setBalance(this.LEVELS[this.mBalance]);
            this.updateBalanceFade();
         }
      }
      
      private function onBalanceFadeCenter(e:WidgetEvent) : void
      {
         this.updateCoordinates(mView.CENTER_X,mView.CENTER_Y);
         this.mBalance = 9;
         this.mFade = 9;
         Peripheral.audioSettings.setBalanceFade(0,0);
      }
      
      private function onBalanceFadeDown(e:MouseEvent) : void
      {
         this.ignoreAudioBalanceFade();
         this.updateCoordinates(mView.optionOverlays_group.balanceFade_group.track.mouseX,mView.optionOverlays_group.balanceFade_group.track.mouseY);
         this.mReportBalanceFadeTimer.start();
         mView.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBalanceFadeStop,false,0,true);
         mView.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onBalanceFadeMove,false,0,true);
      }
      
      private function onBalanceFadeStop(evt:MouseEvent) : void
      {
         this.ignoreAudioBalanceFade();
         this.mReportBalanceFadeTimer.reset();
         mView.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBalanceFadeStop);
         mView.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBalanceFadeMove);
         this.onReportBalanceFadeTimer(null);
      }
      
      private function onBalanceFadeMove(e:MouseEvent) : void
      {
         this.ignoreAudioBalanceFade();
         this.updateCoordinates(mView.optionOverlays_group.balanceFade_group.track.mouseX,mView.optionOverlays_group.balanceFade_group.track.mouseY);
      }
      
      private function onReportBalanceFadeTimer(e:TimerEvent) : void
      {
         this.mBalance = Math.ceil((mView.optionOverlays_group.balanceFade_group.track.thumb.x - mView.mTrackMinX) / mView.INC);
         this.mFade = Math.ceil((mView.optionOverlays_group.balanceFade_group.track.thumb.y - mView.mTrackMinY) / mView.INC);
         Peripheral.audioSettings.setBalanceFade(this.LEVELS[this.mBalance],-this.LEVELS[this.mFade]);
      }
      
      private function onAudioEventBalanceFade(e:AudioEvent) : void
      {
         if(!this.mIgnoreAudioBalanceFade)
         {
            this.mBalance = this.LEVELS.indexOf(Peripheral.audioSettings.balance);
            this.mFade = this.LEVELS.indexOf(-Peripheral.audioSettings.fade);
            this.updateBalanceFade();
         }
      }
      
      private function ignoreAudioBalanceFade() : void
      {
         this.mIgnoreAudioBalanceFade = true;
         this.mIgnoreBalanceFadeTimer.reset();
         this.mIgnoreBalanceFadeTimer.start();
      }
      
      private function onIgnoreBalanceFadeTimer(e:TimerEvent) : void
      {
         this.mIgnoreAudioBalanceFade = false;
         this.mIgnoreBalanceFadeTimer.reset();
      }
      
      private function updateBalanceFade() : void
      {
         mView.mMouseX = this.mBalance * mView.INC + mView.mTrackMinX;
         mView.mMouseY = this.mFade * mView.INC + mView.mTrackMinY;
         this.updateCoordinates(mView.mMouseX,mView.mMouseY);
      }
      
      private function updateCoordinates(_x:int, _y:int) : void
      {
         if(_x <= mView.mTrackMinX)
         {
            mView.optionOverlays_group.balanceFade_group.leftArrow.setEnabled(false);
            mView.optionOverlays_group.balanceFade_group.rightArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.track.thumb.x = mView.mTrackMinX;
         }
         else if(_x >= mView.mTrackMaxX)
         {
            mView.optionOverlays_group.balanceFade_group.leftArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.rightArrow.setEnabled(false);
            mView.optionOverlays_group.balanceFade_group.track.thumb.x = mView.mTrackMaxX;
         }
         else
         {
            mView.optionOverlays_group.balanceFade_group.leftArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.rightArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.track.thumb.x = _x;
         }
         if(_y <= mView.mTrackMinY)
         {
            mView.optionOverlays_group.balanceFade_group.upArrow.setEnabled(false);
            mView.optionOverlays_group.balanceFade_group.downArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.track.thumb.y = mView.mTrackMinY;
         }
         else if(_y >= mView.mTrackMaxY)
         {
            mView.optionOverlays_group.balanceFade_group.upArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.downArrow.setEnabled(false);
            mView.optionOverlays_group.balanceFade_group.track.thumb.y = mView.mTrackMaxY;
         }
         else
         {
            mView.optionOverlays_group.balanceFade_group.upArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.downArrow.setEnabled(true);
            mView.optionOverlays_group.balanceFade_group.track.thumb.y = _y;
         }
      }
      
      private function updateBass(e:Event = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.bass_scroller.getValue();
         mView.optionOverlays_group.equalizer_group.bass_scroller.track.gotoAndStop(10 - value);
         mView.optionOverlays_group.equalizer_group.bassValue_label.text = value;
      }
      
      private function setBass(e:WidgetEvent = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.bass_scroller.getValue();
         Peripheral.audioSettings.setBass(value / 9);
         this.updateBass();
      }
      
      private function updateMid(e:Event = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.mid_scroller.getValue();
         mView.optionOverlays_group.equalizer_group.mid_scroller.track.gotoAndStop(10 - value);
         mView.optionOverlays_group.equalizer_group.midValue_label.text = value;
      }
      
      private function setMid(e:WidgetEvent = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.mid_scroller.getValue();
         Peripheral.audioSettings.setMid(value / 9);
         this.updateMid();
      }
      
      private function updateTreble(e:Event = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.treble_scroller.getValue();
         mView.optionOverlays_group.equalizer_group.treble_scroller.track.gotoAndStop(10 - value);
         mView.optionOverlays_group.equalizer_group.trebleValue_label.text = value;
      }
      
      private function setTreble(e:WidgetEvent = null) : void
      {
         var value:int = -mView.optionOverlays_group.equalizer_group.treble_scroller.getValue();
         Peripheral.audioSettings.setTreble(value / 9);
         this.updateTreble();
      }
      
      private function startEqualizer(evt:MouseEvent) : void
      {
         detachListener(Peripheral.audioSettings,AudioEvent.EQUALIZER,this.onAudioEventEqualizer);
         attachListener(mView.stage,MouseEvent.MOUSE_UP,this.endEqualizer);
         attachListener(mView.optionOverlays_group.equalizer_group.bass_scroller.track,MouseEvent.MOUSE_MOVE,this.updateBass);
         attachListener(mView.optionOverlays_group.equalizer_group.mid_scroller.track,MouseEvent.MOUSE_MOVE,this.updateMid);
         attachListener(mView.optionOverlays_group.equalizer_group.treble_scroller.track,MouseEvent.MOUSE_MOVE,this.updateTreble);
         this.updateBass();
         this.updateMid();
         this.updateTreble();
      }
      
      private function endEqualizer(evt:MouseEvent) : void
      {
         detachListener(mView.optionOverlays_group.equalizer_group.bass_scroller.track,MouseEvent.MOUSE_MOVE,this.updateBass);
         detachListener(mView.optionOverlays_group.equalizer_group.mid_scroller.track,MouseEvent.MOUSE_MOVE,this.updateMid);
         detachListener(mView.optionOverlays_group.equalizer_group.treble_scroller.track,MouseEvent.MOUSE_MOVE,this.updateTreble);
         detachListener(mView.stage,MouseEvent.MOUSE_UP,this.endEqualizer);
         attachListener(Peripheral.audioSettings,AudioEvent.EQUALIZER,this.onAudioEventEqualizer);
      }
      
      private function onAudioEventEqualizer(e:AudioEvent = null) : void
      {
         mView.optionOverlays_group.equalizer_group.bass_scroller.setValue(-Peripheral.audioSettings.bass * 9);
         mView.optionOverlays_group.equalizer_group.mid_scroller.setValue(-Peripheral.audioSettings.mid * 9);
         mView.optionOverlays_group.equalizer_group.treble_scroller.setValue(-Peripheral.audioSettings.treble * 9);
         this.updateBass();
         this.updateMid();
         this.updateTreble();
      }
      
      private function setSpeedAdjustedVolume(e:WidgetEvent) : void
      {
         switch(e.data.targetName)
         {
            case "off_button":
               Peripheral.audioSettings.setSpeedVolume(0);
               break;
            case "level1_button":
               Peripheral.audioSettings.setSpeedVolume(0.25);
               break;
            case "level2_button":
               Peripheral.audioSettings.setSpeedVolume(0.5);
               break;
            case "level3_button":
               Peripheral.audioSettings.setSpeedVolume(0.75);
         }
      }
      
      private function onAudioEventSurroundSoundAvailable(e:AudioEvent) : void
      {
         mView.optionOverlays_group.surroundSound_group.setEnabled(Peripheral.audioSettings.surroundSoundAvailable);
         if(Peripheral.audioSettings.surroundSoundAvailable)
         {
            mView.optionOverlays_group.surroundSound_group.surroundsound.visible = Peripheral.audioSettings.surroundSoundStatus;
         }
         else
         {
            mView.optionOverlays_group.surroundSound_group.surroundsound.visible = false;
         }
      }
      
      private function onAudioEventSurroundSoundStatus(e:AudioEvent) : void
      {
         var status:Boolean = Boolean(Peripheral.audioSettings.surroundSoundStatus);
         mView.optionOverlays_group.surroundSound_group.on_button.setHighlight(status);
         mView.optionOverlays_group.surroundSound_group.off_button.setHighlight(!status);
         mView.optionOverlays_group.surroundSound_group.surroundsound.visible = status;
      }
      
      private function setSurroundSound(e:WidgetEvent = null) : void
      {
         if(false == Peripheral.audioSettings.surroundSoundAvailable)
         {
            return;
         }
         var optionName:String = mView.optionOverlays_group.surroundSound_group.getSelection();
         if(null == optionName || "" == optionName)
         {
            optionName = this.prevOptionName;
         }
         else
         {
            this.prevOptionName = optionName;
         }
         switch(optionName)
         {
            case "off_button":
               mView.optionOverlays_group.surroundSound_group.off_button.setHighlight(true);
               Peripheral.audioSettings.setSurroundSoundStatus(false);
               mView.optionOverlays_group.surroundSound_group.surroundsound.visible = false;
               break;
            case "on_button":
               mView.optionOverlays_group.surroundSound_group.on_button.setHighlight(true);
               Peripheral.audioSettings.setSurroundSoundStatus(true);
               mView.optionOverlays_group.surroundSound_group.surroundsound.visible = true;
         }
      }
      
      private function setAutoOnRadio(e:WidgetEvent) : void
      {
         switch(e.data.name)
         {
            case "on_button":
               mView.optionOverlays_group.autoOnRadio_group.setSelection("on_button");
               Peripheral.personalConfig.setAutoSwitch("active");
               break;
            case "off_button":
               mView.optionOverlays_group.autoOnRadio_group.setSelection("off_button");
               Peripheral.personalConfig.setAutoSwitch("not_active");
               break;
            case "recall_button":
               mView.optionOverlays_group.autoOnRadio_group.setSelection("recall_button");
               Peripheral.personalConfig.setAutoSwitch("recall_last");
         }
      }
      
      private function onAutoOnRadio(evt:PersonalConfigEvent) : void
      {
         mView.optionOverlays_group.autoOnRadio_group.off_button.setSelected(Peripheral.personalConfig.autoSwitch == "not_active");
         mView.optionOverlays_group.autoOnRadio_group.on_button.setSelected(Peripheral.personalConfig.autoSwitch == "active");
         mView.optionOverlays_group.autoOnRadio_group.recall_button.setSelected(Peripheral.personalConfig.autoSwitch == "recall_last");
      }
      
      private function onAudioEventSpeed(evt:AudioEvent) : void
      {
         switch(Peripheral.audioSettings.speedVolume)
         {
            case 0:
               mView.optionOverlays_group.speedAdjustedVolume_group.setSelection("off_button");
               break;
            case 0.25:
               mView.optionOverlays_group.speedAdjustedVolume_group.setSelection("level1_button");
               break;
            case 0.5:
               mView.optionOverlays_group.speedAdjustedVolume_group.setSelection("level2_button");
               break;
            case 0.75:
               mView.optionOverlays_group.speedAdjustedVolume_group.setSelection("level3_button");
         }
      }
      
      private function setAuxVolumeOffset(e:WidgetEvent) : void
      {
         var value:int = mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.getValue() - this.AUX_RANGE;
         if(value != Peripheral.audioMixerManager.AuxVolumeOffset)
         {
            Peripheral.audioMixerManager.setAuxVolumeOffset(value);
         }
         this.updateAuxVolumeOffset();
      }
      
      private function startAuxVolumeOffset(e:MouseEvent) : void
      {
         detachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET,this.onAMMAuxVolumeOffset);
         attachListener(mView.stage,MouseEvent.MOUSE_UP,this.endAuxVolumeOffset);
      }
      
      private function endAuxVolumeOffset(e:MouseEvent) : void
      {
         detachListener(mView.stage,MouseEvent.MOUSE_UP,this.endAuxVolumeOffset);
         attachListener(Peripheral.audioMixerManager,AudioMixerManagerEvent.AMM_AUX_VOLUME_OFFSET,this.onAMMAuxVolumeOffset);
         Peripheral.audioMixerManager.getAuxVolumeOffset();
      }
      
      private function updateAuxVolumeOffset(e:MouseEvent = null) : void
      {
         var value:int = int(mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.getValue());
         mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.track.bar.gotoAndStop(value + 1);
         mView.optionOverlays_group.auxVolumeOffset_group.value.text = this.AUX_VOL[value];
         mView.optionOverlays_group.auxVolumeOffset_group.value.x = mView.AUX_POS[value];
      }
      
      private function onAMMAuxVolumeOffset(e:AudioMixerManagerEvent) : void
      {
         var value:int = Peripheral.audioMixerManager.AuxVolumeOffset + this.AUX_RANGE;
         mView.optionOverlays_group.auxVolumeOffset_group.auxVolume_scroller.setValue(value);
         this.updateAuxVolumeOffset();
      }
      
      private function audioInterruptStatus(evt:AudioEvent) : void
      {
         var balanceFade_group:MovieClip = mView.optionOverlays_group.balanceFade_group;
         var equalizer_group:MovieClip = mView.optionOverlays_group.equalizer_group;
         if(Peripheral.audioSettings.interruptStatus == true && Peripheral.audioMixerManager.interruptSource != "phone")
         {
            balanceFade_group.setInteractive(false);
            balanceFade_group.downArrow.setEnabled(false);
            balanceFade_group.upArrow.setEnabled(false);
            balanceFade_group.leftArrow.setEnabled(false);
            balanceFade_group.rightArrow.setEnabled(false);
            balanceFade_group.center_button.setEnabled(false);
            balanceFade_group.center_button.setInteractive(false);
            equalizer_group.setInteractive(false);
         }
         else
         {
            balanceFade_group.setInteractive(true);
            balanceFade_group.downArrow.setEnabled(true);
            balanceFade_group.upArrow.setEnabled(true);
            balanceFade_group.leftArrow.setEnabled(true);
            balanceFade_group.rightArrow.setEnabled(true);
            balanceFade_group.center_button.setEnabled(true);
            balanceFade_group.center_button.setInteractive(true);
            equalizer_group.setInteractive(true);
         }
      }
      
      private function onAudioInterruptSource(e:AudioMixerManagerEvent) : void
      {
         var amm:IAudioMixerManager = Peripheral.audioMixerManager;
         if(amm.interruptSource == amm.AMM_SOURCE_SIGNAL)
         {
            close();
         }
      }
      
      private function setAutoPlayOn(evt:WidgetEvent) : void
      {
         if(Peripheral.audioSettings.audioAutoPlayStatus != "on")
         {
            Peripheral.audioSettings.audioAutoPlayStatus = "on";
         }
      }
      
      private function setAutoPlayOff(evt:WidgetEvent) : void
      {
         if(Peripheral.audioSettings.audioAutoPlayStatus != "off")
         {
            Peripheral.audioSettings.audioAutoPlayStatus = "off";
         }
      }
      
      private function onAudioEventAutoPlayStatus(evt:AudioEvent) : void
      {
         mView.optionOverlays_group.AutoPlayAudio_group.off_button.setEnabled(true);
         mView.optionOverlays_group.AutoPlayAudio_group.on_button.setEnabled(true);
         switch(Peripheral.audioSettings.audioAutoPlayStatus)
         {
            case "off":
               mView.optionOverlays_group.AutoPlayAudio_group.on_button.setHighlight(false);
               mView.optionOverlays_group.AutoPlayAudio_group.off_button.setHighlight(true);
               mView.optionOverlays_group.AutoPlayAudio_group.AutoPlayState.icon.gotoAndStop(1);
               break;
            case "on":
               mView.optionOverlays_group.AutoPlayAudio_group.off_button.setHighlight(false);
               mView.optionOverlays_group.AutoPlayAudio_group.on_button.setHighlight(true);
               mView.optionOverlays_group.AutoPlayAudio_group.AutoPlayState.icon.gotoAndStop(2);
               break;
            default:
               mView.optionOverlays_group.AutoPlayAudio_group.off_button.setEnabled(false);
               mView.optionOverlays_group.AutoPlayAudio_group.off_button.setHighlight(false);
               mView.optionOverlays_group.AutoPlayAudio_group.on_button.setEnabled(false);
               mView.optionOverlays_group.AutoPlayAudio_group.on_button.setHighlight(false);
         }
      }
   }
}

