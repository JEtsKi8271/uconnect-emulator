package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsGameList
   {
      
      private static const dbusPropertyScreenType:String = "screenType";
      
      private static const dbusPropertySportId:String = "sid";
      
      private static const dbusPropertyDescription:String = "description";
      
      private static const dbusPropertyListHeader:String = "listHeader";
      
      private static const dbusPropertyDate:String = "date";
      
      private static const dbusPropertyGameList:String = "gameList";
      
      private static const dbusPropertyLeagueAbbrev:String = "leagueAbbrev";
      
      private var mScreenType:String = "";
      
      private var mSportId:uint = 0;
      
      private var mDescription:String = "";
      
      private var mListHeader:String = "";
      
      private var mDate:String = "";
      
      private var mListType:String = "";
      
      private var mLeagueAbbrev:String = "";
      
      private var mList:Vector.<TravelLinkSportsGameListItem> = new Vector.<TravelLinkSportsGameListItem>();
      
      public function TravelLinkSportsGameList(data:Object = null)
      {
         var item:Object = null;
         var i:TravelLinkSportsGameListItem = null;
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
            if(data.hasOwnProperty(dbusPropertyGameList))
            {
               this.mListType = dbusPropertyGameList;
               for each(item in data.gameList)
               {
                  i = new TravelLinkSportsGameListItem(item);
                  this.mList.push(i);
               }
            }
         }
      }
      
      public function get length() : int
      {
         return this.mList.length;
      }
      
      public function get list() : Vector.<TravelLinkSportsGameListItem>
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
            this.mList.sort(this.compareNameAscending);
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
      
      public function getItemByIndex(index:int) : TravelLinkSportsGameListItem
      {
         return this.mList[index];
      }
      
      public function getItemByRange(start:int, end:int) : Vector.<TravelLinkSportsGameListItem>
      {
         var i:int = 0;
         var tempList:Vector.<TravelLinkSportsGameListItem> = new Vector.<TravelLinkSportsGameListItem>();
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
      
      private function compareNameAscending(i:TravelLinkSportsGenericListItem, j:TravelLinkSportsGenericListItem) : Number
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
      }
   }
}

