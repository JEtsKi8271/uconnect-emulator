package core.widgets
{
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.IMovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import skin.Skin;
   
   public dynamic class WidgetButton extends WidgetBase implements IMovieClip
   {
      
      public static var STATE_UP:String = "UP";
      
      public static var STATE_DOWN:String = "DOWN";
      
      public static var STATE_ACTIVE:String = "ACTIVE";
      
      public static var STATE_DISABLED:String = "DISABLED";
      
      private var mCurrentState:String = STATE_UP;
      
      private var mActive:Boolean = false;
      
      private var mEnabled:Boolean = true;
      
      private var mAutoClick:Boolean = false;
      
      private var mLongPress:Boolean = false;
      
      private var mAutoClickTimer:Timer = null;
      
      private var mLongPressTimer:Timer = null;
      
      public function WidgetButton()
      {
         super();
         this.interactiveChildren();
         this.addListeners();
         if(this.cursor != null)
         {
            this.cursor.visible = false;
         }
      }
      
      override protected function interactiveChildren() : void
      {
         this.mouseChildren = false;
      }
      
      override protected function updateTheme() : void
      {
         this.setFont();
         this.setState(this.mCurrentState);
         if(this.down != null)
         {
            Skin.style.applyStyle(this.down,Skin.style.currentTheme.downStateStandard);
         }
         if(this.active != null)
         {
            Skin.style.applyStyle(this.active,Skin.style.currentTheme.activeStateStandard);
         }
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMOUSE_DOWN,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMOUSE_OUT,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onCLICK,false,0,true);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this.dispatchEvent(new WidgetEvent(WidgetEvent.VISIBILITY,true));
      }
      
      protected function setFont() : void
      {
         if(this.label != null)
         {
            Skin.style.applyFont(this.label,Skin.style.currentTheme.FONT_PRIMARY);
         }
      }
      
      protected function setState(state:String) : void
      {
         switch(state)
         {
            case STATE_UP:
               if(this.down != null)
               {
                  this.down.visible = false;
               }
               if(this.active != null)
               {
                  this.active.visible = false;
               }
               if(this.label != null)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               }
               if(this.icon != null)
               {
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardUpIcon);
               }
               break;
            case STATE_DOWN:
               if(this.down != null)
               {
                  this.down.visible = true;
               }
               if(this.active != null)
               {
                  this.active.visible = false;
               }
               if(this.label != null)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.tertiaryText);
               }
               if(this.icon != null)
               {
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDownIcon);
               }
               break;
            case STATE_ACTIVE:
               if(this.down != null)
               {
                  this.down.visible = false;
               }
               if(this.active != null)
               {
                  this.active.visible = true;
               }
               if(this.label != null)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.primaryText);
               }
               if(this.icon != null)
               {
                  Skin.style.applyStyle(this.icon,this.active != null ? Skin.style.currentTheme.standardActiveIcon : Skin.style.currentTheme.activeGraphic);
               }
               break;
            case STATE_DISABLED:
               if(this.down != null)
               {
                  this.down.visible = false;
               }
               if(this.active != null)
               {
                  this.active.visible = false;
               }
               if(this.label != null)
               {
                  Skin.style.applyStyle(this.label,Skin.style.currentTheme.disabledText);
               }
               if(this.icon != null)
               {
                  Skin.style.applyStyle(this.icon,Skin.style.currentTheme.standardDisabledIcon);
               }
         }
         this.mCurrentState = state;
      }
      
      protected function onMOUSE_DOWN(e:MouseEvent) : void
      {
         if(this.mEnabled)
         {
            this.mAutoClick = false;
            this.mLongPress = false;
            this.setState(STATE_DOWN);
            this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this,true));
            if(this.mAutoClickTimer != null)
            {
               this.mAutoClickTimer.start();
            }
            if(this.mLongPressTimer != null)
            {
               this.mLongPressTimer.start();
            }
         }
      }
      
      protected function onMOUSE_OUT(e:MouseEvent) : void
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
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this,true));
            if(this.mAutoClickTimer != null)
            {
               this.mAutoClickTimer.reset();
            }
            if(this.mLongPressTimer != null)
            {
               this.mLongPressTimer.reset();
            }
         }
      }
      
      protected function onCLICK(e:MouseEvent) : void
      {
         if(this.mEnabled)
         {
            this.setState(this.mActive ? STATE_ACTIVE : STATE_UP);
            if(!this.mAutoClick && !this.mLongPress && e.target === this)
            {
               this.click();
            }
            this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this,true));
            if(this.mAutoClickTimer != null)
            {
               this.mAutoClickTimer.reset();
            }
            if(this.mLongPressTimer != null)
            {
               this.mLongPressTimer.reset();
            }
         }
         else if(e.target === this)
         {
            this.click();
         }
      }
      
      protected function onAutoClickTIMER(e:TimerEvent) : void
      {
         this.mAutoClick = true;
         if(this.mEnabled)
         {
            this.click();
         }
      }
      
      protected function onLongPressTIMER(e:TimerEvent) : void
      {
         this.mLongPress = true;
         this.mLongPressTimer.reset();
         this.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,this,true));
      }
      
      protected function click() : void
      {
         if(!this.mAutoClick && !this.mLongPress)
         {
            this.root.dispatchEvent(new SoundEvent(this.mEnabled ? SoundEvent.CLICK : SoundEvent.REJECT));
         }
         if(this.mEnabled)
         {
            if(!this.mAutoClick && this.mAutoClickTimer != null && (!this.mLongPress && this.mLongPressTimer != null))
            {
               this.dispatchEvent(new WidgetEvent(WidgetEvent.SHORT,this,true));
            }
            else
            {
               this.dispatchEvent(new WidgetEvent(WidgetEvent.CLICK,this,true));
            }
         }
      }
      
      public function getState() : String
      {
         return this.mCurrentState;
      }
      
      public function getEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function setEnabled(_enabled:Boolean) : void
      {
         if(this.mEnabled != _enabled)
         {
            this.mActive = false;
            this.mEnabled = _enabled;
            if(this.mEnabled)
            {
               if(this.mCurrentState != STATE_DOWN)
               {
                  this.setState(STATE_UP);
               }
            }
            else
            {
               if(this.mCurrentState == STATE_DOWN)
               {
                  this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this,true));
                  if(this.mAutoClickTimer != null)
                  {
                     this.mAutoClickTimer.reset();
                  }
                  if(this.mLongPressTimer != null)
                  {
                     this.mLongPressTimer.reset();
                  }
               }
               this.setState(STATE_DISABLED);
            }
         }
      }
      
      public function getHighlight() : Boolean
      {
         return this.mActive;
      }
      
      public function setHighlight(_active:Boolean) : void
      {
         if(this.mActive != _active)
         {
            if(this.mEnabled)
            {
               this.mActive = _active;
               if(this.mCurrentState != STATE_DOWN)
               {
                  this.setState(this.mActive ? STATE_ACTIVE : STATE_UP);
               }
            }
         }
      }
      
      public function set auto(_milliseconds:Number) : void
      {
         if(_milliseconds > 0)
         {
            if(this.mAutoClickTimer != null)
            {
               this.mAutoClickTimer.delay = _milliseconds;
               if(this.mCurrentState == STATE_DOWN)
               {
                  this.mAutoClickTimer.start();
               }
            }
            else
            {
               this.mAutoClickTimer = new Timer(_milliseconds);
               this.mAutoClickTimer.addEventListener(TimerEvent.TIMER,this.onAutoClickTIMER,false,0,true);
            }
         }
         else if(this.mAutoClickTimer != null)
         {
            this.mAutoClickTimer.reset();
            this.mAutoClickTimer.removeEventListener(TimerEvent.TIMER,this.onAutoClickTIMER);
            this.mAutoClickTimer = null;
         }
      }
      
      public function set long(_milliseconds:Number) : void
      {
         if(_milliseconds > 0)
         {
            if(this.mLongPressTimer != null)
            {
               this.mLongPressTimer.delay = _milliseconds;
               if(this.mCurrentState == STATE_DOWN)
               {
                  this.mLongPressTimer.start();
               }
            }
            else
            {
               this.mLongPressTimer = new Timer(_milliseconds);
               this.mLongPressTimer.addEventListener(TimerEvent.TIMER,this.onLongPressTIMER,false,0,true);
            }
         }
         else if(this.mLongPressTimer != null)
         {
            this.mLongPressTimer.reset();
            this.mLongPressTimer.removeEventListener(TimerEvent.TIMER,this.onLongPressTIMER);
            this.mLongPressTimer = null;
         }
      }
   }
}

