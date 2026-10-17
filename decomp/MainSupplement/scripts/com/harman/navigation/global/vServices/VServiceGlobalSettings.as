package com.harman.navigation.global.vServices
{
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.SupportedCountries;
   import com.harman.navigation.enums.VehicleMarkets;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.moduleLinkAPI.VehConfigEvent;
   
   use namespace NavigationNamespace;
   
   public class VServiceGlobalSettings
   {
      
      private static var UNIT_SYSTEM:int = UNIT_SYSTEM_US;
      
      private static var SPEED_UNIT:int = UNIT_SYSTEM_US;
      
      private static var DISTANCE_UNIT:int = UNIT_SYSTEM_US;
      
      private static var NAV_MARKET_CONFIG:int = MARKET_NORTH_AMERICA;
      
      private static var NAV_GEO_COORDINATE_SYSTEM:int = GeoFormats.FORMAT_DMS;
      
      private static var persistenceLoadStatus:int = 0;
      
      private static var mTmcExcludedByDestination:Boolean = false;
      
      public static const UNDEFINED:int = 900;
      
      public static const UNIT_SYSTEM_METRIC:int = 901;
      
      public static const UNIT_SYSTEM_US:int = 902;
      
      public static const UNIT_SYSTEM_IMPERIAL:int = 903;
      
      public static const MARKET_UNDEFINED:int = 905;
      
      public static const MARKET_NORTH_AMERICA:int = 906;
      
      public static const MARKET_EUROPE:int = 907;
      
      public static const MARKET_ROW:int = 908;
      
      public static const MARKET_CHINA:int = 909;
      
      public static const MARKET_JAPAN:int = 910;
      
      public static const MARKET_KOREA:int = 911;
      
      public static const HMI_DISPATCH_TIMEOUT:Number = 1000;
      
      public function VServiceGlobalSettings()
      {
         super();
         PersistenceApi.impl = PersistenceImpl.create();
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.GLOBAL_SETTINGS);
         PersistenceApi.api.loadData(PersistenceKeys.DEST);
      }
      
      public static function getGeoCoordinateSystem() : void
      {
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_GEO_COORDINATE_SYSTEM);
      }
      
      public static function get geoCoordinateSystem() : int
      {
         return NAV_GEO_COORDINATE_SYSTEM;
      }
      
      public static function setGeoCoordinateSystem(system:int) : void
      {
         NAV_GEO_COORDINATE_SYSTEM = system;
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_GEO_COORDINATE_SYSTEM);
         persistData();
      }
      
      public static function getUnitSystem() : void
      {
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
      }
      
      public static function get unitSystem() : int
      {
         return UNIT_SYSTEM;
      }
      
      public static function get distanceUnits() : int
      {
         return DISTANCE_UNIT;
      }
      
      public static function get speedUnits() : int
      {
         return SPEED_UNIT;
      }
      
      public static function setUnitSystem(unit:int) : void
      {
         if(unit >= UNIT_SYSTEM_METRIC && unit <= UNIT_SYSTEM_IMPERIAL)
         {
            UNIT_SYSTEM = unit;
            NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
            persistData();
         }
      }
      
      public static function getNavMarketConfig() : void
      {
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG);
      }
      
      public static function get navMarketConfig() : int
      {
         return NAV_MARKET_CONFIG;
      }
      
      public static function get tmcExcludedByDestination() : Boolean
      {
         return mTmcExcludedByDestination;
      }
      
      private static function persistData() : void
      {
         var obj:Object = new Object();
         obj["Unit"] = UNIT_SYSTEM;
         obj["Dist"] = DISTANCE_UNIT;
         obj["Speed"] = SPEED_UNIT;
         obj["Geo"] = NAV_GEO_COORDINATE_SYSTEM;
         PersistenceApi.api.saveData(PersistenceKeys.GLOBAL_SETTINGS,obj);
      }
      
      public static function isSupportedTMCCountry(country:String) : Boolean
      {
         return SupportedCountries.isSupportedCountry(country,"TMC");
      }
      
      public static function isSupportedSpeedCamCountry(country:String) : Boolean
      {
         return SupportedCountries.isSupportedCountry(country,"SpeedCam");
      }
      
      public static function isSupportedDangerZoneCountry(country:String) : Boolean
      {
         return SupportedCountries.isSupportedCountry(country,"DangerZone");
      }
      
      private function onDistanceUnits(e:PersonalConfigEvent) : void
      {
         switch(NavigationPackage.peripheral.personalConfig.distanceUnits)
         {
            case "km":
               DISTANCE_UNIT = UNIT_SYSTEM_METRIC;
               break;
            case "miles":
            default:
               DISTANCE_UNIT = UNIT_SYSTEM_US;
         }
         persistData();
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
      }
      
      private function onSpeedUnits(e:PersonalConfigEvent) : void
      {
         switch(NavigationPackage.peripheral.personalConfig.speedUnits)
         {
            case "kph":
               SPEED_UNIT = UNIT_SYSTEM_METRIC;
               break;
            case "mph":
            default:
               SPEED_UNIT = UNIT_SYSTEM_US;
         }
         persistData();
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
      }
      
      private function onDisplaUnits(e:PersonalConfigEvent) : void
      {
         switch(NavigationPackage.peripheral.personalConfig.displayUnits)
         {
            case "metric":
               UNIT_SYSTEM = UNIT_SYSTEM_METRIC;
               break;
            case "imperial":
               UNIT_SYSTEM = UNIT_SYSTEM_IMPERIAL;
               break;
            case "us":
            default:
               UNIT_SYSTEM = UNIT_SYSTEM_US;
         }
         this.onSpeedUnits(e);
         this.onDistanceUnits(e);
         Framework.Trace("VServiceGlobalSettings.onDisplaUnits() -> " + UNIT_SYSTEM);
         persistData();
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         var j:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.GLOBAL_SETTINGS)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.GLOBAL_SETTINGS,true);
            if(res != null)
            {
               for(i in res)
               {
                  if(i == "Unit")
                  {
                     UNIT_SYSTEM = int(res[i]);
                     Framework.Trace("VServiceGlobalSettings.onPersistence() -> " + UNIT_SYSTEM);
                     NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
                  }
                  if(i == "Dist")
                  {
                     DISTANCE_UNIT = int(res[i]);
                     NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
                  }
                  if(i == "Speed")
                  {
                     SPEED_UNIT = int(res[i]);
                     NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM);
                  }
                  if(i == "Geo")
                  {
                     NAV_GEO_COORDINATE_SYSTEM = int(res[i]);
                     NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_GEO_COORDINATE_SYSTEM);
                  }
               }
            }
            ++persistenceLoadStatus;
            NavigationPackage.peripheral.personalConfig.addEventListener(PersonalConfigEvent.UNIT,this.onDisplaUnits,false,0,true);
            NavigationPackage.peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISTANCE_UNITS,this.onDistanceUnits,false,0,true);
            NavigationPackage.peripheral.personalConfig.addEventListener(PersonalConfigEvent.SPEED_UNITS,this.onSpeedUnits,false,0,true);
            NavigationPackage.peripheral.personalConfig.getDisplayUnits();
            NavigationPackage.peripheral.vehConfig.addEventListener(VehConfigEvent.AVAILABLE,this.onVehConfigAvailable,false,0,true);
            this.determineTmcAvailabilityDueToDestination();
            this.readMarketConfig();
         }
         else if(PersistenceApi.api.dataLoaded == PersistenceKeys.DEST)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.DEST,true);
            if(res != null)
            {
               for(j in res)
               {
                  if(j == "DEST")
                  {
                     if((NAV_MARKET_CONFIG = VehicleMarkets.getMarket(int(res[j]))) <= 0)
                     {
                        NAV_MARKET_CONFIG = MARKET_NORTH_AMERICA;
                        Framework.Trace("Nav.VServiceGlobalSettings.onMarketConfig() unknown market configuration received -> Fallback to \'MARKET_NORTH_AMERICA\' !");
                        return;
                     }
                     NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG);
                  }
               }
            }
            ++persistenceLoadStatus;
         }
         if(persistenceLoadStatus >= 1)
         {
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      private function readMarketConfig() : void
      {
         Framework.Trace("Nav.GlobalSettings.market (" + NavigationPackage.peripheral.vehConfig.variantMarket + ")");
         switch(NavigationPackage.peripheral.vehConfig.variantMarket)
         {
            case "ECE":
            case "TU":
               NAV_MARKET_CONFIG = MARKET_EUROPE;
               persistData();
               break;
            case "NA":
               NAV_MARKET_CONFIG = MARKET_NORTH_AMERICA;
               persistData();
               break;
            case "ROW":
            case "JP":
            case "AU":
            case "SA":
            case "KR":
            case "CH":
               NAV_MARKET_CONFIG = MARKET_ROW;
               persistData();
         }
         if(NavigationPackage.peripheral.navigation != null)
         {
            NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.GLOBAL_NAV_MARKET_CONFIG);
         }
      }
      
      private function onVehConfigAvailable(e:VehConfigEvent) : void
      {
         this.determineTmcAvailabilityDueToDestination();
      }
      
      private function determineTmcAvailabilityDueToDestination() : void
      {
         switch(int(NavigationPackage.peripheral.vehConfig.vehicleDestination))
         {
            case 4:
            case 14:
               mTmcExcludedByDestination = true;
               break;
            default:
               mTmcExcludedByDestination = false;
         }
      }
   }
}

