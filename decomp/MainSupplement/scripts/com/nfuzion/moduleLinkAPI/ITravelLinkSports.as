package com.nfuzion.moduleLinkAPI
{
   public interface ITravelLinkSports extends IModule
   {
      
      function init() : void;
      
      function requestServiceStatus() : void;
      
      function get serviceStatus() : String;
      
      function requestLeagueList() : void;
      
      function requestFavoritesList() : void;
      
      function setLeague(param1:uint) : void;
      
      function get league() : uint;
      
      function get favorites() : Array;
      
      function requestListById(param1:uint) : void;
      
      function requestLeaderboard(param1:uint) : void;
      
      function requestPreviousList() : void;
      
      function requestCurrentScreen() : void;
      
      function get currentList() : TravelLinkSportsGenericList;
      
      function get currentGameList() : TravelLinkSportsGameList;
      
      function get scheduleList() : TravelLinkSportsGenericList;
      
      function get teamsInfo() : TravelLinkSportsGenericList;
      
      function get table() : TravelLinkSportsTable;
      
      function setFavorite(param1:uint) : void;
      
      function setFavoriteTeam(param1:int, param2:int, param3:int, param4:int = -1) : void;
      
      function removeFavoriteTeam(param1:int) : void;
      
      function requestTeamInformation(param1:int, param2:int, param3:int) : void;
      
      function requestTeamSchedule(param1:int, param2:int, param3:int) : void;
   }
}

