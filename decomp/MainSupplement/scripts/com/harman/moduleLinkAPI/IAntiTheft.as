package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAntiTheft extends IModule
   {
      
      function checkAntiTheftPin(param1:String) : void;
      
      function reqAntiTheftState() : void;
      
      function enableAntiTheft() : void;
      
      function get antiTheftState() : String;
      
      function reqAntiTheftLockTime() : void;
      
      function get antiTheftLockTime() : String;
      
      function reqBatteryConnectState() : void;
      
      function get batteryDisconnectState() : String;
      
      function reqPowerModeState() : void;
      
      function get powerModeState() : String;
      
      function reqIgnitionState() : void;
      
      function get ignitionState() : String;
      
      function requestReset() : void;
      
      function get WakeUpReason() : String;
   }
}

