package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.navigation.Controller.LiveServices.ConsentStates;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   
   public class Consent extends Helper
   {
      
      private var mConsentState:int = 0;
      
      private var mConsentConfirmExpiration:Date = new Date();
      
      private var mConsentLanguage:int = -1;
      
      private var mConsentPersistenceLoaded:Boolean = false;
      
      public function Consent()
      {
         super();
         this.mConsentState = ConsentStates.CONSENT_STATE_WAITING;
      }
      
      public function get consentState() : int
      {
         if(!mController.ttlsSserviceIsSupportedBySystem)
         {
            this.mConsentState = ConsentStates.CONSENT_STATE_LIVE_SERVICE_NOT_SUPPORTED;
         }
         if(this.mConsentState == ConsentStates.CONSENT_STATE_CONFIRMED && this.confirmationTimeExpired())
         {
            this.mConsentState = ConsentStates.CONSENT_STATE_EXPIRED;
         }
         return this.mConsentState;
      }
      
      public function setConsentState(state:int) : void
      {
         this.mConsentState = state;
         this.resetConfirmationTimeout();
         mController.sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE);
         mController.toPersistence();
      }
      
      public function get consentConfirmExpiration() : Date
      {
         return this.mConsentConfirmExpiration;
      }
      
      public function checkLanguageChange() : void
      {
         Framework.Trace("Consent.checkLanguageChange() " + this.mConsentLanguage + " " + NavigationApi.api.langCurrentLanguage);
         if(this.mConsentLanguage != NavigationApi.api.langCurrentLanguage && this.mConsentPersistenceLoaded)
         {
            this.mConsentLanguage = NavigationApi.api.langCurrentLanguage;
            this.setConsentState(ConsentStates.CONSENT_STATE_UNDEFINED);
         }
      }
      
      public function getConsentDataString() : String
      {
         var result:String = "";
         result += this.mConsentState + ";";
         result += this.mConsentConfirmExpiration.fullYear + ";";
         result += this.mConsentConfirmExpiration.month + ";";
         result += this.mConsentConfirmExpiration.date + ";";
         return result + (this.mConsentLanguage + ";");
      }
      
      public function setConsentDataString(dateString:String) : void
      {
         this.mConsentPersistenceLoaded = true;
         var array:Array = dateString.split(";");
         if(array.length >= 5)
         {
            this.mConsentState = int(array[0]);
            this.mConsentConfirmExpiration.fullYear = int(array[1]);
            this.mConsentConfirmExpiration.month = int(array[2]);
            this.mConsentConfirmExpiration.date = int(array[3]);
            this.mConsentLanguage = int(array[4]);
         }
         else
         {
            this.mConsentState = ConsentStates.CONSENT_STATE_UNDEFINED;
         }
         mController.sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE);
      }
      
      private function resetConfirmationTimeout() : void
      {
         var today:Date = NavigationPackage.peripheral.clock.time;
         this.mConsentConfirmExpiration.fullYear = today.fullYear + 1;
         this.mConsentConfirmExpiration.month = today.month;
         this.mConsentConfirmExpiration.date = today.date;
      }
      
      private function confirmationTimeExpired() : Boolean
      {
         var today:Date = NavigationPackage.peripheral.clock.time;
         if(this.mConsentConfirmExpiration.fullYear <= today.fullYear && this.mConsentConfirmExpiration.month <= today.month && this.mConsentConfirmExpiration.date <= today.date)
         {
            return true;
         }
         return false;
      }
   }
}

