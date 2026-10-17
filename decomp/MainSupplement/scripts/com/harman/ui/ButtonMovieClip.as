package com.harman.ui
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.IMovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class ButtonMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public static var STATE_UP:int = 1;
      
      public static var STATE_DOWN:int = 2;
      
      public static var STATE_ACTIVE:int = 3;
      
      public static var STATE_DISABLED:int = 4;
      
      public var mCurrentState:int = 1;
      
      public var mFiring:Boolean = false;
      
      public var mActive:Boolean = false;
      
      public var mEnabled:Boolean = true;
      
      public var alwaysClick:Boolean = false;
      
      private var mAutoClick:Timer = null;
      
      public function ButtonMovieClip()
      {
         super();
         this.interactiveChildren();
         this.addListeners();
      }
      
      protected function interactiveChildren() : void
      {
         this.mouseChildren = false;
      }
      
      override protected function updateTheme() : void
      {
         this.setFont();
         this.setState(this.mCurrentState);
      }
      
      protected function addListeners() : void
      {
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
      }
      
      protected function setFont() : void
      {
      }
      
      public function setState(state:int) : void
      {
      }
      
      protected function onMouseDown(e:MouseEvent) : void
      {
         if(this.mEnabled)
         {
            this.setState(STATE_DOWN);
         }
         if(this.mAutoClick)
         {
            this.mAutoClick.start();
         }
      }
      
      protected function onMouseOut(e:MouseEvent) : void
      {
         if(this.mEnabled)
         {
            if(this.mActive)
            {
               if(this.mCurrentState != STATE_ACTIVE)
               {
                  this.setState(STATE_ACTIVE);
               }
            }
            else if(this.mCurrentState != STATE_UP)
            {
               this.setState(STATE_UP);
            }
         }
         if(this.mAutoClick)
         {
            this.mAutoClick.reset();
         }
      }
      
      protected function onMouseClick(e:MouseEvent) : void
      {
         if(this.mEnabled)
         {
            this.setState(this.mActive ? STATE_ACTIVE : STATE_UP);
         }
         if(!this.mFiring)
         {
            this.click();
         }
         if(this.mAutoClick)
         {
            this.mAutoClick.reset();
         }
         this.mFiring = false;
      }
      
      protected function onAutoClick(e:TimerEvent) : void
      {
         if(this.mEnabled)
         {
            this.click();
         }
      }
      
      protected function click() : void
      {
         if(!this.mFiring)
         {
            this.root.dispatchEvent(new SoundEvent(this.mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         if(this.alwaysClick || this.mEnabled)
         {
            this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this));
         }
         this.mFiring = true;
      }
      
      public function setEnabled(enabled:Boolean) : void
      {
         if(this.mEnabled != enabled)
         {
            this.mActive = false;
            this.mEnabled = enabled;
            if(enabled)
            {
               if(this.mCurrentState != STATE_DOWN)
               {
                  this.setState(STATE_UP);
               }
            }
            else
            {
               this.setState(STATE_DISABLED);
            }
         }
      }
      
      public function setHighlight(active:Boolean) : void
      {
         if(this.mActive != active)
         {
            if(this.mEnabled)
            {
               this.mActive = active;
               this.setState(this.mActive ? STATE_ACTIVE : STATE_UP);
            }
         }
      }
      
      public function set auto(milliseconds:int) : void
      {
         this.mAutoClick = new Timer(milliseconds);
         this.mAutoClick.addEventListener(TimerEvent.TIMER,this.onAutoClick,false,0,true);
      }
   }
}

