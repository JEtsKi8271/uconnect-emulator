package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import skin.Skin;
   
   public class ButtonPreset extends ButtonMovieClip
   {
      
      public var id:int;
      
      public var labelNbr:TextField;
      
      public var labelName:TextField;
      
      public var labelHoldToSet:TextField;
      
      public var down:MovieClip;
      
      public var active:MovieClip;
      
      private var mBeep:Boolean = false;
      
      private var mLongPress:Boolean = false;
      
      private var mLongPressTimer:Timer = new Timer(2000);
      
      public function ButtonPreset()
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
         Skin.style.applyFont(this.labelNbr,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelName,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.labelHoldToSet,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.labelNbr,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.labelName,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.labelHoldToSet,Skin.style.currentTheme.disabledText);
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.down.visible = false;
               this.active.visible = false;
               break;
            case STATE_DOWN:
               this.down.visible = true;
               this.active.visible = false;
               Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               this.down.visible = false;
               this.active.visible = true;
               Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               this.down.visible = false;
               this.active.visible = false;
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
         if(!this.mLongPress && Boolean(mEnabled))
         {
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         }
         if(this.mBeep)
         {
            this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
      }
      
      private function onLongPress(e:TimerEvent) : void
      {
         if(mEnabled)
         {
            this.mLongPress = true;
            this.mLongPressTimer.reset();
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this));
         }
      }
      
      public function set beep(enable:Boolean) : void
      {
         this.mBeep = enable;
      }
   }
}

