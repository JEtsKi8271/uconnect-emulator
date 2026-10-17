package com.harman.navigation.Controller.LI
{
   import flash.events.Event;
   
   public class LocationInputEvent extends Event
   {
      
      public static const LI_INPUT_PATH:String = "LI_InputPath";
      
      public static const LI_ACTIVE_MENU:String = "LI_ActiveMenu";
      
      public static const LI_SET_CHARACTER:String = "LI_SetCharacters";
      
      public static const LI_SET_ENTERED_CHARACTERS:String = "LI_SetEnteredCharacters";
      
      public static const LI_SET_LIST:String = "LI_SetList";
      
      public static const LI_SET_BUSY:String = "LI_SetBusy";
      
      public static const LI_DEFAULT_COUNTRY:String = "LI_DefaultCountry";
      
      public static const LI_DEFAULT_COUNTRY_CHANGE:String = "LI_DefaultCountryChange";
      
      public static const LI_DEFAULT_COUNTRY_TEMP:String = "LI_DefaultCountryTemp";
      
      public static const LI_DEFAULT_STATE:String = "LI_DefaultState";
      
      public static const LI_DEFAULT_CITY:String = "LI_DefaultCity";
      
      public static const LI_LANGUAGE_CHANGE_IN_PROGRESS:String = "LI_LanguageChangeInProgress";
      
      public static const LI_PAGE_CURRENT:String = "LI_Page_Current";
      
      public static const LI_PAGES_TOTAL:String = "LI_Pages_Total";
      
      public static const LI_INVALID_GEO_COODRINATE:String = "LI_Invalid_Geo_Coordinate";
      
      public static const LI_VALID_GEO_COODRINATE:String = "LI_Valid_Geo_Coordinate";
      
      public static const LI_ZIP_CODE_AVAIL:String = "LI_ZIP_CODE_AVAIL";
      
      public static const LI_OPEN_LOADING_POPUP:String = "LI_Open_Loading_Popup";
      
      public function LocationInputEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

