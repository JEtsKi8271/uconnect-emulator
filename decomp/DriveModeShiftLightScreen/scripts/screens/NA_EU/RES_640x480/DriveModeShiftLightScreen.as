package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeShiftLightScreen extends ScreenEnhanced
   {
      
      private var mAssets:C_DriveModeShiftLight = new C_DriveModeShiftLight();
      
      public function DriveModeShiftLightScreen()
      {
         mView = this.mAssets;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         mView.nonsrt_button_group.driveMode_button.addEventListener(WidgetEvent.CLICK,this.onDriveMode,false,0,true);
         mView.nonsrt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControl,false,0,true);
         mView.nonsrt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onShiftLight,false,0,true);
         mView.srt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onShiftLight,false,0,true);
         mView.srt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControl,false,0,true);
         mView.right_button_group2.shiftLight_on_button.addEventListener(WidgetEvent.PRESS,this.onShiftIndClickDown,false,0,true);
         mView.right_button_group2.shiftLight_on_button.addEventListener(WidgetEvent.RELEASE,this.onShiftIndClickUp,false,0,true);
         mView.right_button_group2.shiftLight_off_button.addEventListener(WidgetEvent.PRESS,this.onShiftIndClickDown,false,0,true);
         mView.right_button_group2.shiftLight_off_button.addEventListener(WidgetEvent.RELEASE,this.onShiftIndClickUp,false,0,true);
         mView.right_button_group2.shiftLight_RpmSetUp_button.addEventListener(WidgetEvent.CLICK,this.onRPMSetUp,false,0,true);
         mView.title_group1.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         mView.title_group2.close_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SHIFT_INDICATION,this.onShiftIndication,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         mView.nonsrt_button_group.driveMode_button.removeEventListener(WidgetEvent.CLICK,this.onDriveMode);
         mView.nonsrt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControl);
         mView.nonsrt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onShiftLight);
         mView.srt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onShiftLight);
         mView.srt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControl);
         mView.right_button_group2.shiftLight_on_button.removeEventListener(WidgetEvent.PRESS,this.onShiftIndClickDown);
         mView.right_button_group2.shiftLight_on_button.removeEventListener(WidgetEvent.RELEASE,this.onShiftIndClickUp);
         mView.right_button_group2.shiftLight_off_button.removeEventListener(WidgetEvent.PRESS,this.onShiftIndClickDown);
         mView.right_button_group2.shiftLight_off_button.removeEventListener(WidgetEvent.RELEASE,this.onShiftIndClickUp);
         mView.right_button_group2.shiftLight_RpmSetUp_button.removeEventListener(WidgetEvent.CLICK,this.onRPMSetUp);
         mView.title_group1.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         mView.title_group2.close_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SHIFT_INDICATION,this.onShiftIndication);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
      }
      
      override protected function initView() : void
      {
         mView.right_button_group2.shiftLight_RpmSetUp_button.alwaysClick = true;
         mView.title_group2.PerformancePages_button.setEnabled("Ready" == Peripheral.appManager.status ? true : false);
         mView.title_group2.PerformancePages_button.alwaysClick = true;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.setUpIntialElements();
         this.onShiftIndication(null);
         Framework.structure.removeFromStack(Screens.DRIVEMODE_LAUNCHCONTROL);
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         Text.format(mView.nonsrt_button_group.driveMode_button.label,[T.STRB_DM_SET_UP_ARG,"Drive Mode"]);
         Text.format(mView.nonsrt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL_ML);
         Text.format(mView.nonsrt_button_group.shiftLight_button.label,T.STRB_SHIFT_LIGHT_ML);
         Text.format(mView.right_button_group2.shiftLight_on_button.label,T.STRB_SHIFT_LIGHT_ON_ML);
         Text.format(mView.right_button_group2.shiftLight_off_button.label,T.STRB_SHIFT_LIGHT_OFF_ML);
         Text.format(mView.right_button_group2.shiftLight_RpmSetUp_button.label,T.STRB_SHIFT_LIGHT_RPM_SETUP_ML);
         Text.format(mView.shiftlight_text,T.STRB_SHIFT_LIGHT_SHOWS);
         Text.format(mView.srt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL_ML);
         Text.format(mView.srt_button_group.shiftLight_button.label,T.STRB_SHIFT_LIGHT_ML);
         Text.format(mView.title_group1.displayTitle.label,T.STRB_RACE_OPTIONS);
         Text.format(mView.title_group2.displayTitle.label,T.STRB_PERFORMANCE_CONTROL);
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBack(null);
      }
      
      private function onBack(evt:WidgetEvent = null) : void
      {
         Framework.structure.back();
      }
      
      private function onDriveMode(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_SETUPNONSRT);
      }
      
      private function onLaunchControl(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_LAUNCHCONTROL,{"isRPMSetup":false});
      }
      
      private function onRPMSetUp(evt:WidgetEvent) : void
      {
         if(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.DISABLED)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_SHIFT_ON,{
               "message":T.STRB_SHIFT_TURN_DISABLE_ML,
               "backgroudType":1,
               "closeButton":true,
               "timeout":3000
            });
         }
         else if(!Peripheral.driveModeManager.checkSpeedLockout())
         {
            Framework.structure.goto(Screens.DRIVEMODE_SHIFTSETUP);
         }
      }
      
      private function onShiftIndClickDown(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.ShiftIndicatorRequest = evt.data.name == "shiftLight_on_button" ? DriveModeValues.ENABLED : DriveModeValues.DISABLED;
      }
      
      private function onShiftIndClickUp(evt:WidgetEvent) : void
      {
         if(!Peripheral.driveMode.isLegacyDriveModes)
         {
            Peripheral.driveMode.ShiftIndicatorRequest = DriveModeValues.NONE;
         }
      }
      
      private function onShiftLight(evt:WidgetEvent) : void
      {
      }
      
      private function onShiftIndication(evt:DriveModeEvent) : void
      {
         mView.right_button_group2.shiftLight_on_button.setHighlight(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED);
         mView.right_button_group2.shiftLight_off_button.setHighlight(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.DISABLED);
         mView.right_button_group2.shiftLight_RpmSetUp_button.setEnabled(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED && !Peripheral.driveModeManager.speedLockOut);
         mView.driveMode_shiftlight_wk.gotoAndStop(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED ? 2 : 1);
         mView.driveMode_shiftlight_lx.gotoAndStop(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED ? 2 : 1);
         mView.driveMode_shiftlight_ld.gotoAndStop(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED ? 2 : 1);
         mView.driveMode_shiftlight_la.gotoAndStop(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED ? 2 : 1);
      }
      
      private function onSpeedLockout(evt:VehicleStatusEvent) : void
      {
         mView.right_button_group2.shiftLight_RpmSetUp_button.setEnabled(Peripheral.driveMode.ShiftIndicatorStatus == DriveModeValues.ENABLED && !Peripheral.driveModeManager.speedLockOut);
      }
      
      private function setUpIntialElements() : void
      {
         mView.title_group1.visible = this.isSRT();
         mView.title_group2.visible = !this.isSRT();
         mView.nonsrt_button_group.visible = !this.isSRT();
         mView.srt_button_group.visible = this.isSRT();
         mView.driveMode_shiftlight_wk.visible = Peripheral.vehConfig.hasTSBMPresent;
         mView.driveMode_shiftlight_la.visible = !Peripheral.vehConfig.hasTSBMPresent && Peripheral.vehConfig.vehicleLine == "LA";
         mView.driveMode_shiftlight_lx.visible = !Peripheral.vehConfig.hasTSBMPresent && Peripheral.vehConfig.vehicleLine == "LX";
         mView.driveMode_shiftlight_ld.visible = !Peripheral.vehConfig.hasTSBMPresent && Peripheral.vehConfig.vehicleLine == "LD";
         mView.nonsrt_button_group.shiftLight_button.setHighlight(true);
         mView.srt_button_group.shiftLight_button.setHighlight(true);
         mView.title_group1.info_button.visible = false;
         mView.title_group2.info_button.visible = false;
      }
      
      private function isSRT() : Boolean
      {
         return Boolean(Peripheral.vehConfig.hasSRTPresent) && Boolean(Peripheral.vehConfig.hasDriveModePresent);
      }
   }
}

