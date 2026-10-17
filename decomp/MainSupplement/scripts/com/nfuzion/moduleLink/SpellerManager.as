package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ISpellerManager;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.SpellerEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class SpellerManager extends Module implements ISpellerManager
   {
      
      private const pinyinDbus:String = "PinYin";
      
      private const hwrDbus:String = "hwr";
      
      private const initialize:String = "InitializeChineseInput";
      
      private const deinitialize:String = "DeInitializeChineseInput";
      
      private const frequencyFlag:String = "SetAdjustFrequencyFlag";
      
      private const predicFlag:String = "SetPredicFlag";
      
      private const tryRetrieveCharacter:String = "TryRetrieveCharacter";
      
      private const feedbackSelectedWord:String = "FeedbackSelectedWord";
      
      private const recogniseRange:String = "setRecogniseRange";
      
      private const recognise:String = "recognise";
      
      private const onRecogRange:String = "onRecogRange";
      
      private const onRecognitionResult:String = "onRecognitionResult";
      
      private var mSavedWords:String = "";
      
      private var mInitialFlg:Boolean = false;
      
      private var mConnection:Connection;
      
      private var mClient:Client;
      
      public function SpellerManager()
      {
         super();
         this.mConnection = Connection.share();
         this.mClient = this.mConnection.span;
         this.mClient.addEventListener(Event.CONNECT,this.connected);
         if(this.mClient.connected)
         {
            this.connected();
         }
         this.mClient.addEventListener(Event.CLOSE,this.disconnected);
         this.mConnection.addEventListener(ConnectionEvent.PINYIN,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.HWR,this.messageHandler);
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.mConnection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendSubscribe(this.onRecogRange);
         this.sendSubscribe(this.onRecognitionResult);
      }
      
      private function disconnected(e:Event) : void
      {
         this.sendUnsubscribe(this.onRecogRange);
         this.sendUnsubscribe(this.onRecognitionResult);
         this.deinitializePinYin();
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function initializePinYin() : void
      {
         if(!this.mInitialFlg)
         {
            this.mInitialFlg = true;
            this.sendCommand(this.pinyinDbus,"\"" + this.initialize + "\":{\"adjust\": false, \"predict\": true}");
         }
      }
      
      public function deinitializePinYin() : void
      {
         this.sendCommand(this.pinyinDbus,"\"" + this.deinitialize + "\":{}");
      }
      
      public function getChineseWords(wordinput:String, state:String, pagesize:int) : void
      {
         var command:String = null;
         command = "\"" + this.tryRetrieveCharacter + "\":{\"wordinput\":\"" + wordinput + "\", \"state\":\"" + state + "\", \"pagesize\": " + pagesize + "}";
         this.sendCommand(this.pinyinDbus,command);
      }
      
      public function getFeedbackWords(wordinput:String, state:String, pagesize:int) : void
      {
         this.dispatchEvent(new SpellerEvent(SpellerEvent.FEEDBACK_WORD));
      }
      
      public function setRecognizeRange(range:int) : void
      {
         var command:String = null;
         command = "\"" + this.recogniseRange + "\":{\"range\": " + range + "}";
         this.sendCommand(this.hwrDbus,command);
      }
      
      public function recognize(strokes:String) : void
      {
         var command:String = null;
         command = "\"" + this.recognise + "\":{\"strokes\": \"" + strokes + "\"}";
         this.sendCommand(this.hwrDbus,command);
      }
      
      private function sendCommand(dbusIdentifier:String, commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": {" + commandName + "}}";
         this.mClient.send(message);
      }
      
      public function sendSubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.hwrDbus + "\", \"Signal\":\"" + signal + "\"}";
         this.mClient.send(message);
      }
      
      public function sendUnsubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.hwrDbus + "\", \"Signal\":\"" + signal + "\"}";
         this.mClient.send(message);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var message:Object = e.data;
         if(message.hasOwnProperty(this.tryRetrieveCharacter))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.RETRIEVE_CHARACTER,message.TryRetrieveCharacter));
         }
         else if(message.hasOwnProperty(this.feedbackSelectedWord))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.FEEDBACK_WORD,message.FeedbackSelectedWord));
         }
         else if(message.hasOwnProperty(this.recogniseRange))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.RECOGNIZE_RANGE,message.response));
         }
         else if(message.hasOwnProperty(this.recognise))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.RECOGNIZE,message.response));
         }
         else if(message.hasOwnProperty(this.onRecogRange))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.ON_RECOG_RANGE,message.onRecogRange));
         }
         else if(message.hasOwnProperty(this.onRecognitionResult))
         {
            this.dispatchEvent(new SpellerEvent(SpellerEvent.ON_RECOGNITION_RESULT,message.onRecognitionResult));
         }
      }
      
      public function setSavedWords(words:String) : void
      {
         this.mSavedWords = words;
      }
      
      public function getSavedWords() : void
      {
         this.sendEvent(SpellerEvent.SAVED_WORD);
      }
      
      public function get savedWords() : String
      {
         return this.mSavedWords;
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new SpellerEvent(eventType));
      }
   }
}

