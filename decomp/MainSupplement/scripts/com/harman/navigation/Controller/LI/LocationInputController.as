package com.harman.navigation.Controller.LI
{
   import com.harman.navigation.Controller.LI.utils.DefaultDetection;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerApi;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerImpl;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.LocationInputMenu;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.enums.SortOption;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.OpenNavUtilities;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.span.Client;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class LocationInputController extends EventDispatcher implements ILocationInput
   {
      
      public static const NOT_FULL_ZIP_CODE:int = 0;
      
      public static const FULL_ZIP_CODE:int = 1;
      
      public static const BRITAIN_FULL_ZIP_CODE:int = 2;
      
      public static const NO_ZIP_CODE:int = -1;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mDefaultDetection:DefaultDetection;
      
      private var mBusy:Boolean = false;
      
      private var mLocationInputPathHistory:Array = new Array();
      
      private var mLocationInputMenu:int = 0;
      
      private var mLocationInputMenuPrevious:int = 0;
      
      private var mListSizePerPage:int = 999;
      
      private var mListCurrentPage:int = 0;
      
      private var mListCurrentPage_country:int = 0;
      
      private var mListCurrentPage_state:int = 0;
      
      private var mListCurrentPage_city:int = 0;
      
      private var mListCurrentPage_street:int = 0;
      
      private var mListCurrentPage_street_second:int = 0;
      
      private var mListCurrentPage_ZipCode:int = 0;
      
      private var mListTotalPages:int = 0;
      
      private var mListTotalPages_country:int = 0;
      
      private var mListTotalPages_state:int = 0;
      
      private var mListTotalPages_city:int = 0;
      
      private var mListTotalPages_street:int = 0;
      
      private var mListTotalPages_street_second:int = 0;
      
      private var mListTotalPages_ZipCode:int = 0;
      
      private var mLastRemovedLI:int = 0;
      
      private var mList:Array = new Array();
      
      private var mSpell:SpellerInfo = new SpellerInfo();
      
      private var mSpelledCharacters:String = "";
      
      private var mDefaultCountry:String = "";
      
      private var mDefaultCountryTemporary:String = "";
      
      private var mDefaultState:String = "";
      
      private var mCountrySpelled:String = "";
      
      private var mStateSpelled:String = "";
      
      private var triggerCountryChange:Boolean = false;
      
      private var mDefaultCity:String = "";
      
      private var mCitySpelled:String = "";
      
      private var mCityListed:String = "";
      
      private var mStreetSpelled:String = "";
      
      private var mStreetListed:String = "";
      
      private var mStreetSecondSpelled:String = "";
      
      private var mStreetSecondListed:String = "";
      
      private var mHouseNumberSpelled:String = "";
      
      private var mHouseNumberRefined:String = "";
      
      private var mZipCodeSpelled:String = "";
      
      private var mZipCodeListed:String = "";
      
      private var mZipCodeAvailable:Boolean = false;
      
      private var mStreetFirstAvailable:Boolean = false;
      
      private var mZipCodeHouseNumberSearchString:String = "";
      
      private var mZipCodeAvailableSearchString:String = "";
      
      private var mLocationDescription:LocationDescription = new LocationDescription();
      
      private var mFetchedGeoCoordinateDetails:LocationDescription = new LocationDescription();
      
      public function LocationInputController()
      {
         super();
         this.mLocationInputPathHistory.push(LocationInputPath.UNDEFINED);
         NavigationApi.impl = NavigationImpl.create();
         TripAssemblerApi.impl = TripAssemblerImpl.create();
         PersistenceApi.impl = PersistenceImpl.create();
         this.mDefaultDetection = new DefaultDetection(this);
      }
      
      private function addLiListeners() : void
      {
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETLIST,this.onGetList,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETSPELL,this.onGetSpell,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETSPELL_FAILED,this.onGetSpellFailed,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETDETAILS,this.onGetDetails,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETDETAILS_FAILED,this.onGetDetailsFailed,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChange,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETAVAILABLEINFO,this.onGetAvailableInformation,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.LOCATION_INPUT)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.LOCATION_INPUT,true);
            if(res != null)
            {
               for(i in res)
               {
                  if(i == "Country")
                  {
                     this.mDefaultCountry = res[i];
                  }
                  if(i == "State")
                  {
                     this.mDefaultState = res[i];
                  }
                  if(i == "City")
                  {
                     this.mDefaultCity = res[i];
                  }
               }
               Framework.Trace("Nav_LI.onPersistence: Default values: " + this.mDefaultCity + " " + this.mDefaultState + " " + this.mDefaultCountry);
               if(EisHelper.getValueOfType(this.mDefaultCountry,OpenNavUtilities.c_EIS_CTR_NNG).length <= 4)
               {
                  this.mDefaultDetection = new DefaultDetection(this);
               }
               else
               {
                  this.addLiListeners();
                  this.requestZipCodeStreetFirstAvailable();
               }
            }
            else
            {
               Framework.Trace("Nav_LI.onPersistence: null\'");
               this.mDefaultDetection = new DefaultDetection(this);
            }
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      private function persistData() : void
      {
      }
      
      public function setDefaultDetectionComplete() : void
      {
         Framework.Trace("Nav_LI: setDefaultDetectionComplete: " + this.mDefaultCity + " " + this.mDefaultState + " " + this.mDefaultCountry);
         this.addLiListeners();
         this.persistData();
         this.mDefaultDetection = null;
         this.requestZipCodeStreetFirstAvailable();
      }
      
      private function onGetDetails(e:NavigationEvent) : void
      {
         if(this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
         {
            this.mFetchedGeoCoordinateDetails.setSecondaryLocation(NavigationApi.api.liDetails);
         }
         else
         {
            this.mLocationDescription.setSecondaryLocation(NavigationApi.api.liDetails);
            TripAssemblerApi.api.addLocationDescription(this.mLocationDescription);
         }
         if(this.getLastPathHistoryItem() == LocationInputPath.ENTER_GEO_COORDINATE || this.getLastPathHistoryItem() == LocationInputPath.ENTER_VR_DESTINATION || this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
         {
            if(this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
            {
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
            }
            this.sendEvent(LocationInputEvent.LI_VALID_GEO_COODRINATE);
         }
         this.sendBusy(false);
      }
      
      private function onGetDetailsFailed(e:NavigationEvent) : void
      {
         if(this.getLastPathHistoryItem() == LocationInputPath.ENTER_GEO_COORDINATE || this.getLastPathHistoryItem() == LocationInputPath.ENTER_VR_DESTINATION || this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
         {
            if(this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
            {
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
            }
            this.sendEvent(LocationInputEvent.LI_INVALID_GEO_COODRINATE);
         }
      }
      
      private function onLanguageChange(e:NavigationEvent) : void
      {
         var loc:LocationDetails = null;
         if(!NavigationApi.api.langIsLanguageChangeInProgress)
         {
            Framework.Trace("LocationInputController.onLanguageChange()");
            if(this.mDefaultCountry != "")
            {
               this.sendBusy(true);
               this.mLocationInputPathHistory.push(LocationInputPath.LIST_LANGUAGE_CHANGE_CTR);
               loc = new LocationDetails();
               loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
               loc.addType(OpenNavUtilities.c_EIS_CTR,"");
               NavigationApi.api.liGetList(loc,1,this.mListSizePerPage,SortOption.DEFAULT);
               this.sendEvent(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS);
            }
         }
      }
      
      private function onGetAvailableInformation(e:NavigationEvent) : void
      {
         var tagFound:Boolean = false;
         Framework.Trace("onGetAvailableInformation");
         var availTypes:Array = e.data.availableTypes;
         var i:int = 0;
         switch(String(e.data.respEIS))
         {
            case this.mZipCodeAvailableSearchString:
               this.mZipCodeAvailableSearchString = "";
               this.mStreetFirstAvailable = false;
               this.mZipCodeAvailable = false;
               for(i = 0; i < availTypes.length; i++)
               {
                  if(String(availTypes[i]).indexOf(OpenNavUtilities.c_EIS_ZIP) >= 0)
                  {
                     this.mZipCodeAvailable = true;
                  }
                  if(String(availTypes[i]).indexOf(OpenNavUtilities.c_EIS_STR) >= 0)
                  {
                     this.mStreetFirstAvailable = true;
                  }
               }
               this.sendEvent(LocationInputEvent.LI_ZIP_CODE_AVAIL);
               break;
            case this.mZipCodeHouseNumberSearchString:
               this.mZipCodeHouseNumberSearchString = "";
               tagFound = false;
               for(i = 0; i < availTypes.length; i++)
               {
                  if(String(availTypes[i]).indexOf(OpenNavUtilities.c_EIS_STR) >= 0)
                  {
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_STREET);
                     this.processNewPathState();
                     return;
                  }
                  if(String(availTypes[i]).indexOf(OpenNavUtilities.c_EIS_HNO) >= 0)
                  {
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_HOUSENUMBER);
                     this.processNewPathState();
                     return;
                  }
               }
               if(!tagFound)
               {
                  this.assembleDescription();
               }
               break;
            default:
               Framework.Trace("LocationInputCtrl.onGetAvailableInformation() Received response for unknown request \'" + String(e.data.respEIS) + "\'");
         }
      }
      
      public function get zipCodeAvailable() : Boolean
      {
         return this.mZipCodeAvailable;
      }
      
      public function get streetFirstAvailable() : Boolean
      {
         return this.mStreetFirstAvailable;
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         if(NavigationApi.api.navIsReady)
         {
            this.requestZipCodeStreetFirstAvailable();
         }
      }
      
      private function onGetList(e:NavigationEvent) : void
      {
         var currentCtrId:String = null;
         var j:int = 0;
         var currentStaId:String = null;
         var k:int = 0;
         Framework.Trace("LocationInputController.onGetList(" + this.getLastPathHistoryItem() + ")");
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_HOUSENUMBER:
            case LocationInputPath.LIST_CITY:
            case LocationInputPath.LIST_CLOSEST_CITIES:
            case LocationInputPath.LIST_COUNTRY:
            case LocationInputPath.LIST_STATE:
            case LocationInputPath.LIST_STREET:
            case LocationInputPath.LIST_ZIPCODE:
            case LocationInputPath.LIST_STREET_SECOND:
               this.mList = NavigationApi.api.liList;
               this.mLocationInputMenu = LocationInputMenu.LIST;
               this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case LocationInputPath.REFINE_HOUSENUMBER:
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1,LocationInputPath.SPELL_HOUSENUMBER);
               if(NavigationApi.api.liList.length >= 1)
               {
                  this.mHouseNumberRefined = NavigationApi.api.liList[0];
               }
               else
               {
                  this.mHouseNumberRefined = "";
               }
               Framework.Trace("REFINE_HOUSENUMBER: ListSize: \"" + NavigationApi.api.liList.length + "\" " + this.mHouseNumberRefined);
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
               this.assembleDescription();
               break;
            case LocationInputPath.LIST_LANGUAGE_CHANGE_CTR:
               currentCtrId = EisHelper.getValueOfType(this.mDefaultCountry,OpenNavUtilities.c_EIS_CTR_NNG);
               for(j = 0; j < NavigationApi.api.liList.length; j++)
               {
                  if(String(NavigationApi.api.liList[j]).indexOf(currentCtrId) != -1)
                  {
                     this.mDefaultCountry = String(NavigationApi.api.liList[j]);
                     this.persistData();
                     Framework.Trace("LIST_LANGUAGE_CHANGE_CTR: Changed to : \"" + this.mDefaultCountry + "\"");
                     break;
                  }
               }
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
               this.checkStateNameOnLanguageChange();
               break;
            case LocationInputPath.LIST_LANGUAGE_CHANGE_STA:
               currentStaId = EisHelper.getValueOfType(this.mDefaultState,OpenNavUtilities.c_EIS_STA_NNG);
               for(k = 0; k < NavigationApi.api.liList.length; k++)
               {
                  if(String(NavigationApi.api.liList[k]).indexOf(currentStaId) != -1)
                  {
                     this.mDefaultState = String(NavigationApi.api.liList[k]);
                     this.mDefaultCity = "";
                     this.persistData();
                     Framework.Trace("LIST_LANGUAGE_CHANGE_STA: Changed to : \"" + this.mDefaultState + "\"");
                     this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
                     this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
                     this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE);
                     break;
                  }
               }
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
               this.sendBusy(false);
               this.sendEvent(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS);
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               this.mList = NavigationApi.api.liList;
               this.mZipCodeListed = String(this.mList[0]);
               break;
            default:
               Framework.Trace("LocationInputController.onGetList: Path(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
      }
      
      private function checkStateNameOnLanguageChange() : void
      {
         var loc:LocationDetails = null;
         if(this.mDefaultState != "")
         {
            this.mLocationInputPathHistory.push(LocationInputPath.LIST_LANGUAGE_CHANGE_STA);
            loc = new LocationDetails();
            loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
            loc.addEisString(this.mDefaultCountry);
            loc.addType(OpenNavUtilities.c_EIS_STA,"");
            NavigationApi.api.liGetList(loc,1,this.mListSizePerPage,SortOption.DEFAULT);
         }
         else
         {
            this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
            this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
            this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE);
            this.sendBusy(false);
            this.sendEvent(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS);
         }
      }
      
      private function onGetSpellFailed(e:NavigationEvent) : void
      {
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_STREET:
               if(this.mStreetSpelled != "")
               {
                  this.liRemoveLastCharacter();
               }
               else
               {
                  this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                  this.assembleDescription();
               }
               break;
            case LocationInputPath.ENTER_CITYCENTER:
            case LocationInputPath.SPELL_CITY:
            case LocationInputPath.SPELL_ZIPCODE:
               this.liRemoveLastCharacter();
               break;
            case LocationInputPath.SPELL_HOUSENUMBER:
               this.mHouseNumberSpelled = "";
            default:
               Framework.Trace("LocationInputController.onGetSpellFailed: Path(" + this.getLastPathHistoryItem() + ") skip to getDetails.");
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
               this.assembleDescription();
         }
      }
      
      private function onGetSpell(e:NavigationEvent) : void
      {
         Framework.Trace("LocationInputController.onGetSpell");
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_COUNTRY:
               this.mListTotalPages_country = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.SPELL_STATE:
               this.mListTotalPages_state = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.SPELL_CITY:
               this.mListTotalPages_city = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.SPELL_STREET:
               this.mListTotalPages_street = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mListTotalPages_street_second = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               this.mListTotalPages_ZipCode = this.getNumberOfPages();
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
         }
         if(NavigationApi.api.liSpell.count <= NavGlobalSettings.LIST_ITEMS_PER_PAGE && this.mSpelledCharacters.length > 0)
         {
            switch(this.getLastPathHistoryItem())
            {
               case LocationInputPath.SPELL_COUNTRY:
               case LocationInputPath.SPELL_STATE:
               case LocationInputPath.SPELL_CITY:
               case LocationInputPath.SPELL_STREET:
                  if(this.mLocationInputMenu != LocationInputMenu.SPELLER)
                  {
                     this.mStreetSpelled = this.mStreetSpelled.slice(0,this.mStreetSpelled.length - 1);
                  }
                  break;
               case LocationInputPath.SPELL_STREET_SECOND:
            }
            if(this.mLocationInputMenu != LocationInputMenu.SPELLER)
            {
               this.mSpelledCharacters = this.mSpelledCharacters.slice(0,this.mSpelledCharacters.length - 1);
               this.processNewPathState();
               return;
            }
            this.sendEvent(LocationInputEvent.LI_OPEN_LOADING_POPUP);
            this.liSwitchToList();
            return;
         }
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_STATE:
               this.mSpell = SpellerInfo(NavigationApi.api.liSpell);
               if(this.mSpell.count == 0 && this.mSpell.fullMatch == false)
               {
                  this.mDefaultState = "";
                  this.mDefaultCity = "";
                  this.triggerCountryChange = false;
                  if(this.mDefaultCountry != this.mDefaultCountryTemporary)
                  {
                     this.mDefaultCity = "";
                     this.triggerCountryChange = true;
                  }
                  this.mDefaultCountry = this.mDefaultCountryTemporary;
                  this.requestZipCodeStreetFirstAvailable();
                  this.persistData();
                  this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
                  this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
                  if(this.triggerCountryChange)
                  {
                     this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE);
                  }
                  if(VServiceGlobalSettings.MARKET_NORTH_AMERICA)
                  {
                     this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_CITY);
                  }
                  else
                  {
                     this.mLocationInputPathHistory.splice(2,2);
                  }
                  this.processNewPathState();
               }
               else if(this.mSpell.count > 0 || this.mSpell.fullMatch == true)
               {
                  this.sendEvent(LocationInputEvent.LI_SET_CHARACTER);
                  this.mLocationInputMenu = LocationInputMenu.SPELLER;
                  this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
                  this.sendBusy(false);
               }
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               Framework.Trace("LocationInputController.onGetSpell->SPELL_ZIPCODE");
               this.mSpell = SpellerInfo(NavigationApi.api.liSpell);
               if(this.fullZipCode() == NOT_FULL_ZIP_CODE)
               {
                  this.sendEvent(LocationInputEvent.LI_SET_CHARACTER);
                  this.mLocationInputMenu = LocationInputMenu.SPELLER;
                  this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
                  this.sendBusy(false);
               }
               else if(this.fullZipCode() == FULL_ZIP_CODE)
               {
                  this.mLocationInputPathHistory.push(LocationInputPath.LIST_ZIPCODE);
                  this.processNewPathState();
               }
               else if(this.fullZipCode() == BRITAIN_FULL_ZIP_CODE)
               {
                  this.assembleDescription();
               }
               else
               {
                  Framework.Trace("LocationInputController.onGetSpell->SPELL_ZIPCODE No Zip Code System");
                  this.sendBusy(false);
               }
               break;
            case LocationInputPath.SPELL_COUNTRY:
            case LocationInputPath.SPELL_CITY:
            case LocationInputPath.SPELL_HOUSENUMBER:
            case LocationInputPath.SPELL_STREET:
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mSpell = SpellerInfo(NavigationApi.api.liSpell);
               if(this.mSpell.count == 0 && this.mSpell.fullMatch == false)
               {
                  Framework.Trace("LocationInputController.onGetSpell: There are no characters left but it is no full match.");
                  this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                  Framework.Trace("Removed last path");
                  this.processNewPathState();
               }
               else if(this.mSpell.count > 0 || this.mSpell.fullMatch == true)
               {
                  this.sendEvent(LocationInputEvent.LI_SET_CHARACTER);
                  this.mLocationInputMenu = LocationInputMenu.SPELLER;
                  this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
                  this.sendBusy(false);
               }
               else
               {
                  this.processNewPathState();
               }
               break;
            default:
               Framework.Trace("LocationInputController.onGetSpell: Path(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
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
      
      public function set locationInputMenuPrevious(menu:int) : void
      {
         this.mLocationInputMenuPrevious = menu;
      }
      
      public function liSetInputPath(path:int) : void
      {
         Framework.Trace("LocationInputController.liSetInputPath:" + path);
         this.sendBusy(true);
         if(path == LocationInputPath.ENTER_ADDRESS_US || path == LocationInputPath.ENTER_ADDRESS_ECE || path == LocationInputPath.ENTER_CITYCENTER || path == LocationInputPath.ENTER_CLOSESTCITIES || path == LocationInputPath.ENTER_INTERSECTION_US || path == LocationInputPath.ENTER_INTERSECTION_ECE || path == LocationInputPath.ENTER_GEO_COORDINATE || path == LocationInputPath.ENTER_VR_DESTINATION || path == LocationInputPath.UNDEFINED)
         {
            this.resetController();
         }
         if(path == LocationInputPath.SPELL_CITY || path == LocationInputPath.SPELL_STREET || path == LocationInputPath.SPELL_STREET_SECOND || path == LocationInputPath.SPELL_HOUSENUMBER || path == LocationInputPath.SPELL_COUNTRY || path == LocationInputPath.SPELL_STATE || path == LocationInputPath.SPELL_ZIPCODE)
         {
            this.mSpelledCharacters = "";
         }
         if(path != LocationInputPath.UNDEFINED)
         {
            this.mLocationInputPathHistory.push(path);
         }
         if(path == LocationInputPath.LIST_COUNTRY)
         {
            this.mListCurrentPage_country = 0;
            this.mListTotalPages_country = 0;
         }
         this.processNewPathState();
      }
      
      private function processNewPathState() : void
      {
         Framework.Trace("LocationInputController.processNewPathState: path: " + this.toStringPathHistory() + " length:" + this.mLocationInputPathHistory.length);
         switch(this.mLocationInputPathHistory.length)
         {
            case 1:
               Framework.Trace(" HANDLING LEVEL 0:");
               this.mLocationInputMenu = LocationInputMenu.UNDEFINED;
               this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            case 2:
               Framework.Trace(" HANDLING LEVEL 1:");
               switch(this.mLocationInputPathHistory[1])
               {
                  case LocationInputPath.ENTER_ADDRESS_US:
                  case LocationInputPath.ENTER_ADDRESS_ECE:
                     this.mLocationInputMenu = LocationInputMenu.ENTRY_STREET_ADDRESS;
                     break;
                  case LocationInputPath.ENTER_CLOSESTCITIES:
                     this.mLocationInputPathHistory.push(LocationInputPath.LIST_CLOSEST_CITIES);
                     this.mLocationInputMenu = LocationInputMenu.LIST;
                     this.requestClosestCitiesList();
                     this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
                     return;
                  case LocationInputPath.ENTER_CITYCENTER:
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_CITY);
                     this.mLocationInputMenu = LocationInputMenu.SPELLER;
                     this.requestCitySpeller();
                     this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
                     return;
                  case LocationInputPath.ENTER_INTERSECTION_US:
                  case LocationInputPath.ENTER_INTERSECTION_ECE:
                     this.mLocationInputMenu = LocationInputMenu.ENTRY_INTERSECTION;
                     break;
                  case LocationInputPath.ENTER_GEO_COORDINATE:
                     this.mLocationInputMenu = LocationInputMenu.GEO_SPELLER;
                     break;
                  case LocationInputPath.FETCH_GEO_COORDINATE_DETAILS:
                     break;
                  default:
                     Framework.Trace(" -> unhandled (" + this.mLocationInputPathHistory[1] + ")");
               }
               this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
               this.sendBusy(false);
               break;
            default:
               Framework.Trace("HANDLING LEVEL " + String(this.mLocationInputPathHistory.length - 1) + ":");
               switch(this.getLastPathHistoryItem())
               {
                  case LocationInputPath.LIST_COUNTRY:
                     Framework.Trace("Handle: LIST_COUNTRY");
                     this.requestCountryList();
                     break;
                  case LocationInputPath.LIST_STATE:
                     Framework.Trace("Handle: LIST_STATE");
                     this.requestStateList();
                     break;
                  case LocationInputPath.LIST_CITY:
                     Framework.Trace("Handle: LIST_CITY");
                     this.requestCityList();
                     break;
                  case LocationInputPath.LIST_CLOSEST_CITIES:
                     Framework.Trace("Handle: LIST_CLOSEST_CITIES");
                     this.requestClosestCitiesList();
                     break;
                  case LocationInputPath.LIST_STREET:
                     Framework.Trace("Handle: LIST_STREET");
                     this.requestStreetList();
                     break;
                  case LocationInputPath.LIST_STREET_SECOND:
                     Framework.Trace("Handle: LIST_STREET_SECOND");
                     this.requestStreetList();
                     break;
                  case LocationInputPath.LIST_ZIPCODE:
                     Framework.Trace("Handle: LIST_ZIPCODE");
                     this.requestZipCodeList();
                     break;
                  case LocationInputPath.LIST_HOUSENUMBER:
                     Framework.Trace("Handle: LIST_HOUSENUMBER");
                     this.requestHouseNumberRefinement();
                     break;
                  case LocationInputPath.SPELL_COUNTRY:
                     Framework.Trace("Handle: SPELL_COUNTRY");
                     this.requestCountrySpeller();
                     break;
                  case LocationInputPath.SPELL_STATE:
                     Framework.Trace("Handle: SPELL_STATE");
                     this.requestStateSpeller();
                     break;
                  case LocationInputPath.SPELL_CITY:
                     Framework.Trace("Handle: SPELL_CITY");
                     this.requestCitySpeller();
                     break;
                  case LocationInputPath.SPELL_STREET:
                     Framework.Trace("Handle: SPELL_STREET");
                     this.requestStreetSpeller();
                     break;
                  case LocationInputPath.SPELL_STREET_SECOND:
                     Framework.Trace("Handle: SPELL_STREET_SECOND");
                     this.requestStreetSpeller();
                     break;
                  case LocationInputPath.SPELL_HOUSENUMBER:
                     Framework.Trace("Handle: SPELL_HOUSENUMBER");
                     this.requestHouseNumberSpeller();
                     break;
                  case LocationInputPath.REFINE_HOUSENUMBER:
                     Framework.Trace("Handle: REFINE_HOUSENUMBER");
                     this.requestHouseNumberRefinement();
                     break;
                  case LocationInputPath.SPELL_ZIPCODE:
                     Framework.Trace("Handle: SPELL_ZIPCODE");
                     this.requestZipCodeSpeller();
                     break;
                  default:
                     Framework.Trace("unhandled");
               }
         }
         this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
      }
      
      public function liGetIputPath() : void
      {
         this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
      }
      
      public function get liInputPath() : int
      {
         return this.mLocationInputPathHistory[this.mLocationInputPathHistory.length - 1];
      }
      
      public function liGetActiveMenu() : void
      {
         this.sendEvent(LocationInputEvent.LI_ACTIVE_MENU);
      }
      
      public function get liActiveMenu() : int
      {
         return this.mLocationInputMenu;
      }
      
      public function liGetBusy() : void
      {
         this.sendEvent(LocationInputEvent.LI_SET_BUSY);
      }
      
      public function get liIsBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function onConfirmDestinationBack() : void
      {
         if(this.mLastRemovedLI != LocationInputPath.UNDEFINED)
         {
            this.mLocationInputPathHistory.push(this.mLastRemovedLI);
            this.mLastRemovedLI = LocationInputPath.UNDEFINED;
         }
      }
      
      public function liOnBack() : void
      {
         Framework.Trace("liOnBack: path:" + this.toStringPathHistory() + " length:" + this.mLocationInputPathHistory.length + " menu:" + this.mLocationInputMenu);
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_COUNTRY:
               this.mSpelledCharacters = "";
               this.mCountrySpelled = "";
               break;
            case LocationInputPath.SPELL_STATE:
               this.mSpelledCharacters = "";
               this.mStateSpelled = "";
               break;
            case LocationInputPath.SPELL_CITY:
               this.mSpelledCharacters = "";
               this.mCitySpelled = "";
               break;
            case LocationInputPath.SPELL_STREET:
               this.mSpelledCharacters = "";
               this.mStreetSpelled = "";
               break;
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mSpelledCharacters = "";
               this.mStreetSecondSpelled = "";
               break;
            case LocationInputPath.SPELL_HOUSENUMBER:
               this.mSpelledCharacters = "";
               this.mHouseNumberSpelled = "";
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               this.mSpelledCharacters = "";
               this.mZipCodeSpelled = "";
               break;
            case LocationInputPath.LIST_ZIPCODE:
               this.mZipCodeListed = "";
               break;
            case LocationInputPath.LIST_CITY:
               this.mCityListed = "";
               break;
            case LocationInputPath.LIST_CLOSEST_CITIES:
               this.mCityListed = "";
               break;
            case LocationInputPath.LIST_STREET:
               this.mStreetListed = "";
               break;
            case LocationInputPath.LIST_HOUSENUMBER:
            case LocationInputPath.LIST_STREET_SECOND:
               this.mStreetSecondListed = "";
               break;
            case LocationInputPath.LIST_COUNTRY:
            case LocationInputPath.LIST_STATE:
         }
         this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_COUNTRY:
               this.mSpelledCharacters = this.mCountrySpelled;
               break;
            case LocationInputPath.SPELL_STATE:
               this.mSpelledCharacters = this.mStateSpelled;
               break;
            case LocationInputPath.SPELL_CITY:
               this.mSpelledCharacters = this.mCitySpelled;
               break;
            case LocationInputPath.SPELL_STREET:
               this.mSpelledCharacters = this.mStreetSpelled;
               break;
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mSpelledCharacters = this.mStreetSecondSpelled;
               break;
            case LocationInputPath.SPELL_HOUSENUMBER:
               this.mSpelledCharacters = this.mHouseNumberSpelled;
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               this.mSpelledCharacters = this.mZipCodeSpelled.slice(0,this.mZipCodeSpelled.length - 1);
               this.mLocationInputMenu = LocationInputMenu.SPELLER;
               this.requestZipCodeSpeller();
               this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
               return;
            case LocationInputPath.LIST_COUNTRY:
               this.mListCurrentPage = this.mListCurrentPage_country;
               this.mListTotalPages = this.mListTotalPages_country;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.LIST_STATE:
               this.mListCurrentPage = this.mListCurrentPage_state;
               this.mListTotalPages = this.mListTotalPages_state;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.LIST_CITY:
            case LocationInputPath.LIST_CLOSEST_CITIES:
               this.mListCurrentPage = this.mListCurrentPage_city;
               this.mListTotalPages = this.mListTotalPages_city;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.LIST_STREET:
               this.mListCurrentPage = this.mListCurrentPage_street;
               this.mListTotalPages = this.mListTotalPages_street;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.LIST_STREET_SECOND:
               this.mListCurrentPage = this.mListCurrentPage_street_second;
               this.mListTotalPages = this.mListTotalPages_street_second;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.LIST_ZIPCODE:
               this.mListCurrentPage = this.mListCurrentPage_ZipCode;
               this.mListTotalPages = this.mListTotalPages_ZipCode;
               this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
               this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
               break;
            case LocationInputPath.ENTER_CITYCENTER:
            case LocationInputPath.ENTER_CLOSESTCITIES:
               this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
         }
         this.processNewPathState();
      }
      
      public function liGetDefaultCountry() : void
      {
         this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
      }
      
      public function liGetDefaultCountryTemp() : void
      {
         this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_TEMP);
      }
      
      public function liGetDefaultState() : void
      {
         this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
      }
      
      public function liGetDefaultCity() : void
      {
         this.sendEvent(LocationInputEvent.LI_DEFAULT_CITY);
      }
      
      public function liGetIsLanguageChangeInProgress() : void
      {
         this.sendEvent(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS);
      }
      
      public function get liDefaultCountry() : String
      {
         return this.mDefaultCountry;
      }
      
      public function get liDefaultCountryTemp() : String
      {
         return this.mDefaultCountryTemporary;
      }
      
      public function get liDefaultState() : String
      {
         return this.mDefaultState;
      }
      
      public function get liDefaultCity() : String
      {
         return this.mDefaultCity;
      }
      
      public function setDefaultCountry(country:String) : void
      {
         Framework.Trace("LocationInputController.setDefaultCountry( " + country + " )");
         this.mDefaultCountry = country;
         this.mDefaultState = "";
         this.mDefaultCity = "";
         this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
         this.persistData();
      }
      
      public function setDefaultState(state:String, sendCountryChangeSignal:Boolean = false) : void
      {
         Framework.Trace("LocationInputController.setDefaultState( " + state + " )");
         this.mDefaultState = state;
         this.mDefaultCity = "";
         this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
         if(sendCountryChangeSignal)
         {
            this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE);
         }
         this.persistData();
      }
      
      public function setDefaultCity(city:String) : void
      {
         Framework.Trace("LocationInputController.setDeafaultCity( " + city + " )");
         this.mDefaultCity = city;
         this.sendEvent(LocationInputEvent.LI_DEFAULT_CITY);
      }
      
      public function get liIsLanguageChangeInProgress() : Boolean
      {
         for(var i:int = 0; i < this.mLocationInputPathHistory.length; i++)
         {
            if(this.mLocationInputPathHistory[i] == LocationInputPath.LIST_LANGUAGE_CHANGE_CTR || this.mLocationInputPathHistory[i] == LocationInputPath.LIST_LANGUAGE_CHANGE_STA)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get liIsLanguageChangeInProgressChina() : Boolean
      {
         return false;
      }
      
      public function liSelectCharacter(char:String) : void
      {
         if(this.mSpell.characters.indexOf(char) == -1)
         {
            Framework.Trace("LocationInputController.liSelectCharacter(" + char + "): not part of (" + this.mSpell.characters + ")");
            return;
         }
         this.sendBusy(true);
         this.mSpelledCharacters += char;
         this.sendEvent(LocationInputEvent.LI_SET_ENTERED_CHARACTERS);
         this.process();
      }
      
      public function liRemoveLastCharacter() : void
      {
         if(this.mLocationInputMenu != LocationInputMenu.SPELLER)
         {
            Framework.Trace("!!! LocationInputController.liRemoveLastCharacter called while not in speller menu. LocationInputMenu(" + this.mLocationInputMenu + ") LocationInputPath(" + this.getLastPathHistoryItem() + ")");
            return;
         }
         this.sendBusy(true);
         this.mSpelledCharacters = this.mSpelledCharacters.substr(0,this.mSpelledCharacters.length - 1);
         this.process();
      }
      
      public function liRemoveAllCharacters() : void
      {
         if(this.mLocationInputMenu != LocationInputMenu.SPELLER)
         {
            Framework.Trace("!!! LocationInputController.liRemoveAllCharacters called while not in speller menu. LocationInputMenu(" + this.mLocationInputMenu + ") LocationInputPath(" + this.getLastPathHistoryItem() + ")");
            return;
         }
         this.sendBusy(true);
         this.mSpelledCharacters = "";
         this.mHouseNumberSpelled = "";
         this.mHouseNumberRefined = "";
         this.process();
      }
      
      public function liGetAvailableCharacters() : void
      {
         this.sendEvent(LocationInputEvent.LI_SET_CHARACTER);
      }
      
      public function liGetEnteredCharacters() : void
      {
         this.sendEvent(LocationInputEvent.LI_SET_ENTERED_CHARACTERS);
      }
      
      public function get liAvailableCharacters() : SpellerInfo
      {
         return this.mSpell;
      }
      
      public function get liEnteredCharacters() : String
      {
         return this.mSpelledCharacters;
      }
      
      private function process() : void
      {
         this.updateSpelledCharacters();
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_CITY:
            case LocationInputPath.SPELL_COUNTRY:
            case LocationInputPath.SPELL_HOUSENUMBER:
            case LocationInputPath.SPELL_ZIPCODE:
            case LocationInputPath.SPELL_STATE:
            case LocationInputPath.SPELL_STREET:
            case LocationInputPath.SPELL_STREET_SECOND:
               this.processNewPathState();
               break;
            default:
               Framework.Trace("!!!LocationInputController.process: LocationInputPath(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
      }
      
      private function updateSpelledCharacters() : void
      {
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_COUNTRY:
               this.mCountrySpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_STATE:
               this.mStateSpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_CITY:
               this.mCitySpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_STREET:
               this.mStreetSpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mStreetSecondSpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_HOUSENUMBER:
               this.mHouseNumberSpelled = this.mSpelledCharacters;
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               this.mZipCodeSpelled = this.mSpelledCharacters;
               break;
            default:
               Framework.Trace("!!!LocationInputController.updateSpelledCharacters: LocationInputPath(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
      }
      
      public function liSwitchToList() : void
      {
         if(this.mLocationInputMenu != LocationInputMenu.SPELLER)
         {
            Framework.Trace("!!! LocationInputController.liSwitchToList called while not in speller menu. LocationInputMenu(" + this.mLocationInputMenu + ") LocationInputPath(" + this.getLastPathHistoryItem() + ")");
            return;
         }
         this.sendBusy(true);
         this.mListCurrentPage = 0;
         this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_CITY:
               this.mListCurrentPage_city = 0;
               this.mCitySpelled = this.mSpelledCharacters;
               this.mLocationInputPathHistory.push(LocationInputPath.LIST_CITY);
               this.processNewPathState();
               break;
            case LocationInputPath.SPELL_STATE:
               this.mListCurrentPage_state = 0;
               this.mStateSpelled = this.mSpelledCharacters;
               this.mLocationInputPathHistory.push(LocationInputPath.LIST_STATE);
               this.processNewPathState();
               break;
            case LocationInputPath.SPELL_COUNTRY:
               this.mListCurrentPage_country = 0;
               this.mCountrySpelled = this.mSpelledCharacters;
               this.mLocationInputPathHistory.push(LocationInputPath.LIST_COUNTRY);
               this.processNewPathState();
               break;
            case LocationInputPath.SPELL_STREET:
               if(this.mStreetSpelled != "")
               {
                  this.mListCurrentPage_street = 0;
                  this.mStreetSpelled = this.mSpelledCharacters;
                  this.mLocationInputPathHistory.push(LocationInputPath.LIST_STREET);
                  this.processNewPathState();
               }
               else
               {
                  this.mLastRemovedLI = LocationInputPath.SPELL_STREET;
                  this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                  if(this.mCityListed == "")
                  {
                     this.mCityListed = this.mDefaultCity;
                  }
                  this.assembleDescription();
               }
               break;
            case LocationInputPath.SPELL_STREET_SECOND:
               this.mListCurrentPage_street_second = 0;
               this.mStreetSecondSpelled = this.mSpelledCharacters;
               this.mLocationInputPathHistory.push(LocationInputPath.LIST_STREET_SECOND);
               this.processNewPathState();
               break;
            case LocationInputPath.SPELL_HOUSENUMBER:
               this.mHouseNumberSpelled = this.mSpelledCharacters;
               Framework.Trace("Reached End for SPELL_HOUSENUMBER. FullMatch:" + this.mSpell.fullMatch);
               Framework.Trace("Assemble the LocationDescription and get the Details from NNG");
               if(this.mSpell.count > 1 && this.mSpell.fullMatch)
               {
                  this.mLocationInputPathHistory.push(LocationInputPath.LIST_HOUSENUMBER);
                  this.processNewPathState();
               }
               else
               {
                  Framework.Trace("NNG-Special: request getList first, to get <GEO> tag.");
                  this.mLocationInputPathHistory.push(LocationInputPath.REFINE_HOUSENUMBER);
                  this.processNewPathState();
               }
               break;
            case LocationInputPath.SPELL_ZIPCODE:
               Framework.Trace("Reached End for SPELL_ZIPCODE. FullMatch:" + this.mSpell.fullMatch + " length = " + this.mSpelledCharacters.length);
               this.mListTotalPages_ZipCode = 0;
               this.mZipCodeSpelled = this.mSpelledCharacters;
               if(this.fullZipCode() == NOT_FULL_ZIP_CODE)
               {
                  this.mLocationInputPathHistory.push(LocationInputPath.LIST_ZIPCODE);
                  this.processNewPathState();
               }
               else if(this.fullZipCode() == FULL_ZIP_CODE)
               {
                  this.mLocationInputPathHistory.push(LocationInputPath.LIST_ZIPCODE);
                  this.processNewPathState();
               }
               else if(this.fullZipCode() == BRITAIN_FULL_ZIP_CODE)
               {
                  this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                  this.assembleDescription();
               }
               else
               {
                  Framework.Trace("LocationInputController.onGetSpell->SPELL_ZIPCODE No Zip Code System");
                  this.sendBusy(false);
               }
               break;
            default:
               Framework.Trace("!!!LocationInputController.liSwitchToList: LocationInputPath(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
      }
      
      public function liSetTripAssemble() : void
      {
      }
      
      public function liSelectListItem(item:int) : void
      {
         if(this.mBusy)
         {
            Framework.Trace("LI.liSelectListItem(" + item + ") busy!");
            return;
         }
         this.sendBusy(true);
         this.clearSpelledCharacters();
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_COUNTRY:
               this.mDefaultCountryTemporary = String(this.mList[item]);
               Framework.Trace("liSelectListItem: mDefaultCountryTemporary= " + this.mDefaultCountryTemporary);
               this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_TEMP);
               this.mLocationInputPathHistory.push(LocationInputPath.SPELL_STATE);
               this.sendEvent(LocationInputEvent.LI_INPUT_PATH);
               this.requestStateSpeller();
               break;
            case LocationInputPath.LIST_STATE:
               this.mDefaultState = String(this.mList[item]);
               this.mDefaultCity = "";
               this.triggerCountryChange = false;
               if(this.mDefaultCountry != this.mDefaultCountryTemporary)
               {
                  this.triggerCountryChange = true;
               }
               this.mDefaultCountry = this.mDefaultCountryTemporary;
               this.requestZipCodeStreetFirstAvailable();
               this.persistData();
               this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY);
               this.sendEvent(LocationInputEvent.LI_DEFAULT_STATE);
               if(this.triggerCountryChange == true)
               {
                  this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE);
               }
               this.mLocationInputPathHistory.push(LocationInputPath.SPELL_CITY);
               this.processNewPathState();
               break;
            case LocationInputPath.LIST_CITY:
            case LocationInputPath.LIST_CLOSEST_CITIES:
               this.mDefaultCity = this.getCityListedString(String(this.mList[item]));
               this.persistData();
               this.sendEvent(LocationInputEvent.LI_DEFAULT_CITY);
               switch(this.getPathHistoryItem(1))
               {
                  case LocationInputPath.ENTER_ADDRESS_ECE:
                  case LocationInputPath.ENTER_ADDRESS_US:
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_STREET);
                     this.processNewPathState();
                     break;
                  case LocationInputPath.ENTER_CLOSESTCITIES:
                     Framework.Trace("Reached End for ENTER_CLOSESTCITIES ");
                     Framework.Trace("Assemble the LocationDescription and get the Details from NNG");
                     this.mDefaultCity = "";
                     this.persistData();
                     this.assembleDescription();
                     break;
                  case LocationInputPath.ENTER_CITYCENTER:
                     Framework.Trace("Reached End for ENTER_CITYCENTER ");
                     Framework.Trace("Assemble the LocationDescription and get the Details from NNG");
                     this.mDefaultCity = "";
                     this.persistData();
                     this.assembleDescription();
                     break;
                  case LocationInputPath.ENTER_INTERSECTION_ECE:
                  case LocationInputPath.ENTER_INTERSECTION_US:
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_STREET);
                     this.processNewPathState();
                     break;
                  default:
                     Framework.Trace("!!! LocationInputController.liSelectListItem: LIST_CITY unsupported LocationInputPath (" + this.getLastPathHistoryItem() + ")");
               }
               break;
            case LocationInputPath.LIST_STREET:
               this.mStreetListed = String(this.mList[item]);
               switch(this.getPathHistoryItem(1))
               {
                  case LocationInputPath.ENTER_ADDRESS_ECE:
                  case LocationInputPath.ENTER_ADDRESS_US:
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_HOUSENUMBER);
                     this.processNewPathState();
                     break;
                  case LocationInputPath.ENTER_INTERSECTION_ECE:
                  case LocationInputPath.ENTER_INTERSECTION_US:
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_STREET_SECOND);
                     this.processNewPathState();
                     break;
                  case LocationInputPath.ENTER_CITYCENTER:
                  case LocationInputPath.ENTER_CLOSESTCITIES:
                  default:
                     Framework.Trace("!!! LocationInputController.liSelectListItem: LIST_STREET unsupported LocationInputPath (" + this.getLastPathHistoryItem() + ")");
               }
               break;
            case LocationInputPath.LIST_ZIPCODE:
               this.mZipCodeListed = String(this.mList[item]);
               switch(this.getPathHistoryItem(1))
               {
                  case LocationInputPath.ENTER_ADDRESS_ECE:
                  case LocationInputPath.ENTER_INTERSECTION_ECE:
                     this.mZipCodeHouseNumberSearchString = "<IFT>LI<*>" + this.mZipCodeListed + this.mDefaultCountry;
                     NavigationApi.api.liGetAvailableInformation(this.mZipCodeHouseNumberSearchString);
                     break;
                  default:
                     Framework.Trace("!!! LocationInputController.liSelectListItem: LIST_STREET unsupported LocationInputPath (" + this.getLastPathHistoryItem() + ")");
               }
               break;
            case LocationInputPath.LIST_HOUSENUMBER:
               this.mHouseNumberRefined = String(this.mList[item]);
               Framework.Trace("Assemble the LocationDescription and get the Details from NNG");
               this.assembleDescription();
               break;
            case LocationInputPath.LIST_STREET_SECOND:
               this.mStreetSecondListed = String(this.mList[item]);
               Framework.Trace("Reached End for ENTER_INTERSECTION ");
               Framework.Trace("Assemble the LocationDescription and get the Details from NNG");
               this.assembleDescription();
               break;
            default:
               Framework.Trace("!!! LocationInputController.liSelectListItem: unsupported LocationInputPath (" + this.getLastPathHistoryItem() + ")");
               this.sendBusy(false);
         }
      }
      
      public function liSetResultsPerPage(results:int) : void
      {
         this.mListSizePerPage = results;
      }
      
      public function liGetList() : void
      {
         this.sendEvent(LocationInputEvent.LI_SET_LIST);
      }
      
      public function liGetCurrentPageNumber() : void
      {
         this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
      }
      
      public function liGetTotalPagesNumber() : void
      {
         this.sendEvent(LocationInputEvent.LI_PAGES_TOTAL);
      }
      
      public function get list() : Array
      {
         return this.mList;
      }
      
      public function get liCurrentPageNumber() : int
      {
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_COUNTRY:
               return this.mListCurrentPage_country;
            case LocationInputPath.LIST_STATE:
               return this.mListCurrentPage_state;
            case LocationInputPath.LIST_CITY:
               return this.mListCurrentPage_city;
            case LocationInputPath.LIST_CLOSEST_CITIES:
               return this.mListCurrentPage_city;
            case LocationInputPath.LIST_STREET:
               return this.mListCurrentPage_street;
            case LocationInputPath.LIST_STREET_SECOND:
               return this.mListCurrentPage_street_second;
            default:
               return this.mListCurrentPage;
         }
      }
      
      public function get liTotalPageNumber() : int
      {
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_COUNTRY:
               return this.mListTotalPages_country;
            case LocationInputPath.LIST_STATE:
               return this.mListTotalPages_state;
            case LocationInputPath.LIST_CITY:
               return this.mListTotalPages_city;
            case LocationInputPath.LIST_CLOSEST_CITIES:
               return this.mListTotalPages_city;
            case LocationInputPath.LIST_STREET:
               return this.mListTotalPages_street;
            case LocationInputPath.LIST_STREET_SECOND:
               return this.mListTotalPages_street_second;
            default:
               return this.mListTotalPages;
         }
      }
      
      public function liOnNextPage() : void
      {
         this.sendBusy(true);
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_COUNTRY:
               if(this.mListTotalPages_country > this.mListCurrentPage_country + 1)
               {
                  ++this.mListCurrentPage_country;
               }
               break;
            case LocationInputPath.LIST_STATE:
               if(this.mListTotalPages_state > this.mListCurrentPage_state + 1)
               {
                  ++this.mListCurrentPage_state;
               }
               break;
            case LocationInputPath.LIST_CITY:
               if(this.mListTotalPages_city > this.mListCurrentPage_city + 1)
               {
                  ++this.mListCurrentPage_city;
               }
               break;
            case LocationInputPath.LIST_CLOSEST_CITIES:
               if(this.mListTotalPages_city > this.mListCurrentPage_city + 1)
               {
                  ++this.mListCurrentPage_city;
               }
               break;
            case LocationInputPath.LIST_STREET:
               if(this.mListTotalPages_street > this.mListCurrentPage_street + 1)
               {
                  ++this.mListCurrentPage_street;
               }
               break;
            case LocationInputPath.LIST_STREET_SECOND:
               if(this.mListTotalPages_street_second > this.mListCurrentPage_street_second + 1)
               {
                  ++this.mListCurrentPage_street_second;
               }
               break;
            default:
               Framework.Trace("!!!LocationInputController.liOnNextPage: LocationInputPath(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
         this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
         this.processNewPathState();
      }
      
      public function liOnPreviousPage() : void
      {
         this.sendBusy(true);
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_COUNTRY:
               if(this.mListCurrentPage_country > 0)
               {
                  --this.mListCurrentPage_country;
               }
               break;
            case LocationInputPath.LIST_STATE:
               if(this.mListCurrentPage_state > 0)
               {
                  --this.mListCurrentPage_state;
               }
               break;
            case LocationInputPath.LIST_CITY:
               if(this.mListCurrentPage_city > 0)
               {
                  --this.mListCurrentPage_city;
               }
               break;
            case LocationInputPath.LIST_CLOSEST_CITIES:
               if(this.mListCurrentPage_city > 0)
               {
                  --this.mListCurrentPage_city;
               }
               break;
            case LocationInputPath.LIST_STREET:
               if(this.mListCurrentPage_street > 0)
               {
                  --this.mListCurrentPage_street;
               }
               break;
            case LocationInputPath.LIST_STREET_SECOND:
               if(this.mListCurrentPage_street_second > 0)
               {
                  --this.mListCurrentPage_street_second;
               }
               break;
            default:
               Framework.Trace("!!!LocationInputController.liOnNextPage: LocationInputPath(" + this.getLastPathHistoryItem() + ") not supported yet.");
         }
         this.sendEvent(LocationInputEvent.LI_PAGE_CURRENT);
         this.processNewPathState();
      }
      
      public function liSetGeoCoordinate(geoCoordinate:String, customName:String) : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addEisString(geoCoordinate);
         loc.setCustomName(customName);
         if(this.getLastPathHistoryItem() == LocationInputPath.ENTER_GEO_COORDINATE)
         {
            this.mLocationDescription = new LocationDescription();
            this.mLocationDescription.setPrimaryLocation(loc);
            NavigationApi.api.liGetDetails(loc.toEIS());
         }
         if(this.getLastPathHistoryItem() == LocationInputPath.FETCH_GEO_COORDINATE_DETAILS)
         {
            this.mFetchedGeoCoordinateDetails = new LocationDescription();
            this.mFetchedGeoCoordinateDetails.setPrimaryLocation(loc);
            NavigationApi.api.liGetDetails(loc.toEIS());
         }
         else
         {
            this.sendEvent(LocationInputEvent.LI_INVALID_GEO_COODRINATE);
         }
      }
      
      public function liSetGeoLocation(loc:LocationDetails) : void
      {
         if(this.getLastPathHistoryItem() == LocationInputPath.ENTER_GEO_COORDINATE)
         {
            this.mLocationDescription = new LocationDescription();
            this.mLocationDescription.setPrimaryLocation(loc);
            NavigationApi.api.liGetDetails(loc.getType(OpenNavUtilities.c_EIS_IFT) + OpenNavUtilities.c_EIS_GEO + loc.getType(OpenNavUtilities.c_EIS_GEO) + OpenNavUtilities.c_EIS_TOKEN_END);
         }
         else if(this.getLastPathHistoryItem() == LocationInputPath.ENTER_VR_DESTINATION)
         {
            this.mLocationDescription = new LocationDescription();
            this.mLocationDescription.setPrimaryLocation(loc);
            NavigationApi.api.liGetDetails(loc.toEIS());
         }
         else
         {
            this.sendEvent(LocationInputEvent.LI_INVALID_GEO_COODRINATE);
         }
      }
      
      public function get liFetchedGeoCoordinateDetails() : LocationDescription
      {
         return this.mFetchedGeoCoordinateDetails;
      }
      
      public function liGetCurrentInputProgress() : String
      {
         var loc:LocationDetails = new LocationDetails();
         if(this.getPathHistoryItem(1) != LocationInputPath.ENTER_CITYCENTER && this.getPathHistoryItem(1) != LocationInputPath.ENTER_CLOSESTCITIES)
         {
            if(this.mDefaultCountry != "")
            {
               loc.addEisString(this.mDefaultCountry);
            }
            if(this.mDefaultState != "")
            {
               loc.addEisString(this.mDefaultState);
            }
         }
         if(this.mCityListed != "")
         {
            loc.addEisString(this.mCityListed);
         }
         else if(this.mDefaultCity != "")
         {
            loc.addEisString(this.mDefaultCity);
         }
         if(this.mStreetListed != "")
         {
            loc.addEisString(this.mStreetListed);
         }
         if(this.mStreetSecondListed != "")
         {
            loc.addEisString(this.mStreetSecondListed);
         }
         if(this.mHouseNumberRefined != "")
         {
            loc.addEisString(this.mHouseNumberRefined);
         }
         this.mLocationDescription = new LocationDescription();
         this.mLocationDescription.setPrimaryLocation(loc);
         return loc.toEIS();
      }
      
      private function getCityListedString(value:String) : String
      {
         this.mCityListed = OpenNavUtilities.c_EIS_CTY + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_CTY) + OpenNavUtilities.c_EIS_TOKEN_END + OpenNavUtilities.c_EIS_CTY_NNG + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_CTY_NNG) + OpenNavUtilities.c_EIS_TOKEN_END;
         if(value.indexOf(OpenNavUtilities.c_EIS_REF) != -1)
         {
            this.mCityListed = this.mCityListed + OpenNavUtilities.c_EIS_REF + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_REF) + OpenNavUtilities.c_EIS_TOKEN_END;
         }
         if(value.indexOf(OpenNavUtilities.c_EIS_STA) != -1)
         {
            this.mCityListed = this.mCityListed + OpenNavUtilities.c_EIS_STA + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_STA) + OpenNavUtilities.c_EIS_TOKEN_END;
         }
         if(value.indexOf(OpenNavUtilities.c_EIS_STA_NNG) != -1)
         {
            this.mCityListed = this.mCityListed + OpenNavUtilities.c_EIS_STA_NNG + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_STA_NNG) + OpenNavUtilities.c_EIS_TOKEN_END;
         }
         if(value.indexOf(OpenNavUtilities.c_EIS_CTR) != -1)
         {
            this.mCityListed = this.mCityListed + OpenNavUtilities.c_EIS_CTR + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_CTR) + OpenNavUtilities.c_EIS_TOKEN_END;
         }
         if(value.indexOf(OpenNavUtilities.c_EIS_CTR_NNG) != -1)
         {
            this.mCityListed = this.mCityListed + OpenNavUtilities.c_EIS_CTR_NNG + EisHelper.getValueOfType(value,OpenNavUtilities.c_EIS_CTR_NNG) + OpenNavUtilities.c_EIS_TOKEN_END;
         }
         return this.mCityListed;
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new LocationInputEvent(eventType));
      }
      
      private function sendBusy(busy:Boolean) : void
      {
         this.mBusy = busy;
         this.sendEvent(LocationInputEvent.LI_SET_BUSY);
      }
      
      private function getLastPathHistoryItem() : int
      {
         return this.mLocationInputPathHistory[this.mLocationInputPathHistory.length - 1];
      }
      
      private function getPathHistoryItem(index:int) : int
      {
         if(this.mLocationInputPathHistory.length > index)
         {
            return this.mLocationInputPathHistory[index];
         }
         return -1;
      }
      
      private function toStringPathHistory() : String
      {
         var pathStr:String = "";
         for(var i:int = 0; i < this.mLocationInputPathHistory.length; i++)
         {
            pathStr += String(this.mLocationInputPathHistory[i]) + " ";
         }
         return pathStr;
      }
      
      private function clearSpelledCharacters() : void
      {
         this.mSpelledCharacters = "";
      }
      
      private function getNumberOfPages() : int
      {
         var ret:int = 0;
         if(SpellerInfo(NavigationApi.api.liSpell).count <= 0)
         {
            return 0;
         }
         ret = SpellerInfo(NavigationApi.api.liSpell).count / this.mListSizePerPage;
         if(SpellerInfo(NavigationApi.api.liSpell).count % this.mListSizePerPage > 0)
         {
            ret++;
         }
         Framework.Trace("getNumberOfPages:" + SpellerInfo(NavigationApi.api.liSpell).count + " ->" + ret + "pages");
         return ret;
      }
      
      private function resetController() : void
      {
         this.mLocationInputPathHistory = new Array();
         this.mLocationInputPathHistory.push(LocationInputPath.UNDEFINED);
         this.mList.splice(0,this.mList.length);
         this.mSpelledCharacters = "";
         this.mCountrySpelled = "";
         this.mStateSpelled = "";
         this.mCitySpelled = "";
         this.mCityListed = "";
         this.mStreetSpelled = "";
         this.mStreetListed = "";
         this.mStreetSecondSpelled = "";
         this.mStreetSecondListed = "";
         this.mHouseNumberSpelled = "";
         this.mHouseNumberRefined = "";
         this.mZipCodeListed = "";
         this.mZipCodeSpelled = "";
      }
      
      private function requestZipCodeStreetFirstAvailable() : void
      {
         this.mZipCodeAvailableSearchString = "<IFT>LI<*>" + this.mDefaultCountry + this.mDefaultState;
         NavigationApi.api.liGetAvailableInformation(this.mZipCodeAvailableSearchString);
      }
      
      private function requestStateSpeller() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountryTemporary);
         loc.addType(OpenNavUtilities.c_EIS_STA,this.mSpelledCharacters);
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestCountrySpeller() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addType(OpenNavUtilities.c_EIS_CTR,this.mSpelledCharacters);
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestCitySpeller() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         if(this.getPathHistoryItem(1) != LocationInputPath.ENTER_CITYCENTER)
         {
            loc.addEisString(this.mDefaultCountry);
            if(this.mDefaultState != "")
            {
               loc.addEisString(this.mDefaultState);
            }
         }
         loc.addType(OpenNavUtilities.c_EIS_CTY,this.mSpelledCharacters);
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestStreetSpeller() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountry);
         if(this.mDefaultState != "")
         {
            loc.addEisString(this.mDefaultState);
         }
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_US:
               if(this.mCityListed != "")
               {
                  loc.addEisString(this.mCityListed);
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               loc.addType(OpenNavUtilities.c_EIS_STR,this.mSpelledCharacters);
               break;
            case LocationInputPath.ENTER_ADDRESS_ECE:
               if(this.mZipCodeListed.indexOf(OpenNavUtilities.c_EIS_ZIP) != -1)
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,EisHelper.getValueFromEisPair(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_ZIP_NNG,EisHelper.getLastValueFromEisString(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               else if(this.mZipCodeSpelled != "")
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,this.mZipCodeSpelled);
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               if(this.isZipFilled(this.mZipCodeListed + this.mZipCodeSpelled) == false)
               {
                  if(this.mDefaultCity == "")
                  {
                     this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_CITY);
                     this.processNewPathState();
                     return;
                  }
                  loc.addEisString(this.mDefaultCity);
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               break;
            case LocationInputPath.ENTER_INTERSECTION_ECE:
               if(this.mZipCodeListed.indexOf(OpenNavUtilities.c_EIS_ZIP) != -1)
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,EisHelper.getValueFromEisPair(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_ZIP_NNG,EisHelper.getLastValueFromEisString(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               else if(this.mZipCodeSpelled != "")
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,this.mZipCodeSpelled);
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               if(this.isZipFilled(this.mZipCodeListed + this.mZipCodeSpelled) == false)
               {
                  if(this.mDefaultCity == "")
                  {
                     this.mLocationInputPathHistory.splice(this.mLocationInputPathHistory.length - 1,1);
                     this.mLocationInputPathHistory.push(LocationInputPath.SPELL_CITY);
                     this.processNewPathState();
                     return;
                  }
                  loc.addEisString(this.mDefaultCity);
               }
               switch(this.getLastPathHistoryItem())
               {
                  case LocationInputPath.SPELL_STREET:
                     loc.addType(OpenNavUtilities.c_EIS_STR,this.mSpelledCharacters);
                     break;
                  case LocationInputPath.SPELL_STREET_SECOND:
                     loc.addEisString(this.mStreetListed);
                     loc.addType(OpenNavUtilities.c_EIS_ITR,this.mSpelledCharacters);
                     break;
                  default:
                     Framework.Trace("LocationInputController.requestStreetSpeller: Illegal path flow! ENTER_INTERSECTION (" + this.toStringPathHistory() + ")");
               }
               break;
            case LocationInputPath.ENTER_INTERSECTION_US:
               if(this.mCityListed != "")
               {
                  loc.addEisString(this.mCityListed);
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               switch(this.getLastPathHistoryItem())
               {
                  case LocationInputPath.SPELL_STREET:
                     loc.addType(OpenNavUtilities.c_EIS_STR,this.mSpelledCharacters);
                     break;
                  case LocationInputPath.SPELL_STREET_SECOND:
                     loc.addEisString(this.mStreetListed);
                     loc.addType(OpenNavUtilities.c_EIS_ITR,this.mSpelledCharacters);
                     break;
                  default:
                     Framework.Trace("LocationInputController.requestStreetSpeller: Illegal path flow! ENTER_INTERSECTION (" + this.toStringPathHistory() + ")");
               }
               break;
            case LocationInputPath.ENTER_CITYCENTER:
            case LocationInputPath.ENTER_CLOSESTCITIES:
            default:
               Framework.Trace("requestStreetSpeller: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestHouseNumberSpeller() : void
      {
         var rtn:Object = null;
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountry);
         if(this.mDefaultState != "")
         {
            loc.addEisString(this.mDefaultState);
         }
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_ECE:
               if(this.mZipCodeListed != "")
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,EisHelper.getValueFromEisPair(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_ZIP_NNG,EisHelper.getLastValueFromEisString(this.mZipCodeListed));
                  rtn = OpenNavUtilities.f_ParseEisString(this.mStreetListed);
                  if(rtn != null)
                  {
                     if(rtn.hasOwnProperty(OpenNavUtilities.c_EIS_STR_N))
                     {
                        loc.addType(OpenNavUtilities.c_EIS_STR,rtn[OpenNavUtilities.c_EIS_STR_N]);
                     }
                     if(rtn.hasOwnProperty(OpenNavUtilities.c_EIS_STR_NNG_N))
                     {
                        loc.addType(OpenNavUtilities.c_EIS_STR_NNG,rtn[OpenNavUtilities.c_EIS_STR_NNG_N]);
                     }
                  }
                  loc.addType(OpenNavUtilities.c_EIS_HNO,this.mSpelledCharacters);
                  NavigationApi.api.liGetSpell(loc);
                  return;
               }
               if(this.mDefaultCity == "")
               {
                  Framework.Trace("LocationInputController.requestHouseNumberSpeller: Empty mDefaultCity found!");
               }
               loc.addEisString(this.mDefaultCity);
               break;
            case LocationInputPath.ENTER_ADDRESS_US:
               if(EisHelper.getValueOfType(this.mStreetListed,OpenNavUtilities.c_EIS_CTY_NNG) == "")
               {
                  if(EisHelper.getValueOfType(this.mCityListed,OpenNavUtilities.c_EIS_CTY_NNG) == "" && EisHelper.getValueOfType(this.mDefaultCity,OpenNavUtilities.c_EIS_CTY_NNG) == "")
                  {
                     Framework.Trace("LocationInputController.requestHouseNumberSpeller: no <CTY_NNG> found for SPELL_HOUSENUMBER");
                  }
                  else if(this.mCityListed != "")
                  {
                     loc.addEisString(this.mCityListed);
                  }
                  else
                  {
                     loc.addEisString(this.mDefaultCity);
                  }
               }
               break;
            default:
               Framework.Trace("LocationInputController.requestHouseNumberSpeller: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         loc.addEisString(this.mStreetListed);
         loc.addType(OpenNavUtilities.c_EIS_HNO,this.mSpelledCharacters);
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestCountryList() : void
      {
         this.mDefaultCountryTemporary = "";
         this.sendEvent(LocationInputEvent.LI_DEFAULT_COUNTRY_TEMP);
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addType(OpenNavUtilities.c_EIS_CTR,this.mCountrySpelled);
         NavigationApi.api.liGetList(loc,this.mListCurrentPage_country * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.DEFAULT);
      }
      
      private function requestStateList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountryTemporary);
         loc.addType(OpenNavUtilities.c_EIS_STA,this.mStateSpelled);
         NavigationApi.api.liGetList(loc,this.mListCurrentPage_state * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.DEFAULT);
      }
      
      private function requestClosestCitiesList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         Framework.Trace("Nav.LI.requestClosestCitiesList() Fetch GEO-Coordinate:" + NavigationApi.api.posPositionInformation.getType("<GEO>"));
         loc.addType(OpenNavUtilities.c_EIS_GEO,NavigationApi.api.posPositionInformation.getType("<GEO>"));
         loc.addType(OpenNavUtilities.c_EIS_CTY,"");
         NavigationApi.api.liGetList(loc,this.mListCurrentPage_city * this.mListSizePerPage + 1,NavGlobalSettings.LIST_SIZE_CLOSEST_CITIES,SortOption.NEAR_FIRST);
      }
      
      private function requestCityList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         if(this.getPathHistoryItem(1) != LocationInputPath.ENTER_CITYCENTER)
         {
            loc.addEisString(this.mDefaultCountry);
            if(this.mDefaultState != "")
            {
               loc.addEisString(this.mDefaultState);
            }
         }
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_ECE:
            case LocationInputPath.ENTER_ADDRESS_US:
            case LocationInputPath.ENTER_INTERSECTION_ECE:
            case LocationInputPath.ENTER_INTERSECTION_US:
               if(this.mStreetListed != "")
               {
                  loc.addEisString(this.mStreetListed);
               }
               loc.addType(OpenNavUtilities.c_EIS_CTY,this.mCitySpelled);
               break;
            case LocationInputPath.ENTER_CITYCENTER:
               loc.addType(OpenNavUtilities.c_EIS_CTY,this.mCitySpelled);
               break;
            case LocationInputPath.ENTER_CLOSESTCITIES:
            default:
               Framework.Trace("LocationInputController.requestCityList: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         if(this.getPathHistoryItem(1) == LocationInputPath.ENTER_CITYCENTER)
         {
            NavigationApi.api.liGetListRequestFields(loc,this.mListCurrentPage_city * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.DEFAULT,"\"<CTR>\",\"<STA>\",\"<CTY>\"");
         }
         else if(EisHelper.getValueOfType(this.mDefaultState,OpenNavUtilities.c_EIS_STA) == "<All States>")
         {
            loc.removeType(OpenNavUtilities.c_EIS_STA);
            loc.removeType(OpenNavUtilities.c_EIS_STA_NNG);
            NavigationApi.api.liGetListRequestFields(loc,this.mListCurrentPage_city * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.ASCENDING,"\"<CTR>\",\"<STA>\",\"<CTY>\"");
         }
         else
         {
            NavigationApi.api.liGetList(loc,this.mListCurrentPage_city * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.ASCENDING);
         }
      }
      
      private function requestZipCodeList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountry);
         if(this.mDefaultState != "")
         {
            loc.addEisString(this.mDefaultState);
         }
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_ECE:
            case LocationInputPath.ENTER_INTERSECTION_ECE:
               loc.addType(OpenNavUtilities.c_EIS_ZIP,this.mZipCodeSpelled);
               break;
            default:
               Framework.Trace("LocationInputController.requestStreetList: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.SPELL_ZIPCODE:
            case LocationInputPath.LIST_ZIPCODE:
               NavigationApi.api.liGetList(loc,1,this.mListSizePerPage,SortOption.DEFAULT);
               break;
            default:
               Framework.Trace("LocationInputController.requestZipCodeList: Illegal LastPathHistoryItem! (" + this.toStringPathHistory() + ")");
         }
      }
      
      private function requestStreetList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountry);
         if(this.mDefaultState != "")
         {
            loc.addEisString(this.mDefaultState);
         }
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_US:
               if(this.mCityListed != "")
               {
                  loc.addEisString(this.mCityListed);
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               break;
            case LocationInputPath.ENTER_ADDRESS_ECE:
               if(this.mZipCodeListed != "")
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,EisHelper.getValueFromEisPair(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_ZIP_NNG,EisHelper.getLastValueFromEisString(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               else
               {
                  if(this.mDefaultCity != "")
                  {
                     loc.addEisString(this.mDefaultCity);
                  }
                  loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
               }
               break;
            case LocationInputPath.ENTER_INTERSECTION_ECE:
               if(this.mZipCodeListed != "")
               {
                  loc.addType(OpenNavUtilities.c_EIS_ZIP,EisHelper.getValueFromEisPair(this.mZipCodeListed));
                  loc.addType(OpenNavUtilities.c_EIS_ZIP_NNG,EisHelper.getLastValueFromEisString(this.mZipCodeListed));
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               switch(this.getLastPathHistoryItem())
               {
                  case LocationInputPath.LIST_STREET:
                     loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
                     break;
                  case LocationInputPath.LIST_STREET_SECOND:
                     loc.addEisString(this.mStreetListed);
                     loc.addType(OpenNavUtilities.c_EIS_ITR,this.mStreetSecondSpelled);
                     break;
                  default:
                     Framework.Trace("LocationInputController.requestStreetList: Unsupported flow: ENTER_INTERSECTION - " + this.getLastPathHistoryItem());
               }
               break;
            case LocationInputPath.ENTER_INTERSECTION_US:
               if(this.mCityListed != "")
               {
                  loc.addEisString(this.mCityListed);
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               switch(this.getLastPathHistoryItem())
               {
                  case LocationInputPath.LIST_STREET:
                     loc.addType(OpenNavUtilities.c_EIS_STR,this.mStreetSpelled);
                     break;
                  case LocationInputPath.LIST_STREET_SECOND:
                     loc.addEisString(this.mStreetListed);
                     loc.addType(OpenNavUtilities.c_EIS_ITR,this.mStreetSecondSpelled);
                     break;
                  default:
                     Framework.Trace("LocationInputController.requestStreetList: Unsupported flow: ENTER_INTERSECTION - " + this.getLastPathHistoryItem());
               }
               break;
            case LocationInputPath.ENTER_CITYCENTER:
            default:
               Framework.Trace("LocationInputController.requestStreetList: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         switch(this.getLastPathHistoryItem())
         {
            case LocationInputPath.LIST_STREET:
               NavigationApi.api.liGetList(loc,this.mListCurrentPage_street * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.DEFAULT);
               break;
            case LocationInputPath.LIST_STREET_SECOND:
               NavigationApi.api.liGetList(loc,this.mListCurrentPage_street_second * this.mListSizePerPage + 1,this.mListSizePerPage,SortOption.DEFAULT);
               break;
            default:
               Framework.Trace("LocationInputController.requestStreetList: Illegal LastPathHistoryItem! (" + this.toStringPathHistory() + ")");
         }
      }
      
      private function requestZipCodeSpeller() : void
      {
         Framework.Trace("requestZipCodeSpeller");
         var loc:LocationDetails = new LocationDetails();
         loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
         loc.addEisString(this.mDefaultCountry);
         if(this.mDefaultState != "")
         {
            loc.addEisString(this.mDefaultState);
         }
         this.mZipCodeSpelled = this.mSpelledCharacters;
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_ECE:
               break;
            default:
               Framework.Trace("LocationInputController.requestZipCodeSpeller: Illegal path flow! (" + this.toStringPathHistory() + ")");
         }
         loc.addType(OpenNavUtilities.c_EIS_ZIP,this.mZipCodeSpelled);
         NavigationApi.api.liGetSpell(loc);
      }
      
      private function requestHouseNumberRefinement() : void
      {
         var loc:LocationDetails = null;
         switch(this.getPathHistoryItem(1))
         {
            case LocationInputPath.ENTER_ADDRESS_ECE:
            case LocationInputPath.ENTER_ADDRESS_US:
               loc = new LocationDetails();
               loc.addType(OpenNavUtilities.c_EIS_IFT,"LI");
               loc.addEisString(this.mDefaultCountry);
               if(this.mDefaultState != "")
               {
                  loc.addEisString(this.mDefaultState);
               }
               if(this.mCityListed != "")
               {
                  loc.addEisString(this.mCityListed);
               }
               else if(this.mDefaultCity != "")
               {
                  loc.addEisString(this.mDefaultCity);
               }
               if(this.mStreetListed != "")
               {
                  loc.addEisString(this.mStreetListed);
               }
               if(this.mZipCodeListed != "")
               {
                  loc.addEisString(this.mZipCodeListed);
               }
               loc.addType(OpenNavUtilities.c_EIS_HNO,this.mHouseNumberSpelled);
               NavigationApi.api.liGetList(loc,1,this.mListSizePerPage,SortOption.DEFAULT);
               break;
            default:
               Framework.Trace("LocationInputController.requestHouseNumberRefinement: Illegal LastPathHistoryItem! (" + this.toStringPathHistory() + ")");
         }
      }
      
      private function isZipFilled(zipcode:String) : Boolean
      {
         return zipcode != "";
      }
      
      private function isFullUKZipCode(cabData:String, zip:String) : Boolean
      {
         var temp:Array = null;
         var tempZip:String = null;
         var rtn:Object = OpenNavUtilities.f_ParseEisString(zip);
         var zipSource:String = "";
         if(rtn != null && rtn.hasOwnProperty(OpenNavUtilities.c_EIS_ZIP_N))
         {
            zipSource = rtn[OpenNavUtilities.c_EIS_ZIP_N];
         }
         if(cabData != null && cabData == "GBR" && zipSource != null)
         {
            temp = zipSource.split(" ");
            tempZip = String(temp[1]);
            if(tempZip != null && tempZip.length >= 2)
            {
               return true;
            }
         }
         return false;
      }
      
      private function fullZipCode(bIsSpell:Boolean = true) : int
      {
         var loc:LocationDetails = this.buildLoc();
         if(bIsSpell)
         {
            if(this.mSpell.count == 0 && this.mSpell.eisString == "" && this.mSpell.fullMatch == false)
            {
               if(this.isFullUKZipCode(loc.getType(OpenNavUtilities.c_EIS_CAB),this.mZipCodeListed) == true)
               {
                  if(this.isZipFilled(this.mZipCodeListed))
                  {
                     return BRITAIN_FULL_ZIP_CODE;
                  }
               }
               return NO_ZIP_CODE;
            }
            if(this.mSpell.count <= 1)
            {
               if(this.isFullUKZipCode(loc.getType(OpenNavUtilities.c_EIS_CAB),this.mZipCodeListed) == true)
               {
                  if(this.isZipFilled(this.mZipCodeListed))
                  {
                     return BRITAIN_FULL_ZIP_CODE;
                  }
               }
               return FULL_ZIP_CODE;
            }
            if(this.mSpell.count > 1)
            {
               return NOT_FULL_ZIP_CODE;
            }
            return NO_ZIP_CODE;
         }
         if(this.isFullUKZipCode(loc.getType(OpenNavUtilities.c_EIS_CAB),this.mZipCodeListed) == true)
         {
            if(this.isZipFilled(this.mZipCodeListed))
            {
               return BRITAIN_FULL_ZIP_CODE;
            }
         }
         return FULL_ZIP_CODE;
      }
      
      private function buildLoc() : LocationDetails
      {
         var loc:LocationDetails = new LocationDetails();
         if(this.getPathHistoryItem(1) != LocationInputPath.ENTER_CITYCENTER)
         {
            if(this.getPathHistoryItem(1) != LocationInputPath.ENTER_CLOSESTCITIES)
            {
               if(this.mDefaultCountry != "")
               {
                  loc.addEisString(this.mDefaultCountry);
               }
               if(this.mDefaultState != "")
               {
                  loc.addEisString(this.mDefaultState);
               }
            }
         }
         return loc;
      }
      
      private function assembleDescription() : void
      {
         Framework.Trace("assembleDescription()\nASSEMBLE: " + this.mDefaultCountry + " | " + this.mDefaultState + " | " + this.mCitySpelled + " | " + this.mCityListed + " | " + this.mStreetSpelled + " | " + this.mStreetListed + " | " + this.mStreetSecondSpelled + " | " + this.mStreetSecondListed + " | " + this.mHouseNumberRefined + " | " + this.mZipCodeSpelled + " | " + this.mZipCodeListed + " END ");
         var loc:LocationDetails = this.buildLoc();
         if(this.mCityListed != "")
         {
            loc.addEisString(this.adjustCityString(this.mCityListed));
         }
         else if(this.mDefaultCity != "")
         {
            loc.addEisString(this.adjustCityString(this.mDefaultCity));
         }
         if(this.mZipCodeListed != "")
         {
            loc.addEisString(this.mZipCodeListed);
         }
         if(this.mStreetListed != "")
         {
            loc.addEisString(this.mStreetListed);
         }
         if(this.mStreetSecondListed != "")
         {
            loc.addEisString(this.mStreetSecondListed);
         }
         if(this.mHouseNumberSpelled != "")
         {
            loc.addEisString(this.mHouseNumberRefined);
         }
         this.mLocationDescription = new LocationDescription();
         this.mLocationDescription.setPrimaryLocation(loc);
         NavigationApi.api.liGetDetails(loc.toEIS());
      }
      
      private function adjustCityString(str:String) : String
      {
         var newCty:String = null;
         var oldCty:String = null;
         var ret:String = str;
         if(str.indexOf(OpenNavUtilities.c_EIS_CTY) != -1 && str.indexOf(OpenNavUtilities.c_EIS_REF) != -1 && EisHelper.getValueOfType(str,OpenNavUtilities.c_EIS_REF) != "")
         {
            newCty = OpenNavUtilities.c_EIS_CTY + EisHelper.getValueOfType(str,OpenNavUtilities.c_EIS_CTY) + ", " + EisHelper.getValueOfType(str,OpenNavUtilities.c_EIS_REF) + OpenNavUtilities.c_EIS_TOKEN_END;
            oldCty = OpenNavUtilities.c_EIS_CTY + EisHelper.getValueOfType(str,OpenNavUtilities.c_EIS_CTY) + OpenNavUtilities.c_EIS_TOKEN_END;
            ret = str.replace(oldCty,newCty);
         }
         return ret;
      }
   }
}

