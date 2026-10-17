package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AmsInfoEvent;
   import com.harman.moduleLinkAPI.IAmsFileInfo;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AmsFileInfo extends Module implements IAmsFileInfo
   {
      
      private static var instance:AmsFileInfo;
      
      private static const mDbusIdentifier:String = "AmsFileInfo";
      
      private var m_Ready:Boolean = false;
      
      private var m_NumFiles:int;
      
      private var m_path:String;
      
      private var m_files:Array = new Array();
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function AmsFileInfo()
      {
         super();
         this.m_NumFiles = 0;
         this.m_path = "";
         this.m_files[0] = "";
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.AMS_FILE_INFO,this.messageHandler);
      }
      
      public static function getInstance() : AmsFileInfo
      {
         if(instance == null)
         {
            instance = new AmsFileInfo();
         }
         return instance;
      }
      
      public function get amsNumFiles() : int
      {
         return this.m_NumFiles;
      }
      
      public function get amsPath() : String
      {
         return this.m_path;
      }
      
      public function get amsFiles() : Array
      {
         return this.m_files;
      }
      
      public function getAmsFileInfo() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getFiles\": {}}}");
      }
      
      public function doAmsFileInstall(filepath:String) : void
      {
         var command:String = null;
         command = "{ \"installApp\":{\"uri\": \"file:" + filepath + "\"}}";
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + "AppManager" + "\", \"packet\": " + command + "}");
      }
      
      public function doAmsFileReinstall(fileName:String, path:String) : void
      {
         var command:String = null;
         command = "{ \"upgradeApp\":{\"path\":\"file:" + path + "\",\"filename\":\"" + fileName + "\"}}";
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + "AppManager" + "\", \"packet\": " + command + "}");
      }
      
      public function doAmsFileUnInstall(appId:String) : void
      {
         var command:String = null;
         command = "{ \"uninstallApp\":{\"appId\": \"" + appId + "\"}}";
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + "AppManager" + "\", \"packet\": " + command + "}");
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var tmp:Object = null;
         var info:Object = e.data;
         tmp = null;
         if(info.hasOwnProperty("getFiles"))
         {
            tmp = info.getFiles;
            if(tmp != null)
            {
               try
               {
                  this.m_NumFiles = tmp.numFiles;
                  this.m_path = tmp.path;
                  this.m_files = tmp.files;
                  this.dispatchEvent(new AmsInfoEvent(AmsInfoEvent.AMS_FILE_INFO));
               }
               catch(e:Error)
               {
               }
            }
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
   }
}

