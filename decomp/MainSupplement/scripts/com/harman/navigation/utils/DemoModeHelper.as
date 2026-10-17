package com.harman.navigation.utils
{
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import flash.system.Capabilities;
   
   public class DemoModeHelper
   {
      
      private var mNavService:Navigation;
      
      private var mPositions:Object = new Object();
      
      private var mIsInitialized:Boolean = false;
      
      public function DemoModeHelper(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
      }
      
      public function initDemoModePositionService() : void
      {
         if(!this.mIsInitialized)
         {
            this.readFromPersistence();
            this.mIsInitialized = true;
         }
         this.mNavService.sendEvent(NavigationEvent.DEMO_MODE_POS_LIST_UPDATE);
      }
      
      public function get isInitialized() : Boolean
      {
         return this.mIsInitialized;
      }
      
      public function get list() : Object
      {
         return this.mPositions;
      }
      
      public function renamePosition(coordinate:String, newName:String) : void
      {
         this.mPositions[coordinate] = newName;
         this.sendToPersistence();
         this.mNavService.sendEvent(NavigationEvent.DEMO_MODE_POS_LIST_UPDATE);
      }
      
      public function deletePosition(coordinate:String) : void
      {
         delete this.mPositions[coordinate];
         this.sendToPersistence();
         this.mNavService.sendEvent(NavigationEvent.DEMO_MODE_POS_LIST_UPDATE);
      }
      
      private function sendToPersistence() : void
      {
         if(this.isReadWriteAvailable())
         {
            this.mNavService.writeObjectToFile(NavGlobalSettings.DEMO_MODE_PERSISTENCE_LOCATION,this.mPositions);
         }
      }
      
      private function readFromPersistence() : void
      {
         var readObj:Object = null;
         if(this.isReadWriteAvailable())
         {
            readObj = this.mNavService.readObjectFromFile(NavGlobalSettings.DEMO_MODE_PERSISTENCE_LOCATION);
            if(readObj != null)
            {
               this.mPositions = readObj;
            }
            else
            {
               this.setDefaults();
            }
         }
         else
         {
            this.setDefaults();
         }
      }
      
      private function isReadWriteAvailable() : Boolean
      {
         switch(Capabilities.manufacturer)
         {
            case "QNX":
               return true;
            case "Linux":
            case "Macintosh":
            case "Windows":
         }
         return false;
      }
      
      private function setDefaults() : void
      {
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_CHINA:
               this.mPositions["+113.945884 +22.535699"] = "Shenzhen, China";
               this.mPositions["+121.470934 +31.215581"] = "Shanghai, China";
               break;
            case VServiceGlobalSettings.MARKET_EUROPE:
               this.mPositions["+010.033022 +53.547823"] = "Hamburg, Germany";
               this.mPositions["+009.398242 +52.335071"] = "Bad Nenndorf, Germany";
               this.mPositions["+009.971479 +48.395518"] = "Temic, Ulm, Germany";
               this.mPositions["+008.506323 +48.879822"] = "Ittersbach, Germany";
               this.mPositions["+011.554289 +48.188370"] = "Munich, Germany";
               this.mPositions["+015.481163 +47.007643"] = "Chrysler, Gössendorf, Austria";
               this.mPositions["+007.618280 +45.029743"] = "FCA plant, Turin, Italy";
               this.mPositions["+018.415927 +47.143478"] = "Szekesfehervar, Hungary";
               break;
            case VServiceGlobalSettings.MARKET_JAPAN:
               this.mPositions["+139.827871 +35.698254"] = "5-6-20, Kameido, Koto-ku, Tokyo, Tokyo, Japan 136-0071";
               this.mPositions["+039.795526 +35.676063"] = "Tokyo, Japan";
               this.mPositions["+135.501011 +34.691928"] = "Osaka, Japan";
               this.mPositions["+130.950932 +33.979842"] = "Shimonoseki, Japan";
               break;
            case VServiceGlobalSettings.MARKET_KOREA:
               this.mPositions["+126.979440 +37.566351"] = "Random point in Seoul South Korea";
               this.mPositions["+127.009043 +37.559490"] = "Seoul, Korea";
               break;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               this.mPositions["-083.431027 +42.496383"] = "HB, 12Mile Rd, Farmington Hills, MI ";
               this.mPositions["-083.439961 +42.487971"] = "Country Cousin, Farmington Hills, MI";
               this.mPositions["-083.462961 +42.391210"] = "EB M-14, Plymouth, MI";
               this.mPositions["-083.109027 +42.355083"] = "I-96 towards Detroit";
               this.mPositions["-083.040035 +42.332722"] = "Detroit, DownTown";
               this.mPositions["-083.662961 +42.224410"] = "I-94 by Ann Arbor";
               this.mPositions["-084.468114 +42.028713"] = "IPD Area, Jerome, MI";
               this.mPositions["-084.106117 +44.092516"] = "I-75, Alger, MI";
               this.mPositions["-086.472901 +41.524161"] = "TimeZone change, Walkerton, IN";
               this.mPositions["-087.324083 +41.603182"] = "I-90, Gary, IN";
               this.mPositions["-112.126967 +33.753564"] = "HOV lanes, Phoenix, AZ";
               this.mPositions["-092.067325 +30.246625"] = "Lafayette, LA";
               this.mPositions["-076.612190 +39.174228"] = "Baltimore, ML ";
               break;
            case VServiceGlobalSettings.MARKET_ROW:
               this.mPositions["+039.82630 +021.423846"] = "Mecca, Saudi Arabia";
               this.mPositions["+117.887436 -35.001102"] = "Albany, Australia";
               break;
            case VServiceGlobalSettings.MARKET_UNDEFINED:
         }
      }
   }
}

