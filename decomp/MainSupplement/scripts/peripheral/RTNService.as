package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.moduleLinkAPI.CVPDemoEvent;
   import com.harman.moduleLinkAPI.ConnectionManagerEvent;
   import com.nfuzion.framework.global.Framework;
   import core.events.PopupManagerEvent;
   import events.GlobalEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RTNService extends EventDispatcher
   {
      
      private static var instance:RTNService;
      
      private var mMSLCode:String;
      
      private var mATRTNActive:Boolean;
      
      private var mATRESETActive:Boolean;
      
      private var mSuccess:Boolean;
      
      private var mFailed:Boolean;
      
      private var RTNState:int;
      
      private var m4Received:Boolean;
      
      private var mWDSIinProgress:Boolean;
      
      private var mConfirmBoxOpen:Boolean;
      
      private var mWDSI4Timer:Timer = new Timer(60000);
      
      private var mWDSI21Timer:Timer = new Timer(120000);
      
      public function RTNService()
      {
         super();
      }
      
      public static function getInstance() : RTNService
      {
         if(instance == null)
         {
            instance = new RTNService();
         }
         return instance;
      }
      
      public function init() : void
      {
      }
      
      public function onNewRTN() : void
      {
         this.RTNState = 0;
         this.mWDSIinProgress = false;
         this.mMSLCode = "";
         this.mATRTNActive = false;
         this.mATRESETActive = false;
         this.mSuccess = false;
         this.mFailed = false;
         this.mConfirmBoxOpen = false;
         Framework.popupManager.addEventListener(GlobalEvent.SPELLER_POPUP_OK,this.onMSLInput,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.CLOSE,this.onMSLInputClosed,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.EMB_PHONE_DEBUGAT_ANSWER,this.onDebugATRTNResponse,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.DEVICE_SERVICE_STATUS,this.onDeviceStatus,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.EMB_PHONE_STATUS,this.onEmbStatus,false,0,true);
         Peripheral.connectionManager.addEventListener(ConnectionManagerEvent.INTERNET_CONNECTED,this.onInternetConnected,false,0,true);
         Peripheral.connectionManager.addEventListener(ConnectionManagerEvent.SWITCH_USAGE,this.onSwitchUsageResp,false,0,true);
         this.mWDSI4Timer.addEventListener(TimerEvent.TIMER,this.onWDSI4Timer,false,0,true);
         this.mWDSI21Timer.addEventListener(TimerEvent.TIMER,this.onWDSI21Timer,false,0,true);
         Framework.popupManager.show(DynamicPopupNames.PHONE_PIN_CHANGE,"phonechangepinpopup",{"screen":DynamicPopupNames.SPELLER_PHONE_RTN_MSL_PASSPHRASE});
      }
      
      public function onRTNComplete() : void
      {
         Framework.Trace("RTN Complete, Cleaning up");
         this.RTNState = 0;
         this.mWDSIinProgress = false;
         this.mMSLCode = "";
         this.mATRTNActive = false;
         this.mATRESETActive = false;
         this.mSuccess = false;
         this.mFailed = false;
         Framework.popupManager.removeEventListener(GlobalEvent.SPELLER_POPUP_OK,this.onMSLInput);
         Framework.popupManager.removeEventListener(PopupManagerEvent.CLOSE,this.onMSLInputClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.EMB_PHONE_DEBUGAT_ANSWER,this.onDebugATRTNResponse);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.DEVICE_SERVICE_STATUS,this.onDeviceStatus);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.EMB_PHONE_STATUS,this.onEmbStatus);
         Peripheral.connectionManager.removeEventListener(ConnectionManagerEvent.INTERNET_CONNECTED,this.onInternetConnected);
         Peripheral.connectionManager.removeEventListener(ConnectionManagerEvent.SWITCH_USAGE,this.onSwitchUsageResp);
         this.mWDSI4Timer.removeEventListener(TimerEvent.TIMER,this.onWDSI4Timer);
         this.mWDSI21Timer.removeEventListener(TimerEvent.TIMER,this.onWDSI21Timer);
      }
      
      public function isRTNActive() : Boolean
      {
         return this.mATRTNActive;
      }
      
      private function onEmbStatus(e:CVPDemoEvent) : void
      {
         var status:Boolean = false;
         status = Boolean(e.mData.status);
         if(status)
         {
            if(this.RTNState == 0 && this.mATRTNActive)
            {
               this.RTNState = 1;
               Peripheral.cvpdemo.sendDebugAT("at!slval=" + this.mMSLCode);
            }
            else if(this.mATRTNActive && this.mSuccess)
            {
               this.mATRTNActive = false;
               Peripheral.connectionManager.switchEmbeddedPhoneUsage("on");
            }
            else if(this.mSuccess || this.mFailed)
            {
               Peripheral.connectionManager.switchEmbeddedPhoneUsage("on");
            }
         }
      }
      
      private function onInternetConnected(e:ConnectionManagerEvent) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_PHONE_MENU);
      }
      
      private function onSwitchUsageResp(e:ConnectionManagerEvent) : void
      {
         if(this.mATRTNActive && !this.mSuccess)
         {
            if(e.mData.success == 1)
            {
               Peripheral.cvpdemo.sendDebugAT("AT$RTN=" + this.mMSLCode);
            }
            else
            {
               Framework.Trace("Error: Unable to switch embedded Phone Status");
            }
         }
         else if(!this.mATRESETActive && this.mSuccess)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_PHONE_MENU);
         }
      }
      
      private function onDeviceStatus(e:CVPDemoEvent) : void
      {
         var WSDI:int = 0;
         if(!this.mWDSIinProgress)
         {
            return;
         }
         WSDI = int(e.mData.event);
         switch(WSDI)
         {
            case 4:
               if(!this.m4Received)
               {
                  this.m4Received = true;
                  this.mWDSI4Timer.stop();
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.RTN_ACTIVATION_STARTED,{
                     "screen":DynamicPopupNames.RTN_ACTIVATION_STARTED,
                     "timeout":0,
                     "title":"",
                     "message":"Activation Started"
                  });
                  Framework.popupManager.dequeue(DynamicPopupNames.RTN_WAITING_ACTIVATION);
                  this.mWDSI21Timer.start();
               }
               break;
            case 21:
               this.mWDSI21Timer.stop();
               this.RTNState = 5;
               Peripheral.cvpdemo.sendDebugAT("at+ifc=0,0");
               break;
            case 5:
            case 7:
               if(this.m4Received)
               {
                  this.mWDSIinProgress = false;
                  this.mWDSI4Timer.stop();
                  Peripheral.cvpdemo.sendDebugAT("at!reset");
                  this.mFailed = true;
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.RTN_ACTIVATION_FAILED,{
                     "screen":DynamicPopupNames.RTN_ACTIVATION_FAILED,
                     "timeout":0,
                     "title":"",
                     "message":"Activation Failed."
                  });
                  Framework.popupManager.dequeue(DynamicPopupNames.RTN_ACTIVATION_STARTED);
               }
               break;
            default:
               Framework.Trace("Unsupported WSDI Value: " + WSDI);
         }
      }
      
      private function onWDSI4Timer(e:TimerEvent) : void
      {
         if(this.mWDSIinProgress)
         {
            this.mWDSIinProgress = false;
            this.mWDSI4Timer.stop();
            this.RTNState = 5;
            Peripheral.cvpdemo.sendDebugAT("at+ifc=0,0");
         }
      }
      
      private function onWDSI21Timer(e:TimerEvent) : void
      {
         if(this.mWDSIinProgress)
         {
            this.mWDSIinProgress = false;
            this.mWDSI21Timer.stop();
            this.RTNState = 5;
            Peripheral.cvpdemo.sendDebugAT("at+ifc=0,0");
         }
      }
      
      private function onDebugATRTNResponse(e:CVPDemoEvent) : void
      {
         if(e.mData.code != 0 && this.mATRTNActive && this.RTNState == 0)
         {
            this.mATRTNActive = false;
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_PHONE_MENU,{
               "screen":DynamicPopupNames.INFO_PHONE_MENU,
               "timeout":10000,
               "title":"",
               "message":"Incorrect Access Code"
            });
            Framework.popupManager.dequeue(DynamicPopupNames.RTN_STARTED);
         }
         else if((this.mSuccess || this.mFailed) && this.mATRTNActive)
         {
            this.mATRTNActive = false;
         }
         else if(e.mData.code == 0 && this.mATRTNActive)
         {
            switch(this.RTNState)
            {
               case 1:
                  Peripheral.cvpdemo.sendDebugAT("at+wdsw=12,0");
                  this.RTNState = 2;
                  break;
               case 2:
                  Peripheral.cvpdemo.sendDebugAT("at!reset");
                  this.RTNState = 3;
                  break;
               case 3:
                  this.RTNState = 4;
                  this.m4Received = false;
                  this.mWDSIinProgress = true;
                  this.mWDSI4Timer.start();
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.RTN_WAITING_ACTIVATION,{
                     "screen":DynamicPopupNames.RTN_WAITING_ACTIVATION,
                     "timeout":0,
                     "title":"",
                     "message":"RTN Complete, waiting for activation"
                  });
                  Framework.popupManager.dequeue(DynamicPopupNames.RTN_STARTED);
                  break;
               case 5:
                  this.RTNState = 6;
                  Peripheral.cvpdemo.sendDebugAT("at+cnmi=2,1,0,1,0");
                  break;
               case 6:
                  this.RTNState = 7;
                  Peripheral.cvpdemo.sendDebugAT("at&w");
                  break;
               case 7:
                  this.mWDSIinProgress = false;
                  this.mSuccess = true;
                  Peripheral.cvpdemo.sendDebugAT("at!reset");
                  Ancillary.definedDynamicPopups.popup(DynamicPopupNames.RTN_ACTIVATION_SUCCESS,{
                     "screen":DynamicPopupNames.RTN_ACTIVATION_SUCCESS,
                     "timeout":0,
                     "title":"",
                     "message":"Activation Success!"
                  });
                  Framework.popupManager.dequeue(DynamicPopupNames.RTN_ACTIVATION_STARTED);
                  Framework.popupManager.dequeue(DynamicPopupNames.RTN_WAITING_ACTIVATION);
                  this.onRTNComplete();
            }
         }
         else if(this.mATRESETActive)
         {
            this.mATRESETActive = false;
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_PHONE_WAITING_ON_RESPONSE);
         }
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         this.mATRTNActive = true;
         Peripheral.connectionManager.switchEmbeddedPhoneUsage("off");
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.RTN_STARTED,{
            "screen":DynamicPopupNames.RTN_STARTED,
            "timeout":0,
            "title":"",
            "message":"RTN Started."
         });
      }
      
      private function onMSLInput(e:GlobalEvent) : void
      {
         Framework.Trace("onMSLInput()");
         try
         {
            if(e.data.type == DynamicPopupNames.SPELLER_PHONE_RTN_MSL_PASSPHRASE)
            {
               this.mMSLCode = e.data.input;
               this.mConfirmBoxOpen = true;
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_PHONE_ASK_CLEAR_ALL_SETTINGS,{"screen":DynamicPopupNames.TWOITEM_PHONE_ASK_CLEAR_ALL_SETTINGS});
               Framework.popupManager.dequeue(DynamicPopupNames.PHONE_PIN_CHANGE);
            }
         }
         catch(errObj:Error)
         {
            Framework.Trace("<AppListPhoneRTN> " + errObj.message);
         }
      }
      
      private function onMSLInputClosed(e:PopupManagerEvent) : void
      {
         Framework.Trace("onMSLInputClosed: " + e.address);
         Framework.Trace(e.toString());
         if(e.address != "phonechangepinpopup")
         {
            if(this.mConfirmBoxOpen)
            {
               this.mConfirmBoxOpen = false;
               Framework.Trace("closing popup2item");
               Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_PHONE_ASK_CLEAR_ALL_SETTINGS);
            }
         }
      }
   }
}

