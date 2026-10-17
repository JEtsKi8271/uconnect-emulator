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
   
   public class NavMenuWhereToFavoritesAddDestination implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      public function NavMenuWhereToFavoritesAddDestination(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_ADD_DESTINATION;
         this.update();
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
         if(Peripheral.navigation.navHomeAddress.homeAddressSet == true)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_MENU_GO_HOME),
               "id":NavMenuWhereToConstants.GO_HOME
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
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_DEST));
         this.mParent.revalidate();
      }
      
      private function onServiceStatusUpdate(e:LiveServicesEvent) : void
      {
         this.update();
      }
      
      public function addListeners() : void
      {
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onServiceStatusUpdate,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onServiceStatusUpdate);
      }
      
      public function onBack() : void
      {
         Peripheral.navigation.navTripAssembler.setDestinationMode(Peripheral.navigation.navVServices.screenHelper.favoriteDestinationsDestinationMode);
         Peripheral.navigation.navDomainControl.onBackButtonPress();
      }
      
      public function onCancel() : void
      {
         Peripheral.navigation.navDomainControl.onCancelButtonPress();
      }
      
      public function onBtn(id:int) : void
      {
         Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ADD_TO_FAVORITES);
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_DEST,this.mParent.getWindowIndex());
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
            case NavMenuWhereToConstants.GO_HOME:
               Peripheral.navigation.navTripAssembler.addLocationDescription(Peripheral.navigation.navHomeAddress.homeAddress);
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
               Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_ADD_TO_FAVORITES);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH);
               break;
            default:
               Framework.Trace("NavMenuWhereTo.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      public function onLiveServicesEvent(e:LiveServicesEvent) : void
      {
         this.update();
      }
   }
}

