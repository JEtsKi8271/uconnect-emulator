package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppHeadrestFold extends App
   {
      
      private var assets:C_Button_HeadrestFold = new C_Button_HeadrestFold();
      
      private const STATE_ON:String = "on";
      
      public function AppHeadrestFold()
      {
         super();
         id = ID.HEADRESTFOLD;
      }
      
      override public function get cp() : IApp
      {
         return new AppHeadrestFold();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_HEADREST);
         }
         return Text.getText(T.STRB_HEADREST_FOLD_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_HeadrestFold();
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
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.HEADREST_DUMP,this.onHeadrestDump,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.HEADREST_DUMP,this.onHeadrestDump);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Peripheral.vehSettings.setHeadrestDump(this.STATE_ON);
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
            Text.format(this.button.label,T.STRB_HEADREST);
         }
         else
         {
            Text.format(this.button.label,T.STRB_HEADREST_FOLD_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Peripheral.vehSettings.headrestDump == this.STATE_ON);
      }
      
      private function onHeadrestDump(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
   }
}

