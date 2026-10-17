package com.harman.navigation.dbService
{
   public class DBControlType
   {
      
      public static const DB_RESULT_SUCCESS:int = 0;
      
      public static const DB_RESULT_ERROR:int = 1;
      
      public static const DB_RESULT_BUSY:int = 2;
      
      public static const DB_RESULT_TIMEOUT:int = 3;
      
      public static const DB_RESULT_SERVICE_NOT_ENABLED:int = 4;
      
      public static const DB_RESULT_STALE:int = 5;
      
      public static const DB_RESULT_INVALID_PARAMETER:int = 6;
      
      public static const DB_RESULT_PIM_SERVICE_OFF:int = 7;
      
      public static const DB_RESULT_PIM_INTERNAL_ERROR:int = 8;
      
      public static const DB_RESULT_INVALID_API:int = 9;
      
      public static const DB_RESULT_QDB_ERROR:int = 10;
      
      public static const DB_READY_SIGNAL:String = "databaseReady";
      
      public static const DB_CHANGED_SIGNAL:String = "databaseChanged";
      
      public static const ECO_FILE_CREATED_SIGNAL:String = "ecoFileCreated";
      
      public static const NAV_ITEM_COUNT_SIGNAL:String = "navItemsCount";
      
      public static const GET_ITEM_METHOD:String = "getItems";
      
      public static const GET_PROPERTIES_METHOD:String = "getProperties";
      
      public static const GET_ITEM_COUNT_METHOD:String = "getItemsCount";
      
      public static const GET_ALPHAJUMP_TABLE_METHOD:String = "getAlphaJumpTable";
      
      public static const INSERT_ITEM_METHOD:String = "insertItems";
      
      public static const UPDATE_ITEM_METHOD:String = "updateItems";
      
      public static const DELETE_ITEM_METHOD:String = "deleteItems";
      
      public static const DELETE_ALL_METHOD:String = "deleteAllItems";
      
      public static const MOVE_ITEM_METHOD:String = "moveItem";
      
      public static const DB_OP_TYPE:String = "operationType";
      
      public static const DB_OPERATION:String = "dbOperation";
      
      public static const DB_OPTYPE_EDIT:String = "edit";
      
      public static const DB_OPTYPE_UPDATE:String = "update";
      
      public static const DB_OPTYPE_DELETE:String = "delete";
      
      public static const DB_OPTYPE_DELETE_ALL:String = "deleteAll";
      
      public static const DB_OPTYPE_INSERT:String = "insert";
      
      public static const NAV_TYPE:String = "navType";
      
      public static const RESULT_SUCCESS:String = "success";
      
      public static const NAV_DB:String = "nav";
      
      public static const ALL_DBS:String = "all";
      
      public static const SAVED_DATABASE:String = "stored";
      
      public static const RECENT_DATABASE:String = "recent";
      
      public static const HOME_DATABASE:String = "home";
      
      public static const PROP_DATABASE_STATUS:String = "databaseStatus";
      
      public static const PROP_DATABASE_MAX_COUNT:String = "maxCount";
      
      public static const DB_OPTYPE_MOVE_UP:String = "up";
      
      public static const DB_OPTYPE_MOVE_DOWN:String = "down";
      
      public static const ASCENDING:String = "ascending";
      
      public static const DESCENDING:String = "descending";
      
      public static const GIVENNAME:String = "givenName";
      
      public static const FORMATTEDNAME:String = "formattedName";
      
      public static const NAV_UNIQUE_ID:String = "navUniqueId";
      
      public static const DATA:String = "data";
      
      public static const PINNED_COLUMN:String = "pinned";
      
      public static const SORTINDEX_COLUMN:String = "sortIndex";
      
      public static const INTERNAL_SERVICE_BUSY:String = "serviceBusy";
      
      public function DBControlType()
      {
         super();
      }
      
      public static function getFieldList(bNeedSortIndex:Boolean = false, bNeedPin:Boolean = false) : Array
      {
         var temp:Array = new Array(NAV_UNIQUE_ID,FORMATTEDNAME,"lat","lon",DATA);
         if(bNeedSortIndex)
         {
            temp.push(SORTINDEX_COLUMN);
         }
         if(bNeedPin)
         {
            temp.push(PINNED_COLUMN);
         }
         return temp;
      }
      
      public static function getMethodFromDBOperation(optype:String) : String
      {
         switch(optype)
         {
            case DB_OPTYPE_DELETE:
               return DELETE_ITEM_METHOD;
            case DB_OPTYPE_DELETE_ALL:
               return DELETE_ALL_METHOD;
            case DB_OPTYPE_EDIT:
               return MOVE_ITEM_METHOD;
            case DB_OPTYPE_UPDATE:
               return UPDATE_ITEM_METHOD;
            case DB_OPTYPE_INSERT:
               return INSERT_ITEM_METHOD;
            default:
               return "";
         }
      }
   }
}

