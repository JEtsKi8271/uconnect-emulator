package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ButtonPressAndHold extends ButtonMovieClip
   {
      
      public var id:int;
      
      private var mBeep:Boolean = false;
      
      private var mLongPress:Boolean = false;
      
      private var mLongPressTimer:Timer = new Timer(2000);
      
      public function ButtonPressAndHold()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         this.mLongPressTimer.addEventListener(TimerEvent.TIMER,this.onLongPress,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
      }
      
      override protected function setFont() : void
      {
      }
      
      override public function setState(state:int) : void
      {
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(STATE_DOWN);
         }
         this.mLongPress = false;
         this.mLongPressTimer.start();
      }
      
      override protected function onMouseOut(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(mActive ? int(STATE_ACTIVE) : int(STATE_UP));
         }
         if(this.mLongPress)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
         this.mLongPressTimer.stop();
         this.mLongPressTimer.reset();
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(mActive ? int(STATE_ACTIVE) : int(STATE_UP));
         }
         this.mLongPressTimer.reset();
         this.click();
      }
      
      override protected function click() : void
      {
         if(!this.mLongPress)
         {
            if(this.mBeep)
            {
               this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
            }
            this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         }
         else
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
      }
      
      protected function onLongPress(e:TimerEvent) : void
      {
         this.mLongPress = true;
         this.mLongPressTimer.reset();
         this.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this));
      }
      
      public function set beep(enable:Boolean) : void
      {
         this.mBeep = enable;
      }
      
      public function set delay(milliseconds:Number) : void
      {
         this.mLongPressTimer.delay = milliseconds;
      }
   }
}

