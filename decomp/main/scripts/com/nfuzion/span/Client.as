package com.nfuzion.span
{
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.XMLSocket;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class Client extends XMLSocket
   {
      
      private static const CHECK_INTERVAL:int = 1000;
      
      private static const PADDING:int = 5;
      
      private static const ZEROS:String = "00000";
      
      private var host:String = "127.0.0.1";
      
      private var port:uint = 1025;
      
      private var thisAutoAttach:Boolean = true;
      
      private var checkTimer:Timer;
      
      private var HMIGatewayToken:String = "";
      
      private var tokenMap:Dictionary = new Dictionary();
      
      private var byteArray:ByteArray = new ByteArray();
      
      public function Client(host:String = "127.0.0.1", port:uint = 1025, autoAttach:Boolean = false)
      {
         super();
         this.checkTimer = new Timer(CHECK_INTERVAL);
         this.checkTimer.addEventListener(TimerEvent.TIMER,this.checkAttachment);
         addEventListener(IOErrorEvent.IO_ERROR,this.ignoreError);
         this.host = host;
         this.port = port;
         this.autoAttach = autoAttach;
      }
      
      private static function zeroPad(_len:int) : String
      {
         var result:String = _len.toString();
         while(result.length < PADDING)
         {
            result = ZEROS.substr(0,PADDING - result.length) + result;
         }
         return result;
      }
      
      private function ignoreError(e:IOErrorEvent) : void
      {
      }
      
      override public function connect(host:String, port:int) : void
      {
         this.host = host;
         this.port = port;
         this.attach();
      }
      
      public function attach() : void
      {
         if(!connected)
         {
            super.connect(this.host,this.port);
         }
      }
      
      public function detach() : void
      {
         if(connected)
         {
            close();
         }
      }
      
      public function set autoAttach(autoAttach:Boolean) : void
      {
         this.thisAutoAttach = autoAttach;
         if(autoAttach == true)
         {
            this.checkTimer.start();
            this.attach();
         }
         else
         {
            this.checkTimer.stop();
         }
      }
      
      public function get autoAttach() : Boolean
      {
         return this.thisAutoAttach;
      }
      
      private function checkAttachment(e:TimerEvent) : void
      {
         if(!connected)
         {
            this.attach();
         }
      }
      
      override public function send(object:*) : void
      {
         var json:String = null;
         var key:String = null;
         if(connected)
         {
            json = object as String;
            key = this.parseSigName(json);
            if(this.tokenMap[key] != null && this.tokenMap[key] != "")
            {
               json = json.substring(0,json.length - 1) + ", \"HMIGatewayContextToken\": " + this.tokenMap[key] + "}";
               delete this.tokenMap[key];
            }
            json = "{\"Length\":" + zeroPad(this.getByteSize("{\"Length\":" + ZEROS + ", " + json.substring(1,json.length))) + ", " + json.substring(1,json.length);
            super.send(json);
         }
         this.HMIGatewayToken = "";
      }
      
      private function getByteSize(_json:String) : uint
      {
         this.byteArray.writeUTFBytes(_json);
         this.byteArray.position = 0;
         var len:uint = this.byteArray.bytesAvailable;
         this.byteArray.clear();
         return len;
      }
      
      private function parseSigName(_json:String) : String
      {
         return _json.substr(_json.indexOf("rsp_") + 4,_json.indexOf("\"",_json.indexOf("rsp_")) - (_json.indexOf("rsp_") + 4));
      }
      
      public function insertToken(_key:String, _token:String) : void
      {
         this.tokenMap[_key] = _token;
      }
      
      public function set token(_token:String) : void
      {
         this.HMIGatewayToken = _token;
      }
   }
}

