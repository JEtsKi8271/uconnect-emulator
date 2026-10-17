package com.nfuzion.moduleLinkAPI
{
   public class GameZoneFavoriteTeam
   {
      
      public static const ALERT_GAME:String = "GAME";
      
      public static const ALERT_SCORE:String = "SCORE";
      
      public static const ALERT_BOTH:String = "GAME_SCORE";
      
      public static const ALERT_NONE:String = "NONE";
      
      public static const ALERT_END:String = "END";
      
      private var mLeague:uint = 0;
      
      private var mTeamID:uint = 0;
      
      private var mTeamName:String = "";
      
      private var mTeamNick:String = "";
      
      private var mAlertType:String = "";
      
      public var isFavorite:Boolean = false;
      
      public function GameZoneFavoriteTeam()
      {
         super();
      }
      
      public function set league(s:uint) : void
      {
         this.mLeague = s;
      }
      
      public function get league() : uint
      {
         return this.mLeague;
      }
      
      public function set teamID(s:uint) : void
      {
         this.mTeamID = s;
      }
      
      public function get teamID() : uint
      {
         return this.mTeamID;
      }
      
      public function set teamName(s:String) : void
      {
         this.mTeamName = s;
      }
      
      public function get teamName() : String
      {
         return this.mTeamName;
      }
      
      public function set teamNick(s:String) : void
      {
         this.mTeamNick = s;
      }
      
      public function get teamNick() : String
      {
         return this.mTeamNick;
      }
      
      public function set alertType(s:String) : void
      {
         this.mAlertType = s;
      }
      
      public function get alertType() : String
      {
         return this.mAlertType;
      }
   }
}

