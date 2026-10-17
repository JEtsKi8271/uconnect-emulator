package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.Controller.LiveServices.LocalSearchResultList;
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   
   public class LocalSearch extends Helper
   {
      
      private var mSearchArea:int = 0;
      
      private var mSearchGeo:String = "";
      
      private var mTripAssemblerMode:int = 0;
      
      private var mSearchString:String = "";
      
      private var mSearchPending:Boolean = false;
      
      private var mSearchFailed:Boolean = false;
      
      private var mResultList:LocalSearchResultList = new LocalSearchResultList(new Array());
      
      public function LocalSearch()
      {
         super();
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE,this.onSearchUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_LOCAL_SEARCH_UPDATE_FAIL,this.onSearchUpdateFail,false,0,true);
      }
      
      public function setLocalSearchSearchArea(area:int, geo:String) : void
      {
         this.mSearchArea = area;
         this.mSearchGeo = geo;
         NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.LOCATION_LIVE_SERVICES_LOCAL_SEARCH);
      }
      
      public function setLocalSearchMainTripAssemblerMode(mode:int) : void
      {
         this.mTripAssemblerMode = mode;
      }
      
      public function get localSearchMainTripAssemblerMode() : int
      {
         return this.mTripAssemblerMode;
      }
      
      public function prepareNewSearch() : void
      {
         this.mSearchPending = true;
         this.mSearchFailed = false;
      }
      
      public function requestLocalSearch(searchString:String) : void
      {
         this.mSearchString = searchString;
         this.mSearchPending = true;
         this.mSearchFailed = false;
         this.mResultList = new LocalSearchResultList(new Array());
         NavigationApi.api.lsRequestLocalSearch(this.mSearchString,this.mSearchGeo,NavGlobalSettingsCommon.TTLS_LOCAL_SEARCH_RADIUS,NavGlobalSettingsCommon.TTLS_LOCAL_SEARCH_RESULT_COUNT);
         sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE);
      }
      
      public function get localSearchString() : String
      {
         return this.mSearchString;
      }
      
      public function get isSearchPending() : Boolean
      {
         return this.mSearchPending;
      }
      
      public function get isSearchFailed() : Boolean
      {
         return this.mSearchFailed;
      }
      
      public function get searchResults() : LocalSearchResultList
      {
         return this.mResultList;
      }
      
      public function getLocationDescriptionForTomTomID(id:int) : LocationDescription
      {
         return this.mResultList.getLocationDescriptionForTomTomID(id);
      }
      
      public function requestLocalSearchCancelSearch() : void
      {
      }
      
      public function set localSearchSortOrder(order:int) : void
      {
         this.mResultList.sortOrder = order;
         sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE);
      }
      
      private function onSearchUpdate(e:NavigationEvent) : void
      {
         this.mResultList = new LocalSearchResultList(e.data as Array);
         this.mSearchPending = false;
         this.mSearchFailed = false;
         sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE);
      }
      
      private function onSearchUpdateFail(e:NavigationEvent) : void
      {
         this.mSearchPending = false;
         this.mSearchFailed = true;
         sendEvent(LiveServicesEvent.LS_LOCAL_SEARCH_UPDATE_FAIL);
      }
   }
}

