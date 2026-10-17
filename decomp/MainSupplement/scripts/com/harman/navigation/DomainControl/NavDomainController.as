package com.harman.navigation.DomainControl
{
   import com.harman.moduleLinkAPI.PersistencyEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.navigation.Controller.LI.LocationInputApi;
   import com.harman.navigation.Controller.LI.LocationInputImpl;
   import com.harman.navigation.Controller.LiveServices.ConsentStates;
   import com.harman.navigation.Controller.LiveServices.LiveServicesApi;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.Controller.LiveServices.LiveServicesImpl;
   import com.harman.navigation.Controller.MAP.MapControllerApi;
   import com.harman.navigation.Controller.MAP.MapControllerImpl;
   import com.harman.navigation.Controller.MAP.utils.MapConfiguration;
   import com.harman.navigation.Controller.POI.PoiInputApi;
   import com.harman.navigation.Controller.POI.PoiInputImpl;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerApi;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerImpl;
   import com.harman.navigation.DomainControl.menuStack.MenuStack;
   import com.harman.navigation.DomainControl.menuStack.MenuStackManager;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.Shortcuts;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.span.Client;
   import core.enums.PopupType;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   
   use namespace NavigationNamespace;
   
   public class NavDomainController extends EventDispatcher implements INavDomain
   {
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mNavReady:Boolean;
      
      private var mInitialized:Boolean = false;
      
      private var mMenuStackManager:MenuStackManager = new MenuStackManager();
      
      private var mNavGlobalPopupController:NavGlobalPopupController = new NavGlobalPopupController();
      
      private var mActiveStackID:int = 0;
      
      private var mNavDomainActive:Boolean = false;
      
      private var mExternalDestinationHelper:ExternalDestinationsHandler = new ExternalDestinationsHandler();
      
      public function NavDomainController()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mNavReady = false;
         this.mMenuStackManager.createStack("menu",NavMenus.MENU_MAIN);
         this.mMenuStackManager.createStack("map",NavMenus.MENU_MAP_MAIN);
         this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
         this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
         NavigationApi.impl = NavigationImpl.create();
         NavigationApi.api.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavReady,false,0,true);
         NavigationApi.api.navGetIsReady();
         NavigationApi.api.addEventListener(NavigationEvent.NAV_ACTIVATION,this.onNavActivation,false,0,true);
         NavigationApi.api.navGetIsActivated();
         NavigationApi.api.addEventListener(NavigationEvent.NAV_FACTORY_RESET,this.onFactoryReset,false,0,true);
         NavigationPackage.peripheral.persistency.addEventListener(PersistencyKeys.KEY_DISCLAIMER_ACCEPTED,this.onDisclaimerAccepted,false,0,true);
         NavigationPackage.peripheral.persistency.read(PersistencyKeys.KEY_DISCLAIMER_ACCEPTED);
         LiveServicesApi.impl = LiveServicesImpl.create();
         LiveServicesApi.api.addEventListener(LiveServicesEvent.LS_USER_CONSENT_UPDATE,this.onTomTomLiveServiceUserConsentUpdate,false,0,true);
      }
      
      private function onNavReady(e:NavigationEvent) : void
      {
         if(this.mNavReady)
         {
            if(NavigationApi.api.navIsReady)
            {
               return;
            }
         }
         if(NavigationApi.api.navIsReady && !this.mInitialized)
         {
            Framework.Trace("NAV is ready - continue");
            this.mInitialized = true;
            LocationInputApi.impl = LocationInputImpl.create();
            LocationInputApi.api.liSetResultsPerPage(NavGlobalSettings.LIST_SIZE);
            PoiInputApi.impl = PoiInputImpl.create();
            TripAssemblerApi.impl = TripAssemblerImpl.create();
            MapControllerApi.impl = MapControllerImpl.create();
            this.mNavGlobalPopupController.init();
            Framework.Trace("Navigation is accessible");
            this.mNavReady = NavigationApi.api.navIsReady;
            this.sendEvent(NavDomainControllerEvent.NAV_IS_OPERABLE);
            if(this.mNavDomainActive)
            {
               Framework.Trace("NavDomainController.onNavReady() Disable \"Nav is being activated...\"");
               this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
            }
         }
      }
      
      private function onNavActivation(e:NavigationEvent) : void
      {
         if(this.mNavDomainActive == true)
         {
            this.checkNavActivationIsValid();
         }
      }
      
      private function checkNavActivationIsValid() : Boolean
      {
         if(NavigationPackage.peripheral.navigation.navigation.navIsActivated == false)
         {
            if(this.mActiveStackID == 1)
            {
               this.mActiveStackID = 0;
            }
            this.sendInternalScreenChangeNotification();
            this.mMenuStackManager.getStack(0).clearAll();
            this.mNavDomainActive = true;
            NavigationPackage.peripheral.navigation.navProductActivation.activate();
            return false;
         }
         return true;
      }
      
      public function switchToMenu(menuID:int) : void
      {
         this.mMenuStackManager.getStack(this.mActiveStackID).addMenu(menuID);
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
      }
      
      public function onBackButtonPress() : void
      {
         this.setBackFlag();
         if(this.mMenuStackManager.getStack(this.mActiveStackID).removeLastMenu() == false)
         {
            this.toggleMenus();
         }
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU,{"back":true});
      }
      
      public function setBackFlag() : void
      {
         this.mMenuStackManager.getStack(this.mActiveStackID).setBackFlag();
      }
      
      public function onCancelButtonPress() : void
      {
         this.mMenuStackManager.getStack(this.mActiveStackID).clearAll();
         if(this.mActiveStackID == 0)
         {
            this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
         }
         else
         {
            this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
         }
         this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
      }
      
      public function clearMenuStack(stack:int) : void
      {
         this.mMenuStackManager.getStack(stack).clearAll();
         if(stack == 0)
         {
            this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
         }
         else
         {
            this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
         }
      }
      
      public function getNavIsOperable() : void
      {
         this.sendEvent(NavDomainControllerEvent.NAV_IS_OPERABLE);
      }
      
      public function addMenuToStackPassive(menuID:int, stack:int) : void
      {
         Framework.Trace("NavDomainCtrl.addMenuToStackPassive( " + menuID + ", " + stack + " )");
         this.mMenuStackManager.getStack(stack).addMenu(menuID);
      }
      
      public function addMenuToStackNoAction(menuID:int, stack:int) : void
      {
         if(!this.mNavDomainActive)
         {
            Framework.Trace("NavDomainCtrl.addMenuToStackNoAction( " + menuID + ", " + stack + " )");
            this.mMenuStackManager.getStack(stack).setBaseMenu(menuID);
         }
         else
         {
            Framework.Trace("NavDomainCtrl.addMenuToStackNoAction( " + menuID + ", " + stack + " ) --> Called when !NavDomainActive -> BLOCKED!");
         }
      }
      
      public function switchToMenuStackPassive(menuStack:int) : void
      {
         Framework.Trace("NavDomainCtrl.switchToMenuStackPassive( " + menuStack + " )");
         this.mActiveStackID = menuStack;
      }
      
      public function removeTopMenuFromStackPassive() : void
      {
         this.mMenuStackManager.getStack(this.mActiveStackID).removeLastMenuNoAction();
      }
      
      public function get navIsOperable() : Boolean
      {
         return this.mNavReady;
      }
      
      public function onNavDomainButton() : void
      {
         this.checkExternalTmcException();
         if(this.checkNavActivationIsValid())
         {
            if(this.mNavReady)
            {
               switch(LiveServicesApi.api.consentState)
               {
                  case ConsentStates.CONSENT_STATE_CONFIRMED:
                  case ConsentStates.CONSENT_STATE_DECLINED:
                  case ConsentStates.CONSENT_STATE_LIVE_SERVICE_NOT_SUPPORTED:
                     if(this.mNavDomainActive)
                     {
                        if(this.checkNavActivationIsValid())
                        {
                           if(this.mActiveStackID == 1)
                           {
                              this.mActiveStackID = 0;
                              this.mMenuStackManager.getStack(1).clearAll();
                              this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
                           }
                           this.sendInternalScreenChangeNotification();
                           this.mMenuStackManager.getStack(0).clearAll();
                           this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
                           if(NavigationPackage.peripheral.navigation.navigation.langIsLanguageChangeInProgress)
                           {
                              NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LANGUAGE_CHANGE_POPUP);
                           }
                           this.onDisclaimerAccepted(null);
                           this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
                           this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
                        }
                     }
                     else
                     {
                        this.mNavDomainActive = true;
                        Framework.Trace("NavDomainController.enterNavDomain() " + this.mNavReady);
                        this.enterNavDomain();
                     }
                     break;
                  case ConsentStates.CONSENT_STATE_EXPIRED:
                  case ConsentStates.CONSENT_STATE_UNDEFINED:
                     Framework.Trace("NavDomainController.enterNavDomain() Display the Consent-Flow");
                     this.mMenuStackManager.getStack(0).clearAll();
                     this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_LIVE_SERVICES_CONSENT_DISCLAIMER);
                     if(this.mActiveStackID == 1)
                     {
                        this.mActiveStackID = 0;
                     }
                     if(NavigationPackage.peripheral.navigation.navigation.langIsLanguageChangeInProgress)
                     {
                        NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LANGUAGE_CHANGE_POPUP);
                     }
                     this.mNavDomainActive = true;
                     this.enterNavDomain();
                     break;
                  case ConsentStates.CONSENT_STATE_WAITING:
                  case ConsentStates.CONSENT_STATE_UNKNOWN:
                     this.mNavDomainActive = true;
                     Framework.structure.goto("mainbackground/menu/navpopupgenericscreen",null,false);
               }
            }
            else
            {
               this.mNavDomainActive = true;
               Framework.Trace("Show \"Navigation is being activated.\"");
               this.onDisclaimerAccepted(null);
               Framework.structure.goto("mainbackground/menu/navpopupgenericscreen",null,false);
            }
         }
      }
      
      private function onDisclaimerAccepted(e:PersistencyEvent) : void
      {
         if(NavigationPackage.peripheral.persistency.getValue(PersistencyKeys.KEY_DISCLAIMER_ACCEPTED).value == "false" && this.navDomainActive)
         {
            Framework.popupManager.show(NavigationPackage.dynamicPopupNames.DISCLAIMER,"PopupNavDisclaimer.swf",{"type":PopupType.PRIMARY});
         }
      }
      
      private function onTomTomLiveServiceUserConsentUpdate(e:LiveServicesEvent) : void
      {
         if(this.mNavDomainActive)
         {
            this.onNavDomainButton();
         }
      }
      
      private function enterNavDomain() : void
      {
         if(!this.checkNavActivationIsValid())
         {
            return;
         }
         this.onDisclaimerAccepted(null);
         this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
         this.sendEvent(NavDomainControllerEvent.NAV_IS_ACTIVE);
      }
      
      public function exitNavDomain() : void
      {
         if(this.mNavDomainActive)
         {
            if(EventDispatcher(this).hasEventListener(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE))
            {
               this.sendEvent(NavDomainControllerEvent.NAV_EXTERNAL_FORCED_DOMAIN_CHANGE);
            }
            this.mMenuStackManager.getStack(this.mActiveStackID).deactivateCurrentMenu();
            this.mNavDomainActive = false;
            this.sendEvent(NavDomainControllerEvent.NAV_IS_ACTIVE);
         }
      }
      
      public function toggleMenus() : void
      {
         if(!this.mNavReady)
         {
            Framework.Trace("Show \"Navigation is being activated.\"");
            return;
         }
         this.mMenuStackManager.getStack(this.mActiveStackID).deactivateCurrentMenu();
         if(this.mActiveStackID == 1)
         {
            this.mActiveStackID = 0;
         }
         else
         {
            this.mActiveStackID = 1;
         }
         this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
      }
      
      public function getNavDomainActive() : void
      {
         this.sendEvent(NavDomainControllerEvent.NAV_IS_ACTIVE);
      }
      
      public function get navDomainActive() : Boolean
      {
         return this.mNavDomainActive;
      }
      
      public function get mapMenuStackIsActive() : Boolean
      {
         if(this.mNavDomainActive)
         {
            if(this.mActiveStackID == 1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get mapMenuStackIsSelected() : Boolean
      {
         return this.mActiveStackID == 1 ? true : false;
      }
      
      public function setSprite(window:Sprite) : void
      {
         NavMenus.mWindow = window;
      }
      
      public function getNavActiveMenu() : void
      {
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
      }
      
      public function get navActiveMenu() : int
      {
         return MenuStack(this.mMenuStackManager.getStack(this.mActiveStackID)).currentMenu;
      }
      
      public function moveBackToMenu(navMenuID:int) : void
      {
         this.mMenuStackManager.getStack(this.mActiveStackID).goBackToMenu(navMenuID);
      }
      
      public function enableMediaMap(enable:Boolean) : void
      {
         if(this.mNavReady)
         {
            if(enable)
            {
               MapControllerApi.api.selectConfiguration(MapConfiguration.MAP_MEDIA);
            }
            else if(MapControllerApi.api.mapConfiguration == MapConfiguration.MAP_MEDIA)
            {
               MapControllerApi.api.selectConfiguration(MapConfiguration.UNDEFINED);
            }
         }
         this.sendEvent(NavDomainControllerEvent.NAV_MEDIA_MAP);
      }
      
      public function getMediaMapEnabled() : void
      {
         this.sendEvent(NavDomainControllerEvent.NAV_MEDIA_MAP);
      }
      
      public function get mediaMapEnabled() : Boolean
      {
         if(this.mNavReady)
         {
            if(MapControllerApi.api.mapConfiguration == MapConfiguration.MAP_MEDIA)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function setExternalDestination(dest:String, backFunction:String) : void
      {
         Framework.Trace("NavDomainController.setExternalDestination(\n   " + dest + "\n   " + backFunction + " )\n");
         if(this.mNavDomainActive == true)
         {
            Framework.Trace("-> rejected, as Nav Domain is active!");
            this.sendEvent(NavDomainControllerEvent.NAV_DESTINATION_REFUSED);
            return;
         }
         if(this.mExternalDestinationHelper.setExternalDestination(dest,backFunction) == false)
         {
            this.sendEvent(NavDomainControllerEvent.NAV_DESTINATION_REFUSED);
         }
         else
         {
            this.mNavDomainActive = true;
         }
      }
      
      public function addContactToFavoriteDestinations(name:String, phoneNumber:String, returnScreen:Object) : Boolean
      {
         if(this.addContactToFavoriteDestinationsAvailable)
         {
            if(this.mActiveStackID == 1)
            {
               Framework.Trace("NavDomainController.addContactToFavoriteDestinations() switch to mActiveStackID \'0\'");
               this.mActiveStackID = 0;
            }
            this.clearMenuStack(0);
            this.addMenuToStackPassive(NavMenus.MENU_DOMAIN_RETURN_SWITCH_MARKER,0);
            this.mMenuStackManager.getStack(this.mActiveStackID).setDomainSwitchScreenName(returnScreen);
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setAddContactToFavoriteDestinationsName(name);
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setAddContactToFavoriteDestinationsPhoneNumber(phoneNumber);
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_CONTACT,0);
            this.switchToMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_CONTACT);
            this.mNavDomainActive = true;
            return true;
         }
         return false;
      }
      
      public function get addContactToFavoriteDestinationsAvailable() : Boolean
      {
         if(this.isReady() && !this.navDomainActive && NavigationPackage.peripheral.navigation.navFavoriteDestinations.maxListSize > NavigationPackage.peripheral.navigation.navFavoriteDestinations.list.length)
         {
            return true;
         }
         return false;
      }
      
      public function goToTmcScreenFromOutSideOfNavDomain() : Boolean
      {
         if(this.isReady() && !this.navDomainActive)
         {
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setTmcExternalEntry(true);
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setTmcEventListIndex(0);
            this.switchToMenu(NavMenus.MENU_TMC_EVENTS_LIST);
            this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
            return true;
         }
         return false;
      }
      
      public function requestVRShortcut(vrShortcut:String) : void
      {
         var navShortcut:int = Shortcuts.INVALID_NAV_SHORTCUT;
         switch(vrShortcut)
         {
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION:
               navShortcut = Shortcuts.NAVIGATION_DOMAIN;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_ADDRESS:
               navShortcut = Shortcuts.LI_ADDRESS;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_POI:
               navShortcut = Shortcuts.LI_POI;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_MY_DESTINATIONS:
               navShortcut = Shortcuts.MY_DESTINATIONS;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_RECENT_DESTINATIONS:
               navShortcut = Shortcuts.RECENT_DESTINATIONS;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_WHERE_TO:
               navShortcut = Shortcuts.WHERE_TO;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_ROUTE_CONFIRM:
               navShortcut = Shortcuts.VR_DESTINATION_ENTRY;
               break;
            case NavigationPackage.peripheral.voiceRecognition.NAVIGATION_MAP:
               navShortcut = Shortcuts.NAVIGATION_MAP;
               break;
            default:
               Framework.Trace("unhandled VR Shortcut: " + vrShortcut);
         }
         if(navShortcut != Shortcuts.INVALID_NAV_SHORTCUT)
         {
            this.requestShortcut(navShortcut);
         }
      }
      
      public function requestShortcut(shortcutID:int) : void
      {
         Framework.Trace("NavDomainController.requestShortcut( " + shortcutID + " )");
         if(!this.mNavReady)
         {
            if(this.checkNavActivationIsValid())
            {
               this.onNavDomainButton();
            }
            return;
         }
         switch(shortcutID)
         {
            case Shortcuts.NAVIGATION_DOMAIN:
               if(this.mMenuStackManager.getStack(this.mActiveStackID).currentMenu == NavMenus.MENU_DOMAIN_RETURN_SWITCH_MARKER)
               {
                  Framework.Trace(" -Removing \'MENU_DOMAIN_RETURN_SWITCH_MARKER\' from stack.");
                  this.mMenuStackManager.getStack(this.mActiveStackID).removeLastMenuNoAction();
               }
               this.onNavDomainButton();
               return;
            case Shortcuts.WHERE_TO:
               this.mNavDomainActive = true;
               this.mMenuStackManager.getStack(0).clearAll();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_WHERE_TO);
               this.sendInternalScreenChangeNotification();
               break;
            case Shortcuts.MY_DESTINATIONS:
               this.mNavDomainActive = true;
               this.mMenuStackManager.getStack(0).clearAll();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_WHERE_TO);
               this.sendInternalScreenChangeNotification();
               NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               NavigationPackage.peripheral.navigation.navVServices.screenHelper.resetFavoriteDestinationsListResetIndex();
               NavigationPackage.peripheral.navigation.navVServices.screenHelper.setFavoriteDestinationsListShowAddButton(true);
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
               break;
            case Shortcuts.RECENT_DESTINATIONS:
               this.mNavDomainActive = true;
               this.mMenuStackManager.getStack(0).clearAll();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_WHERE_TO);
               this.sendInternalScreenChangeNotification();
               NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               NavigationPackage.peripheral.navigation.navVServices.screenHelper.resetMyDestinationsWindowIndex();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MY_DESTINATIONS);
               break;
            case Shortcuts.LI_ADDRESS:
            case Shortcuts.LI_POI:
            case Shortcuts.VR_DESTINATION_ENTRY:
               this.mNavDomainActive = true;
               NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               NavigationPackage.peripheral.navigation.navVoiceRecognition.indicateNewDestinationEntrySessionForDefaultCountryRecovery();
               this.sendInternalScreenChangeNotification();
               this.mMenuStackManager.getStack(0).clearAll();
               this.mMenuStackManager.getStack(1).clearAll();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
               this.mMenuStackManager.getStack(this.mActiveStackID).addMenu(NavMenus.MENU_VR_DESTINATION_ENTRY);
               this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
               this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
               return;
            case Shortcuts.LI_FAVORITES:
               this.mNavDomainActive = true;
               this.mMenuStackManager.getStack(0).clearAll();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_WHERE_TO);
               this.sendInternalScreenChangeNotification();
               NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_ROUTE_TO);
               NavigationPackage.peripheral.navigation.navVServices.screenHelper.resetMyDestinationsWindowIndex();
               this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
               break;
            case Shortcuts.NAVIGATION_MAP:
               this.mNavDomainActive = true;
               this.mMenuStackManager.getStack(1).clearAll();
               this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
               this.sendInternalScreenChangeNotification();
               if(this.mActiveStackID == 0)
               {
                  this.mActiveStackID = 1;
                  this.mMenuStackManager.getStack(0).clearAll();
                  this.mMenuStackManager.getStack(0).setBaseMenu(NavMenus.MENU_MAIN);
               }
               this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
               this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
               return;
            case Shortcuts.REPEAT_PROMPT:
               NavigationPackage.peripheral.navigation.navVoiceRecognition.repeatNavPrompt();
               return;
            default:
               Framework.Trace("NavDomainController.requestShortcut( " + shortcutID + " ) Shortcut not supported -> No action");
               return;
         }
         if(this.mActiveStackID == 1)
         {
            this.mActiveStackID = 0;
            this.mMenuStackManager.getStack(1).clearAll();
            this.mMenuStackManager.getStack(1).setBaseMenu(NavMenus.MENU_MAP_MAIN);
         }
         this.mMenuStackManager.getStack(this.mActiveStackID).reactivateCurrentMenu();
         this.sendEvent(NavDomainControllerEvent.NAV_ACTIVE_MENU);
      }
      
      private function onFactoryReset(e:NavigationEvent) : void
      {
         this.factoryReset();
      }
      
      public function factoryReset() : void
      {
         Framework.Trace("NavDomainController.factoryReset()");
         NavigationPackage.peripheral.navigation.navMapControl.factoryReset();
         NavigationPackage.peripheral.navigation.navGeoCoordinate.factoryReset();
      }
      
      private function sendEvent(eventType:String, obj:Object = null) : void
      {
         this.dispatchEvent(new NavDomainControllerEvent(eventType,obj));
      }
      
      private function sendInternalScreenChangeNotification() : void
      {
         if(EventDispatcher(this).hasEventListener(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU))
         {
            this.sendEvent(NavDomainControllerEvent.NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU);
         }
      }
      
      private function checkExternalTmcException() : void
      {
         if(NavigationPackage.peripheral.navigation.navVServices.screenHelper.TmcExternalEntry == true)
         {
            NavigationPackage.peripheral.navigation.navVServices.screenHelper.setTmcExternalEntry(false);
            if(this.mMenuStackManager.getStack(this.mActiveStackID).currentMenu == NavMenus.MENU_TMC_EVENTS_ZOOM)
            {
               this.removeTopMenuFromStackPassive();
            }
            if(this.mMenuStackManager.getStack(this.mActiveStackID).currentMenu == NavMenus.MENU_TMC_EVENTS_LIST)
            {
               this.removeTopMenuFromStackPassive();
            }
         }
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return NavigationApi.api.navIsReady;
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
   }
}

