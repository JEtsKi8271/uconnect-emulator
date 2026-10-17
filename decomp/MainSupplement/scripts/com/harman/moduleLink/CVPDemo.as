package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.CVPDemoEvent;
   import com.harman.moduleLinkAPI.ICVPDemo;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class CVPDemo extends Module implements ICVPDemo
   {
      
      private static var instance:CVPDemo;
      
      private static const dbusIdentifier:String = "CVPDemo";
      
      private var connection:Connection;
      
      private var name:String = "CVPDemoClient";
      
      private var wakupreason:String = "ignitionOn";
      
      private var m_phoneMeid:String;
      
      private var m_phoneImsi:String;
      
      private var m_phoneMdn:String;
      
      private var m_phoneNai:String;
      
      private var m_phonePrlVersion:String;
      
      private var m_phoneRssi:String;
      
      private var m_phonePaCurrent:String;
      
      private var m_phonePaMax:String;
      
      private var m_phonePmicCurrent:String;
      
      private var m_phonePmicMax:String;
      
      private var m_phoneHwVersion:String = "";
      
      private var m_phoneSwVersion:String = "";
      
      private var m_phoneBtVersion:String = "";
      
      private var m_phoneUsbPorts:Array;
      
      private var m_callState:Object;
      
      private var m_wcntReason:int;
      
      private var m_signalQuality:Number;
      
      private var m_network:String = "";
      
      private var m_networkRegistration:String = "";
      
      private var client:Client;
      
      private var mCVPDemoServicePresent:Boolean = false;
      
      public function CVPDemo()
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
         this.connection.addEventListener(ConnectionEvent.CVPDEMO,this.CVPDemoMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : CVPDemo
      {
         if(instance == null)
         {
            instance = new CVPDemo();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAvailableRequest();
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.sendMultiSubscribe(["wakeupReason","callState","signalQuality","wcntReason","paTempChanged","networkRegistrationState","deviceServiceState","embeddedPhoneStatus"]);
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
      
      public function CVPDemoMessageHandler(e:ConnectionEvent) : void
      {
         var tmpAnswer:Object = null;
         var cvpDemo:Object = e.data;
         try
         {
            if(cvpDemo.hasOwnProperty("dBusServiceAvailable"))
            {
               if(cvpDemo.dBusServiceAvailable == "true" && this.mCVPDemoServicePresent == false)
               {
                  this.mCVPDemoServicePresent = true;
                  this.sendCommand("getCallState");
               }
               else if(cvpDemo.dBusServiceAvailable == "false")
               {
                  this.mCVPDemoServicePresent = false;
               }
            }
            else if(cvpDemo.hasOwnProperty("wakeupReason"))
            {
               this.wakupreason = cvpDemo.wakeupReason.wakeupReason;
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.WAKEUP_REASON,this.wakupreason));
            }
            else if(cvpDemo.hasOwnProperty("paTempChanged"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.PA_TEMP_CHANGED,cvpDemo.paTempChanged.temperature));
            }
            else if(cvpDemo.hasOwnProperty("deviceServiceState"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.DEVICE_SERVICE_STATUS,cvpDemo.deviceServiceState));
            }
            else if(cvpDemo.hasOwnProperty("embeddedPhoneStatus"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_STATUS,cvpDemo.embeddedPhoneStatus));
            }
            else if(cvpDemo.hasOwnProperty("signalQuality"))
            {
               this.convertRSSI(Number(cvpDemo.signalQuality.rssi));
            }
            else if(cvpDemo.hasOwnProperty("wcntReason"))
            {
               if(this.m_networkRegistration == "")
               {
                  this.getNetworkRegistration();
               }
               this.m_wcntReason = cvpDemo.wcntReason.reason;
               this.convertNetwork();
            }
            else if(cvpDemo.hasOwnProperty("networkRegistrationState"))
            {
               this.m_networkRegistration = cvpDemo.networkRegistrationState.state;
               this.convertNetwork();
            }
            else if(cvpDemo.hasOwnProperty("getSwRevision"))
            {
               this.m_phoneSwVersion = cvpDemo.getSwRevision.swApplVer;
               this.m_phoneBtVersion = cvpDemo.getSwRevision.swBootVer;
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.FIRMWARE_VERSIONS,cvpDemo));
               tmpAnswer = cvpDemo.getSwRevision;
               tmpAnswer["calledFromMethod"] = "getSwRevision";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getMEID"))
            {
               this.m_phoneMeid = cvpDemo.getMEID.imei;
               tmpAnswer = cvpDemo.getMEID;
               tmpAnswer["calledFromMethod"] = "getMEID";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getIMSI"))
            {
               this.m_phoneImsi = cvpDemo.getIMSI.imsi;
               tmpAnswer = cvpDemo.getIMSI;
               tmpAnswer["calledFromMethod"] = "getIMSI";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getSubscriberNumber"))
            {
               this.m_phoneMdn = cvpDemo.getSubscriberNumber.numberList[0];
            }
            else if(cvpDemo.hasOwnProperty("getProfileInformation"))
            {
               this.m_phoneNai = cvpDemo.getProfileInformation.profileInfo.nai;
            }
            else if(cvpDemo.hasOwnProperty("getPrlVersion"))
            {
               this.m_phonePrlVersion = cvpDemo.getPrlVersion.prlVersion;
               tmpAnswer = cvpDemo.getPrlVersion;
               tmpAnswer["calledFromMethod"] = "getPrlVersion";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getProperties"))
            {
               if(cvpDemo.getProperties.hasOwnProperty("signalQuality"))
               {
                  this.m_phoneRssi = cvpDemo.getProperties.signalQuality.rssi;
                  this.convertRSSI(Number(cvpDemo.getProperties.signalQuality.rssi));
                  if(this.m_networkRegistration == "")
                  {
                     this.getNetworkRegistration();
                  }
               }
               else if(cvpDemo.getProperties.hasOwnProperty("networkRegistrationState"))
               {
                  this.m_networkRegistration = cvpDemo.getProperties.networkRegistrationState.state;
                  this.convertNetwork();
               }
            }
            else if(cvpDemo.hasOwnProperty("getTemperature"))
            {
               this.m_phonePmicCurrent = cvpDemo.getTemperature.temperature;
               this.m_phonePmicMax = cvpDemo.getTemperature.temperature;
            }
            else if(cvpDemo.hasOwnProperty("getPaTemperature"))
            {
               this.m_phonePaCurrent = cvpDemo.getPaTemperature.temperature;
               this.m_phonePaMax = cvpDemo.getPaTemperature.temperature;
            }
            else if(cvpDemo.hasOwnProperty("getModel"))
            {
               this.m_phoneHwVersion = cvpDemo.getModel.model + " HW Version " + cvpDemo.getModel.hwVersion;
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.FIRMWARE_VERSIONS,cvpDemo));
               tmpAnswer = cvpDemo.getModel;
               tmpAnswer["calledFromMethod"] = "getModel";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getUsbPorts"))
            {
               if(cvpDemo.getUsbPorts.description == "success")
               {
                  this.m_phoneUsbPorts = cvpDemo.getUsbPorts.ports;
               }
            }
            else if(cvpDemo.hasOwnProperty("callState"))
            {
               this.m_callState = cvpDemo.callState;
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_CALLSTATE,this.m_callState));
            }
            else if(cvpDemo.hasOwnProperty("getCallState"))
            {
               this.m_callState = cvpDemo.getCallState;
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_CALLSTATE,this.m_callState));
            }
            else if(cvpDemo.hasOwnProperty("getCdmaSystemStatus"))
            {
               if(cvpDemo.getCdmaSystemStatus.code == 0)
               {
                  this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_CALL_CDMA_SYSTEM_STATUS,cvpDemo.getCdmaSystemStatus.status));
               }
            }
            else if(cvpDemo.hasOwnProperty("debugAT"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_DEBUGAT_ANSWER,cvpDemo.debugAT));
            }
            else if(cvpDemo.hasOwnProperty("getMdn"))
            {
               tmpAnswer = cvpDemo.getMdn;
               tmpAnswer["calledFromMethod"] = "getMdn";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getPri"))
            {
               tmpAnswer = cvpDemo.getPri;
               tmpAnswer["calledFromMethod"] = "getPri";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getReverseTunneling"))
            {
               tmpAnswer = cvpDemo.getReverseTunneling;
               tmpAnswer["calledFromMethod"] = "getReverseTunneling";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getHspi"))
            {
               tmpAnswer = cvpDemo.getHspi;
               tmpAnswer["calledFromMethod"] = "getHspi";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getAspi"))
            {
               tmpAnswer = cvpDemo.getAspi;
               tmpAnswer["calledFromMethod"] = "getAspi";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getMobileStationIp"))
            {
               tmpAnswer = cvpDemo.getMobileStationIp;
               tmpAnswer["calledFromMethod"] = "getMobileStationIp";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getPrimaryHaAddress"))
            {
               tmpAnswer = cvpDemo.getPrimaryHaAddress;
               tmpAnswer["calledFromMethod"] = "getPrimaryHaAddress";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getSecondaryHaAddress"))
            {
               tmpAnswer = cvpDemo.getSecondaryHaAddress;
               tmpAnswer["calledFromMethod"] = "getSecondaryHaAddress";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getServingSystem"))
            {
               tmpAnswer = cvpDemo.getServingSystem;
               tmpAnswer["calledFromMethod"] = "getServingSystem";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getAccessOverloadClass"))
            {
               tmpAnswer = cvpDemo.getAccessOverloadClass;
               tmpAnswer["calledFromMethod"] = "getAccessOverloadClass";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getSlotCycleIndex"))
            {
               tmpAnswer = cvpDemo.getSlotCycleIndex;
               tmpAnswer["calledFromMethod"] = "getSlotCycleIndex";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getNai"))
            {
               tmpAnswer = cvpDemo.getNai;
               tmpAnswer["calledFromMethod"] = "getNai";
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_STATUS,tmpAnswer));
            }
            else if(cvpDemo.hasOwnProperty("getEmergencyNumbers"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_EMG_NUM,cvpDemo.getEmergencyNumbers));
            }
            else if(cvpDemo.hasOwnProperty("setImsi"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setImsi));
            }
            else if(cvpDemo.hasOwnProperty("setAccessOverloadClass"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setAccessOverloadClass));
            }
            else if(cvpDemo.hasOwnProperty("setNai"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setNai));
            }
            else if(cvpDemo.hasOwnProperty("setReverseTunneling"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setReverseTunneling));
            }
            else if(cvpDemo.hasOwnProperty("setHspi"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setHspi));
            }
            else if(cvpDemo.hasOwnProperty("setAspi"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setAspi));
            }
            else if(cvpDemo.hasOwnProperty("setPrimaryHaAddress"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setPrimaryHaAddress));
            }
            else if(cvpDemo.hasOwnProperty("setSecondaryHaAddress"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setSecondaryHaAddress));
            }
            else if(cvpDemo.hasOwnProperty("setMnHaSharedSecrets"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setMnHaSharedSecrets));
            }
            else if(cvpDemo.hasOwnProperty("setMnAaaSharedSecrets"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_VALUE_STATUS,cvpDemo.setMnAaaSharedSecrets));
            }
            else if(cvpDemo.hasOwnProperty("selectProfile"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_SET_PROFILE_STATUS,cvpDemo.selectProfile));
            }
            else if(cvpDemo.hasOwnProperty("setSpc"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_CHECK_MSL_STATUS,cvpDemo.setSpc));
            }
            else if(cvpDemo.hasOwnProperty("commitChanges"))
            {
               this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.EMB_PHONE_AT_COMMIT_CHANGES_STATUS,cvpDemo.commitChanges));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function get network() : String
      {
         return this.m_network;
      }
      
      public function get signalQuality() : int
      {
         return this.m_signalQuality;
      }
      
      public function get WakeupReason() : String
      {
         return this.wakupreason;
      }
      
      public function get phoneMeid() : String
      {
         return this.m_phoneMeid;
      }
      
      public function get phoneImsi() : String
      {
         return this.m_phoneImsi;
      }
      
      public function get phoneMdn() : String
      {
         return this.m_phoneMdn;
      }
      
      public function get phoneNai() : String
      {
         return this.m_phoneNai;
      }
      
      public function get phonePrlVersion() : String
      {
         return this.m_phonePrlVersion;
      }
      
      public function get phoneRssi() : String
      {
         return this.m_phoneRssi;
      }
      
      public function get phonePaCurrent() : String
      {
         return this.m_phonePaCurrent;
      }
      
      public function get phonePaMax() : String
      {
         return this.m_phonePaMax;
      }
      
      public function get phonePmicCurrent() : String
      {
         return this.m_phonePmicCurrent;
      }
      
      public function get phonePmicMax() : String
      {
         return this.m_phonePmicMax;
      }
      
      public function get phoneHwVersion() : String
      {
         return this.m_phoneHwVersion;
      }
      
      public function get phoneSwVersion() : String
      {
         return this.m_phoneSwVersion;
      }
      
      public function get phoneBtVersion() : String
      {
         return this.m_phoneBtVersion;
      }
      
      public function get phoneUsbPorts() : Array
      {
         return this.m_phoneUsbPorts;
      }
      
      public function get callstate() : Object
      {
         return this.m_callState;
      }
      
      public function getFWVersions() : void
      {
         this.sendCommand("getSwRevision");
      }
      
      public function getMeid() : void
      {
         this.sendCommand("getMEID");
      }
      
      public function getModel() : void
      {
         this.sendCommand("getModel");
      }
      
      public function getImsi() : void
      {
         this.sendCommand("getIMSI");
      }
      
      public function getMdn() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getSubscriberNumber\" : {\"maxCount\":1}}}";
         this.client.send(message);
      }
      
      public function getNai() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProfileInformation\" : {\"profileNumber\":1}}}";
         this.client.send(message);
      }
      
      public function getPrlVersion() : void
      {
         this.sendCommand("getPrlVersion");
      }
      
      public function getRssi() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\" : {\"props\":[\"signalQuality\"]}}}";
         this.client.send(message);
      }
      
      public function getTemperature() : void
      {
         this.sendCommand("getTemperature");
      }
      
      public function getPaTemperature() : void
      {
         this.sendCommand("getPaTemperature");
      }
      
      public function getUsbPorts() : void
      {
         this.sendCommand("getUsbPorts");
      }
      
      public function getCdmaSystemStatus() : void
      {
         this.sendCommand("getCdmaSystemStatus");
      }
      
      public function sendDebugAT(atCommand:String) : void
      {
         var params:String = null;
         params = "\"atString\":\"" + atCommand + "\r\"";
         this.sendCommand("debugAT",params);
      }
      
      public function getMDN() : void
      {
         this.sendCommand("getMdn");
      }
      
      public function getPri() : void
      {
         this.sendCommand("getPri");
      }
      
      public function getReverseTunneling() : void
      {
         this.sendCommand("getReverseTunneling");
      }
      
      public function getHspi() : void
      {
         this.sendCommand("getHspi");
      }
      
      public function getAspi() : void
      {
         this.sendCommand("getAspi");
      }
      
      public function getMobileStationIp() : void
      {
         this.sendCommand("getMobileStationIp");
      }
      
      public function getPrimaryHaAddress() : void
      {
         this.sendCommand("getPrimaryHaAddress");
      }
      
      public function getSecondaryHaAddress() : void
      {
         this.sendCommand("getSecondaryHaAddress");
      }
      
      public function getServingSystem() : void
      {
         this.sendCommand("getServingSystem");
      }
      
      public function getAccessOverloadClass() : void
      {
         this.sendCommand("getAccessOverloadClass");
      }
      
      public function getSlotCycleIndex() : void
      {
         this.sendCommand("getSlotCycleIndex");
      }
      
      public function getNAI() : void
      {
         this.sendCommand("getNai");
      }
      
      public function getEmergencyNumbers() : void
      {
         this.sendCommand("getEmergencyNumbers","\"maxCount\":10");
      }
      
      public function setSpc(parameters:String) : void
      {
         this.sendCommand("setSpc","\"spc\":\"" + parameters + "\"");
      }
      
      public function commitChanges(parameters:int) : void
      {
         this.sendCommand("commitChanges","\"commit\": " + parameters);
      }
      
      public function setImsi(parameters:String) : void
      {
         this.sendCommand("setImsi","\"imsi\":\"" + parameters + "\"");
      }
      
      public function setAccessOverloadClass(parameters:String) : void
      {
         this.sendCommand("setAccessOverloadClass","\"aoc\" :" + parameters);
      }
      
      public function setNai(parameters:String) : void
      {
         this.sendCommand("setNai","\"nai\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setReverseTunneling(parameters:String) : void
      {
         this.sendCommand("setReverseTunneling","\"reverseTunneling\":" + parameters + ",\"commit\":1");
      }
      
      public function setHspi(parameters:String) : void
      {
         this.sendCommand("setHspi","\"hspi\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setAspi(parameters:String) : void
      {
         this.sendCommand("setAspi","\"aspi\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setPrimaryHaAddress(parameters:String) : void
      {
         this.sendCommand("setPrimaryHaAddress","\"address\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setSecondaryHaAddress(parameters:String) : void
      {
         this.sendCommand("setSecondaryHaAddress","\"address\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setMnHaSharedSecrets(parameters:String) : void
      {
         this.sendCommand("setMnHaSharedSecrets","\"mnhaCode\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function setMnAaaSharedSecrets(parameters:String) : void
      {
         this.sendCommand("setMnAaaSharedSecrets","\"mnaaaCode\":\"" + parameters + "\",\"commit\":1");
      }
      
      public function selectProfile(parameters:int) : void
      {
         this.sendCommand("selectProfile","\"profileNumber\":" + parameters);
      }
      
      private function getNetworkRegistration() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\" : {\"props\":[\"networkRegistrationState\"]}}}";
         this.client.send(message);
      }
      
      private function convertNetwork() : void
      {
         if(this.m_wcntReason == 33)
         {
            this.m_network = "1x";
         }
         else if(this.m_wcntReason == 33023)
         {
            this.m_network = "3G";
         }
         else
         {
            this.m_network = "none";
         }
         if(this.m_networkRegistration == "PHONE_REGSTATE_SEARCHING")
         {
            this.m_network = "none";
         }
         this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.NETWORK,{"network":this.m_network}));
      }
      
      private function convertRSSI(_value:Number) : void
      {
         var quality:Number = ~_value + 1;
         if(quality < 75)
         {
            this.m_signalQuality = 6;
         }
         else if(quality > 74 && quality < 85)
         {
            this.m_signalQuality = 5;
         }
         else if(quality > 84 && quality < 90)
         {
            this.m_signalQuality = 4;
         }
         else if(quality > 89 && quality < 95)
         {
            this.m_signalQuality = 3;
         }
         else if(quality > 94 && quality < 100)
         {
            this.m_signalQuality = 2;
         }
         else if(quality > 99 && quality > 105)
         {
            this.m_signalQuality = 1;
         }
         else
         {
            this.m_signalQuality = 0;
         }
         this.dispatchEvent(new CVPDemoEvent(CVPDemoEvent.SIGNAL_QUALITY,{"rssi":this.m_signalQuality}));
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
      
      protected function sendCommand(commandName:String, params:String = "") : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\",\"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"" + commandName + "\":{" + params + "}}}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

