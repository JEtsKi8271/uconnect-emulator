package extensions.nav
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.tmc.TmcTypes;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToLSHdTraffic implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      private var mLiveServiceOffFeatureSelection:int = -1;
      
      public function NavMenuWhereToLSHdTraffic(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_HD_TRAFFIC;
         this.update();
      }
      
      public function update() : void
      {
         this.mParent.clearList();
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MINIMIZE_DELAYS),
            "id":NavMenuWhereToConstants.LS_HDT_MINIMIZE_DELAYS
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_SHOW_TRAFFIC),
            "id":NavMenuWhereToConstants.LS_HDT_SHOW_TRAFFIC
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_VIEW_MAP),
            "id":NavMenuWhereToConstants.LS_HDT_VIEW_MAP
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_CHANGE_HOMEWORK_ML),
            "id":NavMenuWhereToConstants.LS_HDT_CHANGE_HOME_WORK
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_TO_WORK),
            "id":NavMenuWhereToConstants.LS_HDT_TO_WORK
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_TO_HOME),
            "id":NavMenuWhereToConstants.LS_HDT_TO_HOME
         });
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN));
         this.mParent.revalidate();
      }
      
      public function addListeners() : void
      {
      }
      
      public function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF);
         Framework.popupManager.dequeue(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_ROUTE_OPTIMIZED);
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
         Framework.Trace("NavMenuHdTraffic.onBtn( " + id + " )");
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN,this.mParent.getWindowIndex());
         switch(id)
         {
            case NavMenuWhereToConstants.LS_HDT_MINIMIZE_DELAYS:
               if(Peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
               {
                  if(Peripheral.navigation.navigation.TMCRouteMode == TmcTypes.ROUTE_MODE_DELAY && Peripheral.navigation.navigation.TMCDelayTime == NavGlobalSettings.TMC_DEFAULT_DELAY_TIME)
                  {
                     Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_ROUTE_OPTIMIZED);
                  }
                  else
                  {
                     Peripheral.navigation.navigation.setTMCRouteMode(TmcTypes.ROUTE_MODE_DELAY);
                     Peripheral.navigation.navigation.setTMCDelayTime(NavGlobalSettings.TMC_DEFAULT_DELAY_TIME);
                  }
               }
               break;
            case NavMenuWhereToConstants.LS_HDT_SHOW_TRAFFIC:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TMC_EVENTS_LIST);
               break;
            case NavMenuWhereToConstants.LS_HDT_VIEW_MAP:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_TRAFFIC_MAP);
               break;
            case NavMenuWhereToConstants.LS_HDT_CHANGE_HOME_WORK:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_HDT_CHANGE_HOME_WORK);
               break;
            case NavMenuWhereToConstants.LS_HDT_TO_WORK:
               if(Peripheral.navigation.navLiveServices.workAddressIsValid)
               {
                  Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_WORK);
                  Peripheral.navigation.navTripAssembler.addLocationDescription(Peripheral.navigation.navLiveServices.workAddress);
               }
               else
               {
                  this.showEnterAddressPopup(DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_WORK_ADDRESS_NOW);
               }
               break;
            case NavMenuWhereToConstants.LS_HDT_TO_HOME:
               if(Peripheral.navigation.navLiveServices.homeAddressIsValid)
               {
                  Peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_LIVE_SERVICES_ROUTE_HOME);
                  Peripheral.navigation.navTripAssembler.addLocationDescription(Peripheral.navigation.navLiveServices.homeAddress);
               }
               else
               {
                  this.showEnterAddressPopup(DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_HOME_ADDRESS_NOW);
               }
               break;
            default:
               Framework.Trace("NavMenuHdTraffic.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      private function showEnterAddressPopup(popupID:int) : void
      {
         if(!Framework.popupManager.check(popupID))
         {
            Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
            Ancillary.definedDynamicPopups.popup(popupID);
         }
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         if(e.data.id == DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_HOME_ADDRESS_NOW)
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME);
         }
         if(e.data.id == DynamicPopupNames.TWOITEM_NAV_ASK_ENTER_WORK_ADDRESS_NOW)
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK);
         }
      }
   }
}

