package ancillary
{
   public class Style
   {
      
      public static const BREADCRUMB_HIGHLIGHT_COLOR:String = "#80B5FF";
      
      public static const OTHER_CALL_COLOR:String = "#F8B205";
      
      public static const EMPTY_FAVORITE_COLOR:String = "#999999";
      
      public static const DEFAULT_POPUP_TIMEOUT:int = 5000;
      
      public static const HVAC_POPUP_TIMEOUT:int = 2000;
      
      public static const SKIPPED_CHANNEL_POPUP_TIMEOUT:int = 3000;
      
      public static const DEFAULT_DOWNLOAD_POPUP_TIMEOUT:int = 240000;
      
      public static const TL_WEATHER_POPUP_TIMEOUT:int = 3000;
      
      public static const AUDIO_MUTED_POPUP_TIMEOUT:int = 2000;
      
      public static const SPEED_LOCKOUT_POPUP_TIMEOUT:int = 3000;
      
      public static const TEN_SECOND_POPUP_TIMEOUT:int = 10000;
      
      public static const EMBEDDED_PHONE_POPUP_RTN_TIMEOUT:int = 2000;
      
      public static const NUM_OF_CHARACTERS:int = 32;
      
      public static const Button:Object = {
         "LONG_PRESS_DELAY":2000,
         "AUTO_REPEAT_DELAY":500,
         "AUTO_REPEAT_PERIOD":200,
         "UP_STATE_DELAY":0,
         "DEFAULT_FRAME_SUFFIX":"Day"
      };
      
      public static const Scroller:Object = {
         "ROUND_VALUES":true,
         "SENSITIVE_TRACK":false,
         "REPORTING_PERIOD":500,
         "HIDE_IF_USELESS":true,
         "POPUP_PAGE_THRESHOLD":10,
         "DISABLE_BUTTONS":false
      };
      
      public static const List:Object = {
         "BUFFER_SIZE":0,
         "REQUEST_TIMEOUT":50000
      };
      
      public static const GenericSettingsScreen:Object = {"SCROLLER_REPORTING_PERIOD":500};
      
      public static const AudioSettingsScreen:Object = {
         "BALANCE_FADE_REPORTING_PERIOD":500,
         "EQUALIZER_REPORTING_PERIOD":500
      };
      
      public static const RadioHomeScreen:Object = {
         "REPLAY_TEXT_PADDING":0,
         "RADIO_LONG_PRESS_DELAY":500,
         "POPUP_TIMEOUT":20000
      };
      
      public static const PlayerHomeScreen:Object = {
         "SKIP_THRESHOLD":3000,
         "PLAYER_LONG_PRESS_DELAY":500,
         "TRACKS_POSITION_OVERRIDE_TIMEOUT":10000,
         "SOURCE_POSITION_OVERRIDE_TIMEOUT":10000,
         "LIST_BUFFER_SIZE":10
      };
      
      public static const PlayerBrowseScreen:Object = {
         "DATA_DELAY_WARNING_THRESHOLD":250,
         "SCROLLER_REPORTING_PERIOD":500,
         "LIST_BUFFER_SIZE":20
      };
      
      public static const TravelLinkGenericScreen:Object = {
         "DATA_DELAY_WARNING_THRESHOLD":250,
         "DATA_DELAY_WARNING_REPEAT":4,
         "DATA_DELAY_WARNING_TIMEOUT":240000
      };
      
      public static const TravelLinkFuelScreen:Object = {
         "DISTANCE_PRECISION":1,
         "SEARCH_RADIUS":30
      };
      
      public static const PhoneBookScreen:Object = {"LIST_BUFFER_SIZE":20};
      
      public static const PhoneRecentCallScreen:Object = {"LIST_BUFFER_SIZE":20};
      
      public static const NavDisclaimerPopupScreen:Object = {
         "CONTROLS_TIMEOUT":4500,
         "SCREEN_TIMEOUT":500
      };
      
      public function Style()
      {
         super();
      }
   }
}

