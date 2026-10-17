package com.harman.navigation
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   
   public class Watchdog
   {
      
      private static var mWatchdogCounter:int = 0;
      
      private var mNavService:Navigation;
      
      private var mWatchdogTimer:Timer = null;
      
      public function Watchdog(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.mWatchdogTimer = new Timer(NavGlobalSettings.NAV_WATCHDOG_INTERVAL);
         this.mWatchdogTimer.addEventListener(TimerEvent.TIMER,this.onWatchdogTimer,false,0,true);
         NavigationPackage.peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_SHUTDOWN_REQUEST,this.onShutdown,false,0,true);
      }
      
      public static function get watchdogCounter() : int
      {
         return mWatchdogCounter;
      }
      
      public function init() : void
      {
         var naviServerShadow:File = File.desktopDirectory.resolvePath(NavGlobalSettings.NAV_WATCHDOG_DISABLE_FLAG);
         if(naviServerShadow.exists == true)
         {
            Framework.Trace(" ~~~~~~~~~~~~~~ Navigation.Watchdog disabled (Flag) ~~~~~~~~~~~~~~~~");
            this.mWatchdogTimer.stop();
            return;
         }
         switch(Capabilities.manufacturer)
         {
            case "QNX":
               if(!this.mWatchdogTimer.running)
               {
                  this.mWatchdogTimer.start();
               }
               Framework.Trace("Navigation.Watchdog running (" + this.mWatchdogTimer.running + ")");
               break;
            case "Linux":
            case "Macintosh":
            case "Windows":
            default:
               Framework.Trace(" ~~~~~~~~~~~~~~ Navigation.Watchdog disabled (" + Capabilities.manufacturer + ") ~~~~~~~~~~~~~~~~");
               this.mWatchdogTimer.stop();
         }
      }
      
      private function onWatchdogTimer(e:TimerEvent) : void
      {
         var navService:File = File.desktopDirectory.resolvePath(NavGlobalSettings.NAV_WATCHDOG_PATH_SERVICE);
         var navIPC:File = File.desktopDirectory.resolvePath(NavGlobalSettings.NAV_WATCHDOG_PATH_IPC);
         if(navService.exists == false || navIPC.exists == false)
         {
            if(mWatchdogCounter < NavGlobalSettings.NAV_WATCHDOG_MAX_RESTARTS)
            {
               ++mWatchdogCounter;
               Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
               Framework.Trace(" ~~~~~~~~~~~~~~ Watchdog ~~~~~~~~~~~~~~~~");
               Framework.Trace(" ~~~~  NAVIGATION SERVICE NOT FOUND  ~~~~");
               if(navService.exists == false)
               {
                  Framework.Trace(" ~~~~~~~~~~~~~~~~ IPC ~~~~~~~~~~~~~~~~~~~");
               }
               if(navIPC.exists == false)
               {
                  Framework.Trace(" ~~~~~~~~~~~~~~~ D-BUS ~~~~~~~~~~~~~~~~~~");
               }
               Framework.Trace(" ~~~~~~~~~~~~ RESTART " + mWatchdogCounter + "/" + NavGlobalSettings.NAV_WATCHDOG_MAX_RESTARTS + " ~~~~~~~~~~~~~~~");
               Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
               this.suspend();
               this.initRestart();
            }
            else
            {
               Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
               Framework.Trace(" ~~~~~~~~~~~~~~ Watchdog ~~~~~~~~~~~~~~~~");
               Framework.Trace(" ~~~~  NAVIGATION SERVICE NOT FOUND  ~~~~");
               Framework.Trace(" ~~~~~~   MAXIMUM RETRIES REACHED   ~~~~~");
               Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
               this.mWatchdogTimer.stop();
            }
         }
      }
      
      private function onShutdown(e:AntiTheftEvent) : void
      {
         Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
         Framework.Trace(" ~~~~~~~~~ Disabled Watchdog ~~~~~~~~~~~~");
         Framework.Trace(" ~~~~~~~~~  due to shutdown  ~~~~~~~~~~~~");
         Framework.Trace(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
         this.suspend();
      }
      
      private function initRestart() : void
      {
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.TRAIL_SERVICE_READY,this.onTrailServiceReady,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.getTrailServiceReady();
      }
      
      private function onTrailServiceReady(e:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navigation.trailServiceReady)
         {
            NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.TRAIL_SERVICE_READY,this.onTrailServiceReady);
            NavigationPackage.peripheral.navigation.navigation.setForceSendConsoleCommand("navRestart.sh &");
            NavigationPackage.peripheral.navigation.reinitialize();
         }
      }
      
      private function suspend() : void
      {
         this.mWatchdogTimer.stop();
         this.mWatchdogTimer.reset();
      }
   }
}

