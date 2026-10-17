package com.harman.moduleLink
{
   import com.adobe.serialization.json.JSON;
   import com.harman.moduleLinkAPI.IPersistency;
   import com.harman.moduleLinkAPI.PersistencyEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.span.Client;
   import flash.utils.Dictionary;
   
   public class Persistency extends Module implements IPersistency
   {
      
      private static const mPersistencyDbusIdentifier:String = "Persistency";
      
      private var ready:Boolean = true;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var values:Dictionary = new Dictionary();
      
      public function Persistency()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.connection.addEventListener(ConnectionEvent.PERSISTENCY,this.persistencyMessageHandler,false,0,true);
         this.start();
      }
      
      private function start() : void
      {
         this.values[PersistencyKeys.KEY_DISCLAIMER_ACCEPTED] = {"value":"false"};
         this.values[PersistencyKeys.KEY_SPLITSCREEN] = {"value":"none"};
         this.values[PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS] = {"value":0};
         this.values[PersistencyKeys.KEY_PROJECTION_AUTO_SHOW] = {"value":"false"};
         this.values[PersistencyKeys.KEY_PHEV_SELECTED_TAB] = {"value":"PowerFlow"};
         this.values[PersistencyKeys.KEY_REPLY_WITH_MESSAGE] = {"value":"false"};
         this.values[PersistencyKeys.KEY_AUTO_REPLY] = {"value":"call"};
         this.values[PersistencyKeys.KEY_AUTO_REPLY_MESSAGE] = {"value":"default"};
         this.read(PersistencyKeys.KEY_DISCLAIMER_ACCEPTED);
         this.read(PersistencyKeys.KEY_SPLITSCREEN);
         this.read(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS);
         this.read(PersistencyKeys.KEY_PROJECTION_AUTO_SHOW);
         this.read(PersistencyKeys.KEY_REPLY_WITH_MESSAGE);
         this.read(PersistencyKeys.KEY_AUTO_REPLY);
         this.read(PersistencyKeys.KEY_AUTO_REPLY_MESSAGE);
      }
      
      public function read(_key:String) : void
      {
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"Persistency\", \"packet\": {\"read\":{\"key\":\"" + _key + "\", \"escval\":0}}}";
         this.client.send(message);
      }
      
      public function write(_key:String, _o:Object) : void
      {
         this.values[_key] = _o;
         var message:String = "{\"Type\":\"Command\", \"Dest\":\"Persistency\", \"packet\": { \"write\": {\"" + _key + "\": {\"key\":\"" + _key + "\", \"value\":" + com.adobe.serialization.json.JSON.encode(_o) + " } }}}";
         this.client.send(message);
      }
      
      private function persistencyMessageHandler(e:ConnectionEvent) : void
      {
         var result:Object = e.data;
         if(result.hasOwnProperty("write"))
         {
            if(result.write.res == "success" || result.write.res == "Success")
            {
            }
         }
         else if(result.hasOwnProperty("read"))
         {
            if(result.read.hasOwnProperty("res"))
            {
               if(result.read.res.hasOwnProperty("key"))
               {
                  this.values[result.read.res.key] = result.read.res.value;
                  dispatchEvent(new PersistencyEvent(result.read.res.key,result.read.res.value));
               }
            }
            else if(result.read.hasOwnProperty("err"))
            {
               dispatchEvent(new PersistencyEvent(result.read.key,{"err":result.read.err}));
            }
         }
      }
      
      public function getValue(_key:String) : *
      {
         return this.values[_key];
      }
      
      override public function isReady() : Boolean
      {
         return this.ready;
      }
   }
}

