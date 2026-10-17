package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AnnouncementMasterEvent;
   import com.harman.moduleLinkAPI.IAnnouncementMaster;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AnnouncementMaster extends Module implements IAnnouncementMaster
   {
      
      private static const dbusIdentifier:String = "AnnouncementMaster";
      
      private static const dbusServiceAvailable:String = "dBusServiceAvailable";
      
      private static const dbusTunerAnnouncementSwitch:String = "tunerAnnouncementSwitch";
      
      private static const dbusSetTunerAnnouncementSwitch:String = "setTunerAnnouncementSwitch";
      
      private static const dbusDabAnnouncementSwitch:String = "dabAnnouncementSwitch";
      
      private static const dbusSetDabAnnouncementSwitch:String = "setDabAnnouncementSwitch";
      
      private static const dbusAdvisoryMessage:String = "advisoryMessage";
      
      private static const dbusSetDABCategory:String = "setDabCategory";
      
      private static const dbusSetAllDABCategories:String = "setAllDabCategories";
      
      private static const dbusRequestAbortAnnouncement:String = "requestAbortAnnouncement";
      
      private static const dbusDabAnnouncementCategories:String = "dabAnnCategoryStates";
      
      private static const dbusGetProperties:String = "getProperties";
      
      private static const CATEGORY_LIST_LENGTH:int = 11;
      
      private var connection:Connection;
      
      private var mTunerAnnouncementSwitch:Boolean = false;
      
      private var mDabAnnouncementSwitch:Boolean = false;
      
      private var mDabAnnCategoryStates:Object = new Object();
      
      private var mAdvisoryMessage:uint = 65535;
      
      protected var client:Client;
      
      public function AnnouncementMaster()
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
         this.connection.addEventListener(ConnectionEvent.ANNOUNCEMENT_MASTER,this.announcementMasterMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.initCategoryStates();
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function get dabAnnouncementSwitch() : Boolean
      {
         return this.mDabAnnouncementSwitch;
      }
      
      public function get tunerAnnouncementSwitch() : Boolean
      {
         return this.mTunerAnnouncementSwitch;
      }
      
      public function get dabAnnCategoryStates() : Object
      {
         return this.mDabAnnCategoryStates;
      }
      
      public function get advisoryMessage() : uint
      {
         return this.mAdvisoryMessage;
      }
      
      public function getCategoryState(categoryId:uint) : Boolean
      {
         return this.mDabAnnCategoryStates[categoryId];
      }
      
      public function setDabCategory(category:uint, enable:Boolean) : void
      {
         this.sendCommandTwoArgs(dbusSetDABCategory,"category",category,"enable",enable);
      }
      
      public function setAllDabCategories(enable:Boolean) : void
      {
         this.sendBooleanCommand(dbusSetAllDABCategories,"enable",enable);
      }
      
      public function setTunerAnnouncementSwitch(enable:Boolean) : void
      {
         this.sendBooleanCommand(dbusSetTunerAnnouncementSwitch,"enable",enable);
      }
      
      public function setDabAnnouncementSwitch(enable:Boolean) : void
      {
         this.sendBooleanCommand(dbusSetDabAnnouncementSwitch,"enable",enable);
      }
      
      public function requestAbortAnnouncement() : void
      {
         this.sendCommand(dbusRequestAbortAnnouncement,"","");
      }
      
      public function set tunerAnnouncementSwitch(enable:Boolean) : void
      {
         this.mTunerAnnouncementSwitch = enable;
         this.dispatchEvent(new AnnouncementMasterEvent(AnnouncementMasterEvent.TUNER_ANNOUNCEMENT_SWITCH));
      }
      
      public function set dabAnnouncementSwitch(enable:Boolean) : void
      {
         this.mDabAnnouncementSwitch = enable;
         this.dispatchEvent(new AnnouncementMasterEvent(AnnouncementMasterEvent.DAB_ANNOUNCEMENT_SWITCH));
      }
      
      public function set dabAnnCategoryStates(message:Object) : void
      {
         var item:Object = null;
         this.mDabAnnCategoryStates = new Object();
         for each(item in message.categories)
         {
            this.mDabAnnCategoryStates[item.category] = item.enable;
         }
         this.dispatchEvent(new AnnouncementMasterEvent(AnnouncementMasterEvent.DAB_ANNOUNCEMENT_CATEGORIES));
      }
      
      public function set advisoryMessage(advMessageCategory:uint) : void
      {
         this.mAdvisoryMessage = advMessageCategory;
         this.dispatchEvent(new AnnouncementMasterEvent(AnnouncementMasterEvent.ADVISORY_MESSAGE));
      }
      
      public function initCategoryStates() : void
      {
         for(var i:int = 11; i < CATEGORY_LIST_LENGTH; i++)
         {
            this.mDabAnnCategoryStates[i] = false;
         }
      }
      
      protected function getValue(valueName:String) : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendBooleanCommand(commandName:String, valueName:String, value:Boolean) : void
      {
         var message:String = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":false}}}";
         }
         this.client.send(message);
      }
      
      protected function sendCommandTwoArgs(commandName:String, valueName:String, value:Number, valueNameTwo:String, valueTwo:Boolean) : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":" + value + ",\"" + valueNameTwo + "\":" + valueTwo + "}} }";
         this.client.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendUnsubscribe(signalName:String) : void
      {
         var message:String = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      public function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe(dbusAdvisoryMessage);
            this.sendSubscribe(dbusDabAnnouncementSwitch);
            this.sendSubscribe(dbusTunerAnnouncementSwitch);
            this.sendSubscribe(dbusDabAnnouncementCategories);
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
      
      public function announcementMasterMessageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var message:Object = e.data;
         if(message.hasOwnProperty(dbusServiceAvailable))
         {
            if(message.dBusServiceAvailable)
            {
               this.getValue(dbusAdvisoryMessage);
               this.getValue(dbusDabAnnouncementSwitch);
               this.getValue(dbusTunerAnnouncementSwitch);
               this.getValue(dbusDabAnnouncementCategories);
               this.dispatchEvent(new AnnouncementMasterEvent(AnnouncementMasterEvent.AVAILABLE));
            }
         }
         if(message.hasOwnProperty(dbusTunerAnnouncementSwitch))
         {
            this.tunerAnnouncementSwitch = message.tunerAnnouncementSwitch.enable;
         }
         if(message.hasOwnProperty(dbusDabAnnouncementSwitch))
         {
            this.dabAnnouncementSwitch = message.dabAnnouncementSwitch.enable;
         }
         if(message.hasOwnProperty(dbusAdvisoryMessage))
         {
            this.advisoryMessage = message.advisoryMessage.category;
         }
         if(message.hasOwnProperty(dbusDabAnnouncementCategories))
         {
            this.dabAnnCategoryStates = message.dabAnnCategoryStates;
         }
         if(message.hasOwnProperty(dbusGetProperties))
         {
            try
            {
               for(property in message.getProperties)
               {
                  if(property == dbusTunerAnnouncementSwitch || property == dbusDabAnnouncementSwitch)
                  {
                     this[property] = message.getProperties[property].enable;
                  }
                  else
                  {
                     this[property] = message.getProperties[property];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

