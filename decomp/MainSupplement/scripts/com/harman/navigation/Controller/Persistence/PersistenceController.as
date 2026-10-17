package com.harman.navigation.Controller.Persistence
{
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class PersistenceController extends Module implements IPersistence
   {
      
      private static const dbusIdentifier:String = "NavigationPersistency";
      
      private static const NAV_INTERVAL_TIME:int = 100;
      
      private var connection:Connection;
      
      private var span:Client;
      
      private var mBusy:Boolean = false;
      
      private var mConnected:Boolean = false;
      
      private var mNavInterval:uint = 0;
      
      private var mDatabaseCheckPending:Boolean = true;
      
      private var mUpdateCheck:UpdateCheck;
      
      private var mDatabaseUpdateCheckBreak:int = 15;
      
      private var mLastLoadedKey:String = "";
      
      private var mEmptyReadsCounter:int = 0;
      
      private var mSaveQueue:Array = new Array();
      
      private var mReadQueue:Array = new Array();
      
      private var mReadingList:Array = new Array();
      
      private var mReadDataBuffer:Array = new Array();
      
      private var mLastPersistedKey:String = "";
      
      private var mLastPersistedValues:Object = new Object();
      
      private var mLastPersistedCounter:int = 5;
      
      public function PersistenceController()
      {
         super();
         this.init();
      }
      
      public function saveData(key:String, value:Object) : void
      {
         var obj:Object = new Object();
         obj[key] = value;
         this.mSaveQueue.push(obj);
         this.checkQueues();
      }
      
      public function loadData(key:String) : void
      {
         this.mReadQueue.push(key);
         this.checkQueues();
      }
      
      public function getDataLoaded(key:String, remove:Boolean) : Object
      {
         var tmp:Object = null;
         var j:String = null;
         loop0:
         for(var i:int = 0; i < this.mReadDataBuffer.length; )
         {
            tmp = Object(this.mReadDataBuffer[i]);
            var _loc6_:int = 0;
            var _loc7_:* = tmp;
            do
            {
               for(j in _loc7_)
               {
               }
               i++;
               continue loop0;
            }
            while(j != key);
            if(remove)
            {
               this.mReadDataBuffer.splice(i,1);
            }
            return tmp[j];
         }
         return null;
      }
      
      public function get dataLoaded() : String
      {
         return this.mLastLoadedKey;
      }
      
      public function indicateDatabaseUpdate() : void
      {
         for(var i:int = 0; i < PersistenceKeys.DELETE_ON_DB_CHANGE.length; i++)
         {
            this.resetWriteFailRetryCounter();
            this.setValuesWithKey(String(PersistenceKeys.DELETE_ON_DB_CHANGE[i]),null);
         }
         this.mDatabaseCheckPending = false;
         this.checkQueues();
      }
      
      public function indicateNoDatabaseUpdate() : void
      {
         this.mDatabaseCheckPending = false;
         this.checkQueues();
      }
      
      public function isBusy() : Boolean
      {
         return !this.connection.configured && !this.span.connected && this.mBusy;
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new PersistenceEvent(eventType));
      }
      
      private function checkQueues() : void
      {
         var j:int = 0;
         var tmp:Object = null;
         var i:String = null;
         if(!this.mConnected)
         {
            return;
         }
         if(this.mDatabaseCheckPending && String(this.mReadQueue[0]) != PersistenceKeys.DATABASE_VERSION && this.mDatabaseUpdateCheckBreak > 0)
         {
            Framework.Trace("-> Database updated -> Pending:" + this.mDatabaseCheckPending);
            for(j = 0; j < this.mReadQueue.length; j++)
            {
               if(String(this.mReadQueue[j]) == PersistenceKeys.DATABASE_VERSION)
               {
                  this.getValuesOfKey(this.mReadQueue[j]);
                  this.mReadQueue.splice(j,1);
               }
               else if(String(this.mReadQueue[j]) == PersistenceKeys.VP3_ACTIVATION_CODE)
               {
                  this.getValuesOfKey(this.mReadQueue[j]);
                  this.mReadQueue.splice(j,1);
               }
               else if(String(this.mReadQueue[j]) == PersistenceKeys.MAP_SETTINGS)
               {
                  this.getValuesOfKey(this.mReadQueue[j]);
                  this.mReadQueue.splice(j,1);
               }
            }
            --this.mDatabaseUpdateCheckBreak;
            return;
         }
         if(this.mSaveQueue.length > 0)
         {
            tmp = Object(this.mSaveQueue[0]);
            for(i in tmp)
            {
               this.resetWriteFailRetryCounter();
               this.setValuesWithKey(i,tmp[i]);
            }
            this.mSaveQueue.splice(0,1);
            return;
         }
         if(this.mReadQueue.length > 0)
         {
            this.getValuesOfKey(this.mReadQueue[0]);
            this.mReadQueue.splice(0,1);
            return;
         }
      }
      
      private function getValuesOfKey(key:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"NavigationPersistency\", \"packet\": {\"read\":{\"key\":\"Nav_" + key + "\", \"escval\":0}}}";
         this.mReadingList.push(key);
         this.span.send(message);
      }
      
      private function removeFromReadingList(key:String) : void
      {
         Framework.Trace("Nav.Persistence.removeFromReadingList( " + key + " ) items left:" + this.mReadingList.length);
         for(var i:int = 0; i < this.mReadingList.length; i++)
         {
            if(String(this.mReadingList[i]) != key)
            {
               Framework.Trace(" is late:" + this.mReadingList[i]);
            }
            else if(String(this.mReadingList[i]) == key)
            {
               Framework.Trace(" - removed at:" + i);
               this.mReadingList.splice(i,1);
               return;
            }
         }
      }
      
      private function setValuesWithKey(key:String, values:Object) : void
      {
         var message:String = null;
         var i:String = null;
         this.mLastPersistedKey = key;
         this.mLastPersistedValues = values;
         message = "{\"Type\":\"Command\", \"Dest\":\"NavigationPersistency\", \"packet\": { \"write\": {";
         message += "\"Nav_" + key.valueOf() + "\": {";
         message += "\"verify_key\":\"" + key.valueOf() + "\"";
         message += ", ";
         if(values == null)
         {
            message += "\"\":\"\"";
         }
         else
         {
            for(i in values)
            {
               message += "\"" + i + "\":\"" + String(values[i]).split("\"").join("\\\"") + "\"";
               message += ", ";
            }
            message = message.substring(0,message.lastIndexOf(", "));
         }
         message += "} }}}";
         this.span.send(message);
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.span = this.connection.span;
         this.span.addEventListener(Event.CONNECT,this.connected);
         if(this.span.connected)
         {
            this.connected();
         }
         this.span.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.NAVIGATION_PERSISTENCY,this.persistencyMessageHandler);
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            Framework.Trace("Navigation.PersistenceController.connected()");
            this.mConnected = true;
            this.sendEvent(PersistenceEvent.PERS_IS_BUSY);
            this.mDatabaseCheckPending = true;
            this.mNavInterval = setInterval(this.onNavInterval,NAV_INTERVAL_TIME);
         }
      }
      
      private function onNavInterval() : void
      {
         if(NavigationPackage.peripheral.navigation != null)
         {
            if(NavigationPackage.peripheral.navigation.navigation != null)
            {
               clearInterval(this.mNavInterval);
               this.mUpdateCheck = new UpdateCheck(this);
               this.checkQueues();
            }
         }
      }
      
      private function resetWriteFailRetryCounter() : void
      {
         this.mLastPersistedCounter = NavGlobalSettings.PERSISTENCE_WRITE_FAIL_RETRY_MAX;
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function persistencyMessageHandler(e:ConnectionEvent) : void
      {
         var erg:Object = null;
         var i:String = null;
         var tmp:Object = null;
         var j:int = 0;
         var trash:Object = null;
         var result:Object = e.data;
         if(result.hasOwnProperty("write"))
         {
            if(!(result.write.res == "success" || result.write.res == "Success"))
            {
               Framework.Trace("persistencyMessageHandler received: write = FAILED");
               NavigationPackage.peripheral.navigation.navigation.setForceSendConsoleCommand("echo \\\"Write Failed for: " + this.mLastPersistedKey + " \\\" >> /tmp/NavPersistenceFails.txt");
               --this.mLastPersistedCounter;
               if(this.mLastPersistedCounter > 0)
               {
                  this.setValuesWithKey(this.mLastPersistedKey,this.mLastPersistedValues);
                  return;
               }
            }
         }
         else if(result.hasOwnProperty("read"))
         {
            if(result.read.res != "Empty")
            {
               erg = new Object();
               this.mLastLoadedKey = "";
               for(i in result.read.res)
               {
                  if(i == "verify_key")
                  {
                     this.mLastLoadedKey = result.read.res[i];
                  }
                  else
                  {
                     erg[i] = result.read.res[i];
                  }
               }
               Framework.Trace("Nav.Persistence read \'" + this.mLastLoadedKey + "\'");
               if(this.mLastLoadedKey == "")
               {
                  ++this.mEmptyReadsCounter;
                  Framework.Trace("Nav.Persistence null:" + this.mEmptyReadsCounter);
               }
               else
               {
                  this.removeFromReadingList(this.mLastLoadedKey);
                  tmp = new Object();
                  tmp[this.mLastLoadedKey] = erg;
                  this.mReadDataBuffer.push(tmp);
               }
               this.sendEvent(PersistenceEvent.PERS_DATA_LOADED);
               if(this.mEmptyReadsCounter == this.mReadingList.length)
               {
                  Framework.Trace("Nav.Persistence declare null: " + this.mReadingList.length);
                  for(j = 0; j < this.mReadingList.length; j++)
                  {
                     Framework.Trace(" -" + this.mReadingList[j]);
                     trash = new Object();
                     trash[this.mReadingList[j]] = null;
                     this.mReadDataBuffer.push(trash);
                     this.mLastLoadedKey = this.mReadingList[j];
                     this.sendEvent(PersistenceEvent.PERS_DATA_LOADED);
                  }
                  this.mReadingList.splice(0,this.mReadingList.length);
                  this.mEmptyReadsCounter = 0;
               }
            }
            else
            {
               Framework.Trace("persistencyMessageHandler received: read EMPTY :( \'" + result.read.res + "\'");
            }
         }
         this.checkQueues();
      }
   }
}

