package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import apps.App;
   import apps.IApp;
   import com.harman.framework.controller.IList;
   import com.harman.framework.template.ScreenList;
   import com.nfuzion.framework.global.Framework;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.utils.Text;
   import events.LocaleEvent;
   import events.TaskBarManagerEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   import skin.Skin;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class AppsHomeScreen extends ScreenList implements IList
   {
      
      private const LENGTH:int = 12;
      
      private const ITEMS_PER_PAGE:int = 12;
      
      private var assets:C_AppsHome = new C_AppsHome();
      
      private var mIndex:int = 0;
      
      public function AppsHomeScreen()
      {
         mView = this.assets;
         cache = true;
         super();
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.listController.bookmark = "AppsHomeScreen";
         Peripheral.listController.allowICSTuning(true);
         Peripheral.listController.construct(this);
         this.assets.window.addEventListener(WidgetEvent.LONG_PRESS,this.onLongPress,false,0,true);
         this.assets.window.addEventListener(WidgetEvent.CLICK,this.onClick,false,0,true);
         Peripheral.taskBarManager.addEventListener(TaskBarManagerEvent.UPDATE,this.onUpdate,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Peripheral.listController.bookmark = "AppsHomeScreen";
         Peripheral.listController.deconstruct();
         this.assets.window.removeEventListener(WidgetEvent.LONG_PRESS,this.onLongPress);
         this.assets.window.removeEventListener(WidgetEvent.CLICK,this.onClick);
         Peripheral.taskBarManager.removeEventListener(TaskBarManagerEvent.UPDATE,this.onUpdate);
      }
      
      override protected function initView() : void
      {
         this.onTotalPages();
         super.initView();
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.itemsPerLine = 12;
         Peripheral.listController.length = 12;
         Peripheral.listController.selectedMax = 12;
         Peripheral.listController.total = Peripheral.taskBarManager.all.length;
         Framework.structure.setExit();
         Peripheral.listController.invalidate();
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         Text.format(this.assets.label_pressAndHold,T.STRB_PRESS_AND_HOLD_ICONS);
         super.changeLocale(e);
         this.populate();
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
      }
      
      private function onTotalPages() : void
      {
         var i:int = 0;
         var page:C_Icon_Page = null;
         var mTotalPages:int = Math.ceil(Peripheral.taskBarManager.all.length / this.ITEMS_PER_PAGE);
         var mPage:int = Math.ceil(this.mIndex / this.ITEMS_PER_PAGE);
         while(this.assets.pages.numChildren > 0)
         {
            this.assets.pages.removeChildAt(0);
         }
         if(mTotalPages >= 2)
         {
            for(i = 0; i < mTotalPages; i++)
            {
               page = new C_Icon_Page();
               page.x = i * 15;
               this.assets.pages.addChild(page);
               if(i == mPage)
               {
                  Skin.style.applyStyle(page,Skin.style.currentTheme.activeStateStandard);
               }
            }
         }
         this.assets.pages.x = (this.assets.screenWidth - this.assets.pages.width) / 2;
      }
      
      private function populate() : void
      {
         var app:IApp = null;
         this.clearWindow();
         var focusArray:Array = new Array();
         for(var i:int = 0; i < this.ITEMS_PER_PAGE; i++)
         {
            if(this.mIndex + i < Peripheral.taskBarManager.all.length)
            {
               app = Peripheral.taskBarManager.all[this.mIndex + i];
               MovieClip(this.assets.window).addChild(app.button);
               app.button.x = this.assets.COOR[i][0];
               app.button.y = this.assets.COOR[i][1];
               app.button.longPress = 1000;
               app.button.setFavorite(false);
               app.button.id = this.mIndex + i;
               app.button.remove = app.removeListeners;
               app.addListeners();
               app.refresh();
               app.button.name = "AppsControlButton";
               focusArray.push(app.button);
            }
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,null,Peripheral.listController.onFocusCallBack));
      }
      
      private function clearWindow() : void
      {
         var button:MovieClip = null;
         while(this.assets.window.numChildren > 0)
         {
            button = MovieClip(this.assets.window).getChildAt(0) as MovieClip;
            if(button.remove != null)
            {
               button.remove();
               button.remove = null;
            }
            this.assets.window.removeChild(button);
         }
      }
      
      private function onLongPress(e:WidgetEvent) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            Peripheral.taskBarManager.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.DRAG_AND_DROP,e.data));
         }
      }
      
      private function onClick(e:WidgetEvent) : void
      {
         var app:App = Peripheral.taskBarManager.all[e.data.id];
         app.press();
      }
      
      private function onUpdate(e:TaskBarManagerEvent) : void
      {
         Peripheral.listController.total = Peripheral.taskBarManager.all.length;
         this.onTotalPages();
         this.populate();
      }
      
      public function set index(index:int) : void
      {
         if(this.mIndex != index)
         {
            this.mIndex = index;
            this.populate();
            this.onTotalPages();
         }
      }
      
      public function set total(total:String) : void
      {
      }
      
      public function get length() : int
      {
         return Peripheral.taskBarManager.all.length;
      }
      
      public function set selected(index:int) : void
      {
      }
   }
}

