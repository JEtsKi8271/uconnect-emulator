package extensions.drivemode
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DriveModeWKSetup implements IDriveModeSetupExtension
   {
      
      private const COLOR_BLUE:uint = 255;
      
      private const COLOR_LIGHT_BLUE:uint = 49407;
      
      private const COLOR_YELLOW:uint = 14859777;
      
      private var mParent:*;
      
      public function DriveModeWKSetup(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function addListeners() : void
      {
         Peripheral.driveMode.addEventListener(DriveModeEvent.TERRAIN_MODE,this.modeChanged,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalModeUpdate,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.driveMode.removeEventListener(DriveModeEvent.TERRAIN_MODE,this.modeChanged);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalModeUpdate);
      }
      
      public function initView() : void
      {
      }
      
      public function initScreen(driveModeType:String = "") : void
      {
         this.mParent.view.line1.visible = false;
         this.mParent.view.line2.visible = false;
         this.mParent.view.buttonGroups.visible = true;
         this.generateSetUpItems();
      }
      
      public function setTitleBar() : void
      {
         Text.format(this.mParent.view.displayTitle.label,[T.STRB_DM_MODE_SET_UP_ARG,Peripheral.driveMode.GlobalDriveModeStatus]);
      }
      
      public function showPopup(e:Object) : Boolean
      {
         var modeProperty:Boolean = false;
         if(!e.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":[T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_BODY,Peripheral.driveMode.GlobalDriveModeStatus,DriveModeValues.HMI_CUSTOM]});
            return true;
         }
         for each(modeProperty in Peripheral.driveMode.SNAGroup)
         {
            if(modeProperty)
            {
               Framework.structure.goto(Screens.DRIVEMODE_MAIN,{"showSNA":true});
               return true;
            }
         }
         return false;
      }
      
      private function onGlobalModeUpdate(evt:DriveModeEvent) : void
      {
         Framework.structure.back();
      }
      
      public function modeChanged(e:DriveModeEvent) : void
      {
         this.generateSetUpItems();
      }
      
      private function generateSetUpItems() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var isSnow:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SNOW;
         var transColor:uint = 0;
         var transLabelArr:Array = [];
         var stabilityLabelArr:Array = [];
         this.mParent.clearDataItems();
         if(isSnow)
         {
            stabilityLabelArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_FULL];
            transColor = this.COLOR_BLUE;
            transLabelArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_SNOW];
         }
         else
         {
            stabilityLabelArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
            transLabelArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
            transColor = this.COLOR_YELLOW;
         }
         if(Peripheral.vehConfig.TcaseType == DriveModeValues.HMI_TCASE_156)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_VEHICLE_AWD,
               "id":T.STRB_VEHICLE_AWD,
               "isAWD":true,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET,DriveModeValues.HMI_HALF_HALF],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom,
               "showMiddle":true,
               "colorBottom":this.COLOR_BLUE,
               "value":this.getValueFromType(DriveModeTypes.ALL_WHEEL_DRIVE)
            });
         }
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_TRANS_SETUP,
               "id":T.STRB_DM_TRANS_SETUP,
               "labels":transLabelArr,
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom,
               "showMiddle":true,
               "colorBottom":(isSnow ? this.COLOR_LIGHT_BLUE : this.COLOR_YELLOW),
               "value":this.getValueFromType(DriveModeTypes.TRANSMISSION)
            });
         }
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_PADDLES_SETUP,
               "id":T.STRB_DM_PADDLES_SETUP,
               "labels":[DriveModeValues.HMI_ON,"",DriveModeValues.HMI_OFF],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":true,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":this.getValueFromType(DriveModeTypes.PADDLE_SHIFTER)
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_STABILITY_SETUP,
               "id":T.STRB_DM_STABILITY_SETUP,
               "labels":stabilityLabelArr,
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom,
               "showMiddle":true,
               "colorBottom":transColor,
               "value":this.getValueFromType(DriveModeTypes.STABILITY_CONTROL)
            });
         }
         if(Peripheral.vehConfig.hasADCMPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_SUSPENSION_SETUP,
               "id":T.STRB_DM_SUSPENSION_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":!isSnow,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":this.getValueFromType(DriveModeTypes.SUSPENSION)
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_STEERING_SETUP,
               "id":T.STRB_DM_STEERING_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":!isSnow,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":this.getValueFromType(DriveModeTypes.STEERING)
            });
         }
         this.mParent.updateGroups();
      }
      
      private function getValueFromType(type:String) : String
      {
         switch(type)
         {
            case DriveModeTypes.ALL_WHEEL_DRIVE:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return DriveModeValues.HMI_STREET;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.TerrainModeCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return DriveModeValues.HMI_HALF_HALF;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return Peripheral.driveMode.PaddleShifterCustomStatus;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.PaddleShifterCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return Peripheral.driveMode.PaddleShifterCustomStatus;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return DriveModeValues.HMI_STREET;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.StabilityCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return DriveModeValues.HMI_FULL;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            case DriveModeTypes.STEERING:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return Peripheral.driveMode.SteeringCustomStatus;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.SteeringCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return DriveModeValues.HMI_STREET;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            case DriveModeTypes.SUSPENSION:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return Peripheral.driveMode.SuspensionCustomStatus;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.SuspensionCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return DriveModeValues.HMI_STREET;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            case DriveModeTypes.TRANSMISSION:
               switch(Peripheral.driveMode.GlobalDriveModeStatus)
               {
                  case DriveModeValues.HMI_AUTO:
                     return DriveModeValues.HMI_STREET;
                  case DriveModeValues.HMI_CUSTOM:
                     return Peripheral.driveMode.TransmissionModeCustomStatus;
                  case DriveModeValues.HMI_SNOW:
                     return DriveModeValues.HMI_SNOW;
                  default:
                     Framework.Trace("getValueFromType(): Unused DriveMode Global Status: " + Peripheral.driveMode.GlobalDriveModeStatus);
                     return "";
               }
               break;
            default:
               Framework.Trace("getValueFromType(): Unused DriveMode Type: " + type);
               return "";
         }
      }
   }
}

