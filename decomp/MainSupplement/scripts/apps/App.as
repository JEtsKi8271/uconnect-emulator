package apps
{
   import events.VRSessionEvent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import peripheral.Peripheral;
   
   public class App extends MovieClip implements IApp
   {
      
      public var mID:String = "";
      
      public var mButton:MovieClip = null;
      
      private var mVREnabled:Boolean = false;
      
      private var mFavorite:Boolean = false;
      
      public function App()
      {
         super();
      }
      
      public function get cp() : IApp
      {
         return new App();
      }
      
      public function get id() : String
      {
         return this.mID;
      }
      
      public function set id(_id:String) : void
      {
         this.mID = _id;
      }
      
      public function get label() : String
      {
         return "Empty";
      }
      
      public function get button() : MovieClip
      {
         return this.mButton;
      }
      
      public function set button(_button:MovieClip) : void
      {
         this.mButton = _button as MovieClip;
      }
      
      public function get embedded() : Boolean
      {
         return false;
      }
      
      public function addListeners() : void
      {
         Peripheral.vrSession.addEventListener(VRSessionEvent.VR_WAVES_HIDE,this.onVRWavesHide,false,0,true);
         Peripheral.vrSession.addEventListener(VRSessionEvent.VR_WAVES_SHOW,this.onVRWavesShow,false,0,true);
      }
      
      public function removeListeners() : void
      {
         Peripheral.vrSession.removeEventListener(VRSessionEvent.VR_WAVES_HIDE,this.onVRWavesHide);
         Peripheral.vrSession.removeEventListener(VRSessionEvent.VR_WAVES_SHOW,this.onVRWavesShow);
      }
      
      private function onVRWavesHide(e:VRSessionEvent) : void
      {
         this.wave = false;
      }
      
      private function onVRWavesShow(e:VRSessionEvent) : void
      {
         this.wave = true;
      }
      
      public function slay() : void
      {
         this.mButton = null;
      }
      
      public function press() : void
      {
      }
      
      public function refresh() : void
      {
      }
      
      public function updateIcon() : void
      {
      }
      
      public function updateLocale() : void
      {
      }
      
      public function updateHighlight() : void
      {
      }
      
      public function get vr() : Boolean
      {
         return this.mVREnabled;
      }
      
      public function set vr(_vr:Boolean) : void
      {
         this.mVREnabled = _vr;
      }
      
      public function set wave(_visible:Boolean) : void
      {
      }
      
      public function get favorite() : Boolean
      {
         return this.mFavorite;
      }
      
      public function set favorite(_favorite:Boolean) : void
      {
         if(_favorite != this.mFavorite)
         {
            this.mFavorite = _favorite;
            this.updateLocale();
         }
         this.mButton.setFavorite(this.mFavorite);
      }
      
      public function adjustLabel(_textField:TextField) : void
      {
         if(this.mFavorite)
         {
            _textField.height = 30;
            _textField.wordWrap = false;
            _textField.multiline = false;
         }
         else
         {
            _textField.height = 50;
            _textField.wordWrap = true;
            _textField.multiline = true;
         }
         this.updateLocale();
      }
   }
}

