package com.harman.navigation.utils
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class NavGateKeeper extends Timer
   {
      
      public function NavGateKeeper(delay:Number, repeatCount:int = 0)
      {
         super(delay,repeatCount);
         addEventListener(TimerEvent.TIMER,this.onTimerComplete,false,0,true);
      }
      
      public function dispose() : void
      {
         removeEventListener(TimerEvent.TIMER,this.onTimerComplete);
      }
      
      private function onTimerComplete(evt:TimerEvent) : void
      {
         stop();
      }
   }
}

