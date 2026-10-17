package extensions.nav
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.SearchAreaTypes;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.routeCalculation.Destination;
   import com.nfuzion.framework.global.Framework;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToLSLocalSearch implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      public function NavMenuWhereToLSLocalSearch(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_LOCAL_SEARCH;
         this.update();
      }
      
      public function update() : void
      {
         this.mParent.clearList();
         if(Peripheral.navigation.navigation.posPositionInformation.getType("<GEO>") != "")
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_AROUND_ME),
               "id":NavMenuWhereToConstants.CLOSEST_CITIES
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_WHERE_TO),
            "id":NavMenuWhereToConstants.ADDRESS
         });
         if(Peripheral.navigation.navRouteCalculation.activeRoute)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_NEAR_DESTINATION),
               "id":NavMenuWhereToConstants.MY_DESTINATIONS
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
         var vehGeo:String = null;
         var j:int = 0;
         var element:int = 0;
         var geo:String = null;
         Framework.Trace("NavMenuWhereToLSLocalSearch.onBtn( " + id + " )");
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH,this.mParent.getWindowIndex());
         if(!this.liveServiceConnectionAvailable)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
            return;
         }
         switch(id)
         {
            case NavMenuWhereToConstants.CLOSEST_CITIES:
               vehGeo = Peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
               if(vehGeo != "")
               {
                  Peripheral.navigation.navLiveServices.setLocalSearchSearchArea(SearchAreaTypes.SA_NEAR_ME,vehGeo);
                  Peripheral.navigation.navVServices.spellerGeneric.setFollowUpMenuID(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST);
                  Peripheral.navigation.navVServices.spellerGeneric.setInputPreset("");
                  Peripheral.navigation.navVServices.spellerGeneric.setMaxCharacters(NavGlobalSettings.POI_BY_NAME_MAX_CHARACTERS);
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER);
               }
               break;
            case NavMenuWhereToConstants.ADDRESS:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO);
               break;
            case NavMenuWhereToConstants.MY_DESTINATIONS:
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
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_DESTINATION_LIST_LOCALSEARCH);
               }
               else
               {
                  geo = Destination(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations[j]).hardDestination.getSecondaryLocation().getType("<GEO>");
                  if(geo != "")
                  {
                     Peripheral.navigation.navLiveServices.setLocalSearchSearchArea(SearchAreaTypes.SA_NEAR_DESTINATION,geo);
                     Peripheral.navigation.navVServices.spellerGeneric.setFollowUpMenuID(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_LIST);
                     Peripheral.navigation.navVServices.spellerGeneric.setInputPreset("");
                     Peripheral.navigation.navVServices.spellerGeneric.setMaxCharacters(NavGlobalSettings.POI_BY_NAME_MAX_CHARACTERS);
                     Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_SPELLER);
                  }
                  else
                  {
                     Framework.Trace("No GeoCoordinate found for Destination (" + j + ")! \'" + Destination(Peripheral.navigation.navRouteCalculation.activeRoute.Destinations[j]).hardDestination.getSecondaryLocation().getPersistenceString() + "\'");
                  }
               }
               break;
            default:
               Framework.Trace("NavMenuWhereToLSLocalSearch.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      private function get liveServiceConnectionAvailable() : Boolean
      {
         if(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH))
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

