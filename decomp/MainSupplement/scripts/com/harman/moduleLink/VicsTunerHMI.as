package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVicsTunerHMI;
   import com.harman.moduleLinkAPI.VicsTunerHMIEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VicsTunerHMI extends Module implements IVicsTunerHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnTunerHmi.NavCtrl_Driver";
      
      private static const START_TUNE:String = "requestStartTune";
      
      private static const FINISH_TUNE:String = "requestFinishTune";
      
      private static const SET_TUNE_TYPE_AUTO:String = "requestSetTuneTypeAuto";
      
      private static const SET_TUNE_TYPE_PREF:String = "requestSetTuneTypePref";
      
      private static const SET_TUNE_TYPE_MANUAL:String = "requestSetTuneTypeManual";
      
      private static const TUNE_UP:String = "requestTuneUp";
      
      private static const TUNE_DOWN:String = "requestTuneDown";
      
      private static const START_TUNE_UP:String = "requestStartTuneUp";
      
      private static const START_TUNE_DOWN:String = "requestStartTuneDown";
      
      private static const END_TUNE_UP_DOWN:String = "requestEndTuneUpDown";
      
      private static const STATE:String = "State";
      
      private static const TUNING_TYPE:String = "TuningType";
      
      private static const FREQUENCY:String = "Frequency";
      
      private static const PREFECTURE_MANUAL:String = "PrefectureManual";
      
      private static const PREFECTURE_AUTO:String = "PrefectureAuto";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mState:uint = 0;
      
      private var mTuningType:uint = 0;
      
      private var mFrequency:uint = 0;
      
      private var mPrefectureManual:uint = 0;
      
      private var mPrefectureAuto:uint = 0;
      
      private var mConvertPrefEng:Array = new Array("","Hokkaido","Aomori","Iwate","Miyagi","Akita","Yamagata","Fukushima","Ibaraki","Tochigi","Gunma","Saitama","Chiba","Tokyo","Kanagawa","Niigata","Toyama","Ishikawa","Fukui","Yamanashi","Nagano","Gifu","Shizuoka","Aichi","Mie","Shiga","Kyoto","Osaka","Hyogo","Nara","Wakayama","Tottori","Shimane","Okayama","Hiroshima","Yamaguchi","Tokushima","Kagawa","Ehime","Kochi","Fukuoka","Saga","Nagasaki","Kumamoto","Oita","Miyazaki","Kagoshima","Okinawa");
      
      private var mConvertPrefJpn:Array = new Array("","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県");
      
      public function VicsTunerHMI()
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
         this.connection.addEventListener(ConnectionEvent.VICSTUNERHMI,this.TunerHMIMessageHandler);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         if(this.client.connected)
         {
            this.sendAttributeSubscribes();
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
      
      private function requestAttributesInitialValue() : void
      {
         this.requestState();
         this.requestTuningType();
         this.requestFrequency();
         this.requestPrefectureManual();
         this.requestPrefectureAuto();
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.sendSubscribe(STATE);
         this.sendSubscribe(TUNING_TYPE);
         this.sendSubscribe(FREQUENCY);
         this.sendSubscribe(PREFECTURE_MANUAL);
         this.sendSubscribe(PREFECTURE_AUTO);
      }
      
      public function requestState() : void
      {
         this.sendAttrRequest(STATE);
      }
      
      public function requestTuningType() : void
      {
         this.sendAttrRequest(TUNING_TYPE);
      }
      
      public function requestFrequency() : void
      {
         this.sendAttrRequest(FREQUENCY);
      }
      
      public function requestPrefectureManual() : void
      {
         this.sendAttrRequest(PREFECTURE_MANUAL);
      }
      
      public function requestPrefectureAuto() : void
      {
         this.sendAttrRequest(PREFECTURE_AUTO);
      }
      
      public function requestStartTune() : void
      {
         this.sendCommandSimple(START_TUNE);
      }
      
      public function requestFinishTune() : void
      {
         this.sendCommandSimple(FINISH_TUNE);
      }
      
      public function requestSetTuneTypeAuto() : void
      {
         this.sendCommandSimple(SET_TUNE_TYPE_AUTO);
      }
      
      public function requestSetTuneTypePref(prefecture:uint) : void
      {
         this.sendCommand(SET_TUNE_TYPE_PREF,"prefecture",String(prefecture));
      }
      
      public function requestSetTuneTypeManual() : void
      {
         this.sendCommandSimple(SET_TUNE_TYPE_MANUAL);
      }
      
      public function requestTuneUp() : void
      {
         this.sendCommandSimple(TUNE_UP);
      }
      
      public function requestTuneDown() : void
      {
         this.sendCommandSimple(TUNE_DOWN);
      }
      
      public function requestStartTuneUp() : void
      {
         this.sendCommandSimple(START_TUNE_UP);
      }
      
      public function requestStartTuneDown() : void
      {
         this.sendCommandSimple(START_TUNE_DOWN);
      }
      
      public function requestEndTuneUpDown() : void
      {
         this.sendCommandSimple(END_TUNE_UP_DOWN);
      }
      
      private function TunerHMIMessageHandler(e:ConnectionEvent) : void
      {
         var TunerData:Object = e.data;
         if(TunerData.hasOwnProperty(STATE))
         {
            this.mState = TunerData.State[1];
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.STATE,e.data));
         }
         else if(TunerData.hasOwnProperty(TUNING_TYPE))
         {
            this.mTuningType = TunerData.TuningType[1];
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.TUNING_TYPE,e.data));
         }
         else if(TunerData.hasOwnProperty(FREQUENCY))
         {
            this.mFrequency = TunerData.Frequency[1];
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.FREQUENCY,e.data));
         }
         else if(TunerData.hasOwnProperty(PREFECTURE_MANUAL))
         {
            this.mPrefectureManual = TunerData.PrefectureManual[1];
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.PREFECTURE_MANUAL,e.data));
         }
         else if(TunerData.hasOwnProperty(PREFECTURE_AUTO))
         {
            this.mPrefectureAuto = TunerData.PrefectureAuto[1];
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.PREFECTURE_AUTO,e.data));
         }
         else if(TunerData.hasOwnProperty(START_TUNE))
         {
            this.dispatchEvent(new VicsTunerHMIEvent(VicsTunerHMIEvent.START_TUNE,e.data));
         }
         else
         {
            trace("Unexpected property returned to VicsTunerHMI module");
         }
      }
      
      public function get State() : uint
      {
         return this.mState;
      }
      
      public function get TuningType() : uint
      {
         return this.mTuningType;
      }
      
      public function get Frequency() : uint
      {
         return this.mFrequency;
      }
      
      public function get PrefectureManual() : uint
      {
         return this.mPrefectureManual;
      }
      
      public function get PrefectureAuto() : uint
      {
         return this.mPrefectureAuto;
      }
      
      public function PrefectureStringJpn(pref:uint) : String
      {
         return this.mConvertPrefJpn[pref];
      }
      
      public function PrefectureStringEng(pref:uint) : String
      {
         return this.mConvertPrefEng[pref];
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
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendCommandSimple(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         this.client.send(message);
      }
      
      protected function sendAttrRequest(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
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

