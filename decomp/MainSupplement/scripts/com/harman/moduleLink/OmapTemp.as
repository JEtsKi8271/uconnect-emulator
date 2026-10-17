package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IOmapTemp;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class OmapTemp extends Module implements IOmapTemp
   {
      
      private static var instance:OmapTemp;
      
      private static const mDbusIdentifier:String = "OmapTemp";
      
      private var mOmapTemp:String;
      
      private var m_Ready:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function OmapTemp()
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
         this.connection.addEventListener(ConnectionEvent.OMAP_TEMP,this.MessageHandler);
      }
      
      public static function getInstance() : OmapTemp
      {
         if(instance == null)
         {
            instance = new OmapTemp();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         else
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var info:Object = e.data;
         if(info.hasOwnProperty("getOmapTemperature"))
         {
            this.mOmapTemp = info.getOmapTemperature.omapTemp;
         }
      }
      
      public function getOmapTemp() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getOmapTemperature\":{}}}");
      }
      
      public function get omapTemp() : String
      {
         return this.mOmapTemp;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
   }
}

