package com.nfuzion.moduleLinkAPI
{
   public interface IBluetoothHFP extends IModule
   {
      
      function dial(param1:String, param2:String = null, param3:String = null) : void;
      
      function reDial() : void;
      
      function acceptIncomingCall(param1:Boolean = false) : void;
      
      function sendDtmfTone(param1:String) : void;
      
      function endCall(param1:BluetoothCall) : void;
      
      function endActiveCall() : void;
      
      function endAllCalls() : void;
      
      function rejectIncomingCall() : void;
      
      function holdActiveCall() : void;
      
      function resumeHeldCall() : void;
      
      function conferenceCall() : void;
      
      function setMuteState(param1:String) : void;
      
      function reqMuteState() : void;
      
      function setHfMode(param1:Boolean) : void;
      
      function swapCalls() : void;
      
      function getProperties(... rest) : void;
      
      function setProperties(param1:String) : void;
      
      function get currentCalls() : Vector.<BluetoothCall>;
      
      function getActiveCall() : BluetoothCall;
      
      function get isCallConferenced() : Boolean;
      
      function getHoldingCall() : BluetoothCall;
      
      function getDialingCall() : BluetoothCall;
      
      function getRingingCall() : BluetoothCall;
      
      function getAlertingCall() : BluetoothCall;
      
      function getWaitingCall() : BluetoothCall;
      
      function deleteCall(param1:BluetoothCall) : void;
      
      function getLastCallData() : BluetoothCall;
      
      function deleteLastCallData() : void;
      
      function getPrimaryCall() : BluetoothCall;
      
      function getSecondaryCall() : BluetoothCall;
      
      function getCallDuration() : int;
      
      function getPrimaryCallDuration() : int;
      
      function getSecondaryCallDuration() : int;
      
      function reqPhonePresets() : void;
      
      function get HFPSignalQuality() : int;
      
      function set HFPSignalQuality(param1:int) : void;
      
      function get handsFreeMode() : Boolean;
      
      function set handsFreeMode(param1:Boolean) : void;
      
      function get audioStatus() : Boolean;
      
      function set audioStatus(param1:Boolean) : void;
      
      function get batteryCharge() : int;
      
      function set batteryCharge(param1:int) : void;
      
      function get networkOperator() : BluetoothNetworkOperator;
      
      function get networkRegistrationState() : String;
      
      function set networkRegistrationState(param1:String) : void;
      
      function get isMuted() : Boolean;
      
      function set muteState(param1:Boolean) : void;
      
      function updateCallState(param1:int, param2:String, param3:String, param4:String, param5:int, param6:Boolean, param7:String) : Boolean;
      
      function getCall(param1:int) : BluetoothCall;
      
      function get reason() : String;
      
      function get featureList() : String;
      
      function get isSiriFeatureSupported() : Boolean;
      
      function get isVRFeatureSupported() : Boolean;
      
      function set setVrMode(param1:Boolean) : void;
      
      function set DNDStatus(param1:Boolean) : void;
      
      function get DNDStatus() : Boolean;
      
      function get subscriberNumber() : String;
      
      function get siriStatusEnabled() : Boolean;
      
      function get siriStatusAvailable() : Boolean;
      
      function startAutoConnect(param1:Boolean) : void;
   }
}

