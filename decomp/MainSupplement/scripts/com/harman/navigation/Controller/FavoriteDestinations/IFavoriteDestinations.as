package com.harman.navigation.Controller.FavoriteDestinations
{
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IFavoriteDestinations extends IModule
   {
      
      function getList() : void;
      
      function getPostion(param1:int = 0) : void;
      
      function get list() : Vector.<FavoriteDestination>;
      
      function get maxListSize() : int;
      
      function moveItem(param1:int, param2:String) : int;
      
      function renameDestination(param1:int, param2:String) : void;
      
      function renameYomi(param1:int, param2:String) : void;
      
      function changePostion(param1:int, param2:LocationDescription) : void;
      
      function changeDestinationSecondaryLocation(param1:int, param2:LocationDetails) : void;
      
      function setPhoneNumber(param1:int, param2:String) : void;
      
      function addDestination(param1:LocationDescription, param2:Object = null) : Boolean;
      
      function deleteDestination(param1:int) : void;
      
      function deleteAllDestinations() : void;
      
      function getChimeStatus(param1:int) : Boolean;
      
      function setChime(param1:int, param2:Boolean) : Boolean;
   }
}

