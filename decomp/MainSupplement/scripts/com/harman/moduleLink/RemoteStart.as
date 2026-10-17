package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IRemoteStart;
   import com.harman.moduleLinkAPI.RemoteStartEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class RemoteStart extends Module implements IRemoteStart
   {
      
      private static var instance:RemoteStart;
      
      private static const mDbusIdentifier:String = "RemoteStart";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiSetProperties:String = "setProperties";
      
      private static const dBusRemoteStartActive:String = "remoteStartActive";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mReady:Boolean = false;
      
      private var mProperties:Dictionary = new Dictionary();
      
      private var mServiceAvailable:Boolean;
      
      public function RemoteStart()
      {
         super();
         this.setUpPropertiesTable();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.onConnected);
         if(this.client.connected)
         {
            this.onConnected();
         }
         this.connection.addEventListener(ConnectionEvent.REMOTESTART,this.onMessageHandler);
      }
      
      public static function getInstance() : RemoteStart
      {
         if(instance == null)
         {
            instance = new RemoteStart();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      public function get remoteStartActive() : Boolean
      {
         return this.mProperties[dBusRemoteStartActive].value;
      }
      
      public function requestRemoteStartActive() : void
      {
         this.sendGetProperties(["remoteStartStatus"]);
      }
      
      private function onConnected(event:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendMultiSubscribe(this.mProperties);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function onMessageHandler(event:ConnectionEvent) : void
      {
         var obj:Object = null;
         var resp:Object = event.data;
         if(resp.hasOwnProperty(dBusApiGetProperties))
         {
            if(Boolean(resp[dBusApiGetProperties].hasOwnProperty("status")) && resp[dBusApiGetProperties].status == "error 0x90000005")
            {
               trace("[ ERROR ] *<HMIModule> RemoteStart.onMessageHandler \'" + dBusApiGetProperties + "\' not recognized! status: error 0x90000005");
               return;
            }
            this.processProperties({"remoteStartActive":resp[dBusApiGetProperties]});
         }
         else
         {
            for(obj in resp)
            {
               this.processProperties(resp[obj]);
            }
         }
      }
      
      private function setUpPropertiesTable() : void
      {
         this.mProperties[dBusRemoteStartActive] = {
            "value":null,
            "convert":this.convertIntToBoolean,
            "event":RemoteStartEvent.REMOTE_START_ACTIVE
         };
      }
      
      private function processProperties(message:Object) : void
      {
         var Signal:Object = null;
         try
         {
            for(Signal in message)
            {
               if(this.mProperties[Signal] != null)
               {
                  if(this.mProperties[Signal].convert == null)
                  {
                     this.mProperties[Signal].value = message[Signal];
                  }
                  else
                  {
                     this.mProperties[Signal].value = this.mProperties[Signal].convert(message[Signal]);
                  }
               }
               if(this.mProperties[Signal].event != null)
               {
                  this.dispatchEvent(new RemoteStartEvent(this.mProperties[Signal].event));
               }
            }
         }
         catch(e:Error)
         {
            trace("[ ERROR ] *<HMIModule> DriveMode.processProperties \'" + message + "\' not recognized!");
         }
      }
      
      private function convertIntToBoolean(val:int) : Boolean
      {
         if(val == 1)
         {
            return true;
         }
         return false;
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mDbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Dictionary) : void
      {
         var message:String = null;
         var i:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signals\": [";
         for(i in signalsArray)
         {
            message = message + "\"" + i + "\"";
            message += ",";
         }
         message = message.substr(0,message.length - 1);
         message += "]}";
         this.client.send(message);
      }
      
      private function sendGetProperties(props:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"getProperties\": {\"props\": ["; i < props.length; )
         {
            message = message + "\"" + props[i] + "\"";
            if(props[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}}}";
         this.client.send(message);
      }
   }
}

