package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppPassHeatedSeat extends App
   {
      
      private const HEAT_SEATS:String = "heatedSeats";
      
      private const FRONT_LEFT:String = "frontLeft";
      
      private const FRONT_RIGHT:String = "frontRight";
      
      private const VEHICLE_HIGH:String = "high";
      
      private const VEHICLE_LOW:String = "low";
      
      private const VEHICLE_OFF:String = "off";
      
      private var vehicleSeat:String = "frontRight";
      
      public function AppPassHeatedSeat()
      {
         super();
         id = ID.PASSHEATEDSEAT;
      }
      
      override public function get cp() : IApp
      {
         return new AppPassHeatedSeat();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_PAS_HEAT);
         }
         return Text.getText(T.STRB_PASS_HEAT);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_HeatedSeat();
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
         this.updateLocale();
      }
      
      override public function addListeners() : void
      {
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEATED_SEAT,this.onHeatedSeat,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEAT_SEAT_FR_FAIL,this.onFRHeatSeatFailure,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.HEATED_SEAT,this.onHeatedSeat);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.HEAT_SEAT_FR_FAIL,this.onFRHeatSeatFailure);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Peripheral.vehSettings.controlFeaturesDisabled == true)
         {
            return;
         }
         if(Peripheral.vehSettings.heatedSeat(this.vehicleSeat) == this.VEHICLE_OFF)
         {
            Peripheral.vehSettings.setHeatedSeat(this.vehicleSeat,this.VEHICLE_HIGH);
         }
         else if(Peripheral.vehSettings.heatedSeat(this.vehicleSeat) == this.VEHICLE_HIGH)
         {
            Peripheral.vehSettings.setHeatedSeat(this.vehicleSeat,this.VEHICLE_LOW);
         }
         else if(Peripheral.vehSettings.heatedSeat(this.vehicleSeat) == this.VEHICLE_LOW)
         {
            Peripheral.vehSettings.setHeatedSeat(this.vehicleSeat,this.VEHICLE_OFF);
         }
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
      }
      
      override public function updateIcon() : void
      {
         this.vehicleSeat = Peripheral.vehConfig.steeringWheelConfig == "2" ? this.FRONT_LEFT : this.FRONT_RIGHT;
         if(Peripheral.vehSettings.controlFeaturesDisabled || Peripheral.vehSettings.comfortFeatureFailStatus(this.HEAT_SEATS,this.FRONT_RIGHT))
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_OFF);
            this.button.setHighlight(false);
            this.button.setEnabled(false);
            return;
         }
         this.button.setEnabled(true);
         if(Peripheral.vehSettings.heatedSeat(this.vehicleSeat) == this.VEHICLE_HIGH)
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_HIGH);
            this.button.setHighlight(true);
         }
         else if(Peripheral.vehSettings.heatedSeat(this.vehicleSeat) == this.VEHICLE_LOW)
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_LOW);
            this.button.setHighlight(true);
         }
         else
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_OFF);
            this.button.setHighlight(false);
         }
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_PAS_HEAT);
         }
         else
         {
            Text.format(this.button.label,T.STRB_PASS_HEAT);
         }
      }
      
      private function onHeatedSeat(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onComfortFeaturesDisable(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onFRHeatSeatFailure(e:VehSettingsEvent) : void
      {
         if(!Peripheral.vehSettings.comfortFeatureFailStatus(this.HEAT_SEATS,this.FRONT_RIGHT))
         {
            Peripheral.vehSettings.getHeatedSeat();
         }
         this.refresh();
      }
   }
}

