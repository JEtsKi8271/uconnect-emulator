package com.harman.navigation.global.vServices
{
   import com.nfuzion.moduleLinkAPI.Module;
   
   public class VServiceEventDispatcher extends Module
   {
      
      public function VServiceEventDispatcher()
      {
         super();
      }
      
      public function sendEvent(event:String, data:* = null) : void
      {
         dispatchEvent(new VServiceEventDispatcherEvent(event,data));
      }
   }
}

