package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.IVoiceRecognition;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VoiceRecognition extends Module implements IVoiceRecognition
   {
      
      private static var instance:VoiceRecognition;
      
      private static const dbusIdentifier:String = "VoiceRecognition";
      
      private static const sTravelLinkDefault:String = "travellinkDefault";
      
      private static const sTravelLinkFavorites:String = "travellinkFavorites";
      
      private static const sTravelLinkFiveDayWeather:String = "travellinkFiveDayWeather";
      
      private static const sTravelLinkFuelPrices:String = "travellinkFuelPrices";
      
      private static const sTravelLinkHeadlines:String = "travellinkHeadlines";
      
      private static const sTravelLinkInformation:String = "information";
      
      private static const sTravelLinkMain:String = "travellinkMain";
      
      private static const sTravelLinkMovieListings:String = "travellinkMovieListings";
      
      private static const sTravelLinkSkiInfo:String = "travellinkSkiInfo";
      
      private static const sTravelLinkSportsHeadlines:String = "travellinkSportsHeadlines";
      
      private static const sTravelLinkSportsRankings:String = "travellinkSportsRankings";
      
      private static const sTravelLinkSportsSchedule:String = "travellinkSportsSchedule";
      
      private static const sTravelLinkSportsScores:String = "travellinkScores";
      
      private static const sTravelLinkSports:String = "travellinkSports";
      
      private static const sTravelLinkSportsLeage:String = "travellinkSportsLeage";
      
      private static const sTravelLinkSportsTeams:String = "travellinkTeams";
      
      private static const sTravelLinkTraffic:String = "travellinkTraffic";
      
      private static const sTravelLinkWeather:String = "travellinkWeather";
      
      private static const sTravelLinkWeatherMap:String = "travellinkWeatherMap";
      
      private static const sTravelLinkCurrentWeather:String = "travellinkCurrentWeather";
      
      private static const sTravelLinkExtWeather:String = "travellinkExtWeather";
      
      private static const sCamera:String = "camera";
      
      private static const sClimate:String = "climate";
      
      private static const sMediaBrowseAlbum:String = "mediaAlbum";
      
      private static const sMediaBrowseArtist:String = "mediaArtist";
      
      private static const sMediaBrowseAudiobook:String = "mediaAudiobook";
      
      private static const sMediaBrowseGenre:String = "mediaGenre";
      
      private static const sMediaBrowsePlaylist:String = "mediaPlaylist";
      
      private static const sMediaBrowsePodcast:String = "mediaPodcast";
      
      private static const sMediaBrowseTitle:String = "mediaTitle";
      
      private static const sMediaPlayer:String = "mediaPlayer";
      
      private static const sMediaAux:String = "mediaAux";
      
      private static const sMediaBluetooth:String = "mediaBluetooth";
      
      private static const sMediaMain:String = "mediaMain";
      
      private static const sMediaCD:String = "mediaDisc";
      
      private static const sMediaIpod:String = "mediaIpod";
      
      private static const sMediaSD:String = "mediaSdCard";
      
      private static const sMediaUSB:String = "mediaUsb";
      
      private static const sMediaBrowse:String = "mediaBrowse";
      
      private static const sMediaDisc:String = "mediaDisc";
      
      private static const sMediaFolders:String = "mediaFolders";
      
      private static const sMediaLastScreen:String = "mediaLastScreen";
      
      private static const sMediaRear:String = "rse";
      
      private static const sMediaSong:String = "mediaSong";
      
      private static const sMediaSources:String = "mediaSources";
      
      private static const sMediaTracks:String = "mediaTracks";
      
      private static const sNavigation:String = "navi";
      
      private static const sNavigationMap:String = "naviMap";
      
      private static const sNavigationAddress:String = "naviAddress";
      
      private static const sNavigationConfirmRoute:String = "naviConfirmRoute";
      
      private static const sNavigationMyDestinations:String = "naviMyDestinations";
      
      private static const sNavigationPoi:String = "naviPoi";
      
      private static const sNavigationRecentDestinations:String = "naviRecentDestinations";
      
      private static const sNavigationWhereTo:String = "naviWhereTo";
      
      private static const sApp:String = "app";
      
      private static const sApps:String = "apps";
      
      private static const sAppVR:String = "appVr";
      
      private static const sPhone:String = "phone";
      
      private static const sPhoneActiveCall:String = "phoneActiveCall";
      
      private static const sPhonePairingScreen:String = "phoneNoHandsFree";
      
      private static const sPhoneConnect:String = "phoneConnect";
      
      private static const sPhoneAskConnect:String = "phoneAskConnect";
      
      private static const sPhoneKeyPad:String = "phoneKeyPad";
      
      private static const sPhoneListAllCalls:String = "phoneListAllCalls";
      
      private static const sPhoneListIncomingCalls:String = "phoneListIncomingCalls";
      
      private static const sPhoneListMissedCalls:String = "phoneListMissedCalls";
      
      private static const sPhoneListOutgoingCalls:String = "phoneListOutgoingCalls";
      
      private static const sPhoneRecentCallList:String = "phoneRecentCalls";
      
      private static const sPhoneMobilePhoneBook:String = "phoneMobilePhoneBook";
      
      private static const sPhonePairedSources:String = "phonePairedSources";
      
      private static const sPhoneBook:String = "phoneBook";
      
      private static const sPhoneSearchResult:String = "phoneSearchResult";
      
      private static const sPhoneShowPaired:String = "phoneShowPaired";
      
      private static const sPhoneSmsInbox:String = "phoneSmsInbox";
      
      private static const sPhoneSmsMessagePopup:String = "phoneSmsMessagePopup";
      
      private static const sPhoneSmsMessagePopupSelected:String = "smsSelected";
      
      private static const sPhoneSmsPredefined:String = "phoneSmsPredefined";
      
      private static const sPhoneVehiclePhoneBook:String = "phoneVehiclePhoneBook";
      
      private static const sTuner:String = "tuner";
      
      private static const sAudioSetting:String = "audioSetting";
      
      private static const sTunerAM:String = "tunerAM";
      
      private static const sTunerMW:String = "tunerMW";
      
      private static const sTunerFM:String = "tunerFM";
      
      private static const sTunerSAT:String = "tunerSAT";
      
      private static const sTunerDAB:String = "tunerDAB";
      
      private static const sTunerDMB:String = "tunerDMB";
      
      private static const sTunerPreset:String = "tunerPreset";
      
      private static const sSmsMessagePlay:String = "smsMessagePlay";
      
      private static const sSmsMessageShow:String = "smsMessageShow";
      
      private static const sSmsMessageSend:String = "smsMessageSend";
      
      private static const sSmsCheckNumber:String = "smsCheckNumber";
      
      private static const sSmsGetDetails:String = "smsGetDetails";
      
      private static const sSendIndexedSmstoNumber:String = "sendIndexedSmstoNumber";
      
      private static const sShowContact:String = "showContact";
      
      private static const sControls:String = "controls";
      
      private static const sSettings:String = "settings";
      
      private static const sSTATUS_VR_ACTIVE:String = "vrDialogActive";
      
      private static const sDefault:String = "default";
      
      private static const sTYPE_HELP:String = "VR_ICON_HELP";
      
      private static const sTYPE_NOSPEAK:String = "VR_ICON_NOSPEAK";
      
      private static const sTYPE_PAUSE:String = "VR_ICON_PAUSE";
      
      private static const sTYPE_SPEAK:String = "VR_ICON_SPEAK";
      
      private static const sTYPE_SUCCESS:String = "VR_ICON_SUCCESS";
      
      private static const sSTATUS_FAIL:String = "VR_COLOR_FAIL";
      
      private static const sSTATUS_HELP:String = "VR_COLOR_HELP";
      
      private static const sSTATUS_OK:String = "VR_COLOR_OK";
      
      private static const sLIST_TYPE_TELEPROMPTER:String = "teleprompter";
      
      private static const sLIST_TYPE_PICK_LIST:String = "pickList";
      
      private static const sLIST_TYPE_FIND_NEAREST:String = "findNearest";
      
      private static const sSESSION_TYPE_REGULAR:String = "vrKeySession";
      
      private static const sSESSION_TYPE_PHONE:String = "phoneKeySession";
      
      private static const sSESSION_TYPE_NONE:String = "none";
      
      private static const sDBUS_UISPEECH_ID:String = "UISpeechService";
      
      private const CONTROL_PANEL_CONTEXTS:Vector.<String>;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mVoiceBarText:String;
      
      private var mVoiceBarType:String;
      
      private var mVoiceBarStatus:String;
      
      private var mVoiceBarTimeout:Boolean;
      
      private var mList:Array;
      
      private var mListHeader:String;
      
      private var mListType:String;
      
      private var mListVisible:Boolean;
      
      private var mListIndex:uint;
      
      private var mListSize:int = 6;
      
      private var mLastGoto:String;
      
      private var mLastContext:String;
      
      private var mLastArgument:Object;
      
      private var mControlPanelContext:String;
      
      private var mContextId:String;
      
      private var mLanguage:String;
      
      private var mUnknownStr:String;
      
      private var mVRSessionInProgress:Boolean;
      
      private var mVRRecState:VoiceRecState;
      
      private var mVRBusyProcessing:Boolean = false;
      
      private var mVoiceRecognitionState:String = "off";
      
      private var mSessionType:String = "none";
      
      private var mDtmfTone:String = "";
      
      private var mDataLoggingEnabled:Boolean;
      
      public function VoiceRecognition()
      {
         this.CONTROL_PANEL_CONTEXTS = new <String>[this.CONTROLS,this.SETTINGS];
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VOICE_RECOGNITION,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.UI_SPEECH_SERVICE,this.uiSpeechHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.mVRSessionInProgress = false;
         this.mVoiceRecognitionState = "off";
         this.mVRRecState = new VoiceRecState();
         this.subscribe(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE);
         this.sendSubscribe(VoiceRecognitionEvent.REMOVE_SMS_POPUP);
         this.sendSubscribe("setListPage");
         this.sendSubscribe("voiceRecognition");
         this.sendSubscribe("showTeleprompter");
         this.controlPanelContext = this.SETTINGS;
      }
      
      public static function getInstance() : VoiceRecognition
      {
         if(instance == null)
         {
            instance = new VoiceRecognition();
         }
         return instance;
      }
      
      public function get LIST_TYPE_TELEPROMPTER() : String
      {
         return sLIST_TYPE_TELEPROMPTER;
      }
      
      public function get LIST_TYPE_PICK_LIST() : String
      {
         return sLIST_TYPE_PICK_LIST;
      }
      
      public function get LIST_TYPE_FIND_NEAREST() : String
      {
         return sLIST_TYPE_FIND_NEAREST;
      }
      
      public function get SESSION_TYPE_REGULAR() : String
      {
         return sSESSION_TYPE_REGULAR;
      }
      
      public function get SESSION_TYPE_PHONE() : String
      {
         return sSESSION_TYPE_PHONE;
      }
      
      public function get SESSION_TYPE_NONE() : String
      {
         return sSESSION_TYPE_NONE;
      }
      
      public function get CAMERA() : String
      {
         return sCamera;
      }
      
      public function get CLIMATE() : String
      {
         return sClimate;
      }
      
      public function get DEFAULT() : String
      {
         return sDefault;
      }
      
      public function get TRAVELLINK_DEFAULT() : String
      {
         return sTravelLinkDefault;
      }
      
      public function get TRAVELLINK_INFORMATION() : String
      {
         return sTravelLinkInformation;
      }
      
      public function get TRAVELLINK_WEATHER_EXTENDED_FORECAST() : String
      {
         return sTravelLinkExtWeather;
      }
      
      public function get TRAVELLINK_FAVORITES() : String
      {
         return sTravelLinkFavorites;
      }
      
      public function get TRAVELLINK_WEATHER_FIVE_DAY_FORECAST() : String
      {
         return sTravelLinkFiveDayWeather;
      }
      
      public function get TRAVELLINK_FUEL() : String
      {
         return sTravelLinkFuelPrices;
      }
      
      public function get TRAVELLINK_MAIN() : String
      {
         return sTravelLinkMain;
      }
      
      public function get TRAVELLINK_MOVIE_LISTINGS() : String
      {
         return sTravelLinkMovieListings;
      }
      
      public function get TRAVELLINK_SPORTS_RANKINGS() : String
      {
         return sTravelLinkSportsRankings;
      }
      
      public function get TRAVELLINK_SPORTS_SCORES() : String
      {
         return sTravelLinkSportsScores;
      }
      
      public function get TRAVELLINK_SKI_INFO() : String
      {
         return sTravelLinkSkiInfo;
      }
      
      public function get TRAVELLINK_SPORTS_MAIN() : String
      {
         return sTravelLinkSports;
      }
      
      public function get TRAVELLINK_SPORTS_LEAGUE() : String
      {
         return sTravelLinkSportsLeage;
      }
      
      public function get TRAVELLINK_SPORTS_TEAMS() : String
      {
         return sTravelLinkSportsTeams;
      }
      
      public function get TRAVELLINK_WEATHER_MAIN() : String
      {
         return sTravelLinkWeather;
      }
      
      public function get TRAVELLINK_WEATHER_MAP() : String
      {
         return sTravelLinkWeatherMap;
      }
      
      public function get TRAVELLINK_TRAFFIC() : String
      {
         return sTravelLinkTraffic;
      }
      
      public function get TRAVELLINK_WEATHER_CURRENT() : String
      {
         return sTravelLinkCurrentWeather;
      }
      
      public function get TRAVELLINK_SPORTS_HEADLINES() : String
      {
         return sTravelLinkSportsHeadlines;
      }
      
      public function get TRAVELLINK_SPORTS_SCHEDULE() : String
      {
         return sTravelLinkSportsSchedule;
      }
      
      public function get MEDIA_MAIN() : String
      {
         return sMediaMain;
      }
      
      public function get MEDIA_PLAYER() : String
      {
         return sMediaPlayer;
      }
      
      public function get MEDIA_AUX() : String
      {
         return sMediaAux;
      }
      
      public function get MEDIA_BLUETOOTH() : String
      {
         return sMediaBluetooth;
      }
      
      public function get MEDIA_CD() : String
      {
         return sMediaCD;
      }
      
      public function get MEDIA_IPOD() : String
      {
         return sMediaIpod;
      }
      
      public function get MEDIA_REAR() : String
      {
         return sMediaRear;
      }
      
      public function get MEDIA_SD() : String
      {
         return sMediaSD;
      }
      
      public function get MEDIA_USB() : String
      {
         return sMediaUSB;
      }
      
      public function get MEDIA_BROWSE_ALBUM() : String
      {
         return sMediaBrowseAlbum;
      }
      
      public function get MEDIA_BROWSE_ARTIST() : String
      {
         return sMediaBrowseArtist;
      }
      
      public function get MEDIA_BROWSE_AUDIOBOOK() : String
      {
         return sMediaBrowseAudiobook;
      }
      
      public function get MEDIA_BROWSE_GENRE() : String
      {
         return sMediaBrowseGenre;
      }
      
      public function get MEDIA_BROWSE_PLAYLIST() : String
      {
         return sMediaBrowsePlaylist;
      }
      
      public function get MEDIA_BROWSE_PODCAST() : String
      {
         return sMediaBrowsePodcast;
      }
      
      public function get MEDIA_BROWSE_TITLE() : String
      {
         return sMediaBrowseTitle;
      }
      
      public function get MEDIA_BROWSE() : String
      {
         return sMediaBrowse;
      }
      
      public function get MEDIA_DISC() : String
      {
         return sMediaDisc;
      }
      
      public function get MEDIA_FOLDERS() : String
      {
         return sMediaFolders;
      }
      
      public function get MEDIA_LAST_SCREEN() : String
      {
         return sMediaLastScreen;
      }
      
      public function get MEDIA_SONG() : String
      {
         return sMediaSong;
      }
      
      public function get MEDIA_SOURCES() : String
      {
         return sMediaSources;
      }
      
      public function get MEDIA_TRACKS() : String
      {
         return sMediaTracks;
      }
      
      public function get NAVIGATION() : String
      {
         return sNavigation;
      }
      
      public function get NAVIGATION_MAP() : String
      {
         return sNavigationMap;
      }
      
      public function get NAVIGATION_ADDRESS() : String
      {
         return sNavigationAddress;
      }
      
      public function get NAVIGATION_ROUTE_CONFIRM() : String
      {
         return sNavigationConfirmRoute;
      }
      
      public function get NAVIGATION_MY_DESTINATIONS() : String
      {
         return sNavigationMyDestinations;
      }
      
      public function get NAVIGATION_POI() : String
      {
         return sNavigationPoi;
      }
      
      public function get NAVIGATION_RECENT_DESTINATIONS() : String
      {
         return sNavigationRecentDestinations;
      }
      
      public function get NAVIGATION_WHERE_TO() : String
      {
         return sNavigationWhereTo;
      }
      
      public function get APP() : String
      {
         return sApp;
      }
      
      public function get APPS() : String
      {
         return sApps;
      }
      
      public function get APPVR() : String
      {
         return sAppVR;
      }
      
      public function get PHONE() : String
      {
         return sPhone;
      }
      
      public function get PHONE_ACTIVE_CALL() : String
      {
         return sPhoneActiveCall;
      }
      
      public function get PHONE_CONNECT() : String
      {
         return sPhoneConnect;
      }
      
      public function get PHONE_ASK_CONNECT() : String
      {
         return sPhoneAskConnect;
      }
      
      public function get PHONE_CONTACT() : String
      {
         return sPhoneSearchResult;
      }
      
      public function get PHONE_KEY_PAD() : String
      {
         return sPhoneKeyPad;
      }
      
      public function get PHONE_RECENT_CALLS_ALL() : String
      {
         return sPhoneListAllCalls;
      }
      
      public function get PHONE_RECENT_CALLS_INCOMING() : String
      {
         return sPhoneListIncomingCalls;
      }
      
      public function get PHONE_RECENT_CALLS_MISSED() : String
      {
         return sPhoneListMissedCalls;
      }
      
      public function get PHONE_RECENT_CALLS_OUTGOING() : String
      {
         return sPhoneListOutgoingCalls;
      }
      
      public function get PHONE_PHONEBOOK() : String
      {
         return sPhoneBook;
      }
      
      public function get PHONE_PHONEBOOK_MOBILE() : String
      {
         return sPhoneMobilePhoneBook;
      }
      
      public function get PHONE_PAIRED_AUDIO_SOURCES() : String
      {
         return sPhonePairedSources;
      }
      
      public function get PHONE_PAIRED_PHONES() : String
      {
         return sPhoneShowPaired;
      }
      
      public function get PHONE_PAIRING() : String
      {
         return sPhonePairingScreen;
      }
      
      public function get PHONE_SMS_INBOX() : String
      {
         return sPhoneSmsInbox;
      }
      
      public function get PHONE_SMS_MESSAGE() : String
      {
         return sPhoneSmsMessagePopup;
      }
      
      public function get PHONE_SMS_MESSAGE_SELECTED() : String
      {
         return sPhoneSmsMessagePopupSelected;
      }
      
      public function get PHONE_SMS_PREDEFINED_MESSAGES() : String
      {
         return sPhoneSmsPredefined;
      }
      
      public function get PHONE_PHONEBOOK_VEHICLE() : String
      {
         return sPhoneVehiclePhoneBook;
      }
      
      public function get PHONE_NO_HF() : String
      {
         return sPhonePairingScreen;
      }
      
      public function get TUNER() : String
      {
         return sTuner;
      }
      
      public function get TUNER_AM() : String
      {
         return sTunerAM;
      }
      
      public function get TUNER_MW() : String
      {
         return sTunerMW;
      }
      
      public function get TUNER_FM() : String
      {
         return sTunerFM;
      }
      
      public function get TUNER_SAT() : String
      {
         return sTunerSAT;
      }
      
      public function get TUNER_DAB() : String
      {
         return sTunerDAB;
      }
      
      public function get TUNER_DMB() : String
      {
         return sTunerDMB;
      }
      
      public function get TUNER_PRESET() : String
      {
         return sTunerPreset;
      }
      
      public function get SMS_MESSAGE_PLAY() : String
      {
         return sSmsMessagePlay;
      }
      
      public function get SMS_MESSAGE_SHOW() : String
      {
         return sSmsMessageShow;
      }
      
      public function get SMS_MESSAGE_SEND() : String
      {
         return sSmsMessageSend;
      }
      
      public function get SMS_CHECK_NUMBER() : String
      {
         return sSmsCheckNumber;
      }
      
      public function get SMS_GET_DETAILS() : String
      {
         return sSmsGetDetails;
      }
      
      public function get SMS_SEND_INDEXED_SMS_TO_NUMBER() : String
      {
         return sSendIndexedSmstoNumber;
      }
      
      public function get VR_DIALOG_ACTIVE() : String
      {
         return sSTATUS_VR_ACTIVE;
      }
      
      public function get SHOW_CONTACT() : String
      {
         return sShowContact;
      }
      
      public function get CONTROLS() : String
      {
         return sControls;
      }
      
      public function get SETTINGS() : String
      {
         return sSettings;
      }
      
      public function get AUDIO_SETTINGS() : String
      {
         return sAudioSetting;
      }
      
      public function get STATUS_OK() : String
      {
         return sSTATUS_OK;
      }
      
      public function get STATUS_HELP() : String
      {
         return sSTATUS_HELP;
      }
      
      public function get STATUS_FAIL() : String
      {
         return sSTATUS_FAIL;
      }
      
      public function get TYPE_SPEAK() : String
      {
         return sTYPE_SPEAK;
      }
      
      public function get TYPE_SUCCESS() : String
      {
         return sTYPE_SUCCESS;
      }
      
      public function get TYPE_NOSPEAK() : String
      {
         return sTYPE_NOSPEAK;
      }
      
      public function get TYPE_HELP() : String
      {
         return sTYPE_HELP;
      }
      
      public function get TYPE_PAUSE() : String
      {
         return sTYPE_PAUSE;
      }
      
      public function canStatusBarBeRemoved(checkStatus:String = "") : Boolean
      {
         if(checkStatus == "")
         {
            checkStatus = this.promptStatus;
         }
         if(checkStatus == this.STATUS_HELP)
         {
            return true;
         }
         return false;
      }
      
      public function setLanguage(language:String, unknown:String) : void
      {
         this.mLanguage = language;
         this.mUnknownStr = unknown;
         this.emitLanguage();
         this.emitUnknownString();
      }
      
      public function setListSize(size:int) : void
      {
         this.mListSize = size;
      }
      
      public function setContext(context:String) : void
      {
         this.mLastContext = context;
      }
      
      public function get context() : String
      {
         return this.mLastContext;
      }
      
      public function set controlPanelContext(context:String) : void
      {
         if(this.CONTROL_PANEL_CONTEXTS.indexOf(context) >= 0)
         {
            this.mControlPanelContext = context;
         }
         else
         {
            this.mControlPanelContext = this.SETTINGS;
         }
      }
      
      public function reportLineIndex(index:uint) : void
      {
         this.mListIndex = index + 1;
         this.emitIndex();
      }
      
      public function reportLineSelected(index:uint) : void
      {
         this.mListIndex = index + 1;
         this.emitSelect();
      }
      
      public function reportHelpSelected() : void
      {
         this.sendEmit("helpItemTouch","","");
      }
      
      public function reportPageUpSelected() : void
      {
         this.client.send("{\"Type\":\"EmitVRSignal\",\"packet\":{\"pageButtonTouch\": { \"pageSet\":\"up\" }}}");
      }
      
      public function reportPageDownSelected() : void
      {
         this.client.send("{\"Type\":\"EmitVRSignal\",\"packet\":{\"pageButtonTouch\": { \"pageSet\":\"down\" }}}");
      }
      
      public function reportAbsoluteListIndex(index:uint) : void
      {
      }
      
      public function updateHFMVoiceBarPopup(Text:String, TimeoutRequired:Boolean = true) : void
      {
         this.prepareHFMVoiceBar(Text,TimeoutRequired);
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VOICE_PROMPT));
      }
      
      private function prepareHFMVoiceBar(Text:String = "", TimeoutRequired:Boolean = true) : void
      {
         if(this.mVRRecState.availbleState == false)
         {
            this.mVoiceBarType = sTYPE_NOSPEAK;
            this.mVoiceBarText = Text;
            this.mVoiceBarStatus = sSTATUS_FAIL;
            this.mVoiceBarTimeout = TimeoutRequired;
         }
         else
         {
            this.mVoiceBarType = sTYPE_SPEAK;
            this.mVoiceBarText = Text;
            this.mVoiceBarStatus = sSTATUS_OK;
            this.mVoiceBarTimeout = TimeoutRequired;
         }
      }
      
      public function cancel(bSilentMode:Boolean = true) : void
      {
         this.emitCancel(bSilentMode);
      }
      
      public function get promptText() : String
      {
         return this.mVoiceBarText;
      }
      
      public function get promptStatus() : String
      {
         return this.mVoiceBarStatus;
      }
      
      public function get promptType() : String
      {
         return this.mVoiceBarType;
      }
      
      public function get promptTimeout() : Boolean
      {
         return this.mVoiceBarTimeout;
      }
      
      public function pickList() : Array
      {
         return this.mList != null ? this.mList : new Array();
      }
      
      public function get listIsVisible() : Boolean
      {
         return this.mListVisible;
      }
      
      public function get lastGoto() : String
      {
         return this.mLastGoto;
      }
      
      public function get lastGotoOptions() : Object
      {
         return this.mLastArgument;
      }
      
      public function get VRSessionInProgress() : Boolean
      {
         return this.mVRSessionInProgress;
      }
      
      public function get VoiceRecognitionState() : String
      {
         return this.mVoiceRecognitionState;
      }
      
      public function get sessionType() : String
      {
         return this.mSessionType;
      }
      
      public function get listType() : String
      {
         return this.mListType;
      }
      
      public function get dataLoggingEnabled() : Boolean
      {
         return this.mDataLoggingEnabled;
      }
      
      public function set dataLoggingEnabled(_enabled:Boolean) : void
      {
         this.mDataLoggingEnabled = _enabled;
         this.client.send("{\"Type\":\"EmitVRSignal\",\"packet\":{\"dataLoggingEnabled\": { \"enabled\":\"" + this.mDataLoggingEnabled + "\" }}}");
      }
      
      public function emitStatus(result:String) : void
      {
         if(result == "success")
         {
            this.emitResponseSuccess();
         }
         else if(result == "invalid")
         {
            this.emitResponseInvalid();
         }
      }
      
      public function get isVRAvailable() : Boolean
      {
         return this.mVRRecState.availbleState;
      }
      
      public function get VRNotAvailableReason() : String
      {
         return this.mVRRecState.VRNotAvailableReason;
      }
      
      public function get isBusyProcessing() : Boolean
      {
         return this.mVRBusyProcessing;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE:
               this.sendSubscribe("vrDialogActive");
               this.sendSubscribe("vrAvailable");
               this.sendSubscribe("getProperties");
               break;
            case VoiceRecognitionEvent.VR_BUSY_PROCESSING:
               this.sendSubscribe("vrBusyProcessing");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE:
               this.sendUnsubscribe("getProperties");
               this.sendUnsubscribe("vrAvailable");
               break;
            case VoiceRecognitionEvent.VR_BUSY_PROCESSING:
               this.sendUnsubscribe("vrBusyProcessing");
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("vrAudioUpdate");
            this.sendSubscribe("vrDialogActive");
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + sDBUS_UISPEECH_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + sDBUS_UISPEECH_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendEmit(commandName:String, valueName:String, value:Object, useQuotes:Boolean = true, contextId:int = -1) : void
      {
         var message:String = null;
         if(contextId != -1)
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"context\": " + contextId + ",\"" + valueName + "\": ";
         }
         else if(null != this.mContextId)
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"context\": " + this.mContextId + ",\"" + valueName + "\": ";
            this.mContextId = null;
         }
         else
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"" + valueName + "\": ";
         }
         if(useQuotes)
         {
            message += "\"" + value + "\"}}}";
         }
         else
         {
            message += value + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendEmitBoolean(commandName:String, valueName:String, value:Boolean) : void
      {
         var message:String = null;
         if(null != this.mContextId)
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"context\": " + this.mContextId + ",\"" + valueName + "\": " + value + "}}}";
            this.mContextId = null;
         }
         else
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         this.client.send(message);
      }
      
      private function sendEmitInt(commandName:String, valueName:String, value:int) : void
      {
         var message:String = null;
         if(null != this.mContextId)
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"context\": " + this.mContextId + ",\"" + valueName + "\": " + value + "}}}";
            this.mContextId = null;
         }
         else
         {
            message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         this.client.send(message);
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var prop:String = null;
         var message:Object = e.data;
         try
         {
            for(prop in message)
            {
               this[prop] = message[prop];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function uiSpeechHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var prop:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty("getProperties"))
         {
            try
            {
               for(property in message.getProperties)
               {
                  this[property] = message.getProperties[property];
               }
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            try
            {
               for(prop in message)
               {
                  this[prop] = message[prop];
                  if("vrDialogActive" == prop)
                  {
                     dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,message));
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function checkContext(payload:Object) : void
      {
         if(payload != null && payload.hasOwnProperty("context"))
         {
            this.mContextId = payload.context;
         }
      }
      
      private function set showTeleprompter(payload:Object) : void
      {
         if(payload.hasOwnProperty("hardKeySessionType"))
         {
            this.mSessionType = payload.hardKeySessionType;
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_SESSION_TYPE));
         }
      }
      
      private function set removeSMSPopup(payload:Object) : void
      {
         this.dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.REMOVE_SMS_POPUP,payload));
      }
      
      private function set getControlPanelContext(payload:Object) : void
      {
         this.emitControlPanelContext(payload.context,payload.methodName);
      }
      
      private function set getListSize(payload:Object) : void
      {
         this.emitListSizeResponse(this.mListSize);
      }
      
      private function set updateVoiceBar(payload:Object) : void
      {
         var context:Number = Number(payload.context);
         var status:String = "failure";
         if(null != payload && payload.hasOwnProperty("textData") && payload.hasOwnProperty("iconType") && payload.hasOwnProperty("color"))
         {
            this.mVoiceBarText = payload.textData;
            this.mVoiceBarType = payload.iconType;
            this.mVoiceBarStatus = payload.color;
            if(payload.hasOwnProperty("timeoutRequired"))
            {
               this.mVoiceBarTimeout = payload.timeoutRequired;
            }
            else
            {
               this.mVoiceBarTimeout = true;
            }
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VOICE_PROMPT));
            status = "success";
         }
         this.emitHMIVRResponse(context,payload.methodName,status);
      }
      
      private function emitgetCurrentVideoContextResponse(context:Number, methodName:String) : void
      {
         var message:Object = null;
         trace("*<HMIModule> VoiceRecognition.emitgetCurrentVideoContextResponse \'" + this.mLastContext + "\'");
         var status:String = "failure";
         if("" != this.mLastContext)
         {
            status = "success";
         }
         message = {
            "Type":"ReturnVRResult",
            "response":"rsp_" + methodName,
            "context":context,
            "packet":{
               "result":status,
               "videoContext":this.mLastContext
            }
         };
         this.connection.send(message);
      }
      
      private function emitHMIVRResponse(context:Number, methodName:String, status:String) : void
      {
         var message:Object = null;
         message = {
            "Type":"ReturnVRResult",
            "response":"rsp_" + methodName,
            "context":context,
            "packet":{"result":status}
         };
         this.connection.send(message);
      }
      
      private function emitListSizeResponse(size:int) : void
      {
         var message:Object = null;
         message = {
            "Type":"ReturnVRResult",
            "response":"rsp_getListSize",
            "packet":{
               "result":"success",
               "listSize":size
            }
         };
         this.connection.send(message);
      }
      
      public function emitSmsVRResponse(context:Number, methodName:String, status:String, isAvail:Object = null, phoneNum:String = null, shown:Object = null, sender:Object = null, contactType:Object = null) : void
      {
         var message:Object = null;
         if(null != isAvail)
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{
                  "result":status,
                  "available":isAvail
               }
            };
         }
         else if(null != sender)
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{
                  "result":status,
                  "phoneNumber":phoneNum,
                  "senderName":sender,
                  "phoneCategory":contactType
               }
            };
         }
         else if(null != phoneNum)
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{
                  "result":status,
                  "phoneNumber":phoneNum
               }
            };
         }
         else if(null != shown)
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{
                  "result":status,
                  "messageShown":shown
               }
            };
         }
         else
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{"result":status}
            };
         }
         this.connection.send(message);
      }
      
      private function set removeVoiceBar(payload:Object) : void
      {
         var status:String = "failure";
         if(null != payload)
         {
            this.mVoiceBarType = sTYPE_PAUSE;
            status = "success";
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VOICE_PROMPT_REMOVE));
         }
         this.emitHMIVRResponse(payload.context,payload.methodName,status);
      }
      
      private function set showList(payload:Object) : void
      {
         this.mList = null;
         this.mListType = "";
         var status:String = "failure";
         if(payload != null && payload.hasOwnProperty("listItems"))
         {
            if(payload.hasOwnProperty("listItems"))
            {
               this.mList = payload.listItems;
            }
            if(payload.hasOwnProperty("listType"))
            {
               this.mListType = payload.listType;
            }
            this.mListVisible = true;
            status = "success";
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SHOW_LIST));
         }
         this.emitHMIVRResponse(payload.context,payload.methodName,status);
      }
      
      private function set hidePickList(payload:Object) : void
      {
         this.hideList = payload;
      }
      
      private function set hideList(payload:Object) : void
      {
         this.mListType = "";
         this.mListVisible = false;
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.HIDE_LIST));
         this.emitHMIVRResponse(payload.context,payload.methodName,"success");
      }
      
      private function set setFocusedItem(payload:Object) : void
      {
         var status:String = "failure";
         if(payload.hasOwnProperty("lineNumber"))
         {
            this.mListIndex = payload.lineNumber - 1;
            if(this.mListIndex >= this.mList.length || this.mListIndex < 0)
            {
               status = "invalid";
               this.emitHMIVRResponse(payload.context,payload.methodName,status);
            }
            else
            {
               status = "success";
               if(this.mList[this.mListIndex] != "" || this.mList[this.mListIndex] != "-")
               {
                  dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_INDEX,this.mListIndex));
               }
               this.emitHMIVRResponse(payload.context,payload.methodName,status);
            }
         }
         else
         {
            this.emitHMIVRResponse(payload.context,payload.methodName,status);
         }
      }
      
      private function set getFocusedItem(payload:Object) : void
      {
         this.emitIndexWithData(payload.context,payload.methodName);
      }
      
      private function set getDataLoggingEnabled(payload:Object) : void
      {
         var message:Object = null;
         message = {
            "Type":"ReturnVRResult",
            "response":"rsp_" + "getDataLoggingEnabled",
            "packet":{"enabled":this.mDataLoggingEnabled}
         };
         this.connection.send(message);
      }
      
      private function set setListPage(payload:Object) : void
      {
         var status:String = "failure";
         if(payload.hasOwnProperty("pageSet"))
         {
            if(payload.pageSet == "up")
            {
               status = "success";
               this.dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_PAGE_UP));
            }
            else if(payload.pageSet == "down")
            {
               status = "success";
               this.dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_PAGE_DOWN));
            }
         }
         this.emitHMIVRResponse(payload.context,payload.methodName,status);
      }
      
      private function set getListItemData(payload:Object) : void
      {
         this.emitIndexWithData(payload.context,payload.methodName);
      }
      
      private function set mediaFilterListShow(payload:Object) : void
      {
         if(null != payload && payload.hasOwnProperty("mediaType"))
         {
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_MEDIAFILTERLISTSHOW,payload));
         }
         else
         {
            this.emitHMIVRResponse(payload.context,payload.methodName,"failure");
         }
      }
      
      private function set vrAudioUpdate(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_AUDIOUPDATE,"mediaPlayer"));
      }
      
      private function set setVideo(payload:Object) : void
      {
         var data:Object = null;
         if(null != payload && payload.hasOwnProperty("videoScreen"))
         {
            this.mLastGoto = payload.videoScreen;
            data = {
               "videoScreen":payload.videoScreen,
               "context":payload.context,
               "methodName":payload.methodName
            };
            if(payload.hasOwnProperty("travellinkValue"))
            {
               if(payload.travellinkValue != -1)
               {
                  this.mLastArgument = payload.travellinkValue;
               }
            }
            if(payload.hasOwnProperty("albumFilterID"))
            {
               if(payload.albumFilterID != -1)
               {
                  this.mLastArgument = payload.albumFilterID;
               }
            }
            if(payload.hasOwnProperty("artistFilterID"))
            {
               if(payload.artistFilterID != -1)
               {
                  this.mLastArgument = payload.artistFilterID;
               }
            }
            if(payload.hasOwnProperty("audioBookFilterID"))
            {
               if(payload.audioBookFilterID != -1)
               {
                  this.mLastArgument = payload.audioBookFilterID;
               }
            }
            if(payload.hasOwnProperty("genreFilterID"))
            {
               if(payload.genreFilterID != -1)
               {
                  this.mLastArgument = payload.genreFilterID;
               }
            }
            if(payload.hasOwnProperty("playListFilterID"))
            {
               if(payload.playListFilterID != -1)
               {
                  this.mLastArgument = payload.playListFilterID;
               }
            }
            if(payload.hasOwnProperty("podcastFilterID"))
            {
               if(payload.podcastFilterID != -1)
               {
                  this.mLastArgument = payload.podcastFilterID;
               }
            }
            if(payload.hasOwnProperty("titleFilterID"))
            {
               if(payload.titleFilterID != -1)
               {
                  this.mLastArgument = payload.titleFilterID;
               }
            }
            else
            {
               this.mLastArgument = null;
            }
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_GOTO,data));
            if(!(this.mLastGoto == this.PHONE_SMS_MESSAGE || this.mLastGoto == this.PHONE_SMS_PREDEFINED_MESSAGES || this.mLastGoto == this.MEDIA_FOLDERS || this.mLastGoto == sMediaBrowse || this.mLastGoto == this.PHONE_RECENT_CALLS_ALL || this.mLastGoto == this.PHONE_RECENT_CALLS_INCOMING || this.mLastGoto == this.PHONE_RECENT_CALLS_MISSED || this.mLastGoto == this.PHONE_RECENT_CALLS_OUTGOING))
            {
               this.emitHMIVRResponse(payload.context,payload.methodName,"success");
            }
         }
         else
         {
            this.emitHMIVRResponse(payload.context,payload.methodName,"failure");
         }
      }
      
      private function set getCurrentVideoContext(payload:Object) : void
      {
         trace("*<HMIModule> VoiceRecognition.getCurrentVideoContext \'" + payload.context + "\'");
         this.emitgetCurrentVideoContextResponse(payload.context,payload.methodName);
      }
      
      private function set showSMSDictationAbortedPopup(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_DICTATION_ABORTED,payload));
         this.emitHMIVRResponse(payload.context,payload.methodName,"success");
      }
      
      private function set smsMessagePlay(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_MESSAGE_PLAY,payload));
      }
      
      private function set setDNDStatus(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.DND_STATUS,payload));
         this.emitHMIVRResponse(payload.context,payload.methodName,"success");
      }
      
      private function set smsMessageShow(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_MESSAGE_SHOW,payload));
      }
      
      private function set smsMessageSend(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_MESSAGE_SEND,payload));
      }
      
      private function set smsCheckNumber(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_CHECK_NUMBER,payload));
      }
      
      private function set smsGetDetails(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_GET_DETAILS,payload));
      }
      
      private function set sendIndexedSmstoNumber(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SMS_SEND_INDEXED_SMS_TO_NUMBER,payload));
      }
      
      private function set showContact(payload:Object) : void
      {
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.SHOW_CONTACT,payload));
      }
      
      private function set vrDialogActive(payload:Object) : void
      {
         if(payload.hasOwnProperty("state"))
         {
            this.mVRSessionInProgress = payload.state;
         }
         if(payload.hasOwnProperty("sessionType"))
         {
            if(this.mSessionType != payload.sessionType)
            {
               this.mSessionType = payload.sessionType;
               dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_SESSION_TYPE));
            }
         }
      }
      
      private function set voiceRecognition(payload:Object) : void
      {
         if(payload.hasOwnProperty("state"))
         {
            this.mVoiceRecognitionState = payload.state;
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_VOICE_RECOGNITION,payload));
         }
      }
      
      private function set vrBusyProcessing(payload:Object) : void
      {
         this.mVRBusyProcessing = payload.state;
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_BUSY_PROCESSING));
      }
      
      private function set vrAvailable(payload:Object) : void
      {
         if(this.mVRRecState.setup(payload.state,payload.state == false ? payload.reason : ""))
         {
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_AVAILABLE,this.mVRRecState.availbleState));
         }
      }
      
      private function set sendDTMFToneInfo(payload:Object) : void
      {
         this.mDtmfTone = payload.dtmfTone;
         dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.DTMF_TONE_INFO));
         this.emitHMIVRResponse(payload.context,payload.methodName,"success");
      }
      
      private function emitControlPanelContext(context:Number, methodName:String) : void
      {
         var message:Object = null;
         message = {
            "Type":"ReturnVRResult",
            "response":"rsp_" + methodName,
            "context":context,
            "packet":{
               "result":"success",
               "controlPanelContext":this.mControlPanelContext
            }
         };
         this.connection.send(message);
      }
      
      private function emitCancel(bSilentMode:Boolean) : void
      {
         if(this.mVRSessionInProgress)
         {
            this.sendEmit("cancelVR","silentMode",bSilentMode,false);
         }
      }
      
      public function emitVRResponse(context:Number, methodName:String, result:Boolean) : void
      {
         var status:String = "failure";
         status = result ? "success" : "failure";
         this.emitHMIVRResponse(context,methodName,status);
      }
      
      public function emitInvalidVRResponse(context:Number, methodName:String) : void
      {
         this.emitHMIVRResponse(context,methodName,"invalid");
      }
      
      public function emitPTTPress() : void
      {
         var message:String = null;
         message = "{\"Type\":\"EmitVRSignal\",\"packet\":{\"PTT_Press\":{\"press\":\"short\"}}}";
         this.client.send(message);
      }
      
      private function emitContext() : void
      {
         var message:Object = null;
         trace("*<HMIModule> VoiceRecognition.emitContext \'" + this.mLastContext + "\'");
         if(null != this.mContextId)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":Number(this.mContextId),
                  "response":{
                     "result":"success",
                     "videoContext":this.mLastContext
                  }
               }}
            };
         }
         else
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{"response":{
                  "result":"success",
                  "videoContext":this.mLastContext
               }}}
            };
         }
         this.connection.send(message);
      }
      
      private function emitIndex() : void
      {
         var message:Object = null;
         if(null != this.mContextId)
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "context":Number(this.mContextId),
                  "response":{
                     "result":"success",
                     "lineNumber":this.mListIndex
                  }
               }}
            };
         }
         else
         {
            message = {
               "Type":"EmitVRSignal",
               "packet":{"vrResponse":{
                  "videoContext":this.mLastContext,
                  "response":{
                     "result":"success",
                     "lineNumber":this.mListIndex
                  }
               }}
            };
         }
         this.connection.send(message);
      }
      
      private function emitIndexWithData(context:Number, methodName:String) : void
      {
         var message:Object = null;
         var listData:String = null;
         if(this.mListIndex <= this.mList.length)
         {
            listData = this.mList[this.mListIndex - 1];
         }
         if(null != listData)
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{
                  "result":"success",
                  "lineNumber":this.mListIndex
               }
            };
         }
         else
         {
            message = {
               "Type":"ReturnVRResult",
               "response":"rsp_" + methodName,
               "context":context,
               "packet":{"result":"failure"}
            };
         }
         this.connection.send(message);
      }
      
      private function emitSelect() : void
      {
         this.sendEmit("listItemTouch","","");
      }
      
      private function emitLanguage() : void
      {
      }
      
      private function emitUnknownString() : void
      {
      }
      
      private function emitResponseSuccessWithContext(contextId:int) : void
      {
         this.sendEmit("vrResponse","response","{\"result\":\"success\"}",false,contextId);
      }
      
      private function emitResponseSuccess() : void
      {
         this.sendEmit("vrResponse","response","{\"result\":\"success\"}",false);
      }
      
      private function emitResponseFailure() : void
      {
         this.sendEmit("vrResponse","response","{\"result\":\"failure\"}",false);
      }
      
      private function emitResponseInvalid() : void
      {
         this.sendEmit("vrResponse","response","{\"result\":\"invalid\"}",false);
      }
      
      public function get dtmfToneInfo() : String
      {
         return this.mDtmfTone;
      }
      
      public function set dtmfToneInfo(dtmfTone:String) : void
      {
         this.mDtmfTone = dtmfTone;
      }
   }
}

