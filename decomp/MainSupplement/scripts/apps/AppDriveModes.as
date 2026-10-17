package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppDriveModes extends App
   {
      
      private const STATE_ON:String = "On";
      
      private const STATE_OFF:String = "Off";
      
      public function AppDriveModes()
      {
         super();
         id = ID.DRIVEMODES;
      }
      
      override public function get cp() : IApp
      {
         return new AppDriveModes();
      }
      
      override public function get label() : String
      {
         if(Peripheral.vehConfig.hasSRTPresent)
         {
            if(favorite)
            {
               return Text.getText(T.STRB_DRV_MODE);
            }
            return Text.getText(T.STRB_DRIVE_MODES);
         }
         if(Peripheral.vehConfig.vehicleBrand == "1")
         {
            if(favorite)
            {
               return Text.getText(T.STRB_PRF_CONTROL);
            }
            return Text.getText(T.STRB_PERF_CONTROL_ML);
         }
         if(Peripheral.vehConfig.vehicleBrand == "2")
         {
            if(favorite)
            {
               return Text.getText(T.STRB_PRF_CONTROL);
            }
            return Text.getText(T.STRB_PERF_CONTROL_ML);
         }
         if(favorite)
         {
            return Text.getText(T.STRB_PRF_CONTROL);
         }
         return Text.getText(T.STRB_PERF_CONTROL_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_DriveModes();
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
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Framework.popupManager.exit();
         Peripheral.driveModeManager.enterDriveMode();
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateIcon() : void
      {
         if(Peripheral.vehConfig.hasSRTPresent && Peripheral.vehConfig.hasDriveModePresent)
         {
            this.button.icon.gotoAndStop("SRT" + this.STATE_ON);
         }
         else if(Peripheral.vehConfig.vehicleBrand == "1")
         {
            this.button.icon.gotoAndStop("Chrysler" + this.STATE_ON);
         }
         else if(Peripheral.vehConfig.vehicleBrand == "2")
         {
            this.button.icon.gotoAndStop("Dodge" + this.STATE_ON);
         }
         else
         {
            this.button.icon.gotoAndStop("SRT" + this.STATE_ON);
         }
      }
      
      override public function updateLocale() : void
      {
         if(Peripheral.vehConfig.hasSRTPresent)
         {
            if(favorite)
            {
               Text.format(this.button.label,T.STRB_DRV_MODE);
            }
            else
            {
               Text.format(this.button.label,T.STRB_DRIVE_MODES);
            }
         }
         else if(favorite)
         {
            Text.format(this.button.label,T.STRB_PRF_CONTROL);
         }
         else
         {
            Text.format(this.button.label,T.STRB_PERF_CONTROL_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getDomain(Framework.mapping.getAddress(Framework.structure.currentBranch)) == Screens.DOMAIN_DRIVEMODES);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
   }
}

