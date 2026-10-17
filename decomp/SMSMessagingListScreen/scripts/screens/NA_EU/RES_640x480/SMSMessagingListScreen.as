package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.SMSMessage;
   import com.nfuzion.moduleLinkAPI.SMSMessageEvent;
   import com.nfuzion.moduleLinkAPI.TextToSpeechEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import mx.utils.ObjectUtil;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SMSMessagingListScreen extends GenericScreen
   {
      
      private const STATE_INBOX:String = "inbox";
      
      private const STATE_NEW_MESSAGE:String = "new message";
      
      private const STATE_NEW_MESSAGE_INIT:String = "new message init";
      
      private const STATE_NEW_MESSAGE_REPLY:String = "new message reply";
      
      private const STATE_NEW_MESSAGE_FORWARD:String = "new message forward";
      
      private const STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN:String = "new message with number see you in";
      
      private const STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE:String = "new message with number will be late";
      
      private const STATE_NEW_MESSAGE_PREDEFINED:String = "new message predefined";
      
      private const STATE_NEW_MESSAGE_DICTATION:String = "new message dictation";
      
      private const STATE_PLAY_MESSAGE_BY_INDEX:String = "play message";
      
      private const VR_REQUEST_NONE:uint = 0;
      
      private const VR_VIEW_SINGLE_MSG:uint = 1;
      
      private const VR_PLAY_SINGLE_MSG:uint = 2;
      
      private const VR_PLAY_ALL_NEW_MSG:uint = 3;
      
      private const MAX_SMS_COUNT:int = 1000;
      
      private const SMS_ITEMS_PER_PAGE:uint = 6;
      
      private const SMS_POPUPS_TIMEOUT:uint = 5000;
      
      private const mNewMessageListData:Vector.<Object> = Vector.<Object>([{"body":T.STRB_SMS_YES},{"body":T.STRB_SMS_NO},{"body":T.STRB_SMS_OKAY},{"body":T.STRB_SMS_CAN_NOT_TALK},{"body":T.STRB_SMS_CALL_ME},{"body":T.STRB_SMS_CALL_YOU_LATER},{"body":T.STRB_SMS_ON_MY_WAY},{"body":T.STRB_SMS_THANKS},{"body":T.STRB_SMS_WILL_BE_LATE},{
         "body":T.STRB_SMS_MINUTES_LATE,
         "requiresWillBeLateNumber":true
      },{
         "body":T.STRB_SMS_SEE_YOU_IN_MINUTES,
         "requiresSeeYouInNumber":true
      },{"body":T.STRB_SMS_STUCK},{"body":T.STRB_SMS_START_WITHOUT_ME},{"body":T.STRB_SMS_WHERE_ARE_YOU},{"body":T.STRB_SMS_THERE_YET},{"body":T.STRB_SMS_NEED_DIRECTIONS},{"body":T.STRB_SMS_LOST},{"body":T.STRB_SMS_LATER}]);
      
      private const mNewMessageInitListData:Vector.<Object> = Vector.<Object>([{
         "body":T.STRB_SEND_NEW_MESSAGE_WITH,
         "id":1
      },{
         "body":T.STRB_SEND_A_PREDEFINED_MES,
         "id":2
      }]);
      
      private const mNewMessageSeeYouInListData:Vector.<Object> = Vector.<Object>([{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"2"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"5"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"10"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"15"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"20"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"30"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"40"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"45"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"50"]},{"body":[T.STRB_SMS_SEE_YOU_IN_X_MINUTES,"60"]}]);
      
      private const mNewMessageWillBeLateListData:Vector.<Object> = Vector.<Object>([{"body":[T.STRB_SMS_X_MINUTES_LATE,"2"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"5"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"10"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"15"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"20"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"30"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"40"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"45"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"50"]},{"body":[T.STRB_SMS_X_MINUTES_LATE,"60"]}]);
      
      private var mMessageListData:Vector.<Object>;
      
      private var mLastOffset:int = 0;
      
      private var mMsgIndexRelativeToCurPage:int = 0;
      
      private var mCurrentSelectedMsg:SMSMessage = null;
      
      private var mCurrentSelectedRow:MovieClip = null;
      
      private var mCurrentState:String = "inbox";
      
      private var mPreviousState:String = "";
      
      private var mRequestingInitialData:Boolean = true;
      
      private var mVRRequestState:uint = 0;
      
      private var mListenPending:Boolean = false;
      
      private var mVRDialogActive:Boolean = false;
      
      private var mInitalState:String = "";
      
      private var mSMSMaxCountFlag:Boolean = false;
      
      private var mReplyMsgThroughVR:Boolean = false;
      
      private var mForwardMsgThroughVR:Boolean = false;
      
      private var mReplyMsgContext:int = -1;
      
      private var mForwardMsgContext:int = -1;
      
      private var disableBackArrow:Boolean = false;
      
      private var mMessage:SMSMessage = null;
      
      private var mMessageIndexToPlay:int = 0;
      
      private var mMessageID:String;
      
      private var mGroupSideButtons:MovieClip;
      
      private var mGroupMain:MovieClip;
      
      private var mGroupInBox:MovieClip;
      
      private var mGroupNewMessage:MovieClip;
      
      private var mCurrentListenButton:MovieClip;
      
      private var mPopupActive:Boolean = false;
      
      public function SMSMessagingListScreen()
      {
         mView = new C_SMSMessagingListScreenView();
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.mRequestingInitialData = true;
         this.mGroupSideButtons = mView.sideButtons_group;
         this.mGroupMain = mView.displays_group;
         this.mGroupInBox = mView.displays_group.inBox_group;
         this.mGroupNewMessage = mView.displays_group.newMessage_group;
         this.mGroupSideButtons.inBox_button.state = this.STATE_INBOX;
         this.mGroupSideButtons.newMessage_button.state = this.STATE_NEW_MESSAGE;
         this.mGroupMain.setExclusiveChildren(true);
         this.mGroupMain.hideChildren();
         this.mGroupSideButtons.setRadioButtons(true);
         this.mGroupSideButtons.setRequireSelection(true);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Peripheral.smsMessaging.CheckIsSMSSupported();
         if(DynamicPopupNames.SMS_INCOMING_MESSAGE == Framework.popupManager.active)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         }
         Peripheral.smsMessaging.clearIncomingMessage(true);
         this.mRequestingInitialData = true;
         this.configureListAndScroller(this.mGroupInBox.browse_list,this.mGroupInBox.browse_scroller,this.inBoxListInitRowUpdater,this.inBoxListRowUpdater,this.inBoxListDataRequester,this.inBoxListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupNewMessage.browse_list,this.mGroupNewMessage.browse_scroller,null,this.newMessageListRowUpdater,this.newMessageListDataRequester,this.newMessageListSelectionChanger,0);
         t(mView.itemsInList_label,"");
         this.checkIfSmsSendingSupported();
         if(null != screenVars && "inbox" == screenVars)
         {
            this.mCurrentState = this.STATE_INBOX;
         }
         else if(screenVars == "newMessageInit" || screenVars.state == "newMessageInit")
         {
            this.mCurrentState = this.STATE_NEW_MESSAGE_INIT;
            if(Framework.popupManager.active == DynamicPopupNames.SMS_DIAL_PAD)
            {
               Framework.popupManager.dequeue(Framework.popupManager.active);
            }
         }
         else if(screenVars == "newMessageReply" || screenVars.state == "newMessageReply")
         {
            if(Framework.popupManager.active == DynamicPopupNames.PHONEBOOK_SMART_SPELLER)
            {
               Framework.popupManager.dequeue(Framework.popupManager.active);
            }
            this.mInitalState = this.STATE_NEW_MESSAGE_REPLY;
            this.mCurrentState = this.STATE_NEW_MESSAGE_INIT;
         }
         else if(screenVars == "forwardMessage" || screenVars.state == "forwardMessage")
         {
            this.mCurrentState = this.STATE_NEW_MESSAGE_FORWARD;
         }
         else if(screenVars == "inbox" || screenVars.state == "inbox")
         {
            this.mCurrentState = this.STATE_INBOX;
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = null;
         }
         else if(screenVars != null && (Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber != null || screenVars == "predefined"))
         {
            this.gotoPredefinedMessageScreen();
         }
         else
         {
            this.mCurrentState = this.STATE_INBOX;
         }
         this.setScreenViewState(this.mCurrentState);
         this.setNewMsgBtn();
         this.mVRDialogActive = Peripheral.voiceRecognition.VRSessionInProgress;
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.displays_group.newMessage_group.browse_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.sideButtons_group.inBox_button,mView.sideButtons_group.newMessage_button]));
      }
      
      override public function cleanup() : void
      {
         this.mMessageListData = null;
         this.mGroupSideButtons = null;
         this.mGroupMain = null;
         this.mGroupInBox = null;
         this.mGroupNewMessage = null;
         super.cleanup();
      }
      
      override public function screenOut() : void
      {
         Peripheral.smsMessaging.currentSelectedMessageIndex = 0;
         this.mListenPending = false;
         this.mCurrentState = this.STATE_INBOX;
         this.mGroupInBox.browse_list.setPosition(0);
         if(this.mCurrentListenButton != null)
         {
            this.mCurrentListenButton.setHighlight(false);
            this.mCurrentListenButton = null;
         }
         if(this.mCurrentSelectedRow != null)
         {
            this.mCurrentSelectedRow.listen_button.setHighlight(false);
         }
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.back_button,MouseEvent.CLICK,this.onBackButtonClick);
         attachListener(mView.close_button,MouseEvent.CLICK,this.onCloseButtonClick);
         attachListener(this.mGroupSideButtons,WidgetEvent.SELECT,this.onSideButtonsGroupSelect);
         attachListener(this.mGroupNewMessage.browse_list,WidgetEvent.SELECT,this.onNewMessageListSelect);
         attachListener(this.mGroupInBox.browse_list,WidgetEvent.SELECT,this.onInboxListSelect);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH,this.onSMSMessageEvent);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.INBOX_MESSAGE_LIST,this.onSMSMessageEvent);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.REQUESTED_MESSAGE,this.onSMSMessageEvent);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_BKGND_SYNC,this.onSMSMessageEvent);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_SYNC_STATE,this.onSMSMessageEvent);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_REPLY,this.onSMSReply);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_INBOX,this.onSMSReply);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.MESSAGE_READ_STATUS_SUCCESS,this.onReadStatus);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.MESSAGE_SEND_SUCCESS,this.onMessageSendSuccess);
         attachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_FEATURE_SUPPORT,this.onSMSFeatureSupport);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_SEND_INDEXED_SMS_TO_NUMBER,this.onVRSendIndexedSMS,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_MESSAGE_SHOW,this.onVRSmsMessageShow,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_MESSAGE_PLAY,this.onVRSmsMessagePlay,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg,false,0,true);
         attachListener(Peripheral.textToSpeach,TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent);
         attachListener(Peripheral.textToSpeach,TextToSpeechEvent.RESULT,this.onTextToSpeechEvent);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent,false,0,true);
         Framework.structure.addEventListener(StructureEvent.REFRESH_STRUCTURE,this.onRefreshStructure,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Framework.Trace("detaching");
         detachListener(mView.back_button,MouseEvent.CLICK,this.onBackButtonClick);
         detachListener(mView.close_button,MouseEvent.CLICK,this.onCloseButtonClick);
         detachListener(this.mGroupSideButtons,WidgetEvent.SELECT,this.onSideButtonsGroupSelect);
         detachListener(this.mGroupNewMessage.browse_list,WidgetEvent.SELECT,this.onNewMessageListSelect);
         detachListener(this.mGroupInBox.browse_list,WidgetEvent.SELECT,this.onInboxListSelect);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH,this.onSMSMessageEvent);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.INBOX_MESSAGE_LIST,this.onSMSMessageEvent);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.REQUESTED_MESSAGE,this.onSMSMessageEvent);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_BKGND_SYNC,this.onSMSMessageEvent);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_SYNC_STATE,this.onSMSMessageEvent);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_REPLY,this.onSMSReply);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_INBOX,this.onSMSReply);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.MESSAGE_READ_STATUS_SUCCESS,this.onReadStatus);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.MESSAGE_SEND_SUCCESS,this.onMessageSendSuccess);
         detachListener(Peripheral.smsMessaging,SMSMessageEvent.SMS_FEATURE_SUPPORT,this.onSMSFeatureSupport);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_SEND_INDEXED_SMS_TO_NUMBER,this.onVRSendIndexedSMS);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_MESSAGE_SHOW,this.onVRSmsMessageShow);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_MESSAGE_PLAY,this.onVRSmsMessagePlay);
         detachListener(Peripheral.textToSpeach,TextToSpeechEvent.PLAY_STATE,this.onTextToSpeechEvent);
         detachListener(Peripheral.textToSpeach,TextToSpeechEvent.RESULT,this.onTextToSpeechEvent);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         Framework.structure.removeEventListener(StructureEvent.REFRESH_STRUCTURE,this.onRefreshStructure);
         super.removeListeners();
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.sideButtons_group.newMessage_button.value_label,T.STRB_SMS_NEW_MESSAGE);
         t(mView.sideButtons_group.inBox_button.value_label,T.STRB_SMS_INBOX);
         if(Peripheral.vehicleStatus.language == "ja_JP")
         {
            mView.sideButtons_group.inBox_button.value_label.y = 9;
         }
         else
         {
            mView.sideButtons_group.inBox_button.value_label.y = 17;
         }
         this.mGroupNewMessage.browse_list.update();
         this.mGroupInBox.browse_list.update();
      }
      
      private function initBreadcrumb() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MESSAGING_BREADCRUMB));
      }
      
      private function setScreenViewState(state:String) : void
      {
         switch(state)
         {
            case this.STATE_INBOX:
               this.mGroupInBox.show();
               this.mGroupSideButtons.setSelection("inBox_button",false);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.displays_group.inBox_group.browse_list.onFocusCallBack));
               this.initBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_INBOX_BREADCRUMB));
               this.mCurrentState = state;
               this.mPreviousState = "";
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = null;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupInBox.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupInBox.browse_list.selectEventHandler);
               this.mGroupInBox.browse_list.setLength(0);
               if(Peripheral.smsMessaging.isSMSReady)
               {
                  Peripheral.smsMessaging.requestInboxMessageListLength();
                  this.mRequestingInitialData = true;
                  this.mMsgIndexRelativeToCurPage = Peripheral.smsMessaging.currentSelectedMessageIndex % this.SMS_ITEMS_PER_PAGE + 1;
                  this.mGroupInBox.browse_list.setPosition(Peripheral.smsMessaging.currentSelectedMessageIndex + 1 - this.mMsgIndexRelativeToCurPage);
                  this.mGroupInBox.browse_list.setCursor(Peripheral.smsMessaging.currentSelectedMessageIndex);
               }
               if(this.disableBackArrow == true)
               {
                  mView.back_button.setEnabled(true);
                  mView.back_button.setInteractive(true);
                  this.disableBackArrow = false;
               }
               break;
            case this.STATE_NEW_MESSAGE:
               this.mMessageListData = this.mNewMessageListData;
               Framework.structure.goto("mainbackground/menu/smscontactscreen");
               break;
            case this.STATE_NEW_MESSAGE_INIT:
            case this.STATE_NEW_MESSAGE_REPLY:
            case this.STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN:
            case this.STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE:
            case this.STATE_NEW_MESSAGE_PREDEFINED:
               this.mGroupNewMessage.show();
               this.mGroupSideButtons.setSelection("newMessage_button",false);
               this.initBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_NEW_MESSAGE_BREADCRUMB));
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupNewMessage.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupNewMessage.browse_list.selectEventHandler);
               if(state == this.STATE_NEW_MESSAGE_REPLY)
               {
                  this.mMessageListData = this.mNewMessageInitListData;
               }
               else if(state == this.STATE_NEW_MESSAGE_INIT)
               {
                  this.mMessageListData = this.mNewMessageInitListData;
                  if(this.disableBackArrow == true)
                  {
                     mView.back_button.setEnabled(false);
                     mView.back_button.setInteractive(false);
                  }
               }
               else if(state == this.STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN)
               {
                  this.mMessageListData = this.mNewMessageSeeYouInListData;
               }
               else if(state == this.STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE)
               {
                  this.mMessageListData = this.mNewMessageWillBeLateListData;
               }
               else if(this.STATE_NEW_MESSAGE_PREDEFINED == state)
               {
                  this.gotoPredefinedMessageScreen();
               }
               this.mGroupNewMessage.browse_list.setLength(0);
               this.mGroupNewMessage.browse_list.setLength(this.mMessageListData.length);
               this.updateItemsInListText(this.mMessageListData.length);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.displays_group.newMessage_group.browse_list.onFocusCallBack));
               break;
            case this.STATE_NEW_MESSAGE_FORWARD:
               if(Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber != null)
               {
                  Framework.structure.goto("mainbackground/menu/smscontactscreen","forwardMessage");
                  Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                     "type":PopupType.PRIMARY,
                     "task":"send outgoing"
                  });
               }
         }
         this.mPreviousState = this.mCurrentState;
         this.mCurrentState = state;
         Framework.focusManager.refresh();
      }
      
      private function inBoxListInitRowUpdater(row:MovieClip, rowIndex:int, data:SMSMessage, dataIndex:int) : void
      {
         attachListener(row.row_button,MouseEvent.CLICK,this.onRowButtonClick);
         attachListener(row.listen_button,MouseEvent.CLICK,this.onListenButtonClick);
         attachListener(row.view_button,MouseEvent.CLICK,this.onViewButtonClick);
         if(true == Peripheral.vehicleStatus.speedLockOut)
         {
            row.view_button.setInteractive(false);
            row.view_button.setEnabled(false);
         }
         else
         {
            row.view_button.setInteractive(true);
            row.view_button.setEnabled(true);
         }
      }
      
      private function inBoxListRowUpdater(row:MovieClip, rowIndex:int, data:SMSMessage, dataIndex:int) : void
      {
         var temp:String = null;
         var checkBoxButton:MovieClip = row.checkBox_button;
         row.data = data;
         if(data)
         {
            row.view_button.value_label.text = compose(T.STRB_SMS_VIEW);
            row.listen_button.value_label.text = compose(T.STRB_SMS_LISTEN);
            row.listen_button.setInteractive(true);
            row.view_button.setInteractive(true);
            row.row_button.setInteractive(true);
            if(Peripheral.smsManager.listenSMSID == row.data.id)
            {
               row.listen_button.setHighlight(true);
            }
            else
            {
               row.listen_button.setHighlight(false);
            }
            if(data.from != "" && data.from != data.phoneNumber)
            {
               row.row_button.value_label.text = data.from;
            }
            else
            {
               row.row_button.value_label.text = Format.phoneNumber(data.phoneNumber);
            }
            row.row_button.value_label.text = dataIndex + 1 + ")" + " " + row.row_button.value_label.text;
            temp = row.row_button.value_label.text;
            t(row.row_button.value_label,temp);
            if(data.isRead == true)
            {
               row.row_button.readMail.visible = true;
               row.row_button.unreadMail.visible = false;
            }
            else
            {
               row.row_button.readMail.visible = false;
               row.row_button.unreadMail.visible = true;
            }
            row.listen_button.value_label.visible = true;
            row.view_button.value_label.visible = true;
            row.listen_button.visible = true;
            row.view_button.visible = true;
            row.row_button.value_label.visible = true;
            row.show();
            if(this.mCurrentSelectedRow != null && ObjectUtil.compare(this.mCurrentSelectedRow.data,data) == 0)
            {
               this.mCurrentSelectedMsg = row.data;
            }
         }
         else if(row.name == "row_0_group")
         {
            if(this.mRequestingInitialData)
            {
               t(row.row_button.value_label,"");
            }
            else
            {
               t(row.row_button.value_label,T.STRB_SMS_NO_MESSAGE);
            }
            row.row_button.readMail.visible = false;
            row.row_button.unreadMail.visible = false;
            row.listen_button.visible = false;
            row.view_button.visible = false;
            row.show();
         }
         else
         {
            row.listen_button.value_label.visible = false;
            row.view_button.value_label.visible = false;
            row.row_button.value_label.visible = false;
            row.row_button.readMail.visible = false;
            row.row_button.unreadMail.visible = false;
            row.listen_button.setInteractive(false);
            row.view_button.setInteractive(false);
            row.row_button.setInteractive(false);
         }
         if(this.mCurrentListenButton != null)
         {
            this.mCurrentListenButton.setHighlight(false);
            this.mCurrentListenButton = null;
         }
      }
      
      private function inBoxListDataRequester(start:int, end:int) : void
      {
         this.mLastOffset = start;
         var length:int = end - start + 1;
         Peripheral.smsMessaging.requestInboxMessageList(start,length);
         this.mRequestingInitialData = true;
      }
      
      private function inBoxListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
         if(this.STATE_INBOX == this.mCurrentState && selected)
         {
            this.mCurrentSelectedRow = row;
            this.mCurrentSelectedMsg = row.data;
         }
      }
      
      private function newMessageListRowUpdater(row:MovieClip, rowIndex:int, data:Object, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         var checkBoxButton:MovieClip = row.checkBox_button;
         rowButton.arrow.visible = false;
         if(data)
         {
            if(T.STRB_SEND_NEW_MESSAGE_WITH == data.body || T.STRB_SEND_A_PREDEFINED_MES == data.body)
            {
               rowButton.arrow.visible = true;
               rowButton.value_label.text = compose(data.body);
               if(T.STRB_SEND_A_PREDEFINED_MES == data.body)
               {
                  rowButton.setEnabled(!Peripheral.vehicleStatus.speedLockOut);
               }
            }
            else if(data.requiresWillBeLateNumber == true || data.requiresSeeYouInNumber == true)
            {
               rowButton.arrow.visible = true;
               rowButton.value_label.text = dataIndex + 1 + ") " + compose([data.body,"<XX>"]);
            }
            else
            {
               rowButton.value_label.text = dataIndex + 1 + ") " + compose(data.body);
            }
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function newMessageListDataRequester(start:int, end:int) : void
      {
         var list:Array = new Array();
         if(end > this.mNewMessageListData.length)
         {
            end = int(this.mMessageListData.length);
         }
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mMessageListData[i]);
         }
         this.mGroupNewMessage.browse_list.setData({
            "offset":start,
            "list":list
         });
      }
      
      private function newMessageListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function configureListAndScroller(browseList:MovieClip, browseScroller:MovieClip, initRowUpdater:Function = null, rowUpdater:Function = null, dataRequester:Function = null, selectionChanger:Function = null, listLength:int = 0) : void
      {
         browseList.attachScroller(browseScroller);
         if(initRowUpdater != null)
         {
            browseList.setRowUpdater(initRowUpdater);
            browseList.update();
         }
         if(rowUpdater != null)
         {
            browseList.setRowUpdater(rowUpdater);
         }
         if(dataRequester != null)
         {
            browseList.setDataRequester(dataRequester);
         }
         if(selectionChanger != null)
         {
            browseList.setSelectionChanger(selectionChanger);
         }
         browseList.setLength(listLength);
         browseScroller.setReportingPeriod(100);
         browseScroller.setValue(0);
         browseList.update();
      }
      
      private function updateItemsInListText(itemAmount:int = 0) : void
      {
         t(mView.itemsInList_label,Format.itemsInList(itemAmount));
      }
      
      private function onDeviceChange(e:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBackButtonClick(null);
      }
      
      private function onBackButtonClick(evt:MouseEvent) : void
      {
         if(this.mCurrentState == this.STATE_INBOX)
         {
            Framework.structure.exit();
         }
         else if(this.STATE_NEW_MESSAGE_REPLY == this.mInitalState && this.STATE_NEW_MESSAGE_INIT == this.mCurrentState)
         {
            this.setScreenViewState(this.STATE_INBOX);
         }
         else if(this.STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN == this.mCurrentState || this.STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE == this.mCurrentState)
         {
            this.gotoPredefinedMessageScreen();
         }
         else if(this.STATE_NEW_MESSAGE_PREDEFINED == this.mCurrentState)
         {
            this.setScreenViewState(this.STATE_NEW_MESSAGE_INIT);
         }
         else if(this.mCurrentState != this.STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN && this.mCurrentState != this.STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE)
         {
            Framework.structure.back();
         }
         else
         {
            this.setScreenViewState(this.mPreviousState);
         }
      }
      
      private function onCloseButtonClick(evt:MouseEvent) : void
      {
         Peripheral.smsMessaging.clearOutgoingMessage();
         Framework.structure.exit();
      }
      
      private function onStateSettingButtonClick(evt:MouseEvent) : void
      {
         this.setScreenViewState(evt.currentTarget.state);
      }
      
      private function onSideButtonsGroupSelect(evt:WidgetEvent) : void
      {
         var msgType:String = null;
         if("inBox_button" == evt.data.targetName)
         {
            this.mCurrentState = this.STATE_INBOX;
         }
         if(evt.data.targetName == "newMessage_button" && Boolean(Peripheral.bluetoothPhone.bluetoothHFP.isSiriFeatureSupported))
         {
            Framework.popupManager.show(DynamicPopupNames.SIRI_PRESS_AND_HOLD,"popup1item",{
               "timeout":10000,
               "type":PopupType.PRIMARY,
               "title":"",
               "message":T.STRB_PRESS_AND_HOLD_THE_VOICE_ML,
               "caption1":T.STRB_OK,
               "showClose":true
            });
         }
         else if(evt.data.targetName == "newMessage_button" && true == Peripheral.smsMessaging.isSendSupported)
         {
            msgType = "new";
            this.mGroupSideButtons.newMessage_button.setSelected(true);
            this.mCurrentState = this.STATE_NEW_MESSAGE;
            this.setScreenViewState(this.mCurrentState);
         }
         else if(false == Peripheral.smsMessaging.isSendSupported && "newMessage_button" == evt.data.targetName)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "timeout":this.SMS_POPUPS_TIMEOUT,
               "status":"sms not supported"
            });
            this.mGroupSideButtons.inBox_button.setSelected(true);
         }
         else
         {
            this.setScreenViewState(this.mGroupSideButtons[evt.data.targetName].state);
         }
      }
      
      private function onRowButtonClick(evt:MouseEvent) : void
      {
         var message:SMSMessage = null;
         if(true == Peripheral.vehicleStatus.speedLockOut)
         {
            if(!Peripheral.textToSpeach.isTTSPlaying)
            {
               if(evt.currentTarget.parent.data != null)
               {
                  this.playMessage(evt.currentTarget.parent.data);
                  Framework.popupManager.show(DynamicPopupNames.SMS_INCOMING_MESSAGE,"popupincomingsms",{
                     "type":PopupType.PRIMARY,
                     "task":"listen",
                     "smsObject":evt.currentTarget.parent.data
                  });
               }
            }
            else
            {
               Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
            }
         }
         else
         {
            message = evt.currentTarget.parent.data;
            if(message != null)
            {
               Peripheral.smsMessaging.requestMessage(message.id);
            }
         }
      }
      
      private function onListenButtonClick(evt:MouseEvent) : void
      {
         if(!Peripheral.textToSpeach.isTTSPlaying)
         {
            this.mCurrentListenButton = evt.currentTarget as MovieClip;
            this.playMessage(evt.currentTarget.parent.data);
            Framework.popupManager.show(DynamicPopupNames.SMS_INCOMING_MESSAGE,"popupincomingsms",{
               "type":PopupType.PRIMARY,
               "task":"listen",
               "smsObject":evt.currentTarget.parent.data
            });
            this.mPopupActive = true;
         }
         else
         {
            Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
         }
      }
      
      private function setNewMsgBtn() : void
      {
         if(false == Peripheral.smsMessaging.isSendSupported)
         {
            this.mGroupSideButtons.newMessage_button.setEnabled(false);
            this.mGroupSideButtons.newMessage_button.setSelected(false);
         }
         else
         {
            this.mGroupSideButtons.newMessage_button.setEnabled(true);
         }
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut == true)
         {
            if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL)
            {
               Framework.popupManager.dequeue(Framework.popupManager.active);
               Peripheral.smsMessaging.clearIncomingMessage();
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
            }
            if(this.mCurrentState != this.STATE_NEW_MESSAGE_DICTATION && this.mCurrentState != this.STATE_INBOX)
            {
               this.mCurrentState = this.STATE_INBOX;
               this.setScreenViewState(this.mCurrentState);
               if(Framework.popupManager.active != DynamicPopupNames.SMS_SPEED_LOCKOUT)
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.SMS_SPEED_LOCKOUT);
               }
            }
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_SPEED_LOCKOUT);
            Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
         this.onSMSInboxSpeedLockOut();
         this.setNewMsgBtn();
      }
      
      private function onInboxListSelect(evt:WidgetEvent) : void
      {
         if("browse_list" == evt.data.targetName)
         {
            if(!Peripheral.textToSpeach.isTTSPlaying)
            {
               this.playMessage(evt.data.data);
            }
            else
            {
               Peripheral.textToSpeach.abort(Peripheral.textToSpeach.READOUT_TYPE_SMS);
            }
         }
      }
      
      private function onViewButtonClick(evt:MouseEvent) : void
      {
         var message:SMSMessage = null;
         if(true == Peripheral.vehicleStatus.speedLockOut)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            message = evt.currentTarget.parent.data;
            Peripheral.smsMessaging.isVrMessageListen = false;
            Peripheral.smsMessaging.requestMessage(message.id);
         }
      }
      
      private function onNewMessageListSelect(evt:WidgetEvent) : void
      {
         var msgType:String = null;
         if(this.disableBackArrow == true)
         {
            mView.back_button.setEnabled(true);
            mView.back_button.setInteractive(true);
         }
         var obj:Object = evt.data.data;
         if(Boolean(obj.requiresSeeYouInNumber) || Boolean(obj.requiresWillBeLateNumber))
         {
            if(obj.requiresSeeYouInNumber)
            {
               this.setScreenViewState(this.STATE_NEW_MESSAGE_WITH_NUMBER_SEE_YOU_IN);
            }
            else if(obj.requiresWillBeLateNumber)
            {
               this.setScreenViewState(this.STATE_NEW_MESSAGE_WITH_NUMBER_WILL_BE_LATE);
            }
         }
         else if(obj.id)
         {
            switch(obj.id)
            {
               case 1:
                  msgType = "new";
                  if(this.mInitalState == this.STATE_NEW_MESSAGE_REPLY)
                  {
                     msgType = "reply";
                  }
                  Peripheral.smsMessaging.startSMSDictation(msgType,true);
                  this.mCurrentState = this.STATE_NEW_MESSAGE_DICTATION;
                  break;
               case 2:
                  if(Peripheral.vehicleStatus.speedLockOut == true)
                  {
                     Ancillary.definedDynamicPopups.popup(DynamicPopupNames.SMS_SPEED_LOCKOUT);
                  }
                  else
                  {
                     this.gotoPredefinedMessageScreen();
                  }
            }
         }
         else
         {
            Peripheral.smsMessaging.outgoingMessageBody = compose(obj.body);
            if(Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber != null)
            {
               Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                  "type":PopupType.PRIMARY,
                  "task":"send outgoing"
               });
            }
            else
            {
               Framework.structure.goto("mainbackground/menu/smscontactscreen");
            }
         }
      }
      
      private function onSMSMessageEvent(evt:SMSMessageEvent) : void
      {
         var msgView:SMSMessage = null;
         var messages:Vector.<SMSMessage> = null;
         var result:String = null;
         var success:Boolean = false;
         var phoneCategory:String = null;
         var SMSMsgView:SMSMessage = null;
         var phoneNumber:String = null;
         var senderName:String = null;
         var phoneNumberType:String = null;
         switch(evt.type)
         {
            case SMSMessageEvent.INBOX_MESSAGE_LIST_LENGTH:
               this.mRequestingInitialData = false;
               if(this.mCurrentState == this.STATE_INBOX)
               {
                  if(Peripheral.smsMessaging.inboxMessageListLength == 0)
                  {
                     this.mGroupInBox.browse_list.setLength(1);
                  }
                  else
                  {
                     this.mGroupInBox.browse_list.setLength(Peripheral.smsMessaging.inboxMessageListLength);
                  }
                  this.updateItemsInListText(Peripheral.smsMessaging.inboxMessageListLength);
                  if(this.MAX_SMS_COUNT == Peripheral.smsMessaging.inboxMessageListLength)
                  {
                     this.mSMSMaxCountFlag = true;
                  }
               }
               break;
            case SMSMessageEvent.INBOX_MESSAGE_LIST:
               this.mRequestingInitialData = false;
               if(this.VR_VIEW_SINGLE_MSG == this.mVRRequestState || this.VR_PLAY_SINGLE_MSG == this.mVRRequestState && (this.mMsgIndexRelativeToCurPage > 0 && this.mMsgIndexRelativeToCurPage <= Peripheral.smsMessaging.inboxMessageList.length))
               {
                  msgView = Peripheral.smsMessaging.inboxMessageList[this.mMsgIndexRelativeToCurPage - 1];
                  if(false == msgView.isRead)
                  {
                     Peripheral.smsMessaging.smsReadStatus(String(msgView.id));
                  }
                  if(this.VR_PLAY_SINGLE_MSG != this.mVRRequestState)
                  {
                     this.mVRRequestState = this.VR_REQUEST_NONE;
                  }
                  Peripheral.smsMessaging.requestMessage(msgView.id);
                  this.mCurrentSelectedMsg = msgView;
               }
               else if(this.mCurrentState == this.STATE_INBOX)
               {
                  messages = Peripheral.smsMessaging.inboxMessageList;
                  if(this.mReplyMsgThroughVR || this.mForwardMsgThroughVR)
                  {
                     result = "failure";
                     success = false;
                     phoneCategory = null;
                     SMSMsgView = Peripheral.smsMessaging.inboxMessageList[this.mMsgIndexRelativeToCurPage - 1];
                     phoneNumber = SMSMsgView.phoneNumber;
                     senderName = "";
                     phoneNumberType = "";
                     if(phoneNumber != null && phoneNumber != "")
                     {
                        senderName = SMSMsgView.from;
                        phoneNumberType = SMSMsgView.phoneNumberType;
                        if(senderName == phoneNumber)
                        {
                           senderName = "";
                        }
                        result = "success";
                     }
                     switch(phoneNumberType)
                     {
                        case "mobileNumber":
                        case "mobile":
                           phoneCategory = "mobile";
                           break;
                        case "homeNumber":
                        case "home":
                           phoneCategory = "home";
                           break;
                        case "workNumber":
                        case "work":
                           phoneCategory = "work";
                           break;
                        case "otherNumber":
                        case "other":
                           phoneCategory = "other";
                           break;
                        default:
                           phoneCategory = "";
                     }
                     if(this.mReplyMsgThroughVR)
                     {
                        this.mReplyMsgThroughVR = false;
                        Peripheral.voiceRecognition.emitSmsVRResponse(this.mReplyMsgContext,"smsGetDetails",result,null,phoneNumber,false,senderName,phoneCategory);
                     }
                     if(this.mForwardMsgThroughVR)
                     {
                        this.mForwardMsgThroughVR = false;
                        Peripheral.smsMessaging.outgoingMessageBody = SMSMsgView.body + "\n\n" + compose([T.STRB_SENT_BY_MY_X,Peripheral.vehConfig.vehicleBrandName]);
                        success = Boolean(Peripheral.smsMessaging.sendOutgoingMessage());
                        Peripheral.voiceRecognition.emitSmsVRResponse(this.mForwardMsgContext,"sendIndexedSmstoNumber",success ? "success" : "failure",null,null);
                     }
                  }
                  messages = messages.slice(0,messages.length);
                  this.mGroupInBox.browse_list.setLength(Peripheral.smsMessaging.inboxMessageListLength);
                  this.updateItemsInListText(Peripheral.smsMessaging.inboxMessageListLength);
                  if(messages.length > 0)
                  {
                     this.mGroupInBox.browse_list.setData({
                        "offset":this.mLastOffset,
                        "list":messages
                     });
                  }
                  if(this.mSMSMaxCountFlag)
                  {
                     this.mSMSMaxCountFlag = false;
                     this.mGroupInBox.browse_list.requestData();
                  }
               }
               break;
            case SMSMessageEvent.REQUESTED_MESSAGE:
               if(!Peripheral.vehicleStatus.speedLockOut && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Framework.popupManager.show(DynamicPopupNames.SMS_MESSAGE_FULL,"popupsmsmessagefull",{
                     "type":PopupType.PRIMARY,
                     "task":"view requested",
                     "multiMessage":Peripheral.smsMessaging.incomingMessageCount > 1
                  });
               }
               if(this.VR_PLAY_SINGLE_MSG == this.mVRRequestState)
               {
                  if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL && !Peripheral.textToSpeach.isTTSPlaying)
                  {
                     Framework.messenger.send({
                        "type":"highlightListenSMSMessageFullPopup",
                        "msgId":this.mCurrentSelectedMsg.id
                     });
                  }
                  this.playMessage(this.mCurrentSelectedMsg);
               }
               else if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL && Boolean(Peripheral.textToSpeach.isTTSPlaying))
               {
                  Framework.messenger.send({
                     "type":"doNotHighlightListenSMSMessageFullPopup",
                     "msgId":this.mCurrentSelectedMsg.id
                  });
               }
               Peripheral.smsMessaging.isVrMessageListen = false;
               break;
            case SMSMessageEvent.SMS_BKGND_SYNC:
               if(Boolean(Peripheral.smsMessaging.isSMSReady) && Framework.structure.currentBranch == "mainbackground/menu/smsmessaginglistscreen" && Framework.popupManager.active != DynamicPopupNames.SMS_INCOMING_MESSAGE && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Peripheral.smsMessaging.requestInboxMessageListLength();
                  this.mRequestingInitialData = true;
               }
               break;
            case SMSMessageEvent.SMS_SYNC_STATE:
               if(Boolean(Peripheral.smsMessaging.isSMSReady) && Framework.structure.currentBranch == "mainbackground/menu/smsmessaginglistscreen" && Framework.popupManager.active != DynamicPopupNames.SMS_INCOMING_MESSAGE && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Peripheral.smsMessaging.requestInboxMessageListLength();
                  this.mRequestingInitialData = true;
                  this.setScreenViewState(this.mCurrentState);
               }
         }
      }
      
      private function onSMSReply(evt:SMSMessageEvent) : void
      {
         switch(evt.type)
         {
            case SMSMessageEvent.SMS_REPLY:
               this.mInitalState = this.STATE_NEW_MESSAGE_REPLY;
               this.mCurrentState = this.STATE_NEW_MESSAGE_INIT;
               this.disableBackArrow = true;
               this.setScreenViewState(this.mCurrentState);
               break;
            case SMSMessageEvent.SMS_INBOX:
               this.setScreenViewState(this.STATE_INBOX);
         }
      }
      
      private function onTextToSpeechEvent(evt:TextToSpeechEvent) : void
      {
         var msgID:int = 0;
         var rowID:int = 0;
         if(!Peripheral.textToSpeach.isTTSPlaying)
         {
            if(this.mListenPending)
            {
               this.mListenPending = false;
               this.playMessage(this.mCurrentSelectedMsg);
            }
         }
         else
         {
            if("playStart" == Peripheral.textToSpeach.playState)
            {
               if(this.VR_PLAY_ALL_NEW_MSG == this.mVRRequestState)
               {
                  if((null != evt.mData.msgID || "" != evt.mData.msgID) && 0 != evt.mData.msgID)
                  {
                     msgID = int(evt.mData.msgID) * -1;
                     this.mMessageID = msgID.toString();
                     rowID = this.getInboxIndexNumber(this.mMessageID);
                     if(rowID >= 0 && rowID <= this.SMS_ITEMS_PER_PAGE)
                     {
                        this.mCurrentSelectedRow = mView.displays_group.inBox_group.browse_list["row_" + rowID + "_group"];
                     }
                  }
               }
            }
            if(null != this.mCurrentSelectedRow)
            {
               this.mCurrentSelectedRow.listen_button.setHighlight(true);
            }
         }
         if(!Peripheral.textToSpeach.isTTSPlaying && null != this.mCurrentSelectedRow && ("playEnd" == Peripheral.textToSpeach.playState || "aborted" == Peripheral.textToSpeach.playState || "playError" == Peripheral.textToSpeach.playState))
         {
            this.mCurrentSelectedRow.listen_button.setHighlight(false);
            this.mCurrentSelectedRow = null;
         }
      }
      
      private function getInboxIndexNumber(msgID:String) : int
      {
         for(var i:int = 0; i < Peripheral.smsMessaging.inboxMessageList.length; i++)
         {
            if(msgID == Peripheral.smsMessaging.inboxMessageList[i].id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function onVRDialogActiveMsg(evt:VoiceRecognitionEvent) : void
      {
         if(evt != null && evt.mData != null)
         {
            this.mVRDialogActive = evt.mData.vrDialogActive.state;
            if(!this.mVRDialogActive && this.mListenPending)
            {
               this.mListenPending = false;
               this.playMessage(this.mCurrentSelectedMsg);
               if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL && !Peripheral.textToSpeach.isTTSPlaying)
               {
                  Framework.messenger.send({
                     "type":"highlightListenSMSMessageFullPopup",
                     "msgId":this.mCurrentSelectedMsg.id
                  });
               }
            }
            else if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL && Boolean(Peripheral.textToSpeach.isTTSPlaying))
            {
               Framework.messenger.send({
                  "type":"doNotHighlightListenSMSMessageFullPopup",
                  "msgId":this.mCurrentSelectedMsg.id
               });
            }
            if(this.mCurrentListenButton != null)
            {
               this.mCurrentListenButton.setHighlight(false);
            }
         }
      }
      
      private function onVRSendIndexedSMS(evt:VoiceRecognitionEvent) : void
      {
         var message:SMSMessage = null;
         if(Peripheral.smsMessaging.incomingMessageCount > 1 && Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",false,null);
            return;
         }
         var success:Boolean = false;
         var vehicleBrand:String = Peripheral.vehConfig.vehicleBrandName;
         var messageIndexToSend:int = int(evt.mData.messageIndex);
         if(evt.mData.phoneNumber != null && evt.mData.phoneNumber != "")
         {
            if(-1 == messageIndexToSend)
            {
               if(this.mCurrentSelectedMsg != null && Peripheral.smsMessaging.inboxMessageListLength > 0)
               {
                  Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = evt.mData.phoneNumber;
                  Peripheral.smsMessaging.outgoingMessageBody = this.mCurrentSelectedMsg.body + "\n\n" + compose([T.STRB_SENT_BY_MY_X,vehicleBrand]);
                  success = Boolean(Peripheral.smsMessaging.sendOutgoingMessage());
               }
            }
            else if(messageIndexToSend > 0 && messageIndexToSend <= Peripheral.smsMessaging.inboxMessageListLength)
            {
               this.updateRelativeIndexToCurPage(evt.mData.messageIndex);
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = evt.mData.phoneNumber;
               this.mMsgIndexRelativeToCurPage = messageIndexToSend % this.SMS_ITEMS_PER_PAGE;
               if(0 == this.mMsgIndexRelativeToCurPage)
               {
                  this.mMsgIndexRelativeToCurPage = this.SMS_ITEMS_PER_PAGE;
               }
               this.mForwardMsgThroughVR = true;
               this.mForwardMsgContext = int(evt.mData.context);
               Peripheral.smsMessaging.requestInboxMessageList(messageIndexToSend - this.mMsgIndexRelativeToCurPage,this.SMS_ITEMS_PER_PAGE);
               return;
            }
         }
         Framework.Trace("success: " + success);
         Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,success ? "success" : "failure",null,null);
      }
      
      private function onVRSmsGetDetails(evt:VoiceRecognitionEvent) : void
      {
         var mRelativeIndexNumberForReply:int = 0;
         var message:SMSMessage = null;
         var result:String = "failure";
         var phoneNumber:String = "";
         var senderName:String = "";
         var phoneNumberType:String = null;
         var phoneCategory:String = null;
         if(Framework.structure.currentBranch == "mainbackground/menu/smsmessaginglistscreen")
         {
            if(this.STATE_NEW_MESSAGE_DICTATION == this.mCurrentState)
            {
               phoneNumber = Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber;
               senderName = Peripheral.smsMessaging.outgoingMessageRecipientName;
               phoneNumberType = Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType;
               if(senderName == phoneNumber)
               {
                  senderName = "";
               }
               result = "success";
            }
            else
            {
               if(evt.mData.messageIndex > 0 && evt.mData.messageIndex <= Peripheral.smsMessaging.inboxMessageListLength)
               {
                  mRelativeIndexNumberForReply = int(evt.mData.messageIndex);
                  this.mMsgIndexRelativeToCurPage = mRelativeIndexNumberForReply % this.SMS_ITEMS_PER_PAGE;
                  if(0 == this.mMsgIndexRelativeToCurPage)
                  {
                     this.mMsgIndexRelativeToCurPage = this.SMS_ITEMS_PER_PAGE;
                  }
                  this.mReplyMsgThroughVR = true;
                  this.mReplyMsgContext = int(evt.mData.context);
                  Peripheral.smsMessaging.requestInboxMessageList(mRelativeIndexNumberForReply - this.mMsgIndexRelativeToCurPage,this.SMS_ITEMS_PER_PAGE);
                  return;
               }
               if(evt.mData.messageIndex == -1)
               {
                  if(this.mCurrentSelectedMsg != null && Peripheral.smsMessaging.inboxMessageListLength > 0)
                  {
                     phoneNumber = this.mCurrentSelectedMsg.phoneNumber;
                     if(phoneNumber != null && phoneNumber != "")
                     {
                        senderName = this.mCurrentSelectedMsg.from;
                        if(senderName == phoneNumber)
                        {
                           senderName = "";
                        }
                        phoneNumberType = this.mCurrentSelectedMsg.phoneNumberType;
                        result = "success";
                     }
                  }
               }
            }
            if("success" == result)
            {
               switch(phoneNumberType)
               {
                  case "mobileNumber":
                  case "mobile":
                     phoneCategory = "mobile";
                     break;
                  case "homeNumber":
                  case "home":
                     phoneCategory = "home";
                     break;
                  case "workNumber":
                  case "work":
                     phoneCategory = "work";
                     break;
                  case "otherNumber":
                  case "other":
                     phoneCategory = "other";
                     break;
                  default:
                     phoneCategory = "";
               }
            }
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,result,null,phoneNumber,false,senderName,phoneCategory);
         }
      }
      
      private function onVRSmsMessageShow(evt:VoiceRecognitionEvent) : void
      {
         var messageListen:Boolean = false;
         if(Peripheral.smsMessaging.incomingMessageCount > 1 && evt.mData.type != "allNew" && Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE && !messageListen)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",false,null);
            return;
         }
         Framework.Trace("onVRSmsMessageShow SMS Messaing List Screen");
         var messageIndexToShow:int = int(evt.mData.messageIndexNo);
         var context:int = int(evt.mData.context);
         var messageShown:Boolean = false;
         messageListen = Boolean(evt.mData.messageListen);
         var mMessage:Object = null;
         Peripheral.smsMessaging.isVrMessageListen = messageListen;
         if(Framework.popupManager.active == DynamicPopupNames.VOICE_PICK_LIST)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.VOICE_PICK_LIST);
         }
         if(!Peripheral.vehicleStatus.speedLockOut || messageListen)
         {
            if(-1 == messageIndexToShow)
            {
               if(this.mPopupActive == true && null == Peripheral.smsMessaging.incomingMessage)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
                  this.mPopupActive = false;
               }
               if(Framework.popupManager.active != DynamicPopupNames.SMS_INCOMING_MESSAGE && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL && null == Peripheral.smsMessaging.incomingMessage)
               {
                  if(this.mCurrentSelectedMsg != null && Peripheral.smsMessaging.inboxMessageListLength > 0)
                  {
                     if(false == this.mCurrentSelectedMsg.isRead)
                     {
                        Peripheral.smsMessaging.smsReadStatus(String(this.mCurrentSelectedMsg.id));
                     }
                     Peripheral.smsMessaging.requestMessage(this.mCurrentSelectedMsg.id);
                     messageShown = true;
                  }
               }
               else
               {
                  mMessage = this.getMostRecentMessage();
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
            else
            {
               if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL)
               {
                  Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",false,null);
                  return;
               }
               if(messageIndexToShow > 0 && messageIndexToShow <= Peripheral.smsMessaging.inboxMessageListLength)
               {
                  if(this.VR_PLAY_SINGLE_MSG != this.mVRRequestState)
                  {
                     this.mVRRequestState = this.VR_VIEW_SINGLE_MSG;
                  }
                  this.updateRelativeIndexToCurPage(messageIndexToShow);
                  Peripheral.smsMessaging.requestInboxMessageList(messageIndexToShow - this.mMsgIndexRelativeToCurPage,Peripheral.smsMessaging.inboxMessageList.length);
                  messageShown = true;
               }
            }
            messageShown = true;
         }
         Peripheral.voiceRecognition.emitSmsVRResponse(context,evt.mData.methodName,"success",null,null,messageShown);
      }
      
      private function onVRSmsMessagePlay(evt:VoiceRecognitionEvent) : void
      {
         var messageIndexToPlay:int = 0;
         if(evt.mData.type == "allNew")
         {
            this.mVRRequestState = this.VR_PLAY_ALL_NEW_MSG;
         }
         var msgIndex:int = int(evt.mData.messageIndexNo);
         var mMessage:Object = null;
         if(evt.mData.type == "current" && msgIndex == -1)
         {
            if(Framework.popupManager.active == DynamicPopupNames.SMS_INCOMING_MESSAGE && Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL || Boolean(Peripheral.vehicleStatus.speedLockOut))
            {
               mMessage = this.getMostRecentMessage();
               if(mMessage)
               {
                  Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",true,null);
                  if(false == mMessage.isRead)
                  {
                     Peripheral.smsMessaging.smsReadStatus(String(mMessage.id));
                  }
                  Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,mMessage.body);
                  if(Framework.popupManager.active == DynamicPopupNames.SMS_MESSAGE_FULL)
                  {
                     Peripheral.smsMessaging.checkViewMessageActive(true);
                  }
               }
               else
               {
                  Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",true,null);
               }
            }
            else if(Framework.popupManager.active != DynamicPopupNames.SMS_INCOMING_MESSAGE || Framework.popupManager.active != DynamicPopupNames.SMS_MESSAGE_FULL)
            {
               if(this.mCurrentSelectedMsg != null && Peripheral.smsMessaging.inboxMessageListLength > 0)
               {
                  Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",true,null);
                  this.playMessage(this.mCurrentSelectedMsg);
               }
               else
               {
                  Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"failure",true,null);
               }
            }
         }
         else if(msgIndex > 0 && msgIndex <= Peripheral.smsMessaging.inboxMessageListLength)
         {
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,"success",true,null);
            messageIndexToPlay = 0;
            this.mVRRequestState = this.VR_PLAY_SINGLE_MSG;
            this.mPreviousState = this.mCurrentState;
            this.mCurrentState = this.STATE_PLAY_MESSAGE_BY_INDEX;
            messageIndexToPlay = msgIndex;
            this.updateRelativeIndexToCurPage(messageIndexToPlay);
            Peripheral.smsMessaging.requestInboxMessageList(messageIndexToPlay - this.mMsgIndexRelativeToCurPage,this.SMS_ITEMS_PER_PAGE);
         }
      }
      
      private function getMostRecentMessage() : Object
      {
         this.mMessage = null;
         if(Peripheral.smsMessaging.incomingMessageCount > 1)
         {
            this.mMessage = Peripheral.smsMessaging.lastMessageReceived;
         }
         if(Peripheral.smsMessaging.incomingMessage != null)
         {
            this.mMessage = Peripheral.smsMessaging.incomingMessage;
         }
         else if(Peripheral.smsMessaging.previousIncomingMessage != null)
         {
            this.mMessage = Peripheral.smsMessaging.previousIncomingMessage;
         }
         return this.mMessage;
      }
      
      private function updateRelativeIndexToCurPage(nIndex:int) : void
      {
         this.mMsgIndexRelativeToCurPage = nIndex % this.SMS_ITEMS_PER_PAGE;
         if(0 == this.mMsgIndexRelativeToCurPage)
         {
            this.mMsgIndexRelativeToCurPage = this.SMS_ITEMS_PER_PAGE;
         }
      }
      
      private function playMessage(message:SMSMessage) : void
      {
         if(message)
         {
            if(!this.mVRDialogActive && !Peripheral.textToSpeach.isTTSPlaying)
            {
               this.mListenPending = false;
               if(false == message.isRead)
               {
                  Peripheral.smsMessaging.smsReadStatus(String(message.id));
               }
               Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_SMS,message.body);
               Peripheral.smsMessaging.playingMessageID = message.id;
               this.mVRRequestState = this.VR_REQUEST_NONE;
               if(this.mCurrentListenButton != null)
               {
                  this.mCurrentListenButton.setHighlight(true);
               }
               if(this.mCurrentState == this.STATE_PLAY_MESSAGE_BY_INDEX)
               {
                  this.setScreenViewState(this.mPreviousState);
               }
            }
            else
            {
               this.mListenPending = true;
               this.mCurrentSelectedMsg = message;
            }
         }
         else
         {
            this.mListenPending = false;
            this.mVRRequestState = this.VR_REQUEST_NONE;
            if(this.mCurrentState == this.STATE_PLAY_MESSAGE_BY_INDEX)
            {
               this.setScreenViewState(this.mPreviousState);
            }
            this.mCurrentSelectedRow.listen_button.setHighlight(false);
         }
      }
      
      private function onReadStatus(evt:SMSMessageEvent) : void
      {
         this.mGroupInBox.browse_list.requestData();
      }
      
      private function onMessageSendSuccess(evt:SMSMessageEvent) : void
      {
         this.mCurrentState = this.STATE_INBOX;
         this.setScreenViewState(this.mCurrentState);
      }
      
      private function onSMSInboxSpeedLockOut() : void
      {
         if(this.STATE_INBOX == this.mCurrentState)
         {
            this.mGroupInBox.browse_list.setRowUpdater(this.inBoxListInitRowUpdater);
            this.mGroupInBox.browse_list.setRowUpdater(this.inBoxListRowUpdater);
         }
         else if(this.STATE_NEW_MESSAGE_INIT == this.mCurrentState)
         {
            this.mGroupNewMessage.browse_list.setRowUpdater(this.newMessageListRowUpdater);
         }
      }
      
      private function onSMSFeatureSupport(evt:SMSMessageEvent) : void
      {
         this.checkIfSmsSendingSupported();
      }
      
      private function checkIfSmsSendingSupported() : void
      {
         if(Peripheral.smsMessaging.isSendSupported == false)
         {
            screenVars = "inbox";
            this.mGroupSideButtons.newMessage_button.setSelected(false);
            this.mGroupSideButtons.newMessage_button.setEnabled(false);
         }
         else
         {
            this.mGroupSideButtons.newMessage_button.setInteractive(true);
            this.mGroupSideButtons.newMessage_button.visible = true;
            this.setNewMsgBtn();
         }
      }
      
      private function gotoPredefinedMessageScreen() : void
      {
         this.mGroupNewMessage.show();
         this.mGroupSideButtons.setSelection("newMessage_button",false);
         this.initBreadcrumb();
         pushBreadcrumb(new Breadcrumb(T.STRB_NEW_MESSAGE_BREADCRUMB));
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupNewMessage.browse_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupNewMessage.browse_list.selectEventHandler);
         this.mMessageListData = this.mNewMessageListData;
         this.mGroupNewMessage.browse_list.setLength(0);
         this.mGroupNewMessage.browse_list.setLength(this.mMessageListData.length);
         this.updateItemsInListText(this.mMessageListData.length);
         Framework.structure.variables = {"state":"predefined"};
         this.mCurrentState = this.STATE_NEW_MESSAGE_PREDEFINED;
      }
      
      private function onRefreshStructure(evt:StructureEvent) : void
      {
         screenVars = evt.vars;
         this.initScreen();
      }
   }
}

