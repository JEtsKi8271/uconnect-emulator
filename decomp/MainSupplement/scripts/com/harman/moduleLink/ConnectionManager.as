package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ConnectionManagerEvent;
   import com.harman.moduleLinkAPI.IConnectionManager;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class ConnectionManager extends Module implements IConnectionManager
   {
      
      private static var instance:ConnectionManager;
      
      private static const dbusIdentifier:String = "ConnectionManager";
      
      private var connection:Connection;
      
      private var name:String = "connMgrHMIClient";
      
      private var client:Client;
      
      private var curConnection:String;
      
      public function ConnectionManager()
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
         this.connection.addEventListener(ConnectionEvent.CONNECTION_MANAGER,this.ConnMgrMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.curConnection = "";
      }
      
      public static function getInstance() : ConnectionManager
      {
         if(instance == null)
         {
            instance = new ConnectionManager();
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
               this.subscribe("internetConnected");
               this.subscribe("internetDisconnected");
               this.subscribe("ipConflict");
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
      
      public function ConnMgrMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("connectInternet"))
         {
            if(resp.connectInternet.errorCode != null)
            {
            }
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.CONNECT_INTERNET,resp.connectInternet));
         }
         else if(resp.hasOwnProperty("switchEmbeddedPhoneUsage"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.SWITCH_USAGE,resp.switchEmbeddedPhoneUsage));
         }
         else if(resp.hasOwnProperty("disconnectInternet"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.DISCONNECT_INTERNET,resp.disconnectInternet));
         }
         else if(resp.hasOwnProperty("disconnectInternetImmediately"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.DISCONNECT_INTERNET_IMMEDIATELY,resp.disconnectInternetImmediately));
         }
         else if(resp.hasOwnProperty("internetConnected"))
         {
            this.curConnection = e.data.internetConnected.connectionMethod;
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.INTERNET_CONNECTED,resp.internetConnected));
         }
         else if(resp.hasOwnProperty("internetDisconnected"))
         {
            this.curConnection = "";
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.INTERNET_DISCONNECTED,resp.internetDisconnected));
         }
         else if(resp.hasOwnProperty("internetConnectError"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.INTERNET_CONNECT_ERROR));
         }
         else if(resp.hasOwnProperty("setAccessPoint"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.SET_ACCESS_POINT,resp.setAccessPoint));
         }
         else if(resp.hasOwnProperty("getAccessPoint"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.GET_ACCESS_POINT,resp.getAccessPoint.accessPoint));
         }
         else if(resp.hasOwnProperty("getInternetPrecedence"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.PRECEDENCE_LIST,resp.getInternetPrecedence));
         }
         else if(resp.hasOwnProperty("ipConflict"))
         {
            this.dispatchEvent(new ConnectionManagerEvent(ConnectionManagerEvent.IP_ADDRESS_CONFLICT,resp.ipConflict));
         }
      }
      
      public function connectInternet(connMethod:String, address:String, uuid:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"connectInternet\":{";
         if(connMethod.length > 0)
         {
            message += "\"connectionMethod\"" + ":\"" + connMethod + "\"";
         }
         if(uuid.length > 0)
         {
            message += ", \"uuid\"" + ":\"" + uuid + "\"";
         }
         if(address.length > 0)
         {
            message += ", \"address\"" + ":\"" + address + "\"";
         }
         message += "}}}";
         this.client.send(message);
      }
      
      public function disconnectInternet(connMethod:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"disconnectInternet\":{\"connectionMethod\":\"" + connMethod + "\"}}}";
         this.client.send(message);
      }
      
      public function disconnectInternetImmediately(connMethod:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"disconnectInternetImmediately\":{\"connectionMethod\":\"" + connMethod + "\"}}}";
         this.client.send(message);
      }
      
      public function setAccessPoint(d:Object) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": {\"setAccessPoint\": {";
         message += "\"address\":\"" + d.address + "\", ";
         message += "\"accessPoint\": {";
         message += "\"provider\":\"" + d.provider + "\", ";
         message += "\"APN\":\"" + d.APN + "\", ";
         message += "\"username\":\"" + d.username + "\", ";
         message += "\"password\":\"" + d.password + "\"";
         message += "}}}}";
         this.client.send(message);
      }
      
      public function getAccessPoint(address:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": {\"getAccessPoint\": {";
         message += "\"address\":\"" + address + "\"";
         message += "}}}";
         this.client.send(message);
      }
      
      public function setPrecedence(precedencelist:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setInternetPrecedence\": { \"precedenceList\":" + precedencelist + "}}}";
         this.client.send(message);
      }
      
      public function switchEmbeddedPhoneUsage(usage:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"switchEmbeddedPhoneUsage\": { \"usage\":\"" + usage + "\"}}}";
         this.client.send(message);
      }
      
      public function getCurConnectionMethod() : String
      {
         return this.curConnection;
      }
      
      public function getPrecedenceList() : void
      {
         this.sendCommand("getInternetPrecedence","","");
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
         if(signalName != "internetConnected" && signalName != "internetDisconnected")
         {
            message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
            this.client.send(message);
            return;
         }
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

