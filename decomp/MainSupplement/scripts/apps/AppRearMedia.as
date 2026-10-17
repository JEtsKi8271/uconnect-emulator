package apps
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import core.enums.Market;
   import core.events.StructureEvent;
   import core.utils.Text;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppRearMedia extends App
   {
      
      private function appRearMedia():void
      {
      }
      private function appRearMediaReadBackPhrase():void
      {
      }
      private var mReadBackPhraseMap:Object = new Object();
      
      public function AppRearMedia()
      {
         super();
         id = ID.REARMEDIA;
         this.mReadBackPhraseMap.RU = new Object();
         this.mReadBackPhraseMap.NRU = new Object();
         this.mReadBackPhraseMap.RU[false] = "Uconnect Theater, button";
         this.mReadBackPhraseMap.RU[true] = "Uconnect Theater, button selected";
         this.mReadBackPhraseMap.NRU[false] = "Rear Seat, button";
         this.mReadBackPhraseMap.NRU[true] = "Rear Seat,button selected";
      }
      
      override public function get cp() : IApp
      {
         return new AppRearMedia();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Peripheral.vehConfig.vehicleLine == "RU" ? Text.getText(T.STRB_MENU_UCONNECT_THEATER) : Text.getText(T.STRB_RSE);
         }
         return Peripheral.vehConfig.vehicleLine == "RU" ? Text.getText(T.STRB_MENU_UCONNECT_THEATER_ML) : Text.getText(T.STRB_REAR_SEAT);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_RearMedia();
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
         if(Peripheral.personalConfig.videoReadBack && Global.market == Market.NORTH_AMERICA)
         {
            this.appRearMedia = this.onRearMedia;
            this.appRearMediaReadBackPhrase = this.getReadBackPhrase;
            Peripheral.readBackManager.registerCallBack("RearMedia",this.appRearMedia,this.appRearMediaReadBackPhrase);
            Peripheral.readBackManager.videoReadBack();
         }
         else
         {
            Framework.structure.goto(Screens.REAR_MEDIA);
         }
      }
      
      private function onRearMedia(e:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.REAR_MEDIA);
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.button.setHighlight(Framework.structure.currentBranch == Screens.REAR_MEDIA);
      }
      
      override public function updateIcon() : void
      {
         this.button.icon.gotoAndStop("on");
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,Peripheral.vehConfig.vehicleLine == "RU" ? T.STRB_MENU_UCONNECT_THEATER : T.STRB_RSE);
         }
         else
         {
            Text.format(this.button.label,Peripheral.vehConfig.vehicleLine == "RU" ? T.STRB_MENU_UCONNECT_THEATER_ML : T.STRB_REAR_SEAT);
         }
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.refresh();
      }
      
      private function getReadBackPhrase(vehLine:String, _press:Boolean) : String
      {
         vehLine = vehLine == "RU" ? "RU" : "NRU";
         return this.mReadBackPhraseMap[vehLine][_press];
      }
   }
}

