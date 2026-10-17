package com.harman.navigation.DomainControl
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import flash.filesystem.File;
   
   public class NavGlobalPopupController
   {
      
      private static const NAVISERVER_LOCATION:String = "/fs/mmc0/nav/NNG/NaviServer";
      
      private var mSpecialFeatures:Array = new Array("GPS_ONLY","NO_GPS","demoMode");
      
      public function NavGlobalPopupController()
      {
         super();
      }
      
      public function init() : void
      {
         if(NavigationPackage.peripheral.navigation.navigation != null)
         {
            NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.TMC_MANUAL_REROUTE,this.onTmcRerouteRequest,false,0,true);
            NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.SPECIAL_FEATURES,this.onSpecialFeatures,false,0,true);
            NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChange,false,0,true);
            NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_IPD_AREA,this.onIpdAreaEvent,false,0,true);
            NavigationPackage.peripheral.navigation.navigation.posGetIPDAreaState();
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED,this.onRouteCalculationFailed,false,0,true);
            NavigationPackage.peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.POI_SEARCH_AREA_CITY_INVALID,this.onPoiSearchCityInvalid,false,0,true);
         }
         else
         {
            Framework.Trace("NavGlobalPopupController.init() Could not initialize!");
         }
         this.checkNaviServerShadow();
      }
      
      private function onLanguageChange(e:NavigationEvent) : void
      {
         Framework.Trace("NavGlobalPopupController.onLanguageChange( " + NavigationPackage.peripheral.navigation.navigation.langIsLanguageChangeInProgress + " )");
         if(NavigationPackage.peripheral.navigation.navigation.langIsLanguageChangeInProgress)
         {
            NavigationPackage.peripheral.navigation.navDomainControl.clearMenuStack(0);
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenuStackPassive(0);
            if(NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
            {
               NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LANGUAGE_CHANGE_POPUP);
            }
            else
            {
               NavigationPackage.peripheral.navigation.navDomainControl.addMenuToStackNoAction(NavMenus.MENU_LANGUAGE_CHANGE_POPUP,0);
            }
         }
         else if(NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
         {
            NavigationPackage.peripheral.navigation.navDomainControl.onBackButtonPress();
         }
         else if(NavigationPackage.peripheral.navigation.navDomainControl.navActiveMenu == NavMenus.MENU_LANGUAGE_CHANGE_POPUP)
         {
            NavigationPackage.peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
         }
      }
      
      private function checkNaviServerShadow() : void
      {
         var info:Object = null;
         var naviServerShadow:File = File.desktopDirectory.resolvePath(NAVISERVER_LOCATION);
         if(naviServerShadow.exists == true)
         {
            info = new Object();
            info["info"] = "    Warning:\n NaviServer has been overwritten!";
            NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.TWOITEM_NAV_FEATURE_WARNING_MESSAGE,info);
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onNaviServerWarningPopupClosed,false,0,true);
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onNaviServerWarningPopupClosed,false,0,true);
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onNaviServerWarningPopupDisableFeature,false,0,true);
         }
      }
      
      private function onNaviServerWarningPopupDisableFeature(e:GlobalEvent) : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onNaviServerWarningPopupClosed);
         Framework.Trace("NavPopup.onNaviServerWarningPopupDisableFeature ()");
         NavigationPackage.peripheral.navigation.navigation.setForceSendConsoleCommand("slay NaviServer");
         NavigationPackage.peripheral.navigation.navigation.setForceSendConsoleCommand("mount -uw /fs/mmc0/");
         NavigationPackage.peripheral.navigation.navigation.setForceDeleteNaviServerPersistence();
         NavigationPackage.peripheral.navigation.navigation.setForceSendConsoleCommand("rm " + NAVISERVER_LOCATION);
         this.removeNaviServerWarningPopupListeners();
      }
      
      private function onNaviServerWarningPopupClosed(e:GlobalEvent) : void
      {
         Framework.Trace("NavPopup.onNaviServerWarningPopupClosed()");
         this.removeNaviServerWarningPopupListeners();
      }
      
      private function removeNaviServerWarningPopupListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onNaviServerWarningPopupClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onNaviServerWarningPopupClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onNaviServerWarningPopupDisableFeature);
      }
      
      private function onSpecialFeatures(e:NavigationEvent) : void
      {
         var info:Object = null;
         for(var i:int = 0; i < this.mSpecialFeatures.length; i++)
         {
            if(NavigationPackage.peripheral.navigation.navigation.getNavSpecialFeatureActive(this.mSpecialFeatures[i]) == true)
            {
               info = new Object();
               info["info"] = "    Warning:\n\'" + String(this.mSpecialFeatures[i]) + "\' is active!";
               NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.TWOITEM_NAV_FEATURE_WARNING_MESSAGE,info);
               Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onSpecialFeaturePopupClosed,false,0,true);
               Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onSpecialFeaturePopupClosed,false,0,true);
               Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onSpecialFeaturePopupDisableFeature,false,0,true);
               break;
            }
         }
         NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.SPECIAL_FEATURES,this.onSpecialFeatures);
      }
      
      private function onSpecialFeaturePopupDisableFeature(e:GlobalEvent) : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onSpecialFeaturePopupClosed);
         for(var i:int = 0; i < this.mSpecialFeatures.length; i++)
         {
            if(NavigationPackage.peripheral.navigation.navigation.getNavSpecialFeatureActive(this.mSpecialFeatures[i]) == true)
            {
               Framework.Trace("NavPopup.onSpecialFeaturePopupDisableFeature (" + this.mSpecialFeatures[i] + ")");
               NavigationPackage.peripheral.navigation.navigation.setNavSpecialFeatureFlag(this.mSpecialFeatures[i],false);
               break;
            }
         }
         this.removeSpecialFeaturePopupListeners();
      }
      
      private function onSpecialFeaturePopupClosed(e:GlobalEvent) : void
      {
         Framework.Trace("NavPopup.onSpecialFeaturePopupClosed()");
         this.removeSpecialFeaturePopupListeners();
      }
      
      private function removeSpecialFeaturePopupListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_CLOSED,this.onSpecialFeaturePopupClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onSpecialFeaturePopupClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_RIGHT_CLICK,this.onSpecialFeaturePopupDisableFeature);
      }
      
      private function onTmcRerouteRequest(e:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteAlternatives.routeList.length > 0)
         {
            this.addTmcThreeItemPopupListeners();
            NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.THREEITEM_NAV_TMC_REROUTE);
         }
         else if(Framework.popupManager.check(NavigationPackage.dynamicPopupNames.THREEITEM_NAV_TMC_REROUTE))
         {
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.THREEITEM_NAV_TMC_REROUTE);
         }
      }
      
      public function onTmcRerouteAccept(e:GlobalEvent) : void
      {
         var i:String = null;
         var routes:Object = NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteAlternatives;
         if(routes.hasOwnProperty("routeList"))
         {
            var _loc4_:int = 0;
            var _loc5_:* = routes.routeList;
            for(i in _loc5_)
            {
               NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteAccept(routes.routeList[i]);
            }
         }
         this.removeTmcThreeItemPopupListeners();
      }
      
      public function onTmcRerouteDecline(e:GlobalEvent) : void
      {
         var i:String = null;
         var routes:Object = NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteAlternatives;
         if(routes.hasOwnProperty("routeList"))
         {
            var _loc4_:int = 0;
            var _loc5_:* = routes.routeList;
            for(i in _loc5_)
            {
               NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteDecline(routes.routeList[i]);
            }
         }
         this.removeTmcThreeItemPopupListeners();
      }
      
      public function onTmcReroutePreview(e:GlobalEvent) : void
      {
         if(!NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
         {
            Framework.Trace("TMC screen switch " + (NavigationPackage.peripheral.navigation.navDomainControl.mapMenuStackIsSelected == true ? 1 : 0));
            NavigationPackage.peripheral.navigation.navDomainControl.addMenuToStackPassive(NavMenus.MENU_TMC_ROUTE_PREVIEW,NavigationPackage.peripheral.navigation.navDomainControl.mapMenuStackIsSelected == true ? 1 : 0);
            NavigationPackage.peripheral.navigation.navDomainControl.onNavDomainButton();
         }
         else
         {
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TMC_ROUTE_PREVIEW);
         }
         this.removeTmcThreeItemPopupListeners();
      }
      
      private function addTmcThreeItemPopupListeners() : void
      {
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_CLOSED,this.onTmcRerouteDecline,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_LEFT_CLICK,this.onTmcRerouteAccept,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_CENTER_CLICK,this.onTmcReroutePreview,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.THREEITEM_POPUP_RIGHT_CLICK,this.onTmcRerouteDecline,false,0,true);
      }
      
      private function removeTmcThreeItemPopupListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.THREEITEM_POPUP_CLOSED,this.onTmcRerouteDecline);
         Framework.popupManager.removeEventListener(GlobalEvent.THREEITEM_POPUP_LEFT_CLICK,this.onTmcRerouteAccept);
         Framework.popupManager.removeEventListener(GlobalEvent.THREEITEM_POPUP_CENTER_CLICK,this.onTmcReroutePreview);
         Framework.popupManager.removeEventListener(GlobalEvent.THREEITEM_POPUP_RIGHT_CLICK,this.onTmcRerouteDecline);
      }
      
      private function onIpdAreaEvent(e:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navigation.posIPDAreaState == true)
         {
            Framework.popupManager.addEventListener(GlobalEvent.ONEITEM_POPUP_CLOSED,this.onIPDPopupConfirmation,false,0,true);
            Framework.popupManager.addEventListener(GlobalEvent.ONEITEM_POPUP_CONFIRMATION,this.onIPDPopupConfirmation,false,0,true);
            NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA);
         }
         else if(Framework.popupManager.check(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA))
         {
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA);
         }
      }
      
      private function onIPDPopupConfirmation(e:GlobalEvent) : void
      {
         if(Framework.popupManager.check(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA))
         {
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_CAUTION_UNVERIFIED_MAP_DATA);
         }
         Framework.popupManager.removeEventListener(GlobalEvent.ONEITEM_POPUP_CLOSED,this.onIPDPopupConfirmation);
         Framework.popupManager.removeEventListener(GlobalEvent.ONEITEM_POPUP_CONFIRMATION,this.onIPDPopupConfirmation);
      }
      
      private function onRouteCalculationFailed(e:RouteCalculationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navDomainControl.navActiveMenu != NavMenus.MENU_FLOW_TRIP_ASSEMBLER)
         {
            Framework.popupManager.addEventListener(GlobalEvent.ONEITEM_POPUP_CLOSED,this.onRouteCalcFailPopupConfirmation,false,0,true);
            Framework.popupManager.addEventListener(GlobalEvent.ONEITEM_POPUP_CONFIRMATION,this.onRouteCalcFailPopupConfirmation,false,0,true);
            NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_ROUTE_CALCULATION_FAILED);
         }
      }
      
      private function onRouteCalcFailPopupConfirmation(e:GlobalEvent) : void
      {
         if(Framework.popupManager.check(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_ROUTE_CALCULATION_FAILED))
         {
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.ONEITEM_NAV_ROUTE_CALCULATION_FAILED);
         }
         Framework.popupManager.removeEventListener(GlobalEvent.ONEITEM_POPUP_CLOSED,this.onRouteCalcFailPopupConfirmation);
         Framework.popupManager.removeEventListener(GlobalEvent.ONEITEM_POPUP_CONFIRMATION,this.onRouteCalcFailPopupConfirmation);
      }
      
      private function onPoiSearchCityInvalid(e:TripAssemblerEvent) : void
      {
         NavigationPackage.ancillary.definedDynamicPopups.popup(NavigationPackage.dynamicPopupNames.INFO_POI_SEARCH_AREA_CITY_INVALID);
      }
   }
}

