package apps
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppSettings extends App
   {
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      public function AppSettings()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
         id = ID.SETTINGS;
      }
      
      override public function get cp() : IApp
      {
         return new AppSettings();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_SETTINGS_APP);
         }
         return Text.getText(T.STRB_SETTINGS_APP_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Settings();
            this.button.alwaysClick = true;
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
         mButton.wave.visible = _visible && favorite;
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onIgnitionState,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_UNLOCKED,this.onUnlocked,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onIgnitionState);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_STATE_UNLOCKED,this.onUnlocked);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(!this.button.mEnabled)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PERSONALIZATION_LOCKOUT);
            return;
         }
         Framework.popupManager.exit();
         Framework.structure.goto(Screens.SETTINGS_SCREEN);
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.button.setEnabled(Peripheral.antiTheft.antiTheftState == "unlocked" && Peripheral.antiTheft.ignitionState != "accessory" && !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed"));
         this.button.setHighlight(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_SETTINGS);
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_SETTINGS_APP);
         }
         else
         {
            Text.format(this.button.label,T.STRB_SETTINGS_APP_ML);
         }
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.refresh();
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         this.refresh();
      }
      
      private function onUnlocked(e:AntiTheftEvent) : void
      {
         this.refresh();
      }
   }
}

