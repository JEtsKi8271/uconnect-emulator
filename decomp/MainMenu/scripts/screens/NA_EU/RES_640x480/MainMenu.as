package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.moduleLinkAPI.*;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import core.events.StructureEvent;
   import core.locale.LocaleArchive;
   import events.EmergencyCallStateEvent;
   import events.GlobalEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.MainMenuManager;
   import peripheral.Peripheral;
   import peripheral.VehicleFeatureManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class MainMenu extends GenericScreen
   {
      
      private const ID_RADIO:String = "radio";
      
      private const RADIO_INDEX:uint = 0;
      
      private const ID_PLAYER:String = "player";
      
      private const PLAYER_INDEX:uint = 1;
      
      private const ID_PHONE:String = "phone";
      
      private const PHONE_INDEX:uint = 2;
      
      private const ID_MORE:String = "apps";
      
      private const MORE_INDEX:uint = 3;
      
      private const ID_APP:String = "apps";
      
      private const APPS_INDEX:uint = 4;
      
      private const ID_NAV:String = "nav";
      
      private const NAV_INDEX:uint = 5;
      
      private const ID_CLIMATE:String = "hvac";
      
      private const HVAC_INDEX:uint = 6;
      
      private const ID_CONTROLS:String = "controls";
      
      private const CONTROLS_INDEX:uint = 7;
      
      private const ID_SETTINGS:String = "settings";
      
      private const SETTINGS_INDEX:uint = 8;
      
      private const ID_ECALL:String = "9-1-1";
      
      private const ECALL_INDEX:uint = 9;
      
      private const MD_LOAD:String = "loading";
      
      private const MD_READ:String = "reading";
      
      private const MD_ERROR:String = "error";
      
      private const MD_NONE:String = "noDisc";
      
      private const MD_EJECT:String = "ejecting";
      
      private const MD_STOP:String = "stop";
      
      private const DISC_EJECT:String = "discNL";
      
      private var compassArr:Array = [T.STRB_GEO_NORTH,T.STRB_GEO_NORTH_EAST,T.STRB_GEO_EAST,T.STRB_GEO_SOUTH_EAST,T.STRB_GEO_SOUTH,T.STRB_GEO_SOUTH_WEST,T.STRB_GEO_WEST,T.STRB_GEO_NORTH_WEST];
      
      private var mVoiceBarTimer:Timer;
      
      private var mMenuVector:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var mMenuFcnArray:Vector.<Function> = new Vector.<Function>();
      
      private var mMenuDeferredFcnArray:Vector.<Function> = new Vector.<Function>();
      
      private var mMenuDeferredTimer:Timer = new Timer(300,1);
      
      private var mVFM:VehicleFeatureManager = new VehicleFeatureManager();
      
      private var mFanPopupTimer:Timer = new Timer(Style.HVAC_POPUP_TIMEOUT);
      
      private var mLastFanSpd:String = "off";
      
      private var mFirstFanSpdChange:Boolean = true;
      
      private var mLastSource:String = "";
      
      private var mLastSongNameText:String = "";
      
      private var mPreviousScreen:String = "";
      
      private var mPhoneConnected:Boolean = false;
      
      private var mCurrentHFPDeviceId:String = "";
      
      private var mCurrentAudioDeviceid:String = "";
      
      private var mCurrentDomain:int = 0;
      
      private var controlsPopupTimeOut:Boolean = false;
      
      private var mPreviousSelectedMenuButtonId:String = null;
      
      private var mProductVariantInfo:ProductVariantID;
      
      private var mMainMenuManager:MainMenuManager = new MainMenuManager();
      
      public function MainMenu()
      {
         mView = new C_MainMenuView();
         cache = true;
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         Peripheral.versionInfo.requestProductVariantID();
         mView.fanSpeed_group.visible = false;
         mView.ecall_button.visible = false;
         mView.controls_button.tab.visible = false;
         mView.apps_button.visible = false;
         mView.more_button.visible = false;
         mView.settings_button.visible = false;
         mView.radio_button.identifier = this.ID_RADIO;
         mView.media_button.identifier = this.ID_PLAYER;
         mView.phone_button.identifier = this.ID_PHONE;
         mView.more_button.identifier = this.ID_MORE;
         mView.apps_button.identifier = this.ID_APP;
         mView.nav_button.identifier = this.ID_NAV;
         mView.climate_button.identifier = this.ID_CLIMATE;
         mView.controls_button.identifier = this.ID_CONTROLS;
         mView.settings_button.identifier = this.ID_SETTINGS;
         mView.ecall_button.identifier = this.ID_ECALL;
         mView.radio_button.wave.visible = false;
         mView.media_button.wave.visible = false;
         mView.controls_button.wave.visible = false;
         mView.climate_button.wave.visible = false;
         mView.nav_button.wave.visible = false;
         mView.phone_button.wave.visible = false;
         mView.apps_button.wave.visible = false;
         mView.more_button.wave.visible = false;
         mView.settings_button.wave.visible = false;
         mView.radio_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_RADIO);
         mView.media_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_MEDIA);
         mView.controls_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_CONTROLS);
         mView.climate_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_CLIMATE);
         mView.nav_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_NAV);
         mView.phone_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_PHONE);
         mView.apps_button.value_label.text = (Global.SRTpackagePrsnt ? "& " : "") + LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_APPS);
         mView.more_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_MORE);
         mView.settings_button.value_label.text = LocaleArchive.getInstance().getTextByResID(T.STRB_MENU_SETTINGS);
         this.mMenuVector.push(mView.radio_button);
         this.mMenuVector.push(mView.media_button);
         this.mMenuVector.push(mView.phone_button);
         this.mMenuVector.push(mView.more_button);
         this.mMenuVector.push(mView.apps_button);
         this.mMenuVector.push(mView.nav_button);
         this.mMenuVector.push(mView.climate_button);
         this.mMenuVector.push(mView.controls_button);
         this.mMenuVector.push(mView.settings_button);
         this.mMenuVector.push(mView.ecall_button);
         this.mMainMenuManager.menu = this.mMenuVector;
         this.mMainMenuManager.configure();
         this.setButtonStates(Framework.structure.currentBranch);
         Peripheral.cvpdemo.getRssi();
         Peripheral.bluetoothPhone.getProperties(BluetoothPropertyConstants.PROP_GAP_NETWORK_REGISTRATION_STATE);
         if(Peripheral.mediaPlayer != null)
         {
            Peripheral.mediaPlayer.getCurrentTrackInfo();
         }
         Peripheral.hvac.getClimateState();
         this.onIgnitionState(null);
         if(Peripheral.vehConfig.hasHeatedSeat == true)
         {
            mView.controls_button.controlsIcon.gotoAndStop(1);
         }
         else
         {
            mView.controls_button.controlsIcon.gotoAndStop(2);
         }
         if((this.mVFM.vehicleFeatureSet == this.mVFM.VFS_F || this.mVFM.vehicleFeatureSet == this.mVFM.VFS_F_R) && !Peripheral.vehConfig.hasECMirror && !Peripheral.vehConfig.hasCargoCamera && !Peripheral.vehConfig.hasEcoMode && !Peripheral.vehConfig.hasHeadRest && !Peripheral.vehConfig.hasSunShade && !Peripheral.vehConfig.hasDisplayOnOffSK && !Peripheral.vehConfig.dtvShortTermPresent && !Peripheral.vehConfig.hasFrontCamera && !Peripheral.vehConfig.hasSideCamera && (!Peripheral.vehConfig.hasSurroundCamera && !Peripheral.vehConfig.hasSVCSoftKey) && !Peripheral.vehConfig.hasRVCMPresent)
         {
            mView.controls_button.visible = false;
            Peripheral.voiceRecognition.controlPanelContext = Peripheral.voiceRecognition.SETTINGS;
         }
         else
         {
            mView.controls_button.visible = true;
            Peripheral.voiceRecognition.controlPanelContext = Peripheral.voiceRecognition.CONTROLS;
         }
         this.mMainMenuManager.configure();
         var signalQuality:int = 0;
         this.displaySignalQuality(signalQuality);
         mView.phone_button.displayBluetooth.visible = true;
         if(Peripheral.bluetooth.currentHFPDevice != null)
         {
            mView.phone_button.displayBluetooth.gotoAndStop("connected");
            Peripheral.bluetoothPhone.getProperties(BluetoothPropertyConstants.PROP_HFP_SIGNAL_QUALITY);
         }
         else
         {
            mView.phone_button.displayBluetooth.gotoAndStop("disconnected");
         }
         this.onClimateStateChange(null);
         this.onVentStateChange(null);
         this.onFanSpeedChange(null);
         this.setButtonActions();
         t(mView.radio_button.value_label,T.STRB_MENU_RADIO);
         t(mView.media_button.value_label,T.STRB_MENU_MEDIA);
         t(mView.controls_button.value_label,T.STRB_MENU_CONTROLS);
         t(mView.climate_button.value_label,T.STRB_MENU_CLIMATE);
         t(mView.nav_button.value_label,T.STRB_MENU_NAV);
         t(mView.phone_button.value_label,T.STRB_MENU_PHONE);
         if(Global.SRTpackagePrsnt)
         {
            t(mView.apps_button.value_label,["& ",T.STRB_MENU_APPS]);
         }
         else
         {
            t(mView.apps_button.value_label,T.STRB_MENU_APPS);
         }
         t(mView.more_button.value_label,T.STRB_MENU_MORE);
         t(mView.settings_button.value_label,T.STRB_MENU_SETTINGS);
         t(mView.climate_button.icon.vents.off,T.STRB_HVAC_OFF);
         mView.nav_button.compassLabel.text = "--";
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Peripheral.vehicleStatus.getIgnitionState();
         mView.settings_button.setEnabled(Peripheral.antiTheft.ignitionState == "on");
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(Framework.structure,StructureEvent.GOTO,this.onGoto);
         attachListener(Peripheral.versionInfo,VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate);
         attachListener(Peripheral.vehConfig,VehConfigEvent.AVAILABLE,this.onVehConfigAvailable,false,0,true);
         attachListener(Peripheral.cvpdemo,CVPDemoEvent.SIGNAL_QUALITY,this.onEmbeddedCellSignalQuality,false,0,true);
         attachListener(Peripheral.cvpdemo,CVPDemoEvent.NETWORK,this.onNetwork,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onBluetoothStatus,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onBluetoothStatus,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onBluetoothDisconnected,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.NETWORK_REGISTRATION_STATE,this.onNetworkRegistrationState,false,0,true);
         attachListener(Peripheral.emergencyCallState,EmergencyCallStateEvent.EMERGENCY_CALLSTATE,this.onEmergencyCallState,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_F_CLIMATE_STATE,this.onClimateStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_F_FAN_SPEED,this.onFanSpeedChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_VENT_MODE,this.onVentStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_AUTO_STATE,this.onAutoStateChange,false,0,true);
         attachListener(this.mFanPopupTimer,TimerEvent.TIMER,this.onFanPopupExpire);
         attachListener(mView.radio_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.media_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.phone_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.apps_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.more_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.nav_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.climate_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.ecall_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.controls_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         attachListener(mView.settings_button,WidgetEvent.PRESS,this.onMenuButtonClick);
         Peripheral.hardControls.addEventListener(WidgetEvent.PRESS,this.onHardButtonClick);
         attachListener(Peripheral.location,LocationEvent.COMPASS_HEADING,this.onCompassHeading);
         Peripheral.location.getCompassHeading();
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         attachListener(Framework.popupManager,PopupManagerEvent.CLOSE,this.onPopupClose,false,0,true);
         attachListener(Framework.popupManager,PopupManagerEvent.ACTIVE,this.onPopupActive,false,0,true);
         this.mMenuDeferredTimer.addEventListener(TimerEvent.TIMER,this.onMainMenuDeferredTimeout);
      }
      
      private function onProductIDUpdate(e:VersionInfoEvent) : void
      {
         this.mProductVariantInfo = Peripheral.versionInfo.productVariantID;
         if(this.mProductVariantInfo != null && this.mProductVariantInfo.VARIANT_ECELL != "YES")
         {
            mView.apps_button.network.visible = false;
            mView.apps_button.signal.visible = false;
         }
      }
      
      override protected function back(e:Event = null) : void
      {
      }
      
      public function CheckVRSession(bSilentMode:Boolean = true) : void
      {
         Peripheral.vrSession.cancelVRSession(bSilentMode);
      }
      
      private function onVehConfigAvailable(e:VehConfigEvent) : void
      {
         if((this.mVFM.vehicleFeatureSet == this.mVFM.VFS_F || this.mVFM.vehicleFeatureSet == this.mVFM.VFS_F_R) && !Peripheral.vehConfig.hasECMirror && !Peripheral.vehConfig.hasCargoCamera && !Peripheral.vehConfig.hasEcoMode && !Peripheral.vehConfig.hasHeadRest && !Peripheral.vehConfig.hasSunShade && !Peripheral.vehConfig.hasDisplayOnOffSK && !Peripheral.vehConfig.dtvShortTermPresent && !Peripheral.vehConfig.hasFrontCamera && !Peripheral.vehConfig.hasSideCamera)
         {
            mView.controls_button.visible = false;
            Peripheral.voiceRecognition.controlPanelContext = Peripheral.voiceRecognition.SETTINGS;
         }
         else
         {
            mView.controls_button.visible = true;
            Peripheral.voiceRecognition.controlPanelContext = Peripheral.voiceRecognition.CONTROLS;
         }
         this.mMainMenuManager.configure();
      }
      
      private function setButtonActions() : void
      {
         Framework.autoAssigner.assignChildren(view);
         this.mMenuFcnArray[0] = this.selectRadio;
         this.mMenuFcnArray[1] = this.selectPlayer;
         this.mMenuFcnArray[2] = this.selectPhone;
         this.mMenuFcnArray[3] = this.selectApps;
         this.mMenuFcnArray[4] = this.selectApps;
         this.mMenuFcnArray[5] = this.selectNav;
         this.mMenuFcnArray[6] = this.selectClimate;
         this.mMenuFcnArray[7] = this.selectControls;
         this.mMenuFcnArray[8] = this.selectSettings;
         this.mMenuFcnArray[9] = this.selectECall;
         this.mMenuDeferredFcnArray[0] = null;
         this.mMenuDeferredFcnArray[1] = null;
         this.mMenuDeferredFcnArray[2] = null;
         this.mMenuDeferredFcnArray[3] = null;
         this.mMenuDeferredFcnArray[4] = null;
         this.mMenuDeferredFcnArray[5] = null;
         this.mMenuDeferredFcnArray[6] = null;
         this.mMenuDeferredFcnArray[7] = null;
         this.mMenuDeferredFcnArray[8] = null;
         this.mMenuDeferredFcnArray[9] = null;
         mView.radio_button.branch = Screens.MAIN_RADIO;
         mView.media_button.branch = Screens.MAIN_MEDIA;
         mView.climate_button.branch = Screens.MAIN_HVAC;
         mView.phone_button.branch = "mainbackground/menu/phonemainscreen";
         mView.more_button.branch = Screens.MAIN_APPS;
         mView.apps_button.branch = Screens.MAIN_APPS;
         mView.controls_button.branch = "vehiclesettingspopupscreen";
         mView.settings_button.branch = Screens.SETTINGS_SCREEN;
         mView.ecall_button.branch = "mainbackground/menu/emergencycall";
      }
      
      private function selectTuner() : void
      {
         Peripheral.audioManager.setSource(Peripheral.audioManager.lastRadioSource);
         switch(Peripheral.audioManager.lastRadioSource)
         {
            case Peripheral.audioManager.SOURCE_SAT:
               Framework.structure.goto(Screens.MAIN_SAT);
               break;
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_MW:
               if(Global.region != TunerRegion.NORTH_AMERICA)
               {
                  Framework.structure.goto(Screens.MAIN_RADIO);
               }
               else
               {
                  Framework.structure.goto(Screens.MAIN_FM,{"source":Peripheral.audioManager.lastRadioSource});
               }
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               Framework.structure.goto(Screens.MAIN_RADIO);
               break;
            case Peripheral.audioManager.SOURCE_FM:
               if(Global.market == TunerRegion.NORTH_AMERICA)
               {
                  Framework.structure.goto(Screens.MAIN_FM,{"source":Peripheral.audioManager.lastRadioSource});
               }
               else
               {
                  Framework.structure.goto(Screens.MAIN_RADIO);
               }
               break;
            case Peripheral.audioManager.SOURCE_DMB:
               Framework.structure.goto(Screens.MAIN_DMB);
               break;
            default:
               Framework.Trace("error: currentBranch" + Framework.structure.currentBranch + "not accepted");
         }
      }
      
      private function selectMediaPlayer() : void
      {
         Framework.structure.goto(mView.media_button.branch);
      }
      
      private function setButtonStates(branch:String) : void
      {
         var _domain:String = Framework.mapping.getDomain(branch);
         switch(Framework.mapping.getDomain(branch))
         {
            case Screens.DOMAIN_TUNER:
               this.mCurrentDomain = this.RADIO_INDEX;
               break;
            case Screens.DOMAIN_MEDIA:
               this.mCurrentDomain = this.PLAYER_INDEX;
               break;
            case Screens.DOMAIN_CLIMATE:
               this.mCurrentDomain = this.HVAC_INDEX;
               break;
            case Screens.DOMAIN_NAVIGATION:
               this.mCurrentDomain = this.NAV_INDEX;
               break;
            case Screens.DOMAIN_ECALL:
               this.mCurrentDomain = this.ECALL_INDEX;
               break;
            case Screens.DOMAIN_PHONE:
               this.mCurrentDomain = this.PHONE_INDEX;
               break;
            case Screens.DOMAIN_APPS:
               if(Global.market != TunerRegion.NORTH_AMERICA)
               {
                  this.mCurrentDomain = this.MORE_INDEX;
               }
               else
               {
                  this.mCurrentDomain = this.APPS_INDEX;
               }
               break;
            case Screens.DOMAIN_SETTINGS:
               if(this.mMenuVector[this.APPS_INDEX].visible && !this.mMenuVector[this.SETTINGS_INDEX].visible)
               {
                  this.mCurrentDomain = this.APPS_INDEX;
               }
               else
               {
                  this.mCurrentDomain = this.SETTINGS_INDEX;
               }
         }
         var i:int = int(this.mMenuVector.length);
         while(--i > -1)
         {
            if(i != this.CONTROLS_INDEX)
            {
               if(i == this.mCurrentDomain)
               {
                  if(this.mMenuVector[i].getSelected() != true)
                  {
                     this.mMenuVector[i].setSelected(true);
                  }
               }
               else if(this.mMenuVector[i].getSelected() != false)
               {
                  this.mMenuVector[i].setSelected(false);
               }
            }
         }
         this.onBluetoothStatus(null);
         this.displaySignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
      }
      
      private function onHardButtonClick(evt:WidgetEvent) : void
      {
         this.switchDomain(evt.data.identifier);
      }
      
      private function onMenuButtonClick(evt:WidgetEvent) : void
      {
         this.switchDomain(evt.currentTarget.identifier);
      }
      
      private function switchDomain(id:String) : void
      {
         var identifier:String = id;
         if(DynamicPopupNames.SMS_MESSAGE_FULL == Framework.popupManager.active || DynamicPopupNames.SMS_INCOMING_MESSAGE == Framework.popupManager.active)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_MESSAGE_FULL);
            Peripheral.smsMessaging.clearIncomingMessage(true);
         }
         mView.controls_button.tab.visible = false;
         Peripheral.appStateManager.onMainMenuButtonClick();
         switch(identifier)
         {
            case this.ID_RADIO:
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.radio_button.getSelected()))
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
                  this.clearMenuButtonSelection();
                  mView.radio_button.setSelected(true);
               }
               else
               {
                  this.clearMenuButtonSelection();
                  mView.radio_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_PLAYER:
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.media_button.getSelected()))
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.media_button.setSelected(true);
               }
               else
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.media_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_PHONE:
               Framework.Trace("MainMenu - isAssistAppRunningInBkgd:" + Peripheral.appStateManager.isAssistAppRunningInBkgd());
               if(Peripheral.appStateManager.isAssistAppRunningInBkgd())
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
               }
               else if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.phone_button.getSelected()))
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.phone_button.setSelected(true);
               }
               else
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.phone_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case "more":
            case this.ID_MORE:
            case this.ID_APP:
               Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
               if(Global.market == TunerRegion.NORTH_AMERICA)
               {
                  if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.apps_button.getSelected()))
                  {
                     Framework.popupManager.exit();
                     this.clearMenuButtonSelection();
                     mView.apps_button.setSelected(true);
                  }
                  else
                  {
                     Framework.popupManager.exit();
                     this.clearMenuButtonSelection();
                     mView.apps_button.setSelected(true);
                     addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                     this.mMenuDeferredTimer.reset();
                  }
               }
               else if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.more_button.getSelected()))
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.more_button.setSelected(true);
               }
               else
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.more_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_NAV:
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.nav_button.getSelected()))
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
                  this.clearMenuButtonSelection();
                  mView.nav_button.setSelected(true);
               }
               else
               {
                  if(!mView.nav_button.getSelected())
                  {
                     Framework.popupManager.exit();
                  }
                  this.clearMenuButtonSelection();
                  mView.nav_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_CLIMATE:
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.climate_button.getSelected()))
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.climate_button.setSelected(true);
               }
               else
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.climate_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_CONTROLS:
               this.selectControls();
               break;
            case this.ID_SETTINGS:
               if(!mView.settings_button.getEnabled())
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
                  return;
               }
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.settings_button.getSelected()))
               {
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.settings_button.setSelected(true);
               }
               else
               {
                  Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
                  Framework.popupManager.exit();
                  this.clearMenuButtonSelection();
                  mView.settings_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
               break;
            case this.ID_ECALL:
               if(Boolean(Framework.popupManager.active == DynamicPopupNames.CONTROLS) && Boolean(mView.controls_button.getSelected()) && Boolean(mView.ecall_button.getSelected()))
               {
                  this.clearMenuButtonSelection();
                  mView.ecall_button.setSelected(true);
               }
               else
               {
                  this.clearMenuButtonSelection();
                  mView.ecall_button.setSelected(true);
                  addEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
                  this.mMenuDeferredTimer.reset();
               }
         }
         this.mPreviousSelectedMenuButtonId = identifier;
      }
      
      private function clearMenuButtonSelection() : void
      {
         var btn:MovieClip = null;
         for each(btn in this.mMenuVector)
         {
            if(Boolean(btn.getSelected()) && btn.identifier != this.ID_CONTROLS)
            {
               btn.setSelected(false);
            }
         }
      }
      
      private function onMainMenuEnterFrame(evt:Event) : void
      {
         for(var j:Number = 0; j < this.mMenuVector.length; j++)
         {
            if(this.mMenuVector[j].getSelected() == true)
            {
               removeEventListener(Event.ENTER_FRAME,this.onMainMenuEnterFrame);
               if(this.mMenuFcnArray[j] != null)
               {
                  this.mMenuFcnArray[j]();
               }
               else
               {
                  Framework.structure.goto(this.mMenuVector[j].branch);
                  this.mMenuDeferredTimer.start();
               }
            }
         }
      }
      
      private function onMainMenuDeferredTimeout(evt:TimerEvent) : void
      {
         this.mMenuDeferredTimer.reset();
         for(var j:Number = 0; j < this.mMenuVector.length; j++)
         {
            if(this.mMenuVector[j].getSelected() == true && this.mMenuVector[j].branch == Framework.structure.currentBranch)
            {
               if(this.mMenuDeferredFcnArray[j] != null)
               {
                  this.mMenuDeferredFcnArray[j]();
               }
            }
         }
      }
      
      private function onClimateStateChange(evt:HvacEvent) : void
      {
         var climateState:Boolean = Boolean(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT));
         if(climateState == false)
         {
            mView.climate_button.icon.fan.gotoAndStop("fan0");
            this.mLastFanSpd = "off";
            mView.climate_button.icon.vents.gotoAndStop("off");
         }
         else
         {
            this.onVentStateChange(null);
            this.onFanSpeedChange(null);
         }
      }
      
      private function onAutoStateChange(evt:HvacEvent) : void
      {
         if(Peripheral.hvac.autoState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.AUTO_ON)
         {
            mView.climate_button.icon.fan.gotoAndStop("fan0");
            this.mLastFanSpd = "off";
            if(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT))
            {
               mView.climate_button.icon.vents.gotoAndStop("auto");
            }
         }
         else
         {
            this.onVentStateChange(null);
            this.onFanSpeedChange(null);
         }
      }
      
      private function procFanPopup(fanSpeed:String) : void
      {
         var mPopupClip:MovieClip = mView.fanSpeed_group;
         if(Framework.structure.currentBranch == Screens.MAIN_HVAC)
         {
            return;
         }
         if(fanSpeed == Peripheral.hvac.FAN_AUTO)
         {
            return;
         }
         if(this.mFanPopupTimer.running)
         {
            this.mFanPopupTimer.reset();
            this.mFanPopupTimer.start();
         }
         else
         {
            this.mFanPopupTimer.start();
         }
         mPopupClip.x = mView.climate_button.x - 44;
         mPopupClip.show();
         mView.root.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickOffFan);
         if(fanSpeed == Peripheral.hvac.FAN_OFF)
         {
            mPopupClip.value_label.visible = false;
         }
         else
         {
            mPopupClip.value_label.visible = true;
            mPopupClip.value_label.text = fanSpeed;
         }
         switch(fanSpeed)
         {
            case Peripheral.hvac.FAN_OFF:
               mPopupClip.fan.gotoAndStop("fan0");
               return;
            case "1":
               mPopupClip.fan.gotoAndStop("fan1");
               return;
            case "2":
               mPopupClip.fan.gotoAndStop("fan2");
               return;
            case "3":
               mPopupClip.fan.gotoAndStop("fan3");
               return;
            case "4":
               mPopupClip.fan.gotoAndStop("fan4");
               return;
            case "5":
               mPopupClip.fan.gotoAndStop("fan5");
               return;
            case "6":
               mPopupClip.fan.gotoAndStop("fan6");
               return;
            case "7":
               mPopupClip.fan.gotoAndStop("fan7");
               return;
            default:
               return;
         }
      }
      
      private function onFanSpeedChange(evt:HvacEvent) : void
      {
         var mClip:MovieClip = mView.climate_button.icon.fan;
         var fanSpeed:String = Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT);
         var climateState:Boolean = Boolean(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT));
         mClip.visible = true;
         if(this.mLastFanSpd != fanSpeed)
         {
            if(evt != null)
            {
               if(this.mFirstFanSpdChange || this.mLastFanSpd == "off" || fanSpeed == "off")
               {
                  this.mFirstFanSpdChange = false;
               }
               else
               {
                  this.procFanPopup(fanSpeed);
               }
            }
            this.mLastFanSpd = fanSpeed;
         }
         if(climateState != false)
         {
            switch(fanSpeed)
            {
               case Peripheral.hvac.FAN_AUTO:
                  mClip.gotoAndStop("fan0");
                  return;
               case Peripheral.hvac.FAN_OFF:
                  mClip.gotoAndStop("fan0");
                  return;
               case "1":
                  mClip.gotoAndStop("fan1");
                  return;
               case "2":
                  mClip.gotoAndStop("fan2");
                  return;
               case "3":
                  mClip.gotoAndStop("fan3");
                  return;
               case "4":
                  mClip.gotoAndStop("fan4");
                  return;
               case "5":
                  mClip.gotoAndStop("fan5");
                  return;
               case "6":
                  mClip.gotoAndStop("fan6");
                  return;
               case "7":
                  mClip.gotoAndStop("fan7");
                  return;
            }
         }
      }
      
      private function onVentStateChange(evt:HvacEvent) : void
      {
         var mClip:MovieClip = mView.climate_button.icon.vents;
         var climateState:Boolean = Boolean(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT));
         mClip.visible = true;
         if(climateState != false)
         {
            if(Peripheral.hvac.autoState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.AUTO_ON)
            {
               mClip.gotoAndStop("auto");
            }
            else
            {
               switch(Peripheral.hvac.ventMode(Peripheral.hvac.ZONE_FRONT))
               {
                  case Peripheral.hvac.VENT_DASH:
                     mClip.gotoAndStop("panel");
                     return;
                  case Peripheral.hvac.VENT_FLOOR:
                     mClip.gotoAndStop("floor");
                     return;
                  case Peripheral.hvac.VENT_MIX:
                     mClip.gotoAndStop("bilevel");
                     return;
                  case Peripheral.hvac.VENT_DEFROSTER_MIX:
                     mClip.gotoAndStop("defrostFloor");
                     return;
                  case Peripheral.hvac.VENT_DEFROSTER:
                     mClip.gotoAndStop("defrost");
                     return;
                  case Peripheral.hvac.VENT_OFF:
                     mClip.gotoAndStop("off");
                     return;
               }
            }
         }
      }
      
      private function onClickOffFan(evt:MouseEvent) : void
      {
         mView.fanSpeed_group.hide();
         evt.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickOffFan);
      }
      
      private function onFanPopupExpire(evt:TimerEvent) : void
      {
         this.mFanPopupTimer.stop();
         mView.fanSpeed_group.hide();
      }
      
      private function onGoto(evt:StructureEvent) : void
      {
         this.setButtonStates(evt.branch);
      }
      
      private function onNetworkRegistrationState(evt:BluetoothEvent) : void
      {
         this.displaySignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
      }
      
      private function onSignalQuality(evt:BluetoothEvent) : void
      {
         var signalQuality:int = int(evt.data);
         this.displaySignalQuality(signalQuality);
      }
      
      private function displaySignalQuality(signalQuality:int) : void
      {
         var prefix:String = null;
         if(Peripheral.bluetooth.currentHFPDevice != null && Boolean(Peripheral.bluetooth.currentHFPDevice.HfpConnected))
         {
            if(mView.phone_button.currentLabel.search("up") >= 0)
            {
               prefix = "inactive";
            }
            else
            {
               prefix = "active";
            }
            if(Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_HOME" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_ROAMING" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_UNKNOWN")
            {
               signalQuality = 0;
            }
            mView.phone_button.displaySignalStrength.visible = true;
            if(signalQuality == 0)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "0");
            }
            else if(signalQuality > 0 && signalQuality <= 5)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "1");
            }
            else if(signalQuality > 5 && signalQuality <= 9)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "2");
            }
            else if(signalQuality > 9 && signalQuality <= 16)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "3");
            }
            else if(signalQuality > 16 && signalQuality <= 21)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "4");
            }
            else if(signalQuality > 21)
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "5");
            }
            else
            {
               mView.phone_button.displaySignalStrength.gotoAndStop(prefix + "0");
            }
         }
         else
         {
            mView.phone_button.displaySignalStrength.visible = false;
         }
      }
      
      private function onBluetoothDisconnected(evt:BluetoothEvent) : void
      {
         this.onBluetoothStatus(evt);
      }
      
      private function onBluetoothStatus(evt:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentA2DPDevice != null && Boolean(Peripheral.bluetooth.currentA2DPDevice.A2dpConnected))
         {
            this.mCurrentAudioDeviceid = Peripheral.bluetooth.currentA2DPDevice.DevAddress;
         }
         if(Peripheral.bluetooth.currentHFPDevice != null && Boolean(Peripheral.bluetooth.currentHFPDevice.HfpConnected))
         {
            this.mPhoneConnected = true;
            this.mCurrentHFPDeviceId = Peripheral.bluetooth.currentHFPDevice.DevAddress;
            mView.phone_button.displayBluetooth.visible = true;
            if(mView.phone_button.currentLabel.search("up") >= 0)
            {
               mView.phone_button.displayBluetooth.gotoAndStop("connected");
            }
            else
            {
               mView.phone_button.displayBluetooth.gotoAndStop("active");
            }
         }
         else
         {
            mView.phone_button.displayBluetooth.gotoAndStop("disconnected");
            mView.phone_button.displaySignalStrength.visible = false;
            if("link_loss" == Peripheral.bluetooth.serviceDisconnectedReason && Peripheral.audioManager.SOURCE_BLUETOOTH == Peripheral.audioManager.source && true == this.mPhoneConnected)
            {
               if(this.mCurrentAudioDeviceid != this.mCurrentHFPDeviceId)
               {
                  this.mPhoneConnected = false;
               }
            }
         }
      }
      
      private function unHighlightAllMenuButtons() : void
      {
         var i:int = int(this.mMenuVector.length);
         while(--i > -1)
         {
            this.mMenuVector[i].setSelected(false);
         }
      }
      
      private function selectRadio() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         this.selectTuner();
      }
      
      private function selectPlayer() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         this.selectMediaPlayer();
      }
      
      private function selectPhone() : void
      {
         var isDeviceConnected:Boolean = false;
         if(Framework.structure.currentBranch != mView.phone_button.branch && Framework.structure.currentBranch != Screens.SETTINGS_BLUETOOTH)
         {
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
            Peripheral.navigation.navDomainControl.exitNavDomain();
            isDeviceConnected = Peripheral.bluetooth.currentHFPDevice != null && Boolean(Peripheral.bluetooth.currentHFPDevice.HfpConnected);
            if(false == isDeviceConnected && Peripheral.bluetooth.serviceDisconnectedReason != "" && Peripheral.audioManager.SOURCE_BLUETOOTH == Peripheral.audioManager.source && Peripheral.bluetooth.currentA2DPDevice != null && Peripheral.bluetooth.currentA2DPDevice.A2dpConnected == true)
            {
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"a2dp connected"
               });
            }
            else if(false == isDeviceConnected && Peripheral.appStateManager.isAssistAppRunningInBkgd() == false)
            {
               if(!Peripheral.vehicleStatus.speedLockOut)
               {
                  if(Peripheral.bluetooth.BT_Status == true)
                  {
                     Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                        "type":PopupType.PRIMARY,
                        "status":"no phone paired"
                     });
                  }
               }
            }
         }
         Framework.structure.goto(mView.phone_button.branch);
      }
      
      private function selectApps() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP_ON_STATION);
         Framework.structure.goto(mView.more_button.branch);
      }
      
      private function selectNav() : void
      {
         Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
         Peripheral.navigation.navDomainControl.onNavDomainButton();
      }
      
      private function selectClimate() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
         Framework.structure.goto(mView.climate_button.branch);
      }
      
      private function selectECall() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         Framework.structure.goto(mView.ecall_button.branch);
      }
      
      private function onPopupActive(e:PopupManagerEvent) : void
      {
         if(e.vars.id == DynamicPopupNames.CONTROLS)
         {
            mView.controls_button.setSelected(true);
            mView.controls_button.tab.visible = true;
         }
         else
         {
            mView.controls_button.setSelected(false);
            mView.controls_button.tab.visible = false;
         }
      }
      
      private function onPopupClose(e:PopupManagerEvent) : void
      {
         if(e.vars.id == DynamicPopupNames.CONTROLS)
         {
            this.controlsPopupTimeOut = true;
            mView.controls_button.setSelected(false);
            mView.controls_button.tab.visible = false;
         }
      }
      
      private function selectControls() : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.CONTROLS)
         {
            Framework.popupManager.close(GlobalEvent.CONTROLS_POPUP_CLOSED);
         }
         else
         {
            Peripheral.controlsPopupManager.showControlsPopup();
         }
      }
      
      private function selectSettings() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
         Framework.structure.goto(mView.settings_button.branch);
      }
      
      private function onCompassHeading(e:LocationEvent) : void
      {
         var heading:int = int(Peripheral.location.compassHeading);
         if(this.mVFM.hasCompass == true)
         {
            if(Peripheral.antiTheft.ignitionState != "accessory")
            {
               mView.nav_button.compassLabel.visible = true;
            }
            if(heading < this.compassArr.length && heading >= 0)
            {
               t(mView.nav_button.compassLabel,uint(this.compassArr[heading]));
            }
            else
            {
               mView.nav_button.compassLabel.text = "--";
            }
         }
         else
         {
            mView.nav_button.compassLabel.visible = false;
         }
      }
      
      private function onNetwork(e:CVPDemoEvent) : void
      {
         switch(Peripheral.cvpdemo.network)
         {
            case "3G":
               mView.apps_button.network.gotoAndStop(3);
               break;
            case "1x":
               mView.apps_button.network.gotoAndStop(2);
               break;
            default:
               mView.apps_button.network.gotoAndStop(1);
         }
      }
      
      private function onEmbeddedCellSignalQuality(e:CVPDemoEvent) : void
      {
         switch(Peripheral.cvpdemo.signalQuality)
         {
            case 0:
               mView.apps_button.signal.gotoAndStop(4);
               break;
            case 1:
            case 2:
               mView.apps_button.signal.gotoAndStop(1);
               break;
            case 3:
            case 4:
               mView.apps_button.signal.gotoAndStop(2);
               break;
            case 5:
            case 6:
               mView.apps_button.signal.gotoAndStop(3);
               break;
            default:
               mView.apps_button.signal.gotoAndStop(4);
         }
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         if(Peripheral.antiTheft.ignitionState == "accessory")
         {
            mView.nav_button.compassLabel.visible = false;
         }
         else
         {
            mView.nav_button.compassLabel.visible = this.mVFM.hasCompass;
         }
         mView.settings_button.setEnabled(Peripheral.antiTheft.ignitionState != "accessory");
      }
      
      private function onEmergencyCallState(e:EmergencyCallStateEvent) : void
      {
         this.updateEmergencyState();
      }
      
      private function updateEmergencyState() : void
      {
         var ecallMode:Boolean = true;
         switch(Peripheral.emergencyCallState.getEmergencyCallState())
         {
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING:
               t(mView.ecall_button.value_label,"9-1-1");
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
               t(mView.ecall_button.value_label,"9-1-1");
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
               if(Framework.structure.currentBranch == "mainbackground/menu/emergencycall")
               {
                  if(Peripheral.emergencyCallState.getECallType() == "emergency_callback")
                  {
                     t(mView.ecall_button.value_label,T.STRB_CALL);
                  }
                  else
                  {
                     t(mView.ecall_button.value_label,"9-1-1");
                  }
               }
               else if(Peripheral.emergencyCallState.getECallType() == "emergency_callback")
               {
                  t(mView.ecall_button.value_label,T.STRB_CALL);
               }
               else
               {
                  t(mView.ecall_button.value_label,"9-1-1");
               }
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END:
               if(Peripheral.emergencyCallState.getECallType() == "emergency_callback")
               {
                  t(mView.ecall_button.value_label,T.STRB_CALL);
               }
               else
               {
                  t(mView.ecall_button.value_label,"9-1-1");
               }
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY:
               t(mView.ecall_button.value_label,"9-1-1");
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK:
               t(mView.ecall_button.value_label,T.STRB_CALL);
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
               ecallMode = false;
         }
         mView.ecall_button.visible = ecallMode;
         mView.phone_button.visible = !ecallMode;
      }
   }
}

