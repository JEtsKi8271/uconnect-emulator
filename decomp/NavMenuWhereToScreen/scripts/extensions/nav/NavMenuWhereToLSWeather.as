package extensions.nav
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.SearchAreaTypes;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToLSWeather implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      public function NavMenuWhereToLSWeather(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_WEATHER;
         this.update();
      }
      
      public function update() : void
      {
         this.mParent.clearList();
         if(Peripheral.navigation.navigation.posPositionInformation.getType("<GEO>") != "")
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_AROUND_ME),
               "id":NavMenuWhereToConstants.LS_HDT_WEATHER_NEAR_ME
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_OTHER_LOCATION),
            "id":NavMenuWhereToConstants.LS_HDT_WEATHER_OTHER
         });
         if(Peripheral.navigation.navRouteCalculation.activeRoute)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_NEAR_DESTINATION),
               "id":NavMenuWhereToConstants.LS_HDT_WEATHER_NEAR_DEST
            });
         }
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS));
         this.mParent.revalidate();
      }
      
      public function addListeners() : void
      {
         Peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO,this.onGuidanceUpdate,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navRouteCalculation.removeEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO,this.onGuidanceUpdate);
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
         var loc:LocationDescription = null;
         var j:int = 0;
         var element:int = 0;
         Framework.Trace("NavMenuWhereToLSWeather.onBtn( " + id + " )");
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER,this.mParent.getWindowIndex());
         if(!this.liveServiceConnectionAvailable)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
            return;
         }
         switch(id)
         {
            case NavMenuWhereToConstants.LS_HDT_WEATHER_NEAR_ME:
               loc = new LocationDescription();
               loc.setPrimaryLocation(Peripheral.navigation.navigation.posPositionInformation);
               loc.setSecondaryLocation(Peripheral.navigation.navigation.posPositionInformation);
               Peripheral.navigation.navLiveServices.setWeatherSearchArea(SearchAreaTypes.SA_NEAR_ME,loc);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_DETAILS);
               break;
            case NavMenuWhereToConstants.LS_HDT_WEATHER_OTHER:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO);
               break;
            case NavMenuWhereToConstants.LS_HDT_WEATHER_NEAR_DEST:
               j = 0;
               element = int(Peripheral.navigation.navRouteCalculation.activeRoute.routeElement);
               if(element > 0)
               {
                  j = element - 1;
               }
               else if(element == -1)
               {
                  j = 0;
               }
               if(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations.length > j + 1)
               {
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_DESTINATION_LIST_WEATHER);
               }
               else if(Destination(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations[j]).hardDestination != null)
               {
                  Peripheral.navigation.navLiveServices.setWeatherSearchArea(SearchAreaTypes.SA_NEAR_DESTINATION,Destination(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations[j]).hardDestination);
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_DETAILS);
               }
               else
               {
                  Framework.Trace("No GeoCoordinate found for Destination (" + j + ")! \'" + Destination(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations[j]).hardDestination.getSecondaryLocation().getPersistenceString() + "\'");
               }
               break;
            default:
               Framework.Trace("NavMenuWhereToLSWeather.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      private function get liveServiceConnectionAvailable() : Boolean
      {
         if(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_WEATHER))
         {
            return true;
         }
         return false;
      }
      
      private function onGuidanceUpdate(e:RouteCalculationEvent) : void
      {
         this.update();
      }
   }
}

