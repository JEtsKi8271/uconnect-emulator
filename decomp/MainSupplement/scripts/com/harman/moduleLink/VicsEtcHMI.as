package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.EtcID;
   import com.harman.moduleLinkAPI.IVicsEtcHMI;
   import com.harman.moduleLinkAPI.VicsEtcHMIEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VicsEtcHMI extends Module implements IVicsEtcHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnEtcHmi.NavCtrl_Driver";
      
      private static const SWITCH_WARNING_MESSAGE:String = "requestSwitchWarningMessage";
      
      private static const SWITCH_WARNING_VOICE_GUIDANCE:String = "requestSwitchWarningVoiceGuidance";
      
      private static const GET_HISTORY:String = "requestGetHistory";
      
      private static const HMI_IS_READY:String = "requestHmiIsReady";
      
      private static const GATE_COMMUNICATION_ERROR_INDICATION:String = "informationGateCommunicationErrorIndication";
      
      private static const FARE_INDICATION:String = "informationFareIndication";
      
      private static const STATUS:String = "Status";
      
      private static const CARD_EXPIRATION_DATE:String = "CardExpirationDate";
      
      private static const PAYMENT_HISTORY:String = "PaymentHistory";
      
      private static const WARNING_MESSAGE:String = "WarningMessage";
      
      private static const WARNING_VOICE_GUIDANCE:String = "WarningVoiceGuidance";
      
      private static const ETC_STATE:String = "EtcState";
      
      private static const ETC_TOKEN_CLEAR_FLAG:String = "EtcTokenClearFlag";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mStatus:uint = 0;
      
      private var mWarningMessage:Boolean = false;
      
      private var mWarningVoiceGuidance:Boolean = false;
      
      private var mReadingHistory:Boolean = false;
      
      private var mEtcState:EtcID = new EtcID();
      
      private var mCardExpirationDate:EtcID = new EtcID();
      
      private var mPaymentHistory:EtcID = new EtcID();
      
      public function VicsEtcHMI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VICSETCHMI,this.EtcHMIMessageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         if(this.client.connected)
         {
            this.sendAttributeSubscribes();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.requestAttributesInitialValue();
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function requestAttributesInitialValue() : void
      {
         this.requestStatus();
         this.requestCardExpirationDate();
         this.requestWarningMessage();
         this.requestWarningVoiceGuidance();
         this.requestEtcState();
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.sendSubscribe(STATUS);
         this.sendSubscribe(CARD_EXPIRATION_DATE);
         this.sendSubscribe(PAYMENT_HISTORY);
         this.sendSubscribe(WARNING_MESSAGE);
         this.sendSubscribe(WARNING_VOICE_GUIDANCE);
         this.sendSubscribe(ETC_STATE);
         this.sendSubscribe(ETC_TOKEN_CLEAR_FLAG);
         this.sendSubscribe(GATE_COMMUNICATION_ERROR_INDICATION);
         this.sendSubscribe(FARE_INDICATION);
      }
      
      public function requestStatus() : void
      {
         this.sendAttrRequest(STATUS);
      }
      
      public function requestCardExpirationDate() : void
      {
         this.sendAttrRequest(CARD_EXPIRATION_DATE);
      }
      
      public function requestPaymentHistory() : void
      {
         this.sendAttrRequest(PAYMENT_HISTORY);
      }
      
      public function requestWarningMessage() : void
      {
         this.sendAttrRequest(WARNING_MESSAGE);
      }
      
      public function requestWarningVoiceGuidance() : void
      {
         this.sendAttrRequest(WARNING_VOICE_GUIDANCE);
      }
      
      public function requestEtcState() : void
      {
         this.sendAttrRequest(ETC_STATE);
      }
      
      public function requestSwitchWarningMessage(active:Boolean) : void
      {
         this.sendCommand(SWITCH_WARNING_MESSAGE,"Active",String(active));
      }
      
      public function requestSwitchWarningVoiceGuidance(active:Boolean) : void
      {
         this.sendCommand(SWITCH_WARNING_VOICE_GUIDANCE,"Active",String(active));
      }
      
      public function requestGetHistory() : void
      {
         this.mReadingHistory = true;
         this.sendCommandSimple(GET_HISTORY);
      }
      
      public function requestHmiIsReady() : void
      {
         this.sendCommandSimple(HMI_IS_READY);
      }
      
      private function EtcHMIMessageHandler(e:ConnectionEvent) : void
      {
         var EtcData:Object = e.data;
         if(EtcData.hasOwnProperty(STATUS))
         {
            this.mStatus = EtcData.Status[1];
         }
         else if(EtcData.hasOwnProperty(CARD_EXPIRATION_DATE))
         {
            this.mCardExpirationDate = this.mCardExpirationDate.copyCardExpirationDate(EtcData.CardExpirationDate[1]);
         }
         else if(EtcData.hasOwnProperty(PAYMENT_HISTORY))
         {
            this.mPaymentHistory = this.mPaymentHistory.copyPaymentHistory(EtcData.PaymentHistory[1]);
         }
         else if(EtcData.hasOwnProperty(ETC_TOKEN_CLEAR_FLAG))
         {
            if(EtcData.EtcTokenClearFlag[1] != false)
            {
               this.mPaymentHistory = this.mPaymentHistory.deletePaymentHistory();
            }
            else
            {
               this.dispatchEvent(new VicsEtcHMIEvent(VicsEtcHMIEvent.PAYMENT_HISTORY));
               this.mReadingHistory = false;
            }
         }
         else if(EtcData.hasOwnProperty(WARNING_MESSAGE))
         {
            this.mWarningMessage = EtcData.WarningMessage[1];
            this.dispatchEvent(new VicsEtcHMIEvent(VicsEtcHMIEvent.WARNING_MESSAGE));
         }
         else if(EtcData.hasOwnProperty(WARNING_VOICE_GUIDANCE))
         {
            this.mWarningVoiceGuidance = EtcData.WarningVoiceGuidance[1];
            this.dispatchEvent(new VicsEtcHMIEvent(VicsEtcHMIEvent.WARNING_VOICE_GUIDANCE));
         }
         else if(EtcData.hasOwnProperty(ETC_STATE))
         {
            this.mEtcState = this.mEtcState.copyEtcState(EtcData.EtcState[1]);
            this.dispatchEvent(new VicsEtcHMIEvent(VicsEtcHMIEvent.ETC_STATE));
         }
         else if(EtcData.hasOwnProperty(GATE_COMMUNICATION_ERROR_INDICATION))
         {
            this.dispatchEvent(new VicsEtcHMIEvent(VicsEtcHMIEvent.GATE_COMMUNICATION_ERROR_INDICATION));
         }
         else if(!EtcData.hasOwnProperty(FARE_INDICATION))
         {
            if(!EtcData.hasOwnProperty(HMI_IS_READY))
            {
               if(EtcData.hasOwnProperty("dBusServiceAvailable"))
               {
                  if(EtcData.dBusServiceAvailable)
                  {
                     this.requestHmiIsReady();
                  }
               }
               else
               {
                  trace("Unexpected property returned to VicsEtcHMI module");
               }
            }
         }
      }
      
      public function get Status() : uint
      {
         return this.mStatus;
      }
      
      public function get CardExpirationDate() : EtcID
      {
         return this.mCardExpirationDate;
      }
      
      public function get PaymentHistory() : EtcID
      {
         return this.mPaymentHistory;
      }
      
      public function get WarningMessage() : Boolean
      {
         return this.mWarningMessage;
      }
      
      public function get WarningVoiceGuidance() : Boolean
      {
         return this.mWarningVoiceGuidance;
      }
      
      public function get EtcState() : EtcID
      {
         return this.mEtcState;
      }
      
      public function get ReadingHistory() : Boolean
      {
         return this.mReadingHistory;
      }
      
      public function setReadingHistory(active:Boolean) : void
      {
         this.mReadingHistory = active;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
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
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendCommandSimple(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendAttrRequest(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

