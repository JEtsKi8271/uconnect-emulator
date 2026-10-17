package apps
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppSurroundView extends App
   {
      
      private const STATE_ON:String = "on";
      
      private const STATE_OFF:String = "off";
      
      public function AppSurroundView()
      {
         super();
         id = ID.SURROUNDVIEW;
      }
      
      override public function get cp() : IApp
      {
         return new AppSurroundView();
      }
      
      override public function get id() : String
      {
         return ID.SURROUNDVIEW;
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_SUR_CAM);
         }
         return Text.getText(T.STRB_SURROUND_CAMERA);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_SurroundView();
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
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SVC_SPEED_LOCKOUT_STATUS,this.onSurrCameraSpdLockout,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SVC_SPEED_LOCKOUT_STATUS,this.onSurrCameraSpdLockout);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(!Peripheral.vehicleStatus.SVCSpeedLockoutStatus && Peripheral.antiTheft.ignitionState != "accessory")
         {
            Peripheral.vehSettings.setSurroundCamera(this.STATE_ON);
         }
      }
      
      override public function refresh() : void
      {
         mButton.setEnabled(!Peripheral.vehicleStatus.SVCSpeedLockoutStatus && Peripheral.antiTheft.ignitionState != "accessory");
         this.updateLocale();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_SUR_CAM);
         }
         else
         {
            Text.format(this.button.label,T.STRB_SURROUND_CAMERA);
         }
      }
      
      private function onSurrCameraSpdLockout(e:VehicleStatusEvent) : void
      {
         this.refresh();
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         this.refresh();
      }
   }
}

