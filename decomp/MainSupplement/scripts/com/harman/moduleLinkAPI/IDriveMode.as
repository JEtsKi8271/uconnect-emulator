package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   import flash.utils.Dictionary;
   
   public interface IDriveMode extends IModule
   {
      
      function resetRPMToFactory(param1:Boolean = true) : void;
      
      function requestEcoMode(param1:Boolean) : void;
      
      function get EcoMode() : Boolean;
      
      function get EngineModeCustomStatus() : String;
      
      function get EngineModeRequest() : String;
      
      function set EngineModeRequest(param1:String) : void;
      
      function get EngineModeStatus() : String;
      
      function get ErrorGroup() : Dictionary;
      
      function get SNAGroup() : Dictionary;
      
      function get Gear1RPMRequest() : String;
      
      function set Gear1RPMRequest(param1:String) : void;
      
      function get Gear1RPMStatus() : String;
      
      function get Gear2RPMRequest() : String;
      
      function set Gear2RPMRequest(param1:String) : void;
      
      function get Gear2RPMStatus() : String;
      
      function get Gear3RPMRequest() : String;
      
      function set Gear3RPMRequest(param1:String) : void;
      
      function get Gear3RPMStatus() : String;
      
      function get Gear4RPMRequest() : String;
      
      function set Gear4RPMRequest(param1:String) : void;
      
      function get Gear4RPMStatus() : String;
      
      function get Gear5RPMRequest() : String;
      
      function set Gear5RPMRequest(param1:String) : void;
      
      function get Gear5RPMStatus() : String;
      
      function get GlobalDriveModeError() : Boolean;
      
      function get GlobalDriveModeRequest() : String;
      
      function set GlobalDriveModeRequest(param1:String) : void;
      
      function get GlobalDriveModeStatus() : String;
      
      function get GlobalDriveModeTables() : Object;
      
      function get HorsepowerModeCustomStatus() : String;
      
      function get HorsepowerModeError() : Boolean;
      
      function get HorsepowerModeRequest() : String;
      
      function set HorsepowerModeRequest(param1:String) : void;
      
      function get HorsepowerModeStatus() : String;
      
      function get isLegacyDriveModes() : Boolean;
      
      function get LaunchButtonRequest() : Boolean;
      
      function set LaunchButtonRequest(param1:Boolean) : void;
      
      function get LaunchButtonStatus() : Boolean;
      
      function get LaunchRPMPointRequest() : String;
      
      function set LaunchRPMPointRequest(param1:String) : void;
      
      function get LaunchRPMPointStatus() : String;
      
      function get MaxShiftRPMStatus() : String;
      
      function get PaddleShifterCustomStatus() : String;
      
      function get PaddleShifterRequest() : String;
      
      function set PaddleShifterRequest(param1:String) : void;
      
      function get PaddleShifterStatus() : String;
      
      function get PowerSteeringLockOut() : Boolean;
      
      function get PowerSteeringType() : String;
      
      function get RedKeyFeaturePresent() : Boolean;
      
      function get RedKeyPresent() : Boolean;
      
      function get ShiftIndicatorRequest() : String;
      
      function set ShiftIndicatorRequest(param1:String) : void;
      
      function get ShiftIndicatorStatus() : String;
      
      function get SRTButtonStatus() : String;
      
      function get StabilityCustomStatus() : String;
      
      function get StabilityRequest() : String;
      
      function set StabilityRequest(param1:String) : void;
      
      function get StabilityStatus() : String;
      
      function get SteeringCustomStatus() : String;
      
      function get SteeringErrorStatus() : String;
      
      function get SteeringRequest() : String;
      
      function set SteeringRequest(param1:String) : void;
      
      function get SteeringStatus() : String;
      
      function get SuspensionCustomStatus() : String;
      
      function get SuspensionRequest() : String;
      
      function set SuspensionRequest(param1:String) : void;
      
      function get SuspensionStatus() : String;
      
      function get ThrottleLockOut() : Boolean;
      
      function get TerrainModeCustomStatus() : String;
      
      function get TerrainModeRequest() : String;
      
      function set TerrainModeRequest(param1:String) : void;
      
      function get TerrainModeStatus() : String;
      
      function get TractionControlStatus() : Boolean;
      
      function get TransmissionModeCustomStatus() : String;
      
      function get TransmissionModeRequest() : String;
      
      function set TransmissionModeRequest(param1:String) : void;
      
      function get TransmissionModeStatus() : String;
      
      function get ValetModeLockOut() : Boolean;
      
      function get ValetModeLockOutReason() : String;
      
      function set isWK(param1:Boolean) : void;
      
      function set isNonSRT(param1:Boolean) : void;
      
      function get TerrainThemeStatus() : String;
      
      function get DriveModeLogging() : Boolean;
      
      function set DriveModeLogging(param1:Boolean) : void;
      
      function get DriveModeVersion() : String;
      
      function copyDriveModeLogToUSB() : void;
      
      function getDriveModeVersion() : void;
      
      function requestLoggingStatus() : void;
   }
}

