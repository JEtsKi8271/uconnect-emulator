package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.CameraEvent;
   import com.harman.moduleLinkAPI.ICameraUpdate;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class CameraUpdate extends Module implements ICameraUpdate
   {
      
      private static var instance:CameraUpdate;
      
      private static const mDbusIdentifier:String = "Camera";
      
      private var m_Ready:Boolean = false;
      
      private var m_gearStatus:String;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function CameraUpdate()
      {
         super();
         this.m_gearStatus == "";
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.CAMERA_UPDATE,this.MessageHandler);
      }
      
      public static function getInstance() : CameraUpdate
      {
         if(instance == null)
         {
            instance = new CameraUpdate();
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
               this.subscribe("prndstatus");
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
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var info:Object = e.data;
         if(info.hasOwnProperty("prndstatus"))
         {
            this.m_gearStatus = info.prndstatus.prndstatus;
            if(this.m_gearStatus == "1")
            {
               this.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_UPDATE));
            }
            else
            {
               this.dispatchEvent(new CameraEvent(CameraEvent.PRND_CANCEL));
            }
         }
      }
      
      public function getgearStatus() : String
      {
         return this.m_gearStatus;
      }
      
      public function requestStartUpStatus() : void
      {
         this.sendCommand("getStartUpStatus");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
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
      
      protected function sendCommand(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
   }
}

