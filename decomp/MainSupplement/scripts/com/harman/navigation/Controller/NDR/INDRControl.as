package com.harman.navigation.Controller.NDR
{
   import com.harman.navigation.Controller.NDR.util.GPSInfo;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface INDRControl extends IModule
   {
      
      function enableSubscriptions(param1:Boolean) : void;
      
      function enableHeadingUpdates(param1:Boolean) : void;
      
      function getGPSInfo() : void;
      
      function get GpsInfo() : GPSInfo;
      
      function getSatelliteInfo() : void;
      
      function get SatelliteInfo() : Object;
      
      function sendPOS_resetCalibration() : void;
      
      function tripComputerStart() : void;
      
      function tripComputerStop() : void;
      
      function tripComputerReset() : void;
      
      function enableTripComputerSignals(param1:Boolean) : void;
      
      function getTripComputerData() : void;
      
      function get tripComputerData() : Object;
      
      function getVehSpeed() : void;
      
      function get vehicleSpeed() : int;
      
      function get calibrationMessage() : Boolean;
      
      function getCalibrationMessage() : void;
   }
}

