package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class MediaPlayerEvent extends Event
   {
      
      public static const AUDITION_PERIOD:String = "auditionPeriod";
      
      public static const BROWSE_ITEMS:String = "browseItems";
      
      public static const BROWSE_MATCH_ITEMS:String = "browseMatchItems";
      
      public static const BROWSE_CHARLIST:String = "browseCharList";
      
      public static const BROWSE_PATH:String = "browsePath";
      
      public static const CURRENT_ALBUM_ART_PATH:String = "currentAlbumArtPath";
      
      public static const CURRENT_DEVICE:String = "currentDevice";
      
      public static const MEDIA_FILTERLISTSHOW:String = "mediaFilterListShow";
      
      public static const CURRENT_TRACK:String = "currentTrack";
      
      public static const CURRENT_TRACK_INFO:String = "currentTrackInfo";
      
      public static const DEVICE:String = "device";
      
      public static const DEVICE_ACTIVE:String = "deviceActive";
      
      public static const DEVICE_READY_TO_BROWSE:String = "deviceReadyToBrowse";
      
      public static const DEVICES:String = "devices";
      
      public static const PLAY_ITEMS:String = "playItems";
      
      public static const PLAY_PATH:String = "playPath";
      
      public static const PLAY_TIME:String = "playTime";
      
      public static const RANDOM_MODE:String = "randomMode";
      
      public static const REPEAT_MODE:String = "repeatMode";
      
      public static const SEEK_SPEED:String = "seekSpeed";
      
      public static const SKIP_THRESHOLD:String = "skipThreshold";
      
      public static const TRANSPORT_ACTION:String = "transportAction";
      
      public static const SYNC_STATE:String = "syncState";
      
      public static const MEDIA_ERROR:String = "mediaError";
      
      public static const MEDIA_UNPLAYABLE:String = "mediaUnplayable";
      
      public static const PLAYLIST_COUNT:String = "playlistCount";
      
      public static const VR_COUNT:String = "vrCount";
      
      public static const SEARCH_COUNT:String = "searchCount";
      
      public static const DEVICE_CAPABILITY:String = "DeviceCapability";
      
      public var data:*;
      
      public function MediaPlayerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.data = data;
         super(type,bubbles,cancelable);
      }
   }
}

