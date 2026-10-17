package peripheral
{
   import ancillary.Screens;
   import com.adobe.serialization.json.JSON;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.framework.template.ScreenGeneric;
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.AbstractScreen;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import core.enums.Layers;
   import core.enums.Market;
   import core.events.ExtensionEvent;
   import core.events.PopupManagerEvent;
   import core.events.StructureEvent;
   import core.template.ScreenContainer;
   import events.WidgetEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.IInteractiveObject;
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import peripheral.helper.StrbMapper;
   
   public class InspectionManager
   {
      
      private static var instance:InspectionManager;
      
      private static var _allowInstantiation:Boolean = false;
      
      private var _runningOnPCState:int;
      
      private const VERSION_STARTUP:String = "1.0";
      
      private const VERSION_SCREEN:String = "1.1";
      
      private const VERSION_BUTTON:String = "1.0";
      
      private const VERSION_ERROR:String = "1.0";
      
      private const SCREEN_STATE_ON:String = "ON";
      
      private const SCREEN_STATE_OFF:String = "OFF";
      
      private const SCREEN_REASON_REFRESH:String = "refresh";
      
      private const SCREEN_REASON_TIMEOUT:String = "timeout";
      
      private const INSIGHT_TOUCH_FILE_URL:String = "file:///fs/etfs/INSIGHT";
      
      private var _insightListening:Boolean;
      
      private var _insightReporting:Boolean;
      
      private var _insightWriteQueue:String;
      
      private var _fileErrorLog:String;
      
      private var _openFileMode:String;
      
      private var _writeToFileTimer:Timer;
      
      private var _dataFileURL:String;
      
      private var _dataFileStream:FileStream;
      
      private const QUEUE_CHR_LIMIT_BEFORE_WRITE:int = 5000;
      
      private const QUEUE_CHR_LIMIT_BEFORE_FLUSH_FOR_MEMORY:int = 1000000;
      
      private var _shouldRecordScreenEvents:Boolean;
      
      private var _shouldRecordWidgetEvents:Boolean;
      
      private var _shouldRecordMouseEvents:Boolean;
      
      private var _insightDataFileStatus:int;
      
      private const RESULT_UNKNOWN:int = -1;
      
      private const RESULT_SUCCESS:int = 0;
      
      private const RESULT_INACTIVE:int = 1;
      
      private const RESULT_NO_FILE_SUPPLIED:int = 2;
      
      private const RESULT_UNABLE_TO_FIND_SUPPLIED_FILE:int = 3;
      
      private const RESULT_UNABLE_TO_WRITE_TO_FILE:int = 4;
      
      private const INSIGHT_MSG_START:String = "hmiStartup";
      
      private const INSIGHT_MSG_SCREEN:String = "ScreenTransition";
      
      private const INSIGHT_MSG_BUTTON:String = "TouchScreenPress";
      
      private const INSIGHT_MSG_ERROR:String = "IOError";
      
      private var _automatedTestingActivated:Boolean = false;
      
      private var _screenLayerName:String = "";
      
      private var _translatablesArray:Array;
      
      private const MAX_DBUS_CHR_LENGTH:uint = 3000;
      
      private const DBUS_EMIT_DELAY:uint = 75;
      
      private var _packetTimer:Timer;
      
      private var _dbusReadyMsg:String = "";
      
      private var _packetCurrent:int = 1;
      
      private var _packetTotal:int = 0;
      
      public function InspectionManager()
      {
         super();
         if(!_allowInstantiation)
         {
            return;
         }
      }
      
      public static function getInstance() : InspectionManager
      {
         if(instance == null)
         {
            _allowInstantiation = true;
            instance = new InspectionManager();
            _allowInstantiation = false;
         }
         return instance;
      }
      
      public static function checkSTRBusage(target:TextField, composition:*) : void
      {
         var par:DisplayObjectContainer = null;
         var linkageName:String = null;
         var whileCount:int = 0;
         var dcIndex:int = 0;
         if(!StrbMapper._shouldWriteMap || instance == null)
         {
            return;
         }
         if(composition is uint == false)
         {
            composition = 12648430;
         }
         var targetName:String = "Unknown";
         var linkagePath:String = "Unknown";
         var screenGraphicName:String = "Unknown";
         var layerName:String = "Unknown";
         if(target != null)
         {
            targetName = target.name;
            if(target.parent != null)
            {
               par = target.parent;
               linkageName = getQualifiedClassName(par);
               linkagePath = "";
               whileCount = 0;
               while(linkageName.indexOf("flash.display") >= 0)
               {
                  linkagePath = linkagePath + "." + par.name;
                  if(!(par != null && par.parent != null && par.parent.name != "root1" && par.parent != par.stage))
                  {
                     linkagePath = "Unknown_NullParentInDom";
                     break;
                  }
                  par = par.parent;
                  linkageName = getQualifiedClassName(par);
                  if(++whileCount > 20)
                  {
                     linkagePath = "Unknown_DomTooBig";
                     break;
                  }
               }
               linkageName = linkageName.substr(linkageName.lastIndexOf(".") + 1);
               dcIndex = linkageName.indexOf("::");
               if(dcIndex >= 0)
               {
                  linkageName = linkageName.substring(dcIndex + 2);
               }
               linkagePath = linkageName + linkagePath;
            }
            layerName = instance.determineLayerName(target);
         }
         if(layerName != null)
         {
            screenGraphicName = instance.getScreenGraphicName(layerName);
         }
         StrbMapper.mapStrbUsage(screenGraphicName,linkagePath,targetName,composition as uint);
      }
      
      private static function log(traceStr:String) : void
      {
      }
      
      public function init() : void
      {
         this._runningOnPCState = -1;
         log("init: runningOnPC = " + this.runningOnPC);
         this.onInsightStart();
         Framework.structure.addEventListener(StructureEvent.GOTO,this.onStructureEvent);
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onStructureEvent);
         Framework.structure.addEventListener(ExtensionEvent.EXTENSION,this.onExtensionEvent);
         Framework.popupManager.addEventListener(PopupManagerEvent.ACTIVE,this.onPopupEvent,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.CLOSE,this.onPopupEvent,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.REFRESH,this.onPopupEvent,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.SHOW,this.onPopupEvent,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.TIMEOUT,this.onPopupEvent,false,0,true);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.INSIGHT_START,this.onInsightStart);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.AUTOMATION_TEST_ACTIVATE,this.onAutomationTestActivate);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.AUTOMATION_TEST_DEACTIVATE,this.onAutomationTestDeActivate);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.AUTOMATION_INSPECT,this.onAutomationInspect);
         Peripheral.hmiRequest.addEventListener(HMIRequestEvent.GOTO_SCREEN,this.onGotoScreen,false,0,true);
         this.setupSTRBChecking();
      }
      
      private function get runningOnPC() : Boolean
      {
         if(this._runningOnPCState == -1)
         {
            this._runningOnPCState = File.applicationDirectory.nativePath.charAt(1) == ":" ? 1 : 0;
         }
         return this._runningOnPCState == 1;
      }
      
      private function onInsightStart(e:HMIRequestEvent = null) : void
      {
         var insightTouchFile:File = null;
         var configFileStream:FileStream = null;
         var config:String = null;
         this._insightReporting = true;
         this._openFileMode = FileMode.WRITE;
         this._shouldRecordScreenEvents = true;
         this._shouldRecordWidgetEvents = false;
         this._shouldRecordMouseEvents = true;
         if(this.runningOnPC)
         {
            log("onInsightStart: runningOnPC = " + this.runningOnPC + ", so _insightReporting = " + this._insightReporting);
         }
         else
         {
            insightTouchFile = new File(this.INSIGHT_TOUCH_FILE_URL);
            if(insightTouchFile.exists)
            {
               Framework.enableInsight = true;
               log("onInsightStart: found " + this.INSIGHT_TOUCH_FILE_URL + ", so setting up Insight Support with FileMode:" + this._openFileMode);
               configFileStream = new FileStream();
               configFileStream.open(insightTouchFile,FileMode.READ);
               config = configFileStream.readUTFBytes(configFileStream.bytesAvailable);
               if(config != null)
               {
                  if(config.length == 4)
                  {
                     if(config.charAt(0) == "1")
                     {
                        this._openFileMode = FileMode.APPEND;
                     }
                     this._shouldRecordScreenEvents = config.charAt(1) == "1";
                     this._shouldRecordWidgetEvents = config.charAt(2) == "1";
                     this._shouldRecordMouseEvents = config.charAt(3) == "1";
                     log("onInsightStart: found valid config options! (FileMode = " + this._openFileMode + ", ScreenEvents = " + this._shouldRecordScreenEvents + ", WidgetEvents = " + this._shouldRecordWidgetEvents + ", MouseEvents = " + this._shouldRecordMouseEvents + ")");
                  }
                  else if(config.length > 0)
                  {
                     log("onInsightStart: found INVALID config options! (" + config + ")");
                  }
               }
            }
            else
            {
               Framework.enableInsight = false;
               log("onInsightStart: no file at " + this.INSIGHT_TOUCH_FILE_URL + ", so tearing down Insight Support");
               this._insightReporting = false;
            }
         }
         if(this._insightReporting)
         {
            this.setupInsight();
            this.startDataRecording(e);
            this.activateInsightListeners();
         }
         else
         {
            this.tearDownInsight();
         }
         if(e != null)
         {
            Peripheral.hmiRequest.insightReturnResult(e.type,this._insightDataFileStatus);
         }
      }
      
      private function startDataRecording(e:HMIRequestEvent) : void
      {
         var reason:String = "Startup";
         if(e != null)
         {
            if(this._insightListening)
            {
               reason = "Already Running";
            }
            else
            {
               reason = "Started on Request";
            }
            this.cleanUpFileStream();
            log("startDataRecording: e.mData = " + e.mData);
            if(e.mData != null && e.mData is String)
            {
               this._dataFileURL = e.mData as String;
            }
            else
            {
               log("startDataRecording: no URL supplied!");
            }
         }
         var startReason:String = "\"Reason\":\"" + reason + "\"";
         this._insightDataFileStatus = this.writeEventToQueue(this.INSIGHT_MSG_START,startReason,this.VERSION_STARTUP,true);
         log("startDataRecording: reason = " + reason + ", _insightDataFileStatus = " + this._insightDataFileStatus);
      }
      
      private function setupInsight() : void
      {
         if(this._writeToFileTimer == null)
         {
            log("setupInsight: creating initial Insight elements...");
            this._insightDataFileStatus = this.RESULT_UNKNOWN;
            this.clearCache();
            this._writeToFileTimer = new Timer(5000,1);
            this._writeToFileTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onWriteToFileTimer);
         }
         else
         {
            log("setupInsight: initial Insight elements already exist!  NO-TO-DO!");
         }
      }
      
      private function activateInsightListeners() : void
      {
         if(this._insightListening)
         {
            log("activateInsightListeners: _insightListening = " + this._insightListening + ", so nothing to do here!");
            return;
         }
         var mainStage:Stage = this.findStage;
         if(mainStage == null)
         {
            log("activateInsightListeners: STAGE IS NULL!!! Cannot set up Insight Engine listeners!");
         }
         else
         {
            if(this._shouldRecordWidgetEvents)
            {
               log("activateInsightListeners: _shouldRecordWidgetEvents = " + this._shouldRecordWidgetEvents + ", so adding WidgetEvent listeners...");
               mainStage.addEventListener(WidgetEvent.CLICK,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.PRESS,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.RELEASE,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.LONG_PRESS,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.AUTO_CLICK,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.SELECT,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.POSITION,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.HORIZONTAL_POSITION,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.VERTICAL_POSITION,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.GRAB,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.LENGTH,this.onWidgetEvent);
               mainStage.addEventListener(WidgetEvent.PAGE_SIZE,this.onWidgetEvent);
            }
            if(this._shouldRecordMouseEvents)
            {
               log("activateInsightListeners: _shouldRecordMouseEvents = " + this._shouldRecordMouseEvents + ", so adding MouseEvent listeners...");
               mainStage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
               mainStage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
               mainStage.addEventListener(MouseEvent.CLICK,this.onMouseEvent);
            }
            this._insightListening = true;
         }
      }
      
      private function get findStage() : Stage
      {
         return (Framework.screens.autoTestView[Layers.MIDDLE] as DisplayObjectContainer).stage;
      }
      
      private function tearDownInsight() : void
      {
         if(!this._insightListening)
         {
            log("tearDownInsight: _insightActive = " + this._insightListening + ", so nothing to do here!");
            return;
         }
         this._insightDataFileStatus = this.RESULT_INACTIVE;
         this.clearCache();
         this.cleanUpFileStream();
         var mainStage:Stage = this.findStage;
         if(mainStage == null)
         {
            log("tearDownInsight: STAGE IS NULL!!! Cannot tear down Insight Engine listeners!");
         }
         else
         {
            log("tearDownInsight: removing WidgetEvent listeners...");
            mainStage.removeEventListener(WidgetEvent.CLICK,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.PRESS,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.RELEASE,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.LONG_PRESS,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.AUTO_CLICK,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.SELECT,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.POSITION,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.HORIZONTAL_POSITION,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.VERTICAL_POSITION,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.GRAB,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.LENGTH,this.onWidgetEvent);
            mainStage.removeEventListener(WidgetEvent.PAGE_SIZE,this.onWidgetEvent);
            mainStage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
            mainStage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
            mainStage.removeEventListener(MouseEvent.CLICK,this.onMouseEvent);
            if(this._writeToFileTimer != null)
            {
               this._writeToFileTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onWriteToFileTimer);
               this._writeToFileTimer = null;
            }
            this._insightListening = false;
         }
      }
      
      private function onAutomationTestActivate(e:HMIRequestEvent) : void
      {
         this._automatedTestingActivated = true;
         this.handleAutomatedTestingStatus();
      }
      
      private function onAutomationTestDeActivate(e:HMIRequestEvent) : void
      {
         this._automatedTestingActivated = false;
         this.handleAutomatedTestingStatus();
      }
      
      private function handleAutomatedTestingStatus() : void
      {
         log("handleAutomatedTestingStatus: activated = " + this._automatedTestingActivated);
         if(!this._automatedTestingActivated)
         {
            log("handleAutomatedTestingStatus: cleaning up support...");
            if(this._packetTimer != null)
            {
               log("handleAutomatedTestingStatus: stopping _packetTimer, removing listener, and cleaning it up");
               this._packetTimer.stop();
               this._packetTimer.removeEventListener(TimerEvent.TIMER,this.onSendPacket);
               this._packetTimer = null;
            }
            this._screenLayerName = "";
            this._dbusReadyMsg = "";
            this._packetCurrent = 1;
            this._packetTotal = 0;
            this._translatablesArray = null;
         }
      }
      
      private function onStructureEvent(e:StructureEvent) : void
      {
         this.onScreenEvent(e.type,e.branch);
      }
      
      private function onExtensionEvent(e:ExtensionEvent) : void
      {
         this.onScreenEvent(e.type,null,Layers.MIDDLE);
      }
      
      private function onPopupEvent(e:PopupManagerEvent) : void
      {
         if(this._automatedTestingActivated)
         {
            Peripheral.hmiRequest.emitScreenStatus(e.type,e.address);
         }
         if(this._shouldRecordScreenEvents)
         {
            if(e.type == PopupManagerEvent.CLOSE && e.vars != null && e.vars.id != null && e.vars.id is Number && Number(e.vars.id) < 0)
            {
               log("onPopupEvent: " + e.type + ", e.vars.id = " + e.vars.id + ", so not reporting this blind-closing of popup to Insight");
            }
            else
            {
               this.recordScreenEvent(e.type,e.address,Layers.POPUPS);
            }
         }
      }
      
      private function onScreenEvent(event:String, screen:String = null, domain:String = null) : void
      {
         if(!this.packetsNeedToBeSent && this._translatablesArray != null)
         {
            log("onScreenEvent: packetsNeedToBeSent = " + this.packetsNeedToBeSent + " with _translatablesArray = " + this._translatablesArray + ", so nulling out that pointer now");
            this._translatablesArray = null;
         }
         var currentScreen:String = Framework.structure.currentBranch;
         if(this._automatedTestingActivated)
         {
            Peripheral.hmiRequest.emitScreenStatus(event,currentScreen);
         }
         if(this._shouldRecordScreenEvents)
         {
            if(screen != null)
            {
               currentScreen = screen;
            }
            if(domain == null)
            {
               domain = this.findDomainByScreenGraphic(currentScreen);
            }
            this.recordScreenEvent(event,currentScreen,domain);
         }
      }
      
      private function get timestamp() : Number
      {
         var now:Date = new Date();
         return now.getTime();
      }
      
      private function recordScreenEvent(event:String, currentScreen:String, domain:String = null) : void
      {
         var screenIdentifier:String = null;
         if(!this._insightReporting)
         {
            return;
         }
         if(event == StructureEvent.GOTO)
         {
            return;
         }
         var layerName:String = "";
         if(domain != null && domain != "")
         {
            layerName = "\"LayerName\":\"" + domain + "\", ";
         }
         if(currentScreen != null && currentScreen.lastIndexOf(".swf") != -1)
         {
            screenIdentifier = currentScreen;
         }
         if(screenIdentifier == null)
         {
            screenIdentifier = this.getScreenGraphicName(domain);
            if(screenIdentifier == domain)
            {
               screenIdentifier = null;
            }
         }
         if(screenIdentifier == null && currentScreen != null && currentScreen.length > 0)
         {
            screenIdentifier = Framework.structure.getAddress(currentScreen);
            if(screenIdentifier.lastIndexOf(".swf") == -1)
            {
               screenIdentifier = null;
            }
         }
         var screenName:String = "";
         if(screenIdentifier != null)
         {
            screenName = "\"ScreenName\":\"" + screenIdentifier + "\", ";
         }
         var insightState:String = this.SCREEN_STATE_ON;
         if(event == PopupManagerEvent.CLOSE)
         {
            insightState = this.SCREEN_STATE_OFF;
         }
         var msyType:String = this.INSIGHT_MSG_SCREEN;
         var msgData:String = layerName + screenName + "\"State\":\"" + insightState + "\"";
         var msgVersion:String = this.VERSION_SCREEN;
         if(domain == Layers.POPUPS)
         {
            msgData += ", \"FullScreen\":\"" + this.isAnyLayerHidden + "\"";
         }
         if(event == PopupManagerEvent.REFRESH || event == ExtensionEvent.EXTENSION)
         {
            msgData += ", \"Reason\":\"" + this.SCREEN_REASON_REFRESH + "\"";
         }
         else if(event == PopupManagerEvent.TIMEOUT)
         {
            msgData += ", \"Reason\":\"" + this.SCREEN_REASON_TIMEOUT + "\"";
         }
         this.writeEventToQueue(msyType,msgData,msgVersion);
      }
      
      private function onWidgetEvent(event:WidgetEvent) : void
      {
         var button:DisplayObject = null;
         if(!this._insightReporting)
         {
            return;
         }
         if(event.target is Stage)
         {
            if(event.data != null && event.data is DisplayObject)
            {
               button = event.data as DisplayObject;
            }
            else
            {
               log("onWidgetEvent: event target the Stage, and the Data (" + event.data + ") is not a DisplayObject!");
            }
         }
         else if(event.target is DisplayObject)
         {
            button = event.target as DisplayObject;
         }
         else
         {
            log("onWidgetEvent: event target is neither the Stage or a DisplayObject!");
         }
         this.onButtonEvent(button,event.type);
      }
      
      private function onMouseEvent(event:MouseEvent) : void
      {
         var button:DisplayObject = null;
         if(!this._insightReporting)
         {
            return;
         }
         if(event.target is DisplayObject)
         {
            button = event.target as DisplayObject;
         }
         else
         {
            log("onMouseEvent: event target not a DisplayObject!");
         }
         this.onButtonEvent(button,event.type);
      }
      
      private function onButtonEvent(button:DisplayObject, action:String) : void
      {
         var layerName:String = null;
         var buttonMovieClip:MovieClip = null;
         if(!this._insightReporting)
         {
            return;
         }
         var screenGraphicName:String = "CURRENT-SWF";
         var keyType:String = "NOT-AVAILABLE";
         var keyId:String = "NOT-AVAILABLE";
         var keyLabel:String = "\"TEXT\":\"LABEL-NOT-AVAILABLE\"";
         var frameLabel:String = "";
         var interactiveObj:Boolean = false;
         var enabled:String = "";
         var selected:String = "";
         if(button != null)
         {
            layerName = this.determineLayerName(button);
            if(layerName != null)
            {
               screenGraphicName = this.getScreenGraphicName(layerName);
            }
            keyType = getQualifiedClassName(button);
            keyId = button.name;
            keyLabel = com.adobe.serialization.json.JSON.encode(this.findLabelText(button));
            if(button is MovieClip)
            {
               buttonMovieClip = button as MovieClip;
               if(buttonMovieClip.currentFrameLabel != null && buttonMovieClip.currentFrameLabel.length > 0)
               {
                  frameLabel = "\"FrameLabel\":\"" + buttonMovieClip.currentFrameLabel + "\", ";
               }
            }
            interactiveObj = button.hasEventListener(MouseEvent.CLICK) || button.hasEventListener(MouseEvent.MOUSE_DOWN) || button.hasEventListener(MouseEvent.MOUSE_UP);
            if(button.hasOwnProperty("mEnabled") == true)
            {
               enabled = "\"Enabled\":\"" + button["mEnabled"] + "\", ";
            }
            if(button.hasOwnProperty("mActive") == true)
            {
               selected = "\"Selected\":\"" + button["mActive"] + "\", ";
            }
         }
         if(layerName == null)
         {
            layerName = "UNDETERMINED";
         }
         var buttonEvent:String = "\"LayerName\":\"" + layerName + "\", \"ScreenName\":\"" + screenGraphicName + "\", \"KeyType\":\"" + keyType + "\", \"KeyId\":\"" + keyId + "\", \"KeyLabel\":" + keyLabel + ", " + frameLabel + "\"InteractiveObject\":\"" + interactiveObj + "\", " + enabled + selected + "\"Action\":\"" + action + "\"";
         this.writeEventToQueue(this.INSIGHT_MSG_BUTTON,buttonEvent,this.VERSION_BUTTON);
      }
      
      private function getScreenGraphicName(layerName:String) : String
      {
         var layerScreenContainer:ScreenContainer = null;
         var screenGraphicName:String = layerName;
         if(layerName != null)
         {
            layerScreenContainer = Framework.screens.getScreenContainer(layerName);
            if(layerScreenContainer != null)
            {
               screenGraphicName = layerScreenContainer.address;
            }
         }
         return screenGraphicName;
      }
      
      private function findDomainByScreenGraphic(currentScreen:String) : String
      {
         var layer:DisplayObject = null;
         for each(layer in Framework.screens.autoTestView)
         {
            if(this.isScreenGraphicLoadedInDomain(currentScreen,layer.name))
            {
               return layer.name;
            }
         }
         return null;
      }
      
      private function isScreenGraphicLoadedInDomain(currentScreen:String, domainToCheck:String) : Boolean
      {
         var potentialDomainCurrentGraphicName:String = this.getScreenGraphicName(domainToCheck);
         return currentScreen == potentialDomainCurrentGraphicName;
      }
      
      private function get isAnyLayerHidden() : Boolean
      {
         var layer:DisplayObject = null;
         for each(layer in Framework.screens.autoTestView)
         {
            if(layer.visible == false)
            {
               return true;
            }
         }
         return false;
      }
      
      private function determineLayerName(obj:DisplayObject) : String
      {
         while(obj != null && obj.parent != null && obj.parent.name != "root1" && obj.parent != obj.stage)
         {
            obj = obj.parent;
         }
         if(obj != null)
         {
            return obj.name;
         }
         return null;
      }
      
      private function getDOMPath(obj:DisplayObject, relativeToThisObjName:String = "root1") : String
      {
         var p:DisplayObjectContainer = obj.parent;
         var instancePath:String = obj.name;
         while(obj.name != relativeToThisObjName && p != null && p.parent != null && p.parent.name != relativeToThisObjName && p.parent != obj.stage)
         {
            p = p.parent;
            instancePath = p.name + "." + instancePath;
         }
         return instancePath;
      }
      
      private function findLabelText(obj:DisplayObject, masterInstanceName:String = null) : Array
      {
         var objAsTF:TextField = null;
         var objPath:String = null;
         var content:Object = null;
         var objAsParent:DisplayObjectContainer = null;
         var i:int = 0;
         var child:DisplayObject = null;
         var childResults:Array = null;
         var childResultCount:int = 0;
         var j:int = 0;
         var foundText:Array = new Array();
         if(masterInstanceName == null)
         {
            masterInstanceName = obj.name;
         }
         if(obj is TextField)
         {
            objAsTF = obj as TextField;
            if(objAsTF.text.length > 0 && objAsTF.text != "\r" && objAsTF.text != "\n" && objAsTF.text != "\t")
            {
               objPath = this.getDOMPath(objAsTF,masterInstanceName);
               content = new Object();
               content[objPath] = objAsTF.text;
               foundText.push(content);
            }
         }
         if(obj is DisplayObjectContainer)
         {
            objAsParent = obj as DisplayObjectContainer;
            for(i = 0; i < objAsParent.numChildren; i++)
            {
               child = objAsParent.getChildAt(i);
               if(child.visible)
               {
                  childResults = this.findLabelText(child,masterInstanceName);
                  childResultCount = int(childResults.length);
                  for(j = 0; j < childResultCount; j++)
                  {
                     foundText.push(childResults[j]);
                  }
               }
            }
         }
         return foundText;
      }
      
      private function clearCache() : void
      {
         if(this._insightWriteQueue != null && this._fileErrorLog != null)
         {
            log("clearCache: captured event data (length = " + this._insightWriteQueue.length + ") is now cleared (error log length = " + this._fileErrorLog.length + ")");
         }
         this._insightWriteQueue = "";
         this._fileErrorLog = "";
      }
      
      private function formatEvent(EventID:String, data:String, version:String) : String
      {
         return "{\"EventID\":\"" + EventID + "\", \"Timestamp\":" + this.timestamp + ", \"Data\":{" + data + "}, \"Version\":\"" + version + "\"}\n";
      }
      
      private function writeEventToQueue(eventType:String, eventData:String, version:String, writeImmediately:Boolean = false) : int
      {
         var formattedEvent:String = this.formatEvent(eventType,eventData,version);
         this._insightWriteQueue += formattedEvent;
         log("writeEventToQueue: " + formattedEvent);
         if(writeImmediately)
         {
            log("writeEventToQueue: writeImmediately = " + writeImmediately + " with Queue Length = " + this._insightWriteQueue.length + ", so writing to file");
            return this.onWriteToFileTimer();
         }
         this.handleWriteToQueue();
         return this._insightDataFileStatus;
      }
      
      private function handleWriteToQueue() : void
      {
         if(this._insightWriteQueue.length > this.QUEUE_CHR_LIMIT_BEFORE_WRITE)
         {
            log("handleWriteToQueue: Queue Length = " + this._insightWriteQueue.length + ", so writing to file");
            this.onWriteToFileTimer();
         }
         else
         {
            log("handleWriteToQueue: Queue Length = " + this._insightWriteQueue.length + ", so resetting timer");
            this.resetWriteToFileTimer();
         }
      }
      
      private function resetWriteToFileTimer() : void
      {
         this._writeToFileTimer.reset();
         this._writeToFileTimer.start();
      }
      
      private function onWriteToFileTimer(e:TimerEvent = null) : int
      {
         if(e == null)
         {
            log("onWriteToFileTimer: MANDATORY-WRITE requested (queue length = " + this._insightWriteQueue.length + ")");
         }
         else
         {
            log("onWriteToFileTimer: TIMEOUT occurred (queue length = " + this._insightWriteQueue.length + ")");
         }
         var writeResult:int = this._insightDataFileStatus;
         if(this._writeToFileTimer.running)
         {
            log("onWriteToFileTimer: _writeToFileTimer is running, so stopping now");
            this._writeToFileTimer.stop();
         }
         if(this._insightWriteQueue.length > 0)
         {
            log("onWriteToFileTimer: Writing " + this._insightWriteQueue.length + " characters to file...");
            writeResult = this.writeEventToFile(this._insightWriteQueue);
            if(writeResult == this.RESULT_SUCCESS)
            {
               log("onWriteToFileTimer: write successful (" + writeResult + "), so clearing cache");
               this.clearCache();
            }
            else if(writeResult == this.RESULT_UNABLE_TO_WRITE_TO_FILE)
            {
               this.recordDataLostAndClearQueue("Unable to write to file");
            }
            else if(this._insightWriteQueue.length > this.QUEUE_CHR_LIMIT_BEFORE_FLUSH_FOR_MEMORY)
            {
               this.recordDataLostAndClearQueue("Excessive character queue length (writeResult = " + writeResult + ")");
            }
         }
         else
         {
            log("onWriteToFileTimer: _insightWriteQueue.length = " + this._insightWriteQueue.length + ", so no need to write at this time");
         }
         return writeResult;
      }
      
      private function recordDataLostAndClearQueue(reason:String) : void
      {
         log("recordDataLostAndClearQueue: " + reason + "! Logging error and clearing _insightWriteQueue (" + this._insightWriteQueue.length + " characters) to prevent memory gains from retained data");
         var details:String = "\"Details\":\"" + reason + "\", \"CharactersLost\":\"" + this._insightWriteQueue.length + "\"";
         var errorChrLimit:int = 5000;
         if(this._fileErrorLog.length < errorChrLimit)
         {
            this._fileErrorLog += this.formatEvent(this.INSIGHT_MSG_ERROR,details,this.VERSION_ERROR);
         }
         else
         {
            log("recordDataLostAndClearQueue: we\'re over " + errorChrLimit + " in the error file now, so you just don\'t get new errors (sorry)");
         }
         this._insightWriteQueue = "";
      }
      
      private function writeEventToFile(formattedData:String) : int
      {
         if(this.runningOnPC && this._dataFileURL == null)
         {
            log("writeEventToFile: runningOnPC = " + this.runningOnPC + ", so pretend we wrote the file");
            return this.RESULT_SUCCESS;
         }
         if(!this._insightReporting)
         {
            log("writeEventQueueToFile: insightReporting = " + this._insightReporting + ", so no-to-do! (formattedEvent = " + formattedData + ")");
            return this.RESULT_INACTIVE;
         }
         if(formattedData == null)
         {
            log("writeEventQueueToFile: formattedData was null! Returning " + this.RESULT_UNKNOWN);
            return this.RESULT_UNKNOWN;
         }
         if(formattedData.length <= 0)
         {
            log("writeEventQueueToFile: formattedData.length = " + formattedData.length + ", so taking no action and returning " + this.RESULT_UNKNOWN);
            return this.RESULT_UNKNOWN;
         }
         if(this._dataFileURL == null)
         {
            log("writeEventQueueToFile: _dataFileURL = " + this._dataFileURL + ", so we have no where to write the data to");
            return this.RESULT_NO_FILE_SUPPLIED;
         }
         this.flushFileStream();
         if(this._dataFileStream != null)
         {
            log("writeEventQueueToFile: adding " + formattedData.length + " characters into " + this._dataFileURL + "\n" + formattedData);
            this._dataFileStream.writeUTFBytes(this._fileErrorLog + formattedData);
            this._dataFileStream.close();
            log("writeEventQueueToFile: successful! (hopefully)");
            return this.RESULT_SUCCESS;
         }
         log("writeEventQueueToFile: no _dataFileStream!  This is an error!");
         return this.RESULT_UNABLE_TO_WRITE_TO_FILE;
      }
      
      private function flushFileStream() : void
      {
         log("flushFileStream: cleaning up previous _dataFileStream before opening it again...");
         this.cleanUpFileStream();
         this.createFileStream();
      }
      
      private function createFileStream() : void
      {
         var dataFile:File = null;
         if(this._dataFileStream == null)
         {
            if(this.runningOnPC)
            {
               dataFile = new File(File.applicationDirectory.nativePath).resolvePath(this._dataFileURL);
            }
            else
            {
               dataFile = new File("file://" + this._dataFileURL);
            }
            if(dataFile.exists == false)
            {
               log("createFileStream: dataFile = " + dataFile + " for " + this._dataFileURL + " does not exist!");
               this._insightDataFileStatus = this.RESULT_UNABLE_TO_FIND_SUPPLIED_FILE;
               return;
            }
            this._dataFileStream = new FileStream();
            log("createFileStream: preparing _dataFileStream for " + this._dataFileURL + ", with openAsync for " + this._openFileMode);
            this._dataFileStream.addEventListener(IOErrorEvent.IO_ERROR,this.onWriteError);
            this._dataFileStream.addEventListener(Event.CLOSE,this.onWriteComplete);
            this._dataFileStream.openAsync(dataFile,this._openFileMode);
            log("createFileStream: started _dataFileStream for " + this._dataFileURL);
         }
         else
         {
            log("createFileStream: previous _dataFileStream exists for " + this._dataFileURL + "!");
         }
      }
      
      private function cleanUpFileStream() : void
      {
         if(this._dataFileStream != null)
         {
            this._dataFileStream.removeEventListener(IOErrorEvent.IO_ERROR,this.onWriteError);
            this._dataFileStream.removeEventListener(Event.CLOSE,this.onWriteComplete);
            try
            {
               this._dataFileStream.close();
               log("cleanUpFileStream: closed _dataFileStream for " + this._dataFileURL);
            }
            catch(e:Error)
            {
               log("cleanUpFileStream: must have already been closed, despite being not-null!");
            }
            this._dataFileStream = null;
         }
         else
         {
            log("cleanUpFileStream: _dataFileStream is null (_dataFileURL = " + this._dataFileURL + "), so hopefully no-to-do here");
         }
      }
      
      private function onWriteComplete(e:Event) : void
      {
         this._insightDataFileStatus = this.RESULT_SUCCESS;
         log("onWriteComplete: _insightDataFileStatus = " + this._insightDataFileStatus + "; flushing file now so Insight is primed for next write session...");
         this.flushFileStream();
      }
      
      private function onWriteError(e:IOErrorEvent = null) : void
      {
         this._insightDataFileStatus = this.RESULT_UNABLE_TO_WRITE_TO_FILE;
         log("onWriteError: e = " + e + ", so set _insightDataFileStatus = " + this._insightDataFileStatus);
      }
      
      private function setupSTRBChecking() : void
      {
         var projectID:String = "unknown";
         if(Peripheral.vehConfig)
         {
            projectID = Peripheral.vehConfig.vehicleBrand + "_" + Peripheral.vehConfig.vehicleLine + "_" + Peripheral.vehConfig.variantMarket;
         }
         StrbMapper.setupMapper(this.runningOnPC,projectID);
      }
      
      private function onAutomationInspect(e:HMIRequestEvent) : void
      {
         var screenInspectResults:Object;
         var filepath:String = null;
         var inspectionFileStream:FileStream = null;
         var layer:DisplayObject = null;
         var inspectionFile:File = null;
         var fileMode:String = null;
         var name:String = null;
         if(this.packetsNeedToBeSent)
         {
            log("onAutomationInspect: inspection already in progress! (packetsNeedToBeSent = " + this.packetsNeedToBeSent + ")");
            return;
         }
         if(e.mData != null && e.mData is String)
         {
            filepath = e.mData as String;
         }
         if(filepath != null)
         {
            if(this.runningOnPC)
            {
               inspectionFile = new File(File.applicationDirectory.nativePath).resolvePath(filepath);
            }
            else
            {
               inspectionFile = new File("file://" + filepath);
            }
            if(inspectionFile.exists == false)
            {
               log("onAutomationInspect: inspectionFile.nativePath = " + inspectionFile.nativePath + " for " + filepath + ", and does not exist! NO-TO-DO!");
               return;
            }
            inspectionFileStream = new FileStream();
            fileMode = FileMode.WRITE;
            log("onAutomationInspect: preparing inspectionFileStream for " + inspectionFile + ", with open for " + fileMode);
            inspectionFileStream.open(inspectionFile,fileMode);
            log("onAutomationInspect: started inspectionFileStream for " + inspectionFile);
         }
         log("onAutomationInspect: starting new inspection...");
         screenInspectResults = new Object();
         for each(layer in Framework.screens.autoTestView)
         {
            if(layer.hasOwnProperty("name"))
            {
               name = layer["name"];
               screenInspectResults[name] = this.inspectLayer(name);
            }
            else
            {
               log("onAutomationInspect: could not find a proper Sprite name on " + layer + ", so it cannot be inspected!! File a ticket on this!!!");
            }
         }
         if(inspectionFileStream != null)
         {
            log("onAutomationInspect: writing inspection results to file...");
            inspectionFileStream.writeUTFBytes(com.adobe.serialization.json.JSON.encode(screenInspectResults));
            log("onAutomationInspect: results written; closing file");
            try
            {
               inspectionFileStream.close();
            }
            catch(e:Error)
            {
               log("onAutomationInspect: must have already been closed somehow");
            }
         }
         else
         {
            this.emitScreenInspectResults(screenInspectResults);
         }
      }
      
      private function inspectLayer(layerName:String) : Object
      {
         this._screenLayerName = layerName;
         this._translatablesArray = null;
         log("inspectLayer: about to inspect " + this._screenLayerName + "...");
         var layerToInspect:DisplayObjectContainer = Framework.screens.autoTestView[this._screenLayerName] as DisplayObjectContainer;
         var inspectionResults:Object = this.inspect(layerToInspect);
         if(inspectionResults == null)
         {
            inspectionResults = new Object();
            if(layerToInspect == null)
            {
               log("inspectLayer: " + this._screenLayerName + " is null!  How did this happen?! (We created an inspectionResults object for it all the same...)");
            }
            else if(layerToInspect.visible == false)
            {
               log("inspectLayer: " + this._screenLayerName + " is not visible, so wasn\'t inspected, hence we created a blank inspectionResults object for it");
            }
            else
            {
               log("inspectLayer: " + this._screenLayerName + " has some unknown issue when inspecting it (NOT GOOD!), so created a blank inspectionResults object for it");
            }
         }
         var screenVars:Object = this.screenVarsForInspectedLayer;
         if(screenVars != null)
         {
            inspectionResults.sV = screenVars;
            log("inspectLayer: found screenVars = " + com.adobe.serialization.json.JSON.encode(inspectionResults.sV));
         }
         var swfAddress:String = this.getScreenGraphicName(this._screenLayerName);
         if(swfAddress != null)
         {
            inspectionResults.SWF = swfAddress;
            log("inspectLayer: found swfAddress = " + swfAddress);
         }
         return inspectionResults;
      }
      
      private function emitScreenInspectResults(screenData:Object) : void
      {
         var screenDataEncoded:String = com.adobe.serialization.json.JSON.encode(screenData);
         this._dbusReadyMsg = escape(screenDataEncoded);
         var pattern:RegExp = /%u/g;
         this._dbusReadyMsg = this._dbusReadyMsg.replace(pattern,"%5Cu");
         this._packetCurrent = 1;
         this._packetTotal = Math.ceil(this._dbusReadyMsg.length / this.MAX_DBUS_CHR_LENGTH);
         log("emitScreenInspectResults: packetTotal = " + this._packetTotal + " for screenDataEncoded = " + screenDataEncoded);
         this.onSendPacket();
      }
      
      private function onSendPacket(e:TimerEvent = null) : void
      {
         var dbusMsgToSend:String = this._dbusReadyMsg.substr((this._packetCurrent - 1) * this.MAX_DBUS_CHR_LENGTH,this.MAX_DBUS_CHR_LENGTH);
         log("onSendPacket: sending packet " + this._packetCurrent + " of " + this._packetTotal + " (" + dbusMsgToSend.length + " characters of " + this._dbusReadyMsg.length + ")");
         Peripheral.hmiRequest.emitScreenInspectResults("SCREEN",dbusMsgToSend,this._packetCurrent,this._packetTotal);
         ++this._packetCurrent;
         this.handlePacketTimer();
      }
      
      private function handlePacketTimer() : void
      {
         if(this.packetsNeedToBeSent)
         {
            if(this._packetTimer == null)
            {
               log("handlePacketTimer: instantiating _packetTimer and adding listener");
               this._packetTimer = new Timer(this.DBUS_EMIT_DELAY,1);
               this._packetTimer.addEventListener(TimerEvent.TIMER,this.onSendPacket);
            }
            log("handlePacketTimer: resetting and starting _packetTimer");
            this._packetTimer.reset();
            this._packetTimer.start();
         }
         else if(this._packetTimer != null)
         {
            log("handlePacketTimer: packetsNeedToBeSent = " + this.packetsNeedToBeSent + " with _packetTimer = " + this._packetTimer + ", so stopping _packetTimer (running = " + this._packetTimer.running + ")");
            this._packetTimer.stop();
         }
      }
      
      private function get packetsNeedToBeSent() : Boolean
      {
         return this._packetCurrent <= this._packetTotal;
      }
      
      private function get screenForInspectedLayer() : MovieClip
      {
         var screenContainerForInspectedLayer:ScreenContainer = Framework.screens.getScreenContainer(this._screenLayerName);
         if(screenContainerForInspectedLayer != null)
         {
            return screenContainerForInspectedLayer.screen;
         }
         return null;
      }
      
      private function get translatablesArray() : Array
      {
         if(this._translatablesArray == null)
         {
            if(this.screenForInspectedLayer != null)
            {
               if(this.screenForInspectedLayer is GenericScreen)
               {
                  this._translatablesArray = (this.screenForInspectedLayer as GenericScreen).translatables;
                  log("translatablesArray: screen was GenericScreen, so translatables were available");
               }
               else if(this.screenForInspectedLayer is ScreenEnhanced)
               {
                  this._translatablesArray = (this.screenForInspectedLayer as ScreenEnhanced).translatables;
                  log("translatablesArray: screen was ScreenEnhanced, so translatables were available");
               }
               else
               {
                  log("translatablesArray: screen is not GenericScreen or ScreenEnhanced (it is " + getQualifiedClassName(this.screenForInspectedLayer) + "), so no translatables available for " + this._screenLayerName + "!!");
               }
            }
            else
            {
               log("translatablesArray: screen was null, so no translatables available for " + this._screenLayerName);
            }
            if(this._translatablesArray == null)
            {
               this._translatablesArray = new Array();
            }
         }
         return this._translatablesArray;
      }
      
      private function get screenVarsForInspectedLayer() : Object
      {
         if(this.screenForInspectedLayer != null)
         {
            if(this.screenForInspectedLayer is AbstractScreen)
            {
               return (this.screenForInspectedLayer as AbstractScreen).screenVars;
            }
            if(this.screenForInspectedLayer is ScreenGeneric)
            {
               return (this.screenForInspectedLayer as ScreenGeneric).screenVars;
            }
            log("screenVars: screen is not AbstractScreen or ScreenGeneric (it is " + getQualifiedClassName(this.screenForInspectedLayer) + "), so no screenVars available!!");
         }
         return null;
      }
      
      private function onGotoScreen(e:HMIRequestEvent) : void
      {
         var branch:String = null;
         if(e.mData != null)
         {
            branch = String(e.mData);
            if(branch == Screens.MAIN_RADIO && Global.region == Market.NORTH_AMERICA)
            {
               branch = Screens.MAIN_FM;
            }
            Framework.structure.goto(branch);
         }
      }
      
      private function inspect(objToInspect:DisplayObject) : Object
      {
         var inspectionResults:Object = null;
         if(objToInspect != null && objToInspect.visible)
         {
            inspectionResults = new Object();
            inspectionResults = this.displayObjInspection(objToInspect,inspectionResults);
            inspectionResults = this.textFieldInspection(objToInspect,inspectionResults);
            inspectionResults = this.buttonInspection(objToInspect,inspectionResults);
            inspectionResults = this.graphicInspection(objToInspect,inspectionResults);
            inspectionResults = this.containerInspection(objToInspect,inspectionResults);
         }
         return inspectionResults;
      }
      
      private function displayObjInspection(objToInspect:DisplayObject, inspectionResults:Object) : Object
      {
         inspectionResults.c = getQualifiedClassName(objToInspect);
         inspectionResults.n = objToInspect.name;
         inspectionResults.w = objToInspect.width;
         inspectionResults.h = objToInspect.height;
         inspectionResults.x = objToInspect.x;
         inspectionResults.y = objToInspect.y;
         if(objToInspect.parent)
         {
            inspectionResults.z = objToInspect.parent.getChildIndex(objToInspect);
         }
         return inspectionResults;
      }
      
      private function textFieldInspection(objToInspect:DisplayObject, inspectionResults:Object) : Object
      {
         var textFieldToInspect:TextField = null;
         var translatableFound:Object = null;
         var translationsAvailable:int = 0;
         var i:int = 0;
         var textFormat:TextFormat = null;
         if(objToInspect is TextField)
         {
            textFieldToInspect = objToInspect as TextField;
            inspectionResults.t = textFieldToInspect.text;
            translationsAvailable = int(this.translatablesArray.length);
            for(i = 0; i < translationsAvailable; i++)
            {
               if(this.translatablesArray[i].target == textFieldToInspect)
               {
                  translatableFound = this.translatablesArray[i];
                  break;
               }
            }
            if(translatableFound != null)
            {
               inspectionResults.STRB = translatableFound.composition;
               inspectionResults.tT = translatableFound.truncationType;
               inspectionResults.e = translatableFound.ellipsis;
            }
            textFormat = textFieldToInspect.getTextFormat();
            if(textFormat != null)
            {
               inspectionResults.f = textFormat.font;
               inspectionResults.fS = textFormat.size;
               inspectionResults.fA = textFormat.align;
            }
            inspectionResults.tC = textFieldToInspect.textColor;
            inspectionResults.tW = textFieldToInspect.textWidth;
            inspectionResults.tH = textFieldToInspect.textHeight;
            inspectionResults.nL = textFieldToInspect.numLines;
            inspectionResults.mSV = textFieldToInspect.maxScrollV;
         }
         return inspectionResults;
      }
      
      private function buttonInspection(objToInspect:DisplayObject, inspectionResults:Object) : Object
      {
         var buttonToInspect:IInteractiveObject = null;
         if(objToInspect is IInteractiveObject)
         {
            buttonToInspect = objToInspect as IInteractiveObject;
            inspectionResults.mE = buttonToInspect.mouseEnabled;
         }
         return inspectionResults;
      }
      
      private function graphicInspection(objToInspect:DisplayObject, inspectionResults:Object) : Object
      {
         var graphicToInspect:IMovieClip = null;
         if(objToInspect is IMovieClip)
         {
            graphicToInspect = objToInspect as IMovieClip;
            inspectionResults.cF = graphicToInspect.currentFrame;
            if(graphicToInspect.currentFrameLabel != null)
            {
               inspectionResults.cFL = graphicToInspect.currentFrameLabel;
            }
         }
         return inspectionResults;
      }
      
      private function containerInspection(objToInspect:DisplayObject, inspectionResults:Object) : Object
      {
         var containerToInspect:DisplayObjectContainer = null;
         var childrenResults:Array = null;
         var i:int = 0;
         var childInfo:Object = null;
         if(objToInspect is DisplayObjectContainer)
         {
            containerToInspect = objToInspect as DisplayObjectContainer;
            if(containerToInspect.numChildren > 0)
            {
               childrenResults = new Array();
               for(i = 0; i < containerToInspect.numChildren; i++)
               {
                  childInfo = this.inspect(containerToInspect.getChildAt(i));
                  if(childInfo != null)
                  {
                     childrenResults.push(childInfo);
                  }
               }
               if(childrenResults.length > 0)
               {
                  inspectionResults.CA = childrenResults;
               }
            }
         }
         return inspectionResults;
      }
   }
}

