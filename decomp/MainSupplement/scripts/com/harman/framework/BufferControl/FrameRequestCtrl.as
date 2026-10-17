package com.harman.framework.BufferControl
{
   public class FrameRequestCtrl
   {
      
      public var bRequestProcessing:Boolean = false;
      
      public var mBufferRequestType:int = 0;
      
      public var mPrevBufferRequestType:int = 3;
      
      public var mFrameRequestType:int = 10;
      
      public var mRequestedPageNum:int = -1;
      
      public var mSongStartPos:int = -1;
      
      public var num_of_items_per_frame:int = 0;
      
      public var num_of_folders_per_frame:int = 0;
      
      public var num_of_empty_items_per_frame:int = 0;
      
      public var mDesiredListPos:int = -1;
      
      public function FrameRequestCtrl()
      {
         super();
      }
      
      public function setFrameRequestControl(src:FrameRequestCtrl) : FrameRequestCtrl
      {
         if(this != src)
         {
            this.bRequestProcessing = src.bRequestProcessing;
            this.mBufferRequestType = src.mBufferRequestType;
            this.mPrevBufferRequestType = src.mPrevBufferRequestType;
            this.mFrameRequestType = src.mFrameRequestType;
            this.mRequestedPageNum = src.mRequestedPageNum;
            this.mSongStartPos = src.mSongStartPos;
            this.num_of_items_per_frame = src.num_of_items_per_frame;
            this.num_of_folders_per_frame = src.num_of_folders_per_frame;
            this.num_of_empty_items_per_frame = src.num_of_empty_items_per_frame;
            this.mDesiredListPos = src.mDesiredListPos;
         }
         return this;
      }
      
      public function reset() : void
      {
         this.bRequestProcessing = false;
         this.mBufferRequestType = BufferControlTypes.ACTIVE_BUFFER;
         this.mPrevBufferRequestType = BufferControlTypes.INVALID_BUFFER;
         this.mFrameRequestType = BufferControlTypes.LIST_FILL_BUFFER;
         this.mRequestedPageNum = BufferControlTypes.INVALID_PAGE_NUM;
         this.mSongStartPos = BufferControlTypes.INVALID_TRACK_NUM;
         this.num_of_items_per_frame = 0;
         this.num_of_folders_per_frame = 0;
         this.num_of_empty_items_per_frame = 0;
         this.mDesiredListPos = BufferControlTypes.INVALID_TRACK_NUM;
      }
      
      public function isFrameRequestCtrlEqual(src:FrameRequestCtrl) : Boolean
      {
         if(this != src)
         {
            if(this.bRequestProcessing == src.bRequestProcessing && this.mBufferRequestType == src.mBufferRequestType && this.mRequestedPageNum == src.mRequestedPageNum && this.mSongStartPos == src.mSongStartPos && this.mDesiredListPos == src.mDesiredListPos && this.num_of_folders_per_frame == src.num_of_folders_per_frame)
            {
               return true;
            }
         }
         return false;
      }
   }
}

