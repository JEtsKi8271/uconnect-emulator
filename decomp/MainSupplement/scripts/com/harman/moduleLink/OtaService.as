package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IOtaService;
   import com.harman.moduleLinkAPI.OtaEvent;
   import com.harman.moduleLinkAPI.Time;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class OtaService extends Module implements IOtaService
   {
      
      private static var instance:OtaService;
      
      private static const m_dbusIdentifier:String = "OtaService";
      
      private var m_installType:Number;
      
      private var m_installSuccess:Number;
      
      private var m_errorCode:Number;
      
      private var m_whatsNew:String;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mServiceAvailable:Boolean;
      
      public function OtaService()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.OTA_SERVICE,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : OtaService
      {
         if(instance == null)
         {
            instance = new OtaService();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var ota_install_done:Object = null;
         var ota_confirm_ui:Object = null;
         var resp:Object = e.data;
         var processed:Boolean = false;
         var ota:Object = e.data;
         if(ota.hasOwnProperty("dBusServiceAvailable"))
         {
            if(ota.dBusServiceAvailable == "true" && this.mServiceAvailable == false)
            {
               this.mServiceAvailable = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + m_dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
            }
            else if(ota.dBusServiceAvailable == "false")
            {
               this.mServiceAvailable = false;
            }
         }
         if(ota.hasOwnProperty("ota_scomo_install_done"))
         {
            ota_install_done = ota.ota_scomo_install_done;
            if(ota_install_done.hasOwnProperty("installSuccess"))
            {
               this.m_installSuccess = ota_install_done.installSuccess;
               if(ota_install_done.hasOwnProperty("errorCode"))
               {
                  this.m_errorCode = ota_install_done.errorCode;
                  if(ota_install_done.hasOwnProperty("whatsNew"))
                  {
                     this.m_whatsNew = ota_install_done.whatsNew;
                     this.dispatchEvent(new OtaEvent(OtaEvent.OTA_INSTALL_DONE,[ota_install_done.installSuccess,ota_install_done.errorCode,ota_install_done.whatsNew]));
                  }
               }
            }
         }
         if(ota.hasOwnProperty("ota_scomo_ins_confirm_ui"))
         {
            ota_confirm_ui = ota.ota_scomo_ins_confirm_ui;
            if(ota_confirm_ui.hasOwnProperty("installType"))
            {
               this.m_installType = ota_confirm_ui.installType;
               this.dispatchEvent(new OtaEvent(OtaEvent.OTA_INSTALL_CONFIRM,ota_confirm_ui.installType));
            }
         }
         if(ota.hasOwnProperty("popupDismiss"))
         {
            this.dispatchEvent(new OtaEvent(OtaEvent.OTA_DISMISS_POPUP));
         }
      }
      
      public function connected(e:Event = null) : void
      {
         trace("OtaService : connected ");
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("popupDismiss");
            this.sendSubscribe("ota_scomo_install_done");
            this.sendSubscribe("ota_scomo_ins_confirm_ui");
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         trace("messageHandler : loadConfiguration ModuleEvent.READY");
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendCommand(command:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + m_dbusIdentifier + "\", \"packet\": {" + command + "}}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         trace("OtaService : sendSubscribe for " + signalName);
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + m_dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + m_dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function get installType() : Number
      {
         return this.m_installType;
      }
      
      public function get installSuccess() : Number
      {
         return this.m_installSuccess;
      }
      
      public function get errorCode() : Number
      {
         return this.m_errorCode;
      }
      
      public function get whatsNew() : String
      {
         return this.m_whatsNew;
      }
      
      public function updateNow() : void
      {
         var message:String = null;
         this.client.send("{\"Type\":\"EmitSignal\",\"packet\":{\"" + "updateNow" + "\":{\"value\":\"" + "" + "\"}}}");
      }
      
      public function scheduledUpdateTime(time:Time) : void
      {
         var message:Object = {
            "Type":"EmitSignal",
            "Dest":m_dbusIdentifier,
            "packet":{"scheduledUpdateTime":{
               "year":time.year,
               "month":time.month,
               "day":time.day,
               "hour":time.hour,
               "minute":time.minute,
               "second":0
            }}
         };
         this.connection.send(message);
      }
   }
}

