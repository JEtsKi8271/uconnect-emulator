package com.nfuzion.moduleLink
{
   import com.adobe.serialization.json.JSON;
   import com.nfuzion.moduleLinkAPI.*;
   import com.nfuzion.span.*;
   import flash.events.*;
   
   public class BluetoothHFP extends Module implements IBluetoothHFP
   {
      
      private static const dbusIdentifier:String = "BluetoothHFP";
      
      private static const dbusBTPersistency:String = "BluetoothHFPPersistency";
      
      private var mSignalQuality:int;
      
      private var mHandsFreeMode:Boolean;
      
      private var mSiriStatusEnabled:Boolean;
      
      private var mSiriStatusAvailable:Boolean;
      
      private var mAudioStatus:Boolean;
      
      private var mBatteryCharge:int;
      
      private var mCalls:Vector.<BluetoothCall> = new Vector.<BluetoothCall>();
      
      private var mIsMuted:Boolean;
      
      private var mNetworkRegistrationState:String = "";
      
      private var mReason:String = "";
      
      private var mDialedNumber:String = "";
      
      private var mConnectIndex:int = 0;
      
      private var mFeatures:String = "";
      
      public var mlastCallData4Fav:BluetoothCall = null;
      
      public var mNetworkOperator:BluetoothNetworkOperator = new BluetoothNetworkOperator();
      
      private var mMyHMIDispatcher:BluetoothPhone = null;
      
      private var mMyTtsHMIDispatcher:TextToSpeech = null;
      
      private var mDNDStatus:Boolean = false;
      
      private var mSubscriberNumber:String = "";
      
      private var client:Client;
      
      private var mconnection:Connection;
      
      public function BluetoothHFP(bt:BluetoothPhone)
      {
         super();
         this.mSignalQuality = -1;
         this.mIsMuted = false;
         this.mSiriStatusEnabled = false;
         this.mSiriStatusAvailable = false;
         this.mBatteryCharge = -1;
         this.mMyHMIDispatcher = bt;
         this.mMyTtsHMIDispatcher = TextToSpeech.getInstance();
         this.addEventListener(BluetoothEvent.SERVICE_DISCONNECTED,this.onDisconnect);
         this.mMyHMIDispatcher.phoneBook.addEventListener(PhoneBookEvent.CALLER_ID,this.onCallerID);
         this.mconnection = Connection.share();
         this.client = this.mconnection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.mconnection.addEventListener(ConnectionEvent.BLUETOOTH_HFP,this.messageHandler);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.mconnection.configured) && Boolean(this.client.connected);
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.mconnection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendMultiSubscribe(["callState","signalQuality","handsFreeMode","audioStatus","batteryCharge","networkRegistrationState","networkOperatorChanged","supportedFeaturesList","phoneVrMode","smsBrowsingListSelection","siriStatus"]);
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.mMyHMIDispatcher.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function dial(number:String, name:String = null, numberType:String = null) : void
      {
         var message:String = null;
         if(name != null && name != "")
         {
            name = name.split("\\").join("\\\\");
            name = name.split("\"").join("\\\"");
         }
         if(number == "")
         {
            return;
         }
         this.mDialedNumber = number;
         if(Boolean(name) && Boolean(numberType) && numberType != "")
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + "dial" + "\": { \"" + "number" + "\": \"" + number + "\"" + "," + "\"" + "name" + "\": \"" + name + "\"" + "," + "\"" + "numberType" + "\": \"" + numberType + "\"}}}";
            this.client.send(message);
         }
         else if(name)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + "dial" + "\": { \"" + "number" + "\": \"" + number + "\"" + "," + "\"" + "name" + "\": \"" + name + "\"}}}";
            this.client.send(message);
         }
         else
         {
            this.sendCommand("dial","number",number);
         }
      }
      
      public function reDial() : void
      {
         this.sendCommand("reDial",null,null);
      }
      
      public function acceptIncomingCall(transfer:Boolean = false) : void
      {
         this.sendCommand("acceptIncomingCall","answerAndTransfer",transfer);
      }
      
      public function sendDtmfTone(dtmf:String) : void
      {
         this.sendCommand("sendDtmfTone","seq",dtmf);
      }
      
      public function endCall(call:BluetoothCall) : void
      {
         this.sendCommand("endCall","callId",call.callId);
      }
      
      public function endActiveCall() : void
      {
         this.sendCommand("endActiveCall",null,null);
      }
      
      public function endAllCalls() : void
      {
         this.sendCommand("endAllCalls",null,null);
      }
      
      public function rejectIncomingCall() : void
      {
         this.sendCommand("rejectIncomingCall",null,null);
      }
      
      public function holdActiveCall() : void
      {
         this.sendCommand("holdActiveCall",null,null);
      }
      
      public function resumeHeldCall() : void
      {
         this.sendCommand("resumeHeldCall",null,null);
      }
      
      public function conferenceCall() : void
      {
         this.sendCommand("conferenceCall",null,null);
      }
      
      public function setMuteState(state:String) : void
      {
         this.sendCommand("setMuteState","muteState",state);
      }
      
      public function reqMuteState() : void
      {
         this.sendCommand("getMuteState",null,null);
      }
      
      public function setHfMode(hfMode:Boolean) : void
      {
         this.sendCommand("setHfMode","hfMode",hfMode);
      }
      
      public function swapCalls() : void
      {
         this.sendCommand("swapCalls",null,null);
      }
      
      public function set DNDStatus(status:Boolean) : void
      {
         var tempDNDStatus:String = null;
         this.mDNDStatus = status;
         if(this.mDNDStatus)
         {
            tempDNDStatus = "on";
         }
         else
         {
            tempDNDStatus = "off";
         }
         this.sendCommand("setDNDStatus","status",tempDNDStatus);
      }
      
      public function getProperties(... args) : void
      {
         var properties:String = null;
         properties = "[";
         for(var i:int = 0; i < args.length; i++)
         {
            switch(args[i][0])
            {
               case BluetoothPropertyConstants.PROP_HFP_SIGNAL_QUALITY:
                  properties += "\"signalQuality\"";
                  break;
               case BluetoothPropertyConstants.PROP_GAP_NETWORK_OPERATOR_CHANGED:
                  properties += "\"networkOperatorChanged\"";
                  break;
               case BluetoothPropertyConstants.PROP_GAP_NETWORK_REGISTRATION_STATE:
                  properties += "\"networkRegistrationState\"";
                  break;
               case BluetoothPropertyConstants.PROP_HFP_HF_MODE:
                  properties += "\"handsFreeMode\"";
                  break;
               case BluetoothPropertyConstants.PROP_HFP_AUDIO_STATUS:
                  properties += "\"audioStatus\"";
                  break;
               case BluetoothPropertyConstants.PROP_HFP_BATTERY_CHARGE:
                  properties += "\"batteryCharge\"";
                  break;
               case BluetoothPropertyConstants.PROP_SUBSCRIBER_NUMBER_INFO:
                  properties += "\"subscriberNumber\"";
            }
            if(i + 1 < args.length)
            {
               properties += ", ";
            }
         }
         properties += "]";
         this.sendCommand("getProperties","properties",properties,false);
      }
      
      public function getSiriStatus() : void
      {
         var properties:String = null;
         properties = "[\"siriStatus\"]";
         this.sendCommand("getProperties","properties",properties,false);
      }
      
      public function setProperties(properties:String) : void
      {
         this.sendCommand("setProperties","props",properties);
      }
      
      public function get currentCalls() : Vector.<BluetoothCall>
      {
         return this.mCalls;
      }
      
      public function getActiveCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateActive)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function get isCallConferenced() : Boolean
      {
         if(this.mCalls.length > 1)
         {
            if(this.mCalls[0].callState == "active" && this.mCalls[1].callState == "active" || this.mCalls[0].callState == "onhold" && this.mCalls[1].callState == "onhold")
            {
               return true;
            }
         }
         return false;
      }
      
      public function getHoldingCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateOnHold)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function getDialingCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateDialing || btc.callState == BluetoothCall.mCallStateAlerting)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function getRingingCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateRinging)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function getAlertingCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateAlerting)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function getWaitingCall() : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callState == BluetoothCall.mCallStateWaiting)
            {
               return btc;
            }
         }
         return null;
      }
      
      public function deleteCall(call:BluetoothCall) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mCalls.length; i++)
         {
            if(this.mCalls[i].callId == call.callId)
            {
               this.mCalls.splice(i,1);
            }
         }
      }
      
      public function getPrimaryCall() : BluetoothCall
      {
         var call:BluetoothCall = null;
         var retCall:BluetoothCall = null;
         var isWaiting:Boolean = false;
         var heldCall:BluetoothCall = null;
         for each(call in this.mCalls)
         {
            if(call.callState == BluetoothCall.mCallStateDialing)
            {
               retCall = call;
               break;
            }
            if(call.callState != BluetoothCall.mCallStateOnHold && call.callState != BluetoothCall.mCallStateWaiting && call.callState != BluetoothCall.mCallStateIdle)
            {
               retCall = call;
            }
            else if(call.callState == BluetoothCall.mCallStateOnHold)
            {
               if(isWaiting)
               {
                  retCall = call;
                  break;
               }
               heldCall = call;
            }
            else if(call.callState == BluetoothCall.mCallStateWaiting)
            {
               isWaiting = true;
               if(heldCall != null)
               {
                  retCall = heldCall;
                  break;
               }
            }
         }
         if(retCall == null)
         {
            retCall = heldCall;
         }
         return retCall;
      }
      
      public function getSecondaryCall() : BluetoothCall
      {
         var call:BluetoothCall = null;
         var isDialing:Boolean = false;
         var primaryCall:BluetoothCall = null;
         primaryCall = this.getPrimaryCall();
         for each(call in this.mCalls)
         {
            if(call.callState == BluetoothCall.mCallStateOnHold || call.callState == BluetoothCall.mCallStateWaiting)
            {
               if(primaryCall != null && primaryCall.callId != call.callId)
               {
                  return call;
               }
            }
            else if(call.callState == BluetoothCall.mCallStateDialing)
            {
               isDialing = true;
            }
         }
         if(isDialing)
         {
            for each(call in this.mCalls)
            {
               if(call.callState == BluetoothCall.mCallStateActive)
               {
                  return call;
               }
            }
         }
         return null;
      }
      
      public function getCallDuration() : int
      {
         var time1:int = this.getPrimaryCallDuration();
         var time2:int = this.getSecondaryCallDuration();
         if(time2 > time1)
         {
            time1 = time2;
         }
         return time1;
      }
      
      public function getPrimaryCallDuration() : int
      {
         var call:BluetoothCall = null;
         var maxTime:int = 0;
         var isWaiting:Boolean = false;
         var heldCall:BluetoothCall = null;
         var isActive:Boolean = false;
         for each(call in this.mCalls)
         {
            if(call.callState == BluetoothCall.mCallStateDialing)
            {
               maxTime = call.duration();
               isActive = true;
               break;
            }
            if(call.callState != BluetoothCall.mCallStateOnHold && call.callState != BluetoothCall.mCallStateWaiting && call.callState != BluetoothCall.mCallStateIdle)
            {
               if(call.duration() > maxTime)
               {
                  maxTime = call.duration();
               }
               isActive = true;
            }
            else if(call.callState == BluetoothCall.mCallStateOnHold)
            {
               if(isWaiting)
               {
                  maxTime = call.duration();
                  break;
               }
               heldCall = call;
            }
            else if(call.callState == BluetoothCall.mCallStateWaiting)
            {
               isWaiting = true;
               if(heldCall != null)
               {
                  maxTime = heldCall.duration();
                  break;
               }
            }
         }
         if(!isActive && heldCall != null)
         {
            maxTime = heldCall.duration();
         }
         return maxTime;
      }
      
      public function getSecondaryCallDuration() : int
      {
         var maxTime:int = 0;
         var isDialing:Boolean = false;
         var call:BluetoothCall = null;
         var primaryCall:BluetoothCall = null;
         primaryCall = this.getPrimaryCall();
         for each(call in this.mCalls)
         {
            if(call.callState == BluetoothCall.mCallStateOnHold || call.callState == BluetoothCall.mCallStateWaiting)
            {
               if(primaryCall != null && primaryCall.callId != call.callId)
               {
                  if(call.duration() > maxTime)
                  {
                     maxTime = call.duration();
                  }
               }
            }
            else if(call.callState == BluetoothCall.mCallStateDialing)
            {
               isDialing = true;
            }
         }
         if(maxTime == 0 && isDialing == true)
         {
            for each(call in this.mCalls)
            {
               if(call.callState == BluetoothCall.mCallStateActive)
               {
                  if(call.duration() > maxTime)
                  {
                     maxTime = call.duration();
                  }
               }
            }
         }
         return maxTime;
      }
      
      public function reqPhonePresets() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusBTPersistency + "\", \"packet\": {\"read\":{\"key\":\"BTPhonePresets\", \"escval\":0}}}";
         this.client.send(message);
      }
      
      public function get HFPSignalQuality() : int
      {
         return this.mSignalQuality;
      }
      
      public function set HFPSignalQuality(q:int) : void
      {
         this.mSignalQuality = q;
      }
      
      public function get handsFreeMode() : Boolean
      {
         return this.mHandsFreeMode;
      }
      
      public function get siriStatusEnabled() : Boolean
      {
         return this.mSiriStatusEnabled;
      }
      
      public function get siriStatusAvailable() : Boolean
      {
         return this.mSiriStatusAvailable;
      }
      
      public function set handsFreeMode(hfm:Boolean) : void
      {
         this.mHandsFreeMode = hfm;
      }
      
      public function get audioStatus() : Boolean
      {
         return this.mAudioStatus;
      }
      
      public function set audioStatus(s:Boolean) : void
      {
         this.mAudioStatus = s;
      }
      
      public function get batteryCharge() : int
      {
         return this.mBatteryCharge;
      }
      
      public function set batteryCharge(bc:int) : void
      {
         this.mBatteryCharge = bc;
      }
      
      public function get networkOperator() : BluetoothNetworkOperator
      {
         return this.mNetworkOperator;
      }
      
      public function get networkRegistrationState() : String
      {
         return this.mNetworkRegistrationState;
      }
      
      public function set networkRegistrationState(nrs:String) : void
      {
         this.mNetworkRegistrationState = nrs;
      }
      
      public function get isMuted() : Boolean
      {
         return this.mIsMuted;
      }
      
      public function set muteState(ms:Boolean) : void
      {
         this.mIsMuted = ms;
      }
      
      private function saveLastCallData(data:BluetoothCall) : void
      {
         this.mlastCallData4Fav = data;
      }
      
      public function getLastCallData() : BluetoothCall
      {
         return this.mlastCallData4Fav;
      }
      
      public function deleteLastCallData() : void
      {
         this.mlastCallData4Fav = null;
      }
      
      public function get DNDStatus() : Boolean
      {
         return this.mDNDStatus;
      }
      
      public function updateCallState(callID:int, callState:String, number:String, name:String, callTime:int, audio:Boolean, numberType:String) : Boolean
      {
         var call:BluetoothCall = null;
         var curDuration:int = 0;
         for each(call in this.mCalls)
         {
            if(call.callId == callID)
            {
               call.callState = callState;
               if(callState == BluetoothCall.mCallStateIdle)
               {
                  this.saveLastCallData(call);
                  this.deleteCall(call);
               }
               else
               {
                  if(number != null)
                  {
                     call.number = number;
                     if(name != null && name != "")
                     {
                        call.callerID = name;
                     }
                     if(numberType != null && numberType != "")
                     {
                        call.numberType = numberType;
                     }
                     this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("CallerIdInfo"));
                  }
                  curDuration = call.duration();
                  call.setDuration(callTime);
                  if(curDuration != call.duration())
                  {
                     this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("offhookTimer",call.duration()));
                  }
                  call.audio = audio;
               }
               return true;
            }
         }
         if(!this.DNDStatus || "dialing" == callState || "alerting" == callState)
         {
            this.addCall(callID,callState,number,name,callTime,audio,numberType);
         }
         return true;
      }
      
      public function getCall(id:int) : BluetoothCall
      {
         var btc:BluetoothCall = null;
         for each(btc in this.mCalls)
         {
            if(btc.callId == id)
            {
               return btc;
            }
         }
         return null;
      }
      
      private function addCall(callID:int, callState:String, number:String, name:String, callTime:int, audio:Boolean, numberType:String) : void
      {
         var newcall:BluetoothCall = new BluetoothCall(callID,callState);
         if(number != null)
         {
            newcall.number = number;
         }
         newcall.setDuration(callTime);
         newcall.audio = audio;
         newcall.callerID = name;
         newcall.numberType = numberType;
         this.mCalls.push(newcall);
      }
      
      public function get reason() : String
      {
         return this.mReason;
      }
      
      public function get connection() : Connection
      {
         return this.mconnection;
      }
      
      public function get featureList() : String
      {
         return this.mFeatures;
      }
      
      public function get isSiriFeatureSupported() : Boolean
      {
         return this.mFeatures.indexOf("PHONE_FEATURE_SIRI") == -1 ? false : true;
      }
      
      public function get isVRFeatureSupported() : Boolean
      {
         return this.mFeatures.indexOf("PHONE_FEATURE_VR") == -1 ? false : true;
      }
      
      public function set setVrMode(svm:Boolean) : void
      {
         this.sendCommand("setVRMode","mode",svm);
      }
      
      public function startAutoConnect(reset:Boolean) : void
      {
         this.sendCommand("startAutoConnect","reset",reset);
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var o:Object = null;
         var message:String = null;
         var rtnstr:String = null;
         var rtn:int = 0;
         var callId:int = 0;
         var number:String = null;
         var callState:String = null;
         var body:String = null;
         var bluetooth:Object = e.data;
         if(bluetooth.hasOwnProperty("getProperties"))
         {
            if(bluetooth.getProperties.hasOwnProperty("networkOperatorChanged"))
            {
               this.mNetworkOperator.code = bluetooth.getProperties.networkOperatorChanged.operatorCode;
               this.mNetworkOperator.longName = bluetooth.getProperties.networkOperatorChanged.operatorLongName;
               this.mNetworkOperator.shortName = bluetooth.getProperties.networkOperatorChanged.operatorShortName;
               this.mNetworkOperator.mode = bluetooth.getProperties.networkOperatorChanged.operatorMode;
               this.mNetworkOperator.ACCTech = bluetooth.getProperties.networkOperatorChanged.operatorAccTech;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("networkOperatorChanged",this.mNetworkOperator));
            }
            if(bluetooth.getProperties.hasOwnProperty("networkRegistrationState"))
            {
               this.networkRegistrationState = bluetooth.getProperties.networkRegistrationState.state;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("networkRegistrationState",this.networkRegistrationState));
            }
            if(bluetooth.getProperties.hasOwnProperty("handsFreeMode"))
            {
               this.handsFreeMode = bluetooth.getProperties.handsFreeMode.hfMode;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("handsFreeMode",bluetooth.getProperties.handsFreeMode));
            }
            if(bluetooth.getProperties.hasOwnProperty("audioStatus"))
            {
               this.audioStatus = bluetooth.getProperties.audioStatus.audioStatus;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("audioStatus",bluetooth.getProperties.audioStatus));
            }
            if(bluetooth.getProperties.hasOwnProperty("signalQuality"))
            {
               this.mSignalQuality = bluetooth.getProperties.signalQuality.signalQuality;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("signalQuality",this.mSignalQuality));
            }
            if(bluetooth.getProperties.hasOwnProperty("batteryCharge"))
            {
               this.mBatteryCharge = bluetooth.getProperties.batteryCharge.batteryCharge;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("batteryCharge",this.batteryCharge));
            }
            if(bluetooth.getProperties.hasOwnProperty("subscriberNumber"))
            {
               this.mSubscriberNumber = bluetooth.getProperties.subscriberNumber.number;
            }
            if(bluetooth.getProperties.hasOwnProperty("siriStatus"))
            {
               this.mSiriStatusEnabled = bluetooth.getProperties.siriStatus.enabled;
               this.mSiriStatusAvailable = bluetooth.getProperties.siriStatus.available;
               if(this.mSiriStatusAvailable)
               {
                  if(!this.mSiriStatusEnabled)
                  {
                     this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("SiriStatus"));
                  }
               }
            }
         }
         else if(bluetooth.hasOwnProperty("acceptIncomingCall"))
         {
            rtnstr = bluetooth.acceptIncomingCall.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("acceptIncomingCallFail"));
               this.mReason = bluetooth.acceptIncomingCall.reason;
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("acceptIncomingCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("dial"))
         {
            rtnstr = bluetooth.dial.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.dial.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("dialFail"));
            }
            else
            {
               callId = int(bluetooth.dial.callId);
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("dialOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("reDial"))
         {
            rtnstr = bluetooth.reDial.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.reDial.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("dialFail"));
            }
            else
            {
               callId = int(bluetooth.reDial.callId);
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("dialOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("sendDtmfTone"))
         {
            rtnstr = bluetooth.sendDtmfTone.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("sendDtmfToneFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("sendDtmfToneOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("endCall"))
         {
            rtnstr = bluetooth.endCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.endCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("endActiveCall"))
         {
            rtnstr = bluetooth.endActiveCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.endActiveCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endActiveCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endActiveCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("endAllCalls"))
         {
            rtnstr = bluetooth.endAllCalls.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.endAllCalls.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endAllCallsFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("endAllCallsOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("rejectIncomingCall"))
         {
            rtnstr = bluetooth.rejectIncomingCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.rejectIncomingCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("rejectIncomingCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("rejectIncomingCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("holdActiveCall"))
         {
            rtnstr = bluetooth.holdActiveCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.holdActiveCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("holdActiveCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("holdActiveCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("resumeHeldCall"))
         {
            rtnstr = bluetooth.resumeHeldCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.resumeHeldCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("resumeHeldCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("resumeHeldCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("conferenceCall"))
         {
            rtnstr = bluetooth.conferenceCall.description;
            if(rtnstr != "success")
            {
               this.mReason = bluetooth.conferenceCall.reason;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("conferenceCallFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("conferenceCallOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("setMuteState"))
         {
            rtnstr = bluetooth.setMuteState.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("setMuteStateFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("setMuteStateOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("getMuteState"))
         {
            rtnstr = bluetooth.getMuteState.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("getMuteStateFail"));
            }
            else
            {
               this.muteState = bluetooth.getMuteState.muteState;
               if(this.isMuted == true)
               {
                  this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("muteStateOn"));
               }
               else
               {
                  this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("muteStateOff"));
               }
            }
         }
         else if(bluetooth.hasOwnProperty("setHfMode"))
         {
            rtnstr = bluetooth.setHfMode.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("setHfModeFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("setHfModeOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("swapCalls"))
         {
            rtnstr = bluetooth.swapCalls.description;
            if(rtnstr != "success")
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("swapCallsFail"));
            }
            else
            {
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("swapCallsOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("getNetworkRegistrationStatus"))
         {
            rtnstr = bluetooth.getNetworkRegistrationStatus.description;
            if(rtnstr == "success")
            {
               this.networkRegistrationState = bluetooth.getNetworkRegistrationStatus.state;
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("networkRegistrationState",this.networkRegistrationState));
            }
         }
         else if(bluetooth.hasOwnProperty("setDNDStatus"))
         {
            if("success" == bluetooth.setDNDStatus.description && 0 == bluetooth.setDNDStatus.code)
            {
               dispatchEvent(new BluetoothEvent(BluetoothEvent.DND_STATUS));
            }
            else
            {
               this.mDNDStatus = !this.mDNDStatus;
               dispatchEvent(new BluetoothEvent(BluetoothEvent.DND_STATUS));
            }
         }
         else if(bluetooth.hasOwnProperty("siriStatus"))
         {
            this.mSiriStatusEnabled = bluetooth.siriStatus.enabled;
            this.mSiriStatusAvailable = bluetooth.siriStatus.available;
         }
         else if(bluetooth.hasOwnProperty("callState"))
         {
            this.decodeCallState(bluetooth.callState);
         }
         else if(bluetooth.hasOwnProperty("signalQuality"))
         {
            this.mSignalQuality = bluetooth.signalQuality.rssi;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("signalQuality",this.mSignalQuality));
         }
         else if(bluetooth.hasOwnProperty("handsFreeMode"))
         {
            if(bluetooth.handsFreeMode.hfMode == true)
            {
            }
            this.handsFreeMode = bluetooth.handsFreeMode.hfMode;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("handsFreeMode",bluetooth.handsFreeMode));
         }
         else if(bluetooth.hasOwnProperty("audioStatus"))
         {
            this.audioStatus = bluetooth.audioStatus.status;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("audioStatus",bluetooth.audioStatus));
         }
         else if(bluetooth.hasOwnProperty("batteryCharge"))
         {
            this.batteryCharge = bluetooth.batteryCharge.level;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("batteryCharge",this.batteryCharge));
         }
         else if(bluetooth.hasOwnProperty("networkRegistrationState"))
         {
            this.networkRegistrationState = bluetooth.networkRegistrationState.state;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("networkRegistrationState",this.networkRegistrationState));
         }
         else if(bluetooth.hasOwnProperty("networkOperatorChanged"))
         {
            this.mNetworkOperator.code = bluetooth.networkOperatorChanged.operatorCode;
            this.mNetworkOperator.longName = bluetooth.networkOperatorChanged.operatorLongName;
            this.mNetworkOperator.shortName = bluetooth.networkOperatorChanged.operatorShortName;
            this.mNetworkOperator.mode = bluetooth.networkOperatorChanged.operatorMode;
            this.mNetworkOperator.ACCTech = bluetooth.networkOperatorChanged.operatorAccTech;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("networkOperatorChanged",this.mNetworkOperator));
         }
         else if(bluetooth.hasOwnProperty("supportedFeaturesList"))
         {
            this.mFeatures = bluetooth.supportedFeaturesList.features;
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("supportedFeaturesList",bluetooth.supportedFeaturesList));
         }
         else if(bluetooth.hasOwnProperty("phoneVrMode"))
         {
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("phoneVrMode",bluetooth.phoneVrMode));
         }
         else if(bluetooth.hasOwnProperty("smsBrowsingListSelection"))
         {
            body = bluetooth.smsBrowsingListSelection.smsBody;
            this.mMyTtsHMIDispatcher.readout("SMS",body);
         }
         else if(bluetooth.hasOwnProperty("write"))
         {
            if(bluetooth.write.res != "OK")
            {
            }
         }
         else if(bluetooth.hasOwnProperty("read"))
         {
            if(bluetooth.read.res != "Empty")
            {
               o = com.adobe.serialization.json.JSON.decode(bluetooth.read.res,false);
            }
         }
      }
      
      private function decodeCallState(callState:Object) : void
      {
         var cs:Object = null;
         var send:Boolean = false;
         var btc:BluetoothCall = null;
         for each(cs in callState.callStateInfo)
         {
            btc = this.getCall(cs.callId);
            if(null == btc)
            {
               send = true;
            }
            else if(btc.callState != cs.callState || btc.audio != cs.audio)
            {
               send = true;
            }
            this.updateCallState(cs.callId,cs.callState,cs.number == 0 ? null : cs.number,cs.name,cs.duration != null ? int(cs.duration) : 0,cs.audio != null ? Boolean(cs.audio) : false,cs.numberType);
         }
         if(send)
         {
            this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("callState"));
         }
      }
      
      private function onDisconnect(evt:BluetoothEvent) : void
      {
         this.mSignalQuality = -1;
         this.mIsMuted = false;
         this.mBatteryCharge = -1;
         this.mSiriStatusEnabled = false;
         this.mSiriStatusAvailable = false;
      }
      
      private function onCallerID(evt:PhoneBookEvent) : void
      {
         var call:BluetoothCall = null;
         var modCallNum:String = "";
         var modEvtNum:String = evt.m_data.phoneNumber;
         for each(call in this.mCalls)
         {
            modCallNum = call.number;
            if(10 < modCallNum.length)
            {
               modCallNum = modCallNum.slice(modCallNum.length - 10,modCallNum.length);
            }
            if(10 < modEvtNum.length)
            {
               modEvtNum = modEvtNum.slice(modEvtNum.length - 10,modEvtNum.length);
            }
            if(modCallNum == modEvtNum)
            {
               if("" == call.callerID || null == call.callerID)
               {
                  call.callerID = evt.m_data.formattedName;
               }
               this.mMyHMIDispatcher.dispatchEvent(new BluetoothEvent("CallerIdInfo"));
               break;
            }
         }
      }
      
      public function get subscriberNumber() : String
      {
         return this.mSubscriberNumber;
      }
   }
}

