package com.harman.navigation.Controller.GeoCoordinate.util
{
   public class GeoFormatCheck
   {
      
      private static const DEFAULT_LATITUDE:String = "+00.000000°";
      
      private static const DEFAULT_LONGITUDE:String = "+000.000000°";
      
      public function GeoFormatCheck()
      {
         super();
      }
      
      public static function checkDDLatitudeStringConsistency(lat:String) : String
      {
         var indexDirection:int = lat.indexOf("+");
         if(indexDirection == -1)
         {
            indexDirection = lat.indexOf("-");
         }
         if(indexDirection == -1)
         {
            return DEFAULT_LATITUDE;
         }
         var indexDot:int = lat.indexOf(".");
         if(indexDirection == -1)
         {
            return DEFAULT_LATITUDE;
         }
         switch(indexDot - indexDirection - 1)
         {
            case 0:
               lat = lat.substr(indexDirection,1) + "00" + lat.substring(indexDirection + 1,lat.length);
               break;
            case 1:
               lat = lat.substr(indexDirection,1) + "0" + lat.substring(indexDirection + 1,lat.length);
               break;
            case 2:
               break;
            case 3:
               lat = lat.substr(indexDirection,1) + lat.substring(indexDirection + 2,lat.length);
               break;
            default:
               return DEFAULT_LATITUDE;
         }
         if(lat.indexOf("°") == -1)
         {
            lat += "°";
         }
         indexDot = lat.indexOf(".");
         var indexDegree:int = lat.indexOf("°");
         while(indexDegree - indexDot - 1 < 6)
         {
            lat = lat.substring(0,indexDot + 1) + "0" + lat.substring(indexDot + 1,lat.length);
            indexDegree = lat.indexOf("°");
         }
         if(indexDegree - indexDot - 1 > 6)
         {
            lat = lat.substring(0,indexDot + 6) + "°";
         }
         return lat;
      }
      
      public static function checkDDLongitudeStringConsistency(long:String) : String
      {
         var indexDirection:int = long.indexOf("+");
         if(indexDirection == -1)
         {
            indexDirection = long.indexOf("-");
         }
         if(indexDirection == -1)
         {
            return DEFAULT_LONGITUDE;
         }
         var indexDot:int = long.indexOf(".");
         if(indexDirection == -1)
         {
            return DEFAULT_LONGITUDE;
         }
         switch(indexDot - indexDirection - 1)
         {
            case 0:
               long = long.substr(indexDirection,1) + "000" + long.substring(indexDirection + 1,long.length);
               break;
            case 1:
               long = long.substr(indexDirection,1) + "00" + long.substring(indexDirection + 1,long.length);
               break;
            case 2:
               long = long.substr(indexDirection,1) + "0" + long.substring(indexDirection + 1,long.length);
               break;
            case 3:
               break;
            default:
               return DEFAULT_LONGITUDE;
         }
         if(long.indexOf("°") == -1)
         {
            long += "°";
         }
         indexDot = long.indexOf(".");
         var indexDegree:int = long.indexOf("°");
         while(indexDegree - indexDot - 1 < 6)
         {
            long = long.substring(0,indexDot + 1) + "0" + long.substring(indexDot + 1,long.length);
            indexDegree = long.indexOf("°");
         }
         if(indexDegree - indexDot - 1 > 6)
         {
            long = long.substring(0,indexDot + 6) + "°";
         }
         return long;
      }
   }
}

