package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DBusTraceMonitorEvent;
   import com.harman.moduleLinkAPI.IDBusTraceMonitor;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DBusTraceMonitor extends Module implements IDBusTraceMonitor
   {
      
      private static var instance:DBusTraceMonitor;
      
      public static const sENABLEALLSCOPES:String = "EnableAllScopes";
      
      public static const sDISABLEALLSCOPES:String = "DisableAllScopes";
      
      public static const sMIXEDSCOPES:String = "EnableMixedScopes";
      
      public static const sUNCHANGEDSCOPES:String = "UnchangedScopeSettings";
      
      private static const dbusIdentifier:String = "DBusTraceMonitor";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mBusy:Boolean = true;
      
      private var mConnected:Boolean = false;
      
      private var mScopes:Array = new Array();
      
      public function DBusTraceMonitor()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : DBusTraceMonitor
      {
         if(instance == null)
         {
            instance = new DBusTraceMonitor();
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
         this.connection.addEventListener(ConnectionEvent.DBUS_TRACE_MONITOR,this.dbusTraceMonitorMessageHandler);
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
               this.mConnected = true;
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.sendEvent(DBusTraceMonitorEvent.SCOPES_CHANGED);
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
         dispatchEvent(new DBusTraceMonitorEvent(eventType));
      }
      
      public function getCurrentScopes() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"DBusTraceMonitor\",\"packet\":{\"getCurrentScopes\":{}}}");
      }
      
      public function setCurrentScopes1(bag:Object) : void
      {
         var send:Boolean = true;
         var message:Object = {
            "Type":"Command",
            "Dest":"DBusTraceMonitor",
            "packet":{"setCurrentScopes":{"action":bag.action}}
         };
         switch(bag.action)
         {
            case this.ENABLE_MIXED_SCOPES:
               message.packet.setCurrentScopes["scopes"] = bag.scopes;
               break;
            case this.ENABLE_ALL_SCOPES:
            case this.DISABLE_ALL_SCOPES:
               message.packet.setCurrentScopes["scopes"] = [];
               break;
            case this.UNCHANGED_SCOPES:
            default:
               send = false;
         }
         if(send)
         {
            this.connection.send(message);
         }
      }
      
      public function setCurrentScopes(bag:Object) : void
      {
         var message:String = null;
         var i:int = 0;
         var send:Boolean = true;
         message = "{\"Type\":\"Command\", \"Dest\":\"DBusTraceMonitor\", \"packet\": {\"setCurrentScopes\":{\"action\":\"" + bag.action + "\",\"scopes\":[";
         switch(bag.action)
         {
            case this.ENABLE_MIXED_SCOPES:
               for(i = 0; i < bag.scopes.length; i++)
               {
                  message += "{\"enabled\":\"" + bag.scopes[i].enabled + "\",\"name\":\"" + bag.scopes[i].name + "\"}";
                  if(i < bag.scopes.length - 1)
                  {
                     message += ",";
                  }
               }
               break;
            case this.ENABLE_ALL_SCOPES:
            case this.DISABLE_ALL_SCOPES:
               break;
            case this.UNCHANGED_SCOPES:
            default:
               send = false;
         }
         if(send)
         {
            message += "]}}}";
            this.client.send(message);
         }
      }
      
      public function get CurrentScopes() : Array
      {
         return this.mScopes;
      }
      
      public function get UNCHANGED_SCOPES() : String
      {
         return sUNCHANGEDSCOPES;
      }
      
      public function get ENABLE_MIXED_SCOPES() : String
      {
         return sMIXEDSCOPES;
      }
      
      public function get ENABLE_ALL_SCOPES() : String
      {
         return sENABLEALLSCOPES;
      }
      
      public function get DISABLE_ALL_SCOPES() : String
      {
         return sDISABLEALLSCOPES;
      }
      
      public function dbusTraceMonitorMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("getCurrentScopes"))
         {
            if(resp.getCurrentScopes.hasOwnProperty("scopes"))
            {
               this.mScopes = resp.getCurrentScopes.scopes;
               this.sendEvent(DBusTraceMonitorEvent.SCOPES_RECEIVED);
            }
         }
      }
   }
}

