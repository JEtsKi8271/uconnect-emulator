package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ITravelLinkSports;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsGameList;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsGameListItem;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsGenericList;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsNewsItem;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsScreenTypes;
   import com.nfuzion.moduleLinkAPI.TravelLinkSportsTable;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class TravelLinkSports extends Module implements ITravelLinkSports
   {
      
      private static const IS_TEST:Boolean = false;
      
      private static const dbusIdentifier:String = "XMSports";
      
      private static const dbusId:String = "id";
      
      private static const dbusSignalServiceStatus:String = "status";
      
      private static const dbusSignalCurrentScreen:String = "currentScreen";
      
      private static const dbusSignalFavoriteTeams:String = "favorites";
      
      private static const dbusSignalCmdResponse:String = "CmdResponse";
      
      private static const dbusMethodLeagueList:String = "enterSports";
      
      private static const dbusMethodFavoriteList:String = "favoriteList";
      
      private static const dbusMethodSetFavoriteTeam:String = "setFavoriteTeam";
      
      private static const dbusMethodRemoveFavoriteTeam:String = "removeFavoriteTeam";
      
      private static const dbusMethodGetListById:String = "listButtonPress";
      
      private static const dbusMethodGetPreviousList:String = "backPressed";
      
      private static const dbusMethodRequestTeamInfo:String = "requestTeamInfo";
      
      private static const dbusMethodRequestLeaderboard:String = "requestLeaderboard";
      
      private static const dbusMethodRequestSchedule:String = "getTeamEventDateList";
      
      private static const dbusPropertyScreenType:String = "screenType";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mServiceStatus:String;
      
      private var mLeague:uint;
      
      private var mGenericList:TravelLinkSportsGenericList = new TravelLinkSportsGenericList();
      
      private var mGameList:TravelLinkSportsGameList = new TravelLinkSportsGameList();
      
      private var mGameInfo:TravelLinkSportsGameListItem = new TravelLinkSportsGameListItem();
      
      private var mTable:TravelLinkSportsTable = new TravelLinkSportsTable();
      
      private var mNewsItem:TravelLinkSportsNewsItem = new TravelLinkSportsNewsItem();
      
      private var mTeamInfo:Object = new Object();
      
      private var mFavoriteTeams:Array = new Array();
      
      private var mXMSportsServiceAvailable:Boolean = false;
      
      public function TravelLinkSports()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.TRAVELLINK_SPORTS,this.messageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe(dbusSignalServiceStatus);
            this.sendSubscribe(dbusSignalCurrentScreen);
            this.sendSubscribe(dbusSignalFavoriteTeams);
            this.sendSubscribe(dbusSignalCmdResponse);
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.sendUnsubscribe(dbusSignalServiceStatus);
         this.sendUnsubscribe(dbusSignalCurrentScreen);
         this.sendUnsubscribe(dbusSignalFavoriteTeams);
         this.sendUnsubscribe(dbusSignalCmdResponse);
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      override public function getAll() : void
      {
      }
      
      override public function isReady() : Boolean
      {
         return this.client.connected;
      }
      
      public function init() : void
      {
      }
      
      public function requestServiceStatus() : void
      {
         this.sendGetPropertyCommand(dbusSignalServiceStatus);
      }
      
      public function get serviceStatus() : String
      {
         return this.mServiceStatus;
      }
      
      public function requestLeagueList() : void
      {
         this.sendCommand(dbusMethodLeagueList,null,null);
      }
      
      public function requestFavoritesList() : void
      {
         this.sendGetPropertyCommand("favorites");
      }
      
      public function setLeague(leagueID:uint) : void
      {
         this.mLeague = leagueID;
      }
      
      public function get league() : uint
      {
         return this.mLeague;
      }
      
      public function get favorites() : Array
      {
         return this.mFavoriteTeams;
      }
      
      public function requestListById(id:uint) : void
      {
         this.sendCommand(dbusMethodGetListById,dbusId,id);
      }
      
      public function requestLeaderboard(id:uint) : void
      {
         this.sendCommand(dbusMethodRequestLeaderboard,dbusId,id);
      }
      
      public function requestPreviousList() : void
      {
         this.sendCommand(dbusMethodGetPreviousList,null,null);
      }
      
      public function requestCurrentScreen() : void
      {
         this.sendGetPropertyCommand(dbusSignalCurrentScreen);
      }
      
      public function requestTeamSchedule(leagueID:int, sportID:int, teamID:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusMethodRequestSchedule + "\": {\"teamID\":" + teamID + ", \"leagueID\":" + leagueID + ", \"sportID\":" + sportID + "}}}";
         this.client.send(message);
      }
      
      public function requestTeamInformation(sportID:int, leagueID:int, teamID:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusMethodRequestTeamInfo + "\": {\"teamID\":" + teamID + ", \"leagueID\":" + leagueID + ", \"sportID\":" + sportID + "}}}";
         this.client.send(message);
      }
      
      public function get currentList() : TravelLinkSportsGenericList
      {
         return this.mGenericList;
      }
      
      public function get currentGameList() : TravelLinkSportsGameList
      {
         return this.mGameList;
      }
      
      public function get scheduleList() : TravelLinkSportsGenericList
      {
         return null;
      }
      
      public function get teamsInfo() : TravelLinkSportsGenericList
      {
         return null;
      }
      
      public function get currentNewsItem() : TravelLinkSportsNewsItem
      {
         return this.mNewsItem;
      }
      
      public function get table() : TravelLinkSportsTable
      {
         return this.mTable;
      }
      
      public function setFavorite(id:uint) : void
      {
      }
      
      public function setFavoriteTeam(sportID:int, leagueID:int, teamID:int, index:int = -1) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dbusMethodSetFavoriteTeam + "\": {\"sportID\":" + sportID + ", \"leagueID\":" + leagueID + ", \"teamID\":" + teamID + ", \"index\":" + index + "}}}";
         this.client.send(message);
      }
      
      public function removeFavoriteTeam(index:int) : void
      {
         this.sendCommand(dbusMethodRemoveFavoriteTeam,"index",index,false);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendGetPropertyCommand(property:String) : void
      {
         var message:String = null;
         if(property != null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + property + "\"]}}}";
            this.client.send(message);
         }
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var sports:Object = e.data;
         if(sports.hasOwnProperty("dBusServiceAvailable"))
         {
            if(sports.dBusServiceAvailable == "true" && this.mXMSportsServiceAvailable == false)
            {
               this.mXMSportsServiceAvailable = true;
               this.requestFavoritesList();
            }
            else if(sports.dBusServiceAvailable == "false")
            {
               this.mXMSportsServiceAvailable = false;
            }
         }
         else if(!sports.hasOwnProperty("requestTeamList"))
         {
            if(sports.hasOwnProperty("listButtonPress"))
            {
               if(sports.listButtonPress.hasOwnProperty("CmdResponse"))
               {
                  if(sports.listButtonPress.CmdResponse.errCode != "eSuccess")
                  {
                     this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.listButtonPress.CmdResponse));
                  }
               }
            }
            else if(sports.hasOwnProperty("enterSports"))
            {
               if(sports.enterSports.hasOwnProperty("CmdResponse"))
               {
                  if(sports.enterSports.CmdResponse.errCode != "eSuccess")
                  {
                     this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.enterSports.CmdResponse));
                  }
               }
            }
            else if(sports.hasOwnProperty("requestTeamInfo"))
            {
               if(sports.requestTeamInfo.hasOwnProperty("CmdResponse"))
               {
                  if(sports.requestTeamInfo.CmdResponse.errCode != "eSuccess")
                  {
                     this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.requestTeamInfo.CmdResponse));
                  }
               }
            }
            else if(sports.hasOwnProperty("requestLeaderboard"))
            {
               if(sports.requestLeaderboard.hasOwnProperty("CmdResponse"))
               {
                  if(sports.requestLeaderboard.CmdResponse.errCode != "eSuccess")
                  {
                     this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.requestLeaderboard.CmdResponse));
                  }
               }
            }
            else if(sports.hasOwnProperty("getTeamEventDateList"))
            {
               if(sports.getTeamEventDateList.hasOwnProperty("CmdResponse"))
               {
                  if(sports.getTeamEventDateList.CmdResponse.errCode != "eSuccess")
                  {
                     this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.getTeamEventDateList.CmdResponse));
                  }
               }
            }
            else if(sports.hasOwnProperty(dbusSignalServiceStatus))
            {
               this.mServiceStatus = sports.status;
               this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_SERVICE_STATUS));
            }
            else if(sports.hasOwnProperty(dbusSignalCurrentScreen))
            {
               this.procScreenUpdate(sports.currentScreen);
            }
            else if(sports.hasOwnProperty(dbusSignalFavoriteTeams))
            {
               this.mFavoriteTeams = sports.favorites.favorites;
               this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_FAVORITES));
            }
            else if(!sports.hasOwnProperty("activeGame"))
            {
               if(sports.hasOwnProperty("CmdResponse"))
               {
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_ERROR,sports.CmdResponse));
               }
            }
         }
      }
      
      private function procScreenUpdate(msg:Object) : void
      {
         var gameInfo:TravelLinkSportsGameListItem = null;
         var screenType:String = "";
         if(msg != null && msg.hasOwnProperty(dbusPropertyScreenType))
         {
            screenType = msg.screenType;
            switch(screenType)
            {
               case TravelLinkSportsScreenTypes.LIST:
                  this.mGenericList = new TravelLinkSportsGenericList(msg);
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_LIST));
                  break;
               case TravelLinkSportsScreenTypes.RL:
               case TravelLinkSportsScreenTypes.TEAM:
                  this.mTeamInfo = msg;
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_TEAM_INFO,this.mTeamInfo));
                  break;
               case TravelLinkSportsScreenTypes.RACE:
               case TravelLinkSportsScreenTypes.GOLF:
                  this.mGenericList = new TravelLinkSportsGenericList(msg);
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_TABULAR_LIST));
                  break;
               case TravelLinkSportsScreenTypes.GAME:
                  gameInfo = new TravelLinkSportsGameListItem(msg);
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_GAME_SCORE,gameInfo));
                  break;
               case TravelLinkSportsScreenTypes.SCORE:
                  this.mGameList = new TravelLinkSportsGameList(msg);
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_GAMES_LIST));
                  break;
               case TravelLinkSportsScreenTypes.NEWS:
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_LEAGUE_HEADLINES,msg));
                  break;
               case TravelLinkSportsScreenTypes.TABLE:
                  this.mTable = new TravelLinkSportsTable(msg);
                  this.dispatchEvent(new TravelLinkSportsEvent(TravelLinkSportsEvent.SPORTS_TABULAR_LIST));
            }
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

