package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   
   public class NavWeatherDetailsContainer
   {
      
      private static const MM_TO_INCH:Number = 25.4;
      
      private var mDayAbbString:String = "";
      
      private var mTemperatureCurrent:String = "--";
      
      private var mTemperatureMin:String = "--";
      
      private var mTemperatureMax:String = "--";
      
      private var mWeatherElementIconID:int = -1;
      
      private var mWeatherElementString:String = "";
      
      private var mPrecipitationString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private var mRainProbabilityString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private var mHumidityString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private var mUVIndexString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private var mWindsString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private var mCloudCoverString:String = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      
      private const CLEAR_DAY:uint = 0;
      
      private const MISTY_DAY:uint = 1;
      
      private const SOME_CLOUDS_DAY:uint = 2;
      
      private const PARTLY_CLOUDY_DAY:uint = 3;
      
      private const CLOUDY_DAY:uint = 4;
      
      private const OVERCAST_DAY:uint = 5;
      
      private const CLEAR_NIGHT:uint = 6;
      
      private const MISTY_NIGHT:uint = 7;
      
      private const SOME_CLOUDS_NIGHT:uint = 8;
      
      private const PARTLY_CLOUDY_NIGHT:uint = 9;
      
      private const CLOUDY_NIGHT:uint = 10;
      
      private const OVERCAST_NIGHT:uint = 11;
      
      private const FOG:uint = 12;
      
      private const LIGHT_THUNDER:uint = 13;
      
      private const THUNDER:uint = 14;
      
      private const LIGHT_ICE_RAIN:uint = 15;
      
      private const ICE_RAIN:uint = 16;
      
      private const LIGHT_RAIN:uint = 17;
      
      private const RAIN:uint = 18;
      
      private const HEAVY_RAIN:uint = 19;
      
      private const LIGHT_SHOWER:uint = 20;
      
      private const SHOWER:uint = 21;
      
      private const HEAVY_SHOWER:uint = 22;
      
      private const SNOW_THUNDER:uint = 23;
      
      private const LIGHT_SNOW:uint = 24;
      
      private const SNOW:uint = 25;
      
      private const HEAVY_SNOW:uint = 26;
      
      private const LIGHT_SNOW_SHOWER:uint = 27;
      
      private const SNOW_SHOWER:uint = 28;
      
      private const HEAVY_SNOW_SHOWER:uint = 29;
      
      private const LIGHT_SLEET:uint = 30;
      
      private const SLEET:uint = 31;
      
      private const HEAV_SLEET:uint = 32;
      
      private const LIGHT_SLEET_SHOWER:uint = 33;
      
      private const SLEET_SHOWER:uint = 34;
      
      private const HEAVY_SLEET_SHOWER:uint = 35;
      
      public function NavWeatherDetailsContainer(data:Object)
      {
         super();
         this.parseData(data);
      }
      
      public static function celsiusToFahrenheit(celsius:Number) : int
      {
         return int(32 + celsius * 9 / 5);
      }
      
      public function get dayAbb() : String
      {
         return this.mDayAbbString;
      }
      
      public function get temperatureCurrent() : String
      {
         return this.mTemperatureCurrent;
      }
      
      public function get temperatureMin() : String
      {
         return this.mTemperatureMin;
      }
      
      public function get temperatureMax() : String
      {
         return this.mTemperatureMax;
      }
      
      public function get weatherElementIconID() : int
      {
         return this.mWeatherElementIconID;
      }
      
      public function get weatherElementString() : String
      {
         return this.mWeatherElementString;
      }
      
      public function get precipitation() : String
      {
         return this.mPrecipitationString;
      }
      
      public function get rainProbability() : String
      {
         return this.mRainProbabilityString;
      }
      
      public function get humidity() : String
      {
         return this.mHumidityString;
      }
      
      public function get uvIndex() : String
      {
         return this.mUVIndexString;
      }
      
      public function get winds() : String
      {
         return this.mWindsString;
      }
      
      public function get cloudCover() : String
      {
         return this.mCloudCoverString;
      }
      
      private function parseData(data:Object) : void
      {
         var element:Object = null;
         if(!data.hasOwnProperty("weatherDefinition"))
         {
            Framework.Trace("NavWeatherDetailsContainer.parseData() Missing Property \"weatherDefinition\"");
            return;
         }
         if(data.weatherDefinition.hasOwnProperty("statistics"))
         {
            this.mDayAbbString = this.getDayAbbreviation(data);
            this.mTemperatureCurrent = this.getCurrentTemperatureString(data);
            this.mTemperatureMin = this.getMinTempString(data);
            this.mTemperatureMax = this.getMaxTempString(data);
            this.mPrecipitationString = this.getPrecipitationString(data);
            this.mHumidityString = this.getHumidityString(data);
            this.mUVIndexString = this.getUVIndexString(data);
            this.mWindsString = this.getWindSpeedString(data);
            this.mCloudCoverString = this.getCloudCover(data);
            if(data.weatherDefinition.hasOwnProperty("weatherDescription"))
            {
               element = this.getMostRelevantSubTableValue(data);
               this.mWeatherElementIconID = this.getWeatherElementIcon(element);
               this.mWeatherElementString = this.getWeatherElementString(element);
               this.mRainProbabilityString = this.getRainProbabilityString(data);
               return;
            }
            Framework.Trace("NavWeatherDetailsContainer.parseData() Missing Property \"weatherDescription\"");
            return;
         }
         Framework.Trace("NavWeatherDetailsContainer.parseData() Missing Property \"statistics\"");
      }
      
      private function getDayAbbreviation(data:Object) : String
      {
         if(!(Boolean(data.weatherDefinition.hasOwnProperty("date")) && data.weatherDefinition.date is Date))
         {
            return "";
         }
         switch(data.weatherDefinition.date.day % 7)
         {
            case 0:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_SUNDAY);
            case 1:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MONDAY);
            case 2:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_TUESDAY);
            case 3:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_WEDNESDAY);
            case 4:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_THURSDAY);
            case 5:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_FRIDAY);
            case 6:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_SATURDAY);
            default:
               return "";
         }
      }
      
      private function getCurrentTemperatureString(data:Object) : String
      {
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("temperature"))
         {
            result += this.transformTemperatureUnit(data.weatherDefinition.statistics.temperature);
         }
         else
         {
            result += "--";
         }
         return result;
      }
      
      private function transformTemperatureUnit(tempInC:int) : String
      {
         var res:String = "";
         if(NavigationPackage.peripheral.personalConfig.temperatureUnits == "US")
         {
            res = (celsiusToFahrenheit(tempInC) as int) + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_FAHRENHEIT);
         }
         else
         {
            res = tempInC + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_CELSIUS);
         }
         return res;
      }
      
      private function getMinTempString(data:Object) : String
      {
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("minTemperature"))
         {
            result += this.transformTemperatureUnit(data.weatherDefinition.statistics.minTemperature);
         }
         else
         {
            result += "--";
         }
         return result;
      }
      
      private function getMaxTempString(data:Object) : String
      {
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("maxTemperature"))
         {
            result += this.transformTemperatureUnit(data.weatherDefinition.statistics.maxTemperature);
         }
         else
         {
            result += "--";
         }
         return result;
      }
      
      private function getPrecipitationString(data:Object) : String
      {
         var inch:Number = NaN;
         var fraction:Number = NaN;
         var tmp:String = null;
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("rainfallTotal"))
         {
            if(NavigationPackage.peripheral.personalConfig.temperatureUnits == "US")
            {
               inch = data.weatherDefinition.statistics.rainfallTotal / MM_TO_INCH;
               fraction = inch - int(inch);
               if(inch == 0)
               {
                  result = "0";
               }
               else if(inch < 0.125)
               {
                  result = "<¼";
               }
               else if(fraction < 0.125)
               {
                  result = String(int(inch));
               }
               else if(fraction < 0.375)
               {
                  result += this.getPrecipitationIntegerString(inch) + "¼";
               }
               else if(fraction < 0.625)
               {
                  result += this.getPrecipitationIntegerString(inch) + "½";
               }
               else if(fraction < 0.875)
               {
                  result += this.getPrecipitationIntegerString(inch) + "¾";
               }
               else
               {
                  result += this.getPrecipitationIntegerString(inch + 1);
               }
               result += NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_INCH_ABB);
            }
            else
            {
               tmp = data.weatherDefinition.statistics.rainfallTotal;
               while(tmp.charAt(tmp.length - 1) == "0" || tmp.charAt(tmp.length - 1) == ".")
               {
                  tmp = tmp.substring(0,tmp.length - 1);
               }
               if(tmp.length == 0)
               {
                  tmp = "0";
               }
               result = tmp + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MILLIMETER_ABB);
            }
         }
         else
         {
            result += NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
         }
         return result;
      }
      
      private function getPrecipitationIntegerString(inch:Number) : String
      {
         if(inch >= 1)
         {
            return String(int(inch));
         }
         return "";
      }
      
      private function getHumidityString(data:Object) : String
      {
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("relativeHumidity"))
         {
            result = data.weatherDefinition.statistics.relativeHumidity + "%";
         }
         else
         {
            result = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
         }
         return result;
      }
      
      private function getUVIndexString(data:Object) : String
      {
         if(Boolean(data.weatherDefinition.statistics.hasOwnProperty("uvIndex")) && Boolean(int(data.weatherDefinition.statistics.uvIndex) >= WeatherTypes.UV_01_LOW) && int(data.weatherDefinition.statistics.uvIndex) <= WeatherTypes.UV_11_EXTREME)
         {
            return data.weatherDefinition.statistics.uvIndex;
         }
         return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      }
      
      private function getWindSpeedString(data:Object) : String
      {
         var speed:int = 0;
         var result:String = "";
         if(data.weatherDefinition.statistics.hasOwnProperty("windSpeed"))
         {
            speed = int(data.weatherDefinition.statistics.windSpeed);
            if(NavigationPackage.peripheral.personalConfig.temperatureUnits == "US")
            {
               speed *= 1.6;
               result = speed + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MPH_ABB);
            }
            else
            {
               result = speed + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_KMH_ABB);
            }
         }
         else
         {
            result = NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
         }
         return result;
      }
      
      private function getCloudCover(data:Object) : String
      {
         if(!data.weatherDefinition.statistics.hasOwnProperty("cloudCover"))
         {
            return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
         }
         switch(data.weatherDefinition.statistics.cloudCover)
         {
            case WeatherTypes.CLOUD_COVER_OKTA_0_CLEAR:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_CLEAR_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_1_FAIR:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_FAIR_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_2_MOSTLY_CLEAR:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MOSTLY_CLEAR_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_3_MOSTLY_CLEAR:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MOSTLY_CLEAR_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_4_PARTLY_CLOUDY:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_PARTLY_CLOUDY_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_5_PARTLY_CLOUDY:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_PARTLY_CLOUDY_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_6_MOSTLY_CLOUDY:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_PARTLY_CLOUDY_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_7_CLOUDY:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_MOSTLY_CLOUDY_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_8_OVERCAST:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_OVERCAST_SKY);
            case WeatherTypes.CLOUD_COVER_OKTA_9_OBSTRUCTED_SKY:
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_OBSTRUCTED);
            default:
               Framework.Trace("NavWeatherDetailsContainer.getCloudCover() Unknown cloudCover (" + data.weatherDefinition.statistics.cloudCover + ") !");
               return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
         }
      }
      
      private function getRainProbabilityString(data:Object) : String
      {
         var rainProb:String = this.getProbabilityStringOfElementTypeForDay(WeatherTypes.ELEMENT_TYPE_RAIN_ELEMENTS,data);
         if(rainProb.length > 0)
         {
            return rainProb;
         }
         return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      }
      
      private function getWeatherElementIcon(element:Object) : int
      {
         if(element.hasOwnProperty("subTableType") && element.hasOwnProperty("subTableValue"))
         {
            switch(element.subTableType)
            {
               case WeatherTypes.ELEMENT_TYPE_RAIN_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.RAIN_ELEMENT_RAIN:
                        return this.RAIN;
                     case WeatherTypes.RAIN_ELEMENT_WET:
                        return this.LIGHT_RAIN;
                     case WeatherTypes.RAIN_ELEMENT_LIGHT_RAIN:
                        return this.LIGHT_RAIN;
                     case WeatherTypes.RAIN_ELEMENT_DRIZZLE:
                        return this.RAIN;
                     case WeatherTypes.RAIN_ELEMENT_LIGHT_DRIZZLE:
                        return this.LIGHT_RAIN;
                     case WeatherTypes.RAIN_ELEMENT_HEAVY_RAIN:
                        return this.HEAVY_RAIN;
                     case WeatherTypes.RAIN_ELEMENT_SHOWERS:
                        return this.SHOWER;
                     case WeatherTypes.RAIN_ELEMENT_BLUSTERY_SHOWERS:
                        return this.SHOWER;
                     case WeatherTypes.RAIN_ELEMENT_INTERMITTENT_SHOWERS:
                        return this.SHOWER;
                     case WeatherTypes.RAIN_ELEMENT_THUNDERY_SHOWERS:
                        return this.LIGHT_THUNDER;
                     case WeatherTypes.RAIN_ELEMENT_THUNDERY_RAIN:
                        return this.THUNDER;
                     case WeatherTypes.RAIN_ELEMENT_FREEZING_RAIN:
                        return this.ICE_RAIN;
                     case WeatherTypes.RAIN_ELEMENT_DAMP:
                        return this.SHOWER;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SNOW_ELEMENT:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SNOW_ELEMENTS_SNOW:
                        return this.SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_SNOW:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_SNOW_SHOWERS:
                        return this.LIGHT_SNOW_SHOWER;
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_SHOWERS:
                        return this.SNOW_SHOWER;
                     case WeatherTypes.SNOW_ELEMENTS_HEAVY_SNOW_SHOWERS:
                        return this.HEAVY_SNOW_SHOWER;
                     case WeatherTypes.SNOW_ELEMENTS_DRIFTING_SNOW:
                        return this.SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_LOW_DRIFTING_SNOW:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_BLOWING_SNOW:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_BLOWING_SNOW:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_LOCALIZED_SNOW_SHOWERS:
                        return this.SNOW_SHOWER;
                     case WeatherTypes.SNOW_ELEMENTS_BLIZZARD:
                        return this.HEAVY_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_DIAMOND_DUST:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_GRAINS:
                        return this.LIGHT_SNOW;
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_CRYZTALS:
                        return this.LIGHT_SNOW;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SLEET_HAIL_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET_OR_HAIL:
                        return this.SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET:
                        return this.SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LIGHT_SLEET:
                        return this.LIGHT_SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET_SHOWERS:
                        return this.SLEET_SHOWER;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HEAVY_SLEET_SHOWERS:
                        return this.HEAVY_SLEET_SHOWER;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HAIL:
                        return this.SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LIGHT_HAIL:
                        return this.LIGHT_SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HAIL_SHOWERS:
                        return this.LIGHT_SLEET_SHOWER;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HEAVY_HAIL_SHOWERS:
                        return this.HEAVY_SLEET_SHOWER;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_DAMAGING_HAIL:
                        return this.HEAV_SLEET;
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LARGE_HAIL:
                        return this.HEAV_SLEET;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_WIND_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.WIND_ELEMENTS_CALM:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_AIR:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_BREEZE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_GENTLE_BREEZE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_BREEZE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_FRESH_BREEZE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_STRONG_BREEZE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_GALE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_GALE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_STRING_GALE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_STORM:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_VIOLENT_STORM:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_HURRICANE:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_WINDY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_STRONG_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_VERY_STRONG_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_BLUSTERY_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_VARIABLE_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_AND_VARIABLE_WIND:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_NORTHERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_EASTERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_SOUTHERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_WESTERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_NORTH_EASTERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_SOUTH_EASTERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_SOUTH_WESTERLY:
                        return 0;
                     case WeatherTypes.WIND_ELEMENTS_NORTH_WESTERLY:
                        return 0;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_STORM_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.STORM_ELEMENT_STORM:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_ICE_STORM:
                        return this.SNOW_THUNDER;
                     case WeatherTypes.STORM_ELEMENT_THUNDERSTORM:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_DERECHO:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_FIRESTORM:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_SQUALL:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_TROPICAL_CYCLONE:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_HAILSTORM:
                        return this.SNOW_THUNDER;
                     case WeatherTypes.STORM_ELEMENT_TORNADO:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_HURRICANE:
                        return this.THUNDER;
                     case WeatherTypes.STORM_ELEMENT_DUST_STORM:
                        return 0;
                     case WeatherTypes.STORM_ELEMENT_SAND_STORM:
                        return 0;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_FOG_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.FOG_ELEMENT_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_PATCHY_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_LOCALISED_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_LOW_LYING_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_SHALLOW_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_DENSE_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_FREEZING_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_DENSE_FREEZING_FOG:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_MIST:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_PATCHY_MIST:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_SEA_MIST:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_THINNING:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_THICKENING:
                        return this.FOG;
                     case WeatherTypes.FOG_ELEMENT_DEVELOPING:
                        return this.FOG;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_FROST_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.FROST_ELEMENT_FROST:
                        return 0;
                     case WeatherTypes.FROST_ELEMENT_LIGHT_FROST:
                        return 0;
                     case WeatherTypes.FROST_ELEMENT_GROUND_FROST:
                        return 0;
                     case WeatherTypes.FROST_ELEMENT_HEAVY_FROST:
                        return 0;
                     case WeatherTypes.FROST_ELEMENT_SEVERE_FROST:
                        return 0;
                     case WeatherTypes.FROST_ELEMENT_ICE:
                        return 0;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SUNSHINE_CLOUD:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLEAR_SKY:
                        return this.CLEAR_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_BLUE_SKY:
                        return this.CLEAR_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_FAIR:
                        return this.SOME_CLOUDS_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_SUNNY:
                        return this.CLEAR_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_SUNNY_INTERVALS:
                        return this.SOME_CLOUDS_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_A_FEW_CLOUDS:
                        return this.SOME_CLOUDS_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_PARTLY_CLOUDY:
                        return this.PARTLY_CLOUDY_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDY:
                        return this.CLOUDY_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_VERY_CLOUDY:
                        return this.OVERCAST_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_OVERCAST:
                        return this.OVERCAST_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_DULL:
                        return this.OVERCAST_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_HAZY:
                        return this.MISTY_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDS_DEVELOPING:
                        return this.PARTLY_CLOUDY_DAY;
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDS_DISSOLVING:
                        return this.SOME_CLOUDS_DAY;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_TEMPERATURE_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.TEMPERATURE_ELEMENT_CHILLY:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_COLD:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_FREEZING:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_HOT:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_MILD:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_SCORCHING:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_WARM:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_HUMID:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_HEAT_WAVE:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_HOTTER_THAN_NORMAL:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_COLDER_THAN_NORMAL:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_EXTEREMELY_COLD:
                        return 0;
                     case WeatherTypes.TEMPERATURE_ELEMENT_EXTREMELY_HOT:
                        return 0;
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_HAZARDS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.HAZARD_ELEMENT_BLACK_ICE:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_FLOODING:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_LOCALISED_FLOODING:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_RISK_OF_FLASH_FLOODS:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_STORM_SURGE:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_LANDSLIDES:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_MUDFLOWS:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_SMOKE:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_SMOG:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_ASH_CLOUD:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_DUST:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_SAND:
                        return 0;
                     case WeatherTypes.HAZARD_ELEMENT_DUST_WHIRLS:
                        return 0;
                  }
            }
         }
         Framework.Trace("NavWeatherDetailsScreen.getWeatherIcon(" + element.subTableType + ":" + element.subTableValue + ") Unknown subTableType!");
         return 0;
      }
      
      private function getWeatherElementString(element:Object) : String
      {
         if(Boolean(element.subTableType) && Boolean(element.subTableValue))
         {
            switch(element.subTableType)
            {
               case WeatherTypes.ELEMENT_TYPE_RAIN_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.RAIN_ELEMENT_RAIN:
                        return "Rain";
                     case WeatherTypes.RAIN_ELEMENT_WET:
                        return "Wet";
                     case WeatherTypes.RAIN_ELEMENT_LIGHT_RAIN:
                        return "Light rain";
                     case WeatherTypes.RAIN_ELEMENT_DRIZZLE:
                        return "Drizzle";
                     case WeatherTypes.RAIN_ELEMENT_LIGHT_DRIZZLE:
                        return "Light drizzle";
                     case WeatherTypes.RAIN_ELEMENT_HEAVY_RAIN:
                        return "Heavy rain";
                     case WeatherTypes.RAIN_ELEMENT_SHOWERS:
                        return "Showers";
                     case WeatherTypes.RAIN_ELEMENT_BLUSTERY_SHOWERS:
                        return "Blustery showers";
                     case WeatherTypes.RAIN_ELEMENT_INTERMITTENT_SHOWERS:
                        return "Intermitten showers";
                     case WeatherTypes.RAIN_ELEMENT_THUNDERY_SHOWERS:
                        return "Thundery showers";
                     case WeatherTypes.RAIN_ELEMENT_THUNDERY_RAIN:
                        return "Thundery rain";
                     case WeatherTypes.RAIN_ELEMENT_FREEZING_RAIN:
                        return "Freezing rain";
                     case WeatherTypes.RAIN_ELEMENT_DAMP:
                        return "Damp";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SNOW_ELEMENT:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SNOW_ELEMENTS_SNOW:
                        return "Snow";
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_SNOW:
                        return "Light snow";
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_SNOW_SHOWERS:
                        return "Light snow showers";
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_SHOWERS:
                        return "Snow showers";
                     case WeatherTypes.SNOW_ELEMENTS_HEAVY_SNOW_SHOWERS:
                        return "Heavy snow showers";
                     case WeatherTypes.SNOW_ELEMENTS_DRIFTING_SNOW:
                        return "Drifting snow";
                     case WeatherTypes.SNOW_ELEMENTS_LOW_DRIFTING_SNOW:
                        return "Low drifting snow";
                     case WeatherTypes.SNOW_ELEMENTS_BLOWING_SNOW:
                        return "Blowing snow";
                     case WeatherTypes.SNOW_ELEMENTS_LIGHT_BLOWING_SNOW:
                        return "Light blowing snow";
                     case WeatherTypes.SNOW_ELEMENTS_LOCALIZED_SNOW_SHOWERS:
                        return "Localized snow showers";
                     case WeatherTypes.SNOW_ELEMENTS_BLIZZARD:
                        return "Blizzard";
                     case WeatherTypes.SNOW_ELEMENTS_DIAMOND_DUST:
                        return "Diamond dust";
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_GRAINS:
                        return "Snow grains";
                     case WeatherTypes.SNOW_ELEMENTS_SNOW_CRYZTALS:
                        return "Snow crystals";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SLEET_HAIL_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET_OR_HAIL:
                        return "Sleet or hail";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET:
                        return "Sleet";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LIGHT_SLEET:
                        return "Light sleet";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_SLEET_SHOWERS:
                        return "Sleet showers";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HEAVY_SLEET_SHOWERS:
                        return "Heavy sleet showers";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HAIL:
                        return "Hail";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LIGHT_HAIL:
                        return "Light hail";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HAIL_SHOWERS:
                        return "Hail showers";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_HEAVY_HAIL_SHOWERS:
                        return "Heavy hail showers";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_DAMAGING_HAIL:
                        return "Damaging hail";
                     case WeatherTypes.SLEET_HAIL_ELEMENTS_LARGE_HAIL:
                        return "Large hail";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_WIND_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.WIND_ELEMENTS_CALM:
                        return "Calm";
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_AIR:
                        return "Light air";
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_BREEZE:
                        return "Light breeze";
                     case WeatherTypes.WIND_ELEMENTS_GENTLE_BREEZE:
                        return "Gentle breeze";
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_BREEZE:
                        return "Moderate breeze";
                     case WeatherTypes.WIND_ELEMENTS_FRESH_BREEZE:
                        return "Fresh breeze";
                     case WeatherTypes.WIND_ELEMENTS_STRONG_BREEZE:
                        return "Strong breeze";
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_GALE:
                        return "Moderate gale";
                     case WeatherTypes.WIND_ELEMENTS_GALE:
                        return "Gale";
                     case WeatherTypes.WIND_ELEMENTS_STRING_GALE:
                        return "String gale";
                     case WeatherTypes.WIND_ELEMENTS_STORM:
                        return "Storm";
                     case WeatherTypes.WIND_ELEMENTS_VIOLENT_STORM:
                        return "Violent storm";
                     case WeatherTypes.WIND_ELEMENTS_HURRICANE:
                        return "Hurricane";
                     case WeatherTypes.WIND_ELEMENTS_WINDY:
                        return "Windy";
                     case WeatherTypes.WIND_ELEMENTS_STRONG_WIND:
                        return "String wind";
                     case WeatherTypes.WIND_ELEMENTS_MODERATE_WIND:
                        return "Moderate wind";
                     case WeatherTypes.WIND_ELEMENTS_VERY_STRONG_WIND:
                        return "Very strong wind";
                     case WeatherTypes.WIND_ELEMENTS_BLUSTERY_WIND:
                        return "Blustery wind";
                     case WeatherTypes.WIND_ELEMENTS_VARIABLE_WIND:
                        return "Variable wind";
                     case WeatherTypes.WIND_ELEMENTS_LIGHT_AND_VARIABLE_WIND:
                        return "Light and variable wind";
                     case WeatherTypes.WIND_ELEMENTS_NORTHERLY:
                        return "Northerly";
                     case WeatherTypes.WIND_ELEMENTS_EASTERLY:
                        return "Easterly";
                     case WeatherTypes.WIND_ELEMENTS_SOUTHERLY:
                        return "Southerly";
                     case WeatherTypes.WIND_ELEMENTS_WESTERLY:
                        return "Westerly";
                     case WeatherTypes.WIND_ELEMENTS_NORTH_EASTERLY:
                        return "North easterly";
                     case WeatherTypes.WIND_ELEMENTS_SOUTH_EASTERLY:
                        return "South easterly";
                     case WeatherTypes.WIND_ELEMENTS_SOUTH_WESTERLY:
                        return "South westerly";
                     case WeatherTypes.WIND_ELEMENTS_NORTH_WESTERLY:
                        return "North westerly";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_STORM_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.STORM_ELEMENT_STORM:
                        return "Storm";
                     case WeatherTypes.STORM_ELEMENT_ICE_STORM:
                        return "Ice storm";
                     case WeatherTypes.STORM_ELEMENT_THUNDERSTORM:
                        return "Thunderstorm";
                     case WeatherTypes.STORM_ELEMENT_DERECHO:
                        return "Derecho";
                     case WeatherTypes.STORM_ELEMENT_FIRESTORM:
                        return "Firestorm";
                     case WeatherTypes.STORM_ELEMENT_SQUALL:
                        return "Squall";
                     case WeatherTypes.STORM_ELEMENT_TROPICAL_CYCLONE:
                        return "Tropical cyclone";
                     case WeatherTypes.STORM_ELEMENT_HAILSTORM:
                        return "Hailstorm";
                     case WeatherTypes.STORM_ELEMENT_TORNADO:
                        return "Tornado";
                     case WeatherTypes.STORM_ELEMENT_HURRICANE:
                        return "Hurricane";
                     case WeatherTypes.STORM_ELEMENT_DUST_STORM:
                        return "Dust storm";
                     case WeatherTypes.STORM_ELEMENT_SAND_STORM:
                        return "Sand storm";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_FOG_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.FOG_ELEMENT_FOG:
                        return "Fog";
                     case WeatherTypes.FOG_ELEMENT_PATCHY_FOG:
                        return "Patchy fog";
                     case WeatherTypes.FOG_ELEMENT_LOCALISED_FOG:
                        return "Localised fog";
                     case WeatherTypes.FOG_ELEMENT_LOW_LYING_FOG:
                        return "Low lying fog";
                     case WeatherTypes.FOG_ELEMENT_SHALLOW_FOG:
                        return "Shallow fog";
                     case WeatherTypes.FOG_ELEMENT_DENSE_FOG:
                        return "Dense fog";
                     case WeatherTypes.FOG_ELEMENT_FREEZING_FOG:
                        return "Freezing fog";
                     case WeatherTypes.FOG_ELEMENT_DENSE_FREEZING_FOG:
                        return "Dense freezing fog";
                     case WeatherTypes.FOG_ELEMENT_MIST:
                        return "Mist";
                     case WeatherTypes.FOG_ELEMENT_PATCHY_MIST:
                        return "Patchy mist";
                     case WeatherTypes.FOG_ELEMENT_SEA_MIST:
                        return "Sea mist";
                     case WeatherTypes.FOG_ELEMENT_THINNING:
                        return "Thinning";
                     case WeatherTypes.FOG_ELEMENT_THICKENING:
                        return "Thickening";
                     case WeatherTypes.FOG_ELEMENT_DEVELOPING:
                        return "Developing";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_FROST_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.FROST_ELEMENT_FROST:
                        return "Frost";
                     case WeatherTypes.FROST_ELEMENT_LIGHT_FROST:
                        return "Light frost";
                     case WeatherTypes.FROST_ELEMENT_GROUND_FROST:
                        return "Ground frost";
                     case WeatherTypes.FROST_ELEMENT_HEAVY_FROST:
                        return "Heavy frost";
                     case WeatherTypes.FROST_ELEMENT_SEVERE_FROST:
                        return "Severe frost";
                     case WeatherTypes.FROST_ELEMENT_ICE:
                        return "Ice";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_SUNSHINE_CLOUD:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLEAR_SKY:
                        return "Clear sky";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_BLUE_SKY:
                        return "Blue sky";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_FAIR:
                        return "Fair";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_SUNNY:
                        return "Sunny";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_SUNNY_INTERVALS:
                        return "Sunny intervals";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_A_FEW_CLOUDS:
                        return "A few clouds";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_PARTLY_CLOUDY:
                        return "Partly cloudy";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDY:
                        return "Cloudy";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_VERY_CLOUDY:
                        return "Very cloudy";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_OVERCAST:
                        return "Overcast";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_DULL:
                        return "Dull";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_HAZY:
                        return "Hazy";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDS_DEVELOPING:
                        return "Clouds developing";
                     case WeatherTypes.SUNSHINE_CLOUD_ELEMENT_CLOUDS_DISSOLVING:
                        return "Clouds dissolving";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_TEMPERATURE_ELEMENTS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.TEMPERATURE_ELEMENT_CHILLY:
                        return "Chilly";
                     case WeatherTypes.TEMPERATURE_ELEMENT_COLD:
                        return "Cold";
                     case WeatherTypes.TEMPERATURE_ELEMENT_FREEZING:
                        return "Freezing";
                     case WeatherTypes.TEMPERATURE_ELEMENT_HOT:
                        return "Hot";
                     case WeatherTypes.TEMPERATURE_ELEMENT_MILD:
                        return "Mild";
                     case WeatherTypes.TEMPERATURE_ELEMENT_SCORCHING:
                        return "Scorching";
                     case WeatherTypes.TEMPERATURE_ELEMENT_WARM:
                        return "Warm";
                     case WeatherTypes.TEMPERATURE_ELEMENT_HUMID:
                        return "Humid";
                     case WeatherTypes.TEMPERATURE_ELEMENT_HEAT_WAVE:
                        return "Heat wave";
                     case WeatherTypes.TEMPERATURE_ELEMENT_HOTTER_THAN_NORMAL:
                        return "Hotter than normal";
                     case WeatherTypes.TEMPERATURE_ELEMENT_COLDER_THAN_NORMAL:
                        return "Colder than normal";
                     case WeatherTypes.TEMPERATURE_ELEMENT_EXTEREMELY_COLD:
                        return "Extremely cold";
                     case WeatherTypes.TEMPERATURE_ELEMENT_EXTREMELY_HOT:
                        return "Extremely hot";
                  }
                  break;
               case WeatherTypes.ELEMENT_TYPE_HAZARDS:
                  switch(element.subTableValue)
                  {
                     case WeatherTypes.HAZARD_ELEMENT_BLACK_ICE:
                        return "Black ice";
                     case WeatherTypes.HAZARD_ELEMENT_FLOODING:
                        return "FLooding";
                     case WeatherTypes.HAZARD_ELEMENT_LOCALISED_FLOODING:
                        return "Localised flooding";
                     case WeatherTypes.HAZARD_ELEMENT_RISK_OF_FLASH_FLOODS:
                        return "Risk of flash floods";
                     case WeatherTypes.HAZARD_ELEMENT_STORM_SURGE:
                        return "Storm surge";
                     case WeatherTypes.HAZARD_ELEMENT_LANDSLIDES:
                        return "Landslides";
                     case WeatherTypes.HAZARD_ELEMENT_MUDFLOWS:
                        return "Mudflows";
                     case WeatherTypes.HAZARD_ELEMENT_SMOKE:
                        return "Smoke";
                     case WeatherTypes.HAZARD_ELEMENT_SMOG:
                        return "Smog";
                     case WeatherTypes.HAZARD_ELEMENT_ASH_CLOUD:
                        return "Ash cloud";
                     case WeatherTypes.HAZARD_ELEMENT_DUST:
                        return "Dust";
                     case WeatherTypes.HAZARD_ELEMENT_SAND:
                        return "Sand";
                     case WeatherTypes.HAZARD_ELEMENT_DUST_WHIRLS:
                        return "Dust whirls";
                  }
                  break;
               default:
                  Framework.Trace("NavWeatherDetailsScreen.getWeatherString(" + element.subTableType + ":" + element.subTableValue + ") Unknown subTableType!");
            }
         }
         return "";
      }
      
      public function getProbabilityStringOfElementTypeForDay(elementType:int, data:Object) : String
      {
         var subTables:Array = null;
         var i:int = 0;
         if(data.hasOwnProperty("weatherDefinition") && Boolean(data.weatherDefinition.hasOwnProperty("weatherDescription")))
         {
            subTables = this.getSubTable(data.weatherDefinition.weatherDescription,elementType);
            for(i = 0; i < subTables.length; i++)
            {
               if(subTables[i].subTableType == WeatherTypes.ELEMENT_TYPE_ELEMENT_QUALIFIER_PROBABILITY)
               {
                  return subTables[i].subTableValue + "%";
               }
            }
         }
         return NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NA);
      }
      
      private function getSubTable(table:Array, elementType:int) : Array
      {
         var j:int = 0;
         var breakLoop:Boolean = false;
         var result:Array = new Array();
         for(var i:int = 0; i < table.length; i++)
         {
            if(table[i].subTableType == elementType)
            {
               for(j = i + 1; j < table.length; j++)
               {
                  breakLoop = false;
                  switch(table[j].subTableType)
                  {
                     case WeatherTypes.ELEMENT_TYPE_UNDEFINED_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_RAIN_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_SNOW_ELEMENT:
                     case WeatherTypes.ELEMENT_TYPE_SLEET_HAIL_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_WIND_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_STORM_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_FOG_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_FROST_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_SUNSHINE_CLOUD:
                     case WeatherTypes.ELEMENT_TYPE_TEMPERATURE_ELEMENTS:
                     case WeatherTypes.ELEMENT_TYPE_HAZARDS:
                        breakLoop = true;
                        break;
                     case WeatherTypes.ELEMENT_TYPE_ELEMENT_QUALIFIER:
                     case WeatherTypes.ELEMENT_TYPE_ELEMENT_QUALIFIER_PROBABILITY:
                        result.push(table[j]);
                  }
                  if(breakLoop)
                  {
                     break;
                  }
               }
            }
         }
         return result;
      }
      
      public function getMostRelevantSubTableValue(data:Object) : Object
      {
         var elements:Array = null;
         var i:int = 0;
         var j:int = 0;
         if(data.hasOwnProperty("weatherDefinition") && Boolean(data.weatherDefinition.hasOwnProperty("weatherDescription")))
         {
            elements = data.weatherDefinition.weatherDescription as Array;
            loop0:
            for(i = 0; i < NavGlobalSettingsCommon.LS_WEATHER_ELEMENT_PRIORITY.length; )
            {
               j = 0;
               while(true)
               {
                  if(j >= elements.length)
                  {
                     i++;
                     continue loop0;
                  }
                  if(Boolean(elements[j].hasOwnProperty("subTableType")) && Boolean(elements[j].hasOwnProperty("subTableValue")))
                  {
                     if(NavGlobalSettingsCommon.LS_WEATHER_ELEMENT_PRIORITY[i] == elements[j].subTableType)
                     {
                        if(j >= elements.length + 1 || Boolean(elements[j + 1].hasOwnProperty("subTableType")) && Boolean(elements[j + 1].subTableType != WeatherTypes.ELEMENT_TYPE_ELEMENT_QUALIFIER_PROBABILITY))
                        {
                           break;
                        }
                     }
                  }
                  j++;
               }
               return elements[j];
            }
         }
         return {
            "subTableType":-1,
            "subTableValue":-1
         };
      }
   }
}

