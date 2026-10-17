package com.harman.framework.BufferControl
{
   public class ListBuffer
   {
      
      public var mListItems:Array;
      
      public var mStartPageNum:int;
      
      public var mEndPageNum:int;
      
      public var mStartIndex:int;
      
      public var num_of_folders_in_buffer:int;
      
      public var num_of_items_in_buffer:int;
      
      public var num_of_empty_items_in_buffer:int;
      
      public var bBufferNoFill:Boolean;
      
      public var bOneBufferMode:Boolean;
      
      public function ListBuffer()
      {
         super();
         this.mListItems = new Array();
         this.mStartPageNum = -1;
         this.mEndPageNum = -1;
         this.mStartIndex = 0;
         this.num_of_folders_in_buffer = 0;
         this.num_of_items_in_buffer = 0;
         this.num_of_empty_items_in_buffer = 0;
         this.bBufferNoFill = false;
         this.bOneBufferMode = false;
      }
      
      public function reset() : void
      {
         if(this.mListItems != null)
         {
            this.mListItems.splice(0,this.mListItems.length);
         }
         if(this.mListItems == null)
         {
            this.mListItems = new Array();
         }
         this.mStartPageNum = BufferControlTypes.INVALID_PAGE_NUM;
         this.mEndPageNum = BufferControlTypes.INVALID_PAGE_NUM;
         this.num_of_items_in_buffer = 0;
         this.num_of_folders_in_buffer = 0;
         this.num_of_empty_items_in_buffer = 0;
         this.bBufferNoFill = false;
         this.bOneBufferMode = false;
      }
      
      public function getItem(index:int) : Object
      {
         var translatedIndex:int = index - this.mStartIndex;
         if(this.bBufferNoFill == false)
         {
            if(translatedIndex >= 0 && translatedIndex < this.mListItems.length)
            {
               return this.mListItems[this.bOneBufferMode ? index : translatedIndex];
            }
         }
         return null;
      }
      
      public function getTotalItems() : int
      {
         return this.num_of_items_in_buffer;
      }
      
      public function getTotalFolderItems() : int
      {
         return this.num_of_folders_in_buffer;
      }
      
      public function getEmptyLineItems() : int
      {
         return this.num_of_empty_items_in_buffer;
      }
      
      public function getStartIndex() : int
      {
         return this.mStartIndex;
      }
   }
}

