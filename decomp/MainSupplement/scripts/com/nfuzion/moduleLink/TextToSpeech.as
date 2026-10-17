package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ITextToSpeech;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.TextToSpeechEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class TextToSpeech extends Module implements ITextToSpeech
   {
      
      private static var instance:TextToSpeech;
      
      private static const DBUS_IDENTIFIER:String = "TextToSpeech";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mPlayState:String = "notPlaying";
      
      private var mAvailable:Boolean = false;
      
      public function TextToSpeech()
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
         this.connection.addEventListener(ConnectionEvent.TEXT_TO_SPEECH,this.onConnectionMessage);
      }
      
      public static function getInstance() : TextToSpeech
      {
         if(instance == null)
         {
            instance = new TextToSpeech();
         }
         return instance;
      }
      
      public function get READOUT_TYPE_EMAIL() : String
      {
         return "EMAIL";
      }
      
      public function get READOUT_TYPE_NAVI() : String
      {
         return "NAVI";
      }
      
      public function get READOUT_TYPE_SMS() : String
      {
         return "SMS";
      }
      
      public function get READOUT_TYPE_TMC() : String
      {
         return "TMC";
      }
      
      public function get READOUT_TYPE_PMSG() : String
      {
         return "PMSG";
      }
      
      public function get READOUT_TYPE_PLAIN() : String
      {
         return "PLAIN";
      }
      
      public function get READOUT_TYPE_ACCFR() : String
      {
         return "ACCFR";
      }
      
      public function get playState() : String
      {
         return this.mPlayState;
      }
      
      public function get available() : Boolean
      {
         return this.mAvailable;
      }
      
      public function readout(readoutType:String, textToRead:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_IDENTIFIER,
            "packet":{"ttsReadout":{
               "readoutType":readoutType,
               "data":textToRead,
               "dataIsFile":false
            }}
         };
         this.connection.send(message);
      }
      
      public function readoutAdv(readoutType:String, textToRead:Array = null) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":DBUS_IDENTIFIER,
            "packet":{"ttsReadoutAdv":{
               "readoutType":readoutType,
               "data":textToRead,
               "dataIsFile":false,
               "respondWithHandle":true
            }}
         };
         this.connection.send(message);
      }
      
      public function setTTsDomainParams(language:String) : void
      {
         var message:String = null;
         var commandName:String = "setTtsDomainParams";
         var valueName:String = "language";
         var valueName2:String = "readoutType";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + DBUS_IDENTIFIER + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + language + "\",\"" + valueName2 + "\": \"" + this.READOUT_TYPE_NAVI + "\"}}}";
         this.client.send(message);
      }
      
      public function abort(readoutType:String) : void
      {
         this.sendCommand("ttsAbort","readoutType",readoutType);
      }
      
      public function requestPlayState() : void
      {
         this.sendGetProperties("ttsPlayState");
      }
      
      public function requestAvailable() : void
      {
         this.sendGetProperties("ttsAvailable");
      }
      
      public function get isTTSPlaying() : Boolean
      {
         if(this.mPlayState == null || this.mPlayState == "playing" || this.mPlayState == "playStart")
         {
            return true;
         }
         return false;
      }
      
      private function set ttsReadout(eventObj:Object) : void
      {
         var result:String = eventObj.description;
         dispatchEvent(new TextToSpeechEvent(TextToSpeechEvent.RESULT,result));
      }
      
      private function set ttsReadoutAdv(eventObj:Object) : void
      {
         var result:String = eventObj.description;
      }
      
      private function set ttsAbort(eventObj:Object) : void
      {
         var result:String = eventObj.description;
      }
      
      private function set ttsPlayState(eventObj:Object) : void
      {
         var state:String = eventObj.state;
         this.mPlayState = state;
         dispatchEvent(new TextToSpeechEvent(TextToSpeechEvent.PLAY_STATE,eventObj));
      }
      
      private function set ttsAvailable(eventObj:Object) : void
      {
         this.mAvailable = Boolean(eventObj.state);
         dispatchEvent(new TextToSpeechEvent(TextToSpeechEvent.AVAILABLE_STATE));
      }
      
      private function set getProperties(eventObj:Object) : void
      {
         var i:String = null;
         for(i in eventObj)
         {
            if(i == "ttsPlayState")
            {
               this.mPlayState = String(eventObj.ttsPlayState.state);
               dispatchEvent(new TextToSpeechEvent(TextToSpeechEvent.PLAY_STATE));
            }
            if(i == "ttsAvailable")
            {
               this.mAvailable = Boolean(eventObj.ttsAvailable.state);
               dispatchEvent(new TextToSpeechEvent(TextToSpeechEvent.AVAILABLE_STATE));
            }
         }
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendCommandToId(DBUS_IDENTIFIER,commandName,valueName,value,addQuotesOnValue);
      }
      
      private function sendCommandToId(id:String, commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      protected function sendGetProperties(value:Object, addQuotesOnValue:Boolean = true) : void
      {
         this.sendGetPropertiesToId(DBUS_IDENTIFIER,value,addQuotesOnValue);
      }
      
      protected function sendGetPropertiesToId(id:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "props" + "\": [\"" + value + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendGetAllPropertiesToId(id:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + id + "\", \"packet\": { \"" + "getAllProperties" + "\" }}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_IDENTIFIER + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + DBUS_IDENTIFIER + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendSubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribeToId(id:String, signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + id + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function onConnectionMessage(e:ConnectionEvent) : void
      {
         var property:String = null;
         var obj:Object = e.data;
         for(property in obj)
         {
            switch(property)
            {
               case "getProperties":
               case "ttsAvailable":
               case "ttsPlayState":
                  this[property] = obj[property];
                  break;
               case "ttsReadout":
                  this[property] = obj[property];
                  break;
               case "ttsReadoutAdv":
               case "ttsAbort":
            }
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendSubscribe("ttsPlayState");
            this.sendSubscribe("ttsAvailable");
            this.sendSubscribe("getProperties");
            this.sendSubscribe("ttsReadout");
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
         this.sendUnsubscribe("ttsPlayState");
         this.sendUnsubscribe("ttsAvailable");
         this.sendUnsubscribe("getProperties");
         this.sendUnsubscribe("ttsReadout");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var _loc2_:String = signalName;
         switch(0)
         {
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var _loc2_:String = signalName;
         switch(0)
         {
         }
      }
   }
}

