package apps
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppCargoCam extends App
   {
      
      private const STATE_ON:String = "on";
      
      private const STATE_OFF:String = "off";
      
      public function AppCargoCam()
      {
         super();
         id = ID.CARGOCAM;
      }
      
      override public function get cp() : IApp
      {
         return new AppCargoCam();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_CRGO_CAM);
         }
         return Text.getText(T.STRB_CARGO_CAM);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_CargoCam();
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
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Peripheral.antiTheft.ignitionState == "on")
         {
            Peripheral.vehSettings.setCargoCamera(this.STATE_ON);
         }
      }
      
      override public function refresh() : void
      {
         mButton.setEnabled(Peripheral.antiTheft.ignitionState == "on");
         this.updateLocale();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_CRGO_CAM);
         }
         else
         {
            Text.format(this.button.label,T.STRB_CARGO_CAM);
         }
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         this.refresh();
      }
   }
}

