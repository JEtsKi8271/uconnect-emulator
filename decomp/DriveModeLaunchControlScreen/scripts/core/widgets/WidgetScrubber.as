package core.widgets
{
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class WidgetScrubber extends WidgetBase
   {
      
      public var track:MovieClip = null;
      
      public var thumb:MovieClip = null;
      
      private var mThumbStartingCoord:int = 0;
      
      private var mThumbCurrentCoord:int = 0;
      
      private var mThumbMinimumCoord:int = 0;
      
      private var mThumbMaximumCoord:int = 0;
      
      private var mPosMimumumCoord:uint = 0;
      
      private var mPosMaximumCoord:uint = 0;
      
      private var mPosCurrentCoord:uint = 0;
      
      private var mDelayTimer:Timer = null;
      
      private var mDragActive:Boolean = false;
      
      private var mVerticalConfig:Boolean = false;
      
      public function WidgetScrubber()
      {
         super();
         if(this.track.height > this.track.width)
         {
            this.mVerticalConfig = true;
         }
         this.mThumbCurrentCoord = this.mVerticalConfig ? int(this.track.y) : int(this.track.x);
         this.mThumbMinimumCoord = this.mVerticalConfig ? int(this.track.y) : int(this.track.x);
         if(this.mVerticalConfig)
         {
            this.mThumbMaximumCoord = this.mThumbMinimumCoord + this.track.height - this.thumb.spacer.height;
         }
         else
         {
            this.mThumbMaximumCoord = this.mThumbMinimumCoord + this.track.width - this.thumb.spacer.width;
         }
      }
      
      override protected function addListeners() : void
      {
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMOUSE_DOWN,false,0,true);
      }
      
      public function set minumum(param1:int) : void
      {
         this.mPosMimumumCoord = param1;
      }
      
      public function set maximum(param1:int) : void
      {
         this.mPosMaximumCoord = param1;
         this.movePosition();
      }
      
      public function get position() : int
      {
         return this.mPosCurrentCoord;
      }
      
      public function set position(param1:int) : void
      {
         if(!this.mDragActive)
         {
            if(param1 > this.mPosMaximumCoord)
            {
               this.mPosCurrentCoord = this.mPosMaximumCoord;
            }
            else if(param1 < this.mPosMimumumCoord)
            {
               this.mPosCurrentCoord = this.mPosMimumumCoord;
            }
            else
            {
               this.mPosCurrentCoord = param1;
            }
            this.movePosition();
         }
      }
      
      public function set delay(param1:int) : void
      {
         if(this.mDelayTimer)
         {
            if(param1 > 0)
            {
               this.mDelayTimer.delay = param1;
            }
            else
            {
               this.mDelayTimer.reset();
               this.mDelayTimer.removeEventListener(TimerEvent.TIMER,this.onDelayTIMER);
            }
         }
         else if(param1 > 0)
         {
            this.mDelayTimer = new Timer(param1);
            this.mDelayTimer.addEventListener(TimerEvent.TIMER,this.onDelayTIMER,false,0,true);
         }
      }
      
      private function onDelayTIMER(param1:TimerEvent) : void
      {
         this.dispatchEvent(new WidgetEvent(WidgetEvent.POSITION,this,true));
      }
      
      private function movePosition() : void
      {
         var _loc1_:int = this.mPosCurrentCoord / this.mPosMaximumCoord * (this.mThumbMaximumCoord - this.mThumbMinimumCoord);
         this.mThumbCurrentCoord = this.mThumbMinimumCoord + _loc1_;
         if(this.mVerticalConfig)
         {
            this.thumb.y = this.mThumbCurrentCoord;
         }
         else
         {
            this.thumb.x = this.mThumbCurrentCoord;
         }
      }
      
      private function onThumbMOUSE_DOWN(param1:MouseEvent) : void
      {
         this.mDragActive = true;
         this.mThumbStartingCoord = this.mVerticalConfig ? int(this.root.stage.mouseY) : int(this.root.stage.mouseX);
         this.root.stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbMOUSE_UP,false,0,true);
         this.root.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMOUSE_MOVE,false,0,true);
         this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,this,true));
      }
      
      private function onThumbMOUSE_UP(param1:MouseEvent) : void
      {
         this.mDragActive = false;
         this.root.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbMOUSE_UP);
         this.root.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMOUSE_MOVE);
         this.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE,this,true));
         if(this.mDelayTimer)
         {
            this.mDelayTimer.reset();
         }
         this.dispatchEvent(new WidgetEvent(WidgetEvent.POSITION,this,true));
      }
      
      private function onThumbMOUSE_MOVE(param1:MouseEvent) : void
      {
         if(this.mVerticalConfig)
         {
            this.mThumbCurrentCoord += this.root.stage.mouseY - this.mThumbStartingCoord;
         }
         else
         {
            this.mThumbCurrentCoord += this.root.stage.mouseX - this.mThumbStartingCoord;
         }
         if(this.mThumbCurrentCoord < this.mThumbMinimumCoord)
         {
            this.mThumbCurrentCoord = this.mThumbMinimumCoord;
         }
         else if(this.mThumbCurrentCoord > this.mThumbMaximumCoord)
         {
            this.mThumbCurrentCoord = this.mThumbMaximumCoord;
         }
         if(this.mVerticalConfig)
         {
            this.mThumbStartingCoord = this.root.stage.mouseY;
            this.thumb.y = this.mThumbCurrentCoord;
         }
         else
         {
            this.mThumbStartingCoord = this.root.stage.mouseX;
            this.thumb.x = this.mThumbCurrentCoord;
         }
         this.mPosCurrentCoord = this.mPosMaximumCoord * ((this.mThumbCurrentCoord - this.mThumbMinimumCoord) / (this.mThumbMaximumCoord - this.mThumbMinimumCoord));
         if(!this.mDelayTimer || !this.mDelayTimer.running)
         {
            if(this.mDelayTimer)
            {
               this.mDelayTimer.start();
            }
            this.dispatchEvent(new WidgetEvent(WidgetEvent.POSITION,this,true));
         }
      }
   }
}

