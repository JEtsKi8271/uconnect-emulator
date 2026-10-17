package screens.NA_EU.RES_640x480
{
   import ancillary.Screens;
   import com.harman.framework.template.ScreenGeneric;
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.navigation.Controller.MAP.utils.MapConfiguration;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.enums.TripAssemblerMenu;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import core.events.FrameworkEvent;
   import core.utils.Text;
   import events.LocaleEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class MainBackgroundScreen extends ScreenGeneric
   {
      
      private static const BACKGROUND_NOR:String = "NOR";
      
      private static const BACKGROUND_APP:String = "APP";
      
      private static const BACKGROUND_MAP:String = "MAP";
      
      private static const BACKGROUND_SPL:String = "SPL";
      
      private static const BACKGROUND_WEA:String = "WEA";
      
      private static const BACKGROUND_DMB:String = "DMB";
      
      private static const BACKGROUND_DTV:String = "DTV";
      
      private static const BACKGROUND_VICS:String = "VICS";
      
      private static const BACKGROUND_PROJ:String = "PROJ";
      
      private var mView:C_MainBackgroundView = new C_MainBackgroundView();
      
      private var mMapConfig:int = -1;
      
      private var mBackground:String = "NORMAL";
      
      public function MainBackgroundScreen()
      {
         view = this.mView as MovieClip;
         this.mView.loading.visible = false;
         this.mView.maskFull.visible = false;
         this.mView.maskSplitWea.visible = false;
         this.mView.maskSplitMap.visible = false;
         this.mView.maskSplitDMB.visible = false;
         this.mView.maskSplitDTV.visible = false;
         this.mView.maskSplitVICS.visible = false;
         this.mView.maskProjection.visible = false;
         this.mView.day.visible = Peripheral.personalConfig.displayMode == "day";
         this.mView.night.visible = Peripheral.personalConfig.displayMode != "day";
         super();
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource,false,0,true);
         Peripheral.shortTermDTVManager.addEventListener(Event.CHANGE,this.onDTVChange,false,0,true);
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavIsOperable,false,0,true);
         Framework.screens.addEventListener(FrameworkEvent.IDLE,this.onScreenChange,false,0,true);
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_VISIBILITY_CHANGE,this.onLayerVisibility,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SPLITSCREEN,this.onSplitScreen,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISPLAYMODE,this.onDisplayMode,false,0,true);
         Peripheral.localeEngine.addEventListener(LocaleEvent.CHANGE,this.changeLocale,false,0,true);
         Peripheral.personalConfig.getDisplayMode();
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.DND_STATUS,this.onVRDNDStatus,false,0,true);
         screenInComplete();
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
         Peripheral.audioManager.removeEventListener(AudioEvent.SOURCE,this.onSource);
         Peripheral.shortTermDTVManager.removeEventListener(Event.CHANGE,this.onDTVChange);
         Peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavIsOperable);
         Framework.screens.removeEventListener(FrameworkEvent.IDLE,this.onScreenChange);
         Peripheral.displayManager.removeEventListener(DisplayManagerEvent.DISPLAY_VISIBILITY_CHANGE,this.onLayerVisibility);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SPLITSCREEN,this.onSplitScreen);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.DISPLAYMODE,this.onDisplayMode);
         Peripheral.localeEngine.removeEventListener(LocaleEvent.CHANGE,this.changeLocale);
         Peripheral.voiceRecognition.removeEventListener(VoiceRecognitionEvent.DND_STATUS,this.onVRDNDStatus);
         screenOutComplete();
      }
      
      protected function changeLocale(e:LocaleEvent) : void
      {
         Text.format(this.mView.loading.label,T.STRB_NAV_IS_BEING_ACTIVATED);
      }
      
      private function onNavIsOperable(e:NavDomainControllerEvent) : void
      {
         if(Peripheral.appStateManager.splitScreenSource == "map")
         {
            this.onScreenChange();
         }
      }
      
      private function onDTVChange(e:Event = null) : void
      {
         this.onScreenChange();
      }
      
      private function onSource(e:AudioEvent) : void
      {
         this.onScreenChange();
      }
      
      private function onLayerVisibility(e:DisplayManagerEvent) : void
      {
         if(e.mData.requestDisplay.layer != DisplayManagerLayers.LAYER_VICS)
         {
            this.onScreenChange();
         }
      }
      
      private function onDisplayMode(e:PersonalConfigEvent) : void
      {
         this.mView.day.visible = Peripheral.personalConfig.displayMode == "day";
         this.mView.night.visible = Peripheral.personalConfig.displayMode != "day";
         this.updateBackground(this.mBackground,true);
      }
      
      private function onSplitScreen(e:PersonalConfigEvent) : void
      {
         if(e.mData.mode)
         {
            this.onScreenChange();
         }
      }
      
      private function onScreenChange(e:FrameworkEvent = null) : void
      {
         if(Framework.screens.isBusy)
         {
            return;
         }
         this.updateDisplay();
         switch(Framework.structure.currentBranch)
         {
            case Screens.APPS_ACTIVE:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_APP);
               break;
            case Screens.REAR_MEDIA:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case Screens.PARENTALCONTROLS:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/travellinkgraphicalweather":
               this.updateMapConfig(MapConfiguration.MAP_GRAPHICAL_WEATHER);
               this.updateBackground(BACKGROUND_WEA);
               break;
            case "mainbackground/menu/navmapscrollingscreen":
               this.updateMapConfig(MapConfiguration.MAP_SCROLLING);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navmapeventzoomscreen":
               switch(Peripheral.navigation.navDomainControl.navActiveMenu)
               {
                  case NavMenus.MENU_TMC_EVENT_ZOOM_MAP:
                     this.updateMapConfig(MapConfiguration.MAP_ZOOM_TMC);
                     break;
                  case NavMenus.MENU_TMC_EVENTS_ZOOM:
                     this.updateMapConfig(MapConfiguration.MAP_ZOOM_TMC);
                     break;
                  case NavMenus.MENU_VICS_PARKING_ZOOM_MAP:
                     this.updateMapConfig(MapConfiguration.MAP_ZOOM_TMC);
                     break;
                  default:
                     Framework.Trace("MainBackgroundScreen.onScreenChange() Unsupported navActiveMenu \'" + Peripheral.navigation.navDomainControl.navActiveMenu + "\'");
               }
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "NavVehicleIconsScreen.swf":
               this.updateMapConfig(MapConfiguration.MAP_GARAGE);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navvehicleiconscreen":
               this.updateMapConfig(MapConfiguration.MAP_GARAGE);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navalternativeroutesscreen":
               this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navemergencyscreen":
               this.updateMapConfig(MapConfiguration.MAP_HALF_MAP);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navmaneuverzoomscreen":
               this.updateMapConfig(MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navconfirmdestinationscreen":
               switch(Peripheral.navigation.navDomainControl.navActiveMenu)
               {
                  case NavMenus.MENU_FLOW_TRIP_ASSEMBLER:
                     switch(Peripheral.navigation.navTripAssembler.activeMenu)
                     {
                        case TripAssemblerMenu.CONFIRM_ROUTE:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                           break;
                        case TripAssemblerMenu.CONFIRM_HOME_SET:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                           break;
                        case TripAssemblerMenu.CONFIRM_HOME_ROUTE:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                           break;
                        case TripAssemblerMenu.CONFIRM_EXTERNAL_DESTINATION:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                           break;
                        case TripAssemblerMenu.CONFIRM_VOICE_RECKONED_DESTINATION:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                           break;
                        case TripAssemblerMenu.CONFIRM_TRAIL:
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE);
                           break;
                        case TripAssemblerMenu.CONFIRM_TRIP_ADD_CONFIRM:
                           this.updateMapConfig(MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION);
                           break;
                        case TripAssemblerMenu.CONFIRM_DESTINATION_REORDER_INFO:
                           this.updateMapConfig(MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION);
                           break;
                        case TripAssemblerMenu.CONFIRM_TPEG_POI_SHOWMAP:
                           this.updateMapConfig(MapConfiguration.MAP_ZOOM_TMC);
                           break;
                        default:
                           Framework.Trace("MainBackgroundScreen.onScreenChange() Unsupported MENU_FLOW_TRIP_ASSEMBLER Menu \'" + Peripheral.navigation.navTripAssembler.activeMenu + "\'");
                           this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
                     }
                     break;
                  case NavMenus.MENU_WHERE_AM_I:
                     this.updateMapConfig(MapConfiguration.MAP_HALF_MAP);
                     break;
                  case NavMenus.MENU_MAP_DESTINATION_INFO:
                     this.updateMapConfig(MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION);
                     break;
                  case NavMenus.MENU_VR_DESTINATION_ENTRY:
                     this.updateMapConfig(MapConfiguration.MAP_HALF_LIKE_FULL_MAP_LOW_FPS);
                     break;
                  case NavMenus.MENU_TMC_ROUTE_PREVIEW:
                     this.updateMapConfig(MapConfiguration.MAP_CONFIRM_TMC_REROUTE);
                     break;
                  default:
                     Framework.Trace("MainBackgroundScreen.onScreenChange() Unsupported navActiveMenu \'" + Peripheral.navigation.navDomainControl.navActiveMenu + "\'");
                     this.updateMapConfig(MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED);
               }
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navdestinationreachedscreen":
               this.updateMapConfig(MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navrouteoverviewscreen":
               this.updateMapConfig(MapConfiguration.MAP_ROUTE_OVERVIEW);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navmapmainscreen":
               this.updateMapConfig(MapConfiguration.MAP_FULL);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navtpegrtmdestinationscreen":
               this.updateMapConfig(MapConfiguration.MAP_ZOOM_TMC);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case "mainbackground/menu/navmaplocationpickerscreen":
               this.updateMapConfig(MapConfiguration.MAP_SCROLLING);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case Screens.MAIN_MEDIA:
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DTV && Boolean(Peripheral.shortTermDTVManager.DTVAvailable))
               {
                  this.updateMapConfig(MapConfiguration.UNDEFINED);
                  this.updateBackground(BACKGROUND_DTV);
                  break;
               }
               if(Peripheral.audioManager.source != "" && Peripheral.audioManager.source != null && Boolean(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source)))
               {
                  this.updateMapConfig(Peripheral.appStateManager.splitScreenSource == "map" ? int(MapConfiguration.MAP_MEDIA) : int(MapConfiguration.UNDEFINED));
                  this.updateBackground(Peripheral.appStateManager.splitScreenSource == "map" ? BACKGROUND_SPL : BACKGROUND_NOR);
                  break;
               }
            case Screens.MAIN_RADIO:
            case Screens.MAIN_FM:
            case Screens.MAIN_SAT:
               this.updateMapConfig(Peripheral.appStateManager.splitScreenSource == "map" ? int(MapConfiguration.MAP_MEDIA) : int(MapConfiguration.UNDEFINED));
               this.updateBackground(Peripheral.appStateManager.splitScreenSource == "map" ? BACKGROUND_SPL : BACKGROUND_NOR);
               break;
            case Screens.MAIN_DMB:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_DMBFULL))
               {
                  this.updateBackground(BACKGROUND_APP);
               }
               else
               {
                  this.updateBackground(BACKGROUND_DMB);
               }
               break;
            case "mainbackground/menu/navvicsbeaconscreen":
            case "mainbackground/menu/navvicsdarcscreen":
            case "mainbackground/menu/navvicsdarcmenuscreen":
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_VICS);
               break;
            case "mainbackground/menu/navvicsinterrupt":
               this.updateMapConfig(MapConfiguration["MAP_HALF_VICS"]);
               this.updateBackground(BACKGROUND_MAP);
               break;
            case Screens.DEVICE_PROJECTION:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_PROJ);
               break;
            default:
               this.updateMapConfig(MapConfiguration.UNDEFINED);
               this.updateBackground(BACKGROUND_NOR);
         }
      }
      
      private function updateDisplay() : void
      {
         if(Global.region == TunerRegion.JAPAN)
         {
            this.updateVICSWindow();
         }
      }
      
      private function updateMapConfig(config:int) : void
      {
         if(this.mMapConfig != config)
         {
            if(Peripheral.navigation)
            {
               if(Peripheral.navigation.navDomainControl.navIsOperable)
               {
                  this.mView.loading.visible = false;
                  this.mMapConfig = config;
                  Peripheral.navigation.navMapControl.selectConfiguration(this.mMapConfig);
               }
               else if(config == MapConfiguration.MAP_MEDIA)
               {
                  this.mView.loading.visible = true;
                  Text.format(this.mView.loading.label,T.STRB_NAV_IS_BEING_ACTIVATED);
               }
               else
               {
                  this.mView.loading.visible = false;
               }
            }
         }
      }
      
      private function updateBackground(background:String, _override:Boolean = false) : void
      {
         if(this.mBackground != background || _override)
         {
            this.mBackground = background;
            this.mView.visible = true;
            this.mView.day.mask = null;
            this.mView.night.mask = null;
            this.mView.maskFull.visible = false;
            this.mView.maskSplitWea.visible = false;
            this.mView.maskSplitMap.visible = false;
            this.mView.maskSplitDMB.visible = false;
            this.mView.maskSplitDTV.visible = false;
            this.mView.maskSplitVICS.visible = false;
            this.mView.maskProjection.visible = false;
            switch(this.mBackground)
            {
               case BACKGROUND_SPL:
                  this.mView.maskSplitMap.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskSplitMap;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskSplitMap;
                  }
                  break;
               case BACKGROUND_WEA:
                  this.mView.maskSplitWea.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskSplitWea;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskSplitWea;
                  }
                  break;
               case BACKGROUND_DMB:
                  this.mView.maskSplitDMB.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskSplitDMB;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskSplitDMB;
                  }
                  break;
               case BACKGROUND_DTV:
                  this.mView.maskSplitDTV.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskSplitDTV;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskSplitDTV;
                  }
                  break;
               case BACKGROUND_VICS:
                  this.mView.maskSplitVICS.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskSplitVICS;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskSplitVICS;
                  }
                  break;
               case BACKGROUND_MAP:
                  this.mView.maskFull.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskFull;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskFull;
                  }
                  break;
               case BACKGROUND_PROJ:
                  this.mView.maskProjection.visible = true;
                  if(Peripheral.personalConfig.displayMode == "day")
                  {
                     this.mView.day.mask = this.mView.maskProjection;
                  }
                  else
                  {
                     this.mView.night.mask = this.mView.maskProjection;
                  }
                  break;
               case BACKGROUND_APP:
                  this.mView.visible = false;
            }
         }
      }
      
      private function updateVICSWindow() : void
      {
         if(-1 == Framework.structure.currentBranch.search("vics"))
         {
            if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_VICS) == true)
            {
               Peripheral.displayManager.requestDisplay(DisplayManagerLayers.LAYER_VICS,false);
            }
            if(Peripheral.vicsManager.VicsMenuActive != "")
            {
               if(Framework.structure.currentBranch == "mainbackground/menu/navmainmenuscreen")
               {
                  switch(Peripheral.vicsManager.VicsMenuActive)
                  {
                     case "Beacon":
                        Peripheral.beaconDSRC.requestFinishMenu();
                        break;
                     case "DARCMenu":
                     case "DARCPage":
                        Peripheral.vicsFMHMI.requestFinishMenu();
                        break;
                     case "Interrupt":
                        Peripheral.beaconDSRC.requestFinishInterupt();
                  }
               }
               else
               {
                  switch(Peripheral.vicsManager.VicsMenuActive)
                  {
                     case "Beacon":
                        Peripheral.beaconDSRC.requestFinishMenu();
                        Peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                        break;
                     case "DARCMenu":
                        Peripheral.vicsFMHMI.requestFinishMenu();
                        Peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                        break;
                     case "DARCPage":
                        Peripheral.vicsFMHMI.requestFinishMenu();
                        Peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                        Peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                        break;
                     case "Interrupt":
                        Peripheral.navigation.navDomainControl.removeTopMenuFromStackPassive();
                        Peripheral.beaconDSRC.requestFinishInterupt();
                  }
               }
               Peripheral.vicsManager.VicsMenuActive = "";
            }
         }
      }
      
      private function onVRDNDStatus(e:VoiceRecognitionEvent) : void
      {
         if("on" == e.mData.status)
         {
            Peripheral.bluetoothPhone.DNDStatus = true;
            Peripheral.smsMessaging.DNDStatus = true;
         }
         if("off" == e.mData.status)
         {
            Peripheral.bluetoothPhone.DNDStatus = false;
            Peripheral.smsMessaging.DNDStatus = false;
            Peripheral.smsMessaging.replyWithMessage = false;
            Peripheral.persistency.write(PersistencyKeys.KEY_REPLY_WITH_MESSAGE,{"value":Peripheral.smsMessaging.replyWithMessage});
            Peripheral.smsMessaging.blockedSMSCount = 0;
            Peripheral.phoneCallList.blockedCallCount = 0;
         }
      }
   }
}

