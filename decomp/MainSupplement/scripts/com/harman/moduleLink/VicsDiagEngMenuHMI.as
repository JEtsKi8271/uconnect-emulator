package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVicsDiagEngMenuHMI;
   import com.harman.moduleLinkAPI.VicsDiagEngMenuHMIEvent;
   import com.harman.moduleLinkAPI.vicsDiagEngMenuID;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VicsDiagEngMenuHMI extends Module implements IVicsDiagEngMenuHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnDiagEngMenu.JpnDiagEngMenu";
      
      private static const JRC_DEVICE_LOG_SAVE:String = "requestJrcDeviceLogSave";
      
      private static const ACCESSING_SD_CARD:String = "AccessingSDCard";
      
      private static const STATUS_VICS_BEACON:String = "StatusVicsBeacon";
      
      private static const STATUS_ETCDSRC:String = "StatusEtcDsrc";
      
      private static const STATUS_VICS_TUNER:String = "StatusVicsTuner";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mAccessingSDCard:Boolean = false;
      
      private var mStatus:vicsDiagEngMenuID = new vicsDiagEngMenuID();
      
      public function VicsDiagEngMenuHMI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VICSDIAGENGMENUHMI,this.DiagEngMenuHMIMessageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         if(this.client.connected)
         {
            this.sendAttributeSubscribes();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAttributeSubscribes();
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
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.subscribe(STATUS_ETCDSRC);
      }
      
      private function requestAttributesInitialValue() : void
      {
         this.requestStatusVicsBeacon();
         this.requestStatusEtcDsrc();
         this.requestStatusVicsTuner();
      }
      
      private function requestStatusVicsBeacon() : void
      {
         this.sendCommandSimple(STATUS_VICS_BEACON);
      }
      
      private function requestStatusEtcDsrc() : void
      {
         this.sendCommandSimple(STATUS_ETCDSRC);
      }
      
      private function requestStatusVicsTuner() : void
      {
         this.sendCommandSimple(STATUS_VICS_TUNER);
      }
      
      public function requestJrcDeviceLogSave() : void
      {
         this.sendCommandSimple(JRC_DEVICE_LOG_SAVE);
      }
      
      private function DiagEngMenuHMIMessageHandler(e:ConnectionEvent) : void
      {
         var DiagEngMenuData:Object = e.data;
         if(!DiagEngMenuData.hasOwnProperty(ACCESSING_SD_CARD))
         {
            if(!DiagEngMenuData.hasOwnProperty(STATUS_VICS_BEACON))
            {
               if(DiagEngMenuData.hasOwnProperty(STATUS_ETCDSRC))
               {
                  this.mStatus = this.mStatus.copyStatusEtcDsrc(DiagEngMenuData.StatusEtcDsrc[1]);
                  this.dispatchEvent(new VicsDiagEngMenuHMIEvent(VicsDiagEngMenuHMIEvent.STATUS_ETCDSRC,e.data));
               }
               else if(DiagEngMenuData.hasOwnProperty(STATUS_VICS_TUNER))
               {
               }
            }
         }
      }
      
      public function get AccessingSDCard() : Boolean
      {
         return this.mAccessingSDCard;
      }
      
      public function get DeviceStatus() : vicsDiagEngMenuID
      {
         return this.mStatus;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendAttrRequest(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendCommandSimple(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

