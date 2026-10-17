package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PhoneCallListEvent extends Event
   {
      
      public static const AVAILABILITY:String = "availability";
      
      public static const ALL_CALLS_LIST:String = "allCallsList";
      
      public static const DIALED_CALLS_LIST:String = "dialedCallsList";
      
      public static const RECEIVED_CALLS_LIST:String = "receivedCallsList";
      
      public static const MISSED_CALLS_LIST:String = "missedCallsList";
      
      public static const SEND_AUTO_REPLY_FOR_CALL:String = "sendAutoReplyForCall";
      
      public static const ALL_CALLS_COUNT:String = "allCallsCount";
      
      public static const DIALED_CALLS_COUNT:String = "dialedCallsCount";
      
      public static const RECEIVED_CALLS_COUNT:String = "receivedCallsCount";
      
      public static const MISSED_CALLS_COUNT:String = "missedCallsCount";
      
      public var data:* = null;
      
      public function PhoneCallListEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
   }
}

