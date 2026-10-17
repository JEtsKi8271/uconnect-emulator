package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class NavMainMenuScreen extends ScreenEnhanced
   {
      
      private var assets:C_NavMainMenu = new C_NavMainMenu();
      
      private var mCancelingRoute:Boolean = false;
      
      public function NavMainMenuScreen()
      {
         mView = this.assets;
         super();
      }
      
      override protected function addListeners() : void
      {
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         this.assets.whereto_button.addEventListener(WidgetEvent.CLICK,this.onWhereTo,false,0,true);
         this.assets.viewmap_button.addEventListener(WidgetEvent.CLICK,this.onViewMap,false,0,true);
         this.assets.information_button.addEventListener(WidgetEvent.CLICK,this.onInformation,false,0,true);
         this.assets.live_information_button.addEventListener(WidgetEvent.CLICK,this.onInformation,false,0,true);
         this.assets.emergency_button.addEventListener(WidgetEvent.CLICK,this.onEmergency,false,0,true);
         this.assets.repeat_button.addEventListener(WidgetEvent.CLICK,this.onRepeat,false,0,true);
         this.assets.stop_button.addEventListener(WidgetEvent.CLICK,this.onStop,false,0,true);
         this.assets.detour_button.addEventListener(WidgetEvent.CLICK,this.onDetour,false,0,true);
         this.assets.settings_button.addEventListener(WidgetEvent.CLICK,this.onSettings,false,0,true);
         Peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onRouteGuidanceUpdate,false,0,true);
         Peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.TRIP_ROUTE_ALTERATION_IN_PROGRESS,this.onRouteAlteration,false,0,true);
         Peripheral.navigation.navRouteCalculation.getActiveRouteGuidanceState();
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onLiveServiceStatusUpdate,false,0,true);
         Peripheral.navigation.navLiveServices.ttlsRequestServiceStatusUpdate();
         super.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         this.assets.whereto_button.removeEventListener(WidgetEvent.CLICK,this.onWhereTo);
         this.assets.viewmap_button.removeEventListener(WidgetEvent.CLICK,this.onViewMap);
         this.assets.information_button.removeEventListener(WidgetEvent.CLICK,this.onInformation);
         this.assets.live_information_button.removeEventListener(WidgetEvent.CLICK,this.onInformation);
         this.assets.emergency_button.removeEventListener(WidgetEvent.CLICK,this.onEmergency);
         this.assets.repeat_button.removeEventListener(WidgetEvent.CLICK,this.onRepeat);
         this.assets.stop_button.removeEventListener(WidgetEvent.CLICK,this.onStop);
         this.assets.detour_button.removeEventListener(WidgetEvent.CLICK,this.onDetour);
         this.assets.settings_button.removeEventListener(WidgetEvent.CLICK,this.onSettings);
         Peripheral.navigation.navRouteCalculation.removeEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onRouteGuidanceUpdate);
         Peripheral.navigation.navTripAssembler.removeEventListener(TripAssemblerEvent.TRIP_ROUTE_ALTERATION_IN_PROGRESS,this.onRouteAlteration);
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onLiveServiceStatusUpdate);
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Framework.structure.setExit();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[this.assets.whereto_button,this.assets.viewmap_button,this.assets.information_button,this.assets.live_information_button,this.assets.emergency_button,this.assets.settings_button,this.assets.stop_button,this.assets.detour_button,this.assets.repeat_button]));
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         Text.format(this.assets.repeat_button.label,T.STRB_REPEAT_2);
         Text.format(this.assets.stop_button.label,T.STRB_STOP);
         Text.format(this.assets.detour_button.label,T.STRB_DETOUR);
         Text.format(this.assets.settings_button.label,T.STRB_NAV_SETTINGS);
         Text.format(this.assets.whereto_button.label,T.STRB_MENU_WHERE_TO);
         Text.format(this.assets.viewmap_button.label,T.STRB_MENU_VIEW_MAP);
         Text.format(this.assets.information_button.label,T.STRB_MENU_INFORMATION);
         Text.format(this.assets.live_information_button.label,T.STRB_MENU_INFORMATION);
         Text.format(this.assets.emergency_button.label,T.STRB_MENU_EMERGENCY);
         super.changeLocale(e);
      }
      
      private function onWhereTo(e:WidgetEvent) : void
      {
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_WHERE_TO,0);
         Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_WHERE_TO);
      }
      
      private function onViewMap(e:WidgetEvent) : void
      {
         var ActiveRoute:Boolean = Boolean(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState);
         if(!(this.mCancelingRoute && ActiveRoute))
         {
            Peripheral.navigation.navDomainControl.clearMenuStack(1);
            Peripheral.navigation.navDomainControl.toggleMenus();
         }
      }
      
      private function onInformation(e:WidgetEvent) : void
      {
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_INFORMATION,0);
         Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_INFORMATION);
      }
      
      private function onEmergency(e:WidgetEvent) : void
      {
         Peripheral.navigation.navPoiInput.poiSelectDefaultSearchArea(PoiSearchArea.AROUND_ME);
         Peripheral.navigation.navVServices.screenHelper.showEmergencyGPSPopup(false);
         Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_EMERGENCY);
      }
      
      private function onRepeat(e:WidgetEvent) : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
         {
            if(!Peripheral.navigation.navigation.navGetAdaSpeaking())
            {
               Peripheral.navigation.navigation.navAdaRepeat();
            }
         }
      }
      
      private function onStop(e:WidgetEvent) : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
         {
            if(this.hasMoreThanOneDestination())
            {
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_STOP_ROUTING);
            }
            else
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_NAV_ASK_STOP_GUIDANCE);
            }
         }
      }
      
      private function onDetour(e:WidgetEvent) : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MAP_TURN_LIST_DETOUR);
         }
      }
      
      private function onSettings(e:WidgetEvent) : void
      {
         Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_SETTINGS);
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         if(e.data.id == DynamicPopupNames.TWOITEM_NAV_ASK_STOP_GUIDANCE)
         {
            this.mCancelingRoute = true;
            if(Global.region == TunerRegion.CHINA || Global.region == TunerRegion.JAPAN || Global.region == TunerRegion.KOREA)
            {
               Peripheral.navigation.navRouteCalculation.killRoute();
            }
            else
            {
               Peripheral.navigation.navRouteCalculation.stopGuidance();
            }
         }
      }
      
      private function onRouteGuidanceUpdate(e:RouteCalculationEvent) : void
      {
         this.stopButtonUpdate();
      }
      
      private function onRouteAlteration(e:TripAssemblerEvent) : void
      {
         this.stopButtonUpdate();
      }
      
      private function onLiveServiceStatusUpdate(e:LiveServicesEvent) : void
      {
         if(Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable)
         {
            this.assets.information_button.visible = false;
            this.assets.live_information_button.visible = true;
         }
         else
         {
            this.assets.information_button.visible = true;
            this.assets.live_information_button.visible = false;
         }
      }
      
      private function stopButtonUpdate() : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            this.assets.stop_button.setEnabled(true);
            this.assets.detour_button.setEnabled(true);
            this.assets.repeat_button.setEnabled(true);
         }
         else
         {
            this.mCancelingRoute = false;
            this.assets.stop_button.setEnabled(false);
            this.assets.detour_button.setEnabled(false);
            this.assets.repeat_button.setEnabled(false);
         }
      }
      
      private function hasMoreThanOneDestination() : Boolean
      {
         if(Peripheral.navigation.navRouteCalculation.activeRoute == null)
         {
            return false;
         }
         if(Peripheral.navigation.navRouteCalculation.activeRoute.routeElement == -1 && Peripheral.navigation.navRouteCalculation.activeRoute.Destinations.length <= 1)
         {
            return false;
         }
         if(Peripheral.navigation.navRouteCalculation.activeRoute.routeElement < Peripheral.navigation.navRouteCalculation.activeRoute.Destinations.length)
         {
            return true;
         }
         return false;
      }
   }
}

