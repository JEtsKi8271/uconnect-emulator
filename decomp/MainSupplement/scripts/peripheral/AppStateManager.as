package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Extensions;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.moduleLink.AppManager;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.Applet;
   import com.harman.moduleLinkAPI.ConnectionManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.HEVEvent;
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.moduleLinkAPI.PPSEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.PhoneProjectionEvent;
   import com.harman.moduleLinkAPI.RSEConstants;
   import com.harman.moduleLinkAPI.SatAdvisoryMessageTypes;
   import com.harman.moduleLinkAPI.TunerSeek;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.Shortcuts;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.moduleLink.MediaErrorCodes;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerPath;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioInstantReplayEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import core.events.StructureEvent;
   import events.EmergencyCallStateEvent;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import locale.T;
   
   public class AppStateManager
   {
      
      private static var instance:AppStateManager;
      
      public static const ASSIST_APP:String = "3bbeae36-1542-11e1-b393-31614824019b";
      
      public static const SUPERAPP_ID:String = "100";
      
      private static const PHONE_RECENT_CALLS_PATH:String = "mainbackground/menu/phonerecentcallscreen";
      
      private static const PHONEBOOK_PATH:String = "mainbackground/menu/PhonebookScreen";
      
      private static const TRAVEL_LINK_WEATHER_PATH:String = "mainbackground/menu/travellinkweatherscreen";
      
      private static const NO_ECALL_YET:String = "No_Ecall_Yet";
      
      private var currentSource:String = "";
      
      private var mAudioSourceService:String = "";
      
      private var mLastSource:String = "";
      
      private var mBrowseHistory:Object = new Object();
      
      private var mBrowseScreen:String = "";
      
      private var mLastModeBrowse:Boolean = false;
      
      private var mPendingBranch:Boolean = false;
      
      private var mPrevPhoneBranch:String = null;
      
      private var mSplitScreen:Object = new Object();
      
      private var mScreenVarsHistory:Dictionary;
      
      private var mCachedAdvisoryMessage:String = "";
      
      private var mXmAdvisory:Boolean = false;
      
      private var mPhoneIsRinging:Boolean = false;
      
      private var mDisplayOFFScreen:String = "";
      
      private var mPrevScreenBeforeActiveCall:String = "";
      
      private var mReturnToScreenAfterEcall:String = "No_Ecall_Yet";
      
      private var mIsAppMainScreen:Boolean = false;
      
      private var mVFM:VehicleFeatureManager = new VehicleFeatureManager();
      
      private var mAssistAppInBkgd:Boolean = false;
      
      private var mCurrentAdvisoryPopup:String = "";
      
      private var mWasAntiTheftPopupUp:Boolean = false;
      
      private var mSrcChangeDuringScreenOff:Boolean = false;
      
      private var mSrcChangeOverride:Boolean = false;
      
      private var mTrailerSelectedForBrowse:String = "";
      
      private var mTrailerSelectedForBrowseId:int = 0;
      
      private var mForegroundAvailability:String = "";
      
      private var mRejectReason:String = "";
      
      private var mPendingChange:Boolean = false;
      
      private var mEcallErrorScreenStatus:Boolean = false;
      
      private var mTransferDelay:Boolean = false;
      
      private var mProjectionDeviceTimer:Timer = new Timer(30000,1);
      
      private var mblockActiveAppScreenSwith:Boolean = false;
      
      private var mStartingApp:String = "";
      
      private var mAppStartedHeptically:Boolean = false;
      
      private var mAudioAppActive:Boolean = false;
      
      private var mIsAudioScreen:Boolean = false;
      
      private var mContext:String = Peripheral.voiceRecognition.DEFAULT;
      
      private var mPrePopupVRContext:String = "";
      
      public var mPerfPagesPaused:Boolean = false;
      
      public var ppReady:Boolean = true;
      
      private var mbAssistWhileScreenOff:Boolean = false;
      
      public var activePpId:String = "";
      
      public var newPpId:String = "";
      
      public function AppStateManager()
      {
         super();
      }
      
      public static function getInstance() : AppStateManager
      {
         if(instance == null)
         {
            instance = new AppStateManager();
         }
         return instance;
      }
      
      public static function create() : AppStateManager
      {
         if(null == Peripheral.appStateManager)
         {
            Peripheral.appStateManager = new AppStateManager();
         }
         return Peripheral.appStateManager;
      }
      
      public function init() : void
      {
         var lastSplitScreen:String = Peripheral.persistency.getValue(PersistencyKeys.KEY_SPLITSCREEN).value;
         if(lastSplitScreen == "map")
         {
            this.mSplitScreen[Screens.MAIN_FM] = lastSplitScreen;
            this.mSplitScreen[Screens.MAIN_SAT] = lastSplitScreen;
            this.mSplitScreen[Screens.MAIN_RADIO] = lastSplitScreen;
            this.mSplitScreen[Screens.MAIN_MEDIA] = lastSplitScreen;
         }
         else
         {
            switch(Global.lastBranch)
            {
               case "radiohomescreen":
               case "sathomescreen":
               case "fmhomescreen":
                  this.mSplitScreen[Screens.MAIN_FM] = lastSplitScreen;
                  this.mSplitScreen[Screens.MAIN_SAT] = lastSplitScreen;
                  this.mSplitScreen[Screens.MAIN_RADIO] = lastSplitScreen;
                  break;
               case "playerhomescreen":
                  this.mSplitScreen[Screens.MAIN_MEDIA] = lastSplitScreen;
            }
         }
         Framework.screens.goto(Screens.BACKGROUND,Layers.BOTTOM);
         Framework.screens.goto(Screens.POPUP_PROMPT,Layers.PROMPT);
         if(Framework.resolution != Framework.RES_800_480)
         {
            if(Global.taskBarEnabled)
            {
               Framework.screens.goto(Screens.TASK_BAR,Layers.TASKBAR);
               Framework.screens.goto(Screens.STATUS_BAR,Layers.STATUS);
            }
            else
            {
               Framework.screens.goto(Screens.MAIN_MENU,Layers.TASKBAR);
               Framework.screens.goto(Screens.STATUS_BAR,Layers.STATUS);
            }
         }
         else
         {
            Framework.screens.goto(Screens.MAIN_MENU,Layers.STATUS);
         }
         this.mScreenVarsHistory = new Dictionary();
         var _screenFromSource:String = this.branchNameFromSource(Peripheral.audioManager.source);
         var _screenFromPersis:String = "";
         switch(Global.lastBranch)
         {
            case "appshomescreen":
               Framework.structure.goto(Screens.APPS_HOME);
               break;
            case "radiohomescreen":
               _screenFromPersis = Screens.MAIN_RADIO;
               if(_screenFromSource == "")
               {
                  _screenFromSource = _screenFromPersis;
               }
               Framework.structure.goto(_screenFromPersis != _screenFromSource ? _screenFromSource : _screenFromPersis);
               break;
            case "dmbhomescreen":
               _screenFromPersis = Screens.MAIN_DMB;
               if(_screenFromSource == "")
               {
                  _screenFromSource = _screenFromPersis;
               }
               Framework.structure.goto(_screenFromPersis != _screenFromSource ? _screenFromSource : _screenFromPersis);
               break;
            case "sathomescreen":
               _screenFromPersis = Screens.MAIN_SAT;
               if(_screenFromSource == "")
               {
                  _screenFromSource = _screenFromPersis;
               }
               Framework.structure.goto(_screenFromPersis != _screenFromSource ? _screenFromSource : _screenFromPersis);
               break;
            case "fmhomescreen":
               this.mLastSource = "fm";
               _screenFromPersis = Screens.MAIN_FM;
               if(_screenFromSource == "")
               {
                  _screenFromSource = _screenFromPersis;
               }
               Framework.structure.goto(_screenFromPersis != _screenFromSource ? _screenFromSource : _screenFromPersis);
               break;
            case "playerhomescreen":
               _screenFromPersis = Screens.MAIN_MEDIA;
               if(_screenFromSource == "")
               {
                  _screenFromSource = _screenFromPersis;
               }
               Framework.structure.goto(_screenFromPersis != _screenFromSource ? _screenFromSource : _screenFromPersis);
               break;
            case "deviceprojection":
               Peripheral.phoneProjection.addEventListener(PhoneProjectionEvent.PROJECTION_DEVICE_LIST,this.onDeviceList);
               Peripheral.phoneProjection.queryDeviceList();
               break;
            case "phonemainscreen":
               Framework.structure.goto(Screens.MAIN_PHONE);
               break;
            case "navmainmenuscreen":
               Framework.structure.updateHistory({
                  "branch":"mainbackground/menu/navmainmenuscreen",
                  "variables":null,
                  "exitPoint":false
               });
               Peripheral.navigation.navDomainControl.onNavDomainButton();
               break;
            case "navmapmainscreen":
               Framework.structure.updateHistory({
                  "branch":"mainbackground/menu/navmapmainscreen",
                  "variables":null,
                  "exitPoint":false
               });
               Peripheral.navigation.navDomainControl.onNavDomainButton();
               break;
            case "hvachomescreen":
               Framework.structure.goto(Screens.MAIN_HVAC);
               break;
            case "appsmainscreen":
               if(Peripheral.appManager.getAppsExist() == "true")
               {
                  Framework.structure.goto(Screens.MAIN_APPS);
               }
               else if(Peripheral.vehConfig.vehicleLine == "Fiat334")
               {
                  Framework.structure.goto(Screens.MORE_MAIN);
               }
               else if(_screenFromSource != Screens.APPS_ACTIVE)
               {
                  Framework.structure.goto(_screenFromSource);
               }
               else
               {
                  Framework.structure.goto(Screens.APPS_HOME);
               }
               break;
            case "rearmediascreen":
               Framework.structure.goto(Screens.REAR_MEDIA);
               break;
            case "amhomescreen":
               if(Global.region == TunerRegion.NORTH_AMERICA)
               {
                  Framework.structure.goto(Screens.MAIN_FM);
               }
               else
               {
                  Framework.structure.goto(Screens.MAIN_RADIO);
               }
            default:
               Framework.structure.goto(_screenFromSource);
         }
         this.updateVRContext(Framework.structure.currentBranch);
         Peripheral.emergencyCallState.addEventListener(EmergencyCallStateEvent.EMERGENCY_CALLSTATE,this.onEmergencyCallState,false,0,true);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.BRINGUP_SOURCE_POPUP,this.onSourcePopup);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.APP_SCREEN_FOCUS_TYPE,this.onAppScreenFocusType);
         Peripheral.emergencyCallState.addEventListener(EmergencyCallStateEvent.EMERGENCY_SWITCHTO_ECALLSCREEN,this.onSwitchToEcallScreen,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.CALL_STATE,this.onCallState,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.HANDS_FREE_MODE,this.onCallState,false,0,true);
         Peripheral.mediaPlayer.addEventListener(VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.MEDIA_ERROR,this.onMediaError);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.DEVICE,this.onMediaDevice);
         Peripheral.mediaPlayer.addEventListener(VoiceRecognitionEvent.VR_RESULT,this.onVRResult);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_MEDIAFILTERLISTSHOW,this.onVRmediaFilterListShow);
         Peripheral.hardControls.addEventListener(HardControlEvent.SCREEN_OFF,this.onScreenOff);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.APP_REQUEST_FOREGROUND,this.onAppRequestForeground);
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_REARCAMERA_STATUS,this.onStateChange);
         Framework.popupManager.addEventListener(PopupManagerEvent.EMPTY,this.onStateChange);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onStateChange);
         Framework.popupManager.addEventListener(PopupManagerEvent.ACTIVE,this.onStateChange);
         Peripheral.emergencyCallState.addEventListener(EmergencyCallStateEvent.EMERGENCY_CALLSTATE,this.onStateChange);
         Peripheral.appManager.addEventListener(AppManagerEvent.INVOKE_BACK,this.onInvokeBack);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppMngrReady);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onPowerModeStateChange);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_CLOSE_SCREEN_OFF,this.onCloseScreenOnff);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionChange);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosition);
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavigationOperable,false,0,true);
         Peripheral.navigation.navDomainControl.getNavIsOperable();
         Framework.structure.addEventListener(StructureEvent.GOTO,this.onGoto);
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.checkForXmState);
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.checkForXmState,false,10);
         Peripheral.satelliteRadioIR.addEventListener(SatelliteRadioInstantReplayEvent.PLAY_STATUS,this.checkForXmState);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_VR_IN_FOCUS,this.appInFocus);
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.START_XLET_ERROR,this.onStartXletError,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.STOP_START_APP,this.onStopStartApp,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_STOPPED_STARTED,this.onAppStoppedStarted,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_PAUSED,this.onAppPaused,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.TOO_MANY_APPS,this.onTooManyApps,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.START_RUNNING_APP,this.onStartRunningApp,false,0,true);
         Peripheral.hmiRequest.addEventListener(VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.SWITCH_TO_DRIVEMODE,this.onSwitchToDriveMode);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.WAITING_FOR_AMS_TO_START_ASSIST_APP,this.onWaitingForAMSToStartAssistApp);
         Peripheral.hmiRequest.addEventListener(AppManagerEvent.APP_REQUEST_RUNNING_SCREEN,this.onRequestRunningScreen);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.SET_NAV_REPEAT_PROMPT,this.onSetNavRepeatPrompt);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.SET_APP_VISIBLE,this.onSetAppVisible);
         Peripheral.hmiRequest.addEventListener(AppManagerEvent.ASSIST_REQUEST,this.onAssistRequest);
         Framework.popupManager.addEventListener(PopupManagerEvent.CLOSE,this.onPopupManagerClose,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.TIMEOUT,this.onPopupManagerTimeout,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.TERRAIN_MODE,this.onTerrainModeChange,false,0,true);
         Framework.structure.addEventListener(StructureEvent.ACTIVATE_NAV,this.onActivateNavigation,false,0,true);
         Framework.structure.addEventListener(StructureEvent.LEAVING_NAV,this.onLeavingNav,false,0,true);
         Peripheral.hev.addEventListener(HEVEvent.ENBL_CHRG_NOW_POPUP_UPDATE,this.onEnableChargeNowPopUp,false,0,true);
         Peripheral.persistency.read(PersistencyKeys.KEY_PHEV_SELECTED_TAB);
         Peripheral.phoneProjection.addEventListener(PhoneProjectionEvent.PROJECTION_STATUS,this.onPhoneProjectionStatus,false,0,true);
         Peripheral.phoneProjection.addEventListener(PhoneProjectionEvent.PROJECTIONDEVICE_READY,this.onProjectionDeviceConnected,false,0,true);
         Peripheral.phoneProjection.addEventListener(PhoneProjectionEvent.PROJECTIONDEVICE_NOTREADY,this.onProjectionDeviceDisconnected,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.EPB_SERVICE_ACTIVE_ALERT,this.onEPBServiceActiveAlert,false,0,true);
         if(Peripheral.vehicleStatus.EPBServiceActiveAlert)
         {
            this.onEPBServiceActiveAlert(null);
         }
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEATED_STEERING_WHEEL_FAIL_POPUP,this.onHeatWheelFailure,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEAT_SEAT_FL_FAIL_POPUP,this.onFLHeatedSeatFailure,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEAT_SEAT_FR_FAIL_POPUP,this.onFRHeatedSeatFailure,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.VENT_SEAT_FL_FAIL_POPUP,this.onFLVentedSeatFailure,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.VENT_SEAT_FR_FAIL_POPUP,this.onFRVentedSeatFailure,false,0,true);
      }
      
      public function setBlockActiveAppScreenSwitch(doswitch:Boolean) : void
      {
         this.mblockActiveAppScreenSwith = doswitch;
      }
      
      public function shouldBlockActiveAppScreenSwitch() : Boolean
      {
         return this.mblockActiveAppScreenSwith == false && this.mStartingApp != "";
      }
      
      public function isAppWithAudio() : Boolean
      {
         return this.mIsAudioScreen || this.mAudioAppActive;
      }
      
      private function onOperStatusUpdate(e:AppManagerEvent) : void
      {
         var switchToAppMenu:Boolean = false;
         switch(e.mData.operStatus.state)
         {
            case "initializing":
            case "starting":
               Peripheral.hmiRequest.hmiSendAppScreenActiveState(false);
               if(e.mData.operStatus.appId == ASSIST_APP && Framework.popupManager.active == DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY);
               }
               if(this.mIsAppMainScreen || this.mAppStartedHeptically == false)
               {
                  if(!(Boolean(e.mData.operStatus.daemon) && e.mData.operStatus.appId != Peripheral.appManager.getSuperAppId()))
                  {
                     if(Framework.structure.currentBranch != Screens.DISPLAY_OFF)
                     {
                        if(!Framework.popupManager.check(DynamicPopupNames.INFO_APPS_STOP_START) && this.mblockActiveAppScreenSwith == false)
                        {
                           if(this.mAppStartedHeptically == false)
                           {
                              if(Peripheral.emergencyCallState.getInEmergency() != true && Framework.structure.currentBranch != Screens.APPS_ACTIVE)
                              {
                                 if(e.mData.operStatus.appId != Peripheral.appManager.getSuperAppId())
                                 {
                                    Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_LOADING,{
                                       "screen":DynamicPopupNames.INFO_APPS_LOADING,
                                       "state":"initializing",
                                       "name":e.mData.operStatus.name
                                    });
                                    Framework.structure.goto(Screens.MAIN_APPS);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               if(e.mData.operStatus.type == "audio" || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId())
               {
                  this.mAudioAppActive = true;
               }
               else
               {
                  this.mAudioAppActive = false;
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId() && Peripheral.appManager.isSuperAppInAppsList)
               {
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_VIA_MOBILE_UPDATING)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_VIA_MOBILE_UPDATING);
                  }
                  if(Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "NA" || Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "CH")
                  {
                     Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VIA_MOBILE_LOADING,{"name":"Uconnect LIVE"});
                  }
                  else
                  {
                     Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_UCONN_LOADING,{"name":e.mData.operStatus.name});
                  }
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getPPId())
               {
                  this.ppReady = false;
               }
               break;
            case "running":
               this.mAppStartedHeptically = false;
               switchToAppMenu = (e.mData.operStatus.daemon == false || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId()) && ((this.mIsAppMainScreen || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId()) && this.mblockActiveAppScreenSwith == false);
               if(switchToAppMenu && Framework.structure.currentBranch != Screens.APPS_ACTIVE)
               {
                  if(Framework.structure.currentBranch != Screens.DISPLAY_OFF)
                  {
                     Peripheral.hmiRequest.hmiSendAppScreenActiveState(true);
                     Framework.structure.goto(Screens.APPS_ACTIVE,null,true);
                  }
               }
               else
               {
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_VIA_MOBILE_LOADING)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_VIA_MOBILE_LOADING);
                  }
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_UCONN_LOADING)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_UCONN_LOADING);
                  }
               }
               if(e.mData.operStatus.type == "audio" || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId())
               {
                  this.mAudioAppActive = true;
               }
               else
               {
                  this.mAudioAppActive = false;
               }
               if(switchToAppMenu == false && Framework.structure.currentBranch != Screens.APPS_ACTIVE && (e.mData.operStatus.daemon == false || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId()))
               {
                  Framework.Trace("app is running and we are not switching to appsActive screen, pause the app");
                  Peripheral.appManager.pauseXlet(e.mData.operStatus.appId);
               }
               if(Framework.structure.currentBranch == Screens.DISPLAY_OFF && (e.mData.operStatus.daemon == false || e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId()))
               {
                  Peripheral.appManager.pauseXlet(e.mData.operStatus.appId);
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getPPId())
               {
                  this.ppReady = true;
               }
               break;
            case "paused":
               if(e.mData.operStatus.appId == Peripheral.appManager.getPPId())
               {
                  this.ppReady = true;
               }
               if(e.mData.operStatus.type == "audio" && Peripheral.audioManager.isSOURCE_HTTPSTREAMER(Peripheral.audioManager.source) && this.changeScreenWithSource(Framework.structure.currentBranch) && Framework.structure.currentBranch != Screens.APPS_ACTIVE && !this.isScreenOff())
               {
                  Peripheral.audioManager.setSource(this.mLastSource);
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId() && Peripheral.appManager.isSuperAppInAppsList)
               {
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_VIA_MOBILE_LOADING)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_VIA_MOBILE_LOADING);
                  }
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_UCONN_LOADING)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_UCONN_LOADING);
                  }
               }
               break;
            case "stopping":
               Peripheral.hmiRequest.hmiSendAppScreenActiveState(false);
               if(e.mData.operStatus.type == "audio")
               {
                  this.mAudioAppActive = false;
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getPPId())
               {
                  this.ppReady = false;
               }
               if(Peripheral.versionInfo.productVariantID.VARIANT_MARKET != "NA" && Peripheral.versionInfo.productVariantID.VARIANT_MARKET != "CH" && e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId() && Peripheral.appManager.isSuperAppInAppsList && Framework.structure.currentBranch == Screens.APPS_ACTIVE)
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_UCONN_LOADING,{"name":e.mData.operStatus.name});
               }
               break;
            case "stopped":
               Peripheral.hmiRequest.hmiSendAppScreenActiveState(false);
               this.mAppStartedHeptically = false;
               if(e.mData.operStatus.appId == ASSIST_APP)
               {
                  this.mAssistAppInBkgd = false;
                  if(Framework.popupManager.active == DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
                  }
                  if(this.mbAssistWhileScreenOff)
                  {
                     this.mbAssistWhileScreenOff = false;
                     if(Framework.resolution == Framework.RES_640_480)
                     {
                        Framework.structure.goto(Screens.DISPLAY_OFF);
                     }
                  }
               }
               if(Framework.popupManager.check(DynamicPopupNames.INFO_APPS_LOADING))
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
               }
               if(Framework.popupManager.active == DynamicPopupNames.INFO_VIA_MOBILE_LOADING)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.INFO_VIA_MOBILE_LOADING);
               }
               if(e.mData.operStatus.appId == Peripheral.appManager.getPPId())
               {
                  this.ppReady = true;
               }
               break;
            case "installing":
               if(e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId() && (Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "NA" || Peripheral.versionInfo.productVariantID.VARIANT_MARKET == "CH"))
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VIA_MOBILE_UPDATING,{"name":"Uconnect LIVE"});
               }
               break;
            default:
               Peripheral.hmiRequest.hmiSendAppScreenActiveState(false);
               this.mAppStartedHeptically = false;
               Framework.Trace("default: " + this.mAssistAppInBkgd);
         }
         if(this.mAssistAppInBkgd)
         {
            if(Framework.popupManager.active == DynamicPopupNames.PHONE_PAIRING)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.PHONE_PAIRING);
            }
         }
      }
      
      private function onInvokeBack(e:AppManagerEvent) : void
      {
         if(Peripheral.appManager.getRunningAppId() == e.mData && Framework.structure.currentBranch == Screens.APPS_ACTIVE)
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "VP3" || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "VP4" || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               Framework.structure.goto(Screens.APPS_HOME);
            }
            else
            {
               Framework.structure.goto(Screens.MORE_MAIN);
            }
         }
      }
      
      private function onAppMngrReady(e:AppManagerEvent) : void
      {
         this.mIsAudioScreen = Peripheral.appManager.getIsSuperAppSystem();
      }
      
      private function onAppPaused(e:AppManagerEvent) : void
      {
         this.mAppStartedHeptically = false;
         if(Peripheral.appManager.getLastRunningAppId() == ASSIST_APP)
         {
            this.mAssistAppInBkgd = e.mData == ASSIST_APP;
         }
         if(e.mData == "999")
         {
            if(Framework.structure.currentBranch != Screens.APPS_ACTIVE && Peripheral.appManager.getRunningAppId() != "")
            {
               Peripheral.appManager.pauseXlet(Peripheral.appManager.getRunningAppId());
            }
         }
         if(Peripheral.appManager.getIsSuperAppSystem() && Peripheral.appManager.getSuperAppId() == e.mData && Framework.structure.currentBranch == Screens.APPS_ACTIVE)
         {
            Framework.structure.back();
         }
      }
      
      private function onTooManyApps(e:AppManagerEvent) : void
      {
         if(e.mData.tooManyApps.hasOwnProperty("requireClosedID"))
         {
            Framework.popupManager.show(DynamicPopupNames.RESOURCE_LIMIT_REACHED,"PopupResourceLimitReached.swf",{
               "type":PopupType.PRIMARY,
               "data":e.mData.tooManyApps.requireClosedID
            });
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.RESOURCE_LIMIT_REACHED,"PopupResourceLimitReached.swf",{
               "type":PopupType.PRIMARY,
               "data":null
            });
         }
      }
      
      private function updateStartingAppId(appOperStatus:Object) : void
      {
         if(appOperStatus.daemon == true)
         {
            return;
         }
         if(this.mStartingApp == "" && appOperStatus.state == "initializing")
         {
            this.mStartingApp = appOperStatus.appId;
            Framework.Trace("set mStartingApp to " + this.mStartingApp);
         }
         else if((appOperStatus.state == "stopped" || appOperStatus.state == "running") && appOperStatus.appId == this.mStartingApp)
         {
            Framework.Trace("initializing app (" + appOperStatus.appId + ") is " + appOperStatus.state + ". make sure mblockActiveAppScreenSwith is set to false");
            this.mblockActiveAppScreenSwith = false;
            this.mStartingApp = "";
         }
         else
         {
            Framework.Trace("don\'t care. mStartingApp is " + this.mStartingApp + ", this appOperStatus = " + appOperStatus.state + " is for appId " + appOperStatus.appId);
         }
      }
      
      private function onSetAppVisible(e:HMIRequestEvent) : void
      {
         this.mIsAppMainScreen = true;
         Peripheral.hmiRequest.setAppVisibleResult(true);
      }
      
      private function onStartXletError(e:AppManagerEvent) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
      }
      
      private function onStopStartApp(e:AppManagerEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_STOP_START,{
            "screen":DynamicPopupNames.INFO_APPS_STOP_START,
            "srcName":e.mData.stopStartApp.srcName,
            "destName":e.mData.stopStartApp.destName
         });
      }
      
      private function onAppStoppedStarted(e:AppManagerEvent) : void
      {
         if(Framework.popupManager.check(DynamicPopupNames.INFO_APPS_STOP_START))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_STOP_START);
         }
      }
      
      private function onVRResult(e:VoiceRecognitionEvent) : void
      {
         if(e.mData.Result == "invalid")
         {
            Peripheral.voiceRecognition.emitInvalidVRResponse(e.mData.Context,e.mData.methodName);
         }
         else
         {
            Peripheral.voiceRecognition.emitVRResponse(e.mData.Context,e.mData.methodName,e.mData.Result);
         }
      }
      
      public function onMainMenuButtonClick() : void
      {
         this.mPrevScreenBeforeActiveCall = "";
      }
      
      public function set lastModeBrowse(value:Boolean) : void
      {
         this.mLastModeBrowse = value;
      }
      
      public function get lastModeBrowse() : Boolean
      {
         return this.mLastModeBrowse;
      }
      
      public function set browseScreen(value:String) : void
      {
         this.mBrowseScreen = value;
      }
      
      public function get browseScreen() : String
      {
         return this.mBrowseScreen;
      }
      
      public function set browseHistory(value:Object) : void
      {
         this.mBrowseHistory = value;
      }
      
      public function get browseHistory() : Object
      {
         return this.mBrowseHistory;
      }
      
      public function set lastSource(value:String) : void
      {
         this.mLastSource = value;
      }
      
      public function get lastSource() : String
      {
         return this.mLastSource;
      }
      
      public function set splitScreenSource(splitScreen:String) : void
      {
         if(splitScreen == "map")
         {
            this.mSplitScreen[Screens.MAIN_FM] = splitScreen;
            this.mSplitScreen[Screens.MAIN_SAT] = splitScreen;
            this.mSplitScreen[Screens.MAIN_RADIO] = splitScreen;
            this.mSplitScreen[Screens.MAIN_MEDIA] = splitScreen;
         }
         if(this.mSplitScreen.hasOwnProperty(Framework.structure.currentBranch) && this.mSplitScreen[Framework.structure.currentBranch] == "map" && splitScreen != "map")
         {
            this.mSplitScreen[Screens.MAIN_FM] = splitScreen;
            this.mSplitScreen[Screens.MAIN_SAT] = splitScreen;
            this.mSplitScreen[Screens.MAIN_RADIO] = splitScreen;
            this.mSplitScreen[Screens.MAIN_MEDIA] = splitScreen;
         }
         else if(Framework.structure.currentBranch == Screens.MAIN_FM || Framework.structure.currentBranch == Screens.MAIN_SAT || Framework.structure.currentBranch == Screens.MAIN_RADIO)
         {
            this.mSplitScreen[Screens.MAIN_FM] = splitScreen;
            this.mSplitScreen[Screens.MAIN_SAT] = splitScreen;
            this.mSplitScreen[Screens.MAIN_RADIO] = splitScreen;
         }
         else
         {
            this.mSplitScreen[Framework.structure.currentBranch] = splitScreen;
         }
         Peripheral.persistency.write(PersistencyKeys.KEY_SPLITSCREEN,{"value":splitScreen});
      }
      
      public function get splitScreenSource() : String
      {
         if(!this.mSplitScreen.hasOwnProperty(Framework.structure.currentBranch))
         {
            return "none";
         }
         return this.mSplitScreen[Framework.structure.currentBranch];
      }
      
      public function onAppScreenFocusType(event:HMIRequestEvent) : void
      {
         this.mIsAudioScreen = event.mData.appScreenFocusType.isAudio;
         Peripheral.hmiRequest.appScreenFocusTypeResponse();
      }
      
      public function onSourcePopup(event:HMIRequestEvent) : void
      {
         if(Peripheral.displayManager.RearCameraStatus)
         {
            Peripheral.hmiRequest.bringUpSourcePopUpReturnResult(1,"RearCameraActive");
         }
         else if(this.isScreenOff())
         {
            Peripheral.hmiRequest.bringUpSourcePopUpReturnResult(2,"DisplayOff");
         }
         else if(Peripheral.voiceRecognition.VRSessionInProgress)
         {
            Peripheral.hmiRequest.bringUpSourcePopUpReturnResult(3,"VRInProgress");
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.OPTIONS_MEDIA_SOURCES,"PopupPlayerSource.swf",{
               "type":PopupType.PRIMARY,
               "timeout":0
            });
            Peripheral.hmiRequest.bringUpSourcePopUpReturnResult(0,"Success");
         }
      }
      
      public function onStateChange(event:Event) : void
      {
         switch(event.type)
         {
            case PopupManagerEvent.ACTIVE:
               if(Framework.popupManager.active != -1)
               {
                  Peripheral.hmiRequest.sendPopupActiveState(true,Framework.popupManager.type);
               }
               this.updateVRPopupContext(Framework.popupManager.active);
               break;
            case PopupManagerEvent.EMPTY:
               Peripheral.hmiRequest.sendPopupActiveState(false,Framework.popupManager.type);
               this.updateVRContext(this.mPrePopupVRContext);
         }
         if(this.mPendingChange)
         {
            this.mForegroundAvailability = this.checkForegroundAvailability();
            if(this.mForegroundAvailability == "true")
            {
               Peripheral.hmiRequest.appRequestForegroundReturnSignal(true,"stateChanged");
               this.mPendingChange = false;
            }
         }
      }
      
      private function checkForegroundAvailability() : String
      {
         if(Peripheral.displayManager.RearCameraStatus)
         {
            this.mRejectReason = "RearCamera";
            return this.mRejectReason;
         }
         if(this.isScreenOff())
         {
            this.mRejectReason = "DisplayOff";
            return this.mRejectReason;
         }
         if(Framework.popupManager.active != -1 && Framework.popupManager.active != 0)
         {
            this.mRejectReason = "Popup";
            return this.mRejectReason;
         }
         if(this.mEcallErrorScreenStatus)
         {
            this.mRejectReason = "FullPopScreen";
            return this.mRejectReason;
         }
         this.mRejectReason = "true";
         return this.mRejectReason;
      }
      
      private function onAppRequestForeground(event:Event) : void
      {
         this.mForegroundAvailability = this.checkForegroundAvailability();
         if(!this.mPendingChange)
         {
            if(this.mForegroundAvailability != "true")
            {
               Peripheral.hmiRequest.appRequestForegroundReturnResult(false,this.mForegroundAvailability);
               this.mPendingChange = true;
            }
            else
            {
               this.appStartedHeptically = false;
               Peripheral.hmiRequest.appRequestForegroundReturnResult(true,"");
            }
         }
      }
      
      private function isScreenOff() : Boolean
      {
         return Boolean(Framework.popupManager.check(DynamicPopupNames.SCREEN_OFF)) || Framework.structure.currentBranch == Screens.DISPLAY_OFF;
      }
      
      public function isAssistAppRunningInBkgd() : Boolean
      {
         return this.mAssistAppInBkgd;
      }
      
      public function set assistAppRunningInBkgd(isRunning:Boolean) : void
      {
         this.mAssistAppInBkgd = isRunning;
      }
      
      public function set appStartedHeptically(hepticalstart:Boolean) : void
      {
         this.mAppStartedHeptically = hepticalstart;
      }
      
      public function handleECallScreen(justSwitch:Boolean) : void
      {
         this.mEcallErrorScreenStatus = false;
         if(Peripheral.emergencyCallState.getEmergencyCallState() == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE)
         {
            this.processBTCallState();
            if(Framework.structure.currentBranch == "mainbackground/menu/emergencycall" && this.mReturnToScreenAfterEcall != NO_ECALL_YET)
            {
               if(this.mReturnToScreenAfterEcall == Screens.APPS_ACTIVE)
               {
                  if(Peripheral.appManager.getLastRunningAppId() != "")
                  {
                     Peripheral.appManager.startXlet(Peripheral.appManager.getLastRunningAppId(),"Resume");
                  }
                  else
                  {
                     Framework.structure.goto(Screens.APPS_HOME);
                  }
               }
               else
               {
                  Framework.structure.back();
               }
            }
            else if(Peripheral.emergencyCallState.getECallType() == "systemError" && Peripheral.emergencyCallState.getHMISystemErrorDismiss() == false)
            {
               Framework.popupManager.show(DynamicPopupNames.GLOBAL_ECALL_ERROR,Screens.GLOBAL_ECALL_ERROR,{
                  "type":PopupType.EMERGENCY,
                  "timeout":8000
               });
               this.mEcallErrorScreenStatus = true;
            }
            this.mReturnToScreenAfterEcall = NO_ECALL_YET;
         }
         else if(Peripheral.emergencyCallState.getInEmergency() == true && this.mReturnToScreenAfterEcall == NO_ECALL_YET)
         {
            this.mReturnToScreenAfterEcall = Framework.structure.currentBranch;
            this.checkNavDomainExit();
            Framework.structure.goto("mainbackground/menu/emergencycall");
         }
         else if(justSwitch == true && Framework.structure.currentBranch != "mainbackground/menu/emergencycall")
         {
            this.checkNavDomainExit();
            Framework.structure.goto("mainbackground/menu/emergencycall");
         }
      }
      
      public function isRadioBrowseScreen(branch:String) : Boolean
      {
         switch(branch)
         {
            case Screens.BROWSE_FM:
            case Screens.BROWSE_SAT:
               return true;
            default:
               return false;
         }
      }
      
      public function isPlayerBrowseScreen(branch:String) : Boolean
      {
         switch(branch)
         {
            case Screens.BROWSE_MEDIA:
            case Screens.BROWSE_DISC:
               return true;
            default:
               return false;
         }
      }
      
      public function isRadioOrPlayerCategoryScreen() : Boolean
      {
         return this.isRadioCategory() || this.isPlayerCategory();
      }
      
      public function screenOnDisplay() : void
      {
         var newBranch:String = null;
         var app:Applet = null;
         this.mbAssistWhileScreenOff = false;
         if(this.mSrcChangeDuringScreenOff && this.changeScreenWithSource(this.mDisplayOFFScreen))
         {
            newBranch = this.branchNameFromSource(this.currentSource);
            Framework.structure.goto(newBranch,{"source":this.currentSource});
            this.mSrcChangeDuringScreenOff = false;
            if(Peripheral.audioManager.isSOURCE_HTTPSTREAMER(this.currentSource))
            {
               Peripheral.appManager.startAudioApp(Peripheral.audioManager.lastAudioAppName);
            }
         }
         else if(Framework.structure.getStackIndex(Screens.APPS_ACTIVE) == 1)
         {
            if(Peripheral.appManager.getLastRunningAppId() != "")
            {
               Framework.structure.returnTo(this.mDisplayOFFScreen);
               if(Peripheral.appManager.getLastRunningAppId() == Peripheral.appManager.getSuperAppId())
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VIA_MOBILE_LOADING,{"name":"Uconnect LIVE"});
               }
               else
               {
                  app = this.getApplication(Peripheral.appManager.getLastRunningAppId());
                  if(null != app)
                  {
                     Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_LOADING,{
                        "screen":DynamicPopupNames.INFO_APPS_LOADING,
                        "state":"initializing",
                        "name":app.label
                     });
                  }
               }
               Peripheral.appManager.startXlet(Peripheral.appManager.getLastRunningAppId(),"Resume");
            }
            else
            {
               Framework.structure.removeFromStack(Screens.DISPLAY_OFF);
               Framework.structure.removeFromStack(Screens.APPS_ACTIVE);
               Framework.structure.goto(Screens.MAIN_APPS);
            }
         }
         else if(Framework.structure.historyIndexOf(this.mDisplayOFFScreen) == -1)
         {
            if(Framework.mapping.isNavDomain(this.mDisplayOFFScreen))
            {
               Peripheral.navigation.navDomainControl.onNavDomainButton();
            }
            else if(this.mDisplayOFFScreen != "")
            {
               Framework.structure.goto(this.mDisplayOFFScreen,null,false);
            }
            else
            {
               Framework.structure.gotolastScreen();
            }
         }
         else
         {
            Framework.structure.returnTo(this.mDisplayOFFScreen);
         }
         this.mDisplayOFFScreen = "";
      }
      
      private function onSource(ev:AudioEvent = null) : void
      {
         this.mLastSource = this.currentSource;
         this.currentSource = Peripheral.audioManager.source;
         this.mAudioSourceService = Peripheral.audioManager.audioSourceService;
         var currentBranch:String = Framework.structure.currentBranch;
         var newBranch:String = this.branchNameFromSource(this.currentSource);
         Framework.mapping.modifyHistory(newBranch);
         if(newBranch == "")
         {
            return;
         }
         this.updateVRContext(currentBranch);
         this.mPendingBranch = false;
         if(Peripheral.audioManager.isSOURCE_HTTPSTREAMER(this.mLastSource) && !this.mAudioAppActive && !this.mSrcChangeOverride)
         {
            return;
         }
         if(newBranch != currentBranch || Peripheral.audioManager.isSOURCE_HTTPSTREAMER(this.currentSource) && this.currentSource != this.lastSource)
         {
            if(this.changeScreenWithSource(currentBranch) || this.mSrcChangeOverride)
            {
               if(currentBranch == Screens.DTV_FULL_SCREEN && newBranch != Screens.MAIN_MEDIA)
               {
                  Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_DTV);
               }
               if(this.changeScreenWithSourceListenIn(currentBranch))
               {
                  this.mSrcChangeOverride = false;
                  if(Framework.structure.currentBranch == Screens.DISPLAY_OFF)
                  {
                     this.mSrcChangeDuringScreenOff = true;
                  }
                  else if(!Peripheral.audioManager.isSOURCE_HTTPSTREAMER(Peripheral.audioManager.source))
                  {
                     if(!Framework.popupManager.check(DynamicPopupNames.INFO_APPS_LOADING))
                     {
                        if(Framework.popupManager.active == DynamicPopupNames.CONTROLS && (newBranch == Screens.MAIN_MEDIA || newBranch == Screens.BROWSE_MEDIA))
                        {
                           Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
                        }
                        Framework.structure.goto(newBranch,{"source":Peripheral.audioManager.source});
                     }
                  }
                  else if(Peripheral.audioManager.isSOURCE_HTTPSTREAMER(Peripheral.audioManager.source))
                  {
                     Peripheral.appManager.startAudioApp(Peripheral.audioManager.lastAudioAppName);
                  }
               }
            }
         }
      }
      
      private function changeScreenWithSource(branch:String) : Boolean
      {
         switch(Framework.structure.currentBranch)
         {
            case Screens.PARENTALCONTROLS:
            case Screens.DISPLAY_OFF:
            case Screens.MAIN_FM:
            case Screens.MAIN_RADIO:
            case Screens.MAIN_DMB:
            case Screens.MAIN_SAT:
            case Screens.AHA_HOME:
            case Screens.AHA_BROWSE:
            case Screens.MAIN_MEDIA:
            case Screens.BROWSE_FM:
            case Screens.BROWSE_DAB:
            case Screens.BROWSE_DMB:
            case Screens.BROWSE_SAT:
            case Screens.BROWSE_DISC:
            case Screens.BROWSE_MEDIA:
            case Screens.SETTINGS_AUDIO:
            case Screens.DTV_FULL_SCREEN:
               return true;
            case Screens.APPS_ACTIVE:
               if(Peripheral.appManager.isAudioAppRunning())
               {
                  return true;
               }
               if(Peripheral.appManager.getRunningAppId() == Peripheral.appManager.getSuperAppId())
               {
                  return this.mIsAudioScreen;
               }
         }
         return false;
      }
      
      private function changeScreenWithSourceListenIn(branch:String) : Boolean
      {
         var retVal:Boolean = true;
         branch = branch.toLowerCase();
         if(branch == "parentalcontrolsscreen.swf" && this.mAudioSourceService == "Rse")
         {
            retVal = false;
         }
         return retVal;
      }
      
      public function branchNameFromSource(source:String) : String
      {
         switch(source)
         {
            case Peripheral.audioManager.SOURCE_SAT:
               return Screens.MAIN_SAT;
            case Peripheral.audioManager.SOURCE_MW:
            case Peripheral.audioManager.SOURCE_AM:
               if(Global.market != TunerRegion.NORTH_AMERICA)
               {
                  return Screens.MAIN_RADIO;
               }
               return Screens.MAIN_FM;
               break;
            case Peripheral.audioManager.SOURCE_FM:
               if(Global.market != TunerRegion.NORTH_AMERICA)
               {
                  return Screens.MAIN_RADIO;
               }
               return Screens.MAIN_FM;
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               return Screens.MAIN_RADIO;
            case Peripheral.audioManager.SOURCE_DMB:
               return Screens.MAIN_DMB;
            case Peripheral.audioManager.SOURCE_VRM:
               return Screens.REAR_MEDIA;
            case Peripheral.audioManager.SOURCE_CD:
            case Peripheral.audioManager.SOURCE_USB1:
               if(Peripheral.audioManager.isSourceCarPlay(Peripheral.audioManager.SOURCE_USB1))
               {
                  return Screens.DEVICE_PROJECTION;
               }
               if(Peripheral.audioManager.isSourceGAL(Peripheral.audioManager.SOURCE_USB1))
               {
                  return Screens.DEVICE_PROJECTION;
               }
               break;
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
            case Peripheral.audioManager.SOURCE_AUX:
            case Peripheral.audioManager.SOURCE_SDCARD:
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
            case Peripheral.audioManager.SOURCE_REAR_AUX1:
            case Peripheral.audioManager.SOURCE_REAR_AUX2:
            case Peripheral.audioManager.SOURCE_REAR_HDMI1:
            case Peripheral.audioManager.SOURCE_REAR_HDMI2:
            case Peripheral.audioManager.SOURCE_DTV:
               break;
            case Peripheral.audioManager.SOURCE_PHONE:
               return Screens.MAIN_PHONE;
            case Peripheral.audioManager.SOURCE_AHA:
               return Screens.AHA_HOME;
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER1:
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER2:
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER3:
               return Screens.APPS_ACTIVE;
            default:
               return "";
         }
         return Screens.MAIN_MEDIA;
      }
      
      public function contextFromSource(source:String) : String
      {
         switch(source)
         {
            case Peripheral.audioManager.SOURCE_AM:
               return Peripheral.voiceRecognition.TUNER_AM;
            case Peripheral.audioManager.SOURCE_MW:
               return Peripheral.voiceRecognition.TUNER_AM;
            case Peripheral.audioManager.SOURCE_FM:
               return Peripheral.voiceRecognition.TUNER_FM;
            case Peripheral.audioManager.SOURCE_SAT:
               return Peripheral.voiceRecognition.TUNER_SAT;
            case Peripheral.audioManager.SOURCE_DAB:
               return Peripheral.voiceRecognition.TUNER_DAB;
            case Peripheral.audioManager.SOURCE_DMB:
               return Peripheral.voiceRecognition.TUNER_DMB;
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               if(Peripheral.audioManager.isSourceIPod(source))
               {
                  return Peripheral.voiceRecognition.MEDIA_IPOD;
               }
               return Peripheral.voiceRecognition.MEDIA_USB;
               break;
            case Peripheral.audioManager.SOURCE_SDCARD:
               return Peripheral.voiceRecognition.MEDIA_SD;
            case Peripheral.audioManager.SOURCE_CD:
               return Peripheral.voiceRecognition.MEDIA_CD;
            case Peripheral.audioManager.SOURCE_AUX:
               return Peripheral.voiceRecognition.MEDIA_AUX;
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               return Peripheral.voiceRecognition.MEDIA_BLUETOOTH;
            case Peripheral.audioManager.SOURCE_PHONE:
               return Peripheral.voiceRecognition.PHONE;
            case Peripheral.audioManager.SOURCE_AHA:
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER1:
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER2:
            case Peripheral.audioManager.SOURCE_HTTPSTREAMER3:
               return Peripheral.voiceRecognition.APP;
            case Peripheral.audioManager.SOURCE_OFF:
         }
         return Peripheral.voiceRecognition.DEFAULT;
      }
      
      private function onGoto(evt:StructureEvent) : void
      {
         var branch:String = evt.branch;
         switch(branch)
         {
            case Screens.APPS_HOME:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("appshomescreen");
               this.mIsAppMainScreen = false;
               break;
            case Screens.MAIN_FM:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("fmhomescreen");
               this.mIsAppMainScreen = false;
               Peripheral.appManager.setAppMenuActive(false);
               break;
            case Screens.MAIN_SAT:
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("sathomescreen");
               break;
            case Screens.MAIN_RADIO:
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("radiohomescreen");
               break;
            case Screens.MAIN_DMB:
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("dmbhomescreen");
               break;
            case Screens.AHA_HOME:
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("ahahomescreen");
               break;
            case Screens.MAIN_MEDIA:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("playerhomescreen");
               this.mIsAppMainScreen = false;
               Peripheral.appManager.setAppMenuActive(false);
               break;
            case Screens.APPS_ACTIVE:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("appsmainscreen");
               Peripheral.appManager.isAppVRFocus();
               break;
            case Screens.DEVICE_PROJECTION:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("deviceprojection");
               this.mIsAppMainScreen = false;
               break;
            case "mainbackground/menu/phonemainscreen":
            case Screens.MAIN_PHONE:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("phonemainscreen");
               this.mIsAppMainScreen = false;
               Peripheral.appManager.setAppMenuActive(false);
               if(this.mAssistAppInBkgd)
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
               }
            case Screens.SETTINGS_BLUETOOTH:
               break;
            case "mainbackground/menu/navmainmenuscreen":
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("navmainmenuscreen");
               break;
            case "mainbackground/menu/navmapmainscreen":
               this.mIsAppMainScreen = false;
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("navmapmainscreen");
               break;
            case Screens.SETTINGS_SCREEN:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("appsmainscreen");
               this.mIsAppMainScreen = false;
               Peripheral.appManager.setAppMenuActive(false);
               break;
            case Screens.MAIN_HVAC:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("hvachomescreen");
               this.mIsAppMainScreen = false;
               Peripheral.appManager.setAppMenuActive(false);
               break;
            case "mainbackground/menu/emergencycall":
               this.mIsAppMainScreen = false;
               break;
            case Screens.MAIN_APPS:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("appsmainscreen");
               this.mIsAppMainScreen = true;
               Peripheral.appManager.setAppMenuActive(true);
               break;
            case "drivemode":
               if(!this.mPerfPagesPaused)
               {
                  this.startXlet(Peripheral.appManager.getPPId(),true);
                  this.mPerfPagesPaused = true;
               }
               break;
            case Screens.REAR_MEDIA:
               Peripheral.hmiRequest.hmiUpdatePersistencyLastScreenValue("rearmediascreen");
         }
         if(branch != Screens.MAIN_PHONE && Framework.popupManager.active == DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
         }
         this.updateVRContext(branch);
         if(Peripheral.emergencyCallState.getEmergencyCallState() == EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE && Peripheral.emergencyCallState.getECallType() == "systemError" && Peripheral.emergencyCallState.getHMISystemErrorDismiss() == false)
         {
            Framework.popupManager.show(DynamicPopupNames.GLOBAL_ECALL_ERROR,Screens.GLOBAL_ECALL_ERROR,{
               "type":PopupType.EMERGENCY,
               "timeout":8000
            });
         }
         if(branch.toLowerCase().indexOf("drivemode") == -1 && branch.toLowerCase().indexOf("apps") == -1 && this.mPerfPagesPaused)
         {
            Peripheral.appManager.stopDaemonXlet(Peripheral.appManager.getPPId());
            this.mPerfPagesPaused = false;
         }
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         var vars:Object = null;
         var ext:int = 0;
         var branch:String = Framework.structure.currentBranch;
         var engineeringModeStatus:Boolean = false;
         var dealerModeStatus:Boolean = false;
         if(Framework.structure.getAddress(branch) == Screens.APPS_LIST)
         {
            vars = Framework.structure.variables;
            if(vars.hasOwnProperty("ext"))
            {
               ext = int(vars.ext);
               if(Extensions.ENGINEERING_MODE_EXTENSIONS.indexOf(ext) >= 0)
               {
                  engineeringModeStatus = true;
               }
               if(Extensions.DEALER_MODE_EXTENSIONS.indexOf(ext) >= 0)
               {
                  dealerModeStatus = true;
               }
            }
         }
         Peripheral.hmiRequest.setDealerModeStatus(dealerModeStatus);
         Peripheral.hmiRequest.setEngineeringModeStatus(engineeringModeStatus);
      }
      
      private function onVRmediaFilterListShow(evt:VoiceRecognitionEvent) : void
      {
         if(evt.mData != null && evt.mData.hasOwnProperty("context"))
         {
            Peripheral.mediaPlayer.VRContext = evt.mData.context;
            Peripheral.mediaPlayer.VRMethodName = evt.mData.methodName;
         }
         Peripheral.mediaPlayer.mediaFilterListShow(evt.mData.mediaType,evt.mData.artistFilterID,evt.mData.albumFilterID,evt.mData.genreFilterID,evt.mData.titleFilterID,evt.mData.playListFilterID,evt.mData.audiobookFilterID,evt.mData.podcastFilterID);
      }
      
      private function onTravelLinkWeatherVRShortcut(id:String) : Boolean
      {
         var isHandled:Boolean = true;
         if(Peripheral.travelLink.isAvailable)
         {
            this.checkNavDomainExit();
            if(Framework.structure.currentBranch != TRAVEL_LINK_WEATHER_PATH)
            {
               Framework.structure.goto(TRAVEL_LINK_WEATHER_PATH,{"favoriteData":id});
            }
            else
            {
               Framework.messenger.send({
                  "type":"screen transition",
                  "value":id
               });
            }
         }
         else
         {
            Peripheral.voiceRecognition.cancel(false);
            isHandled = false;
         }
         return isHandled;
      }
      
      private function onVRShortcut(evt:VoiceRecognitionEvent) : void
      {
         var path:String = null;
         var CanBroweCDFolders:Boolean = false;
         var vrShortcutHandled:Boolean = true;
         this.browseHistory = {
            "cur":0,
            "pos":0
         };
         switch(evt.mData.videoScreen)
         {
            case Peripheral.voiceRecognition.CLIMATE:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.MAIN_HVAC);
               break;
            case Peripheral.voiceRecognition.CONTROLS:
               Peripheral.controlsPopupManager.showControlsPopup();
               break;
            case Peripheral.voiceRecognition.SETTINGS:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.SETTINGS_SCREEN);
               break;
            case Peripheral.voiceRecognition.AUDIO_SETTINGS:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.SETTINGS_AUDIO);
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_INFORMATION:
            case Peripheral.voiceRecognition.TRAVELLINK_MAIN:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travellinkmainscreen");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_FAVORITES:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travelLinkFavoritesScreen");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_FUEL:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travellinkfuelscreen");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_MOVIE_LISTINGS:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travellinkmoviesscreen");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_HEADLINES:
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_LEAGUE:
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_RANKINGS:
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_SCHEDULE:
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_SCORES:
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_TEAMS:
               vrShortcutHandled = false;
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_SPORTS_MAIN:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travellinksportsscreen");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_WEATHER_CURRENT:
               vrShortcutHandled = this.onTravelLinkWeatherVRShortcut(Peripheral.travelLink.landWeather.CURRENT_FORECAST);
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_WEATHER_EXTENDED_FORECAST:
               vrShortcutHandled = this.onTravelLinkWeatherVRShortcut(Peripheral.travelLink.landWeather.EXTENDED_FORECAST);
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_WEATHER_FIVE_DAY_FORECAST:
               vrShortcutHandled = this.onTravelLinkWeatherVRShortcut(Peripheral.travelLink.landWeather.FIVEDAY_FORECAST);
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_WEATHER_MAIN:
               vrShortcutHandled = this.onTravelLinkWeatherVRShortcut(Peripheral.travelLink.landWeather.MAIN_FORECAST);
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_SKI_INFO:
               vrShortcutHandled = this.onTravelLinkWeatherVRShortcut(Peripheral.travelLink.landWeather.SKI_INFO);
               break;
            case Peripheral.voiceRecognition.APPS:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.MAIN_APPS);
               break;
            case Peripheral.voiceRecognition.PHONE_CONNECT:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH);
               break;
            case Peripheral.voiceRecognition.PHONE:
            case Peripheral.voiceRecognition.PHONE_ASK_CONNECT:
               Framework.Trace("Received VR.PHONE");
               this.checkNavDomainExit();
               if(Framework.structure.currentBranch != Screens.SETTINGS_BLUETOOTH && !this.isScreenOff())
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.MAIN_PHONE);
               }
               break;
            case Peripheral.voiceRecognition.PHONE_KEY_PAD:
               this.checkNavDomainExit();
               Framework.structure.goto("mainbackground/menu/phonemainscreen/phonedialpadpopup");
               break;
            case Peripheral.voiceRecognition.PHONE_RECENT_CALLS_ALL:
               if(Peripheral.phoneCallList.allCallsCount != -1)
               {
                  Framework.structure.goto(Screens.PHONE_RECENTCALLS,{"value":"all"});
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               }
               else
               {
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,false);
               }
               break;
            case Peripheral.voiceRecognition.PHONE_RECENT_CALLS_INCOMING:
               if(Peripheral.phoneCallList.receivedCallsCount != -1)
               {
                  Framework.structure.goto(Screens.PHONE_RECENTCALLS,{"value":"incoming"});
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               }
               else
               {
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,false);
               }
               break;
            case Peripheral.voiceRecognition.PHONE_RECENT_CALLS_MISSED:
               if(Peripheral.phoneCallList.missedCallsCount != -1)
               {
                  Framework.structure.goto(Screens.PHONE_RECENTCALLS,{"value":"missed"});
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               }
               else
               {
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,false);
               }
               break;
            case Peripheral.voiceRecognition.PHONE_RECENT_CALLS_OUTGOING:
               if(Peripheral.phoneCallList.dialedCallsCount != -1)
               {
                  Framework.structure.goto(Screens.PHONE_RECENTCALLS,{"value":"outgoing"});
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               }
               else
               {
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,false);
               }
               break;
            case Peripheral.voiceRecognition.PHONE_PHONEBOOK_VEHICLE:
               if(PHONEBOOK_PATH == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":"favorites"
                  });
               }
               else
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/PhonebookScreen",{"show":"favorites"});
               }
               break;
            case Peripheral.voiceRecognition.PHONE_PHONEBOOK_MOBILE:
            case Peripheral.voiceRecognition.PHONE_PHONEBOOK:
               if(PHONEBOOK_PATH == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":"mobile"
                  });
               }
               else
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/PhonebookScreen",{"show":"mobile"});
               }
               break;
            case Peripheral.voiceRecognition.PHONE_PAIRED_AUDIO_SOURCES:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"source":"audio"});
               break;
            case Peripheral.voiceRecognition.PHONE_PAIRED_PHONES:
               this.checkNavDomainExit();
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"source":"phones"});
               break;
            case Peripheral.voiceRecognition.PHONE_SMS_INBOX:
               this.checkNavDomainExit();
               Peripheral.smsMessaging.clearIncomingMessage(true);
               Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"inbox"});
               break;
            case Peripheral.voiceRecognition.PHONE_SMS_MESSAGE:
               vrShortcutHandled = false;
               break;
            case Peripheral.voiceRecognition.PHONE_SMS_PREDEFINED_MESSAGES:
               if(Peripheral.vehicleStatus.speedLockOut)
               {
                  Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
               }
               else
               {
                  this.checkNavDomainExit();
                  Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
                  Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen","predefined");
               }
               break;
            case Peripheral.voiceRecognition.TUNER:
               if(Peripheral.audioManager.isSourceRadio(Peripheral.audioManager.source))
               {
                  if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT)
                  {
                     this.checkNavDomainExit();
                     Framework.structure.goto(Screens.MAIN_SAT);
                  }
                  else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DMB)
                  {
                     this.checkNavDomainExit();
                     Framework.structure.goto(Screens.MAIN_DMB);
                  }
                  else if(Peripheral.tuner.region != TunerRegion.NORTH_AMERICA)
                  {
                     this.checkNavDomainExit();
                     Framework.structure.goto(Screens.MAIN_RADIO);
                  }
                  else
                  {
                     this.checkNavDomainExit();
                     Framework.structure.goto(Screens.MAIN_FM,{
                        "source":Peripheral.audioManager.source,
                        "_back":false
                     });
                  }
               }
               else
               {
                  this.mSrcChangeOverride = true;
                  Peripheral.audioManager.setSource(Peripheral.audioManager.lastRadioSource);
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_PLAYER:
            case Peripheral.voiceRecognition.MEDIA_LAST_SCREEN:
               if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.MAIN_MEDIA);
               }
               else if(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.SOURCE_HTTPSTREAMER1) && Peripheral.audioManager.mediaSources.length <= 1 || !Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.SOURCE_HTTPSTREAMER1) && Peripheral.audioManager.mediaSources.length <= 0)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.MAIN_MEDIA);
               }
               else
               {
                  this.mSrcChangeOverride = true;
                  if(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.lastMediaSource))
                  {
                     Peripheral.audioManager.setSource(Peripheral.audioManager.lastMediaSource);
                  }
                  else
                  {
                     Peripheral.audioManager.setSource(Peripheral.audioManager.mediaSources[0]);
                  }
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_ALBUM:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.ALBUMS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ALBUMS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_FOLDERS:
               CanBroweCDFolders = Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && Peripheral.rse.listSyncStatus == true && (Peripheral.rse.dvdDiscStatValue == "discMp3" || Peripheral.rse.dvdDiscStatValue == "discWma");
               if(Peripheral.audioManager.isSourceIPod() || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AUX || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && CanBroweCDFolders == false || !Peripheral.mediaPlayer.readyToBrowse)
               {
                  Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
                  vrShortcutHandled = false;
                  return;
               }
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.FOLDERS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.FOLDERS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD ? Screens.BROWSE_DISC : Screens.BROWSE_MEDIA,{"path":path});
               }
               Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_ARTIST:
            case Peripheral.voiceRecognition.MEDIA_BROWSE:
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
               {
                  Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
                  vrShortcutHandled = false;
                  return;
               }
               if(Screens.BROWSE_DISC == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.SONG
                  });
               }
               else if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.ARTISTS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ARTISTS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
                  {
                     if(Peripheral.rse.startDiscPlayStatus != true)
                     {
                        Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.Context,evt.mData.methodName);
                        vrShortcutHandled = false;
                        return;
                     }
                     Framework.structure.goto(Screens.BROWSE_DISC);
                  }
                  else
                  {
                     if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AUX || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
                     {
                        Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
                        vrShortcutHandled = false;
                        return;
                     }
                     if(Peripheral.mediaPlayer.mediaErrorCode() == MediaErrorCodes.MEDIA_DEVICE_EMPTY || Peripheral.mediaPlayer.mediaErrorCode() == MediaErrorCodes.MEDIA_DEVICE_UNPLAYABLE)
                     {
                        Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
                        vrShortcutHandled = false;
                        return;
                     }
                     Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
                  }
               }
               Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_AUDIOBOOK:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.AUDIOBOOKS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.AUDIOBOOKS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_GENRE:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.GENRES
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.GENRES;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_PLAYLIST:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.PLAYLISTS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PLAYLISTS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_PODCAST:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.PODCASTS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PODCASTS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_BROWSE_TITLE:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.SONGS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.SONGS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_SONG:
               if(Screens.BROWSE_MEDIA == Framework.structure.currentBranch)
               {
                  Framework.messenger.send({
                     "type":"screen transition",
                     "value":MediaPlayerPath.SONGS
                  });
               }
               else
               {
                  path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.SONGS;
                  if(null != Peripheral.voiceRecognition.lastGotoOptions)
                  {
                     path = path + ("/@" + Peripheral.voiceRecognition.lastGotoOptions);
                  }
                  this.checkNavDomainExit();
                  Framework.structure.goto(Screens.BROWSE_MEDIA,{"path":path});
               }
               break;
            case Peripheral.voiceRecognition.NAVIGATION:
            case Peripheral.voiceRecognition.NAVIGATION_ADDRESS:
            case Peripheral.voiceRecognition.NAVIGATION_POI:
            case Peripheral.voiceRecognition.NAVIGATION_MY_DESTINATIONS:
            case Peripheral.voiceRecognition.NAVIGATION_RECENT_DESTINATIONS:
            case Peripheral.voiceRecognition.NAVIGATION_WHERE_TO:
            case Peripheral.voiceRecognition.NAVIGATION_ROUTE_CONFIRM:
            case Peripheral.voiceRecognition.NAVIGATION_MAP:
               this.closeSmsPopups();
               Peripheral.navigation.navDomainControl.requestVRShortcut(evt.mData.videoScreen as String);
               return;
            case Peripheral.voiceRecognition.PHONE_CONTACT:
            case Peripheral.voiceRecognition.TRAVELLINK_TRAFFIC:
               break;
            case Peripheral.voiceRecognition.TRAVELLINK_WEATHER_MAP:
               if(Peripheral.travelLink.isAvailable)
               {
                  this.checkNavDomainExit();
                  Framework.structure.goto("mainbackground/menu/travellinkgraphicalweather");
               }
               else
               {
                  Peripheral.voiceRecognition.cancel(false);
                  vrShortcutHandled = false;
               }
               break;
            case Peripheral.voiceRecognition.CAMERA:
               if(Peripheral.rse.frontSideCameraAvailable)
               {
                  Peripheral.rse.startRdc2Video("dtvCamera");
               }
               break;
            case Peripheral.voiceRecognition.MEDIA_REAR:
               if(Peripheral.rse.rearVideoStatus)
               {
                  Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onRequestDisplayResponse,false,0,true);
                  Peripheral.displayManager.requestDisplay(DisplayManagerLayers.LAYER_MAP,false);
                  vrShortcutHandled = true;
               }
               break;
            default:
               vrShortcutHandled = false;
         }
         if(vrShortcutHandled)
         {
            this.closeSmsPopups();
         }
      }
      
      private function updateVRContext(branch:String) : void
      {
         switch(branch)
         {
            case Screens.MAIN_HVAC:
               this.mContext = Peripheral.voiceRecognition.CLIMATE;
               break;
            case "mainbackground/menu/phonemainscreen":
            case Screens.MAIN_PHONE:
            case "mainbackground/menu/phonemainscreen/phonepairingpopup":
            case Screens.SETTINGS_BLUETOOTH:
               if(Peripheral.bluetooth.currentHFPDevice != null && Peripheral.bluetooth.currentHFPDevice.HfpConnected)
               {
                  if(Peripheral.bluetoothPhone.getActiveCall() != null || Peripheral.bluetoothPhone.getAlertingCall() != null || Peripheral.bluetoothPhone.getDialingCall() != null || Peripheral.bluetoothPhone.getHoldingCall() != null || Peripheral.bluetoothPhone.getRingingCall() != null || Peripheral.bluetoothPhone.getWaitingCall() != null)
                  {
                     this.mContext = Peripheral.voiceRecognition.PHONE_ACTIVE_CALL;
                  }
                  else
                  {
                     this.mContext = Peripheral.voiceRecognition.PHONE;
                  }
               }
               else
               {
                  this.mContext = Peripheral.voiceRecognition.PHONE_NO_HF;
               }
               break;
            case "mainbackground/menu/phonerecentcallscreen":
               this.mContext = Peripheral.voiceRecognition.PHONE_RECENT_CALLS_ALL;
               break;
            case "mainbackground/menu/navmapmainscreen":
            case "mainbackground/menu/navmapscrollingscreen":
            case "mainbackground/menu/navmainmenuscreen":
            case "mainbackground/menu/navmainmenuscreen/navpopup2itemscreen":
            case "mainbackground/menu/navmenuwheretoscreen":
            case "mainbackground/menu/navmenuwheretoscreen/navpopup2itemscreen":
            case "mainbackground/menu/navmainmenuscreen/navmenupoiscreen":
            case "mainbackground/menu/navmainmenuscreen/navphonespellerscreen":
            case "mainbackground/menu/navmainmenuscreen/navpopup4itemscreen":
            case "mainbackground/menu/navmainmenuscreen/navspellerscreen":
            case "mainbackground/menu/navmainmenuscreen/navkoreanSpellerScreen":
            case "mainbackground/menu/navmainmenuscreen/navgeospellerscreen":
            case "mainbackground/menu/navmainmenuscreen/navoptionspopup":
            case "mainbackground/menu/navmainmenuscreen/navlistscreen":
            case "mainbackground/menu/navmainmenuscreen/navgenericpopup":
            case "mainbackground/menu/navmainmenuscreen/navpopup3itemscreen":
            case "mainbackground/menu/navmainmenuscreen/navaddressscreen":
            case "mainbackground/menu/navmainmenuscreen/navpopupgenericscreen":
            case "mainbackground/menu/navconfirmdestinationscreen":
               this.mContext = Peripheral.voiceRecognition.NAVIGATION;
               break;
            case "mainbackground/menu/travellinkmainscreen":
               this.mContext = Peripheral.voiceRecognition.TRAVELLINK_MAIN;
               break;
            case "mainbackground/menu/travelLinkFavoritesScreen":
            case "mainbackground/menu/travellinksportsscreen":
            case "mainbackground/menu/travellinkfuelscreen":
            case "mainbackground/menu/travellinkweatherscreen":
            case "mainbackground/menu/travellinkmoviesscreen":
            case "mainbackground/menu/travellinkweatherglossary":
            case "mainbackground/menu/travellinkgraphicalweather":
               this.mContext = Peripheral.voiceRecognition.TRAVELLINK_DEFAULT;
               break;
            case "mainbackground/menu/smsmessaginglistscreen":
            case Screens.SMS_MESSAGING_LIST:
               this.mContext = Peripheral.voiceRecognition.PHONE_SMS_INBOX;
               break;
            case Screens.MAIN_APPS:
            case "mainbackground/menu/appsmainscreen":
               this.mContext = Peripheral.voiceRecognition.DEFAULT;
               break;
            case Screens.APPS_ACTIVE:
               this.mContext = Peripheral.voiceRecognition.APPVR;
               break;
            case Screens.POPUP_PICKLIST:
            case Screens.POPUP_FINDNEAREST:
               break;
            case Screens.MAIN_RADIO:
            case Screens.MAIN_SAT:
            case Screens.MAIN_FM:
            default:
               this.mContext = this.contextFromSource(Peripheral.audioManager.source);
         }
         Peripheral.vrSession.setVRContext(this.mContext,branch);
         Peripheral.voiceRecognition.setContext(this.mContext);
         this.mPrePopupVRContext = branch;
         if(branch == Screens.APPS_ACTIVE)
         {
            Peripheral.appManager.isAppVRFocus();
         }
      }
      
      private function updateVRPopupContext(popupId:int) : void
      {
         switch(popupId)
         {
            case DynamicPopupNames.SMS_INCOMING_MESSAGE:
               this.mContext = Peripheral.voiceRecognition.PHONE_SMS_MESSAGE;
               break;
            case DynamicPopupNames.SMS_MESSAGE_FULL:
               this.mContext = Peripheral.voiceRecognition.PHONE_SMS_MESSAGE_SELECTED;
               break;
            case DynamicPopupNames.VOICE_PICK_LIST:
            case DynamicPopupNames.TELEPROMPTER:
               break;
            default:
               this.mContext = this.contextFromSource(Peripheral.audioManager.source);
         }
         Peripheral.voiceRecognition.setContext(this.mContext);
      }
      
      private function onSwitchToDriveMode(e:HMIRequestEvent) : void
      {
         Peripheral.driveModeManager.enterDriveMode();
      }
      
      private function onWaitingForAMSToStartAssistApp(e:HMIRequestEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY);
      }
      
      private function onPosition(e:NavigationEvent) : void
      {
         var position:String = Peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
         var positionArray:Array = position.split(" ");
         var coordinates:Coordinates = new Coordinates();
         coordinates.longitude = Number(positionArray[0]);
         coordinates.latitude = Number(positionArray[1]);
         Peripheral.travelLink.fuel.setCoordinates(coordinates);
         Peripheral.travelLink.movies.setCoordinates(coordinates);
         Peripheral.travelLink.landWeather.setCoordinates(coordinates);
      }
      
      private function onNavigationOperable(e:NavDomainControllerEvent) : void
      {
         if(Peripheral.navigation.navDomainControl.navIsOperable)
         {
            if(!Global.navActivated)
            {
               Peripheral.hmiRequest.hmiUpdatePersistencyNavActivatedValue(1);
            }
            Global.navActivated = true;
         }
      }
      
      public function saveScreenVariables(key:String, vars:Object) : void
      {
         this.mScreenVarsHistory[key] = vars;
      }
      
      public function retrieveScreenVariables(key:String) : Object
      {
         if(this.mScreenVarsHistory.hasOwnProperty(key))
         {
            return this.mScreenVarsHistory[key];
         }
         return null;
      }
      
      public function get wasAntiTheftPopupUp() : Boolean
      {
         return this.mWasAntiTheftPopupUp;
      }
      
      public function get trailerNameSelectedForBrowse() : String
      {
         return this.mTrailerSelectedForBrowse;
      }
      
      public function set trailerNameSelectedForBrowse(trailerName:String) : void
      {
         this.mTrailerSelectedForBrowse = trailerName;
      }
      
      public function get trailerIdSelectedForBrowse() : int
      {
         return this.mTrailerSelectedForBrowseId;
      }
      
      public function set trailerIdSelectedForBrowse(trailerId:int) : void
      {
         this.mTrailerSelectedForBrowseId = trailerId;
      }
      
      public function get HEVLastScreen() : String
      {
         return Peripheral.persistency.getValue(PersistencyKeys.KEY_PHEV_SELECTED_TAB).value;
      }
      
      public function set HEVLastScreen(screenName:String) : void
      {
         Peripheral.persistency.write(PersistencyKeys.KEY_PHEV_SELECTED_TAB,{"value":screenName});
      }
      
      public function startXlet(appId:String, heptic:Boolean = false) : void
      {
         var app:Applet = this.getApplication(appId);
         this.doStartXlet(app,heptic);
      }
      
      public function fullStartDaemonXlet(appId:String) : void
      {
         AppStateManager.getInstance().appStartedHeptically = false;
         Peripheral.appManager.startDaemonXlet(appId);
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_LOADING,{
            "screen":DynamicPopupNames.INFO_APPS_LOADING,
            "state":"initializing",
            "name":"Performance Pages"
         });
      }
      
      private function doStartXlet(app:Applet, heptic:Boolean) : void
      {
         if(null != app)
         {
            if(Peripheral.appManager.status == "Ready" && (app.status.toLowerCase() == "stopped" || app.status.toLowerCase() == "paused" || app.status == ""))
            {
               AppStateManager.getInstance().appStartedHeptically = heptic;
               Peripheral.appManager.startXlet(app.appId,"true");
               if(app.appId != Peripheral.appManager.getSuperAppId())
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_LOADING,{
                     "screen":DynamicPopupNames.INFO_APPS_LOADING,
                     "state":"initializing",
                     "name":app.label
                  });
               }
               else if(app.appId == "100")
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_APPS_LOADING,{
                     "screen":DynamicPopupNames.INFO_APPS_LOADING,
                     "state":"initializing",
                     "name":app.label
                  });
               }
            }
         }
      }
      
      private function onAdvisoryMessage(event:SatelliteRadioEvent) : void
      {
         if(Framework.structure.currentBranch.search("travellink") != -1)
         {
            if(!(event.mData == SatAdvisoryMessageTypes.sSUBSCRIPTION_UPDATED || event.mData == SatAdvisoryMessageTypes.sNO_ERROR))
            {
               return;
            }
         }
         switch(event.mData)
         {
            case SatAdvisoryMessageTypes.sCHECK_TUNER:
               Framework.popupManager.show(DynamicPopupNames.SIRIUS_ADVISORY_MSG,"errorpopupscreen",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SIRIUS,
                  "body":[T.STRB_ERROR_BODY_CHECK_TUNER,"\n\n",T.STRB_ERROR_BODY_SEE_DEALER],
                  "showClose":false,
                  "background":false
               });
               break;
            case SatAdvisoryMessageTypes.sSUBSCRIPTION_UPDATED:
               Framework.popupManager.show(DynamicPopupNames.SIRIUS_ADVISORY_MSG,"errorpopupscreen",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_ERROR_TITLE_SIRIUS,
                  "body":[T.STRB_SAT_UPDATING,"\n\n",T.STRB_SAT_PLEASE_WAIT],
                  "showClose":false,
                  "background":false
               });
               break;
            case SatAdvisoryMessageTypes.sCH_NOT_AVAILABLE:
               Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_NOT_AVAILABLE,
                  "showClose":false
               });
               break;
            case SatAdvisoryMessageTypes.sCH_NOT_SUBSCRIBED:
               Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_NOT_SUBSCRIBED,
                  "showClose":false
               });
               break;
            case SatAdvisoryMessageTypes.sACTIVE_CH_BECAME_UNSUBSCRIBED:
               Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":"",
                  "body":T.STRB_ERROR_BODY_NOT_SUBSCRIBED,
                  "showClose":false
               });
               break;
            case SatAdvisoryMessageTypes.sCHECK_ANTENNA:
               if(!this.isInSatReplay() && this.isOnSatRadioScreen())
               {
                  Framework.popupManager.show(DynamicPopupNames.SIRIUS_ADVISORY_MSG,"errorpopupscreen",{
                     "timeout":0,
                     "type":PopupType.PRIMARY,
                     "title":T.STRB_ERROR_TITLE_SIRIUS,
                     "body":[T.STRB_ERROR_BODY_CHECK_ANTENNA,"\n\n",T.STRB_ERROR_BODY_SEE_DEALER],
                     "showClose":false,
                     "background":false
                  });
               }
               break;
            case SatAdvisoryMessageTypes.sNO_SIGNAL:
               if(!this.isInSatReplay() && this.isOnSatRadioScreen())
               {
                  Framework.popupManager.show(DynamicPopupNames.SIRIUS_ADVISORY_MSG,"errorpopupscreen",{
                     "timeout":0,
                     "type":PopupType.PRIMARY,
                     "title":T.STRB_ERROR_TITLE_SIRIUS,
                     "body":["\n\n",T.STRB_SAT_ACQUIRING_SIGNAL],
                     "showClose":false,
                     "background":false
                  });
               }
               break;
            case SatAdvisoryMessageTypes.sCH_SKIPPED:
               if(this.isOnSatRadioScreen())
               {
                  Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                     "timeout":0,
                     "type":PopupType.PRIMARY,
                     "title":"",
                     "body":T.STRB_ERROR_BODY_SKIPPED_CHANNEL,
                     "showClose":false
                  });
               }
               break;
            case SatAdvisoryMessageTypes.sCH_LOCKED:
               if(this.isOnSatRadioScreen())
               {
                  Framework.popupManager.show(DynamicPopupNames.SMALL,"smallpopupscreen",{
                     "timeout":0,
                     "type":PopupType.PRIMARY,
                     "title":"",
                     "body":"LOCKED CHANNEL",
                     "showClose":false
                  });
               }
               break;
            case SatAdvisoryMessageTypes.sNO_ERROR:
            case SatAdvisoryMessageTypes.sSUPPRESSED_ANTENNA_ERROR:
            default:
               this.removeCurrentAdvisoryPopup();
         }
      }
      
      private function muteSatelliteRadio(mute:Boolean) : void
      {
         var audioMixerManagerSdars:String = "SDARS1";
         if(mute)
         {
            Peripheral.audioMixerManager.setEntertainmentSrcMute(audioMixerManagerSdars);
         }
         else
         {
            Peripheral.audioMixerManager.setEntertainmentSrcUnmute(audioMixerManagerSdars);
         }
      }
      
      private function removeCurrentAdvisoryPopup() : void
      {
         if(Framework.popupManager.check(DynamicPopupNames.SIRIUS_ADVISORY_MSG))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SIRIUS_ADVISORY_MSG);
         }
         if(Framework.popupManager.check(DynamicPopupNames.SMALL))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMALL);
         }
      }
      
      private function isInSatReplay() : Boolean
      {
         var inSatReplay:Boolean = false;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT && !Peripheral.satelliteRadioIR.IRPlayStatus.isLive)
         {
            inSatReplay = true;
         }
         return inSatReplay;
      }
      
      private function isOnSatRadioScreen() : Boolean
      {
         var onSatRadioScreen:Boolean = false;
         var curBranch:String = Framework.structure.currentBranch;
         if(curBranch != null && curBranch.search(Screens.MAIN_SAT) != -1)
         {
            onSatRadioScreen = true;
         }
         return onSatRadioScreen;
      }
      
      private function onInstantReplayBufferWarning(event:SatelliteRadioInstantReplayEvent) : void
      {
         Ancillary.definedDynamicPopups.show(DynamicPopupNames.MAXIMUM_TIME_FOR_RADIO_PAUSE);
      }
      
      private function checkForXmState(e:Event) : void
      {
         var advisoryMessage:String = null;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT)
         {
            if(!this.isOnSatRadioScreen())
            {
               this.removeCurrentAdvisoryPopup();
            }
            else
            {
               advisoryMessage = Peripheral.satelliteRadio.advisoryMessage;
               if(null != advisoryMessage && "" != advisoryMessage)
               {
                  this.onAdvisoryMessage(new SatelliteRadioEvent(SatelliteRadioEvent.ADVISORY_MESSAGE,advisoryMessage));
               }
            }
            Peripheral.satelliteRadio.addEventListener(SatelliteRadioEvent.ADVISORY_MESSAGE,this.onAdvisoryMessage);
            Peripheral.satelliteRadioIR.addEventListener(SatelliteRadioInstantReplayEvent.BUFFER_WARNING,this.onInstantReplayBufferWarning);
         }
         else
         {
            this.removeCurrentAdvisoryPopup();
            Peripheral.satelliteRadio.removeEventListener(SatelliteRadioEvent.ADVISORY_MESSAGE,this.onAdvisoryMessage);
            Peripheral.satelliteRadioIR.removeEventListener(SatelliteRadioInstantReplayEvent.BUFFER_WARNING,this.onInstantReplayBufferWarning);
         }
      }
      
      private function onThemeConfig(e:PPSEvent) : void
      {
      }
      
      private function appInFocus(e:AppManagerEvent) : void
      {
         if(Framework.structure.currentBranch == Screens.APPS_ACTIVE)
         {
            this.mContext = e.mData.vrAppInFocus == true ? Peripheral.voiceRecognition.APPVR : Peripheral.voiceRecognition.APP;
            Peripheral.voiceRecognition.setContext(this.mContext);
         }
      }
      
      private function onRequestRunningScreen(e:AppManagerEvent) : void
      {
         Peripheral.appManager.activeCategory = AppManager.RUNNING_APPS;
         Framework.structure.goto(Screens.MAIN_APPS);
      }
      
      private function onAssistRequest(e:AppManagerEvent) : void
      {
         if(this.isScreenOff())
         {
            this.mbAssistWhileScreenOff = true;
            Framework.structure.goto(Screens.MAIN_APPS);
            Framework.popupManager.dequeue(DynamicPopupNames.SCREEN_OFF);
         }
         if(Framework.popupManager.active == DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.ONEITEM_ASSIST_WILL_LOAD_SHORTLY);
         }
         if(Peripheral.bluetoothPhone.isBluetoothCallActive())
         {
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onTwoItemPopupRightClick,false,0,true);
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_REQUEST_ASSIST);
         }
         else
         {
            Peripheral.appManager.confirmedStartAssist();
         }
      }
      
      private function onStartRunningApp(e:AppManagerEvent) : void
      {
         if(Framework.structure.currentBranch != Screens.APPS_ACTIVE)
         {
            Framework.structure.goto(Screens.APPS_ACTIVE,null,true);
         }
         if(Framework.popupManager.check(DynamicPopupNames.INFO_APPS_LOADING))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
         }
      }
      
      public function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         Peripheral.bluetooth.switchBluetoothOff();
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Peripheral.appManager.confirmedStartAssist();
      }
      
      public function onTwoItemPopupRightClick(e:GlobalEvent) : void
      {
         Peripheral.ecallsvc.setLEDStatus(0);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onTwoItemPopupRightClick);
      }
      
      private function onPowerModeStateChange(e:AntiTheftEvent) : void
      {
         var powerModeState:String = Peripheral.antiTheft.powerModeState;
         switch(powerModeState)
         {
            case "idle":
            case "standby":
               if(!this.isScreenOff())
               {
                  this.mDisplayOFFScreen = Framework.structure.currentBranch;
                  Framework.popupManager.show(DynamicPopupNames.SCREEN_OFF,"PopupDisplayOff.swf",{"type":PopupType.SCREENOFF});
                  Framework.structure.goto(Screens.DISPLAY_OFF,{"powerOff":true},false);
                  Peripheral.versionInfo.setDisplayStatus(false);
               }
               break;
            case "timed":
            case "full_operation":
            default:
               if(this.isScreenOff() || Framework.popupManager.active == DynamicPopupNames.TA_ANNOUNCEMENT)
               {
                  this.screenOnDisplay();
                  Peripheral.versionInfo.setDisplayStatus(true);
               }
         }
      }
      
      private function onCloseScreenOnff(e:AntiTheftEvent) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.SCREEN_OFF);
      }
      
      private function onIgnitionChange(evt:AntiTheftEvent) : void
      {
         if(Peripheral.antiTheft.ignitionState == "on" && Framework.structure.currentBranch == Screens.DISPLAY_OFF)
         {
            Framework.structure.back();
         }
      }
      
      private function onScreenOff(e:HardControlEvent) : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE)
         {
            Peripheral.smsMessaging.clearIncomingMessage(true);
         }
         if(Peripheral.emergencyCallState.getInEmergency() == false)
         {
            if(Framework.structure.currentBranch != Screens.DISPLAY_OFF)
            {
               if(Framework.structure.currentBranch == Screens.SCREEN_CAMERA)
               {
                  this.mDisplayOFFScreen = "";
               }
               else
               {
                  this.mDisplayOFFScreen = Framework.structure.currentBranch;
               }
               if(this.mPhoneIsRinging)
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_INCOMING_CALL,"incomingcall",{"type":PopupType.PHONE});
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.SCREEN_OFF,Screens.POPUP_DISPLAYOFF,{"type":PopupType.SCREENOFF});
               }
               Framework.structure.goto(Screens.DISPLAY_OFF);
               Peripheral.versionInfo.setDisplayStatus(false);
            }
            else
            {
               Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
               Framework.popupManager.dequeue(DynamicPopupNames.SCREEN_OFF);
               this.screenOnDisplay();
               Peripheral.versionInfo.setDisplayStatus(true);
            }
         }
         this.mbAssistWhileScreenOff = false;
      }
      
      private function onCallState(e:BluetoothEvent) : void
      {
         var currentCallState:Object = e.currentTarget.bluetoothHFP.mlastCallData4Fav;
         if(e.data != null)
         {
            if(true == e.data.transferDelay)
            {
               this.mTransferDelay = true;
            }
         }
         if(currentCallState != null)
         {
            if("idle" == currentCallState.callState)
            {
               this.mTransferDelay = false;
               Peripheral.audioSettings.setSHFMicMute(false);
            }
         }
         if(Framework.structure.currentBranch != "mainbackground/menu/emergencycall")
         {
            this.processBTCallState();
         }
      }
      
      private function processBTCallState() : void
      {
         if(Peripheral.bluetoothPhone.getDialingCall() != null)
         {
            this.checkNavDomainExit();
            if(-1 != Framework.popupManager.active)
            {
               if(!(Framework.popupManager.active == DynamicPopupNames.PHONE_PAIRING && true == this.mTransferDelay))
               {
                  Framework.popupManager.exit();
               }
            }
            if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE))
            {
               Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_CAM);
            }
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
         if(Peripheral.bluetoothPhone.getRingingCall() != null || Peripheral.bluetoothPhone.getWaitingCall() != null)
         {
            this.mPhoneIsRinging = true;
            if(Framework.structure.currentBranch == Screens.MAIN_PHONE)
            {
               this.closeSmsPopups();
            }
            if(Framework.structure.currentBranch != "mainbackground/menu/phonemainscreen" && Framework.structure.currentBranch != Screens.MAIN_PHONE)
            {
               if(Framework.structure.currentBranch == "mainbackground/menu/emergencycall")
               {
                  if(this.mReturnToScreenAfterEcall == "")
                  {
                     this.mPrevScreenBeforeActiveCall = this.branchNameFromSource(this.currentSource);
                  }
                  else
                  {
                     this.mPrevScreenBeforeActiveCall = this.mReturnToScreenAfterEcall;
                  }
               }
               else
               {
                  this.mPrevScreenBeforeActiveCall = Framework.structure.currentBranch;
               }
               if(Peripheral.bluetoothPhone.getWaitingCall() != null && Peripheral.bluetoothPhone.getWaitingCall().previousCallState != "waiting")
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_INCOMING_CALL,"incomingcall",{"type":PopupType.PHONE});
               }
               if(Peripheral.bluetoothPhone.getRingingCall() != null && Peripheral.bluetoothPhone.getRingingCall().previousCallState != "ringing")
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_INCOMING_CALL,"incomingcall",{"type":PopupType.PHONE});
               }
            }
            if(Framework.popupManager.check(DynamicPopupNames.PHONE_DIALING))
            {
               Framework.popupManager.dequeue(DynamicPopupNames.PHONE_DIALING);
            }
         }
         else
         {
            this.mPhoneIsRinging = false;
            Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
         }
         if(this.mPrevScreenBeforeActiveCall != "" && Peripheral.bluetoothPhone.currentCalls.length == 0)
         {
            if(Framework.structure.currentBranch == Screens.MAIN_PHONE)
            {
               Framework.structure.back();
            }
            this.mPrevScreenBeforeActiveCall = "";
         }
         this.updateVRContext(Framework.structure.currentBranch);
      }
      
      private function onSetNavRepeatPrompt(evt:HMIRequestEvent) : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            Peripheral.navigation.navDomainControl.requestShortcut(Shortcuts.REPEAT_PROMPT);
            Peripheral.hmiRequest.navSendSetNavRepeatPromptResponse(true);
         }
         else
         {
            Peripheral.hmiRequest.navSendSetNavRepeatPromptResponse(false);
         }
      }
      
      private function onMediaError(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.VRData != null && e.data.code == MediaErrorCodes.TRACK_SESSION_UNPLAYABLE)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_MEDIA_TRKSESSION_UNPLAYABLE);
         }
      }
      
      private function onMediaDevice(e:MediaPlayerEvent) : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.CONTROLS && (Framework.structure.currentBranch == Screens.MAIN_MEDIA || Framework.structure.currentBranch == Screens.BROWSE_MEDIA))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
         }
      }
      
      private function isPlayerCategory() : Boolean
      {
         var currBranch:String = Framework.structure.currentBranch;
         switch(currBranch)
         {
            case Screens.MAIN_MEDIA:
            case Screens.BROWSE_MEDIA:
               return true;
            default:
               return false;
         }
      }
      
      private function isRadioCategory() : Boolean
      {
         var currBranch:String = Framework.structure.currentBranch;
         switch(currBranch)
         {
            case Screens.MAIN_SAT:
            case Screens.MAIN_FM:
            case Screens.MAIN_RADIO:
            case Screens.MAIN_DMB:
            case Screens.BROWSE_SAT:
            case Screens.BROWSE_FM:
            case Screens.BROWSE_DAB:
               return true;
            default:
               return false;
         }
      }
      
      private function onEmergencyCallState(evt:EmergencyCallStateEvent) : void
      {
         this.handleECallScreen(false);
      }
      
      private function onSwitchToEcallScreen(evt:EmergencyCallStateEvent) : void
      {
         if(Peripheral.emergencyCallState.getInEmergency() == true && Framework.structure.currentBranch != "mainbackground/menu/emergencycall")
         {
            if(Framework.popupManager.check(DynamicPopupNames.INFO_APPS_LOADING))
            {
               Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
            }
            Framework.structure.goto("mainbackground/menu/emergencycall");
         }
      }
      
      private function checkNavDomainExit() : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
      }
      
      private function onPopupManagerClose(e:PopupManagerEvent) : void
      {
         if(Framework.structure.currentBranch == Screens.MAIN_PHONE && this.mAssistAppInBkgd)
         {
            Framework.Trace("in phone main menu and assist app is running. put phone not avail popup");
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
         }
      }
      
      private function onPopupManagerTimeout(e:PopupManagerEvent) : void
      {
         if(Framework.popupManager.check(DynamicPopupNames.HYBRID_ELECTRIC_PAGES_CHARGE_NOW))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.HYBRID_ELECTRIC_PAGES_CHARGE_NOW);
         }
      }
      
      private function onIPAddressConflict(e:ConnectionManagerEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.CONNMGR_IP_CONFLICT,{"iface":e.mData.iface});
      }
      
      private function closeSmsPopups() : void
      {
         if(Framework.popupManager.check(DynamicPopupNames.SMS_INCOMING_MESSAGE))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else if(Framework.popupManager.check(DynamicPopupNames.SMS_MESSAGE_FULL))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_MESSAGE_FULL);
         }
      }
      
      private function getApplication(appId:String) : Applet
      {
         var obj:Object = null;
         var app:Applet = null;
         for each(var _loc6_ in Peripheral.appManager.getAllApplications())
         {
            obj = _loc6_;
            _loc6_;
            app = obj as Applet;
            if(app.appId == appId)
            {
               return app;
            }
         }
         return null;
      }
      
      private function onTerrainModeChange(e:DriveModeEvent) : void
      {
         var mVehicleBrand:String = null;
         var theme:String = null;
         var brand:String = null;
         if(Peripheral.vehicleStatus.SelecTerrainModeStatus)
         {
            mVehicleBrand = "Default";
            theme = "";
            if(Global.SRTpackagePrsnt)
            {
               mVehicleBrand = "SRT";
            }
            else
            {
               brand = Peripheral.vehConfig.vehicleBrand;
               switch(brand)
               {
                  case "2":
                     if(Peripheral.vehConfig.vehicleLine == "ZD")
                     {
                        mVehicleBrand = "Viper";
                     }
                     else
                     {
                        mVehicleBrand = "Dodge";
                     }
                     break;
                  case "3":
                     mVehicleBrand = "Jeep";
                     break;
                  case "1":
                     mVehicleBrand = "Chrysler";
                     break;
                  case "12":
                     mVehicleBrand = "Ram";
                     break;
                  case "9":
                     mVehicleBrand = "Fiat";
                     break;
                  case "11":
                     mVehicleBrand = "Maserati";
                     break;
                  case "8":
                     mVehicleBrand = "AlfaRomeo";
                     break;
                  case "10":
                     mVehicleBrand = "Lancia";
                     break;
                  default:
                     mVehicleBrand = "Default";
               }
            }
            theme = mVehicleBrand + "/TerrainThemes/";
            switch(Peripheral.driveMode.TerrainThemeStatus)
            {
               case "Track":
                  theme = theme + "track.swf";
                  break;
               case "Rock":
                  theme = theme + "rock.swf";
                  break;
               case "Tow":
                  theme = theme + "tow.swf";
                  break;
               case "Snow":
                  theme = theme + "snow.swf";
                  break;
               case "Normal":
                  theme = theme + "normal.swf";
                  break;
               case "Ice":
                  theme = theme + "ice.swf";
                  break;
               case "All Road":
                  theme = theme + "allroads.swf";
                  break;
               case "Sport":
                  theme = theme + "sport.swf";
                  break;
               case "MudSand":
                  theme = theme + "mudsand.swf";
                  break;
               case "Sand":
                  theme = theme + "sand.swf";
                  break;
               case "Mud":
                  theme = theme + "mud.swf";
                  break;
               case "Auto":
               default:
                  theme = Peripheral.vehicleStatus.selecTerrainModePrevTheme;
            }
            Framework.themeEngine.theme = theme;
            Peripheral.vehicleStatus.setThemeTo(theme);
         }
      }
      
      public function recordSplitScreen() : void
      {
         Peripheral.persistency.write(PersistencyKeys.KEY_SPLITSCREEN,{"value":this.splitScreenSource});
      }
      
      private function onActivateNavigation(e:StructureEvent) : void
      {
         Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
         Peripheral.navigation.navDomainControl.onNavDomainButton();
      }
      
      private function onLeavingNav(e:StructureEvent) : void
      {
         Peripheral.navigation.navDomainControl.exitNavDomain();
      }
      
      private function onEnableChargeNowPopUp(e:Event) : void
      {
         if(Peripheral.hev.enableChargeNowPopUp)
         {
            Framework.popupManager.show(DynamicPopupNames.HYBRID_ELECTRIC_PAGES_CHARGE_NOW,Screens.POPUP_HYBRID_ELECTRIC_PAGES_CHARGE_NOW,{
               "type":PopupType.CHARGE_NOW,
               "timeout":60000
            });
         }
         else if(!Peripheral.hev.enableChargeNowPopUp)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.HYBRID_ELECTRIC_PAGES_CHARGE_NOW);
         }
      }
      
      private function onPhoneProjectionStatus(e:PhoneProjectionEvent) : void
      {
         if(Peripheral.phoneProjection.sessionActive)
         {
            if(Framework.structure.currentBranch != Screens.DEVICE_PROJECTION)
            {
               if(Peripheral.persistency.getValue(PersistencyKeys.KEY_PROJECTION_AUTO_SHOW))
               {
                  Framework.structure.goto(Screens.DEVICE_PROJECTION);
               }
            }
         }
         else
         {
            if(Peripheral.phoneProjection.sessionStatus == Peripheral.phoneProjection.INTERNAL_ERROR)
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PROJECTION_DEVICE_CONNECT_ERROR);
            }
            if(Framework.structure.currentBranch == Screens.DEVICE_PROJECTION)
            {
               Framework.structure.goto(this.branchNameFromSource(Peripheral.audioManager.source));
            }
         }
      }
      
      public function onProjectionDeviceDisconnected(e:PhoneProjectionEvent) : void
      {
         if(e.mData.ppid == this.activePpId && Screens.DEVICE_PROJECTION == Framework.structure.currentBranch)
         {
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      public function callStartProjection(ppid:String) : void
      {
         Peripheral.phoneProjection.startProjection(ppid);
         this.activePpId = ppid;
      }
      
      private function isEmergencyCall() : Boolean
      {
         switch(Peripheral.emergencyCallState.getEmergencyCallState())
         {
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK:
               return true;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
         }
         return false;
      }
      
      private function onDeviceList(e:PhoneProjectionEvent) : void
      {
         var device:Object = null;
         var ppid:String = "";
         Peripheral.phoneProjection.removeEventListener(PhoneProjectionEvent.PROJECTION_DEVICE_LIST,this.onDeviceList);
         for each(var _loc6_ in e.mData)
         {
            device = _loc6_;
            _loc6_;
            if(device.serialNumber != "")
            {
               ppid = device.ppid;
               break;
            }
         }
         if(ppid != "")
         {
            this.callStartProjection(ppid);
         }
         else if(this.branchNameFromSource(Peripheral.audioManager.source) != Screens.DEVICE_PROJECTION)
         {
            Framework.structure.goto(this.branchNameFromSource(Peripheral.audioManager.source));
         }
         else
         {
            Framework.structure.goto(Screens.DEVICE_PROJECTION);
            Framework.popupManager.show(DynamicPopupNames.CONNECT_PROJECTION_DEVICE,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "status":"connect projection device",
               "timeout":30000
            });
            this.mProjectionDeviceTimer.addEventListener(TimerEvent.TIMER,this.onProjectionDeviceTimer);
            this.mProjectionDeviceTimer.start();
         }
      }
      
      private function onProjectionDeviceTimer(e:TimerEvent) : void
      {
         this.mProjectionDeviceTimer.stop();
         this.mProjectionDeviceTimer.removeEventListener(TimerEvent.TIMER,this.onProjectionDeviceTimer);
         if(Framework.popupManager.active == DynamicPopupNames.CONNECT_PROJECTION_DEVICE)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.CONNECT_PROJECTION_DEVICE);
         }
         if(Framework.structure.currentBranch == Screens.DEVICE_PROJECTION)
         {
            Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_FM);
            if(Global.market != TunerRegion.NORTH_AMERICA)
            {
               Framework.structure.goto(Screens.MAIN_RADIO);
            }
            else
            {
               Framework.structure.goto(Screens.MAIN_FM);
            }
         }
      }
      
      private function onProjectionDeviceConnected(e:PhoneProjectionEvent) : void
      {
         if(!this.isEmergencyCall())
         {
            if(!Peripheral.phoneProjection.sessionActive)
            {
               this.callStartProjection(e.mData.ppid);
            }
            else if(this.activePpId != e.mData.ppid)
            {
               this.newPpId = e.mData.ppid;
               Framework.popupManager.show(DynamicPopupNames.SECOND_DEVICE_CONNECTED,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"new projection device",
                  "timeout":Style.TEN_SECOND_POPUP_TIMEOUT
               });
            }
         }
      }
      
      private function onEPBServiceActiveAlert(e:VehicleStatusEvent) : void
      {
         if(!Framework.popupManager.check(DynamicPopupNames.BRAKESERVICE) && Peripheral.personalConfig.brakeServiceStatus == true)
         {
            Framework.popupManager.show(DynamicPopupNames.BRAKESERVICE,"brakeservicepopup",{
               "type":PopupType.IMPORTANT,
               "status":"ModeOn"
            });
         }
      }
      
      private function onFLHeatedSeatFailure(e:VehSettingsEvent) : void
      {
         var featureString:String = this.mVFM.hasRightHandDrive ? Peripheral.localeEngine.getText(T.STRB_VEHICLE_PASSENGER) : Peripheral.localeEngine.getText(T.STRB_VEHICLE_DRIVER);
         featureString = featureString + " " + "Heated Seat";
         if(Peripheral.vehSettings.comfortFeatureFailPopUpState("heatedSeats","frontLeft"))
         {
            Framework.popupManager.show(DynamicPopupNames.FL_HEAT_SEAT_FAIL_POPUP,"PopupInfo.swf",{
               "timeout":5000,
               "type":PopupType.PRIMARY,
               "title":[featureString],
               "message":["Unable to change setting."],
               "caption1":T.STRB_OK
            });
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FL_HEAT_SEAT_FAIL_POPUP);
         }
      }
      
      private function onFRHeatedSeatFailure(e:VehSettingsEvent) : void
      {
         var featureString:String = this.mVFM.hasRightHandDrive ? Peripheral.localeEngine.getText(T.STRB_VEHICLE_DRIVER) : Peripheral.localeEngine.getText(T.STRB_VEHICLE_PASSENGER);
         featureString = featureString + " " + "Heated Seat";
         if(Peripheral.vehSettings.comfortFeatureFailPopUpState("heatedSeats","frontRight"))
         {
            Framework.popupManager.show(DynamicPopupNames.FR_HEAT_SEAT_FAIL_POPUP,"PopupInfo.swf",{
               "timeout":5000,
               "type":PopupType.PRIMARY,
               "title":[featureString],
               "message":["Unable to change setting."],
               "caption1":T.STRB_OK
            });
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FR_HEAT_SEAT_FAIL_POPUP);
         }
      }
      
      private function onFLVentedSeatFailure(e:VehSettingsEvent) : void
      {
         var featureString:String = this.mVFM.hasRightHandDrive ? Peripheral.localeEngine.getText(T.STRB_VEHICLE_PASSENGER) : Peripheral.localeEngine.getText(T.STRB_VEHICLE_DRIVER);
         featureString = featureString + " " + Peripheral.localeEngine.getText(T.STRB_VEHICLE_VENTED_SEAT);
         if(Peripheral.vehSettings.comfortFeatureFailPopUpState("ventedSeats","frontLeft"))
         {
            Framework.popupManager.show(DynamicPopupNames.FL_VENT_SEAT_FAIL_POPUP,"PopupInfo.swf",{
               "timeout":5000,
               "type":PopupType.PRIMARY,
               "title":[featureString],
               "message":["Unable to change setting."],
               "caption1":T.STRB_OK
            });
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FL_VENT_SEAT_FAIL_POPUP);
         }
      }
      
      private function onFRVentedSeatFailure(e:VehSettingsEvent) : void
      {
         var featureString:String = this.mVFM.hasRightHandDrive ? Peripheral.localeEngine.getText(T.STRB_VEHICLE_DRIVER) : Peripheral.localeEngine.getText(T.STRB_VEHICLE_PASSENGER);
         featureString = featureString + " " + Peripheral.localeEngine.getText(T.STRB_VEHICLE_VENTED_SEAT);
         if(Peripheral.vehSettings.comfortFeatureFailPopUpState("ventedSeats","frontRight"))
         {
            Framework.popupManager.show(DynamicPopupNames.FR_VENT_SEAT_FAIL_POPUP,"PopupInfo.swf",{
               "timeout":5000,
               "type":PopupType.PRIMARY,
               "title":[featureString],
               "message":["Unable to change setting."],
               "caption1":T.STRB_OK
            });
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FR_VENT_SEAT_FAIL_POPUP);
         }
      }
      
      private function onHeatWheelFailure(e:VehSettingsEvent) : void
      {
         var featureString:String = Peripheral.localeEngine.getText(T.STRB_VEHICLE_HEATED_WHEEL);
         if(Peripheral.vehSettings.comfortFeatureFailPopUpState("heatedWheel"))
         {
            Framework.popupManager.show(DynamicPopupNames.HEAT_WHEEL_FAIL_POPUP,"PopupInfo.swf",{
               "timeout":5000,
               "type":PopupType.PRIMARY,
               "title":[featureString],
               "message":["Unable to change setting."],
               "caption1":T.STRB_OK
            });
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.HEAT_WHEEL_FAIL_POPUP);
         }
      }
      
      private function onRequestDisplayResponse(e:DisplayManagerEvent) : void
      {
         Peripheral.displayManager.removeEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onRequestDisplayResponse);
         Peripheral.rse.startRdc2Video("parentalControlsRequest");
         Framework.structure.goto(Screens.PARENTALCONTROLS);
      }
   }
}

