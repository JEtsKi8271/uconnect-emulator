package extensions.drivemode
{
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.WidgetEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DriveModeSRTMain implements IDriveModeMainExtension
   {
      
      private const ERROR_GENERIC:int = 0;
      
      private const ERROR_LAUNCH:int = 1;
      
      private const ERROR_HORSEPOWER:int = 2;
      
      private const ERROR_THROTTLE:int = 3;
      
      private var mParent:*;
      
      private var mContents:Array = [];
      
      private var mErrors:Array = new Array(4);
      
      private var messageTimeout:Timer = new Timer(5000,0);
      
      public function DriveModeSRTMain(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function addListeners() : void
      {
         this.mParent.view.Layer_SRT.custom_button.addEventListener(WidgetEvent.CLICK,this.onCustomClick,false,0,true);
         this.mParent.view.Layer_SRT.default_button.addEventListener(WidgetEvent.CLICK,this.onDefaultClick,false,0,true);
         this.mParent.view.Layer_SRT.display_driveMode_status_group.addEventListener(WidgetEvent.CLICK,this.onSetupClick,false,0,true);
         this.mParent.view.Layer_SRT.eco_button.addEventListener(WidgetEvent.CLICK,this.onEcoClick,false,0,true);
         this.mParent.view.Layer_SRT.buttons_group.black_key_button.addEventListener(WidgetEvent.CLICK,this.onKeyClick,false,0,true);
         this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.close_button.addEventListener(WidgetEvent.CLICK,this.onCloseKeyPopupClick,false,0,true);
         this.mParent.view.Layer_SRT.buttons_group.red_key_button.addEventListener(WidgetEvent.CLICK,this.onKeyClick,false,0,true);
         this.mParent.view.Layer_SRT.setup_button.addEventListener(WidgetEvent.CLICK,this.onSetupClick,false,0,true);
         this.mParent.view.Layer_SRT.sport_button.addEventListener(WidgetEvent.CLICK,this.onSportClick,false,0,true);
         this.mParent.view.Layer_SRT.track_button.addEventListener(WidgetEvent.CLICK,this.onTrackClick,false,0,true);
         this.messageTimeout.addEventListener(TimerEvent.TIMER,this.onMessageTimeout,false,0,true);
      }
      
      public function changeLocale() : void
      {
         Text.format(this.mParent.view.Layer_SRT.custom_button.label,DriveModeValues.HMI_CUSTOM);
         Text.format(this.mParent.view.Layer_SRT.default_button.label,DriveModeValues.HMI_DEFAULT);
         Text.format(this.mParent.view.Layer_SRT.sport_button.label,DriveModeValues.HMI_SPORT);
         Text.format(this.mParent.view.Layer_SRT.track_button.label,DriveModeValues.HMI_TRACK);
         Text.format(this.mParent.view.Layer_SRT.eco_button.label,T.STRB_ECO);
      }
      
      public function cleanup() : void
      {
      }
      
      public function initScreen(screenVars:Object = null) : void
      {
         this.mErrors[this.ERROR_GENERIC] = false;
         this.mErrors[this.ERROR_LAUNCH] = false;
         this.mErrors[this.ERROR_HORSEPOWER] = false;
         this.mErrors[this.ERROR_THROTTLE] = false;
         if(screenVars != null && screenVars.hasOwnProperty("horsePowerError"))
         {
            this.mErrors[this.ERROR_HORSEPOWER] = screenVars.horsePowerError;
         }
         if(screenVars != null && screenVars.hasOwnProperty("throttleError"))
         {
            this.mErrors[this.ERROR_THROTTLE] = screenVars.throttleError;
         }
         Framework.structure.findAndReplace(Screens.DRIVEMODE_MAIN,Screens.DRIVEMODE_MAIN);
         this.updateMainScreen();
      }
      
      public function initView() : void
      {
         this.mParent.view.Layer_WK.visible = false;
         this.mParent.view.Layer_SRT.visible = true;
         this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.visible = false;
         this.mParent.view.Layer_SRT.Warning_icon.visible = false;
         this.mParent.view.Layer_SRT.Warning_message.visible = false;
         this.mParent.view.Layer_SRT.srt_button.visible = Peripheral.appManager.getPPId() != "";
         this.mParent.view.Layer_SRT.srt_graphic.visible = Peripheral.appManager.getPPId() == "";
         this.mParent.view.Layer_SRT.buttons_group.info.visible = Peripheral.driveModeManager.highHorsepowerMode;
         this.mParent.view.Layer_SRT.valet_button.visible = !Peripheral.vehConfig.hasEcoMode;
         this.mParent.view.Layer_SRT.valet_button_eco.visible = Peripheral.vehConfig.hasEcoMode;
         this.mParent.view.Layer_SRT.eco_button.visible = Peripheral.vehConfig.hasEcoMode;
         this.mParent.view.Layer_SRT.valet_button.alwaysClick = true;
         this.mParent.view.Layer_SRT.valet_button_eco.alwaysClick = true;
      }
      
      public function removeListeners() : void
      {
         this.mParent.view.Layer_SRT.custom_button.removeEventListener(WidgetEvent.CLICK,this.onCustomClick);
         this.mParent.view.Layer_SRT.default_button.removeEventListener(WidgetEvent.CLICK,this.onDefaultClick);
         this.mParent.view.Layer_SRT.display_driveMode_status_group.removeEventListener(WidgetEvent.CLICK,this.onSetupClick);
         this.mParent.view.Layer_SRT.eco_button.removeEventListener(WidgetEvent.CLICK,this.onEcoClick);
         this.mParent.view.Layer_SRT.buttons_group.black_key_button.removeEventListener(WidgetEvent.CLICK,this.onKeyClick);
         this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.close_button.removeEventListener(WidgetEvent.CLICK,this.onCloseKeyPopupClick);
         this.mParent.view.Layer_SRT.buttons_group.red_key_button.removeEventListener(WidgetEvent.CLICK,this.onKeyClick);
         this.mParent.view.Layer_SRT.setup_button.removeEventListener(WidgetEvent.CLICK,this.onSetupClick);
         this.mParent.view.Layer_SRT.sport_button.removeEventListener(WidgetEvent.CLICK,this.onSportClick);
         this.mParent.view.Layer_SRT.track_button.removeEventListener(WidgetEvent.CLICK,this.onTrackClick);
         this.messageTimeout.removeEventListener(TimerEvent.TIMER,this.onMessageTimeout);
      }
      
      public function updateMainScreen() : void
      {
         this.updateGlobalMode();
         this.setCarStatus();
         this.setSubItems();
         this.checkForError();
         this.setErrorMessage();
      }
      
      public function onLockOut() : void
      {
         if(Peripheral.driveModeManager.speedLockOut)
         {
            this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.visible = false;
            this.mParent.view.Layer_SRT.valet_button.setEnabled(false);
            this.mParent.view.Layer_SRT.valet_button_eco.setEnabled(false);
         }
         else
         {
            this.mParent.view.Layer_SRT.valet_button.setEnabled(Peripheral.driveMode.ValetModeLockOutReason == DriveModeValues.LOCKOUT_NONE);
            this.mParent.view.Layer_SRT.valet_button_eco.setEnabled(Peripheral.driveMode.ValetModeLockOutReason == DriveModeValues.LOCKOUT_NONE);
         }
         if(Peripheral.driveMode.ThrottleLockOut == false)
         {
            this.mErrors[this.ERROR_THROTTLE] = false;
            this.setSubItems();
            this.setErrorMessage();
         }
         if(Peripheral.driveMode.HorsepowerModeError == false)
         {
            this.mErrors[this.ERROR_HORSEPOWER] = false;
            this.setSubItems();
            this.setErrorMessage();
         }
      }
      
      private function onCustomClick(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.GlobalDriveModeError)
         {
            this.mErrors[this.ERROR_LAUNCH] = true;
            this.messageTimeout.start();
            this.setErrorMessage();
         }
         else
         {
            Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_CUSTOM;
         }
      }
      
      private function onCloseKeyPopupClick(evt:WidgetEvent) : void
      {
         this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.visible = false;
      }
      
      private function onDefaultClick(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.GlobalDriveModeError)
         {
            this.mErrors[this.ERROR_LAUNCH] = true;
            this.messageTimeout.start();
            this.setErrorMessage();
            this.messageTimeout.start();
         }
         else
         {
            Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_DEFAULT;
         }
      }
      
      private function onEcoClick(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.HorsepowerModeError)
         {
            this.mErrors[this.ERROR_HORSEPOWER] = true;
            this.updateMainScreen();
         }
         else
         {
            Peripheral.driveMode.requestEcoMode(!Peripheral.driveModeManager.eco);
         }
      }
      
      private function onKeyClick(evt:WidgetEvent) : void
      {
         if(!Peripheral.driveModeManager.checkSpeedLockout())
         {
            this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.visible = true;
            if(Peripheral.driveMode.RedKeyPresent)
            {
               this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.key_icon.gotoAndStop(1);
               Text.format(this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.message,["     ",T.STRB_THE_RED_KEY_IS_CURRENTLY_ML]);
            }
            else
            {
               this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.key_icon.gotoAndStop(2);
               Text.format(this.mParent.view.Layer_SRT.buttons_group.key_buttons_popup.message,["     ",T.STRB_BLACK_KEY_MESSAGE]);
            }
         }
      }
      
      private function onSetupClick(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_SETUP);
      }
      
      private function onSportClick(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.GlobalDriveModeError)
         {
            this.mErrors[this.ERROR_LAUNCH] = true;
            this.messageTimeout.start();
            this.setErrorMessage();
         }
         else
         {
            Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_SPORT;
         }
      }
      
      private function onTrackClick(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.GlobalDriveModeError)
         {
            this.mErrors[this.ERROR_LAUNCH] = true;
            this.messageTimeout.start();
            this.setErrorMessage();
            this.messageTimeout.start();
         }
         else
         {
            Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_TRACK;
         }
      }
      
      private function onMessageTimeout(evt:TimerEvent) : void
      {
         this.mErrors[this.ERROR_LAUNCH] = false;
         this.messageTimeout.reset();
         this.setErrorMessage();
      }
      
      private function checkForError() : void
      {
         var type:String = null;
         for(type in Peripheral.driveMode.ErrorGroup)
         {
            switch(type)
            {
               case DriveModeTypes.HORSE_POWER:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && Boolean(Peripheral.driveModeManager.highHorsepowerMode))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
                  break;
               case DriveModeTypes.PADDLE_SHIFTER:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && Boolean(Peripheral.vehConfig.hasPaddlesMode))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
                  break;
               case DriveModeTypes.STABILITY_CONTROL:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && Boolean(Peripheral.vehConfig.hasESCDrvMdPresent))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
                  break;
               case DriveModeTypes.STEERING:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && (Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
                  break;
               case DriveModeTypes.SUSPENSION:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && Boolean(Peripheral.vehConfig.hasADCMPresent))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
                  break;
               case DriveModeTypes.TRANSMISSION:
                  if(Boolean(Peripheral.driveMode.ErrorGroup[type]) && Boolean(Peripheral.vehConfig.hasTransDrvMdPresent))
                  {
                     this.mErrors[this.ERROR_GENERIC] = true;
                     return;
                  }
            }
         }
         this.mErrors[this.ERROR_GENERIC] = false;
      }
      
      private function mapColorToValue(value:String) : uint
      {
         switch(value)
         {
            case DriveModeValues.HMI_SPORT:
               return 16738816;
            case DriveModeValues.HMI_RED:
            case DriveModeValues.HMI_TRACK:
            case DriveModeValues.HMI_ON:
               return 16711680;
            case DriveModeValues.HMI_STREET:
         }
         return 16765696;
      }
      
      private function mapIconsToValue(value:String) : uint
      {
         switch(value)
         {
            case DriveModeValues.HMI_SPORT:
               return 2;
            case DriveModeValues.HMI_RED:
            case DriveModeValues.HMI_TRACK:
            case DriveModeValues.HMI_ON:
               return 1;
            case DriveModeValues.HMI_STREET:
         }
         return 3;
      }
      
      private function setCarStatus() : void
      {
         this.mParent.view.Layer_SRT.engine.visible = Peripheral.driveModeManager.highHorsepowerMode;
         this.mParent.view.Layer_SRT.engine.gotoAndStop(Peripheral.driveModeManager.eco ? 4 : this.mapIconsToValue(Peripheral.driveMode.HorsepowerModeStatus));
         this.mParent.view.Layer_SRT.trans.visible = Peripheral.vehConfig.hasTransDrvMdPresent;
         this.mParent.view.Layer_SRT.trans.gotoAndStop(Peripheral.driveModeManager.eco ? 4 : this.mapIconsToValue(Peripheral.driveMode.TransmissionModeStatus));
         this.mParent.view.Layer_SRT.paddles.visible = Peripheral.vehConfig.hasPaddlesMode;
         this.mParent.view.Layer_SRT.paddles.gotoAndStop(Peripheral.driveModeManager.eco ? 4 : this.mapIconsToValue(Peripheral.driveMode.PaddleShifterStatus));
         this.mParent.view.Layer_SRT.traction.visible = Peripheral.vehConfig.hasESCDrvMdPresent && Peripheral.driveMode.StabilityStatus != DriveModeValues.HMI_OFF;
         this.mParent.view.Layer_SRT.traction.gotoAndStop(this.mapIconsToValue(Peripheral.driveMode.StabilityStatus));
         this.mParent.view.Layer_SRT.suspension.visible = Peripheral.vehConfig.hasADCMPresent;
         this.mParent.view.Layer_SRT.suspension.gotoAndStop(this.mapIconsToValue(Peripheral.driveMode.SuspensionStatus));
         this.mParent.view.Layer_SRT.steering.visible = Peripheral.vehConfig.hasEPSPresent && Peripheral.driveMode.PowerSteeringType == "EPS";
         this.mParent.view.Layer_SRT.steering.gotoAndStop(this.mapIconsToValue(Peripheral.driveMode.SteeringStatus));
         this.mParent.view.Layer_SRT.buttons_group.black_key_button.visible = !Peripheral.driveMode.RedKeyPresent && Peripheral.driveModeManager.highHorsepowerMode;
         this.mParent.view.Layer_SRT.buttons_group.red_key_button.visible = Peripheral.driveMode.RedKeyPresent;
      }
      
      private function setErrorMessage() : void
      {
         if(this.mErrors[this.ERROR_GENERIC])
         {
            Text.format(this.mParent.view.Layer_SRT.Warning_message,T.STRB_LEVEL_WARNING_MESSAGE);
         }
         else if(this.mErrors[this.ERROR_LAUNCH])
         {
            Text.format(this.mParent.view.Layer_SRT.Warning_message,T.STRB_DM_ERROR_MODE_CANNOT_CHANGE);
         }
         else if(this.mErrors[this.ERROR_HORSEPOWER])
         {
            Text.format(this.mParent.view.Layer_SRT.Warning_message,T.STRB_DM_ERROR_POWER_CANNOT_CHANGE);
         }
         else if(this.mErrors[this.ERROR_THROTTLE])
         {
            Text.format(this.mParent.view.Layer_SRT.Warning_message,T.STRB_POWER_WARNING_MESSAGE_4);
         }
         else
         {
            Text.format(this.mParent.view.Layer_SRT.Warning_message,"");
         }
         this.mParent.view.Layer_SRT.Warning_icon.visible = this.mParent.view.Layer_SRT.Warning_message.text != "";
         this.mParent.view.Layer_SRT.Warning_message.visible = this.mParent.view.Layer_SRT.Warning_message.text != "";
      }
      
      private function setSubItems() : void
      {
         this.mContents.length = 0;
         if(Peripheral.driveModeManager.highHorsepowerMode)
         {
            this.mContents.push({
               "title":T.STRB_DM_POWER_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.HORSE_POWER] || this.mErrors[this.ERROR_HORSEPOWER] || this.mErrors[this.ERROR_THROTTLE],
               "value":Peripheral.driveMode.HorsepowerModeStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.HorsepowerModeStatus),
               "isEco":Peripheral.driveModeManager.eco,
               "isOff":false
            });
         }
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_TRANSMISSION_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.TRANSMISSION],
               "value":Peripheral.driveMode.TransmissionModeStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.TransmissionModeStatus),
               "isEco":Peripheral.driveModeManager.eco,
               "isOff":false
            });
         }
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mContents.push({
               "title":T.STRB_DM_PADDLE_SHIFTERS_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.PADDLE_SHIFTER],
               "value":Peripheral.driveMode.PaddleShifterStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.PaddleShifterStatus),
               "isEco":Peripheral.driveModeManager.eco,
               "isOff":false
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_TRACTION_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STABILITY_CONTROL],
               "value":Peripheral.driveMode.StabilityStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.StabilityStatus),
               "isEco":false,
               "isOff":Peripheral.driveMode.StabilityStatus == DriveModeValues.HMI_OFF
            });
         }
         if(Peripheral.vehConfig.hasADCMPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_SUSPENSION_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.SUSPENSION],
               "value":Peripheral.driveMode.SuspensionStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.SuspensionStatus),
               "isEco":false,
               "isOff":false
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mContents.push({
               "title":T.STRB_DM_STEERING_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STEERING],
               "value":Peripheral.driveMode.SteeringStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.SteeringStatus),
               "isEco":false,
               "isOff":false
            });
         }
         this.mParent.view.Layer_SRT.display_driveMode_status_group.items = this.mContents;
      }
      
      private function updateGlobalMode() : void
      {
         this.mParent.view.Layer_SRT.default_button.setHighlight(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_DEFAULT);
         this.mParent.view.Layer_SRT.custom_button.setHighlight(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM);
         this.mParent.view.Layer_SRT.sport_button.setHighlight(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SPORT);
         this.mParent.view.Layer_SRT.track_button.setHighlight(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_TRACK);
         this.mParent.view.Layer_SRT.eco_button.setHighlight(Peripheral.driveModeManager.eco);
         Text.format(this.mParent.view.Layer_SRT.setup_button.label,[T.STRB_TRACK_SETUP_ARG,Peripheral.driveMode.GlobalDriveModeStatus]);
      }
   }
}

