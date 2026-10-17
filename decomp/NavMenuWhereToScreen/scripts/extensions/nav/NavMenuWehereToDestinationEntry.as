package extensions.nav
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.enums.PoiInputPath;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.global.vServices.VServiceScreenHelper;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWehereToDestinationEntry implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      private var mButtonID:int = 0;
      
      private var mIsTTLSAvailable:Boolean = false;
      
      public function NavMenuWehereToDestinationEntry(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_MENU_WHERE_TO;
      }
      
      public function update() : void
      {
         var transID:uint = 0;
         this.mParent.clearList();
         if(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH))
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_LOCAL_SEARCH),
               "id":NavMenuWhereToConstants.LS_LOCAL_SEARCH
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_ADDRESS),
            "id":NavMenuWhereToConstants.ADDRESS
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_RECENT),
            "id":NavMenuWhereToConstants.MY_DESTINATIONS
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_POINTS_OF_INTEREST),
            "id":NavMenuWhereToConstants.POINT_OF_INTEREST
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_FAVORITES),
            "id":NavMenuWhereToConstants.FAVORITE_DESTINATIONS
         });
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_INTERSECTION),
                  "id":NavMenuWhereToConstants.INTERSECTION_NA
               });
               break;
            case VServiceGlobalSettings.MARKET_EUROPE:
            case VServiceGlobalSettings.MARKET_ROW:
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_INTERSECTION),
                  "id":NavMenuWhereToConstants.INTERSECTION_EU
               });
               break;
            case VServiceGlobalSettings.MARKET_KOREA:
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_SPELL_NAME),
                  "id":NavMenuWhereToConstants.SPELL_NAME
               });
               break;
            case VServiceGlobalSettings.MARKET_JAPAN:
               break;
            default:
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_INTERSECTION),
                  "id":NavMenuWhereToConstants.INTERSECTION_NA
               });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_GO_HOME),
            "id":NavMenuWhereToConstants.GO_HOME
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRIPS),
            "id":NavMenuWhereToConstants.TRIPS
         });
         if(VServiceGlobalSettings.navMarketConfig != VServiceGlobalSettings.MARKET_CHINA && VServiceGlobalSettings.navMarketConfig != VServiceGlobalSettings.MARKET_KOREA)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_MENU_GEO_COORDINATE),
               "id":NavMenuWhereToConstants.GEO_COORDINATE
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_POINT_ON_MAP),
            "id":NavMenuWhereToConstants.POINT_ON_MAP
         });
         if(String(Peripheral.navigation.navLocationInput.liDefaultCountry) != "")
         {
            if(VServiceGlobalSettings.navMarketConfig != VServiceGlobalSettings.MARKET_JAPAN)
            {
               transID = Framework.resolution == Framework.RES_800_480 ? uint(T.STRB_MENU_CLOSEST_CITIES_330) : uint(T.STRB_MENU_CLOSEST_CITIES);
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_CITY_CENTER),
                  "id":NavMenuWhereToConstants.CITY_CENTER
               });
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(transID),
                  "id":NavMenuWhereToConstants.CLOSEST_CITIES
               });
            }
         }
         if(VServiceGlobalSettings.navMarketConfig != VServiceGlobalSettings.MARKET_CHINA)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRAILS),
               "id":NavMenuWhereToConstants.TRAILS
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_PHONE_NUMBER),
            "id":NavMenuWhereToConstants.PHONE_NUMBER
         });
         this.mParent.revalidate();
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_WHERE_TO));
      }
      
      private function onServiceStatusUpdate(e:LiveServicesEvent) : void
      {
         var oldIsTTLSAvailable:Boolean = this.mIsTTLSAvailable;
         this.mIsTTLSAvailable = Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable;
         if(this.mIsTTLSAvailable != oldIsTTLSAvailable)
         {
            Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_WHERE_TO,this.mParent.getWindowIndex());
            this.update();
         }
      }
      
      public function addListeners() : void
      {
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onServiceStatusUpdate,false,0,true);
         Peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_DEFAULT_STATE,this.onLocationInputEvent,false,0,true);
         Peripheral.navigation.navLocationInput.liGetDefaultState();
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.DB_SERVICE_READY,this.onDBServiceState,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onServiceStatusUpdate);
         Peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_DEFAULT_STATE,this.onLocationInputEvent);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
         NavigationApi.api.removeEventListener(NavigationEvent.DB_SERVICE_READY,this.onDBServiceState);
      }
      
      public function onBack() : void
      {
         Peripheral.navigation.navDomainControl.onBackButtonPress();
      }
      
      public function onCancel() : void
      {
         Peripheral.navigation.navDomainControl.onCancelButtonPress();
      }
      
      public function onBtn(id:int) : void
      {
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_WHERE_TO,this.mParent.getWindowIndex());
         this.mButtonID = id;
         switch(id)
         {
            case NavMenuWhereToConstants.ADDRESS:
               NavMenus.isVRSupported = false;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               switch(VServiceGlobalSettings.navMarketConfig)
               {
                  case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_US);
                     break;
                  case VServiceGlobalSettings.MARKET_KOREA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_MAIN_KOR);
                     break;
                  case VServiceGlobalSettings.MARKET_CHINA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_CHINA);
                     break;
                  case VServiceGlobalSettings.MARKET_JAPAN:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_JAPAN);
                     break;
                  case VServiceGlobalSettings.MARKET_EUROPE:
                  case VServiceGlobalSettings.MARKET_ROW:
                  default:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_ECE);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.MY_DESTINATIONS:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navVServices.screenHelper.resetMyDestinationsWindowIndex();
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MY_DESTINATIONS);
               break;
            case NavMenuWhereToConstants.POINT_OF_INTEREST:
               NavMenus.isVRSupported = false;
               Peripheral.navigation.navPoiInput.poiSelectDefaultSearchArea(PoiSearchArea.AROUND_ME);
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.MAIN);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            case NavMenuWhereToConstants.FAVORITE_DESTINATIONS:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navVServices.screenHelper.resetFavoriteDestinationsListResetIndex();
               Peripheral.navigation.navVServices.screenHelper.setFavoriteDestinationsListShowAddButton(true);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
               break;
            case NavMenuWhereToConstants.INTERSECTION_EU:
            case NavMenuWhereToConstants.INTERSECTION_NA:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               switch(VServiceGlobalSettings.navMarketConfig)
               {
                  case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_INTERSECTION_US);
                     break;
                  case VServiceGlobalSettings.MARKET_CHINA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_INTERSECTION_CHINA);
                     break;
                  case VServiceGlobalSettings.MARKET_EUROPE:
                  case VServiceGlobalSettings.MARKET_ROW:
                  case VServiceGlobalSettings.MARKET_KOREA:
                  default:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_INTERSECTION_ECE);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.GO_HOME:
               NavMenus.isVRSupported = true;
               if(NavigationApi.api.isDbServiceReady == true)
               {
                  this.goToHomeAddress();
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
               }
               break;
            case NavMenuWhereToConstants.TRIPS:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navVServices.screenHelper.resetTripsAllTripsWindowIndex();
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TRIPS_ALL_TRIPS);
               break;
            case NavMenuWhereToConstants.GEO_COORDINATE:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_GEO_COORDINATE);
               Peripheral.navigation.navGeoCoordinate.setCoordinateEntryType(GeoFormats.TYPE_LATITUDE);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_GEO_SPELLER);
               break;
            case NavMenuWhereToConstants.POINT_ON_MAP:
               NavMenus.isVRSupported = false;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navVServices.screenHelper.setMapScrollingEntryCondition(VServiceScreenHelper.SCROLLING_ENTRY_ADVANCED);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MAP_SCROLLING);
               break;
            case NavMenuWhereToConstants.CITY_CENTER:
               NavMenus.isVRSupported = true;
               this.mParent.bookmark = "NavMenuWhereToDestinationEntry";
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_CHINA)
               {
                  Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_CITYCENTER_CHINA);
               }
               else
               {
                  Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_CITYCENTER);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.CLOSEST_CITIES:
               NavMenus.isVRSupported = true;
               this.mParent.bookmark = "NavMenuWhereToDestinationEntry";
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_CLOSESTCITIES);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.TRAILS:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TRAIL_LIST);
               break;
            case NavMenuWhereToConstants.PHONE_NUMBER:
               NavMenus.isVRSupported = false;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navPoiInput.poiRemoveAllCharacters();
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.PHONE_NUMBER_SPELLER);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            case NavMenuWhereToConstants.SPELL_NAME:
               NavMenus.isVRSupported = true;
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navPoiInput.poiRemoveAllCharacters();
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.UNDEFINED);
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.BY_NAME_SPELLER);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            case NavMenuWhereToConstants.LS_LOCAL_SEARCH:
               NavMenus.isVRSupported = false;
               Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH);
               break;
            default:
               Framework.Trace("NavMenuWhereTo.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      public function goToHomeAddress() : void
      {
         if(Peripheral.navigation.navHomeAddress.homeAddressSet == true)
         {
            Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_HOME);
            Peripheral.navigation.navTripAssembler.addLocationDescription(Peripheral.navigation.navHomeAddress.homeAddress);
         }
         else
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_HOME_ADDRESS_NOW);
         }
      }
      
      public function onLocationInputEvent(e:LocationInputEvent) : void
      {
         this.update();
      }
      
      public function onLiveServicesEvent(e:LiveServicesEvent) : void
      {
         this.update();
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         if(e.data.id == DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_HOME_ADDRESS_NOW)
         {
            Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_HOME_ADD_DESTINATION,0);
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_HOME_ADD_DESTINATION);
         }
      }
      
      protected function onDBServiceState(e:NavigationEvent) : void
      {
         var bDbReady:Boolean = Boolean(NavigationApi.api.isDbServiceReady);
         Framework.Trace("Got onDBServiceState readyEvent");
         if(bDbReady == true)
         {
            if(Boolean(Framework.popupManager.check(DynamicPopupNames.PLEASE_WAIT)) && this.mButtonID == NavMenuWhereToConstants.GO_HOME)
            {
               this.goToHomeAddress();
            }
         }
      }
   }
}

