package com.harman.framework.BufferControl
{
   public class BufferControlTypes
   {
      
      public static const DEFAULT_BUFFERED_PAGES:int = 13;
      
      public static const MAX_BUFFERED_PAGES:int = 33;
      
      public static const MIN_BUFFERED_PAGES:int = 3;
      
      public static const INVALID_PAGE_NUM:int = -1;
      
      public static const INVALID_TRACK_NUM:int = -1;
      
      public static const ITEM_POS_OFFSET:int = 1;
      
      public static const MAX_ENTIRES_PER_PAGE:int = 10;
      
      public static const PAGE_MODE:int = 0;
      
      public static const BUFFER_MODE:int = 1;
      
      public static const ACTIVE_BUFFER:int = 0;
      
      public static const INACTIVE_PREV_BUFFER:int = 1;
      
      public static const INACTIVE_NEXT_BUFFER:int = 2;
      
      public static const INVALID_BUFFER:int = 3;
      
      public static const NO_UPDATE:int = 0;
      
      public static const TRACK_UPDATE:int = 1;
      
      public static const LIST_UPDATE:int = 2;
      
      public static const ITEM_UPDATE:int = 3;
      
      public static const SCREEN_JUMP:int = 0;
      
      public static const SCREEN_MOVE_UP:int = 1;
      
      public static const SCREEN_MOVE_DOWN:int = 2;
      
      public static const LIST_NEW_TRACK:int = 0;
      
      public static const LIST_REFRESH:int = 1;
      
      public static const LIST_REFRESH_IGNORE_PAGE:int = 2;
      
      public static const LIST_SKIP_BACKWARDS:int = 3;
      
      public static const LIST_SKIP_FORWARDS:int = 4;
      
      public static const LIST_START:int = 5;
      
      public static const LIST_END:int = 6;
      
      public static const LIST_FIRST_PAGE:int = 7;
      
      public static const LIST_LAST_PAGE:int = 8;
      
      public static const LIST_GOTO_PAGE:int = 9;
      
      public static const LIST_FILL_BUFFER:int = 10;
      
      public static const LIST_FILL_ONE_BUFFER:int = 11;
      
      public static const LIST_FILL_INACTIVE_BUFFER:int = 12;
      
      public static const INVALID_REQUEST:int = 13;
      
      public static const RESULT_OK:int = 0;
      
      public static const RESULT_NOT_OK:int = 1;
      
      public static const RESULT_DOESNOT_MATCH:int = 2;
      
      public static const RESULT_REVISE_SIZE:int = 3;
      
      public function BufferControlTypes()
      {
         super();
      }
   }
}

