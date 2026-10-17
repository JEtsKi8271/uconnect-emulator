package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsPhoneBluetoothScreen extends ScreenListComponent
   {
      
      public function SettingsPhoneBluetoothScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsPhoneBluetoothScreen";
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsPhoneBluetoothScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_PHONE_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         contents.push(T.STRB_DO_NOT_DISTURB);
         contents.push(T.STRB_PAIRED_PHONES_1);
         contents.push(T.STRB_PAIRED_AUDIO_SOURCES);
         if(Peripheral.vehConfig.hasPhoneInfoInClusterPresent)
         {
            contents.push(T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED);
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
               case T.STRB_DO_NOT_DISTURB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_DO_NOT_DISTURB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_DO_NOT_DISTURB));
                  item.setEnabled(Peripheral.smsMessaging.isSendSupported);
                  break;
               case T.STRB_PAIRED_PHONES_1:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_PAIRED_PHONES_1;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_PAIRED_PHONES_1));
                  break;
               case T.STRB_PAIRED_AUDIO_SOURCES:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_PAIRED_AUDIO_SOURCES;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_PAIRED_AUDIO_SOURCES));
                  break;
               case T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.enablePhoneRepetition);
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
            case T.STRB_DO_NOT_DISTURB:
               Framework.structure.goto(Screens.SETTINGS_DO_NOT_DISTURB);
               break;
            case T.STRB_PAIRED_PHONES_1:
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"screen":T.STRB_PAIRED_PHONES_1});
               break;
            case T.STRB_PAIRED_AUDIO_SOURCES:
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"source":"audio"});
               break;
            case T.STRB_SETTINGS_PHONE_POPUPS_DISPLAYED:
               Peripheral.personalConfig.enablePhoneRepetition = !Peripheral.personalConfig.enablePhoneRepetition;
               refresh();
         }
      }
   }
}

