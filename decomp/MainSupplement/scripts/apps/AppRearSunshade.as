package apps
{
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppRearSunshade extends App
   {
      
      private const VEHICLE_UP:String = "up";
      
      private const VEHICLE_DN:String = "down";
      
      protected var mButtonUpTimer:Timer = null;
      
      public function AppRearSunshade()
      {
         super();
         id = ID.REARSUNSHADE;
      }
      
      override public function get cp() : IApp
      {
         return new AppRearSunshade();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_SUNSHADE);
         }
         return Text.getText(T.STRB_REAR_SUNSHADE);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_RearSunshade();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Peripheral.vehSettings.addEventListener(VehSettingsEvent.SUN_SHADE_POSITION,this.onSunshadePosition,false,0,true);
         mButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDn,false,0,true);
         mButton.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         mButton.addEventListener(MouseEvent.ROLL_OUT,this.onMouseUp,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Peripheral.vehSettings.removeEventListener(VehSettingsEvent.SUN_SHADE_POSITION,this.onSunshadePosition);
         mButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDn);
         mButton.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         mButton.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseUp);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(!favorite)
         {
            if(!this.mButtonUpTimer)
            {
               this.mButtonUpTimer = new Timer(150,1);
            }
            if(this.mButtonUpTimer)
            {
               this.cancelTimer();
               this.mButtonUpTimer.addEventListener(TimerEvent.TIMER,this.onTimerExpire);
               this.mButtonUpTimer.delay = 150;
               this.mButtonUpTimer.start();
            }
            Peripheral.vehSettings.setSunShadePosition(this.VEHICLE_DN);
         }
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.getText(T.STRB_SUNSHADE);
         }
         else
         {
            Text.format(this.button.label,T.STRB_REAR_SUNSHADE);
         }
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Peripheral.vehSettings.sunShadePosition() != this.VEHICLE_UP);
      }
      
      private function onSunshadePosition(e:VehSettingsEvent) : void
      {
         this.refresh();
      }
      
      private function onMouseDn(e:MouseEvent) : void
      {
         if(favorite)
         {
            Peripheral.vehSettings.setSunShadePosition(this.VEHICLE_DN);
         }
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         if(favorite)
         {
            Peripheral.vehSettings.setSunShadePosition(this.VEHICLE_UP);
         }
      }
      
      private function onTimerExpire(e:TimerEvent) : void
      {
         Peripheral.vehSettings.setSunShadePosition(this.VEHICLE_UP);
         this.mButtonUpTimer.removeEventListener(TimerEvent.TIMER,this.onTimerExpire);
         this.mButtonUpTimer.stop();
      }
      
      private function cancelTimer() : void
      {
         if(Boolean(this.mButtonUpTimer) && this.mButtonUpTimer.running)
         {
            if(this.mButtonUpTimer.hasEventListener(TimerEvent.TIMER))
            {
               this.mButtonUpTimer.removeEventListener(TimerEvent.TIMER,this.onTimerExpire);
            }
            this.mButtonUpTimer.stop();
         }
      }
   }
}

