package extensions.nav
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavGlobalSettingsCommon;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.OpenNavUtilities;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToInformation implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      private var mLiveServiceOffFeatureSelection:int = -1;
      
      private var mLiveServiceFeatureSelectionBlock:Boolean = false;
      
      private var mTTLSFunctionalTimer:Timer = null;
      
      private var mIsShow:Boolean = false;
      
      private var mIsDangerZoneCountry:Boolean = false;
      
      private var mIsTTLSAvailable:Boolean = false;
      
      private var mWasTTLSEnabled:Boolean = false;
      
      public function NavMenuWhereToInformation(parent:*)
      {
         super();
         this.mParent = parent;
         this.mParent.title = T.STRB_INFORMATION_BREADCRUMB;
         this.update();
      }
      
      public function update() : void
      {
         this.mParent.clearList();
         if(Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable)
         {
            this.setupLiveInformationList();
         }
         else
         {
            this.setupRegularList();
         }
         if(Peripheral.navigation.navLiveServices.ttlsSserviceIsSupportedBySystem)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_INFORMATION_SHARING_ML),
               "id":NavMenuWhereToConstants.LS_INFO_SHARING
            });
         }
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_INFORMATION));
         this.mParent.revalidate();
      }
      
      private function setupRegularList() : void
      {
         var isShow:Boolean = false;
         isShow = Boolean(VServiceGlobalSettings.isSupportedTMCCountry(this.getCountry(Peripheral.navigation.navigation.posPositionInformationString)));
         switch(VServiceGlobalSettings.navMarketConfig)
         {
            case VServiceGlobalSettings.MARKET_EUROPE:
            case VServiceGlobalSettings.MARKET_ROW:
               if(!Peripheral.navigation.navigation.isProduct("VP3") && isShow)
               {
                  this.mParent.pushItem({
                     "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRAFFIC),
                     "id":NavMenuWhereToConstants.TRAFFIC_EU
                  });
               }
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_WHERE_AM_I),
                  "id":NavMenuWhereToConstants.WHERE_AM_I
               });
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRIP_COMPUTER),
                  "id":NavMenuWhereToConstants.TRIP_COMPUTER
               });
               break;
            case VServiceGlobalSettings.MARKET_JAPAN:
               if(!Peripheral.navigation.navigation.isProduct("VP3") && !VServiceGlobalSettings.tmcExcludedByDestination)
               {
                  this.mParent.pushItem({
                     "label":Peripheral.localeEngine.getText(T.STRB_VICS),
                     "id":NavMenuWhereToConstants.TRAFFIC_NA
                  });
               }
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_WHERE_AM_I),
                  "id":NavMenuWhereToConstants.WHERE_AM_I
               });
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRIP_COMPUTER),
                  "id":NavMenuWhereToConstants.TRIP_COMPUTER
               });
               break;
            case VServiceGlobalSettings.MARKET_NORTH_AMERICA:
            default:
               if(!Peripheral.navigation.navigation.isProduct("VP3") && !VServiceGlobalSettings.tmcExcludedByDestination)
               {
                  this.mParent.pushItem({
                     "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRAFFIC),
                     "id":NavMenuWhereToConstants.TRAFFIC_NA
                  });
               }
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_WHERE_AM_I),
                  "id":NavMenuWhereToConstants.WHERE_AM_I
               });
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRIP_COMPUTER),
                  "id":NavMenuWhereToConstants.TRIP_COMPUTER
               });
         }
      }
      
      public function addListeners() : void
      {
         this.mLiveServiceFeatureSelectionBlock = false;
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServiceEnabled,false,0,true);
         Peripheral.navigation.navLiveServices.addEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onLiveServiceUpdate,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo,false,0,true);
         Peripheral.navigation.navigation.posGetPositionInformation();
         Peripheral.navigation.navLiveServices.requestLiveServicesEnabled();
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED,this.onLiveServiceEnabled);
         Peripheral.navigation.navLiveServices.removeEventListener(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE,this.onLiveServiceUpdate);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF);
         Framework.popupManager.dequeue(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_ERROR_MESSAGE);
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo);
         this.showPleaseWaitPopup(false);
         if(this.mTTLSFunctionalTimer)
         {
            this.mTTLSFunctionalTimer.stop();
         }
         if(Framework.popupManager.check(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
         }
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
         Framework.Trace("NavMenuInformation.onBtn( " + id + " )");
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_INFORMATION,this.mParent.getWindowIndex());
         if(this.mLiveServiceFeatureSelectionBlock)
         {
            Framework.Trace(" -Button press blocked, due to TomTom Live Service activation.");
            return;
         }
         switch(id)
         {
            case NavMenuWhereToConstants.TRAFFIC_NA:
            case NavMenuWhereToConstants.TRAFFIC_EU:
               Peripheral.navigation.navVServices.screenHelper.setTmcExternalEntry(false);
               Peripheral.navigation.navVServices.screenHelper.setTmcEventListIndex(0);
               if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_JAPAN)
               {
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_VICS);
               }
               else
               {
                  Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TMC_EVENTS_LIST);
               }
               break;
            case NavMenuWhereToConstants.WHERE_AM_I:
               Peripheral.navigation.navVServices.screenHelper.resetWhereAmIGPSPopup();
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_WHERE_AM_I);
               break;
            case NavMenuWhereToConstants.TRIP_COMPUTER:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_TRIP_COMPUTER);
               break;
            case NavMenuWhereToConstants.MY_TRAFFIC:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_MAP_DEMO_MODE_LOCATION_PICKER);
               break;
            case NavMenuWhereToConstants.LS_HD_TRAFFIC:
            case NavMenuWhereToConstants.LS_LOCAL_SEARCH:
            case NavMenuWhereToConstants.LS_SPEED_CAMERAS:
            case NavMenuWhereToConstants.LS_WEATHER:
               this.goToLiveService(id);
               break;
            case NavMenuWhereToConstants.LS_INFO_SHARING:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_CONSENT_REVIEW);
               break;
            case NavMenuWhereToConstants.LS_SERVICE_TURN_OFF:
            case NavMenuWhereToConstants.LS_SERVICE_TURN_ON:
               if(Peripheral.navigation.navLiveServices.ttlsGeneralServiceAvailable)
               {
                  this.mWasTTLSEnabled = this.liveServicesEnabled;
                  Peripheral.navigation.navLiveServices.enableLiveServices(!this.liveServicesEnabled);
               }
               else
               {
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
               }
               break;
            default:
               Framework.Trace("NavMenuInformation.onBtn( " + id + " ) has no function yet!");
         }
      }
      
      private function onLiveServiceEnabled(e:LiveServicesEvent) : void
      {
         var oldIsTTLSAvailable:Boolean = this.mIsTTLSAvailable;
         this.mIsTTLSAvailable = Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable;
         if(this.mIsTTLSAvailable != oldIsTTLSAvailable || this.mWasTTLSEnabled != this.liveServicesEnabled)
         {
            oldIsTTLSAvailable = this.mIsTTLSAvailable;
            this.mWasTTLSEnabled = this.liveServicesEnabled;
            this.setScreenTitle();
            this.update();
         }
      }
      
      private function onLiveServiceUpdate(e:LiveServicesEvent) : void
      {
         if(this.mLiveServiceFeatureSelectionBlock)
         {
            if(this.isSelectedServiceFunctional)
            {
               this.switchToSelectedService();
            }
         }
      }
      
      private function setScreenTitle() : void
      {
         if(Peripheral.navigation.navLiveServices.ttlsUConnectACNAvailable)
         {
            this.mParent.title = T.STRB_LIVE_INFORMATION;
         }
         else
         {
            this.mParent.title = T.STRB_INFORMATION_BREADCRUMB;
         }
      }
      
      private function get liveServicesEnabled() : Boolean
      {
         return Peripheral.navigation.navLiveServices.liveServicesEnabled;
      }
      
      private function goToLiveService(id:int) : void
      {
         this.mLiveServiceOffFeatureSelection = id;
         if(!Peripheral.navigation.navLiveServices.ttlsGeneralServiceAvailable)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
         }
         else if(!this.liveServicesEnabled)
         {
            this.showPopupTurnOnLiveServices();
         }
         else if(this.isSelectedServiceFunctional)
         {
            this.switchToSelectedService();
         }
         else
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
         }
      }
      
      private function get isSelectedServiceFunctional() : Boolean
      {
         switch(this.mLiveServiceOffFeatureSelection)
         {
            case NavMenuWhereToConstants.LS_LOCAL_SEARCH:
               return Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_LOCALSEARCH);
            case NavMenuWhereToConstants.LS_WEATHER:
               return Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_WEATHER);
            case NavMenuWhereToConstants.LS_HD_TRAFFIC:
               return Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_TRAFFIC);
            case NavMenuWhereToConstants.LS_SPEED_CAMERAS:
               return Boolean(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_SPEEDCAM)) || Boolean(Peripheral.navigation.navLiveServices.ttlsServiceFunctional(AuthenticationTypes.TTLS_SERVICE_SPEEDCAM_FEEDBACK));
            default:
               return false;
         }
      }
      
      private function setupLiveInformationList() : void
      {
         if(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_TRAFFIC))
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_HD_TRAFFIC),
               "id":NavMenuWhereToConstants.LS_HD_TRAFFIC
            });
         }
         if(Boolean(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_SPEEDCAM_INFO)) || Boolean(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_SPEEDCAM_FEEDBACK)))
         {
            if(this.mIsDangerZoneCountry)
            {
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_DANGER_ZONE),
                  "id":NavMenuWhereToConstants.LS_SPEED_CAMERAS
               });
            }
            else if(this.mIsShow)
            {
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_SPEED_CAMERAS),
                  "id":NavMenuWhereToConstants.LS_SPEED_CAMERAS
               });
            }
         }
         if(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_LOCAL_SEARCH))
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_LOCAL_SEARCH),
               "id":NavMenuWhereToConstants.LS_LOCAL_SEARCH
            });
         }
         if(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_WEATHER))
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_WEATHER),
               "id":NavMenuWhereToConstants.LS_WEATHER
            });
         }
         if(Boolean(Peripheral.navigation.navLiveServices.ttlsGeneralServiceAvailable) && this.liveServicesEnabled)
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_TURN_OFF_LIVE_SERV_ML),
               "id":NavMenuWhereToConstants.LS_SERVICE_TURN_OFF
            });
         }
         else
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_TURN_ON_LIVE_SERV_ML),
               "id":NavMenuWhereToConstants.LS_SERVICE_TURN_ON
            });
         }
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_WHERE_AM_I),
            "id":NavMenuWhereToConstants.WHERE_AM_I
         });
         this.mParent.pushItem({
            "label":Peripheral.localeEngine.getText(T.STRB_MENU_TRIP_COMPUTER),
            "id":NavMenuWhereToConstants.TRIP_COMPUTER
         });
      }
      
      private function gotoHdTraffic() : void
      {
         if(Peripheral.navigation.navRouteCalculation.activeRoute)
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_TRAFFIC_ENTRY_MAP);
         }
         else
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN);
         }
      }
      
      private function showPopupTurnOnLiveServices() : void
      {
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         if(!Framework.popupManager.check(DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF))
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF);
         }
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         if(e.data.id == DynamicPopupNames.TWOITEM_NAV_LIVE_SERVICES_IS_TURNED_OFF)
         {
            Peripheral.navigation.navLiveServices.enableLiveServices(true);
            if(this.isSelectedServiceFunctional)
            {
               this.switchToSelectedService();
            }
            else
            {
               this.showPleaseWaitPopup(true);
               this.mLiveServiceFeatureSelectionBlock = true;
            }
         }
      }
      
      private function switchToSelectedService() : void
      {
         switch(this.mLiveServiceOffFeatureSelection)
         {
            case NavMenuWhereToConstants.LS_SPEED_CAMERAS:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS);
               break;
            case NavMenuWhereToConstants.LS_WEATHER:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_WEATHER);
               break;
            case NavMenuWhereToConstants.LS_HD_TRAFFIC:
               this.gotoHdTraffic();
               break;
            case NavMenuWhereToConstants.LS_LOCAL_SEARCH:
               Peripheral.navigation.navLiveServices.setLocalSearchMainTripAssemblerMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH);
               break;
            default:
               Framework.Trace("onTwoItemPopupLeftClick() Unknown Selection (" + this.mLiveServiceOffFeatureSelection + ")");
         }
      }
      
      private function showPleaseWaitPopup(show:Boolean) : void
      {
         if(show)
         {
            Framework.popupManager.show(DynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
            if(!this.mTTLSFunctionalTimer)
            {
               this.mTTLSFunctionalTimer = new Timer(NavGlobalSettingsCommon.TTLS_SERVICE_FUNCTIONAL_TIMEOUT,1);
               this.mTTLSFunctionalTimer.addEventListener(TimerEvent.TIMER,this.onTTLSTurnOnTimeout,false,0,true);
               this.mTTLSFunctionalTimer.start();
            }
         }
         else if(Framework.popupManager.check(DynamicPopupNames.PLEASE_WAIT))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
         }
      }
      
      private function onTTLSTurnOnTimeout(e:TimerEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.ONEITEM_NAV_LIVE_SERVICES_NOT_AVAILABLE);
         this.mTTLSFunctionalTimer.stop();
         this.mTTLSFunctionalTimer = null;
         this.mLiveServiceFeatureSelectionBlock = false;
      }
      
      private function checkConnectionEstablished() : Boolean
      {
         return true;
      }
      
      private function getCountry(str:String) : String
      {
         return OpenNavUtilities.getValueOfType(str,OpenNavUtilities.c_EIS_CAB);
      }
      
      private function onPositionInfo(e:NavigationEvent) : void
      {
         var old:Boolean = this.mIsShow;
         var oldDangerZone:Boolean = this.mIsDangerZoneCountry;
         var mCountry:String = this.getCountry(Peripheral.navigation.navigation.posPositionInformationString);
         this.mIsShow = VServiceGlobalSettings.isSupportedSpeedCamCountry(mCountry);
         this.mIsDangerZoneCountry = VServiceGlobalSettings.isSupportedDangerZoneCountry(mCountry);
         if(this.mIsShow != old || this.mIsDangerZoneCountry != oldDangerZone)
         {
            this.update();
         }
      }
   }
}

