package
{
   import ancillary.Ancillary;
   import ancillary.DefinedDynamicPopups;
   import ancillary.DynamicPopupNames;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import core.events.FrameworkEvent;
   import decorators.ChainDecorator;
   import decorators.ListDecorator;
   import decorators.ScrollerDecorator;
   import flash.display.Sprite;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class MainSupplement extends Sprite
   {
      
      private var mPeripheral:Peripheral;
      
      public function MainSupplement()
      {
         super();
         Ancillary.definedDynamicPopups = new DefinedDynamicPopups();
         this.mPeripheral = new Peripheral();
         NavigationPackage.ancillary = Ancillary;
         NavigationPackage.dynamicPopupNames = DynamicPopupNames;
         NavigationPackage.peripheral = Peripheral;
         NavigationPackage.translations = T;
         this.mPeripheral.addEventListener(FrameworkEvent.READY,this.onPeripheralReady);
         this.mPeripheral.init();
         Ancillary.definedDynamicPopups = new DefinedDynamicPopups();
         Framework.autoAssigner.addDecoratorClass(ChainDecorator);
         Framework.autoAssigner.addDecoratorClass(ListDecorator);
         Framework.autoAssigner.addDecoratorClass(ScrollerDecorator);
      }
      
      private function onPeripheralReady(evt:FrameworkEvent = null) : void
      {
         this.mPeripheral.removeEventListener(FrameworkEvent.READY,this.onPeripheralReady);
         Framework.messenger.send(evt);
         Peripheral.popupService.init();
         Peripheral.mediaBrowser.init();
         Peripheral.appStateManager.init();
         Peripheral.emergencyCallState.init();
         Peripheral.inspectionMgr.init();
         Peripheral.songTagging.init();
      }
   }
}

