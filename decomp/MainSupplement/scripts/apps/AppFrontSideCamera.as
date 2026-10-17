package apps
{
   import com.harman.moduleLinkAPI.RseEvent;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppFrontSideCamera extends App
   {
      
      private var assets:C_Button_FrontSideCamera = new C_Button_FrontSideCamera();
      
      public function AppFrontSideCamera()
      {
         super();
         id = ID.FRONTSIDECAMERA;
      }
      
      override public function get cp() : IApp
      {
         return new AppFrontSideCamera();
      }
      
      override public function get label() : String
      {
         return Peripheral.localeEngine.getText(T.STRB_CAMERA);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_FrontSideCamera();
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
         Peripheral.rse.addEventListener(RseEvent.CAM_AVAILABILITY,this.onCamAvailability,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.rse.removeEventListener(RseEvent.CAM_AVAILABILITY,this.onCamAvailability);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Peripheral.rse.startRdc2Video("dtvCamera");
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_CAMERA);
      }
      
      override public function updateHighlight() : void
      {
         this.button.setEnabled(Peripheral.rse.frontSideCameraAvailable);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
      
      private function onCamAvailability(e:RseEvent) : void
      {
         this.refresh();
      }
   }
}

