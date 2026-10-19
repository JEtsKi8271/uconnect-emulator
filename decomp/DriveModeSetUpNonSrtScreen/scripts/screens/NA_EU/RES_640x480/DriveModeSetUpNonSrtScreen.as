package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.DriveModeValues;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeSetUpNonSrtScreen extends ScreenEnhanced
   {
      
      private const ERROR_GENERIC:int = 0;
      
      private const ERROR_HORSEPOWER:int = 1;
      
      private const ERROR_THROTTLE:int = 2;
      
      private var mAssets:C_DriveModeSetUpNonSrt = new C_DriveModeSetUpNonSrt();
      
      private var mContents:Array = [];
      
      private var mErrors:Array = new Array(3);
      
      public function DriveModeSetUpNonSrtScreen()
      {
         mView = this.mAssets;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         mView.defaultmodesetup_button.addEventListener(WidgetEvent.CLICK,this.onDefaultSetUpClick,false,0,true);
         mView.nonsrt_button_group.driveMode_button.addEventListener(WidgetEvent.CLICK,this.onDriveModeSetUpClick,false,0,true);
         mView.nonsrt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControlClick,false,0,true);
         mView.nonsrt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onShiftLightClick,false,0,true);
         mView.sportmodesetup_button.addEventListener(WidgetEvent.CLICK,this.onSportSetUpClick,false,0,true);
         mView.srt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControlClick,false,0,true);
         mView.srt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onDriveModeSetUpClick,false,0,true);
         mView.title_group2.close_button.addEventListener(WidgetEvent.CLICK,this.onExitClick,false,0,true);
         mView.title_group2.PerformancePages_button.addEventListener(WidgetEvent.CLICK,this.onPerformancePagesClick,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onAppManagerStatus,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SCREEN_UPDATE,this.onScreenUpdate,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onScreenUpdate,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         mView.defaultmodesetup_button.removeEventListener(WidgetEvent.CLICK,this.onDefaultSetUpClick);
         mView.nonsrt_button_group.driveMode_button.removeEventListener(WidgetEvent.CLICK,this.onDriveModeSetUpClick);
         mView.nonsrt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControlClick);
         mView.nonsrt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onShiftLightClick);
         mView.sportmodesetup_button.removeEventListener(WidgetEvent.CLICK,this.onSportSetUpClick);
         mView.srt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControlClick);
         mView.srt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onDriveModeSetUpClick);
         mView.title_group2.close_button.removeEventListener(WidgetEvent.CLICK,this.onExitClick);
         mView.title_group2.PerformancePages_button.removeEventListener(WidgetEvent.CLICK,this.onPerformancePagesClick);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus);
         Peripheral.appManager.removeEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onAppManagerStatus);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SCREEN_UPDATE,this.onScreenUpdate);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.GLOBAL_MODE_UPDATE,this.onScreenUpdate);
      }
      
      override protected function initView() : void
      {
         mView.srt_button_group.visible = Peripheral.vehConfig.shiftIndicatorType != "PSI" && Peripheral.vehConfig.shiftIndicatorType != "PGSI";
         mView.nonsrt_button_group.visible = Peripheral.vehConfig.shiftIndicatorType == "PSI" || Peripheral.vehConfig.shiftIndicatorType == "PGSI";
         mView.title_group2.PerformancePages_button.alwaysClick = true;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         mView.nonsrt_button_group.driveMode_button.setHighlight(true);
         mView.srt_button_group.shiftLight_button.setHighlight(true);
         this.mErrors[this.ERROR_GENERIC] = false;
         this.mErrors[this.ERROR_HORSEPOWER] = false;
         this.mErrors[this.ERROR_THROTTLE] = false;
         if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("horsePowerError")))
         {
            this.mErrors[this.ERROR_HORSEPOWER] = screenVars.horsePowerError;
         }
         if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("throttleError")))
         {
            this.mErrors[this.ERROR_THROTTLE] = screenVars.throttleError;
         }
         this.onAppManagerStatus(null);
         this.onScreenUpdate(null);
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         Text.format(mView.title_group2.displayTitle.label,T.STRB_PERFORMANCE_CONTROL);
         Text.format(mView.title_group2.PerformancePages_button.label,T.STRB_PERFORMANCE_PAGES);
         Text.format(mView.nonsrt_button_group.driveMode_button.label,[T.STRB_DM_SET_UP_ARG,"Drive Mode"]);
         Text.format(mView.nonsrt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL_ML);
         Text.format(mView.nonsrt_button_group.shiftLight_button.label,T.STRB_SHIFT_LIGHT_ML);
         Text.format(mView.srt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL);
         Text.format(mView.srt_button_group.shiftLight_button.label,[T.STRB_DM_SET_UP_ARG,"Drive Mode"]);
         Text.format(mView.sportmodesetup_button.label,[T.STRB_SPORT_MODE_SETUP,"Sport"]);
         Text.format(mView.defaultmodesetup_button.label,[T.STRB_SPORT_MODE_SETUP,"Default"]);
      }
      
      private function onDefaultSetUpClick(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_DEFAULT;
         Framework.structure.goto(Screens.DRIVEMODE_SETUP,{"driveModeType":DriveModeValues.HMI_DEFAULT});
      }
      
      private function onDriveModeSetUpClick(evt:WidgetEvent) : void
      {
      }
      
      private function onExitClick(evt:WidgetEvent) : void
      {
         Framework.structure.exit();
      }
      
      private function onLaunchControlClick(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_LAUNCHCONTROL,{"isRPMSetup":false});
      }
      
      private function onPerformancePagesClick(evt:WidgetEvent) : void
      {
         if(!mView.title_group2.PerformancePages_button.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_PP_NOT_READY);
         }
         else
         {
            Peripheral.appStateManager.startXlet(Peripheral.appManager.getPPId());
         }
      }
      
      private function onShiftLightClick(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_SHIFTLIGHT);
      }
      
      private function onSportSetUpClick(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.GlobalDriveModeRequest = DriveModeValues.HMI_SPORT;
         Framework.structure.goto(Screens.DRIVEMODE_SETUP,{"driveModeType":DriveModeValues.HMI_SPORT});
      }
      
      private function onAppManagerStatus(evt:AppManagerEvent) : void
      {
         mView.title_group2.PerformancePages_button.setEnabled("Ready" == Peripheral.appManager.status);
      }
      
      private function onScreenUpdate(evt:DriveModeEvent) : void
      {
         this.setSubItems();
         this.checkForError();
         this.setErrorMessage();
      }
      
      private function setSubItems() : void
      {
         this.mContents.length = 0;
         if(Boolean(Peripheral.driveMode.GlobalDriveModeStatus == DriveModeValues.HMI_SPORT || DriveModeValues.HMI_DEFAULT) || Boolean(DriveModeValues.HMI_CUSTOM) || Boolean(DriveModeValues.HMI_TRACK))
         {
            this.mContents.push({
               "title":T.STRB_CURRENT_MODE_WC,
               "error":false,
               "value":Peripheral.driveMode.GlobalDriveModeStatus
            });
         }
         this.mContents.push({
            "title":(Peripheral.vehConfig.hasTransDrvMdPresent ? T.STRB_ENGINE_TRANS_WC : T.STRB_DM_ENGINE),
            "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.HORSE_POWER] || this.mErrors[this.ERROR_HORSEPOWER] || this.mErrors[this.ERROR_THROTTLE],
            "value":(Peripheral.vehConfig.hasTransDrvMdPresent ? Peripheral.driveMode.TransmissionModeStatus : Peripheral.driveMode.EngineModeStatus)
         });
         if(Peripheral.vehConfig.hasPaddlesMode)
         {
            this.mContents.push({
               "title":T.STRB_PADDLE_SHIFT_WC,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.PADDLE_SHIFTER],
               "value":Peripheral.driveMode.PaddleShifterStatus
            });
         }
         if(Peripheral.vehConfig.hasESCDrvMdPresent)
         {
            this.mContents.push({
               "title":T.STRB_DM_TRACTION_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STABILITY_CONTROL],
               "value":Peripheral.driveMode.StabilityStatus
            });
         }
         if(Boolean(Peripheral.vehConfig.hasEPSPresent) && Peripheral.driveMode.PowerSteeringType == DriveModeValues.HMI_EPS)
         {
            this.mContents.push({
               "title":T.STRB_DM_STEERING_WK_LABEL,
               "error":Peripheral.driveMode.ErrorGroup[DriveModeTypes.STEERING],
               "value":Peripheral.driveMode.SteeringStatus
            });
         }
         mView.drive_mode_group.items = this.mContents;
      }
      
      private function checkForError() : void
      {
         var type:String = null;
         for(type in Peripheral.driveMode.ErrorGroup)
         {
            switch(type)
            {
               case DriveModeTypes.HORSE_POWER:
                  if(Peripheral.driveMode.ErrorGroup[type])
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
            }
         }
         this.mErrors[this.ERROR_GENERIC] = false;
      }
      
      private function setErrorMessage() : void
      {
         if(this.mErrors[this.ERROR_GENERIC])
         {
            Text.format(mView.Warning_message,T.STRB_LEVEL_WARNING_MESSAGE);
         }
         else if(this.mErrors[this.ERROR_HORSEPOWER])
         {
            Text.format(mView.Warning_message,T.STRB_DM_ERROR_POWER_CANNOT_CHANGE);
         }
         else if(this.mErrors[this.ERROR_THROTTLE])
         {
            Text.format(mView.Warning_message,T.STRB_POWER_WARNING_MESSAGE_4);
         }
         else
         {
            Text.format(mView.Warning_message,"");
         }
         mView.Warning_icon.visible = mView.Warning_message.text != "";
         mView.Warning_message.visible = mView.Warning_message.text != "";
      }
   }
}

