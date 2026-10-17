package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IKanjiHMI;
   import com.harman.moduleLinkAPI.KanjiHMIEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class KanjiHMI extends Module implements IKanjiHMI
   {
      
      private static const dbusIdentifier:String = "KanaKanJi";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var holder:String = "";
      
      private var candidateCount:int = 0;
      
      private var candidateArray:Object = new Object();
      
      private var selectedCandidate:String = "";
      
      private var STR_SPACE:String = " ";
      
      public var mState:String = "";
      
      public var mPreState:String = "";
      
      public function KanjiHMI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.KANAKANJI,this.kanjiInfoMessageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         if(!this.client.connected)
         {
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(!this.client.connected)
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
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function kanjiInfoMessageHandler(e:ConnectionEvent) : void
      {
         var i:int = 0;
         var KanjiData:Object = e.data;
         if(!KanjiData.hasOwnProperty("EnterChar"))
         {
            if(KanjiData.hasOwnProperty("GetCandList"))
            {
               this.candidateCount = e.data.GetCandList.count;
               this.candidateArray = e.data.GetCandList.candidates;
               this.setkanjiCandidateArray(e.data.GetCandList.candidates);
               for(i = 0; i < this.candidateCount; i++)
               {
                  trace("Receiver function Candidate: " + e.data.GetCandList.candidates[i].cand + " at index : " + e.data.GetCandList.candidates[i].index);
               }
               this.dispatchEvent(new KanjiHMIEvent(KanjiHMIEvent.GET_CAND_LIST));
            }
            else if(KanjiData.hasOwnProperty("SelectCand"))
            {
               this.dispatchEvent(new KanjiHMIEvent(KanjiHMIEvent.KANJI_CONVERTED,this.selectedCandidate));
            }
            else if(!KanjiData.hasOwnProperty("Backspace"))
            {
               if(!KanjiData.hasOwnProperty("CancelAll"))
               {
                  if(KanjiData.hasOwnProperty("DeleteAll"))
                  {
                  }
               }
            }
         }
      }
      
      public function sendHiraCharacter(kanjiChar:String) : void
      {
         trace("Nav.KanjiManager.sendKanjiCharacter(" + kanjiChar + ")");
         this.mState += kanjiChar;
         this.sendCommandString("EnterChar","char",kanjiChar);
      }
      
      public function hiraConvert() : void
      {
         trace("Kanji Conversion");
         this.sendCommandSimple("Convert");
      }
      
      public function FocusAllAndConvert() : void
      {
         trace("Kanji Conversion and focus all");
         this.sendCommandSimple("FocusAllAndConvert");
      }
      
      public function kanjiCandidateList() : void
      {
         trace("Kanji Candidate List");
         this.sendCommandSimple("GetCandList");
      }
      
      public function kanjiCandidateSelect(index:int) : void
      {
         trace("Select Kanji Candidate");
         this.sendCommand("SelectCand","index",String(index));
         this.mPreState = this.mState;
         this.mState = "";
         if(this.STR_SPACE == this.mPreState.charAt(0))
         {
            this.selectedCandidate = this.STR_SPACE + this.candidateArray[index - 1].cand;
         }
         else
         {
            this.selectedCandidate = this.candidateArray[index - 1].cand;
         }
      }
      
      public function hiraBackspace() : void
      {
         trace("Backspace HiraCharacter");
         this.mState = this.mState.slice(0,this.mState.length - 1);
         this.sendCommandSimple("Backspace");
      }
      
      public function hiraCancelAll() : void
      {
         trace("Clear all hira converting");
         this.sendCommandSimple("CancelAll");
      }
      
      public function hiraDeleteAll() : void
      {
         trace("Delete all character");
         this.mState = "";
         this.sendCommandSimple("DeleteAll");
      }
      
      public function ModifyChar(type:String) : void
      {
         trace("Convert character on the cursor");
         this.sendCommandSimple("CursorLeft");
         this.sendCommandString("ModifyChar","type",type);
         this.sendCommandSimple("CursorRight");
      }
      
      public function SetInputMax(max:int) : void
      {
         trace("Set maximum number of input character");
         this.sendCommand("SetInputMax","max",String(max));
      }
      
      public function CursorRight() : void
      {
         trace("Move cursor to right");
         this.sendCommandSimple("CursorRight");
      }
      
      public function CursorLeft() : void
      {
         trace("Move cursor to left");
         this.sendCommandSimple("CursorLeft");
      }
      
      public function get kanjiCandidateCount() : int
      {
         var key:String = null;
         this.candidateCount = 0;
         for(key in this.candidateArray)
         {
            ++this.candidateCount;
         }
         return this.candidateCount;
      }
      
      public function get kanjiCandidateArray() : Object
      {
         return this.candidateArray;
      }
      
      public function get kanjiConverting() : String
      {
         return this.mState;
      }
      
      public function get kanjiPreConverting() : String
      {
         return this.mPreState;
      }
      
      public function setkanjiCandidateArray(tmpObject:Object) : void
      {
         this.candidateArray = tmpObject;
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
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendAttrRequest(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendCommandSimple(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendCommandString(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":\"" + value + "\"}}}";
         this.client.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

