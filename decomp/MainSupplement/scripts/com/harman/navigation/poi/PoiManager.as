package com.harman.navigation.poi
{
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.harman.navigation.enums.SortOption;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.framework.global.Framework;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class PoiManager
   {
      
      private static const CHARACTERS_INVALIDATED:String = "_characters_invalidated_";
      
      private static const GET_CATEGORIES:String = "<CAT><*>";
      
      private static const GET_POI_START_TAG:String = "<POI>";
      
      private static const GET_POI_PHONE_TAG:String = "<TEL>";
      
      private static const GET_END_TAG:String = "<*>";
      
      private static const REQUEST_TYPE_NAME:String = "<RQT>Name<*>";
      
      private static const REQUEST_TYPE_CATEGORY:String = "<RQT>Category<*>";
      
      private static const REQUEST_TYPE_PRESET:String = "<RQT>Preset<*>";
      
      private static const REQUEST_TYPE_PHONE:String = "<RQT>Phone<*>";
      
      private static const REQUEST_LIST_OPTIONS_STD_ALL:String = "\"inresultCount\":999,\"insortOption\":0,\"instartIndex\":1,\"cancelPreviousRequest\":true";
      
      private static const REQUEST_DETAILS_OPTIONS_ALL:String = "\"requestedFields\":[\"<ALL>\"]";
      
      private static const SORTOPTIONS_NEAR_FIRST:String = "\"insortOption\":4";
      
      private static const BY_NAME_WORKAROUND:String = "ByName";
      
      private var mNavService:Navigation;
      
      private var mLocalPoiSearchAreaDefault:int = 1;
      
      private var mLocalPoiSearchAreaCurrent:int = 0;
      
      private var mLocalPoiSearchAreaRestriction:Boolean = false;
      
      private var mLocalPoiSearchCity:LocationDescription = new LocationDescription();
      
      private var mLocalPoiSearchNearDestination:LocationDescription = new LocationDescription();
      
      private var mLocalPoiSearchCategory:String = new String();
      
      private var mLocalPoiSearchCategories:Array = new Array();
      
      private var mLocalCharactersEntered:String = new String();
      
      private var mLocalCharactersAvailable:String = new String();
      
      private var mLocalDescriptionDetails:LocationDetails = new LocationDetails();
      
      private var mLocalListCount:int = 0;
      
      private var mLocalCatListCount:int = 0;
      
      private var mLocalTelListCount:int = 0;
      
      private var mRequestID:int = 0;
      
      private var mRequestQueue:Array = new Array();
      
      private var mLocalList:Array = new Array();
      
      private var mLocalPresets:Array = new Array();
      
      private var mLocalSpellerInfo:SpellerInfo = new SpellerInfo();
      
      private var mLastGetListRequest:String = "";
      
      private var mTimeoutInterval:uint = 0;
      
      private const GET_LIST_TIMEOUT:int = 30500;
      
      private var mSortOption:int = SortOption.NEAR_FIRST;
      
      public function PoiManager(naviService:Navigation)
      {
         super();
         PersistenceApi.impl = PersistenceImpl.create();
         this.mNavService = naviService;
         this.init();
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onRouteGuidanceActive,false,0,true);
         NavigationPackage.peripheral.navigation.navRouteCalculation.getActiveRouteGuidanceState();
      }
      
      private function onRouteGuidanceActive(e:RouteCalculationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            this.mLocalPoiSearchAreaRestriction = false;
            this.mLocalPoiSearchAreaCurrent = this.mLocalPoiSearchAreaDefault;
         }
         else
         {
            this.mLocalPoiSearchAreaRestriction = true;
            if(this.mLocalPoiSearchAreaDefault == PoiSearchArea.NEAR_DESTINATION || this.mLocalPoiSearchAreaDefault == PoiSearchArea.ALONG_ROUTE)
            {
               this.mLocalPoiSearchAreaCurrent = PoiSearchArea.AROUND_ME;
            }
            else
            {
               this.mLocalPoiSearchAreaCurrent = this.mLocalPoiSearchAreaDefault;
            }
            this.mLocalPoiSearchNearDestination = new LocationDescription();
            this.mNavService.sendEvent(NavigationEvent.POI_SEARCH_NEAR_DESTINATION);
         }
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCHAREA_CURRENT);
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCHAREA_RESTRICTION);
      }
      
      public function poiSetSearchAreaDefault(area:int) : void
      {
         Framework.Trace("PoiManager.setPoiSearchArea: " + PoiSearchArea.toString(area));
         this.mLocalPoiSearchAreaDefault = area;
         this.persistData();
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_SEARCHAREA_DEFAULT));
         NavigationPackage.peripheral.navigation.navRouteCalculation.getActiveRouteGuidanceState();
      }
      
      public function poiGetSearchAreaDefault() : void
      {
         Framework.Trace("PoiManager.poiGetSearchAreaDefault()");
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_SEARCHAREA_DEFAULT));
      }
      
      public function poiSearchAreaDefault() : int
      {
         return this.mLocalPoiSearchAreaDefault;
      }
      
      public function poiGetSearchAreaCurrent() : void
      {
         NavigationPackage.peripheral.navigation.navRouteCalculation.getActiveRouteGuidanceState();
      }
      
      public function poiSearchAreaCurrent() : int
      {
         return this.mLocalPoiSearchAreaCurrent;
      }
      
      public function poiGetSearchAreaRestriction() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCHAREA_RESTRICTION);
      }
      
      public function poiSearchAreaRestriction() : Boolean
      {
         return this.mLocalPoiSearchAreaRestriction;
      }
      
      public function poiSetSearchCity(loc:LocationDescription) : void
      {
         Framework.Trace("PoiManager.poiSetSearchCity: " + loc.getSecondaryLocation().toEIS());
         this.mLocalPoiSearchCity = loc;
         this.persistData();
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCH_CITY);
      }
      
      public function poiGetSearchCity() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCH_CITY);
      }
      
      public function poiSearchCity() : LocationDescription
      {
         return this.mLocalPoiSearchCity;
      }
      
      public function poiSetSearchNearDestination(loc:LocationDescription) : void
      {
         Framework.Trace("PoiManager.poiSetSearchNearDestination( " + this.mLocalPoiSearchNearDestination.getSecondaryLocation().getType("<GEO>") + " )");
         this.mLocalPoiSearchNearDestination = loc;
      }
      
      public function poiGetSearchNearDestination() : void
      {
         this.mNavService.sendEvent(NavigationEvent.POI_SEARCH_NEAR_DESTINATION);
      }
      
      public function get poiSearchNearDestination() : LocationDescription
      {
         return this.mLocalPoiSearchNearDestination;
      }
      
      public function poiSelectCharacter(char:String) : void
      {
         Framework.Trace("PoiManager.selectCharacter( " + char + " )");
         this.mLocalCharactersEntered += char;
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSENTERED));
      }
      
      public function poiRemoveLastCharacter() : void
      {
         Framework.Trace("PoiManager.removeLastCharacter()");
         this.mLocalCharactersEntered = this.mLocalCharactersEntered.substr(0,this.mLocalCharactersEntered.length - 1);
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSENTERED));
      }
      
      public function poiClearInput() : void
      {
         Framework.Trace("PoiManager.clearInput()");
         this.mLocalCharactersEntered = "";
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSENTERED));
      }
      
      public function poiGetCharactersEntered() : void
      {
         Framework.Trace("PoiManager.getCharactersEntered()");
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSENTERED));
      }
      
      public function poiCharactersEntered() : String
      {
         if(this.mLocalCharactersEntered == CHARACTERS_INVALIDATED)
         {
            return "";
         }
         return this.mLocalCharactersEntered;
      }
      
      public function poiGetCharactersAvailable() : void
      {
         Framework.Trace("PoiManager.getCharactersAvailable()");
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSAVAILABLE));
      }
      
      public function poiCharactersAvailable() : String
      {
         return this.mLocalCharactersAvailable;
      }
      
      private function trackNavRequest(reqMsg:String) : int
      {
         var req:PoiRequestRecord = new PoiRequestRecord(reqMsg);
         this.mRequestQueue.push(req);
         return req.id;
      }
      
      private function resolveNavRequest(msg:String) : PoiRequestRecord
      {
         var req:PoiRequestRecord = null;
         for(var k:int = 0; k < this.mRequestQueue.length; k++)
         {
            req = this.mRequestQueue[k];
            if(msg.toLowerCase() == req.mesg.toLowerCase())
            {
               this.mRequestQueue.splice(k,1);
               return req;
            }
         }
         return null;
      }
      
      private function resolveNavRequestId(msg:String) : int
      {
         var req:PoiRequestRecord = this.resolveNavRequest(msg);
         if(req != null)
         {
            return req.id;
         }
         return -1;
      }
      
      public function poiGetList(startIndex:int, count:int, bForceNameRQT:Boolean = false) : int
      {
         var reqId:int = 0;
         if(startIndex <= 0)
         {
            Framework.Trace("PoiManager.poiGetList() Requesting List with startIndex \"" + startIndex + "\" is not allowed!!! >=1 only!");
         }
         Framework.Trace("PoiManager.getPoiList( " + startIndex + ", " + count + " )");
         var reqEIS:String = "<IFT>POI<*>" + (bForceNameRQT ? REQUEST_TYPE_NAME : this.getRequestType()) + (this.mLocalPoiSearchAreaCurrent == PoiSearchArea.ALONG_ROUTE ? this.getActiveRouteHandle() : "") + "<GEOC>" + this.getSearchAreaPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + this.getRequestCategory() + "<POI>" + this.mNavService.performDoubleQuoteCheck(this.mLocalCharactersEntered) + "<*>";
         this.mLastGetListRequest = "\"Info_GetList\":{\"inputEIS\":\"" + reqEIS + "\"" + ",\"inresultCount\":" + count + "," + SORTOPTIONS_NEAR_FIRST + ",\"instartIndex\":" + startIndex + ",\"cancelPreviousRequest\":true}";
         reqId = this.trackNavRequest(reqEIS);
         clearInterval(this.mTimeoutInterval);
         this.mTimeoutInterval = setInterval(this.onGetListTimeout,this.GET_LIST_TIMEOUT);
         this.mNavService.sendCommand(this.mLastGetListRequest);
         return reqId;
      }
      
      private function onGetListTimeout() : void
      {
         Framework.Trace("PoiManager.onGetListTimeout() ReRequest getPoiList() ");
         clearInterval(this.mTimeoutInterval);
         this.mNavService.sendCommand(this.mLastGetListRequest);
      }
      
      public function poiStopReRequest() : void
      {
         Framework.Trace("PoiManager.poiStopReRequest() ");
         clearInterval(this.mTimeoutInterval);
      }
      
      public function poiGetPresetList(presetGroupName:String) : int
      {
         this.mLocalCharactersEntered = CHARACTERS_INVALIDATED;
         this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_CHARSENTERED));
         var reqEIS:String = "<IFT>POI<*>" + REQUEST_TYPE_PRESET + "<PRE>" + this.mNavService.performDoubleQuoteCheck(presetGroupName) + "<*>" + (this.mLocalPoiSearchAreaCurrent == PoiSearchArea.ALONG_ROUTE ? this.getActiveRouteHandle() : "") + "<GEOC>" + this.getSearchAreaPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + "<POI><*>";
         var reqMsg:String = "\"Info_GetList\":{\"inputEIS\":\"" + reqEIS + "\"" + ",\"inresultCount\":" + NavGlobalSettings.POI_PRESET_LIST_SIZE + "," + SORTOPTIONS_NEAR_FIRST + ",\"instartIndex\":" + 1 + ",\"cancelPreviousRequest\":false}";
         var reqId:int = this.trackNavRequest(reqEIS);
         this.mNavService.sendCommand(reqMsg);
         return reqId;
      }
      
      public function poiList() : Array
      {
         return this.mLocalList;
      }
      
      public function poiGetListCounts(catEIS:String) : void
      {
         Framework.Trace("PoiManager.getPoiListCount()");
         this.mNavService.sendCommand("\"Info_GetAvailableInformation\":{\"inputEIS\":\"<IFT>POI<*>" + this.getRequestType() + "<GEOC>" + this.getSearchAreaPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + catEIS + "\"}");
      }
      
      public function poiGetListCount() : void
      {
         Framework.Trace("PoiManager.getPoiListCount()");
         this.mNavService.sendCommand("\"Info_GetAvailableInformation\":{\"inputEIS\":\"<IFT>POI<*>" + this.getRequestType() + "<GEOC>" + this.getSearchAreaPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + this.getRequestCategory() + "<POI>" + this.mNavService.performDoubleQuoteCheck(this.mLocalCharactersEntered) + "<*>" + "\"}");
      }
      
      private function getRequestType() : String
      {
         if(this.mLocalPoiSearchCategory == BY_NAME_WORKAROUND)
         {
            return REQUEST_TYPE_NAME;
         }
         return REQUEST_TYPE_CATEGORY;
      }
      
      private function getRequestCategory() : String
      {
         if(this.mLocalPoiSearchCategory == BY_NAME_WORKAROUND)
         {
            return "";
         }
         return this.mLocalPoiSearchCategory;
      }
      
      private function getCurrentPosition() : String
      {
         if(this.mNavService.posPositionInformation.getType("<GEO>") != "")
         {
            return this.mNavService.posPositionInformation.getType("<GEO>");
         }
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
               return "+009.990288 +53.560802";
            case VServiceGlobalSettings.MARKET_ROW:
               return "+009.990288 +53.560802";
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
         }
         return "-083.431027 +042.496383";
      }
      
      private function getActiveRouteHandle() : String
      {
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute != null && NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeHandle != -1)
         {
            return "<RTH>" + NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeHandle + "<*>";
         }
         return "";
      }
      
      private function getSearchAreaPosition() : String
      {
         var geo:String = null;
         switch(this.mLocalPoiSearchAreaCurrent)
         {
            case PoiSearchArea.AROUND_ME:
               return this.getCurrentPosition();
            case PoiSearchArea.IN_A_CITY:
               return this.mLocalPoiSearchCity.getSecondaryLocation().getType("<GEO>");
            case PoiSearchArea.NEAR_DESTINATION:
               geo = this.mLocalPoiSearchNearDestination.getSecondaryLocation().getType("<GEO>");
               if(geo != "")
               {
                  return geo;
               }
               this.getCurrentPosition();
               break;
            case PoiSearchArea.ALONG_ROUTE:
               return this.getCurrentPosition();
         }
         return new String();
      }
      
      public function poiListCount() : int
      {
         return this.mLocalListCount;
      }
      
      public function poiCatListCount() : int
      {
         return this.mLocalCatListCount;
      }
      
      public function poiSelectListItem(position:int) : void
      {
         Framework.Trace("PoiManager.selectPoiListItem( " + position + " )");
      }
      
      public function poiSetSearchCategory(category:String) : void
      {
         if(category == BY_NAME_WORKAROUND)
         {
            this.mLocalPoiSearchCategory = category;
         }
         else
         {
            this.mLocalPoiSearchCategory = category;
         }
      }
      
      public function poiGetSearchCategories(category:String) : int
      {
         Framework.Trace("PoiManager.poiGetSearchCategories");
         var reqEIS:String = "<IFT>POI<*>" + (category == "" ? "<IRES>" + NavGlobalSettings.POI_MAIN_CATEGORY_ICON_SIZE + "<*>" : "") + REQUEST_TYPE_CATEGORY + (this.mLocalPoiSearchAreaCurrent == PoiSearchArea.ALONG_ROUTE ? this.getActiveRouteHandle() : "") + "<GEOC>" + this.getSearchAreaPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + category + GET_CATEGORIES;
         var reqMsg:String = "\"Info_GetList\":{\"inputEIS\":\"" + reqEIS + "\"," + REQUEST_LIST_OPTIONS_STD_ALL + "}";
         var reqId:int = this.trackNavRequest(reqEIS);
         this.mNavService.sendCommand(reqMsg);
         return reqId;
      }
      
      public function poiSearchCategories() : Array
      {
         return this.mLocalPoiSearchCategories;
      }
      
      public function poiGetDetails(eisString:String) : int
      {
         var reqEIS:String = "<IFT>POI<*>" + this.mNavService.performDoubleQuoteCheck(eisString);
         var reqMsg:String = "\"Info_GetDetails\":{\"inputEIS\":\"" + reqEIS + "\"," + REQUEST_DETAILS_OPTIONS_ALL + "}";
         var reqId:int = this.trackNavRequest(reqEIS);
         this.mNavService.sendCommand(reqMsg);
         return reqId;
      }
      
      public function poiDetails() : LocationDetails
      {
         return this.mLocalDescriptionDetails;
      }
      
      public function poiPresets() : Array
      {
         return this.mLocalPresets;
      }
      
      public function poiGetPhoneNumberSpell() : void
      {
         Framework.Trace("PoiManager.poiGetPhoneNumberSpell( " + this.mLocalCharactersEntered + ")");
         this.mNavService.sendCommand("\"Info_GetSpell\":{\"inputEIS\":\"<IFT>POI<*>" + REQUEST_TYPE_PHONE + "<GEOC>" + this.getCurrentPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + "<TEL>" + this.mNavService.performDoubleQuoteCheck(this.mLocalCharactersEntered) + "<*>" + "\"}");
      }
      
      public function poiPhoneNumberSpell() : SpellerInfo
      {
         return this.mLocalSpellerInfo;
      }
      
      public function poiGetPhoneNumberList() : int
      {
         Framework.Trace("PoiManager.poiGetPhoneNumberList( " + this.mLocalCharactersEntered + ")");
         var reqEIS:String = "<IFT>POI<*>" + REQUEST_TYPE_PHONE + "<GEOC>" + this.getCurrentPosition() + "<*>" + "<GEOS>" + this.getCurrentPosition() + "<*>" + "<TEL>" + this.mNavService.performDoubleQuoteCheck(this.mLocalCharactersEntered) + "<*>";
         var reqMsg:String = "\"Info_GetList\":{\"inputEIS\":\"" + reqEIS + "\"" + ",\"inresultCount\":30" + "," + SORTOPTIONS_NEAR_FIRST + ",\"instartIndex\":1" + ",\"cancelPreviousRequest\":true}";
         var reqId:int = this.trackNavRequest(reqEIS);
         this.mNavService.sendCommand(reqMsg);
         return reqId;
      }
      
      public function poiGetSortOption() : int
      {
         return this.mSortOption;
      }
      
      public function setResponseInfo(resp:Object) : void
      {
         var i:int = 0;
         var requestEisType:String = null;
         var k:int = 0;
         var responseEisType:String = null;
         var cnt:int = 0;
         var loc:LocationDetails = null;
         var locDet:LocationDetails = null;
         var loc2:LocationDetails = null;
         Framework.Trace("PoiManager.setResponseInfo");
         var reqId:int = -1;
         if(resp.hasOwnProperty("Info_GetAvailableInformation"))
         {
            Framework.Trace("\n\nInfo_GetAvailableInformation");
            if(resp.Info_GetAvailableInformation.hasOwnProperty("availableTypes"))
            {
               for(i = 0; i < resp.Info_GetAvailableInformation.availableTypes.length; i++)
               {
                  Framework.Trace("availableTypes[" + i + "]: " + resp.Info_GetAvailableInformation.availableTypes[i]);
               }
               requestEisType = EisHelper.getLastTypeFromEisString(resp.Info_GetAvailableInformation.respEIS);
               this.mLocalCatListCount = 0;
               this.mLocalListCount = 0;
               this.mLocalTelListCount = 0;
               if(resp.Info_GetAvailableInformation.availableTypes.length > 0)
               {
                  for(k = 0; k < resp.Info_GetAvailableInformation.availableTypes.length; k++)
                  {
                     responseEisType = EisHelper.getTypeFromEisPair(resp.Info_GetAvailableInformation.availableTypes[k]);
                     cnt = int(EisHelper.getValueFromEisPair(resp.Info_GetAvailableInformation.availableTypes[k]));
                     switch(responseEisType)
                     {
                        case "POI":
                           this.mLocalListCount = cnt;
                           break;
                        case "CAT":
                           this.mLocalCatListCount = cnt;
                           break;
                        case "TEL":
                           this.mLocalTelListCount = cnt;
                           break;
                        default:
                           Framework.Trace("Unhandled count type.");
                     }
                  }
               }
               this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_LISTCOUNT));
               return;
            }
         }
         if(resp.hasOwnProperty("Info_GetDetails"))
         {
            Framework.Trace("Info_GetDetails");
            if(resp.Info_GetDetails.hasOwnProperty("respEIS"))
            {
               Framework.Trace("respEIS" + resp.Info_GetDetails.respEIS);
               reqId = this.resolveNavRequestId(String(resp.Info_GetDetails.respEIS));
            }
            if(resp.Info_GetDetails.hasOwnProperty("outputEIS"))
            {
               this.mLocalDescriptionDetails = new LocationDetails();
               this.mLocalDescriptionDetails.addEisString(resp.Info_GetDetails.outputEIS);
               this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_DETAILS,reqId));
            }
         }
         if(resp.hasOwnProperty("Info_GetList"))
         {
            Framework.Trace("\nInfo_GetList (" + resp.Info_GetList.itemList.length + ")");
            clearInterval(this.mTimeoutInterval);
            if(resp.Info_GetList.hasOwnProperty("respEIS"))
            {
               reqId = this.resolveNavRequestId(String(resp.Info_GetList.respEIS));
               if(String(resp.Info_GetList.respEIS).lastIndexOf(GET_CATEGORIES) + GET_CATEGORIES.length == String(resp.Info_GetList.respEIS).length)
               {
                  if(resp.Info_GetList.hasOwnProperty("itemList"))
                  {
                     if(resp.Info_GetList.itemList.hasOwnProperty("length"))
                     {
                        this.mLocalPoiSearchCategories = new Array();
                        for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                        {
                           this.mLocalPoiSearchCategories.push(resp.Info_GetList.itemList[i]);
                        }
                     }
                  }
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_SEARCHCATEGORIES,reqId));
                  return;
               }
               if(String(resp.Info_GetList.respEIS).lastIndexOf(GET_POI_START_TAG) + GET_POI_START_TAG.length + GET_END_TAG.length + this.mLocalCharactersEntered.length == String(resp.Info_GetList.respEIS).length)
               {
                  if(resp.Info_GetList.hasOwnProperty("itemList"))
                  {
                     if(resp.Info_GetList.itemList.hasOwnProperty("length"))
                     {
                        this.mLocalList.splice(0,this.mLocalList.length);
                        for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                        {
                           loc = new LocationDetails();
                           loc.addEisString(resp.Info_GetList.itemList[i]);
                           this.mLocalList.push(loc);
                        }
                     }
                     this.mSortOption = resp.Info_GetList.outsortOption;
                  }
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_LIST,reqId));
                  return;
               }
               if(String(resp.Info_GetList.respEIS).lastIndexOf(GET_POI_START_TAG) + GET_POI_START_TAG.length + GET_END_TAG.length == String(resp.Info_GetList.respEIS).length)
               {
                  if(resp.Info_GetList.hasOwnProperty("itemList"))
                  {
                     if(resp.Info_GetList.itemList.hasOwnProperty("length"))
                     {
                        this.mLocalPresets.splice(0,this.mLocalPresets.length);
                        for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                        {
                           locDet = new LocationDetails();
                           locDet.addEisString(resp.Info_GetList.itemList[i]);
                           this.mLocalPresets.push(locDet);
                        }
                     }
                     this.mSortOption = resp.Info_GetList.outsortOption;
                  }
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_PRESETS,reqId));
                  return;
               }
               if(String(resp.Info_GetList.respEIS).lastIndexOf(GET_POI_PHONE_TAG))
               {
                  if(resp.Info_GetList.hasOwnProperty("itemList"))
                  {
                     if(resp.Info_GetList.itemList.hasOwnProperty("length"))
                     {
                        this.mLocalList.splice(0,this.mLocalList.length);
                        for(i = 0; i < resp.Info_GetList.itemList.length; i++)
                        {
                           loc2 = new LocationDetails();
                           loc2.addEisString(resp.Info_GetList.itemList[i]);
                           this.mLocalList.push(loc2);
                        }
                     }
                  }
                  this.mNavService.dispatchEvent(new NavigationEvent(NavigationEvent.POI_LIST,reqId));
                  return;
               }
               Framework.Trace("UNTREATED RESPONSE: POIManager.Info_GetList");
               Framework.Trace("respEIS" + resp.Info_GetList.respEIS + " " + String(resp.Info_GetList.respEIS).lastIndexOf(GET_CATEGORIES) + " " + String(resp.Info_GetList.respEIS).length);
            }
         }
         if(resp.hasOwnProperty("Info_GetSpell"))
         {
            Framework.Trace("Info_GetSpell");
            if(resp.Info_GetSpell.hasOwnProperty("resultCode"))
            {
               if(resp.Info_GetSpell.resultCode == 2)
               {
                  this.mLocalSpellerInfo.setCount(45);
                  this.mLocalSpellerInfo.setCharacters("0123456789");
                  this.mLocalSpellerInfo.setFullMatch(false);
               }
               else
               {
                  if(resp.Info_GetSpell.hasOwnProperty("count"))
                  {
                     Framework.Trace("count: " + resp.Info_GetSpell.count);
                     this.mLocalSpellerInfo.setCount(int(resp.Info_GetSpell.count));
                  }
                  if(resp.Info_GetSpell.hasOwnProperty("nextAvailableCharacters"))
                  {
                     Framework.Trace("nextAvailableCharacters: " + resp.Info_GetSpell.nextAvailableCharacters);
                     this.mLocalSpellerInfo.setCharacters(String(resp.Info_GetSpell.nextAvailableCharacters));
                  }
                  if(resp.Info_GetSpell.hasOwnProperty("isFullMatch"))
                  {
                     Framework.Trace("isFullMatch: " + resp.Info_GetSpell.isFullMatch);
                     this.mLocalSpellerInfo.setFullMatch(String(resp.Info_GetSpell.isFullMatch) == "true" ? true : false);
                  }
               }
            }
            this.mNavService.sendEvent(NavigationEvent.POI_PHONE_NUMBER_SPELL);
         }
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var index:int = 0;
         var i:String = null;
         var locDes1:LocationDetails = null;
         var locDes2:LocationDetails = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.POI_SEARCH_AREA)
         {
            Framework.Trace("PoiManager.onPersistence()");
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.POI_SEARCH_AREA,true);
            if(res != null)
            {
               index = 0;
               for(i in res)
               {
                  if(i.indexOf("area") != -1)
                  {
                     this.mLocalPoiSearchAreaDefault = int(res[i]);
                     Framework.Trace("AREA:" + this.mLocalPoiSearchAreaDefault + " " + res[i]);
                  }
                  else if(i.indexOf("city_pri") != -1)
                  {
                     locDes1 = new LocationDetails();
                     locDes1.setFromPersistenceString(res[i]);
                     this.mLocalPoiSearchCity.setPrimaryLocation(locDes1);
                  }
                  else if(i.indexOf("city_sec") != -1)
                  {
                     locDes2 = new LocationDetails();
                     locDes2.setFromPersistenceString(res[i]);
                     this.mLocalPoiSearchCity.setSecondaryLocation(locDes2);
                  }
               }
               if(this.mLocalPoiSearchAreaDefault == PoiSearchArea.IN_A_CITY && this.mLocalPoiSearchCity.getSecondaryLocation().getType("<GEO>") == "")
               {
                  this.mLocalPoiSearchAreaDefault = PoiSearchArea.AROUND_ME;
               }
               this.mNavService.sendEvent(NavigationEvent.POI_SEARCHAREA_DEFAULT);
               this.mNavService.sendEvent(NavigationEvent.POI_SEARCHAREA_CURRENT);
               this.mNavService.sendEvent(NavigationEvent.POI_SEARCH_CITY);
            }
            else
            {
               this.mLocalPoiSearchAreaCurrent = this.mLocalPoiSearchAreaDefault = PoiSearchArea.AROUND_ME;
            }
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      private function persistData() : void
      {
         var obj:Object = new Object();
         obj["area"] = this.mLocalPoiSearchAreaDefault;
         obj["city_pri"] = this.mLocalPoiSearchCity.getPrimaryLocation().getPersistenceString();
         obj["city_sec"] = this.mLocalPoiSearchCity.getSecondaryLocation().getPersistenceString();
         PersistenceApi.api.saveData(PersistenceKeys.POI_SEARCH_AREA,obj);
      }
      
      private function unload() : void
      {
         NavigationApi.api.removeEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady);
         NavigationPackage.peripheral.navigation.navRouteCalculation.removeEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onRouteGuidanceActive);
      }
      
      private function init() : void
      {
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.POI_SEARCH_AREA);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
         NavigationApi.api.navGetIsReady();
      }
   }
}

