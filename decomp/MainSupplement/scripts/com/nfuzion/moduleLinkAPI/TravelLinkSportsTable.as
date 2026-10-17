package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsTable
   {
      
      private static const dbusPropertyDate:String = "date";
      
      private static const dbusPropertyDescription:String = "description";
      
      private static const dbusPropertySportId:String = "sid";
      
      private static const dbusPropertyLeagueId:String = "lid";
      
      private static const dbusPropertyHeaders:String = "headers";
      
      private static const dbusPropertyRows:String = "rows";
      
      private static const dbusPropertyLeagueAbbrev:String = "leagueAbbrev";
      
      private var mDate:String = "";
      
      private var mDescription:String = "";
      
      private var mLeagueId:int;
      
      private var mLeagueAbbrev:String = "";
      
      private var mSportId:int;
      
      private var mHeaders:Array = new Array();
      
      private var mRows:Vector.<Object> = new Vector.<Object>();
      
      private var mScrollable:Boolean = false;
      
      public function TravelLinkSportsTable(data:Object = null)
      {
         var headerString:String = null;
         var headerItem:Object = null;
         var rowData:Object = null;
         super();
         if(data != null)
         {
            if(data.hasOwnProperty(dbusPropertyHeaders))
            {
               if(data.headers.length != 0)
               {
                  if(data.headers[0] is String)
                  {
                     for each(headerString in data.headers)
                     {
                        if(headerString != "")
                        {
                           this.mHeaders.push(headerString);
                        }
                     }
                     this.mScrollable = false;
                  }
                  else if(data.headers[0] is Object)
                  {
                     for each(headerItem in data.headers)
                     {
                        if(headerItem.name != "" && headerItem.pr != -1)
                        {
                           this.mHeaders.push(headerItem);
                        }
                     }
                     this.mScrollable = true;
                  }
               }
            }
            if(data.hasOwnProperty(dbusPropertyRows))
            {
               for each(rowData in data.rows)
               {
                  this.mRows.push(rowData);
               }
            }
            if(data.hasOwnProperty(dbusPropertyDate))
            {
               this.mDate = data.date;
            }
            if(data.hasOwnProperty(dbusPropertyDescription))
            {
               this.mDescription = data.description;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueId))
            {
               this.mLeagueId = data.lid;
            }
            if(data.hasOwnProperty(dbusPropertyLeagueAbbrev))
            {
               this.mLeagueAbbrev = data.leagueAbbrev;
            }
            if(data.hasOwnProperty(dbusPropertySportId))
            {
               this.mSportId = data.sid;
            }
         }
      }
      
      public function get rows() : Vector.<Object>
      {
         return this.mRows;
      }
      
      public function get headers() : Array
      {
         return this.mHeaders;
      }
      
      public function get date() : String
      {
         return this.mDate;
      }
      
      public function get lid() : int
      {
         return this.mLeagueId;
      }
      
      public function get sid() : int
      {
         return this.mSportId;
      }
      
      public function get description() : String
      {
         return this.mDescription;
      }
      
      public function get scrollable() : Boolean
      {
         return this.mScrollable;
      }
      
      public function get leagueAbbrev() : String
      {
         return this.mLeagueAbbrev;
      }
      
      public function getItemByRange(start:int, end:int) : Vector.<Object>
      {
         var i:int = 0;
         var tempList:Vector.<Object> = new Vector.<Object>();
         if(this.mRows.length == 0)
         {
            return tempList;
         }
         if(end >= this.mRows.length)
         {
            end = this.mRows.length - 1;
         }
         if(start < this.mRows.length)
         {
            for(i = start; i <= end; i++)
            {
               tempList.push(this.mRows[i]);
            }
         }
         return tempList;
      }
   }
}

