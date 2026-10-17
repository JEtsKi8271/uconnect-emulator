package com.harman.navigation.global.vServices
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.GeoCoordinateTransformer;
   import com.harman.navigation.utils.LocationDescription;
   import flash.text.TextField;
   import flash.utils.describeType;
   
   public class VServiceHmiUtils
   {
      
      public function VServiceHmiUtils()
      {
         super();
      }
      
      public static function performDoubleQuoteCheck(input:String) : String
      {
         return input.split("\"").join("\\\"");
      }
      
      public function getOneLineDescriptionJpn(description:LocationDescription) : String
      {
         return "";
      }
      
      public function getOneLineDescription(description:LocationDescription) : String
      {
         var str:String = "";
         if(description.getSecondaryLocation().getCustomName() != "")
         {
            str = description.getSecondaryLocation().getCustomName();
         }
         else if(description.getPrimaryLocation().getCustomName() != "")
         {
            str = description.getPrimaryLocation().getCustomName();
         }
         else if(description.getSecondaryLocation().isPOI() == true)
         {
            str = description.getSecondaryLocation().getType("<POI>");
         }
         else if(description.getPrimaryLocation().getType("<CTY>") == "")
         {
            if(this.checkForGeoEntry(description) == true)
            {
               str += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(description.getPrimaryLocation().getType("<GEO>")) + " ";
            }
            else
            {
               switch(VServiceGlobalSettings.navMarketConfig)
               {
                  case VServiceGlobalSettings.MARKET_EUROPE:
                  case VServiceGlobalSettings.MARKET_ROW:
                     if(description.getSecondaryLocation().getType("<STR>") != "")
                     {
                        str += description.getSecondaryLocation().getType("<STR>") + " ";
                     }
                     if(description.getSecondaryLocation().getType("<HNO>") != "")
                     {
                        str += description.getSecondaryLocation().getType("<HNO>") + " ";
                     }
                     break;
                  case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
                  default:
                     if(description.getSecondaryLocation().getType("<HNO>") != "")
                     {
                        str += description.getSecondaryLocation().getType("<HNO>") + " ";
                     }
                     if(description.getSecondaryLocation().getType("<STR>") != "")
                     {
                        str += description.getSecondaryLocation().getType("<STR>") + ", ";
                     }
               }
               if(description.getSecondaryLocation().getType("<ITR>") != "")
               {
                  str = str.slice(0,str.length - 2);
                  str += " x " + description.getSecondaryLocation().getType("<ITR>") + ", ";
               }
               if(description.getSecondaryLocation().getType("<CTY>") != "")
               {
                  str += description.getSecondaryLocation().getType("<CTY>") + ", ";
               }
               if(description.getSecondaryLocation().getType("<SAB>") != "")
               {
                  str += description.getSecondaryLocation().getType("<SAB>") + " ";
               }
               else if(description.getSecondaryLocation().getType("<STA>") != "")
               {
                  str += description.getSecondaryLocation().getType("<STA>") + " ";
               }
               if(description.getSecondaryLocation().getType("<CAB>") != "")
               {
                  str += description.getSecondaryLocation().getType("<CAB>") + " ";
               }
               else if(description.getSecondaryLocation().getType("<CTR>") != "")
               {
                  str += description.getSecondaryLocation().getType("<CTR>") + " ";
               }
               if(str == "")
               {
                  str += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(description.getPrimaryLocation().getType("<GEO>"));
               }
            }
         }
         else if(this.checkForGeoEntry(description) == true)
         {
            str += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(description.getPrimaryLocation().getType("<GEO>")) + " ";
         }
         else
         {
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(description.getPrimaryLocation().getType("<STR>") != "")
                  {
                     str += description.getPrimaryLocation().getType("<STR>") + " ";
                  }
                  if(description.getPrimaryLocation().getType("<HNO>") != "")
                  {
                     str += description.getPrimaryLocation().getType("<HNO>") + " ";
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(description.getPrimaryLocation().getType("<HNO>") != "")
                  {
                     str += description.getPrimaryLocation().getType("<HNO>") + " ";
                  }
                  if(description.getPrimaryLocation().getType("<STR>") != "")
                  {
                     str += description.getPrimaryLocation().getType("<STR>") + ", ";
                  }
            }
            if(description.getPrimaryLocation().getType("<ITR>") != "")
            {
               str = str.slice(0,str.length - 2);
               str += " x " + description.getPrimaryLocation().getType("<ITR>") + ", ";
            }
            if(description.getPrimaryLocation().getType("<CTY>") != "")
            {
               str += description.getPrimaryLocation().getType("<CTY>") + ", ";
            }
            if(description.getPrimaryLocation().getType("<SAB>") != "")
            {
               str += description.getPrimaryLocation().getType("<SAB>") + " ";
            }
            else if(description.getSecondaryLocation().getType("<SAB>") != "")
            {
               str += description.getSecondaryLocation().getType("<SAB>") + " ";
            }
            else if(description.getPrimaryLocation().getType("<STA>") != "")
            {
               str += description.getPrimaryLocation().getType("<STA>") + " ";
            }
            if(description.getPrimaryLocation().getType("<CAB>") != "")
            {
               str += description.getPrimaryLocation().getType("<CAB>") + " ";
            }
            else if(description.getPrimaryLocation().getType("<CTR>") != "")
            {
               str += description.getPrimaryLocation().getType("<CTR>") + " ";
            }
            if(str == "")
            {
               str += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(description.getPrimaryLocation().getType("<GEO>"));
            }
         }
         return str;
      }
      
      public function getMultiLineDescription(loc:LocationDescription) : String
      {
         var tmp:String = null;
         var address:String = "";
         if(loc.getSecondaryLocation().isPOI())
         {
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getSecondaryLocation().getType("<STR>") + " ";
                  }
                  if(loc.getSecondaryLocation().getType("<HNO>") != "" && loc.getSecondaryLocation().getType("<STR>") != "" && loc.getSecondaryLocation().getType("<ITR>") == "")
                  {
                     address += " " + loc.getSecondaryLocation().getType("<HNO>");
                  }
                  address += "\n";
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getSecondaryLocation().getType("<HNO>") != "" && loc.getSecondaryLocation().getType("<STR>") != "" && loc.getSecondaryLocation().getType("<ITR>") == "")
                  {
                     address = loc.getSecondaryLocation().getType("<HNO>") + "\n";
                  }
                  if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STR>") + "\n";
                  }
            }
            if(loc.getSecondaryLocation().getType("<ITR>") != "")
            {
               address += this.calcInterSectionSymbolPosition(loc.getSecondaryLocation().getType("<STR>"),loc.getSecondaryLocation().getType("<ITR>"));
               address += loc.getSecondaryLocation().getType("<ITR>") + "\n";
            }
            if(loc.getSecondaryLocation().getType("<CTY>") != "")
            {
               address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
            }
            if(loc.getSecondaryLocation().getType("<STA>") != "")
            {
               address += loc.getSecondaryLocation().getType("<STA>") + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
            }
         }
         else
         {
            if(loc.getPrimaryLocation().getCustomName() != "")
            {
               tmp = loc.getPrimaryLocation().getCustomName();
               tmp = tmp.slice(tmp.indexOf(" ") + 1,tmp.length - 1) + " " + tmp.slice(0,tmp.indexOf(" ") - 1);
               if(tmp == loc.getPrimaryLocation().getType("<GEO>"))
               {
                  address += tmp.slice(tmp.indexOf(" ") + 1,tmp.length) + "\n" + tmp.slice(0,tmp.indexOf(" ")) + "\n";
               }
               else
               {
                  address += loc.getPrimaryLocation().getCustomName() + "\n";
               }
            }
            else if(this.checkForGeoEntry(loc) == true)
            {
               address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getPrimaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getPrimaryLocation().getType("<STR>") + "";
                  }
                  else if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getSecondaryLocation().getType("<STR>") + "";
                     if(loc.getPrimaryLocation().getType("<HNO>") != "")
                     {
                        address += " " + loc.getPrimaryLocation().getType("<HNO>");
                     }
                  }
                  if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
                  {
                     address += " " + loc.getPrimaryLocation().getType("<HNO>");
                  }
                  address += "\n";
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
                  {
                     address = loc.getPrimaryLocation().getType("<HNO>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<STR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STR>") + "\n";
                  }
            }
            if(loc.getSecondaryLocation().getType("<ITR>") != "")
            {
               address += this.calcInterSectionSymbolPosition(loc.getSecondaryLocation().getType("<STR>"),loc.getSecondaryLocation().getType("<ITR>"));
               address += loc.getSecondaryLocation().getType("<ITR>") + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getPrimaryLocation().getType("<ZIP>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<ZIP>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<CTY>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTY>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTY>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
                  }
                  if(loc.getSecondaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STA>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<STA>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STA>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getPrimaryLocation().getType("<CTY>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTY>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTY>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
                  }
                  if(loc.getSecondaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STA>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<STA>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<STA>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STA>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<ZIP>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<ZIP>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
            }
            if(address == "")
            {
               if(loc.getPrimaryLocation().getType("<GEO>") != "")
               {
                  address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n";
               }
               else if(loc.getSecondaryLocation().getType("<GEO>") != "")
               {
                  address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getSecondaryLocation().getType("<GEO>"),true) + "\n";
               }
            }
         }
         return address;
      }
      
      public function getMultiLineDescriptionWithGeo(loc:LocationDescription) : String
      {
         var address:String = "";
         if(loc.getSecondaryLocation().isPOI())
         {
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getSecondaryLocation().getType("<STR>") + " ";
                  }
                  if(loc.getSecondaryLocation().getType("<HNO>") != "" && loc.getSecondaryLocation().getType("<STR>") != "" && loc.getSecondaryLocation().getType("<ITR>") == "")
                  {
                     address += loc.getSecondaryLocation().getType("<HNO>");
                  }
                  address += "\n";
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getSecondaryLocation().getType("<HNO>") != "" && loc.getSecondaryLocation().getType("<STR>") != "" && loc.getSecondaryLocation().getType("<ITR>") == "")
                  {
                     address = loc.getSecondaryLocation().getType("<HNO>") + "\n";
                  }
                  if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STR>") + "\n";
                  }
            }
            if(loc.getSecondaryLocation().getType("<ITR>") != "")
            {
               address += loc.getSecondaryLocation().getType("<ITR>") + "\n";
            }
            if(loc.getSecondaryLocation().getType("<CTY>") != "")
            {
               address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
            }
            if(loc.getSecondaryLocation().getType("<STA>") != "")
            {
               address += loc.getSecondaryLocation().getType("<STA>") + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
            }
         }
         else
         {
            if(this.checkForGeoEntry(loc) == true)
            {
               address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getPrimaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getPrimaryLocation().getType("<STR>") + "";
                  }
                  else if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address = loc.getSecondaryLocation().getType("<STR>") + "";
                  }
                  if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
                  {
                     address += loc.getPrimaryLocation().getType("<HNO>");
                  }
                  address += "\n";
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
                  {
                     address = loc.getPrimaryLocation().getType("<HNO>") + "\n";
                  }
                  if(loc.getPrimaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<STR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<STR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<STR>") + "\n";
                  }
            }
            if(loc.getPrimaryLocation().getType("<ITR>") != "")
            {
               address += loc.getPrimaryLocation().getType("<ITR>") + "\n";
            }
            if(loc.getPrimaryLocation().getType("<CTY>") != "")
            {
               address += loc.getPrimaryLocation().getType("<CTY>") + "\n";
            }
            else if(loc.getSecondaryLocation().getType("<CTY>") != "")
            {
               address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
            }
            if(loc.getSecondaryLocation().getType("<STA>") != "")
            {
               address += loc.getSecondaryLocation().getType("<STA>") + "\n";
            }
            else if(loc.getPrimaryLocation().getType("<STA>") != "")
            {
               address += loc.getPrimaryLocation().getType("<STA>") + "\n";
            }
            else if(loc.getSecondaryLocation().getType("<STA>") != "")
            {
               address += loc.getSecondaryLocation().getType("<STA>") + "\n";
            }
            switch(VServiceGlobalSettings.navMarketConfig)
            {
               case VServiceGlobalSettings.MARKET_EUROPE:
               case VServiceGlobalSettings.MARKET_ROW:
                  if(loc.getPrimaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  break;
               case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               default:
                  if(loc.getPrimaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CAB>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
                  }
                  else if(loc.getPrimaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getPrimaryLocation().getType("<CTR>") + "\n";
                  }
                  else if(loc.getSecondaryLocation().getType("<CTR>") != "")
                  {
                     address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
                  }
            }
         }
         if(loc.getPrimaryLocation().getType("<GEO>") != "")
         {
            address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n";
         }
         else if(loc.getSecondaryLocation().getType("<GEO>") != "")
         {
            address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getSecondaryLocation().getType("<GEO>"),true) + "\n";
         }
         return address;
      }
      
      public function getMultiLineDescriptionAllInfo(loc:LocationDescription, highwayExit:String = null) : String
      {
         var address:String = "";
         if(this.checkForGeoEntry(loc) == true)
         {
            return address + (GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n");
         }
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
            case VServiceGlobalSettings.MARKET_ROW:
               if(loc.getPrimaryLocation().getType("<STR>") != "")
               {
                  address = loc.getPrimaryLocation().getType("<STR>") + "\n";
               }
               else if(loc.getSecondaryLocation().getType("<STR>") != "")
               {
                  address = loc.getSecondaryLocation().getType("<STR>") + "\n";
               }
               if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
               {
                  address += " " + loc.getPrimaryLocation().getType("<HNO>") + "\n";
               }
               address += "\n";
               break;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
            default:
               if(loc.getPrimaryLocation().getType("<HNO>") != "" && loc.getPrimaryLocation().getType("<STR>") != "" && loc.getPrimaryLocation().getType("<ITR>") == "")
               {
                  address = loc.getPrimaryLocation().getType("<HNO>") + "\n";
               }
               if(loc.getPrimaryLocation().getType("<STR>") != "")
               {
                  address += loc.getPrimaryLocation().getType("<STR>") + "\n";
               }
               else if(loc.getSecondaryLocation().getType("<STR>") != "")
               {
                  address += loc.getSecondaryLocation().getType("<STR>") + "\n";
               }
         }
         if(loc.getPrimaryLocation().getType("<ITR>") != "")
         {
            address += loc.getPrimaryLocation().getType("<ITR>") + "\n";
         }
         if(loc.getPrimaryLocation().getType("<CTY>") != "")
         {
            address += loc.getPrimaryLocation().getType("<CTY>") + "\n";
         }
         else if(loc.getSecondaryLocation().getType("<CTY>") != "")
         {
            address += loc.getSecondaryLocation().getType("<CTY>") + "\n";
         }
         if(loc.getSecondaryLocation().getType("<STA>") != "")
         {
            address += loc.getSecondaryLocation().getType("<STA>") + "\n";
         }
         else if(loc.getPrimaryLocation().getType("<STA>") != "")
         {
            address += loc.getPrimaryLocation().getType("<STA>") + "\n";
         }
         else if(loc.getSecondaryLocation().getType("<STA>") != "")
         {
            address += loc.getSecondaryLocation().getType("<STA>") + "\n";
         }
         if(loc.getPrimaryLocation().getType("<CAB>") != "")
         {
            address += loc.getPrimaryLocation().getType("<CAB>") + "\n";
         }
         else if(loc.getSecondaryLocation().getType("<CAB>") != "")
         {
            address += loc.getSecondaryLocation().getType("<CAB>") + "\n";
         }
         else if(loc.getPrimaryLocation().getType("<CTR>") != "")
         {
            address += loc.getPrimaryLocation().getType("<CTR>") + "\n";
         }
         else if(loc.getSecondaryLocation().getType("<CTR>") != "")
         {
            address += loc.getSecondaryLocation().getType("<CTR>") + "\n";
         }
         if(highwayExit != null)
         {
            if(highwayExit.length > 0)
            {
               address += "\n" + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NEXT) + ":\n";
               address += highwayExit + "\n";
            }
         }
         else if(loc.getPrimaryLocation().getType("<HWY>") != "1")
         {
            if(loc.getPrimaryLocation().getType("<ITRN>") != "")
            {
               address += "\n" + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_NEXT) + ":\n";
               address += loc.getPrimaryLocation().getType("<ITRN>") + "\n";
            }
            if(loc.getPrimaryLocation().getType("<ITRL>") != "")
            {
               address += "\n" + NavigationPackage.peripheral.localeEngine.getText(NavigationPackage.translations.STRB_PREVIOUS) + ":\n";
               address += loc.getPrimaryLocation().getType("<ITRL>") + "\n";
            }
         }
         var counter:int = 0;
         for(var i:int = 0; i < address.length; i++)
         {
            if(address.charAt(i) == "\n")
            {
               counter++;
            }
         }
         if(counter < 8)
         {
            address += "\n";
         }
         if(counter <= 9)
         {
            if(loc.getPrimaryLocation().getType("<GEO>") != "")
            {
               address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getPrimaryLocation().getType("<GEO>"),true) + "\n";
            }
            else if(loc.getSecondaryLocation().getType("<GEO>") != "")
            {
               address += GeoCoordinateTransformer.transformGeoTagToCurrentSystem(loc.getSecondaryLocation().getType("<GEO>"),true) + "\n";
            }
         }
         return address;
      }
      
      public function getManeuverIcon(maneuverType:int, maneuverDirection:int) : int
      {
         switch(maneuverType)
         {
            case 0:
            case 1:
               return 0;
            case 3:
            case 4:
            case 5:
               return 5;
            case 2:
            case 6:
            case 7:
               if(maneuverDirection >= 240 || maneuverDirection < 16)
               {
                  return 13;
               }
               if(maneuverDirection < 48)
               {
                  return 14;
               }
               if(maneuverDirection < 80)
               {
                  return 15;
               }
               if(maneuverDirection < 112)
               {
                  return 16;
               }
               if(maneuverDirection < 144)
               {
                  return 9;
               }
               if(maneuverDirection < 176)
               {
                  return 10;
               }
               if(maneuverDirection < 208)
               {
                  return 11;
               }
               if(maneuverDirection < 240)
               {
                  return 12;
               }
            case 8:
            case 9:
            case 10:
               return 0;
            case 11:
               return 2;
            case 12:
               if(maneuverDirection < 128)
               {
                  return 3;
               }
               return 4;
               break;
            case 17:
            case 18:
            case 19:
            case 20:
            case 32:
            case 33:
               if(maneuverDirection < 128)
               {
                  return 92;
               }
               return 93;
               break;
            case 129:
            case 13:
            case 14:
               if(maneuverDirection < 43)
               {
                  return 92;
               }
               if(maneuverDirection < 85)
               {
                  return 91;
               }
               if(maneuverDirection < 128)
               {
                  return 90;
               }
               if(maneuverDirection < 171)
               {
                  return 95;
               }
               if(maneuverDirection < 213)
               {
                  return 94;
               }
               return 93;
               break;
            case 15:
               return 93;
            case 16:
               return 92;
            case 21:
            case 23:
            case 26:
               if(maneuverDirection >= 240 || maneuverDirection < 16)
               {
                  return 28;
               }
               if(maneuverDirection < 48)
               {
                  return 29;
               }
               if(maneuverDirection < 80)
               {
                  return 30;
               }
               if(maneuverDirection < 112)
               {
                  return 31;
               }
               if(maneuverDirection < 144)
               {
                  return 32;
               }
               if(maneuverDirection < 176)
               {
                  return 25;
               }
               if(maneuverDirection < 208)
               {
                  return 26;
               }
               if(maneuverDirection < 240)
               {
                  return 27;
               }
            case 22:
            case 24:
            case 27:
               if(maneuverDirection >= 240 || maneuverDirection < 16)
               {
                  return 20;
               }
               if(maneuverDirection < 48)
               {
                  return 19;
               }
               if(maneuverDirection < 80)
               {
                  return 18;
               }
               if(maneuverDirection < 112)
               {
                  return 17;
               }
               if(maneuverDirection < 144)
               {
                  return 24;
               }
               if(maneuverDirection < 176)
               {
                  return 23;
               }
               if(maneuverDirection < 208)
               {
                  return 22;
               }
               if(maneuverDirection < 240)
               {
                  return 21;
               }
               break;
            case 25:
               break;
            case 28:
            case 29:
            case 30:
            case 31:
               return 5;
            case 34:
               return 8;
            case 35:
               return 8;
            case 130:
               return 8;
            default:
               return 0;
         }
         if(maneuverDirection < 128)
         {
            return 96;
         }
         return 97;
      }
      
      public function getCompassTextBundle(direction:String) : uint
      {
         switch(direction)
         {
            case "N":
               return NavigationPackage.translations.STRB_GEO_NORTH;
            case "NE":
               return NavigationPackage.translations.STRB_GEO_NORTH_EAST;
            case "NW":
               return NavigationPackage.translations.STRB_GEO_NORTH_WEST;
            case "E":
               return NavigationPackage.translations.STRB_GEO_EAST;
            case "W":
               return NavigationPackage.translations.STRB_GEO_WEST;
            case "S":
               return NavigationPackage.translations.STRB_GEO_SOUTH;
            case "SE":
               return NavigationPackage.translations.STRB_GEO_SOUTH_EAST;
            case "SW":
               return NavigationPackage.translations.STRB_GEO_SOUTH_WEST;
            default:
               return NavigationPackage.translations.STRB_NA;
         }
      }
      
      public function cloneTextField(textField:TextField, replace:Boolean = false) : TextField
      {
         var item:XML = null;
         var clone:TextField = new TextField();
         var description:XML = describeType(textField);
         for each(item in description.accessor)
         {
            if(item.@access != "readonly")
            {
               try
               {
                  clone[item.@name] = textField[item.@name];
               }
               catch(error:Error)
               {
               }
            }
         }
         clone.defaultTextFormat = textField.getTextFormat();
         if(Boolean(textField.parent) && replace)
         {
            textField.parent.addChild(clone);
            textField.parent.removeChild(textField);
         }
         return clone;
      }
      
      private function checkForGeoEntry(loc:LocationDescription) : Boolean
      {
         if(loc.getPrimaryLocation().getType("<GEO>") != "")
         {
            if(loc.getPrimaryLocation().getType("<STR>") == "" && loc.getPrimaryLocation().getType("<HNO>") == "" && loc.getPrimaryLocation().getType("<STR>") == "" && loc.getPrimaryLocation().getType("<ITR>") == "" && loc.getPrimaryLocation().getType("<CTY>") == "" && loc.getPrimaryLocation().getType("<STA>") == "" && loc.getPrimaryLocation().getType("<SAB>") == "")
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      private function calcInterSectionSymbolPosition(street_1:String, street_2:String) : String
      {
         var erg:String = "";
         var pos:int = (street_1.length + street_2.length) / 4;
         for(var i:int = 0; i < pos; i++)
         {
            erg += " ";
         }
         return erg + "x\n";
      }
   }
}

