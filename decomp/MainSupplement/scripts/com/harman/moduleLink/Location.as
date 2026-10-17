package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ILocation;
   import com.harman.moduleLinkAPI.LocationEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Location extends Module implements ILocation
   {
      
      private static const mDbusIdentifier:String = "Location";
      
      private var m_Ready:Boolean = false;
      
      private var mCompassHeading:int = 15;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function Location()
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
         this.connection.addEventListener(ConnectionEvent.LOCATION,this.messageHandler);
      }
      
      public function getCompassHeading() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [\"direction\"] }}}");
      }
      
      public function get compassHeading() : int
      {
         return this.mCompassHeading;
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var info:Object = e.data;
         if(info.hasOwnProperty("locationProperty"))
         {
            if(info.locationProperty.hasOwnProperty("direction"))
            {
               if(info.locationProperty.direction.hasOwnProperty("status"))
               {
                  if(String(info.locationProperty.direction.status).indexOf("error") != -1)
                  {
                     this.mCompassHeading == 15;
                  }
               }
               else
               {
                  this.mCompassHeading = int(info.locationProperty.direction);
               }
               this.dispatchEvent(new LocationEvent(LocationEvent.COMPASS_HEADING,e.data));
            }
         }
         else if(info.hasOwnProperty("getProperties"))
         {
            if(info.getProperties.hasOwnProperty("direction"))
            {
               if(info.getProperties.direction.hasOwnProperty("status"))
               {
                  if(String(info.getProperties.direction.status).indexOf("error") != -1)
                  {
                     this.mCompassHeading == 15;
                  }
               }
               else
               {
                  this.mCompassHeading = int(info.getProperties.direction);
               }
               this.dispatchEvent(new LocationEvent(LocationEvent.COMPASS_HEADING,e.data));
            }
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.subscribe("direction");
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
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"locationProperty\"}";
         this.client.send(message);
      }
   }
}

