package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ISoftwareUpdate;
   import com.harman.moduleLinkAPI.SoftwareUpdateEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class SoftwareUpdate extends Module implements ISoftwareUpdate
   {
      
      private static var instance:SoftwareUpdate;
      
      private static const mDbusIdentifier:String = "SoftwareUpdate";
      
      private var m_Ready:Boolean = false;
      
      private var m_currentVersion:String;
      
      private var m_newVersion:String;
      
      private var m_moduleType:String;
      
      private var m_moduleName:String;
      
      private var m_unitName:String;
      
      private var m_swUpdateState:String;
      
      private var m_errorMsg:String = "";
      
      private var m_unitNumber:Number;
      
      private var m_unitPercentComplete:Number;
      
      private var m_totalUnitCount:Number;
      
      private var m_totalPercentComplete:Number;
      
      private var m_estTime:String;
      
      private var m_attemptNumber:Number;
      
      private var m_totalAttemptCount:Number;
      
      private var m_errorCode:String;
      
      private var m_bootDone:Boolean = false;
      
      private var m_SoftwareUpdateDatabase:SoftwareUpdateDatabase;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function SoftwareUpdate()
      {
         super();
         this.m_SoftwareUpdateDatabase = new SoftwareUpdateDatabase(this);
         this.m_totalPercentComplete = 0;
         this.m_totalAttemptCount = 0;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.SOFTWARE_UPDATE,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.SOFTWARE_INSTALLER,this.m_SoftwareUpdateDatabase.messageHandler);
      }
      
      public static function getInstance() : SoftwareUpdate
      {
         if(instance == null)
         {
            instance = new SoftwareUpdate();
         }
         return instance;
      }
      
      public function get spanClient() : Client
      {
         return this.client;
      }
      
      public function get unitNumber() : Number
      {
         return this.m_unitNumber;
      }
      
      public function get unitPercentComplete() : Number
      {
         return this.m_unitPercentComplete;
      }
      
      public function get totalUnitCount() : Number
      {
         return this.m_totalUnitCount;
      }
      
      public function get totalPercentComplete() : Number
      {
         return this.m_totalPercentComplete;
      }
      
      public function get newSoftwareVersion() : String
      {
         return this.m_newVersion;
      }
      
      public function get currentSoftwareVersion() : String
      {
         return this.m_currentVersion;
      }
      
      public function get moduleType() : String
      {
         return this.m_moduleType;
      }
      
      public function get moduleName() : String
      {
         return this.m_moduleName;
      }
      
      public function get unitName() : String
      {
         return this.m_unitName;
      }
      
      public function get swUpdateState() : String
      {
         return this.m_swUpdateState;
      }
      
      public function get errorMessage() : String
      {
         return this.m_errorMsg;
      }
      
      public function get estimatedTime() : String
      {
         return this.m_estTime;
      }
      
      public function get attemptNumber() : Number
      {
         return this.m_attemptNumber;
      }
      
      public function get totalAttemptCount() : Number
      {
         return this.m_totalAttemptCount;
      }
      
      public function get errorCode() : String
      {
         return this.m_errorCode;
      }
      
      public function get bootDone() : Boolean
      {
         return this.m_bootDone;
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var resp:Object = e.data;
         try
         {
            for(property in resp)
            {
               this["store" + property] = resp[property];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function set storestatus(temp:Object) : void
      {
         if(temp.hasOwnProperty("state"))
         {
            if(temp.state is Number)
            {
               this.m_swUpdateState = String(temp.state);
            }
            else
            {
               this.m_swUpdateState = temp.state;
            }
         }
         if(temp.hasOwnProperty("fromVersion"))
         {
            this.m_currentVersion = temp.fromVersion;
         }
         if(temp.hasOwnProperty("toVersion"))
         {
            this.m_newVersion = temp.toVersion;
         }
         if(temp.hasOwnProperty("moduleType"))
         {
            this.m_moduleType = temp.moduleType;
         }
         if(temp.hasOwnProperty("moduleName"))
         {
            this.m_moduleName = temp.moduleName;
         }
         if(temp.hasOwnProperty("errorMsg"))
         {
            this.m_errorMsg = temp.errorMsg;
         }
         if(temp.hasOwnProperty("swdlEstTime"))
         {
            this.m_estTime = temp.swdlEstTime;
         }
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_STATUS));
      }
      
      private function set storebeginUpdate(temp:Object) : void
      {
         this.m_swUpdateState = temp.state;
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_STATUS));
      }
      
      private function set storecancelUpdate(temp:Object) : void
      {
         this.m_swUpdateState = temp.state;
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_STATUS));
      }
      
      private function set storeprogress(temp:Object) : void
      {
         if(temp.hasOwnProperty("unitName"))
         {
            this.m_unitName = temp.unitName;
         }
         if(temp.hasOwnProperty("unitNumber"))
         {
            this.m_unitNumber = temp.unitNumber;
         }
         if(temp.hasOwnProperty("unitPercentComplete"))
         {
            this.m_unitPercentComplete = temp.unitPercentComplete;
         }
         if(temp.hasOwnProperty("totalUnitCount"))
         {
            this.m_totalUnitCount = temp.totalUnitCount;
         }
         if(temp.hasOwnProperty("totalPercentComplete"))
         {
            this.m_totalPercentComplete = temp.totalPercentComplete;
         }
         if(temp.hasOwnProperty("attemptNumber"))
         {
            this.m_attemptNumber = temp.attemptNumber;
         }
         if(temp.hasOwnProperty("totalAttemptCount"))
         {
            this.m_totalAttemptCount = temp.totalAttemptCount;
         }
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_PROGRESS));
      }
      
      private function set storeerror(temp:Object) : void
      {
         if(temp.hasOwnProperty("errorCode"))
         {
            this.m_errorCode = temp.errorCode;
         }
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_ERROR));
      }
      
      private function set storeboot_done(temp:Object) : void
      {
         this.m_bootDone = true;
         this.dispatchEvent(new SoftwareUpdateEvent(SoftwareUpdateEvent.SW_UPDATE_BOOT_DONE));
      }
      
      private function set storetotalPercentComplete(temp:Object) : void
      {
         if(temp.hasOwnProperty("totalPercentComplete"))
         {
            this.m_totalPercentComplete = Number(temp.totalPercentComplete);
         }
      }
      
      private function set store(temp:Object) : void
      {
         if(temp.hasOwnProperty("currentVersion"))
         {
            this.m_currentVersion = String(temp.currentVersion);
         }
      }
      
      private function set storenewVersion(temp:Object) : void
      {
         if(temp.hasOwnProperty("newVersion"))
         {
            this.m_newVersion = String(temp.newVersion);
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.subscribe("status");
            this.subscribe("progress");
            this.subscribe("error");
            this.subscribe("boot_done");
            this.m_SoftwareUpdateDatabase.subscribeHandler();
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
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
      
      public function setButtonPressInfo(btnPress:Boolean, source:String = null) : void
      {
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object) : void
      {
         var message:String = null;
         if(value is String)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      public function getStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getStatus\": {}}}");
      }
      
      public function beginUpdate() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"beginUpdate\": {}}}");
      }
      
      public function cancelUpdate() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"cancelUpdate\": {}}}");
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function get updateDBState() : Object
      {
         return this.m_SoftwareUpdateDatabase.updateState;
      }
      
      public function sendDBUpdateActivationCode(code:String) : void
      {
         this.m_SoftwareUpdateDatabase.sendActivationCode(code);
      }
      
      public function sendDBUpdateActivationCodeReset() : void
      {
         this.m_SoftwareUpdateDatabase.sendDBUpdateActivationCodeReset();
      }
      
      public function get updateDBActivationCodeAcceptanceState() : int
      {
         return this.m_SoftwareUpdateDatabase.updateDBActivationCodeAcceptanceState;
      }
      
      public function sendDBUpdateStartUpdate() : void
      {
         this.m_SoftwareUpdateDatabase.sendDBUpdateStartUpdate();
      }
      
      public function sendDBUpdateDeclineUpdate() : void
      {
         this.m_SoftwareUpdateDatabase.sendDBUpdateDeclineUpdate();
      }
      
      public function sendDBUpdateReset() : void
      {
         this.m_SoftwareUpdateDatabase.sendDBUpdateReset();
      }
   }
}

