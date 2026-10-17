package com.harman.navigation.enums
{
   import com.harman.navigation.global.NavigationPackage;
   
   public class PoiPresets
   {
      
      public static const POI_PRESET_FIRE_DEPARTMENT:String = "FireDepartment";
      
      public static const POI_PRESET_HOSPITAL:String = "Hospital";
      
      public static const POI_PRESET_POLICE:String = "Police";
      
      public static const POI_PRESET_GAS_STATIONS:String = "Gas Stations";
      
      public static const POI_PRESET_RESTAURANTS:String = "CMC_Food";
      
      public static const POI_PRESET_FUEL:String = "CMC_Fuel";
      
      public static const POI_PRESET_BANKS:String = "CMC_ATM_Banks";
      
      public static const POI_PRESET_HOTELS:String = "CMC_Hotels";
      
      public static const POI_PRESET_SPORTS:String = "CMC_Sports";
      
      public static const POI_PRESET_ALL:String = "All";
      
      public static const POI_PRESET_STORE:String = "ConvenienceStore";
      
      public static const POI_PRESET_PARKING:String = "Parking";
      
      public function PoiPresets()
      {
         super();
      }
      
      public static function getLocalTextFor(preset:String) : uint
      {
         switch(preset)
         {
            case POI_PRESET_GAS_STATIONS:
               return NavigationPackage.translations.STRB_MENU_GAS_STATIONS;
            case POI_PRESET_HOTELS:
               return NavigationPackage.translations.STRB_MENU_HOTELS_MOTELS;
            case POI_PRESET_SPORTS:
               return NavigationPackage.translations.STRB_MENU_GOLF_SPORTS;
            case POI_PRESET_BANKS:
               return NavigationPackage.translations.STRB_MENU_ATM_BANKING;
            case POI_PRESET_RESTAURANTS:
               return NavigationPackage.translations.STRB_MENU_RESTAURANTS;
            case POI_PRESET_ALL:
               return NavigationPackage.translations.STRB_MENU_ALL_POIS;
            case POI_PRESET_HOSPITAL:
               return NavigationPackage.translations.STRB_HOSPITAL;
            case POI_PRESET_POLICE:
               return NavigationPackage.translations.STRB_POLICE;
            case POI_PRESET_FIRE_DEPARTMENT:
               return NavigationPackage.translations.STRB_FIRE_DEPARTMENT;
            case POI_PRESET_STORE:
               return NavigationPackage.translations.STRB_CONVENIENCE_STORE;
            case POI_PRESET_PARKING:
               return NavigationPackage.translations.STRB_PARKING;
            default:
               return NavigationPackage.translations.STRB_UNDEFINED;
         }
      }
   }
}

