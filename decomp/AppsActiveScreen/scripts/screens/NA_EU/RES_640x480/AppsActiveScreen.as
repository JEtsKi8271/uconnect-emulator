package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenGeneric;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.nfuzion.framework.global.Framework;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.events.Event;
   import peripheral.AppStateManager;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class AppsActiveScreen extends ScreenGeneric
   {
      
      private var assets:C_AppsActive = new C_AppsActive();
      
      private var mStopped:Boolean = false;
      
      public function AppsActiveScreen()
      {
         view = this.assets;
         super();
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
         this.addListeners();
         screenInComplete();
         this.mStopped = false;
         if(Peripheral.appManager.getLastRunningAppId() == Peripheral.appManager.getSuperAppId() || Peripheral.appManager.getRunningAppId() == Peripheral.appManager.getSuperAppId())
         {
            this.assets.close_button.visible = false;
         }
         else
         {
            this.assets.close_button.visible = true;
         }
         Peripheral.displayManager.requestDisplay("ams",true);
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_VIA_MOBILE_LOADING);
         Framework.popupManager.dequeue(DynamicPopupNames.INFO_UCONN_LOADING);
         Framework.popupManager.close();
         if(Peripheral.appManager.getRunningAppId() == "3bbeae36-1542-11e1-b393-31614824019b")
         {
            AppStateManager.getInstance().assistAppRunningInBkgd = false;
         }
         if(Peripheral.appManager.getRunningAppId() != Peripheral.appManager.getLastRunningAppId() || Boolean(Peripheral.appManager.getPendingPause()))
         {
            Peripheral.appManager.startLastPausedApp("Resume");
         }
         if(Peripheral.appManager.getRunningAppId() == "" && Peripheral.appManager.getLastRunningAppId() == "")
         {
            Framework.structure.goto(Screens.MAIN_APPS);
         }
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
         var curApp:String = Peripheral.appManager.getRunningAppId();
         if(curApp != "" && !this.mStopped)
         {
            Peripheral.appManager.pauseXlet(curApp);
         }
         this.removeListeners();
         screenOutComplete();
         Peripheral.displayManager.requestDisplay("ams",false);
      }
      
      private function addListeners() : void
      {
         Peripheral.appManager.addEventListener(AppManagerEvent.CLOSE,this.onClose2,false,0,true);
         this.assets.close_button.addEventListener(WidgetEvent.CLICK,this.onClose,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_PAUSED,this.onAppPaused,false,0,true);
         Peripheral.hardControls.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.onVerticalScroll,false,0,true);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.STATUS_BAR_AVAILABILITY,this.onStatusBarChange,false,0,true);
      }
      
      private function removeListeners() : void
      {
         Peripheral.appManager.removeEventListener(AppManagerEvent.CLOSE,this.onClose2);
         this.assets.close_button.removeEventListener(WidgetEvent.CLICK,this.onClose);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_PAUSED,this.onAppPaused);
         Peripheral.appManager.removeEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate);
         Peripheral.hardControls.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.onVerticalScroll);
         Peripheral.hmiRequest.removeEventListener(HMIRequestEvent.STATUS_BAR_AVAILABILITY,this.onStatusBarChange);
      }
      
      private function onClose(e:Event) : void
      {
         var curApp:String = Peripheral.appManager.getRunningAppId();
         Peripheral.appManager.closedAppId = curApp;
         if(curApp != "")
         {
            Peripheral.appManager.stopXlet(curApp);
            this.mStopped = true;
         }
         if(Peripheral.appManager.getPPId() != curApp)
         {
            Framework.structure.goto(Screens.MAIN_APPS);
         }
         else
         {
            Framework.structure.back();
         }
      }
      
      private function onClose2(e:Event) : void
      {
         var curApp:String = Peripheral.appManager.getRunningAppId();
         Peripheral.appManager.closedAppId = curApp;
         if(curApp != "")
         {
            this.mStopped = true;
         }
         if(Peripheral.appManager.getPPId() != curApp)
         {
            Framework.structure.goto(Screens.MAIN_APPS);
         }
         else
         {
            Framework.structure.back();
         }
      }
      
      private function onOperStatusUpdate(e:AppManagerEvent) : void
      {
         if(Peripheral.appManager.getLastRunningAppId() == Peripheral.appManager.getSuperAppId() || Peripheral.appManager.getRunningAppId() == Peripheral.appManager.getSuperAppId())
         {
            this.assets.close_button.visible = false;
         }
         else
         {
            this.assets.close_button.visible = true;
         }
         if(e.mData.operStatus.state.toLowerCase() == "running" && e.mData.operStatus.daemon == false && e.mData.operStatus.headless == false)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.INFO_APPS_LOADING);
         }
         if(e.mData.operStatus.state.toLowerCase() == "paused" && e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId())
         {
         }
         if(e.mData.operStatus.state.toLowerCase() == "stopped" && e.mData.operStatus.appId == Peripheral.appManager.getSuperAppId())
         {
            Framework.structure.goto(Screens.MAIN_APPS);
         }
      }
      
      private function onAppPaused(e:AppManagerEvent) : void
      {
         if(e.mData == Peripheral.appManager.getSuperAppId())
         {
         }
      }
      
      private function onVerticalScroll(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
      }
      
      private function onStatusBarChange(event:HMIRequestEvent) : void
      {
         view.status = event.mData.statusBarAvailability.isAvailable;
      }
   }
}

