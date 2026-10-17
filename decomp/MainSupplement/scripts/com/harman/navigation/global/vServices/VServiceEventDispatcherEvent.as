package com.harman.navigation.global.vServices
{
   import flash.events.Event;
   
   public class VServiceEventDispatcherEvent extends Event
   {
      
      public static const GENERIC_POPUP_SHOW:String = "GenericPopupShow";
      
      public static const GENERIC_POPUP_HIDE:String = "GenericPopupHide";
      
      public static const GENERIC_ONE_BUTTON_POPUP_SHOW:String = "GenericTwoButtonPopupShow";
      
      public static const GENERIC_ONE_BUTTON_POPUP_HIDE:String = "GenericTwoButtonPopupHide";
      
      public static const GENERIC_TWO_BUTTON_POPUP_SHOW:String = "GenericTwoButtonPopupShow";
      
      public static const GENERIC_TWO_BUTTON_POPUP_HIDE:String = "GenericTwoButtonPopupHide";
      
      public static const INFO_POPUP_AVAILABLE:String = "InfoPopupAvailable";
      
      public static const INFO_POPUP_SHOW:String = "InfoPopupShow";
      
      public static const INFO_POPUP_HIDE:String = "InfoPopupHide";
      
      public static const INFO_POPUP_CLOSE:String = "InfoPopupClose";
      
      public static const INFO_POPUP_CANCEL:String = "InfoPopupCancel";
      
      public static const INFO_POPUP_OK:String = "InfoPopupOk";
      
      public static const ONE_ITEM_POPUP_AVAILABLE:String = "OneItemPopupAvailable";
      
      public static const ONE_ITEM_POPUP_SHOW:String = "OneItemPopupShow";
      
      public static const ONE_ITEM_POPUP_HIDE:String = "OneItemPopupHide";
      
      public static const ONE_ITEM_POPUP_CONFIRMATION:String = "OneItemPopupConfirmation";
      
      public static const TWO_ITEM_POPUP_AVAILABLE:String = "TwoItemPopupAvailable";
      
      public static const TWO_ITEM_POPUP_SHOW:String = "TwoItemPopupShow";
      
      public static const TWO_ITEM_POPUP_CLOSE:String = "TwoItemPopupClose";
      
      public static const TWO_ITEM_POPUP_BTN_LEFT:String = "TwoItemPopupBtnLeft";
      
      public static const TWO_ITEM_POPUP_BTN_RIGHT:String = "TwoItemPopupBtnRight";
      
      public static const THREE_ITEM_POPUP_AVAILABLE:String = "ThreeItemPopupAvailable";
      
      public static const THREE_ITEM_POPUP_SHOW:String = "ThreeItemPopupShow";
      
      public static const THREE_ITEM_POPUP_CLOSE:String = "ThreeItemPopupClose";
      
      public static const OPTIONS_POPUP_AVAILABLE:String = "OptionsPopupAvailable";
      
      public static const OPTIONS_POPUP_SHOW:String = "OptionsPopupShow";
      
      public static const OPTIONS_POPUP_CLOSE:String = "OptionsPopupClose";
      
      public static const OPTIONS_POPUP_BTN_0:String = "OptionsPopupBtn0";
      
      public static const OPTIONS_POPUP_BTN_1:String = "OptionsPopupBtn1";
      
      public static const OPTIONS_POPUP_BTN_2:String = "OptionsPopupBtn2";
      
      public static const OPTIONS_POPUP_BTN_3:String = "OptionsPopupBtn3";
      
      public static const OPTIONS_POPUP_BTN_4:String = "OptionsPopupBtn4";
      
      public static const DIRECTION_TRACKER_UPDATE:String = "DirectionTrackerUpdate";
      
      public static const SPELLER_POPUP_AVAILABLE:String = "SpellerPopupAvailable";
      
      public static const SPELLER_POPUP_SHOW:String = "SpellerPopupShow";
      
      public static const SPELLER_POPUP_OK:String = "SpellerPopupOk";
      
      public static const SPELLER_POPUP_HIDE:String = "SpellerPopupHide";
      
      public static const CHECKBOX:String = "CheckBox";
      
      public static const OPTION:String = "Option";
      
      public static const ITEM:String = "Item";
      
      public static const CATEGORY:String = "Category";
      
      public static const COMMAND:String = "Command";
      
      public static const TRASH:String = "Trash";
      
      public static const POSITIVE:String = "Positive";
      
      public static const NEGATIVE:String = "Negative";
      
      public static const DISTANCE_LIST_UPDATE:String = "DistanceListUpdate";
      
      public static const WHERE_AM_I_GPS_POPUP_AVAILABLE:String = "WhereAmIGPSPopupAvailable";
      
      public static const WHERE_AM_I_GPS_POPUP_SHOW:String = "WhereAmIGPSPopupShow";
      
      public static const GLOBAL_UNIT_SYSTEM:String = "GlobalUnitSystem";
      
      public static const GLOBAL_NAV_MARKET_CONFIG:String = "GlobalNavigationMarket";
      
      public static const GLOBAL_GEO_COORDINATE_SYSTEM:String = "GlobalGeoCoordinateSystem";
      
      public var data:*;
      
      public function VServiceEventDispatcherEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
   }
}

