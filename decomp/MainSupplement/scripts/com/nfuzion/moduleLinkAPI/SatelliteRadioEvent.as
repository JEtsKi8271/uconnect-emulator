package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SatelliteRadioEvent extends Event
   {
      
      public static const ALL_AUDIO_FAVORITES:String = "allFavorites";
      
      public static const ACTIVE_AUDIO_FAVORITES:String = "activeAudioFavorite";
      
      public static const ACTIVE_GAME:String = "activeGame";
      
      public static const SCORE_ALERT:String = "scoreAlert";
      
      public static const ACTIVE_SCORES:String = "activeScores";
      
      public static const ADVISORY_MESSAGE:String = "advisoryMessage";
      
      public static const ANTENNA_STATUS:String = "antennaStatus";
      
      public static const APP_STATUS:String = "appStatus";
      
      public static const AVAILABLE_CHANNELS:String = "availableChannels";
      
      public static const CATEGORIES:String = "categories";
      
      public static const CHANNEL_SORT:String = "channelSort";
      
      public static const CHANNELS:String = "channels";
      
      public static const CHANNELS_UPDATED:String = "channelsUpdated";
      
      public static const CURRENT_CHANNEL:String = "currentChannel";
      
      public static const DATA_SERVICES_STATE:String = "dataServicesState";
      
      public static const ESN:String = "ESN";
      
      public static const FAVORITE_ALERT:String = "favoriteAlert";
      
      public static const FAVORITE_TEAMS:String = "favoriteTeams";
      
      public static const FEATURED_FAVORITE_LIST:String = "featuredFavoriteList";
      
      public static const FEATURED_FAVORITE:String = "featuredFavorite";
      
      public static const JUMP_CHANNELS:String = "jumpChannels";
      
      public static const JUMP_MARKET:String = "jumpMarket";
      
      public static const LEAGUES:String = "leagues";
      
      public static const LOCKED_CHANNELS:String = "lockedChannels";
      
      public static const SIGNAL_QUALITY:String = "signalStrength";
      
      public static const SKIPPED_CHANNELS:String = "skippedChannels";
      
      public static const SUBSCRIBED:String = "subscribed";
      
      public static const TEAMS:String = "teams";
      
      public static const TRAFFIC:String = "trafficAlert";
      
      public static const TRAFFIC_ALERT_START:String = "trafficAlertStart";
      
      public static const TRAFFIC_ALERT_PENDING:String = "trafficAlertPending";
      
      public static const TRAFFIC_ALERT_END:String = "trafficAlertEnd";
      
      public static const TRAFFIC_ALERT_NO_MARKET:String = "trafficAlertNoMarket";
      
      public static const TRAFFIC_ALERT_IDLE:String = "trafficAlertIdle";
      
      public static const DATA_SERVICE_SUBSCRIPTION_STATUS:String = "dataServicesSubscriptionStatus";
      
      public static const PRESET_SEEK_UP:String = "presetSeekUp";
      
      public static const XM_APP_VER:String = "XMAppVer";
      
      public var mData:Object = null;
      
      public function SatelliteRadioEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
      
      override public function clone() : Event
      {
         return new SatelliteRadioEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SatelliteRadioEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

