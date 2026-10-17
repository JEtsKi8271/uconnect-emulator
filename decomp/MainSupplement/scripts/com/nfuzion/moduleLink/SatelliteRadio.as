package com.nfuzion.moduleLink
{
   import com.harman.moduleLink.VersionInfo;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.harman.moduleLinkAPI.SatAdvisoryMessageTypes;
   import com.nfuzion.moduleLinkAPI.DataServicesState;
   import com.nfuzion.moduleLinkAPI.DataServicesSubscriptionStatus;
   import com.nfuzion.moduleLinkAPI.GameAlert;
   import com.nfuzion.moduleLinkAPI.GameZoneFavoriteTeam;
   import com.nfuzion.moduleLinkAPI.GameZoneLeagues;
   import com.nfuzion.moduleLinkAPI.GameZoneScoreAlert;
   import com.nfuzion.moduleLinkAPI.ISatelliteRadio;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioActiveFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioCategory;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioCategoryList;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioChannel;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioChannelList;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFeaturedFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFeaturedFavoriteBand;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioPreset;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioTrafficChannel;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class SatelliteRadio extends Module implements ISatelliteRadio
   {
      
      private static var instance:SatelliteRadio;
      
      private static const mDbusIdentifier:String = "XMApp";
      
      private static const mXMFavoritesDbusID:String = "XMFavorites";
      
      private static const mXMGameZoneDbusID:String = "XMGameZone";
      
      private static const mXMPersistencyDbusID:String = "XMPersistency";
      
      private static const mXMTrafficJumpDbusID:String = "XMTrafficJump";
      
      private static const mVehicleStatusDbusID:String = "VehicleStatus";
      
      private static const mVehicleConfigDbusID:String = "VehicleConfig";
      
      private static const mJumpStatusDbusID:String = "jumpStatus";
      
      private static const browseOrderChannel:int = 1;
      
      private static const browseOrderCategory:int = 2;
      
      private static const MAX_NUMBER_OF_FAVORITES:int = 200;
      
      private static const MAX_NUMBER_OF_GAME_FAVORITES:int = 10;
      
      private static const AUDIO_SUBSTATUS_NOTSUBSCRIBED:int = 0;
      
      private static const AUDIO_SUBSTATUS_SUBSCRIBED:int = 1;
      
      private static const AUDIO_SUBSTATUS_INVALID:int = 2;
      
      private static const AUDIO_SUBSTATUS_SUSPEND:int = 3;
      
      private static const AUDIO_SUBSTATUS_SUSPENDALERT:int = 4;
      
      private static const AUDIO_SUBSTATUS_UNKNOWN:int = 255;
      
      private static const mTesting:Boolean = false;
      
      private static const mDestinationCountryUS:String = "2";
      
      private static const mDestinationCountryCanada:String = "4";
      
      private static const HAS_SDARS:String = "YES";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mAppStatus:String = "NOT_READY";
      
      private var mAdvisoryMsg:String = "NO ERROR";
      
      private var mSignalStrength:int = 1;
      
      private var mESN:String = "UNKNOWN";
      
      private var mXMAppVersion:String = "";
      
      private var mCurrentStationInfo:SatelliteRadioChannel = new SatelliteRadioChannel();
      
      private var mPresets:Vector.<SatelliteRadioPreset> = new Vector.<SatelliteRadioPreset>();
      
      private var mIsScanning:Boolean = false;
      
      private var mBrowseOrder:int = 1;
      
      private var mCompleteChannelList:SatelliteRadioFullChannelList;
      
      private var mCompleteCategoryList:SatelliteRadioCategoryList;
      
      private var mAvailableChannelList:Vector.<int> = new Vector.<int>();
      
      private var mSkippedChannels:Vector.<int> = new Vector.<int>();
      
      private var mLockedChannels:Vector.<int> = new Vector.<int>();
      
      private var mUnsubscribedChannels:Vector.<int> = new Vector.<int>();
      
      private var mRequestedChannelList:Vector.<SatelliteRadioChannel>;
      
      private var mWeatherTrafficChannelList:Vector.<SatelliteRadioTrafficChannel>;
      
      private var mWeatherTrafficChannel:SatelliteRadioTrafficChannel;
      
      private var mJumpStatus:String = "JUMP_MARKET_UNDEFINED";
      
      private var mTeamList:Vector.<GameZoneFavoriteTeam> = new Vector.<GameZoneFavoriteTeam>();
      
      private var mFavoriteTeamList:Vector.<GameZoneFavoriteTeam> = new Vector.<GameZoneFavoriteTeam>();
      
      private var mActiveGames:Vector.<GameAlert> = new Vector.<GameAlert>();
      
      private var mLeagueList:Vector.<GameZoneLeagues> = new Vector.<GameZoneLeagues>();
      
      private var mScores:Vector.<GameZoneScoreAlert> = new Vector.<GameZoneScoreAlert>();
      
      private var mFavorites:Vector.<SatelliteRadioFavorite> = new Vector.<SatelliteRadioFavorite>();
      
      private var mHasFavorites:Boolean = false;
      
      private var mGameAlertsEnabled:Boolean = false;
      
      private var mScoreAlertsEnabled:Boolean = false;
      
      private var mFavTeamLength:uint = 0;
      
      private var mTeenKeyDetected:Boolean = false;
      
      private var mTeenKeyFeaturePresent:Boolean = false;
      
      private var mActiveFavorites:Vector.<SatelliteRadioActiveFavorite> = new Vector.<SatelliteRadioActiveFavorite>();
      
      private var mFavoriteAudioAlerts:Vector.<SatelliteRadioActiveFavorite> = new Vector.<SatelliteRadioActiveFavorite>();
      
      private var mAudioFavoritesAlertType:String = "visual";
      
      private var mIsFavoriteArtistAllowed:Boolean = false;
      
      private var mIsFavoriteSongAllowed:Boolean = false;
      
      private var mTuneStartStatus:int;
      
      private var mFavoriteOnAirBubbleSuppressed:Boolean = false;
      
      private var mFavoriteAlertState:String = "none";
      
      private var mFeaturedFavoritesList:Vector.<SatelliteRadioFeaturedFavoriteBand> = new Vector.<SatelliteRadioFeaturedFavoriteBand>();
      
      private var mFeaturedFavorites:Vector.<SatelliteRadioFeaturedFavorite> = new Vector.<SatelliteRadioFeaturedFavorite>();
      
      private var mAudioSubscriptionStatus:int = 255;
      
      private var mTLSubscriptionStatus:int = 255;
      
      private var mTrafficSubscriptionStatus:int = 255;
      
      private var mWeatherSubscriptionStatus:int = 255;
      
      private var mCurrentTrafficChannels:Object = null;
      
      private var mCurrentTrafficJump:Object = null;
      
      private var mDataServicesSubscriptionStatus:DataServicesSubscriptionStatus = new DataServicesSubscriptionStatus();
      
      private var mCurrentPresetChannelNumber:int = -1;
      
      private var mIsSeeking:Boolean = false;
      
      private var mWasActiveChannelUnsubscribed:Boolean = false;
      
      private var mXMAppServiceAvailable:Boolean = false;
      
      private var mXMGameZoneServiceAvailable:Boolean = false;
      
      private var mXMFavoritesServiceAvailable:Boolean = false;
      
      private var mXMTrafficJumpServiceAvailable:Boolean = false;
      
      private var mPersistencyServiceAvailable:Boolean = false;
      
      private var mDataServicesStateList:Vector.<DataServicesState> = new Vector.<DataServicesState>();
      
      public function SatelliteRadio()
      {
         this.mTuneStartStatus = this.TuneStartUnsupported;
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_CONFIG,this.VehicleConfigMessageHandler);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_STATUS,this.VehicleStatusMessageHandler);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_RADIO,this.XMAppMessageHandler);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_GAMEZONE,this.XMGameZoneMessageHandler);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_FAVORITES,this.XMFavortiesMessageHandler);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_TRAFFIC_JUMP,this.XMTrafficJumpMessageHandler);
         this.connection.addEventListener(ConnectionEvent.SATELLITE_PERSISTENCY,this.persistencyMessageHandler);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_STATUS,this.VehicleStatusMessageHandler);
         if(this.client.connected)
         {
            this.connected();
         }
         this.mAvailableChannelList.push(0);
         this.mCompleteChannelList = new SatelliteRadioFullChannelList();
         this.InitializeCompleteChannelList();
      }
      
      public static function getInstance() : SatelliteRadio
      {
         if(instance == null)
         {
            instance = new SatelliteRadio();
         }
         return instance;
      }
      
      public function get isAvailable() : Boolean
      {
         var vehDest:String = VehConfig.getInstance().vehicleDestination;
         var productVariant:ProductVariantID = VersionInfo.getInstance().productVariantID;
         var available:Boolean = false;
         if(productVariant.VARIANT_SDARS == HAS_SDARS)
         {
            available = vehDest == mDestinationCountryUS || vehDest == mDestinationCountryCanada;
         }
         return available;
      }
      
      private function InitializeCompleteChannelList() : void
      {
         var ch:SatelliteRadioChannel = null;
         ch = new SatelliteRadioChannel();
         ch.artist = "";
         ch.category = "";
         ch.categoryNum = 255;
         ch.sid = 0;
         ch.name = "";
         ch.content = "";
         ch.isArtistFavorite = false;
         ch.isSongFavorite = false;
         ch.logoUrl = "img/I00000T01.png";
         ch.title = "";
         ch.number = 0;
         ch.replay = true;
         this.mCompleteChannelList.addChannel(ch);
         this.mCompleteChannelList.updateLength(this.mAvailableChannelList.length);
      }
      
      public function get SORT_CATEGORY_DESCENDING() : String
      {
         return SatelliteRadioChannelList.mSortCategoryDescending;
      }
      
      public function get SORT_CATEGORY_ASCENDING() : String
      {
         return SatelliteRadioChannelList.mSortCategoryAscending;
      }
      
      public function get SORT_CHANNEL_DESCENDING() : String
      {
         return SatelliteRadioChannelList.mSortChannelDescending;
      }
      
      public function get SORT_CHANNEL_ASCENDING() : String
      {
         return SatelliteRadioChannelList.mSortChannelAscending;
      }
      
      public function connected(e:Event = null) : void
      {
         trace("tuner connected event received");
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendXMAppAvailableRequest();
            this.sendXMGameZoneAvailableRequest();
            this.sendXMFavortiesAvailableRequest();
            this.sendXMTrafficJumpAvailableRequest();
            this.sendPersistencyAvailableRequest();
            this.sendVehConfigAvailableRequest();
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
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case SatelliteRadioEvent.ALL_AUDIO_FAVORITES:
               this.requestFavorites();
               break;
            case SatelliteRadioEvent.ACTIVE_AUDIO_FAVORITES:
               break;
            case SatelliteRadioEvent.ACTIVE_GAME:
               this.sendSubscribeToId(mXMGameZoneDbusID,"activeGame");
               break;
            case SatelliteRadioEvent.SCORE_ALERT:
               this.sendSubscribeToId(mXMGameZoneDbusID,"scoreAlert");
               break;
            case SatelliteRadioEvent.ACTIVE_SCORES:
               this.sendSubscribeToId(mXMGameZoneDbusID,"activeScores");
               break;
            case SatelliteRadioEvent.ADVISORY_MESSAGE:
               this.sendSubscribe("advisoryMsg");
               break;
            case SatelliteRadioEvent.ANTENNA_STATUS:
               addInterest(SatelliteRadioEvent.ADVISORY_MESSAGE);
               break;
            case SatelliteRadioEvent.APP_STATUS:
            case SatelliteRadioEvent.AVAILABLE_CHANNELS:
            case SatelliteRadioEvent.CATEGORIES:
            case SatelliteRadioEvent.CHANNELS:
               break;
            case SatelliteRadioEvent.CURRENT_CHANNEL:
               this.sendSubscribe("currentStationInfo");
               break;
            case SatelliteRadioEvent.ESN:
               break;
            case SatelliteRadioEvent.LEAGUES:
               this.sendSubscribeToId(mXMGameZoneDbusID,"leagueList");
               break;
            case SatelliteRadioEvent.SIGNAL_QUALITY:
            case SatelliteRadioEvent.SUBSCRIBED:
               break;
            case SatelliteRadioEvent.SKIPPED_CHANNELS:
               this.sendSubscribe("skippedChannelList");
               break;
            case SatelliteRadioEvent.TEAMS:
               this.sendSubscribeToId(mXMGameZoneDbusID,"teamList");
               break;
            case SatelliteRadioEvent.FAVORITE_TEAMS:
               this.sendSubscribeToId(mXMGameZoneDbusID,"currentTeamFavorites");
               break;
            case SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS:
               break;
            case SatelliteRadioEvent.LOCKED_CHANNELS:
               this.sendSubscribe("lockedChannelList");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendGameCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendCommandToId(mXMGameZoneDbusID,commandName,valueName,value,addQuotesOnValue);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendCommandToId(mDbusIdentifier,commandName,valueName,value,addQuotesOnValue);
      }
      
      private function sendCommandToId(id:String, commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      protected function sendGetProperties(value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendGetPropertiesToId(mDbusIdentifier,value,addQuotesOnValue);
      }
      
      protected function sendGetPropertiesToId(id:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "props" + "\": [\"" + value + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendGetAllPropertiesToId(id:String) : void
      {
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribeToId(id:String, signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + id + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendSubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function requestSubscribed() : void
      {
         this.sendGetProperties("audioSubscriptionStatus");
         this.sendGetProperties("dataServicesSubscriptionStatus");
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SUBSCRIBED));
         }
      }
      
      public function get subscribed() : Boolean
      {
         return this.mAudioSubscriptionStatus == 1;
      }
      
      public function subscriptionStatus(type:String) : int
      {
         var subStatus:int = DataServicesSubscriptionStatus.subscribedUnknown;
         switch(type)
         {
            default:
            case this.SUBSCRIPTION_AUDIO:
               subStatus = this.mAudioSubscriptionStatus;
               break;
            case this.SUBSCRIPTION_GRAPHICAL_WEATHER:
               subStatus = this.mDataServicesSubscriptionStatus.mGraphicalWeatherSubStatus;
               break;
            case this.SUBSCRIPTION_TRAFFIC:
               subStatus = this.mDataServicesSubscriptionStatus.mTrafficSubStatus;
               break;
            case this.SUBSCRIPTION_FUEL:
               subStatus = this.mDataServicesSubscriptionStatus.mFuelSubStatus;
               break;
            case this.SUBSCRIPTION_WEATHER:
               subStatus = this.mDataServicesSubscriptionStatus.mLandWeatherSubStatus;
               break;
            case this.SUBSCRIPTION_MOVIES:
               subStatus = this.mDataServicesSubscriptionStatus.mMoviesSubStatus;
               break;
            case this.SUBSCRIPTION_SPORTS:
               subStatus = this.mDataServicesSubscriptionStatus.mSportsSubStatus;
               break;
            case this.SUBSCRIPTION_SECURITY_ALERTS:
               subStatus = this.mDataServicesSubscriptionStatus.mSecurityAlertsSubStatus;
               break;
            case this.SUBSCRIPTION_TRAVELLINK:
               if(this.mDataServicesSubscriptionStatus.mFuelSubStatus == DataServicesSubscriptionStatus.subscribedYes || this.mDataServicesSubscriptionStatus.mLandWeatherSubStatus == DataServicesSubscriptionStatus.subscribedYes || this.mDataServicesSubscriptionStatus.mMoviesSubStatus == DataServicesSubscriptionStatus.subscribedYes || this.mDataServicesSubscriptionStatus.mSportsSubStatus == DataServicesSubscriptionStatus.subscribedYes || this.mDataServicesSubscriptionStatus.mGraphicalWeatherSubStatus == DataServicesSubscriptionStatus.subscribedYes)
               {
                  subStatus = DataServicesSubscriptionStatus.subscribedYes;
               }
               else if(this.mDataServicesSubscriptionStatus.mFuelSubStatus == DataServicesSubscriptionStatus.subscribedUnknown || this.mDataServicesSubscriptionStatus.mLandWeatherSubStatus == DataServicesSubscriptionStatus.subscribedUnknown || this.mDataServicesSubscriptionStatus.mMoviesSubStatus == DataServicesSubscriptionStatus.subscribedUnknown || this.mDataServicesSubscriptionStatus.mSportsSubStatus == DataServicesSubscriptionStatus.subscribedUnknown || this.mDataServicesSubscriptionStatus.mGraphicalWeatherSubStatus == DataServicesSubscriptionStatus.subscribedUnknown)
               {
                  subStatus = DataServicesSubscriptionStatus.subscribedUnknown;
               }
               else
               {
                  subStatus = DataServicesSubscriptionStatus.subscribedNo;
               }
         }
         return subStatus;
      }
      
      public function get SUBSCRIPTION_AUDIO() : String
      {
         return "audio";
      }
      
      public function get SUBSCRIPTION_GRAPHICAL_WEATHER() : String
      {
         return "graphicalweather";
      }
      
      public function get SUBSCRIPTION_TRAFFIC() : String
      {
         return "traffic";
      }
      
      public function get SUBSCRIPTION_FUEL() : String
      {
         return "fuel";
      }
      
      public function get SUBSCRIPTION_WEATHER() : String
      {
         return "weather";
      }
      
      public function get SUBSCRIPTION_MOVIES() : String
      {
         return "movies";
      }
      
      public function get SUBSCRIPTION_SPORTS() : String
      {
         return "sports";
      }
      
      public function get SUBSCRIPTION_SECURITY_ALERTS() : String
      {
         return "securityalerts";
      }
      
      public function get SUBSCRIPTION_TRAVELLINK() : String
      {
         return "travellink";
      }
      
      public function requestAntennaStatus() : void
      {
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ANTENNA_STATUS));
         }
      }
      
      public function antennaStatus() : String
      {
         return "ANTENNA_OK";
      }
      
      public function requestSignalQuality() : void
      {
         this.sendGetProperties("signalStrength");
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SIGNAL_QUALITY));
         }
      }
      
      public function get signalQuality() : Number
      {
         return this.mSignalStrength;
      }
      
      public function requestDataServicesState() : void
      {
         this.sendGetProperties("dataServicesState");
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.DATA_SERVICES_STATE));
         }
      }
      
      public function get dataServicesState() : Vector.<DataServicesState>
      {
         return this.mDataServicesStateList;
      }
      
      public function setChannelSort(sort:String) : void
      {
         if(sort == SatelliteRadioChannelList.mSortChannelAscending)
         {
            this.mCompleteChannelList.sort(0,0);
         }
         else if(sort == SatelliteRadioChannelList.mSortCategoryAscending)
         {
            this.mCompleteChannelList.sort(1,0);
         }
         else if(sort == SatelliteRadioChannelList.mSortChannelDescending)
         {
            this.mCompleteChannelList.sort(0,1);
         }
         else if(sort == SatelliteRadioChannelList.mSortCategoryDescending)
         {
            this.mCompleteChannelList.sort(1,0);
         }
         else if(sort == "sortOnAir")
         {
            this.mCompleteChannelList.sort(0,0);
         }
      }
      
      public function requestChannelSort() : void
      {
      }
      
      public function get channelSort() : String
      {
         return this.mCompleteChannelList.sortOrder;
      }
      
      public function requestChannels(index:int = 0, length:int = 20, sorting:String = "CHANNEL_ASCENDING", includeSkipped:Boolean = false, includeLocked:Boolean = false, includeUnsubscribed:Boolean = false) : void
      {
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.CHANNELS));
         }
         else
         {
            this.mCompleteChannelList.filter(includeSkipped,includeLocked,includeUnsubscribed);
            this.setChannelSort(sorting);
            this.mRequestedChannelList = this.mCompleteChannelList.slice(index,index + length);
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.CHANNELS));
         }
      }
      
      public function get channelList() : Vector.<SatelliteRadioChannel>
      {
         if(this.mCompleteChannelList.length <= 1)
         {
            this.requestChannelMap();
         }
         return this.mRequestedChannelList;
      }
      
      public function get channelListLength() : uint
      {
         return this.mCompleteChannelList.length;
      }
      
      public function setCurrentChannelByNumber(channelNumber:int) : void
      {
         this.sendCommand("channelSelect","station",channelNumber);
      }
      
      public function setChannelToPrevious() : void
      {
         this.sendCommand("tunePreviousChannel",null,null);
      }
      
      public function setCurrentChannelByIndex(channelIndex:int) : void
      {
         this.sendCommand("channelSelect","station",this.mCompleteChannelList.list[channelIndex].number);
      }
      
      public function requestCurrentChannelIndex() : void
      {
      }
      
      public function get currentChannelIndex() : int
      {
         return this.mCompleteChannelList.find(this.mCurrentStationInfo);
      }
      
      public function requestCurrentStationInfo() : void
      {
         this.sendGetProperties("currentStationInfo");
      }
      
      public function get currentChannel() : SatelliteRadioChannel
      {
         return this.mCurrentStationInfo;
      }
      
      public function get seekStatus() : Boolean
      {
         return this.mIsSeeking;
      }
      
      public function requestJumpStatus() : void
      {
         this.sendGetPropertiesToId(mXMTrafficJumpDbusID,mJumpStatusDbusID);
      }
      
      public function requestWeatherTrafficChannels() : void
      {
         if(null != this.mWeatherTrafficChannelList && this.mWeatherTrafficChannelList.length > 0)
         {
            this.buildTrafficChannels();
         }
         this.sendGetPropertiesToId("XMTrafficJump","trafficList");
      }
      
      public function requestCurrentWeatherTrafficChannel() : void
      {
         this.sendGetPropertiesToId(mXMTrafficJumpDbusID,"selectedMarket");
      }
      
      public function get weatherTrafficChannelList() : Vector.<SatelliteRadioTrafficChannel>
      {
         return this.mWeatherTrafficChannelList;
      }
      
      public function set suppressFavOnAirNotifications(suppressed:Boolean) : void
      {
         this.mFavoriteOnAirBubbleSuppressed = suppressed;
         if(this.mFavoriteOnAirBubbleSuppressed)
         {
            this.mFavoriteAlertState = SatelliteRadioFavorite.NONE;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.FAVORITE_ALERT));
         }
      }
      
      public function setJumpChannel(channel:SatelliteRadioTrafficChannel) : void
      {
         var message:Object = null;
         this.mWeatherTrafficChannel = channel;
         this.mCurrentTrafficJump = null;
         if(null == channel)
         {
            this.sendCommandToId(mXMTrafficJumpDbusID,"cancelJump",null,null);
         }
         else
         {
            message = {
               "Type":"Command",
               "Dest":mXMTrafficJumpDbusID,
               "packet":{"selectTrafficMarket":{"marketID":channel.marketIdentifer}}
            };
            this.connection.send(message);
         }
      }
      
      public function get jumpChannel() : SatelliteRadioTrafficChannel
      {
         return this.mWeatherTrafficChannel;
      }
      
      public function get channelNumberList() : Vector.<int>
      {
         return this.mAvailableChannelList;
      }
      
      public function seekUp() : void
      {
         this.mIsSeeking = true;
         this.sendCommand("seekUpPress",null,null);
      }
      
      public function seekDown() : void
      {
         this.mIsSeeking = true;
         this.sendCommand("seekDownPress",null,null);
      }
      
      public function seekRelease() : void
      {
         this.mIsSeeking = false;
         this.sendCommand("seekRelease",null,null);
      }
      
      public function setChannelSkip(channels:String, skip:Boolean) : void
      {
         var channelInt:int = 0;
         var index:int = 0;
         var channel:SatelliteRadioChannel = null;
         var channelArray:Array = channels.split(",");
         var i:int = 0;
         if(channelArray[0] == "skip")
         {
            channelArray.shift();
            this.sendCommand("skipChannel","channelList","[" + channelArray.toString() + "]",false);
            return;
         }
         if(channelArray[0] == "clear")
         {
            channelArray.shift();
            this.sendCommand("clearSkipChannel","channelList","[" + channelArray.toString() + "]",false);
            return;
         }
         if(channels == "")
         {
            channelArray = new Array();
            for each(channel in this.mCompleteChannelList.list)
            {
               if(!(channel.number == 0 || channel.number == 1))
               {
                  channelArray.push(channel.number.toString());
               }
            }
         }
         if(skip)
         {
            for(i = 0; i < channelArray.length; i++)
            {
               channelInt = int(channelArray[i]);
               index = this.mSkippedChannels.indexOf(channelInt,0);
               if(index < 0)
               {
                  this.mSkippedChannels.push(channelInt);
               }
            }
         }
         else
         {
            for(i = 0; i < channelArray.length; i++)
            {
               channelInt = int(channelArray[i]);
               index = this.mSkippedChannels.indexOf(channelInt,0);
               if(index >= 0)
               {
                  this.mSkippedChannels.splice(index,1);
               }
            }
         }
         this.mCompleteChannelList.updateSkippedChannels(this.mSkippedChannels);
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SKIPPED_CHANNELS));
      }
      
      public function requestSkippedChannels() : void
      {
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SKIPPED_CHANNELS,this.mSkippedChannels));
         }
         else
         {
            this.sendGetProperties("skipList");
         }
      }
      
      public function get skippedChannels() : Vector.<int>
      {
         if(this.mCompleteChannelList.length <= 1)
         {
            this.requestChannelMap();
         }
         return this.mSkippedChannels;
      }
      
      public function setChannelLock(channels:String, lock:Boolean) : void
      {
         var channelInt:int = 0;
         var index:int = 0;
         var channel:SatelliteRadioChannel = null;
         var channelArray:Array = channels.split(",");
         var i:int = 0;
         if(this.mTeenKeyFeaturePresent == false)
         {
            return;
         }
         if(channelArray[0] == "lock")
         {
            channelArray.shift();
            this.processTeenKey();
            this.sendCommand("lockChannel","channelList","[" + channelArray.toString() + "]",false);
            return;
         }
         if(channelArray[0] == "clear")
         {
            channelArray.shift();
            this.processTeenKey();
            this.sendCommand("clearLockChannel","channelList","[" + channelArray.toString() + "]",false);
            return;
         }
         if(channels == "")
         {
            channelArray = new Array();
            for each(channel in this.mCompleteChannelList.list)
            {
               if(!(channel.number == 0 || channel.number == 1))
               {
                  channelArray.push(channel.number.toString());
               }
            }
         }
         if(lock)
         {
            for(i = 0; i < channelArray.length; i++)
            {
               channelInt = int(channelArray[i]);
               index = this.mLockedChannels.indexOf(channelInt,0);
               if(index < 0)
               {
                  this.mLockedChannels.push(channelInt);
               }
            }
         }
         else
         {
            for(i = 0; i < channelArray.length; i++)
            {
               channelInt = int(channelArray[i]);
               index = this.mLockedChannels.indexOf(channelInt,0);
               if(index >= 0)
               {
                  this.mLockedChannels.splice(index,1);
               }
            }
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.LOCKED_CHANNELS));
      }
      
      private function processTeenKey() : void
      {
         var LockedChannels:Vector.<int> = null;
         trace("mTeenKeyDetected: " + this.mTeenKeyDetected + " mLockedChannels.length: " + this.mLockedChannels.length);
         if(this.mTeenKeyDetected == true && this.mLockedChannels.length > 0)
         {
            this.mCompleteChannelList.updateLockedChannels(this.mLockedChannels);
         }
         else
         {
            LockedChannels = new Vector.<int>();
            this.mCompleteChannelList.updateLockedChannels(LockedChannels);
         }
      }
      
      public function requestLockedChannels() : void
      {
         if(mTesting)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.LOCKED_CHANNELS,this.mLockedChannels));
         }
         else if(this.mTeenKeyFeaturePresent == true)
         {
            this.sendGetProperties("lockList");
         }
      }
      
      public function get lockedChannels() : Vector.<int>
      {
         if(this.mCompleteChannelList.length <= 1)
         {
            this.requestChannelMap();
         }
         return this.mLockedChannels;
      }
      
      public function setCategoryOrder(order:String) : void
      {
         if(order == SatelliteRadioChannelList.mSortCategoryAscending)
         {
            this.mCompleteChannelList.sort(1,0);
         }
         else if(order == SatelliteRadioChannelList.mSortCategoryDescending)
         {
            this.mCompleteChannelList.sort(1,1);
         }
      }
      
      public function setCategoryFilter(filter:int) : void
      {
         this.sendCommand("setCategoryFilter","list","[" + filter.toString() + "]");
      }
      
      public function clearAllCategoryFilters() : void
      {
         this.sendCommand("setCategoryFilter","list","[]");
      }
      
      public function categoryOrder() : String
      {
         return this.mCompleteChannelList.sortOrder;
      }
      
      public function requestCategories(offset:int = -2147483648, length:int = -2147483648) : void
      {
         this.sendGetProperties("categoryList");
      }
      
      public function requestAppStatus() : void
      {
         this.sendGetProperties("appStatus");
      }
      
      public function get appStatus() : String
      {
         return this.mAppStatus;
      }
      
      public function requestAdvisoryMessage() : void
      {
         this.sendGetProperties("advisoryMsg");
      }
      
      public function get advisoryMessage() : String
      {
         return this.mAdvisoryMsg;
      }
      
      public function requestESN() : void
      {
         this.sendGetProperties("ESN");
      }
      
      public function get SatESN() : String
      {
         return this.mESN;
      }
      
      public function presetSeekUp() : void
      {
         this.sendCommand("presetSeekUp",null,null);
      }
      
      public function presetSeekDown() : void
      {
         this.sendCommand("presetSeekDown",null,null);
      }
      
      public function presetRecall(location:int) : void
      {
         this.sendCommand("presetRecall","presetNum",location);
      }
      
      public function scanUp() : void
      {
         this.sendCommand("scanUp",null,null);
      }
      
      public function scanDown() : void
      {
         this.sendCommand("scanDown",null,null);
      }
      
      public function scanCancel() : void
      {
         this.sendCommand("scanCancel",null,null);
      }
      
      public function requestAvailableChannels() : void
      {
         this.sendGetProperties("availableChannelList");
      }
      
      public function requestChannelMap() : void
      {
         this.sendGetProperties("stationInfoList");
      }
      
      public function requestLeagueList() : void
      {
         this.sendGameCommand("requestLeagueList",null,null);
      }
      
      public function get leagueList() : Vector.<GameZoneLeagues>
      {
         return this.mLeagueList;
      }
      
      public function requestTeamList(league:uint) : void
      {
         this.sendGameCommand("requestTeamList","contentDescriptor",league);
      }
      
      public function getTeamList(league:GameZoneLeagues) : Vector.<GameZoneFavoriteTeam>
      {
         return this.mTeamList;
      }
      
      public function addFavoriteTeam(addLeague:uint, addTeamId:uint, addAlertType:String) : Boolean
      {
         if(this.mFavTeamLength >= MAX_NUMBER_OF_GAME_FAVORITES)
         {
            return false;
         }
         if(this.mGameAlertsEnabled == true && this.mScoreAlertsEnabled == false)
         {
            addAlertType = GameZoneFavoriteTeam.ALERT_GAME;
         }
         else if(this.mGameAlertsEnabled == false && this.mScoreAlertsEnabled == true)
         {
            addAlertType = GameZoneFavoriteTeam.ALERT_SCORE;
         }
         else if(this.mGameAlertsEnabled == true && this.mScoreAlertsEnabled == true)
         {
            addAlertType = GameZoneFavoriteTeam.ALERT_BOTH;
         }
         else if(this.mGameAlertsEnabled == false && this.mScoreAlertsEnabled == false)
         {
            addAlertType = GameZoneFavoriteTeam.ALERT_BOTH;
         }
         var message:Object = {
            "Type":"Command",
            "Dest":mXMGameZoneDbusID,
            "packet":{"setFavoriteTeam":{
               "leagueDescriptor":addLeague,
               "teamDescriptor":addTeamId,
               "alertType":addAlertType
            }}
         };
         this.connection.send(message);
         return true;
      }
      
      public function removeFavoriteTeam(removeLeague:uint, removeTeamId:uint) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mXMGameZoneDbusID,
            "packet":{"removeFavTeam":{
               "leagueDescriptor":removeLeague,
               "teamDescriptor":removeTeamId
            }}
         };
         this.connection.send(message);
      }
      
      public function removeAllTeams() : void
      {
         this.sendCommandToId(mXMGameZoneDbusID,"removeAllTeams",null,null);
      }
      
      public function requestFavoriteTeamsList() : void
      {
         this.sendGetPropertiesToId(mXMGameZoneDbusID,"currentTeamFavorites");
      }
      
      public function get favoriteTeamsList() : Vector.<GameZoneFavoriteTeam>
      {
         return this.mFavoriteTeamList;
      }
      
      public function enableStartOfGameAlert(status:Boolean) : void
      {
         this.mGameAlertsEnabled = status;
         this.sendGameCommand("enableGlobalGameAlert","Status",status,false);
      }
      
      public function get startOfGameAlertStatus() : Boolean
      {
         return this.mGameAlertsEnabled;
      }
      
      public function enableScoreChangeAlert(status:Boolean) : void
      {
         this.mScoreAlertsEnabled = status;
         this.sendGameCommand("enableGlobalScoreAlert","Status",status,false);
      }
      
      public function get scoreChangeAlertStatus() : Boolean
      {
         return this.mScoreAlertsEnabled;
      }
      
      public function requestActiveGameEvents() : void
      {
         this.sendGetPropertiesToId(mXMGameZoneDbusID,"activeGame");
      }
      
      public function requestScoreAlertEvents() : void
      {
         this.sendGetPropertiesToId(mXMGameZoneDbusID,"scoreAlert");
      }
      
      public function get activeGames() : Vector.<GameAlert>
      {
         return this.mActiveGames;
      }
      
      public function requestActiveScoreEvents() : void
      {
         this.sendGetPropertiesToId(mXMGameZoneDbusID,"activeScores");
      }
      
      public function get activeScores() : Vector.<GameZoneScoreAlert>
      {
         return this.mScores;
      }
      
      public function requestFavoriteAlertType() : void
      {
         var message:Object = null;
         message = {
            "Type":"Command",
            "Dest":mXMPersistencyDbusID,
            "packet":{"read":{
               "key":"audioFavoriteAlertType",
               "escval":0
            }}
         };
         this.connection.send(message);
      }
      
      public function set favoriteAlertType(alertType:String) : void
      {
         var message:Object = null;
         var onOff:Boolean = false;
         if(alertType != SatelliteRadioFavorite.ALERT_OFF && alertType != SatelliteRadioFavorite.AUDIO_VISUAL && alertType != SatelliteRadioFavorite.VISUAL_ONLY)
         {
            return;
         }
         this.mAudioFavoritesAlertType = alertType;
         if(alertType == SatelliteRadioFavorite.ALERT_OFF)
         {
            onOff = false;
         }
         else
         {
            onOff = true;
         }
         message = {
            "Type":"Command",
            "Dest":mXMFavoritesDbusID,
            "packet":{"enableGlobalSongArtistSeek":{"status":onOff}}
         };
         this.connection.send(message);
         message = {
            "Type":"Command",
            "Dest":mXMPersistencyDbusID,
            "packet":{"write":{"audioFavoriteAlertType":alertType}}
         };
         this.connection.send(message);
      }
      
      public function get favoriteAlertType() : String
      {
         return this.mAudioFavoritesAlertType;
      }
      
      public function addSongAsFavorite(channel:int) : Boolean
      {
         var message:Object = null;
         if(this.mFavorites.length >= MAX_NUMBER_OF_FAVORITES)
         {
            return false;
         }
         message = {
            "Type":"Command",
            "Dest":mXMFavoritesDbusID,
            "packet":{"setFavoriteSong":{"newFavorite":channel}}
         };
         this.connection.send(message);
         return true;
      }
      
      public function addArtistAsFavorite(channel:int) : Boolean
      {
         var message:Object = null;
         if(this.mFavorites.length >= MAX_NUMBER_OF_FAVORITES)
         {
            return false;
         }
         message = {
            "Type":"Command",
            "Dest":mXMFavoritesDbusID,
            "packet":{"setFavoriteArtist":{"newFavorite":channel}}
         };
         this.connection.send(message);
         return true;
      }
      
      public function addFavorite(newFavorite:SatelliteRadioFavorite) : Boolean
      {
         return true;
      }
      
      public function deleteFavorite(fav:SatelliteRadioFavorite) : void
      {
         var message:Object = null;
         message = {
            "Type":"Command",
            "Dest":mXMFavoritesDbusID,
            "packet":{"removeFavorite":{"id":fav.id}}
         };
         this.connection.send(message);
      }
      
      public function deleteAllFavorites() : void
      {
         this.sendCommandToId(mXMFavoritesDbusID,"removeAllFavorites",null,null);
      }
      
      public function enableFavoriteSeek(favorite:SatelliteRadioFavorite) : void
      {
         this.enableDisableFavoriteSeek(favorite,true);
      }
      
      public function disableFavoriteSeek(favorite:SatelliteRadioFavorite) : void
      {
         this.enableDisableFavoriteSeek(favorite,false);
      }
      
      private function enableDisableFavoriteSeek(favorite:SatelliteRadioFavorite, enable:Boolean) : void
      {
         var message:Object = null;
         if(favorite.type == SatelliteRadioFavorite.ARTIST)
         {
            message = {
               "Type":"Command",
               "Dest":mXMFavoritesDbusID,
               "packet":{"enableArtist":{"status":enable}}
            };
            this.connection.send(message);
         }
         else if(favorite.type == SatelliteRadioFavorite.SONG)
         {
            message = {
               "Type":"Command",
               "Dest":mXMFavoritesDbusID,
               "packet":{"enableSong":{"status":enable}}
            };
            this.connection.send(message);
         }
      }
      
      public function requestFavorites() : void
      {
         if(!this.mHasFavorites)
         {
            this.mFavorites = new Vector.<SatelliteRadioFavorite>();
            this.sendGetPropertiesToId(mXMFavoritesDbusID,"allFavorites",true);
         }
         else
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ALL_AUDIO_FAVORITES));
         }
      }
      
      public function get currentFavoriteList() : Vector.<SatelliteRadioFavorite>
      {
         return this.mFavorites;
      }
      
      public function requestActiveFavorites() : void
      {
         this.sendGetPropertiesToId(mXMFavoritesDbusID,"activeFavorites",true);
      }
      
      public function get activeFavoriteList() : Vector.<SatelliteRadioActiveFavorite>
      {
         return this.mActiveFavorites;
      }
      
      public function get isFavoriteArtistAllowed() : Boolean
      {
         return this.mIsFavoriteArtistAllowed;
      }
      
      public function get favoriteAlertState() : String
      {
         return this.mFavoriteAlertState;
      }
      
      public function get isFavoriteSongAllowed() : Boolean
      {
         return this.mIsFavoriteSongAllowed;
      }
      
      public function get favoriteAudioAlertsList() : Vector.<SatelliteRadioActiveFavorite>
      {
         return this.mFavoriteAudioAlerts;
      }
      
      public function requestFeaturedFavoritesList() : void
      {
         this.sendCommand("getFeaturedFavoritesList",null,null);
      }
      
      public function get featuredFavoritesList() : Vector.<SatelliteRadioFeaturedFavoriteBand>
      {
         return this.mFeaturedFavoritesList;
      }
      
      public function requestFeaturedFavorites(id:int) : void
      {
         var message:Object = null;
         this.mFeaturedFavorites.length = 0;
         message = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getFeaturedFav":{"bandID":id}}
         };
         this.connection.send(message);
      }
      
      public function get featuredFavorites() : Vector.<SatelliteRadioFeaturedFavorite>
      {
         return this.mFeaturedFavorites;
      }
      
      public function get wasActiveChannelUnsubscribed() : Boolean
      {
         return this.mWasActiveChannelUnsubscribed;
      }
      
      public function set wasActiveChannelUnsubscribed(wasUnsubscribed:Boolean) : void
      {
         this.mWasActiveChannelUnsubscribed = wasUnsubscribed;
      }
      
      public function setGMTOffset(offset:int, DSTEnabled:Boolean) : void
      {
         var message:String = null;
         if(offset > 23 || offset < -23)
         {
            return;
         }
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"" + "setTimeZoneOffset" + "\": { \"" + "offset" + "\": " + offset + ", \"DST\":" + DSTEnabled + "}}}";
         this.client.send(message);
      }
      
      public function requestDataServicesSubscriptionStatus() : void
      {
         this.sendGetPropertiesToId(mDbusIdentifier,"dataServicesSubscriptionStatus",true);
      }
      
      public function requestEnableICSTuning() : void
      {
         if(this.mAppStatus == "READY")
         {
            this.sendCommand("requestEnableICSTuning",null,null);
         }
      }
      
      public function requestDisableICSTuning() : void
      {
         if(this.mAppStatus == "READY")
         {
            this.sendCommand("requestDisableICSTuning",null,null);
         }
      }
      
      public function requestTuneStartStatus() : void
      {
         this.sendGetProperties("smartFavoritesStatus");
      }
      
      public function get TuneStartStatus() : int
      {
         return this.mTuneStartStatus;
      }
      
      public function TuneStartEnabled(enabled:Boolean) : void
      {
         if(enabled)
         {
            this.mTuneStartStatus = this.TuneStartIsEnabled;
            this.sendCommand("enableSmartFavs",null,null);
         }
         else
         {
            this.mTuneStartStatus = this.TuneStartIsDisabled;
            this.sendCommand("disableSmartFavs",null,null);
         }
      }
      
      public function requestActiveScores() : void
      {
         this.sendGetPropertiesToId(mXMGameZoneDbusID,"activeScores",true);
      }
      
      public function requestXMAppVersion() : void
      {
         this.sendGetPropertiesToId(mDbusIdentifier,"xmAppVersion",true);
      }
      
      public function get XMAppVersion() : String
      {
         return this.mXMAppVersion;
      }
      
      private function XMAppMessageHandler(e:ConnectionEvent) : void
      {
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mXMAppServiceAvailable == false)
            {
               trace("state of XMAPP : " + this.mAppStatus);
               this.mXMAppServiceAvailable = true;
               this.sendMultiSubscribeToId(mDbusIdentifier,["advisoryMsg","appStatus","availableChannelList","stationInfoList","categoryList","ESN","signalStrength","audioSubscriptionStatus","subscriptionStatus","skippedChannelList","lockedChannelList","dataServicesSubscriptionStatus","dataServicesState","featuredFavoritesList","featureFavorite","smartFavoritesStatus"]);
               this.sendGetAllPropertiesToId(mDbusIdentifier);
               this.requestCurrentStationInfo();
               this.requestAvailableChannels();
               this.requestSkippedChannels();
               this.requestLockedChannels();
               this.requestChannelUpdate();
               this.requestSignalQuality();
               this.requestDataServicesSubscriptionStatus();
               this.requestDataServicesState();
               this.requestAdvisoryMessage();
               this.requestTuneStartStatus();
               this.requestFeaturedFavoritesList();
            }
            else if(e.data.dBusServiceAvailable == "false")
            {
               this.mXMAppServiceAvailable = false;
            }
         }
         else
         {
            this.messageHandler(e);
         }
      }
      
      private function XMGameZoneMessageHandler(e:ConnectionEvent) : void
      {
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mXMGameZoneServiceAvailable == false)
            {
               this.mXMGameZoneServiceAvailable = true;
               this.sendMultiSubscribeToId(mXMGameZoneDbusID,["globalGameAlertStatus","globalScoreAlertStatus","currentTeamFavorites"]);
               this.sendGetAllPropertiesToId(mXMGameZoneDbusID);
               this.sendGetPropertiesToId(mXMGameZoneDbusID,"globalGameAlertStatus",true);
               this.sendGetPropertiesToId(mXMGameZoneDbusID,"globalScoreAlertStatus",true);
               this.requestFavoriteTeamsList();
            }
            else if(e.data.dBusServiceAvailable == "false")
            {
               this.mXMGameZoneServiceAvailable = false;
            }
         }
         else
         {
            this.messageHandler(e);
         }
      }
      
      private function XMFavortiesMessageHandler(e:ConnectionEvent) : void
      {
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mXMFavoritesServiceAvailable == false)
            {
               this.mXMFavoritesServiceAvailable = true;
               this.sendMultiSubscribeToId(mXMFavoritesDbusID,["allFavorites","favAllowed","favoriteAlert","activeFavorites","songArtistSeekEnabled","getProperties"]);
               this.sendGetPropertiesToId(mXMFavoritesDbusID,"favAllowed",true);
            }
            else if(e.data.dBusServiceAvailable == "false")
            {
               this.mXMFavoritesServiceAvailable = false;
            }
         }
         else
         {
            this.messageHandler(e);
         }
      }
      
      private function XMTrafficJumpMessageHandler(e:ConnectionEvent) : void
      {
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mXMTrafficJumpServiceAvailable == false)
            {
               this.mXMTrafficJumpServiceAvailable = true;
               this.sendMultiSubscribeToId(mXMTrafficJumpDbusID,["getProperties","trafficJumpPress","trafficMarket","trafficList","jumpStatus","selectedMarket"]);
               this.requestJumpStatus();
               this.requestWeatherTrafficChannels();
               this.requestCurrentWeatherTrafficChannel();
            }
            else if(e.data.dBusServiceAvailable == "false")
            {
               this.mXMTrafficJumpServiceAvailable = false;
            }
         }
         else
         {
            this.messageHandler(e);
         }
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var rtnstr:String = null;
         var rtn:int = 0;
         var property:String = null;
         var newch:Array = null;
         var newi:int = 0;
         var ffl:Array = null;
         var objffb:Object = null;
         var ffb:SatelliteRadioFeaturedFavoriteBand = null;
         var ffchannel:Array = null;
         var objffc:Object = null;
         var ff:SatelliteRadioFeaturedFavorite = null;
         var prop:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty("getProperties"))
         {
            if(message.getProperties.hasOwnProperty("appStatus"))
            {
               this.updateAppStatus(message.getProperties.appStatus.appStatus);
            }
            else if(message.getProperties.hasOwnProperty("advisoryMsg"))
            {
               this.mAdvisoryMsg = message.getProperties.advisoryMsg.advisoryMsg;
               if(this.mAdvisoryMsg == SatAdvisoryMessageTypes.sACTIVE_CH_BECAME_UNSUBSCRIBED)
               {
                  this.mWasActiveChannelUnsubscribed = true;
               }
               this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ADVISORY_MESSAGE,this.mAdvisoryMsg));
            }
            else if(message.getProperties.hasOwnProperty("xmAppVersion"))
            {
               this.mXMAppVersion = message.getProperties.xmAppVersion;
               this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.XM_APP_VER));
            }
            else if(message.getProperties.hasOwnProperty("smartFavoritesStatus"))
            {
               this.mTuneStartStatus = message.getProperties.smartFavoritesStatus.smartFavoritesStatus;
            }
            else
            {
               try
               {
                  for(property in message.getProperties)
                  {
                     trace("SatelliteRadio " + property + " received");
                     this[property] = message.getProperties[property];
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         else if(message.hasOwnProperty("advisoryMsg"))
         {
            this.mAdvisoryMsg = message.advisoryMsg.advisoryMsg;
            if(this.mAdvisoryMsg == SatAdvisoryMessageTypes.sACTIVE_CH_BECAME_UNSUBSCRIBED)
            {
               this.mWasActiveChannelUnsubscribed = true;
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ADVISORY_MESSAGE,this.mAdvisoryMsg));
         }
         else if(message.hasOwnProperty("stationInfoList"))
         {
            this.decodeStationList(message.stationInfoList);
         }
         else if(message.hasOwnProperty("availableChannelList"))
         {
            newch = new Array();
            newch = message.availableChannelList;
            this.mAvailableChannelList = new Vector.<int>();
            for each(newi in newch)
            {
               this.mAvailableChannelList.push(newi);
            }
            this.mCompleteChannelList.updateLength(this.mAvailableChannelList.length);
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.AVAILABLE_CHANNELS,this.mAvailableChannelList));
         }
         else if(message.hasOwnProperty("categoryList"))
         {
            this.decodeCategoryList(message.categoryList);
         }
         else if(message.hasOwnProperty("signalStrength"))
         {
            this.mSignalStrength = message.signalStrength.signalStrength;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SIGNAL_QUALITY,this.mSignalStrength));
         }
         else if(message.hasOwnProperty("ESN"))
         {
            this.mESN = message.ESN.ESN;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ESN,this.mESN));
         }
         else if(message.hasOwnProperty("audioSubscriptionStatus"))
         {
            this.audioSubscriptionStatus = message.audioSubscriptionStatus;
         }
         else if(!message.hasOwnProperty("createList"))
         {
            if(!message.hasOwnProperty("channelSelect"))
            {
               if(!message.hasOwnProperty("seekUpPress"))
               {
                  if(!message.hasOwnProperty("seekDownPress"))
                  {
                     if(message.hasOwnProperty("allFavorites"))
                     {
                        this["allFavorites"] = message.allFavorites;
                     }
                     else if(message.hasOwnProperty("leagueList"))
                     {
                        this.storeLeagueList = message.leagueList.sortOn("abbrev");
                     }
                     else if(message.hasOwnProperty("currentTeamFavorites"))
                     {
                        this.currentTeamFavorites = message.currentTeamFavorites;
                     }
                     else if(message.hasOwnProperty("teamList"))
                     {
                        this.teamList = message.teamList;
                     }
                     else if(message.hasOwnProperty("dataServicesSubscriptionStatus"))
                     {
                        this.dataServicesSubscriptionStatus = message.dataServicesSubscriptionStatus;
                     }
                     else if(message.hasOwnProperty("appStatus"))
                     {
                        this.updateAppStatus(message.appStatus.appStatus);
                     }
                     else if(message.hasOwnProperty("activeScores"))
                     {
                        this.scores = message.activeScores;
                     }
                     else if(message.hasOwnProperty("dataServicesState"))
                     {
                        this.storeDataServicesStateList = message.dataServicesState.sortOn("service");
                     }
                     else if(message.hasOwnProperty("favoriteAlert"))
                     {
                        if(!this.mFavoriteOnAirBubbleSuppressed && this.mAudioFavoritesAlertType != SatelliteRadioFavorite.ALERT_OFF)
                        {
                           this.mFavoriteAlertState = message.favoriteAlert.alertType;
                           this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.FAVORITE_ALERT));
                        }
                     }
                     else if(message.hasOwnProperty("smartFavoritesStatus"))
                     {
                        this.mTuneStartStatus = message.smartFavoritesStatus.smartFavoritesStatus;
                     }
                     else if(message.hasOwnProperty("featuredFavoritesList"))
                     {
                        ffl = message.featuredFavoritesList.list;
                        this.mFeaturedFavoritesList.length = 0;
                        for each(objffb in ffl)
                        {
                           ffb = new SatelliteRadioFeaturedFavoriteBand();
                           ffb.fillFrom(objffb);
                           this.mFeaturedFavoritesList.push(ffb);
                        }
                        this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.FEATURED_FAVORITE_LIST));
                     }
                     else if(message.hasOwnProperty("featureFavorite"))
                     {
                        ffchannel = message.featureFavorite.list;
                        this.mFeaturedFavorites.length = 0;
                        for each(objffc in ffchannel)
                        {
                           ff = new SatelliteRadioFeaturedFavorite();
                           ff.fillFrom(objffc);
                           this.mFeaturedFavorites.push(ff);
                        }
                        this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.FEATURED_FAVORITE));
                     }
                     else
                     {
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
                  }
               }
            }
         }
      }
      
      private function updateAppStatus(appStatus:String) : void
      {
         this.mAppStatus = appStatus;
         if(this.mAppStatus == "READY")
         {
            trace("received SDARS ready");
            this.requestLockedChannels();
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.APP_STATUS,this.mAppStatus));
         if(this.mAppStatus == "SHUTDOWN_PENDING" || this.mAppStatus == "SHUTDOWN_COMPLETE")
         {
            this.mCurrentStationInfo = new SatelliteRadioChannel();
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.CURRENT_CHANNEL,this.mCurrentStationInfo));
         }
      }
      
      public function VehicleConfigMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         trace("VehicleConfigMessageHandler");
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            trace("VehicleConfigMessageHandler dBusServiceAvailable " + resp.dBusServiceAvailable);
            if(resp.dBusServiceAvailable == "true")
            {
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mVehicleConfigDbusID + "\",\"packet\":{\"getProperties\":{\"props\":[\"teenKeyFeaturePresent\"]}}}");
            }
         }
         else if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("teenKeyFeaturePresent"))
            {
               this.ProcessTeenKeyFeaturePresent(resp.getProperties.teenKeyFeaturePresent);
            }
         }
         else if(resp.hasOwnProperty("teenKeyFeaturePresent"))
         {
            this.ProcessTeenKeyFeaturePresent(resp.teenKeyFeaturePresent.teenKeyFeaturePresent);
         }
      }
      
      public function ProcessTeenKeyFeaturePresent(featurePresent:Boolean) : void
      {
         this.mTeenKeyFeaturePresent = featurePresent;
         trace("teenKeyFeaturePresent : " + this.mTeenKeyFeaturePresent);
         if(this.mTeenKeyFeaturePresent == true)
         {
            this.sendVehStatusAvailableRequest();
         }
      }
      
      public function VehicleStatusMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         trace("VehicleStatusMessageHandler ");
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true")
            {
               trace("VehicleStatusMessageHandler dBusServiceAvailable");
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mVehicleStatusDbusID + "\",\"packet\":{\"getProperties\":{\"props\":[\"TeenKeyIsPresent\"]}}}");
            }
         }
         else if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("TeenKeyIsPresent"))
            {
               this.mTeenKeyDetected = resp.getProperties.TeenKeyIsPresent;
               trace("VehicleStatusMessageHandler getProperties TeenKeyIsPresent value: " + this.mTeenKeyDetected);
               this.processTeenKey();
            }
         }
         else if(resp.hasOwnProperty("TeenKeyIsPresent"))
         {
            this.mTeenKeyDetected = resp.TeenKeyIsPresent.TeenKeyIsPresent;
            trace("VehicleStatusMessageHandler TeenKeyIsPresent value: " + this.mTeenKeyDetected);
            this.processTeenKey();
         }
      }
      
      public function persistencyMessageHandler(e:ConnectionEvent) : void
      {
         var alertType:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty("dBusServiceAvailable"))
         {
            if(message.dBusServiceAvailable == "true" && this.mPersistencyServiceAvailable == false)
            {
               this.mPersistencyServiceAvailable = true;
               this.requestFavoriteAlertType();
            }
            else if(message.dBusServiceAvailable == "false")
            {
               this.mPersistencyServiceAvailable = false;
            }
         }
         else if(message.hasOwnProperty("write"))
         {
            if(message.write.res != "OK")
            {
            }
         }
         else if(message.hasOwnProperty("read"))
         {
            if(message.read.res != "Empty")
            {
               alertType = message.read.res;
               if(alertType != SatelliteRadioFavorite.ALERT_OFF && alertType != SatelliteRadioFavorite.AUDIO_VISUAL && alertType != SatelliteRadioFavorite.VISUAL_ONLY)
               {
                  return;
               }
               this.mAudioFavoritesAlertType = alertType;
            }
            else
            {
               this.mAudioFavoritesAlertType = SatelliteRadioFavorite.VISUAL_ONLY;
            }
         }
      }
      
      private function set audioSubscriptionStatus(status:Object) : void
      {
         var subscribed:int = int(status.subStatus);
         switch(subscribed)
         {
            case AUDIO_SUBSTATUS_NOTSUBSCRIBED:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedNo;
               break;
            case AUDIO_SUBSTATUS_SUBSCRIBED:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedYes;
               break;
            case AUDIO_SUBSTATUS_INVALID:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedUnknown;
               break;
            case AUDIO_SUBSTATUS_SUSPEND:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedNo;
               break;
            case AUDIO_SUBSTATUS_SUSPENDALERT:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedNo;
               break;
            case AUDIO_SUBSTATUS_UNKNOWN:
            default:
               this.mAudioSubscriptionStatus = DataServicesSubscriptionStatus.subscribedUnknown;
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SUBSCRIBED,this.mAudioSubscriptionStatus));
      }
      
      private function set subscriptionStatus(status:Object) : void
      {
         if(status.hasOwnProperty("audio"))
         {
            this.mAudioSubscriptionStatus = status.audio;
         }
         if(status.hasOwnProperty("travellink"))
         {
            this.mTLSubscriptionStatus = status.travellink;
         }
         if(status.hasOwnProperty("traffic"))
         {
            this.mTrafficSubscriptionStatus = status.traffic;
         }
         if(status.hasOwnProperty("graphicalWeather"))
         {
            this.mWeatherSubscriptionStatus = status.graphicalWeather;
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SUBSCRIBED,this.mAudioSubscriptionStatus));
      }
      
      private function set stationInfoList(list:Object) : void
      {
         this.decodeStationList(list);
      }
      
      private function set skipChannel(success:Object) : void
      {
      }
      
      private function set skippedChannelList(list:Object) : void
      {
         var newCh:int = 0;
         this.mSkippedChannels = new Vector.<int>();
         for each(newCh in list)
         {
            this.mSkippedChannels.push(newCh);
         }
         this.mCompleteChannelList.updateSkippedChannels(this.mSkippedChannels);
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SKIPPED_CHANNELS));
      }
      
      private function set lockedChannelList(list:Object) : void
      {
         var newCh:int = 0;
         this.mLockedChannels = new Vector.<int>();
         for each(newCh in list)
         {
            trace("locked channels received: " + newCh);
            this.mLockedChannels.push(newCh);
         }
         if(this.mTeenKeyDetected == true)
         {
            this.mCompleteChannelList.updateLockedChannels(this.mLockedChannels);
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.LOCKED_CHANNELS));
      }
      
      private function decodeStationList(stationList:Object) : void
      {
         var ch:SatelliteRadioChannel = null;
         var newCh:Object = null;
         this.mCompleteChannelList.deleteList();
         this.InitializeCompleteChannelList();
         for each(newCh in stationList)
         {
            ch = new SatelliteRadioChannel();
            if(newCh.hasOwnProperty("artist"))
            {
               ch.artist = newCh.artist;
            }
            else
            {
               ch.artist = "";
            }
            ch.category = newCh.catName;
            ch.categoryNum = newCh.catNum;
            ch.sid = newCh.sid;
            ch.name = newCh.channelName;
            if(newCh.hasOwnProperty("shortName"))
            {
               ch.shortName = newCh.shortName;
            }
            else
            {
               ch.shortName = ch.name;
            }
            if(newCh.hasOwnProperty("info"))
            {
               ch.content = newCh.info;
            }
            else
            {
               ch.content = "";
            }
            ch.isArtistFavorite = newCh.isArtistFavorite;
            ch.isSongFavorite = newCh.isSongFavorite;
            ch.logoUrl = newCh.logoLocation;
            ch.subscribed = newCh.isSubscribed;
            if(newCh.hasOwnProperty("program"))
            {
               ch.title = newCh.program;
            }
            else
            {
               ch.title = "";
            }
            ch.number = newCh.channelID;
            if(ch.number == 0)
            {
               ch.replay = false;
            }
            else
            {
               ch.replay = true;
            }
            if(this.mCompleteChannelList.addChannel(ch))
            {
            }
            if(this.mSkippedChannels.indexOf(ch.number,0) >= 0)
            {
               ch.skip = true;
            }
            else
            {
               ch.skip = false;
            }
            if(this.mLockedChannels.indexOf(ch.number,0) >= 0)
            {
               ch.lock = true;
            }
            else
            {
               ch.lock = false;
            }
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.CHANNELS_UPDATED));
      }
      
      private function decodeCategoryList(categoryList:Object) : void
      {
         var c:SatelliteRadioCategory = null;
         var newC:Object = null;
         var list:Vector.<SatelliteRadioCategory> = new Vector.<SatelliteRadioCategory>();
         for each(newC in categoryList)
         {
            c = new SatelliteRadioCategory();
            c.id = categoryList.categoryID;
            c.isEnabled = categoryList.isEnabled;
            c.name = categoryList.name;
            list.push(c);
         }
         this.mCompleteCategoryList = new SatelliteRadioCategoryList(0,list);
      }
      
      private function set ESN(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.mESN = eventObj.ESN;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ESN,this.mESN));
         }
      }
      
      private function set currentStationInfo(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.mCurrentStationInfo.artist = eventObj.artist;
            this.mCurrentStationInfo.category = eventObj.catName;
            this.mCurrentStationInfo.categoryNum = eventObj.catNum;
            this.mCurrentStationInfo.sid = eventObj.sid;
            this.mCurrentStationInfo.name = eventObj.channelName;
            this.mCurrentStationInfo.shortName = eventObj.shortName;
            this.mCurrentStationInfo.content = eventObj.info;
            this.mCurrentStationInfo.isArtistFavorite = eventObj.isArtistFavorite;
            this.mCurrentStationInfo.isSongFavorite = eventObj.isSongFavorite;
            this.mCurrentStationInfo.subscribed = eventObj.isSubscribed;
            this.mCurrentStationInfo.logoUrl = eventObj.logoLocation;
            this.mCurrentStationInfo.title = eventObj.program;
            this.mCurrentStationInfo.number = eventObj.channelID;
            this.mCurrentStationInfo.presetNum = eventObj.presetNum != 255 ? int(eventObj.presetNum) : -1;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.CURRENT_CHANNEL,this.mCurrentStationInfo));
         }
      }
      
      private function set globalXMPresetList(eventObj:Object) : void
      {
         if(null != eventObj)
         {
         }
      }
      
      private function set signalStrength(eventObj:Object) : void
      {
         var quality:int = 0;
         if(null != eventObj)
         {
            quality = int(eventObj.signalStrength);
            this.mSignalStrength = quality;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SIGNAL_QUALITY,this.mSignalStrength));
         }
      }
      
      private function set scanMode(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.mIsScanning = eventObj.scanMode;
         }
      }
      
      public function get TuneStartUnsupported() : int
      {
         return 0;
      }
      
      public function get TuneStartIsDisabled() : int
      {
         return 1;
      }
      
      public function get TuneStartIsEnabled() : int
      {
         return 2;
      }
      
      private function set activeGame(eventObj:Object) : void
      {
         var gameToRemove:int = 0;
         var game:GameAlert = null;
         var i:int = 0;
         if(null != eventObj && eventObj.hasOwnProperty("channel") && eventObj.hasOwnProperty("league") && (eventObj.hasOwnProperty("home") || eventObj.hasOwnProperty("away")))
         {
            gameToRemove = -1;
            game = new GameAlert();
            game.alertType = GameZoneFavoriteTeam.ALERT_GAME;
            game.channel = eventObj.channel;
            game.league = eventObj.league;
            game.home = eventObj.home;
            game.homeAbbrev = eventObj.homeAbbrev;
            game.away = eventObj.away;
            game.awayAbbrev = eventObj.awayAbbrev;
            game.homeScore = eventObj.scoreHome;
            game.awayScore = eventObj.scoreAway;
            game.progress = "";
            for(i = 0; i < this.mActiveGames.length; i++)
            {
               if(game.channel == this.mActiveGames[i].channel)
               {
                  gameToRemove = i;
               }
            }
            if(gameToRemove > -1)
            {
               this.mActiveGames.splice(gameToRemove,1);
            }
            if(game.alertType != GameZoneFavoriteTeam.ALERT_END)
            {
               this.mActiveGames.push(game);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ACTIVE_GAME,game));
         }
      }
      
      private function set scoreAlert(eventObj:Object) : void
      {
         var game:GameAlert = null;
         if(null != eventObj)
         {
            game = new GameAlert();
            game.alertType = GameZoneFavoriteTeam.ALERT_SCORE;
            game.channel = eventObj.channel;
            game.progress = eventObj.teams;
            game.gameTitle = eventObj.scores;
            if(game.progress == "")
            {
               game.progress = null;
            }
            if(game.gameTitle == "")
            {
               game.gameTitle = null;
            }
            if(game.progress == null && game.gameTitle == null)
            {
               game.alertType = GameZoneFavoriteTeam.ALERT_END;
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.SCORE_ALERT,game));
         }
      }
      
      private function set scores(eventObj:Object) : void
      {
         var traceCnt:int = 0;
         var gameScore:Object = null;
         var gzScore:GameZoneScoreAlert = null;
         if(null != eventObj)
         {
            traceCnt = 1;
            this.mScores = new Vector.<GameZoneScoreAlert>();
            for each(gameScore in eventObj)
            {
               gzScore = new GameZoneScoreAlert();
               if(gameScore.hasOwnProperty("channel"))
               {
                  gzScore.channel = gameScore.channel;
               }
               if(gameScore.hasOwnProperty("scores"))
               {
                  gzScore.gameTitle = gameScore.scores;
               }
               if(gameScore.hasOwnProperty("teams"))
               {
                  gzScore.gameArtist = gameScore.teams;
               }
               this.mScores.push(gzScore);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ACTIVE_SCORES,null));
         }
      }
      
      private function set storeLeagueList(eventObj:Object) : void
      {
         var league:Object = null;
         var newLeague:GameZoneLeagues = null;
         if(null != eventObj)
         {
            this.mLeagueList = new Vector.<GameZoneLeagues>();
            for each(league in eventObj)
            {
               newLeague = new GameZoneLeagues();
               if(league.hasOwnProperty("abbrev"))
               {
                  newLeague.abbrev = league.abbrev;
               }
               if(league.hasOwnProperty("name"))
               {
                  newLeague.name = league.name;
               }
               if(league.hasOwnProperty("contentDescriptor"))
               {
                  newLeague.contentDescriptor = league.contentDescriptor;
               }
               this.mLeagueList.push(newLeague);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.LEAGUES));
         }
      }
      
      private function set storeDataServicesStateList(eventObj:Object) : void
      {
         var service:Object = null;
         var newServiceData:DataServicesState = null;
         if(null != eventObj)
         {
            this.mDataServicesStateList = new Vector.<DataServicesState>();
            for each(service in eventObj)
            {
               newServiceData = new DataServicesState();
               if(service.hasOwnProperty("service"))
               {
                  newServiceData.service = service.service;
               }
               if(service.hasOwnProperty("state"))
               {
                  newServiceData.state = service.state;
               }
               this.mDataServicesStateList.push(newServiceData);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.DATA_SERVICES_STATE));
         }
      }
      
      private function set currentTeamFavorites(eventObj:Object) : void
      {
         var league:Object = null;
         var team:Object = null;
         var fav:GameZoneFavoriteTeam = null;
         if(null != eventObj)
         {
            if(eventObj.hasOwnProperty("currentTeamFavorites"))
            {
               this.mFavTeamLength = eventObj.currentTeamFavorites.length;
            }
            else
            {
               this.mFavTeamLength = 0;
            }
            this.mFavoriteTeamList = new Vector.<GameZoneFavoriteTeam>();
            for each(league in eventObj)
            {
               for each(team in league)
               {
                  fav = new GameZoneFavoriteTeam();
                  fav.alertType = team.alertType;
                  fav.league = team.leagueDescriptor;
                  fav.teamID = team.teamDescriptor;
                  fav.teamName = team.teamName;
                  fav.teamNick = team.teamNick;
                  fav.isFavorite = true;
                  this.mFavoriteTeamList.push(fav);
               }
            }
            this.correlateTeamListWithFavoriteTeamList();
         }
      }
      
      private function set globalGameAlertStatus(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.mGameAlertsEnabled = eventObj.Status;
         }
      }
      
      private function set globalScoreAlertStatus(eventObj:Object) : void
      {
         if(null != eventObj)
         {
            this.mScoreAlertsEnabled = eventObj.Status;
         }
      }
      
      private function set enableGlobalGameAlert(eventObj:Object) : void
      {
         if(null != eventObj)
         {
         }
      }
      
      private function set enableGlobalScoreAlert(eventObj:Object) : void
      {
         if(null != eventObj)
         {
         }
      }
      
      private function set teamList(eventObj:Object) : void
      {
         var team:Object = null;
         var fav:GameZoneFavoriteTeam = null;
         if(null != eventObj)
         {
            this.mTeamList = new Vector.<GameZoneFavoriteTeam>();
            for each(team in eventObj)
            {
               fav = new GameZoneFavoriteTeam();
               fav.alertType = team.alertType;
               if(fav.alertType != GameZoneFavoriteTeam.ALERT_NONE)
               {
                  fav.isFavorite = true;
               }
               fav.league = team.league;
               fav.teamID = team.teamID;
               fav.teamName = team.teamName;
               fav.teamNick = team.teamNick;
               this.mTeamList.push(fav);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TEAMS));
         }
      }
      
      private function correlateTeamListWithFavoriteTeamList() : void
      {
         var i:* = 0;
         var name:String = null;
         var j:* = 0;
         var fullName:String = null;
         var favTeamLookup:Dictionary = new Dictionary();
         for(i = int(this.mFavoriteTeamList.length - 1); i >= 0; i--)
         {
            if(this.mFavoriteTeamList[i].isFavorite == true)
            {
               favTeamLookup[this.mFavoriteTeamList[i].teamName] = this.mFavoriteTeamList[i].teamName;
               favTeamLookup[this.mFavoriteTeamList[i].teamNick] = this.mFavoriteTeamList[i].teamNick;
               fullName = this.mFavoriteTeamList[i].teamName + " " + this.mFavoriteTeamList[i].teamNick;
               favTeamLookup[fullName] = fullName;
            }
         }
         var alertToRemove:int = -1;
         var alertsHaveChanged:Boolean = false;
         for(i = int(this.mTeamList.length - 1); i >= 0; i--)
         {
            this.mTeamList[i].isFavorite = false;
            for each(name in favTeamLookup)
            {
               if(name == this.mTeamList[i].teamName + " " + this.mTeamList[i].teamNick)
               {
                  this.mTeamList[i].isFavorite = true;
                  delete favTeamLookup[name];
               }
            }
            for(j = int(this.mActiveGames.length - 1); j >= 0; j--)
            {
               if(this.mActiveGames[j].home == this.mTeamList[i].teamName)
               {
                  if(this.mTeamList[i].isFavorite != true)
                  {
                     alertToRemove = j;
                  }
               }
            }
            if(alertToRemove > -1)
            {
               this.mActiveGames.splice(alertToRemove,1);
               alertsHaveChanged = true;
            }
            alertToRemove = -1;
         }
         if(alertsHaveChanged)
         {
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ACTIVE_GAME));
         }
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TEAMS));
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.FAVORITE_TEAMS));
      }
      
      private function requestChannelUpdate() : void
      {
      }
      
      private function set activeFavorites(message:Object) : void
      {
         var active:Object = null;
         var newFavorite:SatelliteRadioActiveFavorite = null;
         if(null != message)
         {
            this.mActiveFavorites = new Vector.<SatelliteRadioActiveFavorite>();
            for each(active in message)
            {
               newFavorite = new SatelliteRadioActiveFavorite();
               newFavorite.channelNumber = active.channel;
               newFavorite.currentArtist = active.artist;
               newFavorite.currentSong = active.song;
               if(active.hasOwnProperty("isActiveArtist") && Boolean(active.isActiveArtist))
               {
                  newFavorite.artist = active.artist;
                  newFavorite.type = SatelliteRadioFavorite.ARTIST;
               }
               else if(active.hasOwnProperty("isActiveSong") && Boolean(active.isActiveSong))
               {
                  newFavorite.song = active.song;
                  newFavorite.type = SatelliteRadioFavorite.SONG;
               }
               this.mActiveFavorites.push(newFavorite);
               this.mActiveFavorites.sort(this.compareChannelNumberAscending);
            }
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ACTIVE_AUDIO_FAVORITES));
         }
      }
      
      private function compareChannelNumberAscending(i:SatelliteRadioActiveFavorite, j:SatelliteRadioActiveFavorite) : Number
      {
         if(i.channelNumber < j.channelNumber)
         {
            return -1;
         }
         if(i.channelNumber > j.channelNumber)
         {
            return 1;
         }
         return 0;
      }
      
      private function set CmdResponse(message:Object) : void
      {
      }
      
      private function set favAllowed(message:Object) : void
      {
         if(null != message)
         {
            this.mIsFavoriteArtistAllowed = message.isArtistAllowed;
            this.mIsFavoriteSongAllowed = message.isSongAllowed;
         }
      }
      
      private function set favoriteArtists(message:Object) : void
      {
         var artist:Object = null;
         var newFavorite:SatelliteRadioFavorite = null;
         if(null != message)
         {
            for each(artist in message)
            {
               newFavorite = new SatelliteRadioFavorite();
               newFavorite.artist = artist.artist;
               newFavorite.type = SatelliteRadioFavorite.ARTIST;
               this.mFavorites.push(newFavorite);
            }
         }
      }
      
      private function set favoriteSongs(message:Object) : void
      {
         var song:Object = null;
         var newFavorite:SatelliteRadioFavorite = null;
         if(null != message)
         {
            for each(song in message)
            {
               newFavorite = new SatelliteRadioFavorite();
               newFavorite.song = song.song;
               newFavorite.type = SatelliteRadioFavorite.SONG;
               this.mFavorites.push(newFavorite);
            }
         }
      }
      
      private function set allFavorites(message:Object) : void
      {
         var i:int = 0;
         var fav:Object = null;
         var newFavorite:SatelliteRadioFavorite = null;
         if(null != message)
         {
            i = 0;
            this.mFavorites = new Vector.<SatelliteRadioFavorite>();
            for each(fav in message)
            {
               newFavorite = new SatelliteRadioFavorite();
               newFavorite.song = fav.song;
               newFavorite.artist = fav.artist;
               if("song" == fav.favoriteType)
               {
                  newFavorite.type = SatelliteRadioFavorite.SONG;
               }
               else
               {
                  newFavorite.type = SatelliteRadioFavorite.ARTIST;
               }
               newFavorite.id = fav.id;
               this.mFavorites.push(newFavorite);
            }
            this.mHasFavorites = true;
            this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.ALL_AUDIO_FAVORITES));
         }
      }
      
      private function set trafficList(message:Object) : void
      {
         if(null != message && message.length > 0)
         {
            this.mCurrentTrafficChannels = message;
            this.buildTrafficChannels();
         }
      }
      
      private function set selectTrafficMarket(message:Object) : void
      {
      }
      
      private function set trafficJumpPress(message:Object) : void
      {
         if(message.CmdResponse.errCode != "eSuccess")
         {
            if(message.CmdResponse.errCode == "eNoMarketSelected")
            {
               dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_NO_MARKET));
               this.mJumpStatus = "JUMP_MARKET_NOT_SELECTED";
            }
         }
      }
      
      private function set cancelJump(message:Object) : void
      {
         if(message.CmdResponse.errCode == "eSuccess")
         {
            this.mWeatherTrafficChannel = null;
         }
      }
      
      private function set trafficMarket(message:Object) : void
      {
         if(null != message)
         {
            this.mCurrentTrafficJump = message;
            this.updateTrafficChannel();
         }
      }
      
      private function set songArtistSeekEnabled(message:Object) : void
      {
         if(null != message)
         {
            this.mAudioFavoritesAlertType = message.songArtistSeekEnabled;
         }
      }
      
      private function buildTrafficChannels() : void
      {
         var wtChannel:Object = null;
         var newChannel:SatelliteRadioTrafficChannel = null;
         var chNum:uint = 0;
         var tempChannel:SatelliteRadioChannel = null;
         var chName:String = null;
         var marketName:String = null;
         var tempList:Vector.<SatelliteRadioChannel> = this.mCompleteChannelList.getChannelsByCategory("Traffic/Weather");
         this.mWeatherTrafficChannelList = new Vector.<SatelliteRadioTrafficChannel>();
         for each(wtChannel in this.mCurrentTrafficChannels)
         {
            newChannel = null;
            chNum = 65535;
            if(wtChannel.hasOwnProperty("channel"))
            {
               chNum = uint(wtChannel.channel);
            }
            for each(tempChannel in tempList)
            {
               if(65535 == chNum)
               {
                  chName = tempChannel.name.toUpperCase();
                  marketName = String(wtChannel.marketID).toUpperCase();
                  if(chName.search(marketName) >= 0)
                  {
                     newChannel = new SatelliteRadioTrafficChannel(tempChannel);
                     break;
                  }
               }
               else if(tempChannel.number == chNum)
               {
                  newChannel = new SatelliteRadioTrafficChannel(tempChannel);
                  break;
               }
            }
            if(null == newChannel)
            {
               newChannel = new SatelliteRadioTrafficChannel(new SatelliteRadioChannel());
               newChannel.number = chNum;
            }
            newChannel.marketIdentifer = wtChannel.uniqueID;
            newChannel.shortName = wtChannel.marketID;
            newChannel.name = wtChannel.marketName;
            this.mWeatherTrafficChannelList.push(newChannel);
         }
         dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.JUMP_CHANNELS));
         this.updateTrafficChannel();
      }
      
      private function updateTrafficChannel() : void
      {
         var tempChannel:SatelliteRadioTrafficChannel = null;
         if(null != this.mCurrentTrafficJump && uint(this.mCurrentTrafficJump) == 0)
         {
            this.mWeatherTrafficChannel = null;
            dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.JUMP_MARKET));
            return;
         }
         if(null != this.mCurrentTrafficJump && null != this.mWeatherTrafficChannelList)
         {
            for each(tempChannel in this.mWeatherTrafficChannelList)
            {
               if(tempChannel.marketIdentifer == uint(this.mCurrentTrafficJump))
               {
                  this.mWeatherTrafficChannel = tempChannel;
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.JUMP_MARKET));
                  return;
               }
            }
         }
      }
      
      private function set status(message:Object) : void
      {
      }
      
      private function set favoriteAlert(message:Object) : void
      {
      }
      
      private function set jumpStatus(message:Object) : void
      {
         if(null != message)
         {
            if(this.mJumpStatus != String(message))
            {
               this.mJumpStatus = String(message);
               if(this.mJumpStatus == "JUMP_IN_PROGRESS")
               {
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_START));
               }
               else if(this.mJumpStatus == "JUMP_COMPLETED")
               {
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_END));
               }
               else if(this.mJumpStatus == "JUMP_PENDING")
               {
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_PENDING));
               }
               else if(this.mJumpStatus == "JUMP_MARKET_NOT_SELECTED")
               {
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_NO_MARKET));
               }
               else if(this.mJumpStatus == "JUMP_IDLE")
               {
                  dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.TRAFFIC,SatelliteRadioEvent.TRAFFIC_ALERT_IDLE));
               }
               else if(this.mJumpStatus == "JUMP_MARKET_UNDEFINED")
               {
               }
            }
         }
      }
      
      private function set dataServicesSubscriptionStatus(message:Object) : void
      {
         this.mDataServicesSubscriptionStatus.mChannelArtSubStatus = message.channelArtSubStatus;
         this.mDataServicesSubscriptionStatus.mFuelSubStatus = message.fuelSubStatus;
         this.mDataServicesSubscriptionStatus.mGraphicalWeatherSubStatus = message.graphicalWeatherSubStatus;
         this.mDataServicesSubscriptionStatus.mLandWeatherSubStatus = message.landWeatherSubStatus;
         this.mDataServicesSubscriptionStatus.mMoviesSubStatus = message.moviesSubStatus;
         this.mDataServicesSubscriptionStatus.mSecurityAlertsSubStatus = message.securityAlertsSubStatus;
         this.mDataServicesSubscriptionStatus.mSportsSubStatus = message.sportsSubStatus;
         this.mDataServicesSubscriptionStatus.mTrafficSubStatus = message.trafficSubStatus;
         this.dispatchEvent(new SatelliteRadioEvent(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS));
      }
      
      public function trafficJumpButtonPress() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mXMTrafficJumpDbusID,
            "packet":{"trafficJumpPress":{}}
         };
         this.connection.send(message);
      }
      
      public function trafficJumpCancel() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mXMTrafficJumpDbusID,
            "packet":{"cancelJump":{}}
         };
         this.connection.send(message);
      }
      
      public function get trafficJumpStatus() : String
      {
         return this.mJumpStatus;
      }
      
      private function set selectedMarket(message:Object) : void
      {
         this.mCurrentTrafficJump = message;
         this.updateTrafficChannel();
      }
      
      public function deselectTrafficMarket() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mXMTrafficJumpDbusID,
            "packet":{"clearTrafficMarkets":{}}
         };
         this.connection.send(message);
      }
      
      private function sendXMAppAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + ConnectionEvent.SATELLITE_RADIO + "\"}";
         this.client.send(message);
      }
      
      private function sendXMGameZoneAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + ConnectionEvent.SATELLITE_GAMEZONE + "\"}";
         this.client.send(message);
      }
      
      private function sendXMFavortiesAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + ConnectionEvent.SATELLITE_FAVORITES + "\"}";
         this.client.send(message);
      }
      
      private function sendXMTrafficJumpAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + ConnectionEvent.SATELLITE_TRAFFIC_JUMP + "\"}";
         this.client.send(message);
      }
      
      private function sendPersistencyAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + ConnectionEvent.SATELLITE_PERSISTENCY + "\"}";
         this.client.send(message);
      }
      
      private function sendVehConfigAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mVehicleConfigDbusID + "\"}";
         this.client.send(message);
      }
      
      private function sendVehStatusAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mVehicleStatusDbusID + "\"}";
         this.client.send(message);
      }
   }
}

