package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioChannelList
   {
      
      public static const mSortChannelAscending:String = "CHANNEL_ASCENDING";
      
      public static const mSortChannelDescending:String = "CHANNEL_DESCENDING";
      
      public static const mSortCategoryAscending:String = "CATEGORY_ASCENDING";
      
      public static const mSortCategoryDescending:String = "CATEGORY_DESCENDING";
      
      private var mOffset:uint;
      
      private var mList:Vector.<SatelliteRadioChannel>;
      
      private var mSortOrder:String = "NONE";
      
      private var mCompareChannel:SatelliteRadioChannel;
      
      public function SatelliteRadioChannelList(offset:uint, list:Vector.<SatelliteRadioChannel>)
      {
         super();
         this.mOffset = offset;
         this.mList = list;
      }
      
      private function isChannelEqual(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return item.isEqual(this.mCompareChannel);
      }
      
      public function addChannel(ch:SatelliteRadioChannel) : Boolean
      {
         this.mCompareChannel = ch;
         var subSet:Vector.<SatelliteRadioChannel> = this.mList.filter(this.isChannelEqual,null);
         if(subSet.length == 0)
         {
            this.mList.push(ch);
            return true;
         }
         subSet[0].updateInfo(ch);
         return false;
      }
      
      public function get offset() : uint
      {
         return this.mOffset;
      }
      
      public function get list() : Vector.<SatelliteRadioChannel>
      {
         return this.mList;
      }
      
      public function get length() : int
      {
         return this.mList.length;
      }
      
      public function get sortOrder() : String
      {
         return this.mSortOrder;
      }
      
      public function sort(sortField:int, sortOrder:int = 0) : void
      {
         switch(sortField)
         {
            case 0:
               if(sortOrder == 0)
               {
                  this.mList.sort(this.compareChannelNumberAscending);
                  this.mSortOrder = mSortChannelAscending;
               }
               else if(sortOrder == 1)
               {
                  this.mList.sort(this.compareChannelNumberDescending);
                  this.mSortOrder = mSortChannelDescending;
               }
               break;
            case 1:
               if(sortOrder == 0)
               {
                  this.mList.sort(this.compareCategoryAscending);
                  this.mSortOrder = mSortChannelAscending;
               }
               else if(sortOrder == 1)
               {
                  this.mList.sort(this.compareCategoryDescending);
                  this.mSortOrder = mSortChannelDescending;
               }
         }
      }
      
      private function compareChannelNumberAscending(i:SatelliteRadioChannel, j:SatelliteRadioChannel) : Number
      {
         if(i.number < j.number)
         {
            return -1;
         }
         if(i.number > j.number)
         {
            return 1;
         }
         return 0;
      }
      
      private function compareChannelNumberDescending(i:SatelliteRadioChannel, j:SatelliteRadioChannel) : Number
      {
         if(i.number < j.number)
         {
            return 1;
         }
         if(i.number > j.number)
         {
            return -1;
         }
         return 0;
      }
      
      private function compareCategoryAscending(i:SatelliteRadioChannel, j:SatelliteRadioChannel) : Number
      {
         if(i.category < j.category)
         {
            return -1;
         }
         if(i.category > j.category)
         {
            return 1;
         }
         return this.compareChannelNumberAscending(i,j);
      }
      
      private function compareCategoryDescending(i:SatelliteRadioChannel, j:SatelliteRadioChannel) : Number
      {
         if(i.category < j.category)
         {
            return 1;
         }
         if(i.category > j.category)
         {
            return -1;
         }
         return this.compareChannelNumberDescending(i,j);
      }
   }
}

