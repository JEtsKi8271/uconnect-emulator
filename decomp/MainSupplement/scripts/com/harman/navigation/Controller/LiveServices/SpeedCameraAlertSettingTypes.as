package com.harman.navigation.Controller.LiveServices
{
   public class SpeedCameraAlertSettingTypes
   {
      
      public static const SCAS_UNDEFINED:int = 0;
      
      public static const SCAS_FIXED_CAMERAS:int = 1;
      
      public static const SCAS_TRAFFIC_LIGHT_CAMERAS:int = 2;
      
      public static const SCAS_AVERAGE_SPEED_CHECK:int = 3;
      
      public static const SCAS_ACCIDENT_BLACKSPOTS:int = 4;
      
      public static const SCAS_MOBILE_CAMERA:int = 5;
      
      public static const SCAS_TOLL_ROAD_CAMERA:int = 6;
      
      public static const SCAS_OTHER_CAMERA:int = 7;
      
      public static const SCAS_OFF:int = 0;
      
      public static const SCAS_SPEEDING:int = 1;
      
      public static const SCAS_ALWAYS:int = 2;
      
      public static const SCTYPE_FIXED_CAMERA:int = 1;
      
      public static const SCTYPE_MOBILE_CAMERA:int = 2;
      
      public static const SCTYPE_DANGER_ZONE:int = 4;
      
      public static const SCTYPE_RISK_ZONE:int = 8;
      
      public static const SCTYPE_AVERAGE_SPEED_ZONE:int = 16;
      
      public static const SCTYPE_OTHER_CAMERA:int = 32;
      
      public static const SCTYPE_RED_LIGHT_CAMERA:int = 64;
      
      public static const SCTYPE_BUS_LANE_CAMERA:int = 128;
      
      public function SpeedCameraAlertSettingTypes()
      {
         super();
      }
      
      public static function getMappedSafetyCameraTypeString(scasType:int) : Array
      {
         var ret:Array = new Array();
         switch(scasType)
         {
            case SCAS_FIXED_CAMERAS:
               ret.push("<SCTYPE>" + SCTYPE_FIXED_CAMERA + "<*>");
               break;
            case SCAS_TRAFFIC_LIGHT_CAMERAS:
               ret.push("<SCTYPE>" + SCTYPE_RED_LIGHT_CAMERA + "<*>");
               ret.push("<SCTYPE>" + SCTYPE_BUS_LANE_CAMERA + "<*>");
               break;
            case SCAS_AVERAGE_SPEED_CHECK:
               ret.push("<SCTYPE>" + SCTYPE_AVERAGE_SPEED_ZONE + "<*>");
               break;
            case SCAS_ACCIDENT_BLACKSPOTS:
               ret.push("<SCTYPE>" + SCTYPE_DANGER_ZONE + "<*>");
               ret.push("<SCTYPE>" + SCTYPE_RISK_ZONE + "<*>");
               ret.push("<SCTYPE>" + SCTYPE_OTHER_CAMERA + "<*>");
               ret.push("<SCTYPE>" + SCTYPE_MOBILE_CAMERA + "<*>");
               break;
            case SCAS_MOBILE_CAMERA:
               ret.push("<SCTYPE>" + SCTYPE_MOBILE_CAMERA + "<*>");
               break;
            case SCAS_OTHER_CAMERA:
               ret.push("<SCTYPE>" + SCTYPE_OTHER_CAMERA + "<*>");
               break;
            case SCAS_TOLL_ROAD_CAMERA:
            case SCAS_UNDEFINED:
         }
         return ret;
      }
   }
}

