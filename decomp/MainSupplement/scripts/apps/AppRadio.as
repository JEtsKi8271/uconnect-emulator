package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppRadio extends App
   {
      
      public function AppRadio()
      {
         super();
         id = ID.RADIO;
      }
      
      override public function get cp() : IApp
      {
         return new AppRadio();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_RADIO);
         }
         return Text.getText(T.STRB_RADIO_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Radio();
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
         Peripheral.audioManager.setSource(Peripheral.audioManager.lastRadioSource);
         switch(Peripheral.audioManager.lastRadioSource)
         {
            case Peripheral.audioManager.SOURCE_SAT:
               Framework.structure.goto(Screens.MAIN_SAT);
               break;
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_FM:
            case Peripheral.audioManager.SOURCE_MW:
               if(Global.market == TunerRegion.NORTH_AMERICA)
               {
                  Framework.structure.goto(Screens.MAIN_FM,{
                     "source":Peripheral.audioManager.lastRadioSource,
                     "_back":false
                  });
               }
               else
               {
                  Framework.structure.goto(Screens.MAIN_RADIO);
               }
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               Framework.structure.goto(Screens.MAIN_RADIO);
               break;
            case Peripheral.audioManager.SOURCE_DMB:
               Framework.structure.goto(Screens.MAIN_DMB);
               break;
            case Peripheral.audioManager.SOURCE_AHA:
               Framework.structure.goto(Screens.AHA_HOME);
         }
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_MENU_RADIO);
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_TUNER);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
   }
}

