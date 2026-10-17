package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class HEVEvent extends Event
   {
      
      public static const HE_MODE_UPDATE:String = "hybridElectricModeUpdate";
      
      public static const BATT_PERCENT_UPDATE:String = "batteryPercentUpdate";
      
      public static const BATT_PWR_UPDATE:String = "batteryPwrUpdate";
      
      public static const ENG_PWR_UPDATE:String = "enginePwrUpdate";
      
      public static const HVAC_PWR_UPDATE:String = "HVACPwrUpdate";
      
      public static const ELECTRIC_RANGE_UPDATE:String = "electricRangeUpdate";
      
      public static const CHRG_SYS_STATUS_UPDATE:String = "chargeSystemStatusUpdate";
      
      public static const WHL_PWR_FLW_STATE_UPDATE:String = "wheelPowerFlowStateUpdate";
      
      public static const ENG_TO_BAT_PWR_FLW_STATE_UPDATE:String = "engToBatPowerFlowStateUpdate";
      
      public static const HVAC_PWR_FLW_STATE_UPDATE:String = "HVACPowerFlowStateUpdate";
      
      public static const BAT_ICON_STATE_UPDATE:String = "batteryIconStateUpdate";
      
      public static const ENG_ICON_STATE_UPDATE:String = "engineIconStateUpdate";
      
      public static const MTR_ICON_STATE_UPDATE:String = "motorIconStateUpdate";
      
      public static const CHRG_MIN_LV1_UPDATE:String = "chargeMinutesLv1Update";
      
      public static const CHRG_HR_LV1_UPDATE:String = "chargeHoursLv1Update";
      
      public static const CHRG_MIN_LV2_UPDATE:String = "chargeMinutesLv2Update";
      
      public static const CHRG_HR_LV2_UPDATE:String = "chargeHoursLv2Update";
      
      public static const PLUG_IN_STATUS_UPDATE:String = "plugInStatusUpdate";
      
      public static const WKEND_MIN_STRT_UPDATE:String = "weekendMinuteStartUpdate";
      
      public static const WKEND_MIN_END_UPDATE:String = "weekendMinuteEndUpdate";
      
      public static const WKEND_HR_STRT_UPDATE:String = "weekendHourStartUpdate";
      
      public static const WKEND_HR_END_UPDATE:String = "weekendHourEndUpdate";
      
      public static const WKDAY_MIN_STRT_UPDATE:String = "weekdayMinuteStartUpdate";
      
      public static const WKDAY_MIN_END_UPDATE:String = "weekdayMinuteEndUpdate";
      
      public static const WKDAY_HR_STRT_UPDATE:String = "weekdayHourStartUpdate";
      
      public static const WKDAY_HR_END_UPDATE:String = "weekdayHourEndUpdate";
      
      public static const CHRG_DT_TM_FORMAT_UPDATE:String = "ChargeDateTimeFormatUpdate";
      
      public static const CHRG_REQ_STATUS_UPDATE:String = "chargeRequestStatusUpdate";
      
      public static const ENABLE_CHRG_SCHED_UPDATE:String = "enableChargeScheduleUpdate";
      
      public static const CRNT_DAY_WKDAY_FLAG_UPDATE:String = "currentDayWeekdayFlagUpdate";
      
      public static const CHRG_FULL_WKDAY_UPDATE:String = "chargeFullWeekdayUpdate";
      
      public static const CHRG_FULL_WKEND_UPDATE:String = "chargeFullWeekendUpdate";
      
      public static const DISP_DRV_HISTORY_UPDATE:String = "displayDrivingHistoryUpdate";
      
      public static const ENBL_CHRG_NOW_POPUP_UPDATE:String = "enableChargeNowPopUpUpdate";
      
      public static const HYBRID_MI_WK1_D0_UDPATE:String = "hybridMIWk1D0Update";
      
      public static const HYBRID_MI_WK1_D1_UDPATE:String = "hybridMIWk1D1Update";
      
      public static const HYBRID_MI_WK1_D2_UDPATE:String = "hybridMIWk1D2Update";
      
      public static const HYBRID_MI_WK1_D3_UDPATE:String = "hybridMIWk1D3Update";
      
      public static const HYBRID_MI_WK1_D4_UDPATE:String = "hybridMIWk1D4Update";
      
      public static const HYBRID_MI_WK1_D5_UDPATE:String = "hybridMIWk1D5Update";
      
      public static const HYBRID_MI_WK1_D6_UDPATE:String = "hybridMIWk1D6Update";
      
      public static const HYBRID_MI_WK2_D0_UDPATE:String = "hybridMIWk2D0Update";
      
      public static const HYBRID_MI_WK2_D1_UDPATE:String = "hybridMIWk2D1Update";
      
      public static const HYBRID_MI_WK2_D2_UDPATE:String = "hybridMIWk2D2Update";
      
      public static const HYBRID_MI_WK2_D3_UDPATE:String = "hybridMIWk2D3Update";
      
      public static const HYBRID_MI_WK2_D4_UDPATE:String = "hybridMIWk2D4Update";
      
      public static const HYBRID_MI_WK2_D5_UDPATE:String = "hybridMIWk2D5Update";
      
      public static const HYBRID_MI_WK2_D6_UDPATE:String = "hybridMIWk2D6Update";
      
      public static const HYBRID_KM_WK1_D0_UDPATE:String = "hybridKMWk1D0Update";
      
      public static const HYBRID_KM_WK1_D1_UDPATE:String = "hybridKMWk1D1Update";
      
      public static const HYBRID_KM_WK1_D2_UDPATE:String = "hybridKMWk1D2Update";
      
      public static const HYBRID_KM_WK1_D3_UDPATE:String = "hybridKMWk1D3Update";
      
      public static const HYBRID_KM_WK1_D4_UDPATE:String = "hybridKMWk1D4Update";
      
      public static const HYBRID_KM_WK1_D5_UDPATE:String = "hybridKMWk1D5Update";
      
      public static const HYBRID_KM_WK1_D6_UDPATE:String = "hybridKMWk1D6Update";
      
      public static const HYBRID_KM_WK2_D0_UDPATE:String = "hybridKMWk2D0Update";
      
      public static const HYBRID_KM_WK2_D1_UDPATE:String = "hybridKMWk2D1Update";
      
      public static const HYBRID_KM_WK2_D2_UDPATE:String = "hybridKMWk2D2Update";
      
      public static const HYBRID_KM_WK2_D3_UDPATE:String = "hybridKMWk2D3Update";
      
      public static const HYBRID_KM_WK2_D4_UDPATE:String = "hybridKMWk2D4Update";
      
      public static const HYBRID_KM_WK2_D5_UDPATE:String = "hybridKMWk2D5Update";
      
      public static const HYBRID_KM_WK2_D6_UDPATE:String = "hybridKMWk2D6Update";
      
      public static const ELECTRIC_MI_WK1_D0_UDPATE:String = "electricMIWk1D0Update";
      
      public static const ELECTRIC_MI_WK1_D1_UDPATE:String = "electricMIWk1D1Update";
      
      public static const ELECTRIC_MI_WK1_D2_UDPATE:String = "electricMIWk1D2Update";
      
      public static const ELECTRIC_MI_WK1_D3_UDPATE:String = "electricMIWk1D3Update";
      
      public static const ELECTRIC_MI_WK1_D4_UDPATE:String = "electricMIWk1D4Update";
      
      public static const ELECTRIC_MI_WK1_D5_UDPATE:String = "electricMIWk1D5Update";
      
      public static const ELECTRIC_MI_WK1_D6_UDPATE:String = "electricMIWk1D6Update";
      
      public static const ELECTRIC_MI_WK2_D0_UDPATE:String = "electricMIWk2D0Update";
      
      public static const ELECTRIC_MI_WK2_D1_UDPATE:String = "electricMIWk2D1Update";
      
      public static const ELECTRIC_MI_WK2_D2_UDPATE:String = "electricMIWk2D2Update";
      
      public static const ELECTRIC_MI_WK2_D3_UDPATE:String = "electricMIWk2D3Update";
      
      public static const ELECTRIC_MI_WK2_D4_UDPATE:String = "electricMIWk2D4Update";
      
      public static const ELECTRIC_MI_WK2_D5_UDPATE:String = "electricMIWk2D5Update";
      
      public static const ELECTRIC_MI_WK2_D6_UDPATE:String = "electricMIWk2D6Update";
      
      public static const ELECTRIC_KM_WK1_D0_UDPATE:String = "electricKMWk1D0Update";
      
      public static const ELECTRIC_KM_WK1_D1_UDPATE:String = "electricKMWk1D1Update";
      
      public static const ELECTRIC_KM_WK1_D2_UDPATE:String = "electricKMWk1D2Update";
      
      public static const ELECTRIC_KM_WK1_D3_UDPATE:String = "electricKMWk1D3Update";
      
      public static const ELECTRIC_KM_WK1_D4_UDPATE:String = "electricKMWk1D4Update";
      
      public static const ELECTRIC_KM_WK1_D5_UDPATE:String = "electricKMWk1D5Update";
      
      public static const ELECTRIC_KM_WK1_D6_UDPATE:String = "electricKMWk1D6Update";
      
      public static const ELECTRIC_KM_WK2_D0_UDPATE:String = "electricKMWk2D0Update";
      
      public static const ELECTRIC_KM_WK2_D1_UDPATE:String = "electricKMWk2D1Update";
      
      public static const ELECTRIC_KM_WK2_D2_UDPATE:String = "electricKMWk2D2Update";
      
      public static const ELECTRIC_KM_WK2_D3_UDPATE:String = "electricKMWk2D3Update";
      
      public static const ELECTRIC_KM_WK2_D4_UDPATE:String = "electricKMWk2D4Update";
      
      public static const ELECTRIC_KM_WK2_D5_UDPATE:String = "electricKMWk2D5Update";
      
      public static const ELECTRIC_KM_WK2_D6_UDPATE:String = "electricKMWk2D6Update";
      
      public static const EXT_LOGGING_LEVEL_UPDATE:String = "extLoggingLevelUpdate";
      
      public var mData:* = null;
      
      public function HEVEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

