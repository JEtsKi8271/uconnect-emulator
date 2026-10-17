package com.harman.moduleLinkAPI
{
   public class VicsFMMenuButton
   {
      
      public static const TOGGLECAPTION_TEXT:uint = 0;
      
      public static const TOGGLECAPTION_DIAG:uint = 1;
      
      public static const FM_TEXT:uint = 0;
      
      public static const FM_DIAG:uint = 1;
      
      public var PREV_PAGE_AVAILABLE:Boolean = false;
      
      public var NEXT_PAGE_AVAILABLE:Boolean = false;
      
      public var PROGRAM_KEY:uint = 0;
      
      public var TOGGLE_BUTTON_AVAILABLE:Boolean = false;
      
      public var TOGGLE_BUTTON_CAPTION:uint = 0;
      
      public var TOTAL_PAGE:uint = 0;
      
      public var CURRENT_PAGE:uint = 0;
      
      public function VicsFMMenuButton()
      {
         super();
      }
      
      public function copyVICSFMMenuButton(value:Object) : VicsFMMenuButton
      {
         this.PREV_PAGE_AVAILABLE = value.prevPageAvailable;
         this.NEXT_PAGE_AVAILABLE = value.nextPageAvailable;
         this.PROGRAM_KEY = value.programKey;
         this.TOGGLE_BUTTON_AVAILABLE = value.toggleButtonAvailable;
         this.TOGGLE_BUTTON_CAPTION = value.toggleButtonCaption;
         this.TOTAL_PAGE = value.totalPage;
         this.CURRENT_PAGE = value.currentPage;
         return this;
      }
   }
}

