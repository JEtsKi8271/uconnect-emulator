package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.SatelliteRadioCategory;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioChannel;
   
   public class SatelliteRadioFullChannelList
   {
      
      public static const mSortChannelAscending:String = "CHANNEL_ASCENDING";
      
      public static const mSortChannelDescending:String = "CHANNEL_DESCENDING";
      
      public static const mSortCategoryAscending:String = "CATEGORY_ASCENDING";
      
      public static const mSortCategoryDescending:String = "CATEGORY_DESCENDING";
      
      private var mList:Vector.<SatelliteRadioChannel>;
      
      private var mSortOrder:String = "NONE";
      
      private var mCompareChannel:SatelliteRadioChannel;
      
      private var mFindChannel:SatelliteRadioChannel;
      
      private var mFindIndex:int;
      
      private var mCompareCategory:SatelliteRadioCategory;
      
      private var mBrowseIndex:uint;
      
      private var mFullLength:uint;
      
      private var mSkippedLength:uint;
      
      private var mLockedLength:uint;
      
      private var mUnsubscribedLength:uint;
      
      private var mReportedLength:uint;
      
      private var mIgnoreSkipped:Boolean;
      
      private var mIgnoreLocked:Boolean;
      
      private var mIgnoreUnsubscribed:Boolean;
      
      private var mFilteredList:Vector.<SatelliteRadioChannel>;
      
      public function SatelliteRadioFullChannelList()
      {
         super();
         this.mBrowseIndex = 1;
         this.mIgnoreLocked = true;
         this.mIgnoreSkipped = true;
         this.mIgnoreUnsubscribed = true;
         this.mFullLength = 400;
         this.mList = new Vector.<SatelliteRadioChannel>();
      }
      
      public function updateLength(length:uint) : void
      {
         this.mFullLength = length;
      }
      
      private function isChannelEqual(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         if(item.isEqual(this.mCompareChannel))
         {
            return true;
         }
         return false;
      }
      
      private function isFindEqual(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         if(item.isEqual(this.mFindChannel))
         {
            this.mFindIndex = index;
            return true;
         }
         return false;
      }
      
      private function isNotLocked(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.lock;
      }
      
      private function isNotSkipped(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.skip;
      }
      
      private function isNotUnsubscribed(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return item.subscribed;
      }
      
      private function isNotLockedAndNotSkipped(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.lock && !item.skip;
      }
      
      private function isNotSkippedAndNotUnsubscribed(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.skip && item.subscribed;
      }
      
      private function isNotLockedandNotUnsubscribed(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.lock && item.subscribed;
      }
      
      private function isNotSkippedAndNotLockedAndNotUnsubscribed(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return !item.skip && !item.lock && item.subscribed;
      }
      
      private function isCategory(item:SatelliteRadioChannel, index:int, vector:Vector.<SatelliteRadioChannel>) : Boolean
      {
         return item.category == this.mCompareCategory.name;
      }
      
      public function addChannel(ch:SatelliteRadioChannel) : Boolean
      {
         this.mCompareChannel = ch;
         var subSet:Vector.<SatelliteRadioChannel> = this.mList.filter(this.isChannelEqual,null);
         if(subSet.length == 0)
         {
            ch.index = this.mList.push(ch) - 1;
            return true;
         }
         subSet[0].updateInfo(ch);
         return false;
      }
      
      public function find(ch:SatelliteRadioChannel) : int
      {
         var subSet:Vector.<SatelliteRadioChannel> = null;
         this.mFindIndex = -1;
         if(null != this.mFilteredList && this.mFilteredList.length > 0)
         {
            this.mFindChannel = ch;
            subSet = this.mFilteredList.filter(this.isFindEqual,this);
         }
         return this.mFindIndex;
      }
      
      public function get list() : Vector.<SatelliteRadioChannel>
      {
         return this.mList;
      }
      
      public function deleteList() : void
      {
         while(this.mList.length > 0)
         {
            this.mList.pop();
         }
      }
      
      public function get length() : int
      {
         if(null == this.mFilteredList || null != this.mFilteredList && this.mFilteredList.length == 0)
         {
            return this.mList.length;
         }
         return this.mFilteredList.length;
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
                  this.mFilteredList.sort(this.compareChannelNumberAscending);
                  this.mSortOrder = mSortChannelAscending;
               }
               else if(sortOrder == 1)
               {
                  this.mFilteredList.sort(this.compareChannelNumberDescending);
                  this.mSortOrder = mSortChannelDescending;
               }
               break;
            case 1:
               if(sortOrder == 0)
               {
                  this.mFilteredList.sort(this.compareCategoryAscending);
                  this.mSortOrder = mSortChannelAscending;
               }
               else if(sortOrder == 1)
               {
                  this.mFilteredList.sort(this.compareCategoryDescending);
                  this.mSortOrder = mSortChannelDescending;
               }
         }
      }
      
      public function filter(includeSkippedChannels:Boolean, includeLockedChannels:Boolean, includeUnsubscribed:Boolean) : void
      {
         var update:Boolean = true;
         if(this.mIgnoreLocked == includeLockedChannels)
         {
            this.mIgnoreLocked = !includeLockedChannels;
            update = true;
         }
         if(this.mIgnoreSkipped == includeSkippedChannels)
         {
            this.mIgnoreSkipped = !includeSkippedChannels;
            update = true;
         }
         if(this.mIgnoreUnsubscribed == includeUnsubscribed)
         {
            this.mIgnoreUnsubscribed = !includeUnsubscribed;
            update = true;
         }
         this.mReportedLength = this.mList.length;
         if(this.mIgnoreSkipped)
         {
            this.mReportedLength -= this.mSkippedLength;
         }
         if(this.mIgnoreLocked)
         {
            this.mReportedLength -= this.mLockedLength;
         }
         if(this.mIgnoreUnsubscribed)
         {
            this.mReportedLength -= this.mUnsubscribedLength;
         }
         if(true == update || null == this.mFilteredList)
         {
            if(this.mIgnoreLocked && !this.mIgnoreSkipped && !this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotLocked,this);
            }
            else if(!this.mIgnoreLocked && this.mIgnoreSkipped && !this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotSkipped,this);
            }
            else if(!this.mIgnoreLocked && !this.mIgnoreSkipped && this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotUnsubscribed,this);
            }
            else if(this.mIgnoreLocked && this.mIgnoreSkipped && !this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotLockedAndNotSkipped,this);
            }
            else if(this.mIgnoreLocked && !this.mIgnoreSkipped && this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotLockedandNotUnsubscribed,this);
            }
            else if(!this.mIgnoreLocked && this.mIgnoreSkipped && this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList.filter(this.isNotSkippedAndNotUnsubscribed,this);
            }
            else if(!this.mIgnoreLocked && !this.mIgnoreSkipped && !this.mIgnoreUnsubscribed)
            {
               this.mFilteredList = this.mList;
            }
            else
            {
               this.mFilteredList = this.mList.filter(this.isNotSkippedAndNotLockedAndNotUnsubscribed,this);
            }
         }
      }
      
      public function slice(startIndex:int = 0, endIndex:int = -1) : Vector.<SatelliteRadioChannel>
      {
         return this.mFilteredList.slice(startIndex,endIndex);
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
      
      public function updateSkippedChannels(skipped:Vector.<int>) : void
      {
         var channel:SatelliteRadioChannel = null;
         this.mSkippedLength = skipped.length;
         for each(channel in this.mList)
         {
            if(skipped.indexOf(channel.number,0) >= 0)
            {
               channel.skip = true;
            }
            else
            {
               channel.skip = false;
            }
         }
      }
      
      public function updateLockedChannels(locked:Vector.<int>) : void
      {
         var channel:SatelliteRadioChannel = null;
         this.mLockedLength = locked.length;
         for each(channel in this.mList)
         {
            if(locked.indexOf(channel.number,0) >= 0)
            {
               channel.lock = true;
            }
            else
            {
               channel.lock = false;
            }
         }
      }
      
      public function getChannelsByCategory(category:String) : Vector.<SatelliteRadioChannel>
      {
         if("Traffic/Weather" == category)
         {
            this.mCompareCategory = new SatelliteRadioCategory();
            this.mCompareCategory.name = category;
            return this.mList.filter(this.isCategory,this);
         }
         this.mCompareCategory = new SatelliteRadioCategory();
         this.mCompareCategory.name = category;
         return this.mList.filter(this.isCategory,this);
      }
   }
}

