package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVersionInfo;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.harman.moduleLinkAPI.ServiceEvent;
   import com.harman.moduleLinkAPI.VersionInfoEvent;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VersionInfo extends Module implements IVersionInfo
   {
      
      private static var instance:VersionInfo;
      
      private static const mDiagservDbusIdentifier:String = "diagserv";
      
      private static const mPlatformDbusIdentifier:String = "platform";
      
      private static const dBusServiceAvailable:String = "dBusServiceAvailable";
      
      private var mPlatformServiceAvailable:Boolean = false;
      
      private var m_Ready:Boolean = false;
      
      private var m_appVersion:String;
      
      private var m_eqVersion:String;
      
      private var m_navVersion:String;
      
      private var m_v850AppVersion:String;
      
      private var m_v850BootVersion:String;
      
      private var m_translationVersion:String;
      
      private var m_partNumber:String;
      
      private var m_serialNumber:String;
      
      private var m_ProductVariantID:ProductVariantID;
      
      private var mServiceMenu:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function VersionInfo()
      {
         super();
         this.m_appVersion = "";
         this.m_eqVersion = "";
         this.m_navVersion = "";
         this.m_v850AppVersion = "";
         this.m_v850BootVersion = "";
         this.m_partNumber = "";
         this.m_serialNumber = "";
         this.m_translationVersion = "";
         this.m_ProductVariantID = new ProductVariantID();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.PLATFORM,this.platformMessageHandler);
      }
      
      public static function getInstance() : VersionInfo
      {
         if(instance == null)
         {
            instance = new VersionInfo();
         }
         return instance;
      }
      
      public function get appVersion() : String
      {
         return this.m_appVersion;
      }
      
      public function get eqVersion() : String
      {
         return this.m_eqVersion;
      }
      
      public function get navVersion() : String
      {
         return this.m_navVersion;
      }
      
      public function get v850AppVersion() : String
      {
         return this.m_v850AppVersion;
      }
      
      public function get v850BootVersion() : String
      {
         return this.m_v850BootVersion;
      }
      
      public function get partNumber() : String
      {
         return this.m_partNumber;
      }
      
      public function get serialNumber() : String
      {
         return this.m_serialNumber;
      }
      
      public function get productVariantID() : ProductVariantID
      {
         return this.m_ProductVariantID;
      }
      
      public function get serviceMenu() : Boolean
      {
         return this.mServiceMenu;
      }
      
      public function get translationVersion() : String
      {
         return this.m_translationVersion;
      }
      
      public function requestVersionInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_all_versions\": {}}}");
      }
      
      public function setDisplayStatus(displayStatus:Boolean) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDiagservDbusIdentifier + "\", \"packet\": { \"setDisplayStatus\": { \"value\":" + displayStatus + "}}}");
      }
      
      public function requestPartNumber() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_partnumber\": {}}}");
      }
      
      public function requestEQVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_eq_version\": {}}}");
      }
      
      public function requestSerialNumber() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_serialnumber\": {}}}");
      }
      
      public function requestTranslationVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_translation_version\": {}}}");
      }
      
      public function requestProductVariantID() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_variantinfo\": { }}} ");
      }
      
      public function requestServiceFlags() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"get_service_flags\": {}}}");
      }
      
      public function doFactoryReset() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"do_factory_reset\": {}}}");
      }
      
      public function doTouchScreenCalibrate() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"calibrate_touchscreen\": {}}}");
      }
      
      public function restoreDefaultSettings() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"clearCustRadioSettings\": {}}}");
      }
      
      public function clearPersonalData() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"clearPersonalData\": {}}}");
      }
      
      public function startTestColorPattern() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"testColourPattern\": {}}}");
      }
      
      public function setLoggingFlag(flag:String, enable:Boolean) : void
      {
         var status:int = enable ? 1 : 0;
         this.client.send("{\"Type\":\"Command\",\"Dest\":\"" + mPlatformDbusIdentifier + "\", \"packet\": { \"flagsToTouchInEnggMenu\": {" + "\"flagname\": \"" + flag + "\", \"flagStatus\": " + status + "}}}");
      }
      
      public function platformMessageHandler(e:ConnectionEvent) : void
      {
         var info:Object = e.data;
         if(info.hasOwnProperty(dBusServiceAvailable))
         {
            if(info[dBusServiceAvailable] == "true" && this.mPlatformServiceAvailable == false)
            {
               this.mPlatformServiceAvailable = true;
               this.requestProductVariantID();
            }
            else if(info[dBusServiceAvailable] == "false")
            {
               this.mPlatformServiceAvailable = false;
            }
         }
         if(info.hasOwnProperty("get_all_versions"))
         {
            this.m_appVersion = info.get_all_versions.app_version;
            this.m_eqVersion = info.get_all_versions.eq_version;
            this.m_navVersion = info.get_all_versions.nav_version;
            this.m_v850AppVersion = info.get_all_versions.ioc_app_version;
            this.m_v850BootVersion = info.get_all_versions.ioc_boot_version;
            this.m_translationVersion = info.get_all_versions.translation_version;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.VERSION_INFO));
         }
         else if(info.hasOwnProperty("partnumber"))
         {
            this.m_partNumber = info.partnumber.partnumber;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.PARTNUMBER));
         }
         else if(info.hasOwnProperty("get_partnumber"))
         {
            this.m_partNumber = info.get_partnumber.partnumber;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.PARTNUMBER));
         }
         else if(info.hasOwnProperty("eq_version"))
         {
            this.m_eqVersion = info.eq_version.eq_version;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.EQ_VERSION));
         }
         else if(info.hasOwnProperty("get_eq_version"))
         {
            this.m_eqVersion = info.get_eq_version.eq_version;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.EQ_VERSION));
         }
         else if(info.hasOwnProperty("get_translation_version"))
         {
            this.m_translationVersion = info.get_translation_version.translation_version;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.TRANSLATION_VERSION));
         }
         else if(info.hasOwnProperty("serialNumber"))
         {
            this.m_serialNumber = info.serialNumber.serialnumber;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.SERIAL_NUMBER));
         }
         else if(info.hasOwnProperty("get_serialnumber"))
         {
            this.m_serialNumber = info.get_serialnumber.serialnumber;
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.SERIAL_NUMBER));
         }
         else if(info.hasOwnProperty("variantinfo"))
         {
            this.m_ProductVariantID = this.m_ProductVariantID.copyProductVariantID(info.variantinfo);
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.PRODUCT_VARIANT_ID));
         }
         else if(info.hasOwnProperty("get_variantinfo"))
         {
            this.m_ProductVariantID = this.m_ProductVariantID.copyProductVariantID(info.get_variantinfo);
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.PRODUCT_VARIANT_ID));
         }
         else if(info.hasOwnProperty("get_service_flags"))
         {
            this.mServiceMenu = info.get_service_flags.eng_menu;
            this.dispatchEvent(new ServiceEvent(ServiceEvent.SERVICE,info.get_service_flags.eng_menu));
         }
         else if(info.hasOwnProperty("flagsToTouchInEnggMenu"))
         {
            this.dispatchEvent(new VersionInfoEvent(VersionInfoEvent.FLAG_STATUS,info.flagsToTouchInEnggMenu));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mPlatformDbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.getProductId();
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function getProductId() : void
      {
         this.client.send("{\"Type\":\"ReturnProductID\", \"Dest\":\"" + mPlatformDbusIdentifier + "\"}");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
   }
}

