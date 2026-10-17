package com.harman.navigation
{
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.dbService.DBServiceManager;
   import com.harman.navigation.locationInput.LocationInputManager;
   import com.harman.navigation.map.MapManager;
   import com.harman.navigation.poi.PoiManager;
   import com.harman.navigation.position.PositionManager;
   import com.harman.navigation.routeCalculation.RouteCalculationManager;
   import com.harman.navigation.tmc.TmcEventList;
   import com.harman.navigation.tmc.TmcManager;
   import com.harman.navigation.utils.DemoModeHelper;
   import com.harman.navigation.utils.HighWayModeList;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.PickInfoDetails;
   import com.harman.navigation.utils.SpellerInfo;
   import com.harman.navigation.voiceGuidance.VoiceGuidanceManager;
   
   public class NavigationBase extends NavigationBaseCommon
   {
      
      protected var mMapManager:MapManager;
      
      protected var mPoiManager:PoiManager;
      
      protected var mPositionManager:PositionManager;
      
      protected var mRouteCalculationManager:RouteCalculationManager;
      
      protected var mLocationInputManager:LocationInputManager;
      
      protected var mVoiceGudanceManager:VoiceGuidanceManager;
      
      protected var mTmcManager:TmcManager;
      
      protected var mDBServiceManager:DBServiceManager;
      
      protected var mDemoModeHelper:DemoModeHelper;
      
      private var mWarningReports:Array = new Array();
      
      public function NavigationBase()
      {
         super();
      }
      
      public function mapSendControlCmd(mapEIS:String) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.sendControlCmd(mapEIS);
         }
      }
      
      public function mapSendWorldElementlCmd(weFunction:int, itemList:Array) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.sendWorldElementlCmd(weFunction,itemList);
         }
      }
      
      public function mapRequestMapDetails(eisArray:Array) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.mapRequestMapDetails(eisArray);
         }
      }
      
      public function mapGetPoiVisibilities(reqVis:String = null) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.getMapPoiVisibilities(reqVis);
         }
      }
      
      public function mapGetPoiVisibilitieslistCount(reqVis:String = null) : void
      {
      }
      
      public function get mapPoiVisibilities() : Array
      {
         return this.mMapManager.mapPoiVisibilities();
      }
      
      public function get mapPoiVisListCount() : Array
      {
         return this.mMapManager.mapPoiVisListCount();
      }
      
      public function mapSetPoiVisibility(id:String, visible:Boolean) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.mapSetPoiVisibility(id,visible);
         }
      }
      
      public function mapSetPoiVisibilities(idArrayString:String) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.mapSetPoiVisibilities(idArrayString);
         }
      }
      
      public function mapGetVehicleIcons() : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.getMapVehicleIcons();
         }
      }
      
      public function get mapVehicleIcons() : Array
      {
         return this.mMapManager.mapVehicleIcons();
      }
      
      public function mapGetMapThemes() : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.getMapThemes();
         }
      }
      
      public function get mapThemes() : Array
      {
         return this.mMapManager.mapThemes();
      }
      
      public function get mapPickInfo() : PickInfoDetails
      {
         return this.mMapManager.getPickInfo();
      }
      
      public function get mapDetails() : String
      {
         return this.mMapManager.getMapDetails();
      }
      
      public function mapRequestPickInfo(mapEIS:String, x:int, y:int, worldElementTypes:int, radius:int) : void
      {
         if(this.mMapManager != null)
         {
            this.mMapManager.mapRequestGetPickInfo(mapEIS,x,y,worldElementTypes,radius);
         }
      }
      
      public function poiSetSearchAreaDefault(area:int) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSetSearchAreaDefault(area);
         }
      }
      
      public function poiGetSearchAreaDefault() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetSearchAreaDefault();
         }
      }
      
      public function get poiSearchAreaDefault() : int
      {
         return this.mPoiManager.poiSearchAreaDefault();
      }
      
      public function poiGetSearchAreaCurrent() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetSearchAreaCurrent();
         }
      }
      
      public function get poiSearchAreaCurrent() : int
      {
         return this.mPoiManager.poiSearchAreaCurrent();
      }
      
      public function poiGetSearchAreaRestriction() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetSearchAreaRestriction();
         }
      }
      
      public function get poiSearchAreaRestriction() : Boolean
      {
         return this.mPoiManager.poiSearchAreaRestriction();
      }
      
      public function poiSetSearchCity(loc:LocationDescription) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSetSearchCity(loc);
         }
      }
      
      public function poiGetSearchCity() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetSearchCity();
         }
      }
      
      public function get poiSearchCity() : LocationDescription
      {
         return this.mPoiManager.poiSearchCity();
      }
      
      public function poiSetSearchNearDestination(loc:LocationDescription) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSetSearchNearDestination(loc);
         }
      }
      
      public function poiGetSearchNearDestination() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetSearchNearDestination();
         }
      }
      
      public function get poiSearchNearDestination() : LocationDescription
      {
         return this.mPoiManager.poiSearchNearDestination;
      }
      
      public function poiSetSearchCategory(category:String) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSetSearchCategory(category);
         }
      }
      
      public function poiGetSearchCategories(category:String) : int
      {
         if(this.mPoiManager != null)
         {
            return this.mPoiManager.poiGetSearchCategories(category);
         }
         return -1;
      }
      
      public function get poiSearchCategories() : Array
      {
         return this.mPoiManager.poiSearchCategories();
      }
      
      public function poiSelectCharacter(char:String) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSelectCharacter(char);
         }
      }
      
      public function poiRemoveLastCharacter() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiRemoveLastCharacter();
         }
      }
      
      public function poiClearInput() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiClearInput();
         }
      }
      
      public function poiGetCharactersEntered() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetCharactersEntered();
         }
      }
      
      public function get poiCharactersEntered() : String
      {
         return this.mPoiManager.poiCharactersEntered();
      }
      
      public function poiGetCharactersAvailable() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetCharactersAvailable();
         }
      }
      
      public function get poiCharactersAvailable() : String
      {
         return this.mPoiManager.poiCharactersAvailable();
      }
      
      public function poiGetList(startIndex:int, count:int, bForceNameRQT:Boolean = false) : int
      {
         if(this.mPoiManager != null)
         {
            return this.mPoiManager.poiGetList(startIndex,count,bForceNameRQT);
         }
         return -1;
      }
      
      public function get poiList() : Array
      {
         return this.mPoiManager.poiList();
      }
      
      public function poiGetListCount() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetListCount();
         }
      }
      
      public function poiGetListCounts(catEIS:String) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetListCounts(catEIS);
         }
      }
      
      public function get poiListCount() : int
      {
         return this.mPoiManager.poiListCount();
      }
      
      public function get poiCatListCount() : int
      {
         return this.mPoiManager.poiCatListCount();
      }
      
      public function poiSelectListItem(position:int) : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiSelectListItem(position);
         }
      }
      
      public function poiGetDetails(eisString:String) : int
      {
         if(this.mPoiManager != null)
         {
            return this.mPoiManager.poiGetDetails(eisString);
         }
         return -1;
      }
      
      public function get poiDetails() : LocationDetails
      {
         return this.mPoiManager.poiDetails();
      }
      
      public function poiGetPresetList(presetGroupName:String) : int
      {
         if(this.mPoiManager != null)
         {
            return this.mPoiManager.poiGetPresetList(presetGroupName);
         }
         return -1;
      }
      
      public function get poiPresets() : Array
      {
         return this.mPoiManager.poiPresets();
      }
      
      public function poiGetPhoneNumberSpell() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiGetPhoneNumberSpell();
         }
      }
      
      public function get poiPhoneNumberSpell() : SpellerInfo
      {
         return this.mPoiManager.poiPhoneNumberSpell();
      }
      
      public function poiGetPhoneNumberList() : int
      {
         if(this.mPoiManager != null)
         {
            return this.mPoiManager.poiGetPhoneNumberList();
         }
         return -1;
      }
      
      public function poiStopReRequest() : void
      {
         if(this.mPoiManager != null)
         {
            this.mPoiManager.poiStopReRequest();
         }
      }
      
      public function get poiSortOption() : int
      {
         return this.mPoiManager.poiGetSortOption();
      }
      
      public function posGetPositionInformation() : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.posGetPositionInformation();
         }
      }
      
      public function get posPositionInformation() : LocationDetails
      {
         if(this.mPositionManager)
         {
            return this.mPositionManager.posPositionInformation();
         }
         return new LocationDetails();
      }
      
      public function get posPositionInformationString() : String
      {
         return this.mPositionManager.posPositionInformationString();
      }
      
      public function posGetCompass() : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.posGetCompass();
         }
      }
      
      public function get posCompass() : String
      {
         return this.mPositionManager.posCompass();
      }
      
      public function posGetJunctionViewState() : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.posGetJunctionViewState();
         }
      }
      
      public function get posJunctionViewState() : Boolean
      {
         return this.mPositionManager.posJunctionViewState;
      }
      
      public function posGetIPDAreaState() : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.posGetIPDAreaState();
         }
      }
      
      public function get posIPDAreaState() : Boolean
      {
         return this.mPositionManager.posIPDAreaState;
      }
      
      public function posEnableHighwayModeUpdate(enable:Boolean) : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.enableHighwayModeUpdate(enable);
         }
      }
      
      public function posEnableHighwayModeUpdateTemporary(enable:Boolean) : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.enableHighwayModeUpdateTemporary(enable);
         }
      }
      
      public function get posNextHighwayExits() : HighWayModeList
      {
         return this.mPositionManager.posNextHighwayExits;
      }
      
      public function getPosHighwayModeEnabled() : void
      {
         if(this.mPositionManager != null)
         {
            this.mPositionManager.getHighwayModeEnabled();
         }
      }
      
      public function get posHighwayModeEnabled() : Boolean
      {
         return this.mPositionManager.highwayModeEnabled;
      }
      
      public function rgCreateNewTrip(trip:TripRoute) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.createNewTrip(trip);
         }
      }
      
      public function rgCreateNewTrail(trail:String, mode:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.createNewTrail(trail,mode);
         }
      }
      
      public function rgStartGuidanceForRouteHandle(routeHandle:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.startGuidanceForRouteHandle(routeHandle);
         }
      }
      
      public function rgRequestTurnListForRouteHandle(routeHandle:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.requestTurnListForRouteHandle(routeHandle);
         }
      }
      
      public function rgRequestRouteElementsInfo(routeHandle:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.requestRouteElementsInfo(routeHandle);
         }
      }
      
      public function rgRequestRouteOptionsForRouteHandle(routeHandle:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.requestRouteOptionsForRouteHandle(routeHandle);
         }
      }
      
      public function rgStopGuidance() : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.stopGuidance();
         }
      }
      
      public function rgDestroyRoutesForRouteHandles(routeHandles:String) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.destroyRoutesForRouteHandles(routeHandles);
         }
      }
      
      public function rgBlockRouteSegment(routeHandle:int, routeElement:int, routeSegment:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.blockRouteSegment(routeHandle,routeElement,routeSegment);
         }
      }
      
      public function rgBlockRouteAhead(routeHandle:int, distance:int) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.rgBlockRouteAhead(routeHandle,distance);
         }
      }
      
      public function resetRouteList() : void
      {
      }
      
      public function get tmcPreviewList() : Array
      {
         return null;
      }
      
      public function rgChangeTrip(routeHandle:int, elementList:Array) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.rgChangeTrip(routeHandle,elementList);
         }
      }
      
      public function rtGetInterchangeList(request:String) : void
      {
         if(this.mRouteCalculationManager != null)
         {
            this.mRouteCalculationManager.rtGetInterchangeList(request);
         }
      }
      
      public function get rtInterchangeCurrent() : Array
      {
         return this.mRouteCalculationManager.getInterchangeCurrent();
      }
      
      public function get rtInterchangeAlternatives() : Array
      {
         return this.mRouteCalculationManager.getInterchangeAlternatives();
      }
      
      public function get rtInterchangeDirections() : Array
      {
         return this.mRouteCalculationManager.getInterchangeDirections();
      }
      
      public function liGetList(loc:LocationDetails, listStart:int, listCount:int, sortOption:int) : void
      {
         if(this.mLocationInputManager != null)
         {
            this.mLocationInputManager.liGetList(loc,listStart,listCount,sortOption);
         }
      }
      
      public function liGetListRequestFields(loc:LocationDetails, listStart:int, listCount:int, sortOption:int, infieldOptions:String) : void
      {
         if(this.mLocationInputManager != null)
         {
            this.mLocationInputManager.liGetListRequestFields(loc,listStart,listCount,sortOption,infieldOptions);
         }
      }
      
      public function get liList() : Array
      {
         return this.mLocationInputManager.getLiList();
      }
      
      public function liGetSpell(loc:LocationDetails) : void
      {
         if(this.mLocationInputManager != null)
         {
            this.mLocationInputManager.liGetSpell(loc);
         }
      }
      
      public function get liSpell() : SpellerInfo
      {
         return this.mLocationInputManager.getLiSpell();
      }
      
      public function liGetDetails(eisString:String) : void
      {
         if(this.mLocationInputManager != null)
         {
            this.mLocationInputManager.liGetDetails(eisString);
         }
      }
      
      public function get liDetails() : LocationDetails
      {
         return this.mLocationInputManager.getLiDetails();
      }
      
      public function liGetAvailableInformation(eisString:String) : void
      {
         if(this.mLocationInputManager != null)
         {
            this.mLocationInputManager.liGetAvailableInformation(eisString);
         }
      }
      
      public function get availableInformation() : Array
      {
         return this.mLocationInputManager.availableInformation;
      }
      
      public function tmcGetEventsList(infoType:int) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.tmcGetEventsList(infoType);
         }
      }
      
      public function get tmcGetInfoType() : int
      {
         return this.mTmcManager.getTmcInfoType();
      }
      
      public function get tmcEventsList() : TmcEventList
      {
         return this.mTmcManager.getTmcEventsList();
      }
      
      public function getTmcEventDetails(tev:String) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTmcEventDetails(tev);
         }
      }
      
      public function get tmcEventDetails() : Object
      {
         return this.mTmcManager.tmdEventDetails;
      }
      
      public function getTmcLastDeletedEventIDs() : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTmcLastDeletedEventIDs();
         }
      }
      
      public function get tmcLastDeletedEventIDs() : Array
      {
         return this.mTmcManager.tmcLastDeletedEventIDs;
      }
      
      public function tmcAvoidTmcEventByEventID(tev:int) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.tmcAvoidTmcEventByEventID(tev);
         }
      }
      
      public function getTMCRouteMode() : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTMCRouteMode();
         }
      }
      
      public function get TMCRouteMode() : int
      {
         return this.mTmcManager.TMCRouteMode;
      }
      
      public function setTMCRouteMode(tmcRouteMode:int) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.setTMCRouteMode(tmcRouteMode);
         }
      }
      
      public function getTMCDelayTime() : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTMCDelayTime();
         }
      }
      
      public function get TMCDelayTime() : int
      {
         return this.mTmcManager.TMCDelayTime;
      }
      
      public function setTMCDelayTime(tmcDelayTime:int) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.setTMCDelayTime(tmcDelayTime);
         }
      }
      
      public function getTMCGroupTypes() : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTMCGroupTypes();
         }
      }
      
      public function get tmcGroupTypes() : Object
      {
         return this.mTmcManager.tmcGroupTypes;
      }
      
      public function tmcSetGroupTypesSelected(types:Object) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.tmcSetGroupTypesSelected(types);
         }
      }
      
      public function get tmcManualReRouteAlternatives() : Object
      {
         if(this.mTmcManager != null)
         {
            return this.mTmcManager.manualReRouteAlternatives;
         }
         return null;
      }
      
      public function tmcManualReRouteAccept(routeHandle:String) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.manualReRouteAccept(routeHandle);
         }
      }
      
      public function tmcManualReRouteDecline(routeHandle:String) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.manualReRouteDecline(routeHandle);
         }
      }
      
      public function getTmcStationsList() : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.getTmcStationsList();
         }
      }
      
      public function get tmcStationsList() : Array
      {
         return this.mTmcManager.tmcStationsList;
      }
      
      public function setTmcTuningMode(mode:int) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.setTmcTuningMode(mode);
         }
      }
      
      public function get tmcTuningMode() : int
      {
         return this.mTmcManager.tmcTuningMode;
      }
      
      public function setTmcTuningStation(station:String) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.setTmcTuningStation(station);
         }
      }
      
      public function getTmcTuningStation() : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mTmcManager.getTmcTuningStation();
         }
      }
      
      public function get tmcTuningStation() : String
      {
         return this.mTmcManager.tmcTuningStation;
      }
      
      public function tmcQuerDelayTimeForRouteHandles(enable:Boolean) : void
      {
         if(this.mTmcManager != null)
         {
            this.mTmcManager.tmcQuerDelayTimeForRouteHandles(enable);
         }
      }
      
      public function get tmcDelayTimesByRouteHandle() : Object
      {
         return this.mTmcManager.delayTimesByRouteHandle();
      }
      
      public function navGetSpeedWarningEnabled() : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.navGetSpeedWarningEnabled();
         }
      }
      
      public function get navSpeedWarningEnabled() : Boolean
      {
         return this.mVoiceGudanceManager.navSpeedWarningEnabled;
      }
      
      public function get navSpeedWarningSpeedLimit() : Number
      {
         return this.mVoiceGudanceManager.navSpeedWarningSpeedLimit;
      }
      
      public function setSpeedWarningsEnabled(enable:Boolean) : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.setSpeedWarningsEnabled(enable);
         }
      }
      
      public function setSpeedWarningsSpeedLimit(kmh:Number) : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.setSpeedWarningsSpeedLimit(kmh);
         }
      }
      
      public function navAdaPlayPrompt(prompt:int) : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.adaPlayPrompt(prompt);
         }
      }
      
      public function navGetSafetyCameraMode() : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.getSafetyCameraMode();
         }
      }
      
      public function get navSafetyCameraMode() : int
      {
         return this.mVoiceGudanceManager.safetyCameraMode;
      }
      
      public function navSetSafetyCameraMode(mode:int) : void
      {
         if(this.mVoiceGudanceManager)
         {
            this.mVoiceGudanceManager.navSetSafetyCameraMode(mode);
         }
      }
      
      public function navDemoModeServiceInit() : void
      {
         this.mDemoModeHelper.initDemoModePositionService();
      }
      
      public function get navDemoModeServiceIsInitialized() : Boolean
      {
         return this.mDemoModeHelper.isInitialized;
      }
      
      public function get navDemoModeServicePositionsList() : Object
      {
         return this.mDemoModeHelper.list;
      }
      
      public function navDemoModeServiceRenamePosition(coordinate:String, newName:String) : void
      {
         this.mDemoModeHelper.renamePosition(coordinate,newName);
      }
      
      public function navDemoModeServiceDeletePosition(coordinate:String) : void
      {
         this.mDemoModeHelper.deletePosition(coordinate);
      }
      
      public function get langIsLanguageChangeInProgress() : Boolean
      {
         if(this.mVoiceGudanceManager)
         {
            return this.mVoiceGudanceManager.languageChangeInProgress;
         }
         return false;
      }
      
      public function get langCurrentLanguage() : int
      {
         if(this.mVoiceGudanceManager)
         {
            return this.mVoiceGudanceManager.currentLanguage;
         }
         return -1;
      }
      
      public function reportWarning(msg:String) : void
      {
         while(this.mWarningReports.length > NavGlobalSettings.NAV_MAX_WARNING_REPORTS)
         {
            this.mWarningReports.splice(0,1);
         }
         this.mWarningReports.push(msg);
      }
      
      public function get warningReports() : Array
      {
         return this.mWarningReports;
      }
   }
}

