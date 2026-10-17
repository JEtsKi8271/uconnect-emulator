package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.IDABTunerFollowMaster;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DABTunerFollowMaster extends Module implements IDABTunerFollowMaster
   {
      
      private static var instance:DABTunerFollowMaster;
      
      private static const mDbusIdentifier:String = "DABTunerFollowMaster";
      
      private const FollowingSwitch:String = "followingSwitch";
      
      private const FollowingState:String = "followingState";
      
      private var mFollowingSwitch:Boolean;
      
      private var mFollowingStateMaster:int;
      
      private var mFollowingStateSlave:int;
      
      private var m_Ready:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function DABTunerFollowMaster()
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
         this.connection.addEventListener(ConnectionEvent.DAB_TUNER_FOLLOW_MASTER,this.MessageHandler);
      }
      
      public static function getInstance() : DABTunerFollowMaster
      {
         if(instance == null)
         {
            instance = new DABTunerFollowMaster();
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
         var TunerFollowMaster:Object = e.data;
         if(TunerFollowMaster.hasOwnProperty("dBusServiceAvailable"))
         {
            if(TunerFollowMaster.dBusServiceAvailable == "true")
            {
               this.requestGetFollowingSwitch();
            }
         }
         else if(TunerFollowMaster.hasOwnProperty(this.FollowingSwitch))
         {
            this.mFollowingSwitch = TunerFollowMaster.followingSwitch.followingSwitch;
            this.dispatchEvent(new DABEvent(DABEvent.DAB_FOLLOWING_SWITCH));
         }
         else if(TunerFollowMaster.hasOwnProperty(this.FollowingState))
         {
            if(this.mFollowingStateMaster != TunerFollowMaster.followingState.followingState.master)
            {
               this.mFollowingStateMaster = TunerFollowMaster.followingState.followingState.master;
            }
            if(this.mFollowingStateSlave != TunerFollowMaster.followingState.followingState.slave)
            {
               this.mFollowingStateMaster = TunerFollowMaster.followingState.followingState.slave;
               this.dispatchEvent(new DABEvent(DABEvent.DAB_FOLLOWING_STATE));
            }
         }
      }
      
      public function get followingSwitch() : Boolean
      {
         return this.mFollowingSwitch;
      }
      
      public function get followingStateMaster() : int
      {
         return this.mFollowingStateMaster;
      }
      
      public function get followingStateSlave() : int
      {
         return this.mFollowingStateSlave;
      }
      
      public function requestSetFollowingSwitch(enable:Boolean) : void
      {
         if(this.mFollowingSwitch != enable)
         {
            this.mFollowingSwitch = enable;
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestSetFollowingSwitch\":{\"enable\":" + enable + "}}}");
         }
      }
      
      public function requestGetFollowingSwitch() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestGetDab2FmLinkingSwitch\":{}}}");
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
         this.sendSubscribe(this.FollowingSwitch);
      }
   }
}

