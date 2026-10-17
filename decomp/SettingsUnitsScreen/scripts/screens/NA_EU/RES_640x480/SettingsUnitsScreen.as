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
   public class SettingsUnitsScreen extends ScreenListComponent
   {
      
      private static const CUSTOMIZATION_MENU_ITEM:int = 1;
      
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
      
      public function SettingsUnitsScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.UNIT,refresh,false,0,true);
         if(Peripheral.vehConfig.hasUnitSet)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SPEED_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.DISTANCE_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PRESSURE_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TEMPERATURE_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HORSEPOWER_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TORQUE_UNITS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CUSTOM_UNITS,refresh,false,0,true);
         }
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsUnitsScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.UNIT,refresh);
         if(Peripheral.vehConfig.hasUnitSet)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SPEED_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.DISTANCE_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PRESSURE_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TEMPERATURE_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HORSEPOWER_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TORQUE_UNITS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CUSTOM_UNITS,refresh);
         }
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getCustomUnitSettings();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsUnitsScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_UNITS,Breadcrumb.INERT));
         this.populate();
         if(Peripheral.personalConfig.displayUnits == "custom")
         {
            Peripheral.personalConfig.setDisplayUnits("custom");
         }
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         contents.push(T.STRB_SETTINGS_UNITS);
         if(Peripheral.vehConfig.hasUnitSet)
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
         else
         {
            contents.push(CUSTOMIZATION_MENU_ITEM);
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
               case T.STRB_SETTINGS_UNITS:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     if(Peripheral.vehConfig.isLatinAmericanVehicle())
                     {
                        configure(item,TYPE_CHECK2);
                        item.id = T.STRB_SETTINGS_UNITS;
                        label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS));
                        label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_CUSTOM));
                        label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LATAM));
                        switch(Peripheral.personalConfig.displayUnits)
                        {
                           case "custom":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              break;
                           case "latam":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              break;
                           default:
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                        }
                     }
                     else
                     {
                        configure(item,TYPE_CHECK3);
                        item.id = T.STRB_SETTINGS_UNITS;
                        label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS));
                        label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_CUSTOM));
                        if(Peripheral.vehConfig.isNorthAmericanVehicle())
                        {
                           label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_METRIC));
                           label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_US));
                           switch(Peripheral.personalConfig.displayUnits)
                           {
                              case "custom":
                                 item.checkbox0.setHighlight(true);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(false);
                                 break;
                              case "metric":
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(true);
                                 item.checkbox2.setHighlight(false);
                                 break;
                              case "us":
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(true);
                                 break;
                              default:
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(false);
                           }
                        }
                        else
                        {
                           label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_METRIC));
                           label(item.check2,Peripheral.localeEngine.getText(T.STRB_IMPERIAL_520));
                           switch(Peripheral.personalConfig.displayUnits)
                           {
                              case "custom":
                                 item.checkbox0.setHighlight(true);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(false);
                                 break;
                              case "metric":
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(true);
                                 item.checkbox2.setHighlight(false);
                                 break;
                              case "imperial":
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(true);
                                 break;
                              default:
                                 item.checkbox0.setHighlight(false);
                                 item.checkbox1.setHighlight(false);
                                 item.checkbox2.setHighlight(false);
                           }
                        }
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = T.STRB_SETTINGS_UNITS;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_CUSTOM));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_METRIC));
                     if(Peripheral.vehConfig.isNorthAmericanVehicle())
                     {
                        label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_US));
                        switch(Peripheral.personalConfig.displayUnits)
                        {
                           case "custom":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "metric":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "us":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(true);
                              break;
                           default:
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                        }
                     }
                     else
                     {
                        label(item.check2,Peripheral.localeEngine.getText(T.STRB_IMPERIAL_520));
                        switch(Peripheral.personalConfig.displayUnits)
                        {
                           case "custom":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "metric":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "imperial":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(true);
                              break;
                           default:
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                        }
                     }
                  }
                  break;
               case CUSTOMIZATION_MENU_ITEM:
                  configure(item,TYPE_SELECT);
                  item.id = CUSTOMIZATION_MENU_ITEM;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_CUSTOM));
                  item.value.text = "";
                  break;
               case T.STRB_SPEED:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SPEED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SPEED));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_KMH_ABB));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_MPH_ABB));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.customSpeedUnits == "kph");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.customSpeedUnits == "mph");
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                  }
                  break;
               case T.STRB_DISTANCE:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_DISTANCE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_DISTANCE));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_KM));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_MI));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.customDistanceUnits == "km");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.customDistanceUnits == "miles");
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                  }
                  break;
               case T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION;
                  item.value.text = Peripheral.localeEngine.getText(FUEL_CONSUMPTION[Peripheral.personalConfig.customFuelConsumpUnits]);
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS_FUEL_CONSUMPTION));
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                  }
                  break;
               case T.STRB_PRESSURE:
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
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                     item.checkbox2.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     item.checkbox2.setEnabled(false);
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
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                  }
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
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                     item.checkbox2.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     item.checkbox2.setEnabled(false);
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
                  if(Peripheral.personalConfig.displayUnits == "custom")
                  {
                     item.setEnabled(true);
                     item.checkbox0.setEnabled(true);
                     item.checkbox1.setEnabled(true);
                  }
                  else
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                  }
                  break;
               default:
                  configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case T.STRB_SETTINGS_UNITS:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setDisplayUnits("custom");
                        break;
                     case "checkbox1":
                        if(Peripheral.vehConfig.isLatinAmericanVehicle())
                        {
                           Peripheral.personalConfig.setDisplayUnits("latam");
                        }
                        else
                        {
                           Peripheral.personalConfig.setDisplayUnits("metric");
                        }
                        break;
                     case "checkbox2":
                        if(Peripheral.vehConfig.isNorthAmericanVehicle())
                        {
                           Peripheral.personalConfig.setDisplayUnits("us");
                        }
                        else
                        {
                           Peripheral.personalConfig.setDisplayUnits("imperial");
                        }
                        break;
                     default:
                        switch(Peripheral.personalConfig.displayUnits)
                        {
                           case "custom":
                              if(Peripheral.vehConfig.isLatinAmericanVehicle())
                              {
                                 Peripheral.personalConfig.setDisplayUnits("latam");
                              }
                              else if(Peripheral.vehConfig.isNorthAmericanVehicle())
                              {
                                 Peripheral.personalConfig.setDisplayUnits("us");
                              }
                              else
                              {
                                 Peripheral.personalConfig.setDisplayUnits("imperial");
                              }
                              break;
                           case "us":
                           case "imperial":
                              Peripheral.personalConfig.setDisplayUnits("metric");
                              break;
                           case "latam":
                           case "metric":
                              Peripheral.personalConfig.setDisplayUnits("custom");
                        }
                  }
               }
               else
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setDisplayUnits("custom");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setDisplayUnits("metric");
                        break;
                     case "checkbox2":
                        if(Peripheral.vehConfig.isNorthAmericanVehicle())
                        {
                           Peripheral.personalConfig.setDisplayUnits("us");
                        }
                        else
                        {
                           Peripheral.personalConfig.setDisplayUnits("imperial");
                        }
                        break;
                     default:
                        switch(Peripheral.personalConfig.displayUnits)
                        {
                           case "custom":
                              if(Peripheral.vehConfig.isNorthAmericanVehicle())
                              {
                                 Peripheral.personalConfig.setDisplayUnits("us");
                              }
                              else
                              {
                                 Peripheral.personalConfig.setDisplayUnits("imperial");
                              }
                              break;
                           case "us":
                           case "imperial":
                              Peripheral.personalConfig.setDisplayUnits("metric");
                              break;
                           case "metric":
                              Peripheral.personalConfig.setDisplayUnits("custom");
                        }
                  }
               }
               break;
            case CUSTOMIZATION_MENU_ITEM:
               Framework.structure.goto("SettingsUnitsCustomScreen.swf");
               break;
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
                     Peripheral.personalConfig.pressureUnits = "kPa";
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.pressureUnits = "psi";
                     break;
                  default:
                     switch(Peripheral.personalConfig.pressureUnits)
                     {
                        case "psi":
                           Peripheral.personalConfig.pressureUnits = "kPa";
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

