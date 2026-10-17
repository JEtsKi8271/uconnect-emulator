package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Extensions;
   import ancillary.Screens;
   import com.harman.framework.controller.IList;
   import com.harman.framework.template.ScreenList;
   import com.harman.moduleLink.AppManager;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.Applet;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.locale.LocaleArchive;
   import core.utils.LoadBMP;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class AppsMainScreen extends ScreenList implements IList
   {
      
      private static const INIT:String = "Init";
      
      private static const LOADING:String = "Loading";
      
      private static const STARTING:String = "StartingServices";
      
      private static const READY:String = "Ready";
      
      private static const WIFI_SELECTED_NONE:int = 0;
      
      private static const WIFI_SELECTED_OPTION:int = 1;
      
      private static const WIFI_SELECTED_SETUP:int = 2;
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      private var assets:C_AppsMain = new C_AppsMain();
      
      private var images:LoadBMP = new LoadBMP();
      
      private var contents:Array = new Array();
      
      private var categories:Array = [{
         "id":AppManager.FAVORITE_APPS,
         "label":LocaleArchive.getInstance().getTextByResID(T.STRB_APP_MENU_FAVORITE_APPS)
      },{
         "id":AppManager.ALL_APPS,
         "label":LocaleArchive.getInstance().getTextByResID(T.STRB_APP_MENU_ALL_APPS)
      },{
         "id":AppManager.RUNNING_APPS,
         "label":LocaleArchive.getInstance().getTextByResID(T.STRB_APP_MENU_RUNNING_APPS)
      }];
      
      private var closeAppPending:String = "";
      
      private var mSelectMode:Boolean = false;
      
      private var mCatIndex:int = 0;
      
      private var mWiFiSelected:int = 0;
      
      public function AppsMainScreen()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         mView = this.assets;
         this.assets.back_button.icon.visible = false;
         this.assets.close_button.icon.visible = false;
         this.assets.window.cat3_button.visible = false;
         this.assets.window.cat4_button.visible = false;
         this.assets.window.opt0_button.id = 0;
         this.assets.window.opt1_button.id = 1;
         this.assets.window.opt2_button.id = 2;
         this.assets.window.opt3_button.id = 3;
         this.assets.window.opt4_button.id = 4;
         this.assets.window.opt5_button.id = 5;
         cache = true;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.listController.construct(this);
         this.assets.window.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         this.assets.window.addEventListener(GlobalEvent.ITEMDISABLED,this.onItemDisabled,false,0,true);
         this.assets.window.addEventListener(GlobalEvent.CATEGORY,this.onCategory,false,0,true);
         this.assets.window.addEventListener(GlobalEvent.OPTION,this.onOption,false,0,true);
         this.assets.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         this.assets.close_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.REFRESH_APPLICATIONS,this.onRefreshApplications,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.DRM_VERIFICATION,this.onDRMVerified,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.XLET_ACTION_CANCELED,this.onXletActionCanceled,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIngitionState,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onIngitionState,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.CATEGORY,this.onCategory,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Peripheral.listController.bookmark = "AppsMainScreen";
         Peripheral.listController.deconstruct();
         this.assets.window.removeEventListener(GlobalEvent.ITEM,this.onItem);
         this.assets.window.removeEventListener(GlobalEvent.ITEMDISABLED,this.onItemDisabled);
         this.assets.window.removeEventListener(GlobalEvent.CATEGORY,this.onCategory);
         this.assets.window.removeEventListener(GlobalEvent.OPTION,this.onOption);
         this.assets.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         this.assets.close_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         Peripheral.appManager.removeEventListener(AppManagerEvent.REFRESH_APPLICATIONS,this.onRefreshApplications);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus);
         Peripheral.appManager.removeEventListener(AppManagerEvent.DRM_VERIFICATION,this.onDRMVerified);
         Peripheral.appManager.removeEventListener(AppManagerEvent.XLET_ACTION_CANCELED,this.onXletActionCanceled);
         Peripheral.appManager.removeEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIngitionState);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onIngitionState);
         Framework.popupManager.removeEventListener(GlobalEvent.CATEGORY,this.onCategory);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_XLET_ACTION_CANCELED);
         Peripheral.appManager.closedAppId = "";
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
      }
      
      override protected function initView() : void
      {
         breadcrumbTextField = this.assets.title.label;
      }
      
      override protected function initScreen() : void
      {
         var catOfApp:int = 0;
         Framework.structure.setExit();
         this.assets.back_button.setEnabled(this.mSelectMode);
         this.assets.back_button.icon.visible = this.mSelectMode;
         this.assets.close_button.setEnabled(this.mSelectMode);
         this.assets.close_button.icon.visible = this.mSelectMode;
         Peripheral.listController.length = this.assets.window.MAX_ITEMS;
         Peripheral.listController.selectedMax = this.assets.window.MAX_ITEMS;
         Peripheral.listController.bookmark = "AppsMainScreen";
         this.checkStatus();
         if(Peripheral.appManager.closedAppId != "")
         {
            catOfApp = int(Peripheral.appManager.getAppLaunchedFromCategory(Peripheral.appManager.closedAppId));
            Peripheral.appManager.activeCategory = catOfApp;
            Peripheral.appManager.getAppList(catOfApp);
         }
         else
         {
            Peripheral.appManager.getAppList(Peripheral.appManager.activeCategory);
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,Peripheral.listController.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[this.assets.window.cat0_button,this.assets.window.cat1_button,this.assets.window.cat2_button,this.assets.window.cat3_button,this.assets.window.cat4_button]));
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         this.getTranslations();
         this.getCategoryTranslations();
         this.replaceCat(this.mCatIndex);
         Peripheral.listController.invalidate();
      }
      
      override public function cleanup() : void
      {
         this.contents = null;
         this.categories = null;
         this.images.flush();
         super.cleanup();
      }
      
      override protected function back(e:Event = null) : void
      {
         super.back(e);
         if(Boolean(this.assets.back_button.enabled) && Boolean(this.assets.back_button.icon.visible))
         {
            this.onBack(null);
         }
      }
      
      private function onBack(evt:WidgetEvent) : void
      {
         Peripheral.listController.itemIndex = 0;
         Peripheral.listController.selected = 0;
         Peripheral.appManager.activeCategory = AppManager.FAVORITE_APPS;
         Peripheral.appManager.getAppList(AppManager.FAVORITE_APPS);
      }
      
      private function onItem(e:GlobalEvent) : void
      {
         if(this.mSelectMode)
         {
            this.onAddToFavorites();
         }
         else if(this.contents[e.data.id] != null)
         {
            this.mWiFiSelected = WIFI_SELECTED_NONE;
            if(this.contents[e.data.id].embedded)
            {
               switch(this.contents[e.data.id].appId)
               {
                  case "new":
                     if(!Peripheral.appManager.favoriteAppsFull)
                     {
                        this.onAddNewFavorite();
                     }
                     break;
                  case "WIFIAP":
                     if(Peripheral.wifiService.WiFiReady == true)
                     {
                        this.mWiFiSelected = WIFI_SELECTED_SETUP;
                        Peripheral.appManager.verifyDRM("WIFIAP",Peripheral.localeEngine.getText(T.STRB_WIFI_HOTSPOT));
                     }
                     else
                     {
                        Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_WIFI_SERVICE_NOT_AVAILABLE_YET);
                     }
                     break;
                  case "settings":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Framework.structure.goto(Screens.SETTINGS_SCREEN);
                     break;
                  case "keysense":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Peripheral.keySensePinManager.KeySenseActivation();
                     break;
                  case "rearmedia":
                  case "uconntheater":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Framework.structure.goto(Screens.REAR_MEDIA);
                     break;
                  case "engineering":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Framework.structure.goto("mainbackground/menu/appslistscreen",{"ext":Extensions.LIST_ENG_MENU});
                     break;
                  case "travellink":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Framework.structure.goto("mainbackground/menu/travellinkmainscreen");
                     break;
                  case "parentalcontrols":
                     Peripheral.appManager.startEmbedded(this.contents[e.data.id].appId);
                     Framework.structure.goto(Screens.PARENTALCONTROLS);
                     Peripheral.rse.startRdc2Video("parentalControlsRequest");
                     break;
                  case "SRT Drive Modes":
                  case "Drive Modes":
                     Peripheral.driveModeManager.enterDriveMode();
                     break;
                  case "HybridElectricPages":
                     Framework.structure.goto(Screens.HYBRID_ELECTRIC_PAGES);
               }
            }
            else if(this.contents[e.data.id].appId != Peripheral.appManager.getRunningAppId())
            {
               if(Peripheral.appManager.activeCategory != AppManager.RUNNING_APPS)
               {
                  Peripheral.appManager.saveAppCategory(this.contents[e.data.id].appId);
               }
               if(this.contents[e.data.id].appId == Peripheral.appManager.getPPId())
               {
                  Peripheral.appStateManager.fullStartDaemonXlet(this.contents[e.data.id].appId);
               }
               else
               {
                  Peripheral.appManager.startXlet(this.contents[e.data.id].appId,"MoreScreen");
               }
            }
            else
            {
               if(Peripheral.appManager.activeCategory != AppManager.RUNNING_APPS)
               {
                  Peripheral.appManager.saveAppCategory(this.contents[e.data.id].appId);
               }
               Framework.structure.goto(Screens.APPS_ACTIVE,null,true);
            }
         }
      }
      
      private function onItemDisabled(e:GlobalEvent) : void
      {
         if(this.contents[this.assets.window.selectTarget.id] != null && this.contents[this.assets.window.selectTarget.id].appId == "settings")
         {
            if(!this.itemEnablePermitted)
            {
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
            }
         }
      }
      
      private function onOption(e:GlobalEvent) : void
      {
         Peripheral.listController.selected = e.data.id;
         this.assets.window.selected = e.data.id;
         if(Peripheral.appManager.activeCategory == AppManager.RUNNING_APPS)
         {
            Peripheral.appManager.stopXlet(this.contents[this.assets.window.selectTarget.id].appId);
            this.closeAppPending = this.contents[this.assets.window.selectTarget.id].appId;
            this.replaceCat(this.mCatIndex);
            Peripheral.listController.invalidate();
         }
         else if(this.contents[this.assets.window.selectTarget.id].favorite)
         {
            Framework.popupManager.show(DynamicPopupNames.TWOITEM_REMOVE_FROM_FAVORITE_APPS,"popup2item",{
               "timeout":0,
               "type":PopupType.PRIMARY,
               "title":T.STRB_MENU_APPS,
               "message":[T.STRB_APPS_REMOVE_FROM_FAV_APPS,this.contents[this.assets.window.selectTarget.id].label],
               "caption1":T.STRB_YES,
               "caption2":T.STRB_CANCEL,
               "showClose":false
            });
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.TWOITEM_ADD_TO_FAVORITE_APPS,"popup2item",{
               "timeout":0,
               "type":PopupType.PRIMARY,
               "title":T.STRB_MENU_APPS,
               "message":[T.STRB_WOULD_YOU_LIKE_ARG_ML,this.contents[this.assets.window.selectTarget.id].label],
               "caption1":T.STRB_YES,
               "caption2":T.STRB_CANCEL,
               "showClose":false
            });
         }
      }
      
      private function onCategory(e:GlobalEvent) : void
      {
         Peripheral.appManager.closedAppId = "";
         if(Peripheral.appManager.activeCategory != e.data.id)
         {
            Peripheral.listController.itemIndex = 0;
            Peripheral.listController.selected = 0;
            Peripheral.appManager.activeCategory = e.data.id;
         }
         Peripheral.appManager.getAppList(e.data.id);
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function onRemoveFromFavorites() : void
      {
         Peripheral.appManager.setFavorite(this.contents[this.assets.window.selectTarget.id].appId,false);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
      }
      
      private function onAddNewFavorite() : void
      {
         this.mSelectMode = true;
         Peripheral.listController.itemIndex = 0;
         Peripheral.listController.selected = 0;
         Peripheral.appManager.activeCategory = AppManager.ALL_APPS;
         Peripheral.appManager.getAppList(AppManager.ALL_APPS);
      }
      
      private function onAddToFavorites() : void
      {
         Peripheral.appManager.setFavorite(this.contents[this.assets.window.selectTarget.id].appId,true);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         Framework.popupManager.show(DynamicPopupNames.FAVORITE_APP_ADDED,"PopupSmall.swf",{
            "type":PopupType.SECONDARY,
            "title":this.contents[this.assets.window.selectTarget.id].label,
            "message":T.STRB_APPS_ADDED_TO_FAVORITE_APPS,
            "timeout":3000
         });
      }
      
      private function onStopXlet() : void
      {
         Peripheral.appManager.stopXlet(this.contents[this.assets.window.selectTarget.id].appId);
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case DynamicPopupNames.TWOITEM_ADD_TO_FAVORITE_APPS:
               this.onAddToFavorites();
               break;
            case DynamicPopupNames.TWOITEM_REMOVE_FROM_FAVORITE_APPS:
               this.onRemoveFromFavorites();
         }
      }
      
      private function onAppManagerStatus(e:AppManagerEvent) : void
      {
         this.checkStatus();
      }
      
      private function onRefreshApplications(e:AppManagerEvent) : void
      {
         var indexOfApp:int = 0;
         var selectedLine:int = 0;
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_ADD_TO_FAVORITES);
         this.contents = Peripheral.appManager.applications;
         if(Peripheral.appManager.closedAppId != "")
         {
            indexOfApp = this.getIndexOfApp(Peripheral.appManager.closedAppId);
            Peripheral.listController.itemIndex = indexOfApp;
            selectedLine = int(Peripheral.listController.returnRemainder(indexOfApp));
            Peripheral.listController.selected = selectedLine;
         }
         this.gotoCategory(Peripheral.appManager.activeCategory);
      }
      
      private function onOperStatusUpdate(e:AppManagerEvent) : void
      {
         if(e.mData.operStatus.state == "stopped")
         {
            this.closeAppPending = "";
            Peripheral.appManager.getAppList(Peripheral.appManager.activeCategory);
         }
      }
      
      public function set index(index:int) : void
      {
         var wifiBtnPointer:MovieClip = null;
         var settingsPointer:MovieClip = null;
         var superAppPointer:MovieClip = null;
         var items:Array = null;
         var i:int = 0;
         if(this.contents != null && this.contents.length > 0)
         {
            wifiBtnPointer = null;
            settingsPointer = null;
            superAppPointer = null;
            items = this.contents.slice(index,index + this.assets.window.MAX_ITEMS);
            for(i = 0; i < items.length; i++)
            {
               items[i].id = index + i;
               items[i].select = this.mSelectMode ? Peripheral.localeEngine.getText(T.STRB_SELECT) : "";
               this.assets.window["opt" + i + "_button"].icon.visible = true;
               if(Peripheral.appManager.activeCategory == AppManager.RUNNING_APPS)
               {
                  this.assets.window["opt" + i + "_button"].icon.gotoAndStop(1);
                  if(items[i].appId == Peripheral.appManager.getSuperAppId())
                  {
                     superAppPointer = this.assets.window["opt" + i + "_button"];
                  }
               }
               else if(items[i].favorite)
               {
                  this.assets.window["opt" + i + "_button"].icon.gotoAndStop(2);
               }
               else
               {
                  this.assets.window["opt" + i + "_button"].icon.gotoAndStop(3);
               }
               if(items[i].lgicon != "")
               {
                  this.images.addImage(items[i].lgicon,this.assets.window["item" + i + "_button"].window);
               }
               if(!items[i].embedded && Peripheral.appManager.status == STARTING)
               {
                  this.assets.window["item" + i + "_button"].textColor = 4;
               }
               else if(items[i].embedded == false && items[i].status.toLowerCase() != "stopped" && items[i].status.toLowerCase() != "paused" && items[i].status.toLowerCase() != "running" && items[i].status != "")
               {
                  this.assets.window["item" + i + "_button"].textColor = 4;
               }
               else if(items[i].appId == "WIFIAP")
               {
                  wifiBtnPointer = this.assets.window["item" + i + "_button"];
               }
               else if(items[i].appId == "settings")
               {
                  settingsPointer = this.assets.window["item" + i + "_button"];
               }
               else
               {
                  this.assets.window["item" + i + "_button"].textColor = 0;
               }
               if(Peripheral.appManager.status != READY)
               {
                  this.assets.window["item" + i + "_button"].textColor = 4;
               }
               if(items[i].appId == "new")
               {
                  if(Peripheral.appManager.favoriteAppsFull)
                  {
                     this.assets.window["item" + i + "_button"].textColor = 4;
                  }
                  else
                  {
                     this.assets.window["item" + i + "_button"].textColor = 0;
                  }
               }
               if(items[i].appId == this.closeAppPending)
               {
                  this.assets.window["item" + i + "_button"].textColor = 4;
               }
            }
            this.assets.window.items = items;
            if(wifiBtnPointer != null && Peripheral.appManager.status == READY)
            {
               wifiBtnPointer.setEnabled(true);
               wifiBtnPointer.textColor = 0;
            }
            if(settingsPointer != null && Peripheral.appManager.status == READY)
            {
               settingsPointer.setEnabled(this.itemEnablePermitted);
               settingsPointer.textColor = this.itemEnablePermitted ? 0 : 4;
            }
            if(superAppPointer != null && Peripheral.appManager.status == READY)
            {
               superAppPointer.visible = false;
            }
         }
         else
         {
            this.assets.window.items = new Array();
         }
      }
      
      public function replaceCat(index:int = 0) : void
      {
         var items:Array = this.categories.slice(index,this.categories.length);
         for(var i:int = 0; i < items.length; i++)
         {
            items[i].active = Peripheral.appManager.activeCategory == items[i].id;
         }
         this.assets.window.categories = items;
      }
      
      private function gotoCategory(active:int) : void
      {
         this.activeBreadcrumb(active);
         this.getTranslations();
         if(AppManager.FAVORITE_APPS == active)
         {
            this.mSelectMode = false;
            this.getAddNewFavorite();
         }
         this.replaceCat();
         Peripheral.listController.total = this.contents.length;
         Peripheral.listController.invalidate();
         this.assets.back_button.setEnabled(this.mSelectMode);
         this.assets.back_button.icon.visible = this.mSelectMode;
         this.assets.close_button.setEnabled(this.mSelectMode);
         this.assets.close_button.icon.visible = this.mSelectMode;
         if(AppManager.RUNNING_APPS == active && this.contents.length == 0)
         {
            Text.format(this.assets.window.item0_button.label,T.STRB_NO_APPS_RUNNING);
         }
      }
      
      private function getAddNewFavorite() : void
      {
         var app:Applet = null;
         if(Peripheral.appManager.activeCategory == AppManager.FAVORITE_APPS)
         {
            if(!this.contents)
            {
               this.contents = new Array();
            }
            if(this.contents.length == 0 || this.contents[this.contents.length - 1].appId != "new")
            {
               app = new Applet(Peripheral.localeEngine.getText(T.STRB_ADD_NEW_FAVORITE));
               app.appId = "new";
               app.embedded = true;
               app.favorite = true;
               this.contents.push(app);
            }
         }
      }
      
      private function getCategory(id:int) : uint
      {
         switch(id)
         {
            case AppManager.ALL_APPS:
               return T.STRB_ALL_APPS_BREADCRUMB;
            case AppManager.FAVORITE_APPS:
               return T.STRB_FAVORITE_APPS_BREADCRUMB;
            case AppManager.RUNNING_APPS:
               return T.STRB_RUNNING_APPS_BREADCRUMB;
            default:
               return T.STRB_ALL_APPS_BREADCRUMB;
         }
      }
      
      private function getTranslations() : void
      {
         for(var i:int = 0; i < this.contents.length; i++)
         {
            switch(this.contents[i].appId)
            {
               case "WIFIAP":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_WIFI_HOTSPOT);
                  break;
               case "settings":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_SETTINGS);
                  break;
               case "rearmedia":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_REAR_MEDIA_CAPS);
                  break;
               case "uconntheater":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_MEDIA_UCONNECT_THEATER);
                  break;
               case "engineering":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_ENGINEERING_MENU);
                  break;
               case "travellink":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_TRAVEL_LINK);
                  break;
               case "parentalcontrols":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_PARENTAL_CONTROLS);
                  break;
               case "keysense":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_KEYSENSE);
                  break;
               case "HybridElectricPages":
                  this.contents[i].label = Peripheral.localeEngine.getText(T.STRB_HYBRID_ELEC_PAGES);
            }
         }
      }
      
      private function getCategoryTranslations() : void
      {
         this.categories[0].label = Peripheral.localeEngine.getText(T.STRB_APP_MENU_FAVORITE_APPS);
         this.categories[1].label = Peripheral.localeEngine.getText(T.STRB_APP_MENU_ALL_APPS);
         this.categories[2].label = Peripheral.localeEngine.getText(T.STRB_APP_MENU_RUNNING_APPS);
      }
      
      private function getIndexOfApp(appId:String) : int
      {
         for(var i:int = 0; i < this.contents.length; i++)
         {
            if(this.contents[i].appId == appId)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function activeBreadcrumb(active:int) : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MENU_APPS,Breadcrumb.INERT));
         pushBreadcrumb(new Breadcrumb(this.mSelectMode && active != AppManager.FAVORITE_APPS ? T.STRB_SELECT_NEW_FAVORITE : this.getCategory(active),Breadcrumb.INERT));
      }
      
      private function checkStatus() : void
      {
         switch(Peripheral.appManager.status)
         {
            case "Init":
               this.assets.title.status.text = Peripheral.localeEngine.getText(T.STRB_INITIALIZING_DOTDOTDOT);
               break;
            case "Loading":
               this.assets.title.status.text = Peripheral.localeEngine.getText(T.STRB_LOADING_DOTDOTDOT);
               break;
            case "StartingServices":
               this.assets.title.status.text = Peripheral.localeEngine.getText(T.STRB_STARTING_DOTDOTDOT);
               break;
            case "Ready":
               this.assets.title.status.visible = false;
               this.assets.updateTitle();
               break;
            default:
               this.assets.title.status.visible = false;
               this.assets.title.status.text = "";
         }
      }
      
      public function get length() : int
      {
         return this.contents.length;
      }
      
      public function set selected(index:int) : void
      {
         this.assets.window.selected = index;
      }
      
      public function set total(total:String) : void
      {
         t(this.assets.total,[total + " ",T.STRB_ITEMS_IN_LIST]);
      }
      
      private function onIngitionState(e:AntiTheftEvent) : void
      {
         Peripheral.listController.invalidate();
      }
      
      private function onDRMVerified(e:AppManagerEvent) : void
      {
         if(e.mData.verifyDRM.errorCode == 0 && this.mWiFiSelected != WIFI_SELECTED_NONE)
         {
            if(this.mWiFiSelected == WIFI_SELECTED_SETUP)
            {
               Framework.structure.goto("mainbackground/menu/appslistscreen",{"ext":Extensions.HOTSPOT_SETUP_LIST});
            }
            else if(this.mWiFiSelected == WIFI_SELECTED_OPTION)
            {
               Peripheral.wifiService.setRFActive("on",true);
               this.mWiFiSelected = WIFI_SELECTED_NONE;
            }
         }
      }
      
      private function onXletActionCanceled(e:AppManagerEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_XLET_ACTION_CANCELED,{"message":[T.STRB_ERROR_APPS_WORKING_TRY_AGAIN,e.mData.pendingAppName,e.mData.appName]});
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         Peripheral.listController.invalidate();
      }
      
      private function get itemEnablePermitted() : Boolean
      {
         return !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed" || Peripheral.antiTheft.ignitionState == "accessory");
      }
   }
}

