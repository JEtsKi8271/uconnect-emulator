package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DABTunerControlVersions;
   import com.harman.moduleLinkAPI.IDABTunerControl;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DABTunerControl extends Module implements IDABTunerControl
   {
      
      private static var instance:DABTunerControl;
      
      private static const mDbusIdentifier:String = "DABTunerControl";
      
      private const DeviceState:String = "deviceState";
      
      private const DAB2DABLinkingSwitch:String = "DAB2DABLinkingSwitch";
      
      private var m_Ready:Boolean = false;
      
      private var mFirmwareVersions:Vector.<DABTunerControlVersions>;
      
      private var mTunerPoolVersion:DABTunerControlVersions;
      
      private var mRequiredFirmwareVersion:DABTunerControlVersions;
      
      private var mLable:String;
      
      private var mdeviceState:Boolean;
      
      private var mDAB2DABLinkingSwitch:Boolean;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function DABTunerControl()
      {
         super();
         this.mTunerPoolVersion = null;
         this.mRequiredFirmwareVersion = null;
         this.mFirmwareVersions = new Vector.<DABTunerControlVersions>();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.DAB_TUNER_CONTROL,this.MessageHandler);
      }
      
      public static function getInstance() : DABTunerControl
      {
         if(instance == null)
         {
            instance = new DABTunerControl();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.subscribeToSignals();
            this.sendAvailableRequest();
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var versions:Object = null;
         var TunerControl:Object = e.data;
         if(TunerControl.hasOwnProperty("dBusServiceAvailable"))
         {
            if(TunerControl.dBusServiceAvailable == "true")
            {
               this.dispatchEvent(new DABEvent(DABEvent.AVAILABLE));
               this.requestGetDAB2DABLinkingSwitch();
            }
         }
         else if(TunerControl.hasOwnProperty("requestGetFirmwareVersions"))
         {
            if(TunerControl.requestGetFirmwareVersions.hasOwnProperty("versionNumbers"))
            {
               for each(versions in TunerControl.requestGetFirmwareVersions.versionNumbers)
               {
                  this.mFirmwareVersions.push(new DABTunerControlVersions(versions));
               }
               this.dispatchEvent(new DABEvent(DABEvent.DAB_GET_FIRMWARE_VERSIONS));
            }
         }
         else if(TunerControl.hasOwnProperty("requestGetFrequencyLabel"))
         {
            if(TunerControl.requestGetFrequencyLabel.hasOwnProperty("label"))
            {
               this.mLable = TunerControl.requestGetFrequencyLabel.label;
            }
            this.dispatchEvent(new DABEvent(DABEvent.DAB_GET_FREQUENCY_LABEL));
         }
         else if(TunerControl.hasOwnProperty("requestGetPoolVersion"))
         {
            if(TunerControl.requestGetPoolVersion.hasOwnProperty("versionNumber"))
            {
               this.mTunerPoolVersion = new DABTunerControlVersions(TunerControl.requestGetPoolVersion.versionNumber);
            }
            this.dispatchEvent(new DABEvent(DABEvent.DAB_GET_POOL_VERSION));
         }
         else if(TunerControl.hasOwnProperty("requestGetRequiredFirmwareVersion"))
         {
            if(TunerControl.requestGetRequiredFirmwareVersion.hasOwnProperty("versionNumber"))
            {
               this.mRequiredFirmwareVersion = new DABTunerControlVersions(TunerControl.requestGetRequiredFirmwareVersion.versionNumber);
            }
            this.dispatchEvent(new DABEvent(DABEvent.DAB_GET_REQ_FIRMWARE_VERSION));
         }
         else if(TunerControl.hasOwnProperty(this.DeviceState))
         {
            this.mdeviceState = TunerControl.deviceState.deviceState == 1;
            this.dispatchEvent(new DABEvent(DABEvent.DAB_DEVICE_STATE));
         }
         else if(TunerControl.hasOwnProperty(this.DAB2DABLinkingSwitch))
         {
            this.mDAB2DABLinkingSwitch = TunerControl.DAB2DABLinkingSwitch.DAB2DABLinkingSwitch;
            this.dispatchEvent(new DABEvent(DABEvent.DAB_TO_DAB_LINKING_SWITCH));
         }
      }
      
      public function get firmwareVersions() : Vector.<DABTunerControlVersions>
      {
         return this.mFirmwareVersions;
      }
      
      public function get tunerPoolVersion() : DABTunerControlVersions
      {
         return this.mTunerPoolVersion;
      }
      
      public function get requiredFirmwareVersion() : DABTunerControlVersions
      {
         return this.mRequiredFirmwareVersion;
      }
      
      public function get lable() : String
      {
         return this.mLable;
      }
      
      public function get deviceState() : Boolean
      {
         return this.mdeviceState;
      }
      
      public function get dAB2DABLinkingSwitch() : Boolean
      {
         return this.mDAB2DABLinkingSwitch;
      }
      
      public function requestGetFirmwareVersions() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetFirmwareVersions\":{}}}");
      }
      
      public function requestGetFrequencyLabel() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetFrequencyLabel\":{}}}");
      }
      
      public function requestGetPoolVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetPoolVersion\":{}}}");
      }
      
      public function requestGetRequiredFirmwareVersion() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetRequiredFirmwareVersion\":{}}}");
      }
      
      public function requestSetDAB2DABLinkingSwitch(enable:Boolean) : void
      {
         if(this.mDAB2DABLinkingSwitch != enable)
         {
            this.mDAB2DABLinkingSwitch = enable;
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestSetDAB2DABLinkingSwitch\":{\"enable\":" + enable + "}}}");
         }
      }
      
      public function requestGetDAB2DABLinkingSwitch() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetDab2DabLinkingSwitch\":{}}}");
      }
      
      public function requestGetDeviceState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetDeviceState\":{}}}");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + mDbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function subscribeToSignals() : void
      {
         this.sendSubscribe(this.DAB2DABLinkingSwitch);
      }
   }
}

