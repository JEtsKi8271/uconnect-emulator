package com.harman.framework.controller
{
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import core.enums.FocusType;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import peripheral.Peripheral;
   
   public class ListController
   {
      
      private const DEFAULT_TRACK_LENGTH:int = 120;
      
      private const DEFAULT_ITEMS_PER_LINE:int = 1;
      
      private var mParent:IList;
      
      private var mLength:int = 6;
      
      private var mItemsPerLine:int = 1;
      
      private var mTrackFull:int = 120;
      
      private var mTrackMin:int = 0;
      
      private var mTrackMax:int = 120;
      
      private var mMinIndex:int = 0;
      
      private var mMaxIndex:int = 0;
      
      private var mItemIndex:int = 0;
      
      private var mSelectMin:int = 0;
      
      private var mSelectMax:int = 5;
      
      private var mSelectIndex:int = 0;
      
      private var mMouseStart:int = 0;
      
      private var mLockedItems:int = 36;
      
      private var mLockedPages:int = 5;
      
      private var mTotalItems:int = 0;
      
      private var mRemainder:int = 0;
      
      private var mLastGoodIndex:int = 0;
      
      private var mLastGoodSelected:int = 0;
      
      private var mIncrement:Number = 0;
      
      private var mPetrified:Boolean = false;
      
      private var mEnableRotaryKnob:Boolean = true;
      
      private var mAllowICSTuning:Boolean = false;
      
      private var mInSettings:Boolean = false;
      
      private var mResetIndex:Boolean = true;
      
      private var mBookmark:String = "";
      
      private var mBookmarks:Dictionary = new Dictionary();
      
      public function ListController()
      {
         super();
      }
      
      public function construct(_parent:IList, useCapture:Boolean = false, priority:int = 0) : void
      {
         this.mItemsPerLine = this.DEFAULT_ITEMS_PER_LINE;
         this.mTrackFull = this.DEFAULT_TRACK_LENGTH;
         this.mTrackMax = this.DEFAULT_TRACK_LENGTH;
         if(this.mParent != null)
         {
            this.deconstruct();
         }
         this.mParent = _parent;
         this.mParent.view.pageup_button.auto = 500;
         this.mParent.view.pagedown_button.auto = 500;
         this.mParent.view.window.addEventListener(WidgetEvent.PRESS,this.onWindowPress,useCapture,priority,true);
         this.mParent.view.pageup_button.addEventListener(WidgetEvent.CLICK,this.onPageUp,useCapture,priority,true);
         this.mParent.view.pagedown_button.addEventListener(WidgetEvent.CLICK,this.onPageDown,useCapture,priority,true);
         if(this.mParent.view.slider != null)
         {
            if(this.mParent.view.slider.trackArea != null)
            {
               this.mTrackMax = this.mParent.view.slider.trackArea.height;
               this.mTrackFull = this.mTrackMax;
            }
            this.mParent.view.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onPickupThumb,useCapture,priority,true);
         }
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout,useCapture,priority,true);
         if(!this.mAllowICSTuning)
         {
            Peripheral.hardControls.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.onICSEncoder);
            Peripheral.hardControls.addEventListener(HardControlEvent.SELECT,this.onICSSelect);
         }
      }
      
      public function deconstruct() : void
      {
         this.mParent.view.window.removeEventListener(WidgetEvent.PRESS,this.onWindowPress);
         this.mParent.view.pageup_button.removeEventListener(WidgetEvent.CLICK,this.onPageUp);
         this.mParent.view.pagedown_button.removeEventListener(WidgetEvent.CLICK,this.onPageDown);
         if(this.mParent.view.slider != null)
         {
            this.mParent.view.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onPickupThumb);
         }
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
         if(Peripheral.hardControls.hasEventListener(HardControlEvent.VERTICAL_SCROLL))
         {
            Peripheral.hardControls.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.onICSEncoder);
            Peripheral.hardControls.removeEventListener(HardControlEvent.SELECT,this.onICSSelect);
         }
         this.unpetrify();
         this.mAllowICSTuning = false;
         this.mParent = null;
         this.mBookmark = "";
         this.mSelectIndex = 0;
      }
      
      public function set parent(_parent:IList) : void
      {
         this.mParent = _parent;
      }
      
      public function set length(length:int) : void
      {
         this.mLength = length;
      }
      
      public function set bookmark(_bookmark:String) : void
      {
         if(this.mBookmark == _bookmark)
         {
            this.mBookmarks[_bookmark] = {
               "indexer":this.mItemIndex,
               "selected":this.mSelectIndex
            };
            this.mBookmark = "";
         }
         else
         {
            if(this.mBookmarks[_bookmark] == null)
            {
               this.mItemIndex = 0;
               this.mSelectIndex = 0;
               this.mBookmarks[_bookmark] = {
                  "indexer":this.mItemIndex,
                  "selected":this.mSelectIndex
               };
            }
            else
            {
               this.mItemIndex = this.mBookmarks[_bookmark].indexer;
               this.mSelectIndex = this.mBookmarks[_bookmark].selected;
               if(this.mInSettings)
               {
                  this.mItemIndex = this.mResetIndex ? 0 : this.mItemIndex;
                  this.mSelectIndex = this.mResetIndex ? 0 : this.mSelectIndex;
               }
            }
            this.mResetIndex = true;
            this.mBookmark = _bookmark;
         }
      }
      
      public function set selectedMin(index:int) : void
      {
         this.mSelectMin = index;
      }
      
      public function set selectedMax(index:int) : void
      {
         this.mSelectMax = index;
      }
      
      public function get selected() : int
      {
         return this.mSelectIndex + this.mItemIndex;
      }
      
      public function set selected(index:int) : void
      {
         if(this.mParent.length != 0)
         {
            this.mSelectIndex = index;
            if(this.mSelectIndex > this.mParent.length - 1)
            {
               this.mSelectIndex = this.mParent.length - 1;
            }
            else if(this.mSelectIndex > this.mSelectMax)
            {
               this.mSelectIndex = this.mTotalItems % this.mSelectMax;
               this.mItemIndex = (this.mTotalItems - this.mSelectIndex) / this.mLength;
            }
            else if(this.mSelectIndex < this.mSelectMin)
            {
               this.mSelectIndex = this.mSelectMin;
            }
            this.itemIndex = this.mItemIndex;
         }
      }
      
      public function set trackLength(length:int) : void
      {
         this.mTrackFull = length;
         this.mTrackMax = length;
      }
      
      public function setLockedPages(lockPage:uint, lockItem:uint) : void
      {
         this.mLockedPages = lockPage;
         this.mLockedItems = lockItem;
      }
      
      public function get maxIndex() : int
      {
         return this.mMaxIndex;
      }
      
      public function get itemIndex() : int
      {
         return this.mItemIndex;
      }
      
      public function resetMinIndex() : void
      {
         this.mMinIndex = 0;
      }
      
      public function set itemIndex(index:int) : void
      {
         this.mItemIndex = this.checkItemIndex(index);
      }
      
      public function set itemsPerLine(_itemsPerLine:int) : void
      {
         this.mItemsPerLine = _itemsPerLine;
      }
      
      public function set total(total:int) : void
      {
         this.mRemainder = 0;
         if(this.mItemsPerLine > 1)
         {
            this.mRemainder = total % this.mItemsPerLine;
            total = this.mRemainder > 0 ? int(total + this.mItemsPerLine - this.mRemainder) : total;
         }
         this.mTotalItems = total;
         this.checkPageCount(this.mTotalItems > this.mLength);
         this.mTrackMin = 0;
         this.mTrackMax = this.mTrackFull;
         this.mMaxIndex = this.mTotalItems - this.mLength;
         this.mIncrement = this.mTrackFull / this.mMaxIndex;
         this.forceRePosition();
         if(this.mMaxIndex < 0)
         {
            this.mMaxIndex = 0;
         }
         this.mParent.view.pageup_button.setEnabled(this.mItemIndex > this.mMinIndex);
         this.mParent.view.pagedown_button.setEnabled(this.mItemIndex < this.mMaxIndex);
         this.checkRange();
      }
      
      public function set delta(_delta:int) : void
      {
         var _maxSelected:int = 0;
         if(Boolean(this.mParent.view.window.selectTarget) && Boolean(this.mParent.view.window.selectTarget.mEnabled))
         {
            this.mLastGoodIndex = this.mItemIndex;
            this.mLastGoodSelected = this.mSelectIndex;
         }
         this.mSelectIndex += _delta;
         if(this.mSelectIndex < this.mSelectMin)
         {
            if(this.mItemIndex != this.mMinIndex)
            {
               this.mSelectIndex = this.mItemsPerLine - 1;
            }
            else
            {
               this.mSelectIndex = this.mSelectMin;
            }
            if(this.mItemsPerLine > 1)
            {
               this.itemIndex = this.mItemIndex - this.mItemsPerLine;
            }
            else
            {
               this.itemIndex = this.mItemIndex + _delta;
            }
            this.forceRePosition();
            this.refresh();
            this.mParent.selected = this.mSelectIndex;
         }
         else if(this.mSelectIndex >= this.mTotalItems && this.mTotalItems < this.mSelectMax)
         {
            if(this.mItemIndex != this.mMaxIndex)
            {
               this.mSelectIndex = this.mItemsPerLine - 1;
            }
            else
            {
               this.mSelectIndex = this.mTotalItems - 1;
            }
            if(this.mItemsPerLine > 1)
            {
               this.itemIndex = this.mItemIndex + this.mItemsPerLine;
            }
            else
            {
               this.itemIndex = this.mItemIndex + _delta;
            }
            this.forceRePosition();
            this.refresh();
            this.mParent.selected = this.mSelectIndex;
         }
         else if(this.mSelectIndex >= this.mSelectMax)
         {
            if(this.mItemIndex != this.mMaxIndex)
            {
               this.mSelectIndex = this.mLength - this.mItemsPerLine;
            }
            else if(this.mRemainder != 0)
            {
               if(this.mItemsPerLine + this.mRemainder - 1 < this.mSelectIndex)
               {
                  this.mSelectIndex = this.mItemsPerLine + this.mRemainder - 1;
               }
            }
            else
            {
               this.mSelectIndex = this.mSelectIndex = this.mSelectMax - 1;
            }
            if(this.mItemsPerLine > 1)
            {
               this.itemIndex = this.mItemIndex + this.mItemsPerLine;
            }
            else
            {
               this.itemIndex = this.mItemIndex + _delta;
            }
            this.forceRePosition();
            this.refresh();
            this.mParent.selected = this.mSelectIndex;
         }
         else
         {
            if(this.mItemIndex == this.mMaxIndex)
            {
               if(this.mRemainder != 0)
               {
                  _maxSelected = this.mRemainder - 1;
                  _maxSelected += (this.mLength / this.mItemsPerLine - 1) * this.mItemsPerLine;
                  if(this.mSelectIndex >= _maxSelected)
                  {
                     this.mSelectIndex = _maxSelected;
                  }
               }
            }
            this.forceRePosition();
            this.refresh();
            this.mParent.selected = this.mSelectIndex;
         }
         if(Boolean(this.mParent.view.window.selectTarget) && !this.mParent.view.window.selectTarget.mEnabled)
         {
            if(this.mItemIndex == this.mMaxIndex && this.mSelectIndex == this.mSelectMax)
            {
               this.itemIndex = this.mLastGoodIndex;
               this.mSelectIndex = this.mLastGoodSelected;
               this.forceRePosition();
               this.refresh();
               this.mParent.selected = this.mSelectIndex;
            }
            else if(this.mItemIndex == this.mMinIndex && this.mSelectIndex == this.mSelectMin)
            {
               this.itemIndex = this.mLastGoodIndex;
               this.mSelectIndex = this.mLastGoodSelected;
               this.forceRePosition();
               this.refresh();
               this.mParent.selected = this.mSelectIndex;
            }
            else if(this.mTotalItems == this.mItemIndex + this.mSelectIndex + 1)
            {
               this.delta = _delta > 0 ? -1 : 1;
            }
            else
            {
               this.delta = _delta > 0 ? 1 : -1;
            }
         }
      }
      
      public function onFocusCallBack(_object:Object) : void
      {
         if(this.mParent != null)
         {
            switch(_object.type)
            {
               case FocusType.ROTARY:
                  this.onICSEncoder(new HardControlEvent(HardControlEvent.VERTICAL_SCROLL,_object.value));
                  break;
               case FocusType.ENTER_DOWN:
                  if(!this.mPetrified)
                  {
                     this.mParent.view.window.selectTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
                  }
                  break;
               case FocusType.ENTER_RELEASE:
                  if(Boolean(this.mParent != null) && Boolean(this.mParent.view.window.selectTarget.hasOwnProperty("rotary")) && this.mParent.view.window.selectTarget.rotary == true)
                  {
                     this.onICSSelect(new HardControlEvent(HardControlEvent.SELECT));
                  }
                  else
                  {
                     this.mParent.view.window.selectTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
                     this.mParent.view.window.selectTarget.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  break;
               case FocusType.CHANGE:
                  this.mParent.view.window.focus = _object.value;
            }
         }
      }
      
      public function onICSEncoder(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.mEnableRotaryKnob)
         {
            if(this.mPetrified)
            {
               if(e.data < 0)
               {
                  this.mParent.view.window.selectTarget.incrementer.negative.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
               else
               {
                  this.mParent.view.window.selectTarget.incrementer.positive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               }
            }
            else
            {
               if(this.mParent.length < 1)
               {
                  return;
               }
               this.delta = e.data;
            }
         }
      }
      
      public function onICSSelect(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.mParent.length < 1)
         {
            return;
         }
         var item:MovieClip = this.mParent.view.window["item" + this.mSelectIndex + "_button"];
         if(!item.mEnabled)
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
         else if(item.sound != null)
         {
            Peripheral.audioMixerManager.sendConfirmationTone(item.sound == SoundEvent.SET ? Peripheral.audioMixerManager.TONE_SET : Peripheral.audioMixerManager.TONE_NORMAL);
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
         }
         if(item.mEnabled)
         {
            this.mParent.view.window.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,{
               "id":item.id,
               "name":"haptic"
            }));
         }
      }
      
      private function onWindowPress(e:WidgetEvent) : void
      {
         this.unpetrify();
         this.mSelectIndex = e.data.sel;
         this.mParent.selected = this.mSelectIndex;
         this.refresh();
      }
      
      public function onPageDown(e:WidgetEvent) : void
      {
         this.unpetrify();
         this.itemIndex = this.mItemIndex + this.mLength;
         this.forceRePosition();
         this.refresh();
      }
      
      public function onPageUp(e:WidgetEvent) : void
      {
         this.unpetrify();
         this.itemIndex = this.mItemIndex - this.mLength;
         this.forceRePosition();
         this.refresh();
      }
      
      private function onPickupThumb(e:MouseEvent) : void
      {
         this.unpetrify();
         this.mMouseStart = this.mParent.view.slider.thumb.mouseY;
         this.popupVisible = true;
         this.mParent.view.slider.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDropThumb,false,0,true);
         this.mParent.view.slider.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveThumb,false,0,true);
      }
      
      private function onDropThumb(evt:MouseEvent) : void
      {
         this.popupVisible = false;
         this.mParent.view.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDropThumb);
         this.mParent.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveThumb);
      }
      
      private function onMoveThumb(e:MouseEvent) : void
      {
         if(this.mParent.view.slider.mouseY - this.mMouseStart <= this.mTrackMin)
         {
            this.mParent.view.slider.thumb.y = this.mTrackMin;
         }
         else if(this.mParent.view.slider.mouseY - this.mMouseStart >= this.mTrackMax)
         {
            this.mParent.view.slider.thumb.y = this.mTrackMax;
         }
         else
         {
            this.mParent.view.slider.thumb.y = this.mParent.view.slider.mouseY - this.mMouseStart;
         }
         var index:int = this.mParent.view.slider.thumb.y / this.mIncrement;
         var remainder:int = index % this.mItemsPerLine;
         index += remainder ? this.mItemsPerLine - remainder : 0;
         index = this.checkItemIndex(index);
         if(this.mItemIndex != index)
         {
            this.mItemIndex = index;
            this.refresh();
         }
      }
      
      private function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         this.checkRange();
         this.refresh();
      }
      
      public function petrify(item:Object) : void
      {
         this.mPetrified = !this.mPetrified;
         if(item.name == "haptic")
         {
            this.mParent.view.window["item" + this.mSelectIndex + "_button"].petrify = this.mPetrified;
         }
         else
         {
            item.petrify = this.mPetrified;
         }
      }
      
      public function unpetrify() : void
      {
         if(this.mPetrified)
         {
            this.mPetrified = false;
            this.mParent.view.window["item" + this.mSelectIndex + "_button"].petrify = false;
         }
      }
      
      public function enableRotaryKnob(enable:Boolean) : void
      {
         this.mEnableRotaryKnob = enable;
      }
      
      public function allowICSTuning(enable:Boolean) : void
      {
         this.mAllowICSTuning = enable;
      }
      
      public function invalidate() : void
      {
         if(this.mParent)
         {
            this.itemIndex = this.mItemIndex;
            this.refresh();
            this.mParent.selected = this.mSelectIndex;
            this.forceRePosition();
         }
      }
      
      public function gotoIndex(gotoIndex:int) : void
      {
         if(gotoIndex >= this.mTotalItems)
         {
            gotoIndex = this.mTotalItems - 1;
         }
         if(gotoIndex < this.mSelectMin)
         {
            gotoIndex = 0;
         }
         if(gotoIndex == 0)
         {
            this.mSelectIndex = 0;
            this.itemIndex = 0;
         }
         else if(gotoIndex >= this.mTotalItems - this.mLength)
         {
            this.itemIndex = this.mTotalItems - this.mLength;
            this.mSelectIndex = gotoIndex - this.itemIndex;
         }
         else
         {
            this.mSelectIndex = gotoIndex % this.mLength;
            this.itemIndex = gotoIndex - this.mSelectIndex;
         }
         this.forceRePosition();
         this.refresh();
      }
      
      public function alphaJumpToIndex(index:int) : void
      {
         this.mItemIndex = index;
         this.checkRange();
      }
      
      public function withinRange() : Boolean
      {
         this.mItemIndex = this.checkItemIndex(this.mItemIndex);
         if(this.mItemIndex < this.mMinIndex)
         {
            return false;
         }
         if(this.mItemIndex < this.mMaxIndex)
         {
            return true;
         }
         return false;
      }
      
      public function forceRePosition() : void
      {
         if(this.mParent.view.slider != null)
         {
            this.mParent.view.slider.thumb.y = this.mIncrement * this.mItemIndex;
         }
      }
      
      public function set insideSettings(val:Boolean) : void
      {
         this.mInSettings = val;
      }
      
      public function usePreviousIndex() : void
      {
         this.mResetIndex = false;
      }
      
      private function refresh() : void
      {
         if(this.mParent)
         {
            this.mParent.view.pageup_button.setEnabled(this.mItemIndex > this.mMinIndex);
            this.mParent.view.pagedown_button.setEnabled(this.mItemIndex < this.mMaxIndex);
            this.mParent.index = this.mItemIndex;
            this.checkSelected();
         }
      }
      
      private function checkSelected() : void
      {
         this.mParent.view.window.selected = this.mSelectIndex;
      }
      
      private function checkPageCount(visibility:Boolean) : void
      {
         if(this.mParent.view.slider != null)
         {
            this.mParent.view.slider.visible = visibility;
         }
         this.mParent.view.pageup_button.visible = visibility;
         this.mParent.view.pagedown_button.visible = visibility;
      }
      
      private function checkItemIndex(index:int) : int
      {
         if(index < this.mMinIndex)
         {
            return this.mMinIndex;
         }
         if(index < this.mMaxIndex)
         {
            return index;
         }
         return this.mMaxIndex;
      }
      
      public function returnRemainder(index:int) : int
      {
         if(this.mTotalItems < this.mSelectMax)
         {
            return index;
         }
         if(this.mTotalItems - index < this.mSelectMax)
         {
            return this.mSelectMax - (this.mTotalItems - index);
         }
         return 0;
      }
      
      private function checkRange(index:int = -1) : void
      {
         if(index == -1)
         {
            index = this.mItemIndex;
         }
         if(Boolean(Global.speedlockout) && Peripheral.vehicleStatus.speedLockOut)
         {
            this.mLockedItems = this.mLength * this.mLockedPages;
            this.mMaxIndex = index + this.mLockedItems - this.mLength;
            if(this.mMaxIndex < this.mTotalItems - this.mLength)
            {
               if(this.mMaxIndex < 0)
               {
                  this.mMaxIndex = 0;
               }
               this.mMinIndex = index;
            }
            else
            {
               this.mMaxIndex = this.mTotalItems - this.mLength;
               if(this.mMaxIndex < 0)
               {
                  this.mMaxIndex = 0;
               }
               this.mMinIndex = this.mTotalItems - this.mLockedItems;
               if(this.mMinIndex < 0)
               {
                  this.mMinIndex = 0;
               }
            }
            this.mParent.total = this.mLockedItems > this.mTotalItems ? this.mTotalItems.toString() : this.mLockedItems.toString();
         }
         else
         {
            this.mMaxIndex = this.mTotalItems - this.mLength;
            if(this.mMaxIndex < 0)
            {
               this.mMaxIndex = 0;
            }
            this.mMinIndex = 0;
            this.mParent.total = this.mTotalItems.toString();
         }
         if(this.mMaxIndex == 0)
         {
            this.mTrackMax = 0;
         }
         else
         {
            this.mTrackMax = Math.ceil(this.mMaxIndex * this.mIncrement);
         }
         if(this.mMinIndex == 0)
         {
            this.mTrackMin = 0;
         }
         else
         {
            this.mTrackMin = Math.floor(this.mMinIndex * this.mIncrement);
         }
      }
      
      private function set popupVisible(show:Boolean) : void
      {
         if(this.mParent.view.slider != null && Boolean(this.mParent.view.slider.thumb.popup_simple))
         {
            this.mParent.view.slider.thumb.popup_simple.visible = show;
         }
      }
   }
}

