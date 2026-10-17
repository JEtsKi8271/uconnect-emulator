package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppHeatedSteeringWheel extends App
   {
      
      private var assets:C_Button_HeatedSteeringWheel = new C_Button_HeatedSteeringWheel();
      
      private const HEAT_WHEEL:String = "heatedWheel";
      
      private const VEHICLE_ON:String = "on";
      
      private const VEHICLE_OFF:String = "off";
      
      public function AppHeatedSteeringWheel()
      {
         super();
         id = ID.HEATEDSTEERINGWHEEL;
      }
      
      override public function get cp() : IApp
      {
         return new AppHeatedSteeringWheel();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_HT_WHEEL);
         }
         return Text.getText(T.STRB_MENU_HEATED_WHEEL);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_HeatedSteeringWheel();
            this.button.alwaysClick = true;
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
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEATED_STEERING_WHEEL,this.onHeatedWheel,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEATED_STEERING_WHEEL_FAIL,this.onHeatedWheelFailure,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.HEATED_STEERING_WHEEL,this.onHeatedWheel);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.HEATED_STEERING_WHEEL_FAIL,this.onHeatedWheelFailure);
         super.removeListeners();
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
      }
      
      override public function updateIcon() : void
      {
         if(Peripheral.vehSettings.controlFeaturesDisabled || Peripheral.vehSettings.comfortFeatureFailStatus(this.HEAT_WHEEL))
         {
            this.button.icon.gotoAndStop("off");
            this.button.setHighlight(false);
            this.button.setEnabled(false);
            return;
         }
         this.button.setEnabled(true);
         if(Peripheral.vehSettings.heatedSteeringWheel() == this.VEHICLE_ON)
         {
            this.button.icon.gotoAndStop("on");
            this.button.setHighlight(true);
         }
         else
         {
            this.button.icon.gotoAndStop("off");
            this.button.setHighlight(false);
         }
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_HT_WHEEL);
         }
         else
         {
            Text.format(this.button.label,T.STRB_MENU_HEATED_WHEEL);
         }
      }
      
      override public function press() : void
      {
         if(Peripheral.vehSettings.controlFeaturesDisabled == true)
         {
            return;
         }
         if(Peripheral.vehSettings.heatedSteeringWheel() == this.VEHICLE_OFF)
         {
            Peripheral.vehSettings.setHeatedSteeringWheel(this.VEHICLE_ON);
         }
         else if(Peripheral.vehSettings.heatedSteeringWheel() == this.VEHICLE_ON)
         {
            Peripheral.vehSettings.setHeatedSteeringWheel(this.VEHICLE_OFF);
         }
      }
      
      private function onHeatedWheel(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onComfortFeaturesDisable(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onHeatedWheelFailure(e:VehSettingsEvent) : void
      {
         if(!Peripheral.vehSettings.comfortFeatureFailStatus(this.HEAT_WHEEL))
         {
            Peripheral.vehSettings.getHeatedSteeringWheel();
         }
         this.refresh();
      }
   }
}

