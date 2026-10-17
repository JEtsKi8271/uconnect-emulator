package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IPPS;
   import com.harman.moduleLinkAPI.PPSEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class PPS extends Module implements IPPS
   {
      
      private static var instance:PPS;
      
      private static const dbusIdentifier:String = "readPPS";
      
      private static const STARTUP_RETRY_INTERVAL:int = 3000;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mBusy:Boolean = true;
      
      private var mConnected:Boolean = false;
      
      private var mNavigationMarketConfiguration:int = 0;
      
      private var mECUPartNum:String = null;
      
      private var mInterval:uint = 0;
      
      private var mReadPPSServiceAvailable:Boolean = false;
      
      public function PPS()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : PPS
      {
         if(instance == null)
         {
            instance = new PPS();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.mBusy = true;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.PPS,this.ppsMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAvailableRequest();
               this.mConnected = true;
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.sendEvent(PPSEvent.PPS_BUSY);
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new PPSEvent(eventType));
      }
      
      public function getProperty(object:String, attribute:String, value:Boolean = false) : void
      {
         var message:String = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"readPPS\",\"packet\":{\"getPPSValue\":{\"object\":\"" + object + "\",\"attribute\":\"" + attribute + "\", \"value\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"readPPS\",\"packet\":{\"getPPSValue\":{\"object\":\"" + object + "\",\"attribute\":\"" + attribute + "\", \"value\":false}}}";
         }
         this.client.send(message);
      }
      
      private function requestPPSValues() : void
      {
         this.getProperty("can/vehcfg","DEST");
      }
      
      private function onStartupInterval() : void
      {
         this.requestPPSValues();
      }
      
      public function getPPSBusy() : void
      {
         this.sendEvent(PPSEvent.PPS_BUSY);
      }
      
      public function get PPSBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function getNavigationMarketConfiguration() : void
      {
         this.sendEvent(PPSEvent.PPS_NAV_MARKET_CONFIG);
      }
      
      public function get navigationMarketConfiguration() : int
      {
         return this.mNavigationMarketConfiguration;
      }
      
      public function getHardwarePartNum() : void
      {
         this.getProperty("ame","ECUPartNo",true);
      }
      
      public function get HardwarePartNum() : String
      {
         return this.mECUPartNum;
      }
      
      public function ppsMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mReadPPSServiceAvailable == false)
            {
               this.mReadPPSServiceAvailable = true;
               this.requestPPSValues();
               this.mInterval = setInterval(this.onStartupInterval,STARTUP_RETRY_INTERVAL);
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mReadPPSServiceAvailable = false;
            }
         }
         else if(resp.hasOwnProperty("getPPSValue"))
         {
            if(resp.getPPSValue.hasOwnProperty("DEST"))
            {
               this.mNavigationMarketConfiguration = int(resp.getPPSValue.DEST);
               if(this.mNavigationMarketConfiguration != 0)
               {
                  clearInterval(this.mInterval);
                  this.sendEvent(PPSEvent.PPS_NAV_MARKET_CONFIG);
               }
            }
            if(resp.getPPSValue.hasOwnProperty("ECUPartNo"))
            {
               this.mECUPartNum = resp.getPPSValue.ECUPartNo;
               this.sendEvent(PPSEvent.PPS_ECU_PART_NUM);
            }
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

