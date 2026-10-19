package extensions.drivemode
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DriveModeNonSRTDetailSetup implements IDriveModeDetailSetupExtension
   {
      
      private const MAIN:String = "Main";
      
      private const RED_COLOR:String = "0xFF0000";
      
      private const YELLOW_COLOR:String = "0xFDFE00";
      
      private var mDriveModeType:String;
      
      private var mParent:*;
      
      public function DriveModeNonSRTDetailSetup(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function initScreen(driveModeType:String = "") : void
      {
         this.mDriveModeType = driveModeType;
         this.mParent.pushItemLayout(this.MAIN);
         this.mParent.pushItemLayout(DriveModeTypes.HORSE_POWER);
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mParent.pushItemLayout(DriveModeTypes.PADDLE_SHIFTER);
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mParent.pushItemLayout(DriveModeTypes.STABILITY_CONTROL);
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mParent.pushItemLayout(DriveModeTypes.STEERING);
         }
      }
      
      public function addListeners() : void
      {
      }
      
      public function removeListeners() : void
      {
      }
      
      public function setTitleBar(state:String) : void
      {
         var title:* = undefined;
         switch(state)
         {
            case DriveModeTypes.HORSE_POWER:
               if(Peripheral.vehConfig.hasTransDrvMdPresent)
               {
                  title = T.STRB_DM_ENGINE_TRANS;
               }
               else
               {
                  title = T.STRB_DM_ENGINE_TITLE;
               }
               break;
            case this.MAIN:
               title = [T.STRB_DM_MODE_ARG,this.mDriveModeType];
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               title = T.STRB_DM_PADDLE_SHIFTERS_SETUP;
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               title = T.STRB_DM_TRACTION_CONTROL_TITLE;
               break;
            case DriveModeTypes.STEERING:
               title = T.STRB_DM_STEERING_SETUP;
               break;
            default:
               title = "";
         }
         Text.format(this.mParent.view.displayTitle.label,title);
         this.mParent.view.displayTitle.icon.visible = false;
         this.mParent.view.displayTitle.updateBackgroud(uint(this.RED_COLOR));
      }
      
      public function setAWDState() : void
      {
      }
      
      public function setEngineState() : void
      {
         var status:String = "";
         if(Peripheral.driveMode.isLegacyDriveModes)
         {
            status = Peripheral.vehConfig.hasTransDrvMdPresent ? Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.TRANSMISSION,this.mDriveModeType) : Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,this.mDriveModeType);
         }
         else
         {
            status = Peripheral.vehConfig.hasTransDrvMdPresent ? Peripheral.driveMode.TransmissionModeCustomStatus : Peripheral.driveMode.EngineModeCustomStatus;
         }
         this.mParent.view.option_3Buttons_group.id = T.STRB_POWER;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_SPORT,"",DriveModeValues.HMI_NORMAL];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = this.mDriveModeType == DriveModeValues.HMI_SPORT;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.horsepower_info.horsepowr_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.horsepower_info.horsepowr_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         this.mParent.view.horsepower_info.horsepowr_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         switch(status)
         {
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.horsepower_info.horsepowr_info_LA.gotoAndStop(1);
               this.mParent.view.horsepower_info.horsepowr_info_LD.gotoAndStop(1);
               this.mParent.view.horsepower_info.horsepowr_info_LX.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_NORMAL:
               this.mParent.view.horsepower_info.horsepowr_info_LA.gotoAndStop(3);
               this.mParent.view.horsepower_info.horsepowr_info_LD.gotoAndStop(3);
               this.mParent.view.horsepower_info.horsepowr_info_LX.gotoAndStop(3);
         }
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_ENGINE_TRANS_INFO,"<r>SPORT:</r>","<y>NORMAL:</y>"]));
         }
         else
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_ENGINE_INFO,"<r>SPORT:</r>","<y>NORMAL:</y>"]));
         }
      }
      
      public function setMainState() : void
      {
         if(this.mDriveModeType == DriveModeValues.HMI_SPORT)
         {
            Text.format(this.mParent.view.type_infor.display_type_infor,[T.STRB_SPORT_MODE_INFO_R2,"Sport","Default"]);
         }
         else
         {
            Text.format(this.mParent.view.type_infor.display_type_infor,[T.STRB_DEFAULT_MODE_IS_ACTIVATED,"Default"]);
         }
      }
      
      public function setPaddleShifterState() : void
      {
         var status:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.PADDLE_SHIFTER,this.mDriveModeType);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_ON,"",DriveModeValues.HMI_OFF];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = true;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.paddle_info.paddle_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.paddle_info.paddle_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         this.mParent.view.paddle_info.paddle_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         switch(status)
         {
            case DriveModeValues.HMI_ON:
               this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(1);
               this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(1);
               this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_OFF:
               this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(3);
               this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(3);
               this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(3);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(T.STRB_DM_PADDLE_SHIFTERS_INFO));
      }
      
      public function setStabilityControlState() : void
      {
         var status:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STABILITY_CONTROL,this.mDriveModeType);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_SPORT,"",DriveModeValues.HMI_NORMAL];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = this.mDriveModeType == DriveModeValues.HMI_SPORT;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         switch(status)
         {
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_NORMAL:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(3);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_TRACTION_INFO_NO_SRT,"<r>SPORT:</r>","<y>NORMAL:</y>"]));
      }
      
      public function setSteeringState() : void
      {
         var status:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STEERING,this.mDriveModeType);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_SPORT,DriveModeValues.HMI_NORMAL,DriveModeValues.HMI_COMFORT];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = true;
         this.mParent.view.option_3Buttons_group.select = status;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.steering_info.steering_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.steering_info.steering_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         this.mParent.view.steering_info.steering_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         switch(status)
         {
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(1);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(1);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_NORMAL:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(2);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(2);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_COMFORT:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(3);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(3);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(3);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_STEERING_INFO,"<r>SPORT:</r>","<o>NORMAL:</o>","<y>COMFORT:</y>"]));
      }
      
      public function setSuspensionState() : void
      {
      }
      
      public function setTransState() : void
      {
      }
      
      public function sendAWD(value:String) : void
      {
      }
      
      public function sendEngine(value:String) : void
      {
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            Peripheral.driveMode.TransmissionModeRequest = value;
         }
         else
         {
            Peripheral.driveMode.EngineModeRequest = value;
         }
      }
      
      public function showPopup(e:Object) : Boolean
      {
         if(!e.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_BODY,Peripheral.driveMode.GlobalDriveModeStatus,DriveModeValues.HMI_SPORT])});
            return true;
         }
         if(Boolean(Peripheral.driveMode.HorsepowerModeError) && e.parent.id == T.STRB_POWER)
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUPNONSRT,{"horsePowerError":true});
            return true;
         }
         return false;
      }
   }
}

