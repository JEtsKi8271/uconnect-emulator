package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SMSMessageEvent extends Event
   {
      
      public static const INCOMING_MESSAGE:String = "incomingMessage";
      
      public static const INBOX_MESSAGE_LIST:String = "inboxMessageList";
      
      public static const INBOX_UNREAD_MESSAGE_LIST:String = "inboxUnreadMessageList";
      
      public static const INBOX_MESSAGE_LIST_LENGTH:String = "inboxMessageListLength";
      
      public static const UNREAD_SMS_COUNT:String = "unreadSMSCount";
      
      public static const REQUESTED_MESSAGE:String = "requested message";
      
      public static const MESSAGE_SEND_SUCCESS:String = "messageSendSuccess";
      
      public static const MESSAGE_SEND_ERROR:String = "messageSendError";
      
      public static const MESSAGE_READ_STATUS_SUCCESS:String = "messageReadStatusSuccess";
      
      public static const MESSAGE_READ_STATUS_ERROR:String = "messageReadStatusError";
      
      public static const SMS_NOT_SUPPORTED_ERROR:String = "smsNotSupportedError";
      
      public static const SMS_BKGND_SYNC:String = "smsBkgndSync";
      
      public static const SMS_FEATURE_SUPPORT:String = "smsFeatureSupport";
      
      public static const SMS_SYNC_STATE:String = "smsSyncState";
      
      public static const SMS_REPLY:String = "smsReply";
      
      public static const SMS_INBOX:String = "smsInbox";
      
      public static const MISSED_SMS_COUNT:String = "missedSmsCount";
      
      public static const AUTO_REPLY:String = "autoReply";
      
      public static const AUTO_REPLY_MESSAGE:String = "autoReplyMessage";
      
      public static const SEND_AUTO_REPLY_FOR_SMS:String = "sendAutoReplyForSMS";
      
      public var m_data:Object = null;
      
      public function SMSMessageEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
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
         return new SMSMessageEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SMSMessageEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

