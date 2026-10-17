package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IDABApp;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DABApp extends Module implements IDABApp
   {
      
      private static var instance:DABApp;
      
      private static const DABAPP_DBUS_ID:String = "DABApp";
      
      private static const ENABLE_ICS_TUNING:String = "requestEnableICSTuning";
      
      private static const DISABLE_ICS_TUNING:String = "requestDisableICSTuning";
      
      private var mConnection:Connection;
      
      private var mClient:Client;
      
      private var mDABAppAvailable:Boolean = false;
      
      public function DABApp()
      {
         super();
         this.mConnection = Connection.share();
         this.mClient = this.mConnection.span;
         this.mClient.addEventListener(Event.CONNECT,this.connected);
         this.mClient.addEventListener(Event.CLOSE,this.disconnected);
         this.mConnection.addEventListener(ConnectionEvent.DAB_TUNER_APP,this.messageHandler);
         if(this.mClient.connected)
         {
            this.connected();
         }
      }
      
      public static function getInstance() : DABApp
      {
         if(instance == null)
         {
            instance = new DABApp();
         }
         return instance;
      }
      
      public function connected(e:Event = null) : void
      {
         if(this.mConnection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.initialize();
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.mConnection.configured) && Boolean(this.mClient.connected);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mDABAppAvailable == false)
            {
               this.mDABAppAvailable = true;
               this.initialize();
            }
            else
            {
               this.mDABAppAvailable = false;
            }
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DABAPP_DBUS_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.mClient.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + DABAPP_DBUS_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.mClient.send(message);
      }
      
      private function sendMethod(methodName:String, keyName:String = null, value:* = null) : void
      {
         var message:String = null;
         if(value)
         {
            if(value is String)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + DABAPP_DBUS_ID + "\", \"packet\": { \"" + methodName + "\": { \"" + keyName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + DABAPP_DBUS_ID + "\", \"packet\": { \"" + methodName + "\": { \"" + keyName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + DABAPP_DBUS_ID + "\", \"packet\": { \"" + methodName + "\": {}}}";
         }
         this.mClient.send(message);
      }
      
      private function initialize() : void
      {
      }
      
      public function requestEnableICSTuning() : void
      {
         this.sendMethod(ENABLE_ICS_TUNING,null,null);
      }
      
      public function requestDisableICSTuning() : void
      {
         this.sendMethod(DISABLE_ICS_TUNING,null,null);
      }
   }
}

