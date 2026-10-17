package com.harman.navigation.enums
{
   public class SortOption
   {
      
      public static const DEFAULT:int = 0;
      
      public static const ASCENDING:int = 1 << 0;
      
      public static const DESCENDING:int = 1 << 1;
      
      public static const NEAR_FIRST:int = 1 << 2;
      
      public static const FAR_FIRST:int = 1 << 3;
      
      public function SortOption()
      {
         super();
      }
      
      public static function toEisString(option:int) : String
      {
         var erg:String = "";
         switch(option)
         {
            case DEFAULT:
               return "defaultSort";
            case ASCENDING:
               return "ascending";
            case DESCENDING:
               return "descending";
            case NEAR_FIRST:
               return "nearFirst";
            case FAR_FIRST:
               return "farFirst";
            default:
               return "defaultSort";
         }
      }
   }
}

