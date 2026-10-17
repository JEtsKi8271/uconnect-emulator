package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsDisplayScreen extends ScreenListComponent
   {
      
      private static const MAX_DISPLAY_BRIGHTNESS:uint = uint(Peripheral.personalConfig.brightnessMax);
      
      private static const MIN_DISPLAY_BRIGHTNESS:uint = 1;
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      public function SettingsDisplayScreen()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISPLAYMODESETTING,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BRIGHTHLON,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BRIGHTHLOFF,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.LANG,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.UNIT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TOUCHSCREENBEEP,refresh,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_INSTRUMENT_CLUSTER,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FUELSAVER,refresh,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.HEADLIGHTS_ON,refresh,false,0,true);
         Peripheral.vehicleStatus.addEventListener(PersonalConfigEvent.CONTROLSTIMEOUTENABLED,refresh);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.RDYTODRVSTATUS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.ENBLPHONEREP,refresh,false,0,true);
         assets.window.addEventListener(GlobalEvent.ITEMDISABLED,this.onDisabledItem,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsDisplayScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.DISPLAYMODESETTING,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.BRIGHTHLON,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.BRIGHTHLOFF,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.LANG,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.UNIT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TOUCHSCREENBEEP,refresh);
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.NAV_INSTRUMENT_CLUSTER,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FUELSAVER,refresh);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.HEADLIGHTS_ON,refresh);
         Peripheral.vehicleStatus.removeEventListener(PersonalConfigEvent.CONTROLSTIMEOUTENABLED,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.RDYTODRVSTATUS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.ENBLPHONEREP,refresh);
         assets.window.removeEventListener(GlobalEvent.ITEMDISABLED,this.onDisabledItem);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsDisplayScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_DISPLAY_BREADCRUMB,Breadcrumb.INERT));
         Peripheral.personalConfig.getAll();
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         contents.push(T.STRB_SETTINGS_DISPLAY_MODE);
         contents.push(T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_ON);
         contents.push(T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_OFF);
         if(Global.brandId != 11)
         {
            contents.push(T.STRB_SET_THEME);
         }
         contents.push(T.STRB_SETTINGS_SET_LANGUAGE);
         if(Global.region == TunerRegion.NORTH_AMERICA || Global.region == TunerRegion.EUROPE || Global.region == TunerRegion.ROW)
         {
            contents.push(T.STRB_KEYBOARD);
         }
         if(!Peripheral.vehConfig.hasUnitSet && Boolean(Peripheral.vehConfig.hasUnitOption))
         {
            contents.push(T.STRB_SETTINGS_UNITS);
         }
         contents.push(T.STRB_SETTINGS_TOUCHSCREEN_BEEP);
         if(Framework.resolution != Framework.RES_640_480)
         {
            contents.push(T.STRB_SETTINGS_AUTOSHOW_SMARTPHONE_DISPLAY);
         }
         contents.push(T.STRB_CONTROLS_SCREEN_TIMEOUT);
         if(Boolean(Global.navActivated) && Boolean(Peripheral.vehConfig.hasNavigationTurnByTurn))
         {
            contents.push(T.STRB_SETTINGS_NAV_IN_CLUSTER);
         }
         if(Peripheral.vehConfig.hasPhoneInfoInClusterPresent)
         {
            contents.push(T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED);
         }
         if(Peripheral.vehConfig.hasFuelSaver)
         {
            contents.push(T.STRB_SETTINGS_FUEL_IN_CLUSTER);
         }
         if(Peripheral.vehConfig.hasReadyToDrivePresent)
         {
            contents.push(T.STRB_SETTINGS_READY_TO_DRIVE_POPUP);
         }
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         t(assets.total,Format.itemsInList(contents.length));
      }
      
      override public function set index(index:int) : void
      {
         var item:MovieClip = null;
         for(var i:int = 0; i < LENGTH; i++)
         {
            item = assets.window["item" + i + "_button"];
            switch(contents.length > index + i ? contents[index + i] : -1)
            {
               case T.STRB_SETTINGS_DISPLAY_MODE:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETTINGS_DISPLAY_MODE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DISPLAY_MODE));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MANUAL));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO));
                  item.checkbox1.setHighlight(Peripheral.personalConfig.displayModeSetting == "manual");
                  item.checkbox0.setHighlight(Peripheral.personalConfig.displayModeSetting == "auto");
                  break;
               case T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_ON:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_ON;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_ON));
                  label(item.incrementer.label,Peripheral.personalConfig.displayBrightHlOn.toString());
                  if(Peripheral.personalConfig.displayBrightHlOn == MAX_DISPLAY_BRIGHTNESS || Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == false)
                  {
                     item.incrementer.positive.setEnabled(false);
                  }
                  else
                  {
                     item.incrementer.positive.setEnabled(this.itemEnablePermitted);
                  }
                  if(Peripheral.personalConfig.displayBrightHlOn == MIN_DISPLAY_BRIGHTNESS || Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == false)
                  {
                     item.incrementer.negative.setEnabled(false);
                  }
                  else
                  {
                     item.incrementer.negative.setEnabled(this.itemEnablePermitted);
                  }
                  if(Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == false)
                  {
                     item.setEnabled(false);
                  }
                  break;
               case T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_OFF:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_OFF;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_OFF));
                  label(item.incrementer.label,Peripheral.personalConfig.displayBrightHlOff.toString());
                  if(Peripheral.personalConfig.displayBrightHlOff == MAX_DISPLAY_BRIGHTNESS || Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == true)
                  {
                     item.incrementer.positive.setEnabled(false);
                  }
                  else
                  {
                     item.incrementer.positive.setEnabled(this.itemEnablePermitted);
                  }
                  if(Peripheral.personalConfig.displayBrightHlOff == MIN_DISPLAY_BRIGHTNESS || Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == true)
                  {
                     item.incrementer.negative.setEnabled(false);
                  }
                  else
                  {
                     item.incrementer.negative.setEnabled(this.itemEnablePermitted);
                  }
                  if(Peripheral.personalConfig.displayModeSetting == "auto" || Peripheral.personalConfig.displayModeSetting == "manual" && Peripheral.vehicleStatus.headlightsOn == true)
                  {
                     item.setEnabled(false);
                  }
                  break;
               case T.STRB_SET_THEME:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SET_THEME;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SET_THEME));
                  item.value.text = "";
                  break;
               case T.STRB_SETTINGS_SET_LANGUAGE:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_SET_LANGUAGE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_LANGUAGE));
                  label(item.value,Peripheral.localeEngine.locale.name);
                  break;
               case T.STRB_KEYBOARD:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_KEYBOARD;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_KEYBOARD));
                  break;
               case T.STRB_SETTINGS_UNITS:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETTINGS_UNITS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_METRIC));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_US));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.displayUnits != "us");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.displayUnits == "us");
                  break;
               case T.STRB_SETTINGS_TOUCHSCREEN_BEEP:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_TOUCHSCREEN_BEEP;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_TOUCHSCREEN_BEEP));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.displayTouchScreenBeep);
                  break;
               case T.STRB_SETTINGS_NAV_IN_CLUSTER:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_NAV_IN_CLUSTER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NAV_IN_CLUSTER));
                  item.checkbox0.setHighlight(Peripheral.navigation.navigation.navInstrumentClusterEnabled);
                  break;
               case T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.enablePhoneRepetition);
                  break;
               case T.STRB_SETTINGS_FUEL_IN_CLUSTER:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_FUEL_IN_CLUSTER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FUEL_IN_CLUSTER));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.displayFuelSaver);
                  break;
               case T.STRB_SETTINGS_READY_TO_DRIVE_POPUP:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_READY_TO_DRIVE_POPUP;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_READY_TO_DRIVE_POPUP));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.readyToDriveStatus);
                  break;
               case T.STRB_SETTINGS_AUTOSHOW_SMARTPHONE_DISPLAY:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_AUTOSHOW_SMARTPHONE_DISPLAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTOSHOW_SMARTPHONE_DISPLAY));
                  item.checkbox0.setHighlight(Peripheral.persistency.getValue(PersistencyKeys.KEY_PROJECTION_AUTO_SHOW));
                  break;
               case T.STRB_CONTROLS_SCREEN_TIMEOUT:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_CONTROLS_SCREEN_TIMEOUT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_CONTROLS_SCREEN_TIMEOUT));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.controlsTimeoutEnabled);
                  break;
               default:
                  configure(item,TYPE_EMPTY);
            }
         }
      }
      
      protected function onDisabledItem(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case T.STRB_SET_THEME:
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case T.STRB_SETTINGS_DISPLAY_MODE:
               switch(e.data.name)
               {
                  case "checkbox1":
                     Peripheral.personalConfig.setDisplayModeSetting("manual");
                     break;
                  case "checkbox0":
                     Peripheral.personalConfig.setDisplayModeSetting("auto");
                     break;
                  default:
                     switch(Peripheral.personalConfig.displayModeSetting)
                     {
                        case "auto":
                           Peripheral.personalConfig.setDisplayModeSetting("manual");
                           break;
                        case "manual":
                        default:
                           Peripheral.personalConfig.setDisplayModeSetting("auto");
                     }
               }
               break;
            case T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_ON:
               switch(e.data.name)
               {
                  case "negative":
                     this.setBrightnessOnDelta(-1);
                     break;
                  case "positive":
                     this.setBrightnessOnDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_DISPLAY_BRIGHTNESS_HD_OFF:
               switch(e.data.name)
               {
                  case "negative":
                     this.setBrightnessOffDelta(-1);
                     break;
                  case "positive":
                     this.setBrightnessOffDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SET_THEME:
               Framework.structure.goto("SettingsThemeScreen.swf");
               break;
            case T.STRB_SETTINGS_SET_LANGUAGE:
               Framework.structure.goto(Screens.SETTINGS_LANGUAGE);
               break;
            case T.STRB_KEYBOARD:
               Framework.structure.goto(Screens.SETTINGS_KEYBOARD);
               break;
            case T.STRB_SETTINGS_UNITS:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setDisplayUnits("metric");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setDisplayUnits("us");
                     break;
                  default:
                     Peripheral.personalConfig.setDisplayUnits(Peripheral.personalConfig.displayUnits == "us" ? "metric" : "us");
               }
               refresh();
               break;
            case T.STRB_SETTINGS_TOUCHSCREEN_BEEP:
               Peripheral.personalConfig.setDisplayTouchScreenBeep(!Peripheral.personalConfig.displayTouchScreenBeep);
               break;
            case T.STRB_SETTINGS_NAV_IN_CLUSTER:
               Peripheral.navigation.navigation.navSetInstrumentClusterEnabled(!Peripheral.navigation.navigation.navInstrumentClusterEnabled);
               break;
            case T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED:
               Peripheral.personalConfig.enablePhoneRepetition = !Peripheral.personalConfig.enablePhoneRepetition;
               refresh();
               break;
            case T.STRB_SETTINGS_FUEL_IN_CLUSTER:
               Peripheral.personalConfig.setDisplayFuelSaver(!Peripheral.personalConfig.displayFuelSaver);
               refresh();
               break;
            case T.STRB_SETTINGS_READY_TO_DRIVE_POPUP:
               Peripheral.personalConfig.readyToDriveStatus = !Peripheral.personalConfig.readyToDriveStatus;
               refresh();
               break;
            case T.STRB_SETTINGS_AUTOSHOW_SMARTPHONE_DISPLAY:
               Peripheral.persistency.write(PersistencyKeys.KEY_PROJECTION_AUTO_SHOW,!Peripheral.persistency.getValue(PersistencyKeys.KEY_PROJECTION_AUTO_SHOW));
               refresh();
               break;
            case T.STRB_CONTROLS_SCREEN_TIMEOUT:
               Peripheral.personalConfig.setControlsTimeoutEnabled(!Peripheral.personalConfig.controlsTimeoutEnabled);
               refresh();
         }
      }
      
      private function setBrightnessOnDelta(delta:int) : void
      {
         var brightness:int = int(Peripheral.personalConfig.displayBrightHlOn);
         brightness += delta;
         Peripheral.personalConfig.setDisplayBrightHlOn(brightness);
      }
      
      private function setBrightnessOffDelta(delta:int) : void
      {
         var brightness:int = int(Peripheral.personalConfig.displayBrightHlOff);
         brightness += delta;
         Peripheral.personalConfig.setDisplayBrightHlOff(brightness);
      }
      
      private function get itemEnablePermitted() : Boolean
      {
         return !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed" || Peripheral.antiTheft.ignitionState == "accessory");
      }
   }
}

