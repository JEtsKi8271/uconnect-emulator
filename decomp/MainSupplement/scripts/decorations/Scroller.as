package decorations
{
   import ancillary.Style;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Scroller extends Simple
   {
      
      protected var mScroller:MovieClip;
      
      protected var mVerticalEnabled:Boolean = false;
      
      protected var mHorizontalEnabled:Boolean = false;
      
      protected var mRoundValue:Boolean = Style.Scroller.ROUND_VALUES;
      
      protected var mHValue:Number = 0;
      
      protected var mHValueMinimum:Number = 0;
      
      protected var mHValueMaximum:Number = 90;
      
      protected var mHLimitMaximum:Number = 0;
      
      protected var mVValue:Number = 0;
      
      protected var mVValueMinimum:Number = 0;
      
      protected var mVValueMaximum:Number = 90;
      
      protected var mVPageSize:Number = 10;
      
      protected var mHPageSize:Number = 10;
      
      protected var mTop:Number;
      
      protected var mBottom:Number;
      
      protected var mHeight:Number;
      
      protected var mLeft:Number;
      
      protected var mRight:Number;
      
      protected var mWidth:Number;
      
      protected var mMouseOffsetX:Number = 0;
      
      protected var mMouseOffsetY:Number = 0;
      
      protected var mPreviousVValue:Number;
      
      protected var mPreviousHValue:Number;
      
      protected var mSensitiveTrack:Boolean = Style.Scroller.SENSITIVE_TRACK;
      
      protected var mHideIfUseless:Boolean = Style.Scroller.HIDE_IF_USELESS;
      
      protected var mDisableButtons:Boolean = Style.Scroller.DISABLE_BUTTONS;
      
      private var mThumb:MovieClip;
      
      private var mTrack:MovieClip;
      
      private var mProgress:MovieClip;
      
      private var mReportingPeriod:uint = Style.Scroller.REPORTING_PERIOD;
      
      private var mSlideTimer:Timer = new Timer(100);
      
      private var mThumbDown:Boolean = false;
      
      private var mProgressTracksThumb:Boolean = true;
      
      private var mProgressWidth:Number;
      
      private var mProgressHeight:Number;
      
      private var mPopupPageThreshold:int = Style.Scroller.POPUP_PAGE_THRESHOLD;
      
      private var mPopupUpdater:Function = null;
      
      private var mPopup:MovieClip = null;
      
      public function Scroller(scroller:MovieClip)
      {
         super(scroller);
         this.mScroller = scroller;
         this.mTrack = scroller.track;
         this.mThumb = scroller.thumb;
         this.mProgress = scroller.progress;
         if(this.mThumb)
         {
            this.mPopup = this.mThumb.popup_simple;
            if(this.mPopup)
            {
               this.mPopup.visible = false;
            }
         }
         if(Boolean(this.mTrack) && this.mTrack.height >= this.mTrack.width)
         {
            this.mVerticalEnabled = true;
         }
         if(Boolean(this.mTrack) && this.mTrack.width >= this.mTrack.height)
         {
            this.mHorizontalEnabled = true;
         }
         if(this.mTrack)
         {
            if(this.mThumb)
            {
               this.mTop = this.mThumb.y;
               if(this.mTrack.height == 152)
               {
                  this.mBottom = this.mTrack.height - this.mThumb.y - 4;
               }
               else
               {
                  this.mBottom = 2 * this.mTrack.y + this.mTrack.height - this.mThumb.height - this.mThumb.y;
               }
               this.mLeft = this.mThumb.x;
               this.mRight = 2 * this.mTrack.x + this.mTrack.width - this.mThumb.width - this.mThumb.x;
               if(scroller.trackArea != null)
               {
                  if(this.mVerticalEnabled)
                  {
                     this.mBottom = scroller.trackArea.height;
                  }
                  if(this.mHorizontalEnabled)
                  {
                     this.mRight = scroller.trackArea.width;
                  }
               }
            }
            else
            {
               this.mTop = 0;
               this.mBottom = this.mTrack.height;
               this.mLeft = 0;
               this.mRight = this.mTrack.width;
            }
         }
         this.mHeight = this.mBottom - this.mTop;
         this.mWidth = this.mRight - this.mLeft;
         if(Boolean(this.mProgress) && Boolean(this.mTrack))
         {
            this.mProgressWidth = this.mTrack.width + (this.mTrack.x - this.mProgress.x) * 2;
            this.mProgressHeight = this.mTrack.height + (this.mTrack.y - this.mProgress.y) * 2;
         }
         if(this.mThumb)
         {
            this.mThumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown,false,0,true);
         }
         if(this.mTrack)
         {
            this.mTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackMouseDown,false,0,true);
         }
         if(scroller.upArrow_button)
         {
            this.mVerticalEnabled = true;
            scroller.upArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageUp,false,0,true);
         }
         if(scroller.downArrow_button)
         {
            this.mVerticalEnabled = true;
            scroller.downArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageDown,false,0,true);
         }
         if(scroller.leftArrow_button)
         {
            this.mHorizontalEnabled = true;
            scroller.leftArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageLeft,false,0,true);
         }
         if(scroller.rightArrow_button)
         {
            this.mHorizontalEnabled = true;
            scroller.rightArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageRight,false,0,true);
         }
         this.reportPosition();
      }
      
      override public function update() : void
      {
         var value:Number = NaN;
         var valueRange:Number = NaN;
         var useless:Boolean = false;
         var MY_OFFSET:int = 0;
         if(this.mHideIfUseless)
         {
            useless = true;
            if(this.mVerticalEnabled && this.mVValueMaximum - this.mVPageSize > this.mVValueMinimum)
            {
               useless = false;
            }
            if(this.mHorizontalEnabled && this.mHValueMaximum - this.mHPageSize > this.mHValueMinimum)
            {
               useless = false;
            }
            if(useless)
            {
               this.mScroller.hide();
            }
            else
            {
               this.mScroller.show();
            }
         }
         if(this.mVerticalEnabled)
         {
            value = this.getVValue();
            if(value + this.mVPageSize > this.mVValueMaximum)
            {
               value = this.mVValueMaximum - this.mVPageSize;
            }
            if(value < this.mVValueMinimum)
            {
               value = this.mVValueMinimum;
            }
            valueRange = this.mVValueMaximum - this.mVValueMinimum - this.mVPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            if(this.mThumb)
            {
               this.mThumb.y = (value - this.mVValueMinimum) / valueRange * this.mHeight;
               this.mThumb.y += this.mTop;
            }
            if(Boolean(this.mScroller.progress) && Boolean(this.mThumb) && this.mProgressTracksThumb)
            {
               if(this.mThumb)
               {
                  this.mScroller.progress.height = this.mThumb.y + this.mThumb.height / 2 - this.mScroller.mScroller.progress.y;
               }
               else
               {
                  this.mScroller.progress.height = this.mScroller.mouseY - this.mScroller.progress.y;
               }
            }
         }
         if(this.mHorizontalEnabled)
         {
            value = this.getHValue();
            if(value + this.mHPageSize > this.mHValueMaximum)
            {
               value = this.mHValueMaximum - this.mHPageSize;
            }
            if(value < this.mHValueMinimum)
            {
               value = this.mHValueMinimum;
            }
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            if(this.mThumb)
            {
               MY_OFFSET = 0;
               this.mThumb.x = (value - this.mHValueMinimum) / valueRange * this.mWidth + MY_OFFSET;
               this.mThumb.x += this.mLeft;
            }
            if(Boolean(this.mScroller.progress) && this.mProgressTracksThumb)
            {
               if(this.mThumb)
               {
                  this.mScroller.progress.width = this.mThumb.x + this.mThumb.width / 2 - this.mScroller.progress.x;
               }
               else
               {
                  this.mScroller.progress.width = this.mScroller.mouseX - this.mScroller.progress.x;
               }
            }
         }
         this.updateButtons();
      }
      
      private function updateValue() : void
      {
         var valueRange:Number = NaN;
         if(this.mVerticalEnabled)
         {
            valueRange = this.mVValueMaximum - this.mVValueMinimum - this.mVPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            if(this.mTrack)
            {
               if(this.mThumb)
               {
                  this.setVValue((this.mThumb.y - this.mTop) / this.mHeight * valueRange + this.mVValueMinimum);
               }
               else
               {
                  this.setVValue((this.mTrack.mouseY - this.mTop) / this.mHeight * valueRange + this.mVValueMinimum);
               }
            }
         }
         if(this.mHorizontalEnabled)
         {
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            if(this.mTrack)
            {
               if(this.mThumb)
               {
                  this.setHValue((this.mThumb.x - this.mLeft) / this.mWidth * valueRange + this.mHValueMinimum);
               }
               else
               {
                  this.setHValue((this.mTrack.mouseX - this.mLeft) / this.mWidth * valueRange + this.mHValueMinimum);
               }
            }
         }
         this.updateButtons();
      }
      
      private function updateButtons() : void
      {
         if(this.mVerticalEnabled)
         {
            if(this.mScroller.upArrow_button)
            {
               this.mScroller.upArrow_button.setEnabled(this.getVValue() > this.mVValueMinimum);
            }
            if(this.mScroller.downArrow_button)
            {
               this.mScroller.downArrow_button.setEnabled(this.getVValue() < this.mVValueMaximum - this.mVPageSize);
            }
         }
         if(this.mHorizontalEnabled)
         {
            if(this.mScroller.leftArrow_button)
            {
               this.mScroller.leftArrow_button.setEnabled(this.getHValue() > this.mHValueMinimum);
            }
            if(this.mScroller.rightArrow_button)
            {
               this.mScroller.rightArrow_button.setEnabled(this.getHValue() < this.mHValueMaximum - this.mHPageSize);
            }
         }
      }
      
      protected function onThumbMouseDown(e:MouseEvent) : void
      {
         e.stopPropagation();
         if(this.mThumb)
         {
            this.mMouseOffsetX = this.mThumb.mouseX;
            this.mMouseOffsetY = this.mThumb.mouseY;
         }
         else
         {
            this.mMouseOffsetX = 0;
            this.mMouseOffsetY = 0;
         }
         this.mThumbDown = true;
         this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.GRAB));
         if(this.mTrack)
         {
            this.mThumb.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp,false,0,true);
            this.mTrack.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
            this.mTrack.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
         }
         if(this.mReportingPeriod > 0)
         {
            this.startSlideTimer();
         }
         this.updatePopup();
      }
      
      protected function onTrackMouseDown(e:MouseEvent) : void
      {
         if(this.mSensitiveTrack)
         {
            if(this.mThumb)
            {
               this.mMouseOffsetX = this.mThumb.width / 2;
               this.mMouseOffsetY = this.mThumb.height / 2;
            }
            else
            {
               this.mMouseOffsetX = 0;
               this.mMouseOffsetY = 0;
            }
            if(this.mTrack)
            {
               this.mTrack.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
               this.mTrack.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,false,0,true);
            }
            this.onMouseMove(e);
            if(this.mReportingPeriod > 0)
            {
               this.startSlideTimer();
            }
         }
      }
      
      protected function onMouseUp(evt:MouseEvent) : void
      {
         this.mThumbDown = false;
         this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.RELEASE));
         if(this.mTrack)
         {
            if(this.mThumb)
            {
               this.mThumb.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseUp);
            }
            this.mTrack.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.mTrack.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         this.stopSlideTimer();
         this.updateValue();
         if(this.mPopup)
         {
            this.mPopup.visible = false;
         }
      }
      
      protected function onMouseMove(evt:MouseEvent) : void
      {
         var y:int = 0;
         var x:int = 0;
         if(this.mVerticalEnabled)
         {
            y = this.mScroller.mouseY - this.mMouseOffsetY;
            if(this.mHeight >= 0)
            {
               if(y > this.mBottom)
               {
                  y = this.mBottom;
               }
               else if(y < this.mTop)
               {
                  y = this.mTop;
               }
            }
            else if(y < this.mBottom)
            {
               y = this.mBottom;
            }
            else if(y > this.mTop)
            {
               y = this.mTop;
            }
            if(this.mThumb)
            {
               this.mThumb.y = y;
            }
         }
         if(this.mHorizontalEnabled)
         {
            x = this.mScroller.mouseX - this.mMouseOffsetX;
            if(this.mWidth >= 0)
            {
               if(x > this.mRight - this.mHLimitMaximum)
               {
                  x = this.mRight - this.mHLimitMaximum;
               }
               else if(x < this.mLeft)
               {
                  x = this.mLeft;
               }
            }
            else if(x < this.mRight)
            {
               x = this.mRight;
            }
            else if(x > this.mLeft)
            {
               x = this.mLeft;
            }
            if(this.mThumb)
            {
               this.mThumb.x = x;
            }
         }
         this.updateValue();
         if(this.mReportingPeriod == 0)
         {
            this.reportPosition();
         }
         this.updatePopup();
      }
      
      public function setVerticalEnabled(verticalEnabled:Boolean) : void
      {
         this.mVerticalEnabled = verticalEnabled;
      }
      
      public function getVerticalEnabled() : Boolean
      {
         return this.mVerticalEnabled;
      }
      
      public function setHorizontalEnabled(horizontalEnabled:Boolean) : void
      {
         this.mHorizontalEnabled = horizontalEnabled;
      }
      
      public function getHorizontalEnabled() : Boolean
      {
         return this.mHorizontalEnabled;
      }
      
      public function setSensitiveTrack(sensitiveTrack:Boolean) : void
      {
         this.mSensitiveTrack = sensitiveTrack;
      }
      
      public function getSensitiveTrack() : Boolean
      {
         return this.mSensitiveTrack;
      }
      
      public function setHideIfUseless(hideIfUseless:Boolean) : void
      {
         this.mHideIfUseless = hideIfUseless;
         this.update();
      }
      
      public function getHideIfUseless() : Boolean
      {
         return this.mHideIfUseless;
      }
      
      public function setDisableButtons(disable:Boolean) : void
      {
         if(this.mDisableButtons == disable)
         {
            return;
         }
         this.mDisableButtons = disable;
         if(this.mScroller.upArrow_button)
         {
            if(disable)
            {
               this.mScroller.upArrow_button.removeEventListener(WidgetEvent.AUTO_CLICK,this.pageUp);
            }
            else
            {
               this.mScroller.upArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageUp,false,0,true);
            }
         }
         if(this.mScroller.downArrow_button)
         {
            if(disable)
            {
               this.mScroller.downArrow_button.removeEventListener(WidgetEvent.AUTO_CLICK,this.pageDown);
            }
            else
            {
               this.mScroller.downArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageDown,false,0,true);
            }
         }
         if(this.mScroller.leftArrow_button)
         {
            if(disable)
            {
               this.mScroller.leftArrow_button.removeEventListener(WidgetEvent.AUTO_CLICK,this.pageLeft);
            }
            else
            {
               this.mScroller.leftArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageLeft,false,0,true);
            }
         }
         if(this.mScroller.rightArrow_button)
         {
            if(disable)
            {
               this.mScroller.rightArrow_button.removeEventListener(WidgetEvent.AUTO_CLICK,this.pageRight);
            }
            else
            {
               this.mScroller.rightArrow_button.addEventListener(WidgetEvent.AUTO_CLICK,this.pageRight,false,0,true);
            }
         }
      }
      
      public function getDisableButtons() : Boolean
      {
         return this.mDisableButtons;
      }
      
      public function setRoundValues(doRound:Boolean) : void
      {
         this.mRoundValue = doRound;
      }
      
      public function getRoundValues() : Boolean
      {
         return this.mRoundValue;
      }
      
      public function setValue(value:Number) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVValue(value);
         }
         else
         {
            this.setHValue(value);
         }
      }
      
      public function getValue() : Number
      {
         if(this.mVerticalEnabled)
         {
            return this.getVValue();
         }
         return this.getHValue();
      }
      
      public function setVValue(value:Number) : void
      {
         if(value > this.mVValueMaximum - this.mVPageSize)
         {
            value = this.mVValueMaximum - this.mVPageSize;
         }
         if(value < this.mVValueMinimum)
         {
            value = this.mVValueMinimum;
         }
         this.mVValue = value;
         if(!this.mThumbDown)
         {
            this.update();
            this.reportPosition();
         }
      }
      
      public function getVValue() : Number
      {
         if(this.mRoundValue)
         {
            return int(Math.round(this.mVValue));
         }
         return this.mVValue;
      }
      
      public function getVTrackValue() : Number
      {
         var valueRange:Number = NaN;
         valueRange = this.mVValueMaximum - this.mVValueMinimum - this.mVPageSize;
         if(valueRange < 0)
         {
            valueRange = 0;
         }
         if(this.mRoundValue)
         {
            return int(Math.round((this.mTrack.mouseY - this.mTop) / this.mHeight * valueRange + this.mVValueMinimum));
         }
         return (this.mTrack.mouseY - this.mTop) / this.mHeight * valueRange + this.mVValueMinimum;
      }
      
      public function setHValue(value:Number) : void
      {
         if(value > this.mHValueMaximum - this.mHPageSize)
         {
            value = this.mHValueMaximum - this.mHPageSize;
         }
         if(value < this.mHValueMinimum)
         {
            value = this.mHValueMinimum;
         }
         this.mHValue = value;
         if(!this.mThumbDown)
         {
            this.update();
            this.reportPosition();
         }
      }
      
      public function getHValue() : Number
      {
         if(this.mRoundValue)
         {
            return int(Math.round(this.mHValue));
         }
         return this.mHValue;
      }
      
      public function getHTrackValue() : Number
      {
         var valueRange:Number = NaN;
         valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
         if(valueRange < 0)
         {
            valueRange = 0;
         }
         if(this.mRoundValue)
         {
            return int(Math.round((this.mTrack.mouseX - this.mLeft) / this.mWidth * valueRange + this.mHValueMinimum));
         }
         return (this.mTrack.mouseX - this.mLeft) / this.mWidth * valueRange + this.mHValueMinimum;
      }
      
      public function setHLimit(value:Number) : void
      {
         var valueRange:int = 0;
         if(this.mHorizontalEnabled)
         {
            if(value < this.mHValueMinimum)
            {
               value = this.mHValueMinimum;
            }
            if(value > this.mHValueMaximum - this.mHPageSize)
            {
               value = this.mHValueMaximum - this.mHPageSize;
            }
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            this.mHLimitMaximum = (value - this.mHValueMinimum) / valueRange * this.mRight;
            if(this.mHLimitMaximum < 0)
            {
               this.mHLimitMaximum = 0;
            }
         }
      }
      
      public function getHLimit() : Number
      {
         var valueRange:int = 0;
         if(this.mHorizontalEnabled)
         {
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            return this.mHLimitMaximum / this.mProgressWidth * valueRange + this.mHValueMinimum;
         }
         return 0;
      }
      
      public function setMinimum(min:Number) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVMinimum(min);
         }
         else
         {
            this.setHMinimum(min);
         }
      }
      
      public function getMinimum() : Number
      {
         if(this.mVerticalEnabled)
         {
            return this.getVMinimum();
         }
         return this.getHMinimum();
      }
      
      public function setHMinimum(min:Number) : void
      {
         this.mHValueMinimum = min;
         if(this.mHValueMinimum > this.mHValueMaximum)
         {
            this.mHValueMaximum = this.mHValueMinimum;
         }
         this.setHValue(this.getHValue());
      }
      
      public function getHMinimum() : Number
      {
         return this.mHValueMinimum;
      }
      
      public function setVMinimum(min:Number) : void
      {
         this.mVValueMinimum = min;
         if(this.mVValueMinimum > this.mVValueMaximum)
         {
            this.mVValueMaximum = this.mVValueMinimum;
         }
         this.setVValue(this.getVValue());
      }
      
      public function getVMinimum() : Number
      {
         return this.mVValueMinimum;
      }
      
      public function setMaximum(min:Number) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVMaximum(min);
         }
         else
         {
            this.setHMaximum(min);
         }
      }
      
      public function getMaximum() : Number
      {
         if(this.mVerticalEnabled)
         {
            return this.getVMaximum();
         }
         return this.getHMaximum();
      }
      
      public function maximumEventHandler(e:WidgetEvent) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVMaximum(e.data);
         }
         else
         {
            this.setHMaximum(e.data);
         }
      }
      
      public function setVMaximum(max:Number) : void
      {
         this.mVValueMaximum = max;
         if(this.mVValueMaximum < this.mVValueMinimum)
         {
            this.mVValueMinimum = this.mVValueMaximum;
         }
         this.setHValue(this.getHValue());
      }
      
      public function getVMaximum() : Number
      {
         return this.mVValueMaximum;
      }
      
      public function vMaximumEventHandler(e:WidgetEvent) : void
      {
         this.setVMaximum(e.data);
      }
      
      public function setHMaximum(max:Number) : void
      {
         this.mHValueMaximum = max;
         if(this.mHValueMaximum < this.mHValueMinimum)
         {
            this.mHValueMinimum = this.mHValueMaximum;
         }
         this.setHValue(this.getHValue());
      }
      
      public function getHMaximum() : Number
      {
         return this.mHValueMaximum;
      }
      
      public function hMaximumEventHandler(e:WidgetEvent) : void
      {
         this.setHMaximum(e.data);
      }
      
      public function setPageSize(pageSize:Number) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVPageSize(pageSize);
         }
         else
         {
            this.setHPageSize(pageSize);
         }
      }
      
      public function getPageSize() : Number
      {
         if(this.mVerticalEnabled)
         {
            return this.getVPageSize();
         }
         return this.getHPageSize();
      }
      
      public function pageSizeEventHandler(e:WidgetEvent) : void
      {
         if(this.mVerticalEnabled)
         {
            this.vPageSizeEventHandler(e);
         }
         else
         {
            this.hPageSizeEventHandler(e);
         }
      }
      
      public function setVPageSize(pageSize:Number) : void
      {
         this.mVPageSize = pageSize;
      }
      
      public function getVPageSize() : Number
      {
         return this.mVPageSize;
      }
      
      public function vPageSizeEventHandler(e:WidgetEvent) : void
      {
         this.setVPageSize(e.data);
      }
      
      public function setHPageSize(pageSize:Number) : void
      {
         this.mHPageSize = pageSize;
      }
      
      public function getHPageSize() : Number
      {
         return this.mHPageSize;
      }
      
      public function hPageSizeEventHandler(e:WidgetEvent) : void
      {
         this.setHPageSize(e.data);
      }
      
      private function startSlideTimer() : void
      {
         this.stopSlideTimer();
         this.mSlideTimer.addEventListener(TimerEvent.TIMER,this.reportPosition,false,0,true);
         this.mSlideTimer.delay = this.mReportingPeriod;
         this.mSlideTimer.start();
      }
      
      private function stopSlideTimer() : void
      {
         this.mSlideTimer.stop();
         this.mSlideTimer.removeEventListener(TimerEvent.TIMER,this.reportPosition);
      }
      
      protected function reportPosition(e:TimerEvent = null) : void
      {
         var value:Number = this.getVValue();
         if(this.mPreviousVValue != value)
         {
            this.mPreviousVValue = value;
            this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.VERTICAL_POSITION,value,true));
            if(this.mVerticalEnabled)
            {
               this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.POSITION,value,true));
            }
         }
         value = this.getHValue();
         if(this.mPreviousHValue != value)
         {
            this.mPreviousHValue = value;
            this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.HORIZONTAL_POSITION,value,true));
            if(!this.mVerticalEnabled)
            {
               this.mScroller.dispatchEvent(new WidgetEvent(WidgetEvent.POSITION,value,true));
            }
         }
      }
      
      private function pageUp(e:WidgetEvent) : void
      {
         this.setVValue(this.getVValue() - this.mVPageSize);
      }
      
      private function pageDown(e:WidgetEvent) : void
      {
         this.setVValue(this.getVValue() + this.mVPageSize);
      }
      
      private function pageLeft(e:WidgetEvent) : void
      {
         this.setHValue(this.getHValue() - this.mHPageSize);
      }
      
      private function pageRight(e:WidgetEvent) : void
      {
         this.setHValue(this.getHValue() + this.mHPageSize);
      }
      
      public function getReportingPeriod() : uint
      {
         return this.mReportingPeriod;
      }
      
      public function setReportingPeriod(reportingPeriod:uint) : void
      {
         this.mReportingPeriod = reportingPeriod;
         if(this.mReportingPeriod > 0)
         {
            this.mSlideTimer.delay = reportingPeriod;
         }
         if(this.mScroller.upArrow_button)
         {
            this.mScroller.upArrow_button.setAutoRepeatPeriod(this.mReportingPeriod);
         }
         if(this.mScroller.downArrow_button)
         {
            this.mScroller.downArrow_button.setAutoRepeatPeriod(this.mReportingPeriod);
         }
         if(this.mScroller.leftArrow_button)
         {
            this.mScroller.leftArrow_button.setAutoRepeatPeriod(this.mReportingPeriod);
         }
         if(this.mScroller.rightArrow_button)
         {
            this.mScroller.rightArrow_button.setAutoRepeatPeriod(this.mReportingPeriod);
         }
      }
      
      public function setProgressTracksThumb(progressTracksThumb:Boolean) : void
      {
         this.mProgressTracksThumb = progressTracksThumb;
      }
      
      public function getProgressTracksThumb() : Boolean
      {
         return this.mProgressTracksThumb;
      }
      
      public function setProgress(value:Number) : void
      {
         if(this.mVerticalEnabled)
         {
            this.setVProgress(value);
         }
         else
         {
            this.setHProgress(value);
         }
      }
      
      public function getProgress() : Number
      {
         if(this.mVerticalEnabled)
         {
            return this.getVProgress();
         }
         return this.getHProgress();
      }
      
      public function setVProgress(value:Number) : void
      {
         var valueRange:int = 0;
         if(this.mVerticalEnabled && Boolean(this.mScroller.progress))
         {
            if(value < this.mVValueMinimum)
            {
               value = this.mVValueMinimum;
            }
            if(value > this.mVValueMaximum - this.mVPageSize)
            {
               value = this.mVValueMaximum - this.mVPageSize;
            }
            valueRange = this.mVValueMaximum - this.mVValueMinimum - this.mVPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            this.mScroller.progress.height = (value - this.mVValueMinimum) / valueRange * this.mProgressHeight;
         }
      }
      
      public function getVProgress() : Number
      {
         var valueRange:int = 0;
         if(this.mVerticalEnabled && Boolean(this.mScroller.progress))
         {
            valueRange = this.mVValueMaximum - this.mVValueMinimum - this.mVPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            return this.mScroller.progress.height / this.mProgressHeight * valueRange + this.mVValueMinimum;
         }
         return 0;
      }
      
      public function setHProgress(value:Number) : void
      {
         var valueRange:int = 0;
         if(this.mHorizontalEnabled && Boolean(this.mScroller.progress))
         {
            if(value < this.mHValueMinimum)
            {
               value = this.mHValueMinimum;
            }
            if(value > this.mHValueMaximum - this.mHPageSize)
            {
               value = this.mHValueMaximum - this.mHPageSize;
            }
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            this.mScroller.progress.width = (value - this.mHValueMinimum) / valueRange * this.mProgressWidth;
         }
      }
      
      public function getHProgress() : Number
      {
         var valueRange:int = 0;
         if(this.mHorizontalEnabled && Boolean(this.mScroller.progress))
         {
            valueRange = this.mHValueMaximum - this.mHValueMinimum - this.mHPageSize;
            if(valueRange < 0)
            {
               valueRange = 0;
            }
            return this.mScroller.progress.width / this.mProgressWidth * valueRange + this.mHValueMinimum;
         }
         return 0;
      }
      
      public function getThumbDown() : Boolean
      {
         return this.mThumbDown;
      }
      
      public function setPopupPageThreshold(pageThreshold:int) : void
      {
         this.mPopupPageThreshold = pageThreshold;
      }
      
      public function getPopupPageThreshold() : int
      {
         return this.mPopupPageThreshold;
      }
      
      public function setPopupUpdater(popupUpdater:Function) : void
      {
         this.mPopupUpdater = popupUpdater;
      }
      
      private function updatePopup() : void
      {
         var mHPages:int = 0;
         var mVPages:int = 0;
         if(this.mPopupUpdater != null && Boolean(this.mPopup))
         {
            mHPages = 0;
            if(this.mHorizontalEnabled)
            {
               mHPages = (this.mHValueMaximum - this.mHValueMinimum) / this.mHPageSize;
            }
            mVPages = 0;
            if(this.mVerticalEnabled)
            {
               mVPages = (this.mVValueMaximum - this.mVValueMinimum) / this.mVPageSize;
            }
            if(mVPages >= this.mPopupPageThreshold || mHPages >= this.mPopupPageThreshold)
            {
               this.mPopup.visible = true;
               this.mPopupUpdater(this.mPopup);
            }
         }
      }
      
      public function get popup() : MovieClip
      {
         return this.mPopup;
      }
   }
}

