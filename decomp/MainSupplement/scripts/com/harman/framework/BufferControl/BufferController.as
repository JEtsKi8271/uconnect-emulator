package com.harman.framework.BufferControl
{
   public class BufferController
   {
      
      private var isActive:Boolean = false;
      
      private var bOneBuffer:Boolean = false;
      
      private var mListSize:int = 0;
      
      private var mTotalItemsStored:int = 0;
      
      private var mListParentID:int = 0;
      
      private var mFolderListSize:int = 0;
      
      private var mFolderLastPageNum:int = 1;
      
      private var mSongListSize:int = 0;
      
      private var mSongStartPageNum:int = 1;
      
      private var mPageNumber:int = 1;
      
      private var maxPage:int = 1;
      
      private var mNumOfPages:int = 5;
      
      private var mNumOfItemsPerPage:int = 5;
      
      private var mPrevListPosition:int = -1;
      
      private var mCurListPosition:int = -1;
      
      private var mActiveTrackIndex:int = -1;
      
      private var mLastResult:int = 0;
      
      private var bLastPageShowInFull:Boolean = false;
      
      private var bRequestProcessing:Boolean = false;
      
      private var mFrameRequest:FrameRequestCtrl;
      
      private var mPendingFrameRequest:FrameRequestCtrl;
      
      private var mFrameRequestScreenUpdate:int = 10;
      
      private var mBuffer_A:ListBuffer;
      
      private var mBuffer_B:ListBuffer;
      
      private var mBuffer_C:ListBuffer;
      
      private var activeBuffer:ListBuffer;
      
      private var inActiveBufferPrev:ListBuffer;
      
      private var inActiveBufferNext:ListBuffer;
      
      private var mOutputMode:int = 0;
      
      private var bAllowBufferPrefillAtResponse:Boolean = true;
      
      private var mbTrackingActive:Boolean = true;
      
      private var bBufferNoFill:Boolean = false;
      
      private var mbListWrapAround:Boolean = false;
      
      private var mbResetActiveUponParentIDChange:Boolean = false;
      
      private var _mScreenAction:int = 0;
      
      private var _bFillEmptyOnLastPage:Boolean = false;
      
      private var _mDataProvider:IDataProvider;
      
      public function BufferController()
      {
         super();
         this.mBuffer_A = new ListBuffer();
         this.mBuffer_B = new ListBuffer();
         this.mBuffer_C = new ListBuffer();
      }
      
      public function isBufferNoFill() : Boolean
      {
         return this.bBufferNoFill;
      }
      
      public function getMyProvider() : IDataProvider
      {
         return this._mDataProvider;
      }
      
      public function triggerScreenUpdate(rtn:FrameRequestReturn) : void
      {
         rtn.start = this.getDisplayedStartIndex();
         rtn.numOfEntries = this.getDisplayedItems();
         this._mDataProvider.screenUpdate(rtn);
      }
      
      public function init(numOfPages:int, outputMode:int, bPrefillOk:Boolean, items_per_page:int) : void
      {
         if(items_per_page != 0 && items_per_page < BufferControlTypes.MAX_ENTIRES_PER_PAGE)
         {
            this.mNumOfItemsPerPage = items_per_page;
         }
         if(numOfPages < BufferControlTypes.MIN_BUFFERED_PAGES)
         {
            numOfPages = BufferControlTypes.MIN_BUFFERED_PAGES;
         }
         if(numOfPages > BufferControlTypes.MAX_BUFFERED_PAGES)
         {
            numOfPages = BufferControlTypes.MAX_BUFFERED_PAGES;
         }
         this.mNumOfPages = numOfPages;
         this.bOneBuffer = false;
         this.mLastResult = BufferControlTypes.RESULT_OK;
         this.mTotalItemsStored = 0;
         this.isActive = false;
         this.bLastPageShowInFull = true;
         this.mOutputMode = outputMode;
         this.bAllowBufferPrefillAtResponse = bPrefillOk;
         this.mFrameRequest = new FrameRequestCtrl();
         this.mPendingFrameRequest = new FrameRequestCtrl();
         this.activateBufferA();
      }
      
      public function setLastResponseResultOK() : void
      {
         this.mLastResult = BufferControlTypes.RESULT_OK;
         this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
         this.setFrameRequestProcessing(false);
         this.mFrameRequest.reset();
         this.mPendingFrameRequest.reset();
      }
      
      public function getTrackingActive() : Boolean
      {
         return this.mbTrackingActive;
      }
      
      public function activate(provider:IDataProvider, bAdjustForLastPage:Boolean = true, bListWrapAround:Boolean = false, bResetActiveUponSizeChange:Boolean = false) : void
      {
         this._mDataProvider = provider;
         this.mbListWrapAround = false;
         this.isActive = true;
         this.bLastPageShowInFull = bAdjustForLastPage;
         this.bBufferNoFill = false;
         this.mLastResult = BufferControlTypes.RESULT_OK;
         this.setFrameRequestProcessing(false);
         this.setListSize(0,0);
         this.mbResetActiveUponParentIDChange = bResetActiveUponSizeChange;
         this.setCurActiveIndex(BufferControlTypes.INVALID_TRACK_NUM);
      }
      
      public function deActivate() : void
      {
         this.isActive = false;
         this._mDataProvider = null;
         this.InitBuffers(false);
      }
      
      public function getOutputMode() : int
      {
         return this.mOutputMode;
      }
      
      public function isFolderItem(index:int) : Boolean
      {
         if(this.mFolderListSize == 0)
         {
            return false;
         }
         return index < this.mFolderListSize;
      }
      
      public function getItem(index:int) : Object
      {
         var retVal:Object = this.activeBuffer.getItem(index);
         if(retVal == null)
         {
            if(this.bOneBuffer == false)
            {
               retVal = this.inActiveBufferPrev.getItem(index);
               if(retVal == null)
               {
                  retVal = this.inActiveBufferNext.getItem(index);
               }
            }
         }
         return retVal;
      }
      
      public function isLastResultOK() : Boolean
      {
         return this.mLastResult != BufferControlTypes.RESULT_NOT_OK ? true : false;
      }
      
      public function getNumOfItemsPerFrame() : int
      {
         return this.mNumOfPages * this.mNumOfItemsPerPage;
      }
      
      public function getFrameRequestProcessing() : Boolean
      {
         return this.mFrameRequest.bRequestProcessing;
      }
      
      public function getCurScreenPosition() : int
      {
         return this.mCurListPosition;
      }
      
      public function getNumOfItemsPerPage() : int
      {
         return this.mNumOfItemsPerPage;
      }
      
      public function getCurActiveIndex() : int
      {
         return this.mActiveTrackIndex;
      }
      
      public function setCurActiveIndex(index:int) : void
      {
         if(index != BufferControlTypes.INVALID_TRACK_NUM)
         {
            this.mActiveTrackIndex = index + this.mFolderListSize;
         }
         else
         {
            this.mActiveTrackIndex = BufferControlTypes.INVALID_TRACK_NUM;
         }
      }
      
      public function getDisplayedStartedPage() : int
      {
         var page:int = 0;
         if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
         {
            if(this.activeBuffer)
            {
               page = this.activeBuffer.mStartPageNum;
            }
         }
         else
         {
            page = this.getCurPageNum();
         }
         return page;
      }
      
      public function getDisplayedStartIndex() : int
      {
         if(this.getListSize() == 0)
         {
            return 0;
         }
         if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
         {
            return (this.activeBuffer.mStartPageNum - 1) * this.mNumOfItemsPerPage;
         }
         return this.getCurScreenPosition();
      }
      
      public function getDisplayedItems() : int
      {
         var items:int = 0;
         if(this.getListSize() == 0)
         {
            return items;
         }
         if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
         {
            items = this.activeBuffer.num_of_items_in_buffer;
         }
         else
         {
            items = this.mNumOfItemsPerPage;
            if(this.getCurPageNum() == this.getMaxPageNum() && (this._bFillEmptyOnLastPage == false || this.activeBuffer.num_of_empty_items_in_buffer == 0))
            {
               if(this.bLastPageShowInFull == false)
               {
                  items = this.mListSize - (this.getMaxPageNum() - 1) * this.mNumOfItemsPerPage;
               }
            }
         }
         return items;
      }
      
      public function getMaxPageNum() : int
      {
         return this.maxPage;
      }
      
      public function getSongSize() : int
      {
         if(this.mTotalItemsStored != 0)
         {
            return this.mSongListSize;
         }
         return 0;
      }
      
      public function getFolderSize() : int
      {
         if(this.mTotalItemsStored != 0)
         {
            return this.mFolderListSize;
         }
         return 0;
      }
      
      public function get isBufferControlActive() : Boolean
      {
         return this.isActive;
      }
      
      public function getListParentID() : int
      {
         return this.mListParentID;
      }
      
      public function getListSize() : int
      {
         if(this.mTotalItemsStored != 0)
         {
            return this.mListSize;
         }
         return 0;
      }
      
      public function setListSize(SongListSize:int, FolderListSize:int = 0, parentID:int = 0, bFillEmptyOnLastPage:Boolean = false) : Boolean
      {
         if(this.isActive == false)
         {
            return false;
         }
         if(this.isNumOfItemsPerPageValid() == false)
         {
            return false;
         }
         if(SongListSize < 0)
         {
            SongListSize = 0;
         }
         if(FolderListSize < 0)
         {
            FolderListSize = 0;
         }
         this._bFillEmptyOnLastPage = bFillEmptyOnLastPage;
         var bListSizeChanged:Boolean = false;
         var totalSize:int = SongListSize + FolderListSize;
         if(FolderListSize != this.mFolderListSize || SongListSize != this.mSongListSize || totalSize != this.mListSize || SongListSize == 0 && FolderListSize == 0 || parentID != this.mListParentID || this.mLastResult == BufferControlTypes.RESULT_NOT_OK)
         {
            this.InitBuffers(totalSize != 0 ? false : true);
            this.mFrameRequest.reset();
            this.mPendingFrameRequest.reset();
            this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
            this.initControls(SongListSize,FolderListSize,parentID);
            this._mScreenAction = BufferControlTypes.SCREEN_JUMP;
            this.setCurListPosition(0);
            if(this.bRequestProcessing != true)
            {
               bListSizeChanged = true;
            }
            if(parentID != this.mListParentID && this.mbResetActiveUponParentIDChange)
            {
               this.setCurActiveIndex(0);
            }
         }
         if(this.mListSize == 0)
         {
            bListSizeChanged = false;
         }
         return bListSizeChanged;
      }
      
      public function calculateFrameRequest(tRequest:int, newTrack:int = 0, numOfPages:int = -1, bMakeRequest:Boolean = true, bBufferNoFill:Boolean = false) : FrameRequestReturn
      {
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         if(this.isNumOfItemsPerPageValid() == false)
         {
            return rtn;
         }
         if(this.isActive == false)
         {
            return rtn;
         }
         if(this.mFrameRequestScreenUpdate == tRequest)
         {
            return rtn;
         }
         switch(tRequest)
         {
            case BufferControlTypes.LIST_START:
               rtn = this.ListScrollUp();
               break;
            case BufferControlTypes.LIST_END:
               rtn = this.ListScrollDown();
               break;
            case BufferControlTypes.LIST_SKIP_BACKWARDS:
            case BufferControlTypes.LIST_SKIP_FORWARDS:
            case BufferControlTypes.LIST_FIRST_PAGE:
            case BufferControlTypes.LIST_LAST_PAGE:
            case BufferControlTypes.LIST_GOTO_PAGE:
               rtn = this.ListPageControl(tRequest,newTrack,false);
               break;
            case BufferControlTypes.LIST_FILL_BUFFER:
            case BufferControlTypes.LIST_REFRESH_IGNORE_PAGE:
            case BufferControlTypes.LIST_REFRESH:
            case BufferControlTypes.LIST_NEW_TRACK:
               rtn = this.TrackUpdate(tRequest,newTrack,numOfPages);
               break;
            case BufferControlTypes.LIST_FILL_ONE_BUFFER:
               rtn = this.ListFillOneBuffer(tRequest,newTrack,numOfPages,bMakeRequest,bBufferNoFill);
               break;
            default:
               return rtn;
         }
         if(rtn.bNeedFrame == true && this.bRequestProcessing == false)
         {
            this.handleFrameRequest();
         }
         return rtn;
      }
      
      private function getScreenAction() : int
      {
         return this._mScreenAction;
      }
      
      private function setCurScreenPosition(pos:int, inc:Boolean, dec:Boolean) : void
      {
         if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
         {
            this.setCurListPosition(pos);
         }
      }
      
      public function getPageNum(track:int) : int
      {
         if(this.mListSize == 0)
         {
            return 0;
         }
         var pageNum:int = BufferControlTypes.INVALID_PAGE_NUM;
         if(track <= 0)
         {
            pageNum = 1;
         }
         else
         {
            pageNum = track < this.mListSize ? int(Math.ceil((track + 1) / this.mNumOfItemsPerPage)) : this.maxPage;
         }
         return pageNum;
      }
      
      public function getCurPageNum() : int
      {
         return this.mPageNumber;
      }
      
      public function getActiveBufferOutput() : Array
      {
         if(this.activeBuffer != null)
         {
            return this.activeBuffer.mListItems;
         }
         return null;
      }
      
      public function ClearBuffer(buffer:ListBuffer, bOneBuffer:Boolean) : void
      {
         if(buffer != null)
         {
            buffer.reset();
         }
      }
      
      public function isValidList(newSongSize:int, newFolderSize:int, newParentID:int) : Boolean
      {
         var bValidList:Boolean = false;
         if(this.getListParentID() == newParentID && this.getSongSize() == newSongSize && this.getFolderSize() == newFolderSize)
         {
            bValidList = true;
         }
         return bValidList;
      }
      
      public function isCurScreenPosAtPageBoundary() : Boolean
      {
         var firstSong:int = 0;
         var bAtPageBoundary:Boolean = false;
         var lastSongOnScreen:int = this.getCurScreenPosition() + this.getNumOfItemsPerPage() - 1;
         if(lastSongOnScreen < this.mListSize)
         {
            if(this.getPageNum(lastSongOnScreen) == this.getCurPageNum())
            {
               bAtPageBoundary = true;
            }
         }
         else
         {
            firstSong = (this.mPageNumber - 1) * this.getNumOfItemsPerPage();
            if(firstSong == this.getCurScreenPosition())
            {
               bAtPageBoundary = true;
            }
         }
         return bAtPageBoundary;
      }
      
      public function getLastSongOnScreenPage() : int
      {
         var lastSongOnScreen:int = this.getCurScreenPosition() + this.getNumOfItemsPerPage() - 1;
         if(lastSongOnScreen < this.mListSize)
         {
            return this.getPageNum(lastSongOnScreen);
         }
         return this.getMaxPageNum();
      }
      
      public function responseFrameRequest(category:int = -1) : FrameRequestReturn
      {
         var frameInfo:Object = null;
         var bPageFound:Boolean = false;
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         rtn.bNeedFrame = this.mPendingFrameRequest.bRequestProcessing;
         var needListRightAway:Object = new Object();
         needListRightAway.bNeedToDrawScreen = false;
         this.setFrameRequestProcessing(false);
         this.mLastResult = BufferControlTypes.RESULT_OK;
         if(this.isActive == false)
         {
            return rtn;
         }
         if(this.mFrameRequestScreenUpdate == BufferControlTypes.LIST_FILL_ONE_BUFFER)
         {
            this.processResponseFillOneBuffer(needListRightAway.bNeedToDrawScreen,category);
            this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
            rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
            return rtn;
         }
         if(this.mFrameRequestScreenUpdate == BufferControlTypes.INVALID_REQUEST || this.processResponse(needListRightAway,category) == false)
         {
            if(this.mLastResult != BufferControlTypes.RESULT_DOESNOT_MATCH)
            {
               this.mFrameRequest.reset();
               this.mPendingFrameRequest.reset();
            }
            this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
            rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            return rtn;
         }
         this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
         if(rtn.bNeedFrame == true)
         {
            this.mFrameRequest.setFrameRequestControl(this.mPendingFrameRequest);
         }
         this.mPendingFrameRequest.reset();
         if(needListRightAway.bNeedToDrawScreen == true)
         {
            frameInfo = new Object();
            bPageFound = this.BufferControl(BufferControlTypes.LIST_FILL_BUFFER,frameInfo,this.mFrameRequest.mDesiredListPos);
            rtn.bNeedFrame = frameInfo.bNeedFrame;
            if(bPageFound == true)
            {
               this.setCurListPosition(this.mFrameRequest.mDesiredListPos);
               rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
            }
            else
            {
               rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            }
         }
         if(this.bAllowBufferPrefillAtResponse == true)
         {
            if(rtn.bNeedFrame == false)
            {
               if(this.bOneBuffer != false)
               {
                  this.mFrameRequest.reset();
                  return rtn;
               }
               if(this.handleNextBufferRequest() == false)
               {
                  if(this.handlePrevBufferRequest() == false)
                  {
                     this.mFrameRequest.reset();
                     return rtn;
                  }
               }
            }
            this.handleFrameRequest();
         }
         return rtn;
      }
      
      private function setScreenUpdate(type:int) : void
      {
         this.mFrameRequestScreenUpdate = type;
      }
      
      private function InitBuffers(bNewOneBuffer:Boolean) : void
      {
         this.ClearBuffer(this.activeBuffer,this.bOneBuffer);
         this.ClearBuffer(this.inActiveBufferNext,false);
         this.ClearBuffer(this.inActiveBufferPrev,false);
         this.bOneBuffer = bNewOneBuffer;
         this.SetTotalItems(0);
      }
      
      private function initControls(SongListSize:int, FolderListSize:int, parentID:int) : void
      {
         this.mFolderListSize = FolderListSize;
         this.mSongListSize = SongListSize;
         this.mListSize = SongListSize + FolderListSize;
         this.mListParentID = parentID;
         this.maxPage = Math.ceil(this.mListSize / this.mNumOfItemsPerPage);
         this.mFolderLastPageNum = Math.ceil(this.mFolderListSize / this.mNumOfItemsPerPage);
         this.mSongStartPageNum = Math.ceil((FolderListSize + 1) / this.mNumOfItemsPerPage);
      }
      
      private function SetTotalItems(num_of_items:int) : void
      {
         this.mTotalItemsStored = num_of_items;
      }
      
      private function setFrameRequestProcessing(bProcessing:Boolean) : void
      {
         this.bRequestProcessing = bProcessing;
      }
      
      private function setCurListPosition(pos:int) : int
      {
         this.mPrevListPosition = this.mCurListPosition;
         this.mCurListPosition = pos;
         if(this.mCurListPosition >= this.mListSize)
         {
            this.mCurListPosition = this.mListSize - 1;
         }
         if(this.mCurListPosition < 0)
         {
            this.mCurListPosition = 0;
         }
         this.setCurPageNum(this.getPageNum(this.mCurListPosition));
         var delta:int = this.mCurListPosition - this.mPrevListPosition;
         if(Math.abs(delta) > this.mNumOfItemsPerPage)
         {
            return BufferControlTypes.SCREEN_JUMP;
         }
         return delta > 0 ? BufferControlTypes.SCREEN_MOVE_DOWN : BufferControlTypes.SCREEN_MOVE_UP;
      }
      
      private function setCurPageNum(page:int) : void
      {
         this.mPageNumber = page;
      }
      
      private function handleActiveBufferResponse() : void
      {
         if(this.mFrameRequest.mPrevBufferRequestType == BufferControlTypes.INACTIVE_PREV_BUFFER)
         {
            this.ShiftBufferPtrsToPrev(false);
         }
         else if(this.mFrameRequest.mPrevBufferRequestType == BufferControlTypes.INACTIVE_NEXT_BUFFER)
         {
            this.ShiftBufferPtrsToNext(false);
         }
      }
      
      private function ShiftBufferPtrsToPrev(bCheckBuffer:Boolean) : Boolean
      {
         var tempBuffer1:ListBuffer = this.activeBuffer;
         var tempBuffer2:ListBuffer = this.inActiveBufferNext;
         this.activeBuffer = this.inActiveBufferPrev;
         this.inActiveBufferNext = tempBuffer1;
         this.inActiveBufferPrev = tempBuffer2;
         var bNeedFrame:Boolean = false;
         if(bCheckBuffer == true || bCheckBuffer == false)
         {
            bNeedFrame = this.handlePrevBufferRequest();
         }
         return bNeedFrame;
      }
      
      private function ShiftBufferPtrsToNext(bCheckBuffer:Boolean) : Boolean
      {
         var tempBuffer1:ListBuffer = this.activeBuffer;
         var tempBuffer2:ListBuffer = this.inActiveBufferPrev;
         this.activeBuffer = this.inActiveBufferNext;
         this.inActiveBufferPrev = tempBuffer1;
         this.inActiveBufferNext = tempBuffer2;
         var bNeedFrame:Boolean = false;
         if(bCheckBuffer == true || bCheckBuffer == false)
         {
            bNeedFrame = this.handleNextBufferRequest();
         }
         return bNeedFrame;
      }
      
      private function handlePrevBufferRequest() : Boolean
      {
         var bNeedFrame:Boolean = false;
         if(this.activeBuffer.mStartPageNum == 1 && this.activeBuffer.mEndPageNum == this.maxPage || this.activeBuffer.mStartPageNum == 1 && this.inActiveBufferNext.mEndPageNum == this.maxPage)
         {
            return bNeedFrame;
         }
         var newReq:FrameRequestCtrl = new FrameRequestCtrl();
         newReq.bRequestProcessing = true;
         newReq.num_of_items_per_frame = this.getNumOfItemsPerFrame();
         newReq.mDesiredListPos = BufferControlTypes.INVALID_TRACK_NUM;
         newReq.mFrameRequestType = BufferControlTypes.LIST_FILL_INACTIVE_BUFFER;
         newReq.mPrevBufferRequestType = BufferControlTypes.INVALID_BUFFER;
         if(this.isPrevBufferAdjacent() == false)
         {
            newReq.mRequestedPageNum = this.activeBuffer.mStartPageNum - this.mNumOfPages + 1;
            newReq.mBufferRequestType = BufferControlTypes.INACTIVE_PREV_BUFFER;
            bNeedFrame = this.UpdateRequestCtrl(newReq);
         }
         else if(this.activeBuffer.mStartPageNum == 1)
         {
            newReq.mBufferRequestType = BufferControlTypes.INACTIVE_PREV_BUFFER;
            if(this.mbListWrapAround == true)
            {
               newReq.mRequestedPageNum = this.maxPage - this.mNumOfPages + 1;
            }
            else
            {
               newReq.mRequestedPageNum = this.inActiveBufferNext.mEndPageNum;
            }
            bNeedFrame = this.UpdateRequestCtrl(newReq);
         }
         return bNeedFrame;
      }
      
      private function isCurrentScreenReady(buffer:ListBuffer, startEndPageNumbers:Object, track:int) : Boolean
      {
         if(track == BufferControlTypes.INVALID_TRACK_NUM || buffer == null)
         {
            startEndPageNumbers.mScreenStartPageNum = startEndPageNumbers.mScreenEndPageNum = BufferControlTypes.INVALID_PAGE_NUM;
            return false;
         }
         startEndPageNumbers.mScreenStartPageNum = this.getPageNum(track);
         startEndPageNumbers.mScreenEndPageNum = this.getPageNum(track + this.mNumOfItemsPerPage - 1);
         if(buffer.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM && buffer.getTotalItems() != 0 && startEndPageNumbers.mScreenStartPageNum >= buffer.mStartPageNum && startEndPageNumbers.mScreenEndPageNum <= buffer.mEndPageNum)
         {
            return true;
         }
         return false;
      }
      
      private function get maxTotalItemsPerFrame() : int
      {
         return this.mNumOfItemsPerPage * this.mNumOfPages;
      }
      
      private function get maxTotalItems() : int
      {
         return this.maxPage == 1 ? this.mListSize : int(this.mNumOfItemsPerPage * this.maxPage);
      }
      
      private function UpdateRequestCtrl(newReq:FrameRequestCtrl) : Boolean
      {
         var num_of_songs_in_folder_page:int = 0;
         var myPage:int = newReq.mRequestedPageNum;
         if(myPage <= 0)
         {
            newReq.mRequestedPageNum = 1;
         }
         if(this.mListSize == 0 || myPage >= this.maxPage && myPage != 1)
         {
            return false;
         }
         if(newReq.mDesiredListPos == BufferControlTypes.INVALID_TRACK_NUM)
         {
            newReq.mDesiredListPos = (newReq.mRequestedPageNum - 1) * this.mNumOfItemsPerPage;
         }
         var mAvailableSize:int = this.mListSize - (newReq.mRequestedPageNum - 1) * this.mNumOfItemsPerPage;
         if(newReq.num_of_items_per_frame > mAvailableSize)
         {
            newReq.num_of_empty_items_per_frame = this._bFillEmptyOnLastPage == true ? int(this.maxTotalItems - this.mListSize) : 0;
            newReq.num_of_items_per_frame = mAvailableSize;
         }
         if(this.mFolderListSize != 0)
         {
            if(newReq.mRequestedPageNum <= this.mFolderLastPageNum)
            {
               newReq.num_of_folders_per_frame = this.mNumOfItemsPerPage * (this.mFolderLastPageNum - newReq.mRequestedPageNum + 1);
               num_of_songs_in_folder_page = this.mNumOfItemsPerPage * this.mFolderLastPageNum - this.mFolderListSize;
               newReq.num_of_folders_per_frame -= num_of_songs_in_folder_page;
               if(newReq.num_of_folders_per_frame > newReq.num_of_items_per_frame)
               {
                  newReq.num_of_folders_per_frame = newReq.num_of_items_per_frame;
               }
               newReq.mSongStartPos = 0;
            }
            else
            {
               newReq.num_of_folders_per_frame = 0;
               newReq.mSongStartPos = (newReq.mRequestedPageNum - 1) * this.mNumOfItemsPerPage - this.mFolderListSize;
            }
         }
         else
         {
            newReq.mSongStartPos = (newReq.mRequestedPageNum - 1) * this.mNumOfItemsPerPage;
            newReq.num_of_folders_per_frame = 0;
         }
         if(this.mSongListSize != 0)
         {
            if(newReq.mSongStartPos + 1 > this.mSongListSize)
            {
               newReq.mSongStartPos = 0;
            }
         }
         else
         {
            newReq.mSongStartPos = BufferControlTypes.INVALID_TRACK_NUM;
         }
         var buffer:Object = new Object();
         if(newReq.mBufferRequestType == BufferControlTypes.ACTIVE_BUFFER)
         {
            buffer = this.activeBuffer;
         }
         else if(this.bOneBuffer == false && newReq.mBufferRequestType == BufferControlTypes.INACTIVE_PREV_BUFFER)
         {
            buffer = this.inActiveBufferPrev;
         }
         else
         {
            if(!(this.bOneBuffer == false && newReq.mBufferRequestType == BufferControlTypes.INACTIVE_NEXT_BUFFER))
            {
               return false;
            }
            buffer = this.inActiveBufferNext;
         }
         if(!buffer)
         {
            return false;
         }
         if(buffer.mStartPageNum == newReq.mRequestedPageNum || this.mFrameRequest.isFrameRequestCtrlEqual(newReq) == true || this.mPendingFrameRequest.isFrameRequestCtrlEqual(newReq) == true)
         {
            return false;
         }
         if(this.bRequestProcessing == false)
         {
            this.mFrameRequest.setFrameRequestControl(newReq);
         }
         else
         {
            if(newReq.mBufferRequestType != BufferControlTypes.ACTIVE_BUFFER)
            {
               return false;
            }
            this.mPendingFrameRequest.setFrameRequestControl(newReq);
         }
         return true;
      }
      
      private function handleActiveBufferRequest(type:int, newStartPos:int, newStartPage:int) : Boolean
      {
         var requestedStartPos:int = 0;
         var requestedEndPos:int = 0;
         var newReq:FrameRequestCtrl = new FrameRequestCtrl();
         if(this.bRequestProcessing == true)
         {
            requestedStartPos = this.mFrameRequest.mRequestedPageNum * this.getNumOfItemsPerPage();
            requestedEndPos = requestedStartPos + this.mFrameRequest.num_of_items_per_frame;
            if(newStartPos >= requestedStartPos && newStartPos <= requestedEndPos)
            {
               this.mFrameRequest.mPrevBufferRequestType = this.mFrameRequest.mBufferRequestType;
               this.mFrameRequest.mBufferRequestType = BufferControlTypes.ACTIVE_BUFFER;
               this.mFrameRequest.mFrameRequestType = type;
               this.mFrameRequest.mDesiredListPos = newStartPos;
               return false;
            }
         }
         newReq.bRequestProcessing = true;
         newReq.num_of_items_per_frame = this.getNumOfItemsPerFrame();
         newReq.mDesiredListPos = newStartPos;
         newReq.mFrameRequestType = type;
         newReq.mBufferRequestType = BufferControlTypes.ACTIVE_BUFFER;
         newReq.mPrevBufferRequestType = BufferControlTypes.INVALID_BUFFER;
         newReq.mRequestedPageNum = newStartPage;
         return this.UpdateRequestCtrl(newReq);
      }
      
      private function handleNextBufferRequest() : Boolean
      {
         var bNeedFrame:Boolean = false;
         if(this.activeBuffer.mEndPageNum == this.maxPage && this.activeBuffer.mStartPageNum == 1)
         {
            return bNeedFrame;
         }
         var newReq:FrameRequestCtrl = new FrameRequestCtrl();
         newReq.bRequestProcessing = true;
         newReq.num_of_items_per_frame = this.getNumOfItemsPerFrame();
         newReq.mDesiredListPos = BufferControlTypes.INVALID_TRACK_NUM;
         newReq.mPrevBufferRequestType = BufferControlTypes.INVALID_BUFFER;
         newReq.mFrameRequestType = BufferControlTypes.LIST_FILL_INACTIVE_BUFFER;
         if(this.isNextBufferAdjacent() == false)
         {
            newReq.mBufferRequestType = BufferControlTypes.INACTIVE_NEXT_BUFFER;
            newReq.mRequestedPageNum = this.activeBuffer.mEndPageNum;
            bNeedFrame = this.UpdateRequestCtrl(newReq);
         }
         else if(this.activeBuffer.mEndPageNum == this.maxPage && this.inActiveBufferPrev.mStartPageNum != 1 && this.inActiveBufferPrev.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM)
         {
            newReq.mBufferRequestType = BufferControlTypes.INACTIVE_NEXT_BUFFER;
            if(this.mbListWrapAround == true)
            {
               newReq.mRequestedPageNum = 1;
            }
            else
            {
               newReq.mRequestedPageNum = this.activeBuffer.mStartPageNum - 2 * (this.mNumOfPages - 1);
            }
            bNeedFrame = this.UpdateRequestCtrl(newReq);
         }
         return bNeedFrame;
      }
      
      private function isPrevBufferAdjacent() : Boolean
      {
         if(this.activeBuffer.mStartPageNum == 1)
         {
            return true;
         }
         var bAdjacent:Boolean = false;
         if(this.inActiveBufferPrev.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM && this.activeBuffer.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM && this.inActiveBufferPrev.mStartPageNum < this.activeBuffer.mStartPageNum && this.inActiveBufferPrev.mEndPageNum < this.activeBuffer.mEndPageNum)
         {
            if(this.inActiveBufferPrev.mEndPageNum == this.activeBuffer.mStartPageNum || this.inActiveBufferPrev.mStartPageNum == 1 && this.inActiveBufferPrev.mEndPageNum >= this.activeBuffer.mStartPageNum)
            {
               bAdjacent = true;
            }
         }
         return bAdjacent;
      }
      
      private function isNextBufferAdjacent() : Boolean
      {
         if(this.activeBuffer.mEndPageNum == this.maxPage)
         {
            return true;
         }
         var bAdjacent:Boolean = false;
         if(this.inActiveBufferNext.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM && this.activeBuffer.mStartPageNum != BufferControlTypes.INVALID_PAGE_NUM && this.inActiveBufferNext.mStartPageNum >= this.activeBuffer.mStartPageNum && this.inActiveBufferNext.mEndPageNum >= this.activeBuffer.mEndPageNum)
         {
            if(this.activeBuffer.mEndPageNum == this.inActiveBufferNext.mStartPageNum || this.inActiveBufferNext.mStartPageNum <= this.activeBuffer.mEndPageNum && this.inActiveBufferNext.mEndPageNum == this.maxPage)
            {
               bAdjacent = true;
            }
         }
         return bAdjacent;
      }
      
      private function BufferControl(type:int, frameInfo:Object, track:int) : Boolean
      {
         var bPageFound:Boolean = true;
         frameInfo.bNeedFrame = false;
         frameInfo.bBufferShifted = false;
         if(!this.activeBuffer)
         {
            return bPageFound;
         }
         var startEndPages:Object = new Object();
         var bPageInBuffer:Boolean = this.isCurrentScreenReady(this.activeBuffer,startEndPages,track);
         if(bPageInBuffer == false)
         {
            bPageInBuffer = this.isCurrentScreenReady(this.inActiveBufferNext,startEndPages,track);
            if(bPageInBuffer == false)
            {
               bPageInBuffer = this.isCurrentScreenReady(this.inActiveBufferPrev,startEndPages,track);
               if(bPageInBuffer != false)
               {
                  frameInfo.bNeedFrame = this.ShiftBufferPtrsToPrev(true);
                  frameInfo.bBufferShifted = true;
                  if(frameInfo.bNeedFrame == false)
                  {
                     frameInfo.bNeedFrame = this.handleNextBufferRequest();
                  }
               }
            }
            else
            {
               frameInfo.bNeedFrame = this.ShiftBufferPtrsToNext(true);
               frameInfo.bBufferShifted = true;
               if(frameInfo.bNeedFrame == false)
               {
                  frameInfo.bNeedFrame = this.handlePrevBufferRequest();
               }
            }
         }
         bPageFound = bPageInBuffer;
         frameInfo.mScreenStartPageNum = startEndPages.mScreenStartPageNum;
         frameInfo.mScreenEndPageNum = startEndPages.mScreenEndPageNum;
         return bPageFound;
      }
      
      private function TrackUpdate(tRequest:int, newTrack:int, mOffsetFromTop:int) : FrameRequestReturn
      {
         var newStartPage:int = 0;
         var newEndPage:int = 0;
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         var newStartPos:int = 0;
         if(this.bLastPageShowInFull == false)
         {
            mOffsetFromTop = 0;
         }
         var startEndPages:Object = new Object();
         if(tRequest == BufferControlTypes.LIST_FILL_BUFFER)
         {
            if(newTrack != BufferControlTypes.INVALID_TRACK_NUM)
            {
               newStartPos = newTrack > mOffsetFromTop ? int(newTrack - mOffsetFromTop) : 0;
            }
            else if(this.mActiveTrackIndex == BufferControlTypes.INVALID_TRACK_NUM)
            {
               newStartPos = 0;
            }
            else if(this.getTrackingActive() == true)
            {
               tRequest = BufferControlTypes.LIST_NEW_TRACK;
            }
         }
         else
         {
            this.setCurActiveIndex(newTrack);
            if(tRequest == BufferControlTypes.LIST_NEW_TRACK)
            {
               if(this.isCurrentScreenReady(this.activeBuffer,startEndPages,this.getCurScreenPosition()))
               {
                  if(this.mActiveTrackIndex >= this.getCurScreenPosition() && this.mActiveTrackIndex < this.getCurScreenPosition() + this.mNumOfItemsPerPage)
                  {
                     rtn.bNeedFrame = false;
                     rtn.mListUpdateType = BufferControlTypes.TRACK_UPDATE;
                     return rtn;
                  }
               }
            }
            newStartPos = this.mActiveTrackIndex > mOffsetFromTop ? int(this.mActiveTrackIndex - mOffsetFromTop) : 0;
         }
         if(tRequest != BufferControlTypes.LIST_REFRESH_IGNORE_PAGE)
         {
            if(this.bLastPageShowInFull == true)
            {
               if(this.mNumOfItemsPerPage + newStartPos > this.mListSize)
               {
                  newStartPos = this.mListSize - this.mNumOfItemsPerPage;
               }
            }
            else
            {
               newStartPos = (this.getPageNum(newStartPos) - 1) * this.mNumOfItemsPerPage;
            }
         }
         if(newStartPos == this.getCurScreenPosition() && this.getListSize() != 0)
         {
            return rtn;
         }
         var frameInfo:Object = new Object();
         var bPageFound:Boolean = this.BufferControl(BufferControlTypes.LIST_FILL_BUFFER,frameInfo,newStartPos);
         rtn.bNeedFrame = frameInfo.bNeedFrame;
         if(bPageFound == false)
         {
            if(this.handleActiveBufferRequest(tRequest,newStartPos,frameInfo.mScreenStartPageNum - Math.ceil(this.mNumOfPages / 2)))
            {
               rtn.bNeedFrame = true;
            }
            rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            this.setScreenUpdate(tRequest);
         }
         else
         {
            rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
            this.setCurListPosition(newStartPos);
            if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
            {
               if(frameInfo.bBufferShifted == false)
               {
                  rtn.mListUpdateType = BufferControlTypes.TRACK_UPDATE;
               }
            }
            if(rtn.bNeedFrame == false)
            {
               rtn.bNeedFrame = this.handleBufferPrefill();
            }
         }
         if(this.bOneBuffer && this.mOutputMode == BufferControlTypes.BUFFER_MODE)
         {
            if(rtn.bNeedFrame)
            {
               rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
               rtn.bNeedFrame = false;
               this.setupPageNumForBufferOutputMode();
            }
         }
         return rtn;
      }
      
      private function handleBufferPrefill() : Boolean
      {
         var bNeedFrame:Boolean = false;
         if(this.bAllowBufferPrefillAtResponse == false)
         {
            bNeedFrame = this.handleNextBufferRequest();
            if(bNeedFrame == false)
            {
               bNeedFrame = this.handlePrevBufferRequest();
            }
         }
         return bNeedFrame;
      }
      
      private function ListPageControl(tRequest:int, numOfPages:int, bCallFromListMove:Boolean) : FrameRequestReturn
      {
         var newPageNum:int = 0;
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         var bAtPageBoundary:Boolean = false;
         if(this.getLastSongOnScreenPage() == this.getCurPageNum())
         {
            bAtPageBoundary = true;
         }
         if(tRequest == BufferControlTypes.LIST_SKIP_FORWARDS)
         {
            if(this.getLastSongOnScreenPage() == this.getMaxPageNum())
            {
               newPageNum = numOfPages;
            }
            else
            {
               if(this.getLastSongOnScreenPage() != this.getCurPageNum())
               {
                  numOfPages--;
               }
               newPageNum = this.maxPage <= this.mPageNumber + numOfPages ? this.maxPage : int(this.mPageNumber + numOfPages);
            }
         }
         else if(tRequest == BufferControlTypes.LIST_SKIP_BACKWARDS)
         {
            if(bAtPageBoundary == false)
            {
               numOfPages--;
            }
            if(this.mPageNumber == 1 && numOfPages > 0)
            {
               if(this.maxPage <= numOfPages)
               {
                  return rtn;
               }
               newPageNum = this.maxPage - numOfPages + 1;
            }
            else
            {
               newPageNum = this.mPageNumber > numOfPages ? int(this.mPageNumber - numOfPages) : 1;
            }
         }
         else if(tRequest == BufferControlTypes.LIST_FIRST_PAGE || tRequest == BufferControlTypes.LIST_FILL_BUFFER)
         {
            newPageNum = 1;
         }
         else if(tRequest == BufferControlTypes.LIST_LAST_PAGE)
         {
            newPageNum = this.maxPage;
         }
         else
         {
            if(tRequest != BufferControlTypes.LIST_GOTO_PAGE)
            {
               return rtn;
            }
            if(numOfPages <= this.maxPage)
            {
               newPageNum = numOfPages;
            }
            else
            {
               newPageNum = this.maxPage;
            }
         }
         if(newPageNum > this.maxPage)
         {
            newPageNum = this.maxPage;
         }
         var newStartPos:int = (newPageNum - 1) * this.mNumOfItemsPerPage;
         if(this.bLastPageShowInFull == true)
         {
            if(this.mNumOfItemsPerPage + newStartPos > this.mListSize)
            {
               newStartPos = this.mListSize - this.mNumOfItemsPerPage;
            }
         }
         if(newStartPos == this.getCurScreenPosition() && this.getListSize() != 0)
         {
            return rtn;
         }
         var frameInfo:Object = new Object();
         var bPageFound:Boolean = this.BufferControl(BufferControlTypes.LIST_START,frameInfo,newStartPos);
         rtn.bNeedFrame = frameInfo.bNeedFrame;
         if(bPageFound == false)
         {
            if(this.handleActiveBufferRequest(tRequest,newStartPos,frameInfo.mScreenStartPageNum - Math.ceil(this.mNumOfPages / 2)) == true)
            {
               rtn.bNeedFrame = true;
            }
            rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            this.setScreenUpdate(tRequest);
         }
         else
         {
            rtn.mScreenAction = this.setCurListPosition(newStartPos);
            rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
            if(this.mOutputMode == BufferControlTypes.BUFFER_MODE)
            {
               if(frameInfo.bBufferShifted == false)
               {
                  rtn.mListUpdateType = BufferControlTypes.TRACK_UPDATE;
               }
            }
            if(rtn.bNeedFrame == false)
            {
               rtn.bNeedFrame = this.handleBufferPrefill();
            }
         }
         if(this.bOneBuffer && this.mOutputMode == BufferControlTypes.BUFFER_MODE && bCallFromListMove == false)
         {
            if(rtn.bNeedFrame)
            {
               rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
               rtn.bNeedFrame = false;
               rtn.mScreenAction = this.setupPageNumForBufferOutputMode();
            }
         }
         frameInfo = null;
         return rtn;
      }
      
      private function isNumOfItemsPerPageValid() : Boolean
      {
         return this.mNumOfItemsPerPage >= BufferControlTypes.MAX_ENTIRES_PER_PAGE || this.mNumOfItemsPerPage == 0 ? false : true;
      }
      
      private function ListFillOneBuffer(tRequest:int, newTrack:int, mOffsetFromTop:int, bMakeRequest:Boolean = true, bOneBufferNoFill:Boolean = false) : FrameRequestReturn
      {
         var newStartPos:int = 0;
         var newReq:FrameRequestCtrl = null;
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         if(tRequest == BufferControlTypes.LIST_FILL_ONE_BUFFER)
         {
            newStartPos = 0;
            if(newTrack != 0 && newTrack != BufferControlTypes.INVALID_TRACK_NUM)
            {
               newStartPos = newTrack > mOffsetFromTop ? int(newTrack - mOffsetFromTop) : 0;
            }
            newReq = new FrameRequestCtrl();
            newReq.num_of_items_per_frame = this.mListSize;
            newReq.num_of_empty_items_per_frame = this._bFillEmptyOnLastPage ? int(this.maxPage * this.mNumOfItemsPerPage - this.mListSize) : 0;
            newReq.mDesiredListPos = newStartPos;
            newReq.mFrameRequestType = BufferControlTypes.LIST_FILL_ONE_BUFFER;
            newReq.mBufferRequestType = BufferControlTypes.ACTIVE_BUFFER;
            newReq.mRequestedPageNum = 1;
            newReq.mSongStartPos = 0;
            if(bOneBufferNoFill == false)
            {
               this.bBufferNoFill = false;
            }
            else
            {
               this.bBufferNoFill = bOneBufferNoFill;
            }
            this.mFrameRequest = newReq;
            this.setScreenUpdate(BufferControlTypes.LIST_FILL_ONE_BUFFER);
         }
         rtn.bNeedFrame = bMakeRequest;
         return rtn;
      }
      
      private function handleFrameRequest() : void
      {
         if(this.bRequestProcessing == true)
         {
            return;
         }
         if(this.mFrameRequest.mRequestedPageNum == BufferControlTypes.INVALID_PAGE_NUM)
         {
            this.setScreenUpdate(BufferControlTypes.INVALID_REQUEST);
            return;
         }
         if(this.mFrameRequest.mFrameRequestType != BufferControlTypes.LIST_FILL_ONE_BUFFER)
         {
            this.bBufferNoFill = false;
         }
         var newSongStartPos:int = this.mFrameRequest.mSongStartPos;
         var newFolderStartPos:int = BufferControlTypes.INVALID_TRACK_NUM;
         if(this.mFrameRequest.num_of_folders_per_frame > 0)
         {
            newFolderStartPos = (this.mFrameRequest.mRequestedPageNum - 1) * this.mNumOfItemsPerPage;
         }
         this.setFrameRequestProcessing(true);
         if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.ACTIVE_BUFFER || this.mFrameRequest.mFrameRequestType == BufferControlTypes.LIST_FILL_INACTIVE_BUFFER)
         {
            this.setScreenUpdate(this.mFrameRequest.mFrameRequestType);
         }
         var num_of_songs_requested:int = this.mFrameRequest.num_of_items_per_frame - this.mFrameRequest.num_of_folders_per_frame;
         if(num_of_songs_requested < 0)
         {
            num_of_songs_requested = 0;
         }
         this._mDataProvider.requestNewFrame.call(null,newSongStartPos,num_of_songs_requested,newFolderStartPos,this.mFrameRequest.num_of_folders_per_frame,this.mFrameRequest.mFrameRequestType);
      }
      
      private function processResponse(needListRightAway:Object, category:int) : Boolean
      {
         var tempBuffer:ListBuffer = null;
         if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.ACTIVE_BUFFER)
         {
            needListRightAway.bNeedToDrawScreen = true;
            this.handleActiveBufferResponse();
            tempBuffer = this.activeBuffer;
         }
         else if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.INACTIVE_NEXT_BUFFER)
         {
            tempBuffer = this.inActiveBufferNext;
         }
         else
         {
            if(this.mFrameRequest.mBufferRequestType != BufferControlTypes.INACTIVE_PREV_BUFFER)
            {
               return false;
            }
            tempBuffer = this.inActiveBufferPrev;
         }
         if(!tempBuffer)
         {
            return false;
         }
         this.ClearBuffer(tempBuffer,this.bOneBuffer);
         var num_of_songs_requested:int = this.mFrameRequest.num_of_items_per_frame - this.mFrameRequest.num_of_folders_per_frame;
         var startPos:int = (this.mFrameRequest.mRequestedPageNum - 1) * this.mNumOfItemsPerPage;
         var emptyLines:int = this._bFillEmptyOnLastPage ? this.mFrameRequest.num_of_empty_items_per_frame : 0;
         this.mLastResult = this._mDataProvider.FillBuffer(tempBuffer,num_of_songs_requested,this.mFrameRequest.num_of_folders_per_frame);
         if(this.mLastResult == BufferControlTypes.RESULT_NOT_OK)
         {
            return false;
         }
         if(this.mLastResult == BufferControlTypes.RESULT_DOESNOT_MATCH)
         {
            return false;
         }
         var numOfMisMatchItems:int = 0;
         tempBuffer.mStartIndex = startPos;
         tempBuffer.mStartPageNum = this.mFrameRequest.mRequestedPageNum;
         tempBuffer.mEndPageNum = this.mFrameRequest.mRequestedPageNum + Math.ceil(this.mFrameRequest.num_of_items_per_frame / this.mNumOfItemsPerPage) - 1;
         if(tempBuffer.mEndPageNum > this.maxPage)
         {
            tempBuffer.mEndPageNum = this.maxPage;
         }
         if(this.mLastResult == BufferControlTypes.RESULT_REVISE_SIZE)
         {
            if(this.mFrameRequest.num_of_items_per_frame > tempBuffer.mListItems.length)
            {
               numOfMisMatchItems = this.mFrameRequest.num_of_items_per_frame - tempBuffer.mListItems.length;
               this.mFrameRequest.num_of_items_per_frame = tempBuffer.mListItems.length;
               this.mListSize -= numOfMisMatchItems;
               this.maxPage = Math.ceil(this.mListSize / this.mNumOfItemsPerPage);
               if(this.mFrameRequest.num_of_items_per_frame == 0)
               {
                  return false;
               }
            }
            else
            {
               numOfMisMatchItems = tempBuffer.mListItems.length - this.mFrameRequest.num_of_items_per_frame;
               if(this.maxPage == tempBuffer.mEndPageNum)
               {
                  this.mListSize += numOfMisMatchItems;
               }
            }
         }
         tempBuffer.num_of_items_in_buffer = this.mFrameRequest.num_of_items_per_frame;
         if(this._bFillEmptyOnLastPage)
         {
            if(numOfMisMatchItems == 0 && tempBuffer.mListItems.length == this.mFrameRequest.num_of_items_per_frame + emptyLines)
            {
               tempBuffer.num_of_items_in_buffer = tempBuffer.mListItems.length;
               tempBuffer.num_of_empty_items_in_buffer = emptyLines;
            }
            else
            {
               tempBuffer.num_of_empty_items_in_buffer = 0;
            }
         }
         this.UpdateTotalItems(tempBuffer.num_of_items_in_buffer);
         return true;
      }
      
      private function UpdateTotalItems(num_of_items:int) : void
      {
         this.mTotalItemsStored += num_of_items;
      }
      
      private function ListScrollUp() : FrameRequestReturn
      {
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         if(this.getDisplayedStartIndex() == 0)
         {
            if(1 == this.activeBuffer.mStartPageNum)
            {
               if(this.mbListWrapAround == false)
               {
                  return rtn;
               }
            }
            else if(this.bOneBuffer == false && 1 == this.inActiveBufferPrev.mStartPageNum)
            {
               rtn.bNeedFrame = this.ShiftBufferPtrsToPrev(true);
               rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
               return rtn;
            }
         }
         var newStartPos:int = this.getCurScreenPosition();
         var frameInfo:Object = new Object();
         if(this.mbListWrapAround == true && newStartPos == 0)
         {
            newStartPos = this.getListSize() - 1;
         }
         var bPageFound:Boolean = this.BufferControl(BufferControlTypes.LIST_START,frameInfo,--newStartPos);
         rtn.bNeedFrame = frameInfo.bNeedFrame;
         if(bPageFound == false)
         {
            if(this.handleActiveBufferRequest(BufferControlTypes.LIST_START,newStartPos,frameInfo.mScreenStartPageNum - Math.ceil(this.mNumOfPages / 2)) == true)
            {
               rtn.bNeedFrame = true;
            }
            rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            this.setScreenUpdate(BufferControlTypes.LIST_START);
            return rtn;
         }
         rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
         this.setCurListPosition(newStartPos);
         return rtn;
      }
      
      private function ListScrollDown() : FrameRequestReturn
      {
         var rtn:FrameRequestReturn = new FrameRequestReturn();
         if(this.mOutputMode == BufferControlTypes.PAGE_MODE && this.mListSize <= this.mNumOfItemsPerPage + this.getCurScreenPosition() || this.mOutputMode == BufferControlTypes.BUFFER_MODE && this.mListSize <= this.getDisplayedStartIndex() + this.getDisplayedItems())
         {
            if(this.maxPage == this.activeBuffer.mEndPageNum)
            {
               if(this.mbListWrapAround == false)
               {
                  return rtn;
               }
            }
            else if(this.bOneBuffer == false && this.maxPage == this.inActiveBufferNext.mEndPageNum)
            {
               rtn.bNeedFrame = this.ShiftBufferPtrsToNext(true);
               rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
               return rtn;
            }
         }
         var newStartPos:int = this.getCurScreenPosition();
         var frameInfo:Object = new Object();
         if(this.mbListWrapAround == true && this.maxPage == this.activeBuffer.mEndPageNum)
         {
            newStartPos = -1;
         }
         var bPageFound:Boolean = this.BufferControl(BufferControlTypes.LIST_END,frameInfo,++newStartPos);
         rtn.bNeedFrame = frameInfo.bNeedFrame;
         if(bPageFound == false)
         {
            if(this.handleActiveBufferRequest(BufferControlTypes.LIST_END,newStartPos,frameInfo.mScreenStartPageNum - Math.ceil(this.mNumOfPages / 2)) == true)
            {
               rtn.bNeedFrame = true;
            }
            this.setScreenUpdate(BufferControlTypes.LIST_END);
            rtn.mListUpdateType = BufferControlTypes.NO_UPDATE;
            return rtn;
         }
         this.setCurListPosition(newStartPos);
         rtn.mListUpdateType = BufferControlTypes.LIST_UPDATE;
         return rtn;
      }
      
      private function processResponseFillOneBuffer(needListRightAway:Object, category:int) : Boolean
      {
         var leftOver:int = 0;
         this.InitBuffers(true);
         if(this.activeBuffer == null)
         {
            return false;
         }
         var emptyLines:int = 0;
         this.mLastResult = this._mDataProvider.FillBuffer(this.activeBuffer,this.mFrameRequest.num_of_items_per_frame,0);
         needListRightAway.bNeedToDrawScreen = true;
         this.activeBuffer.mStartIndex = 0;
         this.activeBuffer.mStartPageNum = 1;
         var bufferSize:int = int(this.activeBuffer.mListItems.length);
         if(this.bBufferNoFill == true)
         {
            bufferSize = 0;
            this.mLastResult = BufferControlTypes.RESULT_OK;
         }
         this.activeBuffer.bBufferNoFill = this.bBufferNoFill;
         this.activeBuffer.mEndPageNum = Math.ceil(bufferSize / this.mNumOfItemsPerPage);
         this.activeBuffer.num_of_items_in_buffer = bufferSize;
         this.activeBuffer.bOneBufferMode = this.bOneBuffer;
         this.SetTotalItems(this.activeBuffer.num_of_items_in_buffer);
         this.mListParentID = 0;
         this.mFolderListSize = 0;
         this.mSongListSize = this.activeBuffer.num_of_items_in_buffer;
         this.mListSize = this.activeBuffer.num_of_items_in_buffer;
         this.mFolderLastPageNum = Math.ceil(this.mFolderListSize / this.mNumOfItemsPerPage);
         this.mSongStartPageNum = Math.ceil((this.mFolderListSize + 1) / this.mNumOfItemsPerPage);
         this.maxPage = this.activeBuffer.mEndPageNum;
         if(this._bFillEmptyOnLastPage)
         {
            if(this.activeBuffer.mListItems.length == this.mFrameRequest.num_of_items_per_frame + emptyLines)
            {
               this.activeBuffer.num_of_items_in_buffer = this.activeBuffer.mListItems.length;
               this.activeBuffer.num_of_empty_items_in_buffer = emptyLines;
            }
            else
            {
               this.activeBuffer.num_of_empty_items_in_buffer = 0;
            }
         }
         if(this.mFrameRequestScreenUpdate != BufferControlTypes.INVALID_REQUEST && this.mFrameRequest.mDesiredListPos != BufferControlTypes.INVALID_TRACK_NUM)
         {
            if(this.bLastPageShowInFull == true)
            {
               if(this.mNumOfItemsPerPage + this.mFrameRequest.mDesiredListPos > this.mListSize)
               {
                  this.mFrameRequest.mDesiredListPos = this.mListSize - this.mNumOfItemsPerPage;
               }
            }
            leftOver = this.mFrameRequest.mDesiredListPos % this.mNumOfItemsPerPage;
            this.mFrameRequest.mDesiredListPos -= leftOver;
            this.setCurListPosition(this.mFrameRequest.mDesiredListPos);
         }
         else
         {
            this.setCurListPosition(0);
         }
         this.setupPageNumForBufferOutputMode(true);
         return true;
      }
      
      private function setupPageNumForBufferOutputMode(bFirstSetup:Boolean = false) : int
      {
         if(this.mOutputMode == BufferControlTypes.PAGE_MODE || this.bOneBuffer == false)
         {
            return 0;
         }
         var buffer:Object = new Object();
         if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.ACTIVE_BUFFER)
         {
            buffer = this.activeBuffer;
         }
         else if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.INACTIVE_PREV_BUFFER)
         {
            buffer = this.inActiveBufferPrev;
         }
         else if(this.mFrameRequest.mBufferRequestType == BufferControlTypes.INACTIVE_NEXT_BUFFER)
         {
            buffer = this.inActiveBufferNext;
         }
         if(bFirstSetup)
         {
            this.mFrameRequest.mRequestedPageNum = this.mPageNumber - this.mNumOfPages / 2;
            if(this.mFrameRequest.mRequestedPageNum < 1)
            {
               this.mFrameRequest.mRequestedPageNum = 1;
            }
            this.mFrameRequest.num_of_items_per_frame = this.mNumOfPages * this.mNumOfItemsPerPage;
            if(this.mFrameRequest.num_of_items_per_frame > this.mListSize)
            {
               this.mFrameRequest.num_of_items_per_frame = this.mListSize;
            }
         }
         buffer.mStartPageNum = this.mFrameRequest.mRequestedPageNum;
         buffer.mEndPageNum = buffer.mStartPageNum + this.mNumOfPages - 1;
         buffer.mStartIndex = (buffer.mStartPageNum - 1) * this.mNumOfItemsPerPage;
         buffer.num_of_items_in_buffer = this.mFrameRequest.num_of_items_per_frame;
         buffer.num_of_empty_items_in_buffer = this.mFrameRequest.num_of_empty_items_per_frame;
         buffer.bOneBufferMode = true;
         var screenAction:int = this.setCurListPosition(this.mFrameRequest.mDesiredListPos);
         this.setLastResponseResultOK();
         return 0;
      }
      
      private function activateBufferA() : void
      {
         this.activeBuffer = this.mBuffer_A;
         if(this.bOneBuffer == false)
         {
            this.inActiveBufferPrev = this.mBuffer_B;
            this.inActiveBufferNext = this.mBuffer_C;
         }
         else
         {
            this.inActiveBufferNext = this.inActiveBufferPrev = null;
         }
      }
   }
}

