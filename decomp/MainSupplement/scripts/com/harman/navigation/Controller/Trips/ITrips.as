package com.harman.navigation.Controller.Trips
{
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ITrips extends IModule
   {
      
      function getTripsIsBusy() : void;
      
      function get tripsIsBusy() : Boolean;
      
      function selectTrip(param1:int) : void;
      
      function get selectedTrip() : int;
      
      function selectDestination(param1:int) : void;
      
      function get selectedDestination() : int;
      
      function getTrips() : void;
      
      function get trips() : Array;
      
      function tripCreate(param1:String, param2:Boolean) : int;
      
      function tripRename(param1:int, param2:String, param3:Boolean) : Boolean;
      
      function tripDelete(param1:int) : void;
      
      function tripDeleteAll() : void;
      
      function tripMoveToPosition(param1:int, param2:int) : void;
      
      function destinationAdd(param1:int, param2:LocationDescription) : void;
      
      function startGuidanceTo(param1:int, param2:int) : void;
      
      function destinationSetName(param1:int, param2:int, param3:String) : void;
      
      function destinationSetPhoneNumber(param1:int, param2:int, param3:String) : void;
      
      function destinationMoveToPosition(param1:int, param2:int, param3:int) : void;
      
      function destinationRemove(param1:int, param2:int) : void;
      
      function destinationRemoveAll(param1:int) : void;
      
      function exportTrips() : void;
      
      function importTrips() : void;
      
      function isImportExportInProgress() : void;
      
      function get importExportInProgress() : Boolean;
   }
}

