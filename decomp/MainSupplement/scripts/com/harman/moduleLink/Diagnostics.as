package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DiagnosticsEvent;
   import com.harman.moduleLinkAPI.IDiagnostics;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.SignalStats;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Diagnostics extends Module implements IDiagnostics
   {
      
      private static var instance:Diagnostics;
      
      private static const dbusIdentifier:String = "XMDiagnostics";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mXMHwVersion:String = "";
      
      private var mXMSwVersion:String = "";
      
      private var mXMModuleType:String = "";
      
      private var mXMAntennaStatus:String = "";
      
      private var mXMCompositeSignal:String = "";
      
      private var mXMSatelliteSignal:String = "";
      
      private var mXMTerrestrialSignal:String = "";
      
      private var mSignalState:String = "";
      
      private var mSignalStatsList:Vector.<SignalStats> = new Vector.<SignalStats>();
      
      private var mOverlaySignalStatsList:Vector.<SignalStats> = new Vector.<SignalStats>();
      
      public function Diagnostics()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : Diagnostics
      {
         if(instance == null)
         {
            instance = new Diagnostics();
         }
         return instance;
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
         this.connection.addEventListener(ConnectionEvent.DIAGNOSTICS,this.DiagnosticsMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
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
      
      public function DiagnosticsMessageHandler(e:ConnectionEvent) : void
      {
         var newSignalStats:SignalStats = null;
         var signalResp:Object = null;
         var resp:Object = e.data;
         if(!resp.hasOwnProperty("enterDiagMode"))
         {
            if(!resp.hasOwnProperty("exitDiagMode"))
            {
               if(!resp.hasOwnProperty("requestSetTAMode"))
               {
                  if(resp.hasOwnProperty("requestX65ModuleVersion"))
                  {
                     if(resp.requestX65ModuleVersion.hasOwnProperty("versionInfo"))
                     {
                        this.mXMHwVersion = resp.requestX65ModuleVersion.versionInfo.swRev;
                        this.mXMModuleType = resp.requestX65ModuleVersion.versionInfo.type;
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_HW_VERSION));
                  }
                  else if(resp.hasOwnProperty("getSMSLibVersion"))
                  {
                     if(!resp.getSMSLibVersion.hasOwnProperty("status"))
                     {
                        this.mXMSwVersion = resp.getSMSLibVersion;
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_SW_VERSION));
                  }
                  else if(resp.hasOwnProperty("requestAntennaSignalInfo"))
                  {
                     if(resp.requestAntennaSignalInfo.hasOwnProperty("antennaSignalInfo"))
                     {
                        this.mXMAntennaStatus = resp.requestAntennaSignalInfo.antennaSignalInfo.antennaStatus;
                        this.mXMCompositeSignal = resp.requestAntennaSignalInfo.antennaSignalInfo.compositeSignal;
                        this.mXMSatelliteSignal = resp.requestAntennaSignalInfo.antennaSignalInfo.satelliteSignal;
                        this.mXMTerrestrialSignal = resp.requestAntennaSignalInfo.antennaSignalInfo.terrestrialSignal;
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_ANTENNA_SIGNAL_INFO));
                  }
                  else if(resp.hasOwnProperty("requestDetailedSignalStats"))
                  {
                     if(resp.requestDetailedSignalStats.hasOwnProperty("signalStats"))
                     {
                        this.mSignalStatsList = new Vector.<SignalStats>();
                        signalResp = resp.requestDetailedSignalStats.signalStats;
                        if(signalResp.hasOwnProperty("berS1"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "berS1";
                           newSignalStats.value = signalResp.berS1;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("berS2"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "berS2";
                           newSignalStats.value = signalResp.berS2;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("bert"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "bert";
                           newSignalStats.value = signalResp.bert;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("cnS1A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "cnS1A";
                           newSignalStats.value = signalResp.cnS1A;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("cnS1B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "cnS1B";
                           newSignalStats.value = signalResp.cnS1B;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("cnS2A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "cnS2A";
                           newSignalStats.value = signalResp.cnS2A;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("cnS2B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "cnS2B";
                           newSignalStats.value = signalResp.cnS2B;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("enSALockStatus"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "enSALockStatus";
                           newSignalStats.value = signalResp.enSALockStatus;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("enSBLockStatus"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "enSBLockStatus";
                           newSignalStats.value = signalResp.enSBLockStatus;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("rsErrsSatSymb"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "rsErrsSatSymb";
                           newSignalStats.value = signalResp.rsErrsSatSymb;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("rsErrsTerrSymb"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "rsErrsTerrSymb";
                           newSignalStats.value = signalResp.rsErrsTerrSymb;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("rsErrsWord"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "rsErrsWord";
                           newSignalStats.value = signalResp.rsErrsWord;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("rssi"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "rssi";
                           newSignalStats.value = signalResp.rssi;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("signalStrength"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "signalStrength";
                           newSignalStats.value = signalResp.signalStrength;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("tunerCarrierFreqOffset"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "tunerCarrierFreqOffset";
                           newSignalStats.value = signalResp.tunerCarrierFreqOffset;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("tunerStatus"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "tunerStatus";
                           newSignalStats.value = signalResp.tunerStatus;
                           this.mSignalStatsList.push(newSignalStats);
                        }
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_DETAILED_SIGNAL_STATS));
                  }
                  else if(resp.hasOwnProperty("requestDetailedOverlaySignalStats"))
                  {
                     if(resp.requestDetailedOverlaySignalStats.hasOwnProperty("signalStats"))
                     {
                        this.mOverlaySignalStatsList = new Vector.<SignalStats>();
                        signalResp = resp.requestDetailedOverlaySignalStats.signalStats;
                        if(signalResp.hasOwnProperty("oberS1A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberS1A";
                           newSignalStats.value = signalResp.oberS1A;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberS1B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberS1B";
                           newSignalStats.value = signalResp.oberS1B;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberS2A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberS2A";
                           newSignalStats.value = signalResp.oberS2A;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberS2B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberS2B";
                           newSignalStats.value = signalResp.oberS2B;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER0A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER0A";
                           newSignalStats.value = signalResp.oberTWER0A;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER0B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER0B";
                           newSignalStats.value = signalResp.oberTWER0B;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER1A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER1A";
                           newSignalStats.value = signalResp.oberTWER1A;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER1B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER1B";
                           newSignalStats.value = signalResp.oberTWER1B;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER2A"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER2A";
                           newSignalStats.value = signalResp.oberTWER2A;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTWER2B"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTWER2B";
                           newSignalStats.value = signalResp.oberTWER2B;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTerrA"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTerrA";
                           newSignalStats.value = signalResp.oberTerrA;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("oberTerrB"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "oberTerrB";
                           newSignalStats.value = signalResp.oberTerrB;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                        if(signalResp.hasOwnProperty("receiverState"))
                        {
                           newSignalStats = new SignalStats();
                           newSignalStats.stat = "receiverState";
                           newSignalStats.value = signalResp.receiverState;
                           this.mOverlaySignalStatsList.push(newSignalStats);
                        }
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_DETAILED_OVERLAY_SIGNAL_STATS));
                  }
                  else if(resp.hasOwnProperty("requestSignalQuality"))
                  {
                     if(resp.requestSignalQuality.hasOwnProperty("signalQuality"))
                     {
                        if(resp.requestSignalQuality.signalQuality.hasOwnProperty("signalState"))
                        {
                           this.mSignalState = resp.requestSignalQuality.signalQuality.signalState;
                        }
                     }
                     dispatchEvent(new DiagnosticsEvent(DiagnosticsEvent.XM_SIGNAL_STATE));
                  }
               }
            }
         }
      }
      
      public function set taMode(mode:String) : void
      {
         this.sendCommand("requestSetTAMode","mode",mode);
      }
      
      public function enterXMDiagMode() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"enterDiagMode\":{}}}");
      }
      
      public function exitXMDiagMode() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"exitDiagMode\":{}}}");
      }
      
      public function requestXMHwVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestX65ModuleVersion\":{}}}");
      }
      
      public function requestXMSwVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getSMSLibVersion\":{}}}");
      }
      
      public function restoreX65ToFactoryState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestSRMFactoryShutdown\":{}}}");
      }
      
      public function requestAntennaSignalInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestAntennaSignalInfo\":{}}}");
      }
      
      public function requestDetailedSignalStats() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestDetailedSignalStats\":{}}}");
      }
      
      public function requestDetailedOverlaySignalStats() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestDetailedOverlaySignalStats\":{}}}");
      }
      
      public function requestSignalQuality() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"requestSignalQuality\":{}}}");
      }
      
      public function get xmHwVersion() : String
      {
         return this.mXMHwVersion;
      }
      
      public function get xmSwVersion() : String
      {
         return this.mXMSwVersion;
      }
      
      public function get xmModuleType() : String
      {
         return this.mXMModuleType;
      }
      
      public function get xmAntennaStatus() : String
      {
         return this.mXMAntennaStatus;
      }
      
      public function get xmCompositeSignal() : String
      {
         return this.mXMCompositeSignal;
      }
      
      public function get xmSatelliteSignal() : String
      {
         return this.mXMSatelliteSignal;
      }
      
      public function get xmTerrestrialSignal() : String
      {
         return this.mXMTerrestrialSignal;
      }
      
      public function get xmSignalState() : String
      {
         return this.mSignalState;
      }
      
      public function get detailedSignalStats() : Vector.<SignalStats>
      {
         return this.mSignalStatsList;
      }
      
      public function get detailedOverlaySignalStats() : Vector.<SignalStats>
      {
         return this.mOverlaySignalStatsList;
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
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

