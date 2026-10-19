package extensions.drivemode
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import locale.T;
   import peripheral.Peripheral;
   
   public class DriveModeSRTDetailSetup implements IDriveModeDetailSetupExtension
   {
      
      private const MAIN:String = "Main";
      
      private const GREEN_COLOR:String = "0x00FF00";
      
      private const RED_COLOR:String = "0xFF0000";
      
      private const YELLOW_COLOR:String = "0xFDFE00";
      
      private const SRT_START:int = 4;
      
      private const KEY_START:int = 7;
      
      private var mParent:*;
      
      public function DriveModeSRTDetailSetup(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function initScreen(driveModeType:String = "") : void
      {
         this.mParent.pushItemLayout(this.MAIN);
         if(Peripheral.driveModeManager.highHorsepowerMode)
         {
            this.mParent.pushItemLayout(DriveModeTypes.HORSE_POWER);
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
               title = T.STRB_POWER;
               break;
            case this.MAIN:
               title = [T.STRB_DM_MODE_ARG,Peripheral.driveMode.GlobalDriveModeStatus];
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               title = T.STRB_DM_PADDLE_SHIFTERS_SETUP;
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               title = T.STRB_DM_TRACTION_SETUP;
               break;
            case DriveModeTypes.STEERING:
               title = Peripheral.localeEngine.getText(T.STRB_STEERING_WC).replace(":","");
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
      }
      
      public function setEngineState() : void
      {
         var isEnabled:Boolean = Boolean(Peripheral.driveMode.RedKeyPresent);
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,Peripheral.driveMode.GlobalDriveModeRequest);
         this.mParent.view.option_3Buttons_group.id = T.STRB_POWER;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_RED,"",DriveModeValues.HMI_BLACK];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = isEnabled;
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.horsepower_info.horsepowr_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.horsepower_info.horsepowr_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         this.mParent.view.horsepower_info.horsepowr_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         switch(value)
         {
            case DriveModeValues.HMI_RED:
               this.mParent.view.horsepower_info.horsepowr_info_LA.gotoAndStop(7);
               this.mParent.view.horsepower_info.horsepowr_info_LD.gotoAndStop(7);
               this.mParent.view.horsepower_info.horsepowr_info_LX.gotoAndStop(4);
               break;
            case DriveModeValues.HMI_BLACK:
               this.mParent.view.horsepower_info.horsepowr_info_LA.gotoAndStop(9);
               this.mParent.view.horsepower_info.horsepowr_info_LD.gotoAndStop(9);
               this.mParent.view.horsepower_info.horsepowr_info_LX.gotoAndStop(6);
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(T.STRB_DM_HORSEPOWER_DETAIL));
      }
      
      public function setMainState() : void
      {
         var body:* = undefined;
         switch(Peripheral.driveMode.GlobalDriveModeStatus)
         {
            case DriveModeValues.HMI_DEFAULT:
               if(Peripheral.driveModeManager.eco)
               {
                  if(Peripheral.driveMode.isLegacyDriveModes)
                  {
                     body = [T.STRB_DM_MY15_DEFAULT_INFO_ECO_ARGS,"Default","Default"];
                  }
                  else
                  {
                     body = [T.STRB_DM_DEFAULT_INFO_ECO_ARGS,"Default","Default","Default"];
                  }
               }
               else
               {
                  body = [T.STRB_DEFAULT_MODE_INFO_R1,"Default","Default"];
               }
               break;
            case DriveModeValues.HMI_CUSTOM:
               if(Peripheral.driveModeManager.eco)
               {
                  if(Peripheral.driveMode.isLegacyDriveModes)
                  {
                     body = [T.STRB_DM_MY15_CUSTOM_INFO_ECO_ARGS,"Custom","Custom","Default"];
                  }
                  else
                  {
                     body = [T.STRB_DM_CUSTOM_INFO_ECO_ARGS,"Custom","Custom","Default","Default"];
                  }
               }
               else
               {
                  body = [T.STRB_CUSTOM_MODE_INFO_R1,"Custom","Custom","Default"];
               }
               break;
            case DriveModeValues.HMI_SPORT:
               if(Peripheral.driveModeManager.eco)
               {
                  if(Peripheral.driveMode.isLegacyDriveModes)
                  {
                     body = [T.STRB_DM_MY15_SPORT_MODE_WK_ECO_DETAIL,"Sport","Sport","Default"];
                  }
                  else
                  {
                     body = [T.STRB_DM_SPORT_MODE_WK_ECO_DETAIL,"Sport","Sport","Default","Default"];
                  }
               }
               else
               {
                  body = [T.STRB_SPORT_MODE_INFO_R1,"Sport","Sport","Default"];
               }
               break;
            case DriveModeValues.HMI_TRACK:
               if(Peripheral.driveModeManager.eco)
               {
                  if(Peripheral.driveMode.isLegacyDriveModes)
                  {
                     body = [T.STRB_DM_MY15_TRACK_MODE_WK_ECO_DETAIL,"Track","Track","Default"];
                  }
                  else
                  {
                     body = [T.STRB_DM_TRACK_MODE_WK_ECO_DETAIL,"Track","Track","Default","Default"];
                  }
               }
               else
               {
                  body = [T.STRB_TRACK_MODE_INFO_R1,"Track","Track","Default"];
               }
         }
         this.mParent.colorTag(this.mParent.view.type_infor.display_type_infor,Text.compose(body));
      }
      
      public function setPaddleShifterState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_DEFAULT || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.PADDLE_SHIFTER,Peripheral.driveMode.GlobalDriveModeRequest);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_ON,"",DriveModeValues.HMI_OFF];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = false;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.paddle_info.paddle_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.paddle_info.paddle_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         this.mParent.view.paddle_info.paddle_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         switch(value)
         {
            case DriveModeValues.HMI_ON:
               if(Peripheral.driveModeManager.highHorsepowerMode)
               {
                  this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(7);
                  this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(7);
                  this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(4);
               }
               else
               {
                  this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(4);
                  this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(4);
                  this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(4);
               }
               break;
            case DriveModeValues.HMI_OFF:
               if(Peripheral.driveModeManager.highHorsepowerMode)
               {
                  this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(9);
                  this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(9);
                  this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(6);
               }
               else
               {
                  this.mParent.view.paddle_info.paddle_info_LA.gotoAndStop(6);
                  this.mParent.view.paddle_info.paddle_info_LD.gotoAndStop(6);
                  this.mParent.view.paddle_info.paddle_info_LX.gotoAndStop(6);
               }
         }
         this.mParent.colorTag(this.mParent.view.content,Text.compose(T.STRB_DM_PADDLE_SHIFTERS_INFO));
      }
      
      public function setStabilityControlState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STABILITY_CONTROL,Peripheral.driveMode.GlobalDriveModeRequest);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         switch(value)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.traction_infor.display_pic_infor.gotoAndStop(3);
         }
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_TRACTION_INFO,"<r>:TRACK</r>","<o>:SPORT</o>","<y>:STREET</y>"]));
         }
         else
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_TRACTION_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
         }
      }
      
      public function setSteeringState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_DEFAULT || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STEERING,Peripheral.driveMode.GlobalDriveModeRequest);
         var frame:int = 1;
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         this.mParent.view.steering_info.steering_info_LA.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.mParent.view.steering_info.steering_info_LX.visible = Peripheral.vehConfig.vehicleLine == "LX";
         this.mParent.view.steering_info.steering_info_LD.visible = Peripheral.vehConfig.vehicleLine == "LD";
         frame = Peripheral.driveModeManager.highHorsepowerMode ? this.KEY_START : this.SRT_START;
         switch(value)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(frame);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(frame);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(frame);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(frame + 1);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(frame + 1);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(frame + 1);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.steering_info.steering_info_LA.gotoAndStop(frame + 2);
               this.mParent.view.steering_info.steering_info_LX.gotoAndStop(frame + 2);
               this.mParent.view.steering_info.steering_info_LD.gotoAndStop(frame + 2);
         }
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_STEERING_INFO,"<r>:TRACK</r>","<o>:SPORT</o>","<y>:STREET</y>"]));
         }
         else
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_STEERING_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
         }
      }
      
      public function setSuspensionState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_DEFAULT || Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.SUSPENSION,Peripheral.driveMode.GlobalDriveModeRequest);
         this.mParent.view.option_3Buttons_group.id = -1;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom;
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         switch(value)
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
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_SUSPENSION_INFO,"<r>:TRACK</r>","<o>:SPORT</o>","<y>:STREET</y>"]));
         }
         else
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_SUSPENSION_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
         }
      }
      
      public function setTransState() : void
      {
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var value:String = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.TRANSMISSION,Peripheral.driveMode.GlobalDriveModeRequest);
         var isEngineMode:Boolean = Boolean(Peripheral.driveModeManager.highHorsepowerMode);
         var isLowHP:Boolean = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,Peripheral.driveMode.GlobalDriveModeStatus) == DriveModeValues.HMI_BLACK;
         this.mParent.view.option_3Buttons_group.id = T.STRB_DM_TRANS_SETUP;
         this.mParent.view.option_3Buttons_group.labels = [DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET];
         this.mParent.view.option_3Buttons_group.setUp_center_button.visible = true;
         this.mParent.view.option_3Buttons_group.enable = isCustom && (isEngineMode && !isLowHP || !isEngineMode);
         this.mParent.view.option_3Buttons_group.select = value;
         this.mParent.view.option_3Buttons_group.bottomColor = this.YELLOW_COLOR;
         switch(value)
         {
            case DriveModeValues.HMI_TRACK:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(1);
               break;
            case DriveModeValues.HMI_SPORT:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(2);
               break;
            case DriveModeValues.HMI_STREET:
               this.mParent.view.transmission_infor.display_pic_infor.gotoAndStop(3);
         }
         if(LocaleArchive.getInstance().isMirrored())
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_TRANSMISSION_INFO,"<r>:TRACK</r>","<o>:SPORT</o>","<y>:STREET</y>"]));
         }
         else
         {
            this.mParent.colorTag(this.mParent.view.content,Text.compose([T.STRB_DM_TRANSMISSION_INFO,"<r>TRACK:</r>","<o>SPORT:</o>","<y>STREET:</y>"]));
         }
      }
      
      public function sendEngine(value:String) : void
      {
         Peripheral.driveMode.HorsepowerModeRequest = value;
      }
      
      public function showPopup(evt:Object) : Boolean
      {
         if(!evt.mEnabled)
         {
            if(evt.parent.id == T.STRB_POWER && !Peripheral.driveMode.RedKeyPresent)
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_POWER_LEVEL_BLACK_KEY,DriveModeValues.HMI_RED])});
            }
            else if(!(evt.parent.id == T.STRB_DM_TRANS_SETUP && (Boolean(Peripheral.driveModeManager.highHorsepowerMode) && !Peripheral.driveMode.RedKeyPresent) || evt.parent.id == T.STRB_DM_TRANS_SETUP && (Boolean(Peripheral.driveModeManager.highHorsepowerMode) && Peripheral.driveMode.HorsepowerModeCustomStatus == DriveModeValues.HMI_BLACK)))
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_BODY,Peripheral.driveMode.GlobalDriveModeStatus,DriveModeValues.HMI_CUSTOM])});
            }
            return true;
         }
         if(Boolean(Peripheral.driveMode.HorsepowerModeError) && evt.parent.id == T.STRB_POWER)
         {
            Framework.structure.goto(Screens.DRIVEMODE_MAIN,{"horsePowerError":true});
            return true;
         }
         if(Boolean(Peripheral.driveMode.ThrottleLockOut) && evt.parent.id == T.STRB_POWER)
         {
            Framework.structure.goto(Screens.DRIVEMODE_MAIN,{"throttleError":true});
            return true;
         }
         return false;
      }
   }
}

