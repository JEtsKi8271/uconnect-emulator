package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPoiInput extends IModule
   {
      
      function poiGetIsBusy() : void;
      
      function get poiIsBusy() : Boolean;
      
      function poiOnBack() : void;
      
      function poiOnCancel() : void;
      
      function poiGetIputPath() : void;
      
      function get poiInputPath() : int;
      
      function poiSetInputPath(param1:int) : void;
      
      function poiGetActiveMenu() : void;
      
      function get poiActiveMenu() : int;
      
      function poiGetTypesForLastResult() : void;
      
      function poiSelectListEntry(param1:int) : void;
      
      function poiSetListLength(param1:int) : void;
      
      function poiSetListStartIndex(param1:int) : void;
      
      function poiGetStartIndex() : void;
      
      function get poiListStartIndex() : int;
      
      function poiGetListSegment() : void;
      
      function get poiListUpdate() : Array;
      
      function get poiList() : PoiList;
      
      function get poiCategories() : PoiCategories;
      
      function get poiCategoriesAvailable() : Boolean;
      
      function poiGetListSizeTotal() : void;
      
      function get poiListSizeTotal() : int;
      
      function poiAddSearchNameCharacters(param1:String) : void;
      
      function poiGetSearchByName() : void;
      
      function get poiSearchByName() : String;
      
      function poiGetRemainingCount() : void;
      
      function poiGetListCounts() : void;
      
      function get poiCountPOI() : int;
      
      function get poiCountCAT() : int;
      
      function poiRemoveLastCharacters(param1:int) : void;
      
      function poiRemoveAllCharacters() : void;
      
      function poiGetSearchAreaDefault() : void;
      
      function get poiSearchAreaDefault() : int;
      
      function poiSelectDefaultSearchArea(param1:int) : void;
      
      function poiGetSearchAreaCurrent() : void;
      
      function get poiSearchAreaCurrent() : int;
      
      function poiGetSearchAreaRestricted() : void;
      
      function get poiSearchAreaRestricted() : Boolean;
      
      function poiSetSearchInCity(param1:LocationDescription) : void;
      
      function poiGetSearchCity() : void;
      
      function get poiSearchCity() : LocationDescription;
      
      function poiGetDetails(param1:String) : void;
      
      function get poiDetails() : String;
      
      function poiSetPreset(param1:String) : void;
      
      function get poiPreset() : String;
      
      function poiByPhoneSetDigits(param1:String) : void;
      
      function poiByPhoneGetDigits() : void;
      
      function getSearchingName() : Object;
      
      function get poiResultsID() : int;
      
      function get poiByPhoneDigits() : SpellerInfo;
      
      function poiGetListSegmentName() : void;
      
      function get poiSortOption() : int;
   }
}

