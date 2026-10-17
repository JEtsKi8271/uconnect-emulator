package com.harman.navigation.utils
{
   import com.harman.navigation.Navigation;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DeferredPersistenceHandler
   {
      
      private static const NAV_PERSISTENCE_DELAY:int = 15000;
      
      private var mParent:Navigation = null;
      
      private var mNavPersistenceTimer:Timer = null;
      
      private var mNavPersistenceData:Object = null;
      
      public function DeferredPersistenceHandler(parent:Navigation)
      {
         super();
         this.mParent = parent;
      }
      
      public function setNavPersistence(data:Object) : void
      {
         this.mNavPersistenceTimer = new Timer(NAV_PERSISTENCE_DELAY,1);
         this.mNavPersistenceTimer.addEventListener(TimerEvent.TIMER,this.onNavPersistenceTimer,false,0,true);
         this.mNavPersistenceData = data;
         this.mNavPersistenceTimer.start();
      }
      
      private function onNavPersistenceTimer(e:TimerEvent) : void
      {
         var processedSpeedWarning:Boolean = false;
         var processedTmcSettings:Boolean = false;
         var i:String = null;
         this.mNavPersistenceTimer = null;
         if(this.mNavPersistenceData != null)
         {
            processedSpeedWarning = false;
            processedTmcSettings = false;
            for(i in this.mNavPersistenceData)
            {
               if(i == "SLW_E" || i == "SLW_S")
               {
                  if(!processedSpeedWarning)
                  {
                     this.mParent.voiceGudanceManager.setSpeedWarningsSettings(this.mNavPersistenceData["SLW_E"] == "true" ? true : false,Number(this.mNavPersistenceData["SLW_S"]),false);
                     processedSpeedWarning = true;
                  }
               }
               if(i == "TMC_RM" || i == "TMC_DT")
               {
                  if(!processedTmcSettings)
                  {
                     this.mParent.tmcManager.setTMCRouteMode(int(this.mNavPersistenceData["TMC_RM"]),false,false);
                     this.mParent.tmcManager.setTMCDelayTime(int(this.mNavPersistenceData["TMC_DT"]),false);
                     processedTmcSettings = true;
                  }
               }
            }
         }
         this.mNavPersistenceData = null;
      }
   }
}

