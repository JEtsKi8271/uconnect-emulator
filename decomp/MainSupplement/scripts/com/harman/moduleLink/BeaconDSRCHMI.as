package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.BeaconDSRCHMIEvent;
   import com.harman.moduleLinkAPI.BeaconDSRCID;
   import com.harman.moduleLinkAPI.IBeaconDSRCHMI;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class BeaconDSRCHMI extends Module implements IBeaconDSRCHMI
   {
      
      private static const dbusIdentifier:String = "DNAVNTG5JpnBeaconDsrcHmi.NavCtrl_Driver";
      
      private static const DBUS_SERVICE_AVAILABLE:String = "dbusServiceAvailable";
      
      private static const INTERRUPT_CHARACTER_INFO:String = "InterruptCharacterInfo";
      
      private static const INTERRUPT_FIGURE_INFO:String = "InterruptFigureInfo";
      
      private static const VICS_VOICE_GUIDANCE:String = "VICSVoiceGuidance";
      
      private static const DSRS_TTS_ANNOUNCEMENT:String = "DSRSTTSAnnouncement";
      
      private static const DSRS_UPLINK:String = "DSRSUplink";
      
      private static const DISPLAY_TIME:String = "DisplayTime";
      
      private static const MENU_DATA:String = "menuData";
      
      private static const MENU_BUTTON:String = "menuButton";
      
      private static const INTER_BUTTON:String = "interButton";
      
      private static const PUB_TEXT_RECEIVED_TIME:String = "pubTextReceivedTime";
      
      private static const PUB_DIAG_RECEIVED_TIME:String = "pubDiagReceivedTime";
      
      private static const EXP_TEXT_RECIEVED_TIME:String = "expTextReceivedTime";
      
      private static const EXP_DIAG_RECIEVED_TIME:String = "expDiagReceivedTime";
      
      private static const EXP_TEXT_TOKEN_CLEAR_FLAG:String = "expTextTokenClearFlag";
      
      private static const EXP_DIAG_TOKEN_CLEAR_FLAG:String = "expDiagTokenClearFlag";
      
      private static const SWITCH_INTERRUPT_CHARACTER_INFO:String = "requestSwitchInterruptCharacterInfo";
      
      private static const SWITCH_INTERRUPT_FIGURE_INFO:String = "requestSwitchInterruptFigureInfo";
      
      private static const SWITCH_VICS_VOICE_GUIDANCE:String = "requestSwitchVICSVoiceGuidance";
      
      private static const SWITCH_DSRSTTS_ANNOUNCEMENT:String = "requestSwitchDSRSTTSAnnouncement";
      
      private static const SWITCH_DSRS_UPLINK:String = "requestSwitchDSRSUplink";
      
      private static const SWITCH_DISPLAY_TIME:String = "requestSwitchDisplayTime";
      
      private static const START_MENU:String = "requestStartMenu";
      
      private static const DRAW_MENU_TEXT_MSG:String = "requestDrawMenuTextMsg";
      
      private static const DRAW_MENU_DIAG_MSG:String = "requestDrawMenuDiagMsg";
      
      private static const DRAW_MENU_PREV_PAGE:String = "requestDrawMenuPrevPage";
      
      private static const DRAW_MENU_NEXT_PAGE:String = "requestDrawMenuNextPage";
      
      private static const DRAW_MENU_TOP_PAGE_TEXT:String = "requestDrawMenuTopPageText";
      
      private static const DRAW_MENU_TOP_PAGE_DIAG:String = "requestDrawMenuTopPageDiag";
      
      private static const START_MENU_TTS:String = "requestStartMenuTts";
      
      private static const STOP_MENU_TTS:String = "requestStopMenuTts";
      
      private static const FINISH_MENU:String = "requestFinishMenu";
      
      private static const DRAW_INTER_TOP_PAGE:String = "requestDrawInterTopPage";
      
      private static const DRAW_INTER_PREV_PAGE:String = "requestDrawInterPrevPage";
      
      private static const DRAW_INTER_NEXT_PAGE:String = "requestDrawInterNextPage";
      
      private static const FINISH_INTERRUPT:String = "requestFinishInterrupt";
      
      private static const EVENT_START_INTERRUPT:String = "informationEventStartInterrupt";
      
      private static const EVENT_END_INTERRUPT:String = "informationEventEndInterrupt";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mInterruptCharacterInfo:Boolean = false;
      
      private var mInterruptFigureInfo:Boolean = false;
      
      private var mVICSVoiceGuidance:Boolean = false;
      
      private var mDSRSTTSAnnouncement:Boolean = false;
      
      private var mDSRSUplink:Boolean = false;
      
      private var mMenuData:BeaconDSRCID = new BeaconDSRCID();
      
      private var mMenuButton:BeaconDSRCID = new BeaconDSRCID();
      
      private var mInterButton:BeaconDSRCID = new BeaconDSRCID();
      
      private var mReceivedTime:BeaconDSRCID = new BeaconDSRCID();
      
      private var mCurrntRoadType:uint = 0;
      
      private var mCurrntDataType:uint = 0;
      
      private var mMsgNum:uint = 0;
      
      private var mDisplayTime:uint = 1;
      
      private var mVicsInterruptPriority:uint = 2;
      
      private var mexpTextTokenClearFlag:Boolean = false;
      
      private var mexpDiagTokenClearFlag:Boolean = false;
      
      private var mVicsInterruptActive:Boolean = false;
      
      public function BeaconDSRCHMI()
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
         this.connection.addEventListener(ConnectionEvent.BEACONHMI,this.BeaconHMIMessageHandler);
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
      
      public function requestAttributesInitialValue() : void
      {
         this.requestMenuData();
         this.requestMenuButton();
         this.requestInterButton();
         this.requestInterruptCharacterInfo();
         this.requestInterruptFigureInfo();
         this.requestVICSVoiceGuidance();
         this.requestDSRSTTSAnnouncement();
         this.requestDSRSUplink();
         this.requestDisplayTime();
         this.requestPubTextReceivedTime();
         this.requestPubDiagReceivedTime();
         this.requestExpTextReceivedTime();
         this.requestExpDiagReceivedTime();
         this.requestExpTextTokenClearFlag();
         this.requestExpDiagTokenClearFlag();
      }
      
      public function requestMenuData() : void
      {
         this.sendAttrRequest(MENU_DATA);
      }
      
      public function requestMenuButton() : void
      {
         this.sendAttrRequest(MENU_BUTTON);
      }
      
      public function requestInterButton() : void
      {
         this.sendAttrRequest(INTER_BUTTON);
      }
      
      public function requestInterruptCharacterInfo() : void
      {
         this.sendAttrRequest(INTERRUPT_CHARACTER_INFO);
      }
      
      public function requestInterruptFigureInfo() : void
      {
         this.sendAttrRequest(INTERRUPT_FIGURE_INFO);
      }
      
      public function requestVICSVoiceGuidance() : void
      {
         this.sendAttrRequest(VICS_VOICE_GUIDANCE);
      }
      
      public function requestDSRSTTSAnnouncement() : void
      {
         this.sendAttrRequest(DSRS_TTS_ANNOUNCEMENT);
      }
      
      public function requestDSRSUplink() : void
      {
         this.sendAttrRequest(DSRS_UPLINK);
      }
      
      public function requestDisplayTime() : void
      {
         this.sendAttrRequest(DISPLAY_TIME);
      }
      
      public function requestPubTextReceivedTime() : void
      {
         this.sendAttrRequest(PUB_TEXT_RECEIVED_TIME);
      }
      
      public function requestPubDiagReceivedTime() : void
      {
         this.sendAttrRequest(PUB_DIAG_RECEIVED_TIME);
      }
      
      public function requestExpTextReceivedTime() : void
      {
         this.sendAttrRequest(EXP_TEXT_RECIEVED_TIME);
      }
      
      public function requestExpDiagReceivedTime() : void
      {
         this.sendAttrRequest(EXP_DIAG_RECIEVED_TIME);
      }
      
      public function requestExpTextTokenClearFlag() : void
      {
         this.sendAttrRequest(EXP_TEXT_TOKEN_CLEAR_FLAG);
      }
      
      public function requestExpDiagTokenClearFlag() : void
      {
         this.sendAttrRequest(EXP_DIAG_TOKEN_CLEAR_FLAG);
      }
      
      public function requestSwitchInterruptCharacterInfo(active:Boolean) : void
      {
         this.sendCommand(SWITCH_INTERRUPT_CHARACTER_INFO,"Active",String(active));
      }
      
      public function requestSwitchInterruptFigureInfo(active:Boolean) : void
      {
         this.sendCommand(SWITCH_INTERRUPT_FIGURE_INFO,"Active",String(active));
      }
      
      public function requestSwitchVICSVoiceGuidance(active:Boolean) : void
      {
         this.sendCommand(SWITCH_VICS_VOICE_GUIDANCE,"Active",String(active));
      }
      
      public function requestSwitchDSRSTTSAnnouncement(active:Boolean) : void
      {
         this.sendCommand(SWITCH_DSRSTTS_ANNOUNCEMENT,"Active",String(active));
      }
      
      public function requestSwitchDSRSUplink(active:Boolean) : void
      {
         this.sendCommand(SWITCH_DSRS_UPLINK,"Active",String(active));
      }
      
      public function requestSwitchDisplayTime(dspTime:uint) : void
      {
         this.sendCommand(SWITCH_DISPLAY_TIME,"dspTime",String(dspTime));
      }
      
      public function requestStartMenu(type:int) : void
      {
         this.sendCommand(START_MENU,"type",String(type));
      }
      
      public function requestDrawMenuTopPageText() : void
      {
         this.sendCommandSimple(DRAW_MENU_TOP_PAGE_TEXT);
      }
      
      public function requestDrawMenuTopPageDiag() : void
      {
         this.sendCommandSimple(DRAW_MENU_TOP_PAGE_DIAG);
      }
      
      public function requestDrawMenuTextMsg(msgNum:uint) : void
      {
         this.sendCommand(DRAW_MENU_TEXT_MSG,"msgNum",String(msgNum));
      }
      
      public function requestDrawMenuDiagMsg(msgNum:uint) : void
      {
         this.sendCommand(DRAW_MENU_DIAG_MSG,"msgNum",String(msgNum));
      }
      
      public function requestDrawMenuNextPage() : void
      {
         this.sendCommandSimple(DRAW_MENU_NEXT_PAGE);
      }
      
      public function requestDrawMenuPrevPage() : void
      {
         this.sendCommandSimple(DRAW_MENU_PREV_PAGE);
      }
      
      public function requestStartMenuTTS() : void
      {
         this.sendCommandSimple(START_MENU_TTS);
      }
      
      public function requestStopMenuTTS() : void
      {
         this.sendCommandSimple(STOP_MENU_TTS);
      }
      
      public function requestFinishMenu() : void
      {
         this.sendCommandSimple(FINISH_MENU);
      }
      
      public function requestDrawInterTopPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_TOP_PAGE);
      }
      
      public function requestDrawInterPrevPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_PREV_PAGE);
      }
      
      public function requestDrawInterNextPage() : void
      {
         this.sendCommandSimple(DRAW_INTER_NEXT_PAGE);
      }
      
      public function requestFinishInterupt() : void
      {
         this.sendCommandSimple(FINISH_INTERRUPT);
      }
      
      public function setCurrentRoadType(roadType:uint) : void
      {
         this.mCurrntRoadType = roadType;
      }
      
      public function setCurrentDataType(dataType:uint) : void
      {
         this.mCurrntDataType = dataType;
      }
      
      public function setMsgNum(number:uint) : void
      {
         this.mMsgNum = number;
      }
      
      private function sendAttributeSubscribes() : void
      {
         this.sendSubscribe(MENU_DATA);
         this.sendSubscribe(MENU_BUTTON);
         this.sendSubscribe(INTER_BUTTON);
         this.sendSubscribe(INTERRUPT_CHARACTER_INFO);
         this.sendSubscribe(INTERRUPT_FIGURE_INFO);
         this.sendSubscribe(VICS_VOICE_GUIDANCE);
         this.sendSubscribe(DSRS_TTS_ANNOUNCEMENT);
         this.sendSubscribe(DSRS_UPLINK);
         this.sendSubscribe(DISPLAY_TIME);
         this.sendSubscribe(PUB_TEXT_RECEIVED_TIME);
         this.sendSubscribe(PUB_DIAG_RECEIVED_TIME);
         this.sendSubscribe(EXP_TEXT_RECIEVED_TIME);
         this.sendSubscribe(EXP_DIAG_RECIEVED_TIME);
         this.sendSubscribe(EXP_TEXT_TOKEN_CLEAR_FLAG);
         this.sendSubscribe(EXP_DIAG_TOKEN_CLEAR_FLAG);
         this.sendSubscribe(EVENT_START_INTERRUPT);
         this.sendSubscribe(EVENT_END_INTERRUPT);
      }
      
      private function BeaconHMIMessageHandler(e:ConnectionEvent) : void
      {
         var beaconData:Object = e.data;
         if(!beaconData.hasOwnProperty(DBUS_SERVICE_AVAILABLE))
         {
            if(beaconData.hasOwnProperty(INTERRUPT_CHARACTER_INFO))
            {
               this.mInterruptCharacterInfo = beaconData.InterruptCharacterInfo[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_INTERRUPT_CHARACTER_INFO));
            }
            else if(beaconData.hasOwnProperty(INTERRUPT_FIGURE_INFO))
            {
               this.mInterruptFigureInfo = beaconData.InterruptFigureInfo[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_INTERRUPT_FIGURE_INFO));
            }
            else if(beaconData.hasOwnProperty(VICS_VOICE_GUIDANCE))
            {
               this.mVICSVoiceGuidance = beaconData.VICSVoiceGuidance[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_VICS_VOICE_GUIDANCE));
            }
            else if(beaconData.hasOwnProperty(DSRS_TTS_ANNOUNCEMENT))
            {
               this.mDSRSTTSAnnouncement = beaconData.DSRSTTSAnnouncement[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_DSRSTTS_ANNOUNCEMENT));
            }
            else if(beaconData.hasOwnProperty(DSRS_UPLINK))
            {
               this.mDSRSUplink = beaconData.DSRSUplink[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_DSRS_UPLINK));
            }
            else if(beaconData.hasOwnProperty(DISPLAY_TIME))
            {
               this.mDisplayTime = beaconData.DisplayTime[1];
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.SWITCH_DISPLAY_TIME));
            }
            else if(beaconData.hasOwnProperty(MENU_DATA))
            {
               this.mMenuData = this.mMenuData.copyMenuDataState(beaconData.menuData[1]);
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.MENU_DATA));
            }
            else if(beaconData.hasOwnProperty(MENU_BUTTON))
            {
               this.mMenuButton = this.mMenuButton.copyButtonDataState(beaconData.menuButton[1]);
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.MENU_BUTTON));
            }
            else if(beaconData.hasOwnProperty(INTER_BUTTON))
            {
               this.mInterButton = this.mInterButton.copyButtonDataState(beaconData.interButton[1]);
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.INTER_BUTTON));
            }
            else if(beaconData.hasOwnProperty(EXP_TEXT_TOKEN_CLEAR_FLAG))
            {
               if(beaconData.expTextTokenClearFlag[1] != false)
               {
                  this.mReceivedTime = this.mReceivedTime.clearExpTextTime();
               }
               else
               {
                  this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.EXP_TEXT_RECIEVED_TIME));
               }
            }
            else if(beaconData.hasOwnProperty(EXP_DIAG_TOKEN_CLEAR_FLAG))
            {
               if(beaconData.expDiagTokenClearFlag[1] != false)
               {
                  this.mReceivedTime = this.mReceivedTime.clearExpDiagTime();
               }
               else
               {
                  this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.EXP_DIAG_RECIEVED_TIME));
               }
            }
            else if(beaconData.hasOwnProperty(PUB_TEXT_RECEIVED_TIME))
            {
               this.mReceivedTime = this.mReceivedTime.copyPubTextTime(beaconData.pubTextReceivedTime[1]);
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.PUB_TEXT_RECEIVED_TIME));
            }
            else if(beaconData.hasOwnProperty(PUB_DIAG_RECEIVED_TIME))
            {
               this.mReceivedTime = this.mReceivedTime.copyPubDiagTime(beaconData.pubDiagReceivedTime[1]);
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.PUB_DIAG_RECEIVED_TIME));
            }
            else if(beaconData.hasOwnProperty(EXP_TEXT_RECIEVED_TIME))
            {
               this.mReceivedTime = this.mReceivedTime.copyExpTextTime(beaconData.expTextReceivedTime[1]);
            }
            else if(beaconData.hasOwnProperty(EXP_DIAG_RECIEVED_TIME))
            {
               this.mReceivedTime = this.mReceivedTime.copyExpDiagTime(beaconData.expDiagReceivedTime[1]);
            }
            else if(beaconData.hasOwnProperty(EVENT_START_INTERRUPT))
            {
               this.mVicsInterruptPriority = beaconData.informationEventStartInterrupt;
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.EVENT_START_INTERRUPT,beaconData.informationEventStartInterrupt));
            }
            else if(beaconData.hasOwnProperty(EVENT_END_INTERRUPT))
            {
               this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.EVENT_END_INTERRUPT));
            }
            else if(!beaconData.hasOwnProperty(START_MENU))
            {
               if(!beaconData.hasOwnProperty(FINISH_MENU))
               {
                  if(beaconData.hasOwnProperty(DRAW_MENU_TOP_PAGE_TEXT))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_TOP_PAGE_TEXT,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_MENU_TOP_PAGE_DIAG))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_TOP_PAGE_DIAG,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_MENU_TEXT_MSG))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_TEXT_MSG,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_MENU_DIAG_MSG))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_DIAG_MSG,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_MENU_PREV_PAGE))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_PREV_PAGE,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_MENU_NEXT_PAGE))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_MENU_NEXT_PAGE,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_INTER_TOP_PAGE))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_INTER_TOP_PAGE,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_INTER_PREV_PAGE))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_INTER_PREV_PAGE,e.data));
                  }
                  else if(beaconData.hasOwnProperty(DRAW_INTER_NEXT_PAGE))
                  {
                     this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.DRAW_INTER_NEXT_PAGE,e.data));
                  }
               }
            }
         }
      }
      
      public function get InterruptCharacterInfo() : Boolean
      {
         return this.mInterruptCharacterInfo;
      }
      
      public function get InterruptFigureInfo() : Boolean
      {
         return this.mInterruptFigureInfo;
      }
      
      public function get VICSVoiceGuidance() : Boolean
      {
         return this.mVICSVoiceGuidance;
      }
      
      public function get DSRSTTSAnnouncement() : Boolean
      {
         return this.mDSRSTTSAnnouncement;
      }
      
      public function get DSRSUplink() : Boolean
      {
         return this.mDSRSUplink;
      }
      
      public function get MenuDataState() : BeaconDSRCID
      {
         return this.mMenuData;
      }
      
      public function get ButtonDataState() : BeaconDSRCID
      {
         return this.mMenuButton;
      }
      
      public function get InterButtonState() : BeaconDSRCID
      {
         return this.mInterButton;
      }
      
      public function get CurrentRoadType() : uint
      {
         return this.mCurrntRoadType;
      }
      
      public function get CurrentDataType() : uint
      {
         return this.mCurrntDataType;
      }
      
      public function get MsgNum() : uint
      {
         return this.mMsgNum;
      }
      
      public function get DisplayTime() : uint
      {
         return this.mDisplayTime;
      }
      
      public function get ReceivedTime() : BeaconDSRCID
      {
         return this.mReceivedTime;
      }
      
      public function get VicsInterruptActive() : Boolean
      {
         return this.mVicsInterruptActive;
      }
      
      public function setVicsInterruptActive(active:Boolean) : void
      {
         this.mVicsInterruptActive = active;
         this.dispatchEvent(new BeaconDSRCHMIEvent(BeaconDSRCHMIEvent.EVENT_INTERRUPT_ACTIVE));
      }
      
      public function get VicsInterruptPriority() : uint
      {
         return this.mVicsInterruptPriority;
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
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

