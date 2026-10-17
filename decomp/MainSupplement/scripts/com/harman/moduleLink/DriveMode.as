package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.harman.moduleLinkAPI.IDriveMode;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DriveMode extends Module implements IDriveMode
   {
      
      private static var instance:DriveMode;
      
      private static const mDbusIdentifier:String = "DriveMode";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiSetProperties:String = "setProperties";
      
      private static const dbusSignalActiveDampingDriveMode:String = "activeDampingDriveMode";
      
      private static const dbusSignalActiveDampingStatus:String = "activeDampingStatus";
      
      private static const dbusSignalDriveModeIndicator1:String = "driveModeIndicator1";
      
      private static const dbusSignalDriveModeIndicator2:String = "driveModeIndicator2";
      
      private static const dbusSignalDriveModeIndicator3:String = "driveModeIndicator3";
      
      private static const dbusSignalDriveModeIndicator4:String = "driveModeIndicator4";
      
      private static const dbusSignalEcoModeActive:String = "ecoModeActive";
      
      private static const dbusSignalEngineDriveMode:String = "engineDriveMode";
      
      private static const dbusSignalEngineDriveModeCfg:String = "engineDriveModeCfg";
      
      private static const dbusSignalEnginePowerMode:String = "enginePowerMode";
      
      private static const dbusSignalEPSDriveMode:String = "EPSDriveMode";
      
      private static const dbusSignalEPSModeStatus:String = "EPSModeStatus";
      
      private static const dbusSignalEPSWarnDisplayRequest:String = "EPSWarnDisplayRequest";
      
      private static const dbusSignalErrSys_1:String = "ErrSys_1";
      
      private static const dbusSignalErrSys_2:String = "ErrSys_2";
      
      private static const dbusSignalErrSys_3:String = "ErrSys_3";
      
      private static const dbusSignalErrSys_4:String = "ErrSys_4";
      
      private static const dbusSignalErrSys_5:String = "ErrSys_5";
      
      private static const dbusSignalErrSys_6:String = "ErrSys_6";
      
      private static const dbusSignalErrSys_7:String = "ErrSys_7";
      
      private static const dbusSignalErrSys_8:String = "ErrSys_8";
      
      private static const dbusSignalESCButtonStatus:String = "ESCButtonStatus";
      
      private static const dbusSignalESCDriveMode:String = "ESCDriveMode";
      
      private static const dbusSignalGlobalDriveModeConfigs:String = "globalDriveModeConfigs";
      
      private static const dbusSignalGlobalDriveModeStatus:String = "globalDriveModeStatus";
      
      private static const dbusSignalGear1RPMSetPoint:String = "gear1RPMSetPoint";
      
      private static const dbusSignalGear2RPMSetPoint:String = "gear2RPMSetPoint";
      
      private static const dbusSignalGear3RPMSetPoint:String = "gear3RPMSetPoint";
      
      private static const dbusSignalGear4RPMSetPoint:String = "gear4RPMSetPoint";
      
      private static const dbusSignalGear5RPMSetPoint:String = "gear5RPMSetPoint";
      
      private static const dbusSignalHPDriveModeCfg:String = "HPDriveModeCfg";
      
      private static const dbusSignalIsLegacyDriveMode:String = "isLegacyDriveMode";
      
      private static const dbusSignalLaunchButtonStatus:String = "launchButtonStatus";
      
      private static const dbusSignalLaunchRPMSetPoint:String = "launchRPMSetPoint";
      
      private static const dbusSignalMaxShiftRPM:String = "maxShiftRPM";
      
      private static const dbusSignalPaddlesDriveMode:String = "paddlesDriveMode";
      
      private static const dbusSignalPaddlesDriveModeStatus:String = "paddlesDriveModeStatus";
      
      private static const dbusSignalPowerSteeringType:String = "powerSteeringType";
      
      private static const dbusSignalReady:String = "ready";
      
      private static const dbusSignalRedKeyFeaturePresent:String = "redKeyFeaturePresent";
      
      private static const dbusSignalRedKeyPresent:String = "redKeyPresent";
      
      private static const dbusSignalShiftIndicatorRPMReset:String = "shiftIndicatorRPMReset";
      
      private static const dbusSignalShiftIndicatorStatus:String = "shiftIndicatorStatus";
      
      private static const dbusSignalSRTButtonStatus:String = "SRTButtonStatus";
      
      private static const dbusSignalTerrainDriveMode:String = "terrainDriveMode";
      
      private static const dbusSignalTerrainMode:String = "terrainMode";
      
      private static const dbusSignalThrottlePosition:String = "throttlePosition";
      
      private static const dbusSignalTractionControlIndicator:String = "tractionControlIndicator";
      
      private static const dbusSignalTransmissionDriveMode:String = "transmissionDriveMode";
      
      private static const dbusSignalTransmissionMode:String = "transmissionMode";
      
      private static const dbusSignalValetLockOut:String = "valetLockOut";
      
      private static const signalDriveModeLogging:String = "enableLogging";
      
      private static const signalDriveModeVersion:String = "version";
      
      private static const signalValetUnlocked:String = "valetUnlocked";
      
      private static const SUB_LEVEL_DELAY:int = 3000;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mReady:Boolean = false;
      
      private var mErrorGroup:Dictionary = new Dictionary();
      
      private var mSNAGroup:Dictionary = new Dictionary();
      
      private var mIsWK:Boolean = true;
      
      private var mIsNonSRT:Boolean = false;
      
      private var mProperties:Dictionary = new Dictionary();
      
      private var mServiceAvailable:Boolean;
      
      private var mGlobalDriveModeTables:Object = {};
      
      public function DriveMode()
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
         this.connection.addEventListener(ConnectionEvent.DRIVE_MODE,this.onMessageHandler);
      }
      
      public static function getInstance() : DriveMode
      {
         if(instance == null)
         {
            instance = new DriveMode();
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
      }
      
      public function get EngineModeCustomStatus() : String
      {
         return this.mProperties[dbusSignalEngineDriveModeCfg].value;
      }
      
      public function get EngineModeRequest() : String
      {
         return this.mProperties[dbusSignalEngineDriveMode].request;
      }
      
      public function set EngineModeRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalEngineDriveMode,val);
         this.mProperties[dbusSignalEngineDriveMode].request = val;
      }
      
      public function get EngineModeStatus() : String
      {
         return this.mProperties[dbusSignalEngineDriveMode].value;
      }
      
      public function get ErrorGroup() : Dictionary
      {
         this.mErrorGroup[DriveModeTypes.STEERING] = this.mProperties[dbusSignalErrSys_1].value;
         this.mErrorGroup[DriveModeTypes.PADDLE_SHIFTER] = this.mProperties[dbusSignalErrSys_2].value;
         this.mErrorGroup[DriveModeTypes.TRANSMISSION] = this.mProperties[dbusSignalErrSys_3].value;
         this.mErrorGroup[DriveModeTypes.STABILITY_CONTROL] = this.mProperties[dbusSignalErrSys_4].value;
         this.mErrorGroup[DriveModeTypes.SUSPENSION] = this.mProperties[dbusSignalErrSys_5].value;
         this.mErrorGroup[DriveModeTypes.HORSE_POWER] = this.mProperties[dbusSignalErrSys_6].value;
         this.mErrorGroup[DriveModeTypes.ALL_WHEEL_DRIVE] = this.mProperties[dbusSignalErrSys_7].value;
         this.mErrorGroup[8] = this.mProperties[dbusSignalErrSys_8].value;
         return this.mErrorGroup;
      }
      
      public function get SNAGroup() : Dictionary
      {
         this.mSNAGroup[DriveModeTypes.ALL_WHEEL_DRIVE] = (Boolean(this.mProperties[dbusSignalTerrainDriveMode].isSNA) || Boolean(this.mProperties[dbusSignalTerrainMode].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.PADDLE_SHIFTER] = (Boolean(this.mProperties[dbusSignalPaddlesDriveMode].isSNA) || Boolean(this.mProperties[dbusSignalPaddlesDriveModeStatus].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.STEERING] = (Boolean(this.mProperties[dbusSignalEPSModeStatus].isSNA) || Boolean(this.mProperties[dbusSignalEPSDriveMode].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.STABILITY_CONTROL] = (Boolean(this.mProperties[dbusSignalESCButtonStatus].isSNA) || Boolean(this.mProperties[dbusSignalESCDriveMode].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.SUSPENSION] = (Boolean(this.mProperties[dbusSignalActiveDampingStatus].isSNA) || Boolean(this.mProperties[dbusSignalActiveDampingDriveMode].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.TRANSMISSION] = (Boolean(this.mProperties[dbusSignalTransmissionDriveMode].isSNA) || Boolean(this.mProperties[dbusSignalTransmissionMode].isSNA)) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.HORSE_POWER] = Boolean(this.mProperties[dbusSignalEnginePowerMode].isSNA) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.GLOBAL] = Boolean(this.mProperties[dbusSignalGlobalDriveModeStatus].isSNA) && this.mIsWK ? true : false;
         this.mSNAGroup[DriveModeTypes.ENGINE] = Boolean(this.mProperties[dbusSignalEngineDriveMode].isSNA) && this.mIsWK ? true : false;
         return this.mSNAGroup;
      }
      
      public function get Gear1RPMRequest() : String
      {
         return this.mProperties[dbusSignalGear1RPMSetPoint].request;
      }
      
      public function set Gear1RPMRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalGear1RPMSetPoint,val);
         this.mProperties[dbusSignalGear1RPMSetPoint].request = val;
      }
      
      public function get Gear1RPMStatus() : String
      {
         return this.mProperties[dbusSignalGear1RPMSetPoint].value;
      }
      
      public function get Gear2RPMRequest() : String
      {
         return this.mProperties[dbusSignalGear2RPMSetPoint].request;
      }
      
      public function set Gear2RPMRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalGear2RPMSetPoint,val);
         this.mProperties[dbusSignalGear2RPMSetPoint].request = val;
      }
      
      public function get Gear2RPMStatus() : String
      {
         return this.mProperties[dbusSignalGear2RPMSetPoint].value;
      }
      
      public function get Gear3RPMRequest() : String
      {
         return this.mProperties[dbusSignalGear3RPMSetPoint].request;
      }
      
      public function set Gear3RPMRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalGear3RPMSetPoint,val);
         this.mProperties[dbusSignalGear3RPMSetPoint].request = val;
      }
      
      public function get Gear3RPMStatus() : String
      {
         return this.mProperties[dbusSignalGear3RPMSetPoint].value;
      }
      
      public function get Gear4RPMRequest() : String
      {
         return this.mProperties[dbusSignalGear4RPMSetPoint].request;
      }
      
      public function set Gear4RPMRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalGear4RPMSetPoint,val);
         this.mProperties[dbusSignalGear4RPMSetPoint].request = val;
      }
      
      public function get Gear4RPMStatus() : String
      {
         return this.mProperties[dbusSignalGear4RPMSetPoint].value;
      }
      
      public function get Gear5RPMRequest() : String
      {
         return this.mProperties[dbusSignalGear5RPMSetPoint].request;
      }
      
      public function set Gear5RPMRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalGear5RPMSetPoint,val);
         this.mProperties[dbusSignalGear5RPMSetPoint].request = val;
      }
      
      public function get Gear5RPMStatus() : String
      {
         return this.mProperties[dbusSignalGear5RPMSetPoint].value;
      }
      
      public function get GlobalDriveModeError() : Boolean
      {
         return this.mProperties[dbusSignalDriveModeIndicator2].value;
      }
      
      public function get GlobalDriveModeRequest() : String
      {
         return this.mProperties[dbusSignalGlobalDriveModeStatus].request;
      }
      
      public function set GlobalDriveModeRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalEnginePowerMode,this.onHorsepowerComplete);
            this.createTimerForProp(dbusSignalPaddlesDriveModeStatus,this.onPaddlesComplete);
            this.createTimerForProp(dbusSignalESCButtonStatus,this.onStabilityComplete);
            this.createTimerForProp(dbusSignalEPSModeStatus,this.onSteeringComplete);
            this.createTimerForProp(dbusSignalActiveDampingStatus,this.onSuspensionComplete);
            this.createTimerForProp(dbusSignalTransmissionMode,this.onTransmissionComplete);
         }
         this.sendSetProperties(dbusSignalGlobalDriveModeStatus,val);
         this.mProperties[dbusSignalGlobalDriveModeStatus].request = val;
         if(this.mProperties[dbusSignalEnginePowerMode].timer)
         {
            this.mProperties[dbusSignalEnginePowerMode].timer.start();
         }
         if(this.mProperties[dbusSignalPaddlesDriveModeStatus].timer)
         {
            this.mProperties[dbusSignalPaddlesDriveModeStatus].timer.start();
         }
         if(this.mProperties[dbusSignalESCButtonStatus].timer)
         {
            this.mProperties[dbusSignalESCButtonStatus].timer.start();
         }
         if(this.mProperties[dbusSignalEPSModeStatus].timer)
         {
            this.mProperties[dbusSignalEPSModeStatus].timer.start();
         }
         if(this.mProperties[dbusSignalActiveDampingStatus].timer)
         {
            this.mProperties[dbusSignalActiveDampingStatus].timer.start();
         }
         if(this.mProperties[dbusSignalTransmissionMode].timer)
         {
            this.mProperties[dbusSignalTransmissionMode].timer.start();
         }
      }
      
      public function get GlobalDriveModeStatus() : String
      {
         return this.mProperties[dbusSignalGlobalDriveModeStatus].value;
      }
      
      public function get HorsepowerModeCustomStatus() : String
      {
         return this.mProperties[dbusSignalHPDriveModeCfg].value;
      }
      
      public function get HorsepowerModeError() : Boolean
      {
         return this.mProperties[dbusSignalDriveModeIndicator1].value;
      }
      
      public function get HorsepowerModeRequest() : String
      {
         return this.mProperties[dbusSignalEnginePowerMode].request;
      }
      
      public function set HorsepowerModeRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalEnginePowerMode,this.onHorsepowerComplete);
         }
         this.sendSetProperties(dbusSignalEnginePowerMode,val);
         this.mProperties[dbusSignalEnginePowerMode].request = val;
         if(this.mProperties[dbusSignalEnginePowerMode].timer)
         {
            this.mProperties[dbusSignalEnginePowerMode].timer.start();
         }
      }
      
      public function get HorsepowerModeStatus() : String
      {
         return this.mProperties[dbusSignalEnginePowerMode].value;
      }
      
      public function get LaunchButtonRequest() : Boolean
      {
         return this.mProperties[dbusSignalLaunchButtonStatus].request;
      }
      
      public function set LaunchButtonRequest(val:Boolean) : void
      {
         this.sendSetProperties(dbusSignalLaunchButtonStatus,val);
         this.mProperties[dbusSignalLaunchButtonStatus].request = val;
      }
      
      public function get LaunchButtonStatus() : Boolean
      {
         return this.mProperties[dbusSignalLaunchButtonStatus].value;
      }
      
      public function get LaunchRPMPointRequest() : String
      {
         return this.mProperties[dbusSignalLaunchRPMSetPoint].request;
      }
      
      public function set LaunchRPMPointRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalLaunchRPMSetPoint,val);
         this.mProperties[dbusSignalLaunchRPMSetPoint].request = val;
      }
      
      public function get LaunchRPMPointStatus() : String
      {
         return this.mProperties[dbusSignalLaunchRPMSetPoint].value;
      }
      
      public function get MaxShiftRPMStatus() : String
      {
         return this.mProperties[dbusSignalMaxShiftRPM].value;
      }
      
      public function get PaddleShifterCustomStatus() : String
      {
         return this.mProperties[dbusSignalPaddlesDriveMode].value;
      }
      
      public function get PaddleShifterRequest() : String
      {
         return this.mProperties[dbusSignalPaddlesDriveModeStatus].request;
      }
      
      public function set PaddleShifterRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalPaddlesDriveModeStatus,this.onPaddlesComplete);
         }
         this.sendSetProperties(dbusSignalPaddlesDriveModeStatus,val);
         this.mProperties[dbusSignalPaddlesDriveModeStatus].request = val;
         if(this.mProperties[dbusSignalPaddlesDriveModeStatus].timer)
         {
            this.mProperties[dbusSignalPaddlesDriveModeStatus].timer.start();
         }
      }
      
      public function get PaddleShifterStatus() : String
      {
         return this.mProperties[dbusSignalPaddlesDriveModeStatus].value;
      }
      
      public function get PowerSteeringLockOut() : Boolean
      {
         return this.mProperties[dbusSignalEPSWarnDisplayRequest].value == DriveModeValues.LUA_EPS_SERV || this.mProperties[dbusSignalEPSWarnDisplayRequest].value == DriveModeValues.LUA_SNA || this.mProperties[dbusSignalEPSModeStatus].value == DriveModeValues.LUA_SNA;
      }
      
      public function get PowerSteeringType() : String
      {
         return this.mProperties[dbusSignalPowerSteeringType].value;
      }
      
      public function get RedKeyFeaturePresent() : Boolean
      {
         return this.mProperties[dbusSignalRedKeyFeaturePresent].value;
      }
      
      public function get RedKeyPresent() : Boolean
      {
         return this.mProperties[dbusSignalRedKeyPresent].value;
      }
      
      public function get ShiftIndicatorRequest() : String
      {
         return this.mProperties[dbusSignalShiftIndicatorStatus].request;
      }
      
      public function set ShiftIndicatorRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalShiftIndicatorStatus,val);
         this.mProperties[dbusSignalShiftIndicatorStatus].request = val;
      }
      
      public function get ShiftIndicatorStatus() : String
      {
         return this.mProperties[dbusSignalShiftIndicatorStatus].value;
      }
      
      public function get SRTButtonStatus() : String
      {
         return this.mProperties[dbusSignalSRTButtonStatus].value;
      }
      
      public function get StabilityCustomStatus() : String
      {
         return this.mProperties[dbusSignalESCDriveMode].value;
      }
      
      public function get StabilityRequest() : String
      {
         return this.mProperties[dbusSignalESCButtonStatus].request;
      }
      
      public function set StabilityRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalESCButtonStatus,this.onStabilityComplete);
         }
         this.sendSetProperties(dbusSignalESCButtonStatus,val);
         this.mProperties[dbusSignalESCButtonStatus].request = val;
         if(this.mProperties[dbusSignalESCButtonStatus].timer)
         {
            this.mProperties[dbusSignalESCButtonStatus].timer.start();
         }
      }
      
      public function get StabilityStatus() : String
      {
         return this.mProperties[dbusSignalESCButtonStatus].value;
      }
      
      public function get SteeringCustomStatus() : String
      {
         return this.mProperties[dbusSignalEPSDriveMode].value;
      }
      
      public function get SteeringErrorStatus() : String
      {
         return this.mProperties[dbusSignalEPSWarnDisplayRequest].value;
      }
      
      public function get SteeringRequest() : String
      {
         return this.mProperties[dbusSignalEPSModeStatus].request;
      }
      
      public function set SteeringRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalEPSModeStatus,this.onSteeringComplete);
         }
         this.sendSetProperties(dbusSignalEPSModeStatus,val);
         this.mProperties[dbusSignalEPSModeStatus].request = val;
         if(this.mProperties[dbusSignalEPSModeStatus].timer)
         {
            this.mProperties[dbusSignalEPSModeStatus].timer.start();
         }
      }
      
      public function get SteeringStatus() : String
      {
         return this.mProperties[dbusSignalEPSModeStatus].value;
      }
      
      public function get SuspensionCustomStatus() : String
      {
         return this.mProperties[dbusSignalActiveDampingDriveMode].value;
      }
      
      public function get SuspensionRequest() : String
      {
         return this.mProperties[dbusSignalActiveDampingStatus].request;
      }
      
      public function set SuspensionRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalActiveDampingStatus,this.onSuspensionComplete);
         }
         this.sendSetProperties(dbusSignalActiveDampingStatus,val);
         this.mProperties[dbusSignalActiveDampingStatus].request = val;
         if(this.mProperties[dbusSignalActiveDampingStatus].timer)
         {
            this.mProperties[dbusSignalActiveDampingStatus].timer.start();
         }
      }
      
      public function get SuspensionStatus() : String
      {
         return this.mProperties[dbusSignalActiveDampingStatus].value;
      }
      
      public function get TerrainModeCustomStatus() : String
      {
         return this.mProperties[dbusSignalTerrainDriveMode].value;
      }
      
      public function get TerrainModeRequest() : String
      {
         return this.mProperties[dbusSignalTerrainMode].request;
      }
      
      public function set TerrainModeRequest(val:String) : void
      {
         this.sendSetProperties(dbusSignalTerrainMode,val);
         this.mProperties[dbusSignalTerrainMode].request = val;
      }
      
      public function get TerrainModeStatus() : String
      {
         switch(this.mProperties[dbusSignalTerrainMode].value)
         {
            case DriveModeValues.HMI_AUTO:
               return DriveModeValues.HMI_STREET;
            case DriveModeValues.HMI_SNOW:
            case DriveModeValues.HMI_TOW:
               return DriveModeValues.HMI_HALF_HALF;
            default:
               return this.mProperties[dbusSignalTerrainMode].value;
         }
      }
      
      public function get ThrottleLockOut() : Boolean
      {
         return this.mProperties[dbusSignalThrottlePosition].value;
      }
      
      public function get TractionControlStatus() : Boolean
      {
         return this.mProperties[dbusSignalTractionControlIndicator].value;
      }
      
      public function get TransmissionModeCustomStatus() : String
      {
         return this.mProperties[dbusSignalTransmissionDriveMode].value;
      }
      
      public function get TransmissionModeRequest() : String
      {
         return this.mProperties[dbusSignalTransmissionMode].request;
      }
      
      public function set TransmissionModeRequest(val:String) : void
      {
         if(this.isLegacyDriveModes && !this.mIsNonSRT)
         {
            this.createTimerForProp(dbusSignalTransmissionMode,this.onTransmissionComplete);
         }
         this.sendSetProperties(dbusSignalTransmissionMode,val);
         this.mProperties[dbusSignalTransmissionMode].request = val;
         if(this.mProperties[dbusSignalTransmissionMode].timer)
         {
            this.mProperties[dbusSignalTransmissionMode].timer.start();
         }
      }
      
      public function get TransmissionModeStatus() : String
      {
         return this.mProperties[dbusSignalTransmissionMode].value;
      }
      
      public function get ValetModeLockOut() : Boolean
      {
         return this.mProperties[dbusSignalValetLockOut].value;
      }
      
      public function get ValetModeLockOutReason() : String
      {
         if(this.mProperties[dbusSignalDriveModeIndicator3].value)
         {
            return DriveModeValues.LOCKOUT_LAUNCH;
         }
         if(this.mProperties[dbusSignalDriveModeIndicator4].value)
         {
            return DriveModeValues.LOCKOUT_CRUISE;
         }
         return DriveModeValues.LOCKOUT_NONE;
      }
      
      public function get GlobalDriveModeTables() : Object
      {
         return this.mProperties[dbusSignalGlobalDriveModeConfigs].value;
      }
      
      public function set isWK(val:Boolean) : void
      {
         this.mIsWK = val;
         if(this.mIsWK)
         {
            this.mProperties[dbusSignalGlobalDriveModeStatus].convert = this.convertGlobalModeStatusWK;
            this.mProperties[dbusSignalESCButtonStatus].convert = this.convertESCStatus;
            this.mProperties[dbusSignalESCDriveMode].convert = this.convertESCStatus;
            this.sendGetProperties([dbusSignalGlobalDriveModeStatus]);
         }
      }
      
      public function set isNonSRT(val:Boolean) : void
      {
         this.mIsNonSRT = val;
         if(this.mIsNonSRT)
         {
            this.mProperties[dbusSignalActiveDampingDriveMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalActiveDampingStatus].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalEPSDriveMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalEPSModeStatus].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalESCDriveMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalESCButtonStatus].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalTransmissionDriveMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalTransmissionMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalEngineDriveMode].convert = this.convertGenericNonSRT;
            this.mProperties[dbusSignalEngineDriveModeCfg].convert = this.convertGenericNonSRT;
            if(this.isLegacyDriveModes)
            {
               this.sendGetProperties([dbusSignalActiveDampingStatus,dbusSignalEPSModeStatus,dbusSignalESCButtonStatus,dbusSignalTransmissionMode,dbusSignalGlobalDriveModeConfigs,dbusSignalEngineDriveMode]);
            }
            else
            {
               this.sendGetProperties([dbusSignalActiveDampingDriveMode,dbusSignalActiveDampingStatus,dbusSignalEPSDriveMode,dbusSignalEPSModeStatus,dbusSignalESCDriveMode,dbusSignalESCButtonStatus,dbusSignalTransmissionDriveMode,dbusSignalTransmissionMode,dbusSignalEngineDriveMode,dbusSignalEngineDriveModeCfg]);
            }
         }
      }
      
      public function get TerrainThemeStatus() : String
      {
         return "";
      }
      
      public function get isLegacyDriveModes() : Boolean
      {
         return this.mProperties[dbusSignalIsLegacyDriveMode].value;
      }
      
      public function get EcoMode() : Boolean
      {
         return this.mProperties[dbusSignalEcoModeActive].value;
      }
      
      public function get DriveModeLogging() : Boolean
      {
         return this.mProperties[signalDriveModeLogging].value;
      }
      
      public function set DriveModeLogging(val:Boolean) : void
      {
         var message:String = "";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"setLoggingEnable\": {\"value\":\"" + val + "\"}}}";
         this.client.send(message);
      }
      
      public function get DriveModeVersion() : String
      {
         return this.mProperties[signalDriveModeVersion].value;
      }
      
      public function resetRPMToFactory(press:Boolean = true) : void
      {
         this.sendSetProperties(dbusSignalShiftIndicatorRPMReset,press);
      }
      
      public function requestEcoMode(value:Boolean) : void
      {
         this.emitSignal("ecoModeActiveRequest",value ? "true" : "false");
      }
      
      public function copyDriveModeLogToUSB() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"copyDriveModeLogToUSB\": {}}}";
         this.client.send(message);
      }
      
      public function getDriveModeVersion() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"getDriveModeVersion\": {}}}";
         this.client.send(message);
      }
      
      public function requestLoggingStatus() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\":" + "{\"getLoggingEnable\": {}}}";
         this.client.send(message);
      }
      
      private function onConnected(event:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.sendMultiSubscribe(this.mProperties);
            this.createNonPropertyTables();
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function onMessageHandler(event:ConnectionEvent) : void
      {
         var sig:String = null;
         var obj:Object = null;
         var resp:Object = event.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mServiceAvailable == false)
            {
               this.mServiceAvailable = true;
               this.sendGetProperties([dbusSignalReady]);
               this.getDriveModeVersion();
               this.requestLoggingStatus();
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
         else if(resp.hasOwnProperty(dBusApiGetProperties))
         {
            if(resp[dBusApiGetProperties].hasOwnProperty("code"))
            {
               this.debug("getProperties errorCode: " + resp[dBusApiGetProperties].code + ", description: " + resp[dBusApiGetProperties].description);
               return;
            }
            this.processProperties(resp[dBusApiGetProperties]);
         }
         else if(resp.hasOwnProperty(dBusApiSetProperties))
         {
            if(resp[dBusApiSetProperties].hasOwnProperty("code"))
            {
               this.debug("setProperties errorCode: " + resp[dBusApiSetProperties].code + ", description: " + resp[dBusApiSetProperties].description);
               return;
            }
            for(sig in resp[dBusApiSetProperties])
            {
               if(this.mProperties[sig].hasReturn)
               {
                  if(resp[dBusApiSetProperties][sig] is String)
                  {
                     this.mProperties[sig].request = this.genericConversion(sig,resp[dBusApiSetProperties][sig]);
                  }
                  else if(resp[dBusApiSetProperties][sig] is Object)
                  {
                     if(this.isLegacyDriveModes)
                     {
                        this.modifyTable(sig,resp[dBusApiSetProperties][sig]);
                     }
                     else
                     {
                        this.mProperties[sig].value = this.genericConversion(sig,resp[dBusApiSetProperties][sig].value);
                     }
                  }
                  if(this.mProperties[sig].event != null)
                  {
                     this.dispatchEvent(new DriveModeEvent(this.mProperties[sig].event));
                  }
               }
            }
         }
         else
         {
            for(obj in resp)
            {
               this.processProperties(resp[obj]);
            }
         }
      }
      
      private function onHorsepowerComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.HORSE_POWER);
         this.mProperties[dbusSignalEnginePowerMode].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHorsepowerComplete);
         this.mProperties[dbusSignalEnginePowerMode].timer = null;
      }
      
      private function onPaddlesComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.PADDLE_SHIFTER);
         this.mProperties[dbusSignalPaddlesDriveModeStatus].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPaddlesComplete);
         this.mProperties[dbusSignalPaddlesDriveModeStatus].timer = null;
      }
      
      private function onStabilityComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.STABILITY_CONTROL);
         this.mProperties[dbusSignalESCButtonStatus].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onStabilityComplete);
         this.mProperties[dbusSignalESCButtonStatus].timer = null;
      }
      
      private function onSteeringComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.STEERING);
         this.mProperties[dbusSignalEPSModeStatus].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSteeringComplete);
         this.mProperties[dbusSignalEPSModeStatus].timer = null;
      }
      
      private function onSuspensionComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.SUSPENSION);
         this.mProperties[dbusSignalActiveDampingStatus].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSuspensionComplete);
         this.mProperties[dbusSignalActiveDampingStatus].timer = null;
      }
      
      private function onTransmissionComplete(event:TimerEvent) : void
      {
         this.compareStatusForError(DriveModeTypes.TRANSMISSION);
         this.mProperties[dbusSignalTransmissionMode].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTransmissionComplete);
         this.mProperties[dbusSignalTransmissionMode].timer = null;
      }
      
      private function setUpPropertiesTable() : void
      {
         this.mProperties[dbusSignalActiveDampingDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalActiveDampingStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalDriveModeIndicator1] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.ENGINE_LOCKOUT
         };
         this.mProperties[dbusSignalDriveModeIndicator2] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.GLOBAL_LOCKOUT
         };
         this.mProperties[dbusSignalDriveModeIndicator3] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.VALET_LOCKOUT
         };
         this.mProperties[dbusSignalDriveModeIndicator4] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.VALET_LOCKOUT
         };
         this.mProperties[dbusSignalEcoModeActive] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.ECO_MODE
         };
         this.mProperties[dbusSignalEngineDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalEngineDriveModeCfg] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalEnginePowerMode] = {
            "value":null,
            "request":null,
            "convert":this.convertEnginePower,
            "convertReq":this.convertReqEnginePower,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalEPSDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalEPSModeStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalEPSWarnDisplayRequest] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_1] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_2] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_3] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_4] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_5] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_6] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_7] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalErrSys_8] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalESCDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalESCButtonStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalGear1RPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalGear2RPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalGear3RPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalGear4RPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalGear5RPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalGlobalDriveModeStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertGlobalModeStatus,
            "convertReq":this.convertReqGlobalMode,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.GLOBAL_MODE_UPDATE
         };
         this.mProperties[dbusSignalGlobalDriveModeConfigs] = {
            "value":null,
            "request":null,
            "convert":this.convertGlobalModeConfigs,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalHPDriveModeCfg] = {
            "value":null,
            "request":null,
            "convert":this.convertEnginePower,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalIsLegacyDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.LEGACY_DRIVE_MODE
         };
         this.mProperties[dbusSignalLaunchButtonStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertOnOff,
            "convertReq":this.convertOnOff,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.LAUNCH_STATUS
         };
         this.mProperties[dbusSignalLaunchRPMSetPoint] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.LAUNCH_RPM
         };
         this.mProperties[dbusSignalMaxShiftRPM] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.RPM_UPDATE
         };
         this.mProperties[dbusSignalPaddlesDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertPaddles,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalPaddlesDriveModeStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertPaddles,
            "convertReq":this.convertReqPaddles,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalPowerSteeringType] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalReady] = {
            "value":null,
            "request":null,
            "convert":this.convertReady,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":null
         };
         this.mProperties[dbusSignalRedKeyFeaturePresent] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":null
         };
         this.mProperties[dbusSignalRedKeyPresent] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalShiftIndicatorRPMReset] = {
            "value":null,
            "request":null,
            "convert":this.convertOnOff,
            "convertReq":this.convertOnOff,
            "hasReturn":false,
            "timer":null,
            "event":null
         };
         this.mProperties[dbusSignalShiftIndicatorStatus] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SHIFT_INDICATION
         };
         this.mProperties[dbusSignalSRTButtonStatus] = {
            "value":null,
            "request":null,
            "convert":this.convertOnOff,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SRT_HARDKEY
         };
         this.mProperties[dbusSignalTerrainDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertTerrain,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalTerrainMode] = {
            "value":null,
            "request":null,
            "convert":this.convertTerrain,
            "convertReq":this.convertReqTerrain,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalThrottlePosition] = {
            "value":null,
            "request":null,
            "convert":this.convertThrottle,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.THROTTLE_LOCKOUT
         };
         this.mProperties[dbusSignalTractionControlIndicator] = {
            "value":null,
            "request":null,
            "convert":this.convertOnOff,
            "convertRet":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalTransmissionDriveMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":null,
            "hasReturn":true,
            "timer":null,
            "event":DriveModeEvent.SET_UP_UPDATE
         };
         this.mProperties[dbusSignalTransmissionMode] = {
            "value":null,
            "request":null,
            "convert":this.convertGeneric,
            "convertReq":this.convertReq,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SCREEN_UPDATE
         };
         this.mProperties[dbusSignalValetLockOut] = {
            "value":null,
            "request":null,
            "convert":this.convertBoolean,
            "convertReq":null,
            "hasReturn":false,
            "timer":null,
            "event":DriveModeEvent.SHOW_VALET_KEYPAD
         };
      }
      
      private function createNonPropertyTables() : void
      {
         this.mProperties[signalDriveModeLogging] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "event":null
         };
         this.mProperties[signalDriveModeVersion] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "event":null
         };
         this.mProperties[signalValetUnlocked] = {
            "value":null,
            "request":null,
            "convert":null,
            "convertReq":null,
            "hasReturn":false,
            "event":DriveModeEvent.VALET_UNLOCKED
         };
      }
      
      private function processProperties(message:Object) : void
      {
         var Signal:String = null;
         try
         {
            for(Signal in message)
            {
               if(this.mProperties[Signal] != null)
               {
                  if(this.mProperties[Signal].timer != null)
                  {
                     this.removeTimerForProp(Signal);
                     this.mProperties[Signal].timer = null;
                  }
                  else if(this.isLegacyDriveModes)
                  {
                     this.clearErrorForProp(Signal);
                  }
                  this.mProperties[Signal].value = this.genericConversion(Signal,message[Signal]);
                  this.mProperties[Signal].request = this.genericConversion(Signal,message[Signal]);
                  if(this.mProperties[Signal].event != null)
                  {
                     this.dispatchEvent(new DriveModeEvent(this.mProperties[Signal].event));
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace("[ ERROR ] *<HMIModule> DriveMode.processProperties \'" + message + "\' not recognized!");
         }
      }
      
      private function debug(_str:String = "", _obj:* = null) : void
      {
         var _prop:String = null;
         var _composition:String = " #####DRIVEMODES##### : ";
         if(_obj == null)
         {
            _composition += _str;
         }
         else if(_obj is String || _obj is int)
         {
            _composition += _str;
            _composition += " ";
            _composition += _obj;
         }
         else if(_obj is Object)
         {
            for(_prop in _obj)
            {
               this.debug("Looking up Property: " + _prop,_obj[_prop]);
            }
         }
         trace(_composition);
      }
      
      private function createTimerForProp(prop:String, callBack:Function) : void
      {
         if(this.mProperties[prop].timer == null)
         {
            this.mProperties[prop].timer = new Timer(SUB_LEVEL_DELAY,1);
            this.mProperties[prop].timer.addEventListener(TimerEvent.TIMER_COMPLETE,callBack,false,0,true);
         }
         else
         {
            this.mProperties[prop].timer.reset();
         }
      }
      
      private function removeTimerForProp(prop:String) : void
      {
         var callBack:Function = null;
         switch(prop)
         {
            case dbusSignalEnginePowerMode:
               callBack = this.onHorsepowerComplete;
               break;
            case dbusSignalPaddlesDriveModeStatus:
               callBack = this.onPaddlesComplete;
               break;
            case dbusSignalESCButtonStatus:
               callBack = this.onStabilityComplete;
               break;
            case dbusSignalEPSModeStatus:
               callBack = this.onSteeringComplete;
               break;
            case dbusSignalActiveDampingStatus:
               callBack = this.onSuspensionComplete;
               break;
            case dbusSignalTransmissionMode:
               callBack = this.onTransmissionComplete;
         }
         if(callBack != null)
         {
            this.mProperties[prop].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,callBack);
         }
      }
      
      private function compareStatusForError(type:String) : void
      {
         switch(type)
         {
            case DriveModeTypes.HORSE_POWER:
               this.mProperties[dbusSignalErrSys_6].value = !this.EcoMode && this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalEnginePowerMode].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_6].event));
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               this.mProperties[dbusSignalErrSys_2].value = !this.EcoMode && this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalPaddlesDriveModeStatus].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_2].event));
               break;
            case DriveModeTypes.STEERING:
               this.mProperties[dbusSignalErrSys_1].value = this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalEPSModeStatus].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_1].event));
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               this.mProperties[dbusSignalErrSys_4].value = this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalESCButtonStatus].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_4].event));
               break;
            case DriveModeTypes.SUSPENSION:
               this.mProperties[dbusSignalErrSys_5].value = this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalActiveDampingStatus].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_5].event));
               break;
            case DriveModeTypes.TRANSMISSION:
               this.mProperties[dbusSignalErrSys_3].value = !this.EcoMode && this.mProperties[dbusSignalGlobalDriveModeConfigs].value[this.GlobalDriveModeStatus][type] != this.mProperties[dbusSignalTransmissionMode].value;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_3].event));
         }
      }
      
      private function clearErrorForProp(prop:String) : void
      {
         switch(prop)
         {
            case dbusSignalEnginePowerMode:
               this.mProperties[dbusSignalErrSys_6].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_6].event));
               break;
            case dbusSignalPaddlesDriveModeStatus:
               this.mProperties[dbusSignalErrSys_2].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_2].event));
               break;
            case dbusSignalEPSModeStatus:
               this.mProperties[dbusSignalErrSys_1].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_1].event));
               break;
            case dbusSignalESCButtonStatus:
               this.mProperties[dbusSignalErrSys_4].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_4].event));
               break;
            case dbusSignalActiveDampingStatus:
               this.mProperties[dbusSignalErrSys_5].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_5].event));
               break;
            case dbusSignalTransmissionMode:
               this.mProperties[dbusSignalErrSys_3].value = false;
               this.dispatchEvent(new DriveModeEvent(this.mProperties[dbusSignalErrSys_3].event));
         }
      }
      
      private function genericConversion(_prop:String, _val:*, onReturn:Boolean = false) : *
      {
         var _ret:* = undefined;
         var _fun:Function = onReturn ? this.mProperties[_prop].convertRet : this.mProperties[_prop].convert;
         if(_fun != null)
         {
            _ret = _fun(_val);
            if(_ret == DriveModeValues.LUA_SNA)
            {
               return this.mProperties[_prop].value;
            }
            return _fun(_val);
         }
         return _val;
      }
      
      private function convertGlobalModeStatus(_val:String) : String
      {
         if(_val == DriveModeValues.LUA_VALET)
         {
            this.mProperties[signalValetUnlocked].value = true;
            return DriveModeValues.HMI_VALET;
         }
         if(this.mProperties[signalValetUnlocked].value == true)
         {
            this.mProperties[signalValetUnlocked].value = false;
            this.dispatchEvent(new DriveModeEvent(this.mProperties[signalValetUnlocked].event));
         }
         switch(_val)
         {
            case DriveModeValues.LUA_DEFAULT:
               return DriveModeValues.HMI_DEFAULT;
            case DriveModeValues.LUA_SPORT:
               return DriveModeValues.HMI_SPORT;
            case DriveModeValues.LUA_TRACK:
               return DriveModeValues.HMI_TRACK;
            case DriveModeValues.LUA_CUSTOM:
               return DriveModeValues.HMI_CUSTOM;
            case DriveModeValues.LUA_SNOW:
               return DriveModeValues.HMI_SNOW;
            case DriveModeValues.LUA_TOW:
               return DriveModeValues.HMI_TOW;
            default:
               return _val;
         }
      }
      
      private function convertGlobalModeStatusWK(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_DEFAULT:
               if(this.mProperties[signalValetUnlocked].value == true)
               {
                  this.mProperties[signalValetUnlocked].value = false;
                  this.dispatchEvent(new DriveModeEvent(this.mProperties[signalValetUnlocked].event));
               }
               return DriveModeValues.HMI_AUTO;
            default:
               return this.convertGlobalModeStatus(_val);
         }
      }
      
      private function convertGlobalModeConfigs(_val:Object) : Object
      {
         var _obj:Object = {};
         if(_val.hasOwnProperty(DriveModeValues.LUA_DEFAULT))
         {
            _obj[DriveModeValues.HMI_DEFAULT] = this.createTable(_val.§default§);
         }
         if(_val.hasOwnProperty(DriveModeValues.LUA_TRACK))
         {
            _obj[DriveModeValues.HMI_TRACK] = this.createTable(_val.track);
         }
         if(_val.hasOwnProperty(DriveModeValues.LUA_SPORT))
         {
            _obj[DriveModeValues.HMI_SPORT] = this.createTable(_val.sport);
         }
         if(_val.hasOwnProperty(DriveModeValues.LUA_CUSTOM))
         {
            _obj[DriveModeValues.HMI_CUSTOM] = this.createTable(_val.custom);
         }
         return _obj;
      }
      
      private function convertGeneric(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_ECO:
               return DriveModeValues.HMI_ECO;
            case DriveModeValues.LUA_SNOW:
               return DriveModeValues.HMI_SNOW;
            case DriveModeValues.LUA_STREET:
               return DriveModeValues.HMI_STREET;
            case DriveModeValues.LUA_SPORT:
               return DriveModeValues.HMI_SPORT;
            case DriveModeValues.LUA_TRACK:
               return DriveModeValues.HMI_TRACK;
            case DriveModeValues.LUA_TOW:
               return DriveModeValues.HMI_TOW;
            case "off":
               return DriveModeValues.HMI_OFF;
            default:
               return _val;
         }
      }
      
      private function convertGenericNonSRT(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_STREET:
               return DriveModeValues.HMI_NORMAL;
            case DriveModeValues.LUA_SPORT:
               return DriveModeValues.HMI_SPORT;
            case DriveModeValues.LUA_TRACK:
               return DriveModeValues.HMI_COMFORT;
            default:
               return _val;
         }
      }
      
      private function convertPaddles(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_PADDLES_ON:
               return DriveModeValues.HMI_ON;
            case DriveModeValues.LUA_PADDLES_OFF:
               return DriveModeValues.HMI_OFF;
            default:
               return _val;
         }
      }
      
      private function convertReady(_val:String) : Boolean
      {
         if(_val == "true" && this.mReady != true)
         {
            this.getAll();
         }
         this.mReady = _val == "true";
         return this.mReady;
      }
      
      private function convertThrottle(_val:String) : Boolean
      {
         return _val == "pressed";
      }
      
      private function convertEnginePower(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_RED:
               return DriveModeValues.HMI_RED;
            case DriveModeValues.LUA_BLACK:
               return DriveModeValues.HMI_BLACK;
            case DriveModeValues.LUA_VALET:
               return DriveModeValues.HMI_VALET;
            default:
               return "SNA";
         }
      }
      
      private function convertTerrain(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_AUTO:
               return DriveModeValues.HMI_STREET;
            case DriveModeValues.LUA_SPORT:
               return DriveModeValues.HMI_SPORT;
            case DriveModeValues.LUA_TRACK:
               return DriveModeValues.HMI_TRACK;
            case DriveModeValues.LUA_SNOW:
               return DriveModeValues.HMI_HALF_HALF;
            case DriveModeValues.LUA_TOW:
               return DriveModeValues.HMI_TOW;
            default:
               return "SNA";
         }
      }
      
      private function convertOnOff(_val:*) : *
      {
         switch(_val)
         {
            case DriveModeValues.LUA_ON:
               return true;
            case DriveModeValues.LUA_OFF:
               return false;
            case true:
               return DriveModeValues.LUA_ON;
            case false:
               return DriveModeValues.LUA_OFF;
            default:
               return _val;
         }
      }
      
      private function convertBoolean(_val:String) : Boolean
      {
         return _val == "true";
      }
      
      private function convertESCStatus(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.LUA_SNOW:
               return DriveModeValues.HMI_FULL;
            default:
               return this.convertGeneric(_val);
         }
      }
      
      private function convertReqGlobalMode(_val:String) : String
      {
         switch(_val)
         {
            case DriveModeValues.HMI_DEFAULT:
               return DriveModeValues.LUA_DEFAULT;
            case DriveModeValues.HMI_SPORT:
               return DriveModeValues.LUA_SPORT;
            case DriveModeValues.HMI_TRACK:
               return DriveModeValues.LUA_TRACK;
            case DriveModeValues.HMI_CUSTOM:
               return DriveModeValues.LUA_CUSTOM;
            case DriveModeValues.HMI_VALET:
               return DriveModeValues.LUA_VALET;
            default:
               return _val;
         }
      }
      
      private function convertReq(_val:String) : Object
      {
         var _obj:Object = {};
         switch(_val)
         {
            case DriveModeValues.HMI_STREET:
            case DriveModeValues.HMI_NORMAL:
               _obj["value"] = DriveModeValues.LUA_STREET;
               break;
            case DriveModeValues.HMI_SPORT:
               _obj["value"] = DriveModeValues.LUA_SPORT;
               break;
            case DriveModeValues.HMI_TRACK:
            case DriveModeValues.HMI_COMFORT:
               _obj["value"] = DriveModeValues.LUA_TRACK;
               break;
            default:
               _obj["value"] = _val;
         }
         _obj["type"] = this.getGlobalMode();
         return _obj;
      }
      
      private function convertReqPaddles(_val:String) : Object
      {
         var _obj:Object = {};
         switch(_val)
         {
            case DriveModeValues.HMI_ON:
               _obj["value"] = DriveModeValues.LUA_PADDLES_ON;
               break;
            case DriveModeValues.HMI_OFF:
               _obj["value"] = DriveModeValues.LUA_PADDLES_OFF;
               break;
            default:
               _obj["value"] = _val;
         }
         _obj["type"] = this.getGlobalMode();
         return _obj;
      }
      
      private function convertReqEnginePower(_val:String) : Object
      {
         var _obj:Object = {};
         switch(_val)
         {
            case DriveModeValues.HMI_RED:
               _obj["value"] = DriveModeValues.LUA_RED;
               break;
            case DriveModeValues.HMI_BLACK:
               _obj["value"] = DriveModeValues.LUA_BLACK;
               break;
            default:
               _obj["value"] = _val;
         }
         _obj["type"] = this.getGlobalMode();
         return _obj;
      }
      
      private function convertReqTerrain(_val:String) : Object
      {
         var _obj:Object = {};
         switch(_val)
         {
            case DriveModeValues.HMI_STREET:
               _obj["value"] = DriveModeValues.LUA_AUTO;
               break;
            case DriveModeValues.HMI_SPORT:
               _obj["value"] = DriveModeValues.LUA_SPORT;
               break;
            case DriveModeValues.HMI_TRACK:
               _obj["value"] = DriveModeValues.LUA_TRACK;
               break;
            case DriveModeValues.HMI_HALF_HALF:
               _obj["value"] = DriveModeValues.LUA_SNOW;
               break;
            case DriveModeValues.HMI_TOW:
               _obj["value"] = DriveModeValues.LUA_TOW;
               break;
            default:
               _obj["value"] = _val;
         }
         _obj["type"] = this.getGlobalMode();
         return _obj;
      }
      
      private function createTable(_val:Object) : Object
      {
         var _prop:String = null;
         var _obj:Object = {};
         for(_prop in _val.values)
         {
            switch(_prop)
            {
               case dbusSignalTransmissionDriveMode:
                  _obj[DriveModeTypes.TRANSMISSION] = this.genericConversion(_prop,_val.values[_prop]);
                  break;
               case dbusSignalHPDriveModeCfg:
               case dbusSignalEngineDriveModeCfg:
                  _obj[DriveModeTypes.HORSE_POWER] = this.genericConversion(_prop,_val.values[_prop]);
                  break;
               case dbusSignalEPSDriveMode:
                  _obj[DriveModeTypes.STEERING] = this.genericConversion(_prop,_val.values[_prop]);
                  break;
               case dbusSignalESCDriveMode:
                  _obj[DriveModeTypes.STABILITY_CONTROL] = this.genericConversion(_prop,_val.values[_prop]);
                  break;
               case dbusSignalActiveDampingDriveMode:
                  _obj[DriveModeTypes.SUSPENSION] = this.genericConversion(_prop,_val.values[_prop]);
                  break;
               case dbusSignalPaddlesDriveMode:
                  _obj[DriveModeTypes.PADDLE_SHIFTER] = this.genericConversion(_prop,_val.values[_prop]);
            }
         }
         return _obj;
      }
      
      private function getGlobalMode() : String
      {
         if(this.isLegacyDriveModes)
         {
            return this.convertReqGlobalMode(this.mProperties[dbusSignalGlobalDriveModeStatus].request);
         }
         return this.convertReqGlobalMode(this.mProperties[dbusSignalGlobalDriveModeStatus].value);
      }
      
      private function modifyTable(_type:String, _val:*) : void
      {
         var _globalMode:String = "";
         if(!_val.hasOwnProperty("type") || !_val.hasOwnProperty("value"))
         {
            this.debug("Missing Property in ModifyTable");
            return;
         }
         switch(_val.type)
         {
            case DriveModeValues.LUA_SPORT:
               _globalMode = DriveModeValues.HMI_SPORT;
               break;
            case DriveModeValues.LUA_DEFAULT:
               _globalMode = DriveModeValues.HMI_DEFAULT;
               break;
            case DriveModeValues.LUA_TRACK:
               _globalMode = DriveModeValues.HMI_TRACK;
               break;
            case DriveModeValues.LUA_CUSTOM:
               _globalMode = DriveModeValues.HMI_CUSTOM;
         }
         switch(_type)
         {
            case dbusSignalEPSDriveMode:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.STEERING] = this.genericConversion(_type,_val.value);
               break;
            case dbusSignalPaddlesDriveMode:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.PADDLE_SHIFTER] = this.genericConversion(_type,_val.value);
               break;
            case dbusSignalTransmissionDriveMode:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.TRANSMISSION] = this.genericConversion(_type,_val.value);
               break;
            case dbusSignalESCDriveMode:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.STABILITY_CONTROL] = this.genericConversion(_type,_val.value);
               break;
            case dbusSignalActiveDampingDriveMode:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.SUSPENSION] = this.genericConversion(_type,_val.value);
               break;
            case dbusSignalHPDriveModeCfg:
            case dbusSignalEngineDriveModeCfg:
               this.mProperties[dbusSignalGlobalDriveModeConfigs].value[_globalMode][DriveModeTypes.HORSE_POWER] = this.genericConversion(_type,_val.value);
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
      
      private function emitSignal(signal:String, value:String) : void
      {
         this.client.send("{\"Type\":\"EmitSignal\",\"packet\":{\"" + signal + "\":{\"value\":\"" + value + "\"}}}");
      }
      
      private function sendSetProperties(prop:String, val:*) : void
      {
         val = this.mProperties[prop].convertReq != null ? this.mProperties[prop].convertReq(val) : val;
         var obj:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"setProperties":{"props":{}}}
         };
         obj.packet.setProperties.props[prop] = val;
         this.connection.send(obj);
      }
   }
}

