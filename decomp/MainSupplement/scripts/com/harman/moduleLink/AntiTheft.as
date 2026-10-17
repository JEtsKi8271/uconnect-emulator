package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.AntiTheftStates;
   import com.harman.moduleLinkAPI.IAntiTheft;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AntiTheft extends Module implements IAntiTheft
   {
      
      private static var instance:AntiTheft;
      
      private static const mDbusIdentifier:String = "AntiTheft";
      
      private const dbusAntiTheftState:String = "antiTheftState";
      
      private const dbusAntiTheftLockTime:String = "antiTheftLockTime";
      
      private const dbusBattConnect:String = "battConnect";
      
      private const dbusCloseScreenOff:String = "CloseScreenOff";
      
      private const dbusIgnState:String = "ignState";
      
      private const dbusPowerModeState:String = "powerModeState";
      
      private const dbusShutdownRequest:String = "shutdownReq";
      
      private const dbusWakeUpReason:String = "wakeupReason";
      
      private var mAntiTheftState:String = "locked";
      
      private var mAntiTheftLockTime:String = "30";
      
      private var mBattConnectState:String = "normal";
      
      private var mPowerModeState:String;
      
      private var mIgnState:String;
      
      private var mWakeUpReason:String;
      
      private var m_Ready:Boolean = false;
      
      private var m_EnterPin:Boolean = false;
      
      private var productVariant:ProductVariantID = VersionInfo.getInstance().productVariantID;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function AntiTheft()
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
         this.connection.addEventListener(ConnectionEvent.ANTI_THEFT,this.MessageHandler);
      }
      
      public static function getInstance() : AntiTheft
      {
         if(instance == null)
         {
            instance = new AntiTheft();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe(this.dbusAntiTheftState);
            this.sendSubscribe(this.dbusAntiTheftLockTime);
            this.sendSubscribe(this.dbusBattConnect);
            this.sendSubscribe(this.dbusCloseScreenOff);
            this.sendSubscribe(this.dbusIgnState);
            this.sendSubscribe(this.dbusPowerModeState);
            this.sendSubscribe(this.dbusShutdownRequest);
            this.sendSubscribe(this.dbusWakeUpReason);
            this.getWakeupReason();
         }
         else
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var antiTheftState:String = null;
         var info:Object = e.data;
         if(info.hasOwnProperty(this.dbusAntiTheftState))
         {
            antiTheftState = info.antiTheftState.value;
            this.mAntiTheftState = antiTheftState;
            if(antiTheftState == AntiTheftStates.LOCKED)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_LOCKED));
            }
            else if(antiTheftState == AntiTheftStates.WAIT_FOR_VIN)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_WAITFORVIN));
            }
            else if(antiTheftState == AntiTheftStates.ENTER_PIN)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_ENTERPIN));
               this.m_EnterPin = true;
            }
            else if(antiTheftState == AntiTheftStates.UNLOCKED)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_UNLOCKED));
               if(this.m_EnterPin)
               {
                  this.m_EnterPin = false;
                  if(this.productVariant.VARIANT_PRODUCT == "VP2" || this.productVariant.VARIANT_PRODUCT == "VP3" || this.productVariant.VARIANT_PRODUCT == "VP4")
                  {
                     AppManager.getInstance().xletReturnToNew();
                  }
               }
            }
            else if(antiTheftState == AntiTheftStates.WRONG_PIN)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_WRONGPIN));
            }
            else if(antiTheftState == AntiTheftStates.FORCED_FOTA_UPDATE)
            {
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_STATE_FORCED_FOTA_UPDATE));
            }
         }
         else if(info.hasOwnProperty(this.dbusWakeUpReason))
         {
            this.mWakeUpReason = info.wakeupReason.value;
            this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_WAKEUPREASON));
         }
         if(info.hasOwnProperty(this.dbusAntiTheftLockTime))
         {
            this.mAntiTheftLockTime = info.antiTheftLockTime.value;
            this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_LOCK_TIME));
         }
         if(info.hasOwnProperty(this.dbusBattConnect))
         {
            this.mBattConnectState = info.battConnect;
            this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_BATTERY_DISCONNECT));
         }
         if(info.hasOwnProperty(this.dbusIgnState))
         {
            this.mIgnState = info[this.dbusIgnState].value;
            dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE));
         }
         if(info.hasOwnProperty(this.dbusPowerModeState))
         {
            this.mPowerModeState = info[this.dbusPowerModeState].value;
            dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE));
         }
         if(info.hasOwnProperty(this.dbusShutdownRequest))
         {
            dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_SHUTDOWN_REQUEST));
         }
         if(info.hasOwnProperty("getProperties"))
         {
            if(info.getProperties.hasOwnProperty(this.dbusBattConnect))
            {
               this.mBattConnectState = info.getProperties.battConnect;
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_BATTERY_DISCONNECT));
            }
            if(info.getProperties.hasOwnProperty(this.dbusAntiTheftLockTime))
            {
               this.mAntiTheftLockTime = info.getProperties.antiTheftLockTime;
               this.dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_LOCK_TIME));
            }
            if(info.getProperties.hasOwnProperty(this.dbusWakeUpReason))
            {
               this.mWakeUpReason = info.getProperties[this.dbusWakeUpReason];
            }
            if(info.getProperties.hasOwnProperty(this.dbusIgnState))
            {
               this.mIgnState = info.getProperties[this.dbusIgnState];
               dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE));
            }
            if(info.getProperties.hasOwnProperty(this.dbusPowerModeState))
            {
               this.mPowerModeState = info.getProperties[this.dbusPowerModeState];
               dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE));
            }
         }
         if(info.hasOwnProperty(this.dbusCloseScreenOff))
         {
            dispatchEvent(new AntiTheftEvent(AntiTheftEvent.ANTI_THEFT_CLOSE_SCREEN_OFF));
         }
      }
      
      public function checkAntiTheftPin(PIN:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"checkAntiTheftPIN\": { \"pin\": \"" + PIN + "\"}}}");
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function reqAntiTheftState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getAntiTheftState\":{}}}");
      }
      
      public function enableAntiTheft() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"enableAntiTheft\":{}}}");
      }
      
      public function get antiTheftState() : String
      {
         return this.mAntiTheftState;
      }
      
      public function reqAntiTheftLockTime() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"antiTheftLockTime\"]}}}");
      }
      
      public function get antiTheftLockTime() : String
      {
         return this.mAntiTheftLockTime;
      }
      
      public function getWakeupReason() : void
      {
         this.client.send("{\"Type\":\"Command\",\"Dest\":\"" + mDbusIdentifier + "\", \"packet\":{\"getProperties\":{\"props\":[\"wakeupReason\"]}}}");
      }
      
      public function reqBatteryConnectState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"battConnect\"]}}}");
      }
      
      public function get batteryDisconnectState() : String
      {
         return this.mBattConnectState;
      }
      
      public function reqPowerModeState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + this.dbusPowerModeState + "\"]}}}");
      }
      
      public function get powerModeState() : String
      {
         return this.mPowerModeState;
      }
      
      public function reqIgnitionState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + this.dbusIgnState + "\"]}}}");
      }
      
      public function get ignitionState() : String
      {
         return this.mIgnState;
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
      
      public function requestReset() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"requestReset\":{}}}";
         trace("Message -- " + message);
         this.client.send(message);
      }
      
      public function get WakeUpReason() : String
      {
         return this.mWakeUpReason;
      }
   }
}

