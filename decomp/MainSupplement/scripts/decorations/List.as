package decorations
{
   import ancillary.Style;
   import com.nfuzion.framework.global.Framework;
   import core.enums.FocusType;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class List extends Simple
   {
      
      private const OUTSTANDING_CALL_LIMIT:int = 3;
      
      private var mList:MovieClip;
      
      private var mFocus:Boolean;
      
      private var mCursor:MovieClip;
      
      private var mWorkingRows:Vector.<MovieClip>;
      
      private var mRows:Vector.<MovieClip>;
      
      private var mData:*;
      
      private var mLength:int = 0;
      
      private var mPosition:int = 0;
      
      private var mRowUpdater:Function = null;
      
      private var mDataRequester:Function = null;
      
      private var mReserveHeader:Boolean = false;
      
      private var mChangeSelection:Function = null;
      
      private var mSelectedRowIndex:int = 0;
      
      private var mSetAttachedScrollerValue:Function = null;
      
      private var mAttachedScroller:MovieClip = null;
      
      private var mBufferSize:uint = 0;
      
      private var mRequestInProgress:Boolean = false;
      
      private var mRequestedStart:int = -1;
      
      private var mRequestedEnd:int = -1;
      
      private var mRequestTimer:Timer;
      
      public function List(list:MovieClip)
      {
         var rows:Vector.<MovieClip>;
         var i:int = 0;
         var child:MovieClip = null;
         var parsedChildName:Array = null;
         this.mWorkingRows = new Vector.<MovieClip>();
         this.mRows = new Vector.<MovieClip>();
         this.mRequestTimer = new Timer(Style.List.REQUEST_TIMEOUT);
         super(list);
         this.mList = list;
         for(rows = new Vector.<MovieClip>(); i < this.mList.numChildren; )
         {
            child = this.mList.getChildAt(i) as MovieClip;
            if(child != null && child.name != null)
            {
               parsedChildName = child.name.split("_");
               if(parsedChildName.length >= 2 && parsedChildName[0] == "row")
               {
                  child.row = int(parsedChildName[1]);
                  rows.push(child);
               }
            }
            i++;
         }
         this.mRows = rows.sort(function(x:MovieClip, y:MovieClip):int
         {
            return x.row - y.row;
         });
         for(i = 0; i < this.mRows.length; i++)
         {
            this.mRows[i].row = i;
            this.mRows[i].addEventListener(MouseEvent.CLICK,this.rowClicked,false,0,true);
            this.mRows[i].addEventListener(WidgetEvent.LONG_PRESS,this.rowLongPress,false,0,true);
            this.mRows[i].addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownOnRow,false,0,true);
         }
         if(this.mRows.length < 1)
         {
            Framework.Trace("ERROR: List does not contain any visual rows!");
         }
         this.mWorkingRows = this.mRows;
         this.mBufferSize = Style.PlayerHomeScreen.BUFFER_SIZE;
         this.mRequestTimer.addEventListener(TimerEvent.TIMER,this.onRequestTimeout,false,0,true);
      }
      
      public function reset() : void
      {
         this.mLength = 0;
         this.mPosition = 0;
         this.mRowUpdater = null;
         this.mDataRequester = null;
         this.mReserveHeader = false;
         this.mChangeSelection = null;
         this.mSelectedRowIndex = 0;
         this.mSetAttachedScrollerValue = null;
         this.mAttachedScroller = null;
         this.mRequestInProgress = false;
         this.mRequestedStart = -1;
         this.mRequestedEnd = -1;
      }
      
      public function getRowCount() : int
      {
         return this.mWorkingRows.length;
      }
      
      public function positionEventHandler(e:*) : void
      {
         if(!e.hasOwnProperty("data") && e.data != null)
         {
            return;
         }
         this.setPosition(e.data);
      }
      
      public function getPosition() : int
      {
         return this.mPosition;
      }
      
      public function setPosition(position:int) : void
      {
         if(position > this.mLength - this.mWorkingRows.length)
         {
            position = this.mLength - this.mWorkingRows.length;
         }
         if(position < 0)
         {
            position = 0;
         }
         if(this.mPosition != position)
         {
            this.mPosition = position;
            this.requestLocalData();
            if(this.mSetAttachedScrollerValue != null)
            {
               this.mSetAttachedScrollerValue(this.mPosition);
            }
         }
      }
      
      public function reserveHeader(reserveHeader:Boolean) : MovieClip
      {
         var i:int = 0;
         if(reserveHeader != this.mReserveHeader)
         {
            this.mReserveHeader = reserveHeader;
            if(reserveHeader)
            {
               this.mRows[0].removeEventListener(MouseEvent.CLICK,this.rowClicked);
               this.mRows[0].removeEventListener(WidgetEvent.LONG_PRESS,this.rowLongPress);
               this.mRows[0].removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownOnRow);
               this.mRows[0].mouseEnabled = false;
               this.mRows[0].mouseChildren = false;
               this.mWorkingRows = new Vector.<MovieClip>();
               for(i = 1; i < this.mRows.length; i++)
               {
                  this.mWorkingRows.push(this.mRows[i]);
               }
               --this.mSelectedRowIndex;
               if(this.mSelectedRowIndex < 0 && this.mChangeSelection != null)
               {
                  this.mChangeSelection(this.mRows[0],false);
                  this.mChangeSelection(this.mRows[1],true);
                  this.mSelectedRowIndex = 0;
               }
            }
            else
            {
               this.mRows[0].addEventListener(MouseEvent.CLICK,this.rowClicked,false,0,true);
               this.mRows[0].addEventListener(WidgetEvent.LONG_PRESS,this.rowLongPress,false,0,true);
               this.mRows[0].addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownOnRow,false,0,true);
               this.mRows[0].mouseEnabled = true;
               this.mRows[0].mouseChildren = true;
               this.mWorkingRows = this.mRows;
               ++this.mSelectedRowIndex;
            }
            this.normalizeRows(this.mWorkingRows);
            this.update();
         }
         return this.mRows[0];
      }
      
      private function normalizeRows(rows:Vector.<MovieClip>) : void
      {
         for(var i:int = 0; i < rows.length; i++)
         {
            rows[i].row = i;
         }
      }
      
      public function dataEventHandler(e:*) : void
      {
         if(!e.hasOwnProperty("data") && e.data != null)
         {
            return;
         }
         this.setData(e.data);
      }
      
      public function getSelectedData() : *
      {
         return this.mData.list[this.mPosition - this.mData.offset + this.mSelectedRowIndex];
      }
      
      public function getData() : *
      {
         return this.mData;
      }
      
      public function setData(data:*) : void
      {
         var i:* = 0;
         var requestedLength:int = 0;
         var errorLevel:String = null;
         var mylength:int = 0;
         if(data == null)
         {
            Framework.Trace("WARNING: Null data sent to list!");
         }
         else
         {
            requestedLength = this.mRequestedEnd - this.mRequestedStart + 1;
            if(!this.mRequestInProgress)
            {
               Framework.Trace("WARNING: Unsolicited data sent to list.");
            }
            else if(data.offset == this.mRequestedStart && data.list.length == requestedLength)
            {
               this.mRequestedStart = -1;
               this.mRequestedEnd = -1;
            }
            else
            {
               errorLevel = "ERROR";
               if(data.offset <= this.mRequestedStart && data.offset + data.list.length - 1 >= this.mRequestedEnd)
               {
                  errorLevel = "WARNING";
               }
               Framework.Trace(errorLevel + ": Data request does not match data response!\n" + "  Requested offset " + this.mRequestedStart + ", recieved offset " + data.offset + ".\n" + "  Requested length " + requestedLength + ", received length " + data.list.length + ".");
               if(errorLevel == "ERROR")
               {
                  return;
               }
            }
            this.mRequestInProgress = false;
            if(data.offset >= this.mLength)
            {
               return;
            }
            if(this.getCursor() < 0)
            {
               this.setCursor(0);
            }
            if(this.mData == null || this.mData.offset > data.offset + data.list.length || data.offset > this.mData.offset + this.mData.list.length)
            {
               this.mData = {
                  "offset":data.offset,
                  "list":data.list
               };
            }
            else
            {
               if(data.list == this.mData.list)
               {
                  Framework.Trace("ERROR: Windowed data in data.list must not be reused by the caller!");
               }
               i = int(this.mData.offset - 1);
               while(i >= data.offset)
               {
                  this.mData.list.unshift(data.list[i - data.offset]);
                  this.mData.offset = i;
                  i--;
               }
               i = int(this.mData.offset + this.mData.list.length);
               mylength = int(data.list.length);
               while(i < data.offset + mylength)
               {
                  if(i >= this.mData.offset && i < this.mData.offset + this.mData.list.length)
                  {
                     this.mData.list[i - this.mData.offset] = data.list[i - data.offset];
                  }
                  else
                  {
                     this.mData.list.push(data.list[i - data.offset]);
                  }
                  i++;
               }
               i = int(this.mData.offset);
               while(this.mPosition - i > this.mBufferSize)
               {
                  this.mData.list.shift();
                  ++this.mData.offset;
                  i++;
               }
               i = int(this.mData.offset + this.mData.list.length - 1);
               while(i - (this.mPosition + this.mWorkingRows.length - 1) > this.mBufferSize)
               {
                  this.mData.list.pop();
                  i--;
               }
            }
            this.requestLocalData();
            this.update();
         }
         this.mRequestTimer.reset();
      }
      
      override public function update() : void
      {
         var i:int = 0;
         var dataIndex:int = 0;
         if(this.mRowUpdater != null)
         {
            if(this.mData == null && this.mLength > 0)
            {
               this.requestLocalData();
            }
            for(i = 0; i < this.mWorkingRows.length; i++)
            {
               dataIndex = this.mPosition + this.mWorkingRows[i].row;
               if(this.mData != null && dataIndex >= this.mData.offset && dataIndex < this.mData.offset + this.mData.list.length && dataIndex < this.mLength)
               {
                  this.mRowUpdater(this.mWorkingRows[i],i,this.mData.list[dataIndex - this.mData.offset],dataIndex);
               }
               else
               {
                  this.mRowUpdater(this.mWorkingRows[i],i,null,dataIndex);
               }
            }
         }
      }
      
      public function setRowUpdater(rowUpdater:Function) : void
      {
         this.mRowUpdater = rowUpdater;
         this.update();
      }
      
      public function setDataRequester(dataRequester:Function) : void
      {
         this.mDataRequester = dataRequester;
         this.requestData();
      }
      
      public function getDataRequester() : Function
      {
         return this.mDataRequester;
      }
      
      public function setSelectionChanger(selectionChanger:Function) : void
      {
         this.mChangeSelection = selectionChanger;
         this.changeSelection(this.mSelectedRowIndex);
      }
      
      public function getLength() : int
      {
         return this.mLength;
      }
      
      public function setLength(length:int) : void
      {
         if(this.mLength != length)
         {
            this.mLength = length;
            this.setPosition(this.getPosition());
            this.setCursor(this.getCursor());
            this.mList.dispatchEvent(new WidgetEvent(WidgetEvent.LENGTH,length,true));
            this.mData = null;
            if(this.mLength > 0)
            {
               this.requestData();
            }
            else
            {
               this.update();
            }
         }
      }
      
      public function requestData() : void
      {
         this.mData = null;
         this.mRequestInProgress = false;
         this.requestLocalData();
      }
      
      private function requestLocalData() : void
      {
         var dataStart:int = 0;
         var dataEnd:int = 0;
         var windowStart:int = 0;
         var windowEnd:int = 0;
         var overlapStart:int = 0;
         var overlapEnd:int = 0;
         var bufferedEnd:int = 0;
         var bufferedStart:int = 0;
         var overlapSize:int = 0;
         var windowSize:int = 0;
         var requestStart:int = 0;
         var requestEnd:int = 0;
         if(this.mDataRequester != null && !this.mRequestInProgress)
         {
            if(this.mData == null)
            {
               if(this.mWorkingRows.length > 0)
               {
                  this.addDataRequest(this.mPosition,this.mPosition + this.mWorkingRows.length - 1);
               }
            }
            else
            {
               dataStart = int(this.mData.offset);
               dataEnd = dataStart + this.mData.list.length - 1;
               windowStart = this.mPosition;
               windowEnd = this.mPosition + this.mWorkingRows.length - 1;
               overlapStart = -1;
               if(windowStart <= dataEnd)
               {
                  if(windowStart >= dataStart)
                  {
                     overlapStart = windowStart;
                  }
                  else if(dataStart <= windowEnd)
                  {
                     overlapStart = dataStart;
                  }
               }
               overlapEnd = -1;
               if(windowEnd >= dataStart)
               {
                  if(windowEnd <= dataEnd)
                  {
                     overlapEnd = windowEnd;
                  }
                  else if(windowStart <= dataEnd)
                  {
                     overlapEnd = dataEnd;
                  }
               }
               bufferedEnd = this.mPosition + this.mWorkingRows.length + this.mBufferSize - 1;
               if(bufferedEnd >= this.mLength)
               {
                  bufferedEnd = this.mLength - 1;
               }
               bufferedStart = this.mPosition - this.mBufferSize;
               if(bufferedStart < 0)
               {
                  bufferedStart = 0;
               }
               overlapSize = 0;
               if(overlapStart >= 0 && overlapEnd >= 0)
               {
                  overlapSize = overlapEnd - overlapStart + 1;
               }
               windowSize = int(this.mWorkingRows.length);
               if(windowSize > this.mLength)
               {
                  windowSize = this.mLength;
               }
               if(this.mPosition < this.mLength && overlapSize < windowSize)
               {
                  requestStart = this.mPosition;
                  if(overlapStart == this.mPosition)
                  {
                     requestStart = overlapEnd + 1;
                  }
                  requestEnd = requestStart + (windowSize - overlapSize) - 1;
                  this.addDataRequest(requestStart,requestEnd);
               }
               else if(dataEnd < bufferedEnd)
               {
                  this.addDataRequest(dataEnd + 1,bufferedEnd);
               }
               else if(bufferedStart < this.mData.offset)
               {
                  this.addDataRequest(bufferedStart,dataStart - 1);
               }
               if(this.mPosition >= this.mLength || overlapSize > 0)
               {
                  this.update();
               }
            }
         }
      }
      
      private function rowClicked(e:MouseEvent) : void
      {
         var row:int = 0;
         var dataOffset:int = 0;
         if(e.currentTarget.getEnabled)
         {
            if(this.mData != null)
            {
               row = int(e.currentTarget.row);
               dataOffset = this.mPosition - this.mData.offset + row;
               if(dataOffset < this.mData.list.length && dataOffset >= 0)
               {
                  this.mList.dispatchEvent(new WidgetEvent(WidgetEvent.SELECT,{
                     "targetName":e.target.name,
                     "visualIndex":row,
                     "visual":this.mWorkingRows[row],
                     "dataIndex":this.mPosition + row,
                     "data":this.mData.list[dataOffset],
                     "isICSpress":false
                  },true));
               }
            }
         }
      }
      
      private function rowLongPress(e:WidgetEvent) : void
      {
         var row:int = 0;
         var dataOffset:int = 0;
         if(this.mData != null)
         {
            row = int(e.currentTarget.row);
            dataOffset = this.mPosition - this.mData.offset + row;
            if(dataOffset < this.mData.list.length)
            {
               this.mList.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,{
                  "targetName":e.target.name,
                  "visualIndex":row,
                  "visual":this.mWorkingRows[row],
                  "dataIndex":this.mPosition + row,
                  "data":this.mData.list[dataOffset],
                  "isICSpress":false
               },true));
            }
         }
      }
      
      private function mouseDownOnRow(e:MouseEvent) : void
      {
         this.changeSelection(e.currentTarget.row);
      }
      
      public function onFocusCallBack(_object:Object) : void
      {
         switch(_object.type)
         {
            case FocusType.ROTARY:
               if(this.mSelectedRowIndex >= 0)
               {
                  this.scrollEventHandler(new HardControlEvent(HardControlEvent.VERTICAL_SCROLL,_object.value));
               }
               break;
            case FocusType.ENTER_DOWN:
               if(this.mSelectedRowIndex >= 0)
               {
                  this.rowButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
               }
               break;
            case FocusType.ENTER_RELEASE:
               if(this.mSelectedRowIndex >= 0)
               {
                  this.rowButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
                  if(!this.rowButton.parent.hasOwnProperty("options_button"))
                  {
                     this.rowButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  else if(this.rowButton.parent["options_button"].visible)
                  {
                     this.rowButton.parent["options_button"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  else
                  {
                     this.rowButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               break;
            case FocusType.CHANGE:
               this.mFocus = _object.value;
               this.setCursorVisibility();
               break;
            case FocusType.LONGPRESS:
               if(this.mSelectedRowIndex >= 0)
               {
                  this.select2SecondPressEventHandler(new HardControlEvent(HardControlEvent.SELECT_2SEC_PRESS));
               }
         }
      }
      
      private function get rowButton() : MovieClip
      {
         var row:int = this.mSelectedRowIndex;
         if(this.mReserveHeader)
         {
            row++;
         }
         if(this.mRows[row].hasOwnProperty("row_button"))
         {
            return this.mRows[row].row_button;
         }
         if(this.mRows[row].hasOwnProperty("device_button"))
         {
            return this.mRows[row].device_button;
         }
         return this.mRows[row];
      }
      
      public function scrollEventHandler(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         var newPosition:int = this.getPosition();
         var newIndex:int = this.mSelectedRowIndex + e.data;
         if(newIndex > this.mWorkingRows.length - 1)
         {
            newPosition += newIndex - (this.mWorkingRows.length - 1);
            newIndex = this.mWorkingRows.length - 1;
         }
         if(newIndex < 0)
         {
            newPosition += newIndex;
            newIndex = 0;
         }
         this.setPosition(newPosition);
         this.changeSelection(newIndex);
      }
      
      public function selectEventHandler(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         var row:int = this.mSelectedRowIndex;
         var dataOffset:int = this.mPosition - this.mData.offset + row;
         if(this.mData != null && row >= 0)
         {
            this.mList.dispatchEvent(new WidgetEvent(WidgetEvent.SELECT,{
               "targetName":this.mList.name,
               "visualIndex":row,
               "visual":this.mWorkingRows[row],
               "dataIndex":this.mPosition + row,
               "data":this.mData.list[dataOffset],
               "isICSpress":true
            },true));
         }
      }
      
      public function select2SecondPressEventHandler(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         var row:int = this.mSelectedRowIndex;
         var dataOffset:int = this.mPosition - this.mData.offset + row;
         if(this.mData != null && row >= 0)
         {
            this.mList.dispatchEvent(new WidgetEvent(WidgetEvent.LONG_PRESS,{
               "targetName":this.mList.name,
               "visualIndex":row,
               "visual":this.mWorkingRows[row],
               "dataIndex":this.mPosition + row,
               "data":this.mData.list[dataOffset],
               "isICSpress":true
            },true));
         }
      }
      
      public function setCursor(dataIndex:int) : void
      {
         if(dataIndex > this.mLength - 1)
         {
            dataIndex = this.mLength - 1;
         }
         var rowIndex:int = dataIndex - this.mPosition;
         if(rowIndex < 0)
         {
            rowIndex = 0;
         }
         this.changeSelection(rowIndex);
      }
      
      public function getCursor() : int
      {
         return this.mPosition + this.mSelectedRowIndex;
      }
      
      private function changeSelection(rowIndex:int) : void
      {
         var availableRows:int = 0;
         if(this.mChangeSelection != null)
         {
            availableRows = int(this.mWorkingRows.length);
            if(this.mLength < availableRows)
            {
               availableRows = this.mLength;
            }
            if(rowIndex > availableRows - 1)
            {
               rowIndex = availableRows - 1;
            }
            if(this.mSelectedRowIndex >= 0 && this.mSelectedRowIndex < this.mWorkingRows.length)
            {
               this.mChangeSelection(this.mWorkingRows[this.mSelectedRowIndex],false);
            }
            if(rowIndex >= 0)
            {
               this.mChangeSelection(this.mWorkingRows[rowIndex],true);
            }
         }
         this.mSelectedRowIndex = rowIndex;
         this.setCursorVisibility();
      }
      
      private function setCursorVisibility() : void
      {
         if(this.mCursor != null)
         {
            this.mCursor.visible = false;
            this.mCursor = null;
         }
         if(this.mSelectedRowIndex >= 0)
         {
            if(this.mWorkingRows[this.mSelectedRowIndex].hasOwnProperty("row_button") && Boolean(this.mWorkingRows[this.mSelectedRowIndex].row_button.hasOwnProperty("cursor")))
            {
               this.mCursor = this.mWorkingRows[this.mSelectedRowIndex].row_button.cursor;
               this.mCursor.visible = this.mFocus;
            }
            else if(this.mWorkingRows[this.mSelectedRowIndex].hasOwnProperty("device_button") && Boolean(this.mWorkingRows[this.mSelectedRowIndex].device_button.hasOwnProperty("cursor")))
            {
               this.mCursor = this.mWorkingRows[this.mSelectedRowIndex].device_button.cursor;
               this.mCursor.visible = this.mFocus;
            }
            else if(this.mWorkingRows[this.mSelectedRowIndex].hasOwnProperty("cursor"))
            {
               this.mCursor = this.mWorkingRows[this.mSelectedRowIndex].cursor;
               this.mCursor.visible = this.mFocus;
            }
         }
      }
      
      public function attachScroller(scroller:MovieClip, axis:String = "default") : void
      {
         if(scroller == null)
         {
            this.detachScroller();
            return;
         }
         this.mAttachedScroller = scroller;
         switch(axis)
         {
            case "default":
               scroller.addEventListener(WidgetEvent.POSITION,this.mList.positionEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.LENGTH,scroller.maximumEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.PAGE_SIZE,scroller.pageSizeEventHandler,false,0,true);
               scroller.setMaximum(this.getLength());
               scroller.setPageSize(this.getRowCount());
               scroller.setValue(this.getPosition());
               this.mSetAttachedScrollerValue = scroller.setValue;
               break;
            case "vertical":
               scroller.addEventListener(WidgetEvent.VERTICAL_POSITION,this.mList.positionEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.LENGTH,scroller.vMaximumEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.PAGE_SIZE,scroller.vPageSizeEventHandler,false,0,true);
               scroller.setVMaximum(this.getLength());
               scroller.setVPageSize(this.getRowCount());
               scroller.setVValue(this.getPosition());
               this.mSetAttachedScrollerValue = scroller.setVValue;
               break;
            case "horizontal":
               scroller.addEventListener(WidgetEvent.HORIZONTAL_POSITION,this.mList.positionEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.LENGTH,scroller.hMaximumEventHandler,false,0,true);
               this.mList.addEventListener(WidgetEvent.PAGE_SIZE,scroller.hPageSizeEventHandler,false,0,true);
               scroller.setHMaximum(this.getLength());
               scroller.setHPageSize(this.getRowCount());
               scroller.setHValue(this.getPosition());
               this.mSetAttachedScrollerValue = scroller.setHValue;
         }
      }
      
      public function detachScroller() : void
      {
         if(this.mAttachedScroller)
         {
            this.mAttachedScroller.removeEventListener(WidgetEvent.POSITION,this.mList.positionEventHandler);
            this.mAttachedScroller.removeEventListener(WidgetEvent.VERTICAL_POSITION,this.mList.positionEventHandler);
            this.mAttachedScroller.removeEventListener(WidgetEvent.HORIZONTAL_POSITION,this.mList.positionEventHandler);
            this.mList.removeEventListener(WidgetEvent.LENGTH,this.mAttachedScroller.maximumEventHandler);
            this.mList.removeEventListener(WidgetEvent.LENGTH,this.mAttachedScroller.vMaximumEventHandler);
            this.mList.removeEventListener(WidgetEvent.LENGTH,this.mAttachedScroller.hMaximumEventHandler);
            this.mList.removeEventListener(WidgetEvent.PAGE_SIZE,this.mAttachedScroller.pageSizeEventHandler);
            this.mList.removeEventListener(WidgetEvent.PAGE_SIZE,this.mAttachedScroller.vPageSizeEventHandler);
            this.mList.removeEventListener(WidgetEvent.PAGE_SIZE,this.mAttachedScroller.hPageSizeEventHandler);
            this.mSetAttachedScrollerValue = null;
            this.mAttachedScroller = null;
         }
      }
      
      public function setBufferSize(size:uint) : void
      {
         this.mBufferSize = size;
      }
      
      public function getBufferSize() : uint
      {
         return this.mBufferSize;
      }
      
      private function addDataRequest(start:int, end:int) : void
      {
         if(this.mLength > 0)
         {
            if(end > this.mLength - 1)
            {
               end = this.mLength - 1;
            }
            if(start < 0 || end < 0 || end < start)
            {
               Framework.Trace("WARNING: Request for invalid data range!");
               return;
            }
            this.mRequestTimer.start();
            this.mRequestedStart = start;
            this.mRequestedEnd = end;
            Framework.Trace("INFO: Requesting data from " + start + " to " + end + ".");
            this.mRequestInProgress = true;
            this.mDataRequester(start,end);
         }
      }
      
      private function onRequestTimeout(e:TimerEvent) : void
      {
         this.mRequestInProgress = false;
         this.mRequestTimer.reset();
         Framework.Trace("ERROR: No response received for list request after " + this.mRequestTimer.delay + "ms.");
         this.setData(null);
      }
   }
}

