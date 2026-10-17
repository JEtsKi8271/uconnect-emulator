package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VicsEtcHMIEvent extends Event
   {
      
      public static const STATUS:String = "EventStatus";
      
      public static const CARD_EXPIRATION_DATE:String = "EventCardExpirationDate";
      
      public static const PAYMENT_HISTORY:String = "EventPaymentHistory";
      
      public static const WARNING_MESSAGE:String = "EventWarningMessage";
      
      public static const WARNING_VOICE_GUIDANCE:String = "EventWarningVoiceGuidance";
      
      public static const ETC_STATE:String = "EventEtcState";
      
      public static const ETC_TOKEN_CLEAR_FLAG:String = "EventEtcTokenClearFlag";
      
      public static const GATE_COMMUNICATION_ERROR_INDICATION:String = "EventGateCommErrIndication";
      
      public var mData:Object = null;
      
      public function VicsEtcHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

