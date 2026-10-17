package peripheral
{
   public class VehicleFeatureManager
   {
      
      private static const sFR_ONLY:String = "front_only";
      
      private static const sFR_AWD:String = "front_awd";
      
      private static const sFR_PO:String = "front_po";
      
      private static const sFR_PO_E:String = "front_po_e";
      
      private static const sFR_HS:String = "front_hs";
      
      private static const sFR_HS_AWD:String = "front_hs_awd";
      
      private static const sFR_HS_AWD_SM:String = "front_hs_awd_sm";
      
      private static const sFR_HS_SM:String = "front_hs_sm";
      
      private static const sFR_HS_PO:String = "front_hs_po";
      
      private static const sFR_HS_PO_E:String = "front_hs_po_e";
      
      private static const sFR_HSW:String = "front_hsw";
      
      private static const sFR_HSW_AWD:String = "front_hsw_awd";
      
      private static const sFR_HSW_AWD_SM:String = "front_hsw_awd_sm";
      
      private static const sFR_HSW_SM:String = "front_hsw_sm";
      
      private static const sFR_HSW_SS:String = "front_hsw_ss";
      
      private static const sFR_HSW_SS_AWD:String = "front_hsw_ss_awd";
      
      private static const sFR_HSW_SS_AWD_SM:String = "front_hsw_ss_awd_sm";
      
      private static const sFR_HS_VS:String = "front_hs_vs";
      
      private static const sFR_HS_VS_SM:String = "front_hs_vs_sm";
      
      private static const sFR_HS_VS_PO:String = "front_hs_vs_po";
      
      private static const sFR_HS_VS_SM_PO:String = "front_hs_vs_sm_po";
      
      private static const sFR_HSW_VS:String = "front_hsw_vs";
      
      private static const sFR_HSW_VS_SS:String = "front_hsw_vs_ss";
      
      private static const sFR_HSW_VS_SS_AWD:String = "front_hsw_vs_ss_awd";
      
      private static const sFR_HSW_VS_SS_SM:String = "front_hsw_vs_ss_sm";
      
      private static const sFR_HSW_VS_SS_SM_AWD_PO_E:String = "front_hsw_vs_ss_sm_awd_po_e";
      
      private static const sFR_R:String = "front_rear";
      
      private static const sFR_R_AWD:String = "front_rear_awd";
      
      private static const sFR_R_PO:String = "front_rear_po";
      
      private static const sFR_R_PO_E:String = "front_rear_po_e";
      
      private static const sFR_R_HS:String = "front_rear_hs";
      
      private static const sFR_R_HS_AWD:String = "front_rear_hs_awd";
      
      private static const sFR_R_HS_AWD_SM:String = "front_rear_hs_awd_sm";
      
      private static const sFR_R_HS_SM:String = "front_rear_hs_sm";
      
      private static const sFR_R_HS_PO:String = "front_rear_hs_po";
      
      private static const sFR_R_HS_PO_E:String = "front_rear_hs_po_e";
      
      private static const sFR_R_HSW:String = "front_rear_hsw";
      
      private static const sFR_R_HSW_AWD:String = "front_rear_hsw_awd";
      
      private static const sFR_R_HSW_AWD_SM:String = "front_rear_hsw_awd_sm";
      
      private static const sFR_R_HSW_SM:String = "front_rear_hsw_sm";
      
      private static const sFR_R_HSW_SS:String = "front_rear_hsw_ss";
      
      private static const sFR_R_HSW_SS_AWD:String = "front_rear_hsw_ss_awd";
      
      private static const sFR_R_HSW_SS_AWD_SM:String = "front_rear_hsw_ss_awd_sm";
      
      private static const sFR_R_HS_VS:String = "front_hs_vs";
      
      private static const sFR_R_HS_VS_SM:String = "front_hs_vs_sm";
      
      private static const sFR_R_HS_VS_PO:String = "front_hs_vs_po";
      
      private static const sFR_R_HS_VS_SM_PO:String = "front_hs_vs_sm_po";
      
      private static const sFR_R_HSW_VS:String = "front_rear_hsw_vs";
      
      private static const sFR_R_HSW_VS_SS:String = "front_rear_hsw_vs_ss";
      
      private static const sFR_R_HSW_VS_SS_AWD:String = "front_rear_hsw_vs_ss_awd";
      
      private static const sFR_R_HSW_VS_SS_SM:String = "front_rear_hsw_vs_sm";
      
      private static const sFR_R_HSW_VS_SS_SM_AWD_PO_E:String = "front_rear_hsw_vs_ss_sm_awd_po_e";
      
      private static var mVehicleFeatureSet:String = sFR_ONLY;
      
      private static const MASERATI_VEH_BRAND:String = "11";
      
      public function VehicleFeatureManager()
      {
         super();
      }
      
      public function get VFS_F() : String
      {
         return sFR_ONLY;
      }
      
      public function get VFS_F_AWD() : String
      {
         return sFR_AWD;
      }
      
      public function get VFS_F_PO() : String
      {
         return sFR_PO;
      }
      
      public function get VFS_F_PO_E() : String
      {
         return sFR_PO_E;
      }
      
      public function get VFS_F_HS() : String
      {
         return sFR_HS;
      }
      
      public function get VFS_F_HS_AWD() : String
      {
         return sFR_HS_AWD;
      }
      
      public function get VFS_F_HS_AWD_SM() : String
      {
         return sFR_HS_AWD_SM;
      }
      
      public function get VFS_F_HS_SM() : String
      {
         return sFR_HS_SM;
      }
      
      public function get VFS_F_HS_PO() : String
      {
         return sFR_HS_PO;
      }
      
      public function get VFS_F_HS_PO_E() : String
      {
         return sFR_HS_PO_E;
      }
      
      public function get VFS_F_HSW() : String
      {
         return sFR_HSW;
      }
      
      public function get VFS_F_HSW_AWD() : String
      {
         return sFR_HSW_AWD;
      }
      
      public function get VFS_F_HSW_AWD_SM() : String
      {
         return sFR_HSW_AWD_SM;
      }
      
      public function get VFS_F_HSW_SM() : String
      {
         return sFR_HSW_SM;
      }
      
      public function get VFS_F_HSW_SS() : String
      {
         return sFR_HSW_SS;
      }
      
      public function get VFS_F_HSW_SS_AWD() : String
      {
         return sFR_HSW_SS_AWD;
      }
      
      public function get VFS_F_HSW_SS_AWD_SM() : String
      {
         return sFR_HSW_SS_AWD_SM;
      }
      
      public function get VFS_F_HS_VS() : String
      {
         return sFR_HS_VS;
      }
      
      public function get VFS_F_HS_VS_SM() : String
      {
         return sFR_HS_VS_SM;
      }
      
      public function get VFS_F_HS_VS_PO() : String
      {
         return sFR_HS_VS_PO;
      }
      
      public function get VFS_F_HS_VS_SM_PO() : String
      {
         return sFR_HS_VS_SM_PO;
      }
      
      public function get VFS_F_HSW_VS() : String
      {
         return sFR_HSW_VS;
      }
      
      public function get VFS_F_HSW_VS_SS() : String
      {
         return sFR_HSW_VS_SS;
      }
      
      public function get VFS_F_HSW_VS_SS_AWD() : String
      {
         return sFR_HSW_VS_SS_AWD;
      }
      
      public function get VFS_F_HSW_VS_SS_SM() : String
      {
         return sFR_HSW_VS_SS_SM;
      }
      
      public function get VFS_F_HSW_VS_SS_SM_AWD_PO_E() : String
      {
         return sFR_HSW_VS_SS_SM_AWD_PO_E;
      }
      
      public function get VFS_F_R() : String
      {
         return sFR_R;
      }
      
      public function get VFS_F_R_AWD() : String
      {
         return sFR_R_AWD;
      }
      
      public function get VFS_F_R_PO() : String
      {
         return sFR_R_PO;
      }
      
      public function get VFS_F_R_PO_E() : String
      {
         return sFR_R_PO_E;
      }
      
      public function get VFS_F_R_HS() : String
      {
         return sFR_R_HS;
      }
      
      public function get VFS_F_R_HS_AWD() : String
      {
         return sFR_R_HS_AWD;
      }
      
      public function get VFS_F_R_HS_AWD_SM() : String
      {
         return sFR_R_HS_AWD_SM;
      }
      
      public function get VFS_F_R_HS_SM() : String
      {
         return sFR_R_HS_SM;
      }
      
      public function get VFS_F_R_HS_PO() : String
      {
         return sFR_R_HS_PO;
      }
      
      public function get VFS_F_R_HS_PO_E() : String
      {
         return sFR_R_HS_PO_E;
      }
      
      public function get VFS_F_R_HSW() : String
      {
         return sFR_R_HSW;
      }
      
      public function get VFS_F_R_HSW_AWD() : String
      {
         return sFR_R_HSW_AWD;
      }
      
      public function get VFS_F_R_HSW_AWD_SM() : String
      {
         return sFR_R_HSW_AWD_SM;
      }
      
      public function get VFS_F_R_HSW_SM() : String
      {
         return sFR_R_HSW_SM;
      }
      
      public function get VFS_F_R_HSW_SS() : String
      {
         return sFR_R_HSW_SS;
      }
      
      public function get VFS_F_R_HSW_SS_AWD() : String
      {
         return sFR_R_HSW_SS_AWD;
      }
      
      public function get VFS_F_R_HSW_SS_AWD_SM() : String
      {
         return sFR_R_HSW_SS_AWD_SM;
      }
      
      public function get VFS_F_R_HS_VS() : String
      {
         return sFR_R_HS_VS;
      }
      
      public function get VFS_F_R_HS_VS_SM() : String
      {
         return sFR_R_HS_VS_SM;
      }
      
      public function get VFS_F_R_HS_VS_PO() : String
      {
         return sFR_R_HS_VS_PO;
      }
      
      public function get VFS_F_R_HS_VS_SM_PO() : String
      {
         return sFR_R_HS_VS_SM_PO;
      }
      
      public function get VFS_F_R_HSW_VS() : String
      {
         return sFR_R_HSW_VS;
      }
      
      public function get VFS_F_R_HSW_VS_SS() : String
      {
         return sFR_R_HSW_VS_SS;
      }
      
      public function get VFS_F_R_HSW_VS_SS_AWD() : String
      {
         return sFR_R_HSW_VS_SS_AWD;
      }
      
      public function get VFS_F_R_HSW_VS_SS_SM() : String
      {
         return sFR_R_HSW_VS_SS_SM;
      }
      
      public function get VFS_F_R_HSW_VS_SS_SM_AWD_PO_E() : String
      {
         return sFR_R_HSW_VS_SS_SM_AWD_PO_E;
      }
      
      public function get vehicleFeatureSet() : String
      {
         mVehicleFeatureSet = this.vehicleConfiguration();
         return mVehicleFeatureSet;
      }
      
      public function get hasRear() : Boolean
      {
         var hvacConfig:String = Peripheral.vehConfig.hvacConfig;
         if(hvacConfig == "1" || hvacConfig == "5" || hvacConfig == "6")
         {
            return true;
         }
         return false;
      }
      
      public function get hasRearAc() : Boolean
      {
         if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND && Peripheral.vehConfig.hasNetCfgRearHVACPresent)
         {
            return true;
         }
         return false;
      }
      
      public function get hasAuto() : Boolean
      {
         var hvacConfig:String = Peripheral.vehConfig.hvacConfig;
         if(hvacConfig == "2" || hvacConfig == "4" || hvacConfig == "5")
         {
            return true;
         }
         return false;
      }
      
      public function get hasSync() : Boolean
      {
         var hvacConfig:String = Peripheral.vehConfig.hvacConfig;
         if(hvacConfig == "4" || hvacConfig == "5" || hvacConfig == "3" || hvacConfig == "6")
         {
            return true;
         }
         return false;
      }
      
      public function get hasDualFrontZones() : Boolean
      {
         var hvacConfig:String = Peripheral.vehConfig.hvacConfig;
         if(hvacConfig == "3" || hvacConfig == "4" || hvacConfig == "5" || hvacConfig == "6")
         {
            return true;
         }
         return false;
      }
      
      public function get hasDualRearZones() : Boolean
      {
         if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND)
         {
            if(Peripheral.vehConfig.hvacConfig == "5" && Peripheral.vehConfig.hasNetCfgRearHVACPresent)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function get hasRightHandDrive() : Boolean
      {
         if(Peripheral.vehConfig.steeringWheelConfig == "2")
         {
            return true;
         }
         return false;
      }
      
      public function get hasCompass() : Boolean
      {
         return Peripheral.vehConfig.hasCompassDisplay;
      }
      
      public function get hasOutsideTemp() : Boolean
      {
         return Peripheral.vehConfig.hasTemperatureDisplay;
      }
      
      public function get hasRearDefroster() : Boolean
      {
         return Peripheral.vehConfig.hasRearDefrostButton;
      }
      
      private function vehicleConfiguration() : String
      {
         var hasHS:Boolean = Peripheral.vehConfig.hasHeatedSeat;
         var hasVS:Boolean = Peripheral.vehConfig.hasVentedSeat;
         var hasHSW:Boolean = Peripheral.vehConfig.hasHeatedSteeringWheel;
         var hasPO:Boolean = Peripheral.vehConfig.hasOutlet;
         var hasSS:Boolean = Peripheral.vehConfig.hasSunShade;
         var hasSM:Boolean = Peripheral.vehConfig.hasSportsMode;
         var hasECO:Boolean = Peripheral.vehConfig.hasEcoMode;
         var hasAWD:Boolean = Peripheral.vehConfig.transmissionConfig == "3" ? true : false;
         var hvacConfig:String = Peripheral.vehConfig.hvacConfig;
         if(hasHS && hasVS && hasHSW && hasSS && hasSM)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW_VS_SS_SM;
            }
            return sFR_HSW_VS_SS_SM;
         }
         if(hasHS && hasVS && hasHSW && hasSS)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW_VS_SS;
            }
            return sFR_HSW_VS_SS;
         }
         if(hasHS && hasVS && hasHSW)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW_VS;
            }
            return sFR_HSW_VS;
         }
         if(hasHS && hasHSW && hasSM)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW_SM;
            }
            return sFR_HSW_SM;
         }
         if(hasHS && hasHSW && hasSS)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW_SS;
            }
            return sFR_HSW_SS;
         }
         if(hasHS && hasPO)
         {
            if(this.hasRear)
            {
               return sFR_R_HS_PO;
            }
            return sFR_HS_PO;
         }
         if(hasHS && hasHSW)
         {
            if(this.hasRear)
            {
               return sFR_R_HSW;
            }
            return sFR_HSW;
         }
         if(hasHS && hasVS)
         {
            if(this.hasRear)
            {
               return sFR_R_HS_VS;
            }
            return sFR_HS_VS;
         }
         if(hasHS)
         {
            if(this.hasRear)
            {
               return sFR_R_HS;
            }
            return sFR_HS;
         }
         if(this.hasRear)
         {
            return sFR_R;
         }
         return sFR_ONLY;
      }
   }
}

