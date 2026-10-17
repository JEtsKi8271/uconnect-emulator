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
   public class SettingsDateScreen extends ScreenListComponent
   {
      
      public function SettingsDateScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.clock.addEventListener(ClockEvent.TIME_UPDATE,refresh,false,0,true);
         Peripheral.clock.addEventListener(ClockEvent.GPS_TIME,refresh,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,refresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsDateScreen";
         super.removeListeners();
         Peripheral.clock.removeEventListener(ClockEvent.TIME_UPDATE,refresh);
         Peripheral.clock.removeEventListener(ClockEvent.GPS_TIME,refresh);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,refresh);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsDateScreen";
         clearBreadcrumbs();
         this.populate();
         super.initScreen();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_CLOCK_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_CLOCK));
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_SET_DATE_CLUSTER,Breadcrumb.INERT));
      }
      
      override protected function onClose(e:Event) : void
      {
         Framework.structure.exit();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         contents.push(T.STRB_SETTINGS_SET_DATE_DAY);
         contents.push(T.STRB_SETTINGS_SET_DATE_MONTH);
         contents.push(T.STRB_SETTINGS_SET_DATE_YEAR);
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
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
               case T.STRB_SETTINGS_SET_DATE_DAY:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_SET_DATE_DAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_DATE_DAY));
                  label(item.incrementer.label,Peripheral.clock._time.day.toString());
                  item.incrementer.positive.setEnabled(this.DateEnabled);
                  item.incrementer.negative.setEnabled(this.DateEnabled);
                  break;
               case T.STRB_SETTINGS_SET_DATE_MONTH:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_SET_DATE_MONTH;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_DATE_MONTH));
                  label(item.incrementer.label,Peripheral.clock._time.month.toString());
                  item.incrementer.positive.setEnabled(this.DateEnabled);
                  item.incrementer.negative.setEnabled(this.DateEnabled);
                  break;
               case T.STRB_SETTINGS_SET_DATE_YEAR:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_SET_DATE_YEAR;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SET_DATE_YEAR));
                  label(item.incrementer.label,Peripheral.clock._time.year.toString().substr(2,2));
                  item.incrementer.positive.setEnabled(this.DateEnabled);
                  item.incrementer.negative.setEnabled(this.DateEnabled);
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
            case T.STRB_SETTINGS_SET_DATE_DAY:
               switch(e.data.name)
               {
                  case "negative":
                     Peripheral.clock.adjustManualOffset(-86400);
                     break;
                  case "positive":
                     Peripheral.clock.adjustManualOffset(86400);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_SET_DATE_MONTH:
               switch(e.data.name)
               {
                  case "negative":
                     Peripheral.clock.adjustMonth(-1);
                     break;
                  case "positive":
                     Peripheral.clock.adjustMonth(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_SET_DATE_YEAR:
               switch(e.data.name)
               {
                  case "negative":
                     Peripheral.clock.adjustYear(-1);
                     break;
                  case "positive":
                     Peripheral.clock.adjustYear(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
         }
      }
      
      private function get DateEnabled() : Boolean
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

