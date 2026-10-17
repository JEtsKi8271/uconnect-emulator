package com.harman.navigation.Controller.FavoriteDestinations
{
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.dbService.DBControlType;
   
   public class FavoriteDestinationsController extends FavoriteDestinationBase implements IFavoriteDestinations
   {
      
      public function FavoriteDestinationsController()
      {
         super(DBControlType.SAVED_DATABASE);
      }
      
      override public function getList() : void
      {
         this.sendEvent(FavoriteDestinationsEvent.FD_LIST_UPDATE);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new FavoriteDestinationsEvent(eventType));
      }
      
      override protected function onDBServiceState(e:NavigationEvent) : void
      {
         super.onDBServiceState(e);
         if(bReady)
         {
            NavigationApi.api.addEventListener(NavigationEvent.DB_FAVORITE_CHANGED,onDBChanged,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.DB_FAVORITE_LIST_READY,onFavoriteList,false,0,true);
            super.onDBChanged(null);
         }
      }
   }
}

