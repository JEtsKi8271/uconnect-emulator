package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVicsDSRCEtcDiagHMI;
   import com.harman.moduleLinkAPI.VicsDSRCEtcDiagHMIEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VicsDSRCEtcDiagHMI extends Module implements IVicsDSRCEtcDiagHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnDsrcVicsEtcDiag.NavCtrl_Driver";
      
      private static const SELF_TEST_VICS_BEACON:String = "requestSelfTestVICSBeacon";
      
      private static const SELF_TEST_ETC:String = "requestSelfTestETC";
      
      private static const SELF_TEST_VICS_FM:String = "requestSelfTestVICSFM";
      
      private static const ETC_DEVICE_FAILED:String = "EtcDeviceFailed";
      
      private static const ETC_DEVICE_STATUS:String = "EtcDeviceStatus";
      
      private static const ETC_ANTENNA_FAILED:String = "EtcAntennaFailed";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mEtcDeviceStatus:uint = 0;
      
      private var mEtcDeviceFailed:Boolean = true;
      
      private var mEtcAntennaFailed:Boolean = true;
      
      public function VicsDSRCEtcDiagHMI()
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
         this.connection.addEventListener(ConnectionEvent.VICSDSRCETCDIAGHMI,this.DSRCEtcDiagHMIMessageHandler);
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
            if(!this.client.connected)
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
      
      private function requestAttributesInitialValue() : void
      {
         this.sendAttrRequest(ETC_DEVICE_FAILED);
         this.sendAttrRequest(ETC_DEVICE_STATUS);
         this.sendAttrRequest(ETC_ANTENNA_FAILED);
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.sendSubscribe(ETC_DEVICE_FAILED);
         this.sendSubscribe(ETC_DEVICE_STATUS);
         this.sendSubscribe(ETC_ANTENNA_FAILED);
      }
      
      public function requestEtcDeviceFailed() : void
      {
         this.sendAttrRequest(ETC_DEVICE_FAILED);
      }
      
      public function requestEtcDeviceStatus() : void
      {
         this.sendAttrRequest(ETC_DEVICE_STATUS);
      }
      
      public function requestEtcAntennaFailed() : void
      {
         this.sendAttrRequest(ETC_ANTENNA_FAILED);
      }
      
      public function requestSelfTestVICSBeacon() : void
      {
         this.sendCommandSimple(SELF_TEST_VICS_BEACON);
      }
      
      public function requestSelfTestETC() : void
      {
         this.sendCommandSimple(SELF_TEST_ETC);
      }
      
      public function requestSelfTestVICSFM(frequency:uint) : void
      {
         this.sendCommand(SELF_TEST_VICS_FM,"frequency",String(frequency));
      }
      
      private function DSRCEtcDiagHMIMessageHandler(e:ConnectionEvent) : void
      {
         var DSRCetcDiagData:Object = e.data;
         if(DSRCetcDiagData.hasOwnProperty(ETC_DEVICE_FAILED))
         {
            this.mEtcDeviceFailed = DSRCetcDiagData.EtcDeviceFailed[1];
            this.dispatchEvent(new VicsDSRCEtcDiagHMIEvent(VicsDSRCEtcDiagHMIEvent.ETC_DEVICE_FAILED,e.data));
         }
         else if(DSRCetcDiagData.hasOwnProperty(ETC_DEVICE_STATUS))
         {
            this.mEtcDeviceStatus = DSRCetcDiagData.EtcDeviceStatus[1];
            this.dispatchEvent(new VicsDSRCEtcDiagHMIEvent(VicsDSRCEtcDiagHMIEvent.ETC_DEVICE_STATUS,e.data));
         }
         else if(DSRCetcDiagData.hasOwnProperty(ETC_ANTENNA_FAILED))
         {
            this.mEtcAntennaFailed = DSRCetcDiagData.EtcAntennaFailed[1];
            this.dispatchEvent(new VicsDSRCEtcDiagHMIEvent(VicsDSRCEtcDiagHMIEvent.ETC_ANTENNA_FAILED,e.data));
         }
         else if(!DSRCetcDiagData.hasOwnProperty(SELF_TEST_ETC))
         {
            if(!DSRCetcDiagData.hasOwnProperty(SELF_TEST_VICS_BEACON))
            {
               if(!DSRCetcDiagData.hasOwnProperty(SELF_TEST_VICS_FM))
               {
                  trace("Unexpected property returned to VicsDSRCEtcDiagHMI module");
               }
            }
         }
      }
      
      public function get EtcDeviceFailed() : Boolean
      {
         return this.mEtcDeviceFailed;
      }
      
      public function get EtcDeviceStatus() : uint
      {
         return this.mEtcDeviceStatus;
      }
      
      public function get EtcAntennaFailed() : Boolean
      {
         return this.mEtcAntennaFailed;
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

