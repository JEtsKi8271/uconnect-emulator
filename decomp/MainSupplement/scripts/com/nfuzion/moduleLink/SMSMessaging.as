package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ISMSMessaging;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.SMSMessage;
   import com.nfuzion.moduleLinkAPI.SMSMessageEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SMSMessaging extends Module implements ISMSMessaging
   {
      
      private static var instance:SMSMessaging;
      
      private static const DBUS_IDENTIFIER:String = "PimService";
      
      private static const DBUS_UISPEECH_ID:String = "UISpeechService";
      
      private static const DBUS_DATABASE_IDENTIFIER:String = "PhoneBook";
      
      private static const INBOX_CACHE_SIZE:int = 6;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mInboxMessageList:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
      
      private var mInboxPageOneList:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
      
      private var mInboxMessageListLength:int = -1;
      
      private var mInboxMessagePrevListLength:int = 0;
      
      private var mInboxMessageListStart:int = 0;
      
      private var mInboxMessageListNum:int = 0;
      
      private var mInboxMessageListReqNum:int = 0;
      
      private var mInboxMessageListReqIndex:int = 0;
      
      private var mCurrentSelectedMessageIndex:uint;
      
      private var mInboxRequestedCount:Boolean = false;
      
      private var mInboxRequestedList:Boolean = false;
      
      private var mInboxRequested:Boolean = false;
      
      private var mRequestedMessageID:String;
      
      private var mRequestedMessage:SMSMessage;
      
      private var mInboxIncomingMessageList:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
      
      private var mIncomingMessageID:String;
      
      private var mPromptIncomingName:String;
      
      private var mIncomingMessage:SMSMessage;
      
      private var mOutgoingMessageRecipientNumber:String;
      
      private var mOutgoingMessageRecipientName:String;
      
      private var mOutgoingMessageRecipientNumberType:String;
      
      private var mOutgoingMessageBody:String;
      
      private var mPlayingMessageID:String;
      
      private var mSMSSyncSupported:Boolean = false;
      
      private var mSMSSyncState:Boolean = false;
      
      private var mSendSupport:Boolean = false;
      
      private var mUnreadSMSCount:int = -1;
      
      private var mInboxUnreadMessageList:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
      
      private var mDNDBlockedSMSList:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
      
      private var mUnreadSMSCountPopup:int = -1;
      
      private var mVrDialogStatus:Boolean = false;
      
      private var mVrMode:Boolean = false;
      
      private var mReplyWithMessage:Boolean = false;
      
      private var mBlockedSMSCount:uint = 0;
      
      private var mBlockedSMSNumber:String = "";
      
      private var mDNDStatus:Boolean = false;
      
      private var mAutoReply:String = "call";
      
      private var mAutoReplyMessage:String = "default";
      
      private var mCustomMessage:String = "";
      
      private var mIsViewMessageActive:Boolean = false;
      
      private var mMessagesPendingSend:int = 0;
      
      private var mVrMessageListen:Boolean = false;
      
      private var mPreviousIncomingMessage:SMSMessage = null;
      
      private var mSyncError:Boolean = false;
      
      private var mActiveSIRISession:Boolean = false;
      
      private var mCurrentlyOpenedMessage:SMSMessage = null;
      
      private var mLastReceivedMessage:SMSMessage = null;
      
      private const MESSAGE_TIMEOUT:Number = 5000;
      
      private var mTimer:Timer = new Timer(this.MESSAGE_TIMEOUT);
      
      public function SMSMessaging()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.PIM_SERVICE,this.onConnectionMessage);
         this.connection.addEventListener(ConnectionEvent.BLUETOOTH_MANAGER,this.btMessageHandler);
         this.connection.addEventListener(ConnectionEvent.PHONEBOOK,this.onCustomMessage);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
         this.sendSubscribe("serviceDisconnected");
      }
      
      public static function getInstance() : SMSMessaging
      {
         if(instance == null)
         {
            instance = new SMSMessaging();
         }
         return instance;
      }
      
      public function get requestedMessage() : SMSMessage
      {
         return this.mRequestedMessage;
      }
      
      public function get promptIncomingName() : String
      {
         return this.mPromptIncomingName;
      }
      
      public function get incomingMessage() : SMSMessage
      {
         return this.mIncomingMessage;
      }
      
      public function set playingMessageID(playingID:String) : void
      {
         this.mPlayingMessageID = playingID;
      }
      
      public function get playingMessageID() : String
      {
         return this.mPlayingMessageID;
      }
      
      public function get isSendSupported() : Boolean
      {
         return this.mSendSupport;
      }
      
      public function get unreadSMSCount() : int
      {
         return this.mUnreadSMSCount;
      }
      
      public function get incomingMessageCount() : int
      {
         var pCount:int = 0;
         if(this.mIncomingMessage != null || this.mIncomingMessageID != null)
         {
            pCount++;
         }
         if(this.mInboxIncomingMessageList)
         {
            if(this.mIsViewMessageActive == true && pCount != 0)
            {
               pCount--;
            }
            pCount += this.mInboxIncomingMessageList.length;
         }
         return pCount;
      }
      
      public function checkViewMessageActive(active:Boolean = false) : void
      {
         this.mIsViewMessageActive = active;
      }
      
      public function get inboxMessageList() : Vector.<SMSMessage>
      {
         var offset:int = 0;
         if(this.mInboxMessageListReqIndex != this.mInboxMessageListStart)
         {
            offset = this.mInboxMessageListReqIndex - this.mInboxMessageListStart;
            if(offset >= 0)
            {
               return this.mInboxMessageList.slice(offset);
            }
         }
         return this.mInboxMessageList;
      }
      
      public function get inboxUnreadMessageList() : Vector.<SMSMessage>
      {
         return this.mInboxUnreadMessageList;
      }
      
      public function get inboxMessageListLength() : int
      {
         if(this.mInboxMessageListLength == -1)
         {
            return this.mInboxMessagePrevListLength;
         }
         this.mInboxMessagePrevListLength = this.mInboxMessageListLength;
         return this.mInboxMessageListLength;
      }
      
      public function set outgoingMessageRecipientPhoneNumber(phoneNumber:String) : void
      {
         if(this.isSendSupported == true)
         {
            this.mOutgoingMessageRecipientNumber = phoneNumber;
         }
      }
      
      public function get outgoingMessageRecipientPhoneNumber() : String
      {
         return this.mOutgoingMessageRecipientNumber;
      }
      
      public function set outgoingMessageRecipientPhoneNumberType(phoneNumberType:String) : void
      {
         if(true == this.isSendSupported)
         {
            this.mOutgoingMessageRecipientNumberType = phoneNumberType;
         }
      }
      
      public function get outgoingMessageRecipientPhoneNumberType() : String
      {
         return this.mOutgoingMessageRecipientNumberType;
      }
      
      public function set outgoingMessageRecipientName(recipientName:String) : void
      {
         if(this.isSendSupported == true)
         {
            this.mOutgoingMessageRecipientName = recipientName;
         }
      }
      
      public function get outgoingMessageRecipientName() : String
      {
         return this.mOutgoingMessageRecipientName;
      }
      
      public function set outgoingMessageBody(body:String) : void
      {
         if(this.isSendSupported == true)
         {
            this.mOutgoingMessageBody = body;
         }
      }
      
      public function get outgoingMessageBody() : String
      {
         return this.mOutgoingMessageBody;
      }
      
      public function get isSMSSupported() : Boolean
      {
         return this.mSMSSyncSupported;
      }
      
      public function get isSMSReady() : Boolean
      {
         return this.mSMSSyncState;
      }
      
      public function get isSMSDisabled() : Boolean
      {
         return this.mSyncError;
      }
      
      public function get isVrMessageListen() : Boolean
      {
         return this.mVrMessageListen;
      }
      
      public function set isVrMessageListen(messageListen:Boolean) : void
      {
         this.mVrMessageListen = messageListen;
      }
      
      public function CheckIsSMSSupported() : void
      {
         this.sendGetProperties("pimSupportedFeatures");
         this.sendGetProperties("pimObjectSyncState");
      }
      
      public function replyMessage() : void
      {
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_REPLY));
      }
      
      public function set vrDialogStatus(value:Boolean) : void
      {
         this.mVrDialogStatus = value;
         if(this.mIncomingMessage == null && this.mIncomingMessageID == null && false == this.mVrDialogStatus && this.mInboxIncomingMessageList.length > 0)
         {
            this.mIncomingMessage = this.mInboxIncomingMessageList.pop();
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE));
         }
      }
      
      public function requestInboxMessageList(index:int = 0, length:int = 0) : void
      {
         var i:* = 0;
         var message:Object = null;
         var upperIndex:int = this.mInboxMessageListStart + this.mInboxMessageListNum;
         if(this.mInboxRequestedList == true && index == this.mInboxMessageListReqIndex && this.mInboxMessageListReqNum >= length)
         {
            return;
         }
         this.mInboxMessageListReqIndex = index;
         this.mInboxMessageListReqNum = length;
         if(index == 0 && this.mInboxPageOneList.length >= length)
         {
            i = 0;
            this.mInboxMessageList.length = 0;
            this.mInboxMessageListStart = 0;
            while(i < length)
            {
               this.mInboxMessageList.push(this.mInboxPageOneList[i++]);
            }
            this.mInboxMessageListNum = this.mInboxMessageList.length;
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_MESSAGE_LIST));
            return;
         }
         if(index < this.mInboxMessageListStart || index > upperIndex || index + length > upperIndex)
         {
            this.mInboxMessageListNum = 0;
            this.mInboxMessageListStart = index;
            message = {
               "Type":"Command",
               "Dest":DBUS_IDENTIFIER,
               "packet":{"getSMSList":{
                  "startSMSFrom":index,
                  "type":"inbox",
                  "numSMS":length
               }}
            };
            this.connection.send(message);
            this.mInboxRequestedList = true;
         }
         else
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_MESSAGE_LIST));
         }
      }
      
      public function requestUnreadSMSList(index:int = 0, length:int = 0) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_IDENTIFIER,
            "packet":{"getUnreadSMSList":{
               "startSMSFrom":index,
               "type":"inbox",
               "numSMS":length
            }}
         };
         this.connection.send(message);
      }
      
      public function forceInboxMessageListLength() : void
      {
         this.mInboxRequestedCount = true;
         this.sendCommand("getSMSCount","type","inbox");
      }
      
      public function requestUnreadSMSCount() : void
      {
         this.sendCommand("getUnreadSMSCount","","");
      }
      
      public function requestInboxMessageListLength() : void
      {
         if(!this.mInboxRequestedCount)
         {
            if(this.mInboxMessageListLength >= 0)
            {
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH));
            }
            else
            {
               this.mInboxMessageListStart = 0;
               this.mInboxMessageListNum = 0;
               this.mInboxRequestedCount = true;
               this.sendCommand("getSMSCount","type","inbox");
            }
         }
      }
      
      public function startSMSDictation(messageType:String, isPhoneNumSelected:Boolean) : void
      {
         var message:String = null;
         var id:String = DBUS_UISPEECH_ID;
         var commandName:String = "launchSMSDictation";
         message = "{\"Type\":\"EmitVRSignal\",  \"packet\": { \"" + commandName + "\": { \"smsType\": \"" + messageType + "\",\"" + "phoneNumberSelected\": " + isPhoneNumSelected + "}}}";
         this.client.send(message);
      }
      
      public function startSMSForwardDictation() : void
      {
         var message:String = null;
         message = "{\"Type\":\"EmitVRSignal\", \"packet\": { \"forwardSMS\" : {}}}";
         this.client.send(message);
      }
      
      public function requestMessage(id:String) : void
      {
         this.mRequestedMessageID = id;
         this.sendCommand("getNewSMS","UID",id);
      }
      
      private function processOutgoingNumber(number:String) : String
      {
         var i:int = 0;
         var newNum:String = null;
         if(number.indexOf("@") > 0)
         {
            return number;
         }
         i = 0;
         newNum = "";
         while(i < number.length)
         {
            switch(number.charAt(i))
            {
               case "0":
               case "1":
               case "2":
               case "3":
               case "4":
               case "5":
               case "6":
               case "7":
               case "8":
               case "9":
               case "#":
               case "*":
               case "+":
                  newNum += number.charAt(i);
            }
            i++;
         }
         if(newNum.length == 0)
         {
            newNum = number;
         }
         return newNum;
      }
      
      public function sendOutgoingMessage() : Boolean
      {
         var preProcessedOutgoingNumber:String = null;
         var message:Object = null;
         var hasOutgoingMessage:Boolean = false;
         if(this.isSendSupported == true && this.mOutgoingMessageRecipientNumber != null && this.mOutgoingMessageBody != null)
         {
            preProcessedOutgoingNumber = this.processOutgoingNumber(this.mOutgoingMessageRecipientNumber);
            hasOutgoingMessage = true;
            this.mTimer.start();
            message = {
               "Type":"Command",
               "Dest":DBUS_IDENTIFIER,
               "packet":{"sendSms":{
                  "destNumber":preProcessedOutgoingNumber,
                  "body":this.mOutgoingMessageBody
               }}
            };
            this.connection.send(message);
            this.mMessagesPendingSend += 1;
         }
         if(true == hasOutgoingMessage)
         {
            this.clearOutgoingMessage();
         }
         return hasOutgoingMessage;
      }
      
      public function clearOutgoingMessage() : void
      {
         this.mOutgoingMessageBody = null;
         this.mOutgoingMessageRecipientName = null;
         this.mOutgoingMessageRecipientNumber = null;
      }
      
      public function clearIncomingMessage(all:Boolean = false, getNext:Boolean = true) : void
      {
         if(this.mIncomingMessage != null)
         {
            this.mPreviousIncomingMessage = this.mIncomingMessage;
         }
         this.mIncomingMessage = null;
         this.mIncomingMessageID = null;
         if(all)
         {
            this.mInboxIncomingMessageList.length = 0;
         }
         if(getNext == true)
         {
            if(this.mInboxIncomingMessageList.length > 0)
            {
               this.mIncomingMessage = this.mInboxIncomingMessageList.pop();
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE,"pendingNewSMS"));
            }
         }
      }
      
      public function emitSmsVRResponse(context:Number, status:String, isAvail:Object = null, phoneNum:String = null, shown:Object = null, sender:Object = null, contactType:Object = null) : void
      {
         var message:Object = null;
         if(null != isAvail)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":context,
                  "response":{
                     "result":status,
                     "available":isAvail
                  }
               }}
            };
         }
         else if(null != sender)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":context,
                  "response":{
                     "result":status,
                     "phoneNumber":phoneNum,
                     "senderName":sender,
                     "phoneCategory":contactType
                  }
               }}
            };
         }
         else if(null != phoneNum)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":context,
                  "response":{
                     "result":status,
                     "phoneNumber":phoneNum
                  }
               }}
            };
         }
         else if(null != shown)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":context,
                  "response":{
                     "result":status,
                     "messageShown":shown
                  }
               }}
            };
         }
         else
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":context,
                  "response":{"result":status}
               }}
            };
         }
         this.connection.send(message);
      }
      
      public function smsReadStatus(id:String) : void
      {
         var smsMessage:SMSMessage = null;
         var unreadNewMessage:SMSMessage = null;
         var k:int = 0;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_IDENTIFIER,
            "packet":{"setSMSReadStatus":{
               "messageUID":id,
               "status":"read"
            }}
         };
         this.connection.send(message);
         var i:int = 0;
         while(i < this.mInboxMessageList.length)
         {
            smsMessage = this.mInboxMessageList[i];
            if(smsMessage.id == id)
            {
               smsMessage.isRead = true;
            }
            i++;
         }
         var j:int = 0;
         var temp:Vector.<SMSMessage> = new Vector.<SMSMessage>([]);
         temp.length = 0;
         while(j < this.mInboxUnreadMessageList.length)
         {
            unreadNewMessage = new SMSMessage();
            unreadNewMessage = this.mInboxUnreadMessageList[j];
            if(unreadNewMessage.id != id)
            {
               temp.push(unreadNewMessage);
            }
            j++;
         }
         this.mInboxUnreadMessageList = temp;
         if(this.mBlockedSMSCount > 0)
         {
            for(k = 0; k < this.mDNDBlockedSMSList.length; k++)
            {
               if(this.mDNDBlockedSMSList[k].id == id)
               {
                  --this.mBlockedSMSCount;
               }
            }
         }
      }
      
      public function isValidNumber(number:String) : Boolean
      {
         for(var i:int = 0; i < number.length - 1; i++)
         {
            switch(number.charAt(i))
            {
               case "0":
               case "1":
               case "2":
               case "3":
               case "4":
               case "5":
               case "6":
               case "7":
               case "8":
               case "9":
               case "+":
                  break;
               default:
                  return false;
            }
         }
         return true;
      }
      
      public function emitNewSMSPopupStatus(status:Boolean) : void
      {
         var message:Object = null;
         message = {
            "Type":"EmitSignal",
            "packet":{"hmiPhoneStatus":{"newSmsPopup":{"active":status}}}
         };
         this.connection.send(message);
      }
      
      public function emitViewSMSPopusStatus(status:Boolean) : void
      {
         var message:Object = null;
         message = {
            "Type":"EmitSignal",
            "packet":{"hmiPhoneStatus":{"viewSmsPopup":{"active":status}}}
         };
         this.connection.send(message);
      }
      
      private function set newSMS(eventObj:Object) : void
      {
         var smsObject:Object = null;
         var temp:SMSMessage = null;
         if(this.mSMSSyncState == true)
         {
            smsObject = eventObj.message;
            temp = new SMSMessage();
            temp.id = smsObject.uid_messageId;
            temp.from = smsObject.smsName;
            temp.body = smsObject.smsBody;
            temp.date = smsObject.localTimeStamp;
            temp.isRead = smsObject.smsReadStatus;
            temp.phoneNumber = smsObject.smsFrom;
            temp.phoneNumberType = smsObject.numberType;
            this.mInboxUnreadMessageList.push(temp);
            if(this.mDNDStatus)
            {
               this.mDNDBlockedSMSList.push(temp);
               this.mBlockedSMSCount += 1;
               this.mBlockedSMSNumber = eventObj.message.smsFrom;
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SEND_AUTO_REPLY_FOR_SMS));
               return;
            }
            this.mInboxIncomingMessageList.unshift(temp);
            this.mPromptIncomingName = null != smsObject.smsName && "" != smsObject.smsName ? smsObject.smsName : smsObject.smsFrom;
            if(this.mIncomingMessage == null && this.mIncomingMessageID == null && false == this.mVrDialogStatus)
            {
               this.mIncomingMessage = new SMSMessage();
               if(this.mIsViewMessageActive != true)
               {
                  this.mIncomingMessage = this.mInboxIncomingMessageList.pop();
               }
               if(false == this.mVrMode)
               {
                  dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE));
               }
               else
               {
                  this.mActiveSIRISession = true;
               }
            }
            else if(this.mIncomingMessage != null && false == this.mVrMode)
            {
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE));
            }
            else
            {
               this.mActiveSIRISession = true;
            }
         }
      }
      
      private function set getNewSMS(eventObj:Object) : void
      {
         var smsObject:Object = null;
         var id:String = null;
         if(eventObj.code == 51)
         {
            return;
         }
         if(Boolean(eventObj.smsList) && eventObj.smsList.length > 0)
         {
            smsObject = eventObj.smsList[0];
            if(smsObject.uid_messageId == this.mIncomingMessageID)
            {
               if(this.mIncomingMessageID == this.mRequestedMessageID)
               {
                  this.mRequestedMessageID = null;
               }
               this.mIncomingMessageID = null;
               this.mIncomingMessage = new SMSMessage();
               this.mIncomingMessage.id = smsObject.uid_messageId;
               this.mIncomingMessage.from = smsObject.smsName;
               this.mIncomingMessage.body = smsObject.smsBody;
               this.mIncomingMessage.date = smsObject.localTimeStamp;
               this.mIncomingMessage.isRead = smsObject.smsReadStatus;
               this.mIncomingMessage.phoneNumber = smsObject.smsFrom;
               this.mIncomingMessage.phoneNumberType = smsObject.numberType;
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE));
            }
            else if(smsObject.uid_messageId == this.mRequestedMessageID)
            {
               this.mRequestedMessageID = null;
               this.mRequestedMessage = new SMSMessage();
               this.mRequestedMessage.id = smsObject.uid_messageId;
               this.mRequestedMessage.from = smsObject.smsName;
               this.mRequestedMessage.body = smsObject.smsBody;
               this.mRequestedMessage.date = smsObject.localTimeStamp;
               this.mRequestedMessage.isRead = smsObject.smsReadStatus;
               this.mRequestedMessage.phoneNumber = smsObject.smsFrom;
               this.mRequestedMessage.phoneNumberType = smsObject.numberType;
               if(false == smsObject.smsReadStatus)
               {
                  id = String(smsObject.uid_messageId);
                  this.smsReadStatus(id);
               }
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.REQUESTED_MESSAGE));
            }
         }
         this.requestInboxMessageListLength();
      }
      
      private function set getUnreadSMSCount(eventObj:Object) : void
      {
         if("success" == eventObj.description && 0 == eventObj.code)
         {
            this.mUnreadSMSCount = eventObj.smsCount;
         }
      }
      
      private function set getSMSCount(eventObj:Object) : void
      {
         this.mInboxRequestedCount = false;
         if(eventObj.code == 51)
         {
            return;
         }
         if(eventObj.smsCount >= 0)
         {
            if(this.mInboxMessagePrevListLength == 0)
            {
               this.mInboxMessagePrevListLength = this.mInboxMessageListLength;
            }
            this.mInboxMessageListLength = eventObj.smsCount;
            this.mInboxMessageListReqIndex = 0;
            this.mInboxMessageListReqNum = this.mInboxMessageListLength > INBOX_CACHE_SIZE ? INBOX_CACHE_SIZE : this.mInboxMessageListLength;
            if(this.mInboxMessageListReqNum > 0)
            {
               this.mInboxPageOneList.length = 0;
               this.requestInboxMessageList(0,this.mInboxMessageListReqNum);
            }
         }
         else
         {
            this.mInboxMessageListLength = -1;
         }
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH));
      }
      
      private function set getSMSList(eventObj:Object) : void
      {
         var smsList:Array = null;
         var smsListObj:Object = null;
         var smsMessage:SMSMessage = null;
         var smsCachePageOne:Boolean = false;
         var i:int = 0;
         this.mInboxRequestedList = false;
         if(eventObj.smsList)
         {
            smsList = eventObj.smsList;
            smsCachePageOne = false;
            this.mInboxMessageList.length = 0;
            if(this.mInboxMessageListStart == 0)
            {
               smsCachePageOne = true;
            }
            i = 0;
            while(i < smsList.length)
            {
               smsListObj = smsList[i];
               smsMessage = new SMSMessage();
               smsMessage.id = smsListObj.uid_messageId;
               smsMessage.body = smsListObj.smsBody;
               smsMessage.from = smsListObj.smsName;
               smsMessage.phoneNumber = smsListObj.smsFrom;
               smsMessage.isRead = smsListObj.smsReadStatus;
               smsMessage.date = smsListObj.localTimeStamp;
               smsMessage.phoneNumberType = smsListObj.numberType;
               this.mInboxMessageList.push(smsMessage);
               if(smsCachePageOne)
               {
                  this.mInboxPageOneList.push(smsMessage);
               }
               i++;
            }
            this.mInboxMessageListNum = i;
         }
         else
         {
            this.mInboxMessageList = Vector.<SMSMessage>([]);
            this.mInboxMessageListNum = 0;
            this.mInboxMessageListStart = 0;
         }
         if(this.mInboxMessageListNum < this.mInboxMessageListReqNum)
         {
            this.mInboxMessageListLength = this.mInboxMessageListReqIndex + this.mInboxMessageListNum;
            if(this.mInboxMessageListLength > 0)
            {
               this.forceInboxMessageListLength();
            }
         }
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_MESSAGE_LIST));
      }
      
      private function set getUnreadSMSList(eventObj:Object) : void
      {
         var unreadSmsList:Array = null;
         var unreadSmsListObj:Object = null;
         var unreadSmsMessage:SMSMessage = null;
         var i:int = 0;
         if(eventObj.smsList)
         {
            unreadSmsList = eventObj.smsList;
            this.mInboxUnreadMessageList.length = 0;
            i = 0;
            while(i < unreadSmsList.length)
            {
               unreadSmsListObj = unreadSmsList[i];
               unreadSmsMessage = new SMSMessage();
               unreadSmsMessage.id = unreadSmsListObj.uid_messageId;
               unreadSmsMessage.body = unreadSmsListObj.smsBody;
               unreadSmsMessage.from = unreadSmsListObj.smsName;
               unreadSmsMessage.phoneNumber = unreadSmsListObj.smsFrom;
               unreadSmsMessage.isRead = unreadSmsListObj.smsReadStatus;
               unreadSmsMessage.date = unreadSmsListObj.localTimeStamp;
               unreadSmsMessage.phoneNumberType = unreadSmsListObj.numberType;
               this.mInboxUnreadMessageList.push(unreadSmsMessage);
               i++;
            }
         }
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INBOX_UNREAD_MESSAGE_LIST));
      }
      
      private function set sendSms(eventObj:Object) : void
      {
         if(eventObj.description == "success")
         {
            this.clearOutgoingMessage();
         }
         else if("failure" == eventObj.description)
         {
            this.mTimer.reset();
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_SEND_ERROR));
         }
      }
      
      private function set setSMSReadStatus(eventObj:Object) : void
      {
         if(eventObj.description == "success")
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_READ_STATUS_SUCCESS));
         }
         else
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_READ_STATUS_ERROR));
         }
      }
      
      private function set smsServiceStatus(eventObj:Object) : void
      {
         if(eventObj.available == "false")
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_NOT_SUPPORTED_ERROR));
         }
      }
      
      private function set pimObjectBackGndSyncInfo(eventObj:Object) : void
      {
         if(eventObj.objectType == "SMS")
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_BKGND_SYNC));
         }
      }
      
      private function set pimSupportedFeatures(eventObj:Object) : void
      {
         if(eventObj.objectType == "SMS")
         {
            if(eventObj.syncSupport == "yes")
            {
               this.mSMSSyncSupported = true;
            }
            else
            {
               this.mSMSSyncSupported = false;
               this.resetSMSState();
            }
            if(eventObj.sendSupport == "no")
            {
               this.mSendSupport = false;
            }
            else
            {
               this.mSendSupport = true;
            }
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_FEATURE_SUPPORT));
         }
      }
      
      private function set pimObjectSyncState(eventObj:Object) : void
      {
         if(eventObj.hasOwnProperty("objectType") && eventObj.objectType == "SMS")
         {
            if("syncComplete" == eventObj.syncStatus)
            {
               this.sendGetProperties("pimSupportedFeatures");
               this.mSMSSyncState = true;
               this.mInboxMessageListLength = -1;
               if(this.mIncomingMessageID != null)
               {
                  this.requestMessage(this.mIncomingMessageID);
               }
               else if(this.mRequestedMessageID != null)
               {
                  this.requestMessage(this.mRequestedMessageID);
               }
               else
               {
                  this.requestInboxMessageListLength();
               }
            }
            else
            {
               if("syncError" == eventObj.syncStatus)
               {
                  this.mSyncError = true;
               }
               this.resetSMSState(eventObj.syncStatus);
            }
            if(!this.mDNDStatus)
            {
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_SYNC_STATE));
            }
         }
      }
      
      private function set getProperties(eventObj:Object) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(eventObj.hasOwnProperty("pimSupportedFeatures"))
         {
            for(i = 0; i < eventObj.pimSupportedFeatures.length; i++)
            {
               if(eventObj.pimSupportedFeatures[i].objectType == "SMS")
               {
                  if(eventObj.pimSupportedFeatures[i].syncSupport == "yes")
                  {
                     this.mSMSSyncSupported = true;
                  }
                  else
                  {
                     this.mSMSSyncSupported = false;
                     this.resetSMSState();
                  }
                  if(eventObj.pimSupportedFeatures[i].sendSupport == "no")
                  {
                     this.mSendSupport = false;
                  }
                  else
                  {
                     this.mSendSupport = true;
                  }
                  dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_FEATURE_SUPPORT));
               }
            }
         }
         if(eventObj.hasOwnProperty("pimObjectSyncState"))
         {
            for(j = 0; j < eventObj.pimObjectSyncState.length; j++)
            {
               if(eventObj.pimObjectSyncState[j].objectType == "sms")
               {
                  if("syncComplete" == eventObj.pimObjectSyncState[j].syncState)
                  {
                     this.mSMSSyncState = true;
                  }
                  else
                  {
                     if("syncError" == eventObj.pimObjectSyncState[j].syncState)
                     {
                        this.mSyncError = true;
                     }
                     this.resetSMSState(eventObj.pimObjectSyncState[j].syncState);
                  }
                  if(!this.mDNDStatus)
                  {
                     dispatchEvent(new SMSMessageEvent(SMSMessageEvent.SMS_SYNC_STATE));
                  }
               }
            }
         }
      }
      
      private function set sentMessageStatus(eventObj:Object) : void
      {
         this.mTimer.reset();
         if(this.mMessagesPendingSend > 0)
         {
            --this.mMessagesPendingSend;
            if("SENDING_SUCCESS" == eventObj.notificationType || "DELIVERY_SUCCESS" == eventObj.notificationType)
            {
               this.clearOutgoingMessage();
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_SEND_SUCCESS));
            }
            else if("SENDING_FAILURE" == eventObj.notificationType || "DELIVERY_FAILURE" == eventObj.notificationType)
            {
               dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_SEND_ERROR));
            }
         }
      }
      
      private function onTimeout(evt:TimerEvent) : void
      {
         this.mTimer.reset();
         if(this.mMessagesPendingSend > 0)
         {
            --this.mMessagesPendingSend;
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.MESSAGE_SEND_SUCCESS));
         }
      }
      
      private function resetSMSState(syncState:String = "") : void
      {
         this.mSMSSyncState = false;
         this.mInboxMessageListNum = 0;
         this.mInboxMessageListStart = 0;
         this.mInboxMessageListLength = -1;
         this.mMessagesPendingSend = 0;
         this.mVrMessageListen = false;
         if(syncState == "syncNotStarted")
         {
            this.mIncomingMessage = null;
            this.mPreviousIncomingMessage = null;
            this.mIncomingMessageID = null;
            this.mInboxIncomingMessageList.length = 0;
            this.mInboxPageOneList.length = 0;
            this.mSendSupport = false;
            this.mSyncError = false;
         }
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendCommandToId(DBUS_IDENTIFIER,commandName,valueName,value,addQuotesOnValue);
      }
      
      private function sendCommandToId(id:String, commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      protected function sendGetProperties(value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendGetPropertiesToId(DBUS_IDENTIFIER,value,addQuotesOnValue);
      }
      
      protected function sendGetPropertiesToId(id:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "properties" + "\": [\"" + value + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendGetAllPropertiesToId(id:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getAllProperties" + "\" }}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_IDENTIFIER + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + DBUS_IDENTIFIER + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendSubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function onConnectionMessage(e:ConnectionEvent) : void
      {
         var property:String = null;
         var obj:Object = e.data;
         for(property in obj)
         {
            switch(property)
            {
               case "newSMS":
               case "getNewSMS":
               case "getUnreadSMSCount":
               case "getSMSCount":
               case "getSMSList":
               case "getUnreadSMSList":
               case "sendSms":
               case "setSMSReadStatus":
               case "smsServiceStatus":
               case "pimObjectBackGndSyncInfo":
               case "pimSupportedFeatures":
               case "pimObjectSyncState":
               case "getProperties":
               case "sentMessageStatus":
                  this[property] = obj[property];
            }
         }
      }
      
      private function onCustomMessage(e:ConnectionEvent) : void
      {
         var data:Object = e.data;
         if(data.hasOwnProperty("getItems"))
         {
            if(null != data.getItems.result && "" != data.getItems.result)
            {
               if(Boolean(data.getItems.result[0].hasOwnProperty("smsTemplateId")) && Boolean(100 == data.getItems.result[0].smsTemplateId) && data.getItems.result[0].smsBody != "NULL")
               {
                  this.mCustomMessage = data.getItems.result[0].smsBody;
               }
            }
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case SMSMessageEvent.INCOMING_MESSAGE:
               addInterest(SMSMessageEvent.REQUESTED_MESSAGE);
               this.sendSubscribe("newSMS");
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST:
               this.sendSubscribe("getSMSList");
               break;
            case SMSMessageEvent.INBOX_UNREAD_MESSAGE_LIST:
               this.sendSubscribe("getUnreadSMSList");
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH:
               this.sendSubscribe("getSMSCount");
               break;
            case SMSMessageEvent.REQUESTED_MESSAGE:
               this.sendSubscribe("getNewSMS");
               break;
            case SMSMessageEvent.MESSAGE_SEND_SUCCESS:
            case SMSMessageEvent.MESSAGE_SEND_ERROR:
               this.sendSubscribe("sendSms");
               this.sendSubscribe("sentMessageStatus");
               break;
            case SMSMessageEvent.MESSAGE_READ_STATUS_SUCCESS:
            case SMSMessageEvent.MESSAGE_READ_STATUS_ERROR:
               this.sendSubscribe("setSMSReadStatus");
               break;
            case SMSMessageEvent.SMS_NOT_SUPPORTED_ERROR:
               this.sendSubscribe("smsServiceStatus");
               break;
            case SMSMessageEvent.SMS_BKGND_SYNC:
               this.sendSubscribe("pimObjectBackGndSyncInfo");
               break;
            case SMSMessageEvent.SMS_FEATURE_SUPPORT:
               this.sendSubscribe("pimSupportedFeatures");
               break;
            case SMSMessageEvent.SMS_SYNC_STATE:
               this.sendSubscribe("pimObjectSyncState");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case SMSMessageEvent.INCOMING_MESSAGE:
               removeInterest(SMSMessageEvent.REQUESTED_MESSAGE);
               this.sendUnsubscribe("newSMS");
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST:
               this.sendUnsubscribe("getSMSList");
               break;
            case SMSMessageEvent.INBOX_UNREAD_MESSAGE_LIST:
               this.sendUnsubscribe("getUnreadSMSList");
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH:
               this.sendUnsubscribe("getSMSCount");
               break;
            case SMSMessageEvent.REQUESTED_MESSAGE:
               this.sendUnsubscribe("getNewSMS");
               break;
            case SMSMessageEvent.MESSAGE_SEND_SUCCESS:
            case SMSMessageEvent.MESSAGE_SEND_ERROR:
               this.sendUnsubscribe("sendSms");
               this.sendUnsubscribe("sentMessageStatus");
               break;
            case SMSMessageEvent.MESSAGE_READ_STATUS_SUCCESS:
            case SMSMessageEvent.MESSAGE_READ_STATUS_ERROR:
               this.sendUnsubscribe("setSMSReadStatus");
               break;
            case SMSMessageEvent.SMS_NOT_SUPPORTED_ERROR:
               this.sendUnsubscribe("smsServiceStatus");
               break;
            case SMSMessageEvent.SMS_BKGND_SYNC:
               this.sendUnsubscribe("pimObjectBackGndSyncInfo");
               break;
            case SMSMessageEvent.SMS_FEATURE_SUPPORT:
               this.sendUnsubscribe("pimSupportedFeatures");
               break;
            case SMSMessageEvent.SMS_SYNC_STATE:
         }
      }
      
      private function btMessageHandler(e:ConnectionEvent) : void
      {
         var bluetooth:Object = e.data;
         if(bluetooth.hasOwnProperty("serviceDisconnected") && bluetooth.serviceDisconnected.service == "HFPGW")
         {
            this.mIncomingMessageID = null;
            this.mRequestedMessageID = null;
            this.mBlockedSMSCount = 0;
            while(this.mInboxUnreadMessageList.length > 0)
            {
               this.mInboxUnreadMessageList.pop();
            }
            while(this.mDNDBlockedSMSList.length > 0)
            {
               this.mDNDBlockedSMSList.pop();
            }
            this.resetSMSState("syncNotStarted");
         }
      }
      
      public function set vrMode(vrm:Boolean) : void
      {
         this.mVrMode = vrm;
         if(null != this.mIncomingMessage && false == this.mVrMode && true == this.mActiveSIRISession)
         {
            dispatchEvent(new SMSMessageEvent(SMSMessageEvent.INCOMING_MESSAGE));
            this.mActiveSIRISession = false;
         }
      }
      
      public function set replyWithMessage(rwm:Boolean) : void
      {
         this.mReplyWithMessage = rwm;
      }
      
      public function get replyWithMessage() : Boolean
      {
         return this.mReplyWithMessage;
      }
      
      public function set blockedSMSCount(bsc:uint) : void
      {
         this.mBlockedSMSCount = bsc;
      }
      
      public function get blockedSMSCount() : uint
      {
         return this.mBlockedSMSCount;
      }
      
      public function set blockedSMSNumber(bsn:String) : void
      {
         this.mBlockedSMSNumber = bsn;
      }
      
      public function get blockedSMSNumber() : String
      {
         return this.mBlockedSMSNumber;
      }
      
      public function set DNDStatus(dndStatus:Boolean) : void
      {
         while(this.mDNDBlockedSMSList.length > 0)
         {
            this.mDNDBlockedSMSList.pop();
         }
         this.mDNDStatus = dndStatus;
      }
      
      public function get DNDStatus() : Boolean
      {
         return this.mDNDStatus;
      }
      
      public function set autoReply(ar:String) : void
      {
         this.mAutoReply = ar;
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.AUTO_REPLY));
      }
      
      public function get autoReply() : String
      {
         return this.mAutoReply;
      }
      
      public function set autoReplyMessage(arm:String) : void
      {
         this.mAutoReplyMessage = arm;
         dispatchEvent(new SMSMessageEvent(SMSMessageEvent.AUTO_REPLY_MESSAGE));
      }
      
      public function get autoReplyMessage() : String
      {
         return this.mAutoReplyMessage;
      }
      
      public function get customMessage() : String
      {
         return this.mCustomMessage;
      }
      
      public function set customMessage(cm:String) : void
      {
         this.mCustomMessage = cm;
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_DATABASE_IDENTIFIER,
            "packet":{"updateItems":{
               "database":"sms",
               "fieldsList":[{
                  "smsBody":this.mCustomMessage,
                  "smsTemplateId":100
               }]
            }}
         };
         this.connection.send(message);
      }
      
      public function get previousIncomingMessage() : SMSMessage
      {
         return this.mPreviousIncomingMessage;
      }
      
      public function set previousIncomingMessage(msg:SMSMessage) : void
      {
         this.mPreviousIncomingMessage = msg;
      }
      
      public function get currentlyOpenedMessage() : SMSMessage
      {
         return this.mCurrentlyOpenedMessage;
      }
      
      public function set currentlyOpenedMessage(openedMessage:SMSMessage) : void
      {
         this.mCurrentlyOpenedMessage = openedMessage;
      }
      
      public function get currentSelectedMessageIndex() : uint
      {
         return this.mCurrentSelectedMessageIndex;
      }
      
      public function set currentSelectedMessageIndex(MessageIndex:uint) : void
      {
         this.mCurrentSelectedMessageIndex = MessageIndex;
      }
      
      public function get lastMessageReceived() : SMSMessage
      {
         if(this.mInboxIncomingMessageList.length > 0)
         {
            return this.mLastReceivedMessage = this.mInboxIncomingMessageList[0];
         }
         return null;
      }
   }
}

