package com.nfuzion.moduleLinkAPI
{
   public interface IBluetooth extends IModule
   {
      
      function initBluetooth(param1:Boolean) : void;
      
      function switchBluetoothOff() : void;
      
      function setPin(param1:String) : void;
      
      function reqPin() : void;
      
      function reqDiscoverable(param1:Boolean, param2:String = "") : void;
      
      function reqDeviceSearch(param1:Boolean, param2:uint, param3:uint) : void;
      
      function startDevicePairing(param1:BluetoothDevice) : void;
      
      function standardPairingReply(param1:Boolean) : void;
      
      function securePairingReply(param1:Boolean) : void;
      
      function startDeviceUnpairing(param1:BluetoothDevice) : void;
      
      function reqPairedDeviceList() : void;
      
      function reqSetLocalDeviceName(param1:String) : void;
      
      function reqGetLocalDeviceName() : void;
      
      function reqStartHFPConnect(param1:BluetoothDevice) : void;
      
      function reqStartHFPDisconnect(param1:BluetoothDevice) : void;
      
      function reqStartA2DPConnect(param1:BluetoothDevice) : void;
      
      function reqStartA2DPDisconnect(param1:BluetoothDevice) : void;
      
      function reqSetFavourite(param1:BluetoothDevice, param2:String) : void;
      
      function sendDTMFTone(param1:String) : void;
      
      function setBTChipMode(param1:String) : void;
      
      function getBTChipBTID() : void;
      
      function getPairedDeviceListWithService(param1:String) : Vector.<BluetoothDevice>;
      
      function getDeviceFromAddress(param1:String) : BluetoothDevice;
      
      function get BT_Status() : Boolean;
      
      function get localName() : String;
      
      function get address() : String;
      
      function get PIN() : String;
      
      function get securePIN() : String;
      
      function startAutoconnect() : void;
      
      function stopAutoconnect() : void;
      
      function get currentHFPDevice() : BluetoothDevice;
      
      function get currentA2DPDevice() : BluetoothDevice;
      
      function noPhoneConnectedScenario(param1:String) : void;
      
      function get DeviceSearchList() : Vector.<BluetoothDevice>;
      
      function get PairedDeviceList() : Vector.<BluetoothDevice>;
      
      function get currentDeviceAddress() : String;
      
      function get currentDeviceName() : String;
      
      function get serviceDisconnectedReason() : String;
   }
}

