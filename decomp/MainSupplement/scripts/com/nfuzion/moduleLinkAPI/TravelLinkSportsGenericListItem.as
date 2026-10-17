package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsGenericListItem
   {
      
      private static const dbusPropertyId:String = "id";
      
      private static const dbusPropertySportId:String = "sid";
      
      private static const dbusPropertyLeagueId:String = "lid";
      
      private static const dbusPropertyDescription:String = "description";
      
      private static const dbusPropertyTeamName:String = "teamName";
      
      private static const dbusPropertyShortTeamName:String = "teamAbbrev";
      
      private static const dbusPropertyLeagueAbbrev:String = "leagueAbbrev";
      
      private static const dbusPropertyNickname:String = "nickname";
      
      private static const dbusPropertyTeamId:String = "teamID";
      
      private static const dbusPropertyIsFavorite:String = "isFavorite";
      
      private static const dbusPropertyIsPressable:String = "isPressable";
      
      private static const dbusPropertyStatus:String = "status";
      
      private static const dbusPropertyScore:String = "score";
      
      private static const dbusPropertyChannel:String = "channel";
      
      private static const dbusPropertyTextLeft:String = "textLeft";
      
      private static const dbusPropertyTextRight:String = "textRight";
      
      private static const dbusPropertyTextCenter:String = "textCenter";
      
      private static const dbusPropertyPosition:String = "position";
      
      private static const dbusPropertyDriver:String = "driver";
      
      private static const dbusPropertyLap:String = "lap";
      
      private static const dbusPropertyPlayer:String = "player";
      
      private static const dbusPropertyRound:String = "round";
      
      private static const dbusPropertyHole:String = "hole";
      
      private static const dbusPropertyPlusMinus:String = "plusminus";
      
      public var id:uint = 0;
      
      public var sportId:uint = 0;
      
      public var leagueId:uint = 0;
      
      public var leagueAbbrev:String = "";
      
      public var teamId:uint = 0;
      
      public var isPressable:Boolean = false;
      
      public var isFavorite:Boolean = false;
      
      public var isHomeTeam:Boolean = false;
      
      private var mName:String = "";
      
      public var shortName:String = "";
      
      public var nickname:String = "";
      
      public var description:String = "";
      
      public var score:String = "";
      
      public var channel:Number = -1;
      
      public var position:String = "";
      
      public var lap:String = "";
      
      public var round:String = "";
      
      public var hole:String = "";
      
      public var plusMinus:String = "";
      
      public var textLeft:String = "";
      
      public var textRight:String = "";
      
      public var textCenter:String = "";
      
      public function TravelLinkSportsGenericListItem(data:Object = null, homeTeam:Boolean = false)
      {
         super();
         this.isHomeTeam = homeTeam;
         if(null != data)
         {
            if(data.hasOwnProperty(dbusPropertySportId))
            {
               this.sportId = data.sid;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueAbbrev))
            {
               this.leagueAbbrev = data.leagueAbbrev;
            }
            if(data.hasOwnProperty(dbusPropertyId))
            {
               this.id = data.id;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueId))
            {
               this.leagueId = data.lid;
            }
            if(data.hasOwnProperty(dbusPropertyScore))
            {
               this.score = String(data.score);
            }
            if(data.hasOwnProperty(dbusPropertyChannel))
            {
               this.channel = data.channel;
            }
            if(data.hasOwnProperty(dbusPropertyTeamId))
            {
               this.teamId = data.teamID;
            }
            if(data.hasOwnProperty(dbusPropertyDescription))
            {
               this.description = data.description;
            }
            if(data.hasOwnProperty(dbusPropertyTeamName))
            {
               this.mName = data.teamName;
            }
            if(data.hasOwnProperty(dbusPropertyShortTeamName))
            {
               this.shortName = data.teamAbbrev;
            }
            else if(data.hasOwnProperty(dbusPropertyPlayer))
            {
               this.mName = data.player;
            }
            else if(data.hasOwnProperty(dbusPropertyDriver))
            {
               this.mName = data.driver;
            }
            if(data.hasOwnProperty(dbusPropertyIsPressable))
            {
               this.isPressable = data.isPressable;
            }
            if(data.hasOwnProperty(dbusPropertyIsFavorite))
            {
               this.isFavorite = data.isFavorite;
            }
            if(data.hasOwnProperty(dbusPropertyHole))
            {
               this.hole = data.hole;
            }
            if(data.hasOwnProperty(dbusPropertyRound))
            {
               this.round = data.round;
            }
            if(data.hasOwnProperty(dbusPropertyPlusMinus))
            {
               this.plusMinus = data.plusminus;
            }
            if(data.hasOwnProperty(dbusPropertyPosition))
            {
               this.position = data.position;
            }
            if(data.hasOwnProperty(dbusPropertyLap))
            {
               this.lap = data.lap;
            }
            if(data.hasOwnProperty(dbusPropertyTextLeft))
            {
               this.textLeft = data.textLeft;
            }
            if(data.hasOwnProperty(dbusPropertyTextRight))
            {
               this.textRight = data.textRight;
            }
            if(data.hasOwnProperty(dbusPropertyTextCenter))
            {
               this.textCenter = data.textCenter;
            }
            if(data.hasOwnProperty(dbusPropertyNickname))
            {
               this.nickname = data.nickname;
            }
         }
      }
      
      public function get name() : String
      {
         return this.mName + " " + this.nickname;
      }
   }
}

