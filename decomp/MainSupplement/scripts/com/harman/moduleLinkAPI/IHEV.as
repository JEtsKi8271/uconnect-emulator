package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IHEV extends IModule
   {
      
      function getHybridElectricModeStatus() : void;
      
      function get hybridElectricModeStatus() : String;
      
      function getHVBatteryChargeDisp() : void;
      
      function get HVBatterChargeDisp() : Number;
      
      function getHVBatteryChargeValidity() : void;
      
      function get HVBatteryChargeValidity() : String;
      
      function getBatteryPowerUsage() : void;
      
      function get batteryPowerUsage() : String;
      
      function getEnginePowerUsage() : void;
      
      function get enginePowerUsage() : String;
      
      function getHVACPowerUsage() : void;
      
      function get HVACPowerUsage() : String;
      
      function getEstimatedElectricRange() : void;
      
      function get estimatedElectricRange() : Number;
      
      function getChargingSystemStatus() : void;
      
      function get chargingSystemStatus() : String;
      
      function getWheelPowerFlowState() : void;
      
      function get wheelPowerFlowState() : String;
      
      function getEngToBatPowerFlowState() : void;
      
      function get engToBatPowerFlowState() : String;
      
      function getHVACPowerFlowState() : void;
      
      function get HVACPowerFlowState() : String;
      
      function getBatteryIconState() : void;
      
      function get batteryIconState() : String;
      
      function getEngineIconState() : void;
      
      function get engineIconState() : String;
      
      function getMotorIconState() : void;
      
      function get motorIconState() : String;
      
      function getChargeMinutesLv1() : void;
      
      function get chargeMinutesLv1() : String;
      
      function getChargeHoursLv1() : void;
      
      function get chargeHoursLv1() : String;
      
      function getChargeMinutesLv2() : void;
      
      function get chargeMinutesLv2() : String;
      
      function getChargeHoursLv2() : void;
      
      function get chargeHoursLv2() : String;
      
      function getPlugInStatus() : void;
      
      function get plugInStatus() : String;
      
      function getWeekendMinuteStart() : void;
      
      function get weekendMinuteStart() : String;
      
      function set weekendMinuteStart(param1:String) : void;
      
      function getWeekendMinuteEnd() : void;
      
      function get weekendMinuteEnd() : String;
      
      function set weekendMinuteEnd(param1:String) : void;
      
      function getWeekendHourStart() : void;
      
      function get weekendHourStart() : String;
      
      function set weekendHourStart(param1:String) : void;
      
      function getWeekendHourEnd() : void;
      
      function get weekendHourEnd() : String;
      
      function set weekendHourEnd(param1:String) : void;
      
      function getWeekdayMinuteStart() : void;
      
      function get weekdayMinuteStart() : String;
      
      function set weekdayMinuteStart(param1:String) : void;
      
      function getWeekdayMinuteEnd() : void;
      
      function get weekdayMinuteEnd() : String;
      
      function set weekdayMinuteEnd(param1:String) : void;
      
      function getWeekdayHourStart() : void;
      
      function get weekdayHourStart() : String;
      
      function set weekdayHourStart(param1:String) : void;
      
      function getWeekdayHourEnd() : void;
      
      function get weekdayHourEnd() : String;
      
      function set weekdayHourEnd(param1:String) : void;
      
      function getChargeDateTimeFormat() : void;
      
      function get chargeDateTimeFormat() : String;
      
      function set chargeDateTimeFormat(param1:String) : void;
      
      function getChargeRequestStatus() : void;
      
      function get chargeRequestStatus() : String;
      
      function set chargeRequestStatus(param1:String) : void;
      
      function getEnableChargeSchedule() : void;
      
      function get enableChargeSchedule() : Boolean;
      
      function set enableChargeSchedule(param1:Boolean) : void;
      
      function getCurrentDayIsWeekday() : void;
      
      function get currentDayIsWeekday() : Boolean;
      
      function getChargeUntilFullWeekday() : void;
      
      function get chargeUntilFullWeekday() : Boolean;
      
      function set chargeUntilFullWeekday(param1:Boolean) : void;
      
      function getChargeUntilFullWeekend() : void;
      
      function get chargeUntilFullWeekend() : Boolean;
      
      function set chargeUntilFullWeekend(param1:Boolean) : void;
      
      function getDisplayDrivingHistory() : void;
      
      function get displayDrivingHistory() : Boolean;
      
      function getEnableChargeNowPopUp() : void;
      
      function get enableChargeNowPopUp() : Boolean;
      
      function set enableChargeNowPopUp(param1:Boolean) : void;
      
      function getChargeNowRequest() : void;
      
      function get chargeNowRequest() : Boolean;
      
      function set chargeNowRequest(param1:Boolean) : void;
      
      function sendGetDistnaceValue(param1:String, param2:String, param3:String, param4:String) : void;
      
      function getDistanceValue(param1:String, param2:String, param3:String, param4:String) : Number;
      
      function getHEVLoggingEnabled() : void;
      
      function get HEVLoggingEnabled() : Boolean;
      
      function set HEVLoggingEnabled(param1:Boolean) : void;
      
      function copyHEVLogToUSB() : void;
      
      function deleteHEVLog() : void;
   }
}

