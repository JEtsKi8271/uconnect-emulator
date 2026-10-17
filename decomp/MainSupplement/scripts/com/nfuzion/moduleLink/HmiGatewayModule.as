package com.nfuzion.moduleLink
{
   import com.adobe.serialization.json.JSONEncoder;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class HmiGatewayModule extends Module
   {
      
      protected var mClient:Client;
      
      protected var mConnection:Connection;
      
      private var mDbusId:String;
      
      public function HmiGatewayModule(dbusId:String)
      {
         super();
         this.mDbusId = dbusId;
         this.mConnection = Connection.share();
         this.mClient = this.mConnection.span;
         this.mClient.addEventListener(Event.CONNECT,this.connected);
         if(this.mClient.connected)
         {
            this.connected();
         }
         this.mClient.addEventListener(Event.CLOSE,this.disconnected);
         this.mConnection.addEventListener(this.mDbusId,this.messageHandler);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.mConnection.configured) && Boolean(this.mClient.connected);
      }
      
      protected function get dbusId() : String
      {
         return this.mDbusId;
      }
      
      protected function connected(e:Event = null) : void
      {
         if(this.isReady())
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.init();
         }
      }
      
      protected function init() : void
      {
      }
      
      protected function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      protected function messageHandler(e:ConnectionEvent) : void
      {
      }
      
      protected function sendCommand(object:*) : void
      {
         var encoder:JSONEncoder = new JSONEncoder(object);
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + this.mDbusId + "\", \"packet\":" + encoder.getString() + "}";
         this.mClient.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         this.mClient.send("{\"Type\":\"Subscribe\", \"Dest\":\"" + this.mDbusId + "\", \"Signal\": \"" + signalName + "\"}");
      }
      
      protected function sendUnsubscribe(signalName:String) : void
      {
         this.mClient.send("{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.mDbusId + "\", \"Signal\": \"" + signalName + "\"}");
      }
   }
}

