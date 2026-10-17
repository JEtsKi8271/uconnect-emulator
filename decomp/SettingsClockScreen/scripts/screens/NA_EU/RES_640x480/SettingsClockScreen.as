package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.ClockEvent;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsClockScreen extends ScreenListComponent
   {
      
      public function SettingsClockScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.clock.addEventListener(ClockEvent.TIME_UPDATE,refresh,false,0,true);
         Peripheral.clock.addEventListener(ClockEvent.TWELVE_HOUR_MODE,refresh,false,0,true);
         Peripheral.clock.addEventListener(ClockEvent.GPS_TIME,refresh,false,0,true);
         Peripheral.clock.addEventListener(ClockEvent.ENABLE_CLOCK,refresh,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,refresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsClockScreen";
         super.removeListeners();
         Peripheral.clock.removeEventListener(ClockEvent.TIME_UPDATE,refresh);
         Peripheral.clock.removeEventListener(ClockEvent.TWELVE_HOUR_MODE,refresh);
         Peripheral.clock.removeEventListener(ClockEvent.GPS_TIME,refresh);
         Peripheral.clock.removeEventListener(ClockEvent.ENABLE_CLOCK,refresh);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,refresh);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsClockScreen";
         clearBreadcrumbs();
         this.populate();
         super.initScreen();
         if(screenVars != null && Boolean(screenVars.hasOwnProperty("enableExit")))
         {
            assets.back_button.setEnabled(false);
            pushBreadcrumb(new Breadcrumb(T.STRB_MENU_APPS,Breadcrumb.PAGE));
         }
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_CLOCK_BREADCRUMB,Breadcrumb.INERT));
      }
      
      override protected function onClose(e:Event) : void
      {
         if(screenVars != null && Boolean(screenVars.hasOwnProperty("enableExit")))
         {
            Framework.structure.back();
         }
         else
         {
            Framework.structure.exit();
         }
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            if(Peripheral.vehConfig.hasNavigation520)
            {
               contents.push(T.STRB_SETTINGS_SYNC_TIME);
            }
         }
         else if(Global.navActivated)
         {
            contents.push(T.STRB_SETTINGS_SYNC_TIME);
         }
         contents.push(T.STRB_SETTINGS_SET_HOURS);
         contents.push(T.STRB_SETTINGS_SET_MINUTES);
         contents.push(T.STRB_SETTINGS_TIME_FORMAT);
         if(Peripheral.vehConfig.hasClockDisplayOverride)
         {
            contents.push(T.STRB_SETTINGS_TIME_IN_STATUS);
         }
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.hasSetDatePreset) || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "001" || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "002")
         {
            contents.push(T.STRB_SETTINGS_SET_DATE_CLUSTER);
         }
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         if(!Global.navActivated)
         {
            this.setGpsClockSync(false);
         }
         Peripheral.clock.getTime();
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
               case T.STRB_SETTINGS_SYNC_TIME:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_SYNC_TIME;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SYNC_TIME));
                  item.checkbox0.setHighlight(Peripheral.clock.GPSTime);
                  break;
               case T.STRB_SETTINGS_SET_HOURS:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_SET_HOURS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_HOURS));
                  label(item.incrementer.label,Peripheral.clock.formattedHours);
                  item.incrementer.positive.setEnabled(this.TimeEnabled);
                  item.incrementer.negative.setEnabled(this.TimeEnabled);
                  break;
               case T.STRB_SETTINGS_SET_MINUTES:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_SET_MINUTES;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_MINUTES));
                  label(item.incrementer.label,Peripheral.clock.formattedMinutes);
                  item.incrementer.positive.setEnabled(this.TimeEnabled);
                  item.incrementer.negative.setEnabled(this.TimeEnabled);
                  break;
               case T.STRB_SETTINGS_TIME_FORMAT:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETTINGS_TIME_FORMAT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_TIME_FORMAT));
                  label(item.check1,"12 " + Peripheral.localeEngine.getText(T.STRB_HRS));
                  label(item.check0,"24 " + Peripheral.localeEngine.getText(T.STRB_HRS));
                  item.checkbox1.setHighlight(Peripheral.clock.twelveHourTimeFormat);
                  item.checkbox0.setHighlight(!Peripheral.clock.twelveHourTimeFormat);
                  break;
               case T.STRB_SETTINGS_TIME_IN_STATUS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_TIME_IN_STATUS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_TIME_IN_STATUS));
                  item.checkbox0.setHighlight(Peripheral.clock.EnableClock);
                  break;
               case T.STRB_SETTINGS_SET_DATE_CLUSTER:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_SET_DATE_CLUSTER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_DATE_CLUSTER));
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
            case T.STRB_SETTINGS_SYNC_TIME:
               this.setGpsClockSync(!Peripheral.clock.GPSTime);
               break;
            case T.STRB_SETTINGS_SET_HOURS:
               switch(e.data.name)
               {
                  case "negative":
                     Peripheral.clock.adjustManualOffset(-3600);
                     break;
                  case "positive":
                     Peripheral.clock.adjustManualOffset(3600);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_SET_MINUTES:
               switch(e.data.name)
               {
                  case "negative":
                     Peripheral.clock.adjustManualOffset(-60);
                     break;
                  case "positive":
                     Peripheral.clock.adjustManualOffset(60);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               Peripheral.clock.getTime();
               break;
            case T.STRB_SETTINGS_TIME_FORMAT:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.clock.setTwelveHourTimeFormat(false);
                     break;
                  case "checkbox1":
                     Peripheral.clock.setTwelveHourTimeFormat(true);
                     break;
                  default:
                     Peripheral.clock.setTwelveHourTimeFormat(!Peripheral.clock.twelveHourTimeFormat);
               }
               refresh();
               break;
            case T.STRB_SETTINGS_TIME_IN_STATUS:
               Peripheral.clock.setTimeInStatusBarEnabled(!Peripheral.clock.EnableClock);
               break;
            case T.STRB_SETTINGS_SET_DATE_CLUSTER:
               Framework.structure.goto(Screens.SETTINGS_DATE);
         }
      }
      
      private function setGpsClockSync(enabled:Boolean) : void
      {
         Peripheral.clock.setSyncWithGPSTime(enabled);
         Peripheral.clock.requestSyncWithGPSTime();
      }
      
      private function get TimeEnabled() : Boolean
      {
         var retval:Boolean = false;
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            if(Peripheral.vehConfig.hasNavigation520)
            {
               retval = !Peripheral.clock.GPSTime && Peripheral.antiTheft.powerModeState != "timed";
            }
            else
            {
               retval = Peripheral.antiTheft.powerModeState != "timed";
            }
         }
         else
         {
            retval = !Peripheral.clock.GPSTime;
         }
         return retval;
      }
   }
}

