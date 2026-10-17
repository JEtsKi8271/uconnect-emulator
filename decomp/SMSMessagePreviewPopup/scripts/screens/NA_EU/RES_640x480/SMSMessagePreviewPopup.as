package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SMSMessagePreviewPopup extends GenericScreen
   {
      
      private static const INCOMING_PROMPT_INITIAL:int = -1;
      
      private static const INCOMING_PROMPT_NOT_PLAYING:int = 0;
      
      private static const INCOMING_PROMPT_PLAYING:int = 1;
      
      private static const SMS_POPUPS_TIMEOUT:uint = 5000;
      
      private var mMessageListen:Boolean = false;
      
      private var mMessage:SMSMessage;
      
      private var mMessageIsPlaying:Boolean = false;
      
      private var mListenPending:Boolean = false;
      
      private var mVRDialogActive:Boolean = false;
      
      private var mNumIncoming:int = 0;
      
      private var mExternallyHandlingClear:Boolean = false;
      
      private var mPlayingNewMessageTTS:int = -1;
      
      public function SMSMessagePreviewPopup()
      {
         mView = new C_SMSMessagePreviewPopupScreenView();
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         mView.inbox_button.visible = false;
         mView.ignore_button.visible = false;
         mView.typeTitle.visible = false;
         mView.typeBody.visible = false;
         this.mNumIncoming = Peripheral.smsMessaging.incomingMessageCount;
         if(this.mNumIncoming > 1)
         {
            this.mMessage = Peripheral.smsMessaging.lastMessageReceived;
         }
         else
         {
            this.mMessage = Peripheral.smsMessaging.incomingMessage;
         }
         var messageFrom:String = "";
         if(Framework.popupManager.variables != null && Boolean(Framework.popupManager.variables.hasOwnProperty("smsObject")) && this.mMessage == null)
         {
            this.mMessage = Framework.popupManager.variables.smsObject;
         }
         else if(this.mMessage == null)
         {
            this.mMessage = Peripheral.smsMessaging.previousIncomingMessage;
         }
         if(this.mMessage)
         {
            if(Peripheral.smsManager.listenSMSID == this.mMessage.id)
            {
               mView.buttons_group.listen_button.setHighlight(true);
               mView.controls_group.listen_button.setHighlight(true);
            }
            mView.typeTitle.visible = false;
            mView.typeBody.visible = false;
            if(this.mNumIncoming > 1 && screenVars.task != "listen")
            {
               t(mView.messageTitle_label,[T.STRB_SMS_NEW_TEXT_MSGS,this.mNumIncoming.toString()]);
               mView.messageBody_label.text = "";
            }
            else
            {
               if("" == this.mMessage.from || null == this.mMessage.from)
               {
                  messageFrom = Format.phoneNumber(this.mMessage.phoneNumber);
               }
               else
               {
                  messageFrom = this.mMessage.from;
                  if("" != this.mMessage.phoneNumberType)
                  {
                     mView.typeBody.visible = true;
                     switch(this.mMessage.phoneNumberType)
                     {
                        case "mobileNumber":
                           mView.typeBody.gotoAndStop("mobile");
                           break;
                        case "homeNumber":
                           mView.typeBody.gotoAndStop("home");
                           break;
                        case "workNumber":
                           mView.typeBody.gotoAndStop("work");
                           break;
                        case "otherNumber":
                           mView.typeBody.gotoAndStop("circle");
                           break;
                        default:
                           mView.typeBody.visible = false;
                     }
                  }
               }
               if(messageFrom != "")
               {
                  messageFrom += ", ";
               }
               t(mView.messageTitle_label,messageFrom + " " + this.formatTimeDate(this.mMessage.date));
               mView.messageBody_label.text = "";
            }
         }
         if(screenVars.task == "listen" || Boolean(Framework.popupManager.variables.task != null) && Boolean(Framework.popupManager.variables.task))
         {
            this.mMessageListen = true;
            mView.buttons_group.listen_button.setHighlight(true);
            mView.controls_group.listen_button.setHighlight(true);
         }
         this.updateButtons();
         this.mVRDialogActive = Peripheral.voiceRecognition.VRSessionInProgress;
         Peripheral.textToSpeach.requestPlayState();
         Framework.focusManager.addFocus(new FocusObject(Layers.POPUPS,FocusPriority.REGULAR,[mView.inbox_button,mView.ignore_button,mView.buttons_group.view_button,mView.buttons_group.listen_button,mView.buttons_group.ignore_button,mView.controls_group.listen_button,mView.controls_group.reply_button,mView.controls_group.forward_button,mView.controls_group.inbox_button,mView.controls_group.call_button]));
      }
      
      private function onIncomingSMSMessage(event:SMSMessageEvent) : void
      {
         var messageFrom:String = null;
         if(Peripheral.textToSpeach.isTTSPlaying)
         {
            mView.buttons_group.listen_button.setHighlight(false);
            mView.controls_group.listen_button.setHighlight(false);
         }
         this.mNumIncoming = Peripheral.smsMessaging.incomingMessageCount;
         if(this.mNumIncoming == 1)
         {
            this.mMessage = Peripheral.smsMessaging.incomingMessage;
            messageFrom = "";
            if(this.mMessage)
            {
               mView.typeTitle.visible = false;
               mView.typeBody.visible = false;
               if("" == this.mMessage.from || null == this.mMessage.from)
               {
                  messageFrom = Format.phoneNumber(this.mMessage.phoneNumber);
               }
               else
               {
                  messageFrom = this.mMessage.from;
                  if("" != this.mMessage.phoneNumberType)
                  {
                     mView.typeBody.visible = true;
                     switch(this.mMessage.phoneNumberType)
                     {
                        case "mobileNumber":
                           mView.typeBody.gotoAndStop("mobile");
                           break;
                        case "homeNumber":
                           mView.typeBody.gotoAndStop("home");
                           break;
                        case "workNumber":
                           mView.typeBody.gotoAndStop("work");
                           break;
                        case "otherNumber":
                           mView.typeBody.gotoAndStop("circle");
                           break;
                        default:
                           mView.typeBody.visible = false;
                     }
                  }
               }
               if(messageFrom != "")
               {
                  messageFrom += ", ";
               }
               mView.messageTitle_label.text = messageFrom + this.formatTimeDate(this.mMessage.date);
               mView.messageBody_label.text = "";
            }
         }
         else
         {
            mView.messageTitle_label.text = compose([T.STRB_SMS_NEW_TEXT_MSGS,this.mNumIncoming.toString()]);
            mView.messageBody_label.text = "";
         }
         this.mMessageListen = false;
         screenVars.task = "";
         this.updateButtons();
      }
      
      override public function screenIn() : void
      {
         Peripheral.smsMessaging.emitNewSMSPopupStatus(true);
         super.screenIn();
      }
      
      override public function screenOut() : void
      {
         this.mMessageIsPlaying = false;
         this.mListenPending = false;
         this.mPlayingNewMessageTTS = INCOMING_PROMPT_INITIAL;
         mView.buttons_group.listen_button.setHighlight(false);
         if(this.mMessageListen == true)
         {
            screenVars.task = "listen";
            this.mMessageListen = false;
         }
         else if(false == this.checkForActivePopup() && this.mExternallyHandlingClear == false)
         {
            Peripheral.smsMessaging.clearIncomingMessage(true);
            screenVars.task = "";
         }
         Peripheral.smsMessaging.emitNewSMSPopupStatus(false);
         super.screenOut();
      }
      
      private function formatTimeDate(dateString:String) : String
      {
         var temp_array:Array = null;
         var formattedTimeDate:String = "";
         if(dateString != "")
         {
            temp_array = dateString.split(" ");
            if(temp_array.length > 1)
            {
               formattedTimeDate += Format.timeOfDay(temp_array[1]) + ", ";
            }
            if(temp_array.length > 0)
            {
               formattedTimeDate += Format.dateFormat(temp_array[0]);
            }
         }
         return formattedTimeDate;
      }
      
      override protected function addListeners() : void
      {
         attachListener(mView.close_button,MouseEvent.CLICK,this.onCloseButtonClick,false,0,true);
         attachListener(mView.buttons_group.view_button,MouseEvent.CLICK,this.onViewButtonClick,false,0,true);
         attachListener(mView.buttons_group.listen_button,MouseEvent.CLICK,this.onListenButtonClick,false,0,true);
         attachListener(mView.buttons_group.ignore_button,MouseEvent.CLICK,this.onIgnoreButtonClick,false,0,true);
         attachListener(mView.inbox_button,MouseEvent.CLICK,this.onInboxButtonClick,false,0,true);
         attachListener(mView.ignore_button,MouseEvent.CLICK,this.onIgnoreButtonClick,false,0,true);
         attachListener(mView.controls_group.listen_button,MouseEvent.CLICK,this.onListenButtonClick,false,0,true);
         attachListener(mView.controls_group.reply_button,MouseEvent.CLICK,this.onReplyButtonClick,false,0,true);
         attachListener(mView.controls_group.forward_button,MouseEvent.CLICK,this.onForwardButtonClick,false,0,true);
         attachListener(mView.controls_group.inbox_button,MouseEvent.CLICK,this.onInboxButtonClick,false,0,true);
         attachListener(mView.controls_group.call_button,MouseEvent.CLICK,this.onCallButtonClick,false,0,true);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         attachListener(Peripheral.textToSpeach,TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent,false,0,true);
         attachListener(Peripheral.textToSpeach,TextToSpeechEvent.RESULT,this.onTextToSpeechEvent);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg,false,0,true);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.INCOMING_MESSAGE,this.onIncomingSMSMessage,false,0,true);
         attachListener(Framework.popupManager,PopupManagerEvent.REFRESH,this.onRefresh,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange,false,0,true);
         this.updateViewButton();
      }
      
      override protected function removeListeners() : void
      {
         detachListener(mView.close_button,MouseEvent.CLICK,this.onCloseButtonClick);
         detachListener(mView.buttons_group.view_button,MouseEvent.CLICK,this.onViewButtonClick);
         detachListener(mView.buttons_group.listen_button,MouseEvent.CLICK,this.onListenButtonClick);
         detachListener(mView.buttons_group.ignore_button,MouseEvent.CLICK,this.onIgnoreButtonClick);
         detachListener(mView.inbox_button,MouseEvent.CLICK,this.onInboxButtonClick);
         detachListener(mView.ignore_button,MouseEvent.CLICK,this.onIgnoreButtonClick);
         detachListener(mView.controls_group.listen_button,MouseEvent.CLICK,this.onListenButtonClick);
         detachListener(mView.controls_group.reply_button,MouseEvent.CLICK,this.onReplyButtonClick);
         detachListener(mView.controls_group.forward_button,MouseEvent.CLICK,this.onForwardButtonClick);
         detachListener(mView.controls_group.inbox_button,MouseEvent.CLICK,this.onInboxButtonClick);
         detachListener(mView.controls_group.call_button,MouseEvent.CLICK,this.onCallButtonClick);
         detachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         detachListener(Peripheral.textToSpeach,TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent);
         detachListener(Peripheral.textToSpeach,TextToSpeechEvent.RESULT,this.onTextToSpeechEvent);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.INCOMING_MESSAGE,this.onIncomingSMSMessage);
         detachListener(Framework.popupManager,PopupManagerEvent.REFRESH,this.onRefresh);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange);
         super.removeListeners();
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         if(this.mNumIncoming > 1)
         {
            t(mView.inbox_button.value_label,T.STRB_SMS_INBOX_2);
            t(mView.ignore_button.value_label,T.STRB_SMS_MSG_IGNORE);
         }
         t(mView.buttons_group.view_button.value_label,T.STRB_SMS_MSG_VIEW);
         t(mView.buttons_group.listen_button.value_label,T.STRB_SMS_MSG_LISTEN);
         t(mView.buttons_group.ignore_button.value_label,T.STRB_SMS_MSG_IGNORE);
         t(mView.controls_group.listen_button.value_label,T.STRB_SMS_MSG_LISTEN);
         t(mView.controls_group.reply_button.value_label,T.STRB_SMS_REPLY);
         t(mView.controls_group.forward_button.value_label,T.STRB_SMS_FORWARD);
         t(mView.controls_group.inbox_button.value_label,T.STRB_SMS_INBOX);
         t(mView.controls_group.call_button.value_label,T.STRB_SMS_CALL);
         t(mView.title_label,T.STRB_SMS_MSG_TEXT);
      }
      
      private function updateButtons() : void
      {
         if(this.mMessageListen == true)
         {
            mView.buttons_group.view_button.visible = false;
            mView.buttons_group.listen_button.visible = false;
            mView.buttons_group.ignore_button.visible = false;
            mView.inbox_button.visible = false;
            mView.ignore_button.visible = false;
            mView.controls_group.listen_button.visible = true;
            mView.controls_group.reply_button.visible = true;
            mView.controls_group.forward_button.visible = true;
            if(Peripheral.smsMessaging.isSendSupported == false)
            {
               mView.controls_group.reply_button.setEnabled(false);
               mView.controls_group.reply_button.setInteractive(true);
               mView.controls_group.forward_button.setEnabled(false);
               mView.controls_group.forward_button.setInteractive(true);
            }
            else
            {
               mView.controls_group.reply_button.setInteractive(true);
               mView.controls_group.reply_button.setEnabled(true);
               mView.controls_group.forward_button.setInteractive(true);
               mView.controls_group.forward_button.setEnabled(true);
            }
            mView.controls_group.inbox_button.visible = true;
            mView.controls_group.call_button.visible = true;
            if(!this.mMessage || !this.mMessage.phoneNumber || this.mMessage.phoneNumber.length == 0 || Boolean(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable) || Boolean(Peripheral.bluetoothPhone.bluetoothHFP.isCallConferenced))
            {
               mView.controls_group.call_button.setEnabled(false);
            }
            else
            {
               mView.controls_group.call_button.setEnabled(true);
            }
         }
         else
         {
            if(this.mNumIncoming > 1)
            {
               t(mView.inbox_button.value_label,T.STRB_SMS_INBOX_2);
               t(mView.ignore_button.value_label,T.STRB_SMS_MSG_IGNORE);
               mView.inbox_button.visible = true;
               mView.ignore_button.visible = true;
               mView.buttons_group.view_button.visible = false;
               mView.buttons_group.ignore_button.visible = false;
               mView.buttons_group.listen_button.visible = false;
               mView.typeBody.visible = false;
            }
            else
            {
               t(mView.buttons_group.view_button.value_label,T.STRB_SMS_MSG_VIEW);
               mView.buttons_group.view_button.visible = true;
               mView.buttons_group.listen_button.visible = true;
               mView.buttons_group.ignore_button.visible = true;
            }
            mView.controls_group.listen_button.visible = false;
            mView.controls_group.reply_button.visible = false;
            mView.controls_group.forward_button.visible = false;
            mView.controls_group.inbox_button.visible = false;
            mView.controls_group.call_button.visible = false;
         }
      }
      
      private function onCloseButtonClick(e:Event) : void
      {
         this.mExternallyHandlingClear = true;
         Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         Peripheral.smsMessaging.clearIncomingMessage(true);
      }
      
      private function onViewButtonClick(e:Event) : void
      {
         if(this.mNumIncoming > 1)
         {
            this.mExternallyHandlingClear = true;
            Peripheral.smsMessaging.clearIncomingMessage(true);
            this.mNumIncoming = 0;
            Framework.structure.goto(Screens.SMS_MESSAGING_LIST,"inbox");
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else if(true == Peripheral.vehicleStatus.speedLockOut)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            this.mExternallyHandlingClear = true;
            Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
               "type":PopupType.PRIMARY,
               "task":"view incoming",
               "multiMessage":Peripheral.smsMessaging.incomingMessageCount > 1
            });
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
      }
      
      private function onListenButtonClick(e:Event) : void
      {
         if(!Peripheral.textToSpeach.isTTSPlaying)
         {
            this.playMessage();
         }
         else
         {
            if(this.mPlayingNewMessageTTS == INCOMING_PROMPT_PLAYING)
            {
               this.mListenPending = true;
            }
            Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
         }
         Peripheral.voiceRecognition.setContext(Peripheral.voiceRecognition.PHONE_SMS_MESSAGE_SELECTED);
      }
      
      private function onTextToSpeechEvent(evt:TextToSpeechEvent) : void
      {
         if(evt.type == TextToSpeechEvent.RESULT)
         {
            if(evt.mData == "invalid input parameters")
            {
               mView.buttons_group.listen_button.setHighlight(false);
               mView.controls_group.listen_button.setHighlight(false);
            }
         }
         else if(!Peripheral.textToSpeach.isTTSPlaying)
         {
            if(this.mListenPending)
            {
               this.mListenPending = false;
               this.playMessage();
            }
            else if(this.mPlayingNewMessageTTS != INCOMING_PROMPT_PLAYING)
            {
               mView.buttons_group.listen_button.setHighlight(false);
               mView.controls_group.listen_button.setHighlight(false);
            }
            else if(evt != null && evt.mData != null && evt.mData.state == "playEnd")
            {
               mView.buttons_group.listen_button.setHighlight(false);
               mView.controls_group.listen_button.setHighlight(false);
            }
            if(this.mPlayingNewMessageTTS == INCOMING_PROMPT_PLAYING && evt != null && evt.mData != null && evt.mData.state == "notPlaying")
            {
               this.mPlayingNewMessageTTS = INCOMING_PROMPT_NOT_PLAYING;
            }
         }
         else if(this.mPlayingNewMessageTTS == INCOMING_PROMPT_INITIAL)
         {
            this.mPlayingNewMessageTTS = INCOMING_PROMPT_PLAYING;
         }
      }
      
      private function onVRDialogActiveMsg(evt:VoiceRecognitionEvent) : void
      {
         if(evt != null && evt.mData != null)
         {
            this.mVRDialogActive = evt.mData.vrDialogActive.state;
            if(!this.mVRDialogActive && this.mListenPending)
            {
               this.mListenPending = false;
               this.playMessage();
            }
            else
            {
               mView.controls_group.listen_button.setHighlight(false);
            }
         }
      }
      
      private function onReplyButtonClick(evt:MouseEvent) : void
      {
         this.mExternallyHandlingClear = true;
         if(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable)
         {
            Framework.popupManager.show(DynamicPopupNames.SIRI_PRESS_AND_HOLD,"popup1item",{
               "timeout":10000,
               "type":PopupType.PRIMARY,
               "title":"",
               "message":T.STRB_PRESS_AND_HOLD_THE_VOICE_ML,
               "caption1":T.STRB_OK,
               "showClose":true
            });
            Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"inbox"});
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else if(false == Peripheral.smsMessaging.isSendSupported)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.SECONDARY,
               "timeout":SMS_POPUPS_TIMEOUT,
               "status":"sms not supported"
            });
         }
         else
         {
            if(this.mMessage)
            {
               Peripheral.smsMessaging.outgoingMessageRecipientName = this.mMessage.from;
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = this.mMessage.phoneNumber;
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType = this.mMessage.phoneNumberType;
            }
            if(Peripheral.vehicleStatus.speedLockOut)
            {
               Peripheral.smsMessaging.clearIncomingMessage(true);
               Peripheral.smsMessaging.startSMSDictation("new",true);
            }
            else
            {
               Peripheral.smsMessaging.clearIncomingMessage(true);
               Peripheral.smsMessaging.replyMessage();
               Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"newMessageReply"});
               Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
            }
         }
      }
      
      private function onForwardButtonClick(evt:MouseEvent) : void
      {
         this.mExternallyHandlingClear = true;
         if(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable)
         {
            Framework.popupManager.show(DynamicPopupNames.SIRI_PRESS_AND_HOLD,"popup1item",{
               "timeout":10000,
               "type":PopupType.PRIMARY,
               "title":"",
               "message":T.STRB_PRESS_AND_HOLD_THE_VOICE_ML,
               "caption1":T.STRB_OK,
               "showClose":true
            });
            Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"inbox"});
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else if(!Peripheral.smsMessaging.isSendSupported)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.SECONDARY,
               "timeout":SMS_POPUPS_TIMEOUT,
               "status":"sms not supported"
            });
         }
         else
         {
            Peripheral.smsMessaging.clearIncomingMessage(true);
            if(this.mMessage)
            {
               Peripheral.smsMessaging.outgoingMessageBody = this.mMessage.body;
            }
            if(Framework.structure.historyIndexOf("mainbackground/menu/smscontactscreen") == 0 || Framework.structure.historyIndexOf(Screens.SMS_CONTACT_LIST) == 0)
            {
               Framework.structure.back();
            }
            Framework.structure.goto("mainbackground/menu/smscontactscreen",{
               "state":"forwardMessage",
               "disableBackArrow":"yes"
            });
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
      }
      
      private function onInboxButtonClick(evt:MouseEvent) : void
      {
         this.mExternallyHandlingClear = true;
         Peripheral.smsMessaging.clearIncomingMessage(true);
         Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"inbox"});
         Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
      }
      
      private function onCallButtonClick(evt:MouseEvent) : void
      {
         this.mExternallyHandlingClear = true;
         if(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable)
         {
            Framework.popupManager.show(DynamicPopupNames.SIRI_PRESS_AND_HOLD,"popup1item",{
               "timeout":10000,
               "type":PopupType.PRIMARY,
               "title":"",
               "message":T.STRB_PRESS_AND_HOLD_THE_VOICE_ML,
               "caption1":T.STRB_OK,
               "showClose":true
            });
            Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"inbox"});
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else if(Boolean(this.mMessage) && mView.controls_group.call_button.enabled == true)
         {
            if(Peripheral.phonebook.multipleContactNumberPresent)
            {
               Peripheral.phonebook.multiNumberFromMessageFlag = true;
               Framework.structure.goto("mainbackground/menu/PhonebookScreen",{
                  "show":"details",
                  "contact":Peripheral.phonebook.multipleContactNumberInfo
               });
            }
            else
            {
               Framework.structure.goto(Screens.MAIN_PHONE);
               Peripheral.bluetoothPhone.bluetoothHFP.dial(this.mMessage.phoneNumber,this.mMessage.from,this.mMessage.phoneNumberType);
            }
            Peripheral.smsMessaging.clearIncomingMessage(true);
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.SECONDARY,
               "timeout":SMS_POPUPS_TIMEOUT,
               "status":"sms not supported"
            });
         }
      }
      
      private function onIgnoreButtonClick(e:Event) : void
      {
         this.mExternallyHandlingClear = true;
         Peripheral.smsMessaging.clearIncomingMessage(true);
         this.mNumIncoming = 0;
         Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
      }
      
      private function updateViewButton() : void
      {
         this.mNumIncoming = Peripheral.smsMessaging.incomingMessageCount;
         if(Peripheral.smsMessaging.incomingMessageCount > 1)
         {
            mView.buttons_group.view_button.setEnabled(true);
            mView.buttons_group.view_button.setInteractive(true);
         }
         mView.buttons_group.view_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut);
         mView.buttons_group.view_button.setInteractive(true);
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         this.updateViewButton();
      }
      
      private function playMessage() : void
      {
         if(this.mMessage)
         {
            if(!this.mVRDialogActive && Peripheral.textToSpeach.isTTSPlaying == false)
            {
               this.mListenPending = false;
               if(false == this.mMessage.isRead)
               {
                  Peripheral.smsMessaging.smsReadStatus(String(this.mMessage.id));
               }
               Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,this.mMessage.body);
               Peripheral.smsMessaging.playingMessageID = this.mMessage.id;
               mView.buttons_group.listen_button.setHighlight(true);
               mView.controls_group.listen_button.setHighlight(true);
               if(this.mNumIncoming == 1)
               {
                  this.mExternallyHandlingClear = true;
                  Peripheral.smsMessaging.clearIncomingMessage(true);
               }
               if(this.mMessageListen == false)
               {
                  this.mMessageListen = true;
                  this.updateButtons();
               }
            }
            else
            {
               this.mListenPending = true;
               Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
               mView.buttons_group.listen_button.setHighlight(false);
               mView.controls_group.listen_button.setHighlight(false);
            }
         }
         else
         {
            this.mListenPending = false;
            mView.buttons_group.listen_button.setHighlight(false);
            mView.controls_group.listen_button.setHighlight(false);
         }
      }
      
      private function onRefresh(e:PopupManagerEvent) : void
      {
         if(e != null)
         {
            screenVars = e.vars;
            this.initScreen();
         }
      }
      
      private function checkForActivePopup() : Boolean
      {
         var activePopup:int = 0;
         var retVal:Boolean = false;
         activePopup = int(Framework.popupManager.active);
         switch(activePopup)
         {
            case DynamicPopupNames.PLEASE_WAIT:
            case DynamicPopupNames.VOICE_PICK_LIST:
            case DynamicPopupNames.PHONE_PAIRING:
            case DynamicPopupNames.HVAC:
            case DynamicPopupNames.ERROR_ALERT:
            case DynamicPopupNames.MUTE:
            case DynamicPopupNames.SMS_MESSAGE_FULL:
            case DynamicPopupNames.CONTROLS:
            case DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE:
            case DynamicPopupNames.SIRI_TALK:
            case DynamicPopupNames.TWOITEM_CLEAR_PERSONAL_DATA:
            case DynamicPopupNames.PHONE_SETTINGS:
            case DynamicPopupNames.PHONE_COPIED_TO_FAVORITES:
            case DynamicPopupNames.CAMERAS:
            case DynamicPopupNames.RADIO_DIRECT_TUNE:
            case DynamicPopupNames.TWOITEM_REMOVE_FROM_FAVORITE_APPS:
               retVal = true;
               break;
            default:
               retVal = false;
         }
         return retVal;
      }
      
      private function onCallStateChange(evt:BluetoothEvent) : void
      {
         if(!this.mMessage || !this.mMessage.phoneNumber || this.mMessage.phoneNumber.length == 0 || Boolean(Peripheral.bluetoothPhone.bluetoothHFP.siriStatusAvailable) || Boolean(Peripheral.bluetoothPhone.bluetoothHFP.isCallConferenced))
         {
            mView.buttons_group.controls_group.call_button.setEnabled(false);
         }
         else
         {
            mView.buttons_group.controls_group.call_button.setEnabled(true);
         }
      }
   }
}

