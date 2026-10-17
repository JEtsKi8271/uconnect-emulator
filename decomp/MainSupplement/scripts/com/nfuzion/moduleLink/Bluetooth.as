package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.*;
   import com.nfuzion.span.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class Bluetooth extends Module implements IBluetooth
   {
      
      private static var instance:Bluetooth;
      
      private static const dbusIdentifier:String = "BluetoothGAP";
      
      private static const dbusBTPersistency:String = "BluetoothGAPPersistency";
      
      private static const NEVER_CONNECTED:int = 0;
      
      private static const CONNECTED:int = 1;
      
      private static const DISCONNECTED:int = 2;
      
      private var mBTEnabled:Boolean;
      
      private var mHeadUnitName:String = "";
      
      private var mLocalPIN:String = "";
      
      private var mTempPIN:String = "";
      
      private var mLocalAddress:String = "";
      
      private var mPairedDevices:Vector.<BluetoothDevice> = new Vector.<BluetoothDevice>();
      
      private var mDeviceSearchList:Vector.<BluetoothDevice> = new Vector.<BluetoothDevice>();
      
      private var mSecurePIN:String = "";
      
      private var mDeviceName:String = "";
      
      private var mDeviceAddress:String = "";
      
      private var mBTTimer:Timer = new Timer(5000);
      
      private var mBTTimerExpired:Boolean = false;
      
      private var mReady:Boolean = false;
      
      private var mCurrentHFPDevice:BluetoothDevice;
      
      private var mCurrentA2DPDevice:BluetoothDevice;
      
      private var mSendDevicePairedOKEvent:Boolean;
      
      private var mSendA2DPDevicePairedOKEvent:Boolean = false;
      
      private var mRequestedHFPDevice:BluetoothDevice;
      
      private var mRequestedA2DPDevice:BluetoothDevice;
      
      private var mI:int = -1;
      
      private var mPreviousI:int = -1;
      
      private var mConnectIndex:int = 0;
      
      private var mUnpairingAddress:String = "";
      
      private var mServiceDisconnectedReason:String = "";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mBluetoothServiceAvailable:Boolean = false;
      
      public function Bluetooth()
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
         this.connection.addEventListener(ConnectionEvent.BLUETOOTH_MANAGER,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.BLUETOOTH_MANAGER_PERSISTENCY,this.messageHandler);
         this.mBTEnabled = false;
         this.mCurrentHFPDevice = null;
         this.mCurrentA2DPDevice = null;
      }
      
      public static function getInstance() : Bluetooth
      {
         if(instance == null)
         {
            instance = new Bluetooth();
         }
         return instance;
      }
      
      public function get BT_Status() : Boolean
      {
         return this.mBTEnabled;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function initBluetooth(theState:Boolean) : void
      {
         this.mBTEnabled = theState;
         this.sendCommand("setBluetoothStatus","enable",theState);
      }
      
      public function switchBluetoothOff() : void
      {
         this.sendCommand("switchBluetoothOff",null,null);
      }
      
      public function setPin(thePin:String) : void
      {
         this.mTempPIN = thePin;
         this.sendCommand("setPin","pin",thePin);
      }
      
      public function reqDiscoverable(theState:Boolean, service:String = "") : void
      {
         if(theState)
         {
            if(service == "")
            {
               this.sendCommand("setAccessMode","accessMode","GENERAL");
            }
            else
            {
               this.sendCommandTwoParams("setAccessMode","accessMode","GENERAL","service",service);
            }
         }
         else
         {
            this.sendCommand("setAccessMode","accessMode","CONNECTABLE_ONLY");
         }
      }
      
      public function reqDeviceSearch(theState:Boolean, maxDevices:uint, timeout:uint) : void
      {
         var message:String = null;
         var btDevice:BluetoothDevice = null;
         while(this.mDeviceSearchList.length > 0)
         {
            btDevice = this.mDeviceSearchList.pop();
            btDevice = null;
         }
         if(theState == true)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startDeviceSearch\": {\"maxDevices\":" + maxDevices + ", \"timeout\":" + timeout + "}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"stopDeviceSearch\": {}}}";
         }
         this.client.send(message);
      }
      
      public function startDevicePairing(dev:BluetoothDevice) : void
      {
         this.sendCommand("startDevicePairing","address",dev.DevAddress);
         this.mCurrentHFPDevice = dev;
      }
      
      public function startDeviceUnpairing(dev:BluetoothDevice) : void
      {
         this.mUnpairingAddress = dev.DevAddress;
         this.sendCommand("startDeviceUnpairing","address",dev.DevAddress);
         this.dispatchEvent(new BluetoothEvent(BluetoothEvent.START_DEVICE_UNPAIRING_OK));
      }
      
      public function securePairingReply(accept:Boolean) : void
      {
         var message:String = null;
         if(accept)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"securePairingReply\": {\"address\":\"" + this.mDeviceAddress + "\", \"accept\":true, \"trusted\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"securePairingReply\": {\"address\":\"" + this.mDeviceAddress + "\", \"accept\":false, \"trusted\":true}}}";
         }
         this.client.send(message);
      }
      
      public function standardPairingReply(accept:Boolean) : void
      {
         var message:String = null;
         if(!accept)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"standardPairingReply\": {\"address\":\"" + this.mDeviceAddress + "\", \"accept\":false, \"trusted\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"standardPairingReply\": {\"address\":\"" + this.mDeviceAddress + "\", \"accept\":true, \"trusted\":true}}}";
         }
         this.client.send(message);
      }
      
      public function reqPairedDeviceList() : void
      {
         this.sendCommand("getPairedDeviceList",null,null);
      }
      
      public function reqStartHFPConnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev.HfpAvailable == false)
         {
            return;
         }
         this.mRequestedHFPDevice = dev;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceConnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"" + "HFPGW" + "\"}}}";
         this.client.send(message);
      }
      
      public function reqStartHFPDisconnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev == null)
         {
            return;
         }
         if(dev.HfpAvailable == false)
         {
            return;
         }
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceDisconnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"HFPGW\"}}}";
         this.client.send(message);
      }
      
      public function reqStartA2DPConnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev.A2dpAvailable == false)
         {
            return;
         }
         this.mRequestedA2DPDevice = dev;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceConnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"A2DP_SOURCE\"}}}";
         this.client.send(message);
      }
      
      public function reqStartA2DPDisconnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev == null)
         {
            return;
         }
         if(dev.A2dpAvailable == false)
         {
            return;
         }
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceDisconnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"A2DP_SOURCE\"}}}";
         this.client.send(message);
      }
      
      public function reqStartDUNConnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev.DunAvailable == false)
         {
            return;
         }
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceConnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"DUNGW\"}}}";
         this.client.send(message);
      }
      
      public function reqStartDUNDisconnect(dev:BluetoothDevice) : void
      {
         var message:String = null;
         if(dev == null)
         {
            return;
         }
         if(dev.DunAvailable == false)
         {
            return;
         }
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"startServiceDisconnect\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"DUNGW\"}}}";
         this.client.send(message);
      }
      
      public function reqSetFavourite(dev:BluetoothDevice, service:String) : void
      {
         var message:String = null;
         if(service == "A2DP")
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavourite\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"A2DP_SOURCE\"}}}";
            this.client.send(message);
         }
         else if(service == "HFP")
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavourite\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"HFPGW\"}}}";
            this.client.send(message);
         }
         else if(service == "DUN")
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavourite\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"DUNGW\"}}}";
            this.client.send(message);
         }
         else if(service == "PAN")
         {
            if(dev.DunAvailable && dev.DunPriority == 0)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavourite\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"DUNGW\"}}}";
               this.client.send(message);
            }
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setFavourite\": {\"address\":\"" + dev.DevAddress + "\", \"service\":\"PAN_NAP\"}}}";
            this.client.send(message);
         }
      }
      
      public function sendDTMFTone(keyPress:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"sendDtmfTone\": {\"dtmfTone\":\"" + keyPress + "\"}}}";
         this.client.send(message);
      }
      
      public function getPairedDeviceListWithService(profileName:String) : Vector.<BluetoothDevice>
      {
         var device:BluetoothDevice = null;
         var priorityIdx:int = 0;
         var priorityFound:Boolean = false;
         var list:Vector.<BluetoothDevice> = new Vector.<BluetoothDevice>();
         for(priorityIdx = 1; priorityIdx <= this.mPairedDevices.length; priorityIdx++)
         {
            priorityFound = false;
            for each(device in this.mPairedDevices)
            {
               switch(profileName)
               {
                  case "HFP":
                     if(device.HfpAvailable == true && priorityIdx == device.HfpPriority)
                     {
                        priorityFound = true;
                        list.push(device);
                     }
                     break;
                  case "DUN_&_PAN":
                     if(device.PanAvailable == true && priorityIdx == device.PanPriority)
                     {
                        priorityFound = true;
                        list.push(device);
                     }
                     else if(device.DunAvailable == true && priorityIdx == device.DunPriority)
                     {
                        priorityFound = true;
                        list.push(device);
                     }
                     break;
                  case "A2DP":
                     if(device.A2dpAvailable == true && priorityIdx == device.A2dpPriority)
                     {
                        priorityFound = true;
                        list.push(device);
                     }
               }
               if(priorityFound == true)
               {
                  break;
               }
            }
         }
         for each(device in this.mPairedDevices)
         {
            priorityFound = false;
            switch(profileName)
            {
               case "HFP":
                  if(device.HfpAvailable == true && 0 == device.HfpPriority)
                  {
                     priorityFound = true;
                     list.push(device);
                  }
                  break;
               case "DUN_&_PAN":
                  if(device.PanAvailable == true && 0 == device.PanPriority)
                  {
                     priorityFound = true;
                     list.push(device);
                  }
                  else if(device.DunAvailable == true && 0 == device.DunPriority)
                  {
                     priorityFound = true;
                     list.push(device);
                  }
                  break;
               case "A2DP":
                  if(device.A2dpAvailable == true && 0 == device.A2dpPriority)
                  {
                     priorityFound = true;
                     list.push(device);
                  }
            }
            if(priorityFound == true)
            {
               break;
            }
         }
         return list;
      }
      
      public function getDeviceFromAddress(address:String) : BluetoothDevice
      {
         var device:BluetoothDevice = null;
         for each(device in this.mPairedDevices)
         {
            if(device.DevAddress == address)
            {
               return device;
            }
         }
         return null;
      }
      
      public function get PIN() : String
      {
         return this.mLocalPIN;
      }
      
      public function get securePIN() : String
      {
         return this.mSecurePIN;
      }
      
      public function get address() : String
      {
         return this.mLocalAddress;
      }
      
      public function get localName() : String
      {
         return this.mHeadUnitName;
      }
      
      public function get DeviceSearchList() : Vector.<BluetoothDevice>
      {
         return this.mDeviceSearchList;
      }
      
      public function get PairedDeviceList() : Vector.<BluetoothDevice>
      {
         return this.mPairedDevices;
      }
      
      public function get currentDeviceName() : String
      {
         return this.mDeviceName;
      }
      
      public function get currentDeviceAddress() : String
      {
         return this.mDeviceAddress;
      }
      
      public function get currentHFPDevice() : BluetoothDevice
      {
         return this.mCurrentHFPDevice;
      }
      
      public function get currentA2DPDevice() : BluetoothDevice
      {
         return this.mCurrentA2DPDevice;
      }
      
      public function get serviceDisconnectedReason() : String
      {
         return this.mServiceDisconnectedReason;
      }
      
      public function reqSetLocalDeviceName(name:String) : void
      {
         this.dispatchEvent(new BluetoothEvent("localDeviceName"));
      }
      
      public function reqGetLocalDeviceName() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"properties\": [\"localDeviceName\"]}}}");
      }
      
      public function reqPin() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": { \"properties\": [\"passkey\"]}}}");
      }
      
      public function setBTChipMode(mode:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setBTChipMode\": { \"mode\": \"" + mode + "\"}}}");
      }
      
      public function getBTChipBTID() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getBTChipBTID\": {}}}");
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendBluetoothServiceAvailableRequest();
            this.sendMultiSubscribe(["bluetoothStatus","bluetoothAddress","standardPairingRequest","securePairingRequest","pairingStatus","deviceUnpaired","serviceConnectionRequest","serviceConnected","serviceConnectError","serviceDisconnected","deviceSearchList","profileSearchList","serviceSearchList","pairedDeviceList"]);
            this.sendSubscribe("pimObjectSyncState");
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function sendCommandTwoParams(commandName:String, valueName:String, value:Object, valueName2:String, value2:Object) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(value2 is String)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\", \"" + valueName2 + "\": \"" + value2 + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\", \"" + valueName2 + "\": \"" + value2.toString() + "\"}}}";
            }
         }
         else if(value2 is String)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value.toString() + "\", \"" + valueName2 + "\": \"" + value2 + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value.toString() + "\", \"" + valueName2 + "\": \"" + value2.toString() + "\"}}}";
         }
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
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
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function startAutoconnect() : void
      {
         this.sendCommand("startAutoConnect",null,null);
      }
      
      public function stopAutoconnect() : void
      {
         this.sendCommand("pauseAutoConnect",null,null);
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var o:Object = null;
         var message:String = null;
         var rtnstr:String = null;
         var rtn:int = 0;
         var BT_Enabled:Boolean = false;
         var status:String = null;
         var btd:BluetoothDevice = null;
         var bluetooth:Object = e.data;
         if(bluetooth.hasOwnProperty("dBusServiceAvailable"))
         {
            if(bluetooth.dBusServiceAvailable == "true" && this.mBluetoothServiceAvailable == false)
            {
               this.mBluetoothServiceAvailable = true;
               this.sendCommand("setBluetoothStatus","enable",true);
               this.reqPin();
               this.reqGetLocalDeviceName();
               this.reqPairedDeviceList();
               this.getConnectionHistory();
            }
            else if(bluetooth.dBusServiceAvailable == "false")
            {
               this.mBluetoothServiceAvailable = false;
            }
         }
         else if(bluetooth.hasOwnProperty("setBluetoothStatus"))
         {
            BT_Enabled = Boolean("success" == bluetooth.setBluetoothStatus.description);
            message = "Bluetooth status is now ";
            if(BT_Enabled == true)
            {
               message += "ON\r\n";
               this.reqPairedDeviceList();
            }
            else
            {
               message += "OFF\r\n";
            }
            if(this.mBTEnabled == BT_Enabled)
            {
            }
            this.mBTEnabled = BT_Enabled;
            this.dispatchEvent(new BluetoothEvent("bluetoothStatus"));
         }
         else if(bluetooth.hasOwnProperty("setPin"))
         {
            rtn = int(bluetooth.setPin.code);
            rtnstr = bluetooth.setPin.description;
            if(rtnstr == "success")
            {
               this.mLocalPIN = this.mTempPIN;
               this.dispatchEvent(new BluetoothEvent("bluetoothPinOK"));
            }
            else
            {
               message = "Error in setting Pin.  Return Code = \r\n" + bluetooth.code;
               this.dispatchEvent(new BluetoothEvent("bluetoothPinFail"));
            }
         }
         else if(bluetooth.hasOwnProperty("getPairedDeviceList"))
         {
            rtnstr = bluetooth.getPairedDeviceList.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent("PairedDeviceListFail"));
               return;
            }
            this.decodeBluetoothDevices(bluetooth.getPairedDeviceList.pairedDeviceList);
            this.dispatchEvent(new BluetoothEvent("PairedDeviceList"));
         }
         else if(bluetooth.hasOwnProperty("setAccessMode"))
         {
            rtnstr = bluetooth.setAccessMode.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent("setAccessModeOK"));
            }
            else
            {
               this.dispatchEvent(new BluetoothEvent("setAccessModeOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("startDeviceSearch"))
         {
            rtnstr = bluetooth.startDeviceSearch.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent("startDeviceSearchFail"));
            }
            else
            {
               this.dispatchEvent(new BluetoothEvent("startDeviceSearchOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("stopDeviceSearch"))
         {
            rtnstr = bluetooth.stopDeviceSearch.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent("stopDeviceSearchFail"));
            }
            else
            {
               this.dispatchEvent(new BluetoothEvent("stopDeviceSearchOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("getProperties"))
         {
            if(bluetooth.getProperties.hasOwnProperty("passkey"))
            {
               this.mLocalPIN = bluetooth.getProperties.passkey.pin;
               this.dispatchEvent(new BluetoothEvent("PIN",this.mLocalPIN));
            }
            if(bluetooth.getProperties.hasOwnProperty("bluetoothAddress"))
            {
               this.mLocalAddress = bluetooth.getProperties.bluetoothAddress.address;
               this.dispatchEvent(new BluetoothEvent("localDeviceAddress",this.mLocalAddress));
            }
            if(bluetooth.getProperties.hasOwnProperty("localDeviceName"))
            {
               this.mHeadUnitName = bluetooth.getProperties.localDeviceName.localDeviceName;
               this.dispatchEvent(new BluetoothEvent("localDeviceName",this.mHeadUnitName));
            }
         }
         else if(bluetooth.hasOwnProperty("startServiceConnect"))
         {
            rtnstr = bluetooth.startServiceConnect.description;
            if(rtnstr != "busy")
            {
               if(rtnstr == "success")
               {
                  this.dispatchEvent(new BluetoothEvent("startServiceConnectOK"));
               }
            }
         }
         else if(bluetooth.hasOwnProperty("startServiceDisconnect"))
         {
            rtnstr = bluetooth.startServiceDisconnect.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent("startServiceDisconnectFail"));
            }
            else
            {
               this.dispatchEvent(new BluetoothEvent("startServiceDisconnectOK"));
            }
         }
         else if(bluetooth.hasOwnProperty("setFavourite"))
         {
            this.dispatchEvent(new BluetoothEvent("serviceFavouriteSet"));
            this.reqPairedDeviceList();
         }
         else if(bluetooth.hasOwnProperty("pimObjectSyncState"))
         {
            if(bluetooth.pimObjectSyncState.hasOwnProperty("syncStatus"))
            {
               this.dispatchEvent(new BluetoothEvent(BluetoothEvent.PIM_SYNC_STATE,bluetooth.pimObjectSyncState));
            }
         }
         else if(bluetooth.hasOwnProperty("standardPairingRequest"))
         {
            this.dispatchEvent(new BluetoothEvent("standardPairingRequest"));
            this.mDeviceAddress = bluetooth.standardPairingRequest.address;
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"standardPairingReply\": {\"address\":\"" + bluetooth.standardPairingRequest.address + "\", \"accept\":true, \"trusted\":true}}}";
            this.client.send(message);
         }
         else if(bluetooth.hasOwnProperty("pairingStatus"))
         {
            this.reqPairedDeviceList();
            rtnstr = bluetooth.pairingStatus.pairStatus;
            if("complete" == rtnstr)
            {
               this.dispatchEvent(new BluetoothEvent("DevicePairedOK",bluetooth.pairingStatus.address));
            }
            else if("success" == rtnstr)
            {
               btd = this.findDeviceInList(bluetooth.pairingStatus.address,this.mPairedDevices);
               if(!btd)
               {
                  btd = new BluetoothDevice();
                  btd.DevAddress = bluetooth.pairingStatus.address;
                  this.mPairedDevices.push(btd);
               }
               btd.DevName = bluetooth.pairingStatus.name;
               this.mDeviceName = bluetooth.pairingStatus.name;
            }
            else
            {
               this.dispatchEvent(new BluetoothEvent(BluetoothEvent.DEVICE_PAIRED_FAIL));
            }
         }
         else if(bluetooth.hasOwnProperty("deviceUnpaired"))
         {
            this.removePairedDevice(bluetooth.deviceUnpaired.address);
            this.mUnpairingAddress = "";
            this.dispatchEvent(new BluetoothEvent(BluetoothEvent.DEVICE_UNPAIRED));
            this.reqPairedDeviceList();
         }
         if(bluetooth.hasOwnProperty("deviceSearchList"))
         {
            if(this.decodeDeviceSearchList(bluetooth.deviceSearchList.deviceSearchList) == 0)
            {
               this.dispatchEvent(new BluetoothEvent("DeviceSearchList"));
            }
         }
         else if(bluetooth.hasOwnProperty("standardPairingReply"))
         {
            rtnstr = bluetooth.standardPairingReply.description;
            if(rtnstr != "success")
            {
               this.dispatchEvent(new BluetoothEvent(BluetoothEvent.DEVICE_PAIRED_FAIL));
            }
         }
         else if(bluetooth.hasOwnProperty("bluetoothAddress"))
         {
            this.mLocalAddress = bluetooth.bluetoothAddress.address;
         }
         else if(bluetooth.hasOwnProperty("serviceConnectionRequest"))
         {
            if(bluetooth.serviceConnectionRequest.service == "HFPGW" || bluetooth.serviceConnectionRequest.service == "A2DP_SOURCE")
            {
               if(this.findDeviceInList(bluetooth.serviceConnectionRequest.address,this.mPairedDevices) != null)
               {
                  message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"serviceConnectReply\": {\"address\":\"" + bluetooth.serviceConnectionRequest.address + "\", \"service\":\"" + bluetooth.serviceConnectionRequest.service + "\", \"accept\":true}}}";
                  this.client.send(message);
               }
               else
               {
                  message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"serviceConnectReply\": {\"address\":\"" + bluetooth.serviceConnectionRequest.address + "\", \"service\":\"" + bluetooth.serviceConnectionRequest.service + "\", \"accept\":false}}}";
                  this.client.send(message);
               }
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"serviceConnectReply\": {\"address\":\"" + bluetooth.serviceConnectionRequest.address + "\", \"service\":\"" + bluetooth.serviceConnectionRequest.service + "\", \"accept\":false}}}";
               this.client.send(message);
            }
         }
         else if(bluetooth.hasOwnProperty("serviceSearchList"))
         {
            this.decodeServiceSearchList(bluetooth.serviceSearchList);
         }
         else if(bluetooth.hasOwnProperty("bluetoothStatus"))
         {
            this.mBTEnabled = bluetooth.bluetoothStatus.status;
            message = "Bluetooth status is now ";
            if(this.mBTEnabled == true)
            {
               message += "ON\r\n";
               this.reqPairedDeviceList();
            }
            else
            {
               message += "OFF\r\n";
            }
            this.dispatchEvent(new BluetoothEvent("bluetoothStatus"));
         }
         else if(bluetooth.hasOwnProperty("pairedDeviceList"))
         {
            this.reqPairedDeviceList();
         }
         else if(bluetooth.hasOwnProperty("localDeviceName"))
         {
            this.mHeadUnitName = bluetooth.localDeviceName.localDeviceName;
         }
         else if(bluetooth.hasOwnProperty("serviceConnected"))
         {
            this.reqPairedDeviceList();
            if(bluetooth.serviceConnected.service == "HFP" || bluetooth.serviceConnected.service == "HFPGW")
            {
               this.mServiceDisconnectedReason = "";
               this.mRequestedHFPDevice = null;
               this.updateProfileConnectionStatus(bluetooth.serviceConnected.address,bluetooth.serviceConnected.service,true);
               this.dispatchEvent(new BluetoothEvent("DeviceConnectOK",bluetooth.serviceConnected.service));
            }
            else if(bluetooth.serviceConnected.service == "A2DP_SOURCE")
            {
               this.mRequestedA2DPDevice = null;
               this.updateProfileConnectionStatus(bluetooth.serviceConnected.address,bluetooth.serviceConnected.service,true);
               this.dispatchEvent(new BluetoothEvent("DeviceConnectOK",bluetooth.serviceConnected.service));
            }
         }
         else if(bluetooth.hasOwnProperty("serviceConnectError"))
         {
            if(Boolean(bluetooth.serviceConnectError.service == "HFPGW") && Boolean(this.mRequestedHFPDevice) && bluetooth.serviceConnectError.address == this.mRequestedHFPDevice.DevAddress)
            {
               this.mRequestedHFPDevice = null;
               this.dispatchEvent(new BluetoothEvent("DeviceConnectFail","failure"));
            }
            if(Boolean(bluetooth.serviceConnectError.service == "A2DP_SOURCE") && Boolean(this.mRequestedA2DPDevice) && bluetooth.serviceConnectError.address == this.mRequestedA2DPDevice.DevAddress)
            {
               this.mRequestedA2DPDevice = null;
               this.dispatchEvent(new BluetoothEvent("DeviceConnectFail","failure"));
            }
         }
         else if(bluetooth.hasOwnProperty("serviceDisconnected"))
         {
            this.mServiceDisconnectedReason = bluetooth.serviceDisconnected.reason;
            this.updateProfileConnectionStatus(bluetooth.serviceDisconnected.address,bluetooth.serviceDisconnected.service,false);
            this.dispatchEvent(new BluetoothEvent("serviceDisconnected",bluetooth.serviceDisconnected.service));
         }
         else if(bluetooth.hasOwnProperty("securePairingRequest"))
         {
            this.mSecurePIN = bluetooth.securePairingRequest.pin;
            this.mSecurePIN = this.mSecurePIN.replace(" ","");
            this.mDeviceAddress = bluetooth.securePairingRequest.address;
            this.dispatchEvent(new BluetoothEvent("securePairingRequest"));
         }
         else if(bluetooth.hasOwnProperty("setBTChipMode"))
         {
            this.dispatchEvent(new BluetoothEvent("setBTChipMode",bluetooth.setBTChipMode.description));
         }
         else if(bluetooth.hasOwnProperty("getBTChipBTID"))
         {
            this.dispatchEvent(new BluetoothEvent("getBTChipBTID",bluetooth.getBTChipBTID.description));
         }
      }
      
      private function updateProfileConnectionStatus(address:String, service:String, connected:Boolean) : void
      {
         var p:BluetoothProfile = null;
         var btd:BluetoothDevice = null;
         var j:uint = 0;
         btd = this.findDeviceInList(address,this.mPairedDevices);
         if(btd == null)
         {
            return;
         }
         j = 0;
         switch(service)
         {
            case "HFPGW":
               btd.HfpConnected = connected;
               btd.HfpAvailable = true;
               this.mCurrentHFPDevice = this.updateCurrentHFPDevice();
               break;
            case "DUNGW":
               btd.DunConnected = connected;
               btd.DunAvailable = true;
               break;
            case "A2DP_SOURCE":
               btd.A2dpConnected = connected;
               btd.A2dpAvailable = true;
               this.mCurrentA2DPDevice = this.updateCurrentA2DPDevice();
               break;
            case "PAN_NAP":
               btd.PanConnected = connected;
               btd.PanAvailable = true;
         }
      }
      
      private function decodeBluetoothDevices(deviceList:Object) : void
      {
         var btDevice:BluetoothDevice = null;
         var btdevice:Object = null;
         var d:BluetoothDevice = null;
         var push:Boolean = false;
         for each(btdevice in deviceList)
         {
            d = this.findDeviceInList(btdevice.address,this.mPairedDevices);
            if(d == null)
            {
               d = new BluetoothDevice();
               push = true;
            }
            d.DevAddress = btdevice.address;
            d.DevName = btdevice.name;
            this.decodeService(btdevice.serviceSearchList,d);
            if(push)
            {
               this.mPairedDevices.push(d);
               push = false;
            }
            if(d.HfpConnected == true)
            {
               this.mCurrentHFPDevice = d;
            }
            if(d.A2dpConnected == true)
            {
               this.mCurrentA2DPDevice = d;
            }
         }
      }
      
      private function decodeServiceSearchList(serviceSearchList:Object) : void
      {
         var address:String = null;
         var btd:BluetoothDevice = null;
         var SSL:Object = null;
         for each(SSL in serviceSearchList)
         {
            address = serviceSearchList.address;
            btd = this.findDeviceInList(address,this.mPairedDevices);
            if(btd != null)
            {
               this.decodeService(serviceSearchList.services,btd);
            }
         }
      }
      
      private function decodeService(services:Object, btd:BluetoothDevice) : void
      {
         var p:Object = null;
         for each(p in services)
         {
            switch(p.service)
            {
               case "HFPGW":
                  btd.HfpAvailable = true;
                  btd.HfpConnected = p.connected;
                  btd.HfpPriority = p.priority;
                  break;
               case "DUNGW":
                  btd.DunAvailable = true;
                  btd.DunConnected = p.connected;
                  btd.DunPriority = p.priority;
                  break;
               case "A2DP_SOURCE":
                  btd.A2dpAvailable = true;
                  btd.A2dpConnected = p.connected;
                  btd.A2dpPriority = p.priority;
                  break;
               case "PAN_NAP":
                  btd.PanAvailable = true;
                  btd.PanConnected = p.connected;
                  btd.PanPriority = p.priority;
            }
         }
      }
      
      private function decodeDeviceSearchList(deviceSearchList:Object) : uint
      {
         var btDevice:BluetoothDevice = null;
         var btdevice:Object = null;
         var d:BluetoothDevice = null;
         var i:int = 0;
         for each(btdevice in deviceSearchList)
         {
            if(!btdevice.hasOwnProperty("address"))
            {
               break;
            }
            d = new BluetoothDevice();
            d.DevAddress = btdevice.address;
            d.DevName = btdevice.name;
            this.mDeviceSearchList.push(d);
            i++;
         }
         return i;
      }
      
      private function decodeBluetoothConnectHistory(history:Object) : void
      {
         var btd:BluetoothDevice = null;
         var h:Object = null;
         var newhis:BluetoothConnectionHistory = new BluetoothConnectionHistory();
         for each(h in history)
         {
            newhis.address = h.address;
            btd = this.findDeviceInList(newhis.address,this.mPairedDevices);
            if(btd != null)
            {
               btd.dunTime = h.DUNTime;
               btd.a2dpTime = h.A2DPTime;
               btd.hfpTime = h.HFPTime;
            }
         }
      }
      
      private function findDeviceInList(address:String, list:Vector.<BluetoothDevice>) : BluetoothDevice
      {
         var i:uint = 0;
         while(i < list.length)
         {
            if(list[i].DevAddress == address)
            {
               return list[i];
            }
            i++;
         }
         return null;
      }
      
      private function getConnectionHistory() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusBTPersistency + "\", \"packet\": {\"read\":{\"key\":\"BTConnectionHistory\", \"escval\":0}}}";
         this.client.send(message);
      }
      
      protected function removePairedDevice(address:String) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mPairedDevices.length; i++)
         {
            if(this.mPairedDevices[i].DevAddress == address)
            {
               this.mPairedDevices.splice(i,1);
               return;
            }
         }
      }
      
      private function updateCurrentHFPDevice() : BluetoothDevice
      {
         var i:int = 0;
         for(i = 0; i < this.mPairedDevices.length; i++)
         {
            if(this.mPairedDevices[i].HfpConnected == true)
            {
               return this.mPairedDevices[i];
            }
         }
         return null;
      }
      
      private function updateCurrentA2DPDevice() : BluetoothDevice
      {
         var i:int = 0;
         for(i = 0; i < this.mPairedDevices.length; i++)
         {
            if(this.mPairedDevices[i].A2dpConnected == true)
            {
               return this.mPairedDevices[i];
            }
         }
         return null;
      }
      
      private function sendBluetoothServiceAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendPersistencyServiceAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"PersistentKeyValue\"}";
         this.client.send(message);
      }
      
      public function noPhoneConnectedScenario(info:String) : void
      {
         var message:Object = null;
         message = {
            "Type":"EmitSignal",
            "packet":{"phoneNotConnected":{"status":info}}
         };
         this.connection.send(message);
      }
   }
}

