package decorations
{
   import ancillary.Style;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.*;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class Button extends Simple
   {
      
      private var mButton:MovieClip;
      
      private var mSelected:Boolean = false;
      
      private var mAutoRepeatPeriod:int = Style.Button.AUTO_REPEAT_PERIOD;
      
      private var mAutoRepeatDelay:int = Style.Button.AUTO_REPEAT_DELAY;
      
      private var mUpStateDelayTimer:Timer;
      
      private var mLongPressTimer:Timer;
      
      private var mAutoRepeatTimer:Timer;
      
      private var mDirectClick:Boolean = false;
      
      private var mButtonDown:Boolean = false;
      
      private var mToggleMode:Boolean = false;
      
      private var mInteractive:Boolean = true;
      
      private var mBeepEnable:Boolean = true;
      
      private var mFrameSuffix:String = Style.Button.DEFAULT_FRAME_SUFFIX;
      
      private var mLongPressDelay:int = Style.Button.LONG_PRESS_DELAY;
      
      public function Button(button:MovieClip)
      {
         super(button);
         this.mButton = button;
         this.mButton.mouseChildren = false;
         this.mButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.mButton.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         this.mButton.addEventListener(MouseEvent.MOUSE_UP,this.onDirectUp,false,0,true);
         this.mButton.addEventListener(MouseEvent.CLICK,this.onCancelMouseEvent,false,int.MAX_VALUE,false);
         this.mButton.addEventListener(MouseEvent.MOUSE_UP,this.onCancelMouseEvent,false,int.MAX_VALUE,false);
      }
      
      public function getSelected() : Boolean
      {
         return this.mSelected;
      }
      
      public function setSelected(selected:Boolean) : void
      {
         this.cleanupButtonUpDelayTimer();
         this.mSelected = selected;
         this.update();
      }
      
      override public function setEnabled(enable:Boolean) : void
      {
         this.cleanupButtonUpDelayTimer();
         super.setEnabled(enable);
      }
      
      public function getLongPressDelay() : int
      {
         return this.mLongPressDelay;
      }
      
      public function setLongPressDelay(delay:int) : void
      {
         this.mLongPressDelay = delay;
      }
      
      private function onDown(event:MouseEvent) : void
      {
         if(this.mInteractive)
         {
            this.createLongPressTimer();
            this.mButtonDown = true;
            if(this.mBeepEnable)
            {
               Framework.messenger.dispatchEvent(this.mButton.enabled ? new SoundEvent(SoundEvent.CLICK) : new SoundEvent(SoundEvent.REJECT));
            }
         }
         this.mDirectClick = true;
         if(this.mInteractive && this.mAutoRepeatDelay > 0)
         {
            this.onAutoRepeat();
            this.createAutoRepeatTimer();
         }
         this.mButton.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.mButton.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         this.mButton.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this.mButton,true));
         this.update();
      }
      
      private function onOver(event:MouseEvent) : void
      {
         if(this.mDirectClick)
         {
            this.onDown(event);
         }
      }
      
      private function onUp(event:MouseEvent) : void
      {
         try
         {
            this.mDirectClick = false;
            this.onOut(event);
            this.mButton.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.mButton.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         }
         catch(e:Error)
         {
            Framework.Trace("WARNING: Button decorator failed in onUp().");
         }
      }
      
      private function onCancelMouseEvent(event:MouseEvent) : void
      {
         if(!this.mInteractive)
         {
            event.stopImmediatePropagation();
            if(this.mBeepEnable && this.mDirectClick && MouseEvent.MOUSE_UP == event.type)
            {
               Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
            }
         }
      }
      
      private function onDirectUp(event:MouseEvent) : void
      {
         if(this.mDirectClick && this.mInteractive)
         {
            if(this.mToggleMode)
            {
               this.setSelected(!this.mSelected);
            }
            else
            {
               this.mButtonDown = false;
               this.update();
            }
            this.mButton.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this.mButton,true));
         }
         else if(this.mBeepEnable && this.mDirectClick)
         {
            Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
         }
      }
      
      private function onOut(event:MouseEvent) : void
      {
         if(this.mInteractive)
         {
            this.cleanupLongPressTimer();
            this.cleanupAutoRepeatTimer();
            this.mButtonDown = false;
            if(Style.Button.UP_STATE_DELAY > 0)
            {
               this.createButtonUpDelayTimer();
            }
            else
            {
               this.onButtonUpDelayComplete();
            }
         }
      }
      
      private function onDownLong(event:TimerEvent) : void
      {
         this.cleanupLongPressTimer();
         if(this.mAutoRepeatPeriod > 0)
         {
            this.createAutoRepeatTimer();
         }
         this.mDirectClick = false;
         this.mButton.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this.mButton,true));
         this.onAutoRepeat();
      }
      
      private function onAutoRepeat(e:TimerEvent = null) : void
      {
         this.mButton.dispatchEvent(new WidgetEvent(WidgetEvent.AUTO_CLICK,this.mButton,true));
         if(this.mAutoRepeatPeriod > 0)
         {
            if(this.mAutoRepeatPeriod != this.mAutoRepeatDelay && null != this.mAutoRepeatTimer)
            {
               this.mAutoRepeatTimer.delay = this.mAutoRepeatPeriod;
            }
         }
         else
         {
            this.cleanupAutoRepeatTimer();
         }
      }
      
      private function onButtonUpDelayComplete(event:TimerEvent = null) : void
      {
         this.cleanupButtonUpDelayTimer();
         this.update();
      }
      
      public function setToggleMode(toggleMode:Boolean) : void
      {
         this.mToggleMode = toggleMode;
      }
      
      public function getToggleMode() : Boolean
      {
         return this.mToggleMode;
      }
      
      public function setAutoRepeatPeriod(period:int) : void
      {
         this.mAutoRepeatPeriod = period;
      }
      
      public function getAutoRepeatPeriod() : int
      {
         return this.mAutoRepeatPeriod;
      }
      
      public function setAutoRepeatDelay(delay:int) : void
      {
         this.mAutoRepeatDelay = delay;
      }
      
      public function getAutoRepeatDelay() : int
      {
         return this.mAutoRepeatDelay;
      }
      
      override public function update() : void
      {
         var newFrame:String = null;
         if(!this.mButton.enabled)
         {
            newFrame = "disabled" + this.mFrameSuffix;
         }
         else if(this.mButtonDown)
         {
            newFrame = "down" + this.mFrameSuffix;
         }
         else if(this.mSelected)
         {
            newFrame = "active" + this.mFrameSuffix;
         }
         else
         {
            newFrame = "up" + this.mFrameSuffix;
         }
         if(newFrame)
         {
            try
            {
               this.mButton.gotoAndStop(newFrame);
            }
            catch(e:ArgumentError)
            {
            }
         }
      }
      
      public function toggle() : void
      {
         this.setSelected(!this.getSelected());
         this.mButton.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this.mButton,true));
         Framework.messenger.dispatchEvent(new SoundEvent(SoundEvent.TOGGLE));
      }
      
      public function setFrameSuffix(frameSuffix:String = null) : void
      {
         if(frameSuffix == null)
         {
            frameSuffix = Style.Button.DEFAULT_FRAME_SUFFIX;
         }
         this.mFrameSuffix = frameSuffix;
         this.update();
      }
      
      public function getFrameSuffix() : String
      {
         return this.mFrameSuffix;
      }
      
      override public function getInteractive() : Boolean
      {
         return this.mInteractive;
      }
      
      override public function setInteractive(interactive:Boolean) : void
      {
         this.mInteractive = interactive;
      }
      
      public function setBeepEnabled(enable:Boolean) : void
      {
         this.mBeepEnable = enable;
      }
      
      public function getBeepEnabled() : Boolean
      {
         return this.mBeepEnable;
      }
      
      private function cleanupLongPressTimer() : void
      {
         if(null != this.mLongPressTimer)
         {
            this.mLongPressTimer.stop();
            this.mLongPressTimer.removeEventListener(TimerEvent.TIMER,this.onDownLong);
            this.mLongPressTimer = null;
         }
      }
      
      private function createLongPressTimer() : void
      {
         if(null == this.mLongPressTimer)
         {
            this.mLongPressTimer = new Timer(this.mLongPressDelay);
            this.mLongPressTimer.addEventListener(TimerEvent.TIMER,this.onDownLong,false,0,true);
         }
         this.mLongPressTimer.start();
      }
      
      private function cleanupAutoRepeatTimer() : void
      {
         if(null != this.mAutoRepeatTimer)
         {
            this.mAutoRepeatTimer.stop();
            this.mAutoRepeatTimer.removeEventListener(TimerEvent.TIMER,this.onAutoRepeat);
            this.mAutoRepeatTimer = null;
         }
      }
      
      private function createAutoRepeatTimer() : void
      {
         if(null == this.mAutoRepeatTimer)
         {
            this.mAutoRepeatTimer = new Timer(this.mAutoRepeatDelay);
            this.mAutoRepeatTimer.addEventListener(TimerEvent.TIMER,this.onAutoRepeat,false,0,true);
         }
         this.mAutoRepeatTimer.delay = this.mAutoRepeatDelay;
         this.mAutoRepeatTimer.start();
      }
      
      private function cleanupButtonUpDelayTimer() : void
      {
         if(Style.Button.UP_STATE_DELAY > 0 && null != this.mUpStateDelayTimer)
         {
            this.mUpStateDelayTimer.stop();
            this.mUpStateDelayTimer.removeEventListener(TimerEvent.TIMER,this.onButtonUpDelayComplete);
            this.mUpStateDelayTimer = null;
         }
      }
      
      private function createButtonUpDelayTimer() : void
      {
         if(Style.Button.UP_STATE_DELAY > 0 && null == this.mUpStateDelayTimer)
         {
            this.mUpStateDelayTimer = new Timer(Style.Button.UP_STATE_DELAY);
            this.mUpStateDelayTimer.addEventListener(TimerEvent.TIMER,this.onButtonUpDelayComplete,false,0,true);
         }
         if(null != this.mUpStateDelayTimer)
         {
            this.mUpStateDelayTimer.start();
         }
      }
   }
}

