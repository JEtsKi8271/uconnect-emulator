package apps
{
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.CVPDemoEvent;
   import com.harman.moduleLinkAPI.VersionInfoEvent;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppApps extends App
   {
      
      public function AppApps()
      {
         super();
         id = ID.APPS;
      }
      
      override public function get cp() : IApp
      {
         return new AppApps();
      }
      
      override public function get label() : String
      {
         return Text.getText(T.STRB_TASKBAR_APPS);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Apps();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
         mButton.wave.visible = _visible && vr && favorite;
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.NETWORK,this.onEmbeddedCellNetwork,false,0,true);
         Peripheral.cvpdemo.addEventListener(CVPDemoEvent.SIGNAL_QUALITY,this.onEmbeddedCellSignalStrength,false,0,true);
         Peripheral.versionInfo.addEventListener(VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.NETWORK,this.onEmbeddedCellNetwork);
         Peripheral.cvpdemo.removeEventListener(CVPDemoEvent.SIGNAL_QUALITY,this.onEmbeddedCellSignalStrength);
         Peripheral.versionInfo.removeEventListener(VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Framework.popupManager.exit();
         Framework.structure.goto(Screens.APPS_HOME);
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateEmbeddedCell();
         this.updateNetwork();
         this.updateSignalStrength();
         if(Global.brandId == 99)
         {
            this.button.icon.gotoAndStop(4);
         }
         else
         {
            this.button.icon.gotoAndStop(1);
         }
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_TASKBAR_APPS);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.button.setHighlight(Framework.structure.currentBranch == Screens.APPS_HOME);
      }
      
      private function onProductIDUpdate(e:VersionInfoEvent) : void
      {
         this.updateEmbeddedCell();
      }
      
      private function onEmbeddedCellNetwork(e:CVPDemoEvent) : void
      {
         this.updateNetwork();
      }
      
      private function onEmbeddedCellSignalStrength(e:CVPDemoEvent) : void
      {
         this.updateSignalStrength();
      }
      
      private function updateEmbeddedCell() : void
      {
         this.button.network.visible = Peripheral.versionInfo.productVariantID.VARIANT_ECELL == "YES";
         this.button.signal.visible = Peripheral.versionInfo.productVariantID.VARIANT_ECELL == "YES";
      }
      
      private function updateNetwork() : void
      {
         switch(Peripheral.cvpdemo.network)
         {
            case "3G":
               this.button.network.gotoAndStop(3);
               break;
            case "1x":
               this.button.network.gotoAndStop(2);
               break;
            default:
               this.button.network.gotoAndStop(1);
         }
      }
      
      private function updateSignalStrength() : void
      {
         switch(Peripheral.cvpdemo.signalQuality)
         {
            case 0:
               this.button.signal.gotoAndStop(4);
               break;
            case 1:
            case 2:
               this.button.signal.gotoAndStop(1);
               break;
            case 3:
            case 4:
               this.button.signal.gotoAndStop(2);
               break;
            case 5:
            case 6:
               this.button.signal.gotoAndStop(3);
               break;
            default:
               this.button.signal.gotoAndStop(4);
         }
      }
   }
}

