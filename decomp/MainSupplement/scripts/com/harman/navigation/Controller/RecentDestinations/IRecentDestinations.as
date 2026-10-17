package com.harman.navigation.Controller.RecentDestinations
{
   import com.harman.navigation.Controller.FavoriteDestinations.IFavoriteDestinations;
   import com.harman.navigation.Controller.FavoriteDestinations.PinStatus;
   
   public interface IRecentDestinations extends IFavoriteDestinations
   {
      
      function getIsBusy() : void;
      
      function get isBusy() : Boolean;
      
      function setPin(param1:int, param2:Boolean) : Boolean;
      
      function get pinSlotAvailable() : Boolean;
      
      function getPinStatus(param1:int) : PinStatus;
   }
}

