package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppECO extends App
   {
      
      private const STATE_ON:String = "on";
      
      private const STATE_OFF:String = "off";
      
      public function AppECO()
      {
         super();
         id = ID.ECO;
      }
      
      override public function get cp() : IApp
      {
         return new AppECO();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_ECO);
         }
         return Text.getText(T.STRB_ECO);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_ECO();
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
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.ECO_MODE,this.onEco);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.ECO_MODE,this.onEco);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Peripheral.vehSettings.ecoMode() == this.STATE_ON)
         {
            Peripheral.vehSettings.setEcoMode(this.STATE_OFF);
         }
         else if(Peripheral.vehSettings.ecoMode() == this.STATE_OFF)
         {
            Peripheral.vehSettings.setEcoMode(this.STATE_ON);
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
         this.button.icon.gotoAndStop(Peripheral.vehSettings.ecoMode() == this.STATE_OFF ? 1 : 2);
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_ECO);
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Peripheral.vehSettings.ecoMode() == this.STATE_ON);
      }
      
      private function onEco(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
   }
}

