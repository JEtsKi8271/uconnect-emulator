package com.nfuzion.moduleLink
{
   import com.adobe.serialization.json.JSON;
   import com.nfuzion.span.Client;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class Connection extends EventDispatcher
   {
      
      private static var connection:Connection;
      
      private const configurationFileName:String = "ModuleLink.xml";
      
      private var mReady:Boolean = false;
      
      private var thisConfiguration:XML;
      
      private var client:Client;
      
      public function Connection()
      {
         super();
         this.client = new Client();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.onConfiguration);
         loader.load(new URLRequest(this.configurationFileName));
      }
      
      public static function share() : Connection
      {
         if(connection == null)
         {
            connection = new Connection();
         }
         return connection;
      }
      
      public function send(object:Object) : void
      {
         this.span.send(com.adobe.serialization.json.JSON.encode(object));
      }
      
      private function onConfiguration(e:Event) : void
      {
         this.thisConfiguration = new XML(e.target.data);
         this.client.connect(this.thisConfiguration.hb.@host,int(this.thisConfiguration.hb.@port));
         this.client.addEventListener(DataEvent.DATA,this.dataEventListener);
         this.mReady = true;
         this.dispatchEvent(new ConnectionEvent(ConnectionEvent.READY));
      }
      
      private function dataEventListener(e:DataEvent) : void
      {
         var decodedValue:Object = null;
         var s:String = null;
         var property:String = null;
         var module:String = null;
         s = e.data.toString();
         try
         {
            decodedValue = com.adobe.serialization.json.JSON.decode(s);
            if(decodedValue.hasOwnProperty("HMIGatewayContextToken"))
            {
               this.client.token = decodedValue.HMIGatewayContextToken;
            }
            if(decodedValue.hasOwnProperty("Navigation"))
            {
               dispatchEvent(new ConnectionEvent(ConnectionEvent.NAVIGATION,decodedValue.Navigation));
            }
            else if(decodedValue.hasOwnProperty("NDR"))
            {
               dispatchEvent(new ConnectionEvent(ConnectionEvent.NDR,decodedValue.NDR));
            }
            else
            {
               for(property in decodedValue)
               {
                  if(decodedValue.hasOwnProperty("HMIGatewayContextToken"))
                  {
                     this.client.insertToken(property,decodedValue.HMIGatewayContextToken);
                  }
                  dispatchEvent(new ConnectionEvent(property,decodedValue[property]));
               }
            }
         }
         catch(err:Error)
         {
            trace("<JSONDecoder> [ERROR] Malformed JSON String! " + s);
            module = e.data.toString().split("\"",2)[1];
            dispatchEvent(new ConnectionEvent(module,{
               "msg":s,
               "fatal":{"description":"Malformed JSON String!"}
            }));
         }
      }
      
      public function get span() : Client
      {
         return this.client;
      }
      
      public function get ready() : Boolean
      {
         return this.mReady;
      }
      
      public function get configuration() : XML
      {
         return this.thisConfiguration;
      }
      
      public function get configured() : Boolean
      {
         if(this.configuration == null)
         {
            return false;
         }
         return true;
      }
   }
}

