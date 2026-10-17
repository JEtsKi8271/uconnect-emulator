package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.TunerSeek;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.ISWCEvent;
   import com.nfuzion.moduleLinkAPI.PhoneBookEvent;
   import com.nfuzion.moduleLinkAPI.PhoneCallListEvent;
   import com.nfuzion.moduleLinkAPI.SMSMessage;
   import com.nfuzion.moduleLinkAPI.SMSMessageEvent;
   import com.nfuzion.moduleLinkAPI.TextToSpeechEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import core.enums.PopupType;
   import core.utils.Text;
   import flash.events.EventDispatcher;
   import locale.T;
   
   public class SMSManager extends EventDispatcher
   {
      
      private const PRE_DEFINED_MESSAGE:String = "predefined";
      
      private const DICTATED_MESSAGE:String = "dictated";
      
      private const SMS_POPUPS_TIMEOUT:uint = 5000;
      
      private const SMS_ITEM_PER_PAGE:uint = 6;
      
      private const VR_REQUEST_NONE:uint = 0;
      
      private const VR_VIEW_SINGLE_MSG:uint = 1;
      
      private const VR_PLAY_SINGLE_MSG:uint = 2;
      
      private const VR_PLAY_ALL_NEW_MSG:uint = 3;
      
      private const preDefinedVRMessages:Vector.<String> = new <String>["yes","no","okay","iCantTalkRightNow","callMe","iWillCallYourLater","iAmOnMyWay","thanks","iWillBeLate","iWillBeXMinsLate","seeYouInXMinutes","stuckInTraffic","startWithoutMe","whereAreYou","areYourThereYet","iNeedDirections","iAmLost","seeYouLater"];
      
      private const mNewMessageListData:Vector.<Object> = Vector.<Object>([{"body":T.STRB_SMS_YES},{"body":T.STRB_SMS_NO},{"body":T.STRB_SMS_OKAY},{"body":T.STRB_SMS_CAN_NOT_TALK},{"body":T.STRB_SMS_CALL_ME},{"body":T.STRB_SMS_CALL_YOU_LATER},{"body":T.STRB_SMS_ON_MY_WAY},{"body":T.STRB_SMS_THANKS},{"body":T.STRB_SMS_WILL_BE_LATE},{
         "body":T.STRB_SMS_MINUTES_LATE,
         "requiresWillBeLateNumber":true
      },{
         "body":T.STRB_SMS_SEE_YOU_IN_MINUTES,
         "requiresSeeYouInNumber":true
      },{"body":T.STRB_SMS_STUCK},{"body":T.STRB_SMS_START_WITHOUT_ME},{"body":T.STRB_SMS_WHERE_ARE_YOU},{"body":T.STRB_SMS_THERE_YET},{"body":T.STRB_SMS_NEED_DIRECTIONS},{"body":T.STRB_SMS_LOST},{"body":T.STRB_SMS_LATER}]);
      
      private var mVRDialogActive:Boolean = false;
      
      private var mIncomingSMSPending:Boolean = false;
      
      private var mVRResponseSentForAllNew:Boolean = false;
      
      private var mDtmfToneReceivedThroughVR:Boolean = false;
      
      private var mDNDAutoreplyMessage:Boolean = false;
      
      private var mMethodName:String = "";
      
      private var mMessageID:String;
      
      private var mMessage:SMSMessage = null;
      
      private var mContext:int = 0;
      
      private var mVRRequestState:uint = 0;
      
      private var mMessageIndexToPlay:int = 0;
      
      private var mMsgIndexRelativeToCurPage:int = 0;
      
      private var mPlayingAllNewMessagesStartNum:int = -1;
      
      private var mMessagesToPlay:Vector.<int> = new Vector.<int>();
      
      private var mAllNewMessage:Vector.<SMSMessage> = new Vector.<SMSMessage>();
      
      private var mGetReplyWithMessage:Boolean = false;
      
      private var mGetAutoReply:String = "";
      
      private var mGetAutoReplyMessage:String = "";
      
      private var mPlayingFromCurrentPopup:Boolean = false;
      
      private var mLastReceivedMessage:SMSMessage = null;
      
      private var mListenSMSID:String = "";
      
      public function SMSManager()
      {
         super();
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.INCOMING_MESSAGE,this.onIncomingSMSMessage,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH,this.onSMSMessageEvent,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.SMS_FEATURE_SUPPORT,this.onSMSMessageEvent,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.INBOX_MESSAGE_LIST,this.onSMSMessageEvent,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.INBOX_UNREAD_MESSAGE_LIST,this.onSMSMessageEvent,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.MESSAGE_SEND_SUCCESS,this.onMessageSendSuccess,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.MESSAGE_SEND_ERROR,this.onMessageSendError,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.SMS_SYNC_STATE,this.onMessageSyncState,false,0,true);
         Peripheral.smsMessaging.addEventListener(SMSMessageEvent.SEND_AUTO_REPLY_FOR_SMS,this.onSendAutoReplyForSMS,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_MESSAGE_PLAY,this.onVRSmsMessagePlay,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_MESSAGE_SHOW,this.onVRSmsMessageShow,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_SEND_INDEXED_SMS_TO_NUMBER,this.onVRSendIndexedSMS,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_MESSAGE_SEND,this.onVRSmsMessageSend,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_CHECK_NUMBER,this.onVRSmsCheckNumber,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_GOTO,this.onVRShortcut,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SHOW_CONTACT,this.onVRShowContact,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.DTMF_TONE_INFO,this.onDtmfToneInfo,false,0,true);
         Peripheral.phoneCallList.addEventListener(PhoneCallListEvent.SEND_AUTO_REPLY_FOR_CALL,this.onSendAutoReplyForCall,false,0,true);
         Peripheral.textToSpeach.addEventListener(TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.PHONE_VR_MODE,this.onPhoneVrMode,false,0,true);
         Peripheral.phonebook.addEventListener(PhoneBookEvent.PHONEBOOK_SYNC_UPDATED,this.updatedphoneBookAvailable,false,0,true);
         Peripheral.phonebook.addEventListener(PhoneBookEvent.CONTACT,this.onPhoneBookContact,false,0,true);
         Peripheral.phonebook.addEventListener(PhoneBookEvent.CALLER_ID,this.onCallerID,false,0,true);
         Peripheral.swc.addEventListener(ISWCEvent.PHONE_PRESS,this.onSwcEvent,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.CALL_STATE,this.onCallState,false,0,true);
      }
      
      private function onSMSMessageEvent(evt:SMSMessageEvent) : void
      {
         var mVectorLen:int = 0;
         var idx:int = 0;
         var msgId:int = 0;
         switch(evt.type)
         {
            case SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH:
               if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState && this.mPlayingAllNewMessagesStartNum == 0 && this.mAllNewMessage.length == 0)
               {
                  Peripheral.smsMessaging.clearIncomingMessage(true);
               }
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST:
               if(!(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState && this.mMessagesToPlay.length == 0))
               {
                  if(this.VR_PLAY_SINGLE_MSG == this.mVRRequestState)
                  {
                     Framework.Trace("VR_PLAY_SINGLE_MSG " + this.mMsgIndexRelativeToCurPage);
                     if(false == this.mVRDialogActive)
                     {
                        this.playSingleMessage(this.mMsgIndexRelativeToCurPage);
                     }
                  }
               }
               break;
            case SMSMessageEvent.SMS_FEATURE_SUPPORT:
               Framework.Trace("onSMSMessageEvent - isSendSupported: " + Peripheral.smsMessaging.isSendSupported);
               this.mGetAutoReply = Peripheral.persistency.getValue(PersistencyKeys.KEY_AUTO_REPLY).value;
               this.mGetAutoReplyMessage = Peripheral.persistency.getValue(PersistencyKeys.KEY_AUTO_REPLY_MESSAGE).value;
               this.mGetReplyWithMessage = Peripheral.persistency.getValue(PersistencyKeys.KEY_REPLY_WITH_MESSAGE).value;
               Peripheral.smsMessaging.autoReply = this.mGetAutoReply;
               Peripheral.smsMessaging.autoReplyMessage = this.mGetAutoReplyMessage;
               Peripheral.smsMessaging.replyWithMessage = this.mGetReplyWithMessage;
               break;
            case SMSMessageEvent.INBOX_UNREAD_MESSAGE_LIST:
               if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState && this.mMessagesToPlay.length == 0)
               {
                  mVectorLen = int(this.mAllNewMessage.length);
                  for(idx = 0; idx < mVectorLen; idx++)
                  {
                     this.mAllNewMessage.pop();
                  }
                  for(msgId = 0; msgId < Peripheral.smsMessaging.inboxUnreadMessageList.length; msgId++)
                  {
                     this.mAllNewMessage.push(Peripheral.smsMessaging.inboxUnreadMessageList[msgId]);
                  }
                  this.playMessage();
               }
         }
      }
      
      private function onMessageSendSuccess(evt:SMSMessageEvent) : void
      {
         if(this.mDNDAutoreplyMessage == false)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_MESSAGE_FULL);
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
            Framework.popupManager.show(DynamicPopupNames.SMS_SENT_STATUS,"popupsmsmessagefull",{
               "type":PopupType.PRIMARY,
               "task":"sms send success",
               "timeout":this.SMS_POPUPS_TIMEOUT
            });
         }
         else
         {
            this.mDNDAutoreplyMessage = false;
         }
      }
      
      private function onMessageSendError(evt:SMSMessageEvent) : void
      {
         if(this.mDNDAutoreplyMessage == false)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_MESSAGE_FULL);
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
            Framework.popupManager.show(DynamicPopupNames.SMS_SENT_STATUS,"popupsmsmessagefull",{
               "type":PopupType.PRIMARY,
               "task":"sms send error",
               "timeout":this.SMS_POPUPS_TIMEOUT
            });
         }
         else
         {
            this.mDNDAutoreplyMessage = false;
         }
      }
      
      private function onMessageSyncState(evt:SMSMessageEvent) : void
      {
         if(Peripheral.smsMessaging.incomingMessageCount == 0)
         {
            this.mIncomingSMSPending = false;
         }
      }
      
      private function onIncomingSMSMessage(evt:SMSMessageEvent) : void
      {
         this.checkForActivePopup();
         if("pendingNewSMS" == evt.data && Peripheral.bluetoothPhone.currentCalls.length == 0)
         {
            Framework.popupManager.show(DynamicPopupNames.SMS_INCOMING_MESSAGE,"popupincomingsms",{"type":PopupType.PRIMARY});
         }
         else
         {
            this.announceSMSMessage();
         }
      }
      
      private function onSendAutoReplyForSMS(evt:SMSMessageEvent) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus && Peripheral.smsMessaging.replyWithMessage && Peripheral.smsMessaging.isSendSupported && ("text" == Peripheral.smsMessaging.autoReply || "both" == Peripheral.smsMessaging.autoReply))
         {
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = Peripheral.smsMessaging.blockedSMSNumber;
            this.DNDSendSMS();
         }
      }
      
      private function onSendAutoReplyForCall(e:PhoneCallListEvent) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.DNDStatus && Peripheral.smsMessaging.replyWithMessage && Peripheral.smsMessaging.isSendSupported && ("call" == Peripheral.smsMessaging.autoReply || "both" == Peripheral.smsMessaging.autoReply))
         {
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = Peripheral.phoneCallList.blockedCallNumber;
            this.DNDSendSMS();
         }
      }
      
      private function onVRSmsMessageSend(evt:VoiceRecognitionEvent) : void
      {
         var messageIndex:int = 0;
         var messageToSend:String = null;
         var vehicleBrand:String = Peripheral.vehConfig.vehicleBrandName;
         if(evt.mData.phNumber != null && evt.mData.phNumber != "")
         {
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = evt.mData.phNumber;
            if(evt.mData.messageType == this.PRE_DEFINED_MESSAGE)
            {
               if(evt.mData.preDefinedMessage != null && evt.mData.preDefinedMessage != "")
               {
                  if(evt.mData.preDefinedMessage == "iWillBeXMinsLate")
                  {
                     messageToSend = Text.compose([T.STRB_SMS_X_MINUTES_LATE,evt.mData.smsDynamicValue]);
                  }
                  else if(evt.mData.preDefinedMessage == "seeYouInXMins")
                  {
                     messageToSend = Text.compose([T.STRB_SMS_SEE_YOU_IN_X_MINUTES,evt.mData.smsDynamicValue]);
                  }
                  else
                  {
                     messageIndex = this.preDefinedVRMessages.indexOf(evt.mData.preDefinedMessage);
                     messageToSend = Text.compose(this.mNewMessageListData[messageIndex].body);
                  }
               }
            }
            else if(evt.mData.messageType == this.DICTATED_MESSAGE && evt.mData.dictatedMessage != null && evt.mData.dictatedMessage != "")
            {
               messageToSend = evt.mData.dictatedMessage;
            }
            Framework.Trace("messageToSend: " + messageToSend);
            if(messageToSend != null && (Boolean(vehicleBrand) && Boolean("" != vehicleBrand)))
            {
               Peripheral.smsMessaging.outgoingMessageBody = messageToSend + "\n\n" + Text.compose([T.STRB_SENT_BY_MY_X,vehicleBrand]);
               Framework.Trace("outgoing message: " + Peripheral.smsMessaging.outgoingMessageBody);
               Peripheral.smsMessaging.sendOutgoingMessage();
            }
         }
         Framework.Trace("isSendSupported: " + Peripheral.smsMessaging.isSendSupported);
         if(Peripheral.smsMessaging.isSendSupported)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",null,null);
         }
         else
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",null,null);
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "timeout":this.SMS_POPUPS_TIMEOUT,
               "status":"sms not supported"
            });
         }
      }
      
      private function onVRDialogActiveMsg(evt:VoiceRecognitionEvent) : void
      {
         if(evt != null && evt.mData != null)
         {
            this.mVRDialogActive = evt.mData.vrDialogActive.state;
            Peripheral.smsMessaging.vrDialogStatus = this.mVRDialogActive;
            if(!this.mVRDialogActive)
            {
               if(this.VR_PLAY_SINGLE_MSG == this.mVRRequestState)
               {
                  this.playSingleMessage(this.mMsgIndexRelativeToCurPage);
               }
            }
            if(false == this.mVRDialogActive && this.mDtmfToneReceivedThroughVR && "" != Peripheral.voiceRecognition.dtmfToneInfo)
            {
               Peripheral.bluetooth.sendDTMFTone(Peripheral.voiceRecognition.dtmfToneInfo);
               this.mDtmfToneReceivedThroughVR = false;
               Peripheral.voiceRecognition.dtmfToneInfo = "";
            }
         }
      }
      
      private function onVRSmsCheckNumber(evt:VoiceRecognitionEvent) : void
      {
         var isAvail:Boolean = false;
         this.mContext = int(evt.mData.context);
         var msgIndex:int = int(evt.mData.messageIndexNo);
         if(msgIndex > 0 && msgIndex <= Peripheral.smsMessaging.inboxMessageListLength)
         {
            isAvail = true;
         }
         Peripheral.voiceRecognition.emitSmsVRResponse(this.mContext,evt.mData.methodName,"success",isAvail,null);
      }
      
      private function onVRSmsMessagePlay(evt:VoiceRecognitionEvent) : void
      {
         var msgIndex:int = 0;
         var type:String = null;
         if(evt.mData.type != "current")
         {
            this.mContext = int(evt.mData.context);
            this.mMethodName = evt.mData.methodName;
            msgIndex = int(evt.mData.messageIndexNo);
            type = String(evt.mData.type);
            Framework.Trace("msdIndex = " + msgIndex + ", type = " + type);
            this.mVRRequestState = this.VR_REQUEST_NONE;
            this.mMsgIndexRelativeToCurPage = 0;
            this.mPlayingAllNewMessagesStartNum = -1;
            if(Peripheral.smsMessaging.isSMSReady)
            {
               if(evt.mData.type == "allNew")
               {
                  this.mVRRequestState = this.VR_PLAY_ALL_NEW_MSG;
                  Peripheral.smsMessaging.clearIncomingMessage(true);
                  this.mPlayingAllNewMessagesStartNum = 0;
                  this.mVRResponseSentForAllNew = false;
                  this.mAllNewMessage.length = 0;
                  Peripheral.voiceRecognition.emitSmsVRResponse(this.mContext,this.mMethodName,"success",true,null);
                  Peripheral.smsMessaging.requestUnreadSMSList();
               }
            }
            else
            {
               Peripheral.voiceRecognition.emitSmsVRResponse(this.mContext,this.mMethodName,"failure",false,null);
            }
         }
         else if(!this.mPlayingFromCurrentPopup == true && evt.mData.type == "current" && (Framework.structure.currentBranch != "mainbackground/menu/smsmessaginglistscreen" && Framework.structure.currentBranch != Screens.SMS_MESSAGING_LIST))
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",true,null);
            if(this.mMessage)
            {
               if(false == this.mMessage.isRead)
               {
                  Peripheral.smsMessaging.smsReadStatus(String(this.mMessage.id));
               }
               Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,this.mMessage.body);
               if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Peripheral.smsMessaging.checkViewMessageActive(true);
               }
            }
         }
         else
         {
            if(this.mPlayingFromCurrentPopup == true && evt.mData.type == "current" && (Framework.structure.currentBranch != "mainbackground/menu/smsmessaginglistscreen" && Framework.structure.currentBranch != Screens.SMS_MESSAGING_LIST))
            {
               this.playCurrentlyOpenedMessage();
            }
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",true,null);
            this.mPlayingFromCurrentPopup = false;
         }
      }
      
      private function onVRSmsMessageShow(evt:VoiceRecognitionEvent) : void
      {
         var messageListen:Boolean = false;
         var mMessage:Object = null;
         var messageShown:Boolean = false;
         if(Framework.structure.currentBranch != "mainbackground/menu/smsmessaginglistscreen" && Framework.structure.currentBranch != Screens.SMS_MESSAGING_LIST)
         {
            messageListen = Boolean(evt.mData.messageListen);
            if(Framework.popupManager.active == DynamicPopupNames.VOICE_PICK_LIST)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VOICE_PICK_LIST);
            }
            mMessage = null;
            messageShown = false;
            mMessage = this.getMostRecentMessage();
            if(-1 == evt.mData.messageIndexNo)
            {
               if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL && messageListen == true)
               {
                  this.mPlayingFromCurrentPopup = true;
                  messageShown = true;
               }
               if(messageListen == true && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  if(Peripheral.vehicleStatus.speedLockOut)
                  {
                     Framework.popupManager.show(DynamicPopupNames.SMS_INCOMING_MESSAGE,"popupincomingsms",{
                        "type":PopupType.PRIMARY,
                        "task":"listen",
                        "smsObject":mMessage,
                        "multiMessage":Peripheral.smsMessaging.incomingMessageCount > 1
                     });
                     Peripheral.smsMessaging.clearIncomingMessage(true);
                  }
                  else
                  {
                     Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                        "type":PopupType.PRIMARY,
                        "task":"view incoming",
                        "smsObject":mMessage,
                        "multiMessage":Peripheral.smsMessaging.incomingMessageCount > 1
                     });
                     Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
                  }
                  messageShown = true;
               }
               else if(!Peripheral.vehicleStatus.speedLockOut && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                     "type":PopupType.PRIMARY,
                     "task":"view incoming",
                     "smsObject":mMessage,
                     "multiMessage":Peripheral.smsMessaging.incomingMessageCount > 1
                  });
                  Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
                  messageShown = true;
               }
               Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",null,null,messageShown);
            }
         }
      }
      
      private function onVRSendIndexedSMS(evt:VoiceRecognitionEvent) : void
      {
         var success:Boolean = false;
         var vehicleBrand:String = null;
         var messageIndexToSend:int = 0;
         var message:Object = null;
         if(Peripheral.smsMessaging.incomingMessageCount > 1 && Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",false,null);
            return;
         }
         if(Framework.structure.currentBranch != "mainbackground/menu/smsmessaginglistscreen" && Framework.structure.currentBranch != Screens.SMS_MESSAGING_LIST)
         {
            success = false;
            vehicleBrand = Peripheral.vehConfig.vehicleBrandName;
            messageIndexToSend = int(evt.mData.messageIndex);
            message = this.getMostRecentMessage();
            if(evt.mData.phoneNumber != null && evt.mData.phoneNumber != "")
            {
               if(-1 == messageIndexToSend)
               {
                  Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = evt.mData.phoneNumber;
                  Peripheral.smsMessaging.outgoingMessageBody = message.body + "\n\n" + Text.compose([T.STRB_SENT_BY_MY_X,vehicleBrand]);
                  success = Peripheral.smsMessaging.sendOutgoingMessage();
                  Peripheral.smsMessaging.clearIncomingMessage();
               }
            }
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,success ? "success" : "failure",null,null);
         }
      }
      
      private function onVRSmsGetDetails(evt:VoiceRecognitionEvent) : void
      {
         var result:String = null;
         var phoneNumber:String = null;
         var senderName:String = null;
         var phoneCategory:String = null;
         var mMessage:Object = null;
         if(Peripheral.smsMessaging.incomingMessageCount > 1 && Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",false,null);
            return;
         }
         if(Framework.structure.currentBranch != "mainbackground/menu/smsmessaginglistscreen" && Framework.structure.currentBranch != "mainbackground/menu/phonerecentcallscreen" && Framework.structure.currentBranch != "mainbackground/menu/PhonebookScreen")
         {
            if(evt.mData.messageIndex == -1)
            {
               result = "failure";
               phoneNumber = "";
               senderName = "";
               phoneCategory = null;
               mMessage = this.getMostRecentMessage();
               if(mMessage)
               {
                  phoneNumber = mMessage.phoneNumber;
                  if(phoneNumber != null && phoneNumber != "")
                  {
                     result = "success";
                     if("" != mMessage.from && mMessage.from != mMessage.phoneNumber)
                     {
                        senderName = mMessage.from;
                     }
                     switch(mMessage.phoneNumberType)
                     {
                        case "mobileNumber":
                           phoneCategory = "mobile";
                           break;
                        case "homeNumber":
                           phoneCategory = "home";
                           break;
                        case "workNumber":
                           phoneCategory = "work";
                           break;
                        case "otherNumber":
                           phoneCategory = "other";
                           break;
                        default:
                           phoneCategory = "";
                     }
                  }
               }
               Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,result,null,phoneNumber,false,senderName,phoneCategory);
            }
         }
      }
      
      private function onDtmfToneInfo(e:VoiceRecognitionEvent) : void
      {
         this.mDtmfToneReceivedThroughVR = true;
      }
      
      private function onVRShortcut(evt:VoiceRecognitionEvent) : void
      {
         if(Peripheral.voiceRecognition.PHONE_SMS_MESSAGE == evt.mData.videoScreen)
         {
            if(Peripheral.vehicleStatus.speedLockOut)
            {
               Peripheral.voiceRecognition.emitInvalidVRResponse(evt.mData.context,evt.mData.methodName);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
            }
            else
            {
               Peripheral.voiceRecognition.emitVRResponse(evt.mData.context,evt.mData.methodName,true);
               Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                  "type":PopupType.PRIMARY,
                  "task":"view selected",
                  "msgNum":this.mMessageIndexToPlay
               });
            }
         }
      }
      
      private function onVRShowContact(evt:VoiceRecognitionEvent) : void
      {
         this.mContext = evt.mData.context;
         this.mMethodName = evt.mData.methodName;
         Peripheral.phonebook.requestContactDetails(evt.mData.entryID);
      }
      
      private function onCallState(e:BluetoothEvent) : void
      {
         if(this.mIncomingSMSPending == true)
         {
            this.announceSMSMessage();
         }
         if(Peripheral.bluetoothPhone.currentCalls.length != 0)
         {
            this.removeSMSPopup();
            Peripheral.tuner.tunerSeekInteruptHdlr(TunerSeek.sSTOP);
            if(Screens.MAIN_PHONE == Framework.structure.currentBranch)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
            }
         }
      }
      
      private function onPhoneVrMode(e:BluetoothEvent) : void
      {
         if(true == e.data.vrMode)
         {
            if(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable)
            {
               if(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusEnabled)
               {
                  if(true == e.data.active && Framework.popupManager.active != DynamicPopupNames.SIRI_TALK && false == e.data.transferDelay)
                  {
                     Peripheral.smsMessaging.vrMode = true;
                     Framework.popupManager.show(DynamicPopupNames.SIRI_TALK,Screens.POPUP_SIRI);
                  }
                  else if(false == e.data.active && Boolean(Framework.popupManager.check(DynamicPopupNames.SIRI_TALK)))
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.SIRI_TALK);
                  }
               }
            }
         }
         else
         {
            if(Framework.popupManager.active == DynamicPopupNames.SIRI_TALK)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.SIRI_TALK);
            }
            Peripheral.smsMessaging.vrMode = false;
         }
      }
      
      private function onTextToSpeechEvent(evt:TextToSpeechEvent) : void
      {
         var msgID:int = 0;
         if("notPlaying" == Peripheral.textToSpeach.playState)
         {
            this.mListenSMSID = "";
            if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState)
            {
               this.mVRRequestState = this.VR_REQUEST_NONE;
            }
            else if(this.VR_PLAY_SINGLE_MSG == this.mVRRequestState)
            {
               this.playSingleMessage(this.mMsgIndexRelativeToCurPage);
            }
         }
         else if("playEnd" == Peripheral.textToSpeach.playState)
         {
            this.mListenSMSID = "";
            if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState)
            {
               if((null != evt.mData.msgID || "" != evt.mData.msgID) && 0 != evt.mData.msgID)
               {
                  msgID = int(evt.mData.msgID) * -1;
                  this.mMessageID = msgID.toString();
                  Peripheral.smsMessaging.smsReadStatus(this.mMessageID);
               }
            }
         }
         else if("playStart" == Peripheral.textToSpeach.playState)
         {
            this.mListenSMSID = "";
            if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState)
            {
               if((null != evt.mData.msgID || "" != evt.mData.msgID) && 0 != evt.mData.msgID)
               {
                  msgID = int(evt.mData.msgID) * -1;
                  this.mMessageID = msgID.toString();
                  this.mListenSMSID = this.mMessageID;
               }
            }
         }
         if(this.mIncomingSMSPending)
         {
            this.announceSMSMessage();
         }
      }
      
      private function updatedphoneBookAvailable(evt:PhoneBookEvent) : void
      {
         if("mainbackground/menu/PhonebookScreen" != Framework.structure.currentBranch)
         {
            Peripheral.phonebook.refreshPhonebook();
         }
      }
      
      private function onPhoneBookContact(evt:PhoneBookEvent) : void
      {
         if(evt.m_data.result != null)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(this.mContext,this.mMethodName,"success",null,null);
            Framework.popupManager.exit();
            if("mainbackground/menu/PhonebookScreen" != Framework.structure.currentBranch)
            {
               Peripheral.navigation.navDomainControl.exitNavDomain();
               Framework.structure.goto("mainbackground/menu/PhonebookScreen",{
                  "show":"search",
                  "contact":evt.m_data.result[0]
               });
            }
         }
         else
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(this.mContext,this.mMethodName,"failure",null,null);
         }
      }
      
      private function onSwcEvent(evt:ISWCEvent) : void
      {
         if(evt.type == ISWCEvent.PHONE_PRESS)
         {
            if(!Peripheral.bluetoothPhone.bluetoothHFP.handsFreeMode && Peripheral.bluetoothPhone.getActiveCall() != null && Framework.structure.currentBranch != Screens.MAIN_PHONE)
            {
               Framework.structure.goto(Screens.MAIN_PHONE);
            }
            if(Peripheral.bluetoothPhone.getRingingCall() != null && Framework.structure.currentBranch == Screens.DTV_FULL_SCREEN)
            {
               Framework.structure.back();
            }
            this.handleSWCPhone();
         }
      }
      
      private function handleSWCPhone() : void
      {
         if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState)
         {
            if(Peripheral.textToSpeach.isTTSPlaying == true)
            {
               Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
            }
            this.mVRRequestState = this.VR_REQUEST_NONE;
            this.mPlayingAllNewMessagesStartNum = -1;
            this.mVRResponseSentForAllNew = false;
            this.mMessagesToPlay.length = 0;
         }
      }
      
      private function removeSMSPopup() : void
      {
         if(Screens.MAIN_PHONE == Framework.structure.currentBranch)
         {
            if(DynamicPopupNames.SMS_INCOMING_MESSAGE == Framework.popupManager.active || DynamicPopupNames.SMS_MESSAGE_FULL == Framework.popupManager.active)
            {
               Framework.popupManager.dequeue(Framework.popupManager.active);
            }
         }
      }
      
      private function playMessage() : void
      {
         var id:int = 0;
         var unreadSMSList:Array = new Array();
         for(var i:int = 0; i < this.mAllNewMessage.length; i++)
         {
            id = int(this.mAllNewMessage[i].id);
            id *= -1;
            unreadSMSList.push({
               "msgID":id,
               "msgData":Text.compose(this.mAllNewMessage[i].body)
            });
         }
         Peripheral.textToSpeach.readoutAdv(Peripheral.textToSpeach.READOUT_TYPE_SMS,unreadSMSList);
      }
      
      private function playSingleMessage(msgNum:int) : void
      {
         var messStr:String = null;
         if(false == this.mVRDialogActive && Peripheral.textToSpeach.isTTSPlaying == false)
         {
            if(msgNum > 0 && msgNum <= Peripheral.smsMessaging.inboxMessageList.length)
            {
               messStr = Peripheral.smsMessaging.inboxMessageList[msgNum - 1].body;
               if(false == Peripheral.smsMessaging.inboxMessageList[msgNum - 1].isRead)
               {
                  Peripheral.smsMessaging.smsReadStatus(Peripheral.smsMessaging.inboxMessageList[msgNum - 1].id);
               }
               Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,Text.compose(messStr));
            }
            this.mVRRequestState = this.VR_REQUEST_NONE;
         }
      }
      
      private function announceSMSMessage() : void
      {
         var announcement:String = null;
         if(Peripheral.smsMessaging.incomingMessage != null)
         {
            if(Peripheral.textToSpeach.isTTSPlaying == false && Peripheral.bluetoothPhone.currentCalls.length == 0)
            {
               if(Peripheral.smsMessaging.incomingMessageCount > 1)
               {
                  announcement = Text.compose([T.STRB_SMS_NEW_TEXT_MSGS,Peripheral.smsMessaging.incomingMessageCount.toString()]);
               }
               else if(null != Peripheral.smsMessaging.promptIncomingName && "" != Peripheral.smsMessaging.promptIncomingName)
               {
                  announcement = Text.compose([T.STRB_SMS_NEW_TEXT_MESSAGE_FROM,Peripheral.smsMessaging.promptIncomingName]);
               }
               else
               {
                  announcement = Text.compose(T.STRB_SMS_NEW_TEXT_MESSAGE);
               }
               if(DynamicPopupNames.SMS_INCOMING_MESSAGE != Framework.popupManager.active && DynamicPopupNames.SMS_MESSAGE_FULL != Framework.popupManager.active)
               {
                  if(DynamicPopupNames.SMS_SENT_STATUS == Framework.popupManager.active)
                  {
                     Framework.popupManager.dequeue(DynamicPopupNames.SMS_SENT_STATUS);
                  }
                  Framework.popupManager.show(DynamicPopupNames.SMS_INCOMING_MESSAGE,"popupincomingsms",{"type":PopupType.PRIMARY});
               }
               Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,announcement);
               this.mIncomingSMSPending = false;
            }
            else
            {
               this.mIncomingSMSPending = true;
               if(Peripheral.textToSpeach.playState == null)
               {
                  Peripheral.textToSpeach.requestPlayState();
               }
            }
         }
         else
         {
            this.mIncomingSMSPending = false;
         }
      }
      
      private function DNDSendSMS() : void
      {
         var vehicleBrand:String = Peripheral.vehConfig.vehicleBrandName;
         var messageToSend:String = "";
         var subscriberNumber:String = Peripheral.bluetoothPhone.bluetoothHFP.subscriberNumber;
         var senderNumber:String = Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber;
         if(10 < senderNumber.length)
         {
            senderNumber = senderNumber.slice(senderNumber.length - 10,senderNumber.length);
         }
         if("default" == Peripheral.smsMessaging.autoReplyMessage)
         {
            messageToSend = Text.compose(T.STRB_I_AM_DRIVING_RIGHT_NOW);
         }
         else if("custom" == Peripheral.smsMessaging.autoReplyMessage)
         {
            messageToSend = Peripheral.smsMessaging.customMessage;
            if("" == messageToSend)
            {
               messageToSend = Text.compose(T.STRB_I_AM_DRIVING_RIGHT_NOW);
            }
         }
         if(Boolean(messageToSend != null) && (Boolean(vehicleBrand && "" != vehicleBrand)) && subscriberNumber != senderNumber)
         {
            Peripheral.smsMessaging.outgoingMessageBody = messageToSend + "\n\n" + Text.compose([T.STRB_SENT_BY_MY_X,vehicleBrand]);
            Peripheral.smsMessaging.sendOutgoingMessage();
            this.mDNDAutoreplyMessage = true;
         }
      }
      
      private function onCallerID(evt:PhoneBookEvent) : void
      {
         if(Framework.structure.currentBranch == "mainbackground/menu/smsmessaginglistscreen" || Framework.structure.currentBranch == "mainbackground/menu/smscontactscreen")
         {
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType = evt.m_data.numberType;
            Peripheral.smsMessaging.outgoingMessageRecipientName = evt.m_data.formattedName;
         }
      }
      
      private function getMostRecentMessage() : Object
      {
         this.mMessage = null;
         if(Peripheral.smsMessaging.incomingMessageCount > 1)
         {
            this.mMessage = Peripheral.smsMessaging.lastMessageReceived;
         }
         else if(Peripheral.smsMessaging.incomingMessage != null)
         {
            this.mMessage = Peripheral.smsMessaging.incomingMessage;
         }
         else if(Peripheral.smsMessaging.previousIncomingMessage != null)
         {
            this.mMessage = Peripheral.smsMessaging.previousIncomingMessage;
         }
         return this.mMessage;
      }
      
      private function playCurrentlyOpenedMessage() : void
      {
         var openedMessage:SMSMessage = null;
         openedMessage = Peripheral.smsMessaging.currentlyOpenedMessage;
         Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,openedMessage.body);
      }
      
      private function checkForActivePopup() : void
      {
         var activePopup:int = 0;
         activePopup = int(Framework.popupManager.active);
         switch(activePopup)
         {
            case DynamicPopupNames.PHONEBOOK_SMART_SPELLER:
            case DynamicPopupNames.CONTROLS:
            case DynamicPopupNames.TWOITEM_RESET_YOUR_SETTINGS_TO_DEFAULT:
            case DynamicPopupNames.TWOITEM_CLEAR_PERSONAL_DATA:
            case DynamicPopupNames.ALPHA_JUMP:
            case DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE:
            case DynamicPopupNames.PHONE_PAIRING:
               Framework.popupManager.dequeue(activePopup);
         }
      }
      
      public function get listenSMSID() : String
      {
         return this.mListenSMSID;
      }
      
      public function set listenSMSID(mMessageID:String) : void
      {
         this.mListenSMSID = mMessageID;
      }
   }
}

