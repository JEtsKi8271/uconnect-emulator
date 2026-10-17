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
   public class SettingsComfortScreen extends ScreenListComponent
   {
      
      private static const AUTO_ON_CHECKBOXES:int = 1;
      
      private var mHasHeatedSeats:Boolean = false;
      
      private var mHasHeatedStrWhl:Boolean = false;
      
      private var mHasVentedSeats:Boolean = false;
      
      public function SettingsComfortScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AUTOONDCS,refresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsComfortScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AUTOONDCS,refresh);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getAll();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsComfortScreen";
         this.mHasHeatedSeats = Peripheral.vehConfig.hasHeatedSeat;
         this.mHasHeatedStrWhl = Peripheral.vehConfig.hasHeatedSteeringWheel;
         this.mHasVentedSeats = Peripheral.vehConfig.hasVentedSeat;
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_COMFORT_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(this.mHasHeatedSeats)
         {
            if(this.mHasVentedSeats && this.mHasHeatedStrWhl)
            {
               contents.push(T.STRB_SETTINGS_AUTO_ON_SEATS_WHEEL);
               contents.push(T.STRB_SETTINGS_WHEEL_WITH_VEH_START);
               if(Peripheral.vehConfig.autoOnFeatureMethod == "3option")
               {
                  contents.push(AUTO_ON_CHECKBOXES);
               }
            }
            else if(!this.mHasVentedSeats && this.mHasHeatedStrWhl)
            {
               contents.push(T.STRB_SETTINGS_AUTO_ON_HEATED);
               contents.push(T.STRB_SETTINGS_WITH_VEHICLE_START);
               if(Peripheral.vehConfig.autoOnFeatureMethod == "3option")
               {
                  contents.push(AUTO_ON_CHECKBOXES);
               }
            }
            else if(this.mHasVentedSeats && !this.mHasHeatedStrWhl)
            {
               contents.push(T.STRB_SETTINGS_AUTO_ON_SEATS);
               contents.push(T.STRB_SETTINGS_WITH_VEHICLE_START);
               if(Peripheral.vehConfig.autoOnFeatureMethod == "3option")
               {
                  contents.push(AUTO_ON_CHECKBOXES);
               }
            }
            else
            {
               contents.push(T.STRB_SETTINGS_AUTO_ON_HEATED_SEAT);
               contents.push(T.STRB_SETTINGS_WITH_VEHICLE_START);
               if(Peripheral.vehConfig.autoOnFeatureMethod == "3option")
               {
                  contents.push(AUTO_ON_CHECKBOXES);
               }
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
               case T.STRB_SETTINGS_AUTO_ON_SEATS_WHEEL:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SETTINGS_AUTO_ON_SEATS_WHEEL;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_SEATS_WHEEL));
                  break;
               case T.STRB_SETTINGS_AUTO_ON_HEATED:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SETTINGS_AUTO_ON_HEATED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_HEATED));
                  break;
               case T.STRB_SETTINGS_AUTO_ON_SEATS:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SETTINGS_AUTO_ON_SEATS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_SEATS));
                  break;
               case T.STRB_SETTINGS_AUTO_ON_HEATED_SEAT:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SETTINGS_AUTO_ON_HEATED_SEAT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_HEATED_SEAT));
                  break;
               case T.STRB_SETTINGS_WHEEL_WITH_VEH_START:
                  if(Peripheral.vehConfig.autoOnFeatureMethod == "1option")
                  {
                     configure(item,TYPE_CHECK1);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.autoOnDCS == "on");
                  }
                  else
                  {
                     configure(item,TYPE_SIMPLE);
                  }
                  item.id = T.STRB_SETTINGS_WHEEL_WITH_VEH_START;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_WHEEL_WITH_VEH_START));
                  break;
               case T.STRB_SETTINGS_WITH_VEHICLE_START:
                  if(Peripheral.vehConfig.autoOnFeatureMethod == "1option")
                  {
                     configure(item,TYPE_CHECK1);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.autoOnDCS == "on");
                  }
                  else
                  {
                     configure(item,TYPE_SIMPLE);
                  }
                  item.id = T.STRB_SETTINGS_WITH_VEHICLE_START;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_WITH_VEHICLE_START));
                  break;
               case AUTO_ON_CHECKBOXES:
                  configure(item,TYPE_CHECK3);
                  item.id = AUTO_ON_CHECKBOXES;
                  label(item.label,"");
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_ALL_STARTS));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_ON_REMOTE_START));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                  switch(Peripheral.personalConfig.autoOnDCS)
                  {
                     case "on":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "remoteonly":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     default:
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
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
            case AUTO_ON_CHECKBOXES:
               if(Peripheral.vehConfig.autoOnFeatureMethod == "3option")
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setAutoOnDCS("on");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setAutoOnDCS("remoteonly");
                        break;
                     case "checkbox2":
                        Peripheral.personalConfig.setAutoOnDCS("off");
                        break;
                     default:
                        switch(Peripheral.personalConfig.autoOnDCS)
                        {
                           case "on":
                              Peripheral.personalConfig.setAutoOnDCS("off");
                              break;
                           case "off":
                              Peripheral.personalConfig.setAutoOnDCS("remoteonly");
                              break;
                           default:
                              Peripheral.personalConfig.setAutoOnDCS("on");
                        }
                  }
               }
               refresh();
               break;
            case T.STRB_SETTINGS_WHEEL_WITH_VEH_START:
            case T.STRB_SETTINGS_WITH_VEHICLE_START:
               if(Peripheral.vehConfig.autoOnFeatureMethod == "1option")
               {
                  if(Peripheral.personalConfig.autoOnDCS == "off" || Peripheral.personalConfig.autoOnDCS == "remoteonly")
                  {
                     Peripheral.personalConfig.setAutoOnDCS("on");
                  }
                  else
                  {
                     Peripheral.personalConfig.setAutoOnDCS("off");
                  }
               }
               refresh();
         }
      }
   }
}

