package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.framework.controller.IList;
   import com.harman.framework.template.ScreenList;
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.events.ExtensionEvent;
   import core.utils.Text;
   import events.WidgetEvent;
   import extensions.nav.INavMenuWhereToExtension;
   import extensions.nav.NavMenuWehereToDestinationEntry;
   import extensions.nav.NavMenuWhereToFavoritesAddContact;
   import extensions.nav.NavMenuWhereToFavoritesAddDestination;
   import extensions.nav.NavMenuWhereToHomeAddDestination;
   import extensions.nav.NavMenuWhereToInformation;
   import extensions.nav.NavMenuWhereToLSHdTraffic;
   import extensions.nav.NavMenuWhereToLSLocalSearch;
   import extensions.nav.NavMenuWhereToLSSpeedCameras;
   import extensions.nav.NavMenuWhereToLSWeather;
   import extensions.nav.NavMenuWhereToTripsAddDestination;
   import flash.display.MovieClip;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class NavMenuWhereToScreen extends ScreenList implements IList
   {
      
      private static const OVERFLOW_DETECT_MAX:int = 5;
      
      private const LENGTH:int = 6;
      
      private const ITEMS_PER_LINE:int = 3;
      
      private var assets:C_NavMenuWhereTo = new C_NavMenuWhereTo();
      
      private var mContents:Vector.<Object> = new Vector.<Object>();
      
      private var mExtension:INavMenuWhereToExtension;
      
      private var mOverflowDetect:int = 0;
      
      private var mCurrentBookmark:String = "";
      
      public function NavMenuWhereToScreen()
      {
         mView = this.assets;
         super();
      }
      
      override public function screenOut() : void
      {
         this.bookmark = this.mCurrentBookmark;
         this.mContents.length = 0;
         if(this.mExtension != null)
         {
            this.mExtension.removeListeners();
         }
         this.mExtension = null;
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         Peripheral.listController.construct(this);
         this.assets.window.addEventListener(WidgetEvent.CLICK,this.onItem,true,0,true);
         this.assets.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         this.assets.close_button.addEventListener(WidgetEvent.CLICK,this.onClose,false,0,true);
         if(Global.region == TunerRegion.CHINA)
         {
            Peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS,this.onLanguageChangeProgressChina,false,0,true);
         }
         else
         {
            Peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChangeProgress,false,0,true);
         }
         Peripheral.navigation.navLocationInput.liGetIsLanguageChangeInProgress();
         Framework.structure.addEventListener(ExtensionEvent.EXTENSION,this.onExtension,false,0,true);
         super.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.deconstruct();
         this.assets.window.removeEventListener(WidgetEvent.CLICK,this.onItem);
         this.assets.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         this.assets.close_button.removeEventListener(WidgetEvent.CLICK,this.onClose);
         Framework.structure.removeEventListener(ExtensionEvent.EXTENSION,this.onExtension);
         if(Global.region == TunerRegion.CHINA)
         {
            Peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_LANGUAGE_CHANGE_IN_PROGRESS,this.onLanguageChangeProgressChina);
            if(Framework.popupManager.check(DynamicPopupNames.INFO_NAV_SEARCHING_POI))
            {
               Framework.popupManager.dequeue(DynamicPopupNames.INFO_NAV_SEARCHING_POI);
            }
         }
         else
         {
            Peripheral.navigation.navigation.removeEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChangeProgress);
            if(Framework.popupManager.check(DynamicPopupNames.PLEASE_WAIT))
            {
               Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
            }
         }
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         this.mContents.length = 0;
         if(screenVars != null && screenVars.ext != null)
         {
            this.initExtension();
         }
         this.revalidate();
         super.initScreen();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,Peripheral.listController.onFocusCallBack));
      }
      
      override protected function back(e:Event = null) : void
      {
         super.back(e);
         this.onBack(null);
      }
      
      private function onBack(e:WidgetEvent) : void
      {
         if(this.mExtension != null)
         {
            this.mExtension.onBack();
         }
      }
      
      private function onClose(e:WidgetEvent) : void
      {
         if(this.mExtension != null)
         {
            this.mExtension.onCancel();
         }
      }
      
      public function pushItem(item:Object) : void
      {
         this.mContents.push(item);
      }
      
      private function onItem(e:WidgetEvent) : void
      {
         if(this.mExtension != null)
         {
            this.mExtension.onBtn(e.data.id);
         }
      }
      
      public function set index(index:int) : void
      {
         var item:MovieClip = null;
         for(var i:int = 0; i < this.LENGTH; i++)
         {
            item = this.assets.window["item" + i + "_button"];
            if(this.mContents.length > index + i)
            {
               item.id = this.mContents[index + i].id;
               item.icon.gotoAndStop(this.mContents[index + i].id);
               Text.format(item.label,this.mContents[index + i].label);
               item.visible = true;
            }
            else
            {
               item.visible = false;
            }
         }
      }
      
      private function onExtension(e:ExtensionEvent) : void
      {
         if(this.mCurrentBookmark != "")
         {
            this.bookmark = this.mCurrentBookmark;
         }
         screenVars = e.data;
         this.initExtension();
      }
      
      private function initExtension() : void
      {
         Framework.Trace("NavMenuWhereToScreen.initExtension() -> new Extension: " + screenVars.ext + "(" + Peripheral.navigation.navDomainControl.navActiveMenu + ")");
         if(this.mExtension != null)
         {
            this.mExtension.removeListeners();
         }
         this.clearList();
         switch(screenVars.ext)
         {
            case NavMenus.MENU_WHERE_TO:
               this.bookmark = "NavMenuWhereToDestinationEntry";
               this.mExtension = new NavMenuWehereToDestinationEntry(this);
               break;
            case NavMenus.MENU_TRIPS_ADD_DESTINATION:
               this.bookmark = "NavMenuWhereToTripsAddDestination";
               this.mExtension = new NavMenuWhereToTripsAddDestination(this);
               break;
            case NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_DEST:
               this.bookmark = "NavMenuWhereToFavoritesAddDestination";
               this.mExtension = new NavMenuWhereToFavoritesAddDestination(this);
               break;
            case NavMenus.MENU_FAVORITE_DESTINATIONS_ADD_CONTACT:
               this.bookmark = "NavMenuWhereToFavoritesAddContact";
               this.mExtension = new NavMenuWhereToFavoritesAddContact(this);
               break;
            case NavMenus.MENU_HOME_ADD_DESTINATION:
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_HOME:
            case NavMenus.MENU_LIVE_SERVICES_HDT_ADD_WORK:
            case NavMenus.MENU_LIVE_SERVICES_LS_WEATHER_WHERE_TO:
            case NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH_WHERE_TO:
               this.bookmark = "NavMenuWhereToHomeAddDestination";
               this.mExtension = new NavMenuWhereToHomeAddDestination(this);
               break;
            case NavMenus.MENU_INFORMATION:
               this.bookmark = "NavMenuWhereToInformation";
               this.mExtension = new NavMenuWhereToInformation(this);
               break;
            case NavMenus.MENU_LIVE_SERVICES_HD_TRAFFIC_MAIN:
               this.bookmark = "NavMenuWhereToLSHdTraffic";
               this.mExtension = new NavMenuWhereToLSHdTraffic(this);
               break;
            case NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS:
               this.bookmark = "NavMenuWhereToLSSpeedCameras";
               this.mExtension = new NavMenuWhereToLSSpeedCameras(this);
               break;
            case NavMenus.MENU_LIVE_SERVICES_LS_WEATHER:
               this.bookmark = "NavMenuWhereToLSWeather";
               this.mExtension = new NavMenuWhereToLSWeather(this);
               break;
            case NavMenus.MENU_LIVE_SERVICES_LS_LOCAL_SEARCH:
               this.bookmark = "NavMenuWhereToLSLocalSearch";
               this.mExtension = new NavMenuWhereToLSLocalSearch(this);
               break;
            default:
               Framework.Trace("NavMenuWhereToScreen.onActiveMenu() Unsupported Menu \'" + Peripheral.navigation.navDomainControl.navActiveMenu + "\'");
               this.mExtension = null;
         }
         if(this.mExtension != null)
         {
            this.mOverflowDetect = 0;
            this.mExtension.addListeners();
         }
         else if(this.mOverflowDetect < OVERFLOW_DETECT_MAX)
         {
            ++this.mOverflowDetect;
            Framework.Trace("OVERFLOW DETECTED");
         }
      }
      
      private function onLanguageChangeProgress(e:NavigationEvent) : void
      {
         if(Peripheral.navigation.navigation.langIsLanguageChangeInProgress == true)
         {
            Framework.popupManager.show(DynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
         }
         else if(Framework.popupManager.check(DynamicPopupNames.PLEASE_WAIT))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
         }
      }
      
      private function onLanguageChangeProgressChina(e:LocationInputEvent) : void
      {
         if(Peripheral.navigation.navLocationInput.liIsLanguageChangeInProgressChina)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_NAV_SEARCHING_POI,{"message":[T.STRB_PLEASE_WAIT,""]});
         }
         else if(Framework.popupManager.check(DynamicPopupNames.INFO_NAV_SEARCHING_POI))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_NAV_SEARCHING_POI);
         }
      }
      
      public function set title(translate:int) : void
      {
         Text.format(this.assets.title_button.label,translate);
      }
      
      public function clearList() : void
      {
         this.mContents.length = 0;
      }
      
      public function setWindowIndex(index:int) : void
      {
      }
      
      public function getWindowIndex() : int
      {
         return Peripheral.listController.itemIndex;
      }
      
      public function get length() : int
      {
         return this.mContents.length;
      }
      
      public function set selected(index:int) : void
      {
         this.assets.window.selected = index;
      }
      
      public function set total(total:String) : void
      {
      }
      
      public function get content() : Vector.<Object>
      {
         return this.mContents;
      }
      
      public function refresh(e:Event = null) : void
      {
         Peripheral.listController.invalidate();
      }
      
      public function revalidate() : void
      {
         Peripheral.listController.itemsPerLine = this.ITEMS_PER_LINE;
         Peripheral.listController.length = this.LENGTH;
         Peripheral.listController.selectedMax = this.LENGTH;
         if(!screenVars.isBack)
         {
            Peripheral.listController.selected = 0;
            Peripheral.listController.itemIndex = 0;
         }
         Peripheral.listController.total = this.mContents.length;
         Peripheral.listController.invalidate();
      }
      
      public function set bookmark(_bookmark:String) : void
      {
         this.mCurrentBookmark = _bookmark;
         Peripheral.listController.bookmark = this.mCurrentBookmark;
      }
   }
}

