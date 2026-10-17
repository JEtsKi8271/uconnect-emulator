package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IPhoneProjection;
   import com.harman.moduleLinkAPI.PhoneProjectionEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class PhoneProjection extends Module implements IPhoneProjection
   {
      
      private static const dbusIdentifier:String = "phoneProjectionService";
      
      private static const DBUS_DESTINATION:String = "DeviceConnectionManager";
      
      private static const dBusServiceAvailable:String = "dBusServiceAvailable";
      
      private static const dBusApiStartProjection:String = "startProjection";
      
      private static const dBusSignalProjectionSessionStatus:String = "projectionSessionStatus";
      
      private static const dBusSignalProjectionBackToCar:String = "projectionBackToCar";
      
      private static const dBusSignalProjectionNowPlayingState:String = "projectionNowPlayingState";
      
      private static const dBusSignalProjectionNavStatus:String = "projectionNavStatus";
      
      private static const dBusSignalProjectionCallState:String = "projectionCallState";
      
      private static const dBusprojectionDeviceStatus:String = "projectionDeviceStatus";
      
      private static const SESSION_STARTED:String = "Started";
      
      private static const mTYPE_CARPLAY:String = "CarPlay";
      
      private static const mTYPE_GAL:String = "GAL";
      
      private static const mINTERNAL_ERROR:String = "InternalError";
      
      private static const CARPLAY_CINEMO_START_ERROR:int = 1000;
      
      private static const CARPLAY_CINEMO_STOP_ERROR:int = 1001;
      
      private static const GAL_START_TIMEOUT_ERROR:int = 2501;
      
      private var mBacktoCar:Boolean = false;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mSessionStatus:String = "";
      
      private var mSessionType:String;
      
      private var mAudioStatus:Boolean = false;
      
      private var mNavStatus:Boolean = false;
      
      private var mCallerName:String;
      
      private var mCallState:Boolean = false;
      
      private var mCurrentStatus:String = "";
      
      private var mShortCutActive:Boolean = false;
      
      private var mDCMServiceAvailable:Boolean = false;
      
      private var mVideoStatus:String = "";
      
      private var mErrorCode:int = 0;
      
      public function PhoneProjection()
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
         this.connection.addEventListener(ConnectionEvent.PHONE_PROJECTION,this.phoneProjectionMessageHandler);
         this.connection.addEventListener(ConnectionEvent.DCM,this.DCMmessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function addInterest(signalName:String) : void
      {
      }
      
      override public function removeInterest(signalName:String) : void
      {
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAvailableRequest();
               this.subscribe(dBusSignalProjectionBackToCar);
               this.subscribe(dBusprojectionDeviceStatus);
               this.subscribe(dBusSignalProjectionSessionStatus);
               this.subscribe(dBusSignalProjectionNowPlayingState);
               this.subscribe(dBusSignalProjectionNavStatus);
               this.subscribe(dBusSignalProjectionCallState);
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
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function phoneProjectionMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty(dBusServiceAvailable))
         {
            if(resp.dBusServiceAvailable == "false" && this.mSessionStatus == SESSION_STARTED)
            {
               this.mSessionStatus = "";
               this.mSessionType = "";
               this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_STATUS));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalProjectionSessionStatus))
         {
            this.mSessionStatus = e.data.projectionSessionStatus.sessionStatus;
            this.mSessionType = e.data.projectionSessionStatus.type;
            if(e.data.projectionSessionStatus.sessionStatus == mINTERNAL_ERROR)
            {
               this.mErrorCode = e.data.projectionSessionStatus.errorCode;
            }
            if(e.data.projectionSessionStatus.hasOwnProperty("videoStatus"))
            {
               this.mVideoStatus = e.data.projectionSessionStatus.videoStatus;
            }
            this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_STATUS));
         }
         else if(resp.hasOwnProperty(dBusSignalProjectionBackToCar))
         {
            this.mBacktoCar = true;
            this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_BACKTO_CAR));
         }
         else if(resp.hasOwnProperty(dBusSignalProjectionNowPlayingState))
         {
            if(this.mShortCutActive == false || this.mCurrentStatus == "Audio")
            {
               if(e.data.projectionNowPlayingState.mediaStatus == "Started")
               {
                  this.mAudioStatus = true;
                  this.mShortCutActive = true;
                  this.mCurrentStatus = "Audio";
                  this.mCallerName = "Audio";
               }
               else if(e.data.projectionNowPlayingState.mediaStatus == "Stopped")
               {
                  this.mAudioStatus = false;
                  this.mShortCutActive = false;
                  this.mCurrentStatus = "";
                  this.mCallerName = "";
               }
               this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_STATUS_BAR));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalProjectionNavStatus))
         {
            if(this.mShortCutActive == false || this.mCurrentStatus == "Maps")
            {
               if(e.data.projectionNavStatus.status == "Active")
               {
                  this.mNavStatus = true;
                  this.mShortCutActive = true;
                  this.mCurrentStatus = "Maps";
                  this.mCallerName = "Navigation";
               }
               else
               {
                  this.mNavStatus = false;
                  this.mShortCutActive = false;
                  this.mCurrentStatus = "";
                  this.mCallerName = "";
               }
               this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_STATUS_BAR));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalProjectionCallState))
         {
            if(this.mShortCutActive == false || this.mCurrentStatus == "Call")
            {
               if(e.data.projectionCallState.CallState == "Active")
               {
                  this.mCallState = true;
                  this.mShortCutActive = true;
                  this.mCurrentStatus = "Call";
                  this.mCallerName = e.data.projectionCallState.CallerName;
               }
               else
               {
                  this.mCallState = false;
                  this.mShortCutActive = false;
                  this.mCurrentStatus = "";
                  this.mCallerName = "";
               }
               this.dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_STATUS_BAR));
            }
         }
      }
      
      private function DCMmessageHandler(e:ConnectionEvent) : void
      {
         var projDevice:Object = null;
         var devConMgr:Object = e.data;
         if(devConMgr.hasOwnProperty("dBusServiceAvailable"))
         {
            if(devConMgr.dBusServiceAvailable == "true" && this.mDCMServiceAvailable == false)
            {
               this.mDCMServiceAvailable = true;
            }
            else if(devConMgr.dBusServiceAvailable == "false")
            {
               this.mDCMServiceAvailable = false;
            }
         }
         if(devConMgr.hasOwnProperty("projectionDeviceStatus"))
         {
            projDevice = devConMgr.projectionDeviceStatus;
            if(devConMgr.projectionDeviceStatus.hasOwnProperty("connected"))
            {
               if(devConMgr.projectionDeviceStatus.connected == true)
               {
                  dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTIONDEVICE_READY,projDevice));
               }
               else
               {
                  dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTIONDEVICE_NOTREADY,projDevice));
               }
            }
         }
         if(devConMgr.hasOwnProperty("getProjectionDeviceList"))
         {
            dispatchEvent(new PhoneProjectionEvent(PhoneProjectionEvent.PROJECTION_DEVICE_LIST,devConMgr.getProjectionDeviceList.deviceList));
         }
      }
      
      public function get BacktoCar() : Boolean
      {
         return this.mBacktoCar;
      }
      
      public function get sessionActive() : Boolean
      {
         return this.mSessionStatus == SESSION_STARTED;
      }
      
      public function get videoStatus() : String
      {
         return this.mVideoStatus;
      }
      
      public function get sessionStatus() : String
      {
         return this.mSessionStatus;
      }
      
      public function get errorCode() : int
      {
         return this.mErrorCode;
      }
      
      public function queryDeviceList() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + DBUS_DESTINATION + "\", \"packet\": { \"getProjectionDeviceList\": {}}}";
         this.client.send(message);
      }
      
      public function get sessionType() : String
      {
         return this.mSessionType;
      }
      
      public function get TYPE_CARPLAY() : String
      {
         return mTYPE_CARPLAY;
      }
      
      public function get TYPE_GAL() : String
      {
         return mTYPE_GAL;
      }
      
      public function get ERROR_CARPLAY_CINEMO_START() : int
      {
         return CARPLAY_CINEMO_START_ERROR;
      }
      
      public function get ERROR_CARPLAY_CINEMO_STOP() : int
      {
         return CARPLAY_CINEMO_STOP_ERROR;
      }
      
      public function get ERROR_GAL_START_TIMEOUT() : int
      {
         return GAL_START_TIMEOUT_ERROR;
      }
      
      public function get INTERNAL_ERROR() : String
      {
         return mINTERNAL_ERROR;
      }
      
      public function startProjection(ppId:String) : void
      {
         this.sendCommand(dBusApiStartProjection,"ppId",ppId);
         this.mBacktoCar = false;
      }
      
      public function get ShortCutName() : String
      {
         return this.mCallerName;
      }
      
      public function IsCarPlayShortCut() : Boolean
      {
         if(this.mSessionType == mTYPE_CARPLAY && this.mSessionStatus == SESSION_STARTED && (this.mAudioStatus == true || this.mNavStatus == true || this.mCallState == true))
         {
            return true;
         }
         return false;
      }
      
      public function IsGalShortCut() : Boolean
      {
         if(this.mSessionType == mTYPE_GAL && this.mSessionStatus == SESSION_STARTED && (this.mAudioStatus == true || this.mNavStatus == true))
         {
            return true;
         }
         return false;
      }
      
      protected function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         var dcmmessage:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"DeviceConnectionManager\"}";
         this.client.send(dcmmessage);
         this.client.send(message);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var dcmmessage:String = null;
         var message:String = null;
         if(signalName == "projectionDeviceStatus")
         {
            dcmmessage = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_DESTINATION + "\", \"Signal\": \"" + signalName + "\"}";
            this.client.send(dcmmessage);
         }
         else
         {
            message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
            this.client.send(message);
         }
      }
      
      protected function sendMultiSubscribe(signalsArray:Array) : void
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
         var messagedcm:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(messagedcm = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_DESTINATION + "\", \"Signal\": \"" + signalName + "\"}");
         this.client.send(messagedcm);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:*) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":\"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

