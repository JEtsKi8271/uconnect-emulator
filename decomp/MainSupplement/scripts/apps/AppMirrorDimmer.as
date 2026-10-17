package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppMirrorDimmer extends App
   {
      
      public function AppMirrorDimmer()
      {
         super();
         id = ID.MIRROR_DIMMER;
      }
      
      override public function get cp() : IApp
      {
         return new AppMirrorDimmer();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MIRR_DIM);
         }
         return Text.getText(T.STRB_MENU_MIRROR_DIM);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_MirrorDimmer();
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
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.MIRROR_DIMMING,this.onMirrorDimmer,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.MIRROR_DIMMING,this.onMirrorDimmer);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Peripheral.vehSettings.setMirrorDimming(!Peripheral.vehSettings.mirrorDimming);
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_MIRR_DIM);
         }
         else
         {
            Text.format(this.button.label,T.STRB_MENU_MIRROR_DIM);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Peripheral.vehSettings.mirrorDimming);
      }
      
      private function onMirrorDimmer(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
   }
}

