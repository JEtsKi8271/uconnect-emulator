package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.MessageEvent;
   import core.utils.Text;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.events.*;
   import flash.text.TextField;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PhoneMainScreen extends GenericScreen
   {
      
      private const IDLE:String = "idle";
      
      private const DIALING:String = "dialing";
      
      private const SECOND_DIALING:String = "second dialing";
      
      private const RINGING:String = "ringing";
      
      private const ACTIVE:String = "active";
      
      private const TRANSFERRED:String = "transfer call";
      
      private const SECOND_RINGING:String = "second ringing";
      
      private const TWO_ACTIVE_ONE_ONHOLD:String = "two active, one onhold";
      
      private const CONFERENCE_CALL:String = "conference call";
      
      private const CONFERENCE_CALL_ONHOLD:String = "conference call onhold";
      
      private const NO_PHONE_CONNECTED:String = "no phone connected";
      
      private const NO_PHONES_PAIRED:String = "no phones paired";
      
      private const CONTACT_LENGTH:int = 12;
      
      private const CALL_ENDED_DISPLAY_TIME:int = 10000;
      
      private const MAX_FAVORITES:int = 10;
      
      private const MIN_FAVORITES:int = 5;
      
      private const START_INDEX:int = 0;
      
      private const INFO_DEBOUNCE_TIMEOUT:int = 1000;
      
      private const INFO_DEBOUNCE_TIMEOUT_LONG:int = 2000;
      
      private const SMS_POPUPS_TIMEOUT:uint = 5000;
      
      private var mLastDisplayTime:String = "00:00:00";
      
      private var mFavNumberPosition:int = 0;
      
      private var mCallAmount:int = 0;
      
      private var mlastCallState:String = "";
      
      private var mHasEndCall:Boolean = false;
      
      private var mHasIgnoredCall:Boolean = false;
      
      private var mHasSHFMutedState:Boolean = false;
      
      private var mWasMutedOnActive:Boolean = false;
      
      private var mPhonebookAvailable:Boolean = false;
      
      private var mPriorPhoneState:String = "";
      
      private var mIsConferenced:Boolean = false;
      
      private var mIsHeldConferenced:Boolean = false;
      
      private var mbContactIDDisplay:Boolean = false;
      
      private var mFavoritesContacts:Vector.<PhoneBookContact>;
      
      private var mId:int = 0;
      
      private var mTimeoutTimer:Timer = new Timer(10000);
      
      private var mCallType1:String = "";
      
      private var mCallType2:String = "";
      
      private var mCallTypeNumber1:String = "";
      
      private var mCallTypeNumber2:String = "";
      
      private var mAllActiveCalls:Vector.<BluetoothCall> = null;
      
      public function PhoneMainScreen()
      {
         mView = new C_PhoneMainScreen();
         mView.doNotDecorate = true;
         cache = true;
         super();
      }
      
      override public function screenIn() : void
      {
         this.mCallAmount = 0;
         switch(this.phoneState)
         {
            case "idle":
               Peripheral.bluetoothPhone.phoneHomeScreenStatus(true,Peripheral.localeEngine.getText(T.STRB_PHONE_READY));
               break;
            case "transfer call":
               Peripheral.bluetoothPhone.phoneHomeScreenStatus(true,Peripheral.localeEngine.getText(T.STRB_AUDIO_TRANSFERRED));
               break;
            default:
               Peripheral.bluetoothPhone.phoneHomeScreenStatus(true,"");
         }
         super.screenIn();
      }
      
      override public function screenOut() : void
      {
         Peripheral.bluetoothPhone.phoneHomeScreenStatus(false,"");
         super.screenOut();
      }
      
      override public function cleanup() : void
      {
         this.mFavoritesContacts = null;
         this.mTimeoutTimer = null;
         super.cleanup();
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.displayPrimaryPhone.displayBatteryStatus.visible = false;
         mView.displayPrimaryPhone.displaySignalStrength.visible = false;
         mView.displayPrimaryPhone.displayCallStatus.visible = false;
         mView.displayPrimaryPhone.labelRoaming.visible = false;
         mView.displayPrimaryPhone.labelVR.visible = false;
         mView.displayPrimaryPhone.labelPhoneName.text = "";
         t(mView.displayPrimaryPhone.labelCallTime,"");
         t(mView.displayPrimaryPhone.labelAction,"");
         t(mView.displayPrimaryPhone.labelStatus,"");
         this.setPrimaryPhoneIconVisibility(false);
         mView.displayPrimaryPhone.missedCalls.visible = false;
         mView.displayPrimaryPhone.missedTexts.visible = false;
         mView.btnAnswer_button.visible = false;
         mView.btnIgnore_button.visible = false;
         mView.btnHold_button.visible = false;
         mView.btnRedial_button.visible = true;
         mView.displaySecondaryPhone.visible = false;
         mView.btnFav1_button.labelEmpty_translate.visible = true;
         mView.btnFav2_button.labelEmpty_translate.visible = true;
         mView.btnFav3_button.labelEmpty_translate.visible = true;
         mView.btnFav4_button.labelEmpty_translate.visible = true;
         mView.btnFav5_button.labelEmpty_translate.visible = true;
         mView.btnFav1_button.labelHoldToSet_translate.visible = false;
         mView.btnFav2_button.labelHoldToSet_translate.visible = false;
         mView.btnFav3_button.labelHoldToSet_translate.visible = false;
         mView.btnFav4_button.labelHoldToSet_translate.visible = false;
         mView.btnFav5_button.labelHoldToSet_translate.visible = false;
         mView.btnFav1_button.labelName.visible = false;
         mView.btnFav2_button.labelName.visible = false;
         mView.btnFav3_button.labelName.visible = false;
         mView.btnFav4_button.labelName.visible = false;
         mView.btnFav5_button.labelName.visible = false;
         mView.doNotDisturb.visible = true;
         Framework.focusManager.refresh();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mHasEndCall = false;
         this.mPriorPhoneState = "";
         this.mHasSHFMutedState = Peripheral.audioSettings.SHFMicMute;
         Peripheral.bluetoothPhone.getProperties(BluetoothPropertyConstants.PROP_GAP_NETWORK_REGISTRATION_STATE);
         Peripheral.bluetoothPhone.getProperties(BluetoothPropertyConstants.PROP_HFP_SIGNAL_QUALITY);
         Peripheral.bluetoothPhone.getProperties(BluetoothPropertyConstants.PROP_HFP_BATTERY_CHARGE);
         this.mId = Peripheral.phonebook.requestFavoritesByRange(this.START_INDEX,this.MAX_FAVORITES);
         Peripheral.bluetoothPhone.phoneBook.requestPhoneBookReady();
         Peripheral.smsMessaging.CheckIsSMSSupported();
         this.setScreenState();
         Framework.structure.setExit();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.btnSwap_button,mView.btnAnswer_button,mView.btnRedial_button,mView.btnHold_button,mView.btnFav1_button,mView.btnFav2_button,mView.btnFav3_button,mView.btnFav4_button,mView.btnFav5_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button,mView.btnConfCall_button,mView.btnSettings_button,mView.btnMessaging_button,mView.doNotDisturb.btnReplyWithTextMessage_button,mView.btnDial_button,mView.doNotDisturb.btnDoNotDisturb_button,mView.btnRecentCall_button,mView.btnPhoneBook_button,mView.btnEnd_button,mView.btnIgnore_button]));
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Framework.messenger.onSend(this.onMessage);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_ACTIVE_CALL_OK,this.onEndCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_ALL_CALL_FAIL,this.onEndCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_CALL_OK,this.onEndCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_CALL_FAIL,this.onEndCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.RESUME_HELD_CALL_OK,this.onResumeCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.RESUME_HELD_CALL_FAIL,this.onResumeCall,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SET_HF_MODE_OK,this.onHandsFreeModeStatus,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SET_HF_MODE_FAIL,this.onHandsFreeModeStatus,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.BATTERY_CHARGE,this.onBatteryCharge,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.AUDIO_STATUS,this.onAudioStatus,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.DEVICE_PAIRED_OK,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.OFF_HOOK_TIMER,this.onOffHookTimer,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.NETWORK_REGISTRATION_STATE,this.onNetworkRegistrationState,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.NETWORK_OPERATOR_CHANGED,this.onNetworkOperatorState,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.HANDS_FREE_MODE,this.onHfMode,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALLER_ID_INFO,this.onCallerID,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SUPPORTED_FEATURES_LIST,this.onSupportedFeaturesList,false,0,true);
         attachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onBTStatus,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SWAP_CALLS_FAIL,this.onswapCalls,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SWAP_CALLS_OK,this.onswapCalls,false,0,true);
         attachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.AVAILABILITY,this.phoneBookAvailable,false,0,true);
         attachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.FAVORITES_LIST,this.phoneFavAvailable,false,0,true);
         attachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.FAVORITE_UPDATED,this.phoneFavUpdated,false,0,true);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.AVAILABILITY,this.onCallListAvailable,false,0,true);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.SEND_AUTO_REPLY_FOR_CALL,this.onSendAutoReplyForCall,false,0,true);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_SYNC_STATE,this.onSMSSyncState);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_FEATURE_SUPPORT,this.onSMSSyncState);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SEND_AUTO_REPLY_FOR_SMS,this.onSendAutoReplyForSMS,false,0,true);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         attachListener(Peripheral.audioSettings,AudioEvent.HFMIC,this.onHFMicState,false,0,true);
         attachListener(Peripheral.audioMixerManager,AudioEvent.INTERRUPT_MUTE,this.muteStatusEvent,false,0,false);
         attachListener(Peripheral.phonebook,PhoneBookEvent.PHONEBOOK_SYNC_STATUS,this.onPhonebookSyncStatus,false,0,true);
         attachListener(mView.btnFav1_button,WidgetEvent.CLICK,this.callFavoriteEvent,false,0,true);
         attachListener(mView.btnFav2_button,WidgetEvent.CLICK,this.callFavoriteEvent,false,0,true);
         attachListener(mView.btnFav3_button,WidgetEvent.CLICK,this.callFavoriteEvent,false,0,true);
         attachListener(mView.btnFav4_button,WidgetEvent.CLICK,this.callFavoriteEvent,false,0,true);
         attachListener(mView.btnFav5_button,WidgetEvent.CLICK,this.callFavoriteEvent,false,0,true);
         attachListener(mView.btnFav1_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent,false,0,true);
         attachListener(mView.btnFav2_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent,false,0,true);
         attachListener(mView.btnFav3_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent,false,0,true);
         attachListener(mView.btnFav4_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent,false,0,true);
         attachListener(mView.btnFav5_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent,false,0,true);
         attachListener(mView.btnEnd_button,MouseEvent.CLICK,this.btnEndClickEvent,false,0,true);
         attachListener(mView.btnHold_button,MouseEvent.CLICK,this.btnHoldClickEvent,false,0,true);
         attachListener(mView.btnRedial_button,MouseEvent.CLICK,this.btnRedialClickEvent,false,0,true);
         attachListener(mView.btnAnswer_button,MouseEvent.CLICK,this.btnAnswerClickEvent,false,0,true);
         attachListener(mView.btnIgnore_button,MouseEvent.CLICK,this.btnIgnoreClickEvent,false,0,true);
         attachListener(mView.btnSwap_button,MouseEvent.CLICK,this.btnSwapClickEvent,false,0,true);
         attachListener(mView.btnMute_button,MouseEvent.CLICK,this.btnMuteClickEvent,false,0,true);
         attachListener(mView.btnTransfer_button,MouseEvent.CLICK,this.btnTransferClickEvent,false,0,true);
         attachListener(mView.btnTransferBack_button,MouseEvent.CLICK,this.btnTransferBackClickEvent,false,0,true);
         attachListener(mView.btnConfCall_button,MouseEvent.CLICK,this.btnConfCallClickEvent,false,0,true);
         attachListener(mView.btnDial_button,MouseEvent.CLICK,this.btnDialClickEvent,false,0,true);
         attachListener(mView.btnSettings_button,MouseEvent.CLICK,this.btnSettingsClickEvent,false,0,true);
         attachListener(mView.btnPhoneBook_button,MouseEvent.CLICK,this.btnPhoneBookClickEvent,false,0,true);
         attachListener(mView.btnRecentCall_button,MouseEvent.CLICK,this.btnRecentCallClickEvent,false,0,true);
         attachListener(mView.btnMessaging_button,MouseEvent.CLICK,this.btnMessagingClickEvent,false,0,true);
         attachListener(mView.doNotDisturb.btnDoNotDisturb_button,WidgetEvent.CLICK,this.onDoNotDisturbClick,false,0,true);
         attachListener(mView.doNotDisturb.btnReplyWithTextMessage_button,WidgetEvent.CLICK,this.onReplyWithTextMessageClick,false,0,true);
         attachListener(mView.displayPrimaryPhone,MouseEvent.CLICK,this.primaryClickEvent,false,0,true);
         attachListener(mView.displaySecondaryPhone,MouseEvent.CLICK,this.secondaryClickEvent,false,0,true);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,this.onEnterPressed);
         attachListener(Peripheral.bluetoothPhone.bluetoothHFP,BluetoothEvent.DND_STATUS,this.onDNDStatus,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.DND_STATUS,this.onVRDNDStatus,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Framework.messenger.removeOnSend(this.onMessage);
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_PAIRING);
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_DIALING);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_ACTIVE_CALL_OK,this.onEndCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_ALL_CALL_FAIL,this.onEndCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_CALL_OK,this.onEndCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.END_CALL_FAIL,this.onEndCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.RESUME_HELD_CALL_OK,this.onResumeCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.RESUME_HELD_CALL_FAIL,this.onResumeCall);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SET_HF_MODE_OK,this.onHandsFreeModeStatus);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SET_HF_MODE_FAIL,this.onHandsFreeModeStatus);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.BATTERY_CHARGE,this.onBatteryCharge);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.AUDIO_STATUS,this.onAudioStatus);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_UNPAIRED,this.onDeviceChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.DEVICE_PAIRED_OK,this.onDeviceChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.OFF_HOOK_TIMER,this.onOffHookTimer);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.NETWORK_REGISTRATION_STATE,this.onNetworkRegistrationState);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.NETWORK_OPERATOR_CHANGED,this.onNetworkOperatorState);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.HANDS_FREE_MODE,this.onHfMode);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALLER_ID_INFO,this.onCallerID);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SUPPORTED_FEATURES_LIST,this.onSupportedFeaturesList);
         detachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onBTStatus);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SWAP_CALLS_FAIL,this.onswapCalls);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SWAP_CALLS_OK,this.onswapCalls);
         detachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.AVAILABILITY,this.phoneBookAvailable);
         detachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.FAVORITES_LIST,this.phoneFavAvailable);
         detachListener(Peripheral.bluetoothPhone.phoneBook,PhoneBookEvent.FAVORITE_UPDATED,this.phoneFavUpdated);
         detachListener(Peripheral.phoneCallList,PhoneCallListEvent.AVAILABILITY,this.onCallListAvailable);
         detachListener(Peripheral.phoneCallList,PhoneCallListEvent.SEND_AUTO_REPLY_FOR_CALL,this.onSendAutoReplyForCall);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_SYNC_STATE,this.onSMSSyncState);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_FEATURE_SUPPORT,this.onSMSSyncState);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SEND_AUTO_REPLY_FOR_SMS,this.onSendAutoReplyForSMS);
         detachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         detachListener(Peripheral.audioSettings,AudioEvent.HFMIC,this.onHFMicState);
         detachListener(Peripheral.audioMixerManager,AudioEvent.INTERRUPT_MUTE,this.muteStatusEvent);
         detachListener(Peripheral.phonebook,PhoneBookEvent.PHONEBOOK_SYNC_STATUS,this.onPhonebookSyncStatus);
         detachListener(mView.btnFav1_button,WidgetEvent.CLICK,this.callFavoriteEvent);
         detachListener(mView.btnFav2_button,WidgetEvent.CLICK,this.callFavoriteEvent);
         detachListener(mView.btnFav3_button,WidgetEvent.CLICK,this.callFavoriteEvent);
         detachListener(mView.btnFav4_button,WidgetEvent.CLICK,this.callFavoriteEvent);
         detachListener(mView.btnFav5_button,WidgetEvent.CLICK,this.callFavoriteEvent);
         detachListener(mView.btnFav1_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent);
         detachListener(mView.btnFav2_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent);
         detachListener(mView.btnFav3_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent);
         detachListener(mView.btnFav4_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent);
         detachListener(mView.btnFav5_button,WidgetEvent.LONG_PRESS,this.storeFavoriteEvent);
         detachListener(mView.btnEnd_button,MouseEvent.CLICK,this.btnEndClickEvent);
         detachListener(mView.btnHold_button,MouseEvent.CLICK,this.btnHoldClickEvent);
         detachListener(mView.btnRedial_button,MouseEvent.CLICK,this.btnRedialClickEvent);
         detachListener(mView.btnAnswer_button,MouseEvent.CLICK,this.btnAnswerClickEvent);
         detachListener(mView.btnIgnore_button,MouseEvent.CLICK,this.btnIgnoreClickEvent);
         detachListener(mView.btnSwap_button,MouseEvent.CLICK,this.btnSwapClickEvent);
         detachListener(mView.btnMute_button,MouseEvent.CLICK,this.btnMuteClickEvent);
         detachListener(mView.btnTransfer_button,MouseEvent.CLICK,this.btnTransferClickEvent);
         detachListener(mView.btnTransferBack_button,MouseEvent.CLICK,this.btnTransferBackClickEvent);
         detachListener(mView.btnConfCall_button,MouseEvent.CLICK,this.btnConfCallClickEvent);
         detachListener(mView.btnDial_button,MouseEvent.CLICK,this.btnDialClickEvent);
         detachListener(mView.btnSettings_button,MouseEvent.CLICK,this.btnSettingsClickEvent);
         detachListener(mView.btnPhoneBook_button,MouseEvent.CLICK,this.btnPhoneBookClickEvent);
         detachListener(mView.btnRecentCall_button,MouseEvent.CLICK,this.btnRecentCallClickEvent);
         detachListener(mView.btnMessaging_button,MouseEvent.CLICK,this.btnMessagingClickEvent);
         detachListener(mView.doNotDisturb.btnDoNotDisturb_button,WidgetEvent.CLICK,this.onDoNotDisturbClick);
         detachListener(mView.doNotDisturb.btnReplyWithTextMessage_button,WidgetEvent.CLICK,this.onReplyWithTextMessageClick);
         detachListener(mView.displayPrimaryPhone,MouseEvent.CLICK,this.primaryClickEvent);
         detachListener(mView.displaySecondaryPhone,MouseEvent.CLICK,this.secondaryClickEvent);
         detachListener(Peripheral.hardControls,HardControlEvent.SELECT,this.onEnterPressed);
         detachListener(Peripheral.bluetoothPhone.bluetoothHFP,BluetoothEvent.DND_STATUS,this.onDNDStatus);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.DND_STATUS,this.onVRDNDStatus);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.btnRecentCall_button.label,T.STRB_RECENT_CALLS);
         Text.horizontallyAlignChildren(mView.btnDial_button,T.STRB_DIAL);
         t(mView.btnMessaging_button.label,T.STRB_MESSAGING);
         t(mView.btnSettings_button.label,T.STRB_PHONE_SETTINGS);
         t(mView.btnPhoneBook_button.label,T.STRB_PHONEBOOK);
         t(mView.btnMute_button.label,T.STRB_MUTE_PHONE);
         t(mView.btnTransferBack_button.label,T.STRB_TRANSFER_BACK);
         Text.verticallyAlignChildren(mView.btnTransfer_button,T.STRB_TRANSFER);
         Text.verticallyAlignChildren(mView.btnConfCall_button,T.STRB_JOIN_CALLS_BUTTON);
         t(mView.btnSwap_button.label,T.STRB_SWAP);
         t(mView.btnRedial_button.label,T.STRB_REDIAL);
         t(mView.btnHold_button.label,T.STRB_HOLD);
         t(mView.btnAnswer_button.label,T.STRB_ANSWER);
         t(mView.btnEnd_button.label,T.STRB_END);
         t(mView.btnIgnore_button.label,T.STRB_IGNORE);
         t(mView.doNotDisturb.btnDoNotDisturb_button.label,T.STRB_DO_NOT_DISTURB_ML);
         Text.verticallyAlignChildren(mView.doNotDisturb.btnReplyWithTextMessage_button,T.STRB_REPLY_WITH_TEXT_MESSAGE_ML);
         t(mView.btnFav1_button.labelHoldToSet_translate,T.STRB_HOLD_TO_SET_PHONE);
         t(mView.btnFav1_button.labelEmpty_translate,T.STRB_EMPTY);
         t(mView.btnFav2_button.labelHoldToSet_translate,T.STRB_HOLD_TO_SET_PHONE);
         t(mView.btnFav2_button.labelEmpty_translate,T.STRB_EMPTY);
         t(mView.btnFav3_button.labelHoldToSet_translate,T.STRB_HOLD_TO_SET_PHONE);
         t(mView.btnFav3_button.labelEmpty_translate,T.STRB_EMPTY);
         t(mView.btnFav4_button.labelHoldToSet_translate,T.STRB_HOLD_TO_SET_PHONE);
         t(mView.btnFav4_button.labelEmpty_translate,T.STRB_EMPTY);
         t(mView.btnFav5_button.labelHoldToSet_translate,T.STRB_HOLD_TO_SET_PHONE);
         t(mView.btnFav5_button.labelEmpty_translate,T.STRB_EMPTY);
         Peripheral.phonebook.localLangEmeregencyString = compose(T.STRB_MENU_EMERGENCY);
         Peripheral.phonebook.localLangTowAssistString = compose(T.STRB_PHONE_TOWING_ASSISTANCE);
      }
      
      private function updateFav() : void
      {
         var j:int = 0;
         var i:uint = 5;
         var state:String = this.phoneState;
         this.mFavoritesContacts = Peripheral.phonebook.favoritesList(this.mId);
         if(this.NO_PHONE_CONNECTED == state)
         {
            for(j = 0; j < 5; j++)
            {
               mView["btnFav" + (j + 1) + "_button"].labelName.visible = false;
               mView["btnFav" + (j + 1) + "_button"].labelHoldToSet_translate.visible = false;
               mView["btnFav" + (j + 1) + "_button"].labelEmpty_translate.visible = true;
               mView["btnFav" + (j + 1) + "_button"].setHighlight(false);
            }
            return;
         }
         while(--i > -1)
         {
            mView["btnFav" + (i + 1) + "_button"].labelName.visible = false;
         }
         i = 5;
         while(--i > -1)
         {
            if(mView["btnFav" + (i + 1) + "_button"].labelName.visible != true)
            {
               if((state == this.ACTIVE || this.hasHoldingCall || state == this.TWO_ACTIVE_ONE_ONHOLD || state == this.RINGING || state == this.SECOND_RINGING || state == this.DIALING || state == this.SECOND_DIALING) && state != this.TRANSFERRED || this.mTimeoutTimer.running)
               {
                  mView["btnFav" + (i + 1) + "_button"].labelName.visible = false;
                  mView["btnFav" + (i + 1) + "_button"].labelHoldToSet_translate.visible = true;
                  mView["btnFav" + (i + 1) + "_button"].labelEmpty_translate.visible = false;
                  mView["btnFav" + (i + 1) + "_button"].setHighlight(false);
               }
               else
               {
                  mView["btnFav" + (i + 1) + "_button"].labelName.visible = false;
                  mView["btnFav" + (i + 1) + "_button"].labelHoldToSet_translate.visible = false;
                  mView["btnFav" + (i + 1) + "_button"].labelEmpty_translate.visible = true;
                  mView["btnFav" + (i + 1) + "_button"].setHighlight(false);
               }
            }
            if(this.NO_PHONE_CONNECTED == state || this.DIALING == state || this.RINGING == state || this.SECOND_RINGING == state || this.SECOND_DIALING == state || this.TRANSFERRED == state)
            {
               mView["btnFav" + (i + 1) + "_button"].labelName.textColor = 10066329;
               this.setActiveWithArray([mView["btnFav" + (i + 1) + "_button"]],false,true);
            }
            else
            {
               this.setActiveWithArray([mView["btnFav" + (i + 1) + "_button"]],true,true);
            }
         }
         if(null != this.mFavoritesContacts)
         {
            i = this.mFavoritesContacts.length;
            while(--i > -1)
            {
               if(0 != this.mFavoritesContacts[i].favIndex && this.MIN_FAVORITES >= this.mFavoritesContacts[i].favIndex)
               {
                  this.updateSingleFav(this.mFavoritesContacts[i],state);
               }
            }
            if(state == this.CONFERENCE_CALL)
            {
               this.mAllActiveCalls = Peripheral.bluetoothPhone.currentCalls;
               this.highlightFavInConference(this.mAllActiveCalls);
            }
         }
      }
      
      private function updateSingleFav(contact:PhoneBookContact, pState:String) : void
      {
         var contact_name_num:String = null;
         var pattern:RegExp = null;
         var phoneNumStored:String = null;
         var currentNumCalling:String = null;
         var index:uint = contact.favIndex - 1;
         if("" == contact.otherNumber && "" == contact.homeNumber && "" == contact.mobileNumber && "" == contact.workNumber)
         {
            mView["btnFav" + (index + 1) + "_button"].labelName.visible = false;
         }
         else
         {
            mView["btnFav" + (index + 1) + "_button"].labelName.visible = true;
            mView["btnFav" + (index + 1) + "_button"].labelHoldToSet_translate.visible = false;
         }
         mView["btnFav" + (index + 1) + "_button"].labelEmpty_translate.visible = false;
         mView["btnFav" + (index + 1) + "_button"].setHighlight(false);
         if("" == contact.formattedName)
         {
            contact_name_num = contact.importantNumber();
         }
         else
         {
            contact_name_num = contact.formattedName;
         }
         Format.truncateCharacters(mView["btnFav" + (index + 1) + "_button"].labelName,contact_name_num);
         this.highlightFavs(index + 1);
         var call:BluetoothCall = Peripheral.bluetoothPhone.bluetoothHFP.getPrimaryCall();
         if(null != call && mView["btnFav" + (index + 1) + "_button"].labelName.text != null)
         {
            pattern = /-/gi;
            phoneNumStored = contact.importantNumber();
            currentNumCalling = call.number;
            if(10 != phoneNumStored.length)
            {
               phoneNumStored = phoneNumStored.replace(pattern,"");
               if(10 != phoneNumStored.length)
               {
                  phoneNumStored = phoneNumStored.slice(-10,phoneNumStored.length);
               }
            }
            if(10 != currentNumCalling.length)
            {
               currentNumCalling = currentNumCalling.replace(pattern,"");
               if(10 != currentNumCalling.length)
               {
                  currentNumCalling = currentNumCalling.slice(-10,currentNumCalling.length);
               }
            }
            if(phoneNumStored == currentNumCalling)
            {
               mView["btnFav" + (index + 1) + "_button"].setHighlight(true);
            }
         }
      }
      
      private function getPrimaryCallLabel(target:TextField, isConferenced:Boolean = false) : String
      {
         var type:String = null;
         var label:String = "";
         var primaryCall:BluetoothCall = Peripheral.bluetoothPhone.getPrimaryCall();
         if(isConferenced)
         {
            if(target != null)
            {
               t(target,T.STRB_CONFERENCE_CALL);
               this.setPrimaryPhoneIconVisibility(true,"conference");
               return "";
            }
         }
         else if(primaryCall)
         {
            if(primaryCall.callerID != null && primaryCall.callerID != "")
            {
               if(primaryCall.number == Peripheral.phonebook.emergencyNumber)
               {
                  label = compose(T.STRB_MENU_EMERGENCY);
               }
               else if(primaryCall.number == Peripheral.phonebook.towingAssistanceNumber)
               {
                  label = compose(T.STRB_PHONE_TOWING_ASSISTANCE);
               }
               else
               {
                  label = primaryCall.callerID;
               }
            }
            else
            {
               label = Format.phoneNumber(primaryCall.number);
            }
            if(primaryCall.numberType != null && primaryCall.numberType != "")
            {
               type = null;
               switch(primaryCall.numberType)
               {
                  case "homeNumber":
                     type = "home";
                     break;
                  case "mobileNumber":
                     type = "mobile";
                     break;
                  case "workNumber":
                     type = "work";
                     break;
                  default:
                     type = "circle";
               }
               this.setPrimaryPhoneIconVisibility(true,type);
            }
            else
            {
               this.setPrimaryPhoneIconVisibility(false);
            }
         }
         if(target != null)
         {
            if(label == "")
            {
               t(target,T.STRB_PHONE_PRIVATE_NUMBER_2);
            }
            else
            {
               t(target,label);
            }
         }
         return label;
      }
      
      private function getSecondaryCallLabel(target:TextField, isConferenced:Boolean = false) : String
      {
         var type:String = null;
         var label:String = "";
         var secondaryCall:BluetoothCall = Peripheral.bluetoothPhone.getSecondaryCall();
         if(isConferenced)
         {
            if(target != null)
            {
               t(target,T.STRB_CONFERENCE_CALL);
               mView.displaySecondaryPhone.type.visible = true;
               mView.displaySecondaryPhone.type.gotoAndStop("conference");
               return "";
            }
         }
         else if(secondaryCall)
         {
            if(secondaryCall.callerID != null && secondaryCall.callerID != "")
            {
               if(secondaryCall.number == Peripheral.phonebook.emergencyNumber)
               {
                  label = compose(T.STRB_MENU_EMERGENCY);
               }
               else if(secondaryCall.number == Peripheral.phonebook.towingAssistanceNumber)
               {
                  label = compose(T.STRB_PHONE_TOWING_ASSISTANCE);
               }
               else
               {
                  label = secondaryCall.callerID;
               }
            }
            else
            {
               label = Format.phoneNumber(secondaryCall.number);
            }
            if(secondaryCall.numberType != null && secondaryCall.numberType != "")
            {
               type = null;
               switch(secondaryCall.numberType)
               {
                  case "homeNumber":
                     type = "home";
                     break;
                  case "mobileNumber":
                     type = "mobile";
                     break;
                  case "workNumber":
                     type = "work";
                     break;
                  default:
                     type = "circle";
               }
               mView.displaySecondaryPhone.type.visible = true;
               mView.displaySecondaryPhone.type.gotoAndStop(type);
            }
            else
            {
               mView.displaySecondaryPhone.type.visible = false;
            }
         }
         if(target != null)
         {
            if(label == "")
            {
               t(target,T.STRB_PHONE_PRIVATE_NUMBER_2);
            }
            else
            {
               t(target,label);
            }
         }
         return label;
      }
      
      private function updateButtonBar() : void
      {
         var tempState:Boolean = false;
         var hide:Boolean = false;
         var dndStatus:Boolean = Boolean(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus);
         var replyWithTextMessage:Boolean = Boolean(Peripheral.smsMessaging.replyWithMessage);
         if(this.mPriorPhoneState == this.NO_PHONE_CONNECTED)
         {
            this.setActiveWithArray([mView.btnMessaging_button,mView.btnRecentCall_button,mView.btnPhoneBook_button,mView.btnDial_button,mView.doNotDisturb.btnDoNotDisturb_button,mView.doNotDisturb.btnReplyWithTextMessage_button,mView.btnFav1_button,mView.btnFav2_button,mView.btnFav3_button,mView.btnFav4_button,mView.btnFav5_button],false,true);
            mView.doNotDisturb.btnReplyWithTextMessage_button.checkbox.setHighlight(false);
         }
         else if(this.mPriorPhoneState == this.DIALING || this.mPriorPhoneState == this.RINGING || this.mPriorPhoneState == this.SECOND_RINGING || this.mPriorPhoneState == this.SECOND_DIALING)
         {
            this.setActiveWithArray([mView.btnMessaging_button,mView.btnRecentCall_button,mView.btnPhoneBook_button,mView.btnSettings_button,mView.btnDial_button,mView.doNotDisturb.btnDoNotDisturb_button,mView.doNotDisturb.btnReplyWithTextMessage_button,mView.btnFav1_button,mView.btnFav2_button,mView.btnFav3_button,mView.btnFav4_button,mView.btnFav5_button],false,true);
            mView.doNotDisturb.btnReplyWithTextMessage_button.checkbox.setHighlight(false);
         }
         else
         {
            if(this.mPriorPhoneState != this.TRANSFERRED)
            {
               tempState = Boolean(Peripheral.phoneCallList.recentCallsAvailable);
            }
            this.setActiveWithArray([mView.btnRecentCall_button],tempState,true);
            this.setActiveWithArray([mView.doNotDisturb.btnDoNotDisturb_button],Peripheral.phoneCallList.recentCallsAvailable,true);
            if(Boolean(Peripheral.smsMessaging.isSMSSupported) && Boolean(Peripheral.smsMessaging.isSMSReady))
            {
               this.setActiveWithArray([mView.btnMessaging_button],true,true);
               if(dndStatus && Boolean(Peripheral.smsMessaging.isSendSupported))
               {
                  this.setActiveWithArray([mView.doNotDisturb.btnReplyWithTextMessage_button],true,true);
                  mView.doNotDisturb.btnReplyWithTextMessage_button.setHighlight(replyWithTextMessage);
                  mView.doNotDisturb.btnReplyWithTextMessage_button.checkbox.setHighlight(replyWithTextMessage);
               }
               else
               {
                  this.setActiveWithArray([mView.doNotDisturb.btnReplyWithTextMessage_button],false,true);
                  mView.doNotDisturb.btnReplyWithTextMessage_button.setHighlight(false);
                  mView.doNotDisturb.btnReplyWithTextMessage_button.checkbox.setHighlight(false);
               }
            }
            else
            {
               this.setActiveWithArray([mView.btnMessaging_button,mView.doNotDisturb.btnReplyWithTextMessage_button],false,true);
               mView.doNotDisturb.btnReplyWithTextMessage_button.checkbox.setHighlight(false);
            }
            tempState = Boolean(Peripheral.phonebook.isPhoneBookReady());
            this.setActiveWithArray([mView.btnPhoneBook_button,mView.btnFav1_button,mView.btnFav2_button,mView.btnFav3_button,mView.btnFav4_button,mView.btnFav5_button],tempState,true);
            if(Peripheral.bluetooth.BT_Status == false)
            {
               this.setActiveWithArray([mView.btnSettings_button],false,true);
            }
            else
            {
               this.setActiveWithArray([mView.btnSettings_button],true,true);
            }
            mView.doNotDisturb.btnDoNotDisturb_button.setHighlight(dndStatus);
            switch(this.mPriorPhoneState)
            {
               case this.ACTIVE:
               case this.IDLE:
               case this.CONFERENCE_CALL:
               case this.CONFERENCE_CALL_ONHOLD:
               case this.TWO_ACTIVE_ONE_ONHOLD:
                  this.setActiveWithArray([mView.btnDial_button],true,true);
                  break;
               default:
                  this.setActiveWithArray([mView.btnDial_button],false,true);
            }
         }
      }
      
      private function updateDisplayCallStatus(statusOne:String, statusTwo:String) : void
      {
         mView.displaySecondaryPhone.type.visible = false;
         var type:String = "";
         switch(statusOne)
         {
            case "onHold":
            case "incoming":
               mView.btnMute_button.setEnabled(true);
               mView.btnMute_button.setHighlight(false);
               Peripheral.audioMixerManager.sendPhoneMute(false);
            case "outgoing":
            case "end":
               mView.displayPrimaryPhone.displayCallStatus.gotoAndStop(statusOne);
               mView.displayPrimaryPhone.displayCallStatus.visible = true;
               mView.displayPrimaryPhone.visible = true;
               this.setPrimaryPhoneIconVisibility(true);
               break;
            case "active":
               if(null != Peripheral.bluetoothPhone.getActiveCall().number)
               {
                  mView.displayPrimaryPhone.displayCallStatus.gotoAndStop(statusOne);
                  mView.displayPrimaryPhone.displayCallStatus.visible = true;
                  mView.displayPrimaryPhone.visible = true;
                  switch(Peripheral.bluetoothPhone.getPrimaryCall().numberType)
                  {
                     case "homeNumber":
                        type = "home";
                        break;
                     case "mobileNumber":
                        type = "mobile";
                        break;
                     case "workNumber":
                        type = "work";
                        break;
                     default:
                        type = "circle";
                  }
                  this.setPrimaryPhoneIconVisibility(true,type);
               }
               break;
            case "conference":
               mView.displayPrimaryPhone.displayCallStatus.gotoAndStop("active");
               mView.displayPrimaryPhone.displayCallStatus.visible = true;
               mView.displayPrimaryPhone.visible = true;
               break;
            default:
               mView.displayPrimaryPhone.visible = true;
               mView.displayPrimaryPhone.displayCallStatus.visible = false;
               this.setPrimaryPhoneIconVisibility(false);
         }
         switch(statusTwo)
         {
            case "end":
            case "onHold":
            case "active":
            case "incoming":
            case "outgoing":
               mView.displaySecondaryPhone.displayCallStatus.gotoAndStop(statusTwo);
               mView.displaySecondaryPhone.displayCallStatus.visible = true;
               mView.doNotDisturb.visible = false;
               mView.displaySecondaryPhone.visible = true;
               break;
            default:
               mView.doNotDisturb.visible = true;
               mView.displaySecondaryPhone.visible = false;
               mView.displaySecondaryPhone.displayCallStatus.visible = false;
         }
      }
      
      private function setScreenState() : void
      {
         var btnSwap_button_enabled:Boolean = false;
         var btnConfCall_button_enabled:Boolean = false;
         var state:String = this.phoneState;
         var i:uint = 5;
         var tempDbState:Boolean = false;
         var holdFeatureAvailable:Boolean = false;
         var tempLabel:String = "";
         this.displayCallTime();
         if(this.mPriorPhoneState == state)
         {
         }
         this.mPriorPhoneState = state;
         Framework.Trace("state: " + state + " HandsFreeMode: " + Peripheral.bluetoothPhone.bluetoothHFP.handsFreeMode);
         mView.btnSwap_button.visible = state == this.TWO_ACTIVE_ONE_ONHOLD;
         mView.btnEnd_button.visible = state == this.DIALING || state == this.ACTIVE || state == this.TRANSFERRED || state == this.IDLE || state == this.CONFERENCE_CALL || this.hasHoldingCall || state == this.NO_PHONE_CONNECTED || state == this.TWO_ACTIVE_ONE_ONHOLD || state == this.SECOND_DIALING;
         mView.btnIgnore_button.visible = state == this.RINGING || state == this.SECOND_RINGING;
         mView.btnAnswer_button.visible = state == this.RINGING || state == this.SECOND_RINGING;
         mView.btnHold_button.visible = state == this.DIALING || state == this.SECOND_DIALING || state == this.ACTIVE || this.hasHoldingCall && state != this.TWO_ACTIVE_ONE_ONHOLD && state != this.TRANSFERRED || state == this.CONFERENCE_CALL;
         mView.btnRedial_button.visible = !(Boolean(mView.btnAnswer_button.visible) || Boolean(mView.btnHold_button.visible) || Boolean(mView.btnSwap_button.visible));
         mView.btnConfCall_button.visible = state == this.DIALING || state == this.SECOND_DIALING || state == this.ACTIVE || state == this.RINGING || state == this.SECOND_RINGING || state == this.IDLE || state == this.CONFERENCE_CALL || state == this.TRANSFERRED || this.hasHoldingCall || state == this.NO_PHONE_CONNECTED || state == this.TWO_ACTIVE_ONE_ONHOLD;
         mView.btnMute_button.mouseEnabled = true;
         this.updateFav();
         this.onSupportedFeaturesList(null);
         if(state == this.TRANSFERRED)
         {
            mView.btnTransferBack_button.visible = true;
            mView.btnTransfer_button.visible = false;
         }
         else
         {
            mView.btnTransferBack_button.visible = false;
            mView.btnTransfer_button.visible = true;
         }
         mView.displayPrimaryPhone.labelVR.visible = state != this.NO_PHONE_CONNECTED;
         mView.displayPrimaryPhone.displayBatteryStatus.visible = state != this.NO_PHONE_CONNECTED;
         mView.displayPrimaryPhone.displaySignalStrength.visible = state != this.NO_PHONE_CONNECTED;
         if(state != this.NO_PHONE_CONNECTED)
         {
            t(mView.displayPrimaryPhone.labelPhoneName,Peripheral.bluetooth.currentHFPDevice.DevName);
            this.updateBatteryCharge(Peripheral.bluetoothPhone.bluetoothHFP.batteryCharge);
            this.updateSignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
         }
         if(this.IDLE != state)
         {
            mView.displayPrimaryPhone.missedCalls.visible = false;
            mView.displayPrimaryPhone.missedTexts.visible = false;
         }
         if(state == this.IDLE)
         {
            this.setActiveWithArray([mView.btnRedial_button],true,true);
         }
         else if(this.mTimeoutTimer.running || state == this.NO_PHONE_CONNECTED)
         {
            t(mView.displayPrimaryPhone.labelCallTime,"");
            t(mView.displayPrimaryPhone.labelPhoneName,"");
            this.updateDisplayCallStatus("","");
            this.mLastDisplayTime = "00:00:00";
            this.mHasEndCall = false;
            this.cancelTimeout();
         }
         this.updateButtonBar();
         switch(state)
         {
            case this.IDLE:
               if(this.mHasEndCall && !this.mTimeoutTimer.running)
               {
                  this.mHasEndCall = false;
                  this.updateDisplayCallStatus("end","");
                  this.mbContactIDDisplay = true;
                  t(mView.displayPrimaryPhone.labelCallTime,[T.STRB_CALL_ENDED,this.mLastDisplayTime]);
                  Peripheral.bluetoothPhone.phoneHomeScreenStatus(true,compose([T.STRB_CALL_ENDED,this.mLastDisplayTime]));
                  this.setTimeout(this.CALL_ENDED_DISPLAY_TIME);
                  this.updateFav();
               }
               else if(!this.mTimeoutTimer.running)
               {
                  t(mView.displayPrimaryPhone.labelCallTime,"");
                  this.updateDisplayCallStatus("","");
                  this.mLastDisplayTime = "00:00:00";
               }
               t(mView.displayPrimaryPhone.labelAction,"");
               if(!this.mbContactIDDisplay)
               {
                  if(Boolean(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus) && (Boolean(Peripheral.phoneCallList.blockedCallCount) || Boolean(Peripheral.smsMessaging.blockedSMSCount)))
                  {
                     t(mView.displayPrimaryPhone.labelStatus,"");
                     if(Peripheral.phoneCallList.blockedCallCount)
                     {
                        mView.displayPrimaryPhone.missedCalls.visible = true;
                        t(mView.displayPrimaryPhone.missedCalls,[T.STRB_MISSED_CALLS_ARG,String(Peripheral.phoneCallList.blockedCallCount)]);
                     }
                     if(Peripheral.smsMessaging.blockedSMSCount)
                     {
                        mView.displayPrimaryPhone.missedTexts.visible = true;
                        t(mView.displayPrimaryPhone.missedTexts,[T.STRB_MISSED_TEXT_MESS_ARG,String(Peripheral.smsMessaging.blockedSMSCount)]);
                     }
                     else
                     {
                        mView.displayPrimaryPhone.missedTexts.visible = false;
                     }
                  }
                  else
                  {
                     mView.displayPrimaryPhone.missedCalls.visible = false;
                     mView.displayPrimaryPhone.missedTexts.visible = false;
                     t(mView.displayPrimaryPhone.labelStatus,T.STRB_PHONE_READY);
                  }
               }
               this.onPhonebookSyncStatus(null);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button,mView.btnConfCall_button],false,true);
               this.mCallType1 = "";
               this.mCallType2 = "";
               this.mCallTypeNumber1 = "";
               this.mCallTypeNumber2 = "";
               this.setPrimaryPhoneIconVisibility(false);
               mView.displaySecondaryPhone.type.visible = false;
               break;
            case this.TRANSFERRED:
               t(mView.displayPrimaryPhone.labelCallTime,T.STRB_TRANSFERRED_TO_PHONE);
               this.updateDisplayCallStatus("","");
               t(mView.displayPrimaryPhone.labelAction,"");
               t(mView.displayPrimaryPhone.labelStatus,T.STRB_AUDIO_TRANSFERRED);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnConfCall_button,mView.btnRedial_button,mView.btnHold_button],false,true);
               this.setActiveWithArray([mView.btnTransferBack_button],true,true);
               this.setPrimaryPhoneIconVisibility(false);
               mView.displaySecondaryPhone.type.visible = false;
               break;
            case this.ACTIVE:
               this.setActiveWithArray([mView.btnConfCall_button],false,true);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button],true,true);
               holdFeatureAvailable = Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_SWAP") != -1;
               this.setActiveWithArray([mView.btnHold_button],holdFeatureAvailable,true);
               t(mView.displayPrimaryPhone.labelAction,"");
               if(this.hasHoldingCall && !this.hasActiveCall)
               {
                  if(this.mCallTypeNumber2 == Peripheral.bluetoothPhone.getHoldingCall().number)
                  {
                     this.mCallType1 = this.mCallType2;
                     this.mCallTypeNumber1 = this.mCallTypeNumber2;
                     this.mCallType2 = "";
                     this.mCallTypeNumber2 = "";
                  }
                  else
                  {
                     this.mCallType2 = "";
                     this.mCallTypeNumber2 = "";
                  }
                  mView.btnHold_button.setHighlight(true);
                  mView.btnHold_button.mouseEnabled = true;
                  this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
                  this.updateDisplayCallStatus("onHold","");
                  t(mView.displayPrimaryPhone.labelAction,T.STRB_CALL_HELD_NO_NUMBER);
               }
               else
               {
                  if(this.mCallTypeNumber2 == Peripheral.bluetoothPhone.getActiveCall().number)
                  {
                     this.mCallType1 = this.mCallType2;
                     this.mCallTypeNumber1 = this.mCallTypeNumber2;
                     this.mCallType2 = "";
                     this.mCallTypeNumber2 = "";
                  }
                  else
                  {
                     this.mCallType2 = "";
                     this.mCallTypeNumber2 = "";
                  }
                  mView.btnHold_button.setHighlight(false);
                  mView.btnHold_button.mouseEnabled = true;
                  this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
                  this.updateDisplayCallStatus("active","");
               }
               break;
            case this.SECOND_DIALING:
               this.setActiveWithArray([mView.btnHold_button,mView.btnMute_button,mView.btnTransferBack_button,mView.btnConfCall_button],false,true);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnTransfer_button],true,true);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
               t(mView.displayPrimaryPhone.labelAction,T.STRB_CALLING);
               this.mCallTypeNumber2 = Peripheral.bluetoothPhone.getDialingCall().number;
               this.mCallType2 = "outgoing";
               this.updateDisplayCallStatus("outgoing","onHold");
               this.mLastDisplayTime = "00:00:00";
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber,this.mIsConferenced || this.mIsHeldConferenced);
               mView.btnHold_button.setHighlight(false);
               mView.btnHold_button.mouseEnabled = false;
               break;
            case this.DIALING:
               this.setActiveWithArray([mView.btnHold_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button,mView.btnConfCall_button],false,true);
               this.setActiveWithArray([mView.btnEnd_button],true,true);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
               t(mView.displayPrimaryPhone.labelCallTime,"");
               t(mView.displayPrimaryPhone.labelAction,T.STRB_CALLING);
               this.mCallTypeNumber1 = Peripheral.bluetoothPhone.getDialingCall().number;
               this.mCallType1 = "outgoing";
               this.updateDisplayCallStatus("outgoing","");
               this.mLastDisplayTime = "00:00:00";
               mView.btnHold_button.setHighlight(false);
               mView.btnHold_button.mouseEnabled = true;
               break;
            case this.RINGING:
               this.setActiveWithArray([mView.btnMute_button,mView.btnConfCall_button,mView.btnRecentCall_button],false,true);
               this.setActiveWithArray([mView.btnAnswer_button,mView.btnIgnore_button,mView.btnTransfer_button,mView.btnTransferBack_button],true,true);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
               t(mView.displayPrimaryPhone.labelCallTime,"");
               t(mView.displayPrimaryPhone.labelAction,T.STRB_INCOMING_CALL);
               this.mCallTypeNumber1 = Peripheral.bluetoothPhone.getRingingCall().number;
               this.mCallType1 = "incoming";
               this.updateDisplayCallStatus("incoming","");
               break;
            case this.SECOND_RINGING:
               mView.btnAnswer_button.visible = true;
               mView.btnIgnore_button.visible = true;
               mView.btnHold_button.visible = false;
               mView.btnEnd_button.visible = false;
               t(mView.displaySecondaryPhone.labelActivity,T.STRB_INCOMING_CALL);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus,this.mIsConferenced || this.mIsHeldConferenced);
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber);
               this.mCallTypeNumber2 = Peripheral.bluetoothPhone.getSecondaryCall().number;
               this.mCallType2 = "incoming";
               if("active" == Peripheral.bluetoothPhone.getPrimaryCall().callState)
               {
                  this.updateDisplayCallStatus("active","incoming");
               }
               if("onhold" == Peripheral.bluetoothPhone.getPrimaryCall().callState)
               {
                  this.updateDisplayCallStatus("onHold","incoming");
               }
               this.setActiveWithArray([mView.btnAnswer_button,mView.btnIgnore_button,mView.btnTransfer_button,mView.btnTransferBack_button],true,true);
               this.setActiveWithArray([mView.btnMute_button,mView.btnConfCall_button],false,true);
               break;
            case this.TWO_ACTIVE_ONE_ONHOLD:
               if(this.mIsConferenced)
               {
                  this.mAllActiveCalls = Peripheral.bluetoothPhone.currentCalls;
                  this.highlightFavInConference(this.mAllActiveCalls);
               }
               mView.btnSwap_button.visible = true;
               mView.btnEnd_button.visible = true;
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus,this.mIsConferenced);
               t(mView.displayPrimaryPhone.labelAction,"");
               this.updateDisplayCallStatus("active","onHold");
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber,this.mIsHeldConferenced);
               this.setActiveWithArray([mView.btnSwap_button,mView.btnEnd_button,mView.btnTransfer_button,mView.btnTransferBack_button],true,true);
               mView.btnRedial_button.visible = false;
               btnSwap_button_enabled = Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_SWAP") != -1;
               Framework.Trace("btnSwap_button_enabled: " + btnSwap_button_enabled);
               this.setActiveWithArray([mView.btnSwap_button],btnSwap_button_enabled,true);
               btnConfCall_button_enabled = Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_CONFERENCE") != -1;
               Framework.Trace("btnConfCall_button_enabled: " + btnConfCall_button_enabled);
               this.setActiveWithArray([mView.btnConfCall_button],btnConfCall_button_enabled,true);
               this.setActiveWithArray([mView.btnMute_button],true,true);
               break;
            case this.CONFERENCE_CALL:
               this.mAllActiveCalls = Peripheral.bluetoothPhone.currentCalls;
               this.highlightFavInConference(this.mAllActiveCalls);
               this.setActiveWithArray([mView.btnConfCall_button],false,true);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button],true,true);
               holdFeatureAvailable = Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_SWAP") != -1;
               this.setActiveWithArray([mView.btnHold_button],holdFeatureAvailable,true);
               mView.btnHold_button.setHighlight(false);
               mView.btnHold_button.mouseEnabled = holdFeatureAvailable;
               t(mView.displayPrimaryPhone.labelAction,"");
               this.setPrimaryPhoneIconVisibility(true,"conference");
               t(mView.displayPrimaryPhone.labelStatus,T.STRB_CONFERENCE_CALL);
               this.updateDisplayCallStatus("conference","");
               break;
            case this.CONFERENCE_CALL_ONHOLD:
               this.highlightFavInConference(this.mAllActiveCalls);
               this.setActiveWithArray([mView.btnConfCall_button],false,true);
               this.setActiveWithArray([mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnHold_button],true,true);
               t(mView.displayPrimaryPhone.labelStatus,T.STRB_CONFERENCE_CALL);
               this.updateDisplayCallStatus("onHold","");
               t(mView.displayPrimaryPhone.labelAction,T.STRB_CALL_HELD_NO_NUMBER);
               mView.btnHold_button.setHighlight(true);
               mView.btnHold_button.mouseEnabled = true;
               this.setPrimaryPhoneIconVisibility(true,"conference");
               break;
            case this.NO_PHONE_CONNECTED:
               mView.btnTransferBack_button.visible = false;
               mView.btnTransfer_button.visible = true;
               mView.displayPrimaryPhone.labelRoaming.visible = false;
               this.setPrimaryPhoneIconVisibility(false);
               this.updateDisplayCallStatus("","");
               mView.displayPrimaryPhone.labelPhoneName.text = "";
               t(mView.displayPrimaryPhone.labelCallTime,"");
               if(Peripheral.bluetooth.BT_Status == false)
               {
                  t(mView.displayPrimaryPhone.labelAction,T.STRB_HF_SYSTEM_LOADING);
                  t(mView.displayPrimaryPhone.labelStatus,T.STRB_ERROR_BODY_PLEASE_WAIT);
               }
               else
               {
                  t(mView.displayPrimaryPhone.labelAction,T.STRB_GOTO_SETTINGS);
                  t(mView.displayPrimaryPhone.labelStatus,T.STRB_NO_PHONE);
               }
               this.setActiveWithArray([mView.btnRedial_button,mView.btnEnd_button,mView.btnMute_button,mView.btnTransfer_button,mView.btnTransferBack_button,mView.btnConfCall_button,mView.btnMessaging_button,mView.btnRecentCall_button,mView.btnPhoneBook_button,mView.doNotDisturb.btnDoNotDisturb_button,mView.doNotDisturb.btnReplyWithTextMessage_button,mView.btnFav1_button,mView.btnFav2_button,mView.btnFav3_button,mView.btnFav4_button,mView.btnFav5_button],false,true);
               break;
            case this.NO_PHONES_PAIRED:
         }
         mView.btnMute_button.setHighlight(Peripheral.audioSettings.SHFMicMute);
         Framework.focusManager.refresh();
      }
      
      private function get phoneState() : String
      {
         var i:uint = 0;
         var ii:int = 0;
         var stateToReturn:String = null;
         var calls:Vector.<BluetoothCall> = Peripheral.bluetoothPhone.currentCalls;
         var activeCall:Boolean = false;
         var onHoldCall:Boolean = false;
         var incomingCall:Boolean = false;
         var dialingCall:Boolean = false;
         var waitingCall:Boolean = false;
         var conferenceCall:Boolean = false;
         var idleCall:Boolean = true;
         var hasAudio:Boolean = false;
         var numCalls:int = 0;
         var numConnected:int = 0;
         var btDeviceList:Vector.<BluetoothDevice> = Peripheral.bluetooth.getPairedDeviceListWithService("HFP");
         numConnected = 0;
         this.mIsConferenced = false;
         this.mIsHeldConferenced = false;
         if(btDeviceList.length > 0)
         {
            for(i = 0; i < btDeviceList.length; i++)
            {
               if(btDeviceList[i].HfpConnected == true)
               {
                  numConnected++;
               }
            }
         }
         if(numConnected == 0)
         {
            Peripheral.bluetooth.noPhoneConnectedScenario("PhoneMainScreen.as: No Phone connected scenario in get phoneState");
            stateToReturn = this.NO_PHONE_CONNECTED;
            this.mCallAmount = 0;
         }
         else
         {
            stateToReturn = this.IDLE;
            for(ii = 0; ii < calls.length; ii++)
            {
               if(calls[ii].callState != BluetoothCall.mCallStateIdle)
               {
                  idleCall = false;
                  if(calls[ii].audio == true)
                  {
                     hasAudio = true;
                  }
                  if(BluetoothCall.mCallStateActive == calls[ii].callState)
                  {
                     if(activeCall == true)
                     {
                        this.mIsConferenced = true;
                        conferenceCall = true;
                     }
                     activeCall = true;
                     numCalls++;
                  }
                  else if(BluetoothCall.mCallStateRinging == calls[ii].callState)
                  {
                     incomingCall = true;
                     numCalls++;
                  }
                  else if(BluetoothCall.mCallStateDialing == calls[ii].callState)
                  {
                     dialingCall = true;
                     numCalls++;
                  }
                  else if(BluetoothCall.mCallStateAlerting == calls[ii].callState)
                  {
                     dialingCall = true;
                     numCalls++;
                  }
                  else if(BluetoothCall.mCallStateOnHold == calls[ii].callState)
                  {
                     if(onHoldCall == true)
                     {
                        this.mIsHeldConferenced = true;
                        conferenceCall = true;
                     }
                     onHoldCall = true;
                     numCalls++;
                  }
                  else if(BluetoothCall.mCallStateWaiting == calls[ii].callState)
                  {
                     waitingCall = true;
                     numCalls++;
                  }
               }
            }
            if(waitingCall == false)
            {
               this.mHasIgnoredCall = false;
            }
            if(idleCall == true)
            {
               if(this.mCallAmount > numCalls)
               {
                  this.mHasEndCall = true;
               }
               this.mCallAmount = numCalls;
            }
            else
            {
               this.mCallAmount = numCalls;
               if(dialingCall)
               {
                  if(numCalls > 1)
                  {
                     stateToReturn = this.SECOND_DIALING;
                  }
                  else
                  {
                     stateToReturn = this.DIALING;
                  }
               }
               else if(waitingCall && this.mHasIgnoredCall == false)
               {
                  if(numCalls > 1)
                  {
                     stateToReturn = this.SECOND_RINGING;
                  }
                  else
                  {
                     stateToReturn = this.RINGING;
                  }
               }
               else if(incomingCall)
               {
                  stateToReturn = this.RINGING;
               }
               else if(activeCall)
               {
                  this.mWasMutedOnActive = this.mHasSHFMutedState;
                  if(onHoldCall)
                  {
                     stateToReturn = this.TWO_ACTIVE_ONE_ONHOLD;
                  }
                  else if(conferenceCall)
                  {
                     stateToReturn = this.CONFERENCE_CALL;
                     this.mlastCallState = this.CONFERENCE_CALL;
                  }
                  else
                  {
                     stateToReturn = this.ACTIVE;
                  }
               }
               else if(onHoldCall)
               {
                  this.mWasMutedOnActive = this.mHasSHFMutedState;
                  if(conferenceCall)
                  {
                     stateToReturn = this.CONFERENCE_CALL_ONHOLD;
                  }
                  else
                  {
                     stateToReturn = this.ACTIVE;
                  }
               }
            }
         }
         if(hasAudio == false)
         {
            switch(stateToReturn)
            {
               case this.IDLE:
               case this.NO_PHONE_CONNECTED:
               case this.DIALING:
               case this.RINGING:
                  break;
               case this.CONFERENCE_CALL:
               case this.CONFERENCE_CALL_ONHOLD:
               case this.SECOND_RINGING:
               case this.SECOND_DIALING:
               case this.ACTIVE:
               case this.TWO_ACTIVE_ONE_ONHOLD:
                  stateToReturn = this.TRANSFERRED;
            }
         }
         Framework.Trace("PhoneState =  " + stateToReturn);
         return stateToReturn;
      }
      
      private function phoneFavUpdated(evt:PhoneBookEvent) : void
      {
         Peripheral.phonebook.requestFavoritesCount();
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
      }
      
      private function phoneFavAvailable(evt:PhoneBookEvent) : void
      {
         this.mFavoritesContacts = Peripheral.phonebook.favoritesList(this.mId);
         this.updateFav();
      }
      
      private function onCallerID(evt:BluetoothEvent) : void
      {
         Framework.Trace("\n phoneCallerID() Received");
         var state:String = this.phoneState;
         switch(state)
         {
            case this.SECOND_RINGING:
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus,this.mIsConferenced || this.mIsHeldConferenced);
               break;
            case this.SECOND_DIALING:
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber,this.mIsHeldConferenced || this.mIsConferenced);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
               break;
            case this.TWO_ACTIVE_ONE_ONHOLD:
               this.getSecondaryCallLabel(mView.displaySecondaryPhone.labelNumber,this.mIsHeldConferenced);
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus,this.mIsConferenced);
               break;
            case this.ACTIVE:
            case this.DIALING:
            case this.RINGING:
               this.getPrimaryCallLabel(mView.displayPrimaryPhone.labelStatus);
         }
      }
      
      private function onSupportedFeaturesList(evt:BluetoothEvent) : void
      {
         Framework.Trace("\n PhoneMainScreen::onSupportedFeaturesList() Received");
         if(Peripheral.bluetoothPhone.bluetoothHFP.isSiriFeatureSupported)
         {
            t(view.displayPrimaryPhone.labelVR,"Siri");
         }
         else
         {
            t(view.displayPrimaryPhone.labelVR,"");
         }
      }
      
      private function onBTStatus(evt:BluetoothEvent) : void
      {
         this.setScreenState();
      }
      
      private function get hasHoldingCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getHoldingCall() != null;
      }
      
      private function get hasActiveCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getActiveCall() != null;
      }
      
      private function get hasRingingCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getRingingCall() != null;
      }
      
      private function get hasDialingCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getDialingCall() != null;
      }
      
      private function get hasAlertingCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getAlertingCall() != null;
      }
      
      private function get hasWaitingCall() : Boolean
      {
         return Peripheral.bluetoothPhone.getWaitingCall() != null;
      }
      
      protected function setActiveWithArray(arr:Array, isActive:Boolean, isClickEnabled:Boolean = true) : void
      {
         var i:String = null;
         for(i in arr)
         {
            arr[i].setEnabled(isActive);
            arr[i].enabled = isActive;
            arr[i].mouseEnabled = isClickEnabled;
         }
      }
      
      private function callFavourite(favId:uint) : void
      {
         var favObj:Object = null;
         favObj = this.getFavInfo(favId);
         if(favObj.number != "")
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
            Peripheral.bluetoothPhone.bluetoothHFP.dial(favObj.number,favObj.name,favObj.numberType);
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            if(this.IDLE == this.phoneState && !this.mTimeoutTimer.running)
            {
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "timeout":3000,
                  "status":"favorite popup"
               });
            }
         }
      }
      
      private function getFavInfo(favId:uint) : Object
      {
         var index:uint = 0;
         var number:String = "";
         var obj:Object = new Object();
         if(null != this.mFavoritesContacts)
         {
            index = this.mFavoritesContacts.length;
            while(--index > -1)
            {
               if(this.mFavoritesContacts[index].favIndex == favId)
               {
                  if(this.mFavoritesContacts[index].homeNumber != "")
                  {
                     obj.numberType = "homeNumber";
                     obj.number = this.mFavoritesContacts[index].homeNumber;
                  }
                  else if(this.mFavoritesContacts[index].mobileNumber != "")
                  {
                     obj.numberType = "mobileNumber";
                     obj.number = this.mFavoritesContacts[index].mobileNumber;
                  }
                  else if(this.mFavoritesContacts[index].otherNumber != "")
                  {
                     obj.numberType = "otherNumber";
                     obj.number = this.mFavoritesContacts[index].otherNumber;
                  }
                  else if(this.mFavoritesContacts[index].workNumber != "")
                  {
                     obj.numberType = "workNumber";
                     obj.number = this.mFavoritesContacts[index].workNumber;
                  }
                  obj.name = this.mFavoritesContacts[index].formattedName;
               }
            }
         }
         if(!obj.number)
         {
            obj.number = "";
         }
         return obj;
      }
      
      private function storeFavourite(favId:uint) : void
      {
         var contactId:int = 0;
         if(!this.mFavoritesContacts)
         {
            return;
         }
         var flag:Boolean = false;
         var length:int = int(this.mFavoritesContacts.length);
         while(length)
         {
            if(this.mFavoritesContacts[--length].favIndex == favId)
            {
               contactId = int(this.mFavoritesContacts[length].id);
               flag = true;
            }
         }
         var callNumber:String = "";
         var data:PhoneBookContact = new PhoneBookContact(null,favId);
         var contact_name:String = "";
         var callData:BluetoothCall = null;
         if(Peripheral.bluetoothPhone.getPrimaryCall() != null)
         {
            callData = Peripheral.bluetoothPhone.getPrimaryCall();
         }
         else if(Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData() != null)
         {
            callData = Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData();
         }
         if(callData != null)
         {
            callNumber = callData.number;
            if("" == callNumber)
            {
               return;
            }
            mView["btnFav" + favId + "_button"].labelEmpty_translate.visible = false;
            mView["btnFav" + favId + "_button"].labelHoldToSet_translate.visible = false;
            mView["btnFav" + favId + "_button"].labelName.visible = true;
            if(callData.callerID != null && callData.callerID != "")
            {
               contact_name = callData.callerID;
               switch(callData.numberType)
               {
                  case "homeNumber":
                     data.homeNumber = callNumber;
                     break;
                  case "mobileNumber":
                     data.mobileNumber = callNumber;
                     break;
                  case "workNumber":
                     data.workNumber = callNumber;
                     break;
                  default:
                     data.otherNumber = callNumber;
               }
               data.formattedName = callData.callerID;
            }
            else
            {
               contact_name = callNumber;
               data.otherNumber = Format.phoneNumber(callNumber);
            }
            if(this.CONTACT_LENGTH < contact_name.length)
            {
               contact_name = contact_name.substr(0,10) + "...";
            }
            mView["btnFav" + favId + "_button"].labelName.text = contact_name;
            data.favIndex = favId;
            if(null == data)
            {
               return;
            }
            if(!flag)
            {
               if(1 <= data.favIndex && 5 >= data.favIndex)
               {
                  Peripheral.bluetoothPhone.phoneBook.addFavorite(data);
               }
            }
            else
            {
               data.id = contactId;
               if(1 <= data.favIndex && 5 >= data.favIndex)
               {
                  Peripheral.bluetoothPhone.phoneBook.replaceFavorite(data);
               }
            }
         }
      }
      
      private function highlightFavs(favId:uint) : void
      {
         var obj:Object = null;
         var i:uint = 5;
         obj = this.getFavInfo(favId);
      }
      
      private function onEndCall(evt:BluetoothEvent) : void
      {
         if(this.hasHoldingCall)
         {
            Peripheral.bluetoothPhone.resumeHeldCall();
         }
         this.setScreenState();
      }
      
      private function onResumeCall(evt:BluetoothEvent) : void
      {
         this.setScreenState();
      }
      
      private function onCallStateChange(evt:BluetoothEvent) : void
      {
         var pState:String = this.phoneState;
         if(this.IDLE == pState || this.DIALING == pState || this.RINGING == pState || this.SECOND_DIALING == pState)
         {
            Peripheral.audioSettings.setSHFMicMute(false);
         }
         else if(this.SECOND_RINGING == pState)
         {
            Peripheral.audioSettings.setSHFMicMute(this.mWasMutedOnActive);
         }
         this.setScreenState();
      }
      
      private function onHFMicState(evt:AudioEvent) : void
      {
         if(true == Peripheral.audioSettings.SHFMicMute)
         {
            this.mHasSHFMutedState = true;
            mView.btnMute_button.setHighlight(this.mHasSHFMutedState);
         }
         else if(this.SECOND_RINGING == this.mPriorPhoneState && this.mWasMutedOnActive == true)
         {
            Peripheral.audioSettings.setSHFMicMute(true);
            this.mHasSHFMutedState = true;
            mView.btnMute_button.setHighlight(true);
            this.mWasMutedOnActive = false;
         }
         else
         {
            this.mHasSHFMutedState = false;
            mView.btnMute_button.setHighlight(this.mHasSHFMutedState);
         }
      }
      
      private function onHandsFreeModeStatus(evt:BluetoothEvent) : void
      {
         this.setScreenState();
      }
      
      private function onAudioStatus(evt:BluetoothEvent) : void
      {
         this.setScreenState();
      }
      
      private function onBatteryCharge(evt:BluetoothEvent) : void
      {
         this.updateBatteryCharge(Peripheral.bluetoothPhone.bluetoothHFP.batteryCharge);
      }
      
      private function updateBatteryCharge(batteryCharge:int) : void
      {
         switch(batteryCharge)
         {
            case -1:
            case 0:
            case 1:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("low");
               break;
            case 2:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("one");
               break;
            case 3:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("two");
               break;
            case 4:
            case 5:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("three");
         }
      }
      
      private function onSignalQuality(evt:BluetoothEvent) : void
      {
         this.updateSignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
      }
      
      private function updateSignalQuality(signalQuality:int) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_HOME" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_ROAMING" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_UNKNOWN")
         {
            signalQuality = 0;
         }
         if(signalQuality == 0)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("low");
         }
         else if(signalQuality > 0 && signalQuality <= 5)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("one");
         }
         else if(signalQuality > 5 && signalQuality <= 9)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("two");
         }
         else if(signalQuality > 9 && signalQuality <= 16)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("three");
         }
         else if(signalQuality > 16 && signalQuality <= 21)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("four");
         }
         else if(signalQuality > 21)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("five");
         }
         else
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("low");
         }
      }
      
      private function onDeviceChange(evt:BluetoothEvent) : void
      {
         this.setScreenState();
      }
      
      private function onOffHookTimer(evt:BluetoothEvent) : void
      {
         this.displayCallTime();
      }
      
      private function onOffHookTimerSecondary(evt:BluetoothEvent) : void
      {
         this.displayCallTime();
      }
      
      private function convertCallTime(callTime:int) : String
      {
         var displayTime:String = null;
         var displayHr:String = "00";
         var displayMin:String = "00";
         var displaySec:String = "00";
         var hr:int = 0;
         var min:int = 0;
         var sec:int = 0;
         if(callTime >= 3600)
         {
            hr = callTime / 3600;
            if(hr < 10)
            {
               displayHr = "0" + hr;
            }
            else
            {
               displayHr = String(hr);
            }
         }
         callTime %= 3600;
         if(callTime >= 60)
         {
            min = callTime / 60;
            if(min < 10)
            {
               displayMin = "0" + min;
            }
            else
            {
               displayMin = String(min);
            }
         }
         sec = callTime % 60;
         if(sec < 10)
         {
            displaySec = "0" + sec;
         }
         else
         {
            displaySec = String(sec);
         }
         return displayHr + ":" + displayMin + ":" + displaySec;
      }
      
      private function displayCallTime() : void
      {
         var displayTime:String = null;
         var callTime:int = 0;
         var pState:String = this.phoneState;
         var call:BluetoothCall = null;
         call = Peripheral.bluetoothPhone.getPrimaryCall();
         if(call != null)
         {
            if(this.hasActiveCall || call.callState == BluetoothCall.mCallStateOnHold)
            {
               Framework.Trace("Primary call " + call.callerID + " " + call.callState);
               callTime = int(Peripheral.bluetoothPhone.getPrimaryCallDuration());
               displayTime = this.convertCallTime(callTime);
               if(pState != this.TRANSFERRED)
               {
                  t(mView.displayPrimaryPhone.labelCallTime,[T.STRB_CALL_TIME,displayTime]);
               }
               this.mLastDisplayTime = displayTime;
            }
         }
         if(this.hasRingingCall && Peripheral.bluetoothPhone.currentCalls.length == 1)
         {
            this.mLastDisplayTime = "00:00:00";
         }
         if(this.hasHoldingCall && Peripheral.bluetoothPhone.getSecondaryCall() != null)
         {
            if(!this.hasWaitingCall)
            {
               if(this.hasActiveCall || this.hasDialingCall)
               {
                  callTime = int(Peripheral.bluetoothPhone.getSecondaryCallDuration());
                  displayTime = this.convertCallTime(callTime);
                  if(pState != this.TRANSFERRED)
                  {
                     t(mView.displaySecondaryPhone.labelActivity,T.STRB_CALL_HELD_NO_NUMBER);
                  }
               }
               else
               {
                  callTime = int(Peripheral.bluetoothPhone.getSecondaryCallDuration());
                  displayTime = this.convertCallTime(callTime);
                  if(pState != this.TRANSFERRED)
                  {
                     t(mView.displayPrimaryPhone.labelCallTime,[T.STRB_CALL_TIME,displayTime]);
                  }
               }
            }
         }
         else if(!this.hasWaitingCall)
         {
            t(mView.displaySecondaryPhone.labelActivity,"");
         }
      }
      
      private function onNetworkRegistrationState(evt:BluetoothEvent) : void
      {
         if(evt.data == "PHONE_REGSTATE_ROAMING")
         {
            mView.displayPrimaryPhone.labelRoaming.visible = true;
            t(mView.displayPrimaryPhone.labelRoaming,T.STRB_ROAMING);
         }
         else
         {
            mView.displayPrimaryPhone.labelRoaming.visible = false;
         }
         this.updateSignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
      }
      
      private function onNetworkOperatorState(evt:BluetoothEvent) : void
      {
      }
      
      private function onHfMode(evt:BluetoothEvent) : void
      {
         if(evt.data.hfMode == true)
         {
            Peripheral.audioSettings.setSHFMicMute(Peripheral.audioSettings.SHFMicMute);
         }
         this.setScreenState();
      }
      
      private function phoneBookAvailable(evt:PhoneBookEvent) : void
      {
         this.updateButtonBar();
      }
      
      private function onSMSSyncState(evt:SMSMessageEvent) : void
      {
         this.updateButtonBar();
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         this.setScreenState();
      }
      
      private function onMessage(evt:MessageEvent) : void
      {
         if(evt.message.type == "phone number")
         {
            this.setScreenState();
         }
         else if(evt.message.type == "phone ready")
         {
            this.setScreenState();
         }
         else if(evt.message.type == "no phone connected")
         {
            this.setScreenState();
         }
      }
      
      private function callFavoriteEvent(e:Event) : void
      {
         var buttonName:String = null;
         var pState:String = this.phoneState;
         if(this.DIALING == pState || this.SECOND_DIALING == pState || this.RINGING == pState || this.SECOND_RINGING == pState || this.TRANSFERRED == pState)
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
         else
         {
            buttonName = e.target.name;
            switch(buttonName)
            {
               case "btnFav1_button":
                  this.callFavourite(1);
                  break;
               case "btnFav2_button":
                  this.callFavourite(2);
                  break;
               case "btnFav3_button":
                  this.callFavourite(3);
                  break;
               case "btnFav4_button":
                  this.callFavourite(4);
                  break;
               case "btnFav5_button":
                  this.callFavourite(5);
            }
         }
      }
      
      private function storeFavoriteEvent(e:WidgetEvent) : void
      {
         var pState:String = this.phoneState;
         if(this.mIsConferenced == true && this.mIsHeldConferenced == false)
         {
            return;
         }
         if(!(this.ACTIVE == pState || this.TWO_ACTIVE_ONE_ONHOLD == pState))
         {
            if(!(pState == this.IDLE && this.mTimeoutTimer.running) || this.mlastCallState == this.CONFERENCE_CALL)
            {
               return;
            }
         }
         var buttonName:String = e.target.name;
         switch(buttonName)
         {
            case "btnFav1_button":
               this.storeFavourite(1);
               break;
            case "btnFav2_button":
               this.storeFavourite(2);
               break;
            case "btnFav3_button":
               this.storeFavourite(3);
               break;
            case "btnFav4_button":
               this.storeFavourite(4);
               break;
            case "btnFav5_button":
               this.storeFavourite(5);
         }
      }
      
      private function btnEndClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         if(mView.btnEnd_button.enabled)
         {
            if(pState == this.CONFERENCE_CALL || pState == this.CONFERENCE_CALL_ONHOLD)
            {
               this.mlastCallState = this.CONFERENCE_CALL;
            }
            else
            {
               this.mlastCallState = this.phoneState;
            }
            if(this.mHasIgnoredCall)
            {
               Peripheral.bluetoothPhone.endAllCalls();
            }
            else
            {
               Peripheral.bluetoothPhone.endActiveCall();
            }
         }
      }
      
      private function btnHoldClickEvent(e:Event) : void
      {
         if(mView.btnHold_button.enabled)
         {
            if(Peripheral.bluetoothPhone.getHoldingCall() != null)
            {
               Peripheral.bluetoothPhone.resumeHeldCall();
            }
            else
            {
               Peripheral.bluetoothPhone.holdActiveCall();
            }
         }
      }
      
      private function btnRedialClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         if(mView.btnRedial_button.enabled)
         {
            Peripheral.bluetoothPhone.reDial();
         }
      }
      
      private function btnAnswerClickEvent(e:Event) : void
      {
         if(mView.btnAnswer_button.enabled)
         {
            Peripheral.bluetoothPhone.acceptIncomingCall();
            Peripheral.audioSettings.setSHFMicMute(false);
            if(Peripheral.audioMixerManager.phoneMuteStatus)
            {
               Peripheral.audioMixerManager.sendPhoneMute(false);
            }
            this.mWasMutedOnActive = false;
         }
      }
      
      private function btnIgnoreClickEvent(e:Event) : void
      {
         var rejectFeatureAvailable:Boolean = Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_REJECT") != -1;
         if(mView.btnIgnore_button.enabled)
         {
            if(rejectFeatureAvailable || this.phoneState != this.SECOND_RINGING)
            {
               Peripheral.bluetoothPhone.rejectIncomingCall();
            }
            else if(this.phoneState == this.SECOND_RINGING)
            {
               this.mHasIgnoredCall = true;
               this.setScreenState();
            }
         }
      }
      
      private function btnSwapClickEvent(e:Event) : void
      {
         if(mView.btnSwap_button.enabled)
         {
            Peripheral.bluetoothPhone.swapCalls();
         }
      }
      
      private function btnMuteClickEvent(e:Event) : void
      {
         if(this.phoneState == "ringing")
         {
            Peripheral.audioMixerManager.sendPhoneMute(!Peripheral.audioMixerManager.phoneMuteStatus);
         }
         else if(mView.btnMute_button.enabled)
         {
            Peripheral.audioSettings.setSHFMicMute(!Peripheral.audioSettings.SHFMicMute);
         }
      }
      
      private function muteStatusEvent(e:Event) : void
      {
         mView.btnMute_button.setHighlight(Peripheral.audioMixerManager.phoneMuteStatus);
      }
      
      private function btnTransferClickEvent(e:Event) : void
      {
         if(mView.btnTransfer_button.enabled)
         {
            if(true == Peripheral.audioSettings.SHFMicMute)
            {
               Peripheral.audioSettings.setSHFMicMute(false);
            }
            if(this.hasRingingCall || this.hasWaitingCall)
            {
               Peripheral.bluetoothPhone.acceptIncomingCall(true);
            }
            else
            {
               Peripheral.bluetoothPhone.setHfMode(false);
            }
         }
      }
      
      private function btnTransferBackClickEvent(e:Event) : void
      {
         if(mView.btnTransferBack_button.enabled)
         {
            if(this.hasRingingCall || this.hasWaitingCall)
            {
               Peripheral.bluetoothPhone.acceptIncomingCall(false);
            }
            else
            {
               Peripheral.bluetoothPhone.setHfMode(true);
            }
         }
      }
      
      private function btnConfCallClickEvent(e:Event) : void
      {
         if(mView.btnConfCall_button.enabled)
         {
            Peripheral.bluetoothPhone.conferenceCall();
         }
      }
      
      private function btnDialClickEvent(e:Event) : void
      {
         var params:Object = null;
         if(this.mPriorPhoneState != this.NO_PHONE_CONNECTED)
         {
            if(mView.btnDial_button.enabled)
            {
               this.closeIncomingSmsPopup();
               params = {"type":PopupType.PRIMARY};
               if(this.hasActiveCall)
               {
                  params.touchTone = true;
               }
               Framework.popupManager.show(DynamicPopupNames.PHONE_DIALING,"phonedialpadpopup",params);
            }
         }
      }
      
      private function btnSettingsClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         if(mView.btnSettings_button.enabled)
         {
            Peripheral.bluetooth.reqPairedDeviceList();
            this.closeIncomingSmsPopup();
            Framework.structure.goto(Screens.SETTINGS_PHONE_BLUETOOTH);
         }
      }
      
      private function btnPhoneBookClickEvent(e:Event) : void
      {
         if(mView.btnPhoneBook_button.enabled)
         {
            this.closeIncomingSmsPopup();
            this.showPhonebook();
         }
      }
      
      private function btnRecentCallClickEvent(e:Event) : void
      {
         if(mView.btnRecentCall_button.enabled)
         {
            this.closeIncomingSmsPopup();
            if(Peripheral.phoneCallList.recentCallsAvailable == true)
            {
               Framework.structure.goto("mainbackground/menu/phonerecentcallscreen");
            }
         }
      }
      
      private function primaryClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         Framework.Trace("**************** Primary Info click event ********");
         if(!isDebounceTimerRunning())
         {
            switch(pState)
            {
               case this.RINGING:
                  Peripheral.bluetoothPhone.acceptIncomingCall(false);
                  setDebounce(this.INFO_DEBOUNCE_TIMEOUT);
                  startDebounce();
                  break;
               case this.ACTIVE:
               case this.CONFERENCE_CALL_ONHOLD:
                  if(this.hasHoldingCall && !this.hasActiveCall)
                  {
                     Peripheral.bluetoothPhone.resumeHeldCall();
                     setDebounce(this.INFO_DEBOUNCE_TIMEOUT_LONG);
                     startDebounce();
                  }
            }
         }
      }
      
      private function secondaryClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         Framework.Trace("**************** Secondary Info click event ********");
         if(!isDebounceTimerRunning())
         {
            switch(pState)
            {
               case this.SECOND_RINGING:
                  Peripheral.bluetoothPhone.acceptIncomingCall();
                  Peripheral.audioSettings.setSHFMicMute(false);
                  this.mWasMutedOnActive = false;
                  setDebounce(this.INFO_DEBOUNCE_TIMEOUT);
                  startDebounce();
                  break;
               case this.TWO_ACTIVE_ONE_ONHOLD:
                  if(Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_SWAP") != -1)
                  {
                     Peripheral.bluetoothPhone.swapCalls();
                     this.setActiveWithArray([mView.btnSwap_button],false,true);
                     setDebounce(this.INFO_DEBOUNCE_TIMEOUT_LONG);
                     startDebounce();
                  }
            }
         }
      }
      
      private function btnMessagingClickEvent(e:Event) : void
      {
         var pState:String = this.phoneState;
         if(Boolean(mView.btnMessaging_button.mouseEnabled && pState != this.DIALING && pState != this.RINGING) && Boolean(pState != this.SECOND_RINGING) && pState != this.SECOND_DIALING)
         {
            this.closeIncomingSmsPopup();
            if(Peripheral.smsMessaging.isSMSSupported)
            {
               if(Peripheral.smsMessaging.isSMSDisabled)
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "timeout":this.SMS_POPUPS_TIMEOUT,
                     "status":"sms sync error"
                  });
               }
               else if(Peripheral.smsMessaging.isSMSReady)
               {
                  Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = null;
                  Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen");
               }
               else
               {
                  Framework.Trace("SMS Sync is in progress");
               }
            }
            else if(this.mPriorPhoneState != this.NO_PHONE_CONNECTED)
            {
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "timeout":this.SMS_POPUPS_TIMEOUT,
                  "status":"sms not supported"
               });
               Peripheral.smsMessaging.CheckIsSMSSupported();
               Framework.Trace("SMS is not supported");
            }
         }
      }
      
      private function onDoNotDisturbClick(e:WidgetEvent) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus)
         {
            Peripheral.bluetoothPhone.DNDStatus = false;
            Peripheral.smsMessaging.replyWithMessage = Peripheral.persistency.getValue(PersistencyKeys.KEY_REPLY_WITH_MESSAGE).value;
            mView.displayPrimaryPhone.missedCalls.visible = false;
            mView.displayPrimaryPhone.missedTexts.visible = false;
            Peripheral.smsMessaging.blockedSMSCount = 0;
            Peripheral.phoneCallList.blockedCallCount = 0;
         }
         else
         {
            Peripheral.bluetoothPhone.DNDStatus = true;
         }
      }
      
      private function onReplyWithTextMessageClick(e:WidgetEvent) : void
      {
         Peripheral.smsMessaging.replyWithMessage = !Peripheral.smsMessaging.replyWithMessage;
         Peripheral.persistency.write(PersistencyKeys.KEY_REPLY_WITH_MESSAGE,{"value":Peripheral.smsMessaging.replyWithMessage});
         this.setScreenState();
      }
      
      private function onCallListAvailable(e:PhoneCallListEvent) : void
      {
         this.updateButtonBar();
      }
      
      private function setTimeout(milliseconds:int) : void
      {
         this.cancelTimeout();
         this.mTimeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeoutTimerComplete);
         this.mTimeoutTimer.delay = milliseconds;
         this.mTimeoutTimer.start();
      }
      
      private function cancelTimeout() : void
      {
         if(this.mTimeoutTimer.running)
         {
            if(this.mTimeoutTimer.hasEventListener(TimerEvent.TIMER))
            {
               this.mTimeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeoutTimerComplete);
            }
            this.mTimeoutTimer.stop();
            Peripheral.bluetoothPhone.bluetoothHFP.deleteLastCallData();
            this.mlastCallState = this.IDLE;
            this.mbContactIDDisplay = false;
         }
      }
      
      private function onTimeoutTimerComplete(evt:TimerEvent) : void
      {
         this.mTimeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeoutTimerComplete);
         this.mTimeoutTimer.stop();
         this.updateDisplayCallStatus("","");
         t(mView.displayPrimaryPhone.labelCallTime,"");
         this.updateFav();
         Peripheral.bluetoothPhone.bluetoothHFP.deleteLastCallData();
         this.mlastCallState = this.IDLE;
         Peripheral.bluetoothPhone.phoneHomeScreenStatus(true,Peripheral.localeEngine.getText(T.STRB_PHONE_READY));
         this.mbContactIDDisplay = false;
         this.setScreenState();
      }
      
      private function setPrimaryPhoneIconVisibility(_iconVisible:Boolean, frame:String = "") : void
      {
         mView.displayPrimaryPhone.type.visible = _iconVisible;
         if(_iconVisible)
         {
            mView.displayPrimaryPhone.labelStatus.width = mView.LabelStatusWidth;
            mView.displayPrimaryPhone.labelStatus.x = mView.LabelStatusX;
            if(frame != "")
            {
               mView.displayPrimaryPhone.type.gotoAndStop(frame);
            }
         }
         else
         {
            mView.displayPrimaryPhone.labelStatus.width = mView.Align_LabelStatus;
            mView.displayPrimaryPhone.labelStatus.x = 0;
         }
      }
      
      private function onEnterPressed(e:HardControlEvent) : void
      {
         this.showPhonebook();
      }
      
      private function showPhonebook() : void
      {
         if(Peripheral.phonebook.isPhoneBookReady())
         {
            if(Peripheral.phonebook.phonebookSyncUpdateStatus)
            {
               Peripheral.phonebook.refreshPhonebook();
            }
            Framework.structure.goto("mainbackground/menu/PhonebookScreen",{"show":Peripheral.phonebook.lastModePhonebookScreen});
         }
      }
      
      private function onPhonebookSyncStatus(e:PhoneBookEvent) : void
      {
         if(Peripheral.localeEngine.getText(T.STRB_PHONE_READY) == mView.displayPrimaryPhone.labelStatus.text)
         {
            if("syncStart" == Peripheral.phonebook.phoneBookSyncStatus || "syncInProgress" == Peripheral.phonebook.phoneBookSyncStatus)
            {
               this.updateDisplayCallStatus("","");
               t(mView.displayPrimaryPhone.labelStatus,T.STRB_PHONE_ERROR_DOWNLOADING_1);
            }
         }
         if("syncComplete" == Peripheral.phonebook.phoneBookSyncStatus || "syncError" == Peripheral.phonebook.phoneBookSyncStatus)
         {
            if(!this.mbContactIDDisplay)
            {
               if(Boolean(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus) && (Boolean(Peripheral.phoneCallList.blockedCallCount) || Boolean(Peripheral.smsMessaging.blockedSMSCount)))
               {
                  t(mView.displayPrimaryPhone.labelStatus,"");
                  if(Peripheral.phoneCallList.blockedCallCount)
                  {
                     mView.displayPrimaryPhone.missedCalls.visible = true;
                     t(mView.displayPrimaryPhone.missedCalls,[T.STRB_MISSED_CALLS_ARG,String(Peripheral.phoneCallList.blockedCallCount)]);
                  }
                  if(Peripheral.smsMessaging.blockedSMSCount)
                  {
                     mView.displayPrimaryPhone.missedTexts.visible = true;
                     t(mView.displayPrimaryPhone.missedTexts,[T.STRB_MISSED_TEXT_MESS_ARG,String(Peripheral.smsMessaging.blockedSMSCount)]);
                  }
               }
               else if(this.phoneState != this.CONFERENCE_CALL && this.phoneState == this.IDLE)
               {
                  t(mView.displayPrimaryPhone.labelStatus,T.STRB_PHONE_READY);
               }
            }
         }
      }
      
      private function onswapCalls(evt:BluetoothEvent) : void
      {
         this.setActiveWithArray([mView.btnSwap_button],true,true);
      }
      
      private function closeIncomingSmsPopup() : void
      {
         if(Framework.popupManager.check(DynamicPopupNames.SMS_INCOMING_MESSAGE))
         {
            Peripheral.smsMessaging.clearIncomingMessage(true);
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
      }
      
      private function highlightFavInConference(activeCalls:Vector.<BluetoothCall>) : void
      {
         var i:Number = NaN;
         var idx:Number = NaN;
         var call:BluetoothCall = null;
         var pattern:RegExp = null;
         var phoneNumStored:String = null;
         var currentNum:String = null;
         if(null != this.mFavoritesContacts)
         {
            i = this.mFavoritesContacts.length;
            while(--i > -1)
            {
               if(0 != this.mFavoritesContacts[i].favIndex && this.MIN_FAVORITES >= this.mFavoritesContacts[i].favIndex)
               {
                  idx = this.mFavoritesContacts[i].favIndex - 1;
                  for each(call in activeCalls)
                  {
                     if(call.callState == "active" || this.phoneState == this.CONFERENCE_CALL_ONHOLD)
                     {
                        if(mView["btnFav" + (idx + 1) + "_button"].labelName.text != null)
                        {
                           pattern = /-/gi;
                           phoneNumStored = this.mFavoritesContacts[i].importantNumber();
                           currentNum = call.number;
                           if(10 != phoneNumStored.length)
                           {
                              phoneNumStored = phoneNumStored.replace(pattern,"");
                              if(10 != phoneNumStored.length)
                              {
                                 phoneNumStored = phoneNumStored.slice(-10,phoneNumStored.length);
                              }
                           }
                           if(10 != currentNum.length)
                           {
                              currentNum = currentNum.replace(pattern,"");
                              if(10 != currentNum.length)
                              {
                                 currentNum = currentNum.slice(-10,currentNum.length);
                              }
                           }
                           if(phoneNumStored == currentNum)
                           {
                              mView["btnFav" + (idx + 1) + "_button"].setHighlight(true);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function onDNDStatus(evt:BluetoothEvent) : void
      {
         Peripheral.smsMessaging.DNDStatus = Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus;
         this.setScreenState();
      }
      
      private function onSendAutoReplyForSMS(e:SMSMessageEvent) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus)
         {
            this.setScreenState();
         }
      }
      
      private function onSendAutoReplyForCall(e:PhoneCallListEvent) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus)
         {
            this.setScreenState();
         }
      }
      
      private function onVRDNDStatus(e:VoiceRecognitionEvent) : void
      {
         if("off" == e.mData.status)
         {
            mView.displayPrimaryPhone.missedCalls.visible = false;
            mView.displayPrimaryPhone.missedTexts.visible = false;
         }
      }
   }
}

