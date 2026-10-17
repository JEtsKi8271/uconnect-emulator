package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.IWiFiService;
   import com.harman.moduleLinkAPI.WiFiServiceEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class WiFiService extends Module implements IWiFiService
   {
      
      private static var instance:WiFiService;
      
      private static const STARTUP_GETROLE:int = 0;
      
      private static const STARTUP_GETPROFILE:int = 1;
      
      private static const STARTUP_GETWLAN:int = 2;
      
      private static const APPMANAGER_READY:int = 3;
      
      private static const DRM_VERIFICATION:int = 4;
      
      private static const STARTUP_SETRF:int = 5;
      
      private static const STARTUP_DONE:int = 6;
      
      private static const dbusIdentifier:String = "WiFiService";
      
      private static const dbusWiFiPersistency:String = "WiFiPersistency";
      
      private var connection:Connection;
      
      private var name:String = "WiFiHMIClient";
      
      private var client:Client;
      
      private var mCurWiFiState:String;
      
      private var mCurWiFiRole:String;
      
      private var mWiFiTestMode:Object;
      
      private var mWiFiClientList:Array;
      
      private var mWiFiReady:Boolean;
      
      private var mWiFiActive:String;
      
      private var mPersistedWlanState:String;
      
      private var mWiFiDRMEnabled:Boolean;
      
      private var mWiFiStartupState:int;
      
      private var mIntendedProfile:Object = null;
      
      private var mActiveProfile:Object;
      
      private var mDesiredRole:String = "AP";
      
      private var mWakeUpReason:String = "CAN";
      
      private var mPreviousWakeUpReason:String;
      
      private var mWifiServiceAvailable:Boolean = false;
      
      private var setProfilePending:Boolean = false;
      
      private var appManagerStatus:String = "Undefined";
      
      private var registeredAppMgrStatus:Boolean = false;
      
      public function WiFiService()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.WIFI_SERVICE,this.WiFiSvcMessageHandler);
         this.connection.addEventListener(ConnectionEvent.WIFI_PERSISTENCY,this.WiFiPersistencyMessageHandler);
         this.connection.addEventListener(ConnectionEvent.APP_MANAGER,this.AppMgrMsgHandler);
         AntiTheft.getInstance().addEventListener(AntiTheftEvent.ANTI_THEFT_WAKEUPREASON,this.onWakeupReason);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.mWiFiStartupState = STARTUP_GETROLE;
         this.mCurWiFiState = "";
         this.mCurWiFiRole = "UNKNOWN";
         this.mWiFiTestMode = null;
         this.mWiFiClientList = null;
         this.mWiFiReady = false;
         this.mWiFiActive = "UNKNOWN";
         this.mPersistedWlanState = "AP_READY";
         this.mWiFiDRMEnabled = false;
         this.mActiveProfile = new Object();
         this.mActiveProfile.keyList = [""];
         this.mActiveProfile.keyIndex = -1;
         this.mActiveProfile.password = "";
         this.mActiveProfile.SSIDBroadcast = "";
         this.mActiveProfile.SSID = "";
         this.mActiveProfile.encryption = "";
         this.mActiveProfile.authentication = "";
         this.mActiveProfile.channel = -1;
         this.mActiveProfile.op_mode = "";
         this.mActiveProfile.country = "";
      }
      
      public static function getInstance() : WiFiService
      {
         if(instance == null)
         {
            instance = new WiFiService();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendWiFiAvailableRequest();
               this.sendAppManagerAvailableRequest();
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.getWlanStatePersistency();
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
         this.name = this.connection.configuration.@name.toString();
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function processClientList(obj:Object) : void
      {
         this.mWiFiClientList = obj.clientList;
      }
      
      public function onWakeupReason(e:AntiTheftEvent) : void
      {
         this.mPreviousWakeUpReason = this.mWakeUpReason;
         this.mWakeUpReason = AntiTheft.getInstance().WakeUpReason;
         if(this.mWakeUpReason != "resumeMode" && this.mPreviousWakeUpReason == "resumeMode")
         {
            this.mWiFiStartupState = STARTUP_GETROLE;
            this.wifiStartupState();
         }
      }
      
      public function WiFiSvcMessageHandler(e:ConnectionEvent) : void
      {
         var curProfile:Object = null;
         var resultOK:String = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mWifiServiceAvailable == false)
            {
               this.mWifiServiceAvailable = true;
               this.wifiStartupState();
               this.sendMultiSubscribe(["Wlan_EV_stateChanged","Wlan_EV_modeChanged","Wlan_EV_clientJoined","Wlan_EV_clientLeave","Wlan_EV_clientWPASuccess","Wlan_EV_scanResults","Wlan_EV_joinedNetwork","Wlan_Client_EV_WPA_failure","Wlan_EV_leftNetwork"]);
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mWifiServiceAvailable = false;
            }
         }
         else if(resp.hasOwnProperty("Wlan_EV_clientJoined"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_CLIENTJOINED,e.data));
            this.getClientList();
         }
         else if(resp.hasOwnProperty("Wlan_EV_clientLeave"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_CLIENTLEAVE,e.data));
            this.getClientList();
         }
         else if(resp.hasOwnProperty("Wlan_EV_clientWPASuccess"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_WPASUCCESS,e.data));
            this.getClientList();
         }
         else if(resp.hasOwnProperty("Wlan_EV_stateChanged"))
         {
            this.mCurWiFiState = e.data.Wlan_EV_stateChanged.wlanState;
            if((this.mCurWiFiRole == null || this.mCurWiFiRole == "UNKNOWN") && this.mWiFiStartupState == STARTUP_GETROLE)
            {
               this.wifiStartupState();
            }
            else
            {
               this.processWlanState();
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_STATECHANGED,this.mCurWiFiState));
            }
         }
         else if(resp.hasOwnProperty("Wlan_EV_modeChanged"))
         {
            this.mCurWiFiRole = e.data.Wlan_EV_modeChanged.wlanMode;
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_CURRENT_ROLE,this.mCurWiFiRole));
         }
         else if(resp.hasOwnProperty("getRole"))
         {
            this.processWiFiRole(e.data.getRole.role);
         }
         else if(resp.hasOwnProperty("setRole"))
         {
            if(e.data.setRole.result == "OK")
            {
               this.getRole();
            }
         }
         else if(resp.hasOwnProperty("getRFActive"))
         {
            if(e.data.getRFActive.result == "OK")
            {
               this.mWiFiActive = e.data.getRFActive.rf_on;
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_RF_ACTIVE,this.mWiFiActive));
            }
         }
         else if(resp.hasOwnProperty("getContinuousTransmit"))
         {
            this.mWiFiTestMode = e.data.getContinuousTransmit;
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_TEST_MODE,this.mWiFiTestMode));
         }
         else if(resp.hasOwnProperty("setContinuousTransmit"))
         {
            this.getWiFiAPTestMode();
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_SET_TEST_MODE_RESULT,e.data));
         }
         else if(resp.hasOwnProperty("getClientList"))
         {
            if(e.data.getClientList.result == "OK")
            {
               this.processClientList(e.data.getClientList);
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_GET_CLIENT_LIST_RESULT,e.data));
            }
         }
         else if(resp.hasOwnProperty("getProfile"))
         {
            curProfile = e.data.getProfile;
            this.mActiveProfile.SSIDBroadcast = curProfile.SSIDBroadcast;
            this.mActiveProfile.SSID = curProfile.SSID;
            this.mActiveProfile.encryption = curProfile.encryption;
            this.mActiveProfile.authentication = curProfile.authentication;
            this.mActiveProfile.channel = curProfile.channel;
            this.mActiveProfile.op_mode = curProfile.op_mode;
            this.mActiveProfile.country = curProfile.country;
            if(this.mActiveProfile.encryption == "EM_WEP128")
            {
               this.mActiveProfile.password = curProfile.password;
               this.mActiveProfile.keyIndex = 0;
               this.mActiveProfile.keyList.length = 1;
               this.mActiveProfile.keyList[0] = curProfile.password;
            }
            else if(curProfile.hasOwnProperty("keyList") && curProfile.hasOwnProperty("keyIndex"))
            {
               this.mActiveProfile.keyList = curProfile.keyList;
               this.mActiveProfile.keyIndex = curProfile.keyIndex;
               this.mActiveProfile.password = curProfile.keyList[curProfile.keyIndex];
            }
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_GET_AP_PROFILE,this.mActiveProfile));
            if(this.mWiFiStartupState < STARTUP_DONE)
            {
               ++this.mWiFiStartupState;
               this.wifiStartupState();
            }
         }
         else if(resp.hasOwnProperty("setProfile"))
         {
            resultOK = e.data.setProfile.result;
            if(resultOK.toUpperCase() != "OK")
            {
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_SET_PROFILE_FAILURE,e.data.setProfile.result));
            }
            this.getAPProfile();
            this.mIntendedProfile = null;
            if(this.mCurWiFiState != this.mPersistedWlanState.toUpperCase())
            {
               if(this.mPersistedWlanState == "AP_ACTIVE")
               {
                  this.setRFActive("on",false);
               }
               else
               {
                  this.setRFActive("off",false);
               }
            }
         }
         else if(resp.hasOwnProperty("getWlanState"))
         {
            if(e.data.getWlanState.result == "OK")
            {
               this.mCurWiFiState = e.data.getWlanState.wlanState;
               this.processWlanState();
            }
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_GET_WLAN_STATE,e.data));
         }
         else if(resp.hasOwnProperty("setRFActive"))
         {
            if(this.mWiFiStartupState < STARTUP_DONE)
            {
               ++this.mWiFiStartupState;
               this.wifiStartupState();
            }
            else if(this.mWiFiActive.toUpperCase() == "OFF" && this.setProfilePending)
            {
               this.sentAPProfileRequest();
            }
         }
         else if(resp.hasOwnProperty("Wlan_EV_scanResults"))
         {
            if(e.data.Wlan_EV_scanResults.networks != null)
            {
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_GET_SCAN_NETWORK_RESULT,e.data.Wlan_EV_scanResults.networks));
            }
         }
         else if(resp.hasOwnProperty("getClientStatus"))
         {
            if(e.data.getClientStatus.result == "OK")
            {
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_GET_CLIENT_STATUS,e.data.getClientStatus));
            }
         }
         else if(resp.hasOwnProperty("Wlan_EV_joinedNetwork"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_JOINED_NETWORK,e.data));
         }
         else if(resp.hasOwnProperty("Wlan_Client_EV_WPA_failure"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_JOIN_NETWORK_FAILURE,e.data.Wlan_Client_EV_WPA_failure));
         }
         else if(resp.hasOwnProperty("joinNetwork"))
         {
            if(e.data.joinNetwork.result != "OK")
            {
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_JOIN_NETWORK_FAILURE,e.data.joinNetwork));
            }
         }
         else if(resp.hasOwnProperty("Wlan_EV_leftNetwork"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_LEFT_NETWORK,e.data));
         }
         else if(resp.hasOwnProperty("addNetwork"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_ADD_TO_KNOWN_NETWORKS_RESULT,e.data.addNetwork.result));
         }
         else if(resp.hasOwnProperty("deleteNetwork"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_DELETE_FROM_KNOWN_NETWORKS_RESULT,e.data.deleteNetwork.result));
         }
         else if(resp.hasOwnProperty("getKnownNetworks"))
         {
            if(e.data.getKnownNetworks.networks != null)
            {
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_KNOWN_NETWORKS,e.data.getKnownNetworks.networks));
            }
         }
         else if(resp.hasOwnProperty("setFavoriteNetwork"))
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_SET_FAVORITE_NETWORK_RESULT,e.data.setFavoriteNetwork.result));
         }
      }
      
      public function WiFiPersistencyMessageHandler(e:ConnectionEvent) : void
      {
         var message:Object = e.data;
         if(message.hasOwnProperty("write"))
         {
            if(message.write.res != "OK")
            {
            }
         }
         else if(message.hasOwnProperty("read"))
         {
            if(message.read.res != "Empty")
            {
               this.mPersistedWlanState = message.read.res;
            }
            else
            {
               this.mPersistedWlanState = "AP_READY";
            }
         }
      }
      
      public function AppMgrMsgHandler(e:ConnectionEvent) : void
      {
         var message:Object = e.data;
         if(message.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.registeredAppMgrStatus == false)
            {
               this.subscribeAppManagerStatus();
               this.subscribeWiFiDRMStatus();
            }
         }
         else if(message.hasOwnProperty("verifyDRM"))
         {
            if(message.verifyDRM.errorCode == 0)
            {
               this.mWiFiDRMEnabled = true;
            }
            else
            {
               this.mWiFiDRMEnabled = false;
            }
            if(this.mWiFiStartupState < STARTUP_DONE)
            {
               ++this.mWiFiStartupState;
               this.wifiStartupState();
            }
         }
         else if(message.hasOwnProperty("appManagerStatus"))
         {
            this.appManagerStatus = message.appManagerStatus.status;
            if(this.appManagerStatus != "Undefined" && this.mWiFiStartupState == APPMANAGER_READY)
            {
               this.wifiStartupState();
            }
         }
         else if(message.hasOwnProperty("wifiSubscriptionExpired"))
         {
            if(this.mCurWiFiState == "AP_ACTIVE")
            {
               this.mWiFiDRMEnabled = false;
               this.setRFActive("off",false);
            }
         }
         else if(message.hasOwnProperty("wifiSubscriptionValid"))
         {
            if(this.mPersistedWlanState == "AP_ACTIVE" && this.mCurWiFiState != "AP_ACTIVE")
            {
               this.mWiFiDRMEnabled = true;
               this.setRFActive("on",false);
            }
         }
      }
      
      public function get WiFiClientList() : Array
      {
         if(this.mWiFiClientList == null)
         {
         }
         return this.mWiFiClientList;
      }
      
      public function get Role() : String
      {
         if(this.mCurWiFiRole == "UNKNOWN" || this.mCurWiFiRole == null)
         {
            this.getRole();
            return "UNKNOWN";
         }
         return this.mCurWiFiRole;
      }
      
      public function get WlanState() : String
      {
         return this.mCurWiFiState;
      }
      
      public function get WiFiAPTestMode() : Object
      {
         return this.mWiFiTestMode;
      }
      
      public function get WiFiReady() : Boolean
      {
         return this.mWiFiReady;
      }
      
      public function get WiFiActive() : Boolean
      {
         return this.mWiFiActive.toUpperCase() == "ON";
      }
      
      public function get WiFiSSID() : String
      {
         return this.mActiveProfile.SSID;
      }
      
      public function get WiFiPassPhrase() : String
      {
         return this.mActiveProfile.password;
      }
      
      public function get WiFiSecurity() : String
      {
         return this.mActiveProfile.encryption;
      }
      
      public function setWiFiAPStatus(enable:Boolean) : void
      {
      }
      
      public function getWlanConnectionState() : String
      {
         return null;
      }
      
      public function getClientList() : void
      {
         this.sendCommand("getClientList","","");
      }
      
      public function setRole(role:String) : void
      {
         this.sendCommand("setRole","role",role);
      }
      
      public function setRFActive(active:String, persist:Boolean) : void
      {
         this.mWakeUpReason = AntiTheft.getInstance().WakeUpReason;
         if(this.mWakeUpReason != "resumeMode")
         {
            this.sendCommand("setRFActive","active",active);
            if(persist)
            {
               if(active == "off")
               {
                  this.mPersistedWlanState = "AP_READY";
               }
               else if(active == "on")
               {
                  this.mPersistedWlanState = "AP_ACTIVE";
               }
               this.setWlanStatePersistency(this.mPersistedWlanState);
            }
         }
         else
         {
            this.sendCommand("setRFActive","active","off");
         }
      }
      
      public function getRFActive() : void
      {
         this.sendCommand("getRFActive","","");
      }
      
      private function getRole() : void
      {
         this.sendCommand("getRole","","");
      }
      
      private function getWiFiAPTestMode() : void
      {
         this.sendCommand("getContinuousTransmit","","");
      }
      
      private function wifiStartupState() : void
      {
         switch(this.mWiFiStartupState)
         {
            case APPMANAGER_READY:
               ++this.mWiFiStartupState;
               this.wifiStartupState();
               break;
            case DRM_VERIFICATION:
               this.verifyWiFiDRM();
               break;
            case STARTUP_GETROLE:
               this.getRole();
               break;
            case STARTUP_GETPROFILE:
               this.getAPProfile();
               break;
            case STARTUP_GETWLAN:
               this.getWlanState();
               break;
            case STARTUP_SETRF:
               if(this.mWiFiDRMEnabled == false)
               {
                  if(this.mCurWiFiState == "AP_ACTIVE")
                  {
                     this.setRFActive("off",false);
                  }
                  else
                  {
                     ++this.mWiFiStartupState;
                     this.wifiStartupState();
                  }
               }
               else if(this.mWiFiDRMEnabled)
               {
                  if(this.mPersistedWlanState == "AP_READY" && this.mCurWiFiState == "AP_ACTIVE")
                  {
                     this.setRFActive("off",false);
                  }
                  else if(this.mPersistedWlanState == "AP_ACTIVE" && this.mCurWiFiState != this.mPersistedWlanState)
                  {
                     this.setRFActive("on",false);
                  }
                  else
                  {
                     ++this.mWiFiStartupState;
                     this.wifiStartupState();
                  }
               }
               break;
            case STARTUP_DONE:
               this.mWiFiReady = true;
               this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WIFI_READY,this.mWiFiReady));
         }
      }
      
      private function processWiFiRole(rolename:String) : void
      {
         if(rolename == "AP" || rolename == "CLIENT")
         {
            if(this.mDesiredRole == rolename)
            {
               this.mCurWiFiRole = rolename;
               if(this.mWiFiStartupState != STARTUP_DONE)
               {
                  ++this.mWiFiStartupState;
                  this.wifiStartupState();
               }
            }
            else
            {
               this.setRole("NONE");
            }
         }
         else if(rolename == "NONE")
         {
            if(this.mDesiredRole != "NONE")
            {
               this.setRole(this.mDesiredRole);
            }
         }
      }
      
      private function processWlanState() : void
      {
         if(this.mWiFiStartupState == STARTUP_GETWLAN)
         {
            ++this.mWiFiStartupState;
            this.wifiStartupState();
         }
         else if(this.mWiFiStartupState == STARTUP_DONE)
         {
            if(this.mWiFiDRMEnabled && this.mCurWiFiState != this.mPersistedWlanState.toUpperCase() && this.setProfilePending == false)
            {
               if(this.mPersistedWlanState == "AP_READY")
               {
                  this.setRFActive("off",false);
               }
               else if(this.mPersistedWlanState == "AP_ACTIVE")
               {
                  this.setRFActive("on",false);
               }
            }
         }
         if(this.mCurWiFiState == "AP_ACTIVE")
         {
            this.mWiFiActive = "on";
            this.getClientList();
         }
         else
         {
            this.mWiFiActive = "off";
         }
         if(this.mWiFiReady)
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_RF_ACTIVE,this.mWiFiActive));
         }
      }
      
      public function setWiFiAPTestMode(channel:int, rate:int, power:int, rf_mode:int, data_len:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setContinuousTransmit\": {";
         message = message + "\"channel\":" + channel + ",";
         message = message + "\"rate\":" + rate + ",";
         message = message + "\"power\":" + power + ",";
         message = message + "\"rf_mode\":" + rf_mode + ",";
         message = message + "\"data_len\":" + data_len + "}}}";
         this.client.send(message);
      }
      
      public function getAPProfile() : void
      {
         this.sendCommand("getProfile","","");
      }
      
      public function setAPProfile(profile:Object) : void
      {
         if(this.mIntendedProfile == null)
         {
            this.mIntendedProfile = new Object();
         }
         if(profile.encryption == "EM_WEP128")
         {
            this.mIntendedProfile.password = profile.password;
            this.mIntendedProfile.keyIndex = -1;
         }
         else
         {
            this.mIntendedProfile.keyList = profile.keyList;
            this.mIntendedProfile.keyIndex = profile.keyIndex;
            this.mIntendedProfile.password = "";
         }
         this.mIntendedProfile.SSIDBroadcast = profile.SSIDBroadcast;
         this.mIntendedProfile.SSID = profile.SSID;
         this.mIntendedProfile.encryption = profile.encryption;
         this.mIntendedProfile.authentication = profile.authentication;
         this.mIntendedProfile.channel = profile.channel;
         this.mIntendedProfile.op_mode = profile.op_mode;
         this.mIntendedProfile.country = profile.country;
         if(this.mIntendedProfile.encryption == "EM_WEP128" && this.mIntendedProfile.password.length != 13)
         {
            this.dispatchEvent(new WiFiServiceEvent(WiFiServiceEvent.WLAN_SET_PROFILE_WEP_PASSPHASE_NOT_13,this.mIntendedProfile));
         }
         else if(this.mWiFiActive.toUpperCase() == "ON")
         {
            this.setRFActive("off",false);
            this.setProfilePending = true;
         }
         else
         {
            this.sentAPProfileRequest();
         }
      }
      
      private function sentAPProfileRequest() : void
      {
         var index:int = 0;
         var message:String = null;
         this.setProfilePending = false;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setProfile\": {";
         if(this.mIntendedProfile.hasOwnProperty("keyList") && this.mIntendedProfile.keyList.length > 0)
         {
            message += "\"keyList\":[";
            for(index = 0; index < this.mIntendedProfile.keyList.length - 1; index++)
            {
               message = message + "\"" + this.mIntendedProfile.keyList[index] + "\",";
            }
            message = message + "\"" + this.mIntendedProfile.keyList[this.mIntendedProfile.keyList.length - 1] + "\"";
            message += "],";
            message = message + "\"keyIndex\":" + this.mIntendedProfile.keyIndex + ",";
         }
         else
         {
            message = message + "\"password\":\"" + this.mIntendedProfile.password + "\",";
         }
         message = message + "\"SSIDBroadcast\":\"" + this.mIntendedProfile.SSIDBroadcast + "\",";
         message = message + "\"SSID\":\"" + this.mIntendedProfile.SSID + "\",";
         message = message + "\"encryption\":\"" + this.mIntendedProfile.encryption + "\",";
         message = message + "\"authentication\":\"" + this.mIntendedProfile.authentication + "\",";
         message = message + "\"channel\":" + this.mIntendedProfile.channel + ",";
         message = message + "\"op_mode\":\"" + this.mIntendedProfile.op_mode + "\",";
         message = message + "\"country\":\"" + this.mIntendedProfile.country + "\"}}}";
         this.client.send(message);
      }
      
      public function getWlanState() : void
      {
         this.sendCommand("getWlanState","","");
      }
      
      public function scanNetworks(scanTimeInSeconds:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"scanNetworks\": {";
         message = message + "\"scanTime\":" + scanTimeInSeconds + "}}}";
         this.client.send(message);
      }
      
      public function getClientStatus() : void
      {
         this.sendCommand("getClientStatus","","");
      }
      
      public function joinNetwork(networkSSID:String, networkPassword:String, networkSecurity:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"joinNetwork\": {";
         message = message + "\"SSID\":\"" + networkSSID + "\"";
         if(networkPassword != null && networkPassword != "")
         {
            message = message + ",\"password\":\"" + networkPassword + "\"";
         }
         if(networkSecurity != null && networkSecurity != "")
         {
            message = message + ",\"security\":\"" + networkSecurity + "\"";
         }
         message += "}}}";
         this.client.send(message);
      }
      
      public function leaveNetwork() : void
      {
         this.sendCommand("leaveNetwork","","");
      }
      
      public function addToKnownNetworks(networkSSID:String, networkPassword:String, networkSecurity:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"addNetwork\": {";
         message = message + "\"SSID\":\"" + networkSSID + "\"";
         message = message + ",\"password\":\"" + networkPassword + "\"";
         if(networkSecurity != null && networkSecurity != "")
         {
            message = message + ",\"security\":\"" + networkSecurity + "\"";
         }
         message += "}}}";
         this.client.send(message);
      }
      
      public function deleteFromKnownNetworks(networkSSID:String) : void
      {
         this.sendCommand("deleteNetwork","SSID",networkSSID);
      }
      
      public function getKnownNetworks() : void
      {
         this.sendCommand("getKnownNetworks","","");
      }
      
      public function setFavoriteNetwork(networkSSID:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavoriteNetwork\": {";
         message = message + "\"SSID\":\"" + networkSSID + "\"";
         message += "}}}";
         this.client.send(message);
      }
      
      public function getActiveProfile() : Object
      {
         return this.mActiveProfile;
      }
      
      public function getIntendedProfile() : Object
      {
         if(this.mIntendedProfile == null)
         {
            return this.mActiveProfile;
         }
         return this.mIntendedProfile;
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
         switch(signalName)
         {
            case "Wlan_EV_stateChanged":
            case "Wlan_EV_modeChanged":
               break;
            default:
               message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
               this.client.send(message);
         }
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendWiFiAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendAppManagerAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"AppManager\"}";
         this.client.send(message);
      }
      
      private function subscribeAppManagerStatus() : void
      {
         var message:String = null;
         this.registeredAppMgrStatus = true;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"AppManager\", \"Signal\":\"appManagerStatus\"}";
         this.client.send(message);
      }
      
      private function subscribeWiFiDRMStatus() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"AppManager\", \"Signal\":\"wifiSubscriptionExpired\"}";
         this.client.send(message);
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"AppManager\", \"Signal\":\"wifiSubscriptionValid\"}";
         this.client.send(message);
      }
      
      private function getWlanStatePersistency() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusWiFiPersistency + "\", \"packet\": {\"read\":{\"key\":\"WLanState\", \"escval\":0}}}";
         this.client.send(message);
      }
      
      private function setWlanStatePersistency(enableWiFi:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusWiFiPersistency + "\", \"packet\": {\"write\":{\"WLanState\":\"" + enableWiFi + "\"}}}";
         this.client.send(message);
      }
      
      private function verifyWiFiDRM() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"AppManager\", \"packet\": {\"verifyDRM\":{\"appId\":\"WIFIAP\",\"name\":\"Wi-Fi Hotspot\",\"hideErrorPopup\":true}}}";
         this.client.send(message);
      }
   }
}

