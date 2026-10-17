package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVicsEtcHMI extends IModule
   {
      
      function get Status() : uint;
      
      function get CardExpirationDate() : EtcID;
      
      function get PaymentHistory() : EtcID;
      
      function get WarningMessage() : Boolean;
      
      function get WarningVoiceGuidance() : Boolean;
      
      function get EtcState() : EtcID;
      
      function get ReadingHistory() : Boolean;
      
      function setReadingHistory(param1:Boolean) : void;
      
      function requestSwitchWarningMessage(param1:Boolean) : void;
      
      function requestSwitchWarningVoiceGuidance(param1:Boolean) : void;
      
      function requestGetHistory() : void;
      
      function requestHmiIsReady() : void;
      
      function requestStatus() : void;
      
      function requestCardExpirationDate() : void;
      
      function requestPaymentHistory() : void;
      
      function requestWarningMessage() : void;
      
      function requestWarningVoiceGuidance() : void;
      
      function requestEtcState() : void;
   }
}

