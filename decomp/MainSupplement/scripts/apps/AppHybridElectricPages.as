package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   
   public class AppHybridElectricPages extends App
   {
      
      public function AppHybridElectricPages()
      {
         super();
         id = ID.HYBRIDELECTRICPAGES;
      }
      
      override public function get cp() : IApp
      {
         return new AppHybridElectricPages();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_HYBRID_ELECTRIC);
         }
         return Text.getText(T.STRB_MENU_HYBRID_ELECTRIC_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_HybridElectricPages();
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
         Framework.structure.goto(Screens.HYBRID_ELECTRIC_PAGES);
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateIcon() : void
      {
         this.button.icon.gotoAndStop(this.isHybridPage ? 2 : 1);
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_MENU_HYBRID_ELECTRIC);
         }
         else
         {
            Text.format(this.button.label,T.STRB_MENU_HYBRID_ELECTRIC_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(this.isHybridPage);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateIcon();
         this.updateHighlight();
      }
      
      private function get isHybridPage() : Boolean
      {
         return Framework.structure.currentBranch == Screens.HYBRID_ELECTRIC_PAGES || Framework.structure.currentBranch == Screens.HYBRID_ELECTRIC_PAGES_SCHEDULE_TIME;
      }
   }
}

