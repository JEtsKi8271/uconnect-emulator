package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AhaEvent extends Event
   {
      
      public static const APP_STATE:String = "AhaEvent.AppState";
      
      public static const PLAYBACK_STATE:String = "AhaEvent.PlaybackState";
      
      public static const PRESET_LIST_CHANGE:String = "AhaEvent.PresetListChange";
      
      public static const STATION_LIST_CHANGE:String = "AhaEvent.StationListChange";
      
      public static const CONTENT_LIST_CHANGE:String = "AhaEvent.ContentListChange";
      
      public static const FEATURED_LIST_CHANGE:String = "AhaEvent.FeaturedListChange";
      
      public static const NEARBY_LIST_CHANGE:String = "AhaEvent.NearbyListChange";
      
      public static const STATION_CHANGE:String = "AhaEvent.StationChange";
      
      public static const CONTENT_CHANGE:String = "AhaEvent.ContentChange";
      
      public static const PLAYBACK_PROGRESS:String = "AhaEvent.PlaybackProgress";
      
      public static const IMAGE_AVAILABLE:String = "AhaEvent.ImageAvailable";
      
      public static const IMAGE_STATION_AVAILABLE:String = "AhaEvent.ImageStationAvailable";
      
      public static const IMAGE_CONTENT_AVAILABLE:String = "AhaEvent.ImageContentAvailable";
      
      public static const IMAGE_PROVIDER_AVAILABLE:String = "AhaEvent.ImageProviderAvailable";
      
      public static const IMAGE_RATING_AVAILABLE:String = "AhaEvent.ImageRatingAvailable";
      
      public static const IMAGE_LIKE_AVAILABLE:String = "AhaEvent.ImageLikeAvailable";
      
      public static const IMAGE_DISLIKE_AVAILABLE:String = "AhaEvent.ImageDislikeAvailable";
      
      public static const LIKED:String = "AhaEvent.Liked";
      
      public var mData:Object = null;
      
      public function AhaEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

