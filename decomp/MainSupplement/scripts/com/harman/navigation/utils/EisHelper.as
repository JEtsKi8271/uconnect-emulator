package com.harman.navigation.utils
{
   public class EisHelper
   {
      
      private static const EIS_TXT:String = "<TXT>";
      
      public function EisHelper()
      {
         super();
      }
      
      public static function getValueFromEisPair(eisPair:String) : String
      {
         return eisPair.substring(eisPair.indexOf(">") + 1,eisPair.indexOf("<*>"));
      }
      
      public static function getTypeFromEisPair(eisPair:String) : String
      {
         return eisPair.substring(eisPair.indexOf("<") + 1,eisPair.indexOf(">"));
      }
      
      public static function getLastTypeFromEisString(eisString:String) : String
      {
         var ret:String = null;
         var begin:int = eisString.lastIndexOf("<*><") + 4;
         ret = eisString.substr(begin,eisString.length - begin);
         return ret.substr(0,ret.indexOf(">"));
      }
      
      public static function getLastValueFromEisString(eisString:String) : String
      {
         var ret:String = null;
         ret = eisString.substring(0,eisString.lastIndexOf("<*>"));
         return ret.substring(ret.lastIndexOf(">") + 1,ret.length);
      }
      
      public static function getValueOfType(eisString:String, eisType:String, searchFromStart:Boolean = true) : String
      {
         var erg:String = "";
         if(eisString.indexOf(eisType) == -1)
         {
            return erg;
         }
         if(searchFromStart)
         {
            erg = eisString.substr(eisString.indexOf(eisType) + eisType.length,eisString.length);
         }
         else
         {
            erg = eisString.substr(eisString.lastIndexOf(eisType) + eisType.length,eisString.length);
         }
         return erg.substr(0,erg.indexOf("<*>"));
      }
      
      public static function extractTextStringForTags(inputString:String, requestedTags:Array) : String
      {
         var eisType:String = null;
         var i:int = 0;
         var tmp:String = null;
         var foundString:String = null;
         var input:String = inputString;
         var result:String = "";
         while(input.length > 0)
         {
            if(input.indexOf("<") > 0)
            {
               input = input.substring(input.indexOf("<"),input.length);
            }
            eisType = input.substring(input.indexOf("<"),input.indexOf(">") + 1);
            for(i = 0; i < requestedTags.length; i++)
            {
               if(eisType == requestedTags[i])
               {
                  foundString = input.substring(input.indexOf(">") + 1,input.indexOf("<*>"));
                  if(result.length > 0)
                  {
                     result += ", ";
                  }
                  while(foundString.indexOf("%s") != -1)
                  {
                     if(input.indexOf(EIS_TXT) != -1)
                     {
                        foundString = foundString.replace("%s",getValueOfType(input,EIS_TXT,true));
                        input = input.replace(EIS_TXT + getValueOfType(input,EIS_TXT,true) + "<*>","");
                     }
                     else
                     {
                        foundString = foundString.replace("%s","");
                     }
                  }
                  result += foundString;
               }
            }
            tmp = eisType + input.substring(input.indexOf(">") + 1,input.indexOf("<*>")) + "<*>";
            input = input.replace(eisType + input.substring(input.indexOf(">") + 1,input.indexOf("<*>")) + "<*>","");
         }
         return result;
      }
   }
}

