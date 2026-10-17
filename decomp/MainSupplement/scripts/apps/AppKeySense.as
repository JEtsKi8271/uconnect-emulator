package apps
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.events.FrameworkEvent;
   import core.events.PopupManagerEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppKeySense extends App
   {
      
      public function AppKeySense()
      {
         super();
         id = ID.KEYSENSE;
      }
      
      override public function get cp() : IApp
      {
         return new AppKeySense();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_KEYSENSE);
         }
         return Text.getText(T.STRB_KEYSENSE);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_KeySense();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.popupManager.addEventListener(PopupManagerEvent.ACTIVE,this.onPopupManagerActive,false,0,true);
         Framework.screens.addEventListener(FrameworkEvent.IDLE,this.onFrameworkIdle,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(PopupManagerEvent.ACTIVE,this.onPopupManagerActive);
         Framework.screens.removeEventListener(FrameworkEvent.IDLE,this.onFrameworkIdle);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(this.currentScreenIsKeySense)
         {
            Framework.structure.goto(Screens.SETTINGS_KEYSENSE_MAIN);
         }
         else if(Framework.popupManager.active != DynamicPopupNames.KEYSENSE_PIN_KEYPAD)
         {
            Framework.popupManager.exit();
            Peripheral.keySensePinManager.KeySenseActivation();
         }
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateIcon() : void
      {
         if(this.currentScreenIsKeySense || this.keySensePopUpDisplayed)
         {
            this.button.icon.gotoAndStop("on");
         }
         else
         {
            this.button.icon.gotoAndStop("off");
         }
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_KEYSENSE);
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(this.currentScreenIsKeySense || this.keySensePopUpDisplayed);
      }
      
      private function onPopupManagerActive(e:PopupManagerEvent) : void
      {
         this.refresh();
      }
      
      private function onFrameworkIdle(e:FrameworkEvent) : void
      {
         this.refresh();
      }
      
      private function get keySensePopUpDisplayed() : Boolean
      {
         return Framework.popupManager.active == DynamicPopupNames.TWOITEM_KEYSENSE_PIN || Framework.popupManager.active == DynamicPopupNames.KEYSENSE_PIN_KEYPAD || Framework.popupManager.active == DynamicPopupNames.KEYSENSE_PIN_INFO;
      }
      
      private function get currentScreenIsKeySense() : Boolean
      {
         return Framework.structure.currentBranch == Screens.SETTINGS_KEYSENSE_MAIN || Framework.structure.currentBranch == Screens.SETTINGS_SIRIUS && Framework.structure.historyIndexOf(Screens.SETTINGS_KEYSENSE_MAIN) == 1 || Framework.structure.currentBranch == Screens.SETTINGS_CHANNELSKIP && Framework.structure.historyIndexOf(Screens.SETTINGS_KEYSENSE_MAIN) == 2 || Framework.structure.currentBranch == Screens.SAT_SUBSCRIPTION && Framework.structure.historyIndexOf(Screens.SETTINGS_KEYSENSE_MAIN) == 2;
      }
   }
}

