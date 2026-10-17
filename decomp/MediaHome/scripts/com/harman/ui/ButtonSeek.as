package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import skin.Skin;
   
   public class ButtonSeek extends ButtonMovieClip
   {
      
      public var icon:MovieClip;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      private var mBeep:Boolean = true;
      
      private var mLongPress:Boolean = false;
      
      private var mLongPressTimer:Timer = new Timer(2000);
      
      public function ButtonSeek()
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
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
         }
         mCurrentState = state;
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
         this.mLongPressTimer.reset();
         if(this.mLongPress && Boolean(mEnabled))
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
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
            if(mEnabled)
            {
               this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
            }
         }
         else if(mEnabled)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this));
         }
      }
      
      private function onLongPress(e:TimerEvent) : void
      {
         this.mLongPress = true;
         this.mLongPressTimer.reset();
         if(mEnabled)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this));
         }
      }
      
      public function set beep(enable:Boolean) : void
      {
         this.mBeep = enable;
      }
      
      public function set longPressDelay(_delay:Number) : void
      {
         this.mLongPressTimer.delay = _delay;
      }
   }
}

