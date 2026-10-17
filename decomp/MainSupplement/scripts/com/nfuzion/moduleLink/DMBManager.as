package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.DMBAppEvent;
   import com.nfuzion.moduleLinkAPI.IDMBManager;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DMBManager extends Module implements IDMBManager
   {
      
      private static var instance:DMBManager;
      
      public static const TPEG_POI_TYPE_RESTAURANT_WEEK:int = 2;
      
      public static const TPEG_POI_TYPE_RESTAURANT_TV:int = 4;
      
      public static const TPEG_POI_TYPE_RESTAURANT_THEME:int = 8;
      
      public static const TPEG_POI_TYPE_TRAVEL_RECOMMEND:int = 16;
      
      public static const TPEG_POI_TYPE_TRAVEL_THEME:int = 32;
      
      public static const TPEG_POI_TYPE_TRAVEL_COLUMN:int = 64;
      
      private const dbusIdentifier:String = "dmbApp";
      
      private const cmd_dmbOn:String = "DMB_On";
      
      private const cmd_dmbOff:String = "DMB_Off";
      
      private const cmd_dmbSeek:String = "DMB_Seek";
      
      private const cmd_dmbTune:String = "DMB_Tune";
      
      private const cmd_dmbScan:String = "DMB_Scan";
      
      private const cmd_dmbStatus:String = "DMB_Status";
      
      private const cmd_dmbVersion:String = "DMB_Version";
      
      private const cmd_dmbUpdate:String = "DMB_Update";
      
      private const cmd_dmbDebug:String = "DMB_Debug";
      
      private const cmd_dmbInfo:String = "DMB_Info";
      
      private const cmd_dmbOperable:String = "DMB_OPERABLE";
      
      private const cmd_dmbCheckInit:String = "DMB_Check_Init";
      
      private const cmd_tpegStep:String = "Request_Tpeg_Stop";
      
      private const cmd_tpeg_get_cttsum:String = "TPEG_GetCttsum";
      
      private const cmd_tpeg_poi_getList:String = "TPEG_GetPoiList";
      
      private const cmd_tpeg_poi_getDetail:String = "TPEG_GetPoiDetail";
      
      private const cmd_tpeg_rtm_getList:String = "TPEG_GetRtmList";
      
      private var mDMBChannelLists:Array = new Array();
      
      private var mDMBPrevChannelLists:Array = new Array();
      
      private var mCTTSumPath:String = "";
      
      private var mTPEGPOICategoryLists:Array = new Array();
      
      private var mTPEGPOIAllCategoryLists:Array = new Array();
      
      private var mTPEGPOISelectedCategoryLists:Array = new Array();
      
      private var mTPEGPOIDetail:Object;
      
      private var mTPEGRTMLists:Array = new Array();
      
      private var mNextPrev:Boolean = false;
      
      private var mOnDmbScan:Boolean = false;
      
      private var mDMBOperable:Boolean = false;
      
      private var mPrevFrequency:int = 0;
      
      private var mPrevServiceIndex:int = 0;
      
      private var mPrevChannelName:String = "";
      
      private var mActiveChannelIndex:int = -1;
      
      private var mConnection:Connection;
      
      private var mClient:Client;
      
      public function DMBManager()
      {
         super();
         this.mConnection = Connection.share();
         this.mClient = this.mConnection.span;
         this.mClient.addEventListener(Event.CONNECT,this.connected);
         if(this.mClient.connected)
         {
            this.connected();
         }
         this.mClient.addEventListener(Event.CLOSE,this.disconnected);
         this.mConnection.addEventListener(ConnectionEvent.DMBAPP,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.mConnection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : DMBManager
      {
         if(instance == null)
         {
            instance = new DMBManager();
         }
         return instance;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.mConnection.configured) && Boolean(this.mClient.connected);
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.mConnection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.mClient.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function getDMBChannelLists() : Array
      {
         return this.mDMBChannelLists;
      }
      
      public function getPrevDMBFrequency() : int
      {
         return this.mPrevFrequency;
      }
      
      public function getPrevDMBServiceIndex() : int
      {
         return this.mPrevServiceIndex;
      }
      
      public function getPrevDMBChannelName() : String
      {
         return this.mPrevChannelName;
      }
      
      public function get ActiveChannelIndex() : int
      {
         return this.mActiveChannelIndex;
      }
      
      public function setPreDMBInfo(frequency:int, serviceIndex:int, channelName:String) : void
      {
         this.mPrevFrequency = frequency;
         this.mPrevServiceIndex = serviceIndex;
         this.mPrevChannelName = channelName;
      }
      
      public function setDMBChannelLists(channelArray:Array) : void
      {
         this.mDMBChannelLists.length = 0;
         for(var i:int = 0; i < channelArray.length; i++)
         {
            this.mDMBChannelLists.push(channelArray[i]);
         }
      }
      
      public function getDMBOperable() : Boolean
      {
         return this.mDMBOperable;
      }
      
      public function getDMBScan() : Boolean
      {
         return this.mOnDmbScan;
      }
      
      public function getCTTSumPath() : String
      {
         return this.mCTTSumPath;
      }
      
      public function getTPEGPOICategoryLists() : Array
      {
         return this.mTPEGPOICategoryLists;
      }
      
      public function getTPEGPOIAllCategoryLists() : Array
      {
         return this.mTPEGPOIAllCategoryLists;
      }
      
      public function getTPEGPOISelectedCategoryLists() : Array
      {
         return this.mTPEGPOISelectedCategoryLists;
      }
      
      public function getTPEGPOIDetail() : Object
      {
         return this.mTPEGPOIDetail;
      }
      
      public function getTPEGRTMLists() : Array
      {
         return this.mTPEGRTMLists;
      }
      
      public function dmbOperable() : void
      {
         var command:String = null;
         trace("dmbOperable");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbOperable + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbOn() : void
      {
         var command:String = null;
         trace("dmbOn");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbOn + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbOff() : void
      {
         var command:String = null;
         trace("dmbOff");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbOff + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbTune(selectIndex:int) : void
      {
         var frequency:int = 0;
         var serviceIndex:int = 0;
         var channelName:String = null;
         var command:String = null;
         if(selectIndex >= 0 && selectIndex < this.mDMBChannelLists.length)
         {
            frequency = int(this.mDMBChannelLists[selectIndex].frequency);
            serviceIndex = int(this.mDMBChannelLists[selectIndex].serviceIndex);
            channelName = this.mDMBChannelLists[selectIndex].channelName;
            this.mPrevFrequency = frequency;
            this.mPrevServiceIndex = serviceIndex;
            this.mPrevChannelName = channelName;
            command = "\"" + this.cmd_dmbTune + "\":{\"Freq\":" + frequency + ", \"SIndex\":" + serviceIndex + "}";
            trace("dmbTune selectIndex:" + selectIndex + " command:" + command);
            this.sendCommand(command);
         }
      }
      
      public function dmbPrevTune() : void
      {
         var command:String = null;
         var frequency:int = this.mPrevFrequency;
         var serviceIndex:int = this.mPrevServiceIndex;
         command = "\"" + this.cmd_dmbTune + "\":{\"Freq\":" + frequency + ", \"SIndex\":" + serviceIndex + "}";
         this.sendCommand(command);
      }
      
      public function dmbDefaultTune() : void
      {
         var command:String = null;
         var frequency:int = 181280;
         var serviceIndex:int = 2;
         command = "\"" + this.cmd_dmbTune + "\":{\"Freq\":" + frequency + ", \"SIndex\":" + serviceIndex + "}";
         this.sendCommand(command);
      }
      
      public function dmbScan(frequencyIndex:int) : void
      {
         var command:String = null;
         trace("dmbScan");
         command = "\"" + this.cmd_dmbScan + "\":{\"index\":" + frequencyIndex + "}";
         this.sendCommand(command);
      }
      
      public function dmbStatus() : void
      {
         var command:String = null;
         trace("dmbStatus");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbStatus + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbVersion() : void
      {
         var command:String = null;
         trace("dmbVersion");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbVersion + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbUpdate() : void
      {
         var command:String = null;
         trace("dmbUpdate");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbUpdate + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbDebug() : void
      {
         var command:String = null;
         trace("dmbDebug");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbDebug + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function dmbCheckInit() : void
      {
         var command:String = null;
         trace("dmbCheckInit");
         var enable:String = "true";
         command = "\"" + this.cmd_dmbCheckInit + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function prepareDmbScan() : void
      {
         this.backupChannelLists();
         this.resetChannelLists();
         this.setOnDMBScan(true);
      }
      
      public function setOnDMBScan(bOn:Boolean) : void
      {
         this.mOnDmbScan = bOn;
      }
      
      public function resetChannelLists() : void
      {
         this.mDMBChannelLists.length = 0;
      }
      
      public function backupChannelLists() : void
      {
         trace("<< backupChannelLists >>");
         this.mDMBPrevChannelLists.length = 0;
         for(var i:int = 0; i < this.mDMBChannelLists.length; i++)
         {
            trace(this.mDMBChannelLists[i].channelName);
            this.mDMBPrevChannelLists.push(this.mDMBChannelLists[i]);
         }
      }
      
      public function restoreChannelLists() : void
      {
         trace("<< restoreChannelLists >>");
         this.mDMBChannelLists.length = 0;
         for(var i:int = 0; i < this.mDMBPrevChannelLists.length; i++)
         {
            trace(this.mDMBPrevChannelLists[i].channelName);
            this.mDMBChannelLists.push(this.mDMBPrevChannelLists[i]);
         }
      }
      
      public function requestTpegStop() : void
      {
         var command:String = null;
         trace("requestTpegStop");
         var enable:String = "true";
         command = "\"" + this.cmd_tpegStep + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function requestCTTSumDetail(imageId:int) : void
      {
         var command:String = null;
         trace("<< requestCTTSumDetail >>");
         command = "\"" + this.cmd_tpeg_get_cttsum + "\":{\"MapId\":" + imageId + "}";
         this.sendCommand(command);
      }
      
      public function requestTPEGPOICategory() : void
      {
         var command:String = null;
         this.mTPEGPOICategoryLists[0] = "주간 맛집";
         this.mTPEGPOICategoryLists[1] = "TV 맛집";
         this.mTPEGPOICategoryLists[2] = "테마 맛집";
         this.mTPEGPOICategoryLists[3] = "추천 여행";
         this.mTPEGPOICategoryLists[4] = "테마 여행";
         this.mTPEGPOICategoryLists[5] = "컬럼 여행";
         trace("<< requestTPEGPOICategory >>");
         var enable:String = "true";
         command = "\"" + this.cmd_tpeg_poi_getList + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function requestTPEGPOIAllCategoryList() : void
      {
         this.mTPEGPOISelectedCategoryLists.length = 0;
         for(var i:int = 0; i < this.mTPEGPOIAllCategoryLists.length; i++)
         {
            this.mTPEGPOISelectedCategoryLists.push(this.mTPEGPOIAllCategoryLists[i]);
         }
         this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_POI_ALL_CATEGORY_LISTS));
      }
      
      public function requestTPEGPOISelectedCategoryList(index:int) : void
      {
         var iCategoryIndex:int = 0;
         switch(index)
         {
            case 0:
               iCategoryIndex = TPEG_POI_TYPE_RESTAURANT_WEEK;
               break;
            case 1:
               iCategoryIndex = TPEG_POI_TYPE_RESTAURANT_TV;
               break;
            case 2:
               iCategoryIndex = TPEG_POI_TYPE_RESTAURANT_THEME;
               break;
            case 3:
               iCategoryIndex = TPEG_POI_TYPE_TRAVEL_RECOMMEND;
               break;
            case 4:
               iCategoryIndex = TPEG_POI_TYPE_TRAVEL_THEME;
               break;
            case 5:
               iCategoryIndex = TPEG_POI_TYPE_TRAVEL_COLUMN;
         }
         this.mTPEGPOISelectedCategoryLists.length = 0;
         for(var i:int = 0; i < this.mTPEGPOIAllCategoryLists.length; i++)
         {
            if(this.mTPEGPOIAllCategoryLists[i].type == iCategoryIndex)
            {
               this.mTPEGPOISelectedCategoryLists.push(this.mTPEGPOIAllCategoryLists[i]);
            }
         }
         this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_POI_SELECTED_CATEGORY_LISTS));
      }
      
      public function requestTPEGPOIDetail(categoryIndex:int, selectIndex:int, bNextOrPrev:Boolean = false) : void
      {
         var command:String = null;
         this.mNextPrev = bNextOrPrev;
         var poiIndex:int = int(this.mTPEGPOISelectedCategoryLists[selectIndex].index);
         trace("requestTPEGPOIDetail poiIndex: " + poiIndex);
         command = "\"" + this.cmd_tpeg_poi_getDetail + "\":{\"PoiIndex\":" + poiIndex + "}";
         this.sendCommand(command);
      }
      
      public function requestRTMLists() : void
      {
         var command:String = null;
         var enable:String = "true";
         command = "\"" + this.cmd_tpeg_rtm_getList + "\":{\"enable\":\"" + enable + "\"}";
         this.sendCommand(command);
      }
      
      public function DMB_Seek(value:Number) : void
      {
         var message:String = null;
         var valueName:String = "direction";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + this.cmd_dmbSeek + "\": { \"" + valueName + "\": " + value + "}}}";
         this.mClient.send(message);
      }
      
      private function sendCommand(commandName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"dmbApp\", \"packet\": {" + commandName + "}}";
         this.mClient.send(message);
      }
      
      public function getProperty(property:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"dmbApp\", \"packet\": { \"JSON_GetProperties\":{\"inprop\":[\"" + property + "\"]}}}";
         this.mClient.send(message);
      }
      
      public function sendSubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"dmbApp\", \"Signal\":" + signal + "}";
         this.mClient.send(message);
      }
      
      public function sendUnsubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"dmbApp\", \"Signal\":" + signal + "}";
         this.mClient.send(message);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var iDMBTotalNumber:int = 0;
         var dmbObject:Object = null;
         var x:int = 0;
         var iTPEGPOINumber:int = 0;
         var tpegObject:Object = null;
         var poiType:int = 0;
         var poiTypeName:String = null;
         var poiName:String = null;
         var poiPhoneNr:String = null;
         var poiAddress:String = null;
         var poiDescription:String = null;
         var poiImagePath:String = null;
         var poiCenterLo:String = null;
         var poiCenterLa:String = null;
         var iTPEGRTMNumber:int = 0;
         var geoCoordinate:String = null;
         var geoLo:String = null;
         var geoLa:String = null;
         var centerLo:String = null;
         var centerLa:String = null;
         var rtmObject:Object = null;
         var resp:Object = e.data;
         var i:int = 0;
         if(resp.hasOwnProperty("JSON_GetProperties"))
         {
            if(resp.JSON_GetProperties.hasOwnProperty("outprop"))
            {
               if(resp.JSON_GetProperties.outprop != null)
               {
                  this.distribute_JSON_Prop(resp.JSON_GetProperties.outprop);
               }
            }
            return;
         }
         if(resp.hasOwnProperty("DMB_OPERABLE"))
         {
            this.mDMBOperable = Boolean(resp.DMB_OPERABLE);
            trace("response DMB_OPERABLE:" + this.mDMBOperable);
            this.dispatchEvent(new DMBAppEvent(DMBAppEvent.DMB_OPERABLE));
            return;
         }
         if(resp.hasOwnProperty("DMB_Scan"))
         {
            if(this.mOnDmbScan)
            {
               iDMBTotalNumber = int(resp.DMB_Scan.TotalIndex);
               trace("<<< response DMB_Scan : iDMBTotalNumber" + iDMBTotalNumber);
               for(i = 0; i < iDMBTotalNumber; i++)
               {
                  trace("channel Name:" + resp.DMB_Scan.ChannelName[i] + " Freq:" + resp.DMB_Scan.Freq[i] + " Sindex:" + resp.DMB_Scan.ServiceIndex[i]);
                  dmbObject = {
                     "frequency":resp.DMB_Scan.Freq[i],
                     "serviceIndex":resp.DMB_Scan.ServiceIndex[i],
                     "channelName":resp.DMB_Scan.ChannelName[i]
                  };
                  this.mDMBChannelLists.push(dmbObject);
               }
               this.dispatchEvent(new DMBAppEvent(DMBAppEvent.DMB_SCAN));
            }
         }
         if(resp.hasOwnProperty("DMB_Tune"))
         {
            trace("response DMB_Tune");
         }
         if(resp.hasOwnProperty("DMB_StartSeek"))
         {
            if(resp.DMB_StartSeek.startSeek)
            {
               this.dispatchEvent(new DMBAppEvent(DMBAppEvent.DMB_TUNE_ONGOING));
            }
         }
         if(resp.hasOwnProperty("DMB_CurrChannel"))
         {
            this.mActiveChannelIndex = -1;
            for(x = 0; x < this.mDMBChannelLists.length; x++)
            {
               if(resp.DMB_CurrChannel.Freq == this.mDMBChannelLists[x].frequency && resp.DMB_CurrChannel.SIndex == this.mDMBChannelLists[x].serviceIndex)
               {
                  this.mActiveChannelIndex = x;
               }
            }
         }
         if(resp.hasOwnProperty("DMB_VIDEOREADY"))
         {
            trace("response DMB_VIDEOREADY value = " + resp.DMB_VIDEOREADY);
            if(resp.DMB_VIDEOREADY)
            {
               this.dispatchEvent(new DMBAppEvent(DMBAppEvent.DMB_TUNE_FINISH));
            }
            return;
         }
         if(resp.hasOwnProperty("TPEG_GetCttsum"))
         {
            trace("response TPEG_GetCttsum");
            this.mCTTSumPath = resp.TPEG_GetCttsum.Path;
            trace("tpegPath: " + this.mCTTSumPath);
            this.dispatchEvent(new DMBAppEvent(DMBAppEvent.CTT_SUM_DETAIL));
         }
         if(resp.hasOwnProperty("TPEG_GetPoiList"))
         {
            trace("response TPEG_POI_GetList");
            this.mTPEGPOIAllCategoryLists.length = 0;
            iTPEGPOINumber = int(resp.TPEG_GetPoiList.TotalIndex);
            trace("iTPEGPOI Number : " + iTPEGPOINumber);
            for(i = 0; i < iTPEGPOINumber; i++)
            {
               tpegObject = {
                  "index":i,
                  "type":resp.TPEG_GetPoiList.Type[i],
                  "title":resp.TPEG_GetPoiList.Title[i],
                  "centerLo":resp.TPEG_GetPoiList.CenterLo[i],
                  "centerLa":resp.TPEG_GetPoiList.CenterLa[i]
               };
               this.mTPEGPOIAllCategoryLists.push(tpegObject);
            }
            this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_POI_CATEGORY));
         }
         if(resp.hasOwnProperty("TPEG_GetPoiDetail"))
         {
            trace("response TPEG_GetPoiDetail");
            trace("type:" + resp.TPEG_GetPoiDetail.Type);
            trace("name:" + resp.TPEG_GetPoiDetail.Name);
            trace("PhoneNr:" + resp.TPEG_GetPoiDetail.PhoneNr);
            trace("Address:" + resp.TPEG_GetPoiDetail.Address);
            trace("Description:" + resp.TPEG_GetPoiDetail.description);
            trace("ImagePath:" + resp.TPEG_GetPoiDetail.ImagePath);
            trace("CenterLo:" + resp.TPEG_GetPoiDetail.CenterLo);
            trace("CenterLa:" + resp.TPEG_GetPoiDetail.CenterLa);
            poiType = int(resp.TPEG_GetPoiDetail.Type);
            poiTypeName = "";
            poiName = resp.TPEG_GetPoiDetail.Name;
            poiPhoneNr = resp.TPEG_GetPoiDetail.PhoneNr;
            poiAddress = resp.TPEG_GetPoiDetail.Address;
            poiDescription = resp.TPEG_GetPoiDetail.description;
            poiImagePath = resp.TPEG_GetPoiDetail.ImagePath;
            poiCenterLo = resp.TPEG_GetPoiDetail.CenterLo;
            poiCenterLa = resp.TPEG_GetPoiDetail.CenterLa;
            switch(poiType)
            {
               case TPEG_POI_TYPE_RESTAURANT_WEEK:
                  poiTypeName = this.mTPEGPOICategoryLists[0];
                  break;
               case TPEG_POI_TYPE_RESTAURANT_TV:
                  poiTypeName = this.mTPEGPOICategoryLists[1];
                  break;
               case TPEG_POI_TYPE_RESTAURANT_THEME:
                  poiTypeName = this.mTPEGPOICategoryLists[2];
                  break;
               case TPEG_POI_TYPE_TRAVEL_RECOMMEND:
                  poiTypeName = this.mTPEGPOICategoryLists[3];
                  break;
               case TPEG_POI_TYPE_TRAVEL_THEME:
                  poiTypeName = this.mTPEGPOICategoryLists[4];
                  break;
               case TPEG_POI_TYPE_TRAVEL_COLUMN:
                  poiTypeName = this.mTPEGPOICategoryLists[5];
                  break;
               default:
                  poiTypeName = " ";
            }
            if(poiName == null)
            {
               poiName = " ";
            }
            if(poiPhoneNr == null)
            {
               poiPhoneNr = " ";
            }
            if(poiAddress == null)
            {
               poiAddress = " ";
            }
            if(poiDescription == null)
            {
               poiDescription = " ";
            }
            if(poiImagePath == null)
            {
               poiImagePath = " ";
            }
            this.mTPEGPOIDetail = {
               "Category":poiTypeName,
               "Name":poiName,
               "Phone":poiPhoneNr,
               "Address":poiAddress,
               "Description":poiDescription,
               "ImagePath":poiImagePath,
               "CenterLo":poiCenterLo,
               "CenterLa":poiCenterLa
            };
            if(this.mNextPrev)
            {
               this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_POI_DETAIL_NEXTPREV));
            }
            else
            {
               this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_POI_DETAIL));
            }
         }
         if(resp.hasOwnProperty("TPEG_GetRtmList"))
         {
            trace("response TPEG_GetRtmList");
            this.mTPEGRTMLists.length = 0;
            iTPEGRTMNumber = int(resp.TPEG_GetRtmList.TotalIndex);
            geoCoordinate = "";
            geoLo = "";
            geoLa = "";
            centerLo = "";
            centerLa = "";
            trace("iTPEGRTM Number : " + iTPEGRTMNumber);
            for(i = 0; i < iTPEGRTMNumber; i++)
            {
               centerLo = resp.TPEG_GetRtmList.CenterLo[i];
               centerLa = resp.TPEG_GetRtmList.CenterLa[i];
               geoLo = "+" + centerLo.substr(0,3) + "." + centerLo.substr(3,centerLo.length - 1);
               geoLa = "+" + centerLa.substr(0,2) + "." + centerLa.substr(2,centerLa.length - 1);
               geoCoordinate = geoLo + " " + geoLa;
               rtmObject = {
                  "index":i,
                  "title":resp.TPEG_GetRtmList.Title[i],
                  "type":resp.TPEG_GetRtmList.Type[i],
                  "cityType":resp.TPEG_GetRtmList.CityType[i],
                  "GEO":geoCoordinate,
                  "info":resp.TPEG_GetRtmList.Info[i]
               };
               this.mTPEGRTMLists.push(rtmObject);
            }
            this.dispatchEvent(new DMBAppEvent(DMBAppEvent.TPEG_RTM_LISTS));
         }
      }
      
      private function distribute_JSON_Prop(outprop:Object) : void
      {
         if(outprop.hasOwnProperty("DMB_OPERABLE"))
         {
            this.mDMBOperable = Boolean(outprop.DMB_OPERABLE);
            this.dispatchEvent(new DMBAppEvent(DMBAppEvent.DMB_OPERABLE));
            return;
         }
      }
   }
}

