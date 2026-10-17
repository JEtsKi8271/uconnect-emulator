package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsGenericList
   {
      
      private static const dbusPropertyScreenType:String = "screenType";
      
      private static const dbusPropertySportId:String = "sid";
      
      private static const dbusPropertyDescription:String = "description";
      
      private static const dbusPropertyListHeader:String = "listHeader";
      
      private static const dbusPropertyDate:String = "date";
      
      private static const dbusPropertyGameList:String = "gameList";
      
      private static const dbusPropertyText:String = "text";
      
      private static const dbusPropertyResults:String = "results";
      
      private static const dbusPropertyList:String = "list";
      
      private static const dbusPropertyHomeTeam:String = "homeTeam";
      
      private static const dbusPropertyAwayTeam:String = "awayTeam";
      
      private static const dbusPropertyStatus:String = "status";
      
      private static const dbusPropertyIsFavorite:String = "isFavorite";
      
      private static const dbusPropertyEventName:String = "eventName";
      
      private static const dbusPropertyEventLocation:String = "eventLocation";
      
      private static const dbusPropertyEventTime:String = "eventTime";
      
      private static const dbusPropertyFavorites:String = "favorites";
      
      private static const dbusPropertyLeagueAbbrev:String = "leagueAbbrev";
      
      private static const dbusPropertyLeagueId:String = "lid";
      
      private var mScreenType:String = "";
      
      private var mLeagueId:uint = 0;
      
      private var mLeagueAbbrev:String = "";
      
      private var mSportId:uint;
      
      private var mDescription:String = "";
      
      private var mListHeader:String = "";
      
      private var mDate:String = "";
      
      private var mListType:String = "";
      
      private var mIsFavorite:Boolean = false;
      
      private var mIsHomeTeam:Boolean = false;
      
      private var mGameStatus:String = "";
      
      private var mEventName:String = "";
      
      private var mEventLocation:String = "";
      
      private var mEventTime:String = "";
      
      private var mList:Vector.<TravelLinkSportsGenericListItem> = new Vector.<TravelLinkSportsGenericListItem>();
      
      public function TravelLinkSportsGenericList(data:Object = null)
      {
         var item:Object = null;
         var i:TravelLinkSportsGenericListItem = null;
         super();
         if(null != data)
         {
            if(data.hasOwnProperty(dbusPropertyScreenType))
            {
               this.mScreenType = data.screenType;
            }
            if(data.hasOwnProperty(dbusPropertySportId))
            {
               this.mSportId = data.sid;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueId))
            {
               this.mLeagueId = data.lid;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueAbbrev))
            {
               this.mLeagueAbbrev = data.leagueAbbrev;
            }
            if(data.hasOwnProperty(dbusPropertyDescription))
            {
               this.mDescription = data.description;
            }
            if(data.hasOwnProperty(dbusPropertyListHeader))
            {
               this.mListHeader = data.listHeader;
            }
            if(data.hasOwnProperty(dbusPropertyDate))
            {
               this.mDate = data.date;
            }
            if(data.hasOwnProperty(dbusPropertyIsFavorite))
            {
               this.mIsFavorite = data.isFovorite == "TRUE" ? true : false;
            }
            if(data.hasOwnProperty(dbusPropertyEventName))
            {
               this.mEventName = data.eventName;
            }
            if(data.hasOwnProperty(dbusPropertyEventLocation))
            {
               this.mEventLocation = data.eventLocation;
            }
            if(data.hasOwnProperty(dbusPropertyEventTime))
            {
               this.mEventTime = data.eventTime;
            }
            if(data.hasOwnProperty(dbusPropertyList))
            {
               this.mListType = dbusPropertyList;
               for each(item in data.list)
               {
                  i = new TravelLinkSportsGenericListItem(item);
                  this.mList.push(i);
               }
            }
            if(data.hasOwnProperty(dbusPropertyFavorites))
            {
               this.mListType = dbusPropertyFavorites;
               for each(item in data.favorites)
               {
                  i = new TravelLinkSportsGenericListItem(item);
                  this.mList.push(i);
               }
            }
            if(data.hasOwnProperty(dbusPropertyResults))
            {
               this.mListType = dbusPropertyResults;
               for each(item in data.results)
               {
                  i = new TravelLinkSportsGenericListItem(item);
                  this.mList.push(i);
               }
            }
            if(data.hasOwnProperty(dbusPropertyStatus))
            {
               this.mGameStatus = data.status;
            }
            if(data.hasOwnProperty(dbusPropertyHomeTeam))
            {
            }
            if(data.hasOwnProperty(dbusPropertyAwayTeam))
            {
            }
         }
      }
      
      public function get length() : int
      {
         return this.mList.length;
      }
      
      public function get list() : Vector.<TravelLinkSportsGenericListItem>
      {
         return this.mList;
      }
      
      public function get description() : String
      {
         return this.mDescription;
      }
      
      public function get screenType() : String
      {
         return this.mScreenType;
      }
      
      public function get leagueId() : uint
      {
         return this.mLeagueId;
      }
      
      public function get sportId() : uint
      {
         return this.mSportId;
      }
      
      public function get leagueAbbrev() : String
      {
         return this.mLeagueAbbrev;
      }
      
      public function get header() : String
      {
         return this.mListHeader;
      }
      
      public function get date() : String
      {
         return this.mDate;
      }
      
      public function get listType() : String
      {
         return this.mListType;
      }
      
      public function sort(sortType:String) : void
      {
         if(sortType == "ascendingName")
         {
            this.mList.sort(this.compareDescriptionAscending);
         }
      }
      
      public function filterFavoritesOnly() : void
      {
         this.mList = this.mList.filter(this.isFavorite,this);
      }
      
      public function deleteList() : void
      {
         while(this.mList.length > 0)
         {
            this.mList.pop();
         }
      }
      
      public function getItemByIndex(index:int) : TravelLinkSportsGenericListItem
      {
         return this.mList[index];
      }
      
      public function getItemByRange(start:int, end:int) : Vector.<TravelLinkSportsGenericListItem>
      {
         var i:int = 0;
         var tempList:Vector.<TravelLinkSportsGenericListItem> = new Vector.<TravelLinkSportsGenericListItem>();
         if(this.mList.length == 0)
         {
            return tempList;
         }
         if(end >= this.mList.length)
         {
            end = this.mList.length - 1;
         }
         if(start < this.mList.length)
         {
            for(i = start; i <= end; i++)
            {
               tempList.push(this.mList[i]);
            }
         }
         return tempList;
      }
      
      private function compareDescriptionAscending(i:TravelLinkSportsGenericListItem, j:TravelLinkSportsGenericListItem) : Number
      {
         if(i.description < j.description)
         {
            return -1;
         }
         if(i.description > j.description)
         {
            return 1;
         }
         return 0;
      }
      
      private function isFavorite(item:TravelLinkSportsGenericListItem, index:int, vector:Vector.<TravelLinkSportsGenericListItem>) : Boolean
      {
         return item.isFavorite;
      }
      
      public function makeFakeData() : void
      {
         var tempItem:TravelLinkSportsGenericListItem = null;
         this.deleteList();
         for(var i:int = 0; i < 15; i++)
         {
            tempItem = new TravelLinkSportsGenericListItem();
            tempItem.id = 1000 + i;
            tempItem.leagueId = this.mLeagueId;
            tempItem.description = "TL Sports Description: " + i;
            tempItem.isPressable = true;
            tempItem.isFavorite = false;
            this.mList.push(tempItem);
         }
      }
   }
}

