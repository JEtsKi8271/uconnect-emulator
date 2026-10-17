package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVehicleStatus;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VehicleStatus extends Module implements IVehicleStatus
   {
      
      private static var instance:VehicleStatus;
      
      private static const dbusIdentifier:String = "VehicleStatus";
      
      private static const dbusIdCANService:String = "canservice";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mTestToolPresent:Boolean = false;
      
      private var mSpeedLockOut:Boolean = false;
      
      private var mSpeedLockOutFeature:String = "undefined";
      
      private var mheadlightsOn:Boolean = true;
      
      private var mLanguage:String = "en_US";
      
      private var mVehServiceReady:Boolean = false;
      
      private var mVehStatusServicePresent:Boolean = false;
      
      private var mLangUnitMstrOverride:String = "off";
      
      private var mThemeFileOverride:String = "off";
      
      private var mFuelSaverModeActual:String = "na";
      
      private var mIgnitionState:String = "undefined";
      
      private var mVehicleInPark:Boolean = false;
      
      private var mSelecTerrainModeStatus:Boolean = false;
      
      private var mTeenKeyPresent:Boolean = false;
      
      private var mResumeModeTimeout:int = 0;
      
      private var mIsVehicleMoving:Boolean = false;
      
      private var mCurrentGear:String = "";
      
      private var mDriverDoorStatus:String = "";
      
      private var mVehicleInMotion:Boolean = false;
      
      private var mEPBServiceModeActiveAlert:Boolean = false;
      
      private var mSurroundCameraLockActive:Boolean = false;
      
      private var mKeySensePinTimerValue:int = 0;
      
      private var mGearDisplay:String = "SNA";
      
      private var mSelecTerrainModePrevTheme:String = "Default/001_Uconnect.swf";
      
      private var mKeySenseSecurityPIN:String = "FFFF";
      
      public function VehicleStatus()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : VehicleStatus
      {
         if(instance == null)
         {
            instance = new VehicleStatus();
         }
         return instance;
      }
      
      override public function addInterest(signalName:String) : void
      {
      }
      
      override public function removeInterest(signalName:String) : void
      {
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_STATUS,this.VehicleStatusMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendMultiSubscribe(["speedLockOut","speedLockOutFeature","headlightsOn","comfortFeaturesDisabled","language","testToolPresent","themeFileOverride","selecTerrainModeStatus","langUnitMstrOverride","fuelSaverModeActual","vehicleInPark","ready","ignitionState","TeenKeyIsPresent","resumeModeTimeout","currentGear","driverDoorStatus","vehicleInMotion","EPBServiceActivePopup","rearCameraSpeedDelay","KeySenseTimerValue","gearDisplay","selecTerrainModePrevTheme","keySenseSecurityPINReset"]);
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
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
      
      public function VehicleStatusMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mVehStatusServicePresent == false)
            {
               this.mVehStatusServicePresent = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getKeySenseSecurityPIN\": {}}}");
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mVehStatusServicePresent = false;
            }
         }
         else if(resp.hasOwnProperty("getAllProperties"))
         {
            if(resp.getAllProperties.hasOwnProperty("speedLockOut"))
            {
               this.mSpeedLockOut = Boolean(resp.getAllProperties.speedLockOut == "enabled");
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT,this.mSpeedLockOut));
            }
            if(resp.getAllProperties.hasOwnProperty("vehicleInPark"))
            {
               this.mVehicleInPark = Boolean(resp.getAllProperties.vehicleInPark == "true");
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEHICLE_IN_PARK,this.mVehicleInPark));
            }
            if(resp.getAllProperties.hasOwnProperty("speedLockOutFeature"))
            {
               this.mSpeedLockOutFeature = resp.getAllProperties.speedLockOutFeature;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
            }
            if(resp.getAllProperties.hasOwnProperty("headlightsOn"))
            {
               this.mheadlightsOn = resp.getAllProperties.headlightsOn;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.HEADLIGHTS_ON));
            }
            if(resp.getAllProperties.hasOwnProperty("language"))
            {
               this.mLanguage = resp.getAllProperties.language;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE));
            }
            if(resp.getAllProperties.hasOwnProperty("testToolPresent"))
            {
               this.mTestToolPresent = resp.getAllProperties.testToolPresent;
            }
            if(resp.getAllProperties.hasOwnProperty("themeFileOverride"))
            {
               this.mThemeFileOverride = resp.getAllProperties.themeFileOverride;
            }
            if(resp.getAllProperties.hasOwnProperty("selecTerrainModeStatus"))
            {
               this.mSelecTerrainModeStatus = resp.getAllProperties.selecTerrainModeStatus;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SELECTERRAIN_MODE_STATUS));
            }
            if(resp.getAllProperties.hasOwnProperty("langUnitMstrOverride"))
            {
               this.mLangUnitMstrOverride = resp.getAllProperties.langUnitMstrOverride;
            }
            if(resp.getAllProperties.hasOwnProperty("fuelSaverModeActual"))
            {
               this.mFuelSaverModeActual = resp.getAllProperties.fuelSaverModeActual;
            }
            if(resp.getAllProperties.hasOwnProperty("ignition"))
            {
               this.mIgnitionState = resp.getAllProperties.ignition;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.IGNITION_STATE));
            }
            if(resp.getAllProperties.hasOwnProperty("TeenKeyIsPresent"))
            {
               this.mTeenKeyPresent = resp.getAllProperties.TeenKeyIsPresent;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.TEEN_KEY_PRESENT));
            }
            if(resp.getAllProperties.hasOwnProperty("resumeModeTimeout"))
            {
               this.mResumeModeTimeout = resp.getAllProperties.resumeModeTimeout;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.RESUME_MODE_TIMEOUT));
            }
            if(resp.getAllProperties.hasOwnProperty("currentGear"))
            {
               this.mCurrentGear = resp.getAllProperties.currentGear;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.GEAR_UPDATE));
            }
            if(resp.getAllProperties.hasOwnProperty("driverDoorStatus"))
            {
               this.mDriverDoorStatus = resp.getAllProperties.driverDoorStatus;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.DRV_DR_STATUS_UPDATE));
            }
            if(resp.getAllProperties.hasOwnProperty("vehicleInMotion"))
            {
               this.mVehicleInMotion = resp.getAllProperties.vehicleInMotion;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEH_IN_MOTION_UPDATE));
            }
            if(resp.getAllProperties.hasOwnProperty("EPBServiceActivePopup"))
            {
               this.mEPBServiceModeActiveAlert = resp.getAllProperties.EPBServiceActivePopup;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.EPB_SERVICE_ACTIVE_ALERT));
            }
            if(resp.getAllProperties.hasOwnProperty("rearCameraSpeedDelay"))
            {
               this.mSurroundCameraLockActive = resp.getAllProperties.rearCameraSpeedDelay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SVC_SPEED_LOCKOUT_STATUS));
            }
            if(resp.getAllProperties.hasOwnProperty("KeySenseTimerValue"))
            {
               this.mKeySensePinTimerValue = resp.getAllProperties.KeySenseTimerValue;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.KEYSENSE_TIMER_VALUE));
            }
            if(resp.getAllProperties.hasOwnProperty("gearDisplay"))
            {
               this.mGearDisplay = resp.getAllProperties.gearDisplay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.GEAR_DISPLAY_UPDATE));
            }
            if(resp.getAllProperties.hasOwnProperty("selecTerrainModePrevTheme"))
            {
               this.mSelecTerrainModePrevTheme = resp.getAllProperties.selecTerrainModePrevTheme;
            }
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         else if(resp.hasOwnProperty("speedLockOut"))
         {
            this.mSpeedLockOut = Boolean(resp.speedLockOut.speedLockOut == "enabled");
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT,this.mSpeedLockOut));
         }
         else if(resp.hasOwnProperty("vehicleInPark"))
         {
            this.mVehicleInPark = Boolean(resp.vehicleInPark.vehicleInPark == "true");
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEHICLE_IN_PARK,this.mVehicleInPark));
         }
         else if(resp.hasOwnProperty("setSpeedLockOutFeature"))
         {
            this.mSpeedLockOutFeature = resp.setSpeedLockOutFeature.setting;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
         }
         else if(resp.hasOwnProperty("speedLockOutFeature"))
         {
            this.mSpeedLockOutFeature = resp.speedLockOutFeature.setting;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
         }
         else if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("speedLockOutFeature"))
            {
               this.mSpeedLockOutFeature = resp.getProperties.speedLockOutFeature;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
            }
            if(resp.getProperties.hasOwnProperty("TeenKeyIsPresent"))
            {
               this.mTeenKeyPresent = resp.getProperties.TeenKeyIsPresent;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.TEEN_KEY_PRESENT));
            }
            if(resp.getProperties.hasOwnProperty("resumeModeTimeout"))
            {
               this.mResumeModeTimeout = resp.getProperties.resumeModeTimeout;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.RESUME_MODE_TIMEOUT));
            }
            if(resp.getProperties.hasOwnProperty("EPBServiceActivePopup"))
            {
               this.mEPBServiceModeActiveAlert = resp.getProperties.EPBServiceActivePopup;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.EPB_SERVICE_ACTIVE_ALERT));
            }
            if(resp.getProperties.hasOwnProperty("rearCameraSpeedDelay"))
            {
               this.mSurroundCameraLockActive = resp.getProperties.rearCameraSpeedDelay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SVC_SPEED_LOCKOUT_STATUS));
            }
            if(resp.getProperties.hasOwnProperty("KeySenseTimerValue"))
            {
               this.mKeySensePinTimerValue = resp.getProperities.KeySenseTimerValue;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.KEYSENSE_TIMER_VALUE));
            }
            if(resp.getProperties.hasOwnProperty("gearDisplay"))
            {
               this.mGearDisplay = resp.getProperities.gearDisplay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.GEAR_DISPLAY_UPDATE));
            }
            if(resp.getProperties.hasOwnProperty("selecTerrainModePrevTheme"))
            {
               this.mSelecTerrainModePrevTheme = resp.getProperities.selecTerrainModePrevTheme;
            }
         }
         else if(resp.hasOwnProperty("headlightsOn"))
         {
            this.mheadlightsOn = resp.headlightsOn.headlightsOn;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.HEADLIGHTS_ON));
         }
         else if(resp.hasOwnProperty("language"))
         {
            this.mLanguage = resp.language.language;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE,resp.language));
         }
         else if(resp.hasOwnProperty("themeFileOverride"))
         {
            this.mThemeFileOverride = resp.themeFileOverride.themeFileOverride;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.THEME_OVERRIDE));
         }
         else if(resp.hasOwnProperty("selecTerrainModeStatus"))
         {
            this.mSelecTerrainModeStatus = resp.selecTerrainModeStatus.selecTerrainModeStatus;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SELECTERRAIN_MODE_STATUS));
         }
         else if(resp.hasOwnProperty("langUnitMstrOverride"))
         {
            this.mLangUnitMstrOverride = resp.langUnitMstrOverride.langUnitMstrOverride;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANG_UNIT_MST_OVERRIDE));
         }
         else if(!resp.hasOwnProperty("ready"))
         {
            if(resp.hasOwnProperty("testToolPresent"))
            {
               this.mTestToolPresent = resp.testToolPresent.testToolPresent;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.TEST_TOOL_PRESENT));
            }
            else if(resp.hasOwnProperty("fuelSaverModeActual"))
            {
               this.mFuelSaverModeActual = resp.fuelSaverModeActual.fuelSaverModeActual;
            }
            else if(resp.hasOwnProperty("ignitionState"))
            {
               this.mIgnitionState = resp.ignitionState.state;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.IGNITION_STATE));
            }
            else if(resp.hasOwnProperty("TeenKeyIsPresent"))
            {
               this.mTeenKeyPresent = resp.TeenKeyIsPresent.TeenKeyIsPresent;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.TEEN_KEY_PRESENT));
            }
            else if(resp.hasOwnProperty("resumeModeTimeout"))
            {
               this.mResumeModeTimeout = resp.resumeModeTimeout.resumeModeTimeout;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.RESUME_MODE_TIMEOUT));
            }
            else if(resp.hasOwnProperty("isVehicleMoving"))
            {
               this.mIsVehicleMoving = resp.isVehicleMoving;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEHICLE_MOVING));
            }
            else if(resp.hasOwnProperty("currentGear"))
            {
               this.mCurrentGear = resp.currentGear.currentGear;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.GEAR_UPDATE));
            }
            else if(resp.hasOwnProperty("driverDoorStatus"))
            {
               this.mDriverDoorStatus = resp.driverDoorStatus.driverDoorStatus;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.DRV_DR_STATUS_UPDATE));
            }
            else if(resp.hasOwnProperty("vehicleInMotion"))
            {
               this.mVehicleInMotion = resp.vehicleInMotion.vehicleInMotion;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEH_IN_MOTION_UPDATE));
            }
            else if(resp.hasOwnProperty("EPBServiceActivePopup"))
            {
               this.mEPBServiceModeActiveAlert = resp.EPBServiceActivePopup.EPBServiceActivePopup;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.EPB_SERVICE_ACTIVE_ALERT));
            }
            else if(resp.hasOwnProperty("rearCameraSpeedDelay"))
            {
               this.mSurroundCameraLockActive = resp.rearCameraSpeedDelay.rearCameraSpeedDelay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SVC_SPEED_LOCKOUT_STATUS));
            }
            else if(resp.hasOwnProperty("KeySenseTimerValue"))
            {
               this.mKeySensePinTimerValue = resp.KeySenseTimerValue.KeySenseTimerValue;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.KEYSENSE_TIMER_VALUE));
            }
            else if(resp.hasOwnProperty("gearDisplay"))
            {
               this.mGearDisplay = resp.gearDisplay.gearDisplay;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.GEAR_DISPLAY_UPDATE));
            }
            else if(resp.hasOwnProperty("selecTerrainModePrevTheme"))
            {
               this.mSelecTerrainModePrevTheme = resp.selecTerrainModePrevTheme.selecTerrainModePrevTheme;
            }
            else if(resp.hasOwnProperty("getKeySenseSecurityPIN"))
            {
               if(resp.getKeySenseSecurityPIN.hasOwnProperty("KeySensePIN"))
               {
                  this.mKeySenseSecurityPIN = resp.getKeySenseSecurityPIN.KeySensePIN;
               }
            }
            else if(resp.hasOwnProperty("setKeySenseSecurityPIN"))
            {
               if(resp.setKeySenseSecurityPIN.hasOwnProperty("Success"))
               {
                  if(resp.setKeySenseSecurityPIN.Success == false)
                  {
                     this.requestKeySenseSecurityPIN();
                  }
               }
            }
            else if(resp.hasOwnProperty("keySenseSecurityPINReset"))
            {
               if(resp.keySenseSecurityPINReset.keySenseSecurityPINReset == true)
               {
                  this.requestKeySenseSecurityPIN();
               }
            }
         }
      }
      
      public function getSpeedLockoutFeatureState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"speedLockOutFeature\"]}}}");
      }
      
      public function toggleSpeedLockOutFeature() : void
      {
         if(this.mSpeedLockOutFeature == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setSpeedLockOutFeature\":{\"setting\":\"off\"}}}");
         }
         else if(this.mSpeedLockOutFeature == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setSpeedLockOutFeature\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function set speedLockOut(locked:Boolean) : void
      {
         this.mSpeedLockOut = locked;
         this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT));
      }
      
      public function get vehicleInPark() : Boolean
      {
         return this.mVehicleInPark;
      }
      
      public function get speedLockOut() : Boolean
      {
         return this.mSpeedLockOut;
      }
      
      public function get speedLockOutFeature() : String
      {
         return this.mSpeedLockOutFeature;
      }
      
      public function get headlightsOn() : Boolean
      {
         return this.mheadlightsOn;
      }
      
      public function get language() : String
      {
         return this.mLanguage;
      }
      
      public function getLanguage() : void
      {
         this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE));
      }
      
      public function get TestToolPresent() : Boolean
      {
         return this.mTestToolPresent;
      }
      
      public function get LangUnitMstrOverride() : String
      {
         return this.mLangUnitMstrOverride;
      }
      
      public function toggleLangUnitMstrOverride() : void
      {
         if(this.mLangUnitMstrOverride == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setLangUnitMstrOverride\":{\"setting\":\"off\"}}}");
         }
         else if(this.mLangUnitMstrOverride == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setLangUnitMstrOverride\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function get ThemeFileOverride() : String
      {
         return this.mThemeFileOverride;
      }
      
      public function toggleThemeFileOverride() : void
      {
         if(this.mThemeFileOverride == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setThemeOverride\":{\"setting\":\"off\"}}}");
         }
         else if(this.mThemeFileOverride == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setThemeOverride\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function get SelecTerrainModeStatus() : Boolean
      {
         return this.mSelecTerrainModeStatus;
      }
      
      public function setSelecTerrainModeStatus(status:Boolean) : void
      {
         this.mSelecTerrainModeStatus = status;
         if(status)
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"setSelecTerrainModeStatus\":{\"setting\":true}}}");
         }
         else
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"setSelecTerrainModeStatus\":{\"setting\":false}}}");
         }
      }
      
      public function setThemeTo(theme:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"setThemeTo\":{\"newTheme\":\"" + theme + "\"}}}");
      }
      
      public function get fuelSaverModeActual() : String
      {
         return this.mFuelSaverModeActual;
      }
      
      public function getIgnitionState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"ignition\"]}}}");
      }
      
      public function get ignitionState() : String
      {
         return this.mIgnitionState;
      }
      
      public function getTeenKeyIsPresent() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"TeenKeyIsPresent\"]}}}");
      }
      
      public function get TeenKeyIsPresent() : Boolean
      {
         return this.mTeenKeyPresent;
      }
      
      public function getResumeModeTimeout() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"resumeModeTimeout\"]}}}");
      }
      
      public function setResumeModeTimeout(timeout:int) : void
      {
         this.mResumeModeTimeout = timeout;
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setResumeModeTimeout\":{\"setting\":\"" + timeout + "\"}}}");
      }
      
      public function get resumeModeTimeout() : int
      {
         return this.mResumeModeTimeout;
      }
      
      public function getIsVehicleMoving() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"isVehicleMoving\":{}}}");
      }
      
      public function get isVehicleMoving() : Boolean
      {
         return this.mIsVehicleMoving;
      }
      
      public function getCurrentGear() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"currentGear\"]}}}");
      }
      
      public function get currentGear() : String
      {
         return this.mCurrentGear;
      }
      
      public function getDriverDoorStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"driverDoorStatus\"]}}}");
      }
      
      public function get driverDoorStatus() : String
      {
         return this.mDriverDoorStatus;
      }
      
      public function getVehicleInMotion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"vehicleInMotion\"]}}}");
      }
      
      public function get vehicleInMotion() : Boolean
      {
         return this.mVehicleInMotion;
      }
      
      public function getEPBServiceActiveAlert() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"EPBServiceActivePopup\"]}}}");
      }
      
      public function get EPBServiceActiveAlert() : Boolean
      {
         return this.mEPBServiceModeActiveAlert;
      }
      
      public function getSVCSpeedLockoutStatus() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"rearCameraSpeedDelay\"]}}}");
      }
      
      public function get SVCSpeedLockoutStatus() : Boolean
      {
         return this.mSurroundCameraLockActive;
      }
      
      public function getKeySensePinTimer() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"KeySenseTimerValue\"]}}}");
      }
      
      public function get KeySensePinTimer() : int
      {
         return this.mKeySensePinTimerValue;
      }
      
      public function setKeySensePinTimerState(status:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setKeySenseTimer\":{\"setting\":\"" + status + "\"}}}");
      }
      
      public function getGearDisplay() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"gearDisplay\"]}}}");
      }
      
      public function get gearDisplay() : String
      {
         return this.mGearDisplay;
      }
      
      public function getSelecTerrainModePrevTheme() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"selecTerrainModePrevTheme\"]}}}");
      }
      
      public function get selecTerrainModePrevTheme() : String
      {
         return this.mSelecTerrainModePrevTheme;
      }
      
      public function setSelecTerrainModePrevTheme(theme:String) : void
      {
         this.mSelecTerrainModePrevTheme = theme;
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"setSelecTerrainModePrevTheme\":{\"theme\":\"" + theme + "\"}}}");
      }
      
      public function requestKeySenseSecurityPIN() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"getKeySenseSecurityPIN\":{}}}");
      }
      
      public function get keySenseSecurityPIN() : String
      {
         return this.mKeySenseSecurityPIN;
      }
      
      public function set keySenseSecurityPIN(_pin:String) : void
      {
         this.mKeySenseSecurityPIN = _pin;
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\":{\"setKeySenseSecurityPIN\":{\"pin\":\"" + _pin + "\"}}}");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

