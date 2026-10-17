package
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import ancillary.SpeedLockout;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLinkAPI.MarketConverter;
   import core.Core;
   import core.enums.Market;
   import core.enums.PopupType;
   import core.events.FrameworkEvent;
   import core.flash.Swf;
   import core.locale.LocaleArchive;
   import core.locale.LocaleResolverSWF;
   import core.theme.ThemeEngine;
   import decorators.*;
   import events.StartupEvent;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   [SWF(width="640", height="480", backgroundColor="#000000", frameRate="24")]
   public class Main extends Core
   {
      
      private var CONFIG_FILE_NAME:String = "hmiVars";
      
      private const FRAM_SYSTEM_FILE_NAME:String = "/dev/fram/system";
      
      private var connection:Connection;
      
      public function Main()
      {
         var _font:String;
         var iowWindowClass:Object = null;
         var iow:Object = null;
         Framework.echo("HMI START");
         this.connection = Connection.share();
         try
         {
            iowWindowClass = getDefinitionByName("qnx.display.IowWindow");
            iow = iowWindowClass.getAirWindow();
            iow.id = "hmi";
         }
         catch(e:Error)
         {
         }
         stage.stageFocusRect = false;
         stage.quality = StageQuality.HIGH;
         super((640).toString() + "x" + (480).toString());
         this.readHMIVars();
         this.readFramSystem();
         Framework.focusManager.enabled = Global.brandId == 11;
         Global.taskBarEnabled = true;
         Framework.autoAssigner.addDecoratorClass(ButtonDecorator);
         Framework.autoAssigner.addDecoratorClass(GroupDecorator);
         Framework.autoAssigner.addDecoratorClass(SimpleDecorator);
         Framework.mapping = new Screens();
         Framework.themeEngine = new ThemeEngine();
         _font = "";
         if(Global.region == Market.CHINA)
         {
            _font = "fontSwfs/MHeiM.swf";
         }
         else if(Global.region == Market.JAPAN)
         {
            _font = "fontSwfs/Helvetica55JKforChrysler.swf";
         }
         else if(Global.region == Market.KOREA)
         {
            _font = "fontSwfs/Helvetica55SCKforChrysler.swf";
         }
         else
         {
            _font = "fontSwfs/HelveticaNeueLTStd-Roman.swf";
         }
         Framework.themeEngine.init(Global.skinName,Global.themeUrl,_font);
         Framework.screens.skinName = Global.skinName;
         super.startFramework();
         Global.stage = this.root;
         LocaleArchive.create(new LocaleResolverSWF());
         LocaleArchive.getInstance().setLanguage(Global.languageId,Global.languageId);
      }
      
      private function readHMIVars() : void
      {
         var HARMAN_DEMO:File;
         var NAVIGATION_ACTIVATED:uint = 0;
         var byteArray:ByteArray = new ByteArray();
         var file:File = File.applicationDirectory.resolvePath(this.CONFIG_FILE_NAME);
         var fileStream:FileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.READ);
            fileStream.readBytes(byteArray,0,fileStream.bytesAvailable - 1);
            Global.languageId = int(byteArray.readUnsignedByte());
            Global.themeUrl = byteArray.readUTFBytes(50);
            Global.skinName = byteArray.readUTFBytes(20);
            Global.lastBranch = byteArray.readUTFBytes(40);
            Global.brandId = byteArray.readUnsignedByte();
            switch(byteArray.readUnsignedByte())
            {
               case 0:
                  Global.region = Market.EUROPE;
                  break;
               case 7:
                  Global.region = Market.ROW;
                  break;
               case 2:
                  Global.region = Market.JAPAN;
                  break;
               case 10:
                  Global.region = Market.KOREA;
                  break;
               case 11:
                  Global.region = Market.CHINA;
                  break;
               case 1:
               default:
                  Global.region = Market.NORTH_AMERICA;
            }
            NAVIGATION_ACTIVATED = byteArray.readUnsignedByte();
            Global.navActivated = NAVIGATION_ACTIVATED == 1 ? true : false;
            Global.antiTheftState = byteArray.readUTFBytes(10);
            Global.driverConfiguration = byteArray.readUnsignedByte();
            Global.comfortConfiguration = byteArray.readUnsignedByte();
            Global.SRTpackagePrsnt = byteArray.readUnsignedByte() & 1 ? true : false;
            Global.destinationCode = byteArray.readUnsignedByte();
            Global.speedlockout = SpeedLockout.getLockout(Global.destinationCode);
            Global.market = MarketConverter.getMarketFromDestCode(Global.destinationCode);
            Global.region = Global.market;
         }
         catch(e:Error)
         {
            Global.brandId = 0;
            Global.themeUrl = "Default/001_Uconnect.swf";
            Global.skinName = "default";
            Global.region = Market.NORTH_AMERICA;
            if(Global.region == Market.NORTH_AMERICA)
            {
               Global.lastBranch = new String("fmhomescreen");
            }
            else
            {
               Global.lastBranch = new String("radiohomescreen");
            }
            Global.market = Global.region;
            Global.languageId = 3;
            Global.navActivated = false;
            Global.antiTheftState = "locked";
            Global.comfortConfiguration = 7;
            Global.driverConfiguration = 1;
            Global.SRTpackagePrsnt = false;
            Framework.Trace("*****************************************************************");
            Framework.Trace("******************** ERROR HMI VARS NOT READ ********************");
            Framework.Trace("language :  " + Global.languageId);
            Framework.Trace("theme : " + Global.themeUrl);
            Framework.Trace("skin : " + Global.skinName);
            Framework.Trace("last_screen : " + Global.lastBranch);
            Framework.Trace("brand : " + Global.brandId);
            Framework.Trace("region_code : " + Global.region);
            Framework.Trace("navigation_activated : " + Global.navActivated);
            Framework.Trace("antiTheftState : " + Global.antiTheftState);
            Framework.Trace("driverConfig : " + Global.driverConfiguration);
            Framework.Trace("comfortConfig : " + Global.comfortConfiguration);
            Framework.Trace("SRTpackagePrsnt : " + Global.SRTpackagePrsnt);
            Framework.Trace("destinationCode : " + Global.destinationCode);
            Framework.Trace("*****************************************************************");
            Framework.Trace("*****************************************************************");
         }
         HARMAN_DEMO = new File("/fs/mmc0/HARMAN_DEMO");
         if(HARMAN_DEMO.exists)
         {
            Global.themeUrl = "Default/999_HARMAN.swf";
            Global.brandId = 99;
         }
         fileStream.close();
         if(Global.brandId < 0 || Global.brandId > 14 && Global.brandId != 99)
         {
            Global.brandId = 0;
         }
         switch(Global.themeUrl.substr(0,4))
         {
            case "Abar":
            case "Alfa":
            case "Chry":
            case "Defa":
            case "Dodg":
            case "Ferr":
            case "Fiat":
            case "Jeep":
            case "Lanc":
            case "Mase":
            case "Ram/":
            case "SRT/":
            case "Vipe":
               break;
            default:
               Global.themeUrl = "Default/001_Uconnect.swf";
         }
         if(Global.skinName != "default")
         {
            Global.skinName = "default";
         }
         if(Global.languageId < 2 || Global.languageId > 20)
         {
            Global.languageId = 3;
         }
      }
      
      private function readFramSystem() : void
      {
         var byteArray:ByteArray = new ByteArray();
         var file:File = File.desktopDirectory.resolvePath(this.FRAM_SYSTEM_FILE_NAME);
         var fileStream:FileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.READ);
            Framework.Trace("file open with " + fileStream.bytesAvailable + " bytes availble");
            fileStream.readBytes(byteArray,0,fileStream.bytesAvailable - 1);
            Global.ignitionCount = byteArray.readUnsignedInt();
            Global.resetCount = byteArray.readUnsignedByte();
            Global.serviceKeyCount = byteArray.readUnsignedByte();
            Global.mmcErrorCount = byteArray.readUnsignedByte();
            Global.boloCount = byteArray.readUnsignedByte();
            switch(byteArray.readUnsignedByte())
            {
               case 1:
                  Global.lastAwakeMode = "standby";
                  break;
               case 2:
                  Global.lastAwakeMode = "timed";
                  break;
               case 3:
                  Global.lastAwakeMode = "idle";
                  break;
               case 4:
                  Global.lastAwakeMode = "full_operation";
                  break;
               default:
               case 0:
                  Global.lastAwakeMode = "undefined";
            }
            switch(byteArray.readUnsignedByte())
            {
               case 1:
                  Global.autoOnFeature = "active";
                  break;
               case 2:
                  Global.autoOnFeature = "not_active";
                  break;
               default:
               case 3:
                  Global.autoOnFeature = "recall_last";
            }
            Framework.Trace("*****************************************************************");
            Framework.Trace("************** FRAM System VARS READ SUCCESSFULLY ***************");
         }
         catch(e:Error)
         {
            Global.ignitionCount = 0;
            Global.resetCount = 0;
            Global.serviceKeyCount = 0;
            Global.mmcErrorCount = 0;
            Global.lastAwakeMode = "undefined";
            Framework.Trace("*****************************************************************");
            Framework.Trace("*************** ERROR FRAM System VARS NOT READ *****************");
         }
         fileStream.close();
         Framework.Trace("ignition_count : " + Global.ignitionCount);
         Framework.Trace("reset_count : " + Global.resetCount);
         Framework.Trace("svc_key_count : " + Global.serviceKeyCount);
         Framework.Trace("mmcerr_count : " + Global.mmcErrorCount);
         Framework.Trace("last_awake_mode : " + Global.lastAwakeMode);
         Framework.Trace("*****************************************************************");
         Framework.Trace("*****************************************************************");
      }
      
      override protected function frameworkStarted() : void
      {
         super.frameworkStarted();
         Framework.screens.addEventListener(FrameworkEvent.IDLE,this.onDisclaimerLoaded);
         Framework.popupManager.show(DynamicPopupNames.GLOBAL_DISCLAIMER,Screens.GLOBAL_DISCLAIMER,{"type":PopupType.DISCLAIMER});
      }
      
      private function onDisclaimerLoaded(e:FrameworkEvent) : void
      {
         Framework.screens.removeEventListener(FrameworkEvent.IDLE,this.onDisclaimerLoaded);
         Framework.messenger.addEventListener(StartupEvent.UNLOCK,this.onUnlock);
         var swf:Swf = new Swf("MainSupplement.swf",true);
         swf.addEventListener(Event.COMPLETE,this.onMainSupplementLoaded);
      }
      
      private function onMainSupplementLoaded(e:Event) : void
      {
         var swf:Swf = e.target as Swf;
         swf.removeEventListener(Event.COMPLETE,this.onMainSupplementLoaded);
      }
      
      private function onUnlock(e:StartupEvent) : void
      {
         Framework.messenger.removeEventListener(StartupEvent.UNLOCK,this.onUnlock);
         Framework.screens.addEventListener(FrameworkEvent.IDLE,this.onInitialLayersLoaded);
      }
      
      private function onInitialLayersLoaded(e:FrameworkEvent) : void
      {
         var STARTUP_FILE:String;
         var myfile:File;
         var myFileStream:FileStream;
         Framework.screens.removeEventListener(FrameworkEvent.IDLE,this.onInitialLayersLoaded);
         Global.showAccept = true;
         STARTUP_FILE = "accept.txt";
         myfile = File.applicationStorageDirectory.resolvePath(STARTUP_FILE);
         myFileStream = new FileStream();
         try
         {
            myFileStream.open(myfile,FileMode.WRITE);
         }
         catch(e:Error)
         {
         }
         Framework.messenger.dispatchEvent(new StartupEvent(StartupEvent.READY));
      }
   }
}

