package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerApi;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerImpl;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.PoiInputMenu;
   import com.harman.navigation.enums.PoiInputPath;
   import com.harman.navigation.enums.PoiPresets;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.span.Client;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class PoiInputController extends EventDispatcher implements IPoiInput
   {
      
      public static var REGEX_PHONE:RegExp = /^[0-9]+$/;
      
      public static var PRESET_INDEX_GAS_STATIONS:int = 0;
      
      public static var PRESET_INDEX_RESTAURANTS:int = 1;
      
      public static var PRESET_INDEX_HOTELS:int = 2;
      
      public static var PRESET_INDEX_BANKING:int = 3;
      
      public static var PRESET_INDEX_ALL_POIS:int = 4;
      
      public static var PRESET_INDEX_STORE:int = 5;
      
      public static var PRESET_INDEX_PARKING:int = 6;
      
      private static const GET_DETAILS_REQUEST_DEFAULT:int = 0;
      
      private static const GET_DETAILS_REQUEST_HMI:int = 1;
      
      private static const DEMO_MODE_COORDINATE_NORTH_AMERICA:String = "-083.431027 +42.496383";
      
      private static const DEMO_MODE_COORDINATE_EUROPE:String = "+009.990288 +53.560802";
      
      private static const DEMO_MODE_COORDINATE_ROW:String = "+117.887436 -35.001102";
      
      private const FIRST_SEARCH_INDEX:int = 2;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mCurrentResultsID:int = -1;
      
      private var mBusy:Boolean = false;
      
      private var mListSizePerPage:int = 999;
      
      private var mPoiInputPathHistory:Array;
      
      private var mPoiInputMenu:int = -1;
      
      private var mLastNavRequestID:int = -1;
      
      private var mSearchAreaDefault:int = -1;
      
      private var mSearchAreaCurrent:int = -1;
      
      private var mSearchAreaRestriction:Boolean = false;
      
      private var mSearchCity:LocationDescription = new LocationDescription();
      
      private var mCharactersEntered:String = "";
      
      private var mRemainingListCount:int = 0;
      
      private var mRemainingCatListCount:int = 0;
      
      private var mCategoriesStack:Array = new Array();
      
      private var mCategoryListSize:int = 0;
      
      private var mTempCategoriesRequestCheck:Boolean = false;
      
      private var mDoNotRequestCategories:Boolean = false;
      
      private var mPhoneSpellerInfo:SpellerInfo = new SpellerInfo();
      
      private var mListResult:Array = new Array();
      
      private var mLocationDescription:LocationDescription = new LocationDescription();
      
      private var mPreset:String = "";
      
      private var mTriggerMainQueryWhenReady:Boolean = false;
      
      private var mGetDetailsHmiResponse:String = "";
      
      private var mGetDetailsRequestType:int = 0;
      
      public function PoiInputController()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
         TripAssemblerApi.impl = TripAssemblerImpl.create();
         this.init();
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         if(NavigationApi.api.navIsReady == true)
         {
            Framework.Trace("PoiInputController.onNavReady()");
            NavigationApi.api.addEventListener(NavigationEvent.POI_SEARCHAREA_CURRENT,this.onSearchAreaCurrent,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_SEARCHAREA_DEFAULT,this.onSearchAreaDefault,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_SEARCHAREA_RESTRICTION,this.onSearchAreaRestriction,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_SEARCHCATEGORIES,this.onCategories,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_SEARCH_CITY,this.onSearchCity,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_CHARSENTERED,this.onCharactersEntered,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_LISTCOUNT,this.onListCount,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_LIST,this.onList,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_DETAILS,this.onGetDetails,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_PRESETS,this.onPresetsList,false,0,true);
            NavigationApi.api.addEventListener(NavigationEvent.POI_PHONE_NUMBER_SPELL,this.onPhoneNumberSpeller,false,0,true);
            NavigationApi.api.poiGetSearchAreaDefault();
            NavigationApi.api.poiGetSearchAreaCurrent();
         }
      }
      
      private function onSearchAreaDefault(e:NavigationEvent) : void
      {
         this.mSearchAreaDefault = NavigationApi.api.poiSearchAreaDefault;
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_DEFAULT);
      }
      
      private function onSearchAreaCurrent(e:NavigationEvent) : void
      {
         this.mSearchAreaCurrent = NavigationApi.api.poiSearchAreaCurrent;
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_CURRENT);
      }
      
      private function onSearchAreaRestriction(e:NavigationEvent) : void
      {
         this.mSearchAreaRestriction = NavigationApi.api.poiSearchAreaRestriction;
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_RESTICTED);
      }
      
      private function onSearchCity(e:NavigationEvent) : void
      {
         this.mSearchCity = NavigationApi.api.poiSearchCity;
         this.sendEvent(PoiInputEvent.POI_SEARCH_CITY);
      }
      
      private function onCharactersEntered(e:NavigationEvent) : void
      {
         this.mCharactersEntered = NavigationApi.api.poiCharactersEntered;
         this.mBusy = false;
         this.sendEvent(PoiInputEvent.POI_SEARCHED_NAME);
      }
      
      private function onListCount(e:NavigationEvent) : void
      {
         this.mRemainingListCount = NavigationApi.api.poiListCount;
         this.mRemainingCatListCount = NavigationApi.api.poiCatListCount;
         this.sendEvent(PoiInputEvent.POI_SEARCHED_REMAINING_COUNT);
         this.sendEvent(PoiInputEvent.POI_LIST_SIZE_TOTAL);
         this.sendBusy(false);
      }
      
      private function onList(e:NavigationEvent) : void
      {
         var i:int = 0;
         var k:int = 0;
         Framework.Trace("PoiInputController.onList: length=" + NavigationApi.api.poiList.length);
         ++this.mCurrentResultsID;
         this.mListResult = new Array();
         if(this.mLastNavRequestID != e.data)
         {
            Framework.Trace("Ignoring incoming list because of stale request ID " + this.mLastNavRequestID + " " + e.data);
            return;
         }
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.BY_NAME_LIST:
               this.mListResult = NavigationApi.api.poiList;
               this.mBusy = false;
               this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
               this.sendBusy(false);
               break;
            case PoiInputPath.PHONE_NUMBER_LIST:
               this.mListResult = NavigationApi.api.poiList;
               this.mBusy = false;
               this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
               this.sendBusy(false);
               break;
            case PoiInputPath.BY_CATEGORY_LIST:
               this.mTempCategoriesRequestCheck = false;
               for(i = 0; i < NavigationApi.api.poiList.length; i++)
               {
                  this.mListResult.push(LocationDetails(NavigationApi.api.poiList[i]));
               }
               this.mCategoryListSize = this.mListResult.length;
               this.mBusy = false;
               this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
               this.sendBusy(false);
               break;
            case PoiInputPath.BY_POI_LIST:
               for(k = 0; k < NavigationApi.api.poiList.length; k++)
               {
                  this.mListResult.push(LocationDetails(NavigationApi.api.poiList[k]));
               }
               this.mBusy = false;
               this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
               this.sendBusy(false);
               break;
            case PoiInputPath.MAIN:
            default:
               Framework.Trace("PoiInputController.onList: unsupported inputPath \"" + this.getLastPathHistoryItem() + "\"");
         }
      }
      
      public function getSearchingName() : Object
      {
         var result:Object = null;
         for(var k:* = int(this.mCategoriesStack.length - 1); k >= this.FIRST_SEARCH_INDEX; k--)
         {
            if(this.mPoiInputPathHistory[k] == PoiInputPath.BY_POI_LIST)
            {
               if(k == this.FIRST_SEARCH_INDEX)
               {
                  return PoiPresets.getLocalTextFor(LocationDetails(this.mCategoriesStack[k]).getType("<PRE>"));
               }
               return LocationDetails(this.mCategoriesStack[k]).getType("<CAT>");
            }
         }
         if(this.mPoiInputPathHistory.length > 0)
         {
            switch(this.mPoiInputPathHistory[this.mPoiInputPathHistory.length - 1])
            {
               case PoiInputPath.BY_NAME_LIST:
               case PoiInputPath.PHONE_NUMBER_LIST:
                  return this.poiSearchByName;
               case PoiInputPath.EMERGENCY:
                  result = PoiPresets.getLocalTextFor(this.mPreset);
                  if(result == NavigationPackage.translations.STRB_UNDEFINED)
                  {
                     return this.mPreset;
                  }
                  return result;
            }
         }
         return NavigationPackage.translations.STRB_MENU_ALL_POIS;
      }
      
      private function onCategories(e:NavigationEvent) : void
      {
         var loc:LocationDetails = null;
         Framework.Trace("PoiInputController.onCategories: length=" + NavigationApi.api.poiSearchCategories.length);
         ++this.mCurrentResultsID;
         this.mListResult = new Array();
         for(var i:* = int(NavigationApi.api.poiSearchCategories.length - 1); i >= 0; i--)
         {
            loc = new LocationDetails();
            loc.addEisString(String(NavigationApi.api.poiSearchCategories[i]));
            this.mListResult.push(loc);
         }
         this.mTempCategoriesRequestCheck = false;
         this.mCategoryListSize = this.mListResult.length;
         this.mBusy = false;
         this.sendEvent(PoiInputEvent.POI_CATEGORIES);
         this.sendBusy(false);
      }
      
      private function onGetDetails(e:NavigationEvent) : void
      {
         Framework.Trace("PoiInputController.onGetDetails()");
         switch(this.mGetDetailsRequestType)
         {
            case GET_DETAILS_REQUEST_HMI:
               this.mGetDetailsRequestType = GET_DETAILS_REQUEST_DEFAULT;
               this.mGetDetailsHmiResponse = NavigationApi.api.poiDetails.toEIS();
               this.sendEvent(PoiInputEvent.POI_GET_DETAILS);
               break;
            case GET_DETAILS_REQUEST_DEFAULT:
            default:
               this.mLocationDescription.setSecondaryLocation(NavigationApi.api.poiDetails);
               TripAssemblerApi.api.addLocationDescription(this.mLocationDescription);
         }
         this.sendBusy(false);
      }
      
      private function onPresetsList(e:NavigationEvent) : void
      {
         Framework.Trace("PoiInputController.onPresetsList()");
         ++this.mCurrentResultsID;
         this.mListResult = NavigationApi.api.poiPresets;
         this.mBusy = false;
         this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
         this.sendBusy(false);
      }
      
      private function onPhoneNumberSpeller(e:NavigationEvent) : void
      {
         Framework.Trace("PoiInputController.onPhoneNumberSpeller()");
         this.mPhoneSpellerInfo = NavigationApi.api.poiPhoneNumberSpell;
         this.sendEvent(PoiInputEvent.POI_PHONE_SPELLER);
         this.sendBusy(false);
      }
      
      public function poiSetInputPath(path:int) : void
      {
         var isPhoneNumber:Boolean = false;
         Framework.Trace("PoiInputController.poiSetInputPath:" + path);
         this.sendBusy(true);
         if(path == PoiInputPath.MAIN || path == PoiInputPath.UNDEFINED || path == PoiInputPath.PHONE_NUMBER_SPELLER || path == PoiInputPath.EMERGENCY)
         {
            this.resetController();
         }
         if(path == PoiInputPath.BY_NAME_SPELLER || path == PoiInputPath.PHONE_NUMBER_SPELLER)
         {
            isPhoneNumber = REGEX_PHONE.test(NavigationApi.api.poiCharactersEntered);
            if(isPhoneNumber && path == PoiInputPath.BY_NAME_SPELLER || !isPhoneNumber && path == PoiInputPath.PHONE_NUMBER_SPELLER)
            {
               NavigationApi.api.poiClearInput();
            }
            NavigationApi.api.poiSetSearchCategory("ByName");
         }
         if(path != PoiInputPath.UNDEFINED)
         {
            this.mPoiInputPathHistory.push(path);
            this.poiSetListStartIndex(0);
         }
         this.processNewPathState();
      }
      
      private function initResultsListForMain() : void
      {
         this.mListResult = new Array();
         this.mListResult.push(LocationDetails.fromPreset(PoiPresets.POI_PRESET_GAS_STATIONS));
         this.mListResult.push(LocationDetails.fromPreset(PoiPresets.POI_PRESET_RESTAURANTS));
         this.mListResult.push(LocationDetails.fromPreset(PoiPresets.POI_PRESET_HOTELS));
         this.mListResult.push(LocationDetails.fromPreset(PoiPresets.POI_PRESET_BANKS));
         this.mListResult.push(new LocationDetails());
      }
      
      private function processNewPathState() : void
      {
         this.mPoiInputMenu = PoiInputMenu.MAIN;
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.UNDEFINED:
               this.mPoiInputMenu = PoiInputMenu.UNDEFINED;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case PoiInputPath.MAIN:
               ++this.mCurrentResultsID;
               this.initResultsListForMain();
               this.sendBusy(false);
               this.mPoiInputMenu = PoiInputMenu.MAIN;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case PoiInputPath.SEARCH_AREA:
               this.mPoiInputMenu = PoiInputMenu.SEARCH_AREA;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case PoiInputPath.SEARCH_AREA_DEST_LIST:
               this.mPoiInputMenu = PoiInputMenu.DESTINATION_LIST;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case PoiInputPath.BY_NAME_SPELLER:
               this.mPoiInputMenu = PoiInputMenu.SPELLER;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case PoiInputPath.BY_NAME_LIST:
               this.mPoiInputMenu = PoiInputMenu.POI_LIST;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               break;
            case PoiInputPath.BY_POI_LIST:
            case PoiInputPath.BY_CATEGORY_LIST:
               this.mPoiInputMenu = PoiInputMenu.POI_LIST;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               break;
            case PoiInputPath.EMERGENCY:
               this.mPoiInputMenu = PoiInputMenu.EMERGENCY_LIST;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               break;
            case PoiInputPath.PHONE_NUMBER_SPELLER:
               this.mPoiInputMenu = PoiInputMenu.PHONE_SPELLER;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               break;
            case PoiInputPath.PHONE_NUMBER_LIST:
               this.mPoiInputMenu = PoiInputMenu.PHONE_LIST;
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               break;
            default:
               Framework.Trace("PoiInputController.processNewPathState: Path " + this.getLastPathHistoryItem() + "not supported yet");
         }
      }
      
      public function poiGetIsBusy() : void
      {
         this.sendEvent(PoiInputEvent.POI_BUSY);
      }
      
      public function get poiIsBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function poiGetIputPath() : void
      {
         this.sendEvent(PoiInputEvent.POI_INPUT_PATH);
      }
      
      public function get poiInputPath() : int
      {
         return this.getLastPathHistoryItem();
      }
      
      public function poiGetActiveMenu() : void
      {
         this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
      }
      
      public function get poiActiveMenu() : int
      {
         return this.mPoiInputMenu;
      }
      
      public function poiOnBack() : void
      {
         Framework.Trace("PoiInputController.poiOnBack()");
         this.sendBusy(true);
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.MAIN:
               this.removeLastHistoryItem();
            case PoiInputPath.SEARCH_AREA:
               this.removeLastHistoryItem();
               break;
            case PoiInputPath.SEARCH_AREA_DEST_LIST:
               this.removeLastHistoryItem();
               this.removeLastHistoryItem();
               break;
            case PoiInputPath.BY_NAME_SPELLER:
            case PoiInputPath.BY_NAME_LIST:
               this.removeLastHistoryItem();
               break;
            case PoiInputPath.BY_POI_LIST:
            case PoiInputPath.BY_CATEGORY_LIST:
               this.removeLastHistoryItem();
               this.poiGetListSegment();
               break;
            case PoiInputPath.EMERGENCY:
               this.removeLastHistoryItem();
               break;
            case PoiInputPath.PHONE_NUMBER_SPELLER:
            case PoiInputPath.PHONE_NUMBER_LIST:
               this.removeLastHistoryItem();
               break;
            case PoiInputPath.UNDEFINED:
            default:
               Framework.Trace("PoiInputController.poiOnBack: Path " + this.getLastPathHistoryItem() + "not supported yet");
         }
         this.processNewPathState();
      }
      
      public function poiOnCancel() : void
      {
         NavigationApi.api.poiStopReRequest();
         this.poiOnBack();
      }
      
      public function poiGetTypesForLastResult() : void
      {
         this.mCategoriesStack[this.mCategoriesStack.length] = this.mCategoriesStack[this.mCategoriesStack.length - 1];
         this.mPoiInputPathHistory.push(PoiInputPath.BY_CATEGORY_LIST);
         this.mPoiInputMenu = PoiInputMenu.POI_LIST;
         this.sendEvent(PoiInputEvent.POI_INPUT_PATH);
         this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
         this.poiSetListStartIndex(0);
      }
      
      public function poiSelectListEntry(index:int) : void
      {
         Framework.Trace("PoiInputController.poiSelectListEntry(" + index + ")");
         if(this.poiIsBusy)
         {
            Framework.Trace(" -called while busy!");
         }
         this.sendBusy(true);
         if(this.mPoiInputPathHistory.length > 2 && this.mListResult.length <= index)
         {
            Framework.Trace("PoiInputController.poiSelectListEntry(" + index + "): ListSize is too small:" + this.mListResult.length + " Path:" + this.getLastPathHistoryItem());
            return;
         }
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.BY_NAME_LIST:
            case PoiInputPath.PHONE_NUMBER_LIST:
               this.mLocationDescription = new LocationDescription();
               this.mLocationDescription.setPrimaryLocation(this.mListResult[index]);
               this.mLastNavRequestID = NavigationApi.api.poiGetDetails(this.mLocationDescription.getPrimaryLocation().toEIS());
               break;
            case PoiInputPath.EMERGENCY:
               this.mLocationDescription = new LocationDescription();
               this.mLocationDescription.setPrimaryLocation(this.mListResult[index]);
               this.mLastNavRequestID = NavigationApi.api.poiGetDetails(this.mLocationDescription.getPrimaryLocation().toEIS());
               break;
            case PoiInputPath.MAIN:
               this.initResultsListForMain();
               this.mCategoriesStack[this.mPoiInputPathHistory.length] = this.mListResult[index];
               if(index == PRESET_INDEX_ALL_POIS)
               {
                  this.mPoiInputPathHistory.push(PoiInputPath.BY_CATEGORY_LIST);
               }
               else
               {
                  this.mPoiInputPathHistory.push(PoiInputPath.BY_POI_LIST);
               }
               this.mPoiInputMenu = PoiInputMenu.POI_LIST;
               this.sendEvent(PoiInputEvent.POI_INPUT_PATH);
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               if(index == 0)
               {
                  Framework.Trace("Avoid re-requesting Categories ");
                  this.mDoNotRequestCategories = true;
               }
               this.poiSetListStartIndex(0);
               break;
            case PoiInputPath.BY_POI_LIST:
               this.mLocationDescription = new LocationDescription();
               this.mLocationDescription.setPrimaryLocation(this.mListResult[index]);
               this.mLastNavRequestID = NavigationApi.api.poiGetDetails(this.mLocationDescription.getPrimaryLocation().toEIS());
               break;
            case PoiInputPath.BY_CATEGORY_LIST:
               this.mCategoriesStack[this.mPoiInputPathHistory.length] = this.mListResult[index];
               this.mPoiInputPathHistory.push(PoiInputPath.BY_POI_LIST);
               this.mPoiInputMenu = PoiInputMenu.POI_LIST;
               this.sendEvent(PoiInputEvent.POI_INPUT_PATH);
               this.sendEvent(PoiInputEvent.POI_ACTIVE_MENU);
               this.poiSetListStartIndex(0);
               break;
            default:
               Framework.Trace("PoiInputController.poiSelectListEntry(" + index + "): not supported InputPath: " + this.getLastPathHistoryItem());
         }
      }
      
      public function poiSetListLength(length:int) : void
      {
         this.mListSizePerPage = length;
      }
      
      public function poiSetListStartIndex(startIndex:int) : void
      {
         Framework.Trace("PoiInputController.poiSetListStartIndex" + startIndex);
         this.poiGetListSegment();
         this.sendEvent(PoiInputEvent.POI_LIST_START_INDEX);
      }
      
      public function poiGetStartIndex() : void
      {
         this.sendEvent(PoiInputEvent.POI_LIST_START_INDEX);
      }
      
      public function get poiListStartIndex() : int
      {
         return 0;
      }
      
      public function poiGetListSegment() : void
      {
         this.sendBusy(true);
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.MAIN:
            case PoiInputPath.SEARCH_AREA:
               break;
            case PoiInputPath.BY_POI_LIST:
               if(this.mCategoriesStack.length == this.FIRST_SEARCH_INDEX + 1)
               {
                  this.mLastNavRequestID = NavigationApi.api.poiGetPresetList(LocationDetails(this.mCategoriesStack[this.FIRST_SEARCH_INDEX]).getType("<PRE>"));
               }
               else
               {
                  NavigationApi.api.poiSetSearchCategory(this.getCategoryStackAsEIS());
                  NavigationApi.api.poiClearInput();
                  this.mLastNavRequestID = NavigationApi.api.poiGetList(1,999,true);
               }
               break;
            case PoiInputPath.BY_CATEGORY_LIST:
               this.mLastNavRequestID = NavigationApi.api.poiGetSearchCategories(LocationDetails(this.mCategoriesStack[this.mCategoriesStack.length - 1]).toEIS());
               break;
            case PoiInputPath.BY_NAME_LIST:
               this.mLastNavRequestID = NavigationApi.api.poiGetList(1,this.mListSizePerPage);
               break;
            case PoiInputPath.EMERGENCY:
               this.mLastNavRequestID = NavigationApi.api.poiGetPresetList(this.mPreset);
               break;
            case PoiInputPath.PHONE_NUMBER_LIST:
               this.mLastNavRequestID = NavigationApi.api.poiGetPhoneNumberList();
               break;
            case PoiInputPath.BY_NAME_SPELLER:
            case PoiInputPath.PHONE_NUMBER_SPELLER:
            case PoiInputPath.UNDEFINED:
            default:
               Framework.Trace("PoiInputController.poiGetListSegment: unsupported inputPath: " + this.getLastPathHistoryItem());
               this.mListResult = new Array();
               ++this.mCurrentResultsID;
               this.sendEvent(PoiInputEvent.POI_LIST_UPDATE);
         }
      }
      
      private function getCategoryStackAsEIS() : String
      {
         var eis:String = "";
         for(var k:* = int(this.mCategoriesStack.length - 1); k >= this.FIRST_SEARCH_INDEX; k--)
         {
            if(this.mPoiInputPathHistory[k] == PoiInputPath.BY_POI_LIST)
            {
               eis = LocationDetails(this.mCategoriesStack[k]).toEIS() + eis;
            }
         }
         return eis;
      }
      
      public function get poiResultsID() : int
      {
         return this.mCurrentResultsID;
      }
      
      public function get poiList() : PoiList
      {
         var ld:LocationDetails = null;
         var lst:PoiList = new PoiList(this.poiSearchAreaCurrent,this.getSearchingName());
         lst.id = this.mCurrentResultsID;
         for(var k:int = 0; k < this.mListResult.length; k++)
         {
            ld = LocationDetails(this.mListResult[k]);
            if(ld.isPOI())
            {
               lst.addPoi(Poi.fromPrimaryDetails(ld));
            }
         }
         return lst;
      }
      
      public function get poiCategoriesAvailable() : Boolean
      {
         return this.getCategoryStackAsEIS().length > 0;
      }
      
      public function get poiCategories() : PoiCategories
      {
         var ld:LocationDetails = null;
         var lst:PoiCategories = new PoiCategories(this.poiSearchAreaCurrent,this.getSearchingName());
         lst.id = this.mCurrentResultsID;
         for(var k:int = 0; k < this.mListResult.length; k++)
         {
            ld = LocationDetails(this.mListResult[k]);
            if(!ld.isPOI())
            {
               lst.addCategory(ld);
            }
         }
         return lst;
      }
      
      public function get poiListUpdate() : Array
      {
         return this.mListResult;
      }
      
      public function poiGetListSizeTotal() : void
      {
         this.sendEvent(PoiInputEvent.POI_LIST_SIZE_TOTAL);
      }
      
      public function get poiListSizeTotal() : int
      {
         switch(this.getLastPathHistoryItem())
         {
            case PoiInputPath.BY_NAME_LIST:
            case PoiInputPath.BY_NAME_SPELLER:
               return this.mRemainingListCount;
            case PoiInputPath.BY_CATEGORY_LIST:
               return this.mCategoryListSize;
            case PoiInputPath.UNDEFINED:
         }
         Framework.Trace("PoiInputController.poiListSizeTotal: unsupported inputPath: " + this.getLastPathHistoryItem());
         return 0;
      }
      
      public function poiAddSearchNameCharacters(char:String) : void
      {
         this.sendBusy(true);
         NavigationApi.api.poiSelectCharacter(char);
      }
      
      public function poiGetSearchByName() : void
      {
         this.sendEvent(PoiInputEvent.POI_SEARCHED_NAME);
      }
      
      public function get poiSearchByName() : String
      {
         return this.mCharactersEntered;
      }
      
      public function poiGetListCounts() : void
      {
         NavigationApi.api.poiGetListCounts(this.getCategoryStackAsEIS());
      }
      
      public function poiGetRemainingCount() : void
      {
         NavigationApi.api.poiGetListCount();
      }
      
      public function get poiCountPOI() : int
      {
         return this.mRemainingListCount;
      }
      
      public function get poiCountCAT() : int
      {
         return this.mRemainingCatListCount;
      }
      
      public function poiRemoveLastCharacters(amount:int) : void
      {
         this.sendBusy(true);
         for(var i:int = 0; i < amount; i++)
         {
            NavigationApi.api.poiRemoveLastCharacter();
         }
         if(this.getLastPathHistoryItem() == PoiInputPath.PHONE_NUMBER_SPELLER)
         {
            this.poiByPhoneGetDigits();
         }
      }
      
      public function poiRemoveAllCharacters() : void
      {
         this.sendBusy(true);
         NavigationApi.api.poiClearInput();
      }
      
      public function poiGetSearchAreaDefault() : void
      {
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_DEFAULT);
      }
      
      public function get poiSearchAreaDefault() : int
      {
         return this.mSearchAreaDefault;
      }
      
      public function poiSelectDefaultSearchArea(searchArea:int) : void
      {
         NavigationApi.api.poiSetSearchAreaDefault(searchArea);
      }
      
      public function poiGetSearchAreaCurrent() : void
      {
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_CURRENT);
      }
      
      public function get poiSearchAreaCurrent() : int
      {
         return this.mSearchAreaCurrent;
      }
      
      public function poiGetSearchAreaRestricted() : void
      {
         this.sendEvent(PoiInputEvent.POI_SEARCH_AREA_RESTICTED);
      }
      
      public function get poiSearchAreaRestricted() : Boolean
      {
         return this.mSearchAreaRestriction;
      }
      
      public function poiSetSearchInCity(loc:LocationDescription) : void
      {
         NavigationApi.api.poiSetSearchCity(loc);
         if(this.getLastPathHistoryItem() == PoiInputPath.SEARCH_AREA)
         {
            this.removeLastHistoryItem();
            this.processNewPathState();
         }
      }
      
      public function poiGetSearchCity() : void
      {
         this.sendEvent(PoiInputEvent.POI_SEARCH_CITY);
      }
      
      public function get poiSearchCity() : LocationDescription
      {
         return this.mSearchCity;
      }
      
      public function poiSetPreset(presetGroupName:String) : void
      {
         this.mPreset = presetGroupName;
         this.sendEvent(PoiInputEvent.POI_PRESET);
      }
      
      public function get poiPreset() : String
      {
         return this.mPreset;
      }
      
      public function poiByPhoneSetDigits(digits:String) : void
      {
         if(this.getLastPathHistoryItem() == PoiInputPath.PHONE_NUMBER_SPELLER)
         {
            this.sendBusy(true);
            NavigationApi.api.poiClearInput();
            NavigationApi.api.poiSelectCharacter(digits);
            NavigationApi.api.poiGetPhoneNumberSpell();
         }
         else
         {
            Framework.Trace("PoiInputController.poiByPhoneSetDigits( " + digits + ") not in correct PoiInputPath( " + this.getLastPathHistoryItem() + " )");
            this.sendEvent(PoiInputEvent.POI_PHONE_SPELLER);
         }
      }
      
      public function poiByPhoneGetDigits() : void
      {
         this.poiByPhoneSetDigits(NavigationApi.api.poiCharactersEntered);
      }
      
      public function get poiByPhoneDigits() : SpellerInfo
      {
         return this.mPhoneSpellerInfo;
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new PoiInputEvent(eventType));
      }
      
      private function sendBusy(busy:Boolean) : void
      {
         this.mBusy = busy;
         this.sendEvent(PoiInputEvent.POI_BUSY);
      }
      
      private function getLastPathHistoryItem() : int
      {
         return this.mPoiInputPathHistory[this.mPoiInputPathHistory.length - 1];
      }
      
      private function getPathHistoryItem(index:int) : int
      {
         if(this.mPoiInputPathHistory.length > index)
         {
            return this.mPoiInputPathHistory[index];
         }
         return -1;
      }
      
      private function removeLastHistoryItem() : void
      {
         this.mPoiInputPathHistory.splice(this.mPoiInputPathHistory.length - 1);
         this.mCategoriesStack.splice(this.mPoiInputPathHistory.length,1);
      }
      
      private function toStringPathHistory() : String
      {
         var pathStr:String = "";
         for(var i:int = 0; i < this.mPoiInputPathHistory.length; i++)
         {
            pathStr += String(this.mPoiInputPathHistory[i]) + " ";
         }
         return pathStr;
      }
      
      private function resetController() : void
      {
         this.mPoiInputPathHistory = new Array();
         this.mCategoriesStack = new Array();
         this.mPoiInputPathHistory.push(PoiInputPath.UNDEFINED);
         this.mListResult = new Array();
      }
      
      private function getCurrentPosition() : String
      {
         if(NavigationApi.api.posPositionInformation.getType("<GEO>") != "")
         {
            return NavigationApi.api.posPositionInformation.getType("<GEO>");
         }
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
               return DEMO_MODE_COORDINATE_EUROPE;
            case VServiceGlobalSettings.MARKET_ROW:
               return DEMO_MODE_COORDINATE_ROW;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               return DEMO_MODE_COORDINATE_NORTH_AMERICA;
            default:
               Framework.Trace("MarketConfig not supported: Fallback to MARKET_NORTH_AMERICA");
               return DEMO_MODE_COORDINATE_NORTH_AMERICA;
         }
      }
      
      private function init() : void
      {
         this.mPoiInputPathHistory = new Array();
         NavigationApi.api.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
      }
      
      private function unload() : void
      {
         NavigationApi.api.removeEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady);
         NavigationApi.api.removeEventListener(NavigationEvent.POI_SEARCHAREA_CURRENT,this.onSearchAreaCurrent);
         NavigationApi.api.removeEventListener(NavigationEvent.POI_SEARCHAREA_DEFAULT,this.onSearchAreaDefault);
         NavigationApi.api.removeEventListener(NavigationEvent.POI_SEARCHAREA_RESTRICTION,this.onSearchAreaRestriction);
         NavigationApi.api.removeEventListener(NavigationEvent.POI_PRESETS,this.onPresetsList);
         NavigationApi.api.removeEventListener(NavigationEvent.POI_PHONE_NUMBER_SPELL,this.onPhoneNumberSpeller);
      }
      
      public function poiGetDetails(eis:String) : void
      {
         this.mGetDetailsRequestType = GET_DETAILS_REQUEST_HMI;
         this.mLastNavRequestID = NavigationApi.api.poiGetDetails(eis);
      }
      
      public function get poiDetails() : String
      {
         return this.mGetDetailsHmiResponse;
      }
      
      public function poiGetListSegmentName() : void
      {
      }
      
      public function get poiSortOption() : int
      {
         return NavigationApi.api.poiSortOption;
      }
   }
}

