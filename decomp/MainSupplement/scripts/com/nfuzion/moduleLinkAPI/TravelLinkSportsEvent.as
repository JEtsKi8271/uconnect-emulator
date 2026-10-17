package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TravelLinkSportsEvent extends Event
   {
      
      public static const SPORTS_SERVICE_STATUS:String = "sportsServiceStatus";
      
      public static const SPORTS_LIST:String = "sportsLeaguesList";
      
      public static const SPORTS_LEAGUE_HEADLINES:String = "sportsLeagueHeadlines";
      
      public static const SPORTS_LEAGUE_SCHEDULE:String = "sportsLeagueScheduleDates";
      
      public static const SPORTS_TEAMS_LIST:String = "sportsTeamsList";
      
      public static const SPORTS_TEAM_INFO:String = "sportsTeamInfo";
      
      public static const SPORTS_GAME_SCORE:String = "sportsGameScore";
      
      public static const SPORTS_GAME_STATUS:String = "sportsGameStatus";
      
      public static const SPORTS_GAMES_LIST:String = "sportsGamesList";
      
      public static const SPORTS_TABULAR_LIST:String = "sportsTabularList";
      
      public static const SPORTS_ERROR:String = "sportsError";
      
      public static const SPORTS_FAVORITES:String = "sportsFavorites";
      
      public var mData:Object = null;
      
      public function TravelLinkSportsEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
   }
}

