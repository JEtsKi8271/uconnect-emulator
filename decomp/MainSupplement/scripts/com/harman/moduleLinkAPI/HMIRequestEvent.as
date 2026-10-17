package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class HMIRequestEvent extends Event
   {
      
      public static const BTN_PRESSED:String = "btnPressed";
      
      public static const TIMEOUT:String = "timeout";
      
      public static const NEW_POPUP:String = "newPopup";
      
      public static const POPUP_DISPLAYED:String = "popupDisplayed";
      
      public static const POPUP_IN_QUEUE:String = "popupInQueue";
      
      public static const POPUP_DISPLAY_DENIED:String = "popupDisplayDenied";
      
      public static const DISPLAY_BLOCK_POPUP:String = "displayBlockPopup";
      
      public static const DISPLAY_BLOCK_POPUP_BY_MSGID:String = "displayBlockPopupByMsgId";
      
      public static const DISPLAY_GLOBAL_POPUP:String = "displayGlobalPopup";
      
      public static const DISPLAY_GLOBAL_POPUP_BY_MSGID:String = "displayGlobalPopupByMsgId";
      
      public static const GET_PROP_LD:String = "getPropertyLD";
      
      public static const SET_PROP_LD:String = "setPropertyLD";
      
      public static const ACCEPT_PROP_LD:String = "acceptPropertyLD";
      
      public static const ROUTE_TO_LOCATION:String = "routeToLocation";
      
      public static const START_GUIDANCE:String = "startGuidance";
      
      public static const STOP_GUIDANCE:String = "stopGuidance";
      
      public static const GET_GUIDANCE_STATE:String = "getGuidanceState";
      
      public static const SET_NAV_REPEAT_PROMPT:String = "setNavRepeatPrompt";
      
      public static const SWITCH_TO_DRIVEMODE:String = "switchToDriveMode";
      
      public static const GOTO_SCREEN:String = "gotoScreen";
      
      public static const TEXTFIELD_LABEL_TYPE:String = "textFieldLabelType";
      
      public static const HIGHLIGHT_TRUNCATIONS:String = "highlightTruncations";
      
      public static const LABEL_BOUNDS:String = "labelBounds";
      
      public static const WAITING_FOR_AMS_TO_START_ASSIST_APP:String = "waitingForAMSToStartAssistApp";
      
      public static const APP_REQUEST_FOREGROUND:String = "appRequestForeground";
      
      public static const STATUS_BAR_AVAILABILITY:String = "statusBarAvailability";
      
      public static const SET_APP_STATUS_BAR_DISPLAY:String = "setAppStatusBarDisplay";
      
      public static const SCREEN_STATUS:String = "screenStatus";
      
      public static const BRINGUP_SOURCE_POPUP:String = "bringUpSourcePopup";
      
      public static const APP_SCREEN_FOCUS_TYPE:String = "appScreenFocusType";
      
      public static const SET_PHONE_CONN_STATUS:String = "setPhoneConnStatus";
      
      public static const SET_ECO_DRIVE_STATUS:String = "setEcoDriveStatus";
      
      public static const SET_LOCALIZATION_STATUS:String = "setLocalizationStatus";
      
      public static const GET_HEX_CODE:String = "getHexCode";
      
      public static const SET_APP_VISIBLE:String = "setAppVisible";
      
      public static const MEDIA_INSERT:String = "mediaInsert";
      
      public static const AUTOMATION_TEST_ACTIVATE:String = "automationTestActivate";
      
      public static const AUTOMATION_TEST_DEACTIVATE:String = "automationTestDeActivate";
      
      public static const AUTOMATION_INSPECT:String = "automationInspect";
      
      public static const INSIGHT_START:String = "InsightStart";
      
      public var mData:Object = null;
      
      public function HMIRequestEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

