package apps
{
   import ancillary.DynamicPopupNames;
   import ancillary.Extensions;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.WiFiServiceEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppWiFiHotspot extends App
   {
      
      public function AppWiFiHotspot()
      {
         super();
         id = ID.WIFIHOTSPOT;
      }
      
      override public function get cp() : IApp
      {
         return new AppWiFiHotspot();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_WIFI_APP);
         }
         return Text.getText(T.STRB_WIFI_HOTSPOT_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_WiFiHotspot();
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
         Peripheral.wifiService.addEventListener(WiFiServiceEvent.WLAN_RF_ACTIVE,this.onWiFiRFActive,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.DRM_VERIFICATION,this.onDRMVerified,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.wifiService.removeEventListener(WiFiServiceEvent.WLAN_RF_ACTIVE,this.onWiFiRFActive);
         Peripheral.appManager.removeEventListener(AppManagerEvent.DRM_VERIFICATION,this.onDRMVerified);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Framework.popupManager.exit();
         if(Peripheral.wifiService.WiFiReady)
         {
            Peripheral.appManager.verifyDRM("WIFIAP",Peripheral.localeEngine.getText(T.STRB_WIFI_HOTSPOT));
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.INFO_WIFI_SERVICE_NOT_AVAILABLE_YET,"popupsearching",{
               "timeout":0,
               "type":PopupType.PRIMARY,
               "title":T.STRB_WIFI_NOT_AVAILABLE,
               "message":T.STRB_WIFI_BEING_STARTED,
               "caption1":T.STRB_OK,
               "caption2":"",
               "showClose":true,
               "showOk":true,
               "showCancel":false,
               "showSearching":false
            });
         }
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateIcon() : void
      {
         this.button.icon.gotoAndStop(Peripheral.wifiService.WiFiActive ? "on" : "off");
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_WIFI_APP);
         }
         else
         {
            Text.format(this.button.label,T.STRB_WIFI_HOTSPOT_ML);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.structure.currentExtension == Extensions.HOTSPOT_SETUP_LIST || Framework.structure.currentExtension == Extensions.HOTSPOT_CONNECTED_DEVICES_LIST);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
      
      private function onWiFiRFActive(e:WiFiServiceEvent) : void
      {
         this.updateIcon();
      }
      
      private function onDRMVerified(e:AppManagerEvent) : void
      {
         if(e.mData.verifyDRM.errorCode == 0)
         {
            Framework.structure.goto(Screens.APPS_LIST,{"ext":Extensions.HOTSPOT_SETUP_LIST});
         }
      }
   }
}

