package com.harman.navigation.enums
{
   public class PoiSearchArea
   {
      
      public static const UNDEFINED:int = 0;
      
      public static const AROUND_ME:int = 1;
      
      public static const IN_A_CITY:int = 2;
      
      public static const NEAR_DESTINATION:int = 3;
      
      public static const ALONG_ROUTE:int = 4;
      
      public function PoiSearchArea()
      {
         super();
      }
      
      public static function toString(poiSearchArea:int) : String
      {
         switch(poiSearchArea)
         {
            case UNDEFINED:
               return "Undefined";
            case AROUND_ME:
               return "Around Me";
            case IN_A_CITY:
               return "In a City";
            case NEAR_DESTINATION:
               return "Near Destination";
            case ALONG_ROUTE:
               return "Along Route";
            default:
               return "Unknown";
         }
      }
   }
}

