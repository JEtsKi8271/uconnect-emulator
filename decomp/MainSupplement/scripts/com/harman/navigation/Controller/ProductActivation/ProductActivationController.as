package com.harman.navigation.Controller.ProductActivation
{
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class ProductActivationController extends EventDispatcher implements IProductActivation
   {
      
      private var mWaitPunishmentTime:int = 1;
      
      private var mWaitPunishmentInterval:uint = 0;
      
      private const WAIT_PUNISHMENT_TIME_MULTIPLIER:int = 4;
      
      private const WAIT_PUNISHMENT_TIME_MULTIPLIER_MAX:int = 60;
      
      private var mActiveMenu:int = 64;
      
      private var mProductRequestCode:String = "";
      
      private var mProductActivationCode:String = "";
      
      public function ProductActivationController()
      {
         super();
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_DEVICE_ID,this.onDeviceIDUpdate,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_ACTIVATION_RESPONSE,this.onActivationResponse,false,0,true);
      }
      
      public function activate() : void
      {
         Framework.Trace("ProductActivationController.activate()");
         this.changeToScreen(this.mActiveMenu);
      }
      
      public function getProductRequestCode() : void
      {
         NavigationPackage.peripheral.navigation.navigation.getAuthenticationDeviceID();
      }
      
      public function get productRequestCode() : String
      {
         return this.mProductRequestCode;
      }
      
      public function get productActivationCode() : String
      {
         return this.mProductActivationCode;
      }
      
      public function gotoActivationCodeSpeller() : void
      {
         this.changeToScreen(NavMenus.MENU_NAV_READY_SPELLER);
      }
      
      public function submitActivationCode(code:String) : void
      {
         Framework.Trace("ProductActivationController.submitActivationCode( " + code + " )");
         this.mProductActivationCode = code;
         NavigationPackage.peripheral.navigation.navigation.setAuthenticationCode(this.mProductActivationCode);
         this.changeToScreen(NavMenus.MENU_NAV_READY_WAIT);
      }
      
      public function onBackToRequestCodeScreen() : void
      {
         this.changeToScreen(NavMenus.MENU_NAV_READY_ANNOUNCEMENT);
      }
      
      public function onRetryActivationCodeEntry() : void
      {
         this.showPunishmentScreen();
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new ProductActivationEvent(eventType));
      }
      
      private function changeToScreen(navMenuID:int) : void
      {
         Framework.Trace("ProductActivationController.changeToScreen( " + navMenuID + " )");
         this.mActiveMenu = navMenuID;
         if(NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
         {
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenu(this.mActiveMenu);
         }
      }
      
      private function showPunishmentScreen() : void
      {
         Framework.Trace("ProductActivationController.showPunishmentScreen( " + this.mWaitPunishmentTime + " seconds )");
         this.changeToScreen(NavMenus.MENU_NAV_READY_PUNISHMENT);
         this.mWaitPunishmentInterval = setInterval(this.onWaitScreenTimeout,this.mWaitPunishmentTime * 1000);
         this.mWaitPunishmentTime *= this.WAIT_PUNISHMENT_TIME_MULTIPLIER;
         if(this.mWaitPunishmentTime >= this.WAIT_PUNISHMENT_TIME_MULTIPLIER_MAX)
         {
            this.mWaitPunishmentTime = this.WAIT_PUNISHMENT_TIME_MULTIPLIER_MAX;
         }
      }
      
      private function onWaitScreenTimeout() : void
      {
         clearInterval(this.mWaitPunishmentInterval);
         this.changeToScreen(NavMenus.MENU_NAV_READY_SPELLER);
      }
      
      private function onDeviceIDUpdate(e:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navigation.authenticationDeviceID != null)
         {
            Framework.Trace("ProductActivationController.onDeviceIDUpdate( " + NavigationPackage.peripheral.navigation.navigation.authenticationDeviceID + " )");
            this.mProductRequestCode = NavigationPackage.peripheral.navigation.navigation.authenticationDeviceID;
            this.sendEvent(ProductActivationEvent.PA_REQUEST_CODE);
         }
      }
      
      private function onActivationResponse(e:NavigationEvent) : void
      {
         Framework.Trace("ProductActivationController.onActivationResponse( " + NavigationPackage.peripheral.navigation.navigation.authenticationResponse + " )");
         if(NavigationPackage.peripheral.navigation.navigation.authenticationResponse == true)
         {
            this.changeToScreen(NavMenus.MENU_NAV_READY_ACCEPTED);
         }
         else
         {
            this.changeToScreen(NavMenus.MENU_NAV_READY_DECLINED);
         }
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function isReady() : Boolean
      {
         return true;
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
   }
}

