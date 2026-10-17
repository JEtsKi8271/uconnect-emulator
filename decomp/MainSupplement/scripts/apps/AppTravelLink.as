package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   
   public class AppTravelLink extends App
   {
      
      public function AppTravelLink()
      {
         super();
         id = ID.TRAVELLINK;
      }
      
      override public function get cp() : IApp
      {
         return new AppTravelLink();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_TRVL_LNK);
         }
         return Text.getText(T.STRB_TRAVEL_LINK_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_TravelLink();
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
         Framework.structure.goto(Screens.MAIN_TRAVELLINK);
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.button.setHighlight(Framework.mapping.getDomain(Framework.mapping.getAddress(Framework.structure.currentBranch)) == Screens.DOMAIN_TRAVELLINK);
      }
      
      override public function updateIcon() : void
      {
         this.button.icon.gotoAndStop("on");
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_TRVL_LNK);
         }
         else
         {
            Text.format(this.button.label,T.STRB_TRAVEL_LINK_ML);
         }
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.refresh();
      }
   }
}

