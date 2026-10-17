package com.nfuzion.moduleLinkAPI
{
   public interface ISatelliteRadio extends IModule
   {
      
      function get SORT_CATEGORY_DESCENDING() : String;
      
      function get SORT_CATEGORY_ASCENDING() : String;
      
      function get SORT_CHANNEL_DESCENDING() : String;
      
      function get SORT_CHANNEL_ASCENDING() : String;
      
      function get isAvailable() : Boolean;
      
      function requestSubscribed() : void;
      
      function get subscribed() : Boolean;
      
      function subscriptionStatus(param1:String) : int;
      
      function get SUBSCRIPTION_AUDIO() : String;
      
      function get SUBSCRIPTION_TRAVELLINK() : String;
      
      function get SUBSCRIPTION_TRAFFIC() : String;
      
      function get SUBSCRIPTION_GRAPHICAL_WEATHER() : String;
      
      function get SUBSCRIPTION_FUEL() : String;
      
      function get SUBSCRIPTION_WEATHER() : String;
      
      function get SUBSCRIPTION_MOVIES() : String;
      
      function get SUBSCRIPTION_SPORTS() : String;
      
      function get SUBSCRIPTION_SECURITY_ALERTS() : String;
      
      function requestAntennaStatus() : void;
      
      function antennaStatus() : String;
      
      function requestSignalQuality() : void;
      
      function get signalQuality() : Number;
      
      function requestWeatherTrafficChannels() : void;
      
      function get weatherTrafficChannelList() : Vector.<SatelliteRadioTrafficChannel>;
      
      function setJumpChannel(param1:SatelliteRadioTrafficChannel) : void;
      
      function get jumpChannel() : SatelliteRadioTrafficChannel;
      
      function requestAvailableChannels() : void;
      
      function requestChannelMap() : void;
      
      function get channelNumberList() : Vector.<int>;
      
      function requestChannels(param1:int = 0, param2:int = 10, param3:String = "CHANNEL_ASCENDING", param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : void;
      
      function get channelListLength() : uint;
      
      function get channelList() : Vector.<SatelliteRadioChannel>;
      
      function setCurrentChannelByNumber(param1:int) : void;
      
      function setChannelToPrevious() : void;
      
      function presetRecall(param1:int) : void;
      
      function setCurrentChannelByIndex(param1:int) : void;
      
      function get currentChannelIndex() : int;
      
      function get seekStatus() : Boolean;
      
      function requestCurrentStationInfo() : void;
      
      function get currentChannel() : SatelliteRadioChannel;
      
      function seekUp() : void;
      
      function seekDown() : void;
      
      function seekRelease() : void;
      
      function scanUp() : void;
      
      function scanDown() : void;
      
      function scanCancel() : void;
      
      function setChannelSkip(param1:String, param2:Boolean) : void;
      
      function requestSkippedChannels() : void;
      
      function get skippedChannels() : Vector.<int>;
      
      function setChannelLock(param1:String, param2:Boolean) : void;
      
      function requestLockedChannels() : void;
      
      function get lockedChannels() : Vector.<int>;
      
      function requestAppStatus() : void;
      
      function get appStatus() : String;
      
      function requestAdvisoryMessage() : void;
      
      function get advisoryMessage() : String;
      
      function requestESN() : void;
      
      function get SatESN() : String;
      
      function requestLeagueList() : void;
      
      function get leagueList() : Vector.<GameZoneLeagues>;
      
      function requestTeamList(param1:uint) : void;
      
      function getTeamList(param1:GameZoneLeagues) : Vector.<GameZoneFavoriteTeam>;
      
      function addFavoriteTeam(param1:uint, param2:uint, param3:String) : Boolean;
      
      function removeFavoriteTeam(param1:uint, param2:uint) : void;
      
      function removeAllTeams() : void;
      
      function requestFavoriteTeamsList() : void;
      
      function get favoriteTeamsList() : Vector.<GameZoneFavoriteTeam>;
      
      function enableStartOfGameAlert(param1:Boolean) : void;
      
      function get startOfGameAlertStatus() : Boolean;
      
      function enableScoreChangeAlert(param1:Boolean) : void;
      
      function get scoreChangeAlertStatus() : Boolean;
      
      function requestActiveGameEvents() : void;
      
      function get activeGames() : Vector.<GameAlert>;
      
      function requestActiveScoreEvents() : void;
      
      function requestScoreAlertEvents() : void;
      
      function requestActiveScores() : void;
      
      function get activeScores() : Vector.<GameZoneScoreAlert>;
      
      function addSongAsFavorite(param1:int) : Boolean;
      
      function addArtistAsFavorite(param1:int) : Boolean;
      
      function addFavorite(param1:SatelliteRadioFavorite) : Boolean;
      
      function deleteFavorite(param1:SatelliteRadioFavorite) : void;
      
      function deleteAllFavorites() : void;
      
      function set favoriteAlertType(param1:String) : void;
      
      function get favoriteAlertType() : String;
      
      function enableFavoriteSeek(param1:SatelliteRadioFavorite) : void;
      
      function disableFavoriteSeek(param1:SatelliteRadioFavorite) : void;
      
      function requestFavorites() : void;
      
      function get currentFavoriteList() : Vector.<SatelliteRadioFavorite>;
      
      function requestActiveFavorites() : void;
      
      function get activeFavoriteList() : Vector.<SatelliteRadioActiveFavorite>;
      
      function get isFavoriteArtistAllowed() : Boolean;
      
      function get isFavoriteSongAllowed() : Boolean;
      
      function get favoriteAudioAlertsList() : Vector.<SatelliteRadioActiveFavorite>;
      
      function setGMTOffset(param1:int, param2:Boolean) : void;
      
      function get wasActiveChannelUnsubscribed() : Boolean;
      
      function set wasActiveChannelUnsubscribed(param1:Boolean) : void;
      
      function requestDataServicesSubscriptionStatus() : void;
      
      function requestEnableICSTuning() : void;
      
      function requestDisableICSTuning() : void;
      
      function trafficJumpButtonPress() : void;
      
      function trafficJumpCancel() : void;
      
      function get trafficJumpStatus() : String;
      
      function deselectTrafficMarket() : void;
      
      function requestDataServicesState() : void;
      
      function get dataServicesState() : Vector.<DataServicesState>;
      
      function requestTuneStartStatus() : void;
      
      function get TuneStartStatus() : int;
      
      function TuneStartEnabled(param1:Boolean) : void;
      
      function get TuneStartUnsupported() : int;
      
      function get TuneStartIsDisabled() : int;
      
      function get TuneStartIsEnabled() : int;
      
      function requestFeaturedFavoritesList() : void;
      
      function get featuredFavoritesList() : Vector.<SatelliteRadioFeaturedFavoriteBand>;
      
      function requestFeaturedFavorites(param1:int) : void;
      
      function get featuredFavorites() : Vector.<SatelliteRadioFeaturedFavorite>;
      
      function set suppressFavOnAirNotifications(param1:Boolean) : void;
      
      function get favoriteAlertState() : String;
      
      function requestXMAppVersion() : void;
      
      function get XMAppVersion() : String;
   }
}

