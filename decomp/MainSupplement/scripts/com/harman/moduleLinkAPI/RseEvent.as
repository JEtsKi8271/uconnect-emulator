package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class RseEvent extends Event
   {
      
      public static const RSE_STATUS:String = "RseStatus";
      
      public static const SHUFFLE_STATUS:String = "ShuffleStatus";
      
      public static const DVD_OUT_STAT:String = "DvdOutStat";
      
      public static const REPEAT_STATUS:String = "RepeatStatus";
      
      public static const PLAY_TIME:String = "PlayTime";
      
      public static const CURRENT_TRACK_LENGTH:String = "CurrentTrackLength";
      
      public static const CURRENT_TRACK_INFO:String = "CurrentTrackInfo";
      
      public static const DISC_ERROR_VALUE:String = "DiscErrorValue";
      
      public static const RSE_CURRENT_TRACK:String = "rseCurrentTrack";
      
      public static const BROWSE_ITEMS:String = "BrowseItems";
      
      public static const ACTIVATE_BROWSE_BUTTON:String = "ActivateBrowseButton";
      
      public static const VIDEO_LOCKOUT_STATUS:String = "VideoLockoutStatus";
      
      public static const START_DISC_PLAY_STATUS:String = "StartDiscPlayStatus";
      
      public static const DVD_DISC_STAT:String = "DVD_DISC_STAT";
      
      public static const FULL_SCREEN_BUTTON_STATUS:String = "FULL_SCREEN_BUTTON_STATUS";
      
      public static const BRANCH_ON_EXIT_FULL_SCREEN:String = "BranchOnExitFullScreen";
      
      public static const BROWSE_PATH:String = "Browse_path";
      
      public static const REAR_VIDEO_STATUS:String = "RearVideoStatus";
      
      public static const RDC2_VIDEO_STATUS:String = "Rdc2VideoStatus";
      
      public static const RDC2_MODE_STARTED:String = "Rdc2ModeStarted";
      
      public static const CAM_AVAILABILITY:String = "CamAvailability";
      
      public static const VRM_AVAILABILITY:String = "VRMAvailability";
      
      public static const REQUEST_ICS_TUNING:String = "requestICSTuning";
      
      public var mData:Object = null;
      
      public function RseEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

