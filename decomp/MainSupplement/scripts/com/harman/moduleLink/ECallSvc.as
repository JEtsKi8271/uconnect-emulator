package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ECallSvcEvent;
   import com.harman.moduleLinkAPI.IECallSvc;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class ECallSvc extends Module implements IECallSvc
   {
      
      private static var instance:ECallSvc;
      
      private static const dbusIdentifier:String = "ECallSvc";
      
      private var connection:Connection;
      
      private var mStatus:Boolean = false;
      
      private var name:String = "ECallSvc";
      
      public var mProgress:int = 0;
      
      private var client:Client;
      
      private var curEcallState:Object;
      
      public function ECallSvc()
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
         this.connection.addEventListener(ConnectionEvent.ECALLSVC,this.ecallSvcMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : ECallSvc
      {
         if(instance == null)
         {
            instance = new ECallSvc();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.subscribe("ecall");
               this.subscribe("ecallProgress");
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
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function ecallSvcMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("ecall"))
         {
            this.curEcallState = e.data.ecall;
            this.dispatchEvent(new ECallSvcEvent(ECallSvcEvent.ECALL_EVENT,e.data.ecall));
         }
         else if(resp.hasOwnProperty("ecallProgress"))
         {
            this.mProgress = e.data.ecallProgress.progress;
         }
      }
      
      public function startECall() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startEcall\": {}}}";
         this.client.send(message);
      }
      
      public function exitECall() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"exitEcall\": {}}}";
         this.client.send(message);
      }
      
      public function setECallRetryState(retrystate:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setEcallRetryHmiState\": {\"state\":" + retrystate + "}}}";
         this.client.send(message);
      }
      
      public function logMessageToEcallLog(logMsg:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"logStringToEcallLog\": {\"message\":\"" + logMsg + "\"}}}";
         this.client.send(message);
      }
      
      public function moveLogToUSB() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"saveEmergencyLogToUSBAndRemoveLocalLog\": {}}}";
         this.client.send(message);
      }
      
      public function setLEDStatus(LEDStatus:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setLEDStatus\": {\"status\":" + LEDStatus + "}}}";
         this.client.send(message);
      }
      
      public function get CurrentECallState() : Object
      {
         return this.curEcallState;
      }
      
      public function get progress() : int
      {
         return this.mProgress;
      }
      
      public function get status() : Boolean
      {
         return this.mStatus;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signalName + "\"}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
      }
   }
}

