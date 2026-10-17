package com.harman.navigation.Controller.FavoriteDestinations
{
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.dbService.DBControlType;
   import com.harman.navigation.dbService.DBItem;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class FavoriteDestinationBase extends EventDispatcher
   {
      
      protected var mDests:Vector.<FavoriteDestination>;
      
      protected var mDBType:String;
      
      protected var bReady:Boolean = false;
      
      protected var bPinSlotAvailable:Boolean = false;
      
      protected var mLastUserPinStatus:PinStatus;
      
      protected var mMoveupIndex:int = -1;
      
      protected var mMoveDownIndex:int = -1;
      
      protected var mItemsWaitingForUpdate:Vector.<FavoriteDestination>;
      
      public function FavoriteDestinationBase(type:String)
      {
         super();
         this.mDests = new Vector.<FavoriteDestination>();
         this.mItemsWaitingForUpdate = new Vector.<FavoriteDestination>();
         NavigationApi.impl = NavigationImpl.create();
         this.mDBType = type;
         if(NavigationApi.api.isDbServiceReady == false)
         {
            NavigationApi.api.addEventListener(NavigationEvent.DB_SERVICE_READY,this.onDBServiceState,false,0,true);
         }
         else
         {
            this.onDBServiceState(null);
         }
      }
      
      protected function isGetItemsOK() : Boolean
      {
         return NavigationApi.api.getDBCounts(this.mDBType) > 0;
      }
      
      protected function getDBList() : Vector.<DBItem>
      {
         return NavigationApi.api.getDestinationList();
      }
      
      public function getList() : void
      {
      }
      
      public function getPostion(type:int = 0) : void
      {
      }
      
      public function get list() : Vector.<FavoriteDestination>
      {
         if(this.isGetItemsOK())
         {
            if(this.mDests.length == 0)
            {
               this.onServiceNotBusy(null);
            }
         }
         return this.mDests;
      }
      
      public function refreshList() : void
      {
         if(this.mMoveupIndex != -1 || this.mMoveDownIndex != -1)
         {
            this.mMoveupIndex = this.mMoveDownIndex = -1;
         }
      }
      
      protected function sendBusy(busy:Boolean) : void
      {
      }
      
      public function moveItem(index:int, direction:String) : int
      {
         if(this.isIndexValid(index))
         {
            if(this.mLastUserPinStatus == null || this.mLastUserPinStatus.listIndex != index)
            {
               this.mLastUserPinStatus = null;
               this.getPinStatus(index);
            }
            if(NavigationApi.api.moveDestination(this.mDBType,this.mDests[index],direction) == true)
            {
               if(direction == DBControlType.DB_OPTYPE_MOVE_UP)
               {
                  index = this.mLastUserPinStatus.moveUpToIndex;
               }
               else
               {
                  index = this.mLastUserPinStatus.moveDownToIndex;
               }
            }
         }
         this.mLastUserPinStatus = null;
         return index;
      }
      
      public function get maxListSize() : int
      {
         return NavigationApi.api.getDBMaxLimits(this.mDBType);
      }
      
      protected function isIndexValid(index:int) : Boolean
      {
         if(index >= 0 && index < this.mDests.length)
         {
            return true;
         }
         return false;
      }
      
      protected function onDBServiceState(e:NavigationEvent) : void
      {
         this.bReady = NavigationApi.api.isDbServiceReady;
         Framework.Trace(this.mDBType + " -> FavoriteDestinationControllerBase got readyEvent");
      }
      
      public function addDestination(dest:LocationDescription, data:Object = null) : Boolean
      {
         var tempFav:FavoriteDestination = new FavoriteDestination(dest);
         if(dest != null)
         {
            return NavigationApi.api.addDestination(this.mDBType,tempFav);
         }
         return false;
      }
      
      public function deleteDestination(index:int) : void
      {
         if(this.isIndexValid(index))
         {
            NavigationApi.api.removeDestination(this.mDBType,this.mDests[index].location.databaseKey);
            this.mDests.splice(index,1);
            this.getList();
         }
      }
      
      public function deleteAllDestinations() : void
      {
         this.clearList();
         NavigationApi.api.removeAllDestinations(this.mDBType);
         this.getList();
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return this.bReady;
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
      
      public function getPinStatus(index:int) : PinStatus
      {
         var i:* = 0;
         var j:int = 0;
         if(index < 0 || index >= this.mDests.length)
         {
            return null;
         }
         var moveUpIndex:int = -1;
         var moveDownIndex:int = -1;
         if(this.mDests[index].pinned == false)
         {
            if(index != 0)
            {
               for(i = int(index - 1); i >= 0; i--)
               {
                  if(this.mDests[i].pinned == false)
                  {
                     moveUpIndex = i;
                     break;
                  }
               }
            }
            if(index != this.mDests.length - 1)
            {
               for(j = index + 1; j < this.mDests.length; j++)
               {
                  if(this.mDests[j].pinned == false)
                  {
                     moveDownIndex = j;
                     break;
                  }
               }
            }
         }
         if(this.mLastUserPinStatus == null)
         {
            this.mLastUserPinStatus = new PinStatus(index,this.mDests[index].pinned,moveUpIndex,moveDownIndex);
         }
         else
         {
            this.mLastUserPinStatus.setPinStatus(index,this.mDests[index].pinned,moveUpIndex,moveDownIndex);
         }
         return this.mLastUserPinStatus;
      }
      
      public function getChimeStatus(index:int) : Boolean
      {
         return false;
      }
      
      protected function setPinSlotAvailable(count:int) : void
      {
         this.bPinSlotAvailable = false;
      }
      
      protected function clearList() : void
      {
         if(this.mDests != null && this.mDests.length > 0)
         {
            this.mDests.splice(0,this.mDests.length);
         }
      }
      
      protected function onFavoriteList(e:NavigationEvent) : void
      {
         var item:FavoriteDestination = null;
         this.clearList();
         var dbItemList:Vector.<DBItem> = this.getDBList();
         var usedPinSlotCounter:int = 0;
         var bNeedPin:Boolean = false;
         var bNeedSort:Boolean = false;
         if(this.mDBType == DBControlType.RECENT_DATABASE)
         {
            bNeedPin = bNeedSort = true;
         }
         for(var i:int = 0; i < dbItemList.length; i++)
         {
            item = dbItemList[i].getMyLocDescription(bNeedSort,bNeedPin);
            if(item != null)
            {
               if(item.pinned)
               {
                  usedPinSlotCounter++;
               }
               this.mDests.push(item);
            }
         }
         this.setPinSlotAvailable(usedPinSlotCounter);
         this.mLastUserPinStatus = null;
         this.mMoveDownIndex = this.mMoveupIndex = -1;
         this.sendBusy(false);
         this.getList();
      }
      
      private function onServiceNotBusy(e:NavigationEvent) : void
      {
         NavigationApi.api.removeEventListener(NavigationEvent.DB_SERVICE_NOT_BUSY,this.onServiceNotBusy);
         if(NavigationApi.api.requestItems(this.mDBType) == false)
         {
            NavigationApi.api.addEventListener(NavigationEvent.DB_SERVICE_NOT_BUSY,this.onServiceNotBusy,false,0,true);
         }
      }
      
      public function get pinSlotAvailable() : Boolean
      {
         return this.bPinSlotAvailable;
      }
      
      protected function onDBChanged(e:NavigationEvent) : void
      {
         if(this.isGetItemsOK())
         {
            this.onServiceNotBusy(null);
         }
         else
         {
            this.clearList();
         }
      }
      
      public function renameDestination(index:int, name:String) : void
      {
         if(name != null && name != "" && this.mDBType != DBControlType.HOME_DATABASE)
         {
            if(this.isIndexValid(index))
            {
               this.mDests[index].location.setName(name);
               this.getList();
               if(!NavigationApi.api.updateDestination(this.mDBType,this.mDests[index]))
               {
                  this.mItemsWaitingForUpdate.push(this.mDests[index]);
                  NavigationApi.api.addEventListener(NavigationEvent.DB_SERVICE_NOT_BUSY,this.updateDatabaseItemWhenDBServiceAvail,false,0,true);
               }
            }
         }
      }
      
      public function renameYomi(index:int, name:String) : void
      {
      }
      
      public function changePostion(index:int, loc:LocationDescription) : void
      {
      }
      
      public function changeDestinationSecondaryLocation(index:int, secLocation:LocationDetails) : void
      {
         if(secLocation != null && secLocation.toEIS() != "" && this.mDBType != DBControlType.HOME_DATABASE)
         {
            if(this.isIndexValid(index))
            {
               this.mDests[index].location.setSecondaryLocation(secLocation);
               this.getList();
               if(!NavigationApi.api.updateDestination(this.mDBType,this.mDests[index]))
               {
                  this.mItemsWaitingForUpdate.push(this.mDests[index]);
                  NavigationApi.api.addEventListener(NavigationEvent.DB_SERVICE_NOT_BUSY,this.updateDatabaseItemWhenDBServiceAvail,false,0,true);
               }
            }
         }
      }
      
      public function updateDatabaseItemWhenDBServiceAvail(e:NavigationEvent) : void
      {
         if(this.mItemsWaitingForUpdate.length > 0 && NavigationApi.api.updateDestination(this.mDBType,this.mItemsWaitingForUpdate[this.mItemsWaitingForUpdate.length - 1]))
         {
            this.mItemsWaitingForUpdate.pop();
         }
         if(this.mItemsWaitingForUpdate.length == 0)
         {
            NavigationApi.api.removeEventListener(NavigationEvent.DB_SERVICE_NOT_BUSY,this.updateDatabaseItemWhenDBServiceAvail);
         }
      }
      
      public function setPhoneNumber(index:int, number:String) : void
      {
         if(number != null)
         {
            if(this.isIndexValid(index))
            {
               this.mDests[index].location.getPrimaryLocation().addType("<TEL>",number);
               this.getList();
               NavigationApi.api.updateDestination(this.mDBType,this.mDests[index]);
               return;
            }
         }
      }
      
      public function setChime(index:int, chime:Boolean) : Boolean
      {
         return false;
      }
   }
}

