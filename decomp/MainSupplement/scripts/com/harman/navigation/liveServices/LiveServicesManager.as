package com.harman.navigation.liveServices
{
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.SpeedCameraAlertSettingTypes;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LiveServicesManager
   {
      
      private var mParent:Navigation;
      
      private var mAuthenticationStatus:Object = null;
      
      private var mTTLS_Status:int = 0;
      
      private var mTTLS_AvailableServices:int = 0;
      
      private var mTTLS_TurnedOn:Boolean = false;
      
      private var mTTLS_TurnedOnBlockRequest:Boolean = false;
      
      private var mTTLS_StatusReceived:Boolean = false;
      
      private var mAuthenticationStatusRequested:Boolean = false;
      
      private var mSimulationDataEnabled:Boolean = false;
      
      private var mSimulationResponseTimer:Timer = null;
      
      private var mSimulationResponseType:int = -1;
      
      public function LiveServicesManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
         this.mParent.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
         this.mParent.navGetIsReady();
         if(this.mSimulationDataEnabled)
         {
            this.checkDataSumilationConfiguration();
         }
      }
      
      public function get lsAuthenticationStatus() : Object
      {
         if(this.mAuthenticationStatus == null)
         {
            if(this.mAuthenticationStatusRequested)
            {
               Framework.Trace("LiveServicesManager.lsAuthenticationStatus() Multiple AuthenticationStatusRequests detected.");
            }
            else
            {
               this.mAuthenticationStatusRequested = true;
               this.mParent.sendServiceCommand(Navigation.dbusUConnectACNDbusIdentifier,"\"getProperties\":{\"props\":[\"authenticationStatus\",\"sessionToken\",\"connectivityStatus\",\"subscriptionList\",\"notifyConnectivityStatus\"]}");
               if(!this.mTTLS_StatusReceived)
               {
                  this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_GetStatus\":{}");
               }
            }
         }
         return this.mAuthenticationStatus;
      }
      
      public function requestWeatherData(geo:String) : void
      {
         var split:Object = new Object();
         split["geo"] = geo;
         this.splitLatLong(split);
         if(this.mSimulationDataEnabled)
         {
            this.mSimulationResponseType = AuthenticationTypes.TTLS_SERVICE_WEATHER;
            this.mSimulationResponseTimer.start();
            return;
         }
         this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_GetList\":" + "{" + "\"IFT\":\"WEA\"" + ",\"parameter\":" + "{" + "\"currentLoc\":" + "{" + "\"latitude\":\"" + split["lat"] + "\"" + "," + "\"longitude\":\"" + split["long"] + "\"" + "}" + "}" + "}");
      }
      
      public function requestLocalSearch(search:String, geo:String, radius:int, results:int) : void
      {
         var split:Object = new Object();
         split["geo"] = geo;
         this.splitLatLong(split);
         if(this.mSimulationDataEnabled)
         {
            this.mSimulationResponseType = AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH;
            this.mSimulationResponseTimer.start();
            return;
         }
         this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_GetList\":" + "{" + "\"IFT\":\"LOCALSEARCH\"," + "\"parameter\":" + "{" + "\"where\":" + "{" + "\"geo\":" + "{" + "\"latitude\":\"" + split["lat"] + "\"" + "," + "\"longitude\":\"" + split["long"] + "\"" + "," + "\"radius\":" + radius + "}" + "}," + "\"what\":\"" + search + "\"," + "\"resultCount\":" + results + "," + "\"sortOption\":0" + "}" + "}");
      }
      
      public function reportSpeedCamera(cameraType:int, geo:String, speed:int, direction:int) : void
      {
         var split:Object = new Object();
         split["geo"] = geo;
         this.splitLatLong(split);
         this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_SpeedcamFeedback\":" + "{" + "\"reports\":" + "[" + "{" + "\"reportType\":0," + "\"item\":" + "{" + "\"speedCamType\":" + cameraType + "," + "\"speedLimit\":" + speed + "," + "\"latitude\":\"" + split["lat"] + "\"," + "\"longitude\":\"" + split["long"] + "\"," + "\"bearing\":\"" + direction + "\"" + "}" + "}" + "]" + "}");
      }
      
      public function setSpeedCameraAlertSettings(settings:Object) : void
      {
         var i:String = null;
         var arr:Array = null;
         var j:int = 0;
         var inputEIS:String = "";
         for(i in settings)
         {
            arr = SpeedCameraAlertSettingTypes.getMappedSafetyCameraTypeString(int(i));
            for(j = 0; j < arr.length; j++)
            {
               inputEIS += "\"" + arr[j] + "<SCAW>" + settings[i] + "<*>\"";
               if(inputEIS.length > 0)
               {
                  inputEIS += ",";
               }
            }
         }
         if(inputEIS.lastIndexOf(",") == inputEIS.length - 1)
         {
            inputEIS = inputEIS.slice(0,inputEIS.length - 1);
         }
         this.mParent.sendCommand("\"ETC_SetAlertProperties\":" + "{" + "\"configs\":" + "[" + inputEIS + "]" + "}");
      }
      
      public function setServerCommunicationEnable(enable:Boolean) : void
      {
         if(enable)
         {
            if(!this.mTTLS_TurnedOn && !this.mTTLS_TurnedOnBlockRequest)
            {
               this.mTTLS_TurnedOnBlockRequest = true;
               this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_TurnOn\":{}");
            }
            else
            {
               Framework.Trace("LiveServicesManager.setServerCommunicationEnable(" + enable + ") blocked! ");
            }
         }
         else if(this.mTTLS_TurnedOn)
         {
            this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_TurnOff\":{}");
         }
         else
         {
            Framework.Trace("LiveServicesManager.setServerCommunicationEnable(" + enable + ") blocked! ");
         }
      }
      
      public function get ttlsTurnedOn() : Boolean
      {
         return this.mTTLS_TurnedOn;
      }
      
      public function get ttlsStatus() : int
      {
         return this.mTTLS_Status;
      }
      
      public function get ttlsAvailableServices() : int
      {
         return this.mTTLS_AvailableServices;
      }
      
      public function set lsDataSimulationEnabled(enable:Boolean) : void
      {
         this.mSimulationDataEnabled = enable;
         this.checkDataSumilationConfiguration();
      }
      
      public function get lsDataSimulationEnabled() : Boolean
      {
         return this.mSimulationDataEnabled;
      }
      
      public function liveServicesMessageHandlerACN(e:ConnectionEvent) : void
      {
         var i:String = null;
         for(i in e.data)
         {
            Framework.Trace("LiveServicesMessageHandler (" + i + ")");
         }
         if(this.mAuthenticationStatus == null)
         {
            this.mAuthenticationStatus = new Object();
         }
         if(e.hasOwnProperty("data"))
         {
            if(e.data.hasOwnProperty("authenticationStatus"))
            {
               if(e.data.authenticationStatus.hasOwnProperty("value"))
               {
                  this.mAuthenticationStatus["authenticationStatus"] = e.data.authenticationStatus.value;
               }
            }
            if(e.data.hasOwnProperty("connectivityStatus"))
            {
               if(e.data.connectivityStatus.hasOwnProperty("value"))
               {
                  this.mAuthenticationStatus["connectivityStatus"] = e.data.connectivityStatus.value;
               }
            }
            if(e.data.hasOwnProperty("sessionToken"))
            {
               if(e.data.sessionToken.hasOwnProperty("value"))
               {
                  this.mAuthenticationStatus["sessionToken"] = e.data.sessionToken.value;
               }
            }
            if(e.data.hasOwnProperty("subscriptionList"))
            {
               if(e.data.subscriptionList.hasOwnProperty("value"))
               {
                  this.mAuthenticationStatus["subscriptionList"] = e.data.subscriptionList.value;
               }
            }
            if(e.data.hasOwnProperty("getProperties"))
            {
               if(e.data.getProperties.hasOwnProperty("authenticationStatus"))
               {
                  this.mAuthenticationStatus["authenticationStatus"] = e.data.getProperties.authenticationStatus;
               }
               if(e.data.getProperties.hasOwnProperty("connectivityStatus"))
               {
                  this.mAuthenticationStatus["connectivityStatus"] = e.data.getProperties.connectivityStatus;
               }
               if(e.data.getProperties.hasOwnProperty("sessionToken"))
               {
                  this.mAuthenticationStatus["sessionToken"] = e.data.getProperties.sessionToken;
               }
               if(e.data.getProperties.hasOwnProperty("subscriptionList"))
               {
                  this.mAuthenticationStatus["subscriptionList"] = e.data.getProperties.subscriptionList;
               }
            }
            this.mParent.sendEvent(NavigationEvent.TTLS_AUTHENTICATION_STATUS,this.mAuthenticationStatus);
         }
      }
      
      public function liveServicesMessageHandlerTTLS(e:ConnectionEvent) : void
      {
         if(e.hasOwnProperty("data"))
         {
            if(e.data.hasOwnProperty("TTLive_SpeedcamFeedback"))
            {
               if(e.data.TTLive_SpeedcamFeedback.hasOwnProperty("resultCode"))
               {
                  Framework.Trace("LiveServicesManager() TTLive_SpeedcamFeedback confirmed (" + e.data.TTLive_SpeedcamFeedback.resultCode + ")");
                  this.mParent.sendEvent(NavigationEvent.TTLS_SPEEDCAM_FEEDBACK_UPDATE,e.data.TTLive_SpeedcamFeedback.resultCode);
               }
               else
               {
                  Framework.Trace("LiveServicesManager() TTLive_SpeedcamFeedback missing resultCode !");
               }
            }
            if(Boolean(e.data.hasOwnProperty("TTLive_TurnOn")) && Boolean(e.data.TTLive_TurnOn.hasOwnProperty("resultCode")))
            {
               if(e.data.TTLive_TurnOn.hasOwnProperty("resultCode"))
               {
                  Framework.Trace("LiveServicesManager() TTLive_TurnOn confirmed (" + e.data.TTLive_TurnOn.resultCode + ")");
                  this.mTTLS_TurnedOnBlockRequest = false;
                  if(e.data.TTLive_TurnOn.resultCode == 1)
                  {
                     this.mTTLS_TurnedOn = true;
                     this.mParent.sendEvent(NavigationEvent.TTLS_TURN_ON_OFF_UPDATE,this.mTTLS_TurnedOn);
                  }
               }
               else
               {
                  Framework.Trace("LiveServiceManager.TTLS: An ERROR OCCURRED during TTLive_TurnOn !!!");
               }
            }
            if(e.data.hasOwnProperty("TTLive_TurnOff"))
            {
               if(e.data.TTLive_TurnOff.hasOwnProperty("resultCode"))
               {
                  Framework.Trace("LiveServicesManager() TTLive_TurnOff confirmed (" + e.data.TTLive_TurnOff.resultCode + ")");
                  this.mTTLS_TurnedOnBlockRequest = false;
                  if(e.data.TTLive_TurnOff.resultCode == 1)
                  {
                     this.mTTLS_TurnedOn = false;
                     this.mParent.sendEvent(NavigationEvent.TTLS_TURN_ON_OFF_UPDATE,this.mTTLS_TurnedOn);
                  }
               }
               else
               {
                  Framework.Trace("LiveServiceManager.TTLS: An ERROR OCCURRED during TTLive_TurnOff !!!");
               }
            }
            if(e.data.hasOwnProperty("TTLive_Signal_WEA_List"))
            {
               if(Boolean(e.data.TTLive_Signal_WEA_List.hasOwnProperty("resultCode")) && e.data.TTLive_Signal_WEA_List.resultCode == 1)
               {
                  this.mParent.sendEvent(NavigationEvent.TTLS_WEATHER_UPDATE,e.data.TTLive_Signal_WEA_List.hasOwnProperty("weatherList") == true ? e.data.TTLive_Signal_WEA_List.weatherList : null);
               }
               else
               {
                  this.mParent.sendEvent(NavigationEvent.TTLS_WEATHER_UPDATE_FAIL);
               }
            }
            if(e.data.hasOwnProperty("TTLive_Signal_LocalSearch_List"))
            {
               if(Boolean(e.data.TTLive_Signal_LocalSearch_List.hasOwnProperty("resultCode")) && e.data.TTLive_Signal_LocalSearch_List.resultCode == 1)
               {
                  this.mParent.sendEvent(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE,e.data.TTLive_Signal_LocalSearch_List.hasOwnProperty("places") == true ? e.data.TTLive_Signal_LocalSearch_List.places : null);
               }
               else
               {
                  this.mParent.sendEvent(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE_FAIL);
               }
            }
            if(e.data.hasOwnProperty("TTLive_Signal_Status"))
            {
               Framework.Trace("Received TTLive_Signal_Status");
               if(e.data.TTLive_Signal_Status.hasOwnProperty("status"))
               {
                  this.mTTLS_StatusReceived = true;
                  if(int(e.data.TTLive_Signal_Status.status) == AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE)
                  {
                     Framework.Trace("setting TTLS_SIGNAL_STATUS_AVAILABLE");
                     this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE;
                  }
                  else if(int(e.data.TTLive_Signal_Status.status) == AuthenticationTypes.TTLS_SIGNAL_STATUS_UNAVAILABLE)
                  {
                     Framework.Trace("setting TTLS_SIGNAL_STATUS_UNAVAILABLE");
                     this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_UNAVAILABLE;
                  }
                  else if(int(e.data.TTLive_Signal_Status.status) == AuthenticationTypes.TTLS_TOMTOM_SERVICE_READY && Boolean(e.data.TTLive_Signal_Status.hasOwnProperty("services")))
                  {
                     Framework.Trace("setting TTLS_TOMTOM_SERVICE_READY");
                     this.mTTLS_AvailableServices |= int(e.data.TTLive_Signal_Status.services);
                     this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE;
                  }
                  else if(int(e.data.TTLive_Signal_Status.status) == AuthenticationTypes.TTLS_TOMTOM_SERVICE_NOT_READY && Boolean(e.data.TTLive_Signal_Status.hasOwnProperty("services")))
                  {
                     Framework.Trace("setting TTLS_TOMTOM_SERVICE_NOT_READY");
                     this.mTTLS_AvailableServices ^= int(e.data.TTLive_Signal_Status.services);
                  }
                  this.mParent.sendEvent(NavigationEvent.TTLS_SERVICE_READY_UPDATE);
               }
            }
            if(e.data.hasOwnProperty("TTLive_GetStatus"))
            {
               Framework.Trace("Received TTLive_GetStatus");
               if(Boolean(e.data.TTLive_GetStatus.hasOwnProperty("status")) && Boolean(e.data.TTLive_GetStatus.hasOwnProperty("services")))
               {
                  this.mTTLS_StatusReceived = true;
                  if(int(e.data.TTLive_GetStatus.status) == AuthenticationTypes.TTLS_TOMTOM_SERVICE_READY || int(e.data.TTLive_GetStatus.status) == AuthenticationTypes.TTLS_TOMTOM_SERVICE_NOT_READY || int(e.data.TTLive_GetStatus.status) == AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE)
                  {
                     this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE;
                  }
                  else
                  {
                     this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_UNAVAILABLE;
                  }
                  if(int(e.data.TTLive_GetStatus.status) == AuthenticationTypes.TTLS_TOMTOM_SERVICE_READY)
                  {
                     this.mTTLS_AvailableServices = int(e.data.TTLive_GetStatus.services);
                  }
                  this.mParent.sendEvent(NavigationEvent.TTLS_SERVICE_READY_UPDATE);
               }
            }
            if(Boolean(e.data.hasOwnProperty("TTLive_GetList")) && Boolean(e.data.TTLive_GetList.hasOwnProperty("resultCode")))
            {
               if(int(e.data.TTLive_GetList.resultCode) != 1)
               {
                  if(1)
                  {
                     this.mParent.sendEvent(NavigationEvent.TTLS_WEATHER_UPDATE_FAIL);
                  }
                  if(1)
                  {
                     this.mParent.sendEvent(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE_FAIL);
                  }
                  Framework.Trace("LiveServicesManager.liveServicesMessageHandlerTTLS() ResultCode = " + e.data.TTLive_GetList.resultCode);
               }
            }
         }
         else
         {
            Framework.Trace("LiveServicesManager.liveServicesMessageHandlerTTLS() Unknown Event");
         }
      }
      
      public function informSetAlertProperties(resp:Object) : void
      {
         var found:Boolean = false;
         var newRequest:Array = null;
         var i:int = 0;
         var inputEIS:String = null;
         var j:int = 0;
         if(resp.hasOwnProperty("configs") && resp.hasOwnProperty("validState"))
         {
            if(resp.validState != 1)
            {
               found = false;
               newRequest = new Array();
               for(i = 0; i < (resp.configs as Array).length; i++)
               {
                  if(String(resp.configs[i]).indexOf("<SCTYPE>64<*>") != -1 || String(resp.configs[i]).indexOf("<SCTYPE>128<*>") != -1)
                  {
                     found = true;
                  }
                  else
                  {
                     newRequest.push(String(resp.configs[i]));
                  }
               }
               if(found)
               {
                  inputEIS = "";
                  for(j = 0; j < newRequest.length; j++)
                  {
                     inputEIS += "\"" + newRequest[j] + "\"";
                     if(inputEIS.length > 0)
                     {
                        inputEIS += ",";
                     }
                  }
                  if(inputEIS.lastIndexOf(",") == inputEIS.length - 1)
                  {
                     inputEIS = inputEIS.slice(0,inputEIS.length - 1);
                  }
                  this.mParent.sendCommand("\"ETC_SetAlertProperties\":" + "{" + "\"configs\":" + "[" + inputEIS + "]" + "}");
               }
            }
         }
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         if(this.mParent.navIsReady)
         {
            this.mParent.removeEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady);
            this.mParent.sendServiceSubscribe(Navigation.dbusUConnectACNDbusIdentifier,"authenticationStatus");
            this.mParent.sendServiceSubscribe(Navigation.dbusUConnectACNDbusIdentifier,"sessionToken");
            this.mParent.sendServiceSubscribe(Navigation.dbusUConnectACNDbusIdentifier,"subscriptionList");
            this.mParent.sendServiceSubscribe(Navigation.dbusUConnectACNDbusIdentifier,"connectivityStatus");
            this.mParent.sendServiceSubscribe(Navigation.dbusUConnectACNDbusIdentifier,"notifyConnectivityStatus");
            this.mParent.sendServiceSubscribe(Navigation.dbusTomTomLiveServiceDbusIdentifier,"TTLive_Signal_Status");
            this.mParent.sendServiceSubscribe(Navigation.dbusTomTomLiveServiceDbusIdentifier,"TTLive_Signal_WEA_List");
            this.mParent.sendServiceSubscribe(Navigation.dbusTomTomLiveServiceDbusIdentifier,"TTLive_Signal_LocalSearch_List");
            this.mParent.sendServiceCommand(Navigation.dbusTomTomLiveServiceDbusIdentifier,"\"TTLive_GetStatus\":{}");
         }
      }
      
      private function splitLatLong(split:Object) : void
      {
         split["long"] = String(String(split["geo"]).substring(0,String(split["geo"]).lastIndexOf(" ")));
         split["lat"] = String(String(split["geo"]).substring(String(split["geo"]).lastIndexOf(" ") + 1,String(split["geo"]).length - 1));
         if(String(split["long"]).charAt(0) != "+" && String(split["long"]).charAt(0) != "-")
         {
            split["long"] = "+" + String(split["long"]);
         }
         if(String(split["lat"]).charAt(0) != "+" && String(split["lat"]).charAt(0) != "-")
         {
            split["lat"] = "+" + String(split["lat"]);
         }
      }
      
      private function checkDataSumilationConfiguration() : void
      {
         if(this.mSimulationDataEnabled)
         {
            this.mAuthenticationStatus = SimulationDataProvider.provideSimulationData();
            this.mTTLS_Status = AuthenticationTypes.TTLS_SIGNAL_STATUS_AVAILABLE;
            this.mTTLS_AvailableServices = AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH | AuthenticationTypes.TTLS_SERVICE_TRAFFIC | AuthenticationTypes.TTLS_SERVICE_WEATHER | AuthenticationTypes.TTLS_SERVICE_SPEEDCAM | AuthenticationTypes.TTLS_SERVICE_SPEEDCAM_FEEDBACK;
            this.mTTLS_TurnedOn = true;
            this.mTTLS_StatusReceived = true;
            if(this.mSimulationResponseTimer == null)
            {
               this.mSimulationResponseTimer = new Timer(5000,1);
               this.mSimulationResponseTimer.addEventListener(TimerEvent.TIMER,this.onSimulationResponseTimer,false,0,true);
            }
         }
      }
      
      private function onSimulationResponseTimer(e:TimerEvent) : void
      {
         switch(this.mSimulationResponseType)
         {
            case AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH:
               this.mParent.sendEvent(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE,Object(SimulationDataProvider.localSearchSimulationData())["places"]);
               break;
            case AuthenticationTypes.TTLS_SERVICE_TRAFFIC:
               break;
            case AuthenticationTypes.TTLS_SERVICE_WEATHER:
               this.mParent.sendEvent(NavigationEvent.TTLS_WEATHER_UPDATE,Object(SimulationDataProvider.weatherSimulationData())["weatherList"]);
               break;
            case AuthenticationTypes.TTLS_SERVICE_SPEEDCAM:
            case AuthenticationTypes.TTLS_SERVICE_SPEEDCAM_FEEDBACK:
         }
      }
   }
}

