package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   
   public class AppAppManager extends App
   {
      
      public function AppAppManager()
      {
         super();
         id = ID.APPMANAGER;
      }
      
      override public function get cp() : IApp
      {
         return new AppAppManager();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MANAGER);
         }
         return Text.getText(T.STRB_APP_MANAGER);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_AppManager();
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
         Framework.structure.goto(Screens.APP_MANAGER);
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
            Text.format(this.button.label,T.STRB_MANAGER);
         }
         else
         {
            Text.format(this.button.label,T.STRB_APP_MANAGER);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.APP_MANAGER);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
   }
}

