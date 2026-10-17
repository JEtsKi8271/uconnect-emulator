package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioInstantReplayPlayStatus
   {
      
      private var mPauseStatus:String = "Unknown";
      
      private var mIsLive:Boolean = true;
      
      private var mFFActive:Boolean = false;
      
      private var mRWActive:Boolean = false;
      
      private var mScanActive:Boolean = false;
      
      public function SatelliteRadioInstantReplayPlayStatus()
      {
         super();
      }
      
      public function get pauseStatus() : String
      {
         return this.mPauseStatus;
      }
      
      public function set pauseStatus(s:String) : void
      {
         this.mPauseStatus = s;
      }
      
      public function get isLive() : Boolean
      {
         return this.mIsLive;
      }
      
      public function set isLive(b:Boolean) : void
      {
         this.mIsLive = b;
      }
      
      public function get FFActive() : Boolean
      {
         return this.mFFActive;
      }
      
      public function set FFActive(b:Boolean) : void
      {
         this.mFFActive = b;
      }
      
      public function get RWActive() : Boolean
      {
         return this.mRWActive;
      }
      
      public function set RWActive(b:Boolean) : void
      {
         this.mRWActive = b;
      }
      
      public function get scanActive() : Boolean
      {
         return this.mScanActive;
      }
      
      public function set scanActive(b:Boolean) : void
      {
         this.mScanActive = b;
      }
   }
}

