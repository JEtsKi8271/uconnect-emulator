package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import core.widgets.WidgetScrubber;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeLaunchControlScreen extends ScreenEnhanced
   {
      
      private const mRPMRangeAutomatic:Array = [{
         "range":"3500",
         "frame":9
      },{
         "range":"3250",
         "frame":8
      },{
         "range":"3000",
         "frame":7
      },{
         "range":"2750",
         "frame":6
      },{
         "range":"2500",
         "frame":5
      },{
         "range":"2250",
         "frame":4
      },{
         "range":"2000",
         "frame":3
      },{
         "range":"1750",
         "frame":2
      },{
         "range":"1500",
         "frame":1
      }];
      
      private const mRPMRangeManual:Array = [{
         "range":"4500",
         "frame":13
      },{
         "range":"4250",
         "frame":12
      },{
         "range":"4000",
         "frame":11
      },{
         "range":"3750",
         "frame":10
      },{
         "range":"3500",
         "frame":9
      },{
         "range":"3250",
         "frame":8
      },{
         "range":"3000",
         "frame":7
      },{
         "range":"2750",
         "frame":6
      },{
         "range":"2500",
         "frame":5
      }];
      
      private var assets:C_DriveModeLaunchControl = new C_DriveModeLaunchControl();
      
      private var isRPMSetup:Boolean = false;
      
      private var mContents:Array = [];
      
      private var mLaunchControlRPM:String = "";
      
      private var mScrubber:WidgetScrubber = null;
      
      private var mClickStep:int = 1;
      
      public function DriveModeLaunchControlScreen()
      {
         mView = this.assets;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.assets.nonsrt_button_group.driveMode_button.addEventListener(WidgetEvent.CLICK,this.onDriveMode,false,0,true);
         this.assets.srt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControl,false,0,true);
         this.assets.nonsrt_button_group.launchControl_button.addEventListener(WidgetEvent.CLICK,this.onLaunchControl,false,0,true);
         this.assets.srt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onShiftLight,false,0,true);
         this.assets.nonsrt_button_group.shiftLight_button.addEventListener(WidgetEvent.CLICK,this.onShiftLight,false,0,true);
         this.assets.right_button_group1.activateLaunchControl_button.addEventListener(WidgetEvent.CLICK,this.onActivateLaunch,false,0,true);
         this.assets.right_button_group1.launchRpmSetUp_button.addEventListener(WidgetEvent.CLICK,this.onRPMSetUp,false,0,true);
         this.assets.pagedown_button.addEventListener(WidgetEvent.CLICK,this.onPageDownClick,false,0,true);
         this.assets.pagedown_button.addEventListener(WidgetEvent.LONG_PRESS,this.onPageDownLongPress,false,0,true);
         this.assets.pagedown_button.addEventListener(WidgetEvent.RELEASE,this.onPageDownRelease,false,0,true);
         this.assets.pagedown_button.addEventListener(WidgetEvent.SHORT,this.onPageDownClick,false,0,true);
         this.assets.pageup_button.addEventListener(WidgetEvent.CLICK,this.onPageUpClick,false,0,true);
         this.assets.pageup_button.addEventListener(WidgetEvent.LONG_PRESS,this.onPageUpLongPress,false,0,true);
         this.assets.pageup_button.addEventListener(WidgetEvent.RELEASE,this.onPageUpRelease,false,0,true);
         this.assets.pageup_button.addEventListener(WidgetEvent.SHORT,this.onPageUpClick,false,0,true);
         this.assets.slider.addEventListener(WidgetEvent.POSITION,this.onScrollerPosition,false,0,true);
         this.assets.slider.addEventListener(WidgetEvent.RELEASE,this.onScrollerRelease,false,0,true);
         this.assets.title_group1.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         this.assets.title_group1.info_button.addEventListener(WidgetEvent.CLICK,this.onShowInfo,false,0,true);
         this.assets.title_group2.close_button.addEventListener(WidgetEvent.CLICK,this.onExit,false,0,true);
         this.assets.title_group2.info_button.addEventListener(WidgetEvent.CLICK,this.onShowInfo,false,0,true);
         this.assets.title_group2.PerformancePages_button.addEventListener(WidgetEvent.CLICK,this.onClickPerformancePages,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.LAUNCH_STATUS,this.onLaunchStatus,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.LAUNCH_RPM,this.onLaunchRPMSetting,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         this.assets.nonsrt_button_group.driveMode_button.removeEventListener(WidgetEvent.CLICK,this.onDriveMode);
         this.assets.srt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControl);
         this.assets.nonsrt_button_group.launchControl_button.removeEventListener(WidgetEvent.CLICK,this.onLaunchControl);
         this.assets.srt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onShiftLight);
         this.assets.nonsrt_button_group.shiftLight_button.removeEventListener(WidgetEvent.CLICK,this.onShiftLight);
         this.assets.right_button_group1.activateLaunchControl_button.removeEventListener(WidgetEvent.CLICK,this.onActivateLaunch);
         this.assets.right_button_group1.launchRpmSetUp_button.removeEventListener(WidgetEvent.CLICK,this.onRPMSetUp);
         this.assets.pagedown_button.removeEventListener(WidgetEvent.CLICK,this.onPageDownClick);
         this.assets.pagedown_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onPageDownLongPress);
         this.assets.pagedown_button.removeEventListener(WidgetEvent.RELEASE,this.onPageDownRelease);
         this.assets.pagedown_button.removeEventListener(WidgetEvent.SHORT,this.onPageDownClick);
         this.assets.pageup_button.removeEventListener(WidgetEvent.CLICK,this.onPageUpClick);
         this.assets.pageup_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onPageUpLongPress);
         this.assets.pageup_button.removeEventListener(WidgetEvent.RELEASE,this.onPageUpRelease);
         this.assets.pageup_button.removeEventListener(WidgetEvent.SHORT,this.onPageUpClick);
         this.assets.slider.removeEventListener(WidgetEvent.POSITION,this.onScrollerPosition);
         this.assets.slider.removeEventListener(WidgetEvent.RELEASE,this.onScrollerRelease);
         this.assets.title_group1.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         this.assets.title_group1.info_button.removeEventListener(WidgetEvent.CLICK,this.onShowInfo);
         this.assets.title_group2.close_button.removeEventListener(WidgetEvent.CLICK,this.onExit);
         this.assets.title_group2.info_button.removeEventListener(WidgetEvent.CLICK,this.onShowInfo);
         this.assets.title_group2.PerformancePages_button.removeEventListener(WidgetEvent.CLICK,this.onClickPerformancePages);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.LAUNCH_STATUS,this.onLaunchStatus);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.LAUNCH_RPM,this.onLaunchRPMSetting);
      }
      
      override protected function initView() : void
      {
         this.assets.title_group2.PerformancePages_button.setEnabled("Ready" == Peripheral.appManager.status ? true : false);
         this.assets.title_group2.PerformancePages_button.alwaysClick = true;
         this.assets.title_group1.info_button.alwaysClick = true;
         this.assets.title_group2.info_button.alwaysClick = true;
         this.mScrubber = this.assets.slider;
         this.assets.pagedown_button.auto = 500;
         this.assets.pagedown_button.long = 500;
         this.assets.pageup_button.auto = 500;
         this.assets.pageup_button.long = 500;
      }
      
      override protected function initScreen() : void
      {
         this.mContents = [];
         this.setUpIntialElements();
         this.onLaunchStatus(null);
         Framework.structure.removeFromStack(Screens.DRIVEMODE_SHIFTLIGHT);
         if(Peripheral.vehConfig.transEquipped == "Automatic")
         {
            this.assets.maximum.text = "3500";
            this.assets.minimum.text = "1500";
            this.mLaunchControlRPM = "1500";
            this.mContents = this.mRPMRangeAutomatic;
         }
         else
         {
            this.assets.maximum.text = "4500";
            this.assets.minimum.text = "2500";
            this.mLaunchControlRPM = "2500";
            this.mContents = this.mRPMRangeManual;
         }
         this.mScrubber.maximum = this.mContents.length - 1;
         this.onLaunchRPMSetting(null);
         if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("isRPMSetup")))
         {
            this.isRPMSetup = screenVars.isRPMSetup;
         }
         this.switchElements();
         super.initScreen();
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         Text.format(this.assets.title_group1.info_button.label,T.STRB_DM_INFO,false);
         Text.format(this.assets.title_group2.info_button.label,T.STRB_DM_INFO,false);
         Text.resizeToFitByFontSize(this.assets.title_group1.info_button.label,false,true);
         Text.resizeToFitByFontSize(this.assets.title_group2.info_button.label,false,true);
         Text.format(this.assets.title_group2.PerformancePages_button.label,T.STRB_PERFORMANCE_PAGES);
         Text.format(this.assets.nonsrt_button_group.driveMode_button.label,[T.STRB_DM_SET_UP_ARG,"Drive Mode"]);
         Text.format(this.assets.nonsrt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL_ML);
         Text.format(this.assets.nonsrt_button_group.shiftLight_button.label,T.STRB_SHIFT_LIGHT_ML);
         Text.format(this.assets.srt_button_group.launchControl_button.label,T.STRB_LAUNCH_CONTROL_ML);
         if(!this.isSRT() && !this.hasShiftIndicator())
         {
            Text.format(this.assets.srt_button_group.shiftLight_button.label,[T.STRB_DM_SET_UP_ARG,"Drive Mode"]);
         }
         else
         {
            Text.format(this.assets.srt_button_group.shiftLight_button.label,T.STRB_SHIFT_LIGHT_ML);
         }
         Text.format(this.assets.right_button_group1.launchRpmSetUp_button.label,T.STRB_LAUNCH_RPM_SETUP_2);
         Text.format(this.assets.launchLabelA,T.STRB_LAUNCH_MODE_ACTIVATED);
         Text.format(this.assets.launchLabelB,T.STRB_FOLLOW_INSTRUCTIONS_ML);
      }
      
      override public function cleanup() : void
      {
         this.mContents = null;
         super.cleanup();
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBack(null);
      }
      
      private function onActivateLaunch(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.LaunchButtonRequest = true;
      }
      
      private function onDriveMode(evt:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.DRIVEMODE_SETUPNONSRT);
      }
      
      private function onLaunchControl(evt:WidgetEvent) : void
      {
      }
      
      private function onRPMSetUp(evt:WidgetEvent) : void
      {
         this.isRPMSetup = true;
         this.switchElements();
      }
      
      private function onShiftLight(evt:WidgetEvent) : void
      {
         if(this.hasShiftIndicator())
         {
            Framework.structure.goto(Screens.DRIVEMODE_SHIFTLIGHT);
         }
         else
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUPNONSRT);
         }
      }
      
      private function onBack(evt:WidgetEvent) : void
      {
         if(this.isRPMSetup)
         {
            this.isRPMSetup = false;
            this.switchElements();
         }
         else
         {
            Framework.structure.back();
         }
      }
      
      private function onExit(evt:WidgetEvent) : void
      {
         Framework.structure.exit();
      }
      
      private function onShowInfo(evt:WidgetEvent) : void
      {
         if(!Peripheral.driveModeManager.checkSpeedLockout())
         {
            Framework.structure.findAndReplace(Framework.structure.currentBranch,Framework.structure.currentBranch,{"isRPMSetup":this.isRPMSetup});
            Framework.structure.goto(Screens.DRIVEMODE_LAUNCHINFO);
         }
      }
      
      private function onPageDownClick(evt:WidgetEvent) : void
      {
         var index:int = this.getIndexFromString(this.mLaunchControlRPM);
         index = index >= this.mContents.length ? int(this.mContents.length - 1) : int(index + this.mClickStep);
         this.mScrubber.position = index;
         this.updateRPMPosition(index);
      }
      
      private function onPageDownLongPress(evt:WidgetEvent) : void
      {
         this.mClickStep = 2;
      }
      
      private function onPageDownRelease(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.LaunchRPMPointRequest = this.mLaunchControlRPM;
         this.mClickStep = 1;
      }
      
      private function onPageUpClick(evt:WidgetEvent) : void
      {
         var index:int = this.getIndexFromString(this.mLaunchControlRPM);
         index = index == 0 ? 0 : int(index - this.mClickStep);
         this.mScrubber.position = index;
         this.updateRPMPosition(index);
      }
      
      private function onPageUpLongPress(evt:WidgetEvent) : void
      {
         this.mClickStep = 2;
      }
      
      private function onPageUpRelease(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.LaunchRPMPointRequest = this.mLaunchControlRPM;
         this.mClickStep = 1;
      }
      
      private function onScrollerPosition(evt:WidgetEvent) : void
      {
         this.updateRPMPosition(this.mScrubber.position);
      }
      
      private function onScrollerRelease(evt:WidgetEvent) : void
      {
         Peripheral.driveMode.LaunchRPMPointRequest = this.mLaunchControlRPM;
         this.mScrubber.position = this.getIndexFromString(this.mLaunchControlRPM);
         this.updateRPMPosition(this.getIndexFromString(this.mLaunchControlRPM));
      }
      
      private function onLaunchStatus(e:Event) : void
      {
         var translationID:uint = Peripheral.driveMode.LaunchButtonStatus ? uint(T.STRB_CANCEL_LAUNCH_MODE) : uint(T.STRB_ACTIVE_LAUNCH_MODE);
         Text.format(this.assets.right_button_group1.activateLaunchControl_button.label,translationID);
         this.assets.launchLabelA.visible = Boolean(Peripheral.driveMode.LaunchButtonStatus) && !this.isRPMSetup;
         this.assets.launchLabelB.visible = Boolean(Peripheral.driveMode.LaunchButtonStatus) && !this.isRPMSetup;
         this.assets.right_button_group1.activateLaunchControl_button.setHighlight(Peripheral.driveMode.LaunchButtonStatus);
      }
      
      private function onLaunchRPMSetting(e:Event) : void
      {
         var index:int = this.getIndexFromString(Peripheral.driveMode.LaunchRPMPointStatus);
         this.mScrubber.position = index;
         this.updateRPMPosition(index);
      }
      
      private function onClickPerformancePages(e:Event = null) : void
      {
         if(!this.assets.title_group2.PerformancePages_button.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_PP_NOT_READY);
         }
         else
         {
            Peripheral.appStateManager.startXlet(Peripheral.appManager.getPPId());
         }
      }
      
      private function onAppManagerStatus(e:AppManagerEvent) : void
      {
         this.assets.title_group2.PerformancePages_button.setEnabled("Ready" == Peripheral.appManager.status);
      }
      
      private function getIndexFromString(str:String) : int
      {
         var index:int = NaN;
         switch(str)
         {
            case "4500":
               index = 0;
               break;
            case "4250":
               index = 1;
               break;
            case "4000":
               index = 2;
               break;
            case "3750":
               index = 3;
               break;
            case "3500":
               index = Peripheral.vehConfig.transEquipped == "Automatic" ? 0 : 4;
               break;
            case "3250":
               index = Peripheral.vehConfig.transEquipped == "Automatic" ? 1 : 5;
               break;
            case "3000":
               index = Peripheral.vehConfig.transEquipped == "Automatic" ? 2 : 6;
               break;
            case "2750":
               index = Peripheral.vehConfig.transEquipped == "Automatic" ? 3 : 7;
               break;
            case "2500":
               index = Peripheral.vehConfig.transEquipped == "Automatic" ? 4 : 8;
               break;
            case "2250":
               index = 5;
               break;
            case "2000":
               index = 6;
               break;
            case "1750":
               index = 7;
               break;
            case "1500":
               index = 8;
         }
         return index;
      }
      
      private function hasShiftIndicator() : Boolean
      {
         return Peripheral.vehConfig.shiftIndicatorType == "PSI" || Peripheral.vehConfig.shiftIndicatorType == "PGSI";
      }
      
      private function isSRT() : Boolean
      {
         return Boolean(Peripheral.vehConfig.hasSRTPresent) && Boolean(Peripheral.vehConfig.hasDriveModePresent);
      }
      
      private function setUpIntialElements() : void
      {
         this.assets.title_group1.visible = this.isSRT();
         this.assets.title_group2.visible = !this.isSRT();
         this.assets.nonsrt_button_group.visible = !this.isSRT() && this.hasShiftIndicator();
         this.assets.srt_button_group.visible = this.isSRT() && this.hasShiftIndicator() || !this.isSRT() && !this.hasShiftIndicator();
         this.assets.window.display_point_wk.visible = Peripheral.vehConfig.hasTSBMPresent;
         this.assets.window.dial_display.visible = Peripheral.vehConfig.vehicleLine != "LX" && !Peripheral.vehConfig.hasTSBMPresent;
         this.assets.window.display_point1.visible = Peripheral.vehConfig.vehicleLine == "LA";
         this.assets.window.display_point2.visible = Peripheral.vehConfig.vehicleLine == "LD";
         this.assets.window.display_point3.visible = Peripheral.vehConfig.vehicleLine == "LX";
         if(this.isSRT() && Boolean(Peripheral.vehConfig.hasRedKeyPresent))
         {
            this.assets.window.dial_display.gotoAndStop(Peripheral.vehConfig.vehicleLine + "_HellCat");
         }
         else if(this.isSRT())
         {
            this.assets.window.dial_display.gotoAndStop(Peripheral.vehConfig.vehicleLine + "_SRT");
         }
         else
         {
            this.assets.window.dial_display.gotoAndStop(Peripheral.vehConfig.vehicleLine + "_Base");
         }
         this.assets.nonsrt_button_group.launchControl_button.setHighlight(true);
         this.assets.srt_button_group.launchControl_button.setHighlight(true);
         this.assets.title_group1.info_button.visible = false;
         this.assets.title_group2.info_button.visible = false;
      }
      
      private function switchElements() : void
      {
         this.assets.title_group1.visible = this.isRPMSetup || this.isSRT();
         this.assets.title_group2.visible = !this.isRPMSetup && !this.isSRT();
         this.assets.title_group1.info_button.visible = this.isRPMSetup;
         this.assets.title_group1.info_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
         this.assets.title_group2.info_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
         this.assets.maximum.visible = this.isRPMSetup;
         this.assets.minimum.visible = this.isRPMSetup;
         this.assets.background.visible = this.isRPMSetup;
         this.assets.pagedown_button.visible = this.isRPMSetup;
         this.assets.pageup_button.visible = this.isRPMSetup;
         this.assets.slider.visible = this.isRPMSetup;
         this.assets.slider.thumb.rpm.visible = this.isRPMSetup;
         this.assets.right_button_group1.visible = !this.isRPMSetup;
         this.assets.launchLabelA.visible = Boolean(Peripheral.driveMode.LaunchButtonStatus) && !this.isRPMSetup;
         this.assets.launchLabelB.visible = Boolean(Peripheral.driveMode.LaunchButtonStatus) && !this.isRPMSetup;
         if(this.isRPMSetup)
         {
            Text.format(this.assets.title_group1.displayTitle.label,T.STRB_LAUNCH_RPM_SETUP_1);
            Text.format(this.assets.title_group2.displayTitle.label,T.STRB_LAUNCH_RPM_SETUP_1);
         }
         else
         {
            Text.format(this.assets.title_group1.displayTitle.label,T.STRB_RACE_OPTIONS);
            Text.format(this.assets.title_group2.displayTitle.label,T.STRB_PERFORMANCE_CONTROL);
         }
      }
      
      private function updateRPMPosition(position:Number) : void
      {
         if(position >= this.mContents.length)
         {
            position = this.mContents.length - 1;
         }
         else if(position < 0)
         {
            position = 0;
         }
         this.mLaunchControlRPM = this.mContents[position].range;
         this.assets.slider.thumb.rpm.label.text = this.mLaunchControlRPM;
         this.assets.pageup_button.setEnabled(position == 0 ? false : true);
         this.assets.pagedown_button.setEnabled(position >= this.mContents.length - 1 ? false : true);
         this.assets.window.display_point_wk.gotoAndStop(this.mContents[position].frame);
         this.assets.window.display_point3.gotoAndStop(this.mContents[position].frame);
         this.assets.window.display_point2.gotoAndStop(this.mContents[position].frame);
         this.assets.window.display_point1.gotoAndStop(this.mContents[position].frame);
      }
   }
}

