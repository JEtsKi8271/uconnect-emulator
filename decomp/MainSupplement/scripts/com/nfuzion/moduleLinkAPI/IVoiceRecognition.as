package com.nfuzion.moduleLinkAPI
{
   public interface IVoiceRecognition extends IModule
   {
      
      function get LIST_TYPE_TELEPROMPTER() : String;
      
      function get LIST_TYPE_PICK_LIST() : String;
      
      function get LIST_TYPE_FIND_NEAREST() : String;
      
      function get SESSION_TYPE_REGULAR() : String;
      
      function get SESSION_TYPE_PHONE() : String;
      
      function get SESSION_TYPE_NONE() : String;
      
      function get CAMERA() : String;
      
      function get CLIMATE() : String;
      
      function get TRAVELLINK_DEFAULT() : String;
      
      function get TRAVELLINK_INFORMATION() : String;
      
      function get TRAVELLINK_WEATHER_EXTENDED_FORECAST() : String;
      
      function get TRAVELLINK_FAVORITES() : String;
      
      function get TRAVELLINK_WEATHER_FIVE_DAY_FORECAST() : String;
      
      function get TRAVELLINK_FUEL() : String;
      
      function get TRAVELLINK_MAIN() : String;
      
      function get TRAVELLINK_MOVIE_LISTINGS() : String;
      
      function get TRAVELLINK_SPORTS_RANKINGS() : String;
      
      function get TRAVELLINK_SPORTS_SCORES() : String;
      
      function get TRAVELLINK_SKI_INFO() : String;
      
      function get TRAVELLINK_SPORTS_MAIN() : String;
      
      function get TRAVELLINK_SPORTS_LEAGUE() : String;
      
      function get TRAVELLINK_SPORTS_TEAMS() : String;
      
      function get TRAVELLINK_WEATHER_MAIN() : String;
      
      function get TRAVELLINK_WEATHER_MAP() : String;
      
      function get TRAVELLINK_TRAFFIC() : String;
      
      function get TRAVELLINK_WEATHER_CURRENT() : String;
      
      function get TRAVELLINK_SPORTS_HEADLINES() : String;
      
      function get TRAVELLINK_SPORTS_SCHEDULE() : String;
      
      function get SMS_MESSAGE_PLAY() : String;
      
      function get SMS_MESSAGE_SHOW() : String;
      
      function get SMS_MESSAGE_SEND() : String;
      
      function get SMS_CHECK_NUMBER() : String;
      
      function get VR_DIALOG_ACTIVE() : String;
      
      function get SHOW_CONTACT() : String;
      
      function get MEDIA_MAIN() : String;
      
      function get MEDIA_PLAYER() : String;
      
      function get MEDIA_AUX() : String;
      
      function get MEDIA_BLUETOOTH() : String;
      
      function get MEDIA_CD() : String;
      
      function get MEDIA_IPOD() : String;
      
      function get MEDIA_SD() : String;
      
      function get MEDIA_USB() : String;
      
      function get MEDIA_BROWSE_ALBUM() : String;
      
      function get MEDIA_BROWSE_ARTIST() : String;
      
      function get MEDIA_BROWSE_AUDIOBOOK() : String;
      
      function get MEDIA_BROWSE_GENRE() : String;
      
      function get MEDIA_BROWSE_PLAYLIST() : String;
      
      function get MEDIA_BROWSE_PODCAST() : String;
      
      function get MEDIA_BROWSE_TITLE() : String;
      
      function get MEDIA_BROWSE() : String;
      
      function get MEDIA_DISC() : String;
      
      function get MEDIA_FOLDERS() : String;
      
      function get MEDIA_LAST_SCREEN() : String;
      
      function get MEDIA_REAR() : String;
      
      function get MEDIA_SONG() : String;
      
      function get MEDIA_SOURCES() : String;
      
      function get MEDIA_TRACKS() : String;
      
      function get NAVIGATION() : String;
      
      function get NAVIGATION_MAP() : String;
      
      function get NAVIGATION_ADDRESS() : String;
      
      function get NAVIGATION_ROUTE_CONFIRM() : String;
      
      function get NAVIGATION_MY_DESTINATIONS() : String;
      
      function get NAVIGATION_POI() : String;
      
      function get NAVIGATION_RECENT_DESTINATIONS() : String;
      
      function get NAVIGATION_WHERE_TO() : String;
      
      function get APP() : String;
      
      function get APPS() : String;
      
      function get APPVR() : String;
      
      function get PHONE() : String;
      
      function get PHONE_ACTIVE_CALL() : String;
      
      function get PHONE_CONNECT() : String;
      
      function get PHONE_ASK_CONNECT() : String;
      
      function get PHONE_CONTACT() : String;
      
      function get PHONE_KEY_PAD() : String;
      
      function get PHONE_RECENT_CALLS_ALL() : String;
      
      function get PHONE_RECENT_CALLS_INCOMING() : String;
      
      function get PHONE_RECENT_CALLS_MISSED() : String;
      
      function get PHONE_RECENT_CALLS_OUTGOING() : String;
      
      function get PHONE_PHONEBOOK() : String;
      
      function get PHONE_PHONEBOOK_MOBILE() : String;
      
      function get PHONE_PAIRED_PHONES() : String;
      
      function get PHONE_PAIRED_AUDIO_SOURCES() : String;
      
      function get PHONE_PAIRING() : String;
      
      function get PHONE_SMS_INBOX() : String;
      
      function get PHONE_SMS_MESSAGE() : String;
      
      function get PHONE_SMS_MESSAGE_SELECTED() : String;
      
      function get PHONE_SMS_PREDEFINED_MESSAGES() : String;
      
      function get PHONE_PHONEBOOK_VEHICLE() : String;
      
      function get TUNER() : String;
      
      function get TUNER_AM() : String;
      
      function get TUNER_MW() : String;
      
      function get TUNER_FM() : String;
      
      function get TUNER_SAT() : String;
      
      function get TUNER_DAB() : String;
      
      function get TUNER_DMB() : String;
      
      function get TUNER_PRESET() : String;
      
      function get AUDIO_SETTINGS() : String;
      
      function get PHONE_NO_HF() : String;
      
      function get DEFAULT() : String;
      
      function get STATUS_FAIL() : String;
      
      function get STATUS_HELP() : String;
      
      function get STATUS_OK() : String;
      
      function get TYPE_HELP() : String;
      
      function get TYPE_PAUSE() : String;
      
      function get TYPE_NOSPEAK() : String;
      
      function get TYPE_SPEAK() : String;
      
      function get TYPE_SUCCESS() : String;
      
      function get CONTROLS() : String;
      
      function get SETTINGS() : String;
      
      function get VRSessionInProgress() : Boolean;
      
      function get VoiceRecognitionState() : String;
      
      function get sessionType() : String;
      
      function get listType() : String;
      
      function get dataLoggingEnabled() : Boolean;
      
      function set dataLoggingEnabled(param1:Boolean) : void;
      
      function setLanguage(param1:String, param2:String) : void;
      
      function setListSize(param1:int) : void;
      
      function setContext(param1:String) : void;
      
      function get context() : String;
      
      function set controlPanelContext(param1:String) : void;
      
      function reportLineIndex(param1:uint) : void;
      
      function reportLineSelected(param1:uint) : void;
      
      function reportHelpSelected() : void;
      
      function reportPageUpSelected() : void;
      
      function reportPageDownSelected() : void;
      
      function reportAbsoluteListIndex(param1:uint) : void;
      
      function updateHFMVoiceBarPopup(param1:String, param2:Boolean = true) : void;
      
      function cancel(param1:Boolean = true) : void;
      
      function get promptText() : String;
      
      function get promptStatus() : String;
      
      function canStatusBarBeRemoved(param1:String = "") : Boolean;
      
      function get promptType() : String;
      
      function get promptTimeout() : Boolean;
      
      function pickList() : Array;
      
      function get listIsVisible() : Boolean;
      
      function get lastGoto() : String;
      
      function get lastGotoOptions() : Object;
      
      function emitStatus(param1:String) : void;
      
      function get isVRAvailable() : Boolean;
      
      function get VRNotAvailableReason() : String;
      
      function get isBusyProcessing() : Boolean;
      
      function emitVRResponse(param1:Number, param2:String, param3:Boolean) : void;
      
      function emitInvalidVRResponse(param1:Number, param2:String) : void;
      
      function emitPTTPress() : void;
      
      function emitSmsVRResponse(param1:Number, param2:String, param3:String, param4:Object = null, param5:String = null, param6:Object = null, param7:Object = null, param8:Object = null) : void;
      
      function get dtmfToneInfo() : String;
      
      function set dtmfToneInfo(param1:String) : void;
   }
}

