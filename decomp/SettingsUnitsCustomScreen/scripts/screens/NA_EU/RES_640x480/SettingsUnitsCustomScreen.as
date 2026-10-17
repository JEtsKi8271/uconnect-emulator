package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsUnitsCustomScreen extends ScreenListComponent
   {
      
      private static const FUEL_CONSUMPTION:Object = {
         "mpg_us":T.STRB_MPG_US,
         "mpg_uk":T.STRB_MPG_UK,
         "Lp100km":T.STRB_L_100_KM,
         "kmpL":T.STRB_KM_L
      };
      
      private static const HORSE_POWER:Object = {
         "hp_us":T.STRB_HP_US,
         "hp_uk":T.STRB_HP_UK,
         "kW":T.STRB_KW
      };
      
      public function SettingsUnitsCustomScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SPEED_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISTANCE_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PRESSURE_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TEMPERATURE_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HORSEPOWER_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TORQUE_UNITS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CUSTOM_UNITS,refresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsUnitsCustomScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SPEED_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.DISTANCE_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PRESSURE_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TEMPERATURE_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HORSEPOWER_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TORQUE_UNITS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CUSTOM_UNITS,refresh);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getCustomUnitSettings();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsUnitsCustomScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Boolean(Peripheral.vehConfig.hasUnitSet))
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_UNITS,Breadcrumb.PAGE,Screens.SETTINGS_UNITS));
         }
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_UNITS_CUSTOM_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            if(Peripheral.vehConfig.hasDistanceOption)
            {
               contents.push(T.STRB_DISTANCE);
               if(Peripheral.vehConfig.hasConsumptionUnits)
               {
                  contents.push(T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION);
               }
            }
            if(Peripheral.vehConfig.hasTemperatureDisplay)
            {
               contents.push(T.STRB_TEMPERATURE);
            }
            if(Peripheral.vehConfig.pressureUnitsPresent)
            {
               contents.push(T.STRB_PRESSURE);
            }
         }
         else
         {
            if(Peripheral.vehConfig.speedUnitsPresent)
            {
               contents.push(T.STRB_SPEED);
            }
            if(Peripheral.vehConfig.distanceUnitsPresent)
            {
               contents.push(T.STRB_DISTANCE);
            }
            if(Peripheral.vehConfig.consumptionUnitsPresent)
            {
               contents.push(T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION);
            }
            if(Peripheral.vehConfig.pressureUnitsPresent)
            {
               contents.push(T.STRB_PRESSURE);
            }
            if(Peripheral.vehConfig.temperatureUnitsPresent)
            {
               contents.push(T.STRB_TEMPERATURE);
            }
            if(Peripheral.vehConfig.powerUnitsPresent)
            {
               contents.push(T.STRB_POWER_BASE);
            }
            if(Peripheral.vehConfig.torqueUnitsPresent)
            {
               contents.push(T.STRB_TORQUE);
            }
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
               case T.STRB_SPEED:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SPEED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SPEED));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_KMH_ABB));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_MPH_ABB));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.customSpeedUnits == "kph");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.customSpeedUnits == "mph");
                  break;
               case T.STRB_DISTANCE:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.isLatinAmericanVehicle()))
                  {
                     configure(item,TYPE_CHECK1);
                     item.id = T.STRB_DISTANCE;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_DISTANCE));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_KM));
                     item.checkbox0.setHighlight(Peripheral.personalConfig.customDistanceUnits == "km");
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                  }
                  else
                  {
                     configure(item,TYPE_CHECK2);
                     item.id = T.STRB_DISTANCE;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_DISTANCE));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_KM));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_MI));
                     item.checkbox0.setHighlight(Peripheral.personalConfig.customDistanceUnits == "km");
                     item.checkbox1.setHighlight(Peripheral.personalConfig.customDistanceUnits == "miles");
                  }
                  break;
               case T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION;
                  item.value.text = Peripheral.localeEngine.getText(FUEL_CONSUMPTION[Peripheral.personalConfig.customFuelConsumpUnits]);
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION));
                  break;
               case T.STRB_PRESSURE:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.isLatinAmericanVehicle()))
                  {
                     configure(item,TYPE_CHECK2);
                     item.id = T.STRB_PRESSURE;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_PRESSURE));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_BAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_PSI));
                     switch(Peripheral.personalConfig.customPressureUnits)
                     {
                        case "bar":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           break;
                        case "psi":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = T.STRB_PRESSURE;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_PRESSURE));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_BAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_KPA));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_PSI));
                     switch(Peripheral.personalConfig.customPressureUnits)
                     {
                        case "bar":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "kPa":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "psi":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  break;
               case T.STRB_TEMPERATURE:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_TEMPERATURE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_TEMPERATURE));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_CELSIUS));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_FAHRENHEIT));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.customTemperatureUnits == "METRIC");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.customTemperatureUnits == "US");
                  break;
               case T.STRB_POWER_BASE:
                  configure(item,TYPE_CHECK3);
                  item.id = T.STRB_POWER_BASE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_POWER_BASE));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_KW));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_HP_UK));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_HP_US));
                  switch(Peripheral.personalConfig.customHorsePowerUnits)
                  {
                     case "kW":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "hp_uk":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "hp_us":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
                  }
                  break;
               case T.STRB_TORQUE:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_TORQUE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_TORQUE));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_NM));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_LB_FT));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.customTorqueUnits == "Nm");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.customTorqueUnits == "lb-ft");
                  break;
               default:
                  configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         if(Peripheral.personalConfig.displayUnits != "custom" && (e.data.id != T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4"))
         {
            Peripheral.personalConfig.setDisplayUnits("custom");
         }
         switch(e.data.id)
         {
            case T.STRB_SPEED:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.speedUnits = "kph";
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.speedUnits = "mph";
                     break;
                  default:
                     switch(Peripheral.personalConfig.speedUnits)
                     {
                        case "kph":
                           Peripheral.personalConfig.speedUnits = "mph";
                           break;
                        case "mph":
                           Peripheral.personalConfig.speedUnits = "kph";
                     }
               }
               break;
            case T.STRB_DISTANCE:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.distanceUnits = "km";
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.distanceUnits = "miles";
                     break;
                  default:
                     switch(Peripheral.personalConfig.distanceUnits)
                     {
                        case "km":
                           Peripheral.personalConfig.distanceUnits = "miles";
                           break;
                        case "miles":
                           Peripheral.personalConfig.distanceUnits = "km";
                     }
               }
               break;
            case T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION:
               Framework.structure.goto("SettingsUnitsFuelConsumptionScreen.swf");
               return;
            case T.STRB_PRESSURE:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.pressureUnits = "bar";
                     break;
                  case "checkbox1":
                     if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.isLatinAmericanVehicle()))
                     {
                        Peripheral.personalConfig.pressureUnits = "psi";
                     }
                     else
                     {
                        Peripheral.personalConfig.pressureUnits = "kPa";
                     }
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.pressureUnits = "psi";
                     break;
                  default:
                     switch(Peripheral.personalConfig.pressureUnits)
                     {
                        case "psi":
                           if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.isLatinAmericanVehicle()))
                           {
                              Peripheral.personalConfig.pressureUnits = "bar";
                           }
                           else
                           {
                              Peripheral.personalConfig.pressureUnits = "kPa";
                           }
                           break;
                        case "kPa":
                           Peripheral.personalConfig.pressureUnits = "bar";
                           break;
                        case "bar":
                           Peripheral.personalConfig.pressureUnits = "psi";
                     }
               }
               break;
            case T.STRB_TEMPERATURE:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.temperatureUnits = "METRIC";
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.temperatureUnits = "US";
                     break;
                  default:
                     switch(Peripheral.personalConfig.temperatureUnits)
                     {
                        case "US":
                           Peripheral.personalConfig.temperatureUnits = "METRIC";
                           break;
                        case "METRIC":
                           Peripheral.personalConfig.temperatureUnits = "US";
                     }
               }
               break;
            case T.STRB_POWER_BASE:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.horsePowerUnits = "kW";
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.horsePowerUnits = "hp_uk";
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.horsePowerUnits = "hp_us";
                     break;
                  default:
                     switch(Peripheral.personalConfig.horsePowerUnits)
                     {
                        case "hp_us":
                           Peripheral.personalConfig.horsePowerUnits = "hp_uk";
                           break;
                        case "hp_uk":
                           Peripheral.personalConfig.horsePowerUnits = "kW";
                           break;
                        case "kW":
                           Peripheral.personalConfig.horsePowerUnits = "hp_us";
                     }
               }
               break;
            case T.STRB_TORQUE:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.torqueUnits = "Nm";
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.torqueUnits = "lb-ft";
                     break;
                  default:
                     switch(Peripheral.personalConfig.torqueUnits)
                     {
                        case "lb-ft":
                           Peripheral.personalConfig.torqueUnits = "Nm";
                           break;
                        case "Nm":
                           Peripheral.personalConfig.torqueUnits = "lb-ft";
                     }
               }
         }
         refresh();
      }
   }
}

