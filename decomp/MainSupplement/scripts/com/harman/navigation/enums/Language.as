package com.harman.navigation.enums
{
   public class Language
   {
      
      public static const LangUndef:int = 0;
      
      public static const LangDansk:int = 1;
      
      public static const LangGerman:int = 2;
      
      public static const LangEngGB:int = 3;
      
      public static const LangEngUS:int = 4;
      
      public static const LangSpanish:int = 5;
      
      public static const LangSpanishUS:int = 6;
      
      public static const LangFrench:int = 7;
      
      public static const LangItalian:int = 8;
      
      public static const LangNetherlands:int = 9;
      
      public static const LangPortuguese:int = 10;
      
      public static const LangSwedish:int = 11;
      
      public static const LangTurkish:int = 12;
      
      public static const LangFlemish:int = 13;
      
      public static const LangArabic:int = 14;
      
      public static const LangChineseTraditional:int = 15;
      
      public static const LangChineseSimple:int = 16;
      
      public static const LangKorean:int = 17;
      
      public static const LangJapanese:int = 18;
      
      public static const LangBrazilianPortuguese:int = 19;
      
      public static const LangFrenchCanadian:int = 20;
      
      public static const LangFinnish:int = 21;
      
      public static const LangGreek:int = 22;
      
      public static const LangNorwegian:int = 23;
      
      public static const LangPolish:int = 24;
      
      public static const LangRussian:int = 25;
      
      public function Language()
      {
         super();
      }
      
      public static function toString(id:int) : String
      {
         switch(id)
         {
            case 0:
               return "Undefined";
            case 1:
               return "Danish";
            case 2:
               return "German";
            case 3:
               return "British English";
            case 4:
               return "US English";
            case 5:
               return "Spanish";
            case 6:
               return "US/NA Spanish";
            case 7:
               return "French";
            case 8:
               return "Italian";
            case 9:
               return "Nederland";
            case 10:
               return "Portuguese";
            case 11:
               return "Swedish";
            case 12:
               return "Turkish";
            case 13:
               return "Flemish";
            case 14:
               return "Arabic";
            case 15:
               return "ChineseTraditional";
            case 16:
               return "ChineseSimple";
            case 17:
               return "Korean";
            case 18:
               return "Japanese";
            case 19:
               return "Brazilian Portuguese";
            case 20:
               return "French Canadian";
            default:
               return "Unknown";
         }
      }
   }
}

