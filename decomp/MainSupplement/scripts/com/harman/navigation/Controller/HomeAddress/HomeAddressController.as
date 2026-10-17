package com.harman.navigation.Controller.HomeAddress
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestinationBase;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.dbService.DBControlType;
   import com.harman.navigation.dbService.DBItem;
   import com.harman.navigation.utils.LocationDescription;
   
   public class HomeAddressController extends FavoriteDestinationBase implements IHomeAddress
   {
      
      public function HomeAddressController()
      {
         super(DBControlType.HOME_DATABASE);
      }
      
      public function getHomeAddressSet() : void
      {
         this.sendEvent(HomeAddressEvent.HA_HOME_ADDRESS_SET);
      }
      
      override protected function onDBServiceState(e:NavigationEvent) : void
      {
         super.onDBServiceState(e);
         if(bReady)
         {
            NavigationApi.api.addEventListener(NavigationEvent.DB_HOME_READY,onFavoriteList,false,0,true);
            if(isGetItemsOK())
            {
               super.onFavoriteList(null);
            }
         }
      }
      
      override protected function getDBList() : Vector.<DBItem>
      {
         var tempVector:Vector.<DBItem> = new Vector.<DBItem>();
         tempVector.push(NavigationApi.api.getHome());
         return tempVector;
      }
      
      public function get homeAddressSet() : Boolean
      {
         if(isGetItemsOK())
         {
            return true;
         }
         return false;
      }
      
      override public function getList() : void
      {
         this.getHomeAddress();
      }
      
      override public function get maxListSize() : int
      {
         return 1;
      }
      
      public function getHomeAddress() : void
      {
         this.sendEvent(HomeAddressEvent.HA_HOME_ADDRESS);
      }
      
      public function get homeAddress() : LocationDescription
      {
         if(this.homeAddressSet)
         {
            if(mDests.length == 1)
            {
               return mDests[0].location;
            }
            super.onFavoriteList(null);
         }
         return null;
      }
      
      public function setHomeAddress(loc:LocationDescription) : void
      {
         clearList();
         var tempLoc:LocationDescription = new LocationDescription();
         tempLoc.clone(loc);
         tempLoc.setName("");
         NavigationApi.api.addDestination(DBControlType.HOME_DATABASE,new FavoriteDestination(tempLoc));
      }
      
      private function doHomeEvents() : void
      {
         this.sendEvent(HomeAddressEvent.HA_HOME_ADDRESS);
         this.sendEvent(HomeAddressEvent.HA_HOME_ADDRESS_SET);
      }
      
      public function clearHomeAddress() : void
      {
         clearList();
         this.doHomeEvents();
         NavigationApi.api.removeAllDestinations(DBControlType.HOME_DATABASE);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new HomeAddressEvent(eventType));
      }
   }
}

