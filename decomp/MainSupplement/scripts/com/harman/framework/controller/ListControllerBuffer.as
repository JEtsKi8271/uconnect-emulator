package com.harman.framework.controller
{
   import com.harman.framework.BufferControl.BufferControlTypes;
   import com.harman.framework.BufferControl.BufferController;
   import com.harman.framework.BufferControl.FrameRequestReturn;
   import com.harman.framework.BufferControl.IDataProvider;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import core.enums.FocusType;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.SoundEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import peripheral.Peripheral;
   
   public class ListControllerBuffer
   {
      
      private var mParent:IList;
      
      private var mLength:int = 5;
      
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
      
      private var mLimitOfNum:int = int(this.mLockedPages / 2);
      
      private var mTotalItems:int = 0;
      
      private var mMinPage:int = 0;
      
      private var mMaxPage:int = 0;
      
      private var mIncrement:Number = 0;
      
      private var mPetrified:Boolean = false;
      
      private var mBufferController:BufferController;
      
      public function ListControllerBuffer()
      {
         super();
      }
      
      public function getTotalItems() : int
      {
         return this.mBufferController.getListSize();
      }
      
      public function isFolderItem(index:int) : Boolean
      {
         return this.mBufferController.isFolderItem(index);
      }
      
      public function getCurrentListPosition() : int
      {
         return this.mBufferController.getCurScreenPosition();
      }
      
      public function construct(_parent:IList, bActivateBufferControl:Boolean = false) : void
      {
         if(this.mParent != null)
         {
            this.deconstruct();
         }
         this.mIncrement = 0;
         this.mParent = _parent;
         this.mParent.view.pageup_button.auto = 500;
         this.mParent.view.pagedown_button.auto = 500;
         this.mParent.view.window.addEventListener(WidgetEvent.PRESS,this.onWindowPress,false,0,true);
         this.mParent.view.pageup_button.addEventListener(WidgetEvent.CLICK,this.onPageUp,false,0,true);
         this.mParent.view.pagedown_button.addEventListener(WidgetEvent.CLICK,this.onPageDown,false,0,true);
         this.mParent.view.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onPickupThumb,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout,false,0,true);
         Peripheral.hardControls.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.onICSEncoder);
         Peripheral.hardControls.addEventListener(HardControlEvent.SELECT,this.onICSSelect);
      }
      
      public function activateBufferControl(provider:IDataProvider) : void
      {
         this.selected = 0;
         this.itemIndex = 0;
         if(this.mBufferController == null)
         {
            this.mBufferController = new BufferController();
         }
         this.mBufferController.init(5,BufferControlTypes.PAGE_MODE,true,this.mLength);
         this.mBufferController.activate(provider,false,false);
      }
      
      public function selectedItem(selectedIndex:int) : Object
      {
         var activeIndex:* = 0;
         var temp:Object = null;
         if(selectedIndex >= 0 && selectedIndex < this.mBufferController.getNumOfItemsPerPage())
         {
            selectedIndex += this.mBufferController.getCurScreenPosition();
            activeIndex = selectedIndex;
            if(this.mBufferController.getFolderSize() > 0)
            {
               activeIndex--;
            }
            this.mBufferController.setCurActiveIndex(activeIndex);
            temp = new Object();
            temp.data = this.getItem(selectedIndex);
            temp.index = activeIndex;
            return temp;
         }
         return null;
      }
      
      public function getItem(absoluteIndex:int) : Object
      {
         return this.mBufferController.getItem(absoluteIndex);
      }
      
      public function fillWindowBuffer() : void
      {
         var rtn:FrameRequestReturn = this.mBufferController.responseFrameRequest();
         if(Boolean(rtn) && rtn.mListUpdateType != BufferControlTypes.NO_UPDATE)
         {
            this.mBufferController.triggerScreenUpdate(rtn);
         }
      }
      
      public function gotoListTop() : void
      {
         this.mBufferController.setCurActiveIndex(0);
         var rtn:FrameRequestReturn = this.mBufferController.calculateFrameRequest(BufferControlTypes.LIST_FILL_BUFFER,0,0,true,false);
         this.mBufferController.triggerScreenUpdate(rtn);
      }
      
      public function gotoIndex(i:int) : void
      {
         var rtn:FrameRequestReturn = this.mBufferController.calculateFrameRequest(BufferControlTypes.LIST_NEW_TRACK,i,0,true,false);
         this.mBufferController.triggerScreenUpdate(rtn);
      }
      
      public function deconstruct() : void
      {
         this.mBufferController.deActivate();
         this.mParent.view.window.removeEventListener(WidgetEvent.PRESS,this.onWindowPress);
         this.mParent.view.pageup_button.removeEventListener(WidgetEvent.CLICK,this.onPageUp);
         this.mParent.view.pagedown_button.removeEventListener(WidgetEvent.CLICK,this.onPageDown);
         this.mParent.view.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onPickupThumb);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
         Peripheral.hardControls.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.onICSEncoder);
         Peripheral.hardControls.removeEventListener(HardControlEvent.SELECT,this.onICSSelect);
         this.unpetrify();
         this.mParent = null;
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
      
      public function set selectedMin(index:int) : void
      {
         this.mSelectMin = index;
      }
      
      public function set selectedMax(index:int) : void
      {
         this.mSelectMax = index;
      }
      
      public function set itemIndex(index:int) : void
      {
         this.mItemIndex = this.checkItemIndex(index);
      }
      
      public function get selected() : int
      {
         return this.mSelectIndex;
      }
      
      public function get itemIndex() : int
      {
         return this.mItemIndex;
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
               this.mSelectIndex = this.getTotalItems() % this.mSelectMax;
               this.mItemIndex = (this.getTotalItems() - this.mSelectIndex) / this.mLength;
            }
            else if(this.mSelectIndex < this.mSelectMin)
            {
               this.mSelectIndex = this.mSelectMin;
            }
            this.itemIndex = this.mItemIndex;
         }
      }
      
      public function setListSize(song:int, folder:int = 0, parentID:int = 0) : void
      {
         if(this.mBufferController.setListSize(song,folder,parentID,false))
         {
            this.setPageRange(this.mBufferController.getCurActiveIndex());
            this.mIncrement = 0;
            this.mSelectIndex = 0;
         }
      }
      
      private function isSliderVisible() : Boolean
      {
         return this.mBufferController.getListSize() > this.mBufferController.getNumOfItemsPerPage();
      }
      
      public function getCurActiveIndex() : int
      {
         var index:int = this.mBufferController.getCurActiveIndex();
         if(index < 0)
         {
            return 0;
         }
         return index;
      }
      
      private function getPageUpButtonState() : Boolean
      {
         return this.mBufferController.getCurPageNum() > this.mMinPage;
      }
      
      private function getPageDownButtonState() : Boolean
      {
         if(this.mBufferController.getCurPageNum() + 1 == this.mMaxPage)
         {
            return this.mBufferController.isCurScreenPosAtPageBoundary();
         }
         return this.mBufferController.getCurPageNum() < this.mMaxPage;
      }
      
      private function configureIncrement() : void
      {
         if(this.isSliderVisible())
         {
            if(this.mIncrement == 0 && this.mBufferController.getListSize() != 0)
            {
               this.mIncrement = this.mTrackFull / this.mBufferController.getListSize();
            }
         }
         else
         {
            this.mIncrement = 0;
         }
      }
      
      public function set trackFull(trackFull:int) : void
      {
         this.mTrackFull = trackFull;
      }
      
      public function set total(total:int) : void
      {
         this.checkPageCount(this.isSliderVisible());
         this.configureIncrement();
         this.forceRePosition();
         this.mParent.view.pageup_button.setEnabled(this.getPageUpButtonState());
         this.mParent.view.pagedown_button.setEnabled(this.getPageDownButtonState());
         this.mTrackMin = 0;
         this.mTrackMax = this.mTrackFull;
         this.mTotalItems = total;
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
         var index:int = 0;
         var foldSize:int = 0;
         var listSize:int = 0;
         e.stopImmediatePropagation();
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
            if(this.mBufferController.getListSize() == 0)
            {
               return;
            }
            index = 0;
            foldSize = this.mBufferController.getFolderSize();
            listSize = this.mBufferController.getListSize();
            if(foldSize == 0)
            {
               index = this.mBufferController.getCurActiveIndex();
            }
            else
            {
               index = this.mBufferController.getCurActiveIndex() - foldSize;
               listSize -= foldSize;
            }
            if(index <= -1)
            {
               index = 0;
            }
            if(index > listSize)
            {
               index = listSize;
            }
            index += e.data;
            if(index < 0 || index >= listSize)
            {
               return;
            }
            this.gotoIndex(index);
         }
      }
      
      private function getListSize() : int
      {
         var foldSize:int = this.mBufferController.getFolderSize();
         var listSize:int = this.mBufferController.getListSize();
         listSize -= foldSize;
         return listSize - 1;
      }
      
      public function onICSSelect(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         if(this.mParent.length < 1)
         {
            return;
         }
         this.mSelectIndex = this.mBufferController.getCurActiveIndex() % this.mBufferController.getNumOfItemsPerPage();
         var item:MovieClip = this.mParent.view.window["item" + this.mSelectIndex + "_button"];
         if(Peripheral.personalConfig.displayTouchScreenBeep)
         {
            if(item.sound != null)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(item.sound == SoundEvent.SET ? Peripheral.audioMixerManager.TONE_SET : Peripheral.audioMixerManager.TONE_NORMAL);
            }
            else
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
            }
         }
         this.mParent.view.window.dispatchEvent(new GlobalEvent(GlobalEvent.ITEM,{
            "id":item.id,
            "select":this.mSelectIndex,
            "name":"haptic",
            "label":item.labelArrow.label.text
         }));
      }
      
      public function onWindowPress(e:WidgetEvent) : void
      {
         this.unpetrify();
      }
      
      private function onPageDown(e:WidgetEvent) : void
      {
         this.unpetrify();
         var rtn:FrameRequestReturn = this.mBufferController.calculateFrameRequest(BufferControlTypes.LIST_SKIP_FORWARDS,1);
         this.mBufferController.triggerScreenUpdate(rtn);
      }
      
      private function onPageUp(e:WidgetEvent) : void
      {
         this.unpetrify();
         var rtn:FrameRequestReturn = this.mBufferController.calculateFrameRequest(BufferControlTypes.LIST_SKIP_BACKWARDS,1);
         this.mBufferController.triggerScreenUpdate(rtn);
      }
      
      public function resetPage() : void
      {
         this.mItemIndex = 0;
         this.forceRePosition();
         this.refresh();
      }
      
      public function onPickupThumb(e:MouseEvent) : void
      {
         if(!Peripheral.vehicleStatus.speedLockOut)
         {
            this.unpetrify();
            this.mMouseStart = this.mParent.view.slider.thumb.mouseY;
            this.mParent.view.slider.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDropThumb,false,0,true);
         }
      }
      
      public function onDropThumb(evt:MouseEvent) : void
      {
         var index:int = 0;
         if(this.mBufferController.getListSize() != 0)
         {
            this.mParent.view.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDropThumb);
            this.mParent.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveThumb);
            index = int(Number(this.mParent.view.slider.thumb.mouseY - this.mMouseStart) / this.mIncrement) + this.mBufferController.getCurScreenPosition();
            if(index >= this.mBufferController.getListSize())
            {
               index = this.getListSize();
            }
            this.gotoIndex(index);
         }
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
         if(index >= this.mBufferController.getListSize())
         {
            index = this.getListSize();
         }
         this.gotoIndex(index);
      }
      
      private function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         this.setPageRange(this.mBufferController.getCurActiveIndex());
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
      
      public function invalidate() : void
      {
         this.refresh();
         var delta:int = this.mBufferController.getCurActiveIndex() - this.mBufferController.getCurScreenPosition();
         if(delta >= 0 && delta < this.mBufferController.getNumOfItemsPerPage())
         {
            this.mParent.selected = delta;
         }
         else
         {
            this.mParent.selected = this.selected;
         }
         this.forceRePosition();
      }
      
      public function forceRePosition() : void
      {
         if(this.mBufferController.getCurPageNum() == this.mBufferController.getMaxPageNum())
         {
            this.mParent.view.slider.thumb.y = this.mTrackFull;
         }
         else
         {
            this.mParent.view.slider.thumb.y = this.mIncrement * this.mBufferController.getCurScreenPosition();
         }
      }
      
      private function refresh() : void
      {
         this.mParent.view.pageup_button.setEnabled(this.getPageUpButtonState());
         this.mParent.view.pagedown_button.setEnabled(this.getPageDownButtonState());
         this.mParent.index = this.mItemIndex;
      }
      
      private function checkPageCount(visibility:Boolean) : void
      {
         this.mParent.view.slider.visible = visibility;
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
      
      public function setPageRange(i:int) : void
      {
         var calCurPageNum:int = 0;
         var curPageNum:int = 0;
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            calCurPageNum = Math.round(i / this.mBufferController.getNumOfItemsPerPage()) + 1;
            curPageNum = this.mBufferController.getCurPageNum();
            if(curPageNum != calCurPageNum)
            {
               curPageNum = calCurPageNum;
            }
            if(curPageNum <= this.mLimitOfNum)
            {
               this.mMinPage = 1;
               this.mMaxPage = this.mBufferController.getMaxPageNum() <= this.mLockedPages == true ? this.mBufferController.getMaxPageNum() : this.mLockedPages;
               return;
            }
            if(curPageNum >= this.mBufferController.getMaxPageNum() - this.mLimitOfNum)
            {
               this.mMinPage = this.mBufferController.getMaxPageNum() < this.mLockedPages == true ? 1 : int(this.mBufferController.getMaxPageNum() - this.mLockedPages - 1);
               this.mMaxPage = this.mBufferController.getMaxPageNum();
               return;
            }
            this.mMinPage = curPageNum - int(this.mLockedPages / 2);
            this.mMaxPage = curPageNum + int(this.mLockedPages / 2);
         }
         else
         {
            this.mMinPage = 1;
            this.mMaxPage = this.mBufferController.getMaxPageNum();
         }
      }
   }
}

