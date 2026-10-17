package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Extensions;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.ICSEvent;
   import com.nfuzion.moduleLinkAPI.ISWCEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerTransportAction;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.TunerEvent;
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.enums.PopupType;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HardControls implements IEventDispatcher
   {
      
      private static var instance:HardControls;
      
      private var eventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var mPriorities:Object = new Object();
      
      private var mStage:DisplayObjectContainer;
      
      private var mEncoderDelta:int = 0;
      
      private var mPressTimer:Timer = new Timer(500);
      
      private var mPress:uint = 0;
      
      private var mSportPress:Boolean = false;
      
      private var mediaICSEnabled:Boolean = false;
      
      private var m2SecondLongPress:Timer = new Timer(2000,1);
      
      private var mBackLongPress:Timer = new Timer(1000,1);
      
      public function HardControls()
      {
         super();
         this.mPriorities[HardControlEvent.VERTICAL_SCROLL] = 0;
         this.onSource(null);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource);
         Peripheral.tuner.addEventListener(TunerEvent.AVAILABLE,this.onTunerAvailable);
         Peripheral.satelliteRadio.addEventListener(SatelliteRadioEvent.APP_STATUS,this.onSatAvailable);
         Peripheral.dabTunerControl.addEventListener(DABEvent.AVAILABLE,this.onDABAvailable);
         Peripheral.ics.addEventListener(ICSEvent.ENCODER,this.onIcsEncoder);
         Peripheral.ics.addEventListener(ICSEvent.SELECT,this.onIcsSelect);
         Peripheral.ics.addEventListener(ICSEvent.BACK,this.onIcsBack);
         Peripheral.ics.addEventListener(ICSEvent.BROWSE,this.onIcsBrowse);
         Peripheral.ics.addEventListener(ICSEvent.EXIT,this.onIcsExit);
         Peripheral.ics.addEventListener(ICSEvent.SCREEN_OFF,this.onIcsScreenOff);
         Peripheral.ics.addEventListener(ICSEvent.AUDIOONOFF,this.onAudioOnOff);
         Peripheral.swc.addEventListener(ISWCEvent.PRESET_ADVANCE,this.onSwcPresetAdvance);
         Peripheral.swc.addEventListener(ISWCEvent.MODE_ADVANCE,this.onModeAdvancePressed);
         Peripheral.ics.addEventListener(ICSEvent.RADIO,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.PLAYER,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.NAV,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.PHONE,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.MORE,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.SETTINGS,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.BACK,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.SRT,this.onICSKeySRT);
         Peripheral.ics.addEventListener(ICSEvent.DEALER_MODE,this.onDealerMode);
         Peripheral.ics.addEventListener(ICSEvent.ENGINEERING_MODE,this.onEngineeringMode);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.SCREEN_ENABLE,this.onScreenEnable);
         this.mPressTimer.addEventListener(TimerEvent.TIMER,this.onICSKeySRTDoubleClick);
         this.m2SecondLongPress.addEventListener(TimerEvent.TIMER,this.onICSSelectPressAndHold);
         this.mBackLongPress.addEventListener(TimerEvent.TIMER,this.onICSBackPressAndHold);
      }
      
      public static function getInstance() : HardControls
      {
         if(instance == null)
         {
            instance = new HardControls();
         }
         return instance;
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(type);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(!this.mPriorities.hasOwnProperty(type))
         {
            this.mPriorities[type] = 0;
         }
         if(type == HardControlEvent.VERTICAL_SCROLL)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.disableICSTuning();
            }
         }
         ++this.mPriorities[type];
         if(priority == 0)
         {
            priority = int(this.mPriorities[type]);
         }
         this.eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(!(!this.mPriorities.hasOwnProperty(type) || this.mPriorities[type] <= 0))
         {
            this.eventDispatcher.removeEventListener(type,listener,useCapture);
            --this.mPriorities[type];
            if(type == HardControlEvent.VERTICAL_SCROLL)
            {
               if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
               {
                  this.enableICSTuning();
               }
            }
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.willTrigger(type);
      }
      
      private function onSource(e:AudioEvent) : void
      {
         if(!this.enableICSMedia())
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onTunerAvailable(e:TunerEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AM || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_MW || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onSatAvailable(e:SatelliteRadioEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onDABAvailable(e:DABEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DAB)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function disableICSTuning() : void
      {
         Peripheral.tuner.setTuneKnobEnabled(false);
         if(Peripheral.satelliteRadio.appStatus == "READY")
         {
            Peripheral.satelliteRadio.requestDisableICSTuning();
         }
         if(Peripheral.vehConfig.dabPresent == true)
         {
            Peripheral.dabApp.requestDisableICSTuning();
         }
      }
      
      private function enableICSMedia() : Boolean
      {
         var changed:Boolean = false;
         if(Peripheral.audioManager.isSourceMediaService() || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(!this.mediaICSEnabled)
            {
               changed = true;
               this.mediaICSEnabled = true;
               this.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.onTuneKnob,false,-1000);
            }
         }
         else if(this.mediaICSEnabled)
         {
            changed = true;
            this.mediaICSEnabled = false;
            this.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.onTuneKnob);
         }
         return changed;
      }
      
      private function enableICSTuning() : void
      {
         if(Framework.focusManager.enabled)
         {
            this.disableICSTuning();
            return;
         }
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_SAT:
               Peripheral.tuner.setTuneKnobEnabled(false);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestEnableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestDisableICSTuning();
               }
               break;
            case Peripheral.audioManager.SOURCE_FM:
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_MW:
               Peripheral.tuner.setTuneKnobEnabled(true);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestDisableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestDisableICSTuning();
               }
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               Peripheral.tuner.setTuneKnobEnabled(false);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestDisableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestEnableICSTuning();
               }
               break;
            default:
               this.disableICSTuning();
         }
      }
      
      private function onTuneKnob(e:HardControlEvent) : void
      {
         var delta:* = int(e.data);
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
            case Peripheral.audioManager.SOURCE_SDCARD:
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               while(delta > 0)
               {
                  Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.SKIP_FORWARD);
                  delta--;
               }
               while(delta < 0)
               {
                  Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PREVIOUS);
                  delta++;
               }
               break;
            case Peripheral.audioManager.SOURCE_CD:
               if(delta > 0)
               {
                  Peripheral.rse.nextTrack(delta);
               }
               else if(delta < 0)
               {
                  Peripheral.rse.previousTrack(Math.abs(delta));
               }
         }
      }
      
      public function onIcsEncoder(e:ICSEvent) : void
      {
         if(Framework.popupManager.active != DynamicPopupNames.VOICE_PICK_LIST)
         {
            Peripheral.voiceRecognition.cancel(false);
         }
         if(Framework.focusManager.enabled)
         {
            if(Framework.structure.currentBranch != Screens.APPS_ACTIVE)
            {
               Framework.focusManager.rotaryTriggered(e.data);
            }
         }
         else
         {
            this.dispatchEvent(new HardControlEvent(HardControlEvent.VERTICAL_SCROLL,e.data));
         }
      }
      
      public function onIcsSelect(e:ICSEvent) : void
      {
         if(Framework.popupManager.active != DynamicPopupNames.VOICE_PICK_LIST)
         {
            Peripheral.voiceRecognition.cancel(false);
         }
         if(Framework.focusManager.enabled)
         {
            if(Framework.structure.currentBranch != Screens.APPS_ACTIVE)
            {
               Framework.focusManager.selectTriggered(e.data);
            }
         }
         else if(e.data == true)
         {
            if(this.m2SecondLongPress.running)
            {
               this.m2SecondLongPress.reset();
               this.dispatchEvent(new HardControlEvent(HardControlEvent.SELECT));
            }
         }
         else
         {
            this.m2SecondLongPress.reset();
            this.m2SecondLongPress.start();
         }
      }
      
      public function onICSSelectPressAndHold(e:TimerEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SELECT_2SEC_PRESS));
      }
      
      public function onIcsBack(e:ICSEvent) : void
      {
         if(Framework.focusManager.enabled)
         {
            if(e.data == true)
            {
               this.mBackLongPress.start();
            }
            else if(this.mBackLongPress.running)
            {
               this.mBackLongPress.reset();
               if(Framework.focusManager.back() != true)
               {
                  if(Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.NAV_MAPVIEW)
                  {
                     Peripheral.navigation.navDomainControl.onNavDomainButton();
                  }
                  else
                  {
                     this.dispatchEvent(new HardControlEvent(HardControlEvent.BACK));
                  }
               }
            }
         }
         else if(e.data == true)
         {
            this.dispatchEvent(new HardControlEvent(HardControlEvent.BACK));
         }
      }
      
      public function onICSBackPressAndHold(e:TimerEvent) : void
      {
         this.mBackLongPress.reset();
         if(Framework.focusManager.enabled)
         {
            if(Framework.focusManager.exit())
            {
            }
         }
      }
      
      public function onIcsBrowse(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.BROWSE));
      }
      
      public function onIcsScreenOff(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SCREEN_OFF));
      }
      
      public function onAudioOnOff(e:ICSEvent) : void
      {
         if(Peripheral.bluetoothPhone.getRingingCall() != null)
         {
            Peripheral.audioMixerManager.sendPhoneMute(!Peripheral.audioMixerManager.phoneMuteStatus);
         }
         if(Peripheral.bluetoothPhone.getActiveCall() != null)
         {
            Peripheral.audioSettings.setSHFMicMute(!Peripheral.audioSettings.SHFMicMute);
         }
      }
      
      public function onIcsExit(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.EXIT));
      }
      
      public function onSwcPresetAdvance(e:ISWCEvent) : void
      {
         Peripheral.presetManager.onSWCPresetAdvance();
      }
      
      public function onModeAdvancePressed(e:ISWCEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.MODE_ADVANCE));
      }
      
      private function onICSKey(e:ICSEvent) : void
      {
         this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,{"identifier":e.type}));
      }
      
      private function onDealerMode(e:ICSEvent) : void
      {
         if(Extensions.DEALER_MODE_EXTENSIONS.indexOf(Framework.structure.currentExtension) == -1)
         {
            Framework.structure.goto(Screens.APPS_LIST,{"ext":Extensions.LIST_DEALER_MAIN});
         }
         else
         {
            Framework.structure.exit();
         }
      }
      
      private function onEngineeringMode(e:ICSEvent) : void
      {
         if(Extensions.ENGINEERING_MODE_EXTENSIONS.indexOf(Framework.structure.currentExtension) == -1)
         {
            Framework.structure.goto(Screens.APPS_LIST,{"ext":Extensions.LIST_ENG_MENU});
         }
         else
         {
            Framework.structure.exit();
         }
      }
      
      private function onScreenEnable(e:VehSettingsEvent) : void
      {
         if(Peripheral.vehSettings.screenEnable() == true)
         {
            if(Framework.resolution == Framework.RES_640_480)
            {
               Framework.structure.goto(Screens.DISPLAY_OFF);
            }
            else
            {
               Framework.popupManager.show(DynamicPopupNames.SCREEN_OFF,Screens.DISPLAY_OFF,{"type":PopupType.SCREENOFF});
            }
         }
         else
         {
            Framework.structure.back();
         }
      }
      
      private function onICSKeySRT(e:ICSEvent) : void
      {
         this.mPress += 1;
         this.mPressTimer.start();
      }
      
      private function onICSKeySRTDoubleClick(e:TimerEvent) : void
      {
         if(this.mPress == 2)
         {
            if(Peripheral.vehConfig.hasSRTPresent)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_CUSTOM;
            }
         }
         Framework.popupManager.exit();
         Peripheral.driveModeManager.enterDriveMode();
         this.mPress = 0;
         this.mPressTimer.reset();
      }
   }
}

