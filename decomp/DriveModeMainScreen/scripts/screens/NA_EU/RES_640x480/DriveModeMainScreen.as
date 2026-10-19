package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import extensions.drivemode.DriveModeSRTMain;
   import extensions.drivemode.DriveModeWKMain;
   import extensions.drivemode.IDriveModeMainExtension;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeMainScreen extends ScreenEnhanced
   {
      
      private var assets:C_driveModeMainView = new C_driveModeMainView();
      
      private var mExtension:IDriveModeMainExtension;
      
      public function DriveModeMainScreen()
      {
         mView = this.assets;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         mView.Layer_SRT.exit_button.addEventListener(WidgetEvent.CLICK,this.onClose,false,0,true);
         mView.Layer_WK.exit_button.addEventListener(WidgetEvent.CLICK,this.onClose,false,0,true);
         mView.Layer_SRT.valet_button.addEventListener(WidgetEvent.CLICK,this.onValet,false,0,true);
         mView.Layer_SRT.valet_button_eco.addEventListener(WidgetEvent.CLICK,this.onValet,false,0,true);
         mView.Layer_WK.valet_button.addEventListener(WidgetEvent.CLICK,this.onValet,false,0,true);
         mView.Layer_SRT.raceoptions_button.addEventListener(WidgetEvent.CLICK,this.onOption,false,0,true);
         mView.Layer_WK.raceoptions_button.addEventListener(WidgetEvent.CLICK,this.onOption,false,0,true);
         mView.Layer_SRT.srt_button.addEventListener(WidgetEvent.CLICK,this.onSRTClick,false,0,true);
         mView.Layer_WK.srt_button.addEventListener(WidgetEvent.CLICK,this.onSRTClick,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onAppManagerStatus,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onUpdateMainScreen,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdateMainScreen,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.VALET_LOCKOUT,this.onValetLockOut,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.THROTTLE_LOCKOUT,this.onThrottleLockOut,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.ENGINE_LOCKOUT,this.onEngineLockOut,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SNA_RECOVERY,this.onUpdateMainScreen,false,0,true);
         Peripheral.driveModeManager.addEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdateMainScreen,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onLockOut,false,0,true);
         this.mExtension.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         mView.Layer_SRT.exit_button.removeEventListener(WidgetEvent.CLICK,this.onClose);
         mView.Layer_WK.exit_button.removeEventListener(WidgetEvent.CLICK,this.onClose);
         mView.Layer_SRT.valet_button.removeEventListener(WidgetEvent.CLICK,this.onValet);
         mView.Layer_SRT.valet_button_eco.removeEventListener(WidgetEvent.CLICK,this.onValet);
         mView.Layer_WK.valet_button.removeEventListener(WidgetEvent.CLICK,this.onValet);
         mView.Layer_SRT.raceoptions_button.removeEventListener(WidgetEvent.CLICK,this.onOption);
         mView.Layer_WK.raceoptions_button.removeEventListener(WidgetEvent.CLICK,this.onOption);
         mView.Layer_SRT.srt_button.removeEventListener(WidgetEvent.CLICK,this.onSRTClick);
         mView.Layer_WK.srt_button.removeEventListener(WidgetEvent.CLICK,this.onSRTClick);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus);
         Peripheral.appManager.removeEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onAppManagerStatus);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onUpdateMainScreen);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdateMainScreen);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.VALET_LOCKOUT,this.onValetLockOut);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.THROTTLE_LOCKOUT,this.onThrottleLockOut);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.ENGINE_LOCKOUT,this.onEngineLockOut);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SNA_RECOVERY,this.onUpdateMainScreen);
         Peripheral.driveModeManager.removeEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdateMainScreen);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onLockOut);
         this.mExtension.removeListeners();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.initExtension();
         this.mExtension.initView();
         mView.Layer_SRT.srt_button.alwaysClick = true;
         mView.Layer_WK.srt_button.alwaysClick = true;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mExtension.initScreen(screenVars);
         if(screenVars != null && Boolean(screenVars.hasOwnProperty("showSNA")))
         {
            screenVars.showSNA = false;
         }
         this.onAppManagerStatus(null);
         this.onLockOut(null);
         this.onValetLockOut(null);
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         var composition:* = this.hasShiftIndicator() ? T.STRB_RACE_OPTIONS : T.STRB_LAUNCH_CONTROL;
         Text.format(mView.Layer_SRT.raceoptions_button.label,composition);
         Text.format(mView.Layer_WK.raceoptions_button.label,composition);
         Text.format(mView.Layer_SRT.srt_button.label,T.STRB_PAGES);
         Text.format(mView.Layer_WK.srt_button.label,T.STRB_PAGES);
         Text.format(mView.Layer_SRT.valet_button.label,T.STRB_VALET);
         Text.format(mView.Layer_SRT.valet_button_eco.label,T.STRB_VALET);
         Text.format(mView.Layer_WK.valet_button.label,T.STRB_VALET);
         this.mExtension.changeLocale();
      }
      
      override public function cleanup() : void
      {
         this.mExtension.cleanup();
         super.cleanup();
      }
      
      private function onClose(evt:WidgetEvent) : void
      {
         Framework.structure.exit();
      }
      
      private function onOption(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_LAUNCHCONTROL,{"isRPMSetup":false});
      }
      
      private function onSRTClick(evt:WidgetEvent) : void
      {
         if(!evt.target.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_PP_NOT_READY);
         }
         else
         {
            Peripheral.appStateManager.fullStartDaemonXlet(Peripheral.appManager.getPPId());
         }
      }
      
      public function onValet(evt:WidgetEvent) : void
      {
         Peripheral.driveModeManager.toggleValetMode();
      }
      
      private function onAppManagerStatus(e:Event) : void
      {
         mView.Layer_SRT.srt_button.setEnabled("Ready" == Peripheral.appManager.status && Boolean(Peripheral.appStateManager.ppReady) ? true : false);
         mView.Layer_WK.srt_button.setEnabled("Ready" == Peripheral.appManager.status && Boolean(Peripheral.appStateManager.ppReady) ? true : false);
      }
      
      private function onLockOut(evt:VehicleStatusEvent) : void
      {
         this.mExtension.onLockOut();
      }
      
      private function onUpdateMainScreen(evt:DriveModeEvent) : void
      {
         this.mExtension.updateMainScreen();
      }
      
      private function onValetLockOut(evt:DriveModeEvent) : void
      {
         if(Peripheral.driveMode.ValetModeLockOutReason == DriveModeValues.LOCKOUT_NONE)
         {
            mView.Layer_WK.valet_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
            mView.Layer_SRT.valet_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
            mView.Layer_SRT.valet_button_eco.setEnabled(!Peripheral.driveModeManager.speedLockOut);
         }
         else
         {
            mView.Layer_WK.valet_button.setEnabled(false);
            mView.Layer_SRT.valet_button.setEnabled(false);
            mView.Layer_SRT.valet_button_eco.setEnabled(false);
         }
      }
      
      private function onThrottleLockOut(evt:DriveModeEvent) : void
      {
         this.mExtension.onLockOut();
      }
      
      private function onEngineLockOut(evt:DriveModeEvent) : void
      {
         this.mExtension.onLockOut();
      }
      
      private function initExtension() : void
      {
         if(Peripheral.vehConfig.hasTSBMPresent)
         {
            this.mExtension = new DriveModeWKMain(this);
         }
         else
         {
            this.mExtension = new DriveModeSRTMain(this);
         }
      }
      
      private function hasShiftIndicator() : Boolean
      {
         return Peripheral.vehConfig.shiftIndicatorType == "PSI" || Peripheral.vehConfig.shiftIndicatorType == "PGSI";
      }
   }
}

