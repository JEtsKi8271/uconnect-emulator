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
   
   public class ButtonApp extends ButtonMovieClip
   {
      
      public var id:int = -1;
      
      public var wave:MovieClip;
      
      public var icon:MovieClip;
      
      public var vents:MovieClip;
      
      public var label:TextField;
      
      public var value:TextField;
      
      private var mLongPress:Boolean = false;
      
      private var mLongPressTimer:Timer = null;
      
      public function ButtonApp()
      {
         super();
         this.wave.visible = false;
      }
      
      override protected function addListeners() : void
      {
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
      }
      
      override protected function setFont() : void
      {
         Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         if(this.value != null)
         {
            Skin.style.applyFont(this.value,Skin.style.currentTheme.FONT_PRIMARY);
         }
         if(this.vents != null)
         {
            Skin.style.applyFont(this.vents.off,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               this.icon.filters = [];
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.glowActive);
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.glowActive);
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               break;
            case STATE_DISABLED:
               this.icon.filters = [];
               Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
         }
         mCurrentState = state;
      }
      
      override protected function onMouseDown(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(STATE_DOWN);
         }
         if(this.mLongPressTimer == null)
         {
            if(mEnabled || alwaysClick)
            {
               this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this,true));
            }
            this.root.dispatchEvent(new SoundEvent(mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         else
         {
            this.mLongPress = false;
            this.mLongPressTimer.start();
         }
      }
      
      override protected function onMouseOut(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(mActive ? STATE_ACTIVE : STATE_UP);
         }
         if(this.mLongPressTimer)
         {
            this.mLongPressTimer.reset();
         }
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         if(mEnabled)
         {
            this.setState(mActive ? STATE_ACTIVE : STATE_UP);
         }
         if(this.mLongPressTimer)
         {
            this.mLongPressTimer.reset();
         }
         if(!this.mLongPress && this.mLongPressTimer != null)
         {
            this.click();
         }
      }
      
      override protected function click() : void
      {
         if(mEnabled || alwaysClick)
         {
            this.root.dispatchEvent(new SoundEvent(SoundEvent.CLICK));
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         }
         else
         {
            this.root.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
         }
      }
      
      private function onLongPress(e:TimerEvent) : void
      {
         if(mEnabled || alwaysClick)
         {
            this.mLongPress = true;
            this.mLongPressTimer.reset();
            this.parent.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this));
         }
      }
      
      public function set longPress(milliseconds:Number) : void
      {
         if(!this.mLongPressTimer)
         {
            this.mLongPressTimer = new Timer(milliseconds);
            this.mLongPressTimer.addEventListener(TimerEvent.TIMER,this.onLongPress,false,0,true);
         }
      }
      
      public function get cursor() : TextField
      {
         return this.label;
      }
      
      public function setFavorite(mFavorite:Boolean) : void
      {
      }
   }
}

