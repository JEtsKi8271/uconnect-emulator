package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.Applet;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.harman.moduleLinkAPI.PersistencyEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.VehConfigEvent;
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.enums.PopupType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import locale.T;
   
   public class DriveModeManager extends EventDispatcher
   {
      
      private var mEnterPin:String = "";
      
      private var mHasDriveMode:Boolean = false;
      
      private var mLastGlobalDrvMd:String = "";
      
      private var mValetPin:String = "0000";
      
      private var mHighHorsepowerMode:Boolean = false;
      
      private var mEco:Boolean = false;
      
      public function DriveModeManager()
      {
         super();
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnChanged,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalStatusChange,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SHOW_VALET_KEYPAD,this.onShowValetKeypad,false,0,true);
         Framework.messenger.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalStatusChange,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.VALET_UNLOCKED,this.onValetUnlocked,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SRT_HARDKEY,this.onSRTChange,false,0,true);
         this.onLegacyDriveMode(null);
         Peripheral.driveMode.addEventListener(DriveModeEvent.LEGACY_DRIVE_MODE,this.onLegacyDriveMode,false,0,true);
         this.onVehicleConfigAvailable(null);
         Peripheral.vehConfig.addEventListener(VehConfigEvent.AVAILABLE,this.onVehicleConfigAvailable);
         Peripheral.persistency.addEventListener(PersistencyKeys.KEY_VALET_PIN,this.onValetPin);
         Peripheral.persistency.read(PersistencyKeys.KEY_VALET_PIN);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.ECO_MODE,this.onEcoMode);
         Peripheral.driveMode.addEventListener(DriveModeEvent.ECO_MODE,this.onEcoMode);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOut,false,0,true);
      }
      
      public function get speedLockOut() : Boolean
      {
         return Peripheral.vehicleStatus.speedLockOut;
      }
      
      public function get highHorsepowerMode() : Boolean
      {
         return this.mHighHorsepowerMode;
      }
      
      public function get eco() : Boolean
      {
         return this.mEco;
      }
      
      public function enterDriveMode() : void
      {
         if(Peripheral.antiTheft.ignitionState != "on")
         {
            Framework.popupManager.show(DynamicPopupNames.DRIVEMODE_POPUP_IGNITION,Screens.DRIVEMODE_IGNITION,{"type":PopupType.PRIMARY});
         }
         else if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET)
         {
            this.disableValet();
         }
         else if(Peripheral.vehConfig.hasSRTPresent && Peripheral.vehConfig.hasDriveModePresent)
         {
            Framework.structure.goto(Screens.DRIVEMODE_MAIN);
         }
         else
         {
            Framework.structure.goto(Screens.DRIVEMODE_LAUNCHCONTROL,{"isRPMSetup":false});
         }
      }
      
      public function toggleValetMode() : void
      {
         var obj:Object = null;
         if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET)
         {
            this.disableValet();
         }
         else
         {
            switch(Peripheral.driveMode.ValetModeLockOutReason)
            {
               case DriveModeValues.LOCKOUT_CRUISE:
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP,{
                     "body":"Feature not available while cruise control set.",
                     "closeButton":false
                  });
                  return;
               case DriveModeValues.LOCKOUT_LAUNCH:
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP,{
                     "body":"Valet unavailable while using Launch Control.",
                     "closeButton":false
                  });
                  return;
               case DriveModeValues.LOCKOUT_NONE:
                  if(!this.checkSpeedLockout())
                  {
                     obj = {
                        "type":PopupType.PRIMARY,
                        "title":T.STRB_VALET_MODE,
                        "message":T.STRB_VALET_MODE_WILL_LIMIT_ML,
                        "caption1":T.STRB_YES,
                        "caption2":T.STRB_CANCEL,
                        "callBack":this.onEnterValetMode,
                        "showClose":true
                     };
                     Framework.popupManager.show(DynamicPopupNames.VALETMODE_ENTER_VALET_MODE,Screens.POPUP_2ITEM,obj);
                  }
            }
         }
      }
      
      public function checkSpeedLockout(temp:Boolean = true) : Boolean
      {
         if(this.speedLockOut)
         {
            if(temp)
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP,{
                  "body":T.STRB_ERROR_BODY_SPEED_LOCKOUT,
                  "closeButton":false
               });
            }
            else
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_FUNCTION_POPUP,{
                  "type":PopupType.PRIMARY,
                  "message":T.STRB_ERROR_BODY_SPEED_LOCKOUT,
                  "backgroudType":(Framework.structure.currentBranch == Screens.DRIVEMODE_SETUPDETAIL ? 2 : 1)
               });
            }
         }
         return this.speedLockOut;
      }
      
      public function get hasDriveMode() : Boolean
      {
         return this.mHasDriveMode;
      }
      
      private function onIgnChanged(evt:AntiTheftEvent) : void
      {
         switch(Peripheral.antiTheft.ignitionState)
         {
            case "on":
               if(Framework.popupManager.active == DynamicPopupNames.DRIVEMODE_POPUP_IGNITION)
               {
                  this.enterDriveMode();
                  Framework.popupManager.dequeue(DynamicPopupNames.DRIVEMODE_POPUP_IGNITION);
               }
               break;
            case "accessory":
               if(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_DRIVEMODES)
               {
                  if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET)
                  {
                     Framework.popupManager.show(DynamicPopupNames.DRIVEMODE_POPUP_IGNITION,Screens.DRIVEMODE_IGNITION,{"type":PopupType.PRIMARY});
                  }
                  else
                  {
                     Framework.structure.exit();
                     Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_KEYPAD);
                     Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_PIN_INFO);
                  }
               }
         }
      }
      
      private function onGlobalStatusChange(evt:DriveModeEvent) : void
      {
         if(evt.mData != null)
         {
            this.mLastGlobalDrvMd = evt.mData;
            return;
         }
         switch(Peripheral.driveMode.GlobalDriveModeStatus)
         {
            case DriveModeValues.HMI_VALET:
               if(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_DRIVEMODES && Framework.popupManager.active != DynamicPopupNames.VALETMODE_PIN_INFO)
               {
                  this.disableValet();
               }
               break;
            case DriveModeValues.HMI_CUSTOM:
               if(Peripheral.antiTheft.ignitionState == "on" && Peripheral.vehConfig.vehicleLine == "WK" && this.mHasDriveMode && this.mLastGlobalDrvMd != DriveModeValues.HMI_CUSTOM && Framework.mapping.getDomain(Framework.structure.currentBranch) != Screens.DOMAIN_DRIVEMODES)
               {
                  Framework.popupManager.show(DynamicPopupNames.DRIVEMODE_POPUP_WK_CUSTOM,Screens.DRIVEMODE_WKCUSTOM_POPUP,{
                     "timeout":5000,
                     "type":PopupType.PRIMARY
                  });
               }
         }
         this.mLastGlobalDrvMd = Peripheral.driveMode.GlobalDriveModeStatus;
      }
      
      private function onValetUnlocked(evt:DriveModeEvent) : void
      {
         if(Framework.mapping.getDomain(Framework.structure.currentBranch) != Screens.DOMAIN_DRIVEMODES)
         {
            Framework.structure.goto(Screens.DRIVEMODE_MAIN);
         }
      }
      
      private function onShowValetKeypad(evt:DriveModeEvent) : void
      {
         if(Peripheral.driveMode.ValetModeLockOut)
         {
            this.disableValet();
         }
      }
      
      private function onSRTChange(evt:DriveModeEvent) : void
      {
         if(Framework.mapping.getDomain(Framework.structure.currentBranch) != Screens.DOMAIN_DRIVEMODES)
         {
            if(Peripheral.driveMode.SRTButtonStatus == "true")
            {
               Framework.popupManager.exit();
               this.enterDriveMode();
            }
         }
      }
      
      private function onValetPin(evt:PersistencyEvent) : void
      {
         if(evt.value.hasOwnProperty("err"))
         {
            Framework.Trace("onValetPin: Error: " + evt.value.err);
            return;
         }
         this.mValetPin = evt.value.pin;
      }
      
      private function onVehicleConfigAvailable(event:VehConfigEvent) : void
      {
         Peripheral.driveMode.isWK = Peripheral.vehConfig.hasTSBMPresent;
         Peripheral.driveMode.isNonSRT = Peripheral.vehConfig.hasSportsMode && Peripheral.vehConfig.hasSportModePresent && !Peripheral.vehConfig.hasSRTPresent;
         switch(Peripheral.vehConfig.vehicleLine)
         {
            case "WK":
               this.mHasDriveMode = Peripheral.vehConfig.driveModeVersion == "Version_2" && Peripheral.vehConfig.hasDriveModePresent;
               break;
            case "LA":
            case "LD":
            case "LX":
               this.mHasDriveMode = Peripheral.vehConfig.hasDriveModePresent && (!Peripheral.vehConfig.hasSRTPresent && Peripheral.vehConfig.hasSportModePresent && Peripheral.vehConfig.hasSportsMode) || Peripheral.vehConfig.hasSRTPresent;
               if(Peripheral.driveMode.isLegacyDriveModes)
               {
                  this.mHasDriveMode = Peripheral.vehConfig.hasDriveModePresent && (Peripheral.vehConfig.hasSuperTrackPackPresent || Peripheral.vehConfig.hasSRTPresent);
               }
               break;
            default:
               this.mHasDriveMode = false;
         }
         this.setupDriveModeApp();
      }
      
      private function onLegacyDriveMode(e:DriveModeEvent) : void
      {
         if(Peripheral.driveMode.isLegacyDriveModes)
         {
            this.mHighHorsepowerMode = Peripheral.vehConfig.hasEngPowerDrvMdPresent && Peripheral.driveMode.RedKeyFeaturePresent && Peripheral.vehConfig.vehicleLine != "LX";
            Peripheral.vehSettings.removeEventListener(VehSettingsEvent.ECO_MODE,this.onEcoMode);
         }
         else
         {
            this.mHighHorsepowerMode = Peripheral.vehConfig.hasEngPowerDrvMdPresent && Peripheral.vehConfig.hasRedKeyPresent && Peripheral.vehConfig.vehicleLine != "LX";
            Peripheral.driveMode.removeEventListener(DriveModeEvent.ECO_MODE,this.onEcoMode);
         }
      }
      
      private function onSpeedLockOut(event:VehicleStatusEvent) : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.VALETMODE_KEYPAD && this.speedLockOut)
         {
            if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET)
            {
               this.disableValet();
               if(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_DRIVEMODES)
               {
                  Framework.structure.exit();
               }
               Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_KEYPAD);
            }
            else
            {
               this.checkSpeedLockout();
               Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_KEYPAD);
            }
         }
      }
      
      private function onEcoMode(event:Event) : void
      {
         if(Peripheral.driveMode.isLegacyDriveModes)
         {
            this.mEco = Peripheral.driveMode.EcoMode;
         }
         else
         {
            this.mEco = Peripheral.vehSettings.ecoMode() == "on";
         }
         Peripheral.driveModeManager.dispatchEvent(new DriveModeEvent(DriveModeEvent.SCREEN_UPDATE));
      }
      
      private function setupDriveModeApp() : void
      {
         var app:Applet = null;
         if(this.mHasDriveMode)
         {
            app = new Applet("Drive Mode");
            if(Peripheral.vehConfig.hasSRTPresent)
            {
               app.label = "SRT Drive Modes";
               app.lgicon = "file:///fs/mmc0/app/share/hmi/img/SRT Drive Modes.png";
               app.exlgicon = "file:///fs/mmc0/app/share/hmi/img/SRT Drive Modes.png";
            }
            else if(Peripheral.vehConfig.vehicleBrand == "1")
            {
               app.label = "Chrysler Performance Control";
               app.lgicon = "file:///fs/mmc0/app/share/hmi/img/ChryslerPerformanceControl.png";
               app.exlgicon = "file:///fs/mmc0/app/share/hmi/img/ChryslerPerformanceControl.png";
            }
            else if(Peripheral.vehConfig.vehicleBrand == "2")
            {
               app.label = "Dodge Performance Control";
               app.lgicon = "file:///fs/mmc0/app/share/hmi/img/DodgePerformanceControl.png";
               app.exlgicon = "file:///fs/mmc0/app/share/hmi/img/DodgePerformanceControl.png";
            }
            else
            {
               app.label = "Performance Control";
               app.lgicon = "file:///fs/mmc0/app/share/hmi/img/SRT Drive Modes.png";
               app.exlgicon = "file:///fs/mmc0/app/share/hmi/img/SRT Drive Modes.png";
            }
            Peripheral.appManager.driveModeApp = app;
            Peripheral.appManager.setDriveModeName(app.label);
         }
         else
         {
            Peripheral.appManager.driveModeApp = null;
         }
      }
      
      private function showKeypad() : void
      {
         var title:uint = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET ? T.STRB_VALET_MODE_DEACTIVATION : T.STRB_VALET_MODE_ACTIVATION;
         var message:uint = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET ? T.STRB_ENTER_PIN_USED_FOR_ML : T.STRB_ENTER_A_4_DIGIT_PIN_ML;
         Framework.popupManager.show(DynamicPopupNames.VALETMODE_KEYPAD,Screens.POPUP_KEYPAD,{
            "type":PopupType.PRIMARY,
            "input":this.mEnterPin,
            "title":title,
            "message":message,
            "callBack":this.onKeyPad
         });
      }
      
      private function disableValet() : void
      {
         if(this.speedLockOut)
         {
            Framework.popupManager.show(DynamicPopupNames.VALETMODE_SPEED_LOCKOUT,"popup1item",{
               "type":PopupType.PRIMARY,
               "title":T.STRB_VALET_MODE,
               "message":T.STRB_FUNCTION_NOT_AVAIL_ML,
               "caption1":T.STRB_OK,
               "showClose":true
            });
         }
         else
         {
            this.showKeypad();
         }
      }
      
      private function set enterPin(_pin:String) : void
      {
         if(this.mEnterPin == _pin)
         {
            Framework.popupManager.show(DynamicPopupNames.VALETMODE_PIN_INFO,"PopupInfo.swf",{
               "type":PopupType.PRIMARY,
               "title":T.STRB_VALET_MODE,
               "message":T.STRB_PIN_MUST_BE_4_DIGITS,
               "caption1":T.STRB_OK
            });
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
         else
         {
            this.mEnterPin = _pin;
         }
      }
      
      public function onEnterValetMode(o:Object) : void
      {
         this.showKeypad();
         Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_ENTER_VALET_MODE);
      }
      
      public function onKeyPad(o:Object) : void
      {
         if(o.hasOwnProperty("input"))
         {
            this.enterPin = o.input;
         }
         else if(o.name == "go_button")
         {
            if(o.mEnabled)
            {
               if(Peripheral.driveMode.GlobalDriveModeStatus != DriveModeValues.HMI_VALET)
               {
                  this.mValetPin = this.mEnterPin;
                  this.mEnterPin = "";
                  Peripheral.persistency.write(PersistencyKeys.KEY_VALET_PIN,{"pin":this.mValetPin});
                  Framework.popupManager.show(DynamicPopupNames.DRIVEMODE_POPUP_VALET_MODE,Screens.DRIVEMODE_VALET_MODE,{"type":PopupType.PRIMARY});
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
                  Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_VALET;
               }
               else if(this.mEnterPin == this.mValetPin)
               {
                  Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_VALET;
                  this.mEnterPin = "";
                  Framework.popupManager.show(DynamicPopupNames.VALETMODE_PIN_INFO,"PopupInfo.swf",{
                     "type":PopupType.PRIMARY,
                     "title":T.STRB_VALET_MODE,
                     "message":T.STRB_VALET_MODE_DEACTIVATED,
                     "caption1":T.STRB_OK
                  });
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
                  Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_KEYPAD);
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.VALETMODE_PIN_INFO,"PopupInfo.swf",{
                     "type":PopupType.PRIMARY,
                     "title":T.STRB_VALET_MODE,
                     "message":T.STRB_INCORRECT_PIN_ENTERED,
                     "caption1":T.STRB_OK
                  });
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               }
            }
            else
            {
               Framework.popupManager.show(DynamicPopupNames.VALETMODE_PIN_INFO,"PopupInfo.swf",{
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_VALET_MODE,
                  "message":T.STRB_PIN_MUST_BE_4_DIGITS,
                  "caption1":T.STRB_OK
               });
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
         }
         else if(o.name == "close_button")
         {
            this.mEnterPin = "";
            if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_VALET)
            {
               if(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_DRIVEMODES)
               {
                  Framework.structure.exit();
               }
            }
            Framework.popupManager.dequeue(DynamicPopupNames.VALETMODE_KEYPAD);
         }
      }
      
      public function getCustomerSettings(_type:String, _mode:String = "") : String
      {
         if(_mode == "")
         {
            _mode = Peripheral.driveMode.GlobalDriveModeStatus;
         }
         if(Peripheral.driveMode.isLegacyDriveModes)
         {
            return Peripheral.driveMode.GlobalDriveModeTables[_mode][_type];
         }
         switch(_type)
         {
            case DriveModeTypes.HORSE_POWER:
               if(Peripheral.vehConfig.hasSRTPresent)
               {
                  return Peripheral.driveMode.HorsepowerModeRequest;
               }
               return Peripheral.driveMode.EngineModeCustomStatus;
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               return Peripheral.driveMode.PaddleShifterCustomStatus;
            case DriveModeTypes.STABILITY_CONTROL:
               return Peripheral.driveMode.StabilityCustomStatus;
            case DriveModeTypes.STEERING:
               return Peripheral.driveMode.SteeringCustomStatus;
            case DriveModeTypes.SUSPENSION:
               return Peripheral.driveMode.SuspensionCustomStatus;
            case DriveModeTypes.TRANSMISSION:
               return Peripheral.driveMode.TransmissionModeCustomStatus;
            default:
               return "Error";
         }
      }
   }
}

