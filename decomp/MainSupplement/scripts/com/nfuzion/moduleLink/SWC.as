package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ISWC;
   import com.nfuzion.moduleLinkAPI.ISWCEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class SWC extends Module implements ISWC
   {
      
      private static var instance:SWC;
      
      private static const dbusIdentifier:String = "SWC";
      
      private static const dbusSWCUpdateVolume:String = "UpdateVolume";
      
      private static const dbusSWCPhone_Press:String = "Phone_Press";
      
      private static const dbusSWCmodeAdvance:String = "modeAdvance";
      
      private static const dbusSWCpresetAdvance:String = "presetAdvance";
      
      private static const dbusSWCPTT_Press:String = "PTT_Press";
      
      private static const dbusSWCseekMinus:String = "seekMinus";
      
      private static const dbusSWCseekPlus:String = "seekPlus";
      
      private static const dbusSWCvolume:String = "volume";
      
      private static const dbusSWCVR3Press:String = "VR3_Press";
      
      private static const dbusSWCPhonePickUp:String = "phonePickUp";
      
      private static const dbusSWCPhoneHangUp:String = "phoneHangUp";
      
      private var connection:Connection;
      
      private var client:Client;
      
      public function SWC()
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
         this.connection.addEventListener(ConnectionEvent.SWC,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : SWC
      {
         if(instance == null)
         {
            instance = new SWC();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var rtnstr:String = null;
         var processed:Boolean = false;
         var swc:Object = e.data;
         if(swc.hasOwnProperty(dbusSWCUpdateVolume) && Boolean(swc.UpdateVolume.hasOwnProperty("vol")))
         {
            if(swc.UpdateVolume.vol != 0)
            {
               AudioSettings.getInstance().HWVolumeRelative = swc.UpdateVolume.vol;
            }
         }
         if(swc.hasOwnProperty(dbusSWCseekPlus))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.SEEK_PLUS));
         }
         if(swc.hasOwnProperty(dbusSWCseekMinus))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.SEEK_MINUS));
         }
         if(swc.hasOwnProperty(dbusSWCpresetAdvance))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PRESET_ADVANCE));
         }
         if(swc.hasOwnProperty(dbusSWCvolume))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.VOLUME,swc.volume.volume));
         }
         if(swc.hasOwnProperty(dbusSWCmodeAdvance))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.MODE_ADVANCE));
         }
         if(swc.hasOwnProperty(dbusSWCPTT_Press))
         {
            rtnstr = swc.PTT_Press.press;
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PTT_PRESS,rtnstr));
         }
         if(swc.hasOwnProperty(dbusSWCPhone_Press))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PHONE_PRESS));
         }
         if(swc.hasOwnProperty(dbusSWCVR3Press))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PTT_PRESS));
         }
         if(swc.hasOwnProperty(dbusSWCPhonePickUp))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PHONE_PRESS));
         }
         if(swc.hasOwnProperty(dbusSWCPhoneHangUp))
         {
            this.dispatchEvent(new ISWCEvent(ISWCEvent.PHONE_HANGUP));
         }
      }
      
      public function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendMultiSubscribe([dbusSWCUpdateVolume,dbusSWCPhone_Press,dbusSWCmodeAdvance,dbusSWCpresetAdvance,dbusSWCPTT_Press,dbusSWCseekMinus,dbusSWCseekPlus,dbusSWCvolume,dbusSWCVR3Press,dbusSWCPhonePickUp,dbusSWCPhoneHangUp]);
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
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
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
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

