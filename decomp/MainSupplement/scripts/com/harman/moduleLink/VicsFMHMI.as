package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVicsFMHMI;
   import com.harman.moduleLinkAPI.VicsFMHMIEvent;
   import com.harman.moduleLinkAPI.VicsFMInterButton;
   import com.harman.moduleLinkAPI.VicsFMMenuButton;
   import com.harman.moduleLinkAPI.VicsFMMenuDataState;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VicsFMHMI extends Module implements IVicsFMHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnVicsFmHmi.NavCtrl_Driver";
      
      private static const MENU_DATA:String = "menuData";
      
      private static const MENU_BUTTON:String = "menuButton";
      
      private static const IS_MENU_DATA_UPDATED:String = "isMenuDataUpdated";
      
      private static const IS_SUBMENU_DISPLAYED:String = "isSubmenuDisplayed";
      
      private static const INTER_BUTTON:String = "interButton";
      
      private static const DRAW_MENU_TOP_PAGE_TEXT:String = "requestDrawMenuTopPageText";
      
      private static const DRAW_MENU_TOP_PAGE_DIAG:String = "requestDrawMenuTopPageDiag";
      
      private static const DRAW_MENU_PREV_PAGE:String = "requestDrawMenuPrevPage";
      
      private static const DRAW_MENU_NEXT_PAGE:String = "requestDrawMenuNextPage";
      
      private static const DRAW_MENU_PROGRAM:String = "requestDrawMenuProgram";
      
      private static const DRAW_MENU_BACK:String = "requestDrawMenuBack";
      
      private static const FINISH_MENU:String = "requestFinishMenu";
      
      private static const DRAW_INTER_TOP_PAGE:String = "requestDrawInterTopPage";
      
      private static const DRAW_INTER_PREV_PAGE:String = "requestDrawInterPrevPage";
      
      private static const DRAW_INTER_NEXT_PAGE:String = "requestDrawInterNextPage";
      
      private static const FINISH_INTERRUPT:String = "requestFinishInterrupt";
      
      private static const EVENT_INTERRUPT:String = "informationEventInterrupt";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mMenuDataState:Object = new VicsFMMenuDataState();
      
      private var mMenuButton:Object = new VicsFMMenuButton();
      
      private var mInterButton:Object = new VicsFMInterButton();
      
      private var mIsMenuDataUpdated:Boolean = false;
      
      private var mIsSubmenuDisplayed:Boolean = false;
      
      private var mCurrntType:uint = 0;
      
      private var mPrgNum:uint = 0;
      
      public function VicsFMHMI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.FMHMI,this.VICSFMHMIMessageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAttributeSubscribes();
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function requestAttributesInitialValue() : void
      {
         this.requestMenuData();
         this.requestMenuButton();
         this.requestInterButton();
         this.requestIsMenuDataUpdated();
         this.requestIsSubmenuDisplayed();
      }
      
      public function requestMenuData() : void
      {
         this.sendCommandSimple(MENU_DATA);
      }
      
      public function requestMenuButton() : void
      {
         this.sendCommandSimple(MENU_BUTTON);
      }
      
      public function requestInterButton() : void
      {
         this.sendCommandSimple(INTER_BUTTON);
      }
      
      public function requestIsMenuDataUpdated() : void
      {
         this.sendCommandSimple(IS_MENU_DATA_UPDATED);
      }
      
      public function requestIsSubmenuDisplayed() : void
      {
         this.sendCommandSimple(IS_SUBMENU_DISPLAYED);
      }
      
      public function requestDrawMenuTopPageText() : void
      {
         this.sendCommandSimple(DRAW_MENU_TOP_PAGE_TEXT);
      }
      
      public function requestDrawMenuTopPageDiag() : void
      {
         this.sendCommandSimple(DRAW_MENU_TOP_PAGE_DIAG);
      }
      
      public function requestDrawMenuPrevPage() : void
      {
         this.sendCommandSimple(DRAW_MENU_PREV_PAGE);
      }
      
      public function requestDrawMenuNextPage() : void
      {
         this.sendCommandSimple(DRAW_MENU_NEXT_PAGE);
      }
      
      public function requestDrawMenuProgram(value:int) : void
      {
         this.sendCommand(DRAW_MENU_PROGRAM,"number",String(value));
      }
      
      public function requestDrawMenuBack() : void
      {
         this.sendCommandSimple(DRAW_MENU_BACK);
      }
      
      public function requestFinishMenu() : void
      {
         this.sendCommandSimple(FINISH_MENU);
      }
      
      public function requestDrawInterTopPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_TOP_PAGE);
      }
      
      public function requestDrawInterPrevPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_PREV_PAGE);
      }
      
      public function requestDrawInterNextPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_NEXT_PAGE);
      }
      
      public function requestFinishInterrupt() : void
      {
         this.sendCommandSimple(FINISH_INTERRUPT);
      }
      
      public function setCurrentType(type:uint) : void
      {
         this.mCurrntType = type;
      }
      
      public function setPrgNum(number:uint) : void
      {
         this.mPrgNum = number;
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.sendSubscribe(MENU_DATA);
         this.sendSubscribe(MENU_BUTTON);
         this.sendSubscribe(INTER_BUTTON);
         this.sendSubscribe(IS_MENU_DATA_UPDATED);
         this.sendSubscribe(IS_SUBMENU_DISPLAYED);
         this.sendSubscribe(EVENT_INTERRUPT);
      }
      
      private function VICSFMHMIMessageHandler(e:ConnectionEvent) : void
      {
         var fmData:Object = e.data;
         if(fmData.hasOwnProperty(MENU_DATA))
         {
            this.mMenuDataState = this.mMenuDataState.copyVICSFMMenuDataState(fmData.menuData[1]);
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.MENU_DATA));
         }
         else if(fmData.hasOwnProperty(MENU_BUTTON))
         {
            this.mMenuButton = this.mMenuButton.copyVICSFMMenuButton(fmData.menuButton[1]);
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.MENU_BUTTON));
         }
         else if(fmData.hasOwnProperty(INTER_BUTTON))
         {
            this.mInterButton = this.mInterButton.copyVICSFMInterButton(fmData.interButton[1]);
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.INTER_BUTTON));
         }
         else if(fmData.hasOwnProperty(IS_MENU_DATA_UPDATED))
         {
            this.mIsMenuDataUpdated = fmData.isMenuDataUpdated[1];
         }
         else if(fmData.hasOwnProperty(IS_SUBMENU_DISPLAYED))
         {
            this.mIsSubmenuDisplayed = fmData.isSubmenuDisplayed[1];
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_TOP_PAGE_TEXT))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_TOP_PAGE_TEXT,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_TOP_PAGE_DIAG))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_TOP_PAGE_DIAG,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_PREV_PAGE))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_PREV_PAGE,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_NEXT_PAGE))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_NEXT_PAGE,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_PROGRAM))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_PROGRAM,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_MENU_BACK))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_MENU_BACK,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_INTER_TOP_PAGE))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_INTER_TOP_PAGE,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_INTER_PREV_PAGE))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_INTER_PREV_PAGE,e.data));
         }
         else if(fmData.hasOwnProperty(DRAW_INTER_NEXT_PAGE))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.DRAW_INTER_NEXT_PAGE,e.data));
         }
         else if(fmData.hasOwnProperty(FINISH_INTERRUPT))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.FINISH_INTERRUPT,e.data));
         }
         else if(fmData.hasOwnProperty(EVENT_INTERRUPT))
         {
            this.dispatchEvent(new VicsFMHMIEvent(VicsFMHMIEvent.EVENT_INTERRUPT,e.data));
         }
         else
         {
            trace("Unexpected property returned to VICSFMHMI module");
         }
      }
      
      public function get MenuDataState() : Object
      {
         return this.mMenuDataState;
      }
      
      public function get MenuButton() : Object
      {
         return this.mMenuButton;
      }
      
      public function get InterButton() : Object
      {
         return this.mInterButton;
      }
      
      public function get IsMenuDataUpdated() : Boolean
      {
         return this.mIsMenuDataUpdated;
      }
      
      public function get IsSubmenuDisplayed() : Boolean
      {
         return this.mIsSubmenuDisplayed;
      }
      
      public function get CurrentType() : uint
      {
         return this.mCurrntType;
      }
      
      public function get PrgNum() : uint
      {
         return this.mPrgNum;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommandSimple(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

