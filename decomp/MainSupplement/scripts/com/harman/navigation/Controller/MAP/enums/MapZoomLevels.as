package com.harman.navigation.Controller.MAP.enums
{
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   
   public class MapZoomLevels
   {
      
      public static const LEVEL_AUTO_OFF:int = -4;
      
      public static const LEVEL_AUTO_FAR:int = -3;
      
      public static const LEVEL_AUTO_NORMAL:int = -2;
      
      public static const LEVEL_AUTO_NEAR:int = -1;
      
      public static const LEVEL_AUTO:int = 0;
      
      public static const LEVEL_0:int = 1;
      
      public static const LEVEL_1:int = 2;
      
      public static const LEVEL_2:int = 3;
      
      public static const LEVEL_3:int = 4;
      
      public static const LEVEL_4:int = 5;
      
      public static const LEVEL_5:int = 6;
      
      public static const LEVEL_6:int = 7;
      
      public static const LEVEL_7:int = 8;
      
      public static const LEVEL_8:int = 9;
      
      public static const LEVEL_9:int = 10;
      
      public static const LEVEL_10:int = 11;
      
      public static const LEVEL_11:int = 12;
      
      public static const LEVEL_12:int = 13;
      
      public static const LEVEL_13:int = 14;
      
      public static const LEVEL_14:int = 15;
      
      public static const LEVEL_15:int = 16;
      
      public static const LEVEL_16:int = 17;
      
      public static const LEVEL_17:int = 18;
      
      public static const LEVEL_18:int = 19;
      
      public static const LEVEL_19:int = 20;
      
      public static const LEVEL_20:int = 21;
      
      public static const LEVEL_21:int = 22;
      
      public static const LEVEL_22:int = 23;
      
      public static const TOTAL_LEVELS:int = 24;
      
      public static const mLevels_US:Object = {
         "-3":-3,
         "-2":-2,
         "-1":-1,
         0:-1,
         1:50,
         2:100,
         3:200,
         4:280,
         5:480,
         6:680,
         7:900,
         8:1350,
         9:1800,
         10:2400,
         11:4800,
         12:7200,
         13:9600,
         14:16800,
         15:24000,
         16:48000,
         17:72000,
         18:120000,
         19:240000,
         20:480000,
         21:720000,
         22:1200000
      };
      
      public static const mLevels_Imperial:Object = {
         "-3":-3,
         "-2":-2,
         "-1":-1,
         0:-1,
         1:50,
         2:100,
         3:200,
         4:280,
         5:480,
         6:680,
         7:900,
         8:1350,
         9:1800,
         10:2400,
         11:4800,
         12:7200,
         13:9600,
         14:16800,
         15:24000,
         16:48000,
         17:72000,
         18:120000,
         19:240000,
         20:480000,
         21:720000,
         22:1200000
      };
      
      public static const mLevels_Metric:Object = {
         "-3":-3,
         "-2":-2,
         "-1":-1,
         0:-1,
         1:50,
         2:100,
         3:217,
         4:280,
         5:480,
         6:742,
         7:1033,
         8:1477,
         9:2213,
         10:2981,
         11:4475,
         12:7456,
         13:10438,
         14:14912,
         15:23860,
         16:44740,
         17:74565,
         18:119302,
         19:238607,
         20:477214,
         21:715818,
         22:1193032
      };
      
      public static const mLevels_US_display:Object = {
         "-3":"auto",
         "-2":"auto",
         "-1":"auto",
         0:"auto",
         1:"25ft",
         2:"50ft",
         3:"150ft",
         4:"250ft",
         5:"500ft",
         6:"750ft",
         7:"1000ft",
         8:"1500ft ",
         9:"2000ft",
         10:"0.5mi",
         11:"1mi",
         12:"1.5mi ",
         13:"2mi",
         14:"3.5mi",
         15:"5mi",
         16:"10mi",
         17:"15mi",
         18:"25mi",
         19:"50mi",
         20:"100mi",
         21:"150mi",
         22:"250mi"
      };
      
      public static const mLevels_Imperial_display:Object = {
         "-3":"auto",
         "-2":"auto",
         "-1":"auto",
         0:"auto",
         1:"10yd",
         2:"15yd",
         3:"50yd",
         4:"75yd",
         5:"150yd",
         6:"250yd",
         7:"350yd",
         8:"500yd",
         9:"750yd",
         10:"0.5mi",
         11:"1mi",
         12:"1.5mi ",
         13:"2mi",
         14:"3.5mi",
         15:"5mi",
         16:"10mi",
         17:"15mi",
         18:"25mi",
         19:"50mi",
         20:"100mi",
         21:"150mi",
         22:"250mi"
      };
      
      public static const mLevels_Metric_display:Object = {
         "-3":"auto",
         "-2":"auto",
         "-1":"auto",
         0:"auto",
         1:"10m",
         2:"15m",
         3:"50m",
         4:"75m",
         5:"150m",
         6:"250m",
         7:"350m",
         8:"500m",
         9:"750m",
         10:"1km",
         11:"1.5km",
         12:"2.5km",
         13:"3.5km",
         14:"5km",
         15:"8km",
         16:"15km",
         17:"25km",
         18:"40km",
         19:"80km",
         20:"160km",
         21:"240km",
         22:"400km"
      };
      
      public function MapZoomLevels()
      {
         super();
      }
      
      public static function get currentZoomLevels() : Object
      {
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               return mLevels_Imperial;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               return mLevels_Metric;
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
         }
         return mLevels_US;
      }
      
      public static function get currentZoomLevelsDisplay() : Object
      {
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               return mLevels_Imperial_display;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               return mLevels_Metric_display;
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
         }
         return mLevels_US_display;
      }
      
      public static function getDistanceStringWithUnit(lvl:int) : String
      {
         var erg:String = "";
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               return mLevels_Imperial_display[lvl];
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               return mLevels_Metric_display[lvl];
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
         }
         return mLevels_US_display[lvl];
      }
      
      private static function formatDecimals(num:Number, digits:uint) : String
      {
         var decimalPosition:int = 0;
         var j:int = 0;
         var tenToPower:Number = Math.pow(10,digits);
         var cropped:String = String(Math.round(num * tenToPower) / tenToPower);
         for(var i:int = 0; i < cropped.length; i++)
         {
            if(cropped.charAt(i) == ".")
            {
               decimalPosition = i;
            }
         }
         var output:String = cropped;
         var decimals:String = cropped.substr(decimalPosition + 1,cropped.length);
         var missingZeros:Number = digits - decimals.length;
         if(decimals.length < digits && decimalPosition > 0)
         {
            for(j = 0; j < missingZeros; j++)
            {
               output += "0";
            }
         }
         return output;
      }
   }
}

