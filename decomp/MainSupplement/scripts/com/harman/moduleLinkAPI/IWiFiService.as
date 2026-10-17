package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IWiFiService extends IModule
   {
      
      function get WiFiReady() : Boolean;
      
      function get Role() : String;
      
      function get WiFiActive() : Boolean;
      
      function get WiFiSSID() : String;
      
      function get WiFiPassPhrase() : String;
      
      function get WiFiSecurity() : String;
      
      function get WiFiClientList() : Array;
      
      function get WlanState() : String;
      
      function get WiFiAPTestMode() : Object;
      
      function getActiveProfile() : Object;
      
      function getClientList() : void;
      
      function getWlanConnectionState() : String;
      
      function setRole(param1:String) : void;
      
      function setRFActive(param1:String, param2:Boolean) : void;
      
      function getWlanState() : void;
      
      function setWiFiAPTestMode(param1:int, param2:int, param3:int, param4:int, param5:int) : void;
      
      function getAPProfile() : void;
      
      function setAPProfile(param1:Object) : void;
      
      function scanNetworks(param1:int) : void;
      
      function getClientStatus() : void;
      
      function joinNetwork(param1:String, param2:String, param3:String) : void;
      
      function leaveNetwork() : void;
      
      function addToKnownNetworks(param1:String, param2:String, param3:String) : void;
      
      function deleteFromKnownNetworks(param1:String) : void;
      
      function getKnownNetworks() : void;
      
      function setFavoriteNetwork(param1:String) : void;
      
      function getIntendedProfile() : Object;
   }
}

