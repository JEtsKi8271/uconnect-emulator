package com.nfuzion.moduleLinkAPI
{
   public interface IHvac extends IModule
   {
      
      function get ZONE_ALL() : String;
      
      function get ZONE_FRONT() : String;
      
      function get ZONE_FRONT_RIGHT() : String;
      
      function get ZONE_FRONT_LEFT() : String;
      
      function get ZONE_REAR() : String;
      
      function get ZONE_REAR_RIGHT() : String;
      
      function get ZONE_REAR_LEFT() : String;
      
      function get VENT_DASH() : String;
      
      function get VENT_FLOOR() : String;
      
      function get VENT_MIX() : String;
      
      function get VENT_DEFROSTER_MIX() : String;
      
      function get VENT_DEFROSTER() : String;
      
      function get VENT_OFF() : String;
      
      function get FAN_OFF() : String;
      
      function get FAN_LO() : String;
      
      function get FAN_HI() : String;
      
      function get FAN_AUTO() : String;
      
      function get FAN_UP() : String;
      
      function get FAN_DOWN() : String;
      
      function get AC_ON() : String;
      
      function get AC_DISABLE() : String;
      
      function get AUTO_ON() : String;
      
      function get AUTO_DISABLE() : String;
      
      function get MAXAC_ON() : String;
      
      function get MAXAC_DISABLE() : String;
      
      function get RECIRC_OFF() : String;
      
      function get RECIRC_ON() : String;
      
      function get RECIRC_DISABLE() : String;
      
      function get RECIRC_SNA() : String;
      
      function get AIRQUALITY_ON() : String;
      
      function get AIRQUALITY_OFF() : String;
      
      function get REAR_DEFROST_OFF() : String;
      
      function get REAR_DEFROST_ON() : String;
      
      function get REAR_DEFROST_DISABLE() : String;
      
      function get REAR_DEFROST_SNA() : String;
      
      function get TEMP_LO() : String;
      
      function get TEMP_HI() : String;
      
      function get TEMP_UNKNOWN() : String;
      
      function get TEMP_SINGLE() : String;
      
      function get TEMP_DUAL() : String;
      
      function get TEMP_UP() : String;
      
      function get TEMP_DOWN() : String;
      
      function get MODE_AC() : String;
      
      function get MODE_MAX_AC() : String;
      
      function get MODE_CLIMATE() : String;
      
      function get MODE_RECIRCULATION() : String;
      
      function get MODE_AUTO() : String;
      
      function get MODE_FRONT_DEFROSTER() : String;
      
      function get MODE_REAR_DEFROSTER() : String;
      
      function get hasRear() : Boolean;
      
      function get hasRearAc() : Boolean;
      
      function get hasAuto() : Boolean;
      
      function get hasSync() : Boolean;
      
      function get frontTempZones() : String;
      
      function get rearTempZones() : String;
      
      function getClimateState() : void;
      
      function isClimateEnabled(param1:String) : Boolean;
      
      function setClimateState(param1:String, param2:Boolean) : void;
      
      function getAcState() : void;
      
      function acState(param1:String) : String;
      
      function setAcState(param1:String, param2:Boolean) : void;
      
      function getMaxAcState() : void;
      
      function maximumAcState(param1:String) : String;
      
      function setMaxAcState(param1:String, param2:Boolean) : void;
      
      function getRecircState() : void;
      
      function recirculationState(param1:String) : String;
      
      function setRecircuState(param1:String, param2:Boolean) : void;
      
      function airQualityState(param1:String) : String;
      
      function getAutoState() : void;
      
      function autoState(param1:String) : String;
      
      function setAutoState(param1:String, param2:Boolean) : void;
      
      function getDefrosterState() : void;
      
      function isDefrosterEnabled(param1:String) : Boolean;
      
      function rearDefrosterState() : String;
      
      function setDefrosterState(param1:String, param2:Boolean) : void;
      
      function getLockState() : void;
      
      function isLockEnabled(param1:String) : Boolean;
      
      function setLockState(param1:String, param2:Boolean) : void;
      
      function getSyncState() : void;
      
      function get isSyncEnabled() : Boolean;
      
      function get isRearSyncEnabled() : Boolean;
      
      function setSyncState(param1:String, param2:Boolean) : void;
      
      function getVentMode() : void;
      
      function ventMode(param1:String) : String;
      
      function setVentMode(param1:String, param2:String, param3:Boolean) : void;
      
      function getFanSpeed() : void;
      
      function fanSpeed(param1:String) : String;
      
      function setFanSpeed(param1:String, param2:String) : void;
      
      function setFanSpeedIncrement(param1:String, param2:String, param3:Boolean) : void;
      
      function getZoneTemp() : void;
      
      function zoneTemp(param1:String) : String;
      
      function setZoneTemp(param1:String, param2:String) : void;
      
      function setZoneTempIncrement(param1:String, param2:String, param3:Boolean) : void;
      
      function getRear() : void;
   }
}

