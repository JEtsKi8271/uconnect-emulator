package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.BluetoothCall;
   import com.nfuzion.moduleLinkAPI.BluetoothPropertyConstants;
   import com.nfuzion.moduleLinkAPI.IBluetoothHFP;
   import com.nfuzion.moduleLinkAPI.IBluetoothPhone;
   import com.nfuzion.moduleLinkAPI.IPhoneBook;
   import com.nfuzion.moduleLinkAPI.IPhoneCallList;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   
   public class BluetoothPhone extends Module implements IBluetoothPhone
   {
      
      private static var instance:BluetoothPhone;
      
      private var connection:Connection;
      
      private var mbluetoothHFP:BluetoothHFP;
      
      private var mphoneBook:PhoneBook = new PhoneBook();
      
      private var mcallList:PhoneCallList = new PhoneCallList();
      
      public function BluetoothPhone()
      {
         super();
         this.connection = Connection.share();
         this.mbluetoothHFP = new BluetoothHFP(this);
         this.mbluetoothHFP.addEventListener(ModuleEvent.READY,this.onHFPReady);
         if(this.mbluetoothHFP.isReady())
         {
            this.onHFPReady(null);
         }
      }
      
      public static function getInstance() : BluetoothPhone
      {
         if(instance == null)
         {
            instance = new BluetoothPhone();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return this.mbluetoothHFP.isReady() && this.mphoneBook.isReady() && this.mcallList.isReady();
      }
      
      private function onHFPReady(e:ModuleEvent) : void
      {
         this.mbluetoothHFP.removeEventListener(ModuleEvent.READY,this.onHFPReady);
         this.mphoneBook.init(this.mbluetoothHFP.connection);
         this.mcallList.init(this.mbluetoothHFP.connection,this);
         this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
      }
      
      public function get HFPSignalQuality() : int
      {
         return this.mbluetoothHFP.HFPSignalQuality;
      }
      
      public function get reason() : String
      {
         return this.mbluetoothHFP.reason;
      }
      
      public function dial(number:String) : void
      {
         this.mbluetoothHFP.dial(number);
      }
      
      public function reDial() : void
      {
         this.mbluetoothHFP.reDial();
      }
      
      public function acceptIncomingCall(transfer:Boolean = false) : void
      {
         this.mbluetoothHFP.acceptIncomingCall(transfer);
      }
      
      public function sendDtmfTone(dtmf:String) : void
      {
         this.mbluetoothHFP.sendDtmfTone(dtmf);
      }
      
      public function endCall(call:BluetoothCall) : void
      {
         this.mbluetoothHFP.endCall(call);
      }
      
      public function endActiveCall() : void
      {
         this.mbluetoothHFP.endActiveCall();
      }
      
      public function endAllCalls() : void
      {
         this.mbluetoothHFP.endAllCalls();
      }
      
      public function rejectIncomingCall() : void
      {
         this.mbluetoothHFP.rejectIncomingCall();
      }
      
      public function holdActiveCall() : void
      {
         this.mbluetoothHFP.holdActiveCall();
      }
      
      public function resumeHeldCall() : void
      {
         this.mbluetoothHFP.resumeHeldCall();
      }
      
      public function conferenceCall() : void
      {
         this.mbluetoothHFP.conferenceCall();
      }
      
      public function setMuteState(state:String) : void
      {
         this.mbluetoothHFP.setMuteState(state);
      }
      
      public function reqMuteState() : void
      {
         this.mbluetoothHFP.reqMuteState();
      }
      
      public function setHfMode(hfMode:Boolean) : void
      {
         this.mbluetoothHFP.setHfMode(hfMode);
      }
      
      public function swapCalls() : void
      {
         this.mbluetoothHFP.swapCalls();
      }
      
      public function getProperties(... args) : void
      {
         this.mbluetoothHFP.getProperties(args);
      }
      
      public function getSiriStatus() : void
      {
         this.mbluetoothHFP.getSiriStatus();
      }
      
      public function setProperties(properties:String) : void
      {
         this.mbluetoothHFP.setProperties(properties);
      }
      
      public function get currentCalls() : Vector.<BluetoothCall>
      {
         return this.mbluetoothHFP.currentCalls;
      }
      
      public function getActiveCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getActiveCall();
      }
      
      public function getHoldingCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getHoldingCall();
      }
      
      public function getDialingCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getDialingCall();
      }
      
      public function getRingingCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getRingingCall();
      }
      
      public function getAlertingCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getAlertingCall();
      }
      
      public function getWaitingCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getWaitingCall();
      }
      
      public function deleteCall(call:BluetoothCall) : void
      {
         this.mbluetoothHFP.deleteCall(call);
      }
      
      public function getPrimaryCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getPrimaryCall();
      }
      
      public function getSecondaryCall() : BluetoothCall
      {
         return this.mbluetoothHFP.getSecondaryCall();
      }
      
      public function getCallDuration() : int
      {
         return this.mbluetoothHFP.getCallDuration();
      }
      
      public function getPrimaryCallDuration() : int
      {
         return this.mbluetoothHFP.getPrimaryCallDuration();
      }
      
      public function getSecondaryCallDuration() : int
      {
         return this.mbluetoothHFP.getSecondaryCallDuration();
      }
      
      public function reqPhonePresets() : void
      {
         this.mbluetoothHFP.reqPhonePresets();
      }
      
      public function get bluetoothHFP() : IBluetoothHFP
      {
         return this.mbluetoothHFP;
      }
      
      public function isBluetoothCallActive() : Boolean
      {
         var _callState:String = null;
         var _call:BluetoothCall = this.getPrimaryCall();
         if(_call)
         {
            _callState = _call.callState;
            if(_callState == BluetoothCall.mCallStateActive && _call.audio || _callState == BluetoothCall.mCallStateAlerting || _callState == BluetoothCall.mCallStateDialing || _callState == BluetoothCall.mCallStateOnHold && _call.audio || _callState == BluetoothCall.mCallStateRinging)
            {
               return true;
            }
         }
         return false;
      }
      
      public function phoneHomeScreenStatus(status:Boolean, state:String) : void
      {
         var message:Object = null;
         message = {
            "Type":"EmitSignal",
            "packet":{"hmiPhoneStatus":{"homeScreen":{
               "active":status,
               "state":state
            }}}
         };
         this.connection.send(message);
      }
      
      public function set DNDStatus(status:Boolean) : void
      {
         if(status)
         {
            this.getProperties(BluetoothPropertyConstants.PROP_SUBSCRIBER_NUMBER_INFO);
         }
         this.mbluetoothHFP.DNDStatus = status;
      }
      
      public function get phoneBook() : IPhoneBook
      {
         return this.mphoneBook;
      }
      
      public function get callList() : IPhoneCallList
      {
         return this.mcallList;
      }
   }
}

