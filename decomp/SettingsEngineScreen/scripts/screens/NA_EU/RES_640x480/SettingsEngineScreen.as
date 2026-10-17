package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsEngineScreen extends ScreenListComponent
   {
      
      public function SettingsEngineScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.EXITSEAT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.ENGINEOFFDELAY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HLOFFDELAY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PWROFFWITHDOOROPEN,refresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsEngineScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.EXITSEAT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.ENGINEOFFDELAY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HLOFFDELAY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PWROFFWITHDOOROPEN,refresh);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getAll();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsEngineScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_ENGINE_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Peripheral.vehConfig.hasEasySeatExit)
         {
            contents.push(T.STRB_SETTINGS_EASY_EKIT);
         }
         if(Peripheral.vehConfig.hasAccessoryDelay)
         {
            contents.push(T.STRB_SETTINGS_POWER_DELAY);
         }
         if(Peripheral.vehConfig.hasHeadlampOffDelay)
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_DELAY);
         }
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.hasRadioOn))
         {
            contents.push(T.STRB_SETTINGS_RADIO_OFF_DELAY);
         }
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            contents.push(T.STRB_RADIO_OFF_WITH_D);
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
               case T.STRB_SETTINGS_EASY_EKIT:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_EASY_EKIT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_EASY_EKIT));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.easyExitSeat);
                  break;
               case T.STRB_SETTINGS_POWER_DELAY:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_POWER_DELAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_POWER_DELAY));
                  if(Peripheral.personalConfig.engineOffPowerDelay > 60)
                  {
                     label(item.incrementer.label,compose([(Peripheral.personalConfig.engineOffPowerDelay / 60).toString() + "\n",T.STRB_MINUTE_ABBREVVIATION]));
                  }
                  else
                  {
                     label(item.incrementer.label,compose([Peripheral.personalConfig.engineOffPowerDelay.toString() + "\n",T.STRB_SECOND_ABBREVIATION]));
                  }
                  item.incrementer.positive.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" && Peripheral.personalConfig.engineOffPowerDelay != 600);
                  item.incrementer.negative.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" && Peripheral.personalConfig.engineOffPowerDelay != 0);
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_DELAY:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_HEADLIGHT_DELAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_DELAY));
                  label(item.incrementer.label,compose([Peripheral.personalConfig.headLightOffDelay.toString() + "\n",T.STRB_SECOND_ABBREVIATION]));
                  item.incrementer.positive.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" && Peripheral.personalConfig.headLightOffDelay != 90);
                  item.incrementer.negative.setEnabled(Peripheral.antiTheft.ignitionState != "accessory" && Peripheral.personalConfig.headLightOffDelay != 0);
                  break;
               case T.STRB_SETTINGS_RADIO_OFF_DELAY:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETTINGS_RADIO_OFF_DELAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_RADIO_OFF_DELAY));
                  label(item.check0,compose([Peripheral.vehConfig.SwitchOffTime + "\n",T.STRB_MINUTE_ABBREVVIATION]));
                  label(item.check1,compose(["0\n",T.STRB_MINUTE_ABBREVVIATION]));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.engineOffPowerDelay != 0);
                  item.checkbox1.setHighlight(Peripheral.personalConfig.engineOffPowerDelay == 0);
                  break;
               case T.STRB_RADIO_OFF_WITH_D:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_RADIO_OFF_WITH_D;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_RADIO_OFF_WITH_D));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.pwrOffWithDoorOpen);
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
            case T.STRB_SETTINGS_EASY_EKIT:
               Peripheral.personalConfig.setEasyExitSeat(!Peripheral.personalConfig.easyExitSeat);
               refresh();
               break;
            case T.STRB_SETTINGS_POWER_DELAY:
               switch(e.data.name)
               {
                  case "negative":
                     this.setEngineDelta(-1);
                     break;
                  case "positive":
                     this.setEngineDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_HEADLIGHT_DELAY:
               switch(e.data.name)
               {
                  case "negative":
                     this.setHLOffDelayDelta(-1);
                     break;
                  case "positive":
                     this.setHLOffDelayDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_RADIO_OFF_DELAY:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setEngineOffPowerDelay(60);
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setEngineOffPowerDelay(0);
                     break;
                  default:
                     Peripheral.personalConfig.setEngineOffPowerDelay(Peripheral.personalConfig.engineOffPowerDelay > 0 ? 0 : 60);
               }
               break;
            case T.STRB_RADIO_OFF_WITH_D:
               Peripheral.personalConfig.setPwrOffWithDoorOpen(!Peripheral.personalConfig.pwrOffWithDoorOpen);
         }
      }
      
      private function setEngineDelta(delta:int) : void
      {
         var delay:int = int(Peripheral.personalConfig.engineOffPowerDelay);
         switch(delay)
         {
            case 0:
               delay = 0;
               break;
            case 45:
               delay = 1;
               break;
            case 300:
               delay = 2;
               break;
            case 600:
               delay = 3;
               break;
            default:
               return;
         }
         delay += delta;
         if(delay > 2)
         {
            delay = 600;
         }
         else if(delay < 1)
         {
            delay = 0;
         }
         else if(delay == 1)
         {
            delay = 45;
         }
         else if(delay == 2)
         {
            delay = 300;
         }
         Peripheral.personalConfig.setEngineOffPowerDelay(delay);
      }
      
      private function setHLOffDelayDelta(delta:int) : void
      {
         var delay:int = int(Peripheral.personalConfig.headLightOffDelay);
         delay += delta * 30;
         if(delay > 90)
         {
            delay = 0;
         }
         else if(delay < 0)
         {
            delay = 90;
         }
         Peripheral.personalConfig.setHeadLightOffDelay(delay);
      }
   }
}

