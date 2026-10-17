package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class BluetoothEvent extends Event
   {
      
      public static const DEVICE_PAIRED_OK:String = "DevicePairedOK";
      
      public static const DEVICE_PAIRED_FAIL:String = "DevicePairedFail";
      
      public static const DEVICE_UNPAIRED:String = "DeviceUnpaired";
      
      public static const DEVICE_SEARCH_LIST:String = "DeviceSearchList";
      
      public static const PAIRED_DEVICE_LIST:String = "PairedDeviceList";
      
      public static const PAIRED_DEVICE_LIST_FAIL:String = "PairedDeviceListFail";
      
      public static const BLUETOOTH_STATUS:String = "bluetoothStatus";
      
      public static const BLUETOOTH_PIN_OK:String = "bluetoothPinOK";
      
      public static const BLUETOOTH_PIN_FAIL:String = "bluetoothPinFail";
      
      public static const STANDARD_PAIRING_REQUEST:String = "standardPairingRequest";
      
      public static const SECURE_PAIRING_REQUEST:String = "securePairingRequest";
      
      public static const PROFILE_SEARCH_LIST:String = "profileSearchList";
      
      public static const SERVICE_CONNECTED:String = "serviceConnected";
      
      public static const SERVICE_DISCONNECTED:String = "serviceDisconnected";
      
      public static const SERVICE_FAVOURITE_SET:String = "serviceFavouriteSet";
      
      public static const SET_DISCOVERABLE_OK:String = "setAccessModeOK";
      
      public static const SET_DISCOVERABLE_FAIL:String = "setAccessModeFail";
      
      public static const START_DEVICE_SEARCH_OK:String = "startDeviceSearchOK";
      
      public static const START_DEVICE_SEARCH_FAIL:String = "startDeviceSearchFail";
      
      public static const STOP_DEVICE_SEARCH_OK:String = "stopDeviceSearchOK";
      
      public static const STOP_DEVICE_SEARCH_FAIL:String = "stopDeviceSearchFail";
      
      public static const START_DEVICE_PAIRING_OK:String = "startDevicePairingOK";
      
      public static const START_DEVICE_PAIRING_FAIL:String = "startDevicePairingFail";
      
      public static const START_DEVICE_UNPAIRING_OK:String = "startDeviceUnpairingOK";
      
      public static const START_DEVICE_UNPAIRING_FAIL:String = "startDeviceUnpairingFail";
      
      public static const PIN:String = "PIN";
      
      public static const LOCAL_DEVICE_ADDRESS:String = "localDeviceAddress";
      
      public static const LOCAL_DEVICE_NAME:String = "localDeviceName";
      
      public static const START_SERVICE_CONNECT_OK:String = "startServiceConnectOK";
      
      public static const START_SERVICE_CONNECT_FAIL:String = "startServiceConnectFail";
      
      public static const START_SERVICE_DISCONNECT_OK:String = "startServiceDisconnectOK";
      
      public static const START_SERVICE_DISCONNECT_FAIL:String = "startServiceDisconnectFail";
      
      public static const DEVICE_CONNECT_OK:String = "DeviceConnectOK";
      
      public static const DEVICE_CONNECT_FAIL:String = "DeviceConnectFail";
      
      public static const CALL_STATE:String = "callState";
      
      public static const SIGNAL_QUALITY:String = "signalQuality";
      
      public static const HANDS_FREE_MODE:String = "handsFreeMode";
      
      public static const AUDIO_STATUS:String = "audioStatus";
      
      public static const BATTERY_CHARGE:String = "batteryCharge";
      
      public static const NETWORK_REGISTRATION_STATE:String = "networkRegistrationState";
      
      public static const NETWORK_OPERATOR_CHANGED:String = "networkOperatorChanged";
      
      public static const ACCEPT_INCOMING_CALL_OK:String = "acceptIncomingCallOK";
      
      public static const ACCEPT_INCOMING_CALL_FAIL:String = "acceptIncomingCallFail";
      
      public static const DIAL_OK:String = "dialOK";
      
      public static const DIAL_FAIL:String = "dialFail";
      
      public static const SEND_DTMF_TONE_OK:String = "sendDtmfToneOK";
      
      public static const SEND_DTMF_TONE_FAIL:String = "sendDtmfToneFail";
      
      public static const END_CALL_OK:String = "endCallOK";
      
      public static const END_CALL_FAIL:String = "endCallFail";
      
      public static const END_ACTIVE_CALL_OK:String = "endActiveCallOK";
      
      public static const END_ACTIVE_CALL_FAIL:String = "endActiveCallFail";
      
      public static const END_ALL_CALLS_OK:String = "endAllCallsOK";
      
      public static const END_ALL_CALL_FAIL:String = "endAllCallFail";
      
      public static const REJECT_INCOMING_CALL_OK:String = "rejectIncomingCallOK";
      
      public static const REJECT_INCOMING_CALL_FAIL:String = "rejectIncomingCallFail";
      
      public static const HOLD_ACTIVE_CALL_OK:String = "holdActiveCallOK";
      
      public static const HOLD_ACTIVE_CALL_FAIL:String = "holdActiveCallFail";
      
      public static const RESUME_HELD_CALL_OK:String = "resumeHeldCallOK";
      
      public static const RESUME_HELD_CALL_FAIL:String = "resumeHeldCallFail";
      
      public static const CONFERENCE_CALL_OK:String = "conferenceCallOK";
      
      public static const CONFERENCE_CALL_FAIL:String = "conferenceCallFail";
      
      public static const SET_MUTE_STATE_OK:String = "setMuteStateOK";
      
      public static const SET_MUTE_STATE_FAIL:String = "setMuteStateFail";
      
      public static const GET_MUTE_STATE_FAIL:String = "getMuteStateFail";
      
      public static const MUTE_STATE_ON:String = "muteStateOn";
      
      public static const MUTE_STATE_OFF:String = "muteStateOff";
      
      public static const SET_HF_MODE_OK:String = "setHfModeOK";
      
      public static const SET_HF_MODE_FAIL:String = "setHfModeFail";
      
      public static const SWAP_CALLS_OK:String = "swapCallsOK";
      
      public static const SWAP_CALLS_FAIL:String = "swapCallsFail";
      
      public static const CALLER_ID_INFO:String = "CallerIdInfo";
      
      public static const PHONE_PRESETS:String = "phonePresets";
      
      public static const OFF_HOOK_TIMER:String = "offhookTimer";
      
      public static const OFF_HOOK_TIMER_PRIMARY:String = "offhookTimerPrimary";
      
      public static const OFF_HOOK_TIMER_SECONDARY:String = "offhookTimerSecondary";
      
      public static const SUPPORTED_FEATURES_LIST:String = "supportedFeaturesList";
      
      public static const PHONE_VR_MODE:String = "phoneVrMode";
      
      public static const DND_STATUS:String = "DNDStatus";
      
      public static const SIRI_STATUS:String = "SiriStatus";
      
      public static const PIM_SYNC_STATE:String = "pimSyncState";
      
      public static const INIT_QUERY_GET_CONTACTS_LIST_OK:String = "initQueryGetContactsListOK";
      
      public static const INIT_QUERY_GET_CONTACTS_LIST_FAIL:String = "initQueryGetContactsListFail";
      
      public static const GET_CONTACTS_COUNT_OK:String = "getContactsCountOK";
      
      public static const GET_CONTACTS_COUNT_FAIL:String = "getContactsCountFail";
      
      public static const DEINIT_QUERY_GET_CONTACTS_LIST_OK:String = "deInitQueryGetContactsListOK";
      
      public static const DEINIT_QUERY_GET_CONTACTS_LIST_FAIL:String = "deInitQueryGetContactsListFail";
      
      public static const GET_CONTACTS_LIST_OK:String = "getContactsListOK";
      
      public static const GET_CONTACTS_LIST_FAIL:String = "getContactsListFail";
      
      public static const SET_BT_CHIP_MODE:String = "setBTChipMode";
      
      public static const GET_BT_CHIP_BTID:String = "getBTChipBTID";
      
      public var m_data:Object = null;
      
      public function BluetoothEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.m_data = data;
      }
      
      public function get data() : Object
      {
         return this.m_data;
      }
      
      override public function clone() : Event
      {
         return new BluetoothEvent(type,this.data,bubbles,cancelable);
      }
   }
}

