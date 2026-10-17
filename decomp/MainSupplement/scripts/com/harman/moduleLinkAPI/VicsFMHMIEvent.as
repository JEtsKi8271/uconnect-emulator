package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VicsFMHMIEvent extends Event
   {
      
      public static const MENU_DATA:String = "EventMenuData";
      
      public static const MENU_BUTTON:String = "EventButton";
      
      public static const INTER_BUTTON:String = "EventInterButton";
      
      public static const DRAW_MENU_PROGRAM:String = "EventDrawMenuProgram";
      
      public static const DRAW_MENU_TOP_PAGE_TEXT:String = "EventDrawMenuTopPageText";
      
      public static const DRAW_MENU_TOP_PAGE_DIAG:String = "EventDrawMenuTopPageDiag";
      
      public static const DRAW_MENU_PREV_PAGE:String = "EventDrawMenuPrevPage";
      
      public static const DRAW_MENU_NEXT_PAGE:String = "EventDrawMenuNextPage";
      
      public static const DRAW_MENU_BACK:String = "EventDrawMenuBack";
      
      public static const DRAW_INTER_TOP_PAGE:String = "EventDrawInterTopPage";
      
      public static const DRAW_INTER_PREV_PAGE:String = "EventDrawInterPrevPage";
      
      public static const DRAW_INTER_NEXT_PAGE:String = "EventDrawInterNextPage";
      
      public static const FINISH_INTERRUPT:String = "EventFinishInterrupt";
      
      public static const EVENT_INTERRUPT:String = "EventEventInterrupt";
      
      public var mData:Object = null;
      
      public function VicsFMHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

