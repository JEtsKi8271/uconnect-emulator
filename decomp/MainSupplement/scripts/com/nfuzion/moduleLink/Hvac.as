package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.HvacEvent;
   import com.nfuzion.moduleLinkAPI.IHvac;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Hvac extends Module implements IHvac
   {
      
      private static var instance:Hvac;
      
      private static const IS_TEST:Boolean = false;
      
      private static const sVENT_DASH:String = "vent";
      
      private static const sVENT_FLOOR:String = "floor";
      
      private static const sVENT_MIX:String = "mix";
      
      private static const sVENT_DMIX:String = "defrostMix";
      
      private static const sVENT_DEFROSTER:String = "defrost";
      
      private static const sVENT_ON:String = "on";
      
      private static const sVENT_OFF:String = "off";
      
      private static const sZONE_ALL:String = "all";
      
      private static const sZONE_FRONT:String = "front";
      
      private static const sZONE_FRONT_RIGHT:String = "frontRight";
      
      private static const sZONE_FRONT_LEFT:String = "frontLeft";
      
      private static const sZONE_REAR:String = "rear";
      
      private static const sZONE_REAR_RIGHT:String = "rearRight";
      
      private static const sZONE_REAR_LEFT:String = "rearLeft";
      
      private static const sFAN_OFF:String = "off";
      
      private static const sFAN_LO:String = "lo";
      
      private static const sFAN_HI:String = "hi";
      
      private static const sFAN_AUTO:String = "auto";
      
      private static const sAC_OFF:String = "off";
      
      private static const sAC_ON:String = "on";
      
      private static const sAC_DISABLE:String = "disable";
      
      private static const sAUTO_OFF:String = "off";
      
      private static const sAUTO_ON:String = "on";
      
      private static const sAUTO_DISABLE:String = "disable";
      
      private static const sMAXAC_OFF:String = "off";
      
      private static const sMAXAC_ON:String = "on";
      
      private static const sMAXAC_DISABLE:String = "disable";
      
      private static const sRECIRC_OFF:String = "off";
      
      private static const sRECIRC_ON:String = "on";
      
      private static const sRECIRC_DISABLE:String = "disable";
      
      private static const sRECIRC_SNA:String = "SNA";
      
      private static const sAIRQUALITY_OFF:String = "off";
      
      private static const sAIRQUALITY_ON:String = "on";
      
      private static const sREAR_DEFROST_OFF:String = "off";
      
      private static const sREAR_DEFROST_ON:String = "on";
      
      private static const sREAR_DEFROST_DISABLE:String = "disable";
      
      private static const sREAR_DEFROST_SNA:String = "SNA";
      
      private static const sTEMP_UNKNOWN:String = "--";
      
      private static const sTEMP_LO:String = "lo";
      
      private static const sTEMP_HI:String = "hi";
      
      private static const sTEMP_AUTO:String = "auto";
      
      private static const sTEMP_SINGLE:String = "single";
      
      private static const sTEMP_DUAL:String = "dual";
      
      private static const sMODE_AC:String = "ac";
      
      private static const sMODE_MAX_AC:String = "maxAC";
      
      private static const sMODE_CLIMATE:String = "climate";
      
      private static const sMODE_RECIRCULATION:String = "recirc";
      
      private static const sMODE_AUTO:String = "auto";
      
      private static const sMODE_REAR_DEFROSTER:String = "rearDefrost";
      
      private static const sBUTTON_PRESS:String = "press";
      
      private static const sBUTTON_RELEASE:String = "release";
      
      private static const sDIRECTION_UP:String = "up";
      
      private static const sDIRECTION_DOWN:String = "down";
      
      private static const dbusIdentifier:String = "HVAC";
      
      private static const dbusGetZoneProperties:String = "getZoneProperties";
      
      private static const dbusGetControlProperties:String = "getControlProperties";
      
      private static const dbusSetControlProperties:String = "setControlProperties";
      
      private static const dBusEventsMode:String = "mode";
      
      private static const dBusModeClimate:String = "climate";
      
      private static const dBusModeAc:String = "ac";
      
      private static const dBusModeMaxAc:String = "maxAC";
      
      private static const dBusModeRecirculation:String = "recirc";
      
      private static const dBusModeAirQuality:String = "airquality";
      
      private static const dBusModeAuto:String = "auto";
      
      private static const dBusModeDefroster:String = "defrost";
      
      private static const dBusModeFrontDefroster:String = "frontDefrost";
      
      private static const dBusModeRearDefroster:String = "rearDefrost";
      
      private static const dBusEventsVent:String = "airflowMode";
      
      private static const dBusZones:String = "zones";
      
      private static const dBusZone:String = "zone";
      
      private static const dBusFan:String = "fan";
      
      private static const dBusFanUp:String = "fanUp";
      
      private static const dBusFanDown:String = "fanDown";
      
      private static const dBusLock:String = "lock";
      
      private static const dBusSync:String = "sync";
      
      private static const dBusTemp:String = "temp";
      
      private static const dBusTempUp:String = "tempUp";
      
      private static const dBusTempDown:String = "tempDown";
      
      private static const dBusReady:String = "ready";
      
      private var mClimateStateFront:Boolean = true;
      
      private var mClimateStateRear:Boolean = true;
      
      private var mAcStateFront:String = "off";
      
      private var mAcStateRear:String = "off";
      
      private var mMaxAcStateFront:String = "off";
      
      private var mRecircStateFront:String = "off";
      
      private var mRecircStateRear:String = "off";
      
      private var mAirQualityStateFront:String = "off";
      
      private var mAutoStateFront:String = "off";
      
      private var mAutoStateRear:String = "off";
      
      private var mDefrosterStateRear:String = "off";
      
      private var mLockStateRear:Boolean = false;
      
      private var mSyncStateFront:Boolean = false;
      
      private var mSyncStateRear:Boolean = false;
      
      private var mVentModeFront:String = "off";
      
      private var mVentModeRear:String = "off";
      
      private var mFanSpeedFront:String = "off";
      
      private var mFanSpeedRear:String = "off";
      
      private var mZoneTempFrontLeft:String = "--";
      
      private var mZoneTempFrontRight:String = "--";
      
      private var mZoneTempRearRight:String = "--";
      
      private var mZoneTempRearLeft:String = "--";
      
      private var mRearPresent:Boolean = true;
      
      private var mRearAcPresent:Boolean = true;
      
      private var mAutoPresent:Boolean = true;
      
      private var mSyncPresent:Boolean = true;
      
      private var mZoneTempFrontZoneConfig:String = "dual";
      
      private var mZoneTempRearZoneConfig:String = "single";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mHVACServiceAvailable:Boolean = false;
      
      public function Hvac()
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
         this.connection.addEventListener(ConnectionEvent.HVAC,this.hvacMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : Hvac
      {
         if(instance == null)
         {
            instance = new Hvac();
         }
         return instance;
      }
      
      public function get ZONE_ALL() : String
      {
         return sZONE_ALL;
      }
      
      public function get ZONE_FRONT() : String
      {
         return sZONE_FRONT;
      }
      
      public function get ZONE_FRONT_RIGHT() : String
      {
         return sZONE_FRONT_RIGHT;
      }
      
      public function get ZONE_FRONT_LEFT() : String
      {
         return sZONE_FRONT_LEFT;
      }
      
      public function get ZONE_REAR() : String
      {
         return sZONE_REAR;
      }
      
      public function get ZONE_REAR_RIGHT() : String
      {
         return sZONE_REAR_RIGHT;
      }
      
      public function get ZONE_REAR_LEFT() : String
      {
         return sZONE_REAR_LEFT;
      }
      
      public function get VENT_DASH() : String
      {
         return sVENT_DASH;
      }
      
      public function get VENT_FLOOR() : String
      {
         return sVENT_FLOOR;
      }
      
      public function get VENT_MIX() : String
      {
         return sVENT_MIX;
      }
      
      public function get VENT_DEFROSTER_MIX() : String
      {
         return sVENT_DMIX;
      }
      
      public function get VENT_DEFROSTER() : String
      {
         return sVENT_DEFROSTER;
      }
      
      public function get VENT_OFF() : String
      {
         return sVENT_OFF;
      }
      
      public function get FAN_OFF() : String
      {
         return sFAN_OFF;
      }
      
      public function get FAN_LO() : String
      {
         return sFAN_LO;
      }
      
      public function get FAN_HI() : String
      {
         return sFAN_HI;
      }
      
      public function get FAN_AUTO() : String
      {
         return sFAN_AUTO;
      }
      
      public function get FAN_UP() : String
      {
         return sDIRECTION_UP;
      }
      
      public function get FAN_DOWN() : String
      {
         return sDIRECTION_DOWN;
      }
      
      public function get AC_ON() : String
      {
         return sAC_ON;
      }
      
      public function get AC_DISABLE() : String
      {
         return sAC_DISABLE;
      }
      
      public function get AUTO_ON() : String
      {
         return sAUTO_ON;
      }
      
      public function get AUTO_DISABLE() : String
      {
         return sAUTO_DISABLE;
      }
      
      public function get MAXAC_ON() : String
      {
         return sMAXAC_ON;
      }
      
      public function get MAXAC_DISABLE() : String
      {
         return sMAXAC_DISABLE;
      }
      
      public function get RECIRC_ON() : String
      {
         return sRECIRC_ON;
      }
      
      public function get RECIRC_OFF() : String
      {
         return sRECIRC_OFF;
      }
      
      public function get RECIRC_DISABLE() : String
      {
         return sRECIRC_DISABLE;
      }
      
      public function get RECIRC_SNA() : String
      {
         return sRECIRC_SNA;
      }
      
      public function get AIRQUALITY_ON() : String
      {
         return sAIRQUALITY_ON;
      }
      
      public function get AIRQUALITY_OFF() : String
      {
         return sAIRQUALITY_OFF;
      }
      
      public function get REAR_DEFROST_ON() : String
      {
         return sREAR_DEFROST_ON;
      }
      
      public function get REAR_DEFROST_OFF() : String
      {
         return sREAR_DEFROST_OFF;
      }
      
      public function get REAR_DEFROST_DISABLE() : String
      {
         return sREAR_DEFROST_DISABLE;
      }
      
      public function get REAR_DEFROST_SNA() : String
      {
         return sREAR_DEFROST_SNA;
      }
      
      public function get TEMP_LO() : String
      {
         return sTEMP_LO;
      }
      
      public function get TEMP_HI() : String
      {
         return sTEMP_HI;
      }
      
      public function get TEMP_UNKNOWN() : String
      {
         return sTEMP_UNKNOWN;
      }
      
      public function get TEMP_SINGLE() : String
      {
         return sTEMP_SINGLE;
      }
      
      public function get TEMP_DUAL() : String
      {
         return sTEMP_DUAL;
      }
      
      public function get MODE_AC() : String
      {
         return sMODE_AC;
      }
      
      public function get MODE_MAX_AC() : String
      {
         return sMODE_MAX_AC;
      }
      
      public function get MODE_CLIMATE() : String
      {
         return sMODE_CLIMATE;
      }
      
      public function get MODE_RECIRCULATION() : String
      {
         return sMODE_RECIRCULATION;
      }
      
      public function get MODE_AUTO() : String
      {
         return sMODE_AUTO;
      }
      
      public function get MODE_FRONT_DEFROSTER() : String
      {
         return sVENT_DEFROSTER;
      }
      
      public function get MODE_REAR_DEFROSTER() : String
      {
         return sMODE_REAR_DEFROSTER;
      }
      
      public function get TEMP_UP() : String
      {
         return sDIRECTION_UP;
      }
      
      public function get TEMP_DOWN() : String
      {
         return sDIRECTION_DOWN;
      }
      
      override protected function subscribe(signalName:String) : void
      {
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
      }
      
      override public function getAll() : void
      {
         this.sendZoneCommand(dbusGetZoneProperties,dBusZones,this.ZONE_ALL);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_VFS));
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function getRear() : void
      {
         this.sendZoneCommand(dbusGetZoneProperties,dBusZones,this.ZONE_REAR);
      }
      
      public function get hasRear() : Boolean
      {
         if(IS_TEST)
         {
            return false;
         }
         return this.mRearPresent;
      }
      
      public function get hasRearAc() : Boolean
      {
         if(IS_TEST)
         {
            return true;
         }
         return this.mRearAcPresent;
      }
      
      public function get hasAuto() : Boolean
      {
         if(IS_TEST)
         {
            return true;
         }
         return this.mAutoPresent;
      }
      
      public function get hasSync() : Boolean
      {
         if(IS_TEST)
         {
            return true;
         }
         return this.mSyncPresent;
      }
      
      public function get frontTempZones() : String
      {
         if(IS_TEST)
         {
            return this.mZoneTempFrontZoneConfig;
         }
         return this.mZoneTempFrontZoneConfig;
      }
      
      public function get rearTempZones() : String
      {
         if(IS_TEST)
         {
            return this.mZoneTempRearZoneConfig;
         }
         return this.mZoneTempRearZoneConfig;
      }
      
      public function getClimateState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeClimate);
         this.getControlValue(this.ZONE_REAR,dBusModeClimate);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_CLIMATE_STATE));
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_CLIMATE_STATE));
         }
      }
      
      public function isClimateEnabled(zone:String) : Boolean
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mClimateStateFront;
            case this.ZONE_REAR:
               return this.mClimateStateRear;
            default:
               return false;
         }
      }
      
      public function setClimateState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(zone,dBusModeClimate,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     this.mClimateStateFront = !this.mClimateStateFront;
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_CLIMATE_STATE));
                  }
               }
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusModeClimate,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     this.mClimateStateRear = !this.mClimateStateRear;
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_CLIMATE_STATE));
                  }
               }
         }
      }
      
      public function getAcState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeAc);
         this.getControlValue(this.ZONE_REAR,dBusModeAc);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AC_STATE));
         }
      }
      
      public function acState(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mAcStateFront;
            case this.ZONE_REAR:
               return this.mAcStateRear;
            default:
               return sAC_DISABLE;
         }
      }
      
      public function setAcState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(zone,dBusModeAc,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mAcStateFront == sAC_ON)
                     {
                        this.mAcStateFront = sAC_OFF;
                     }
                     else if(this.mAcStateFront == sAC_OFF)
                     {
                        this.mAcStateFront = sAC_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AC_STATE));
                  }
               }
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusModeAc,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mAcStateRear == sAC_ON)
                     {
                        this.mAcStateRear = sAC_OFF;
                     }
                     else if(this.mAcStateRear == sAC_OFF)
                     {
                        this.mAcStateRear = sAC_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AC_STATE));
                  }
               }
         }
      }
      
      public function getMaxAcState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeMaxAc);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_MAX_AC_STATE));
         }
      }
      
      public function maximumAcState(zone:String) : String
      {
         if(zone == this.ZONE_FRONT)
         {
            return this.mMaxAcStateFront;
         }
         return sMAXAC_DISABLE;
      }
      
      public function setMaxAcState(zone:String, state:Boolean) : void
      {
         if(zone == this.ZONE_FRONT)
         {
            this.setControlValue(zone,dBusModeMaxAc,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
            if(IS_TEST)
            {
               if(state)
               {
                  if(this.mMaxAcStateFront == sMAXAC_ON)
                  {
                     this.mMaxAcStateFront = sMAXAC_OFF;
                  }
                  else if(this.mMaxAcStateFront == sMAXAC_OFF)
                  {
                     this.mMaxAcStateFront = sMAXAC_ON;
                  }
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_MAX_AC_STATE));
               }
            }
         }
      }
      
      public function getRecircState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeRecirculation);
         this.getControlValue(this.ZONE_REAR,dBusModeRecirculation);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_RECIRC_STATE));
         }
      }
      
      public function recirculationState(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mRecircStateFront;
            case this.ZONE_REAR:
               return this.mRecircStateRear;
            default:
               return sRECIRC_DISABLE;
         }
      }
      
      public function setRecircuState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(zone,dBusModeRecirculation,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mRecircStateFront == sRECIRC_ON)
                     {
                        this.mRecircStateFront = sRECIRC_OFF;
                     }
                     else if(this.mRecircStateFront == sRECIRC_OFF)
                     {
                        this.mRecircStateFront = sRECIRC_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_RECIRC_STATE));
                  }
               }
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusModeRecirculation,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mRecircStateRear == sRECIRC_ON)
                     {
                        this.mRecircStateRear = sRECIRC_OFF;
                     }
                     else if(this.mRecircStateRear == sRECIRC_OFF)
                     {
                        this.mRecircStateRear = sRECIRC_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_RECIRC_STATE));
                  }
               }
         }
      }
      
      public function airQualityState(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mAirQualityStateFront;
            default:
               return sAIRQUALITY_OFF;
         }
      }
      
      public function getAutoState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeAuto);
         this.getControlValue(this.ZONE_REAR,dBusModeAuto);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AUTO_STATE));
         }
      }
      
      public function autoState(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mAutoStateFront;
            case this.ZONE_REAR:
               return this.mAutoStateRear;
            default:
               return sAUTO_DISABLE;
         }
      }
      
      public function setAutoState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(zone,dBusModeAuto,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mAutoStateFront == sAUTO_ON)
                     {
                        this.mAutoStateFront = sAUTO_OFF;
                     }
                     else if(this.mAutoStateFront == sAUTO_OFF)
                     {
                        this.mAutoStateFront = sAUTO_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AUTO_STATE));
                  }
               }
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusModeAuto,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     if(this.mAutoStateRear == sAUTO_ON)
                     {
                        this.mAutoStateRear = sAUTO_OFF;
                     }
                     else if(this.mAutoStateRear == sAUTO_OFF)
                     {
                        this.mAutoStateRear = sAUTO_ON;
                     }
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AUTO_STATE));
                  }
               }
         }
      }
      
      public function getDefrosterState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusModeFrontDefroster);
         this.getControlValue(this.ZONE_FRONT,dBusModeRearDefroster);
      }
      
      public function isDefrosterEnabled(defroster:String) : Boolean
      {
         switch(defroster)
         {
            case this.MODE_REAR_DEFROSTER:
               return this.mDefrosterStateRear == sREAR_DEFROST_ON;
            default:
               return false;
         }
      }
      
      public function rearDefrosterState() : String
      {
         return this.mDefrosterStateRear;
      }
      
      public function setDefrosterState(defroster:String, state:Boolean) : void
      {
         switch(defroster)
         {
            case this.MODE_REAR_DEFROSTER:
               this.setControlValue(this.ZONE_FRONT,dBusModeRearDefroster,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
      }
      
      public function getLockState() : void
      {
         this.getControlValue(this.ZONE_REAR,dBusLock);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_LOCK_STATE));
         }
      }
      
      public function isLockEnabled(zone:String) : Boolean
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return false;
            case this.ZONE_REAR:
               return this.mLockStateRear;
            default:
               return false;
         }
      }
      
      public function setLockState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusLock,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               if(IS_TEST)
               {
                  if(state)
                  {
                     this.mLockStateRear = !this.mLockStateRear;
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_LOCK_STATE));
                  }
               }
         }
      }
      
      public function getSyncState() : void
      {
         this.getControlValue(this.ZONE_FRONT,dBusSync);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_SYNC_STATE));
         }
      }
      
      public function get isSyncEnabled() : Boolean
      {
         return this.mSyncStateFront;
      }
      
      public function get isRearSyncEnabled() : Boolean
      {
         return this.mSyncStateRear;
      }
      
      public function setSyncState(zone:String, state:Boolean) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(this.ZONE_FRONT,dBusSync,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
               break;
            case this.ZONE_REAR:
               this.setControlValue(this.ZONE_REAR,dBusSync,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
         if(IS_TEST)
         {
            if(state)
            {
               this.mSyncStateFront = !this.mSyncStateFront;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_SYNC_STATE));
            }
         }
      }
      
      public function getVentMode() : void
      {
         this.getControlVents(this.ZONE_FRONT);
         this.getControlVents(this.ZONE_REAR);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_VENT_MODE));
         }
      }
      
      public function ventMode(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mVentModeFront;
            case this.ZONE_REAR:
               return this.mVentModeRear;
            default:
               return "";
         }
      }
      
      public function setVentMode(zone:String, mode:String, state:Boolean) : void
      {
         this.setControlValue(zone,mode,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         switch(zone)
         {
            case this.ZONE_FRONT:
               if(IS_TEST)
               {
                  if(state)
                  {
                     this.mVentModeFront = mode;
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_VENT_MODE));
                  }
               }
               break;
            case this.ZONE_REAR:
               if(IS_TEST)
               {
                  if(state)
                  {
                     this.mVentModeRear = mode;
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_VENT_MODE));
                  }
               }
         }
      }
      
      public function getFanSpeed() : void
      {
         this.getControlValue(this.ZONE_REAR,dBusFan);
         this.getControlValue(this.ZONE_REAR,dBusFan);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_FAN_SPEED));
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_FAN_SPEED));
         }
      }
      
      public function fanSpeed(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               return this.mFanSpeedFront;
            case this.ZONE_REAR:
               return this.mFanSpeedRear;
            default:
               return "off";
         }
      }
      
      public function setFanSpeed(zone:String, speed:String) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT:
               this.setControlValue(zone,dBusFan,speed);
               if(IS_TEST)
               {
                  this.mFanSpeedFront = speed;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_FAN_SPEED));
               }
               break;
            case this.ZONE_REAR:
               this.setControlValue(zone,dBusFan,speed);
               if(IS_TEST)
               {
                  this.mFanSpeedRear = speed;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_FAN_SPEED));
               }
         }
      }
      
      public function setFanSpeedIncrement(zone:String, direction:String, state:Boolean) : void
      {
         var fanSpeedValue:Number = NaN;
         if(direction == sDIRECTION_UP)
         {
            this.setControlValue(zone,dBusFanUp,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
         else
         {
            this.setControlValue(zone,dBusFanDown,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
         if(IS_TEST)
         {
            switch(zone)
            {
               case this.ZONE_FRONT:
                  if(state)
                  {
                     fanSpeedValue = Number(this.mFanSpeedFront);
                     if(direction == sDIRECTION_UP)
                     {
                        fanSpeedValue++;
                     }
                     else
                     {
                        fanSpeedValue--;
                     }
                     this.mFanSpeedFront = String(fanSpeedValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_FAN_SPEED));
                  }
                  break;
               case this.ZONE_REAR:
                  if(state)
                  {
                     fanSpeedValue = Number(this.mFanSpeedRear);
                     if(direction == sDIRECTION_UP)
                     {
                        fanSpeedValue++;
                     }
                     else
                     {
                        fanSpeedValue--;
                     }
                     this.mFanSpeedRear = String(fanSpeedValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_FAN_SPEED));
                  }
            }
         }
      }
      
      public function getZoneTemp() : void
      {
         this.getControlValue(this.ZONE_FRONT_LEFT,dBusTemp);
         this.getControlValue(this.ZONE_FRONT_RIGHT,dBusTemp);
         this.getControlValue(this.ZONE_REAR,dBusTemp);
         if(IS_TEST)
         {
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
         }
      }
      
      public function zoneTemp(zone:String) : String
      {
         switch(zone)
         {
            case this.ZONE_FRONT_LEFT:
               return this.mZoneTempFrontLeft;
            case this.ZONE_FRONT:
            case this.ZONE_FRONT_RIGHT:
               return this.mZoneTempFrontRight;
            case this.ZONE_REAR:
            case this.ZONE_REAR_RIGHT:
               return this.mZoneTempRearRight;
            case this.ZONE_REAR_LEFT:
               return this.mZoneTempRearLeft;
            default:
               return "lo";
         }
      }
      
      public function setZoneTemp(zone:String, temp:String) : void
      {
         switch(zone)
         {
            case this.ZONE_FRONT_LEFT:
               this.setControlValue(zone,dBusTemp,temp);
               if(IS_TEST)
               {
                  this.mZoneTempFrontLeft = temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
               }
               break;
            case this.ZONE_FRONT:
            case this.ZONE_FRONT_RIGHT:
               this.setControlValue(zone,dBusTemp,temp);
               if(IS_TEST)
               {
                  this.mZoneTempFrontRight = temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
               }
               break;
            case this.ZONE_REAR:
            case this.ZONE_REAR_RIGHT:
               this.setControlValue(zone,dBusTemp,temp);
               if(IS_TEST)
               {
                  this.mZoneTempRearRight = temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
               }
               break;
            case this.ZONE_REAR_LEFT:
               this.setControlValue(zone,dBusTemp,temp);
               if(IS_TEST)
               {
                  this.mZoneTempRearLeft = temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
               }
         }
      }
      
      public function setZoneTempIncrement(zone:String, direction:String, state:Boolean) : void
      {
         var zoneTempValue:Number = NaN;
         if(direction == sDIRECTION_UP)
         {
            this.setControlValue(zone,dBusTempUp,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
         else
         {
            this.setControlValue(zone,dBusTempDown,state ? sBUTTON_PRESS : sBUTTON_RELEASE);
         }
         if(IS_TEST)
         {
            switch(zone)
            {
               case this.ZONE_FRONT_LEFT:
                  if(this.mZoneTempFrontLeft == sTEMP_LO || this.mZoneTempFrontLeft == sTEMP_HI)
                  {
                     break;
                  }
                  zoneTempValue = Number(this.mZoneTempFrontLeft);
                  if(state)
                  {
                     if(direction == sDIRECTION_UP)
                     {
                        zoneTempValue++;
                     }
                     else
                     {
                        zoneTempValue--;
                     }
                     this.mZoneTempFrontLeft = String(zoneTempValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
                  }
                  break;
               case this.ZONE_FRONT:
               case this.ZONE_FRONT_RIGHT:
                  if(this.mZoneTempFrontRight == sTEMP_LO || this.mZoneTempFrontRight == sTEMP_HI)
                  {
                     break;
                  }
                  zoneTempValue = Number(this.mZoneTempFrontRight);
                  if(state)
                  {
                     if(direction == sDIRECTION_UP)
                     {
                        zoneTempValue++;
                     }
                     else
                     {
                        zoneTempValue--;
                     }
                     this.mZoneTempFrontRight = String(zoneTempValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
                  }
                  break;
               case this.ZONE_REAR:
               case this.ZONE_REAR_RIGHT:
                  if(this.mZoneTempRearRight == sTEMP_LO || this.mZoneTempRearRight == sTEMP_HI)
                  {
                     break;
                  }
                  zoneTempValue = Number(this.mZoneTempRearRight);
                  if(state)
                  {
                     if(direction == sDIRECTION_UP)
                     {
                        zoneTempValue++;
                     }
                     else
                     {
                        zoneTempValue--;
                     }
                     this.mZoneTempRearRight = String(zoneTempValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
                  }
                  break;
               case this.ZONE_REAR_LEFT:
                  if(this.mZoneTempRearLeft == sTEMP_LO || this.mZoneTempRearLeft == sTEMP_HI)
                  {
                     break;
                  }
                  zoneTempValue = Number(this.mZoneTempRearLeft);
                  if(state)
                  {
                     if(direction == sDIRECTION_UP)
                     {
                        zoneTempValue++;
                     }
                     else
                     {
                        zoneTempValue--;
                     }
                     this.mZoneTempRearLeft = String(zoneTempValue);
                     this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
                  }
            }
         }
      }
      
      public function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendSubscribe(dBusZone);
         this.sendSubscribe(dBusFan);
         this.sendSubscribe(dBusLock);
         this.sendSubscribe(dBusSync);
         this.sendSubscribe(dBusEventsVent);
         this.sendSubscribe(dBusTemp);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function getValue(valueName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      private function getControlValue(zone:String, control:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusGetControlProperties + "\":{\"zone\": \"" + zone + "\",\"controls\":[\"" + control + "\"]}}}";
         this.client.send(message);
      }
      
      private function getControlVents(zone:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusGetControlProperties + "\":{\"zone\": \"" + zone + "\",\"controls\":[\"" + dBusEventsVent + "\"]}}}";
         this.client.send(message);
      }
      
      private function setControlValue(zone:String, control:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusSetControlProperties + "\":{\"zone\": \"" + zone + "\",\"controls\":{\"" + control + "\":\"" + value + "\"}}}}";
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendZoneCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":[\"" + value + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
      }
      
      public function hvacMessageHandler(e:ConnectionEvent) : void
      {
         var hvacMsg:Object = e.data;
         if(hvacMsg.hasOwnProperty("dBusServiceAvailable"))
         {
            if(hvacMsg.dBusServiceAvailable == "true" && this.mHVACServiceAvailable == false)
            {
               this.mHVACServiceAvailable = true;
               this.getAll();
            }
            else if(hvacMsg.dBusServiceAvailable == "false")
            {
               this.mHVACServiceAvailable = false;
            }
         }
         if(hvacMsg.hasOwnProperty(dbusGetZoneProperties))
         {
            this.mRearPresent = false;
            this.mZoneTempFrontZoneConfig = sTEMP_DUAL;
            this.mZoneTempRearZoneConfig = sTEMP_SINGLE;
            this.handleZonePropertyMessage(hvacMsg.getZoneProperties.zones);
         }
         if(hvacMsg.hasOwnProperty(dbusGetControlProperties))
         {
            this.handleControlPropertyMessage(hvacMsg.getControlProperties.zone,hvacMsg.getControlProperties.controls);
         }
         if(hvacMsg.hasOwnProperty(dBusZone))
         {
            this.handleControlPropertyMessage(hvacMsg.zone.zone,hvacMsg.zone.controls);
         }
         if(hvacMsg.hasOwnProperty(dBusEventsMode))
         {
         }
         if(hvacMsg.hasOwnProperty(dBusEventsVent))
         {
         }
         if(hvacMsg.hasOwnProperty(dBusTemp))
         {
         }
         if(hvacMsg.hasOwnProperty(dBusSync))
         {
         }
         if(hvacMsg.hasOwnProperty(dBusLock))
         {
         }
         if(hvacMsg.hasOwnProperty(dBusFan))
         {
         }
      }
      
      public function handleZonePropertyMessage(msg:Object) : void
      {
         var zone:Object = null;
         if(null == msg)
         {
            return;
         }
         for each(var _loc5_ in msg)
         {
            zone = _loc5_;
            _loc5_;
            switch(zone.zone)
            {
               case this.ZONE_FRONT:
                  this.handleControlPropertyMessage(this.ZONE_FRONT,zone.controls);
                  break;
               case this.ZONE_REAR:
                  this.mRearPresent = true;
                  this.handleControlPropertyMessage(this.ZONE_REAR,zone.controls);
                  break;
               case this.ZONE_FRONT_LEFT:
                  this.handleControlPropertyMessage(this.ZONE_FRONT_LEFT,zone.controls);
                  break;
               case this.ZONE_FRONT_RIGHT:
                  this.handleControlPropertyMessage(this.ZONE_FRONT_RIGHT,zone.controls);
            }
         }
      }
      
      public function handleControlPropertyMessage(zone:String, msg:Object) : void
      {
         if(null == msg)
         {
            return;
         }
         if(msg.hasOwnProperty(dBusModeClimate))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mClimateStateFront = msg.climate == "on" ? true : false;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_CLIMATE_STATE));
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mClimateStateRear = msg.climate == "on" ? true : false;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_CLIMATE_STATE));
            }
         }
         if(msg.hasOwnProperty(dBusModeAc))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mAcStateFront = msg.ac;
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mRearAcPresent = true;
               this.mAcStateRear = msg.ac;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AC_STATE));
         }
         if(msg.hasOwnProperty(dBusModeMaxAc))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mMaxAcStateFront = msg.maxAC;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_MAX_AC_STATE));
         }
         if(msg.hasOwnProperty(dBusModeAuto))
         {
            this.mAutoPresent = true;
            if(zone == this.ZONE_FRONT)
            {
               this.mAutoStateFront = msg.auto;
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mAutoStateRear = msg.auto;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AUTO_STATE));
         }
         if(msg.hasOwnProperty(dBusModeRecirculation))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mRecircStateFront = msg.recirc;
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mRecircStateRear = msg.recirc;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_RECIRC_STATE));
         }
         if(msg.hasOwnProperty(dBusModeAirQuality))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mAirQualityStateFront = msg.airquality;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_AIRQUALITY_STATE));
            }
         }
         if(msg.hasOwnProperty(dBusModeRearDefroster))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mDefrosterStateRear = msg.rearDefrost;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_DEFROSTER_STATE));
            }
         }
         if(msg.hasOwnProperty(dBusSync))
         {
            this.mSyncPresent = true;
            if(zone == this.ZONE_FRONT)
            {
               this.mSyncStateFront = msg.sync == "on" ? true : false;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_SYNC_STATE));
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mSyncStateRear = msg.sync == "on" ? true : false;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_SYNC_STATE));
            }
         }
         if(msg.hasOwnProperty(dBusLock))
         {
            if(zone == this.ZONE_REAR)
            {
               this.mLockStateRear = msg.lock == "on" ? true : false;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_LOCK_STATE));
         }
         if(msg.hasOwnProperty(dBusFan))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mFanSpeedFront = msg.fan;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_F_FAN_SPEED));
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mFanSpeedRear = msg.fan;
               this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_R_FAN_SPEED));
            }
         }
         if(msg.hasOwnProperty(dBusTemp))
         {
            if(msg.temp != "SNA")
            {
               if(zone == this.ZONE_FRONT)
               {
                  this.mZoneTempFrontLeft = msg.temp;
                  this.mZoneTempFrontRight = msg.temp;
               }
               if(zone == this.ZONE_FRONT_LEFT)
               {
                  this.mZoneTempFrontZoneConfig = sTEMP_DUAL;
                  this.mZoneTempFrontLeft = msg.temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP));
               }
               if(zone == this.ZONE_FRONT_RIGHT)
               {
                  this.mZoneTempFrontRight = msg.temp;
                  this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP));
               }
               if(zone == this.ZONE_REAR)
               {
                  this.mZoneTempRearLeft = msg.temp;
                  this.mZoneTempRearRight = msg.temp;
               }
               if(zone == this.ZONE_REAR_LEFT)
               {
                  this.mZoneTempRearZoneConfig = sTEMP_DUAL;
                  this.mZoneTempRearLeft = msg.temp;
               }
               if(zone == this.ZONE_REAR_RIGHT)
               {
                  this.mZoneTempRearRight = msg.temp;
               }
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_ZONE_TEMP));
         }
         if(msg.hasOwnProperty(dBusEventsVent))
         {
            if(zone == this.ZONE_FRONT)
            {
               this.mVentModeFront = msg.airflowMode;
            }
            else if(zone == this.ZONE_REAR)
            {
               this.mVentModeRear = msg.airflowMode;
            }
            this.dispatchEvent(new HvacEvent(HvacEvent.HVAC_VENT_MODE,zone));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

