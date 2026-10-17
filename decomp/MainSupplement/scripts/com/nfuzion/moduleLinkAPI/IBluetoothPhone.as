package com.nfuzion.moduleLinkAPI
{
   public interface IBluetoothPhone extends IModule
   {
      
      function get HFPSignalQuality() : int;
      
      function get reason() : String;
      
      function get currentCalls() : Vector.<BluetoothCall>;
      
      function getActiveCall() : BluetoothCall;
      
      function getHoldingCall() : BluetoothCall;
      
      function getDialingCall() : BluetoothCall;
      
      function getRingingCall() : BluetoothCall;
      
      function getAlertingCall() : BluetoothCall;
      
      function getWaitingCall() : BluetoothCall;
      
      function getPrimaryCall() : BluetoothCall;
      
      function getSecondaryCall() : BluetoothCall;
      
      function dial(param1:String) : void;
      
      function reDial() : void;
      
      function acceptIncomingCall(param1:Boolean = false) : void;
      
      function rejectIncomingCall() : void;
      
      function sendDtmfTone(param1:String) : void;
      
      function endCall(param1:BluetoothCall) : void;
      
      function endActiveCall() : void;
      
      function endAllCalls() : void;
      
      function holdActiveCall() : void;
      
      function resumeHeldCall() : void;
      
      function conferenceCall() : void;
      
      function setMuteState(param1:String) : void;
      
      function reqMuteState() : void;
      
      function setHfMode(param1:Boolean) : void;
      
      function swapCalls() : void;
      
      function getProperties(... rest) : void;
      
      function getSiriStatus() : void;
      
      function setProperties(param1:String) : void;
      
      function deleteCall(param1:BluetoothCall) : void;
      
      function getCallDuration() : int;
      
      function getPrimaryCallDuration() : int;
      
      function getSecondaryCallDuration() : int;
      
      function reqPhonePresets() : void;
      
      function get bluetoothHFP() : IBluetoothHFP;
      
      function isBluetoothCallActive() : Boolean;
      
      function set DNDStatus(param1:Boolean) : void;
      
      function get phoneBook() : IPhoneBook;
      
      function get callList() : IPhoneCallList;
      
      function phoneHomeScreenStatus(param1:Boolean, param2:String) : void;
   }
}

