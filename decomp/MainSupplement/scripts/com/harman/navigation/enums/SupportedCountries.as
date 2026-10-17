package com.harman.navigation.enums
{
   public class SupportedCountries
   {
      
      private static var countriesSupportTMCStation:Array = ["AUS","NZL","SIN","INA","ALB","AND","ARM","AUT","AZE","BLR","BEL","LUX","BIH","BUL","CRO","CYP","CZE","DEN","EST","FIN","FRA","GEO","GER","GIB","GRE","HUN","ISL","IRL","ITA","LAT","LTU","MLT","MDA","MON","NED","NOR","POL","POR","SCG","SVK","SLO","ROM","RUS","ESP","SWE","SUI","TUR","UKR","GBR","VAT","BOT","KEN","LES","MAW","MRI","MOZ","RSA","TAN","UGA","ZAM","ZIM"];
      
      private static var countriesSupportSpeedCam:Array = ["AND","AUT","BEL","BUL","CZE","DEN","FIN","HUN","IRL","ITA","NED","NOR","POL","POR","ROM","RUS","SVK","SLO","ESP","SWE","GBR","KOR","PRK","CHN","Australia"];
      
      private static var countriesSupportDangerZone:Array = ["FRA"];
      
      public function SupportedCountries()
      {
         super();
      }
      
      public static function isSupportedCountry(location:String, type:String) : Boolean
      {
         var tmp:Array = null;
         var name:String = null;
         switch(type)
         {
            case "TMC":
               tmp = countriesSupportTMCStation;
               break;
            case "SpeedCam":
               tmp = countriesSupportSpeedCam;
               break;
            case "DangerZone":
               tmp = countriesSupportDangerZone;
               break;
            default:
               return false;
         }
         for each(name in tmp)
         {
            if(name == location)
            {
               return true;
            }
         }
         return false;
      }
   }
}

