package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.moduleLink.AppManager;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.ConsentStates;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.nfuzion.framework.global.Framework;
   
   public class Status extends Helper
   {
      
      private var mAssumedAuthenticationStatus:int = 2;
      
      private var mLiveServicesEnabled:Boolean = false;
      
      private var mLiveServicesEnabledRequest:Boolean = false;
      
      public function Status()
      {
         super();
         mController.addEventListener(LiveServicesEvent.LS_USER_CONSENT_UPDATE,this.onConsentUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_SERVICE_READY_UPDATE,this.onServiceReadyUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_TURN_ON_OFF_UPDATE,this.onServiceOnOffUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_AUTHENTICATION_STATUS,this.onAuthenticationStatus,false,0,true);
      }
      
      public function set persistedAuthorizationStatus(status:int) : void
      {
         this.mAssumedAuthenticationStatus = status;
      }
      
      public function get persistedAuthorizationStatus() : int
      {
         return this.mAssumedAuthenticationStatus;
      }
      
      public function get ttlsSserviceIsSupportedBySystem() : Boolean
      {
         if(NavGlobalSettingsCommon.TTLS_ENABLE_SIMULATION_DATA)
         {
            return true;
         }
         var vehLine:String = NavigationPackage.peripheral.vehConfig.vehicleLine;
         if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_EUROPE && AppManager.getInstance().isSuperAppInAppsList)
         {
            return true;
         }
         return false;
      }
      
      public function ttlsUConnectACNAvailable() : Boolean
      {
         if(!this.ttlsSserviceIsSupportedBySystem || mController.consentState != ConsentStates.CONSENT_STATE_CONFIRMED)
         {
            return false;
         }
         var status:Object = NavigationPackage.peripheral.navigation.navigation.lsAuthenticationStatus;
         if(status == null || status["connectivityStatus"] == null || status["authenticationStatus"] == null)
         {
            return false;
         }
         if(status != null && status["connectivityStatus"] != null && status["authenticationStatus"] != null)
         {
            if(status["connectivityStatus"] != AuthenticationTypes.UC_CONNECTED_NOT_AVAILABLE && status["authenticationStatus"] == AuthenticationTypes.UC_AUTH_AUTHORIZED)
            {
               return true;
            }
         }
         else if(this.mAssumedAuthenticationStatus == AuthenticationTypes.UC_AUTH_AUTHORIZED)
         {
            return true;
         }
         return false;
      }
      
      public function ttlsGeneralServiceAvailable() : Boolean
      {
         if(!this.ttlsSserviceIsSupportedBySystem || mController.consentState != ConsentStates.CONSENT_STATE_CONFIRMED)
         {
            return false;
         }
         if(NavigationApi.api.lsServiceStatus == AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE)
         {
            return true;
         }
         return false;
      }
      
      public function ttlsServiceAvailable(serviceType:String) : Boolean
      {
         var i:String = null;
         if(!this.ttlsSserviceIsSupportedBySystem || !this.ttlsUConnectACNAvailable())
         {
            return false;
         }
         var status:Object = NavigationPackage.peripheral.navigation.navigation.lsAuthenticationStatus;
         if(status != null && status["subscriptionList"] != null)
         {
            if(Boolean(status["subscriptionList"]) && (status["subscriptionList"] as Array).length > 0)
            {
               for(i in status["subscriptionList"])
               {
                  if(status["subscriptionList"][i] == serviceType)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function ttlsServiceFunctional(ttlsService:int) : Boolean
      {
         if(!this.ttlsGeneralServiceAvailable() || !this.ttlsUConnectACNAvailable())
         {
            return false;
         }
         if(NavigationPackage.peripheral.navigation.navigation.lsServicesAvailable & ttlsService)
         {
            return true;
         }
         return false;
      }
      
      public function enableLiveServices(enable:Boolean) : void
      {
         this.mLiveServicesEnabledRequest = enable;
         this.updateConnectionSetting();
      }
      
      public function get liveServicesEnabled() : Boolean
      {
         return this.mLiveServicesEnabled;
      }
      
      private function onConsentUpdate(e:LiveServicesEvent) : void
      {
         this.updateConnectionSetting();
      }
      
      private function onServiceReadyUpdate(e:NavigationEvent) : void
      {
         this.updateConnectionSetting();
         sendEvent(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE);
      }
      
      private function onAuthenticationStatus(e:NavigationEvent) : void
      {
         this.updateConnectionSetting();
         sendEvent(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE);
      }
      
      private function onServiceOnOffUpdate(e:NavigationEvent) : void
      {
         this.mLiveServicesEnabled = NavigationApi.api.lsServiceTurnedOn;
         sendEvent(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED);
         mController.toPersistence();
      }
      
      private function updateConnectionSetting() : void
      {
         if(NavigationApi.api.lsServiceStatus == AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE)
         {
            if(this.mLiveServicesEnabledRequest != NavigationApi.api.lsServiceTurnedOn)
            {
               if(mController.consentState != ConsentStates.CONSENT_STATE_CONFIRMED)
               {
                  Framework.Trace("TTLS.ServerOnOff.updateConnectionSetting() Consent not confirmed!");
                  NavigationApi.api.lsSetServerCommunicationEnable(false);
                  this.mLiveServicesEnabled = false;
                  this.mLiveServicesEnabledRequest = false;
               }
               else
               {
                  Framework.Trace("TTLS.ServerOnOff.updateConnectionSetting() Sending (" + this.mLiveServicesEnabledRequest + ")");
                  NavigationApi.api.lsSetServerCommunicationEnable(this.mLiveServicesEnabledRequest);
               }
            }
            else
            {
               this.mLiveServicesEnabled = this.mLiveServicesEnabledRequest;
            }
            sendEvent(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED);
         }
         else
         {
            Framework.Trace("TTLS.ServerOnOff.updateConnectionSetting() TTLS is not available yet.");
            this.mLiveServicesEnabled = false;
            sendEvent(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED);
         }
      }
   }
}

