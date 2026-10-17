package com.harman.navigation.Controller.LI
{
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ILocationInput extends IModule
   {
      
      function liSetInputPath(param1:int) : void;
      
      function liGetIputPath() : void;
      
      function get liInputPath() : int;
      
      function liGetActiveMenu() : void;
      
      function get liActiveMenu() : int;
      
      function liGetBusy() : void;
      
      function get liIsBusy() : Boolean;
      
      function onConfirmDestinationBack() : void;
      
      function liOnBack() : void;
      
      function liGetDefaultCountry() : void;
      
      function get liDefaultCountry() : String;
      
      function liGetDefaultCountryTemp() : void;
      
      function get liDefaultCountryTemp() : String;
      
      function liGetDefaultState() : void;
      
      function get liDefaultState() : String;
      
      function liGetDefaultCity() : void;
      
      function get liDefaultCity() : String;
      
      function setDefaultCountry(param1:String) : void;
      
      function setDefaultState(param1:String, param2:Boolean = false) : void;
      
      function liSetTripAssemble() : void;
      
      function liGetIsLanguageChangeInProgress() : void;
      
      function get liIsLanguageChangeInProgress() : Boolean;
      
      function get liIsLanguageChangeInProgressChina() : Boolean;
      
      function get zipCodeAvailable() : Boolean;
      
      function get streetFirstAvailable() : Boolean;
      
      function liSelectCharacter(param1:String) : void;
      
      function liRemoveLastCharacter() : void;
      
      function liRemoveAllCharacters() : void;
      
      function liGetAvailableCharacters() : void;
      
      function get liAvailableCharacters() : SpellerInfo;
      
      function liGetEnteredCharacters() : void;
      
      function get liEnteredCharacters() : String;
      
      function liSwitchToList() : void;
      
      function liSelectListItem(param1:int) : void;
      
      function liGetList() : void;
      
      function get list() : Array;
      
      function liSetResultsPerPage(param1:int) : void;
      
      function liGetCurrentPageNumber() : void;
      
      function get liCurrentPageNumber() : int;
      
      function liGetTotalPagesNumber() : void;
      
      function get liTotalPageNumber() : int;
      
      function liOnNextPage() : void;
      
      function liOnPreviousPage() : void;
      
      function set locationInputMenuPrevious(param1:int) : void;
      
      function liSetGeoCoordinate(param1:String, param2:String) : void;
      
      function liSetGeoLocation(param1:LocationDetails) : void;
      
      function get liFetchedGeoCoordinateDetails() : LocationDescription;
      
      function liGetCurrentInputProgress() : String;
   }
}

