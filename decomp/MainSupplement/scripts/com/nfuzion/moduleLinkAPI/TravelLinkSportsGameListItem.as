package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsGameListItem
   {
      
      private static const dbusPropertyStatus:String = "status";
      
      private static const dbusPropertyDate:String = "date";
      
      private static const dbusPropertyHomeTeam:String = "homeTeam";
      
      private static const dbusPropertyAwayTeam:String = "awayTeam";
      
      private static const dbusPropertyWinner:String = "winner";
      
      private static const dbusPropertySportId:String = "sid";
      
      private static const dbusPropertyLeagueId:String = "lid";
      
      private static const dbusPropertyChannel:String = "channel";
      
      private static const dbusPropertyListId:String = "id";
      
      public var status:String = "";
      
      public var date:String = "";
      
      public var homeTeam:TravelLinkSportsGenericListItem;
      
      public var awayTeam:TravelLinkSportsGenericListItem;
      
      public var winner:String = "";
      
      public var sportId:uint;
      
      public var leagueId:uint;
      
      public var channel:int;
      
      public var id:int;
      
      public function TravelLinkSportsGameListItem(data:Object = null)
      {
         super();
         if(null != data)
         {
            if(data.hasOwnProperty(dbusPropertyListId))
            {
               this.id = data.id;
            }
            if(data.hasOwnProperty(dbusPropertySportId))
            {
               this.sportId = data.sid;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueId))
            {
               this.leagueId = data.lid;
            }
            if(data.hasOwnProperty(dbusPropertyStatus))
            {
               this.status = data.status;
            }
            if(data.hasOwnProperty(dbusPropertyDate))
            {
               this.date = data.date;
            }
            if(data.hasOwnProperty(dbusPropertyWinner))
            {
               this.winner = data.winner;
            }
            if(data.hasOwnProperty(dbusPropertyChannel))
            {
               this.channel = data.channel;
            }
            if(data.hasOwnProperty(dbusPropertyHomeTeam))
            {
               this.homeTeam = new TravelLinkSportsGenericListItem(data.homeTeam,true);
            }
            if(data.hasOwnProperty(dbusPropertyAwayTeam))
            {
               this.awayTeam = new TravelLinkSportsGenericListItem(data.awayTeam,false);
            }
         }
      }
   }
}

