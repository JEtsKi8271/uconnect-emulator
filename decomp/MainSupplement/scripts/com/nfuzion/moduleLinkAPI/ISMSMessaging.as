package com.nfuzion.moduleLinkAPI
{
   public interface ISMSMessaging extends IModule
   {
      
      function requestInboxMessageList(param1:int = 0, param2:int = 0) : void;
      
      function get inboxMessageList() : Vector.<SMSMessage>;
      
      function requestInboxMessageListLength() : void;
      
      function get inboxMessageListLength() : int;
      
      function requestMessage(param1:String) : void;
      
      function startSMSDictation(param1:String, param2:Boolean) : void;
      
      function startSMSForwardDictation() : void;
      
      function requestUnreadSMSList(param1:int = 0, param2:int = 0) : void;
      
      function get inboxUnreadMessageList() : Vector.<SMSMessage>;
      
      function get requestedMessage() : SMSMessage;
      
      function get promptIncomingName() : String;
      
      function get incomingMessage() : SMSMessage;
      
      function get isSendSupported() : Boolean;
      
      function get incomingMessageCount() : int;
      
      function requestUnreadSMSCount() : void;
      
      function get unreadSMSCount() : int;
      
      function set playingMessageID(param1:String) : void;
      
      function get playingMessageID() : String;
      
      function set outgoingMessageRecipientPhoneNumber(param1:String) : void;
      
      function get outgoingMessageRecipientPhoneNumber() : String;
      
      function set outgoingMessageRecipientPhoneNumberType(param1:String) : void;
      
      function get outgoingMessageRecipientPhoneNumberType() : String;
      
      function set outgoingMessageRecipientName(param1:String) : void;
      
      function get outgoingMessageRecipientName() : String;
      
      function set outgoingMessageBody(param1:String) : void;
      
      function get outgoingMessageBody() : String;
      
      function get isSMSSupported() : Boolean;
      
      function get isSMSReady() : Boolean;
      
      function get isSMSDisabled() : Boolean;
      
      function get isVrMessageListen() : Boolean;
      
      function set isVrMessageListen(param1:Boolean) : void;
      
      function clearOutgoingMessage() : void;
      
      function clearIncomingMessage(param1:Boolean = false, param2:Boolean = true) : void;
      
      function checkViewMessageActive(param1:Boolean = false) : void;
      
      function CheckIsSMSSupported() : void;
      
      function replyMessage() : void;
      
      function smsReadStatus(param1:String) : void;
      
      function isValidNumber(param1:String) : Boolean;
      
      function get currentlyOpenedMessage() : SMSMessage;
      
      function set currentlyOpenedMessage(param1:SMSMessage) : void;
      
      function sendOutgoingMessage() : Boolean;
      
      function emitSmsVRResponse(param1:Number, param2:String, param3:Object = null, param4:String = null, param5:Object = null, param6:Object = null, param7:Object = null) : void;
      
      function set vrDialogStatus(param1:Boolean) : void;
      
      function emitNewSMSPopupStatus(param1:Boolean) : void;
      
      function emitViewSMSPopusStatus(param1:Boolean) : void;
      
      function set vrMode(param1:Boolean) : void;
      
      function set replyWithMessage(param1:Boolean) : void;
      
      function get replyWithMessage() : Boolean;
      
      function set blockedSMSCount(param1:uint) : void;
      
      function get blockedSMSCount() : uint;
      
      function set blockedSMSNumber(param1:String) : void;
      
      function get blockedSMSNumber() : String;
      
      function set DNDStatus(param1:Boolean) : void;
      
      function get DNDStatus() : Boolean;
      
      function set autoReply(param1:String) : void;
      
      function get autoReply() : String;
      
      function set autoReplyMessage(param1:String) : void;
      
      function get autoReplyMessage() : String;
      
      function get customMessage() : String;
      
      function set customMessage(param1:String) : void;
      
      function get previousIncomingMessage() : SMSMessage;
      
      function set previousIncomingMessage(param1:SMSMessage) : void;
      
      function get currentSelectedMessageIndex() : uint;
      
      function set currentSelectedMessageIndex(param1:uint) : void;
      
      function get lastMessageReceived() : SMSMessage;
   }
}

