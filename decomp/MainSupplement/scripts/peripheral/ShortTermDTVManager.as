package peripheral
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ShortTermDTVManager extends EventDispatcher
   {
      
      private var mDtvAvailable:Boolean = false;
      
      private var mDtvTimer:Timer = new Timer(8000);
      
      public function ShortTermDTVManager()
      {
         super();
         if(Peripheral.vehConfig.dtvShortTermPresent)
         {
            this.init();
         }
      }
      
      public function init() : void
      {
         this.mDtvTimer.addEventListener(TimerEvent.TIMER,this.onDTVTimer,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         this.onIgnitionState(null);
      }
      
      public function get DTVAvailable() : Boolean
      {
         return !Peripheral.vehConfig.dtvShortTermPresent || this.mDtvAvailable;
      }
      
      private function onDTVTimer(e:TimerEvent) : void
      {
         this.mDtvAvailable = true;
         this.mDtvTimer.stop();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         switch(Peripheral.antiTheft.ignitionState)
         {
            case "start":
            case "lock":
               this.mDtvAvailable = false;
               this.mDtvTimer.reset();
               dispatchEvent(new Event(Event.CHANGE));
               break;
            default:
               this.mDtvTimer.start();
         }
      }
   }
}

