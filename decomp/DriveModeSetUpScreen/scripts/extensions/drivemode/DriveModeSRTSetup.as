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
   
   public class DriveModeSRTSetup implements IDriveModeSetupExtension
   {
      
      private const COLOR_YELLOW:uint = 14859777;
      
      private var mParent:*;
      
      public function DriveModeSRTSetup(parent:*)
      {
         super();
         this.mParent = parent;
      }
      
      public function addListeners() : void
      {
      }
      
      public function removeListeners() : void
      {
      }
      
      public function initView() : void
      {
      }
      
      public function initScreen(driveModeType:String = "") : void
      {
         this.mParent.view.line1_WK.visible = false;
         this.mParent.view.line2_WK.visible = false;
         this.mParent.view.buttonGroups.visible = true;
         this.generateSetUpItems();
      }
      
      public function setTitleBar() : void
      {
         Text.format(this.mParent.view.displayTitle.label,[T.STRB_DM_MODE_SET_UP_ARG,Peripheral.driveMode.GlobalDriveModeStatus]);
      }
      
      public function modeChanged(e:DriveModeEvent) : void
      {
         this.generateSetUpItems();
      }
      
      public function showPopup(e:Object) : Boolean
      {
         if(!e.mEnabled)
         {
            if(e.parent.id == T.STRB_POWER && !Peripheral.driveMode.RedKeyPresent)
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_POWER_LEVEL_BLACK_KEY,DriveModeValues.HMI_RED])});
            }
            else if(!(e.parent.id == T.STRB_DM_TRANS_SETUP && (Boolean(Peripheral.driveModeManager.highHorsepowerMode) && !Peripheral.driveMode.RedKeyPresent) || e.parent.id == T.STRB_DM_TRANS_SETUP && (Boolean(Peripheral.driveModeManager.highHorsepowerMode) && Peripheral.driveMode.HorsepowerModeCustomStatus == DriveModeValues.HMI_BLACK)))
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_BODY,Peripheral.driveMode.GlobalDriveModeStatus,DriveModeValues.HMI_CUSTOM])});
            }
            return true;
         }
         if(Boolean(Peripheral.driveMode.HorsepowerModeError) && e.parent.id == T.STRB_POWER)
         {
            Framework.structure.findAndReplace(Screens.DRIVEMODE_MAIN,Screens.DRIVEMODE_MAIN,{"horsePowerError":true});
            Framework.structure.back();
            return true;
         }
         if(Boolean(Peripheral.driveMode.ThrottleLockOut) && e.parent.id == T.STRB_POWER)
         {
            Framework.structure.findAndReplace(Screens.DRIVEMODE_MAIN,Screens.DRIVEMODE_MAIN,{"throttleError":true});
            Framework.structure.back();
            return true;
         }
         return false;
      }
      
      private function generateSetUpItems() : void
      {
         this.mParent.clearDataItems();
         var isCustom:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_CUSTOM;
         var isDefault:Boolean = Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_DEFAULT;
         var isEngineMode:Boolean = Boolean(Peripheral.driveModeManager.highHorsepowerMode);
         var isLowHP:Boolean = Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,Peripheral.driveMode.GlobalDriveModeStatus) == DriveModeValues.HMI_BLACK;
         if(Peripheral.driveModeManager.highHorsepowerMode)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_POWER,
               "id":T.STRB_POWER,
               "labels":[DriveModeValues.HMI_RED,"",DriveModeValues.HMI_BLACK],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":Peripheral.driveMode.RedKeyPresent,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_TRANS_SETUP,
               "id":T.STRB_DM_TRANS_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom && (isEngineMode && !isLowHP || !isEngineMode),
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.TRANSMISSION,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_PADDLES_SETUP,
               "id":T.STRB_DM_PADDLES_SETUP,
               "labels":[DriveModeValues.HMI_ON,"",DriveModeValues.HMI_OFF],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom || isDefault,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.PADDLE_SHIFTER,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_TRACTION_SETUP,
               "id":T.STRB_DM_TRACTION_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STABILITY_CONTROL,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         if(Peripheral.vehConfig.hasADCMPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_SUSPENSION_SETUP,
               "id":T.STRB_DM_SUSPENSION_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom || isDefault,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.SUSPENSION,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_STEERING_SETUP,
               "id":T.STRB_DM_STEERING_SETUP,
               "labels":[DriveModeValues.HMI_TRACK,DriveModeValues.HMI_SPORT,DriveModeValues.HMI_STREET],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isCustom || isDefault,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STEERING,Peripheral.driveMode.GlobalDriveModeStatus)
            });
         }
         this.mParent.updateGroups();
      }
   }
}

