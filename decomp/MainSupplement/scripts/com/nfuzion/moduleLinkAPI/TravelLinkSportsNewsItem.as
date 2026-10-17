package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkSportsNewsItem
   {
      
      private static const dbusPropertyScreenType:String = "screenType";
      
      private static const dbusPropertyDescription:String = "description";
      
      private static const dbusPropertyListHeader:String = "listHeader";
      
      private static const dbusPropertyDate:String = "date";
      
      private var mScreenType:String = "";
      
      private var mDescription:String = "";
      
      private var mListHeader:String = "";
      
      private var mDate:String = "";
      
      public function TravelLinkSportsNewsItem(data:Object = null)
      {
         super();
         if(null != data)
         {
            if(data.hasOwnProperty(dbusPropertyScreenType))
            {
               this.mScreenType = data.screenType;
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
         }
      }
      
      public function get description() : String
      {
         return this.mDescription;
      }
      
      public function get screenType() : String
      {
         return this.mScreenType;
      }
      
      public function get header() : String
      {
         return this.mListHeader;
      }
      
      public function get date() : String
      {
         return this.mDate;
      }
   }
}

