package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IPerformanceInfo;
   import com.harman.moduleLinkAPI.PerformanceInfoEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class PerformanceInfo extends Module implements IPerformanceInfo
   {
      
      private static var instance:PerformanceInfo;
      
      private static const mDbusIdentifier:String = "PerformanceInfo";
      
      private var m_Ready:Boolean = false;
      
      private var m_freeMemory:String;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function PerformanceInfo()
      {
         super();
         this.m_freeMemory = "";
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.PERFORMANCE_INFO,this.messageHandler);
      }
      
      public static function getInstance() : PerformanceInfo
      {
         if(instance == null)
         {
            instance = new PerformanceInfo();
         }
         return instance;
      }
      
      public function get freeMemory() : String
      {
         return this.m_freeMemory;
      }
      
      public function getPerformanceInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getPerformanceInfo\": {}}}");
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var tmp:Object = null;
         var info:Object = e.data;
         tmp = null;
         if(info.hasOwnProperty("getPerformanceInfo"))
         {
            tmp = info.getPerformanceInfo;
            if(tmp != null)
            {
               try
               {
                  this.m_freeMemory = tmp.freememory;
                  this.dispatchEvent(new PerformanceInfoEvent(PerformanceInfoEvent.PERFORMANCE_INFO));
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
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
   }
}

