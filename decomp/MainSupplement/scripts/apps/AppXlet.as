package apps
{
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.filesystem.File;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppXlet extends App
   {
      
      private const DEFAULT_PATH_ON:String = "./img/default_on.png";
      
      private const DEFAULT_PATH_OFF:String = "./img/default_off.png";
      
      private var mLabel:String = "";
      
      private var mLabelShortRaw:String = "";
      
      private var mLabelShortRawArray:Array = null;
      
      private var mLabelMediumRaw:String = "";
      
      private var mLabelMediumRawArray:Array = null;
      
      private var mPathOn:String = "";
      
      private var mPathOff:String = "";
      
      public function AppXlet()
      {
         super();
      }
      
      override public function get cp() : IApp
      {
         var xlet:AppXlet = new AppXlet();
         xlet.id = mID;
         xlet.label = this.mLabel;
         xlet.labelShort = this.mLabelShortRaw;
         xlet.labelMedium = this.mLabelMediumRaw;
         xlet.refresh();
         return xlet;
      }
      
      override public function get id() : String
      {
         return mID;
      }
      
      override public function set id(_id:String) : void
      {
         mID = _id;
         var mXletsRoot:String = Peripheral.taskBarManager.xletDir != "" ? Peripheral.taskBarManager.xletDir : Peripheral.appManager.getXletsDir();
         this.mPathOn = "file://" + mXletsRoot + "/" + mID + "/data/onIcon.png";
         this.mPathOff = "file://" + mXletsRoot + "/" + mID + "/data/offIcon.png";
         this.mPathOn = File.desktopDirectory.resolvePath(mXletsRoot + "/" + mID + "/data/onIcon.png").exists ? this.mPathOn : this.DEFAULT_PATH_ON;
         this.mPathOff = File.desktopDirectory.resolvePath(mXletsRoot + "/" + mID + "/data/offIcon.png").exists ? this.mPathOff : this.DEFAULT_PATH_OFF;
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            if(this.mLabelShortRawArray[Peripheral.localeEngine.locale.id] != null)
            {
               return this.mLabelShortRawArray[Peripheral.localeEngine.locale.id];
            }
            if(this.mLabelShortRawArray["en_US"] != null)
            {
               return this.mLabelShortRawArray["en_US"];
            }
            if(this.mLabelShortRawArray["es_US"] != null)
            {
               return this.mLabelShortRawArray["es_US"];
            }
            if(this.mLabelShortRawArray["en_GB"] != null)
            {
               return this.mLabelShortRawArray["en_GB"];
            }
            return "<no name>";
         }
         if(this.mLabelMediumRawArray[Peripheral.localeEngine.locale.id] != null)
         {
            return this.mLabelMediumRawArray[Peripheral.localeEngine.locale.id];
         }
         if(this.mLabelMediumRawArray["en_US"] != null)
         {
            return this.mLabelMediumRawArray["en_US"];
         }
         if(this.mLabelMediumRawArray["es_US"] != null)
         {
            return this.mLabelMediumRawArray["es_US"];
         }
         if(this.mLabelMediumRawArray["en_GB"] != null)
         {
            return this.mLabelMediumRawArray["en_GB"];
         }
         return "<no name>";
      }
      
      public function set label(_label:String) : void
      {
         this.labelShort = _label;
      }
      
      public function get labelShort() : String
      {
         return this.mLabelShortRaw;
      }
      
      public function set labelShort(_label:String) : void
      {
         this.mLabelShortRaw = _label;
         this.mLabelShortRawArray = this.parseLanguages(this.mLabelShortRaw);
      }
      
      public function get labelMedium() : String
      {
         return this.mLabelMediumRaw;
      }
      
      public function set labelMedium(_label:String) : void
      {
         this.mLabelMediumRaw = _label;
         this.mLabelMediumRawArray = this.parseLanguages(this.mLabelMediumRaw);
      }
      
      public function parseLanguages(_string:String) : Array
      {
         var _temp1:Array = null;
         var i:int = 0;
         var _temp2:Array = null;
         var _languages:Array = new Array();
         if(_string != null)
         {
            _temp1 = _string.split(",");
            for(i = 0; _temp1.length > i; i++)
            {
               _temp2 = _temp1[i].split(":");
               if(_temp2.length == 2)
               {
                  _languages[_temp2[0]] = _temp2[1];
               }
            }
         }
         return _languages;
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Xlet();
            Peripheral.taskBarManager.xletImage(this.mPathOn,this.button.icon.on_icon);
            Peripheral.taskBarManager.xletImage(this.mPathOff,this.button.icon.off_icon);
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
      
      override public function get embedded() : Boolean
      {
         return true;
      }
      
      override public function addListeners() : void
      {
         this.updateLocale();
         Peripheral.appManager.addEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.appManager.removeEventListener(AppManagerEvent.OPER_STATUS_UPDATE,this.onOperStatusUpdate);
         Peripheral.appManager.removeEventListener(AppManagerEvent.APP_MANAGER_STATUS,this.onAppManagerStatus);
         super.removeListeners();
      }
      
      override public function slay() : void
      {
         this.unloadOnIcon();
         this.unloadOffIcon();
         super.slay();
      }
      
      private function unloadOnIcon() : void
      {
         while(this.button.icon.on_icon.numChildren)
         {
            this.button.icon.on_icon.removeChildAt(0);
         }
      }
      
      private function unloadOffIcon() : void
      {
         while(this.button.icon.off_icon.numChildren)
         {
            this.button.icon.off_icon.removeChildAt(0);
         }
      }
      
      override public function press() : void
      {
         Framework.popupManager.exit();
         Peripheral.appStateManager.startXlet(this.id,false);
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateIcon() : void
      {
         this.button.icon.on_icon.visible = Peripheral.appManager.isAppRunning(this.id);
         this.button.icon.off_icon.visible = !Peripheral.appManager.isAppRunning(this.id);
      }
      
      override public function updateLocale() : void
      {
         if(Peripheral.appManager.status != "Ready")
         {
            Text.format(this.button.label,Peripheral.localeEngine.getText(T.STRB_LOADING_DOTDOTDOT));
         }
         else if(favorite)
         {
            if(this.mLabelShortRawArray[Peripheral.localeEngine.locale.id] != null)
            {
               Text.format(this.button.label,this.mLabelShortRawArray[Peripheral.localeEngine.locale.id]);
            }
            else if(this.mLabelShortRawArray["en_US"] != null)
            {
               Text.format(this.button.label,this.mLabelShortRawArray["en_US"]);
            }
            else if(this.mLabelShortRawArray["es_US"] != null)
            {
               Text.format(this.button.label,this.mLabelShortRawArray["es_US"]);
            }
            else if(this.mLabelShortRawArray["en_GB"] != null)
            {
               Text.format(this.button.label,this.mLabelShortRawArray["en_GB"]);
            }
            else
            {
               Text.format(this.button.label,"<no name>");
            }
         }
         else if(this.mLabelMediumRawArray[Peripheral.localeEngine.locale.id] != null)
         {
            Text.format(this.button.label,this.mLabelMediumRawArray[Peripheral.localeEngine.locale.id]);
         }
         else if(this.mLabelMediumRawArray["en_US"] != null)
         {
            Text.format(this.button.label,this.mLabelMediumRawArray["en_US"]);
         }
         else if(this.mLabelMediumRawArray["es_US"] != null)
         {
            Text.format(this.button.label,this.mLabelMediumRawArray["es_US"]);
         }
         else if(this.mLabelMediumRawArray["en_GB"] != null)
         {
            Text.format(this.button.label,this.mLabelMediumRawArray["en_GB"]);
         }
         else
         {
            Text.format(this.button.label,"<no name>");
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.APPS_ACTIVE && Peripheral.appManager.isAppInFocus(this.id));
      }
      
      private function onOperStatusUpdate(e:AppManagerEvent) : void
      {
         this.refresh();
      }
      
      private function onAppManagerStatus(e:AppManagerEvent) : void
      {
         this.refresh();
      }
   }
}

