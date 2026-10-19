package extensions.drivemode
{
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.WidgetEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DriveModeWKMain implements IDriveModeMainExtension
   {
      
      private const ERROR_GENERIC:int = 0;
      
      private const ERROR_SNA:int = 1;
      
      private var mParent:*;
      
      private var mErrors:Array = new Array(2);
      
      private var mContents:Array = [];
      
      public function DriveModeWKMain(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function addListeners() : void
      {
         this.mParent.view.Layer_WK.setup_button.addEventListener(WidgetEvent.CLICK,this.onSetup,false,0,true);
         this.mParent.view.Layer_WK.display_driveMode_WK_status_group.addEventListener(WidgetEvent.CLICK,this.onSetup,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.TERRAIN_MODE,this.onTerrainChange,false,0,true);
      }
      
      public function changeLocale() : void
      {
         Text.format(this.mParent.view.Layer_WK.track_off_message.track_message,T.STRB_DM_TRACTION_CONTROL_OFF);
         this.setTitleBar();
      }
      
      public function cleanup() : void
      {
      }
      
      public function initScreen(screenVars:Object = null) : void
      {
         this.mErrors[this.ERROR_GENERIC] = false;
         this.mErrors[this.ERROR_SNA] = false;
         if(screenVars != null && screenVars.hasOwnProperty("showSNA"))
         {
            this.mErrors[this.ERROR_SNA] = screenVars.showSNA;
         }
         else
         {
            this.mErrors[this.ERROR_SNA] = false;
         }
         this.updateMainScreen();
         this.onLockOut();
      }
      
      public function initView() : void
      {
         this.mParent.view.Layer_SRT.visible = false;
         this.mParent.view.Layer_WK.visible = true;
         this.mParent.view.Layer_WK.popup_SRT_modes.visible = false;
         this.mParent.view.Layer_WK.Warning_message.visible = false;
         this.mParent.view.Layer_WK.Warning_icon.visible = false;
         this.mParent.view.Layer_WK.setup_button.alwaysClick = true;
         this.mParent.view.Layer_WK.valet_button.alwaysClick = true;
      }
      
      public function removeListeners() : void
      {
         this.mParent.view.Layer_WK.setup_button.removeEventListener(WidgetEvent.CLICK,this.onSetup);
         this.mParent.view.Layer_WK.display_driveMode_WK_status_group.removeEventListener(WidgetEvent.CLICK,this.onSetup);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.TERRAIN_MODE,this.onTerrainChange);
      }
      
      public function updateMainScreen() : void
      {
         this.setCarStatusPhoto();
         this.setSubItems();
         this.setTitleBar();
         this.checkForError();
         this.setErrorMessage();
         this.onLockOut();
      }
      
      public function onLockOut() : void
      {
         this.mParent.view.Layer_WK.setup_button.setEnabled(!Peripheral.driveModeManager.speedLockOut || (Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_AUTO || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SNOW));
         this.mParent.view.Layer_WK.valet_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
      }
      
      private function onSetup(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_AUTO || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SNOW)
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUP);
         }
         else if(!Peripheral.driveModeManager.checkSpeedLockout())
         {
            Framework.structure.goto(Screens.DRIVEMODE_WKINFO);
         }
      }
      
      private function onTerrainChange(evt:DriveModeEvent) : void
      {
         this.setSubItems();
         this.setErrorMessage();
      }
      
      private function checkForError() : void
      {
         var type:String = null;
         var moduletype:String = null;
         this.mErrors[this.ERROR_GENERIC] = false;
         for(type in Peripheral.driveMode.ErrorGroup)
         {
            if(Peripheral.driveMode.ErrorGroup[type])
            {
               this.mErrors[this.ERROR_GENERIC] = true;
               break;
            }
         }
         if(this.mErrors[this.ERROR_SNA])
         {
            this.mErrors[this.ERROR_SNA] = false;
            for(moduletype in Peripheral.driveMode.SNAGroup)
            {
               if(Peripheral.driveMode.SNAGroup[moduletype])
               {
                  this.mErrors[this.ERROR_SNA] = true;
                  break;
               }
            }
         }
      }
      
      private function mapColorToValue(value:String) : uint
      {
         switch(value)
         {
            case DriveModeValues.HMI_SNOW:
               return 49407;
            case DriveModeValues.HMI_SPORT:
               return 16738816;
            case DriveModeValues.HMI_TOW:
               return 5570815;
            case DriveModeValues.HMI_TRACK:
            case DriveModeValues.HMI_ON:
               return 16711680;
            case DriveModeValues.HMI_FULL:
            case DriveModeValues.HMI_HALF_HALF:
               return 11263;
            case DriveModeValues.HMI_STREET:
         }
         return 16765696;
      }
      
      private function setCarStatusPhoto() : void
      {
         switch(Peripheral.driveMode.GlobalDriveModeStatus)
         {
            case DriveModeValues.HMI_CUSTOM:
               this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_AUTO:
               if(Peripheral.driveModeManager.eco)
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(2);
               }
               else
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(1);
               }
               break;
            case DriveModeValues.HMI_TRACK:
               if(Peripheral.driveModeManager.eco)
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(4);
               }
               else
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(3);
               }
               break;
            case DriveModeValues.HMI_SPORT:
               if(Peripheral.driveModeManager.eco)
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(6);
               }
               else
               {
                  this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(5);
               }
               break;
            case DriveModeValues.HMI_SNOW:
               this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(7);
               break;
            case DriveModeValues.HMI_TOW:
               this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(8);
               break;
            default:
               this.mParent.view.Layer_WK.car_status_photo.gotoAndStop(1);
               Framework.Trace("setCarPhoto(): Unknown/Unused global value");
         }
         this.mParent.view.Layer_WK.track_off_message.track_message.visible = !Peripheral.driveMode.TractionControlStatus;
      }
      
      private function setErrorMessage() : void
      {
         if(this.mErrors[this.ERROR_GENERIC])
         {
            Text.format(this.mParent.view.Layer_WK.Warning_message,T.STRB_LEVEL_WARNING_MESSAGE);
         }
         else if(this.mErrors[this.ERROR_SNA])
         {
            Text.format(this.mParent.view.Layer_WK.Warning_message,T.STRB_LEVEL_WARNING_MESSAGE);
         }
         else
         {
            this.mParent.view.Layer_WK.Warning_message.text = "";
         }
         this.mParent.view.Layer_WK.Warning_icon.visible = this.mParent.view.Layer_WK.Warning_message.text != "";
         this.mParent.view.Layer_WK.Warning_message.visible = this.mParent.view.Layer_WK.Warning_message.text != "";
      }
      
      private function setSubItems() : void
      {
         this.mContents.length = 0;
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_TRANSMISSION_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.TRANSMISSION] || Peripheral.driveMode.SNAGroup[DriveModeTypes.TRANSMISSION] && this.mErrors[this.ERROR_SNA],
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
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.PADDLE_SHIFTER] || Peripheral.driveMode.SNAGroup[DriveModeTypes.PADDLE_SHIFTER] && this.mErrors[this.ERROR_SNA],
               "value":Peripheral.driveMode.PaddleShifterStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.PaddleShifterStatus),
               "isEco":Peripheral.driveModeManager.eco,
               "isOff":false
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_STABILITY_CONTROL_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STABILITY_CONTROL] || Peripheral.driveMode.SNAGroup[DriveModeTypes.STABILITY_CONTROL] && this.mErrors[this.ERROR_SNA],
               "value":Peripheral.driveMode.StabilityStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.StabilityStatus),
               "isEco":false,
               "isOff":Peripheral.driveMode.StabilityStatus == DriveModeValues.HMI_OFF
            });
         }
         if(Peripheral.vehConfig.TcaseType == DriveModeValues.HMI_TCASE_156)
         {
            this.mContents.push({
               "title":T.STRB_DM_AWD_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.ALL_WHEEL_DRIVE] || Peripheral.driveMode.SNAGroup[DriveModeTypes.ALL_WHEEL_DRIVE] && this.mErrors[this.ERROR_SNA],
               "value":Peripheral.driveMode.TerrainModeStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.TerrainModeStatus),
               "isEco":false,
               "isOff":false
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mContents.push({
               "title":T.STRB_DM_STEERING_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STEERING] || Peripheral.driveMode.SNAGroup[DriveModeTypes.STEERING] && this.mErrors[this.ERROR_SNA],
               "value":Peripheral.driveMode.SteeringStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.SteeringStatus),
               "isEco":false,
               "isOff":false
            });
         }
         if(Peripheral.vehConfig.hasADCMPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_SUSPENSION_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.SUSPENSION] || Peripheral.driveMode.SNAGroup[DriveModeTypes.SUSPENSION] && this.mErrors[this.ERROR_SNA],
               "value":Peripheral.driveMode.SuspensionStatus,
               "color":this.mapColorToValue(Peripheral.driveMode.SuspensionStatus),
               "isEco":false,
               "isOff":false
            });
         }
         this.mParent.view.Layer_WK.display_driveMode_WK_status_group.items = this.mContents;
      }
      
      private function setTitleBar() : void
      {
         var composition:Array = [];
         var setupComposition:Array = [];
         var text:String = "";
         composition.push(T.STRB_DM_CURRENT_MODE_ARGS);
         switch(Peripheral.driveMode.GlobalDriveModeStatus)
         {
            case DriveModeValues.HMI_AUTO:
            case DriveModeValues.HMI_CUSTOM:
            case DriveModeValues.HMI_SNOW:
               setupComposition.push(T.STRB_TRACK_SETUP_ARG);
               break;
            case DriveModeValues.HMI_SPORT:
            case DriveModeValues.HMI_TOW:
            case DriveModeValues.HMI_TRACK:
               setupComposition.push(T.STRB_DM_INFO_ARGS);
               break;
            default:
               Framework.Trace("Uh Oh!!! Undefined Mode was broadcasted: " + Peripheral.driveMode.GlobalDriveModeStatus);
         }
         composition.push(Peripheral.driveMode.GlobalDriveModeStatus);
         setupComposition.push(Peripheral.driveMode.GlobalDriveModeStatus);
         if(Peripheral.driveModeManager.eco)
         {
            composition.push(" + ECO");
         }
         Text.format(this.mParent.view.Layer_WK.setup_button.label,setupComposition);
         Text.format(this.mParent.view.Layer_WK.currentMode_title.label,composition);
         Text.format(this.mParent.view.Layer_WK.popup_currentMode_title.label,composition);
         this.mParent.view.Layer_WK.popup_currentMode_title.visible = !Peripheral.vehConfig.hasSportsMode || Peripheral.appManager.getPPId() == "";
         this.mParent.view.Layer_WK.srt_button.visible = Peripheral.vehConfig.hasSportsMode && Peripheral.appManager.getPPId() != "";
         this.mParent.view.Layer_WK.currentMode_title.visible = Peripheral.vehConfig.hasSportsMode && Peripheral.appManager.getPPId() != "";
      }
   }
}

