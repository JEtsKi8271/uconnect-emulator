package com.nfuzion.moduleLinkAPI
{
   public class MarketConverter
   {
      
      public function MarketConverter()
      {
         super();
      }
      
      public static function getMarketFromDestCode(dest:int) : String
      {
         var NAdestCodes:Array = [2,4,12,14,19,22,24,30,42,52,58,61,77,82,89,102,120,141,159,179,180,181,182,183,188,196,200];
         var EUDestCodes:Array = [3,5,7,8,17,20,21,26,27,28,32,46,51,54,55,56,65,69,70,71,76,80,92,93,95,98,99,100,105,106,109,111,113,116,119,123,126,129,132,133,134,135,136,137,140,148,157,158,161,162,167,171,172,175,177,187,191,192,197,198,199,202,203,205,208,210,218,219,220,221,222,223,224];
         var RWdestCodes:Array = [0,1,9,11,18,23,29,31,33,34,35,36,37,38,39,40,41,43,44,48,49,53,63,64,66,67,68,72,73,74,75,78,79,81,83,84,86,87,91,94,96,97,101,103,104,107,108,110,112,114,115,117,118,121,122,124,125,127,128,130,138,139,142,143,145,146,147,149,150,152,155,156,160,163,164,165,166,168,169,170,173,174,178,184,185,186,189,193,194,195,201,204,206,209,212,213,214,215,217];
         var SAdestCodes:Array = [13,15,25,45,47,50,59,60,62,85,88,90,144,151,153,154,207,211];
         var AUdestCodes:Array = [10];
         var JPdestCodes:Array = [6];
         var KRdestCodes:Array = [176,190];
         var CHdestCodes:Array = [16];
         if(NAdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.NORTH_AMERICA;
         }
         if(EUDestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.EUROPE;
         }
         if(RWdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.ROW;
         }
         if(SAdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.SOUTH_AMERICA;
         }
         if(AUdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.AUSTRALIA;
         }
         if(JPdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.JAPAN;
         }
         if(KRdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.KOREA;
         }
         if(CHdestCodes.indexOf(dest) != -1)
         {
            return TunerRegion.CHINA;
         }
         return TunerRegion.NORTH_AMERICA;
      }
      
      public static function convertAbbrevMarket(abbrev:String) : String
      {
         switch(abbrev)
         {
            case "ECE":
               return TunerRegion.EUROPE;
            case "NA":
               return TunerRegion.NORTH_AMERICA;
            case "ROW":
               return TunerRegion.ROW;
            case "CH":
               return TunerRegion.CHINA;
            case "KR":
               return TunerRegion.KOREA;
            case "SA":
               return TunerRegion.SOUTH_AMERICA;
            case "AUS":
               return TunerRegion.AUSTRALIA;
            case "JP":
               return TunerRegion.JAPAN;
            default:
               return TunerRegion.NORTH_AMERICA;
         }
      }
   }
}

