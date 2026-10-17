package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioInstantReplayBufferInfo
   {
      
      private var mFillPercent:int = 0;
      
      private var mPlaybackPercent:int = 0;
      
      private var mHours:int = 0;
      
      private var mMinutes:int = 0;
      
      private var mSeconds:int = 0;
      
      public function SatelliteRadioInstantReplayBufferInfo()
      {
         super();
      }
      
      public function set fillPercent(i:int) : void
      {
         this.mFillPercent = i;
      }
      
      public function get fillPercent() : int
      {
         return this.mFillPercent;
      }
      
      public function set playbackPercent(i:int) : void
      {
         this.mPlaybackPercent = i;
      }
      
      public function get playbackPercent() : int
      {
         return this.mPlaybackPercent;
      }
      
      public function set hours(i:int) : void
      {
         this.mHours = i;
      }
      
      public function get hours() : int
      {
         return this.mHours;
      }
      
      public function set minutes(i:int) : void
      {
         this.mMinutes = i;
      }
      
      public function get minutes() : int
      {
         return this.mMinutes;
      }
      
      public function set seconds(i:int) : void
      {
         this.mSeconds = i;
      }
      
      public function get seconds() : int
      {
         return this.mSeconds;
      }
   }
}

