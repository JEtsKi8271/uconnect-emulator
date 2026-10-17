package extensions.nav
{
   import com.harman.navigation.Controller.GeoCoordinate.util.GeoFormats;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.enums.PoiInputPath;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.global.vServices.VServiceScreenHelper;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToHomeAddDestination implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      private var mIsTTLSAvailable:Boolean = false;
      
      private var mWasTTLSEnabled:Boolean = false;
      
      public function NavMenuWhereToHomeAddDestination(parent:*)
      {
         super();
         this.mParent = parent;
         switch(Peripheral.navigation.navDomainControl.navActiveMenu)
         {
            case NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:
               this.mParent.title = T.STRB_SHOW_WEATHER_FOR;
               break;
            case NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:
               this.mParent.title = T.STRB_SELECT_SEARCH_LOCATION;
               break;
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK:
               this.mParent.title = T.STRB_SET_WORK_ADDRESS;
               break;
            case NavMenus.MENU_HOME_ADD_DESTINATION:
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME:
            default:
               this.mParent.title = T.STRB_SET_HOME_ADDRESS;
         }
         this.update();
      }
      
      public function update() : void
      {
         var transID:uint = 0;
         this.mParent.clearList();
         if(Peripheral.navigation.navDomainControl.navActiveMenu != NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO)
         {
            if(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH))
            {
               this.mParent.pushItem({
                  "label":T.STRB_LOCAL_SEARCH,
                  "id":NavMenuWhereToConstants.LS_LOCAL_SEARCH
               });
            }
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
            case VServiceGlobalSettings.MARKET_JAPAN:
            case VServiceGlobalSettings.MARKET_KOREA:
               break;
            default:
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_INTERSECTION),
                  "id":NavMenuWhereToConstants.INTERSECTION_NA
               });
         }
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
            if(Global.region != TunerRegion.JAPAN)
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
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_PHONE_NUMBER),
            "id":NavMenuWhereToConstants.PHONE_NUMBER
         });
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(Peripheral.navigation.navDomainControl.navActiveMenu));
         this.mParent.revalidate();
      }
      
      public function addListeners() : void
      {
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServicesEvent,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServicesEvent);
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
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(Peripheral.navigation.navDomainControl.navActiveMenu,this.mParent.getWindowIndex());
         switch(Peripheral.navigation.navDomainControl.navActiveMenu)
         {
            case NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.LOCATION_LIVE_SERVICES_LOCAL_SEARCH);
               break;
            case NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.LOCATION_LIVE_SERVICES_WEATHER);
               break;
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_HOME);
               break;
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_WORK);
               break;
            case NavMenus.MENU_HOME_ADD_DESTINATION:
            default:
               Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_SET_HOME);
         }
         switch(id)
         {
            case NavMenuWhereToConstants.ADDRESS:
               switch(VServiceGlobalSettings.navMarketConfig)
               {
                  case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_US);
                     break;
                  case VServiceGlobalSettings.MARKET_JAPAN:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_JAPAN);
                     break;
                  case VServiceGlobalSettings.MARKET_KOREA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_MAIN_KOR);
                     break;
                  case VServiceGlobalSettings.MARKET_CHINA:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_CHINA);
                     break;
                  case VServiceGlobalSettings.MARKET_EUROPE:
                  case VServiceGlobalSettings.MARKET_ROW:
                  default:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_ADDRESS_ECE);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.MY_DESTINATIONS:
               Peripheral.navigation.navVServices.screenHelper.resetMyDestinationsWindowIndex();
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MY_DESTINATIONS);
               break;
            case NavMenuWhereToConstants.POINT_OF_INTEREST:
               Peripheral.navigation.navPoiInput.poiSelectDefaultSearchArea(PoiSearchArea.AROUND_ME);
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.MAIN);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            case NavMenuWhereToConstants.FAVORITE_DESTINATIONS:
               Peripheral.navigation.navVServices.screenHelper.resetFavoriteDestinationsListResetIndex();
               Peripheral.navigation.navVServices.screenHelper.setFavoriteDestinationsListShowAddButton(false);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
               break;
            case NavMenuWhereToConstants.INTERSECTION_EU:
            case NavMenuWhereToConstants.INTERSECTION_NA:
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
                  default:
                     Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_INTERSECTION_ECE);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.GEO_COORDINATE:
               Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_GEO_COORDINATE);
               Peripheral.navigation.navGeoCoordinate.setCoordinateEntryType(GeoFormats.TYPE_LATITUDE);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_GEO_SPELLER);
               break;
            case NavMenuWhereToConstants.POINT_ON_MAP:
               Peripheral.navigation.navVServices.screenHelper.setMapScrollingEntryCondition(VServiceScreenHelper.SCROLLING_ENTRY_ADVANCED);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MAP_SCROLLING);
               break;
            case NavMenuWhereToConstants.CITY_CENTER:
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
               Peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_CLOSESTCITIES);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_LOCATION);
               break;
            case NavMenuWhereToConstants.TRAILS:
               break;
            case NavMenuWhereToConstants.PHONE_NUMBER:
               Peripheral.navigation.navPoiInput.poiRemoveAllCharacters();
               Peripheral.navigation.navPoiInput.poiSetInputPath(PoiInputPath.PHONE_NUMBER_SPELLER);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FLOW_INPUT_POI);
               break;
            case NavMenuWhereToConstants.LS_LOCAL_SEARCH:
               switch(Peripheral.navigation.navDomainControl.navActiveMenu)
               {
                  case NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:
                     Framework.Trace("NavMenuWhereToHomeAddDestinations.onBtn() - Illegal recursion detected! (MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO)");
                     break;
                  case NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:
                     Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.LOCATION_LIVE_SERVICES_WEATHER);
                     break;
                  case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME:
                     Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_HOME);
                     break;
                  case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK:
                     Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_SET_WORK);
                     break;
                  case NavMenus.MENU_HOME_ADD_DESTINATION:
                  default:
                     Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_SET_HOME);
               }
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH);
               break;
            default:
               Framework.Trace("NavMenuWhereTo.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      public function onLiveServicesEvent(e:LiveServicesEvent) : void
      {
         var oldIsTTLSAvailable:Boolean = this.mIsTTLSAvailable;
         this.mIsTTLSAvailable = Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable;
         if(this.mIsTTLSAvailable != oldIsTTLSAvailable)
         {
            Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(Peripheral.navigation.navDomainControl.navActiveMenu,this.mParent.getWindowIndex());
            this.update();
         }
      }
   }
}

