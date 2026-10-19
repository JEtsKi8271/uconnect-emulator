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
   
   public class DriveModeWKDetailSetup implements IDriveModeDetailSetupExtension
   {
      
      private const MAIN:String = "Main";
      
      private const BLUE_COLOR:String = "0x0000FF";
      
      private const GREEN_COLOR:String = "0x00FF00";
      
      private const LIGHT_BLUE_COLOR:String = "0x569EFF";
      
      private const RED_COLOR:String = "0xFF0000";
      
      private const YELLOW_COLOR:String = "0xFDFE00";
      
      private var mParent:*;
      
      public function DriveModeWKDetailSetup(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function initScreen(driveModeType:String = "") : void
      {
         this.mParent.pushItemLayout(this.MAIN);
         if(Peripheral.vehConfig.TcaseType == DriveModeValues.HMI_TCASE_156)
         {
            this.mParent.pushItemLayout(DriveModeTypes.ALL_WHEEL_DRIVE);
         }
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mParent.pushItemLayout(DriveModeTypes.TRANSMISSION);
         }
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mParent.pushItemLayout(DriveModeTypes.PADDLE_SHIFTER);
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mParent.pushItemLayout(DriveModeTypes.STABILITY_CONTROL);
         }
         if(Peripheral.vehConfig.hasADCMPresent)
         {
            this.mParent.pushItemLayout(DriveModeTypes.SUSPENSION);
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mParent.pushItemLayout(DriveModeTypes.STEERING);
         }
      }
      
      public function addListeners() : void
      {
         Peripheral.driveMode.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalModeUpdate,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.driveMode.removeEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onGlobalModeUpdate);
      }
      
      public function setTitleBar(state:String) : void
      {
         var title:* = undefined;
         switch(state)
         {
            case DriveModeTypes.ALL_WHEEL_DRIVE:
               title = T.STRB_AWD_DETAILS_TITLE;
               break;
            case this.MAIN:
               title = [T.STRB_DM_INFO_ARGS,Peripheral.driveMode.GlobalDriveModeStatus];
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               title = T.STRB_SETUP_PADDLE_SHIFTERS;
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               title = T.STRB_DM_STABILITY_CONTROL_TITLE;
               break;
            case DriveModeTypes.STEERING:
               title = T.STRB_SETUP_STEERING;
               break;
            case DriveModeTypes.SUSPENSION:
               title = T.STRB_SETUP_SUSPENSION;
               break;
            case DriveModeTypes.TRANSMISSION:
               title = T.STRB_SETUP_TRANSMISSION;
               break;
            default:
               title = "";
         }
         Text.format(this.mParent.view.displayTitle.label,title);
         this.mParent.view.displayTitle.icon.visible = Peripheral.driveModeManager.eco && state == this.MAIN;
         this.mParent.view.displayTitle.updateBackgroud(Boolean(Peripheral.driveModeManager.eco) && state == this.MAIN ? uint(this.GREEN_COLOR) : uint(this.RED_COLOR));
      }
      
      public function setAWDState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var status:String = this.getValueFromType(DriveModeTypes.ALL_WHEEL_DRIVE);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_4Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET,DriveModeValues.HMI_HALF_HALF];
         this.mParent.view.option_4Buttons_group.enable = isCustom;
         this.mParent.view.option_4Buttons_group.select = status;
         this.mParent.view.option_4Buttons_group.bottomColor = this.LIGHT_BLUE_COLOR;
         switch(status)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.all_wheel_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.all_wheel_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.all_wheel_infor.display_pic_infor.gotoAndStop(3);
               break;
            case DriveModeValues.HMI_HALF_HALF:
               this.mParent.view.all_wheel_infor.display_pic_infor.gotoAndStop(4);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_AWD_DETAIL,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>","<lb>50/50:</lb>"]));
      }
      
      public function setEngineState() : void
      {
      }
      
      public function setMainState() : void
      {
         var body:* = undefined;
         switch(Peripheral.driveMode.GlobalDriveModeStatus)
         {
            case DriveModeValues.HMI_AUTO:
               if(Peripheral.driveModeManager.eco)
               {
                  body = [T.STRB_DM_AUTO_MODE_DETAIL_ECO,DriveModeValues.HMI_AUTO,DriveModeValues.HMI_AUTO];
               }
               else
               {
                  body = [T.STRB_DM_AUTO_MODE_DETAIL,DriveModeValues.HMI_AUTO];
               }
               break;
            case DriveModeValues.HMI_CUSTOM:
               body = [T.STRB_DM_CUSTOM_MODE_WK_DETAIL,DriveModeValues.HMI_CUSTOM,DriveModeValues.HMI_CUSTOM,DriveModeValues.HMI_AUTO,DriveModeValues.HMI_AUTO];
               break;
            case DriveModeValues.HMI_SNOW:
               body = [T.STRB_DM_SNOW_MODE_DETAIL,DriveModeValues.HMI_SNOW,DriveModeValues.HMI_SNOW,DriveModeValues.HMI_AUTO,DriveModeValues.HMI_AUTO];
         }
         this.mParent.colorTag(this.mParent.view.type_infor.display_type_infor,Text.compose(body));
      }
      
      public function setPaddleShifterState() : void
      {
         var status:String = this.getValueFromType(DriveModeTypes.PADDLE_SHIFTER);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_ON,"",DriveModeValues.HMI_OFF];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = true;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.paddle_info.paddle_info_LD.visible = false;
         this.mParent.view.paddle_info.paddle_info_LX.visible = false;
         switch(status)
         {
            case DriveModeValues.HMI_ON:
               this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(7);
               break;
            case DriveModeValues.HMI_OFF:
               this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(9);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(T.STRB_DM_PADDLE_SHIFTERS_INFO));
      }
      
      public function setStabilityControlState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var isSnow:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SNOW;
         var status:String = this.getValueFromType(DriveModeTypes.STABILITY_CONTROL);
         var translationArr:Array = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         var composition:Array = [];
         if(isSnow)
         {
            translationArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_FULL];
         }
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = translationArr;
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = isSnow ? this.BLUE_COLOR : this.YELLOW_COLOR;
         switch(status)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(3);
               break;
            case DriveModeValues.HMI_FULL:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(4);
         }
         if(isSnow)
         {
            composition = [T.STRB_DM_STABILITY_FULL_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<bl>FULL:</bl>"];
         }
         else
         {
            composition = [T.STRB_DM_STABILITY_STREET_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"];
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(composition));
      }
      
      public function setSteeringState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_AUTO;
         var status:String = this.getValueFromType(DriveModeTypes.STEERING);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.steering_info.steering_info_LX.visible = false;
         this.mParent.view.steering_info.steering_info_LD.visible = false;
         switch(status)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(4);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(5);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(6);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_STEERING_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
      }
      
      public function setSuspensionState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_AUTO || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var status:String = this.getValueFromType(DriveModeTypes.SUSPENSION);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         switch(status)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.suspension_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.suspension_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.suspension_infor.display_pic_infor.gotoAndStop(3);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_SUSPENSION_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
      }
      
      public function setTransState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var isSnow:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SNOW;
         var status:String = this.getValueFromType(DriveModeTypes.TRANSMISSION);
         var translationArr:Array = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         var composition:Array = [];
         if(isSnow)
         {
            translationArr = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_SNOW];
         }
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = translationArr;
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = isSnow ? this.LIGHT_BLUE_COLOR : this.YELLOW_COLOR;
         switch(status)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(3);
               break;
            case DriveModeValues.HMI_SNOW:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(4);
         }
         if(isSnow)
         {
            composition = [T.STRB_DM_TRANSMISSION_SNOW_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<lb>SNOW:</lb>"];
         }
         else
         {
            composition = [T.STRB_DM_TRANSMISSION_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"];
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(composition));
      }
      
      public function sendEngine(value:String) : void
      {
      }
      
      public function showPopup(evt:Object) : Boolean
      {
         var modeProperty:Boolean = false;
         if(!evt.mEnabled)
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
         Framework.structure.returnTo(Screens.DRIVEMODE_MAIN);
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

