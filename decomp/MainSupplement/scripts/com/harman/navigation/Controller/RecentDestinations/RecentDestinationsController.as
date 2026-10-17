package com.harman.navigation.Controller.RecentDestinations
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestinationBase;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.dbService.DBControlType;
   
   public class RecentDestinationsController extends FavoriteDestinationBase implements IRecentDestinations
   {
      
      private var mBusy:Boolean;
      
      public function RecentDestinationsController()
      {
         super(DBControlType.RECENT_DATABASE);
      }
      
      override public function get list() : Vector.<FavoriteDestination>
      {
         this.mBusy = false;
         return super.list;
      }
      
      override public function getList() : void
      {
         this.sendEvent(RecentDestinationsEvent.RD_DESTINATIONS_CHANGED);
      }
      
      public function get isBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function isPinned(index:int) : Boolean
      {
         if(super.isIndexValid(index))
         {
            return mDests[index].pinned;
         }
         return false;
      }
      
      override public function moveItem(index:int, action:String) : int
      {
         var newIndex:int = super.moveItem(index,action);
         if(newIndex != index)
         {
            this.sendBusy(true);
         }
         return newIndex;
      }
      
      override protected function setPinSlotAvailable(count:int) : void
      {
         if(count >= NavGlobalSettings.RECENT_DESTINATIONS_PINNED_MAX)
         {
            bPinSlotAvailable = false;
         }
         else
         {
            bPinSlotAvailable = true;
         }
      }
      
      public function setPin(index:int, pin:Boolean) : Boolean
      {
         if(super.isIndexValid(index))
         {
            if(mDests[index].setPin(pin))
            {
               if(bPinSlotAvailable == false && pin == false)
               {
                  bPinSlotAvailable = true;
               }
               NavigationApi.api.updateDestination(mDBType,mDests[index]);
               return true;
            }
         }
         return false;
      }
      
      public function getIsBusy() : void
      {
         this.sendEvent(RecentDestinationsEvent.RD_BUSY);
      }
      
      override protected function sendBusy(busy:Boolean) : void
      {
         this.mBusy = busy;
         this.sendEvent(RecentDestinationsEvent.RD_BUSY);
      }
      
      protected function sendEvent(eventType:String) : void
      {
         dispatchEvent(new RecentDestinationsEvent(eventType));
      }
      
      override protected function onDBServiceState(e:NavigationEvent) : void
      {
         super.onDBServiceState(e);
         if(bReady)
         {
            NavigationApi.api.addEventListener(NavigationEvent.DB_RECENT_CHANGED,onDBChanged,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.DB_RECENT_LIST_READY,onFavoriteList,false,0,true);
            super.onDBChanged(null);
         }
      }
   }
}

