package apps
{
   import ancillary.DynamicPopupNames;
   import com.nfuzion.framework.global.Framework;
   import core.events.PopupManagerEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppControls extends App
   {
      
      public function AppControls()
      {
         super();
         id = ID.CONTROLS;
      }
      
      override public function get cp() : IApp
      {
         return new AppControls();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_CONTROLS);
         }
         return Text.getText(T.STRB_CONTROLS_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Controls();
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
         Framework.popupManager.addEventListener(PopupManagerEvent.CLOSE,this.onPopupManagerClose,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(PopupManagerEvent.ACTIVE,this.onPopupManagerActive);
         Framework.popupManager.removeEventListener(PopupManagerEvent.CLOSE,this.onPopupManagerClose);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.CONTROLS)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
         }
         else
         {
            Peripheral.controlsPopupManager.showControlsPopup();
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
         this.button.icon.gotoAndStop(Peripheral.vehConfig.hasHeatedSeat ? 1 : 2);
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_MENU_CONTROLS);
         }
         else
         {
            Text.format(this.button.label,T.STRB_CONTROLS_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         if(this.button.name == "AppsControlButton")
         {
            this.button.tab.visible = false;
         }
         else
         {
            this.button.tab.visible = Framework.popupManager.active == DynamicPopupNames.CONTROLS;
         }
         this.button.setHighlight(Framework.popupManager.active == DynamicPopupNames.CONTROLS);
      }
      
      private function onPopupManagerActive(e:PopupManagerEvent) : void
      {
         this.updateHighlight();
      }
      
      private function onPopupManagerClose(e:PopupManagerEvent) : void
      {
         if(e.vars.id == DynamicPopupNames.CONTROLS)
         {
            this.button.tab.visible = false;
            this.button.setHighlight(false);
         }
      }
   }
}

