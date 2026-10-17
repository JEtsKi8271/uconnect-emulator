package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioInstantReplayBufferEntry
   {
      
      private var mOffset:int = 0;
      
      private var mArtist:String = "";
      
      private var mProgram:String = "";
      
      private var mComposer:String = "";
      
      private var mArtistID:String = "";
      
      private var mProgramID:String = "";
      
      public function SatelliteRadioInstantReplayBufferEntry()
      {
         super();
      }
      
      public function get offset() : int
      {
         return this.mOffset;
      }
      
      public function set offset(i:int) : void
      {
         this.mOffset = i;
      }
      
      public function get artist() : String
      {
         return this.mArtist;
      }
      
      public function set artist(s:String) : void
      {
         this.mArtist = s;
      }
      
      public function get program() : String
      {
         return this.mProgram;
      }
      
      public function set program(s:String) : void
      {
         this.mProgram = s;
      }
      
      public function get composer() : String
      {
         return this.mComposer;
      }
      
      public function set composer(s:String) : void
      {
         this.mComposer = s;
      }
      
      public function get artistID() : String
      {
         return this.mArtistID;
      }
      
      public function set artistID(s:String) : void
      {
         this.mArtistID = s;
      }
      
      public function get programID() : String
      {
         return this.mProgramID;
      }
      
      public function set programID(s:String) : void
      {
         this.mProgramID = s;
      }
   }
}

