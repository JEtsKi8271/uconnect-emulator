package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import core.locale.Locale;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsLanguageScreen extends ScreenListComponent
   {
      
      public function SettingsLanguageScreen()
      {
         if(!Peripheral.localeEngine.locales)
         {
            Peripheral.localeEngine.onMarketConfigRead();
         }
         super();
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsLanguageScreen";
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsLanguageScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_DISPLAY_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_DISPLAY));
         pushBreadcrumb(new Breadcrumb(T.STRB_SET_LANGUAGE_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         var l:Locale = null;
         contents.length = 0;
         var i:int = 0;
         for each(l in Peripheral.localeEngine.locales)
         {
            contents.push({
               "label":l.name,
               "id":l.id
            });
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
            if(contents.length > index + i)
            {
               configure(item,TYPE_CHECK1);
               item.id = index + i;
               label(item.label,contents[item.id].label);
               item.checkbox0.setHighlight(contents[item.id].id == Peripheral.localeEngine.locale.id);
            }
            else
            {
               configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         if(contents[e.data.id].id != Peripheral.localeEngine.locale.id)
         {
            Peripheral.personalConfig.setDisplayLang(contents[e.data.id].id);
            refresh();
         }
      }
   }
}

