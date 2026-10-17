package com.nfuzion.moduleLinkAPI
{
   public class GameAlert
   {
      
      private var mAlertType:String = "NONE";
      
      private var mChannel:int = -1;
      
      private var mLeague:String = "";
      
      private var mHome:String = "";
      
      private var mHomeAbbrev:String = "";
      
      private var mAway:String = "";
      
      private var mAwayAbbrev:String = "";
      
      private var mHomeScore:int = 0;
      
      private var mAwayScore:int = 0;
      
      private var mProgress:String = "";
      
      private var mGameTitle:String = "";
      
      public function GameAlert()
      {
         super();
      }
      
      public function get alertType() : String
      {
         return this.mAlertType;
      }
      
      public function set alertType(a:String) : void
      {
         this.mAlertType = a;
      }
      
      public function get channel() : int
      {
         return this.mChannel;
      }
      
      public function set channel(c:int) : void
      {
         this.mChannel = c;
      }
      
      public function get league() : String
      {
         return this.mLeague;
      }
      
      public function set league(l:String) : void
      {
         this.mLeague = l;
      }
      
      public function get home() : String
      {
         return this.mHome;
      }
      
      public function set home(s:String) : void
      {
         this.mHome = s;
      }
      
      public function get homeAbbrev() : String
      {
         return this.mHomeAbbrev;
      }
      
      public function set homeAbbrev(s:String) : void
      {
         this.mHomeAbbrev = s;
      }
      
      public function get away() : String
      {
         return this.mAway;
      }
      
      public function set away(s:String) : void
      {
         this.mAway = s;
      }
      
      public function get awayAbbrev() : String
      {
         return this.mAwayAbbrev;
      }
      
      public function set awayAbbrev(s:String) : void
      {
         this.mAwayAbbrev = s;
      }
      
      public function get homeScore() : int
      {
         return this.mHomeScore;
      }
      
      public function set homeScore(i:int) : void
      {
         this.mHomeScore = i;
      }
      
      public function get awayScore() : int
      {
         return this.mAwayScore;
      }
      
      public function set awayScore(i:int) : void
      {
         this.mAwayScore = i;
      }
      
      public function get progress() : String
      {
         return this.mProgress;
      }
      
      public function set progress(s:String) : void
      {
         this.mProgress = s;
      }
      
      public function set gameTitle(s:String) : void
      {
         this.mGameTitle = s;
      }
      
      public function get gameTitle() : String
      {
         return this.mGameTitle;
      }
   }
}

