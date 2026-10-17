package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVehicleStatus extends IModule
   {
      
      function get vehicleInPark() : Boolean;
      
      function get speedLockOut() : Boolean;
      
      function get speedLockOutFeature() : String;
      
      function toggleSpeedLockOutFeature() : void;
      
      function getSpeedLockoutFeatureState() : void;
      
      function get headlightsOn() : Boolean;
      
      function get language() : String;
      
      function getLanguage() : void;
      
      function get TestToolPresent() : Boolean;
      
      function get LangUnitMstrOverride() : String;
      
      function toggleLangUnitMstrOverride() : void;
      
      function get ThemeFileOverride() : String;
      
      function toggleThemeFileOverride() : void;
      
      function get SelecTerrainModeStatus() : Boolean;
      
      function setSelecTerrainModeStatus(param1:Boolean) : void;
      
      function setThemeTo(param1:String) : void;
      
      function get fuelSaverModeActual() : String;
      
      function getIgnitionState() : void;
      
      function get ignitionState() : String;
      
      function getTeenKeyIsPresent() : void;
      
      function get TeenKeyIsPresent() : Boolean;
      
      function get resumeModeTimeout() : int;
      
      function getResumeModeTimeout() : void;
      
      function setResumeModeTimeout(param1:int) : void;
      
      function getIsVehicleMoving() : void;
      
      function get isVehicleMoving() : Boolean;
      
      function getCurrentGear() : void;
      
      function get currentGear() : String;
      
      function getDriverDoorStatus() : void;
      
      function get driverDoorStatus() : String;
      
      function getVehicleInMotion() : void;
      
      function get vehicleInMotion() : Boolean;
      
      function getEPBServiceActiveAlert() : void;
      
      function get EPBServiceActiveAlert() : Boolean;
      
      function getSVCSpeedLockoutStatus() : void;
      
      function get SVCSpeedLockoutStatus() : Boolean;
      
      function getKeySensePinTimer() : void;
      
      function get KeySensePinTimer() : int;
      
      function setKeySensePinTimerState(param1:String) : void;
      
      function getGearDisplay() : void;
      
      function get gearDisplay() : String;
      
      function getSelecTerrainModePrevTheme() : void;
      
      function get selecTerrainModePrevTheme() : String;
      
      function setSelecTerrainModePrevTheme(param1:String) : void;
      
      function requestKeySenseSecurityPIN() : void;
      
      function get keySenseSecurityPIN() : String;
      
      function set keySenseSecurityPIN(param1:String) : void;
   }
}

