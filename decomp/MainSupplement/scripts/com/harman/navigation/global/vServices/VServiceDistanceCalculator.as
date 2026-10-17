package com.harman.navigation.global.vServices
{
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   
   use namespace NavigationNamespace;
   
   public class VServiceDistanceCalculator
   {
      
      private static const METERS_PER_KM:Number = 1000;
      
      private static const YARDS_PER_MILE:Number = 1760;
      
      private static const FEET_PER_MILE:Number = 5280;
      
      private static const KM_TO_YARDS:Number = 1093.61;
      
      private static const KM_TO_FEET:Number = 3280.84;
      
      private static const KM_TO_METER:Number = 1000;
      
      private static const PI_BY_180:Number = Math.PI / 180;
      
      private static const DIST_TABLE_METRIC:Object = {
         "0":{
            "RANGE_MAX":100,
            "INCREMENT":10,
            "DIVIDER":5,
            "SUFFIX":NavigationPackage.translations.STRB_METER_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "1":{
            "RANGE_MAX":270,
            "INCREMENT":50,
            "DIVIDER":25,
            "SUFFIX":NavigationPackage.translations.STRB_METER_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "2":{
            "RANGE_MAX":940,
            "INCREMENT":100,
            "DIVIDER":50,
            "SUFFIX":NavigationPackage.translations.STRB_METER_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "3":{
            "RANGE_MAX":9900,
            "INCREMENT":100,
            "DIVIDER":50,
            "SUFFIX":NavigationPackage.translations.STRB_KM,
            "DIGITS":1,
            "FAKTOR":METERS_PER_KM
         },
         "4":{
            "RANGE_MAX":536870910,
            "INCREMENT":1000,
            "DIVIDER":500,
            "SUFFIX":NavigationPackage.translations.STRB_KM,
            "DIGITS":0,
            "FAKTOR":METERS_PER_KM
         }
      };
      
      private static const DIST_TABLE_IMPERIAL:Object = {
         "0":{
            "RANGE_MAX":100,
            "INCREMENT":10,
            "DIVIDER":5,
            "SUFFIX":NavigationPackage.translations.STRB_YARD_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "1":{
            "RANGE_MAX":300,
            "INCREMENT":50,
            "DIVIDER":25,
            "SUFFIX":NavigationPackage.translations.STRB_YARD_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "2":{
            "RANGE_MAX":900,
            "INCREMENT":100,
            "DIVIDER":50,
            "SUFFIX":NavigationPackage.translations.STRB_YARD_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "3":{
            "RANGE_MAX":17424,
            "INCREMENT":528,
            "DIVIDER":264,
            "SUFFIX":NavigationPackage.translations.STRB_MI,
            "DIGITS":1,
            "FAKTOR":YARDS_PER_MILE
         },
         "4":{
            "RANGE_MAX":536870910,
            "INCREMENT":5280,
            "DIVIDER":2640,
            "SUFFIX":NavigationPackage.translations.STRB_MI,
            "DIGITS":0,
            "FAKTOR":YARDS_PER_MILE
         }
      };
      
      private static const DIST_TABLE_US:Object = {
         "0":{
            "RANGE_MAX":300,
            "INCREMENT":50,
            "DIVIDER":25,
            "SUFFIX":NavigationPackage.translations.STRB_FEET_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "1":{
            "RANGE_MAX":900,
            "INCREMENT":100,
            "DIVIDER":50,
            "SUFFIX":NavigationPackage.translations.STRB_FEET_ARG,
            "DIGITS":0,
            "FAKTOR":1
         },
         "2":{
            "RANGE_MAX":52272,
            "INCREMENT":528,
            "DIVIDER":264,
            "SUFFIX":NavigationPackage.translations.STRB_MI,
            "DIGITS":1,
            "FAKTOR":FEET_PER_MILE
         },
         "3":{
            "RANGE_MAX":536870910,
            "INCREMENT":5280,
            "DIVIDER":2640,
            "SUFFIX":NavigationPackage.translations.STRB_MI,
            "DIGITS":0,
            "FAKTOR":FEET_PER_MILE
         }
      };
      
      public function VServiceDistanceCalculator()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
      }
      
      public function getDistanceToPositionString(pos:String) : String
      {
         if(pos.length > 0)
         {
            return this.getDistanceStringWithUnit(this.getDistanceToPosition(pos));
         }
         return "";
      }
      
      public function getDistanceToPosition(pos:String) : Number
      {
         var vehicleStr:String = NavigationApi.api.posPositionInformation.getType("<GEO>");
         var distance:Number = 0;
         var posLong:Number = PI_BY_180 * Number(pos.substring(0,pos.indexOf(" ")));
         var posLat:Number = PI_BY_180 * Number(pos.substring(pos.indexOf(" ") + 1,pos.length - 1));
         var vehLong:Number = PI_BY_180 * Number(vehicleStr.substring(0,vehicleStr.indexOf(" ")));
         var vehLat:Number = PI_BY_180 * Number(vehicleStr.substring(vehicleStr.indexOf(" ") + 1,vehicleStr.length - 1));
         distance = Math.cos(posLat) * Math.cos(vehLat) * Math.cos(vehLong - posLong) + Math.sin(posLat) * Math.sin(vehLat);
         if(distance < 0)
         {
            distance *= -1;
         }
         return Math.acos(distance) * 6371;
      }
      
      public function getDistanceBetweenTwoLocations(pos1:String, pos2:String) : String
      {
         return this.getDistanceStringWithUnit(this.getDistanceBetweenTwoLocationsNum(pos1,pos2));
      }
      
      public function getDistanceBetweenTwoLocationsNum(pos1:String, pos2:String) : Number
      {
         var vehicleStr:String = NavigationApi.api.posPositionInformation.getType("<GEO>");
         var distance:Number = 0;
         var pos1Long:Number = PI_BY_180 * Number(pos1.substring(0,pos1.indexOf(" ")));
         var pos1Lat:Number = PI_BY_180 * Number(pos1.substring(pos1.indexOf(" ") + 1,pos1.length - 1));
         var pos2Long:Number = PI_BY_180 * Number(pos2.substring(0,pos2.indexOf(" ")));
         var pos2Lat:Number = PI_BY_180 * Number(pos2.substring(pos2.indexOf(" ") + 1,pos2.length - 1));
         distance = Math.cos(pos1Lat) * Math.cos(pos2Lat) * Math.cos(pos2Long - pos1Long) + Math.sin(pos1Lat) * Math.sin(pos2Lat);
         if(distance < 0)
         {
            distance *= -1;
         }
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
               return Math.acos(distance) * 3959;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               return Math.acos(distance) * 6371;
            default:
               return Math.acos(distance) * 6371;
         }
      }
      
      public function getDistanceStringWithUnit(distance:Number) : String
      {
         var tablePointer:Object = null;
         var value:int = 0;
         var increment:int = 0;
         var i:String = null;
         var erg:String = "";
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
               tablePointer = DIST_TABLE_US;
               value = distance * KM_TO_FEET;
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               tablePointer = DIST_TABLE_METRIC;
               value = distance * KM_TO_METER;
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               tablePointer = DIST_TABLE_IMPERIAL;
               value = distance * KM_TO_YARDS;
               break;
            default:
               tablePointer = DIST_TABLE_US;
               value = distance * KM_TO_FEET;
         }
         for(i in tablePointer)
         {
            if(value <= int(Object(tablePointer[i])["RANGE_MAX"]))
            {
               increment = int(Object(tablePointer[i])["INCREMENT"]);
               if(value % increment > int(Object(tablePointer[i])["DIVIDER"]))
               {
                  value = increment * (int(value / increment) + 1);
               }
               else
               {
                  value = increment * int(value / increment);
               }
               erg = this.composeVariableStrings(this.formatDecimals(value / int(Object(tablePointer[i])["FAKTOR"]),int(Object(tablePointer[i])["DIGITS"])),Object(tablePointer[i])["SUFFIX"]);
               break;
            }
         }
         return erg;
      }
      
      public function getDistanceStringWithUnitNotSmooted(distance:Number) : String
      {
         var erg:String = "";
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               if(distance < 0.5)
               {
                  erg = this.formatDecimals(distance / 1.6 * 1760,0) + "yd";
               }
               else if(distance >= 100)
               {
                  erg = this.formatDecimals(distance / 1.6,0) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MI);
               }
               else
               {
                  erg = this.formatDecimals(distance / 1.6,1) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MI);
               }
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
               if(distance < 0.5)
               {
                  erg = this.composeVariableStrings(this.formatDecimals(distance / 1.6 * 5280,0),NavigationPackage.translations.STRB_FEET_ARG);
               }
               else if(distance >= 100)
               {
                  erg = this.formatDecimals(distance / 1.6,0) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MI);
               }
               else
               {
                  erg = this.formatDecimals(distance / 1.6,1) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MI);
               }
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               if(distance < 0.5)
               {
                  erg = this.composeVariableStrings(this.formatDecimals(distance * 1000,0),NavigationPackage.translations.STRB_METER_ARG);
               }
               else if(distance >= 100)
               {
                  erg = this.formatDecimals(distance,0) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_KM);
               }
               else
               {
                  erg = this.formatDecimals(distance,1) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_KM);
               }
               break;
            default:
               erg = distance + "undefined";
         }
         return erg;
      }
      
      public function getDistanceStringLowestMeasurementWithUnitNotSmooted(distance:Number) : String
      {
         var erg:String = "";
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               erg = this.formatDecimals(distance / 1.6 * 1760,0) + "yd";
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
               erg = this.composeVariableStrings(this.formatDecimals(distance / 1.6 * 5280,0),NavigationPackage.translations.STRB_FEET_ARG);
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               erg = this.composeVariableStrings(this.formatDecimals(distance * 1000,0),NavigationPackage.translations.STRB_METER_ARG);
               break;
            default:
               erg = distance + "undefined";
         }
         return erg;
      }
      
      public function getSpeedStringWithUnit(speed:int) : String
      {
         var erg:String = "";
         switch(VServiceGlobalSettings.speedUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
               erg = int(speed / 1.6) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MPH_ABB);
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               erg = speed + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_KMH_ABB);
               break;
            default:
               erg = speed + "undefined";
         }
         return erg;
      }
      
      private function formatDecimals(num:Number, digits:uint) : String
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
      
      private function composeVariableStrings(input:String, strId:int) : String
      {
         var fullString:String = NavigationPackage.peripheral.localeEngine.getText(strId);
         if(fullString.indexOf("%s") >= 0)
         {
            fullString = fullString.replace("%s",input);
         }
         else
         {
            fullString = input + fullString;
         }
         return fullString;
      }
   }
}

