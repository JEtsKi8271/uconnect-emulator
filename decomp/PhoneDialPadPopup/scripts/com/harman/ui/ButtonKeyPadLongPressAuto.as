package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import skin.Skin;
   
   public class ButtonKeyPadLongPressAuto extends ButtonPressAndHold
   {
      
      public var icon:MovieClip;
      
      public var colorize:MovieClip;
      
      private var mAutoClick:Timer = null;
      
      private var mBeepOccured:Boolean = false;
      
      public function ButtonKeyPadLongPressAuto()
      {
         super();
      }
      
      override protected function onLongPress(e:TimerEvent) : void
      {
         super.onLongPress(e);
         if(this.mAutoClick != null)
         {
            this.mAutoClick.start();
         }
      }
      
      override public function setState(state:int) : void
      {
         switch(state)
         {
            case STATE_UP:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
               break;
            case STATE_DOWN:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.downStateStandard);
               break;
            case STATE_ACTIVE:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardActiveIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.activeStateStandard);
               break;
            case STATE_DISABLED:
               Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
               Skin.style.applyStyle(this.colorize,Skin.style.currentTheme.upStateStandard);
         }
         mCurrentState = state;
      }
      
      override public function set auto(milliseconds:int) : void
      {
         this.mAutoClick = new Timer(milliseconds);
         this.mAutoClick.addEventListener(TimerEvent.TIMER,this.onBackButtonAutoClick,false,0,true);
      }
      
      protected function onBackButtonAutoClick(e:TimerEvent) : void
      {
         if(Boolean(mEnabled) && mCurrentState != STATE_DISABLED)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
            this.mBeepOccured = false;
         }
         else if(!this.mBeepOccured)
         {
            this.root.dispatchEvent(new SoundEvent(SoundEvent.REJECT));
            this.mBeepOccured = true;
         }
      }
      
      override protected function onMouseClick(e:MouseEvent) : void
      {
         if(this.mAutoClick != null)
         {
            this.mAutoClick.stop();
            this.mAutoClick.reset();
         }
         super.onMouseClick(e);
      }
      
      override protected function onMouseOut(e:MouseEvent) : void
      {
         super.onMouseOut(e);
         if(this.mAutoClick != null)
         {
            this.mAutoClick.stop();
            this.mAutoClick.reset();
         }
      }
   }
}

