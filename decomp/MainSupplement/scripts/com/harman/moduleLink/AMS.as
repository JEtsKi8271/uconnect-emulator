package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AMSEvent;
   import com.harman.moduleLinkAPI.IAMS;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AMS extends Module implements IAMS
   {
      
      private static var instance:AMS;
      
      private static const dbusIdentifier:String = "AMS";
      
      private var connection:Connection;
      
      private var name:String = "AMSHMIClient";
      
      private var client:Client;
      
      private var installedAppName:String = "";
      
      private var uninstalledAppName:String = "";
      
      private var uninstalledAppID:String = "";
      
      public function AMS()
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
         this.connection.addEventListener(ConnectionEvent.AMS,this.AMSMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : AMS
      {
         if(instance == null)
         {
            instance = new AMS();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.subscribe("appInstalled");
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         this.name = this.connection.configuration.@name.toString();
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function AMSMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("queryAppIds"))
         {
            this.dispatchEvent(new AMSEvent(AMSEvent.QUERY_APP_IDS,e.data));
         }
         else if(resp.hasOwnProperty("getPackageInfo"))
         {
            this.dispatchEvent(new AMSEvent(AMSEvent.PACKAGE_INFO,e.data));
         }
         else if(resp.hasOwnProperty("extractResource"))
         {
            this.dispatchEvent(new AMSEvent(AMSEvent.EXTRACT_RESOURCE,e.data));
         }
         else if(resp.hasOwnProperty("appInstalled"))
         {
            this.installedAppName = e.data.appInstalled.name;
            this.dispatchEvent(new AMSEvent(AMSEvent.APP_INSTALLED,e.data));
         }
         else if(resp.hasOwnProperty("appUninstalled"))
         {
            this.uninstalledAppName = e.data.appUninstalled.name;
            this.uninstalledAppID = e.data.appUninstalled.appId;
            this.dispatchEvent(new AMSEvent(AMSEvent.APP_UNINSTALLED,e.data));
         }
      }
      
      public function getAppIds(filter:String) : void
      {
         this.sendCommand("queryAppIds","filter",filter);
      }
      
      public function getPackageInfo(appId:String) : void
      {
         this.sendCommand("getPackageInfo","appId",appId);
      }
      
      public function extractResource(app:Object) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier;
         message += "\", \"packet\": { \"" + "extractResource";
         message += "\": { \"" + "appId" + "\": \"" + app.appId + "\"";
         message += ", \"" + "resPath" + "\": \"" + app.resPath + "\"";
         message += ", \"" + "destUri" + "\": \"" + app.icon + "\"}}}";
         this.client.send(message);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

