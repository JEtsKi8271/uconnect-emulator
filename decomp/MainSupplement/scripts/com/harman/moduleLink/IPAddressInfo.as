package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IIPAddressInfo;
   import com.harman.moduleLinkAPI.IPAddressInfoEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class IPAddressInfo extends Module implements IIPAddressInfo
   {
      
      private static var instance:IPAddressInfo;
      
      private static const mDbusIdentifier:String = "IPAddressInfo";
      
      private var m_Ready:Boolean = false;
      
      private var m_ipAddress:String;
      
      private var m_qxdmConnStatus:String;
      
      private var m_displayHotWarning:Boolean;
      
      private var m_temperatures:Object = {
         "gyroCurrent":0,
         "gyroMAX":0,
         "gyroOdometer":0,
         "gyroCabinTemp":0,
         "thermistorOmapCurrent":0,
         "thermistorOmapMAX":0,
         "thermistorOmapOdometer":0,
         "thermistorOmapCabinTemp":0,
         "thermistorEcellCurrent":0,
         "thermistorEcellMAX":0,
         "thermistorEcellOdometer":0,
         "thermistorEcellCabinTemp":0,
         "displayDriverCurrent":0,
         "displayDriverMAX":0,
         "displayDriverOdometer":0,
         "displayDriverCabinTemp":0,
         "displatBacklightCurrent":0,
         "displatBacklightMAX":0,
         "displatBacklightOdometer":0,
         "displatBacklightCabinTemp":0,
         "eCellPhoneCurrent":0,
         "eCellPhoneMAX":0,
         "eCellPhoneOdometer":0,
         "eCellPhoneCabinTemp":0,
         "eCellPowerAmpCurrent":0,
         "eCellPowerAmpMAX":0,
         "eCellPowerAmpOdometer":0,
         "eCellPowerAmpCabinTemp":0,
         "oMapCurrent":0,
         "oMapMAX":0,
         "oMapOdometer":0,
         "oMapCabinTemp":0,
         "powerAmpStatus":0,
         "eCellStatus":"UNDEFINED"
      };
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function IPAddressInfo()
      {
         super();
         this.m_ipAddress = "";
         this.m_qxdmConnStatus = "";
         this.m_displayHotWarning = false;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.IPADDRESS_INFO,this.messageHandler);
      }
      
      public static function getInstance() : IPAddressInfo
      {
         if(instance == null)
         {
            instance = new IPAddressInfo();
         }
         return instance;
      }
      
      public function get temperatures() : Object
      {
         return this.m_temperatures;
      }
      
      public function get ipAddress() : String
      {
         return this.m_ipAddress;
      }
      
      public function get QXDMConnStatus() : String
      {
         return this.m_qxdmConnStatus;
      }
      
      public function get displayHotWarning() : Boolean
      {
         return this.m_displayHotWarning;
      }
      
      public function connectQXDM() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"connectQXDM\": {}}}";
         this.client.send(message);
      }
      
      public function disconnectQXDM() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"disconnectQXDM\": {}}}";
         this.client.send(message);
      }
      
      public function clearThermalHistory() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"clearThermalHistory\": {}}}");
      }
      
      public function getIPAddressInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getIPAddressInfo\": {}}}");
      }
      
      public function enableTemperatureBroadCast() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"enableTemperatureBroadcast\": {}}}");
      }
      
      public function disableTemperatureBroadCast() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"disableTemperatureBroadcast\": {}}}");
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var tmp:Object = null;
         var info:Object = e.data;
         tmp = null;
         if(info.hasOwnProperty("getIPAddressInfo"))
         {
            tmp = info.getIPAddressInfo;
            if(tmp != null)
            {
               try
               {
                  this.m_ipAddress = tmp.ipaddress;
                  this.dispatchEvent(new IPAddressInfoEvent(IPAddressInfoEvent.IPADDRESS_INFO));
               }
               catch(e:Error)
               {
               }
            }
         }
         else if(info.hasOwnProperty("QXDMConnStatus"))
         {
            if(this.m_qxdmConnStatus != info.QXDMConnStatus)
            {
               this.m_qxdmConnStatus = info.QXDMConnStatus;
               this.dispatchEvent(new IPAddressInfoEvent(IPAddressInfoEvent.QXDM_CONN_STATUS,e.data));
            }
         }
         else if(info.hasOwnProperty("temperature"))
         {
            this.updateTemperature(info.temperature);
            this.dispatchEvent(new IPAddressInfoEvent(IPAddressInfoEvent.TEMPERATURE_INFO,e.data));
         }
         else if(info.hasOwnProperty("displayHotWarning"))
         {
            this.m_displayHotWarning = info.displayHotWarning.displayHot;
            this.dispatchEvent(new IPAddressInfoEvent(IPAddressInfoEvent.DISPLAY_HOT_WARNING,e.data));
         }
      }
      
      private function updateTemperature(temp:Object) : void
      {
         this.m_temperatures.gyroCurrent = temp.gyro.cur;
         this.m_temperatures.gyroMAX = temp.gyro.max;
         this.m_temperatures.gyroOdometer = temp.gyro.odo;
         this.m_temperatures.gyroCabinTemp = temp.gyro.cab;
         this.m_temperatures.thermistorOmapCurrent = temp.thermistorOmap.cur;
         this.m_temperatures.thermistorOmapMAX = temp.thermistorOmap.max;
         this.m_temperatures.thermistorOmapOdometer = temp.thermistorOmap.odo;
         this.m_temperatures.thermistorOmapCabinTemp = temp.thermistorOmap.cab;
         this.m_temperatures.thermistorEcellCurrent = temp.thermistorEcell.cur;
         this.m_temperatures.thermistorEcellMAX = temp.thermistorEcell.max;
         this.m_temperatures.thermistorEcellOdometer = temp.thermistorEcell.odo;
         this.m_temperatures.thermistorEcellCabinTemp = temp.thermistorEcell.cab;
         this.m_temperatures.displayDriverCurrent = temp.displayDriver.cur;
         this.m_temperatures.displayDriverMAX = temp.displayDriver.max;
         this.m_temperatures.displayDriverOdometer = temp.displayDriver.odo;
         this.m_temperatures.displayDriverCabinTemp = temp.displayDriver.cab;
         this.m_temperatures.displatBacklightCurrent = temp.displatBacklight.cur;
         this.m_temperatures.displatBacklightMAX = temp.displatBacklight.max;
         this.m_temperatures.displatBacklightOdometer = temp.displatBacklight.odo;
         this.m_temperatures.displatBacklightCabinTemp = temp.displatBacklight.cab;
         this.m_temperatures.eCellPhoneCurrent = temp.ecell.phone.cur;
         this.m_temperatures.eCellPhoneMAX = temp.ecell.phone.max;
         this.m_temperatures.eCellPhoneOdometer = temp.ecell.phone.odo;
         this.m_temperatures.eCellPhoneCabinTemp = temp.ecell.phone.cab;
         this.m_temperatures.eCellPowerAmpCurrent = temp.ecell.powerAmp.cur;
         this.m_temperatures.eCellPowerAmpMAX = temp.ecell.powerAmp.max;
         this.m_temperatures.eCellPowerAmpOdometer = temp.ecell.powerAmp.odo;
         this.m_temperatures.eCellPowerAmpCabinTemp = temp.ecell.powerAmp.cab;
         this.m_temperatures.oMapCurrent = temp.omap.cur;
         this.m_temperatures.oMapMAX = temp.omap.max;
         this.m_temperatures.oMapOdometer = temp.omap.odo;
         this.m_temperatures.oMapCabinTemp = temp.omap.cab;
         this.m_temperatures.powerAmpStatus = temp.powerAmpStatus;
         this.m_temperatures.eCellStatus = temp.ecellTempState;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.subscribe("QXDMConnStatus");
            this.subscribe("temperature");
            this.subscribe("displayHotWarning");
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
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

