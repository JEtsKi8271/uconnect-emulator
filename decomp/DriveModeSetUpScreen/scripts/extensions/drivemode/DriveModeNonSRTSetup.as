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
   
   public class DriveModeNonSRTSetup implements IDriveModeSetupExtension
   {
      
      private const COLOR_YELLOW:uint = 14859777;
      
      private var mDriveModeType:String;
      
      private var mParent:*;
      
      public function DriveModeNonSRTSetup(parent:*)
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
         this.mDriveModeType = driveModeType;
         this.mParent.view.line1.visible = true;
         this.mParent.view.line2.visible = true;
         this.mParent.view.buttonGroups.visible = true;
         this.generateSetUpItems();
      }
      
      public function setTitleBar() : void
      {
         Text.format(this.mParent.view.displayTitle.label,[T.STRB_DM_MODE_SET_UP_ARG,this.mDriveModeType]);
      }
      
      public function modeChanged(e:DriveModeEvent) : void
      {
         this.generateSetUpItems();
      }
      
      public function showPopup(e:Object) : Boolean
      {
         if(!e.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_POPUP_DISABLED_BTN_SELECTED,{"message":Text.compose([T.STRB_DM_ERROR_LEVEL_UNAVAILABLE_BODY,DriveModeValues.HMI_DEFAULT,DriveModeValues.HMI_SPORT])});
            return true;
         }
         if(Boolean(Peripheral.driveMode.HorsepowerModeError) && e.parent.id == T.STRB_ENGINE_TRANS)
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUPNONSRT,{"horsePowerError":true});
            return true;
         }
         return false;
      }
      
      private function generateSetUpItems() : void
      {
         var isSport:Boolean = this.mDriveModeType == DriveModeValues.HMI_SPORT;
         this.mParent.clearDataItems();
         if(Peripheral.vehConfig.hasTransDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_ENGINE_TRANS,
               "id":T.STRB_ENGINE_TRANS,
               "labels":[DriveModeValues.HMI_SPORT,"",DriveModeValues.HMI_NORMAL],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isSport,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.TRANSMISSION,this.mDriveModeType)
            });
         }
         else
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_ENGINE,
               "id":T.STRB_DM_ENGINE,
               "labels":[DriveModeValues.HMI_SPORT,"",DriveModeValues.HMI_NORMAL],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isSport,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.HORSE_POWER,this.mDriveModeType)
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
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.PADDLE_SHIFTER,this.mDriveModeType)
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_TRACTION_CONTROL,
               "id":T.STRB_DM_TRACTION_CONTROL,
               "labels":[DriveModeValues.HMI_SPORT,"",DriveModeValues.HMI_NORMAL],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":isSport,
               "showMiddle":false,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STABILITY_CONTROL,this.mDriveModeType)
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mParent.pushDataItems({
               "title":T.STRB_DM_STEERING_SETUP,
               "id":T.STRB_DM_STEERING_SETUP,
               "labels":[DriveModeValues.HMI_SPORT,DriveModeValues.HMI_NORMAL,DriveModeValues.HMI_COMFORT],
               "lockOut":Peripheral.driveModeManager.speedLockOut,
               "enable":true,
               "showMiddle":true,
               "colorBottom":this.COLOR_YELLOW,
               "value":Peripheral.driveModeManager.getCustomerSettings(DriveModeTypes.STEERING,this.mDriveModeType)
            });
         }
         this.mParent.updateGroups();
      }
   }
}

