package com.harman.navigation.instrumentCluster
{
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.moduleLink.ConnectionEvent;
   
   public class instrumentClusterManager
   {
      
      private var mParent:Navigation;
      
      private var localInstrumentClusterEnabled:Boolean = true;
      
      public function instrumentClusterManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
      }
      
      public function setInstrumentClusterEnabled(enable:Boolean) : void
      {
         this.setInstrumentClusterEnabledNoPersistCall(enable);
         this.mParent.savePersistence();
      }
      
      public function setInstrumentClusterEnabledNoPersistCall(enable:Boolean) : void
      {
         this.localInstrumentClusterEnabled = enable;
         this.mParent.sendCommandNavCluster("\"IC_SetEnabled\":{\"enable\":" + enable + "}");
      }
      
      public function getInstrumentClusterEnabled() : void
      {
         this.mParent.sendEvent(NavigationEvent.NAV_INSTRUMENT_CLUSTER);
      }
      
      public function get instrumentClusterEnabled() : Boolean
      {
         return this.localInstrumentClusterEnabled;
      }
      
      public function instrumentClusterMessageHandler(e:ConnectionEvent) : void
      {
         if(e.hasOwnProperty("data"))
         {
            if(e.data.hasOwnProperty("IC_SetEnabled"))
            {
               if(e.data.IC_SetEnabled.hasOwnProperty("enable"))
               {
                  this.localInstrumentClusterEnabled = Boolean(e.data.IC_SetEnabled.enable);
                  this.mParent.sendEvent(NavigationEvent.NAV_INSTRUMENT_CLUSTER);
               }
            }
            else if(e.data.hasOwnProperty("JSON_GetProperties"))
            {
               if(e.data.JSON_GetProperties.hasOwnProperty("outprop"))
               {
                  if(e.data.JSON_GetProperties.outprop.hasOwnProperty("IC_IsEnabled"))
                  {
                     this.localInstrumentClusterEnabled = Boolean(e.data.JSON_GetProperties.outprop.IC_IsEnabled);
                     this.mParent.sendEvent(NavigationEvent.NAV_INSTRUMENT_CLUSTER);
                  }
               }
            }
         }
         this.mParent.sendEvent(NavigationEvent.NAV_INSTRUMENT_CLUSTER);
      }
      
      private function getInstrumentClusterServiceSetting() : void
      {
         this.mParent.getPropertyNavCluster("IC_IsEnabled");
      }
   }
}

