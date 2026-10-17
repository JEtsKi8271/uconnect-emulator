package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SatelliteRadioInstantReplayEvent extends Event
   {
      
      public static const BUFFER_INFO:String = "bufferInfo";
      
      public static const PAUSE_PLAY_MODE:String = "pausePlayMode";
      
      public static const PLAY_STATUS:String = "playStatus";
      
      public static const PLAYLIST:String = "playList";
      
      public static const CURRENT_OFFSET:String = "currentOffset";
      
      public static const PLAYLIST_ITEM_COUNT:String = "playlistItemCount";
      
      public static const BUFFER_WARNING:String = "bufferWarning";
      
      public static const BUFFER_FULL:String = "bufferFull";
      
      public var mData:Object = null;
      
      public function SatelliteRadioInstantReplayEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

