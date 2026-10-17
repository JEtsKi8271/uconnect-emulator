package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ISierraUpdate;
   import com.harman.moduleLinkAPI.SierraUpdateEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class SierraUpdate extends Module implements ISierraUpdate
   {
      
      private static var instance:SierraUpdate;
      
      private static const mDbusIdentifier:String = "SierraUpdate";
      
      private var m_progress:Number = 0;
      
      private var m_status:String;
      
      private var m_errormsg:String;
      
      private var m_Ready:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function SierraUpdate()
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
         this.connection.addEventListener(ConnectionEvent.SIERRA_UPDATE,this.MessageHandler);
      }
      
      public static function getInstance() : SierraUpdate
      {
         if(instance == null)
         {
            instance = new SierraUpdate();
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
               this.subscribe("status");
               this.subscribe("progress");
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
         var SierraUpdate:Object = e.data;
         if(SierraUpdate.hasOwnProperty("progress"))
         {
            this.m_progress = SierraUpdate.progress.unitPercentComplete;
            this.dispatchEvent(new SierraUpdateEvent(SierraUpdateEvent.SIERRA_PERCENT_UPDATE));
         }
         if(SierraUpdate.hasOwnProperty("status"))
         {
            this.m_status = SierraUpdate.status.state;
            this.m_errormsg = SierraUpdate.status.errorMsg;
            this.dispatchEvent(new SierraUpdateEvent(SierraUpdateEvent.SIERRA_STATUS_UPDATE));
         }
      }
      
      public function sierraupdatemode(UPDATEMODE:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"setSierraUpdateMode\": { \"updatemode\": \"" + UPDATEMODE + "\"}}}");
      }
      
      public function get errorMsg() : String
      {
         return this.m_errormsg;
      }
      
      public function get progress() : Number
      {
         return this.m_progress;
      }
      
      public function get status() : String
      {
         return this.m_status;
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
   }
}

