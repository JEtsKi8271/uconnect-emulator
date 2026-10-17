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
   
   public class AppMedia extends App
   {
      
      private function mainMedia():void
      {
      }
      private function mainMediaReadBackPhrase():void
      {
      }
      private var mReadBackPhraseMap:Object = new Object();
      
      public function AppMedia()
      {
         super();
         id = ID.MEDIA;
         this.mReadBackPhraseMap.Media = new Object();
         this.mReadBackPhraseMap.NonMedia = new Object();
         this.mReadBackPhraseMap.Media[false] = "Media, button selected";
         this.mReadBackPhraseMap.Media[true] = "Media, button selected";
         this.mReadBackPhraseMap.NonMedia[false] = "Media, button";
         this.mReadBackPhraseMap.NonMedia[true] = "Media,button selected";
      }
      
      override public function get cp() : IApp
      {
         return new AppMedia();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_MEDIA);
         }
         return Text.getText(T.STRB_MEDIA_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Media();
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
            this.mainMedia = this.onMedia;
            this.mainMediaReadBackPhrase = this.getReadBackPhrase;
            Peripheral.readBackManager.registerCallBack("media_button",this.mainMedia,this.mainMediaReadBackPhrase);
            Peripheral.readBackManager.videoReadBack();
         }
         else
         {
            Framework.structure.goto(Screens.MAIN_MEDIA);
         }
      }
      
      private function onMedia(e:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.MAIN_MEDIA);
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
            Text.format(this.button.label,T.STRB_MENU_MEDIA);
         }
         else
         {
            Text.format(this.button.label,T.STRB_MEDIA_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_MEDIA);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
      
      private function getReadBackPhrase(_str:String, _press:Boolean) : String
      {
         var mBranch:String = _str == Screens.MAIN_MEDIA ? "Media" : "NonMedia";
         return this.mReadBackPhraseMap[mBranch][_press];
      }
   }
}

