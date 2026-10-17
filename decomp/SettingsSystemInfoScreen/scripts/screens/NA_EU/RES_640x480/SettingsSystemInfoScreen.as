package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.CVPDemoEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.SoftwareUpdateEvent;
   import com.harman.moduleLinkAPI.VersionInfoEvent;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsSystemInfoScreen extends ScreenListComponent
   {
      
      private static const NAVI_SERVER:int = 1;
      
      private static const MAP_VERSION:int = 2;
      
      private static const REQUEST_CODE:int = 3;
      
      private static const MAP_REQCODE:int = 4;
      
      private static const RESET_TO_FACTORY_DEFAULTS:int = 5;
      
      private static const MDN:int = 6;
      
      private static const MSID:int = 7;
      
      private static const PRL_VER:int = 8;
      
      private static const ESN:int = 9;
      
      private static const HU_PART_NUMBER:int = 11;
      
      private static const HU_SERIAL_NUMBER:int = 12;
      
      private static const FOTA_WHATS_NEW:int = 13;
      
      private static const FACTORY_DEFAULTS_POPUP_ID:int = 0;
      
      public function SettingsSystemInfoScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.versionInfo.addEventListener(VersionInfoEvent.VERSION_INFO,refresh,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_VERSIONS,refresh,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_DEVICE_ID,refresh,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.EMB_PHONE_AT_STATUS,refresh,false,0,true);
         Peripheral.versionInfo.addEventListener(VersionInfoEvent.PARTNUMBER,refresh,false,0,true);
         Peripheral.versionInfo.addEventListener(VersionInfoEvent.SERIAL_NUMBER,refresh,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         Peripheral.softwareUpdate.addEventListener(SoftwareUpdateEvent.SW_UPDATE_BOOT_DONE,this.onBootDone,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsSystemInfoScreen";
         super.removeListeners();
         Peripheral.versionInfo.removeEventListener(VersionInfoEvent.VERSION_INFO,refresh);
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.NAV_VERSIONS,refresh);
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.NAV_DEVICE_ID,refresh);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.EMB_PHONE_AT_STATUS,refresh);
         Peripheral.versionInfo.removeEventListener(VersionInfoEvent.PARTNUMBER,refresh);
         Peripheral.versionInfo.removeEventListener(VersionInfoEvent.SERIAL_NUMBER,refresh);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Peripheral.softwareUpdate.removeEventListener(SoftwareUpdateEvent.SW_UPDATE_BOOT_DONE,this.onBootDone);
      }
      
      override protected function initScreen() : void
      {
         Peripheral.versionInfo.requestVersionInfo();
         Peripheral.navigation.navigation.navGetNavVersions();
         Peripheral.navigation.navigation.getAuthenticationDeviceID();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsSystemInfoScreen";
         Peripheral.cvpdemo.getMdn();
         Peripheral.cvpdemo.getImsi();
         Peripheral.cvpdemo.getFWVersions();
         Peripheral.cvpdemo.getModel();
         Peripheral.cvpdemo.getPrlVersion();
         Peripheral.cvpdemo.getPri();
         Peripheral.cvpdemo.getMeid();
         Peripheral.versionInfo.requestPartNumber();
         Peripheral.versionInfo.requestSerialNumber();
         Peripheral.persistency.read(PersistencyKeys.KEY_FOTA_WHATS_NEW_MESSAGE);
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_SYSTEM_INFORMATION,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         contents.push(T.STRB_SOFTWARE_VERSION);
         contents.push(NAVI_SERVER);
         contents.push(T.STRB_MAP_DATABASE);
         contents.push(MAP_VERSION);
         contents.push(REQUEST_CODE);
         contents.push(MAP_REQCODE);
         contents.push(MDN);
         contents.push(MSID);
         contents.push(PRL_VER);
         contents.push(ESN);
         contents.push(HU_PART_NUMBER);
         contents.push(HU_SERIAL_NUMBER);
         var objPersistencyKey:Object = Peripheral.persistency.getValue(PersistencyKeys.KEY_FOTA_WHATS_NEW_MESSAGE);
         if(objPersistencyKey != null && objPersistencyKey.hasOwnProperty("value") && objPersistencyKey.value != "")
         {
            contents.push(FOTA_WHATS_NEW);
         }
         contents.push(RESET_TO_FACTORY_DEFAULTS);
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         t(assets.total,Format.itemsInList(contents.length));
      }
      
      override public function set index(index:int) : void
      {
         var item:MovieClip = null;
         var dbVersion:String = null;
         for(var i:int = 0; i < LENGTH; i++)
         {
            item = assets.window["item" + i + "_button"];
            switch(contents.length > index + i ? contents[index + i] : -1)
            {
               case T.STRB_SOFTWARE_VERSION:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SOFTWARE_VERSION;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SOFTWARE_VERSION) + ": " + Peripheral.versionInfo.appVersion);
                  break;
               case NAVI_SERVER:
                  configure(item,TYPE_SIMPLE);
                  item.id = NAVI_SERVER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_NAVI_SERVER) + ": " + Peripheral.navigation.navigation.navVersions["ETC_SoftwareVersion"]);
                  break;
               case T.STRB_MAP_DATABASE:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_MAP_DATABASE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_MAP_DATABASE) + ":");
                  break;
               case MAP_VERSION:
                  configure(item,TYPE_SIMPLE);
                  item.id = MAP_VERSION;
                  if(Peripheral.navigation.navigation.navVersions.hasOwnProperty("ETC_SimpleDatabaseVersion"))
                  {
                     dbVersion = Peripheral.navigation.navigation.navVersions["ETC_SimpleDatabaseVersion"];
                  }
                  else
                  {
                     dbVersion = Peripheral.localeEngine.getText(T.STRB_UNDEFINED);
                  }
                  label(item.label,"     " + dbVersion);
                  break;
               case REQUEST_CODE:
                  configure(item,TYPE_SIMPLE);
                  item.id = REQUEST_CODE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_REQUEST_CODE) + ": ");
                  break;
               case MAP_REQCODE:
                  configure(item,TYPE_SIMPLE);
                  item.id = MAP_REQCODE;
                  label(item.label,"     " + Peripheral.navigation.navigation.authenticationDeviceID);
                  break;
               case RESET_TO_FACTORY_DEFAULTS:
                  configure(item,TYPE_SELECT);
                  item.id = RESET_TO_FACTORY_DEFAULTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_RESET_TO_FACTORY_DEFAULT_1L));
                  item.setEnabled(Peripheral.softwareUpdate.bootDone);
                  break;
               case MDN:
                  configure(item,TYPE_SIMPLE);
                  item.id = MDN;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_MDN) + ": " + Peripheral.cvpdemo.phoneMdn);
                  break;
               case MSID:
                  configure(item,TYPE_SIMPLE);
                  item.id = MSID;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_MSID) + ": " + Peripheral.cvpdemo.phoneImsi);
                  break;
               case PRL_VER:
                  configure(item,TYPE_SIMPLE);
                  item.id = PRL_VER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_PRL_VERSION) + ": " + Peripheral.cvpdemo.phonePrlVersion);
                  break;
               case ESN:
                  configure(item,TYPE_SIMPLE);
                  item.id = ESN;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_ESN) + ": " + Peripheral.cvpdemo.phoneMeid);
                  break;
               case HU_PART_NUMBER:
                  configure(item,TYPE_SIMPLE);
                  item.id = HU_PART_NUMBER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_HU_PART_NUMBER) + ": " + Peripheral.versionInfo.partNumber);
                  break;
               case HU_SERIAL_NUMBER:
                  configure(item,TYPE_SIMPLE);
                  item.id = HU_SERIAL_NUMBER;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_HU_SERIAL_NUMBER) + ": " + Peripheral.versionInfo.serialNumber);
                  break;
               case FOTA_WHATS_NEW:
                  configure(item,TYPE_SELECT);
                  item.id = FOTA_WHATS_NEW;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_FOTA_WHATS_NEW).replace("\n"," "));
                  break;
               default:
                  configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         var msg:String = null;
         var objPersistencyKey:Object = null;
         switch(e.data.id)
         {
            case RESET_TO_FACTORY_DEFAULTS:
               Framework.popupManager.show(FACTORY_DEFAULTS_POPUP_ID,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_FACTORY_RESET,
                  "message":T.STRB_ARE_YOU_SURE_RESET,
                  "caption1":T.STRB_YES,
                  "caption2":T.STRB_NO,
                  "showClose":false
               });
               break;
            case FOTA_WHATS_NEW:
               msg = "Software is up to date";
               objPersistencyKey = Peripheral.persistency.getValue(PersistencyKeys.KEY_FOTA_WHATS_NEW_MESSAGE);
               if(objPersistencyKey != null && objPersistencyKey.hasOwnProperty("value") && objPersistencyKey.value != "")
               {
                  msg = objPersistencyKey.value;
               }
               Framework.popupManager.show(DynamicPopupNames.FOTA_WHATS_NEW,Screens.WHATS_NEWDETAILS,{
                  "state":1,
                  "message":msg
               });
         }
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         if(e.data.id == FACTORY_DEFAULTS_POPUP_ID)
         {
            Framework.popupManager.show(DynamicPopupNames.GLOBAL_FULLSCREEN,Screens.GLOBAL_FULLSCREEN,{
               "id":DynamicPopupNames.GLOBAL_FULLSCREEN,
               "title":T.STRB_FACTORY_RESET,
               "msg":T.STRB_FACTORY_RESET_IN_PROGRESS,
               "closeButton":false
            });
            Peripheral.versionInfo.doFactoryReset();
         }
      }
      
      private function onBootDone(e:SoftwareUpdateEvent) : void
      {
         Peripheral.listController.invalidate();
      }
   }
}

