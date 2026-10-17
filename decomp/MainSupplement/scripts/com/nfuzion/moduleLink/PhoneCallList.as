package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.IBluetooth;
   import com.nfuzion.moduleLinkAPI.IPhoneCallList;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.PhoneCallListEntry;
   import com.nfuzion.moduleLinkAPI.PhoneCallListEvent;
   import com.nfuzion.span.*;
   
   public class PhoneCallList extends Module implements IPhoneCallList
   {
      
      private static const mDbusIdentifier:String = "PhoneCallList";
      
      private static const mPIM_DbusIdentifier:String = "PimService";
      
      private var mBluetooth:IBluetooth;
      
      private var mAllCount:int = -1;
      
      private var mAllStartIndex:uint;
      
      private var mDialedCount:int = -1;
      
      private var mDialedStartIndex:uint;
      
      private var mReceivedCount:int = -1;
      
      private var mReceivedStartIndex:uint;
      
      private var mMissedCount:int = -1;
      
      private var mMissedStartIndex:uint;
      
      private var mRecentCallsSync:Boolean;
      
      private var mConnection:Connection;
      
      private var mInitalized:Boolean;
      
      private var mBlockedCallCount:uint = 0;
      
      private var mBlockedCallNumber:String = "";
      
      private var client:Client;
      
      private var mAvailable:Boolean;
      
      private var mHFPDeviceConnected:Boolean = true;
      
      public function PhoneCallList()
      {
         super();
         this.mConnection = null;
         this.mInitalized = false;
         this.mAvailable = false;
      }
      
      public function init(connect:Connection, bt:BluetoothPhone) : void
      {
         this.mConnection = connect;
         this.mInitalized = true;
         this.mRecentCallsSync = false;
         this.client = this.mConnection.span;
         this.mConnection.addEventListener(ConnectionEvent.PHONE_CALL_LIST,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.PIM_SERVICE,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.BLUETOOTH_MANAGER,this.btMessageHandler);
         this.sendSubscribePIM("pimObjectSyncState");
         this.sendSubscribePIM("newCallList");
         this.sendSubscribe("serviceDisconnected");
      }
      
      private function onServiceDisconnect() : void
      {
         this.mRecentCallsSync = false;
         this.mAllCount = -1;
         this.mDialedCount = -1;
         this.mMissedCount = -1;
         this.mReceivedCount = -1;
         this.mAvailable = false;
         this.mHFPDeviceConnected = false;
         this.mBlockedCallCount = 0;
         this.mBlockedCallNumber = "";
      }
      
      public function initBt(bt:IBluetooth) : void
      {
         this.mBluetooth = bt;
         this.mBluetooth.addEventListener(BluetoothEvent.PIM_SYNC_STATE,this.onSyncState);
      }
      
      public function getAllCallsCount() : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"getAllCallsCount\":{ }}}";
         this.client.send(message);
      }
      
      public function get allCallsCount() : int
      {
         return this.mAllCount;
      }
      
      public function getDialedCallsCount() : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"getDialedCallsCount\":{ }}}";
         this.client.send(message);
      }
      
      public function get dialedCallsCount() : int
      {
         return this.mDialedCount;
      }
      
      public function getReceivedCallsCount() : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"getReceivedCallsCount\":{ }}}";
         this.client.send(message);
      }
      
      public function get receivedCallsCount() : int
      {
         return this.mReceivedCount;
      }
      
      public function getMissedCallsCount() : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"getMissedCallsCount\":{ }}}";
         this.client.send(message);
      }
      
      public function get missedCallsCount() : int
      {
         return this.mMissedCount;
      }
      
      public function get recentCallsAvailable() : Boolean
      {
         return this.mRecentCallsSync;
      }
      
      public function requestCallList(list:String, startIndex:uint, max:uint) : void
      {
         var cmd:String = null;
         var message:String = null;
         var requested:Boolean = false;
         switch(list)
         {
            case PhoneCallListEvent.ALL_CALLS_LIST:
               cmd = "getAllCallLists";
               this.mAllStartIndex = startIndex;
               requested = this.mAllCount != -1;
               break;
            case PhoneCallListEvent.DIALED_CALLS_LIST:
               cmd = "getDialedCallList";
               this.mDialedStartIndex = startIndex;
               requested = this.mDialedCount != -1;
               break;
            case PhoneCallListEvent.RECEIVED_CALLS_LIST:
               cmd = "getReceivedCallList";
               this.mReceivedStartIndex = startIndex;
               requested = this.mReceivedCount != -1;
               break;
            case PhoneCallListEvent.MISSED_CALLS_LIST:
               cmd = "getMissedCallList";
               this.mMissedStartIndex = startIndex;
               requested = this.mMissedCount != -1;
         }
         if(max > 0)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": {\"" + cmd + "\":{\"numCallstacks\":" + max + ", \"startCallstacksFrom\":" + startIndex + " }}}";
            this.client.send(message);
         }
         else if(startIndex == 0 && requested)
         {
            this.processEmptyList(list);
         }
      }
      
      public function set blockedCallCount(bcc:uint) : void
      {
         this.mBlockedCallCount = bcc;
      }
      
      public function get blockedCallCount() : uint
      {
         return this.mBlockedCallCount;
      }
      
      public function set blockedCallNumber(bcn:String) : void
      {
         this.mBlockedCallNumber = bcn;
      }
      
      public function get blockedCallNumber() : String
      {
         return this.mBlockedCallNumber;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case PhoneCallListEvent.AVAILABILITY:
               if(this.mRecentCallsSync)
               {
                  dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.AVAILABILITY));
               }
               break;
            case PhoneCallListEvent.ALL_CALLS_COUNT:
               this.getAllCallsCount();
               break;
            case PhoneCallListEvent.DIALED_CALLS_COUNT:
               this.getDialedCallsCount();
               break;
            case PhoneCallListEvent.RECEIVED_CALLS_COUNT:
               this.getReceivedCallsCount();
               break;
            case PhoneCallListEvent.MISSED_CALLS_COUNT:
               this.getMissedCallsCount();
         }
      }
      
      protected function sendSubscribePIM(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mPIM_DbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mConnection.span.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mConnection.span.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case PhoneCallListEvent.AVAILABILITY:
         }
      }
      
      override public function isReady() : Boolean
      {
         return this.mInitalized && this.mConnection != null;
      }
      
      private function btMessageHandler(e:ConnectionEvent) : void
      {
         var bluetooth:Object = e.data;
         if(bluetooth.hasOwnProperty("serviceDisconnected"))
         {
            if(bluetooth.serviceDisconnected.service == "HFPGW")
            {
               this.onServiceDisconnect();
            }
         }
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var j:int = 0;
         var data:Object = e.data;
         if(data.hasOwnProperty("unreadMissedCallCount"))
         {
         }
         if(data.hasOwnProperty("unreadDialedCallCount"))
         {
            this.getDialedCallsCount();
            this.getAllCallsCount();
         }
         if(data.hasOwnProperty("unreadReceivedCallCount"))
         {
            this.getReceivedCallsCount();
            this.getAllCallsCount();
         }
         if(data.hasOwnProperty("getAllCallsCount"))
         {
            this.mAllCount = data.getAllCallsCount.callstackCount;
            dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.ALL_CALLS_COUNT));
         }
         if(data.hasOwnProperty("getDialedCallsCount"))
         {
            this.mDialedCount = data.getDialedCallsCount.callstackCount;
            dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.DIALED_CALLS_COUNT));
         }
         if(data.hasOwnProperty("getReceivedCallsCount"))
         {
            this.mReceivedCount = data.getReceivedCallsCount.callstackCount;
            dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.RECEIVED_CALLS_COUNT));
         }
         if(data.hasOwnProperty("getMissedCallsCount"))
         {
            this.mMissedCount = data.getMissedCallsCount.callstackCount;
            dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.MISSED_CALLS_COUNT));
         }
         if(data.hasOwnProperty("getAllCallLists"))
         {
            this.processListEvent(PhoneCallListEvent.ALL_CALLS_LIST,data.getAllCallLists);
         }
         if(data.hasOwnProperty("getDialedCallList"))
         {
            this.processListEvent(PhoneCallListEvent.DIALED_CALLS_LIST,data.getDialedCallList);
         }
         if(data.hasOwnProperty("getReceivedCallList"))
         {
            this.processListEvent(PhoneCallListEvent.RECEIVED_CALLS_LIST,data.getReceivedCallList);
         }
         if(data.hasOwnProperty("getMissedCallList"))
         {
            this.processListEvent(PhoneCallListEvent.MISSED_CALLS_LIST,data.getMissedCallList);
         }
         if(data.hasOwnProperty("newCallList"))
         {
            switch(data.newCallList.storageType)
            {
               case "MC":
                  if(SMSMessaging.getInstance().DNDStatus)
                  {
                     this.mBlockedCallCount += 1;
                     this.mBlockedCallNumber = data.newCallList.phoneNumber;
                     dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.SEND_AUTO_REPLY_FOR_CALL));
                  }
                  else
                  {
                     this.mBlockedCallCount = 0;
                     this.mBlockedCallNumber = "";
                  }
                  this.getMissedCallsCount();
                  break;
               case "RC":
                  if(SMSMessaging.getInstance().DNDStatus)
                  {
                     this.mBlockedCallCount += 1;
                     this.mBlockedCallNumber = data.newCallList.phoneNumber;
                     dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.SEND_AUTO_REPLY_FOR_CALL));
                  }
                  else
                  {
                     this.mBlockedCallCount = 0;
                     this.mBlockedCallNumber = "";
                  }
                  this.getReceivedCallsCount();
                  break;
               case "DC":
                  this.getDialedCallsCount();
            }
            this.getAllCallsCount();
         }
         if(data.hasOwnProperty("pimObjectSyncState"))
         {
            if(Boolean(data.pimObjectSyncState.hasOwnProperty("objectType")) && "CallStack" == data.pimObjectSyncState.objectType)
            {
               if("syncComplete" == data.pimObjectSyncState.syncStatus)
               {
                  this.mHFPDeviceConnected = true;
                  this.mRecentCallsSync = true;
                  this.getAllCallsCount();
                  this.getDialedCallsCount();
                  this.getMissedCallsCount();
                  this.getReceivedCallsCount();
               }
               else
               {
                  this.mRecentCallsSync = false;
                  this.mAllCount = -1;
                  this.mDialedCount = -1;
                  this.mMissedCount = -1;
                  this.mReceivedCount = -1;
               }
               dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.AVAILABILITY));
            }
         }
         if(data.hasOwnProperty("getProperties"))
         {
            if(data.getProperties.hasOwnProperty("pimObjectSyncState"))
            {
               for(j = 0; j < data.getProperties.pimObjectSyncState.length; j++)
               {
                  if(data.getProperties.pimObjectSyncState[j].objectType == "callStack")
                  {
                     if("syncComplete" == data.getProperties.pimObjectSyncState[j].syncState && this.mHFPDeviceConnected)
                     {
                        this.mRecentCallsSync = true;
                     }
                     else
                     {
                        this.mRecentCallsSync = false;
                        this.mAllCount = -1;
                        this.mDialedCount = -1;
                        this.mMissedCount = -1;
                        this.mReceivedCount = -1;
                     }
                     dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.AVAILABILITY));
                  }
               }
            }
         }
      }
      
      private function onSyncState(e:BluetoothEvent) : void
      {
         if(e.data.hasOwnProperty("objectType") && e.data.objectType == "callStack")
         {
            if("syncComplete" == e.data.syncState)
            {
               this.mRecentCallsSync = true;
               this.mAvailable = true;
            }
            else
            {
               this.mAvailable = false;
               this.mRecentCallsSync = false;
               this.mAllCount = -1;
               this.mDialedCount = -1;
               this.mMissedCount = -1;
               this.mReceivedCount = -1;
            }
            dispatchEvent(new PhoneCallListEvent(PhoneCallListEvent.AVAILABILITY));
         }
      }
      
      private function processEmptyList(listType:String) : void
      {
         var list:Vector.<PhoneCallListEntry> = new Vector.<PhoneCallListEntry>();
         var contact:Object = new Object();
         list.push(new PhoneCallListEntry(contact,0,listType));
         dispatchEvent(new PhoneCallListEvent(listType,{
            "offset":0,
            "list":list
         }));
      }
      
      private function processListEvent(listType:String, eventObj:Object) : void
      {
         var offset:int = 0;
         var index:int = 0;
         var num:int = 0;
         var contact:Object = null;
         var emptyContact:Object = null;
         var list:Vector.<PhoneCallListEntry> = new Vector.<PhoneCallListEntry>();
         if("success" == eventObj.description)
         {
            switch(listType)
            {
               case PhoneCallListEvent.ALL_CALLS_LIST:
                  offset = int(this.mAllStartIndex);
                  break;
               case PhoneCallListEvent.DIALED_CALLS_LIST:
                  offset = int(this.mDialedStartIndex);
                  break;
               case PhoneCallListEvent.RECEIVED_CALLS_LIST:
                  offset = int(this.mReceivedStartIndex);
                  break;
               case PhoneCallListEvent.MISSED_CALLS_LIST:
                  offset = int(this.mMissedStartIndex);
            }
            index = offset;
            num = 0;
            for each(contact in eventObj.callstacksList)
            {
               list.push(new PhoneCallListEntry(contact,index,listType));
               index++;
               num++;
            }
            if(num == 0 && offset == 0)
            {
               emptyContact = new Object();
               list.push(new PhoneCallListEntry(emptyContact,0,listType));
            }
            dispatchEvent(new PhoneCallListEvent(listType,{
               "offset":offset,
               "list":list
            }));
         }
      }
   }
}

