package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.HEVEvent;
   import com.harman.moduleLinkAPI.IHEV;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class HEV extends Module implements IHEV
   {
      
      private static var instance:HEV;
      
      private static const mDbusIdentifier:String = "HEV";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiSetProperties:String = "setProperties";
      
      private static const dBusApiGetLoggingConfig:String = "getHEVLoggingConfig";
      
      private static const dBusApiSetLoggingConfig:String = "configureHEVLogging";
      
      private static const dBusApiCopyLogToUSB:String = "copyHEVLogToUSB";
      
      private static const dBusApiDeleteLog:String = "deleteHEVLog";
      
      private static const dBusSignalHybridElectricMode:String = "hybridElectricMode";
      
      private static const dBusSignalHVBatteryChargeDisp:String = "HVBatteryChargeDisp";
      
      private static const dBusSignalHVBatteryChargeValidity:String = "HVBatteryChargeValidity";
      
      private static const dBusSignalBatteryPowerUsage:String = "batteryPowerUsage";
      
      private static const dBusSignalEnginePowerUsage:String = "enginePowerUsage";
      
      private static const dBusSignalHVACPowerUsage:String = "HVACPowerUsage";
      
      private static const dBusSignalEstimatedElectricRange:String = "estimatedElectricRange";
      
      private static const dBusSignalChargingSystemStatus:String = "chargingSystemStatus";
      
      private static const dBusSignalWheelPowerFlowState:String = "wheelPowerFlowState";
      
      private static const dBusSignalEngToBatPowerFlowState:String = "engToBatPowerFlowState";
      
      private static const dBusSignalHVACPowerFlowState:String = "HVACPowerFlowState";
      
      private static const dBusSignalBatteryIconState:String = "batteryIconState";
      
      private static const dBusSignalEngineIconState:String = "engineIconState";
      
      private static const dBusSignalMotorIconState:String = "motorIconState";
      
      private static const dBusSignalChargeMinutesLv1:String = "chargeMinutesLv1";
      
      private static const dBusSignalChargeHoursLv1:String = "chargeHoursLv1";
      
      private static const dBusSignalChargeMinutesLv2:String = "chargeMinutesLv2";
      
      private static const dBusSignalChargeHoursLv2:String = "chargeHoursLv2";
      
      private static const dBusSignalPlugInStatus:String = "plugInStatus";
      
      private static const dBusSignalWeekendMinuteStart:String = "weekendMinuteStart";
      
      private static const dBusSignalWeekendMinuteEnd:String = "weekendMinuteEnd";
      
      private static const dBusSignalWeekendHourStart:String = "weekendHourStart";
      
      private static const dBusSignalWeekendHourEnd:String = "weekendHourEnd";
      
      private static const dBusSignalWeekdayMinuteStart:String = "weekdayMinuteStart";
      
      private static const dBusSignalWeekdayMinuteEnd:String = "weekdayMinuteEnd";
      
      private static const dBusSignalWeekdayHourStart:String = "weekdayHourStart";
      
      private static const dBusSignalWeekdayHourEnd:String = "weekdayHourEnd";
      
      private static const dBusSignalChargeDateTimeFormat:String = "chargeDateTimeFormat";
      
      private static const dBusSignalChargeRequestStatus:String = "chargeRequestStatus";
      
      private static const dBusSignalEnableChargeSchedule:String = "enableChargeSchedule";
      
      private static const dBusSignalCurrentDayIsWeekday:String = "currentDayIsWeekday";
      
      private static const dBusSignalChargeUntilFullWeekend:String = "chargeUntilFullWeekend";
      
      private static const dBusSignalChargeUntilFullWeekday:String = "chargeUntilFullWeekday";
      
      private static const dBusSignalDisplayDrivingHistory:String = "displayDrivingHistory";
      
      private static const dBusSignalEnableChargeNowPopUp:String = "enableChargeNowPopUp";
      
      private static const dBusSignalChargeNowRequest:String = "chargeNowRequest";
      
      private static const dBusSignalHybridMIWk1D0:String = "hybridMI_Wk1_D0";
      
      private static const dBusSignalHybridMIWk1D1:String = "hybridMI_Wk1_D1";
      
      private static const dBusSignalHybridMIWk1D2:String = "hybridMI_Wk1_D2";
      
      private static const dBusSignalHybridMIWk1D3:String = "hybridMI_Wk1_D3";
      
      private static const dBusSignalHybridMIWk1D4:String = "hybridMI_Wk1_D4";
      
      private static const dBusSignalHybridMIWk1D5:String = "hybridMI_Wk1_D5";
      
      private static const dBusSignalHybridMIWk1D6:String = "hybridMI_Wk1_D6";
      
      private static const dBusSignalHybridMIWk2D0:String = "hybridMI_Wk2_D0";
      
      private static const dBusSignalHybridMIWk2D1:String = "hybridMI_Wk2_D1";
      
      private static const dBusSignalHybridMIWk2D2:String = "hybridMI_Wk2_D2";
      
      private static const dBusSignalHybridMIWk2D3:String = "hybridMI_Wk2_D3";
      
      private static const dBusSignalHybridMIWk2D4:String = "hybridMI_Wk2_D4";
      
      private static const dBusSignalHybridMIWk2D5:String = "hybridMI_Wk2_D5";
      
      private static const dBusSignalHybridMIWk2D6:String = "hybridMI_Wk2_D6";
      
      private static const dBusSignalHybridKMWk1D0:String = "hybridKM_Wk1_D0";
      
      private static const dBusSignalHybridKMWk1D1:String = "hybridKM_Wk1_D1";
      
      private static const dBusSignalHybridKMWk1D2:String = "hybridKM_Wk1_D2";
      
      private static const dBusSignalHybridKMWk1D3:String = "hybridKM_Wk1_D3";
      
      private static const dBusSignalHybridKMWk1D4:String = "hybridKM_Wk1_D4";
      
      private static const dBusSignalHybridKMWk1D5:String = "hybridKM_Wk1_D5";
      
      private static const dBusSignalHybridKMWk1D6:String = "hybridKM_Wk1_D6";
      
      private static const dBusSignalHybridKMWk2D0:String = "hybridKM_Wk2_D0";
      
      private static const dBusSignalHybridKMWk2D1:String = "hybridKM_Wk2_D1";
      
      private static const dBusSignalHybridKMWk2D2:String = "hybridKM_Wk2_D2";
      
      private static const dBusSignalHybridKMWk2D3:String = "hybridKM_Wk2_D3";
      
      private static const dBusSignalHybridKMWk2D4:String = "hybridKM_Wk2_D4";
      
      private static const dBusSignalHybridKMWk2D5:String = "hybridKM_Wk2_D5";
      
      private static const dBusSignalHybridKMWk2D6:String = "hybridKM_Wk2_D6";
      
      private static const dBusSignalElectricMIWk1D0:String = "electricMI_Wk1_D0";
      
      private static const dBusSignalElectricMIWk1D1:String = "electricMI_Wk1_D1";
      
      private static const dBusSignalElectricMIWk1D2:String = "electricMI_Wk1_D2";
      
      private static const dBusSignalElectricMIWk1D3:String = "electricMI_Wk1_D3";
      
      private static const dBusSignalElectricMIWk1D4:String = "electricMI_Wk1_D4";
      
      private static const dBusSignalElectricMIWk1D5:String = "electricMI_Wk1_D5";
      
      private static const dBusSignalElectricMIWk1D6:String = "electricMI_Wk1_D6";
      
      private static const dBusSignalElectricMIWk2D0:String = "electricMI_Wk2_D0";
      
      private static const dBusSignalElectricMIWk2D1:String = "electricMI_Wk2_D1";
      
      private static const dBusSignalElectricMIWk2D2:String = "electricMI_Wk2_D2";
      
      private static const dBusSignalElectricMIWk2D3:String = "electricMI_Wk2_D3";
      
      private static const dBusSignalElectricMIWk2D4:String = "electricMI_Wk2_D4";
      
      private static const dBusSignalElectricMIWk2D5:String = "electricMI_Wk2_D5";
      
      private static const dBusSignalElectricMIWk2D6:String = "electricMI_Wk2_D6";
      
      private static const dBusSignalElectricKMWk1D0:String = "electricKM_Wk1_D0";
      
      private static const dBusSignalElectricKMWk1D1:String = "electricKM_Wk1_D1";
      
      private static const dBusSignalElectricKMWk1D2:String = "electricKM_Wk1_D2";
      
      private static const dBusSignalElectricKMWk1D3:String = "electricKM_Wk1_D3";
      
      private static const dBusSignalElectricKMWk1D4:String = "electricKM_Wk1_D4";
      
      private static const dBusSignalElectricKMWk1D5:String = "electricKM_Wk1_D5";
      
      private static const dBusSignalElectricKMWk1D6:String = "electricKM_Wk1_D6";
      
      private static const dBusSignalElectricKMWk2D0:String = "electricKM_Wk2_D0";
      
      private static const dBusSignalElectricKMWk2D1:String = "electricKM_Wk2_D1";
      
      private static const dBusSignalElectricKMWk2D2:String = "electricKM_Wk2_D2";
      
      private static const dBusSignalElectricKMWk2D3:String = "electricKM_Wk2_D3";
      
      private static const dBusSignalElectricKMWk2D4:String = "electricKM_Wk2_D4";
      
      private static const dBusSignalElectricKMWk2D5:String = "electricKM_Wk2_D5";
      
      private static const dBusSignalElectricKMWk2D6:String = "electricKM_Wk2_D6";
      
      private static const dBusSignalExtLoggingLevel:String = "externalLoggingDebugLevel";
      
      private static const dBusSignalReady:String = "ready";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mReady:Boolean = false;
      
      private var mProperties:Dictionary = new Dictionary();
      
      private var mServiceAvailable:Boolean;
      
      public function HEV()
      {
         super();
         this.setUpPropertiesTable();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.onConnected);
         if(this.client.connected)
         {
            this.onConnected();
         }
         this.connection.addEventListener(ConnectionEvent.HEV,this.onMessageHandler);
      }
      
      public function getInstance() : HEV
      {
         if(instance == null)
         {
            instance = new HEV();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getHEVLoggingConfig\": {}}}");
      }
      
      public function getHybridElectricModeStatus() : void
      {
         this.sendGetProperties([dBusSignalHybridElectricMode]);
      }
      
      public function get hybridElectricModeStatus() : String
      {
         return this.mProperties[dBusSignalHybridElectricMode].value;
      }
      
      public function getHVBatteryChargeDisp() : void
      {
         this.sendGetProperties([dBusSignalHVBatteryChargeDisp]);
      }
      
      public function get HVBatterChargeDisp() : Number
      {
         return this.mProperties[dBusSignalHVBatteryChargeDisp].value;
      }
      
      public function getHVBatteryChargeValidity() : void
      {
         this.sendGetProperties([dBusSignalHVBatteryChargeValidity]);
      }
      
      public function get HVBatteryChargeValidity() : String
      {
         return this.mProperties[dBusSignalHVBatteryChargeValidity].value;
      }
      
      public function getBatteryPowerUsage() : void
      {
         this.sendGetProperties([dBusSignalBatteryPowerUsage]);
      }
      
      public function get batteryPowerUsage() : String
      {
         return this.mProperties[dBusSignalBatteryPowerUsage].value;
      }
      
      public function getEnginePowerUsage() : void
      {
         this.sendGetProperties([dBusSignalEnginePowerUsage]);
      }
      
      public function get enginePowerUsage() : String
      {
         return this.mProperties[dBusSignalEnginePowerUsage].value;
      }
      
      public function getHVACPowerUsage() : void
      {
         this.sendGetProperties([dBusSignalHVACPowerUsage]);
      }
      
      public function get HVACPowerUsage() : String
      {
         return this.mProperties[dBusSignalHVACPowerUsage].value;
      }
      
      public function getEstimatedElectricRange() : void
      {
         this.sendGetProperties([dBusSignalEstimatedElectricRange]);
      }
      
      public function get estimatedElectricRange() : Number
      {
         return this.mProperties[dBusSignalEstimatedElectricRange].value;
      }
      
      public function getChargingSystemStatus() : void
      {
         this.sendGetProperties([dBusSignalChargingSystemStatus]);
      }
      
      public function get chargingSystemStatus() : String
      {
         return this.mProperties[dBusSignalChargingSystemStatus].value;
      }
      
      public function getWheelPowerFlowState() : void
      {
         this.sendGetProperties([dBusSignalWheelPowerFlowState]);
      }
      
      public function get wheelPowerFlowState() : String
      {
         return this.mProperties[dBusSignalWheelPowerFlowState].value;
      }
      
      public function getEngToBatPowerFlowState() : void
      {
         this.sendGetProperties([dBusSignalEngToBatPowerFlowState]);
      }
      
      public function get engToBatPowerFlowState() : String
      {
         return this.mProperties[dBusSignalEngToBatPowerFlowState].value;
      }
      
      public function getHVACPowerFlowState() : void
      {
         this.sendGetProperties([dBusSignalHVACPowerFlowState]);
      }
      
      public function get HVACPowerFlowState() : String
      {
         return this.mProperties[dBusSignalHVACPowerFlowState].value;
      }
      
      public function getBatteryIconState() : void
      {
         this.sendGetProperties([dBusSignalBatteryIconState]);
      }
      
      public function get batteryIconState() : String
      {
         return this.mProperties[dBusSignalBatteryIconState].value;
      }
      
      public function getEngineIconState() : void
      {
         this.sendGetProperties([dBusSignalEngineIconState]);
      }
      
      public function get engineIconState() : String
      {
         return this.mProperties[dBusSignalEngineIconState].value;
      }
      
      public function getMotorIconState() : void
      {
         this.sendGetProperties([dBusSignalMotorIconState]);
      }
      
      public function get motorIconState() : String
      {
         return this.mProperties[dBusSignalMotorIconState].value;
      }
      
      public function getChargeMinutesLv1() : void
      {
         this.sendGetProperties([dBusSignalChargeMinutesLv1]);
      }
      
      public function get chargeMinutesLv1() : String
      {
         return this.mProperties[dBusSignalChargeMinutesLv1].value;
      }
      
      public function getChargeHoursLv1() : void
      {
         this.sendGetProperties([dBusSignalChargeHoursLv1]);
      }
      
      public function get chargeHoursLv1() : String
      {
         return this.mProperties[dBusSignalChargeHoursLv1].value;
      }
      
      public function getChargeMinutesLv2() : void
      {
         this.sendGetProperties([dBusSignalChargeMinutesLv2]);
      }
      
      public function get chargeMinutesLv2() : String
      {
         return this.mProperties[dBusSignalChargeMinutesLv2].value;
      }
      
      public function getChargeHoursLv2() : void
      {
         this.sendGetProperties([dBusSignalChargeHoursLv2]);
      }
      
      public function get chargeHoursLv2() : String
      {
         return this.mProperties[dBusSignalChargeHoursLv2].value;
      }
      
      public function getPlugInStatus() : void
      {
         this.sendGetProperties([dBusSignalPlugInStatus]);
      }
      
      public function get plugInStatus() : String
      {
         return this.mProperties[dBusSignalPlugInStatus].value;
      }
      
      public function getWeekendMinuteStart() : void
      {
         this.sendGetProperties([dBusSignalWeekendMinuteStart]);
      }
      
      public function get weekendMinuteStart() : String
      {
         return this.mProperties[dBusSignalWeekendMinuteStart].value;
      }
      
      public function set weekendMinuteStart(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekendMinuteStart,this.mProperties[dBusSignalWeekendMinuteStart].convert(val));
         this.mProperties[dBusSignalWeekendMinuteStart].value = val;
      }
      
      public function getWeekendMinuteEnd() : void
      {
         this.sendGetProperties([dBusSignalWeekendMinuteEnd]);
      }
      
      public function get weekendMinuteEnd() : String
      {
         return this.mProperties[dBusSignalWeekendMinuteEnd].value;
      }
      
      public function set weekendMinuteEnd(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekendMinuteEnd,this.mProperties[dBusSignalWeekendMinuteEnd].convert(val));
         this.mProperties[dBusSignalWeekendMinuteEnd].value = val;
      }
      
      public function getWeekendHourStart() : void
      {
         this.sendGetProperties([dBusSignalWeekendHourStart]);
      }
      
      public function get weekendHourStart() : String
      {
         return this.mProperties[dBusSignalWeekendHourStart].value;
      }
      
      public function set weekendHourStart(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekendHourStart,val);
         this.mProperties[dBusSignalWeekendHourStart].value = val;
      }
      
      public function getWeekendHourEnd() : void
      {
         this.sendGetProperties([dBusSignalWeekendHourEnd]);
      }
      
      public function get weekendHourEnd() : String
      {
         return this.mProperties[dBusSignalWeekendHourEnd].value;
      }
      
      public function set weekendHourEnd(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekendHourEnd,val);
         this.mProperties[dBusSignalWeekendHourEnd].value = val;
      }
      
      public function getWeekdayMinuteStart() : void
      {
         this.sendGetProperties([dBusSignalWeekdayMinuteStart]);
      }
      
      public function get weekdayMinuteStart() : String
      {
         return this.mProperties[dBusSignalWeekdayMinuteStart].value;
      }
      
      public function set weekdayMinuteStart(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekdayMinuteStart,this.mProperties[dBusSignalWeekdayMinuteStart].convert(val));
         this.mProperties[dBusSignalWeekdayMinuteStart].value = val;
      }
      
      public function getWeekdayMinuteEnd() : void
      {
         this.sendGetProperties([dBusSignalWeekdayMinuteEnd]);
      }
      
      public function get weekdayMinuteEnd() : String
      {
         return this.mProperties[dBusSignalWeekdayMinuteEnd].value;
      }
      
      public function set weekdayMinuteEnd(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekdayMinuteEnd,this.mProperties[dBusSignalWeekdayMinuteEnd].convert(val));
         this.mProperties[dBusSignalWeekdayMinuteEnd].value = val;
      }
      
      public function getWeekdayHourStart() : void
      {
         this.sendGetProperties([dBusSignalWeekdayHourStart]);
      }
      
      public function get weekdayHourStart() : String
      {
         return this.mProperties[dBusSignalWeekdayHourStart].value;
      }
      
      public function set weekdayHourStart(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekdayHourStart,val);
         this.mProperties[dBusSignalWeekdayHourStart].value = val;
      }
      
      public function getWeekdayHourEnd() : void
      {
         this.sendGetProperties([dBusSignalWeekdayHourEnd]);
      }
      
      public function get weekdayHourEnd() : String
      {
         return this.mProperties[dBusSignalWeekdayHourEnd].value;
      }
      
      public function set weekdayHourEnd(val:String) : void
      {
         this.sendSetProperties(dBusSignalWeekdayHourEnd,val);
         this.mProperties[dBusSignalWeekdayHourEnd].value = val;
      }
      
      public function getChargeDateTimeFormat() : void
      {
         this.sendGetProperties([dBusSignalChargeDateTimeFormat]);
      }
      
      public function get chargeDateTimeFormat() : String
      {
         return this.mProperties[dBusSignalChargeDateTimeFormat].value;
      }
      
      public function set chargeDateTimeFormat(val:String) : void
      {
         this.sendSetProperties(dBusSignalChargeDateTimeFormat,val);
         this.mProperties[dBusSignalChargeDateTimeFormat].value = val;
      }
      
      public function getChargeRequestStatus() : void
      {
         this.sendGetProperties([dBusSignalChargeRequestStatus]);
      }
      
      public function get chargeRequestStatus() : String
      {
         return this.mProperties[dBusSignalChargeRequestStatus].value;
      }
      
      public function set chargeRequestStatus(val:String) : void
      {
         this.sendSetProperties(dBusSignalChargeRequestStatus,val);
         this.mProperties[dBusSignalChargeRequestStatus].value = val;
      }
      
      public function getEnableChargeSchedule() : void
      {
         this.sendGetProperties([dBusSignalEnableChargeSchedule]);
      }
      
      public function get enableChargeSchedule() : Boolean
      {
         return this.mProperties[dBusSignalEnableChargeSchedule].value;
      }
      
      public function set enableChargeSchedule(val:Boolean) : void
      {
         this.sendSetProperties(dBusSignalEnableChargeSchedule,val);
         this.mProperties[dBusSignalEnableChargeSchedule].value = val;
      }
      
      public function getCurrentDayIsWeekday() : void
      {
         this.sendGetProperties([dBusSignalCurrentDayIsWeekday]);
      }
      
      public function get currentDayIsWeekday() : Boolean
      {
         return this.mProperties[dBusSignalCurrentDayIsWeekday].value;
      }
      
      public function getChargeUntilFullWeekday() : void
      {
         this.sendGetProperties([dBusSignalChargeUntilFullWeekday]);
      }
      
      public function get chargeUntilFullWeekday() : Boolean
      {
         return this.mProperties[dBusSignalChargeUntilFullWeekday].value;
      }
      
      public function set chargeUntilFullWeekday(val:Boolean) : void
      {
         this.sendSetProperties(dBusSignalChargeUntilFullWeekday,val);
         this.mProperties[dBusSignalChargeUntilFullWeekday].value = val;
      }
      
      public function getChargeUntilFullWeekend() : void
      {
         this.sendGetProperties([dBusSignalChargeUntilFullWeekend]);
      }
      
      public function get chargeUntilFullWeekend() : Boolean
      {
         return this.mProperties[dBusSignalChargeUntilFullWeekend].value;
      }
      
      public function set chargeUntilFullWeekend(val:Boolean) : void
      {
         this.sendSetProperties(dBusSignalChargeUntilFullWeekend,val);
         this.mProperties[dBusSignalChargeUntilFullWeekend].value = val;
      }
      
      public function getDisplayDrivingHistory() : void
      {
         this.sendGetProperties([dBusSignalDisplayDrivingHistory]);
      }
      
      public function get displayDrivingHistory() : Boolean
      {
         return this.mProperties[dBusSignalDisplayDrivingHistory].value;
      }
      
      public function getEnableChargeNowPopUp() : void
      {
         this.sendGetProperties([dBusSignalEnableChargeNowPopUp]);
      }
      
      public function get enableChargeNowPopUp() : Boolean
      {
         return this.mProperties[dBusSignalEnableChargeNowPopUp].value;
      }
      
      public function set enableChargeNowPopUp(val:Boolean) : void
      {
         this.sendSetProperties(dBusSignalEnableChargeNowPopUp,val);
         this.mProperties[dBusSignalEnableChargeNowPopUp].value = val;
      }
      
      public function getChargeNowRequest() : void
      {
         this.sendGetProperties([dBusSignalChargeNowRequest]);
      }
      
      public function get chargeNowRequest() : Boolean
      {
         return this.mProperties[dBusSignalChargeNowRequest].value;
      }
      
      public function set chargeNowRequest(val:Boolean) : void
      {
         this.sendSetProperties(dBusSignalChargeNowRequest,val);
         this.mProperties[dBusSignalChargeNowRequest].value = val;
      }
      
      public function sendGetDistnaceValue(type:String, unit:String, wkNum:String, dayNum:String) : void
      {
         var propKey:String = type.toLowerCase() + unit.toUpperCase() + "_Wk" + wkNum + "_D" + dayNum;
         this.sendGetProperties([propKey]);
      }
      
      public function getDistanceValue(type:String, unit:String, wkNum:String, dayNum:String) : Number
      {
         var propKey:String = type.toLowerCase() + unit.toUpperCase() + "_Wk" + wkNum + "_D" + dayNum;
         return this.mProperties[propKey].value;
      }
      
      public function getHEVLoggingEnabled() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + dBusApiGetLoggingConfig + "\": {}}}");
      }
      
      public function get HEVLoggingEnabled() : Boolean
      {
         return this.mProperties[dBusSignalExtLoggingLevel].value != "OFF";
      }
      
      public function set HEVLoggingEnabled(state:Boolean) : void
      {
         if(state)
         {
            this.mProperties[dBusSignalExtLoggingLevel].value = "LEVEL_3";
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + dBusApiSetLoggingConfig + "\": {\"debugConfig\":\"LEVEL_3\"}}}");
         }
         else
         {
            this.mProperties[dBusSignalExtLoggingLevel].value = "OFF";
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + dBusApiSetLoggingConfig + "\": {\"debugConfig\":\"OFF\"}}}");
         }
      }
      
      public function copyHEVLogToUSB() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + dBusApiCopyLogToUSB + "\": {}}}");
      }
      
      public function deleteHEVLog() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + dBusApiDeleteLog + "\": {}}}");
      }
      
      private function onConnected(event:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.sendMultiSubscribe(this.mProperties);
         }
         this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
      }
      
      private function onMessageHandler(event:ConnectionEvent) : void
      {
         var obj:Object = null;
         var resp:Object = event.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mServiceAvailable == false)
            {
               this.mServiceAvailable = true;
               this.sendGetProperties([dBusSignalReady]);
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mServiceAvailable = false;
            }
         }
         else if(resp.hasOwnProperty(dBusApiGetAllProperties))
         {
            this.processProperties(resp[dBusApiGetAllProperties]);
         }
         else if(resp.hasOwnProperty(dBusApiGetLoggingConfig))
         {
            this.processProperties(resp[dBusApiGetLoggingConfig]);
         }
         else if(resp.hasOwnProperty(dBusApiGetProperties))
         {
            this.processProperties(resp[dBusApiGetProperties]);
         }
         else
         {
            for(obj in resp)
            {
               this.processProperties(resp[obj]);
            }
         }
      }
      
      private function setUpPropertiesTable() : void
      {
         this.mProperties[dBusSignalReady] = {
            "value":null,
            "convert":this.readyFlagConversion,
            "event":null
         };
         this.mProperties[dBusSignalHybridElectricMode] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.HE_MODE_UPDATE
         };
         this.mProperties[dBusSignalHVBatteryChargeDisp] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.BATT_PERCENT_UPDATE
         };
         this.mProperties[dBusSignalHVBatteryChargeValidity] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.BATT_PERCENT_UPDATE
         };
         this.mProperties[dBusSignalBatteryPowerUsage] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.BATT_PWR_UPDATE
         };
         this.mProperties[dBusSignalEnginePowerUsage] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.ENG_PWR_UPDATE
         };
         this.mProperties[dBusSignalHVACPowerUsage] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.HVAC_PWR_UPDATE
         };
         this.mProperties[dBusSignalEstimatedElectricRange] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.ELECTRIC_RANGE_UPDATE
         };
         this.mProperties[dBusSignalChargingSystemStatus] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.CHRG_SYS_STATUS_UPDATE
         };
         this.mProperties[dBusSignalWheelPowerFlowState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.WHL_PWR_FLW_STATE_UPDATE
         };
         this.mProperties[dBusSignalEngToBatPowerFlowState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.ENG_TO_BAT_PWR_FLW_STATE_UPDATE
         };
         this.mProperties[dBusSignalHVACPowerFlowState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.HVAC_PWR_FLW_STATE_UPDATE
         };
         this.mProperties[dBusSignalBatteryIconState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.BAT_ICON_STATE_UPDATE
         };
         this.mProperties[dBusSignalEngineIconState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.ENG_ICON_STATE_UPDATE
         };
         this.mProperties[dBusSignalMotorIconState] = {
            "value":"off",
            "convert":null,
            "event":HEVEvent.MTR_ICON_STATE_UPDATE
         };
         this.mProperties[dBusSignalChargeMinutesLv1] = {
            "value":"--",
            "convert":this.convertObjToStr,
            "event":HEVEvent.CHRG_MIN_LV1_UPDATE
         };
         this.mProperties[dBusSignalChargeHoursLv1] = {
            "value":"--",
            "convert":this.convertObjToStr,
            "event":HEVEvent.CHRG_HR_LV1_UPDATE
         };
         this.mProperties[dBusSignalChargeMinutesLv2] = {
            "value":"--",
            "convert":this.convertObjToStr,
            "event":HEVEvent.CHRG_MIN_LV2_UPDATE
         };
         this.mProperties[dBusSignalChargeHoursLv2] = {
            "value":"--",
            "convert":this.convertObjToStr,
            "event":HEVEvent.CHRG_HR_LV2_UPDATE
         };
         this.mProperties[dBusSignalPlugInStatus] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.PLUG_IN_STATUS_UPDATE
         };
         this.mProperties[dBusSignalEnableChargeSchedule] = {
            "value":"false",
            "convert":null,
            "event":HEVEvent.ENABLE_CHRG_SCHED_UPDATE
         };
         this.mProperties[dBusSignalCurrentDayIsWeekday] = {
            "value":false,
            "convert":null,
            "event":HEVEvent.CRNT_DAY_WKDAY_FLAG_UPDATE
         };
         this.mProperties[dBusSignalChargeUntilFullWeekday] = {
            "value":"false",
            "convert":null,
            "event":HEVEvent.CHRG_FULL_WKDAY_UPDATE
         };
         this.mProperties[dBusSignalChargeUntilFullWeekend] = {
            "value":"false",
            "convert":null,
            "event":HEVEvent.CHRG_FULL_WKEND_UPDATE
         };
         this.mProperties[dBusSignalDisplayDrivingHistory] = {
            "value":false,
            "convert":null,
            "event":HEVEvent.DISP_DRV_HISTORY_UPDATE
         };
         this.mProperties[dBusSignalEnableChargeNowPopUp] = {
            "value":false,
            "convert":null,
            "event":HEVEvent.ENBL_CHRG_NOW_POPUP_UPDATE
         };
         this.mProperties[dBusSignalChargeNowRequest] = {
            "value":false,
            "convert":null,
            "event":null
         };
         this.mProperties[dBusSignalHybridMIWk1D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D0_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D1_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D2_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D3_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D4_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D5_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk1D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK1_D6_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D0_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D1_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D2_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D3_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D4_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D5_UDPATE
         };
         this.mProperties[dBusSignalHybridMIWk2D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_MI_WK2_D6_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D0_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D1_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D2_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D3_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D4_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D5_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk1D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK1_D6_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D0_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D1_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D2_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D3_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D4_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D5_UDPATE
         };
         this.mProperties[dBusSignalHybridKMWk2D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.HYBRID_KM_WK2_D6_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D0_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D1_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D2_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D3_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D4_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D5_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk1D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK1_D6_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D0_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D1_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D2_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D3_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D4_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D5_UDPATE
         };
         this.mProperties[dBusSignalElectricMIWk2D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_MI_WK2_D6_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D0_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D1_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D2_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D3_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D4_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D5_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk1D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK1_D6_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D0] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D0_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D1] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D1_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D2] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D2_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D3] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D3_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D4] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D4_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D5] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D5_UDPATE
         };
         this.mProperties[dBusSignalElectricKMWk2D6] = {
            "value":0,
            "convert":null,
            "event":HEVEvent.ELECTRIC_KM_WK2_D6_UDPATE
         };
         this.mProperties[dBusSignalWeekendMinuteStart] = {
            "value":"--",
            "convert":this.convertChargeMinutes,
            "event":HEVEvent.WKEND_MIN_STRT_UPDATE
         };
         this.mProperties[dBusSignalWeekendMinuteEnd] = {
            "value":"--",
            "convert":this.convertChargeMinutes,
            "event":HEVEvent.WKEND_MIN_END_UPDATE
         };
         this.mProperties[dBusSignalWeekendHourStart] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.WKEND_HR_STRT_UPDATE
         };
         this.mProperties[dBusSignalWeekendHourEnd] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.WKEND_HR_END_UPDATE
         };
         this.mProperties[dBusSignalWeekdayMinuteStart] = {
            "value":"--",
            "convert":this.convertChargeMinutes,
            "event":HEVEvent.WKDAY_MIN_STRT_UPDATE
         };
         this.mProperties[dBusSignalWeekdayMinuteEnd] = {
            "value":"--",
            "convert":this.convertChargeMinutes,
            "event":HEVEvent.WKDAY_MIN_END_UPDATE
         };
         this.mProperties[dBusSignalWeekdayHourStart] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.WKDAY_HR_STRT_UPDATE
         };
         this.mProperties[dBusSignalWeekdayHourEnd] = {
            "value":"--",
            "convert":null,
            "event":HEVEvent.WKDAY_HR_END_UPDATE
         };
         this.mProperties[dBusSignalChargeDateTimeFormat] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.CHRG_DT_TM_FORMAT_UPDATE
         };
         this.mProperties[dBusSignalChargeRequestStatus] = {
            "value":null,
            "convert":null,
            "event":HEVEvent.CHRG_REQ_STATUS_UPDATE
         };
         this.mProperties[dBusSignalExtLoggingLevel] = {
            "value":"OFF",
            "convert":null,
            "event":HEVEvent.EXT_LOGGING_LEVEL_UPDATE
         };
      }
      
      private function processProperties(message:Object) : void
      {
         var Signal:Object = null;
         for(Signal in message)
         {
            if(this.mProperties[Signal])
            {
               if(this.mProperties[Signal].convert == null)
               {
                  this.mProperties[Signal].value = message[Signal];
               }
               else
               {
                  this.mProperties[Signal].value = this.mProperties[Signal].convert(message[Signal]);
               }
               if(this.mProperties[Signal].event != null)
               {
                  this.dispatchEvent(new HEVEvent(this.mProperties[Signal].event));
               }
            }
         }
      }
      
      private function readyFlagConversion(val:String) : Boolean
      {
         if(!this.mReady && val == "true")
         {
            this.getAll();
         }
         this.mReady = val == "true";
         return this.mReady;
      }
      
      private function convertObjToStr(val:Object) : String
      {
         return String(val);
      }
      
      private function convertChargeMinutes(minutes:String) : String
      {
         switch(minutes)
         {
            case "ZERO":
               return "00";
            case "FIFTEEN":
               return "15";
            case "THIRTY":
               return "30";
            case "FOURTY_FIVE":
               return "45";
            case "00":
               return "ZERO";
            case "15":
               return "FIFTEEN";
            case "30":
               return "THIRTY";
            case "45":
               return "FOURTY_FIVE";
            default:
               return minutes;
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mDbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Dictionary) : void
      {
         var message:String = null;
         var i:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signals\": [";
         for(i in signalsArray)
         {
            message = message + "\"" + i + "\"";
            message += ",";
         }
         message = message.substr(0,message.length - 1);
         message += "]}";
         this.client.send(message);
      }
      
      private function sendGetProperties(props:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"getProperties\": {\"props\": ["; i < props.length; )
         {
            message = message + "\"" + props[i] + "\"";
            if(props[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}}}";
         this.client.send(message);
      }
      
      private function sendSetProperties(prop:String, val:*) : void
      {
         if(val is String)
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"setProperties\": { \"props\": {\"" + prop + "\": \"" + val + "\"}}}}");
         }
         else
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"setProperties\": { \"props\": {\"" + prop + "\": " + val + "}}}}");
         }
      }
   }
}

