package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DriverABEvent;
   import com.harman.moduleLinkAPI.IDriverAB;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DriverAB extends Module implements IDriverAB
   {
      
      private const mDbusDriverAB:String = "DriverAB";
      
      private var connection:Connection;
      
      private var span:Client;
      
      private var mDriverABServiceAvailable:Boolean = false;
      
      private var mReady:Boolean = false;
      
      private var mDriverAB:int = -1;
      
      public function DriverAB()
      {
         super();
         this.connection = Connection.share();
         this.span = this.connection.span;
         this.span.addEventListener(Event.CONNECT,this.connected);
         if(this.span.connected)
         {
            this.connected();
         }
         this.span.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.DRIVER_AB,this.DriverABHandler);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.span.connected) && this.mReady;
      }
      
      private function DriverABHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.mDriverABServiceAvailable == false)
            {
               this.mDriverABServiceAvailable = true;
               this.sendSubscribe(this.mDbusDriverAB,"driverType");
               this.sendSubscribe(this.mDbusDriverAB,"driverSettingsAB");
               this.sendGetPropertiesToId(this.mDbusDriverAB,"driverType");
            }
         }
         else if(message.hasOwnProperty("driverSettingsAB"))
         {
            if(this.mDriverAB != message.driverSettingsAB.driver)
            {
               if(message.driverSettingsAB.driverSetting == "save")
               {
                  this.dispatchEvent(new DriverABEvent(DriverABEvent.SAVE,this.mDriverAB));
               }
               else if(message.driverSettingsAB.driverSetting == "restore")
               {
                  this.mDriverAB = message.driverSettingsAB.driver;
                  this.dispatchEvent(new DriverABEvent(DriverABEvent.RECALL,this.mDriverAB));
               }
            }
         }
         else if(message.hasOwnProperty("getProperties"))
         {
            this.mDriverAB = message.getProperties.driverType;
         }
      }
      
      private function dispatchReady() : void
      {
         this.mReady = true;
         this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendDriverABAvailableRequest();
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function get driver() : int
      {
         return this.mDriverAB;
      }
      
      protected function sendGetPropertiesToId(id:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "props" + "\": [\"" + value + "\"]}}}";
         this.span.send(message);
      }
      
      private function sendSubscribe(busName:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + busName + "\", \"Signal\": \"" + signalName + "\"}";
         this.span.send(message);
      }
      
      private function sendDriverABAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.mDbusDriverAB + "\"}";
         this.span.send(message);
      }
   }
}

