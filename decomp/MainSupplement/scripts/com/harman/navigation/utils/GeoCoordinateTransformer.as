package com.harman.navigation.utils
{
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.nfuzion.framework.global.Framework;
   
   public class GeoCoordinateTransformer
   {
      
      private static const NAV_GPS_TICKS_PER_DEGR:int = 11930464;
      
      private static const NAV_GPS_TICKS_PER_MDEGR:int = 11930;
      
      private static const NAV_GPS_TICKS_PER_MIN:int = 198841;
      
      private static const NAV_GPS_TICKS_PER_SEC:int = 3314;
      
      public function GeoCoordinateTransformer()
      {
         super();
      }
      
      public static function transformDMS_Long_to_DD(long:String, addDegreeSymbol:Boolean) : String
      {
         var ret:String = null;
         var result:Number = Number(long.substr(0,3)) + Number(long.substr(4,2)) / 60 + Number(long.substr(7,5)) / 3600;
         if(long.substr(14,1) == "W")
         {
            ret = "-";
         }
         else
         {
            ret = "+";
         }
         ret = ret + (result < 100 ? "0" : "") + (result < 10 ? "0" : "");
         return ret + result.toFixed(6) + (addDegreeSymbol == true ? "°" : "");
      }
      
      public static function transformDMS_Lat_to_DD(lat:String, addDegreeSymbol:Boolean) : String
      {
         var ret:String = null;
         var result:Number = Number(lat.substr(0,2)) + Number(lat.substr(3,2)) / 60 + Number(lat.substr(6,5)) / 3600;
         if(lat.substr(13,1) == "S")
         {
            ret = "-";
         }
         else
         {
            ret = "+";
         }
         ret += result < 10 ? "0" : "";
         return ret + result.toFixed(6) + (addDegreeSymbol == true ? "°" : "");
      }
      
      public static function transformDD_Long_to_DMS(long:String, addPrecedingZeros:Boolean) : String
      {
         var result:String = null;
         var tmp:Number = NaN;
         if(long.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoCoordinateTransformer.transformDD_Long_to_DMS bad input (" + long + ")");
            long = "+000.000000°";
         }
         var tmpNum:Number = Number(long.substr(0,long.length - 1));
         if(isNaN(tmpNum))
         {
            tmpNum = 0;
         }
         if(long.charAt(0) == "+")
         {
            result = (tmpNum < 100 && addPrecedingZeros ? "0" : "") + (tmpNum < 10 && addPrecedingZeros ? "0" : "") + int(tmpNum) + "°";
            tmpNum -= int(tmpNum);
            result = result + (tmpNum * 60 < 10 ? "0" : "") + int(tmpNum * 60) + "\'";
            tmp = (tmpNum * 60 - int(tmpNum * 60)) / 60 * 3600;
            result = result + (int(tmp.toFixed(2)) < 10 ? "0" : "") + tmp.toFixed(2) + "\" ";
            result += "E";
         }
         else
         {
            tmpNum *= -1;
            result = (tmpNum < 100 && addPrecedingZeros ? "0" : "") + (tmpNum < 10 && addPrecedingZeros ? "0" : "") + int(tmpNum) + "°";
            tmpNum -= int(tmpNum);
            result = result + (tmpNum * 60 < 10 ? "0" : "") + int(tmpNum * 60) + "\'";
            tmp = (tmpNum * 60 - int(tmpNum * 60)) / 60 * 3600;
            result = result + (int(tmp.toFixed(2)) < 10 ? "0" : "") + tmp.toFixed(2) + "\" ";
            result += "W";
         }
         return result;
      }
      
      public static function transformDD_Lat_to_DMS(lat:String) : String
      {
         var result:String = null;
         var tmp:Number = NaN;
         if(lat.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoCoordinateTransformer.transformDD_Lat_to_DMS bad input (" + lat + ")");
            lat = "+00.000000°";
         }
         var tmpNum:Number = Number(lat.substr(0,lat.length - 1));
         if(isNaN(tmpNum))
         {
            tmpNum = 0;
         }
         if(lat.charAt(0) == "+")
         {
            result = (tmpNum < 10 ? "0" : "") + int(tmpNum) + "°";
            tmpNum -= int(tmpNum);
            result = result + (int(tmpNum * 60) < 10 ? "0" : "") + int(tmpNum * 60) + "\'";
            tmp = (tmpNum * 60 - int(tmpNum * 60)) / 60 * 3600;
            result = result + (tmp < 10 ? "0" : "") + tmp.toFixed(2) + "\" ";
            result += "N";
         }
         else
         {
            tmpNum *= -1;
            result = (tmpNum < 10 ? "0" : "") + int(tmpNum) + "°";
            tmpNum -= int(tmpNum);
            result = result + (int(tmpNum * 60) < 10 ? "0" : "") + int(tmpNum * 60) + "\'";
            tmp = (tmpNum * 60 - int(tmpNum * 60)) / 60 * 3600;
            result = result + (int(tmp.toFixed(2)) < 10 ? "0" : "") + tmp.toFixed(2) + "\" ";
            result += "S";
         }
         return result;
      }
      
      public static function transformDM_Long_to_DD(long:String, addDegreeSymbol:Boolean) : String
      {
         var result:Number = Number(long.substr(0,3)) + Number(long.substr(4,6)) / 60;
         var erg:String = "";
         if(result < 10)
         {
            erg = "00";
         }
         else if(result < 100)
         {
            erg = "0";
         }
         erg = erg + result.toFixed(6) + (addDegreeSymbol == true ? "°" : "");
         if(long.substr(12,1) == "W")
         {
            erg = "-" + erg;
         }
         else
         {
            erg = "+" + erg;
         }
         return erg;
      }
      
      public static function transformDM_Lat_to_DD(lat:String, addDegreeSymbol:Boolean) : String
      {
         var result:Number = Number(lat.substr(0,2)) + Number(lat.substr(3,6)) / 60;
         var erg:String = "";
         erg = String(result.toFixed(6) + (addDegreeSymbol == true ? "°" : ""));
         if(lat.substr(11,1) == "S")
         {
            erg = "-" + erg;
         }
         else
         {
            erg = "+" + erg;
         }
         return erg;
      }
      
      public static function transformDD_Long_to_DM(long:String, addPrecedingZeros:Boolean) : String
      {
         var result:String = null;
         if(long.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoCoordinateTransformer.transformDD_Long_to_DM bad input (" + long + ")");
            long = "+000.000000°";
         }
         var tmpNum:Number = Number(long.substr(0,long.length - 1));
         if(isNaN(tmpNum))
         {
            tmpNum = 0;
         }
         if(long.charAt(0) == "+")
         {
            result = (tmpNum < 100 && addPrecedingZeros ? "0" : "") + (tmpNum < 10 && addPrecedingZeros ? "0" : "") + int(tmpNum) + "°" + (Number(Number(tmpNum % 1) * 60) < 10 ? "0" : "") + Number(Number(tmpNum % 1) * 60).toFixed(3) + "\' " + "E";
         }
         else
         {
            tmpNum *= -1;
            result = (tmpNum < 100 && addPrecedingZeros ? "0" : "") + (tmpNum < 10 && addPrecedingZeros ? "0" : "") + int(tmpNum) + "°" + (Number(Number(tmpNum % 1) * 60) < 10 ? "0" : "") + Number(Number(tmpNum % 1) * 60).toFixed(3) + "\' " + "W";
         }
         return result;
      }
      
      public static function transformDD_Lat_to_DM(lat:String) : String
      {
         var result:String = null;
         if(lat.indexOf("NaN") != -1)
         {
            Framework.Trace("GeoCoordinateTransformer.transformDD_Lat_to_DM bad input (" + lat + ")");
            lat = "+00.000000°";
         }
         var tmpNum:Number = Number(lat.substr(0,lat.length - 1));
         if(isNaN(tmpNum))
         {
            tmpNum = 0;
         }
         if(lat.charAt(0) == "+")
         {
            result = (tmpNum < 10 ? "0" : "") + int(tmpNum) + "°" + (Number(Number(tmpNum % 1) * 60) < 10 ? "0" : "") + Number(Number(tmpNum % 1) * 60).toFixed(3) + "\' " + "N";
         }
         else
         {
            tmpNum *= -1;
            result = (tmpNum < 10 ? "0" : "") + int(tmpNum) + "°" + (Number(Number(tmpNum % 1) * 60) < 10 ? "0" : "") + Number(Number(tmpNum % 1) * 60).toFixed(3) + "\' " + "S";
         }
         return result;
      }
      
      private static function transformDD_to_DD(input:String) : String
      {
         var length:int = input.length - 1 - input.lastIndexOf(".");
         while(length < 6)
         {
            input += "0";
            length++;
         }
         return input;
      }
      
      public static function transformGeoTagToCurrentSystem(input:String, addLineBreak:Boolean = false) : String
      {
         var long:String = String(input.substring(0,input.lastIndexOf(" ")));
         var lat:String = String(input.substring(input.lastIndexOf(" ") + 1,input.length - 1));
         if(long.charAt(0) != "+" && long.charAt(0) != "-")
         {
            long = "+" + long;
         }
         if(lat.charAt(0) != "+" && lat.charAt(0) != "-")
         {
            lat = "+" + lat;
         }
         switch(VServiceGlobalSettings.geoCoordinateSystem)
         {
            case GeoFormats.FORMAT_DD:
               return transformToLanguage(String(transformDD_to_DD(lat) + (addLineBreak ? "\n" : ", ") + transformDD_to_DD(long)));
            case GeoFormats.FORMAT_DM:
               return transformToLanguage(String(transformDD_Lat_to_DM(lat) + (addLineBreak ? "\n" : ", ") + transformDD_Long_to_DM(long,false)));
            case GeoFormats.FORMAT_DMS:
         }
         return transformToLanguage(String(transformDD_Lat_to_DMS(lat) + (addLineBreak ? "\n" : ", ") + transformDD_Long_to_DMS(long,false)));
      }
      
      public static function transformToLanguage(input:String) : String
      {
         var characters:String = input;
         if(characters.indexOf("N") != -1)
         {
            characters = characters.replace("N",NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_NORTH));
         }
         if(characters.indexOf("S") != -1)
         {
            characters = characters.replace("S",NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_SOUTH));
         }
         if(characters.indexOf("E") != -1)
         {
            characters = characters.replace("E",NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_EAST));
         }
         if(characters.indexOf("W") != -1)
         {
            characters = characters.replace("W",NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_WEST));
         }
         return characters;
      }
      
      public static function transformFromLanguage(input:String) : String
      {
         var character:String = input;
         if(character.indexOf(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_NORTH)) != -1)
         {
            character = character.replace(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_NORTH),"N");
         }
         if(character.indexOf(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_SOUTH)) != -1)
         {
            character = character.replace(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_SOUTH),"S");
         }
         if(character.indexOf(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_EAST)) != -1)
         {
            character = character.replace(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_EAST),"E");
         }
         if(character.indexOf(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_WEST)) != -1)
         {
            character = character.replace(NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_GEO_WEST),"W");
         }
         return character;
      }
   }
}

