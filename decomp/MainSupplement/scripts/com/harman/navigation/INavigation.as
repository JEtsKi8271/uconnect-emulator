package com.harman.navigation
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.dbService.DBItem;
   import com.harman.navigation.tmc.TmcEventList;
   import com.harman.navigation.utils.HighWayModeList;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.PickInfoDetails;
   import com.harman.navigation.utils.SpellerInfo;
   
   public interface INavigation extends INavigationCommon
   {
      
      function navGetIsReady() : void;
      
      function get navIsReady() : Boolean;
      
      function reportGuidanceRestarterFinished() : void;
      
      function getProductDeviceID() : void;
      
      function get productDeviceID() : String;
      
      function isProduct(param1:String) : Boolean;
      
      function getProductID() : void;
      
      function get productID() : String;
      
      function navGetIsActivated() : void;
      
      function get navIsActivated() : Boolean;
      
      function navFakeLicenseExpiration() : void;
      
      function navGetStartupState() : void;
      
      function get navStartupState() : int;
      
      function navGetDemoMode() : void;
      
      function get navDemoMode() : Boolean;
      
      function navSetDemoMode(param1:Boolean) : void;
      
      function navSetDemoModePosition(param1:Boolean, param2:String, param3:Boolean = false) : void;
      
      function get navDemoModePosition() : String;
      
      function navDemoModeServiceInit() : void;
      
      function get navDemoModeServiceIsInitialized() : Boolean;
      
      function get navDemoModeServicePositionsList() : Object;
      
      function navDemoModeServiceRenamePosition(param1:String, param2:String) : void;
      
      function navDemoModeServiceDeletePosition(param1:String) : void;
      
      function navAdaRepeat() : void;
      
      function navAdaPlayPrompt(param1:int) : void;
      
      function get langIsLanguageChangeInProgress() : Boolean;
      
      function get langCurrentLanguage() : int;
      
      function navGetAdaState() : void;
      
      function get navAdaState() : Boolean;
      
      function navSetAdaState(param1:Boolean) : void;
      
      function navGetAdaSpeaking() : Boolean;
      
      function navGetSpeedWarningEnabled() : void;
      
      function get navSpeedWarningEnabled() : Boolean;
      
      function get navSpeedWarningSpeedLimit() : Number;
      
      function setSpeedWarningsEnabled(param1:Boolean) : void;
      
      function setSpeedWarningsSpeedLimit(param1:Number) : void;
      
      function navGetSafetyCameraMode() : void;
      
      function get navSafetyCameraMode() : int;
      
      function navSetSafetyCameraMode(param1:int) : void;
      
      function navGetNavVersions() : void;
      
      function get navVersions() : Object;
      
      function rgCreateNewTrip(param1:TripRoute) : void;
      
      function rgCreateNewTrail(param1:String, param2:int) : void;
      
      function rgStartGuidanceForRouteHandle(param1:int) : void;
      
      function rgRequestTurnListForRouteHandle(param1:int) : void;
      
      function rgRequestRouteElementsInfo(param1:int) : void;
      
      function rgRequestRouteOptionsForRouteHandle(param1:int) : void;
      
      function rgStopGuidance() : void;
      
      function rgDestroyRoutesForRouteHandles(param1:String) : void;
      
      function rgBlockRouteSegment(param1:int, param2:int, param3:int) : void;
      
      function rgBlockRouteAhead(param1:int, param2:int) : void;
      
      function resetRouteList() : void;
      
      function get tmcPreviewList() : Array;
      
      function rgChangeTrip(param1:int, param2:Array) : void;
      
      function rtGetInterchangeList(param1:String) : void;
      
      function get rtInterchangeCurrent() : Array;
      
      function get rtInterchangeAlternatives() : Array;
      
      function get rtInterchangeDirections() : Array;
      
      function mapSendControlCmd(param1:String) : void;
      
      function mapSendWorldElementlCmd(param1:int, param2:Array) : void;
      
      function mapRequestMapDetails(param1:Array) : void;
      
      function get mapDetails() : String;
      
      function mapGetPoiVisibilities(param1:String = null) : void;
      
      function mapGetPoiVisibilitieslistCount(param1:String = null) : void;
      
      function get mapPoiVisibilities() : Array;
      
      function get mapPoiVisListCount() : Array;
      
      function mapSetPoiVisibility(param1:String, param2:Boolean) : void;
      
      function mapSetPoiVisibilities(param1:String) : void;
      
      function mapGetVehicleIcons() : void;
      
      function get mapVehicleIcons() : Array;
      
      function mapGetMapThemes() : void;
      
      function get mapThemes() : Array;
      
      function mapRequestPickInfo(param1:String, param2:int, param3:int, param4:int, param5:int) : void;
      
      function get mapPickInfo() : PickInfoDetails;
      
      function poiSetSearchAreaDefault(param1:int) : void;
      
      function poiGetSearchAreaDefault() : void;
      
      function get poiSearchAreaDefault() : int;
      
      function poiGetSearchAreaCurrent() : void;
      
      function get poiSearchAreaCurrent() : int;
      
      function poiGetSearchAreaRestriction() : void;
      
      function get poiSearchAreaRestriction() : Boolean;
      
      function poiSetSearchCity(param1:LocationDescription) : void;
      
      function poiGetSearchCity() : void;
      
      function get poiSearchCity() : LocationDescription;
      
      function poiSetSearchNearDestination(param1:LocationDescription) : void;
      
      function poiGetSearchNearDestination() : void;
      
      function get poiSearchNearDestination() : LocationDescription;
      
      function poiSetSearchCategory(param1:String) : void;
      
      function poiGetSearchCategories(param1:String) : int;
      
      function get poiSearchCategories() : Array;
      
      function poiSelectCharacter(param1:String) : void;
      
      function poiRemoveLastCharacter() : void;
      
      function poiClearInput() : void;
      
      function poiGetCharactersEntered() : void;
      
      function get poiCharactersEntered() : String;
      
      function poiGetCharactersAvailable() : void;
      
      function get poiCharactersAvailable() : String;
      
      function poiGetList(param1:int, param2:int, param3:Boolean = false) : int;
      
      function get poiList() : Array;
      
      function poiGetListCount() : void;
      
      function poiGetListCounts(param1:String) : void;
      
      function get poiListCount() : int;
      
      function get poiCatListCount() : int;
      
      function poiSelectListItem(param1:int) : void;
      
      function poiGetDetails(param1:String) : int;
      
      function get poiDetails() : LocationDetails;
      
      function poiGetPresetList(param1:String) : int;
      
      function get poiPresets() : Array;
      
      function poiGetPhoneNumberSpell() : void;
      
      function get poiPhoneNumberSpell() : SpellerInfo;
      
      function poiGetPhoneNumberList() : int;
      
      function poiStopReRequest() : void;
      
      function get poiSortOption() : int;
      
      function liGetList(param1:LocationDetails, param2:int, param3:int, param4:int) : void;
      
      function liGetListRequestFields(param1:LocationDetails, param2:int, param3:int, param4:int, param5:String) : void;
      
      function get liList() : Array;
      
      function liGetSpell(param1:LocationDetails) : void;
      
      function get liSpell() : SpellerInfo;
      
      function liGetDetails(param1:String) : void;
      
      function get liDetails() : LocationDetails;
      
      function liGetAvailableInformation(param1:String) : void;
      
      function get availableInformation() : Array;
      
      function posGetPositionInformation() : void;
      
      function get posPositionInformation() : LocationDetails;
      
      function get posPositionInformationString() : String;
      
      function posGetCompass() : void;
      
      function get posCompass() : String;
      
      function posGetJunctionViewState() : void;
      
      function get posJunctionViewState() : Boolean;
      
      function posGetIPDAreaState() : void;
      
      function get posIPDAreaState() : Boolean;
      
      function posEnableHighwayModeUpdate(param1:Boolean) : void;
      
      function posEnableHighwayModeUpdateTemporary(param1:Boolean) : void;
      
      function get posNextHighwayExits() : HighWayModeList;
      
      function getPosHighwayModeEnabled() : void;
      
      function get posHighwayModeEnabled() : Boolean;
      
      function tmcGetEventsList(param1:int) : void;
      
      function get tmcGetInfoType() : int;
      
      function get tmcEventsList() : TmcEventList;
      
      function getTmcEventDetails(param1:String) : void;
      
      function get tmcEventDetails() : Object;
      
      function getTmcLastDeletedEventIDs() : void;
      
      function get tmcLastDeletedEventIDs() : Array;
      
      function tmcAvoidTmcEventByEventID(param1:int) : void;
      
      function getTMCRouteMode() : void;
      
      function get TMCRouteMode() : int;
      
      function setTMCRouteMode(param1:int) : void;
      
      function getTMCDelayTime() : void;
      
      function get TMCDelayTime() : int;
      
      function setTMCDelayTime(param1:int) : void;
      
      function getTMCGroupTypes() : void;
      
      function get tmcGroupTypes() : Object;
      
      function tmcSetGroupTypesSelected(param1:Object) : void;
      
      function get tmcManualReRouteAlternatives() : Object;
      
      function tmcManualReRouteAccept(param1:String) : void;
      
      function tmcManualReRouteDecline(param1:String) : void;
      
      function getTmcStationsList() : void;
      
      function get tmcStationsList() : Array;
      
      function setTmcTuningMode(param1:int) : void;
      
      function get tmcTuningMode() : int;
      
      function setTmcTuningStation(param1:String) : void;
      
      function getTmcTuningStation() : void;
      
      function get tmcTuningStation() : String;
      
      function tmcQuerDelayTimeForRouteHandles(param1:Boolean) : void;
      
      function get tmcDelayTimesByRouteHandle() : Object;
      
      function get dbServiceState() : int;
      
      function get isDbServiceReady() : Boolean;
      
      function getDBCounts(param1:String) : int;
      
      function getDBMaxLimits(param1:String) : int;
      
      function addDestination(param1:String, param2:FavoriteDestination) : Boolean;
      
      function removeDestination(param1:String, param2:int) : Boolean;
      
      function removeAllDestinations(param1:String) : Boolean;
      
      function requestItems(param1:String, param2:int = 0, param3:int = -1) : Boolean;
      
      function getDestinationList() : Vector.<DBItem>;
      
      function getHome() : DBItem;
      
      function updateDestination(param1:String, param2:FavoriteDestination) : Boolean;
      
      function moveDestination(param1:String, param2:FavoriteDestination, param3:String) : Boolean;
      
      function sendTestCall() : void;
      
      function reportWarning(param1:String) : void;
      
      function get warningReports() : Array;
   }
}

