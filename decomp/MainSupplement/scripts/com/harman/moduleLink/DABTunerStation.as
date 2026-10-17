package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DABIndexIdHelper;
   import com.harman.moduleLinkAPI.DABPreset;
   import com.harman.moduleLinkAPI.DABRequestStatus;
   import com.harman.moduleLinkAPI.DABTunerStationInstance;
   import com.harman.moduleLinkAPI.IDABTunerStation;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DABTunerStation extends Module implements IDABTunerStation
   {
      
      private static var mInstance:DABTunerStation;
      
      private static const mDbusIdentifier:String = "DABTunerStation";
      
      private const InformationCurrentStation:String = "informationCurrentStation";
      
      private const InformationStationList:String = "informationStationList";
      
      private const InformationPresetList:String = "informationPresetList";
      
      private const InformationEnsembleList:String = "informationEnsembleList";
      
      private var mCode:int;
      
      private var mDescription:String;
      
      private var mHandle:String;
      
      private var mFeedback:int;
      
      private var mCurrentStation:DABTunerStationInstance;
      
      private var mStationList:Vector.<DABTunerStationInstance>;
      
      private var mPrimaryStationList:Vector.<DABTunerStationInstance>;
      
      private var mSecondaryStationList:Vector.<DABTunerStationInstance>;
      
      private var mEnsembleList:Vector.<DABTunerStationInstance>;
      
      private var mGenreList:Vector.<String>;
      
      private var mRequestStartTuneStatus:DABRequestStatus;
      
      private var mRequestControlSeekStatus:DABRequestStatus;
      
      private var mRequestForceUpdateStatus:DABRequestStatus;
      
      private var mStationlistSortType:String = "serviceName";
      
      private var mPresets:Array = new Array();
      
      private var m_Ready:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function DABTunerStation()
      {
         super();
         this.mCurrentStation = new DABTunerStationInstance();
         this.mStationList = new Vector.<DABTunerStationInstance>();
         this.mEnsembleList = new Vector.<DABTunerStationInstance>();
         this.mGenreList = new Vector.<String>();
         this.mRequestStartTuneStatus = null;
         this.mRequestControlSeekStatus = null;
         this.mRequestForceUpdateStatus = null;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.DAB_TUNER_STATION,this.MessageHandler);
      }
      
      public static function getInstance() : DABTunerStation
      {
         if(mInstance == null)
         {
            mInstance = new DABTunerStation();
         }
         return mInstance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe(this.InformationCurrentStation);
            this.sendSubscribe(this.InformationStationList);
            this.sendSubscribe(this.InformationPresetList);
            this.sendSubscribe(this.InformationEnsembleList);
            this.requestForceUpdate(DABIndexIdHelper.RFU_DAB_CURRENT_STATION);
            this.requestForceUpdate(DABIndexIdHelper.RFU_DAB_STATIONLIST);
            this.requestPresetList();
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      public function MessageHandler(e:ConnectionEvent) : void
      {
         var TunerStation:Object = e.data;
         if(TunerStation.hasOwnProperty(this.InformationCurrentStation))
         {
            this.processCurrentStation(TunerStation.informationCurrentStation);
         }
         if(TunerStation.hasOwnProperty(this.InformationStationList))
         {
            this.processStationList(TunerStation.informationStationList);
         }
         if(TunerStation.hasOwnProperty(this.InformationPresetList))
         {
            this.processPresetList(TunerStation.informationPresetList);
         }
         if(TunerStation.hasOwnProperty(this.InformationEnsembleList))
         {
            this.processEnsembleList(TunerStation.informationEnsembleList);
         }
      }
      
      private function processCurrentStation(infoCurrentStation:Object) : void
      {
         if(infoCurrentStation.hasOwnProperty("current"))
         {
            this.mCurrentStation = new DABTunerStationInstance(infoCurrentStation.current);
         }
         this.dispatchEvent(new DABEvent(DABEvent.DAB_INFO_CURRENT_STATION));
      }
      
      private function processStationList(stationList:Object) : void
      {
         var station:Object = null;
         this.mStationList = new Vector.<DABTunerStationInstance>();
         this.mPrimaryStationList = new Vector.<DABTunerStationInstance>();
         this.mSecondaryStationList = new Vector.<DABTunerStationInstance>();
         for each(station in stationList.StationList.stations)
         {
            if(station.stationType & DABIndexIdHelper.DAB_PRIMARY_COMP_MASK)
            {
               this.mPrimaryStationList.push(new DABTunerStationInstance(station));
            }
            else
            {
               this.mSecondaryStationList.push(new DABTunerStationInstance(station));
            }
            this.mStationList.push(new DABTunerStationInstance(station));
         }
         this.buildGenreList();
         this.sortListBy(this.mStationlistSortType);
         this.dispatchEvent(new DABEvent(DABEvent.DAB_INFO_STATION_LIST));
      }
      
      private function processPresetList(presets:Object) : void
      {
         var presetInfo:Object = null;
         var preset:DABPreset = null;
         if(presets != null && presets.hasOwnProperty("presetList"))
         {
            this.mPresets.length = 0;
            for each(presetInfo in presets.presetList)
            {
               preset = new DABPreset();
               preset.fill(presetInfo.presetID,presetInfo.name,presetInfo.genre,presetInfo.selected);
               this.mPresets.push(preset);
            }
            this.dispatchEvent(new DABEvent(DABEvent.DAB_PRESET_LIST));
         }
      }
      
      private function processEnsembleList(ensembles:Object) : void
      {
         var newEnsembleList:Array = null;
         var ensembleData:Object = null;
         this.mEnsembleList.length = 0;
         if(ensembles.hasOwnProperty("EnsembleList"))
         {
            if(ensembles.EnsembleList.hasOwnProperty("stations"))
            {
               newEnsembleList = ensembles.EnsembleList.stations;
               for each(ensembleData in newEnsembleList)
               {
                  this.mEnsembleList.push(new DABTunerStationInstance(ensembleData));
               }
            }
         }
         this.dispatchEvent(new DABEvent(DABEvent.ENSEMBLE_LIST));
      }
      
      public function get handle() : String
      {
         return this.mHandle;
      }
      
      public function get feedback() : int
      {
         return this.mFeedback;
      }
      
      public function get currentStation() : DABTunerStationInstance
      {
         return this.mCurrentStation;
      }
      
      public function get Presets() : Array
      {
         return this.mPresets;
      }
      
      public function get stationList() : Vector.<DABTunerStationInstance>
      {
         return this.mStationList;
      }
      
      public function get ensembleList() : Vector.<DABTunerStationInstance>
      {
         return this.mEnsembleList;
      }
      
      public function get genreList() : Vector.<String>
      {
         return this.mGenreList;
      }
      
      public function get startTuneStatus() : DABRequestStatus
      {
         return this.mRequestStartTuneStatus;
      }
      
      public function get controlSeekStatus() : DABRequestStatus
      {
         return this.mRequestControlSeekStatus;
      }
      
      public function get forceUpdateStatus() : DABRequestStatus
      {
         return this.mRequestForceUpdateStatus;
      }
      
      public function get stationListSortType() : String
      {
         return this.mStationlistSortType;
      }
      
      private function compareServiceNameAscending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL] < j.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL])
         {
            return -1;
         }
         if(i.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL] > j.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL])
         {
            return 1;
         }
         return 0;
      }
      
      private function comparePTYAscending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX] < j.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX])
         {
            return -1;
         }
         if(i.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX] > j.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX])
         {
            return 1;
         }
         return this.compareServiceNameAscending(i,j);
      }
      
      private function compareServiceNameDescending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL] > j.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL])
         {
            return -1;
         }
         if(i.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL] < j.names[DABIndexIdHelper.DAB_STATIONLIST_SERVICE_LBL])
         {
            return 1;
         }
         return 0;
      }
      
      private function comparePTYDescending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX] > j.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX])
         {
            return -1;
         }
         if(i.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX] < j.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX])
         {
            return 1;
         }
         return this.compareServiceNameDescending(i,j);
      }
      
      private function compareServiceIdAscending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.id[DABIndexIdHelper.DAB_SERVICE_ID] < j.id[DABIndexIdHelper.DAB_SERVICE_ID])
         {
            return -1;
         }
         if(i.id[DABIndexIdHelper.DAB_SERVICE_ID] > j.id[DABIndexIdHelper.DAB_SERVICE_ID])
         {
            return 1;
         }
         return this.compareComponentIdAscending(i,j);
      }
      
      private function compareComponentIdAscending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.id[DABIndexIdHelper.DAB_COMPONENT_ID] < j.id[DABIndexIdHelper.DAB_COMPONENT_ID])
         {
            return -1;
         }
         if(i.id[DABIndexIdHelper.DAB_COMPONENT_ID] > j.id[DABIndexIdHelper.DAB_COMPONENT_ID])
         {
            return 1;
         }
         return 0;
      }
      
      private function compareServiceIdDescending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.id[DABIndexIdHelper.DAB_SERVICE_ID] > j.id[DABIndexIdHelper.DAB_SERVICE_ID])
         {
            return -1;
         }
         if(i.id[DABIndexIdHelper.DAB_SERVICE_ID] < j.id[DABIndexIdHelper.DAB_SERVICE_ID])
         {
            return 1;
         }
         return this.compareComponentIdDescending(i,j);
      }
      
      private function compareComponentIdDescending(i:DABTunerStationInstance, j:DABTunerStationInstance) : Number
      {
         if(i.id[DABIndexIdHelper.DAB_COMPONENT_ID] > j.id[DABIndexIdHelper.DAB_COMPONENT_ID])
         {
            return -1;
         }
         if(i.id[DABIndexIdHelper.DAB_COMPONENT_ID] < j.id[DABIndexIdHelper.DAB_COMPONENT_ID])
         {
            return 1;
         }
         return 0;
      }
      
      private function sortListBy(sortType:String = "serviceName", direction:String = "ascending") : void
      {
         switch(sortType)
         {
            case "serviceName":
               if(direction == "ascending")
               {
                  this.mStationList = new Vector.<DABTunerStationInstance>();
                  this.mPrimaryStationList.sort(this.compareServiceNameAscending);
                  this.mSecondaryStationList.sort(this.compareServiceIdAscending);
                  this.buildPrimarySecondaryList();
               }
               else if(direction == "decending")
               {
                  this.mStationList = new Vector.<DABTunerStationInstance>();
                  this.mPrimaryStationList.sort(this.compareServiceNameDescending);
                  this.mSecondaryStationList.sort(this.compareServiceIdDescending);
                  this.buildPrimarySecondaryList();
               }
               break;
            case "pty":
               if(direction == "ascending")
               {
                  this.mStationList.sort(this.comparePTYAscending);
               }
               else if(direction == "decending")
               {
                  this.mStationList.sort(this.comparePTYDescending);
               }
         }
      }
      
      public function requestStartTune(freq:int, ensembleId:int, serviceId:int, componentId:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestStartTune\":{\"station\":{\"frequency\":" + freq + ",\"id\":[" + ensembleId + "," + serviceId + "," + componentId + "]}}}}";
         this.client.send(message);
      }
      
      public function requestControlSeek(seekMode:int, genre:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestControlSeek\":{\"seekMode\":" + seekMode + ",\"genre\":" + genre + "}}}";
         this.client.send(message);
      }
      
      public function requestForceUpdate(updateId:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + mDbusIdentifier + "\", \"packet\": { \"requestForceUpdate\":{\"updateId\":" + updateId + "}}}";
         this.client.send(message);
      }
      
      public function requestSortStationlist(type:String, direction:String = "ascending") : Vector.<DABTunerStationInstance>
      {
         if(this.mStationlistSortType != type)
         {
            this.sortListBy(type,direction);
            this.mStationlistSortType = type;
         }
         return this.mStationList;
      }
      
      public function storePreset(presetId:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestStorePreset":{"presetID":presetId}}
         };
         this.connection.send(message);
      }
      
      public function recallPreset(presetId:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestRecallPreset":{"presetID":presetId}}
         };
         this.connection.send(message);
      }
      
      public function clearPreset(presetId:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestClearPreset":{"presetID":presetId}}
         };
         this.connection.send(message);
      }
      
      public function clearAllPresets() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestClearAllPresets":{}}
         };
         this.connection.send(message);
      }
      
      public function seekPreset(directionCode:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestSeekPreset":{"direction":directionCode}}
         };
         this.connection.send(message);
      }
      
      public function requestPresetList() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"requestGetPresetList":{}}
         };
         this.connection.send(message);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function buildPrimarySecondaryList() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.mPrimaryStationList.length; i++)
         {
            this.mStationList.push(this.mPrimaryStationList[i]);
            for(j = 0; j < this.mSecondaryStationList.length; j++)
            {
               if(this.mPrimaryStationList[i].id[DABIndexIdHelper.DAB_SERVICE_ID] == this.mSecondaryStationList[j].id[DABIndexIdHelper.DAB_SERVICE_ID])
               {
                  this.mStationList.push(this.mSecondaryStationList[j]);
               }
            }
         }
      }
      
      private function buildGenreList() : void
      {
         var station:DABTunerStationInstance = null;
         var tempGenre:String = null;
         this.mGenreList.length = 0;
         for each(station in this.mStationList)
         {
            tempGenre = station.genres[DABIndexIdHelper.DAB_STATIC_PTY_IDX];
            if(this.mGenreList.indexOf(tempGenre) == -1)
            {
               this.mGenreList.push(tempGenre);
            }
         }
         this.mGenreList.sort(this.compareStrings);
      }
      
      private function compareStrings(s1:String, s2:String) : Number
      {
         return s1.localeCompare(s2);
      }
   }
}

