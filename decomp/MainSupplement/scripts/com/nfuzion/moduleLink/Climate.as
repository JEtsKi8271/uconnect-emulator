package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ClimateEvent;
   import com.nfuzion.moduleLinkAPI.IClimate;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Climate extends Module implements IClimate
   {
      
      private static var instance:Climate;
      
      private static const mDbusIdentifier:String = "Climate";
      
      private static const mDBusApiGetProperties:String = "getProperties";
      
      private static const mDBusApiGetInternalTemp:String = "getInternalTemp";
      
      private const mDbusOutsideTemp:String = "outsideTemp";
      
      private const mDbusInsideTemp:String = "insideTemp";
      
      private var m_Ready:Boolean = false;
      
      private var m_outsideTemp:String;
      
      private var m_insideTemp:String;
      
      private var m_driverTemp:Number;
      
      private var m_passengerTemp:Number;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mClimateServiceAvailable:Boolean = false;
      
      public function Climate()
      {
         super();
         this.m_outsideTemp = "0";
         this.m_insideTemp = "0";
         this.m_driverTemp = 0;
         this.m_passengerTemp = 0;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.CLIMATE,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : Climate
      {
         if(instance == null)
         {
            instance = new Climate();
         }
         return instance;
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function getValue(valueName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      public function getOutsideTemp() : void
      {
         this.getValue(this.mDbusOutsideTemp);
      }
      
      public function getInsideTemp() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getInternalTemp\":{}}}";
         this.client.send(this.messageHandler);
      }
      
      public function get outsideTemp() : String
      {
         return this.m_outsideTemp;
      }
      
      public function get insideTemp() : String
      {
         return this.m_insideTemp;
      }
      
      public function get driverTemp() : Number
      {
         return this.m_driverTemp;
      }
      
      public function get passengerTemp() : Number
      {
         return this.m_passengerTemp;
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.mClimateServiceAvailable == false)
            {
               this.mClimateServiceAvailable = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\": {\" props\":[\"" + this.mDbusOutsideTemp + "\"] }}} ");
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getInternalTemp\":{}}}");
            }
            else if(message.dBusServiceAvailable == "false")
            {
               this.mClimateServiceAvailable = false;
            }
         }
         if(message.hasOwnProperty(mDBusApiGetInternalTemp))
         {
            this.setInsideTemp(message.getInternalTemp.insideTemp);
         }
         if(message.hasOwnProperty(mDBusApiGetProperties))
         {
            this.handlePropertyMessage(message.getProperties);
         }
         if(message.hasOwnProperty(this.mDbusOutsideTemp))
         {
            this.setOutsideTemp(message.outsideTemp.outsideTemp);
         }
         if(message.hasOwnProperty(this.mDbusInsideTemp))
         {
            this.setInsideTemp(message.insideTemp.insideTemp);
         }
         try
         {
            for(property in message)
            {
               this["store" + property] = message[property];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function handlePropertyMessage(msg:Object) : void
      {
         if(msg.hasOwnProperty(this.mDbusOutsideTemp))
         {
            this.setOutsideTemp(msg.outsideTemp);
         }
      }
      
      private function set storegetProperties(o:Object) : void
      {
         var property:String = null;
         try
         {
            for(property in o)
            {
               this["store" + property] = o[property];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function set storedriverTemp(temp:Object) : void
      {
         if(temp.hasOwnProperty("driverTemp"))
         {
            this.m_driverTemp = Number(temp.driverTemp);
            this.dispatchEvent(new ClimateEvent(ClimateEvent.DRIVER_TEMP,this.m_driverTemp));
         }
      }
      
      private function set storeoutsideTemp(temp:Object) : void
      {
         if(temp.hasOwnProperty("outsideTemp"))
         {
            this.setOutsideTemp(temp.outsideTemp);
         }
      }
      
      private function setOutsideTemp(tempature:Object) : void
      {
         if(tempature == "--" || tempature == "SNA")
         {
            this.m_outsideTemp = String(tempature);
         }
         else
         {
            this.m_outsideTemp = Math.round(Number(tempature)).toString() + String.fromCharCode(176);
         }
         this.dispatchEvent(new ClimateEvent(ClimateEvent.OUTSIDE_TEMP,this.m_outsideTemp));
      }
      
      private function setInsideTemp(tempature:Object) : void
      {
         if(tempature == "--" || tempature == "SNA")
         {
            this.m_insideTemp = String(tempature);
         }
         else
         {
            this.m_insideTemp = Math.round(Number(tempature)).toString() + String.fromCharCode(176);
         }
         this.dispatchEvent(new ClimateEvent(ClimateEvent.INSIDE_TEMP,this.m_insideTemp));
      }
      
      private function set storepassengerTemp(temp:Object) : void
      {
         if(temp.hasOwnProperty("passengerTemp"))
         {
            this.m_passengerTemp = Number(temp.passengerTemp);
            this.dispatchEvent(new ClimateEvent(ClimateEvent.PASSENGER_TEMP,this.m_passengerTemp));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.sendSubscribe(this.mDbusOutsideTemp);
            this.sendSubscribe(this.mDbusInsideTemp);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mDbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

