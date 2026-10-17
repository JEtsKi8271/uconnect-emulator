package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import locale.T;
   import peripheral.*;
   import skin.Skin;
   import skin.StyleEvent;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsThemeScreen extends ScreenListComponent
   {
      
      private static const THEMES_PATH:String = "/skins/default/themes.xml";
      
      private static var SELEC_TRACK_TERRAIN_ID:uint = 0;
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      private var mVehicleBrand:String = "Default";
      
      private var mXML:XML;
      
      private var mXMLLoader:URLLoader;
      
      public function SettingsThemeScreen()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Skin.style.addEventListener(StyleEvent.THEME_CHANGE,this.onThemeChangeEvent,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,refresh,false,0,true);
         assets.window.addEventListener(GlobalEvent.ITEMDISABLED,this.onDisabledItem,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Skin.style.removeEventListener(StyleEvent.THEME_CHANGE,this.onThemeChangeEvent);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,refresh);
         Peripheral.listController.bookmark = "SettingsThemeScreen";
         assets.window.removeEventListener(GlobalEvent.ITEMDISABLED,this.onDisabledItem);
         super.removeListeners();
      }
      
      override protected function initView() : void
      {
         var brand:String = null;
         if(Boolean(Peripheral.vehConfig.hasSRTPresent) && Peripheral.vehConfig.vehicleLine != "ZD")
         {
            this.mVehicleBrand = "SRT";
         }
         else
         {
            brand = Peripheral.vehConfig.vehicleBrand;
            switch(brand)
            {
               case "2":
                  if(Peripheral.vehConfig.vehicleLine == "ZD")
                  {
                     this.mVehicleBrand = "Viper";
                  }
                  else
                  {
                     this.mVehicleBrand = "Dodge";
                  }
                  break;
               case "3":
                  this.mVehicleBrand = "Jeep";
                  break;
               case "1":
                  this.mVehicleBrand = "Chrysler";
                  break;
               case "12":
                  this.mVehicleBrand = "Ram";
                  break;
               case "9":
                  this.mVehicleBrand = "Fiat";
                  break;
               case "11":
                  this.mVehicleBrand = "Maserati";
                  break;
               case "8":
                  this.mVehicleBrand = "AlfaRomeo";
                  break;
               case "10":
                  this.mVehicleBrand = "Lancia";
                  break;
               default:
                  this.mVehicleBrand = "Default";
            }
         }
         this.mXMLLoader = new URLLoader(new URLRequest(THEMES_PATH));
         this.mXMLLoader.addEventListener(Event.COMPLETE,this.onComplete);
         this.mXMLLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         super.initView();
      }
      
      private function onThemeChangeEvent(e:StyleEvent) : void
      {
         refresh();
      }
      
      private function onComplete(e:Event) : void
      {
         var mList:XMLList = null;
         var theme:XML = null;
         this.mXMLLoader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.mXML = new XML(this.mXMLLoader.data);
         mList = this.mXML.brand.(@id == (Peripheral.vehConfig.vehicleLine == "RU" ? "RU" : mVehicleBrand));
         for each(theme in mList.theme)
         {
            contents.push({
               "label":theme.@id,
               "path":theme.@path
            });
         }
         this.populate();
      }
      
      protected function onIOError(event:IOErrorEvent) : void
      {
         this.mXMLLoader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mXMLLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.mXMLLoader = null;
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsThemeScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_DISPLAY_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_DISPLAY));
         pushBreadcrumb(new Breadcrumb(T.STRB_SET_THEME,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         t(assets.total,Format.itemsInList(contents.length));
      }
      
      override public function set index(index:int) : void
      {
         var item:MovieClip = null;
         for(var i:int = 0; i < LENGTH; i++)
         {
            item = assets.window["item" + i + "_button"];
            if(contents.length > index + i)
            {
               configure(item,TYPE_CHECK1);
               item.id = index + i;
               label(item.label,contents[item.id].label);
               if(item.label.text == Peripheral.localeEngine.getText(SELEC_TRACK_TERRAIN_ID))
               {
                  item.checkbox0.setHighlight(Peripheral.vehicleStatus.SelecTerrainModeStatus);
               }
               else
               {
                  item.checkbox0.setHighlight(!Peripheral.vehicleStatus.SelecTerrainModeStatus && this.mVehicleBrand + "/" + contents[item.id].path == Framework.themeEngine.theme);
               }
            }
            else
            {
               configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         var theme:String = "";
         if(Peripheral.vehicleStatus.ThemeFileOverride != "on")
         {
            Peripheral.vehicleStatus.toggleThemeFileOverride();
         }
         if(contents[e.data.id].label == Peripheral.localeEngine.getText(SELEC_TRACK_TERRAIN_ID))
         {
            Peripheral.vehicleStatus.setSelecTerrainModeStatus(true);
            Peripheral.vehicleStatus.setSelecTerrainModePrevTheme(Framework.themeEngine.theme);
            theme = this.mVehicleBrand + "/TerrainThemes/";
            switch(Peripheral.driveMode.TerrainThemeStatus)
            {
               case "Track":
                  theme += "track.swf";
                  break;
               case "Rock":
                  theme += "rock.swf";
                  break;
               case "Tow":
                  theme += "tow.swf";
                  break;
               case "Snow":
                  theme += "snow.swf";
                  break;
               case "Normal":
                  theme += "normal.swf";
                  break;
               case "Ice":
                  theme += "ice.swf";
                  break;
               case "All Road":
                  theme += "allroads.swf";
                  break;
               case "Sport":
                  theme += "sport.swf";
                  break;
               case "MudSand":
                  theme += "mudsand.swf";
                  break;
               case "Sand":
                  theme += "sand.swf";
                  break;
               case "Mud":
                  theme += "mud.swf";
                  break;
               case "Auto":
               default:
                  theme = Peripheral.vehicleStatus.selecTerrainModePrevTheme;
            }
         }
         else
         {
            if(Peripheral.vehicleStatus.SelecTerrainModeStatus)
            {
               Peripheral.vehicleStatus.setSelecTerrainModeStatus(false);
            }
            theme = this.mVehicleBrand + "/" + contents[e.data.id].path;
         }
         Framework.themeEngine.theme = theme;
         Peripheral.vehicleStatus.setThemeTo(theme);
      }
      
      protected function onDisabledItem(e:GlobalEvent) : void
      {
      }
      
      private function get itemEnablePermitted() : Boolean
      {
         return !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed" || Peripheral.antiTheft.ignitionState == "accessory");
      }
   }
}

