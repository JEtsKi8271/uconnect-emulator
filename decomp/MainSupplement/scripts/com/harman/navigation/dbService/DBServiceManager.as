package com.harman.navigation.dbService
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestination;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.StartupState;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import flash.utils.Dictionary;
   
   public class DBServiceManager
   {
      
      private var mParent:Navigation;
      
      private var databaseCount:Array;
      
      private var dataBaseLimit:Array;
      
      private var dbServiceState:int = 4;
      
      private var mHome:DBItem;
      
      private var mDestinationList:Vector.<DBItem>;
      
      private var mErrorList:Vector.<int>;
      
      private var mMethodcallDictionary:Dictionary;
      
      private var mServiceBusy:Boolean = false;
      
      public function DBServiceManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
         this.mMethodcallDictionary = new Dictionary(true);
      }
      
      public function init() : void
      {
         if(this.dbServiceState == StartupState.INIT)
         {
            this.dataBaseLimit = new Array();
            this.databaseCount = new Array();
            Framework.Trace("DBSERVICE MANAGER ADD SUBSCRIB EVENTS");
            this.mParent.sendServiceSubscribe(Navigation.dbusNavigationDBServiceIdentifier,DBControlType.DB_READY_SIGNAL);
            this.mParent.sendServiceSubscribe(Navigation.dbusNavigationDBServiceIdentifier,DBControlType.DB_CHANGED_SIGNAL);
         }
         if(this.dbServiceState != StartupState.FULLY_READY)
         {
            this.dbServiceState = StartupState.WAITING;
            this.evaluateDBService(true);
         }
      }
      
      public function dbServiceMessageHandler(e:ConnectionEvent) : void
      {
         var dbResp:Object = e.data;
         if(dbResp.hasOwnProperty(DBControlType.GET_PROPERTIES_METHOD))
         {
            this.responseGetProperties(dbResp[DBControlType.GET_PROPERTIES_METHOD]);
            return;
         }
         if(dbResp.hasOwnProperty(DBControlType.GET_ITEM_COUNT_METHOD))
         {
            this.responseGetItemCounts(dbResp[DBControlType.GET_ITEM_COUNT_METHOD]);
            return;
         }
         if(dbResp.hasOwnProperty(DBControlType.GET_ITEM_METHOD))
         {
            this.responseGetItems(dbResp[DBControlType.GET_ITEM_METHOD]);
            return;
         }
         if(dbResp.hasOwnProperty(DBControlType.DB_CHANGED_SIGNAL))
         {
            this.responseDBChanaged(dbResp[DBControlType.DB_CHANGED_SIGNAL]);
            return;
         }
         if(dbResp.hasOwnProperty(DBControlType.DB_READY_SIGNAL))
         {
            this.responseDBReady(dbResp[DBControlType.DB_READY_SIGNAL]);
            return;
         }
         var thisMethodcall:String = "";
         if(dbResp.hasOwnProperty(DBControlType.INSERT_ITEM_METHOD))
         {
            thisMethodcall = DBControlType.INSERT_ITEM_METHOD;
         }
         else if(dbResp.hasOwnProperty(DBControlType.UPDATE_ITEM_METHOD))
         {
            thisMethodcall = DBControlType.UPDATE_ITEM_METHOD;
         }
         else if(dbResp.hasOwnProperty(DBControlType.DELETE_ITEM_METHOD))
         {
            thisMethodcall = DBControlType.DELETE_ITEM_METHOD;
         }
         else if(dbResp.hasOwnProperty(DBControlType.DELETE_ALL_METHOD))
         {
            thisMethodcall = DBControlType.DELETE_ALL_METHOD;
         }
         else if(dbResp.hasOwnProperty(DBControlType.MOVE_ITEM_METHOD))
         {
            thisMethodcall = DBControlType.MOVE_ITEM_METHOD;
         }
         if(thisMethodcall != "")
         {
            this.methodCallResponse(thisMethodcall,dbResp[thisMethodcall]);
         }
      }
      
      private function clearList(type:String) : void
      {
         if(type == DBControlType.ALL_DBS || type == DBControlType.HOME_DATABASE)
         {
            this.mHome = null;
         }
         if(type == DBControlType.ALL_DBS || type == DBControlType.SAVED_DATABASE || type == DBControlType.RECENT_DATABASE)
         {
            if(this.mDestinationList != null)
            {
               this.mDestinationList.splice(0,this.mDestinationList.length);
            }
         }
      }
      
      public function deleteAll(type:String) : Boolean
      {
         if(this.isNavTypeValid(type) && this.isReady)
         {
            if(this.mMethodcallDictionary[DBControlType.DELETE_ALL_METHOD] == null)
            {
               if(this.databaseCount[type] > 0)
               {
                  this.databaseCount[type] = 0;
                  this.clearList(type);
                  this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.DELETE_ALL_METHOD,type));
               }
               return true;
            }
            this.setServiceBusy(true,DBControlType.DELETE_ALL_METHOD);
         }
         return false;
      }
      
      public function get isReady() : Boolean
      {
         return this.dbServiceState == StartupState.FULLY_READY;
      }
      
      private function get favoriteCounts() : int
      {
         return this.getCounts(DBControlType.SAVED_DATABASE);
      }
      
      private function get recentCounts() : int
      {
         return this.getCounts(DBControlType.RECENT_DATABASE);
      }
      
      private function get homeCount() : int
      {
         return this.getCounts(DBControlType.HOME_DATABASE);
      }
      
      public function getCounts(type:String) : int
      {
         if(this.isNavTypeValid(type) && (this.databaseCount != null && this.databaseCount[type] != null))
         {
            return this.databaseCount[type];
         }
         return -1;
      }
      
      public function getMaxLimit(type:String) : int
      {
         if(this.isNavTypeValid(type) && (this.dataBaseLimit != null && this.dataBaseLimit[type] != null))
         {
            return this.dataBaseLimit[type];
         }
         return -1;
      }
      
      private function isAddDestinationAllowed(type:String) : Boolean
      {
         if(!this.isNavTypeValid(type))
         {
            return false;
         }
         return this.getCounts(type) < this.dataBaseLimit[type] || type == DBControlType.RECENT_DATABASE;
      }
      
      public function moveDestination(type:String, item:FavoriteDestination, moveOperation:String) : Boolean
      {
         var newDBItem:DBItem = null;
         if(this.isReady && this.isNavTypeValid(type))
         {
            if(this.mMethodcallDictionary[DBControlType.MOVE_ITEM_METHOD] == null)
            {
               newDBItem = new DBItem(type,item);
               if(newDBItem.Valid && (moveOperation == DBControlType.DB_OPTYPE_MOVE_UP || moveOperation == DBControlType.DB_OPTYPE_MOVE_DOWN))
               {
                  return this.moveItem(newDBItem,moveOperation);
               }
               Framework.Trace("invalid item: possibly no secondary loc details");
            }
         }
         return false;
      }
      
      public function addDestination(type:String, item:FavoriteDestination) : Boolean
      {
         var newDBItem:DBItem = null;
         if(this.isReady && this.isAddDestinationAllowed(type))
         {
            newDBItem = new DBItem(type,item);
            if(newDBItem.Valid)
            {
               this.insertItem(newDBItem);
               return true;
            }
            Framework.Trace("invalid item: possibly no secondary loc details");
         }
         return false;
      }
      
      public function removeDestination(type:String, index:int) : Boolean
      {
         if(this.isReady && this.isNavTypeValid(type))
         {
            return this.deleteItem(type,index);
         }
         return false;
      }
      
      public function updateDestination(type:String, item:FavoriteDestination) : Boolean
      {
         var newDBItem:DBItem = null;
         if(!this.isReady || !this.isNavTypeValid(type))
         {
            return false;
         }
         if(this.mMethodcallDictionary[DBControlType.UPDATE_ITEM_METHOD] == null)
         {
            newDBItem = new DBItem(type,item);
            if(newDBItem.Valid)
            {
               this.updateItem(type,newDBItem);
               return true;
            }
         }
         return false;
      }
      
      public function requestItems(type:String, startId:int = 0, numberOfItems:int = -1, sortBy:String = "", order:String = "") : Boolean
      {
         if(this.mMethodcallDictionary[DBControlType.GET_ITEM_METHOD] != null)
         {
            Framework.Trace("RequestItems pending request? (" + this.mMethodcallDictionary[DBControlType.GET_ITEM_METHOD] + ")");
            this.setServiceBusy(true,DBControlType.GET_ITEM_METHOD);
            return false;
         }
         var totalItems:int = this.getCounts(type);
         if(startId < 0 || startId >= totalItems)
         {
            startId = 0;
         }
         if(numberOfItems <= 0)
         {
            numberOfItems = totalItems;
         }
         else if(totalItems < startId + numberOfItems)
         {
            numberOfItems = totalItems - startId;
         }
         if(totalItems > 0)
         {
            this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.GET_ITEM_METHOD,type,startId,numberOfItems));
         }
         return true;
      }
      
      public function getDestinationList() : Vector.<DBItem>
      {
         return this.mDestinationList;
      }
      
      public function getHome() : DBItem
      {
         return this.mHome;
      }
      
      public function get state() : int
      {
         return this.dbServiceState;
      }
      
      private function requestItemCounts(type:String = "") : Boolean
      {
         if(type == "")
         {
            type = DBControlType.ALL_DBS;
         }
         return this.getItemsCount(type);
      }
      
      private function getItemsCount(navTypeName:String) : Boolean
      {
         if(this.mMethodcallDictionary[DBControlType.GET_ITEM_COUNT_METHOD] == null)
         {
            if(this.isNavTypeValid(navTypeName) == true)
            {
               this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.GET_ITEM_COUNT_METHOD,navTypeName));
            }
            return true;
         }
         this.setServiceBusy(true,DBControlType.GET_ITEM_COUNT_METHOD);
         return false;
      }
      
      private function setServiceBusy(bBusy:Boolean, busyWithAction:String = "") : void
      {
         if(bBusy == false)
         {
            if(busyWithAction != "" && this.mMethodcallDictionary[busyWithAction] != null)
            {
               delete this.mMethodcallDictionary[busyWithAction];
            }
         }
         if(this.mServiceBusy != bBusy || this.mServiceBusy && this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY] != busyWithAction)
         {
            this.mServiceBusy = bBusy;
            if(this.mServiceBusy == false)
            {
               if(this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY] != null && busyWithAction == this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY])
               {
                  this.mParent.sendEvent(NavigationEvent.DB_SERVICE_NOT_BUSY);
                  delete this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY];
               }
            }
            else if(this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY] == null && busyWithAction != "")
            {
               this.mMethodcallDictionary[DBControlType.INTERNAL_SERVICE_BUSY] = busyWithAction;
            }
         }
      }
      
      private function requestDBProperties() : void
      {
         this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.GET_PROPERTIES_METHOD));
      }
      
      private function responseGetItems(resp:Object) : void
      {
         var listArray:Array = null;
         var lastRequest:String = null;
         if(this.mMethodcallDictionary[DBControlType.GET_ITEM_METHOD] != null)
         {
            Framework.Trace("responseGetItems: " + this.mMethodcallDictionary[DBControlType.GET_ITEM_METHOD]);
            if(resp.hasOwnProperty("result") && resp.hasOwnProperty("status") && resp["status"] == DBControlType.RESULT_SUCCESS)
            {
               if(resp["result"] != "")
               {
                  listArray = resp["result"];
               }
               lastRequest = this.mMethodcallDictionary[DBControlType.GET_ITEM_METHOD] as String;
               this.setServiceBusy(false,DBControlType.GET_ITEM_METHOD);
               if(listArray != null)
               {
                  if(lastRequest == DBControlType.SAVED_DATABASE || lastRequest == DBControlType.RECENT_DATABASE)
                  {
                     this.createDestionList(lastRequest,listArray);
                  }
                  else
                  {
                     this.saveHome(listArray[0]);
                  }
               }
            }
         }
      }
      
      private function updateItem(type:String, item:DBItem) : Boolean
      {
         var message:Object = this.dbServiceCmd(DBControlType.UPDATE_ITEM_METHOD,item);
         this.setServiceBusy(true,DBControlType.UPDATE_ITEM_METHOD);
         this.mParent.sendServiceCommandObject(message);
         return true;
      }
      
      private function moveItem(moveFavoriteItem:DBItem, moveAction:String) : Boolean
      {
         var message:Object = this.dbServiceCmd(DBControlType.MOVE_ITEM_METHOD,moveFavoriteItem,0,0,moveAction);
         this.mParent.sendServiceCommandObject(message);
         return true;
      }
      
      private function insertItem(newFavorite:DBItem) : Boolean
      {
         var message:Object = this.dbServiceCmd(DBControlType.INSERT_ITEM_METHOD,newFavorite);
         this.mParent.sendServiceCommandObject(message);
         return true;
      }
      
      private function deleteItem(type:String, index:int) : Boolean
      {
         if(type == DBControlType.HOME_DATABASE)
         {
            if(this.homeCount > 0)
            {
               this.clearList(type);
               this.deleteAll(DBControlType.HOME_DATABASE);
            }
            return true;
         }
         if(index != -1)
         {
            this.clearList(type);
            this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.DELETE_ITEM_METHOD,type,index));
            return true;
         }
         return false;
      }
      
      private function createDestionList(type:String, listArray:Array) : void
      {
         var i:Object = null;
         var item:DBItem = null;
         var j:* = undefined;
         if(this.mDestinationList == null)
         {
            this.mDestinationList = new Vector.<DBItem>();
         }
         else
         {
            this.mDestinationList.splice(0,this.mDestinationList.length);
         }
         for(i in listArray)
         {
            item = new DBItem(type);
            for(j in listArray[i])
            {
               if(item.hasOwnProperty(j))
               {
                  item[j] = listArray[i][j];
               }
            }
            if(item.Valid)
            {
               this.mDestinationList.push(item);
            }
            else
            {
               if(this.mErrorList == null)
               {
                  this.mErrorList = new Vector.<int>();
               }
               this.mErrorList.push(item.navUniqueId);
            }
         }
         Framework.Trace("createDestinationList done " + type + " length " + this.mDestinationList.length);
         if(this.mDestinationList.length != this.getCounts(type))
         {
            Framework.Trace("ERROR, SOMETHING IS WRONG HERE");
         }
         var eventType:String = type == DBControlType.SAVED_DATABASE ? NavigationEvent.DB_FAVORITE_LIST_READY : NavigationEvent.DB_RECENT_LIST_READY;
         if(this.mDestinationList.length > 0)
         {
            this.mParent.sendEvent(eventType);
         }
         this.errorHandler(type);
      }
      
      private function saveHome(item:Object) : void
      {
         var i:* = undefined;
         Framework.Trace("saveItem done");
         this.mHome = null;
         this.mHome = new DBItem(DBControlType.HOME_DATABASE);
         for(i in item)
         {
            if(this.mHome.hasOwnProperty(i))
            {
               this.mHome[i] = item[i];
            }
            else
            {
               Framework.Trace(i + " required in mHome");
            }
         }
         this.mHome.setEntryAsHome();
         this.evaluateDBService();
         if(this.mHome.Valid)
         {
            this.mParent.sendEvent(NavigationEvent.DB_HOME_READY);
         }
         else
         {
            Framework.Trace("Home is invalid so, delete it");
            this.deleteAll(DBControlType.HOME_DATABASE);
         }
      }
      
      private function methodCallResponse(thisMethodcall:String, resp:Object) : void
      {
         if(this.mMethodcallDictionary[thisMethodcall] != null)
         {
            if(resp != null)
            {
               if(resp.hasOwnProperty("status") && resp["status"] != DBControlType.RESULT_SUCCESS)
               {
                  Framework.Trace(thisMethodcall + " failed!!!!!");
                  if(resp.hasOwnProperty("result"))
                  {
                     Framework.Trace(" reason " + resp["result"]);
                  }
               }
               if(this.requestItemCounts(this.mMethodcallDictionary[thisMethodcall]))
               {
                  Framework.Trace("DB Change signal not here???");
               }
            }
            delete this.mMethodcallDictionary[thisMethodcall];
         }
      }
      
      private function responseDBChanaged(resp:Object) : void
      {
         var type:String = null;
         var optype:String = null;
         if(resp.hasOwnProperty(DBControlType.NAV_TYPE) && resp.hasOwnProperty(DBControlType.DB_OPERATION))
         {
            type = resp[DBControlType.NAV_TYPE];
            optype = resp[DBControlType.DB_OPERATION];
            if(this.isNavTypeValid(type))
            {
               Framework.Trace("DBService Manager: db type " + type + ", opType " + optype);
               if(optype != DBControlType.DB_OPTYPE_EDIT && !resp.hasOwnProperty("currCount"))
               {
                  Framework.Trace("DBService Manager: expecting count return! quit!!!!");
                  return;
               }
               type = this.modifyDatabaseCount(type,resp.hasOwnProperty("currCount") ? int(resp["currCount"]) : -1);
               this.setServiceBusy(false,DBControlType.getMethodFromDBOperation(optype));
               if(optype == DBControlType.DB_OPTYPE_DELETE || optype == DBControlType.DB_OPTYPE_DELETE_ALL)
               {
                  if(this.mErrorList != null && this.mErrorList.length > 0)
                  {
                     Framework.Trace("error handling is done");
                     this.mErrorList.splice(0,this.mErrorList.length);
                     return;
                  }
               }
               if(type == NavigationEvent.DB_HOME_CHANGED)
               {
                  if(this.homeCount == 1)
                  {
                     this.requestHomeItem();
                  }
               }
               this.mParent.sendEvent(type);
            }
         }
      }
      
      private function modifyDatabaseCount(type:String, count:int = -1) : String
      {
         if(this.isNavTypeValid(type))
         {
            if(count != -1)
            {
               this.databaseCount[type] = count;
            }
            if(type == DBControlType.SAVED_DATABASE)
            {
               type = NavigationEvent.DB_FAVORITE_CHANGED;
            }
            else if(type == DBControlType.HOME_DATABASE)
            {
               type = NavigationEvent.DB_HOME_CHANGED;
            }
            else
            {
               type = NavigationEvent.DB_RECENT_CHANGED;
            }
            return type;
         }
         return "";
      }
      
      private function responseDBReady(resp:Object) : void
      {
         this.evaluateDBService();
      }
      
      private function responseGetProperties(resp:Object) : void
      {
         var statusArray:Array = null;
         var i:int = 0;
         var maxCountArray:Array = null;
         var k:int = 0;
         var navType:String = null;
         if(resp.hasOwnProperty(DBControlType.PROP_DATABASE_STATUS))
         {
            statusArray = resp[DBControlType.PROP_DATABASE_STATUS];
            for(i = 0; i < statusArray.length; i++)
            {
               if(statusArray[i].database == DBControlType.NAV_DB)
               {
                  if(statusArray[i].available == true)
                  {
                     break;
                  }
                  return;
               }
            }
         }
         if(resp.hasOwnProperty(DBControlType.PROP_DATABASE_MAX_COUNT))
         {
            maxCountArray = resp[DBControlType.PROP_DATABASE_MAX_COUNT];
            for(k = 0; k < maxCountArray.length; k++)
            {
               if(maxCountArray[k].db == DBControlType.NAV_DB)
               {
                  navType = maxCountArray[k].navtype;
                  if(this.isNavTypeValid(navType))
                  {
                     this.dataBaseLimit[navType] = maxCountArray[k].count;
                  }
               }
            }
            this.evaluateDBService();
         }
      }
      
      private function responseGetItemCounts(resp:Object) : void
      {
         var requestedAction:String = null;
         var event:String = null;
         Framework.Trace("DBServiceManager responseGetItemCounts " + resp["status"]);
         if(this.mMethodcallDictionary[DBControlType.GET_ITEM_COUNT_METHOD] != null)
         {
            Framework.Trace(this.mMethodcallDictionary[DBControlType.GET_ITEM_COUNT_METHOD]);
            requestedAction = this.mMethodcallDictionary[DBControlType.GET_ITEM_COUNT_METHOD];
            this.setServiceBusy(false,DBControlType.GET_ITEM_COUNT_METHOD);
            if(resp.hasOwnProperty("status") && resp["status"] == DBControlType.RESULT_SUCCESS)
            {
               if(requestedAction == DBControlType.ALL_DBS)
               {
                  this.onInitialNavItemCounts(resp);
               }
               else
               {
                  event = this.modifyDatabaseCount(requestedAction,resp["count"]);
                  if(event != "")
                  {
                     this.mParent.sendEvent(event);
                  }
               }
            }
         }
      }
      
      private function onInitialNavItemCounts(result:Object) : void
      {
         var navType:String = null;
         var bInitOK:Boolean = false;
         Framework.Trace("onIntialNavItemCount received ");
         for(navType in result)
         {
            if(this.isNavTypeValid(navType) && result.hasOwnProperty(navType))
            {
               bInitOK = true;
               this.databaseCount[navType] = result[navType];
               Framework.Trace(navType + " ==> " + this.databaseCount[navType]);
            }
         }
         if(bInitOK)
         {
            this.evaluateDBService();
         }
      }
      
      private function evaluateDBService(bInit:Boolean = false) : void
      {
         if(this.dbServiceState == StartupState.FULLY_READY)
         {
            return;
         }
         Framework.Trace("-------------------------- evaluateDBService binit " + bInit + " state " + this.dbServiceState + "---------------------------");
         if(this.isDatabaseLimitReady() == false)
         {
            this.requestDBProperties();
            return;
         }
         if(this.favoriteCounts == -1 || this.homeCount == -1)
         {
            this.requestItemCounts();
            return;
         }
         var bServiceReady:Boolean = false;
         if(this.homeCount == 0 || this.mHome != null && this.mHome.Valid)
         {
            bServiceReady = true;
            if(this.dbServiceState != StartupState.FULLY_READY && bServiceReady)
            {
               this.dbServiceState = StartupState.FULLY_READY;
               Framework.Trace("-------------------------- evaluateDBService  ready  fav " + this.favoriteCounts + " home " + this.homeCount + " recent " + this.recentCounts + "================");
               this.mParent.sendEvent(NavigationEvent.DB_SERVICE_READY);
            }
            return;
         }
         this.requestHomeItem();
      }
      
      private function requestHomeItem() : Boolean
      {
         Framework.Trace("requestHomeItem");
         if(this.homeCount > 0)
         {
            if(this.mHome != null)
            {
               this.mHome = null;
            }
            return this.requestItems(DBControlType.HOME_DATABASE);
         }
         return false;
      }
      
      private function isDatabaseLimitReady() : Boolean
      {
         if(this.dataBaseLimit == null || this.dataBaseLimit[DBControlType.HOME_DATABASE] == null)
         {
            return false;
         }
         return true;
      }
      
      private function errorHandler(type:String) : void
      {
         if(this.isNavTypeValid(type) && this.mErrorList != null && this.mErrorList.length > 0)
         {
            this.mParent.sendServiceCommandObject(this.dbServiceCmd(DBControlType.DELETE_ITEM_METHOD,type,-1,this.mErrorList.length));
         }
      }
      
      private function isNavTypeValid(type:String) : Boolean
      {
         return type == DBControlType.HOME_DATABASE || type == DBControlType.SAVED_DATABASE || type == DBControlType.RECENT_DATABASE || type == DBControlType.ALL_DBS;
      }
      
      private function dbServiceCmd(commandType:String, typeName:Object = null, index:int = 0, count:int = 0, action:String = "") : Object
      {
         var bRecent:Boolean = false;
         var updateItem:DBItem = null;
         var insertItem:DBItem = null;
         var j:int = 0;
         var moveItem:DBItem = null;
         Framework.Trace("dbServiceCmd " + commandType);
         var command:Object = new Object();
         command.Type = "Command";
         command.Dest = Navigation.dbusNavigationDBServiceIdentifier;
         var param:Object = new Object();
         switch(commandType)
         {
            case DBControlType.GET_ITEM_METHOD:
               bRecent = typeName as String == DBControlType.RECENT_DATABASE;
               param.database = DBControlType.NAV_DB;
               param.navType = typeName as String;
               param.startId = index;
               param.count = count;
               this.mMethodcallDictionary[commandType] = typeName as String;
               if(bRecent == false)
               {
                  param.sortCriteria = DBControlType.FORMATTEDNAME;
                  param.sortOrder = DBControlType.ASCENDING;
               }
               else
               {
                  param.sortCriteria = DBControlType.SORTINDEX_COLUMN;
                  param.sortOrder = DBControlType.DESCENDING;
               }
               param.fieldList = new Array();
               param.fieldList = DBControlType.getFieldList(bRecent,bRecent);
               break;
            case DBControlType.GET_PROPERTIES_METHOD:
               if(typeName != null)
               {
                  param.properties = new Array(typeName as String);
               }
               else
               {
                  param.properties = new Array(DBControlType.PROP_DATABASE_STATUS,DBControlType.PROP_DATABASE_MAX_COUNT);
               }
               break;
            case DBControlType.GET_ITEM_COUNT_METHOD:
               param.database = DBControlType.NAV_DB;
               param.navType = typeName as String;
               this.mMethodcallDictionary[commandType] = typeName as String;
               break;
            case DBControlType.UPDATE_ITEM_METHOD:
               param.database = DBControlType.NAV_DB;
               updateItem = typeName as DBItem;
               param.navType = updateItem.type;
               this.mMethodcallDictionary[commandType] = updateItem.type;
               param.fieldsList = new Array(updateItem.getUpdateItem(false,updateItem.type == DBControlType.RECENT_DATABASE));
               break;
            case DBControlType.INSERT_ITEM_METHOD:
               insertItem = typeName as DBItem;
               param.database = DBControlType.NAV_DB;
               param.navType = insertItem.type;
               this.mMethodcallDictionary[commandType] = insertItem.type;
               param.insertList = new Array(insertItem.getInsertItem(insertItem.type == DBControlType.RECENT_DATABASE));
               break;
            case DBControlType.DELETE_ALL_METHOD:
               param.database = DBControlType.NAV_DB;
               param.navType = typeName as String;
               this.mMethodcallDictionary[commandType] = typeName as String;
               break;
            case DBControlType.DELETE_ITEM_METHOD:
               param.database = DBControlType.NAV_DB;
               param.navType = typeName as String;
               param.deleteList = new String("");
               if(count != 0 && (this.mErrorList != null && this.mErrorList.length > 0))
               {
                  for(j = 0; j < this.mErrorList.length - 1; j++)
                  {
                     param.deleteList += String(this.mErrorList[j]) + ",";
                  }
                  param.deleteList += String(this.mErrorList[this.mErrorList.length - 1]);
               }
               else
               {
                  param.deleteList = String(index);
               }
               this.mMethodcallDictionary[commandType] = typeName as String;
               break;
            case DBControlType.MOVE_ITEM_METHOD:
               moveItem = typeName as DBItem;
               param.database = DBControlType.NAV_DB;
               param.navType = moveItem.type;
               param.operationType = action;
               param.fieldsList = new Array(moveItem.getMoveItem());
               this.mMethodcallDictionary[commandType] = moveItem.type;
               break;
            default:
               return null;
         }
         command.packet = new Object();
         command.packet[commandType] = param;
         return command;
      }
   }
}

