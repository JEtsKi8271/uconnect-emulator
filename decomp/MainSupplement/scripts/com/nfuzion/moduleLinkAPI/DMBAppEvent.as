package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DMBAppEvent extends Event
   {
      
      public static const DMB_OPERABLE:String = "DMB_OPERABLE";
      
      public static const DMB_SCAN:String = "DMB_SCAN";
      
      public static const DMB_TUNE_FINISH:String = "DMB_TUNE_FINISH";
      
      public static const CTT_SUM_DETAIL:String = "CTT_SUM_DETAIL";
      
      public static const TPEG_POI_CATEGORY:String = "TPEG_POI_CATEGORY";
      
      public static const TPEG_POI_ALL_CATEGORY_LISTS:String = "TPEG_POI_ALL_CATEGORY_LISTS";
      
      public static const TPEG_POI_SELECTED_CATEGORY_LISTS:String = "TPEG_POI_SELECTED_CATEGORY_LISTS";
      
      public static const TPEG_POI_DETAIL:String = "TPEG_POI_DETAIL";
      
      public static const TPEG_POI_DETAIL_NEXTPREV:String = "TPEG_POI_DETAIL_NEXTPREV";
      
      public static const TPEG_RTM_LISTS:String = "TPEG_RTM_LISTS";
      
      public static const DMB_INIT_FINISH:String = "DMB_INIT_FINISH";
      
      public static const DMB_CHANNEL_LIST:String = "DMB_CHANNEL_LISTS";
      
      public static const DMB_TUNE_ONGOING:String = "DMB_TUNE_ONGOING";
      
      public static const DMB_SCAN_ONGOING:String = "DMB_SCAN_ONGOING";
      
      public static const DMB_SCAN_FINISH:String = "DMB_SCAN_FINISH";
      
      public static const DMB_INFO_CURRENT_CHANNEL:String = "DMB_INFO_CURRENT_CHANNEL";
      
      public static const DMB_NO_SIGNAL:String = "DMB_NO_SIGNAL";
      
      public static const TPEG_POI_CATEGORY_LIST:String = "TPEG_POI_CATEGORY_LISTS";
      
      public static const TPEG_ACTIVE_MENU:String = "TPEG_ActiveMenu";
      
      public static const TPEG_SET_LIST:String = "TPEG_Set_List";
      
      public static const TPEG_INPUT_PATH:String = "TPEG_Input_Path";
      
      public static const TPEG_SET_BUSY:String = "TPEG_Set_Busy";
      
      public static const TPEG_RTM_LIST_UPDATE:String = "TPEG_RTM_LIST_UPDATE";
      
      private var mData:Object;
      
      public function DMBAppEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
   }
}

