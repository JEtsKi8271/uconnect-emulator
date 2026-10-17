package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IPodTagInfo;
   import com.harman.moduleLinkAPI.IPodTaggerEvent;
   import com.harman.moduleLinkAPI.IiPodTagger;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class iPodTagger extends Module implements IiPodTagger
   {
      
      private static var instance:iPodTagger;
      
      private static const DBUS_ID:String = "TaggingService";
      
      public static const PROP_LOCAL_STATUS:String = "localStatus";
      
      public static const PROP_CONNECTION_STATUS:String = "connectionStatus";
      
      public static const PROP_TRANSFER_STATUS:String = "transferStatus";
      
      private static const SIGNAL_CONTENT_TAGGABLE:String = "tagContentTaggableInd";
      
      private static const SIGNAL_TAGS_AUTOSTORED:String = "tagsAutoStored";
      
      private static const SIGNAL_LOCAL_STATUS:String = "tagsLocalStatus";
      
      private static const SIGNAL_TAG_RESULT:String = "tagRequest";
      
      private static const SIGNAL_TRANSFER_STATUS:String = "transferStatus";
      
      private static const GET_PROPERTIES:String = "getProperties";
      
      private var mConnection:Connection;
      
      private var mClient:Client;
      
      private var mIPodTaggerAvailable:Boolean = false;
      
      private var mCurrentTaggerInfo:IPodTagInfo;
      
      private var mCanTagCurrent:Boolean = false;
      
      private var mCurrentIsTagged:Boolean = false;
      
      private var mDevices:Array = new Array();
      
      private var mMaxTags:uint = 0;
      
      private var mCurrentTags:uint = 0;
      
      private var transferStatusMSID:int = 0;
      
      private var transferStatusName:String = "";
      
      private var transferStatusValue:int = 0;
      
      public function iPodTagger()
      {
         super();
         this.mCurrentTaggerInfo = new IPodTagInfo();
         this.mConnection = Connection.share();
         this.mClient = this.mConnection.span;
         this.mClient.addEventListener(Event.CONNECT,this.connected);
         this.mClient.addEventListener(Event.CLOSE,this.disconnected);
         this.mConnection.addEventListener(ConnectionEvent.TAGGING_SERVICE,this.messageHandler);
         if(this.mClient.connected)
         {
            this.connected();
         }
      }
      
      public static function getInstance() : iPodTagger
      {
         if(instance == null)
         {
            instance = new iPodTagger();
         }
         return instance;
      }
      
      public function connected(e:Event = null) : void
      {
         if(this.mConnection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.initialize();
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.mConnection.configured) && Boolean(this.mClient.connected);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var message:Object = null;
         if(e.data.hasOwnProperty("dBusServiceAvailable"))
         {
            if(e.data.dBusServiceAvailable == "true" && this.mIPodTaggerAvailable == false)
            {
               this.mIPodTaggerAvailable = true;
               this.initialize();
            }
            else
            {
               this.mIPodTaggerAvailable = false;
            }
         }
         else
         {
            message = e.data;
            if(message.hasOwnProperty(GET_PROPERTIES))
            {
               this.processProperties(message.getProperties.props);
            }
            else if(message.hasOwnProperty(SIGNAL_CONTENT_TAGGABLE))
            {
               this.processSignalContentTaggable(message.tagContentTaggableInd);
            }
            else if(message.hasOwnProperty(SIGNAL_TAG_RESULT))
            {
               this.processTagResult(message.tagRequest);
            }
            else if(message.hasOwnProperty(SIGNAL_TAGS_AUTOSTORED))
            {
               this.processTagResult(message.tagsAutoStored);
            }
            else if(message.hasOwnProperty(SIGNAL_LOCAL_STATUS))
            {
               this.processLocalStatus(message[SIGNAL_LOCAL_STATUS]);
            }
            else if(message.hasOwnProperty(SIGNAL_TRANSFER_STATUS))
            {
               dispatchEvent(new IPodTaggerEvent(IPodTaggerEvent.TRANSFER_RESULT,message));
            }
            else
            {
               trace("iPodTagger Unknown message: " + message);
            }
         }
      }
      
      private function processProperties(props:Object) : void
      {
         var device:Object = null;
         if(props != null)
         {
            if(props.hasOwnProperty(PROP_CONNECTION_STATUS))
            {
               this.mDevices.length = 0;
               if(props.connectionStatus.hasOwnProperty("Devices"))
               {
                  for each(device in props.connectionStatus.Devices)
                  {
                     this.mDevices.push(device);
                  }
               }
               dispatchEvent(new IPodTaggerEvent(IPodTaggerEvent.IPOD_CONNECTION));
            }
            if(props.hasOwnProperty(PROP_LOCAL_STATUS))
            {
               this.processLocalStatus(props.localStatus);
            }
            if(props.hasOwnProperty(PROP_TRANSFER_STATUS))
            {
               this.transferStatusMSID = props.transferStatus.MSID;
               this.transferStatusName = props.transferStatus.Name;
               this.transferStatusValue = props.transferStatus.Value;
            }
         }
      }
      
      private function processSignalContentTaggable(message:Object) : void
      {
         var tagDataChanged:Boolean = false;
         var currentTaggerInfo:IPodTagInfo = null;
         var canTagCurrent:Boolean = false;
         var currentIsTagged:Boolean = false;
         var tagInfo:Object = null;
         if(message != null)
         {
            tagDataChanged = false;
            currentTaggerInfo = new IPodTagInfo();
            canTagCurrent = false;
            currentIsTagged = false;
            canTagCurrent = Boolean(message.isTaggable);
            currentIsTagged = Boolean(message.isTagged);
            if(message.hasOwnProperty("tagInfo"))
            {
               tagInfo = message.tagInfo;
               currentTaggerInfo.artist = tagInfo.artist;
               currentTaggerInfo.songId = tagInfo.songId;
               currentTaggerInfo.title = tagInfo.title;
            }
            if(currentIsTagged)
            {
               canTagCurrent = false;
            }
            if(canTagCurrent != this.mCanTagCurrent)
            {
               this.mCanTagCurrent = canTagCurrent;
               tagDataChanged = true;
            }
            if(currentIsTagged != this.mCurrentIsTagged)
            {
               this.mCurrentIsTagged = currentIsTagged;
               tagDataChanged = true;
            }
            if(this.mCurrentTaggerInfo.isDifferent(currentTaggerInfo))
            {
               this.mCurrentTaggerInfo = currentTaggerInfo;
               tagDataChanged = true;
            }
            if(tagDataChanged)
            {
               dispatchEvent(new IPodTaggerEvent(IPodTaggerEvent.IS_TAGGABLE));
            }
         }
      }
      
      private function processLocalStatus(message:Object) : void
      {
         if(message != null)
         {
            this.mCurrentTags = message.Current;
            this.mMaxTags = message.Max;
            dispatchEvent(new IPodTaggerEvent(IPodTaggerEvent.TAG_COUNT,message));
         }
      }
      
      private function processTagResult(message:Object) : void
      {
         var fixMsg:Object = null;
         if(message != null)
         {
            if(message.Status != null)
            {
               fixMsg = new Object();
               fixMsg.Name = message.Status.Name;
               fixMsg.Value = int(message.Status.Value);
               message = fixMsg;
            }
            this.transferStatusName = message.Name;
            this.transferStatusValue = message.Value;
            switch(this.transferStatusValue)
            {
               case IPodTaggerEvent.TagStoredLocal:
               case IPodTaggerEvent.TagStoredToTarget:
                  this.mCurrentIsTagged = true;
            }
            dispatchEvent(new IPodTaggerEvent(IPodTaggerEvent.TRANSFER_RESULT,message));
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.mClient.send(message);
      }
      
      private function sendMultiSubscribeToId(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + DBUS_ID + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.mClient.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + DBUS_ID + "\", \"Signal\": \"" + signalName + "\"}";
         this.mClient.send(message);
      }
      
      private function sendRequest(request:String) : void
      {
         var message:String = null;
         if(request != null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + DBUS_ID + "\", \"packet\": { " + request + " }}";
            this.mClient.send(message);
         }
      }
      
      private function initialize() : void
      {
         this.sendSubscribe(SIGNAL_CONTENT_TAGGABLE);
         this.sendSubscribe(SIGNAL_TAGS_AUTOSTORED);
         this.sendSubscribe(SIGNAL_LOCAL_STATUS);
         this.sendSubscribe(SIGNAL_TAG_RESULT);
         this.getAllProperties();
      }
      
      public function tagRequest(tagInfo:IPodTagInfo) : void
      {
         var msg:String = null;
         if(tagInfo != null)
         {
            msg = "\"tagRequest\":{\"tagInfo\":{\"artist\":\"" + tagInfo.artist + "\",\"songId\":" + tagInfo.songId + ",\"title\":\"" + tagInfo.title + "\"}}";
            trace("Tagging request" + msg);
            this.sendRequest(msg);
         }
      }
      
      public function clearAllLocalTags() : void
      {
         this.sendRequest("tagClearAllLocal");
      }
      
      public function getProperties(propertyArray:Array) : void
      {
         var msg:String = null;
         var i:uint = 0;
         if(propertyArray.length > 0)
         {
            for(msg = "{\"Type\":\"Command\", \"Dest\":\"" + DBUS_ID + "\", \"packet\": { \"" + "getProperties" + "\": { \"" + "props" + "\": ["; i < propertyArray.length; )
            {
               msg = msg + "\"" + propertyArray[i] + "\"";
               if(propertyArray[i + 1])
               {
                  msg += ",";
               }
               i++;
            }
            msg += "]}}}";
            this.mClient.send(msg);
         }
      }
      
      public function getAllProperties() : void
      {
         this.getProperties([PROP_CONNECTION_STATUS,PROP_LOCAL_STATUS,PROP_TRANSFER_STATUS]);
      }
      
      public function canTagCurrent(tagInfo:IPodTagInfo) : Boolean
      {
         var canTag:Boolean = false;
         if(!this.mCurrentIsTagged)
         {
            canTag = this.mCanTagCurrent && this.mCurrentTaggerInfo.isSame(tagInfo);
         }
         return canTag;
      }
      
      public function isTagged(tagInfo:IPodTagInfo) : Boolean
      {
         return this.mCurrentIsTagged && this.mCurrentTaggerInfo.isSame(tagInfo);
      }
   }
}

