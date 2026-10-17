package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppPassVentedSeat extends App
   {
      
      private const VENT_SEATS:String = "ventedSeats";
      
      private const FRONT_LEFT:String = "frontLeft";
      
      private const FRONT_RIGHT:String = "frontRight";
      
      private const VEHICLE_HIGH:String = "high";
      
      private const VEHICLE_LOW:String = "low";
      
      private const VEHICLE_OFF:String = "off";
      
      private var vehicleSeat:String = "frontRight";
      
      public function AppPassVentedSeat()
      {
         super();
         id = ID.PASSVENTEDSEAT;
      }
      
      override public function get cp() : IApp
      {
         return new AppPassVentedSeat();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_PAS_VENT);
         }
         return Text.getText(T.STRB_PASS_VENT);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_VentedSeat();
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
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.VENTED_SEAT,this.onVentedSeat,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable,false,0,true);
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.VENT_SEAT_FR_FAIL,this.onFRVentSeatFailure,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.VENTED_SEAT,this.onVentedSeat);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.CNTRL_FEATURES_DISABLED,this.onComfortFeaturesDisable);
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.VENT_SEAT_FR_FAIL,this.onFRVentSeatFailure);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Peripheral.vehSettings.controlFeaturesDisabled == true)
         {
            return;
         }
         if(Peripheral.vehSettings.ventedSeat(this.vehicleSeat) == this.VEHICLE_OFF)
         {
            Peripheral.vehSettings.setVentedSeat(this.vehicleSeat,this.VEHICLE_HIGH);
         }
         else if(Peripheral.vehSettings.ventedSeat(this.vehicleSeat) == this.VEHICLE_HIGH)
         {
            Peripheral.vehSettings.setVentedSeat(this.vehicleSeat,this.VEHICLE_LOW);
         }
         else if(Peripheral.vehSettings.ventedSeat(this.vehicleSeat) == this.VEHICLE_LOW)
         {
            Peripheral.vehSettings.setVentedSeat(this.vehicleSeat,this.VEHICLE_OFF);
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
         if(Peripheral.vehSettings.controlFeaturesDisabled || Peripheral.vehSettings.comfortFeatureFailStatus(this.VENT_SEATS,this.FRONT_RIGHT))
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_OFF);
            this.button.setHighlight(false);
            this.button.setEnabled(false);
            return;
         }
         this.button.setEnabled(true);
         if(Peripheral.vehSettings.ventedSeat(this.vehicleSeat) == this.VEHICLE_HIGH)
         {
            this.button.icon.gotoAndStop(this.vehicleSeat + this.VEHICLE_HIGH);
            this.button.setHighlight(true);
         }
         else if(Peripheral.vehSettings.ventedSeat(this.vehicleSeat) == this.VEHICLE_LOW)
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
            Text.format(this.button.label,T.STRB_PAS_VENT);
         }
         else
         {
            Text.format(this.button.label,T.STRB_PASS_VENT);
         }
      }
      
      private function onVentedSeat(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onComfortFeaturesDisable(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onFRVentSeatFailure(e:VehSettingsEvent) : void
      {
         if(!Peripheral.vehSettings.comfortFeatureFailStatus(this.VENT_SEATS,this.FRONT_RIGHT))
         {
            Peripheral.vehSettings.getVentedSeat();
         }
         this.refresh();
      }
   }
}

