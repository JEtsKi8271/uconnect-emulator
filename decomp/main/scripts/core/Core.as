package core
{
   import com.nfuzion.framework.global.Framework;
   import core.api.AutoAssigner;
   import core.api.FocusManager;
   import core.api.Keyboards;
   import core.api.Messenger;
   import core.api.PopupManager;
   import core.api.ScreenModel;
   import core.api.Structure;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Core extends Sprite
   {
      
      public function Core(resolution:String)
      {
         super();
         Framework.keyboards = new Keyboards();
         Framework.resolution = resolution;
         Framework.focusManager = new FocusManager();
         Framework.screens = new ScreenModel(this);
         Framework.structure = new Structure();
         Framework.popupManager = new PopupManager();
         Framework.messenger = new Messenger();
         Framework.autoAssigner = new AutoAssigner();
      }
      
      protected function startFramework() : void
      {
         this.checkThemingEngine();
      }
      
      private function checkThemingEngine(e:Event = null) : void
      {
         if(Framework.themeEngine)
         {
            if(Framework.themeEngine.ready)
            {
               Framework.themeEngine.removeEventListener(Event.COMPLETE,this.checkThemingEngine);
               this.frameworkStarted();
            }
            else
            {
               Framework.themeEngine.addEventListener(Event.COMPLETE,this.checkThemingEngine);
            }
         }
         else
         {
            trace("<HMICore> [ERROR] No ThemeEngine!");
         }
      }
      
      protected function frameworkStarted() : void
      {
         Framework.focusManager.init(this);
      }
   }
}

