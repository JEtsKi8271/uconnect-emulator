package screens.NA_EU.RES_640x480
{
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.events.StructureEvent;
   import core.utils.Text;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   import peripheral.VehicleFeatureManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class HVACHomeScreen extends GenericScreen
   {
      
      private static const MASERATI_VEH_BRAND:String = "11";
      
      private const SLIDER_HI:String = "HI";
      
      private const SLIDER_LO:String = "LO";
      
      private var mVFM:VehicleFeatureManager = new VehicleFeatureManager();
      
      private var mVehicleFeatureSet:String = this.mVFM.vehicleFeatureSet;
      
      private var mFrontClimateState:Boolean = true;
      
      private var mRearClimateState:Boolean = true;
      
      private var mCurrentView:MovieClip;
      
      private var mVehicleSettingView:MovieClip;
      
      private var sliderMax:String = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" ? "41" : "85";
      
      private var sliderMin:String = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" ? "15" : "59";
      
      private var mTempAdjusting:String = "";
      
      private var mSliderFrontRightPressed:Boolean = false;
      
      private var mSliderFrontLeftPressed:Boolean = false;
      
      private var mSliderRearRightPressed:Boolean = false;
      
      private var mSliderRearLeftPressed:Boolean = false;
      
      private var mTempFrontRightValue:String = "";
      
      private var mTempFrontLeftValue:String = "";
      
      private var mOriginal:int = 0;
      
      private var mVehicleBrand:String = Peripheral.vehConfig.vehicleBrand;
      
      public function HVACHomeScreen()
      {
         mView = new C_HVACHomeScreenView();
         cache = true;
         super();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Framework.structure.setExit();
         mView.display_group.hideChildren();
         this.mFrontClimateState = Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT);
         this.mRearClimateState = Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_REAR);
         if(!Peripheral.vehConfig.hvacSystemAutomatic)
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.track.gotoAndStop("manual");
            mView.display_group.frontClimate_group.rightTempControl_scroller.track.gotoAndStop("manual");
            mView.display_group.rearClimate_group.rearTempControl_scroller.track.gotoAndStop("manual");
            mView.display_group.rearClimate_group.leftTempControl_scroller.track.gotoAndStop("manual");
            mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.grip.visible = true;
            mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.grip.visible = true;
            mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.grip.visible = true;
            mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.grip.visible = true;
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               this.sliderMin = "0";
               this.sliderMax = "17";
            }
            else if(Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
            {
               this.sliderMin = "0";
               this.sliderMax = "26";
            }
            else if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
            {
               this.sliderMin = "0";
               this.sliderMax = "25";
            }
            else
            {
               this.sliderMin = "0";
               this.sliderMax = "16";
            }
         }
         else
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.track.gotoAndStop("automatic");
            mView.display_group.frontClimate_group.rightTempControl_scroller.track.gotoAndStop("automatic");
            mView.display_group.rearClimate_group.rearTempControl_scroller.track.gotoAndStop("automatic");
            mView.display_group.rearClimate_group.leftTempControl_scroller.track.gotoAndStop("automatic");
            mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.grip.visible = false;
            mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.grip.visible = false;
            mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.grip.visible = false;
            mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.grip.visible = false;
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               this.sliderMin = "15";
               this.sliderMax = "41";
            }
            else if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
            {
               this.sliderMin = "59";
               this.sliderMax = "85";
            }
            else
            {
               this.sliderMin = "13";
               this.sliderMax = "31";
            }
         }
         mView.display_group.frontClimate_group.leftTempControl_scroller.setVMinimum(Number(this.sliderMin));
         mView.display_group.frontClimate_group.leftTempControl_scroller.setVMaximum(Number(this.sliderMax) + 1);
         mView.display_group.frontClimate_group.leftTempControl_scroller.setVPageSize(1);
         mView.display_group.frontClimate_group.leftTempControl_scroller.setReportingPeriod(100);
         mView.display_group.frontClimate_group.leftTempControl_scroller.setDisableButtons(true);
         mView.display_group.frontClimate_group.rightTempControl_scroller.setVMinimum(Number(this.sliderMin));
         mView.display_group.frontClimate_group.rightTempControl_scroller.setVMaximum(Number(this.sliderMax) + 1);
         mView.display_group.frontClimate_group.rightTempControl_scroller.setVPageSize(1);
         mView.display_group.frontClimate_group.rightTempControl_scroller.setReportingPeriod(100);
         mView.display_group.frontClimate_group.rightTempControl_scroller.setDisableButtons(true);
         this.mTempFrontRightValue = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT);
         this.mTempFrontLeftValue = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT);
         this.mTempFrontRightValue = "lo" == this.mTempFrontRightValue ? this.SLIDER_LO : ("hi" == this.mTempFrontRightValue ? this.SLIDER_HI : this.mTempFrontRightValue + String.fromCharCode(176));
         this.mTempFrontLeftValue = "lo" == this.mTempFrontLeftValue ? this.SLIDER_LO : ("hi" == this.mTempFrontLeftValue ? this.SLIDER_HI : this.mTempFrontLeftValue + String.fromCharCode(176));
         mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = this.mTempFrontRightValue;
         mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = this.mTempFrontLeftValue;
         if(this.mVFM.hasDualFrontZones == true)
         {
            this.setupSliderListeners(mView.display_group.frontClimate_group.leftTempControl_scroller,Peripheral.hvac.ZONE_FRONT_LEFT,true);
            this.setupSliderListeners(mView.display_group.frontClimate_group.rightTempControl_scroller,Peripheral.hvac.ZONE_FRONT_RIGHT,true);
         }
         else if(this.mVFM.hasRightHandDrive == true)
         {
            this.setupSliderListeners(mView.display_group.frontClimate_group.rightTempControl_scroller,Peripheral.hvac.ZONE_FRONT_RIGHT,true);
         }
         else
         {
            this.setupSliderListeners(mView.display_group.frontClimate_group.leftTempControl_scroller,Peripheral.hvac.ZONE_FRONT_LEFT,true);
         }
         if(this.mFrontClimateState == true)
         {
            this.mCurrentView = mView.display_group.frontClimate_group;
         }
         else
         {
            this.mCurrentView = mView.display_group.frontClimateOff_group;
         }
         this.setScreenState();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button,mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.AC_button,mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button,mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.frontDefrost_button,mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.AC_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.frontDefrost_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button,mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearClimate_button,mView.display_group
         .frontClimate_group.climate5BarTop_group.maxAC_button,mView.display_group.frontClimate_group.climate5BarTop_group.AC_button,mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button,mView.display_group.frontClimate_group.climate5BarTop_group.auto_button,mView.display_group.frontClimate_group.climate5BarTop_group.frontDefrost_button,mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button,mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button,mView.display_group.frontClimate_group.climate6BarTop_group.AC_button,mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button,mView.display_group.frontClimate_group.climate6BarTop_group.auto_button,mView.display_group.frontClimate_group.climate6BarTop_group.frontDefrost_button,mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button,mView.display_group.frontClimate_group.climate6BarTop_group.rearClimate_button,mView.display_group.frontClimate_group
         .frontPanel_group.panelVent_button,mView.display_group.frontClimate_group.frontPanel_group.panelFloorVent_button,mView.display_group.frontClimate_group.frontPanel_group.floorVent_button,mView.display_group.frontClimate_group.frontPanel_group.defrostFloor_button,mView.display_group.frontClimate_group.controlLinkHsVsHst_button,mView.display_group.frontClimate_group.fanSpeedNoSync_group.off_button,mView.display_group.frontClimate_group.fanSpeedNoSync_group.loFan_button,mView.display_group.frontClimate_group.fanSpeedNoSync_group.hiFan_button,mView.display_group.frontClimate_group.lowerBarFanSpeed_group.off_button,mView.display_group.frontClimate_group.lowerBarFanSpeed_group.loFan_button,mView.display_group.frontClimate_group.lowerBarFanSpeed_group.hiFan_button,mView.display_group.frontClimate_group.lowerBarFanSpeed_group.sync_button,mView.display_group.rearClimate_group.topBarAC_group.rearAC_button,mView.display_group.rearClimate_group.topBarAC_group.lockRear_button,mView.display_group.rearClimate_group
         .topBarAC_group.rearAuto_button,mView.display_group.rearClimate_group.topBarAC_group.frontClimate_button,mView.display_group.rearClimate_group.topBar_group.rearAuto_button,mView.display_group.rearClimate_group.topBar_group.lockRear_button,mView.display_group.rearClimate_group.topBar_group.frontClimate_button,mView.display_group.rearClimate_group.rearTempControl_scroller.downArrow_button,mView.display_group.rearClimate_group.rearTempControl_scroller.upArrow_button,mView.display_group.rearClimate_group.fanSpeed_group.sync_button,mView.display_group.rearClimate_group.fanSpeed_group.hiFan_button,mView.display_group.rearClimate_group.fanSpeed_group.loFan_button,mView.display_group.rearClimate_group.fanSpeed_group.rearOff_button,mView.display_group.rearClimate_group.leftTempControl_scroller.upArrow_button,mView.display_group.rearClimate_group.leftTempControl_scroller.downArrow_button,mView.display_group.rearClimate_group.rearVent_group.panelVent_button,mView.display_group.rearClimate_group.rearVent_group
         .panelFloorVent_button,mView.display_group.rearClimate_group.rearVent_group.floorVent_button,mView.display_group.frontClimateOff_group.on_button,mView.display_group.frontClimateOff_group.controlLinkHsVsHst_button,mView.display_group.frontClimateOff_group.rearDefrost_button,mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button,mView.display_group.rearClimateOff_group.topBar_group.lockRear_button,mView.display_group.rearClimateOff_group.topBar_group.frontClimate_button,mView.display_group.rearClimateOff_group.topBarAC_group.rearAC_button,mView.display_group.rearClimateOff_group.topBarAC_group.lockRear_button,mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button,mView.display_group.rearClimateOff_group.topBarAC_group.frontClimate_button]));
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.display_group.hideChildren();
         mView.display_group.frontClimate_group.frontPanel_group.setRadioButtons(true);
         mView.display_group.frontClimate_group.frontPanel_group.setRequireSelection(true);
         mView.display_group.rearClimate_group.rearVent_group.setRadioButtons(true);
         mView.display_group.rearClimate_group.rearVent_group.setRequireSelection(true);
         mView.display_group.frontClimate_group.leftTempControl_scroller.setDisableButtons(true);
         mView.display_group.frontClimate_group.rightTempControl_scroller.setDisableButtons(true);
         mView.display_group.rearClimate_group.rearTempControl_scroller.setDisableButtons(true);
         mView.display_group.rearClimate_group.leftTempControl_scroller.setDisableButtons(true);
         this.setLeftSliderTemps();
         this.setRightSliderTemps();
         var _recirc:String = Peripheral.vehConfig.vehicleLine;
         if(_recirc == "DS")
         {
            if(Peripheral.vehConfig.bodyStyle == "7" || Peripheral.vehConfig.bodyStyle == "8")
            {
               _recirc += "_Long";
            }
         }
         mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.icon.gotoAndStop(_recirc);
         mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.airQuality.visible = false;
         mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.icon.gotoAndStop(_recirc);
         mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.airQuality.visible = false;
         mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.icon.gotoAndStop(_recirc);
         mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.airQuality.visible = false;
         mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.icon.gotoAndStop(_recirc);
         mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.airQuality.visible = false;
         this.mOriginal = mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.y;
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group,true);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate5BarTop_group,true);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group,true);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate6BarTop_group,true);
         this.setupVentGroupListeners(mView.display_group.frontClimate_group.frontPanel_group,this.procFrontVentButtonGrpClick,true);
         attachListener(mView.display_group.frontClimate_group.controlLinkHsVsHst_button,MouseEvent.CLICK,this.procVehicleSettingsBtnClick);
         this.setupFanBarListeners(mView.display_group.frontClimate_group.lowerBarFanSpeed_group,Peripheral.hvac.ZONE_FRONT,true);
         this.setupFanBarListeners(mView.display_group.frontClimate_group.fanSpeedNoSync_group,Peripheral.hvac.ZONE_FRONT,true);
         attachListener(mView.display_group.frontClimateOff_group.rearDefrost_button,MouseEvent.MOUSE_DOWN,this.procRearDefrosterBtnClick);
         attachListener(mView.display_group.frontClimateOff_group.rearDefrost_button,MouseEvent.MOUSE_UP,this.procRearDefrosterBtnClick);
         attachListener(mView.display_group.frontClimateOff_group.on_button,MouseEvent.MOUSE_DOWN,this.procFrontOffClimateOnBtnClick);
         attachListener(mView.display_group.frontClimateOff_group.on_button,MouseEvent.MOUSE_UP,this.procFrontOffClimateOnBtnClick);
         attachListener(mView.display_group.frontClimateOff_group.controlLinkHsVsHst_button,MouseEvent.CLICK,this.procVehicleSettingsBtnClick);
         this.setupButtonBarListeners(mView.display_group.rearClimate_group.topBar_group,true);
         this.setupButtonBarListeners(mView.display_group.rearClimate_group.topBarAC_group,true);
         this.setupVentGroupListeners(mView.display_group.rearClimate_group.rearVent_group,this.procRearVentButtonGrpClick,true);
         this.setupFanBarListeners(mView.display_group.rearClimate_group.fanSpeed_group,Peripheral.hvac.ZONE_REAR,true);
         this.setupButtonBarListeners(mView.display_group.rearClimateOff_group.topBar_group,true);
         attachListener(mView.display_group.rearClimateOff_group.on_button,MouseEvent.MOUSE_DOWN,this.procRearOnBtnClick);
         attachListener(mView.display_group.rearClimateOff_group.on_button,MouseEvent.MOUSE_UP,this.procRearOnBtnClick);
         mView.display_group.frontClimate_group.leftTempControl_scroller.addEventListener(WidgetEvent.GRAB,this.procSliderThumbDown,false,0,true);
         mView.display_group.frontClimate_group.leftTempControl_scroller.addEventListener(WidgetEvent.RELEASE,this.procSliderThumbUp,false,0,true);
         mView.display_group.frontClimate_group.rightTempControl_scroller.addEventListener(WidgetEvent.GRAB,this.procSliderThumbDown,false,0,true);
         mView.display_group.frontClimate_group.rightTempControl_scroller.addEventListener(WidgetEvent.RELEASE,this.procSliderThumbUp,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_AC_STATE,this.procAcStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_MAX_AC_STATE,this.procMaxAcStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_RECIRC_STATE,this.procRecircStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_AIRQUALITY_STATE,this.procAQSStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_AUTO_STATE,this.procAutoStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_DEFROSTER_STATE,this.procDefrosterStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_F_CLIMATE_STATE,this.procClimateStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_R_CLIMATE_STATE,this.procClimateStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_VENT_MODE,this.procFrontVentModeChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP,this.procLeftTempChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP,this.procRightTempChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_SYNC_STATE,this.procFrontSyncStateChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_F_FAN_SPEED,this.procFrontFanSpeedChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_R_FAN_SPEED,this.procRearFanSpeedChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_LOCK_STATE,this.procRearLockStateChange,false,0,true);
         attachListener(Framework.structure,StructureEvent.GOTO,this.procGoto,false,0,true);
         attachListener(Peripheral.personalConfig,PersonalConfigEvent.TEMPERATURE_UNITS,this.procUnitChanges,false,0,true);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.display_group.rearClimateOff_group.off_label,T.STRB_REAR_CLIMATE_OFF);
         t(mView.display_group.rearClimateOff_group.on_button.value_label,T.STRB_REAR_ON);
         t(mView.display_group.rearClimateOff_group.topBar_group.frontClimate_button.value_label,T.STRB_FRONT_CLIMATE_LG);
         t(mView.display_group.rearClimateOff_group.topBar_group.lockRear_button.value_label,T.STRB_LOCK_REAR_LG);
         t(mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button.value_label,T.STRB_REAR_AUTO_LG);
         t(mView.display_group.rearClimateOff_group.topBarAC_group.rearAC_button.value_label,T.STRB_AC_MED);
         t(mView.display_group.rearClimateOff_group.topBarAC_group.frontClimate_button.value_label,T.STRB_FRONT_CLIMATE_SM);
         t(mView.display_group.rearClimateOff_group.topBarAC_group.lockRear_button.value_label,T.STRB_LOCK_REAR_SM);
         t(mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button.value_label,T.STRB_REAR_AUTO_SM);
         t(mView.display_group.frontClimateOff_group.off_label,T.STRB_CLIMATE_OFF);
         t(mView.display_group.frontClimateOff_group.rearDefrost_button.value_label,T.STRB_REAR_DEFROST);
         t(mView.display_group.frontClimateOff_group.on_button.value_label,T.STRB_ON_HVAC);
         t(mView.display_group.rearClimate_group.rear_label,T.STRB_REAR_CLIMATE_LABEL);
         t(mView.display_group.rearClimate_group.topBar_group.frontClimate_button.value_label,T.STRB_FRONT_CLIMATE_LG);
         t(mView.display_group.rearClimate_group.topBar_group.lockRear_button.value_label,T.STRB_LOCK_REAR_LG);
         t(mView.display_group.rearClimate_group.topBar_group.rearAuto_button.value_label,T.STRB_REAR_AUTO_LG);
         t(mView.display_group.rearClimate_group.fanSpeed_group.sync_button.value_label,T.STRB_SYNC);
         t(mView.display_group.rearClimate_group.fanSpeed_group.rearOff_button.value_label,T.STRB_REAR_OFF);
         t(mView.display_group.rearClimate_group.topBarAC_group.rearAC_button.value_label,T.STRB_AC_SM);
         t(mView.display_group.rearClimate_group.topBarAC_group.frontClimate_button.value_label,T.STRB_FRONT_CLIMATE_SM);
         t(mView.display_group.rearClimate_group.topBarAC_group.lockRear_button.value_label,T.STRB_LOCK_REAR_SM);
         t(mView.display_group.rearClimate_group.topBarAC_group.rearAuto_button.value_label,T.STRB_REAR_AUTO_SM);
         t(mView.display_group.frontClimate_group.lowerBarFanSpeed_group.off_button.value_label,T.STRB_OFF_FAN);
         t(mView.display_group.frontClimate_group.lowerBarFanSpeed_group.sync_button.value_label,T.STRB_SYNC);
         t(mView.display_group.frontClimate_group.fanSpeedNoSync_group.off_button.value_label,T.STRB_OFF_FAN);
         t(mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.value_label,"MAX A/C");
         t(mView.display_group.frontClimate_group.climate6BarTop_group.AC_button.value_label,T.STRB_AC_LG);
         t(mView.display_group.frontClimate_group.climate6BarTop_group.auto_button.value_label,T.STRB_AUTO_HVAC_TOPBAR);
         t(mView.display_group.frontClimate_group.climate6BarTop_group.frontDefrost_button.value_label,T.STRB_FRONT_DEFROST);
         t(mView.display_group.frontClimate_group.climate6BarTop_group.rearClimate_button.value_label,T.STRB_REAR_CLIMATE);
         t(mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.value_label,T.STRB_REAR_DEFROST);
         t(mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.value_label,"MAX A/C");
         t(mView.display_group.frontClimate_group.climate5BarTop_group.AC_button.value_label,T.STRB_AC_MED);
         t(mView.display_group.frontClimate_group.climate5BarTop_group.auto_button.value_label,T.STRB_AUTO_HVAC_TOPBAR);
         t(mView.display_group.frontClimate_group.climate5BarTop_group.frontDefrost_button.value_label,T.STRB_FRONT_DEFROST);
         t(mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.value_label,T.STRB_REAR_DEFROST);
         t(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.AC_button.value_label,T.STRB_AC_MED);
         t(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.value_label,"MAX A/C");
         t(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.frontDefrost_button.value_label,T.STRB_FRONT_DEFROST);
         t(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.value_label,T.STRB_REAR_DEFROST);
         t(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearClimate_button.value_label,T.STRB_REAR_CLIMATE);
         t(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.value_label,"MAX A/C");
         t(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.frontDefrost_button.value_label,T.STRB_FRONT_DEFROST);
         t(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.value_label,T.STRB_REAR_DEFROST);
         t(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.AC_button.value_label,T.STRB_AC_SM);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate4BarTopNoAuto_group,false);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate5BarTop_group,false);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate5BarTopNoAuto_group,false);
         this.setupButtonBarListeners(mView.display_group.frontClimate_group.climate6BarTop_group,false);
         this.setupVentGroupListeners(mView.display_group.frontClimate_group.frontPanel_group,this.procFrontVentButtonGrpClick,false);
         detachListener(mView.display_group.frontClimate_group.controlLinkHsVsHst_button,MouseEvent.CLICK,this.procVehicleSettingsBtnClick);
         this.setupFanBarListeners(mView.display_group.frontClimate_group.lowerBarFanSpeed_group,Peripheral.hvac.ZONE_FRONT,false);
         this.setupFanBarListeners(mView.display_group.frontClimate_group.fanSpeedNoSync_group,Peripheral.hvac.ZONE_FRONT,false);
         this.setupSliderListeners(mView.display_group.frontClimate_group.leftTempControl_scroller,Peripheral.hvac.ZONE_FRONT_LEFT,false);
         this.setupSliderListeners(mView.display_group.frontClimate_group.rightTempControl_scroller,Peripheral.hvac.ZONE_FRONT_RIGHT,false);
         detachListener(mView.display_group.frontClimateOff_group.rearDefrost_button,MouseEvent.MOUSE_DOWN,this.procRearDefrosterBtnClick);
         detachListener(mView.display_group.frontClimateOff_group.rearDefrost_button,MouseEvent.MOUSE_UP,this.procRearDefrosterBtnClick);
         detachListener(mView.display_group.frontClimateOff_group.on_button,MouseEvent.MOUSE_DOWN,this.procFrontClimateOnBtnClick);
         detachListener(mView.display_group.frontClimateOff_group.on_button,MouseEvent.MOUSE_UP,this.procFrontClimateOnBtnClick);
         detachListener(mView.display_group.frontClimateOff_group.controlLinkHsVsHst_button,MouseEvent.CLICK,this.procVehicleSettingsBtnClick);
         this.setupButtonBarListeners(mView.display_group.rearClimate_group.topBar_group,false);
         this.setupButtonBarListeners(mView.display_group.rearClimate_group.topBar_group,false);
         this.setupButtonBarListeners(mView.display_group.rearClimate_group.topBarAC_group,false);
         this.setupVentGroupListeners(mView.display_group.rearClimate_group.rearVent_group,this.procRearVentButtonGrpClick,false);
         this.setupFanBarListeners(mView.display_group.rearClimate_group.fanSpeed_group,Peripheral.hvac.ZONE_REAR,false);
         this.setupButtonBarListeners(mView.display_group.rearClimateOff_group.topBar_group,true);
         detachListener(mView.display_group.rearClimateOff_group.on_button,MouseEvent.MOUSE_DOWN,this.procRearOnBtnClick);
         detachListener(mView.display_group.rearClimateOff_group.on_button,MouseEvent.MOUSE_UP,this.procRearOnBtnClick);
         mView.display_group.frontClimate_group.leftTempControl_scroller.removeEventListener(WidgetEvent.GRAB,this.procSliderThumbDown);
         mView.display_group.frontClimate_group.leftTempControl_scroller.removeEventListener(WidgetEvent.RELEASE,this.procSliderThumbUp);
         mView.display_group.frontClimate_group.rightTempControl_scroller.removeEventListener(WidgetEvent.GRAB,this.procSliderThumbDown);
         mView.display_group.frontClimate_group.rightTempControl_scroller.removeEventListener(WidgetEvent.RELEASE,this.procSliderThumbUp);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_AC_STATE,this.procAcStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_MAX_AC_STATE,this.procMaxAcStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_RECIRC_STATE,this.procRecircStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_AIRQUALITY_STATE,this.procAQSStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_AUTO_STATE,this.procAutoStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_DEFROSTER_STATE,this.procDefrosterStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_F_CLIMATE_STATE,this.procClimateStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_R_CLIMATE_STATE,this.procClimateStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_VENT_MODE,this.procFrontVentModeChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP,this.procLeftTempChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP,this.procRightTempChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_SYNC_STATE,this.procFrontSyncStateChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_F_FAN_SPEED,this.procFrontFanSpeedChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_R_FAN_SPEED,this.procRearFanSpeedChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_LOCK_STATE,this.procRearLockStateChange);
         detachListener(Framework.structure,StructureEvent.GOTO,this.procGoto);
         detachListener(Peripheral.personalConfig,PersonalConfigEvent.TEMPERATURE_UNITS,this.procUnitChanges);
         if(this.mTempAdjusting != "")
         {
            Peripheral.hvac.setZoneTempIncrement(this.mTempAdjusting,"down",false);
            Peripheral.hvac.setZoneTempIncrement(this.mTempAdjusting,"up",false);
         }
      }
      
      private function setupButtonBarListeners(theBar:MovieClip, add:Boolean) : void
      {
         if(!theBar)
         {
            return;
         }
         if(add == true)
         {
            if(theBar.AC_button)
            {
               attachListener(theBar.AC_button,MouseEvent.MOUSE_DOWN,this.procFrontAcBtnClick);
               attachListener(theBar.AC_button,MouseEvent.MOUSE_UP,this.procFrontAcBtnClick);
            }
            if(theBar.maxAC_button)
            {
               attachListener(theBar.maxAC_button,MouseEvent.MOUSE_DOWN,this.procFrontMaxAcBtnClick);
               attachListener(theBar.maxAC_button,MouseEvent.MOUSE_UP,this.procFrontMaxAcBtnClick);
            }
            if(theBar.recirculate_button)
            {
               attachListener(theBar.recirculate_button,MouseEvent.MOUSE_DOWN,this.procFrontRecirculateBtnClick);
               attachListener(theBar.recirculate_button,MouseEvent.MOUSE_UP,this.procFrontRecirculateBtnClick);
            }
            if(theBar.auto_button)
            {
               attachListener(theBar.auto_button,MouseEvent.MOUSE_DOWN,this.procFrontAutoBtnClick);
               attachListener(theBar.auto_button,MouseEvent.MOUSE_UP,this.procFrontAutoBtnClick);
            }
            if(theBar.frontDefrost_button)
            {
               attachListener(theBar.frontDefrost_button,MouseEvent.MOUSE_DOWN,this.procFrontDefrosterBtnClick);
               attachListener(theBar.frontDefrost_button,MouseEvent.MOUSE_UP,this.procFrontDefrosterBtnClick);
            }
            if(theBar.rearDefrost_button)
            {
               attachListener(theBar.rearDefrost_button,MouseEvent.MOUSE_DOWN,this.procRearDefrosterBtnClick);
               attachListener(theBar.rearDefrost_button,MouseEvent.MOUSE_UP,this.procRearDefrosterBtnClick);
            }
            if(theBar.rearClimate_button)
            {
               attachListener(theBar.rearClimate_button,MouseEvent.CLICK,this.procRearClimateBtnClick);
            }
            if(theBar.frontClimate_button)
            {
               attachListener(theBar.frontClimate_button,MouseEvent.CLICK,this.procFrontClimateOnBtnClick);
            }
            if(theBar.lockRear_button)
            {
               attachListener(theBar.lockRear_button,MouseEvent.MOUSE_DOWN,this.procRearLockBtnClick);
               attachListener(theBar.lockRear_button,MouseEvent.MOUSE_UP,this.procRearLockBtnClick);
            }
            if(theBar.rearAuto_button)
            {
               attachListener(theBar.rearAuto_button,MouseEvent.MOUSE_DOWN,this.procRearAutoBtnClick);
               attachListener(theBar.rearAuto_button,MouseEvent.MOUSE_UP,this.procRearAutoBtnClick);
            }
            if(theBar.rearAC_button)
            {
               attachListener(theBar.rearAC_button,MouseEvent.MOUSE_DOWN,this.procRearAcBtnClick);
               attachListener(theBar.rearAC_button,MouseEvent.MOUSE_UP,this.procRearAcBtnClick);
            }
         }
         else
         {
            if(theBar.AC_button)
            {
               detachListener(theBar.AC_button,MouseEvent.MOUSE_DOWN,this.procFrontAcBtnClick);
               detachListener(theBar.AC_button,MouseEvent.MOUSE_UP,this.procFrontAcBtnClick);
            }
            if(theBar.maxAC_button)
            {
               detachListener(theBar.maxAC_button,MouseEvent.MOUSE_DOWN,this.procFrontMaxAcBtnClick);
               detachListener(theBar.maxAC_button,MouseEvent.MOUSE_UP,this.procFrontMaxAcBtnClick);
            }
            if(theBar.recirculate_button)
            {
               detachListener(theBar.recirculate_button,MouseEvent.MOUSE_DOWN,this.procFrontRecirculateBtnClick);
               detachListener(theBar.recirculate_button,MouseEvent.MOUSE_UP,this.procFrontRecirculateBtnClick);
            }
            if(theBar.auto_button)
            {
               detachListener(theBar.auto_button,MouseEvent.MOUSE_DOWN,this.procFrontAutoBtnClick);
               detachListener(theBar.auto_button,MouseEvent.MOUSE_UP,this.procFrontAutoBtnClick);
            }
            if(theBar.frontDefrost_button)
            {
               detachListener(theBar.frontDefrost_button,MouseEvent.MOUSE_DOWN,this.procFrontDefrosterBtnClick);
               detachListener(theBar.frontDefrost_button,MouseEvent.MOUSE_UP,this.procFrontDefrosterBtnClick);
            }
            if(theBar.rearDefrost_button)
            {
               detachListener(theBar.rearDefrost_button,MouseEvent.MOUSE_DOWN,this.procRearDefrosterBtnClick);
               detachListener(theBar.rearDefrost_button,MouseEvent.MOUSE_UP,this.procRearDefrosterBtnClick);
            }
            if(theBar.rearClimate_button)
            {
               detachListener(theBar.rearClimate_button,MouseEvent.CLICK,this.procRearClimateBtnClick);
            }
            if(theBar.frontClimate_button)
            {
               detachListener(theBar.frontClimate_button,MouseEvent.CLICK,this.procFrontClimateOnBtnClick);
            }
            if(theBar.lockRear_button)
            {
               detachListener(theBar.lockRear_button,MouseEvent.MOUSE_DOWN,this.procRearLockBtnClick);
               detachListener(theBar.lockRear_button,MouseEvent.MOUSE_UP,this.procRearLockBtnClick);
            }
            if(theBar.rearAuto_button)
            {
               detachListener(theBar.rearAuto_button,MouseEvent.MOUSE_DOWN,this.procRearAutoBtnClick);
               detachListener(theBar.rearAuto_button,MouseEvent.MOUSE_UP,this.procRearAutoBtnClick);
            }
            if(theBar.rearAC_button)
            {
               detachListener(theBar.rearAC_button,MouseEvent.MOUSE_DOWN,this.procRearAcBtnClick);
               detachListener(theBar.rearAC_button,MouseEvent.MOUSE_UP,this.procRearAcBtnClick);
            }
         }
      }
      
      private function setupVentGroupListeners(theBar:MovieClip, callback:Function, add:Boolean) : void
      {
         if(!theBar)
         {
            return;
         }
         if(add == true)
         {
            if(theBar.floorVent_button)
            {
               attachListener(theBar.floorVent_button,MouseEvent.MOUSE_DOWN,callback);
               attachListener(theBar.floorVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.panelVent_button)
            {
               attachListener(theBar.panelVent_button,MouseEvent.MOUSE_DOWN,callback);
               attachListener(theBar.panelVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.panelFloorVent_button)
            {
               attachListener(theBar.panelFloorVent_button,MouseEvent.MOUSE_DOWN,callback);
               attachListener(theBar.panelFloorVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.defrostFloor_button)
            {
               attachListener(theBar.defrostFloor_button,MouseEvent.MOUSE_DOWN,callback);
               attachListener(theBar.defrostFloor_button,MouseEvent.MOUSE_UP,callback);
            }
         }
         else
         {
            if(theBar.floorVent_button)
            {
               detachListener(theBar.floorVent_button,MouseEvent.MOUSE_DOWN,callback);
               detachListener(theBar.floorVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.panelVent_button)
            {
               detachListener(theBar.panelVent_button,MouseEvent.MOUSE_DOWN,callback);
               detachListener(theBar.panelVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.panelFloorVent_button)
            {
               detachListener(theBar.panelFloorVent_button,MouseEvent.MOUSE_DOWN,callback);
               detachListener(theBar.panelFloorVent_button,MouseEvent.MOUSE_UP,callback);
            }
            if(theBar.defrostFloor_button)
            {
               detachListener(theBar.defrostFloor_button,MouseEvent.MOUSE_DOWN,callback);
               detachListener(theBar.defrostFloor_button,MouseEvent.MOUSE_UP,callback);
            }
         }
      }
      
      private function setupFanBarListeners(theFanBar:MovieClip, zone:String, add:Boolean) : void
      {
         switch(zone)
         {
            case Peripheral.hvac.ZONE_FRONT:
               if(add == true)
               {
                  if(theFanBar.loFan_button)
                  {
                     attachListener(theFanBar.loFan_button,MouseEvent.MOUSE_DOWN,this.procFrontFanDownBtnClick);
                     attachListener(theFanBar.loFan_button,MouseEvent.MOUSE_UP,this.procFrontFanDownBtnClick);
                  }
                  if(theFanBar.hiFan_button)
                  {
                     attachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_DOWN,this.procFrontFanUpBtnClick);
                     attachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_UP,this.procFrontFanUpBtnClick);
                  }
                  if(theFanBar.fanSpeed_group)
                  {
                     attachListener(theFanBar.fanSpeed_group,MouseEvent.CLICK,this.procFrontFanBarClick);
                     attachListener(theFanBar.fanSpeed_group,MouseEvent.MOUSE_MOVE,this.procFrontFanBarClick);
                  }
                  if(theFanBar.sync_button)
                  {
                     attachListener(theFanBar.sync_button,MouseEvent.MOUSE_DOWN,this.procFrontSyncBtnClick);
                     attachListener(theFanBar.sync_button,MouseEvent.MOUSE_UP,this.procFrontSyncBtnClick);
                  }
                  if(theFanBar.off_button)
                  {
                     attachListener(theFanBar.off_button,MouseEvent.MOUSE_DOWN,this.procFrontOffBtnClick);
                     attachListener(theFanBar.off_button,MouseEvent.MOUSE_UP,this.procFrontOffBtnClick);
                  }
               }
               else
               {
                  if(theFanBar.loFan_button)
                  {
                     detachListener(theFanBar.loFan_button,MouseEvent.MOUSE_DOWN,this.procFrontFanDownBtnClick);
                     detachListener(theFanBar.loFan_button,MouseEvent.MOUSE_UP,this.procFrontFanDownBtnClick);
                  }
                  if(theFanBar.hiFan_button)
                  {
                     detachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_DOWN,this.procFrontFanUpBtnClick);
                     detachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_UP,this.procFrontFanUpBtnClick);
                  }
                  if(theFanBar.fanSpeed_group)
                  {
                     detachListener(theFanBar.fanSpeed_group,MouseEvent.CLICK,this.procFrontFanBarClick);
                     detachListener(theFanBar.fanSpeed_group,MouseEvent.MOUSE_MOVE,this.procFrontFanBarClick);
                  }
                  if(theFanBar.sync_button)
                  {
                     detachListener(theFanBar.sync_button,MouseEvent.MOUSE_DOWN,this.procFrontSyncBtnClick);
                     detachListener(theFanBar.sync_button,MouseEvent.MOUSE_UP,this.procFrontSyncBtnClick);
                  }
                  if(theFanBar.off_button)
                  {
                     detachListener(theFanBar.off_button,MouseEvent.MOUSE_DOWN,this.procFrontOffBtnClick);
                     detachListener(theFanBar.off_button,MouseEvent.MOUSE_UP,this.procFrontOffBtnClick);
                  }
               }
               break;
            case Peripheral.hvac.ZONE_REAR:
               if(add == true)
               {
                  if(theFanBar.loFan_button)
                  {
                     attachListener(theFanBar.loFan_button,MouseEvent.MOUSE_DOWN,this.procRearFanDownBtnClick);
                     attachListener(theFanBar.loFan_button,MouseEvent.MOUSE_UP,this.procRearFanDownBtnClick);
                  }
                  if(theFanBar.hiFan_button)
                  {
                     attachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_DOWN,this.procRearFanUpBtnClick);
                     attachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_UP,this.procRearFanUpBtnClick);
                  }
                  if(theFanBar.fanSpeed_group)
                  {
                     attachListener(theFanBar.fanSpeed_group,MouseEvent.CLICK,this.procRearFanBarClick);
                     attachListener(theFanBar.fanSpeed_group,MouseEvent.MOUSE_MOVE,this.procRearFanBarClick);
                  }
                  if(theFanBar.sync_button)
                  {
                     attachListener(theFanBar.sync_button,MouseEvent.MOUSE_DOWN,this.procRearSyncBtnClick);
                     attachListener(theFanBar.sync_button,MouseEvent.MOUSE_UP,this.procRearSyncBtnClick);
                  }
                  if(theFanBar.rearOff_button)
                  {
                     attachListener(theFanBar.rearOff_button,MouseEvent.MOUSE_DOWN,this.procRearOffBtnClick);
                     attachListener(theFanBar.rearOff_button,MouseEvent.MOUSE_UP,this.procRearOffBtnClick);
                  }
               }
               else
               {
                  if(theFanBar.loFan_button)
                  {
                     detachListener(theFanBar.loFan_button,MouseEvent.MOUSE_DOWN,this.procRearFanDownBtnClick);
                     detachListener(theFanBar.loFan_button,MouseEvent.MOUSE_UP,this.procRearFanDownBtnClick);
                  }
                  if(theFanBar.hiFan_button)
                  {
                     detachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_DOWN,this.procRearFanUpBtnClick);
                     detachListener(theFanBar.hiFan_button,MouseEvent.MOUSE_UP,this.procRearFanUpBtnClick);
                  }
                  if(theFanBar.fanSpeed_group)
                  {
                     detachListener(theFanBar.fanSpeed_group,MouseEvent.CLICK,this.procRearFanBarClick);
                     detachListener(theFanBar.fanSpeed_group,MouseEvent.MOUSE_MOVE,this.procRearFanBarClick);
                  }
                  if(theFanBar.sync_button)
                  {
                     detachListener(theFanBar.sync_button,MouseEvent.MOUSE_DOWN,this.procFrontSyncBtnClick);
                     detachListener(theFanBar.sync_button,MouseEvent.MOUSE_UP,this.procFrontSyncBtnClick);
                  }
                  if(theFanBar.rearOff_button)
                  {
                     detachListener(theFanBar.rearOff_button,MouseEvent.MOUSE_DOWN,this.procRearOffBtnClick);
                     detachListener(theFanBar.rearOff_button,MouseEvent.MOUSE_UP,this.procRearOffBtnClick);
                  }
               }
         }
      }
      
      private function setupSliderListeners(theSlider:MovieClip, zone:String, add:Boolean) : void
      {
         if(theSlider == null || !theSlider.thumb)
         {
            return;
         }
         if(add == true)
         {
            if(theSlider.getDisableButtons() == true)
            {
               attachListener(theSlider.upArrow_button,MouseEvent.MOUSE_DOWN,this.procTempSliderButton);
               attachListener(theSlider.upArrow_button,MouseEvent.MOUSE_UP,this.procTempSliderButton);
               attachListener(theSlider.downArrow_button,MouseEvent.MOUSE_DOWN,this.procTempSliderButton);
               attachListener(theSlider.downArrow_button,MouseEvent.MOUSE_UP,this.procTempSliderButton);
            }
         }
         else if(theSlider.getDisableButtons() == true)
         {
            detachListener(theSlider.upArrow_button,MouseEvent.MOUSE_DOWN,this.procTempSliderButton);
            detachListener(theSlider.upArrow_button,MouseEvent.MOUSE_UP,this.procTempSliderButton);
            detachListener(theSlider.downArrow_button,MouseEvent.MOUSE_DOWN,this.procTempSliderButton);
            detachListener(theSlider.downArrow_button,MouseEvent.MOUSE_UP,this.procTempSliderButton);
         }
         switch(zone)
         {
            case Peripheral.hvac.ZONE_FRONT_LEFT:
               if(add == true)
               {
                  attachListener(theSlider,WidgetEvent.VERTICAL_POSITION,this.procFrontLeftTempSlider);
               }
               else
               {
                  detachListener(theSlider,WidgetEvent.VERTICAL_POSITION,this.procFrontLeftTempSlider);
               }
               break;
            case Peripheral.hvac.ZONE_FRONT:
            case Peripheral.hvac.ZONE_FRONT_RIGHT:
               if(add == true)
               {
                  attachListener(theSlider,WidgetEvent.VERTICAL_POSITION,this.procFrontRightTempSlider);
               }
               else
               {
                  detachListener(theSlider,WidgetEvent.VERTICAL_POSITION,this.procFrontRightTempSlider);
               }
         }
      }
      
      private function setScreenState() : void
      {
         this.mVehicleFeatureSet = this.mVFM.vehicleFeatureSet;
         mView.display_group.frontClimate_group.visible = false;
         mView.display_group.frontClimateOff_group.visible = false;
         mView.display_group.rearClimate_group.visible = false;
         mView.display_group.rearClimateOff_group.visible = false;
         mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button.value_label.visible = false;
         mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button.setInteractive(false);
         mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button.setEnabled(false);
         mView.display_group.rearClimateOff_group.topBar_group.rearAuto_button.setBeepEnabled(false);
         mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button.value_label.visible = false;
         mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button.setInteractive(false);
         mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button.setEnabled(false);
         mView.display_group.rearClimateOff_group.topBarAC_group.rearAuto_button.setBeepEnabled(false);
         switch(this.mCurrentView)
         {
            case mView.display_group.frontClimate_group:
               mView.display_group.frontClimate_group.visible = true;
               break;
            case mView.display_group.frontClimateOff_group:
               mView.display_group.frontClimateOff_group.visible = true;
               break;
            case mView.display_group.rearClimate_group:
               mView.display_group.rearClimate_group.visible = true;
               break;
            case mView.display_group.rearClimateOff_group:
               mView.display_group.rearClimateOff_group.topBarAC_group.visible = false;
               mView.display_group.rearClimateOff_group.topBar_group.visible = true;
               mView.display_group.rearClimateOff_group.visible = true;
         }
         mView.setControlsButtonType(Peripheral.vehConfig.hasHeatedSeat,Peripheral.vehConfig.hasHeatedSteeringWheel,Peripheral.vehConfig.hasVentedSeat);
         if(this.mVFM.hasRear)
         {
            mView.display_group.frontClimate_group.climate5BarTop_group.visible = false;
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.visible = false;
            if(this.mVFM.hasAuto == true)
            {
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.visible = false;
               mView.display_group.frontClimate_group.climate6BarTop_group.visible = true;
               this.rearAutoTemporaryFix(true);
            }
            else
            {
               mView.display_group.frontClimate_group.climate6BarTop_group.visible = false;
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.visible = true;
               this.rearAutoTemporaryFix(false);
            }
            if(this.mVFM.hasRearAc == true)
            {
               mView.display_group.rearClimate_group.topBar_group.visible = false;
               mView.display_group.rearClimate_group.topBarAC_group.visible = true;
            }
            else
            {
               mView.display_group.rearClimate_group.topBarAC_group.visible = false;
               mView.display_group.rearClimate_group.topBar_group.visible = true;
            }
         }
         else
         {
            mView.display_group.frontClimate_group.climate6BarTop_group.visible = false;
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.visible = false;
            if(this.mVFM.hasAuto == true)
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.visible = false;
               mView.display_group.frontClimate_group.climate5BarTop_group.visible = true;
            }
            else
            {
               mView.display_group.frontClimate_group.climate5BarTop_group.visible = false;
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.visible = true;
            }
         }
         mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.visible = false;
         mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.visible = false;
         mView.display_group.rearClimate_group.rearTempControl_scroller.popupDisplay.visible = false;
         this.setAcBtnState(this.mCurrentView);
         this.setMaxAcBtnState();
         this.setFrontRecirculateBtnState();
         this.setAQSState();
         this.setAutoBtnState(this.mCurrentView,Peripheral.hvac.ZONE_FRONT);
         this.setRearDefrosterBtnState();
         this.setFrontDefrosterBtnState();
         this.setFrontVentBtnStates();
         this.setFrontSyncBtnState();
         this.setFrontOffBtnState();
         this.setFrontFanSpeedBar();
         this.setAutoBtnState(this.mCurrentView,Peripheral.hvac.ZONE_REAR);
         this.setRearVentBtnStates();
         this.setRearFanSpeedBar();
         this.setRearLockBtnState();
         this.setLeftSliderTemps();
         this.setRightSliderTemps();
         this.mCurrentView.show();
      }
      
      private function rearAutoTemporaryFix(hasRearAuto:Boolean) : void
      {
         mView.display_group.rearClimate_group.topBar_group.rearAuto_button.value_label.visible = hasRearAuto;
         mView.display_group.rearClimate_group.topBar_group.rearAuto_button.setInteractive(hasRearAuto);
         mView.display_group.rearClimate_group.topBar_group.rearAuto_button.setEnabled(hasRearAuto);
         mView.display_group.rearClimate_group.topBar_group.rearAuto_button.setBeepEnabled(hasRearAuto);
         mView.display_group.rearClimate_group.topBarAC_group.rearAuto_button.value_label.visible = hasRearAuto;
         mView.display_group.rearClimate_group.topBarAC_group.rearAuto_button.setInteractive(hasRearAuto);
         mView.display_group.rearClimate_group.topBarAC_group.rearAuto_button.setEnabled(hasRearAuto);
         mView.display_group.rearClimate_group.topBarAC_group.rearAuto_button.setBeepEnabled(hasRearAuto);
      }
      
      private function setAcBtnState(currentView:MovieClip) : void
      {
         var state:String = Peripheral.hvac.acState(Peripheral.hvac.ZONE_FRONT);
         if(Boolean(currentView.climate4BarTopNoAuto_group) && Boolean(currentView.climate4BarTopNoAuto_group.AC_button))
         {
            this.setBarAcBtnState(currentView.climate4BarTopNoAuto_group,state);
         }
         if(Boolean(currentView.climate5BarTopNoAuto_group) && Boolean(currentView.climate5BarTopNoAuto_group.AC_button))
         {
            this.setBarAcBtnState(currentView.climate5BarTopNoAuto_group,state);
         }
         if(Boolean(currentView.climate5BarTop_group) && Boolean(currentView.climate5BarTop_group.AC_button))
         {
            this.setBarAcBtnState(currentView.climate5BarTop_group,state);
         }
         if(Boolean(currentView.climate6BarTop_group) && Boolean(currentView.climate6BarTop_group.AC_button))
         {
            this.setBarAcBtnState(currentView.climate6BarTop_group,state);
         }
      }
      
      private function setBarAcBtnState(theBar:MovieClip, btnState:String) : void
      {
         if(btnState == Peripheral.hvac.AC_ON)
         {
            theBar.AC_button.setEnabled(true);
            theBar.AC_button.setSelected(true);
         }
         else if((Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || this.mVehicleBrand == MASERATI_VEH_BRAND) && btnState == Peripheral.hvac.AC_DISABLE)
         {
            theBar.AC_button.setEnabled(false);
         }
         else
         {
            theBar.AC_button.setEnabled(true);
            theBar.AC_button.setSelected(false);
         }
      }
      
      private function setMaxAcBtnState() : void
      {
         if(Peripheral.hvac.maximumAcState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.MAXAC_ON)
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.setSelected(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.setSelected(true);
         }
         else if((Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || this.mVehicleBrand == MASERATI_VEH_BRAND) && Peripheral.hvac.maximumAcState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.MAXAC_DISABLE)
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.setEnabled(false);
         }
         else
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.maxAC_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.maxAC_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTop_group.maxAC_button.setSelected(false);
            mView.display_group.frontClimate_group.climate6BarTop_group.maxAC_button.setSelected(false);
         }
      }
      
      private function setFrontRecirculateBtnState() : void
      {
         if(Peripheral.hvac.recirculationState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.RECIRC_ON)
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.setSelected(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.setSelected(true);
         }
         else if(Peripheral.hvac.recirculationState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.RECIRC_OFF || (Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || this.mVehicleBrand == MASERATI_VEH_BRAND) && Peripheral.hvac.recirculationState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.RECIRC_SNA)
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.setEnabled(true);
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.setSelected(false);
            mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.setSelected(false);
         }
         else
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.setEnabled(false);
            mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.setEnabled(false);
         }
      }
      
      private function setAQSState() : void
      {
         if(this.mVehicleBrand == MASERATI_VEH_BRAND)
         {
            if(Peripheral.hvac.airQualityState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.AIRQUALITY_ON)
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.airQuality.visible = true;
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.airQuality.visible = true;
               mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.airQuality.visible = true;
               mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.airQuality.visible = true;
            }
            else
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.recirculate_button.airQuality.visible = false;
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.recirculate_button.airQuality.visible = false;
               mView.display_group.frontClimate_group.climate5BarTop_group.recirculate_button.airQuality.visible = false;
               mView.display_group.frontClimate_group.climate6BarTop_group.recirculate_button.airQuality.visible = false;
            }
         }
      }
      
      private function setAutoBtnState(currentView:MovieClip, zone:String) : void
      {
         if(this.mVFM.hasAuto == false)
         {
            return;
         }
         var state:String = Peripheral.hvac.autoState(zone);
         switch(zone)
         {
            case Peripheral.hvac.ZONE_FRONT:
               if(Boolean(currentView.climate5BarTop_group) && Boolean(currentView.climate5BarTop_group.auto_button))
               {
                  this.setBarAutoBtnState(currentView.climate5BarTop_group.auto_button,state);
               }
               if(Boolean(currentView.climate6BarTop_group) && Boolean(currentView.climate6BarTop_group.auto_button))
               {
                  this.setBarAutoBtnState(currentView.climate6BarTop_group.auto_button,state);
               }
               break;
            case Peripheral.hvac.ZONE_REAR:
               if(Boolean(currentView.topBar_group) && Boolean(currentView.topBar_group.rearAuto_button))
               {
                  this.setBarAutoBtnState(currentView.topBar_group.rearAuto_button,state);
               }
               if(Boolean(currentView.topBarAC_group) && Boolean(currentView.topBarAC_group.rearAuto_button))
               {
                  this.setBarAutoBtnState(currentView.topBarAC_group.rearAuto_button,state);
               }
         }
      }
      
      private function setBarAutoBtnState(theBarBtn:MovieClip, btnState:String) : void
      {
         if(btnState == Peripheral.hvac.AUTO_ON)
         {
            theBarBtn.setEnabled(true);
            theBarBtn.setSelected(true);
         }
         else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && btnState == Peripheral.hvac.AUTO_DISABLE)
         {
            theBarBtn.setEnabled(false);
         }
         else
         {
            theBarBtn.setEnabled(true);
            theBarBtn.setSelected(false);
         }
      }
      
      private function setFrontDefrosterBtnState() : void
      {
         if(Peripheral.hvac.ventMode(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.VENT_DEFROSTER)
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.frontDefrost_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.frontDefrost_button.setSelected(true);
            mView.display_group.frontClimate_group.climate5BarTop_group.frontDefrost_button.setSelected(true);
            mView.display_group.frontClimate_group.climate6BarTop_group.frontDefrost_button.setSelected(true);
         }
         else
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.frontDefrost_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.frontDefrost_button.setSelected(false);
            mView.display_group.frontClimate_group.climate5BarTop_group.frontDefrost_button.setSelected(false);
            mView.display_group.frontClimate_group.climate6BarTop_group.frontDefrost_button.setSelected(false);
         }
      }
      
      private function setRearDefrosterBtnState() : void
      {
         if(Peripheral.vehConfig.hasRearDefrostButton)
         {
            if(Peripheral.hvac.rearDefrosterState() == Peripheral.hvac.REAR_DEFROST_ON)
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimateOff_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.setSelected(true);
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.setSelected(true);
               mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.setSelected(true);
               mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.setSelected(true);
               mView.display_group.frontClimateOff_group.rearDefrost_button.setSelected(true);
            }
            else if(Peripheral.hvac.rearDefrosterState() == Peripheral.hvac.REAR_DEFROST_OFF || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && (Peripheral.hvac.rearDefrosterState() == Peripheral.hvac.REAR_DEFROST_SNA || Peripheral.hvac.rearDefrosterState() == Peripheral.hvac.REAR_DEFROST_DISABLE))
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimateOff_group.rearDefrost_button.setEnabled(true);
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.setSelected(false);
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.setSelected(false);
               mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.setSelected(false);
               mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.setSelected(false);
               mView.display_group.frontClimateOff_group.rearDefrost_button.setSelected(false);
            }
            else
            {
               mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.setEnabled(false);
               mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.setEnabled(false);
               mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.setEnabled(false);
               mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.setEnabled(false);
               mView.display_group.frontClimateOff_group.rearDefrost_button.setEnabled(false);
            }
         }
         else
         {
            mView.display_group.frontClimate_group.climate4BarTopNoAuto_group.rearDefrost_button.visible = false;
            mView.display_group.frontClimate_group.climate5BarTopNoAuto_group.rearDefrost_button.visible = false;
            mView.display_group.frontClimate_group.climate5BarTop_group.rearDefrost_button.visible = false;
            mView.display_group.frontClimate_group.climate6BarTop_group.rearDefrost_button.visible = false;
            mView.display_group.frontClimateOff_group.rearDefrost_button.visible = false;
         }
      }
      
      private function setFrontVentBtnStates() : void
      {
         switch(Peripheral.hvac.ventMode(Peripheral.hvac.ZONE_FRONT))
         {
            case Peripheral.hvac.VENT_DASH:
               mView.display_group.frontClimate_group.frontPanel_group.setSelection("panelVent_button");
               break;
            case Peripheral.hvac.VENT_FLOOR:
               mView.display_group.frontClimate_group.frontPanel_group.setSelection("floorVent_button");
               break;
            case Peripheral.hvac.VENT_MIX:
               mView.display_group.frontClimate_group.frontPanel_group.setSelection("panelFloorVent_button");
               break;
            case Peripheral.hvac.VENT_DEFROSTER_MIX:
               mView.display_group.frontClimate_group.frontPanel_group.setSelection("defrostFloor_button");
               break;
            default:
               mView.display_group.frontClimate_group.frontPanel_group.setSelection("off");
         }
      }
      
      private function setFrontSyncBtnState() : void
      {
         if(Peripheral.hvac.isSyncEnabled)
         {
            mView.display_group.frontClimate_group.lowerBarFanSpeed_group.sync_button.setSelected(true);
            mView.display_group.rearClimate_group.fanSpeed_group.sync_button.setSelected(true);
         }
         else
         {
            mView.display_group.frontClimate_group.lowerBarFanSpeed_group.sync_button.setSelected(false);
            mView.display_group.rearClimate_group.fanSpeed_group.sync_button.setSelected(false);
         }
      }
      
      private function setFrontOffBtnState() : void
      {
      }
      
      private function setRightSliderTemps() : void
      {
         var temp:String = null;
         var tempCalcMP:Number = NaN;
         if(this.mVFM.hasDualFrontZones == false && this.mVFM.hasRightHandDrive == false)
         {
            mView.display_group.frontClimate_group.rightTempControl_scroller.hide();
         }
         else
         {
            mView.display_group.frontClimate_group.rightTempControl_scroller.show();
            mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.y = this.mOriginal;
            temp = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT);
            if(!Peripheral.vehConfig.hvacSystemAutomatic && temp != Peripheral.hvac.TEMP_UNKNOWN)
            {
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
               {
                  temp = String(int(temp) - 15);
               }
               else
               {
                  temp = String(int(int(temp) * int(this.sliderMax) / 100));
               }
            }
            if(temp == Peripheral.hvac.TEMP_LO)
            {
               mView.display_group.frontClimate_group.rightTempControl_scroller.setVValue(Number(this.sliderMin));
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
               }
               else
               {
                  mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = "";
               }
            }
            else if(temp == Peripheral.hvac.TEMP_HI)
            {
               mView.display_group.frontClimate_group.rightTempControl_scroller.setVValue(Number(this.sliderMax + 1));
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
               }
               else
               {
                  mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = "";
               }
            }
            else
            {
               if(temp != Peripheral.hvac.TEMP_UNKNOWN)
               {
                  mView.display_group.frontClimate_group.rightTempControl_scroller.setVValue(Number(temp));
               }
               else
               {
                  mView.display_group.frontClimate_group.rightTempControl_scroller.setVValue(Number(this.sliderMin));
               }
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     if(temp != Peripheral.hvac.TEMP_UNKNOWN)
                     {
                        if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
                        {
                           tempCalcMP = 60 + (Number(temp) - 16);
                           mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                           mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                        }
                        else
                        {
                           tempCalcMP = 16 + (Number(temp) - 16) * 0.5;
                           if(Number(temp) % 2 == 0)
                           {
                              mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                              mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                              Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,true);
                           }
                           else
                           {
                              mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                              mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                              Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,true);
                           }
                        }
                     }
                     else
                     {
                        mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
                     }
                  }
                  else
                  {
                     mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
                  }
               }
               else
               {
                  mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = "";
               }
            }
         }
      }
      
      private function setLeftSliderTemps() : void
      {
         var temp:String = null;
         var tempCalcMP:Number = NaN;
         if(this.mVFM.hasDualFrontZones == false && this.mVFM.hasRightHandDrive == true)
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.hide();
         }
         else
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.show();
            mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.y = this.mOriginal;
            temp = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT);
            if(!Peripheral.vehConfig.hvacSystemAutomatic && temp != Peripheral.hvac.TEMP_UNKNOWN)
            {
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
               {
                  temp = String(int(temp) - 15);
               }
               else
               {
                  temp = String(int(int(temp) * int(this.sliderMax) / 100));
               }
            }
            if(temp == Peripheral.hvac.TEMP_LO)
            {
               mView.display_group.frontClimate_group.leftTempControl_scroller.setVValue(Number(this.sliderMin));
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
               }
               else
               {
                  mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = "";
               }
            }
            else if(temp == Peripheral.hvac.TEMP_HI)
            {
               mView.display_group.frontClimate_group.leftTempControl_scroller.setVValue(Number(this.sliderMax + 1));
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
               }
               else
               {
                  mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = "";
               }
            }
            else
            {
               if(temp != Peripheral.hvac.TEMP_UNKNOWN)
               {
                  mView.display_group.frontClimate_group.leftTempControl_scroller.setVValue(Number(temp));
               }
               else
               {
                  mView.display_group.frontClimate_group.leftTempControl_scroller.setVValue(Number(this.sliderMin));
               }
               if(Peripheral.vehConfig.hvacSystemAutomatic)
               {
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     if(temp != Peripheral.hvac.TEMP_UNKNOWN)
                     {
                        if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
                        {
                           tempCalcMP = 60 + (Number(temp) - 16);
                           mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                           mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                        }
                        else
                        {
                           tempCalcMP = 16 + (Number(temp) - 16) * 0.5;
                           if(Number(temp) % 2 == 0)
                           {
                              mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                              mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                              Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,true);
                           }
                           else
                           {
                              mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                              mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                              Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,true);
                           }
                        }
                     }
                     else
                     {
                        mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
                     }
                  }
                  else
                  {
                     mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
                  }
               }
               else
               {
                  mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = "";
               }
            }
         }
      }
      
      private function setFrontFanSpeedBar() : void
      {
         var mClip:MovieClip = null;
         if(this.mVFM.hasSync == true)
         {
            mView.display_group.frontClimate_group.fanSpeedNoSync_group.visible = false;
            mView.display_group.frontClimate_group.lowerBarFanSpeed_group.visible = true;
            mClip = mView.display_group.frontClimate_group.lowerBarFanSpeed_group.fanSpeed_group;
         }
         else
         {
            mView.display_group.frontClimate_group.lowerBarFanSpeed_group.visible = false;
            mView.display_group.frontClimate_group.fanSpeedNoSync_group.visible = true;
            mClip = mView.display_group.frontClimate_group.fanSpeedNoSync_group.fanSpeed_group;
         }
         switch(Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT))
         {
            case Peripheral.hvac.FAN_AUTO:
               mClip.gotoAndStop("auto");
               t(mClip.fanBar_label,T.STRB_HVAC_AUTO);
               return;
            case Peripheral.hvac.FAN_OFF:
               mClip.gotoAndStop("auto");
               t(mClip.fanBar_label,T.STRB_HVAC_OFF);
               return;
            case "1":
               mClip.gotoAndStop("speed1");
               return;
            case "2":
               mClip.gotoAndStop("speed2");
               return;
            case "3":
               mClip.gotoAndStop("speed3");
               return;
            case "4":
               mClip.gotoAndStop("speed4");
               return;
            case "5":
               mClip.gotoAndStop("speed5");
               return;
            case "6":
               mClip.gotoAndStop("speed6");
               return;
            case "7":
               mClip.gotoAndStop("speed7");
               return;
            default:
               return;
         }
      }
      
      private function setRearLockBtnState() : void
      {
         if(Peripheral.hvac.isLockEnabled(Peripheral.hvac.ZONE_REAR))
         {
            mView.display_group.rearClimate_group.topBar_group.lockRear_button.setSelected(true);
            mView.display_group.rearClimate_group.topBarAC_group.lockRear_button.setSelected(true);
            mView.display_group.rearClimateOff_group.topBar_group.lockRear_button.setSelected(true);
         }
         else
         {
            mView.display_group.rearClimate_group.topBar_group.lockRear_button.setSelected(false);
            mView.display_group.rearClimate_group.topBarAC_group.lockRear_button.setSelected(false);
            mView.display_group.rearClimateOff_group.topBar_group.lockRear_button.setSelected(false);
         }
      }
      
      private function setRearVentBtnStates() : void
      {
         switch(Peripheral.hvac.ventMode(Peripheral.hvac.ZONE_REAR))
         {
            case Peripheral.hvac.VENT_DASH:
               mView.display_group.rearClimate_group.rearVent_group.setSelection("panelVent_button");
               break;
            case Peripheral.hvac.VENT_FLOOR:
               mView.display_group.rearClimate_group.rearVent_group.setSelection("floorVent_button");
               break;
            case Peripheral.hvac.VENT_MIX:
               mView.display_group.rearClimate_group.rearVent_group.setSelection("panelFloorVent_button");
               break;
            default:
               mView.display_group.rearClimate_group.rearVent_group.setSelection("off");
         }
      }
      
      private function setRearFanSpeedBar() : void
      {
         var mClip:MovieClip = mView.display_group.rearClimate_group.fanSpeed_group.fanSpeed_group;
         switch(Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_REAR))
         {
            case Peripheral.hvac.FAN_AUTO:
               mClip.gotoAndStop("auto");
               t(mClip.fanBar_label,T.STRB_HVAC_AUTO);
               return;
            case Peripheral.hvac.FAN_OFF:
               mClip.gotoAndStop("auto");
               t(mClip.fanBar_label,T.STRB_HVAC_OFF);
               return;
            case "1":
               mClip.gotoAndStop("speed1");
               return;
            case "2":
               mClip.gotoAndStop("speed2");
               return;
            case "3":
               mClip.gotoAndStop("speed3");
               return;
            case "4":
               mClip.gotoAndStop("speed4");
               return;
            case "5":
               mClip.gotoAndStop("speed5");
               return;
            case "6":
               mClip.gotoAndStop("speed6");
               return;
            case "7":
               mClip.gotoAndStop("speed7");
               return;
            default:
               return;
         }
      }
      
      private function procFrontAcBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontAcBtnClick);
         Peripheral.hvac.setAcState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontMaxAcBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontMaxAcBtnClick);
         Peripheral.hvac.setMaxAcState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontRecirculateBtnClick(e:Event) : void
      {
         var recircState:String = Peripheral.hvac.recirculationState(Peripheral.hvac.ZONE_FRONT);
         if(recircState == Peripheral.hvac.RECIRC_DISABLE)
         {
            return;
         }
         this.setupRollOutListener(e,this.procFrontRecirculateBtnClick);
         Peripheral.hvac.setRecircuState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontAutoBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontAutoBtnClick);
         Peripheral.hvac.setAutoState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontDefrosterBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontDefrosterBtnClick);
         Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.MODE_FRONT_DEFROSTER,e.type == "mouseDown" ? true : false);
      }
      
      private function procRearDefrosterBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearDefrosterBtnClick);
         Peripheral.hvac.setDefrosterState(Peripheral.hvac.MODE_REAR_DEFROSTER,e.type == "mouseDown");
      }
      
      private function procRearClimateBtnClick(e:Event) : void
      {
         Framework.structure.goto("RearClimateScreen.swf");
      }
      
      private function procFrontVentButtonGrpClick(e:MouseEvent) : void
      {
         var button:String = e.currentTarget.name;
         this.setupRollOutListener(e,this.procFrontVentButtonGrpClick);
         switch(button)
         {
            case "panelVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.VENT_DASH,e.type == "mouseDown" ? true : false);
               break;
            case "floorVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.VENT_FLOOR,e.type == "mouseDown" ? true : false);
               break;
            case "defrostFloor_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.VENT_DEFROSTER_MIX,e.type == "mouseDown" ? true : false);
               break;
            case "panelFloorVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.VENT_MIX,e.type == "mouseDown" ? true : false);
         }
      }
      
      private function procLeftTempChange(e:Event) : void
      {
         this.setLeftSliderTemps();
      }
      
      private function procRightTempChange(e:Event) : void
      {
         this.setRightSliderTemps();
      }
      
      private function procVehicleSettingsBtnClick(e:Event) : void
      {
         Peripheral.controlsPopupManager.showControlsPopup();
      }
      
      private function procFrontFanUpBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontFanUpBtnClick);
         Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.FAN_UP,e.type == "mouseDown" ? true : false);
      }
      
      private function procFrontFanDownBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontFanDownBtnClick);
         if(Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT) == "1" || Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.FAN_OFF)
         {
            if(e.type != "mouseDown")
            {
               Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.FAN_DOWN,false);
            }
            return;
         }
         Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_FRONT,Peripheral.hvac.FAN_DOWN,e.type == "mouseDown" ? true : false);
      }
      
      private function procFrontFanBarClick(e:Event) : void
      {
         var clip:Object = e.currentTarget;
         var segmentSize:int = clip.width / 7;
         var segmentIndex:int = clip.mouseX / segmentSize + 1;
         Peripheral.hvac.setFanSpeed(Peripheral.hvac.ZONE_FRONT,String(segmentIndex));
      }
      
      private function procSliderThumbDown(e:Event) : void
      {
         detachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP,this.procLeftTempChange);
         detachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP,this.procRightTempChange);
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            e.currentTarget.thumb.value_label.visible = false;
            e.currentTarget.popupDisplay.y = e.currentTarget.thumb.y;
            e.currentTarget.popupDisplay.visible = true;
         }
         switch(e.currentTarget.name)
         {
            case "leftTempControl_scroller":
               if(e.currentTarget.parent.name == "frontClimate_group")
               {
                  this.mSliderFrontLeftPressed = true;
               }
               else
               {
                  this.mSliderRearLeftPressed = true;
               }
               break;
            case "rightTempControl_scroller":
               this.mSliderFrontRightPressed = true;
               break;
            case "rearTempControl_scroller":
               this.mSliderRearRightPressed = true;
         }
      }
      
      private function procSliderThumbUp(e:Event) : void
      {
         var temp:Number = Number(e.currentTarget.getValue());
         attachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP,this.procLeftTempChange,false,0,true);
         attachListener(Peripheral.hvac,HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP,this.procRightTempChange,false,0,true);
         e.currentTarget.popupDisplay.visible = false;
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            e.currentTarget.thumb.value_label.visible = true;
         }
         switch(e.currentTarget.name)
         {
            case "leftTempControl_scroller":
               if(e.currentTarget.parent.name == "frontClimate_group")
               {
                  this.setZoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT,temp);
                  this.mSliderFrontLeftPressed = false;
               }
               else
               {
                  this.setZoneTemp(Peripheral.hvac.ZONE_REAR_LEFT,temp);
                  this.mSliderRearLeftPressed = false;
               }
               break;
            case "rightTempControl_scroller":
               this.setZoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT,temp);
               this.mSliderFrontRightPressed = false;
               break;
            case "rearTempControl_scroller":
               this.setZoneTemp(Peripheral.hvac.ZONE_REAR_RIGHT,temp);
               this.mSliderRearRightPressed = false;
         }
      }
      
      private function setZoneTemp(zone:String, temp:Number) : void
      {
         var convertedTemp:String = String(temp);
         if(convertedTemp == this.sliderMin)
         {
            convertedTemp = Peripheral.hvac.TEMP_LO;
         }
         else if(convertedTemp == this.sliderMax)
         {
            convertedTemp = Peripheral.hvac.TEMP_HI;
         }
         else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            if(Peripheral.vehConfig.hvacSystemAutomatic)
            {
               if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
               {
                  convertedTemp = String(44 + temp);
               }
               else
               {
                  convertedTemp = String(16 + (temp - 16) * 0.5);
               }
            }
         }
         Peripheral.hvac.setZoneTemp(zone,convertedTemp);
      }
      
      private function procTempSliderButton(e:Event) : void
      {
         this.setupRollOutListener(e,this.procTempSliderButton);
         this.mTempAdjusting = "";
         switch(e.currentTarget.parent.name)
         {
            case "leftTempControl_scroller":
               if(e.currentTarget.parent.parent.name == "frontClimate_group")
               {
                  if(e.type == "mouseDown")
                  {
                     this.mTempAdjusting = Peripheral.hvac.ZONE_FRONT_LEFT;
                  }
                  Peripheral.hvac.setZoneTempIncrement(Peripheral.hvac.ZONE_FRONT_LEFT,e.currentTarget.name == "upArrow_button" ? "down" : "up",e.type == "mouseDown" ? true : false);
               }
               else
               {
                  if(e.type == "mouseDown")
                  {
                     this.mTempAdjusting = Peripheral.hvac.ZONE_REAR_LEFT;
                  }
                  Peripheral.hvac.setZoneTempIncrement(Peripheral.hvac.ZONE_REAR_LEFT,e.currentTarget.name == "upArrow_button" ? "down" : "up",e.type == "mouseDown" ? true : false);
               }
               break;
            case "rightTempControl_scroller":
               if(e.type == "mouseDown")
               {
                  this.mTempAdjusting = Peripheral.hvac.ZONE_FRONT_RIGHT;
               }
               Peripheral.hvac.setZoneTempIncrement(Peripheral.hvac.ZONE_FRONT_RIGHT,e.currentTarget.name == "upArrow_button" ? "down" : "up",e.type == "mouseDown" ? true : false);
               break;
            case "rearTempControl_scroller":
               if(e.type == "mouseDown")
               {
                  this.mTempAdjusting = Peripheral.hvac.ZONE_REAR_RIGHT;
               }
               Peripheral.hvac.setZoneTempIncrement(Peripheral.hvac.ZONE_REAR_RIGHT,e.currentTarget.name == "upArrow_button" ? "down" : "up",e.type == "mouseDown" ? true : false);
         }
      }
      
      private function setupRollOutListener(e:Event, callback:Function) : void
      {
         if(e.type == "mouseDown")
         {
            attachListener(e.currentTarget as MovieClip,MouseEvent.ROLL_OUT,callback);
         }
         else
         {
            detachListener(e.currentTarget as MovieClip,MouseEvent.ROLL_OUT,callback);
         }
      }
      
      private function procFrontLeftTempSlider(e:Event) : void
      {
         var tempCalcMP:Number = NaN;
         var temp:String = String(mView.display_group.frontClimate_group.leftTempControl_scroller.getVValue());
         var tempComparisonStr1:String = temp;
         var tempComparisonStr2:String = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT);
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            if(temp == this.sliderMin)
            {
               tempComparisonStr1 = "lo";
            }
            else if(temp == this.sliderMax)
            {
               tempComparisonStr1 = "hi";
            }
         }
         else if(tempComparisonStr2 != Peripheral.hvac.TEMP_UNKNOWN)
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
            {
               tempComparisonStr2 = String(int(tempComparisonStr2) - 15);
            }
            else
            {
               tempComparisonStr2 = String(int(int(tempComparisonStr2) * int(this.sliderMax) / 100));
            }
         }
         if(this.mSliderFrontLeftPressed == false && tempComparisonStr1 != tempComparisonStr2 && tempComparisonStr2 != Peripheral.hvac.TEMP_UNKNOWN)
         {
            this.setZoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT,Number(temp));
         }
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.y = this.mOriginal;
            if(temp == this.sliderMin)
            {
               Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
               Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_LO);
            }
            else if(temp == this.sliderMax)
            {
               Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
               Text.format(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_HI);
            }
            else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
               {
                  tempCalcMP = 60 + (Number(temp) - 16);
                  mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                  mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
               }
               else
               {
                  tempCalcMP = 16 + (Number(temp) - 16) * 0.5;
                  if(Number(temp) % 2 == 0)
                  {
                     mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                     mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                     Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,true);
                  }
                  else
                  {
                     mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                     mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                     Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label,true);
                  }
               }
            }
            else
            {
               mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
               mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = temp + String.fromCharCode(176);
            }
         }
         mView.display_group.frontClimate_group.leftTempControl_scroller.popupDisplay.y = mView.display_group.frontClimate_group.leftTempControl_scroller.thumb.y;
      }
      
      private function procFrontRightTempSlider(e:Event) : void
      {
         var tempCalcMP:Number = NaN;
         var temp:String = String(mView.display_group.frontClimate_group.rightTempControl_scroller.getVValue());
         var tempComparisonStr1:String = temp;
         var tempComparisonStr2:String = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT);
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            if(temp == this.sliderMin)
            {
               tempComparisonStr1 = "lo";
            }
            else if(temp == this.sliderMax)
            {
               tempComparisonStr1 = "hi";
            }
         }
         else if(tempComparisonStr2 != Peripheral.hvac.TEMP_UNKNOWN)
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
            {
               tempComparisonStr2 = String(int(tempComparisonStr2) - 15);
            }
            else
            {
               tempComparisonStr2 = String(int(int(tempComparisonStr2) * int(this.sliderMax) / 100));
            }
         }
         if(this.mSliderFrontRightPressed == false && tempComparisonStr1 != tempComparisonStr2 && tempComparisonStr2 != Peripheral.hvac.TEMP_UNKNOWN)
         {
            this.setZoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT,Number(temp));
         }
         if(Peripheral.vehConfig.hvacSystemAutomatic)
         {
            mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.y = this.mOriginal;
            if(temp == this.sliderMin)
            {
               Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
               Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_LO);
            }
            else if(temp == this.sliderMax)
            {
               Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
               Text.format(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_HI);
            }
            else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
               {
                  tempCalcMP = 60 + (Number(temp) - 16);
                  mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                  mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
               }
               else
               {
                  tempCalcMP = 16 + (Number(temp) - 16) * 0.5;
                  if(Number(temp) % 2 == 0)
                  {
                     mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                     mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + ".0" + String.fromCharCode(176);
                     Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,true);
                  }
                  else
                  {
                     mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                     mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = String(tempCalcMP) + String.fromCharCode(176);
                     Text.resizeToFitByFontSize(mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label,true);
                  }
               }
            }
            else
            {
               mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
               mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.value_label.text = temp + String.fromCharCode(176);
            }
         }
         mView.display_group.frontClimate_group.rightTempControl_scroller.popupDisplay.y = mView.display_group.frontClimate_group.rightTempControl_scroller.thumb.y;
      }
      
      private function procFrontSyncBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontSyncBtnClick);
         Peripheral.hvac.setSyncState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontOffBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontOffBtnClick);
         Peripheral.hvac.setClimateState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontOffClimateOnBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procFrontOffClimateOnBtnClick);
         Peripheral.hvac.setClimateState(Peripheral.hvac.ZONE_FRONT,e.type == "mouseDown");
      }
      
      private function procFrontClimateOnBtnClick(e:Event) : void
      {
         if(this.mFrontClimateState == true)
         {
            mView.display_group.hideChildren();
            this.mCurrentView = mView.display_group.frontClimate_group;
         }
         else
         {
            mView.display_group.hideChildren();
            this.mCurrentView = mView.display_group.frontClimateOff_group;
         }
         this.setScreenState();
      }
      
      private function procRearOffBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearOffBtnClick);
         Peripheral.hvac.setClimateState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearOnBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearOnBtnClick);
         Peripheral.hvac.setClimateState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearLockBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearLockBtnClick);
         Peripheral.hvac.setLockState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearSyncBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearSyncBtnClick);
         Peripheral.hvac.setSyncState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearAutoBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearAutoBtnClick);
         Peripheral.hvac.setAutoState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearAcBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearAcBtnClick);
         Peripheral.hvac.setAcState(Peripheral.hvac.ZONE_REAR,e.type == "mouseDown");
      }
      
      private function procRearVentButtonGrpClick(e:MouseEvent) : void
      {
         var button:String = String(e.currentTarget.name);
         this.setupRollOutListener(e,this.procRearVentButtonGrpClick);
         switch(button)
         {
            case "panelVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.VENT_DASH,e.type == "mouseDown" ? true : false);
               break;
            case "floorVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.VENT_FLOOR,e.type == "mouseDown" ? true : false);
               break;
            case "panelFloorVent_button":
               Peripheral.hvac.setVentMode(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.VENT_MIX,e.type == "mouseDown" ? true : false);
         }
      }
      
      private function procRearFanUpBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearFanUpBtnClick);
         Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.FAN_UP,e.type == "mouseDown" ? true : false);
      }
      
      private function procRearFanDownBtnClick(e:Event) : void
      {
         this.setupRollOutListener(e,this.procRearFanDownBtnClick);
         if(Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_REAR) == "1" || Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_REAR) == Peripheral.hvac.FAN_OFF)
         {
            if(e.type != "mouseDown")
            {
               Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.FAN_DOWN,false);
            }
            return;
         }
         Peripheral.hvac.setFanSpeedIncrement(Peripheral.hvac.ZONE_REAR,Peripheral.hvac.FAN_DOWN,e.type == "mouseDown" ? true : false);
      }
      
      private function procRearFanBarClick(e:Event) : void
      {
         var clip:Object = e.currentTarget;
         var segmentSize:int = clip.width / 7;
         var segmentIndex:int = clip.mouseX / segmentSize + 1;
         Peripheral.hvac.setFanSpeed(Peripheral.hvac.ZONE_REAR,String(segmentIndex));
      }
      
      private function procRearLeftTempSlider(e:Event) : void
      {
         var temp:String = String(mView.display_group.rearClimate_group.leftTempControl_scroller.getVValue());
         if(this.mSliderRearLeftPressed == false)
         {
            this.setZoneTemp(Peripheral.hvac.ZONE_REAR_LEFT,Number(temp));
         }
         if(temp == this.sliderMin)
         {
            Text.format(mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
            Text.format(mView.display_group.rearClimate_group.leftTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_LO);
         }
         else if(temp == this.sliderMax)
         {
            Text.format(mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
            Text.format(mView.display_group.rearClimate_group.leftTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_HI);
         }
         else
         {
            mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
            mView.display_group.rearClimate_group.leftTempControl_scroller.popupDisplay.value_label.text = temp + String.fromCharCode(176);
         }
         mView.display_group.rearClimate_group.leftTempControl_scroller.popupDisplay.y = mView.display_group.rearClimate_group.leftTempControl_scroller.thumb.y;
      }
      
      private function procRearRightTempSlider(e:Event) : void
      {
         var temp:String = String(mView.display_group.rearClimate_group.rearTempControl_scroller.getVValue());
         if(this.mSliderRearRightPressed == false)
         {
            this.setZoneTemp(Peripheral.hvac.ZONE_REAR_RIGHT,Number(temp));
         }
         if(temp == this.sliderMin)
         {
            Text.format(mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_LO);
            Text.format(mView.display_group.rearClimate_group.rearTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_LO);
         }
         else if(temp == this.sliderMax)
         {
            Text.format(mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.value_label,T.STRB_HVAC_SLIDER_HI);
            Text.format(mView.display_group.rearClimate_group.rearTempControl_scroller.popupDisplay.value_label,T.STRB_HVAC_SLIDER_HI);
         }
         else
         {
            mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.value_label.text = temp + String.fromCharCode(176);
            mView.display_group.rearClimate_group.rearTempControl_scroller.popupDisplay.value_label.text = temp + String.fromCharCode(176);
         }
         mView.display_group.rearClimate_group.rearTempControl_scroller.popupDisplay.y = mView.display_group.rearClimate_group.rearTempControl_scroller.thumb.y;
      }
      
      private function procVehicleFeatureSetChange(evt:HvacEvent) : void
      {
      }
      
      private function procClimateStateChange(evt:HvacEvent) : void
      {
         var oldRearState:Boolean = this.mRearClimateState;
         this.mFrontClimateState = Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT);
         this.mRearClimateState = Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_REAR);
         if(this.mCurrentView == mView.display_group.frontClimate_group)
         {
            if(this.mFrontClimateState == false)
            {
               mView.display_group.hideChildren();
               this.mCurrentView = mView.display_group.frontClimateOff_group;
            }
            else if(this.mRearClimateState == true)
            {
            }
         }
         else if(this.mCurrentView == mView.display_group.rearClimate_group)
         {
            if(this.mRearClimateState == false)
            {
               mView.display_group.hideChildren();
               this.mCurrentView = mView.display_group.rearClimateOff_group;
            }
            else if(this.mFrontClimateState == false)
            {
               mView.display_group.hideChildren();
               this.mCurrentView = mView.display_group.frontClimateOff_group;
            }
            else if(this.mFrontClimateState == true)
            {
            }
         }
         else if(this.mCurrentView == mView.display_group.frontClimateOff_group)
         {
            if(this.mFrontClimateState == true)
            {
               mView.display_group.hideChildren();
               this.mCurrentView = mView.display_group.frontClimate_group;
            }
         }
         else if(this.mCurrentView == mView.display_group.rearClimateOff_group)
         {
            if(oldRearState != this.mRearClimateState)
            {
               if(this.mRearClimateState == true)
               {
                  mView.display_group.hideChildren();
                  this.mCurrentView = mView.display_group.rearClimate_group;
               }
            }
            else if(this.mFrontClimateState == true)
            {
               mView.display_group.hideChildren();
               this.mCurrentView = mView.display_group.frontClimate_group;
            }
         }
         this.setScreenState();
      }
      
      private function procAcStateChange(evt:HvacEvent) : void
      {
         this.setAcBtnState(this.mCurrentView);
      }
      
      private function procMaxAcStateChange(evt:HvacEvent) : void
      {
         this.setMaxAcBtnState();
      }
      
      private function procRecircStateChange(evt:HvacEvent) : void
      {
         this.setFrontRecirculateBtnState();
      }
      
      private function procAQSStateChange(evt:HvacEvent) : void
      {
         this.setAQSState();
      }
      
      private function procAutoStateChange(evt:HvacEvent) : void
      {
         this.setAutoBtnState(this.mCurrentView,Peripheral.hvac.ZONE_FRONT);
         this.setAutoBtnState(this.mCurrentView,Peripheral.hvac.ZONE_REAR);
      }
      
      private function procDefrosterStateChange(evt:HvacEvent) : void
      {
         this.setRearDefrosterBtnState();
      }
      
      private function procFrontVentModeChange(evt:HvacEvent) : void
      {
         this.setFrontDefrosterBtnState();
         this.setFrontVentBtnStates();
         this.setRearVentBtnStates();
      }
      
      private function procFrontSyncStateChange(evt:HvacEvent) : void
      {
         this.setFrontSyncBtnState();
      }
      
      private function procFrontClimateStateChange(evt:HvacEvent) : void
      {
         this.setFrontOffBtnState();
      }
      
      private function procFrontFanSpeedChange(evt:HvacEvent) : void
      {
         this.setFrontFanSpeedBar();
      }
      
      private function procRearFanSpeedChange(evt:HvacEvent) : void
      {
         this.setRearFanSpeedBar();
      }
      
      private function procRearLockStateChange(evt:HvacEvent) : void
      {
         this.setRearLockBtnState();
      }
      
      private function procUnitChanges(evt:PersonalConfigEvent) : void
      {
         if(!Peripheral.vehConfig.hvacSystemAutomatic)
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
            {
               this.sliderMin = "0";
               this.sliderMax = "17";
            }
            else if(Peripheral.vehConfig.vehicleLine == "LD" && Number(Peripheral.vehConfig.modelYear) >= 18 && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent))
            {
               this.sliderMin = "0";
               this.sliderMax = "26";
            }
            else if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
            {
               this.sliderMin = "0";
               this.sliderMax = "25";
            }
            else
            {
               this.sliderMin = "0";
               this.sliderMax = "16";
            }
         }
         else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            this.sliderMin = "15";
            this.sliderMax = "41";
         }
         else if(Peripheral.personalConfig.temperatureUnits == "US" || Peripheral.personalConfig.temperatureUnits == "us")
         {
            this.sliderMin = "59";
            this.sliderMax = "85";
         }
         else
         {
            this.sliderMin = "13";
            this.sliderMax = "31";
         }
         if(this.mVFM.hasDualFrontZones == true || this.mVFM.hasRightHandDrive == false)
         {
            mView.display_group.frontClimate_group.leftTempControl_scroller.setVMinimum(Number(this.sliderMin));
            mView.display_group.frontClimate_group.leftTempControl_scroller.setVMaximum(Number(this.sliderMax) + 1);
         }
         if(this.mVFM.hasDualFrontZones == true || this.mVFM.hasRightHandDrive == true)
         {
            mView.display_group.frontClimate_group.rightTempControl_scroller.setVMinimum(Number(this.sliderMin));
            mView.display_group.frontClimate_group.rightTempControl_scroller.setVMaximum(Number(this.sliderMax) + 1);
         }
      }
      
      private function procGoto(evt:StructureEvent) : void
      {
         if(evt.branch == Framework.structure.currentBranch)
         {
            this.procFrontClimateOnBtnClick(null);
         }
      }
   }
}

