package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AhaContent;
   import com.harman.moduleLinkAPI.AhaEvent;
   import com.harman.moduleLinkAPI.AhaState;
   import com.harman.moduleLinkAPI.AhaStation;
   import com.harman.moduleLinkAPI.IAha;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Aha extends Module implements IAha
   {
      
      private static const dbusIdentifier:String = "AhaConnect";
      
      private static const dBusServiceAvailable:String = "dBusServiceAvailable";
      
      private static const dBusApiStartPeerSession:String = "startPeerSession";
      
      private static const dBusApiGetCurrentStationContentSelectionState:String = "getCurrentStationContentSelectionState";
      
      private static const dBusApiGetStations:String = "getStations";
      
      private static const dBusApiGetStationParameters:String = "getStationParameters";
      
      private static const dBusApiGetContentParameters:String = "getContentParameters";
      
      private static const dBusApiGetStationContent:String = "getStationContent";
      
      private static const dBusApiGetStationImage:String = "getStationImage";
      
      private static const dBusApiGetContentImage:String = "getContentImage";
      
      private static const dBusApiGetCurrentContentInfo:String = "getCurrentContentInfo";
      
      private static const dBusApiGetContentProviderImage:String = "getContentProviderImage";
      
      private static const dBusApiGetRatingImage:String = "getRatingImage";
      
      private static const dBusApiGetLikeImage:String = "getLikeImage";
      
      private static const dBusApiGetDislikeImage:String = "getDislikeImage";
      
      private static const dBusApiTimeShift:String = "timeShift";
      
      private static const dBusApiSelectStationForPlayback:String = "selectStationForPlayback";
      
      private static const dBusApiSelectContentForPlayback:String = "selectContentForPlayback";
      
      private static const dBusApiLike:String = "like";
      
      private static const dBusApiDislike:String = "dislike";
      
      private static const dBusApiChangeClientPlaybackStateToPlay:String = "changeClientPlaybackStateToPlay";
      
      private static const dBusApiChangeClientPlaybackStateToPause:String = "changeClientPlaybackStateToPause";
      
      private static const dBusApiAddStation:String = "addStation";
      
      private static const dBusApiRemoveStation:String = "removeStation";
      
      private static const dBusApiGetStationRequest:String = "getStationRequest";
      
      private static const dBusApiGetImage:String = "getImage";
      
      private static const dBusApiCall:String = "call";
      
      private static const dBusApiNavigate:String = "navigate";
      
      private static const dBusSignalStationContentSelectionState:String = "StationContentSelectionState";
      
      private static const dBusSignalPlaybackOfNewStation:String = "PlaybackOfNewStation";
      
      private static const dBusSignalNewContentPlaybackState:String = "NewContentPlaybackState";
      
      private static const dBusSignalNewContentAvailable:String = "NewContentAvailable";
      
      private static const dBusSignalContentDeleted:String = "ContentDeleted";
      
      private static const dBusSignalPlaybackProgress:String = "PlaybackProgress";
      
      private static const dBusSignalContentImage:String = "ContentImage";
      
      private static const dBusSignalClientStatusUpdate:String = "ClientStatusUpdate";
      
      private static const DEFAULT_IMAGE_STATION:String = "../../../img/default-album-art.png";
      
      private static const DEFAULT_IMAGE_CONTENT:String = "../../../img/default-album-art.png";
      
      private static const DEFAULT_IMAGE_PROVIDER:String = "";
      
      private static const DEFAULT_IMAGE_RATING:String = "";
      
      private static const DEFAULT_IMAGE_LIKE:String = "../../../img/like.png";
      
      private static const DEFAULT_IMAGE_DISLIKE:String = "../../../img/dislike.png";
      
      public static const sTYPE_PRESETS:uint = 1;
      
      public static const sTYPE_NEARBY:uint = 2;
      
      public static const sTYPE_FEATURED:uint = 4;
      
      public static const sTYPE_ADDSTATION:uint = 8;
      
      public static const sCATEGORY_ROOT:String = "home";
      
      private static const SEEK_PREV:int = 0;
      
      private static const SEEK_SMART_BACK:int = 1;
      
      private static const SEEK_NEXT:int = 2;
      
      private static const MAX_ITEMS_TO_RETURN:int = 20;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mServiceAvailable:Boolean;
      
      private var mCurrentStationID:int = -1;
      
      private var mCurrentContentID:int = -1;
      
      private var mCurrentStationProperties:AhaStation = new AhaStation(-1,{});
      
      private var mCurrentContentProperties:AhaContent = new AhaContent(-1,{});
      
      private var mPresetList:Array = [];
      
      private var mFeaturedList:Array = [];
      
      private var mNearbyList:Array = [];
      
      private var mStationList:Array = [];
      
      private var mContentList:Array = [];
      
      private var mStationRequests:Array = [];
      
      private var mImageRequests:Array = [];
      
      private var mAppState:int = -2;
      
      private var mLoadingState:int = 0;
      
      private var mPlayDuration:int = 0;
      
      private var mPlayTime:int = 0;
      
      private var mPlaybackState:int = 0;
      
      private var mLastRequestedID:String = "";
      
      private var mLastRequestedPG:int = 0;
      
      private var mLastRequestedMSG:String = "";
      
      private var mImagePathForStation:String = "../../../img/default-album-art.png";
      
      private var mImagePathForContent:String = "../../../img/default-album-art.png";
      
      private var mImagePathForProvider:String = "";
      
      private var mImagePathForRating:String = "";
      
      private var mImagePathForLike:String = "../../../img/like.png";
      
      private var mImagePathForDislike:String = "../../../img/dislike.png";
      
      private var mAddStationRequest:Vector.<String> = new Vector.<String>();
      
      public function Aha()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected(null);
         }
         this.connection.addEventListener(ConnectionEvent.AHA,this.messageHandler);
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function addInterest(signalName:String) : void
      {
      }
      
      override public function removeInterest(signalName:String) : void
      {
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.sendAvailableRequest();
            this.sendMultiSubscribe([dBusSignalPlaybackOfNewStation,dBusSignalNewContentPlaybackState,dBusSignalNewContentAvailable,dBusSignalContentDeleted,dBusSignalPlaybackProgress,dBusSignalContentImage,dBusSignalClientStatusUpdate]);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var deletedIDs:Array = null;
         var id:int = 0;
         var prop:String = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty(dBusServiceAvailable))
         {
            if(resp.dBusServiceAvailable == "true" && this.mServiceAvailable == false)
            {
               this.mServiceAvailable = true;
               if(this.mAppState == AhaState.SERVICE_CRASHED)
               {
                  this.init();
               }
            }
            else if(resp.dBusServiceAvailable == "false" && this.mServiceAvailable == true)
            {
               this.mPresetList.length = 0;
               this.mServiceAvailable = false;
               this.appState = AhaState.SERVICE_CRASHED;
            }
         }
         else if(resp.hasOwnProperty(dBusSignalPlaybackOfNewStation))
         {
            if(resp.PlaybackOfNewStation.playbackState == 0)
            {
               this.mCurrentStationID = -1;
               this.mContentList = [];
               this.loadingState = AhaState.LS_STATION_DEACTIVATED;
            }
            else if(this.mCurrentStationID != resp.PlaybackOfNewStation.stationID)
            {
               this.mCurrentStationID = resp.PlaybackOfNewStation.stationID;
               this.mCurrentContentID = -1;
               this.mContentList = [];
               this.mImagePathForStation = DEFAULT_IMAGE_STATION;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_STATION_AVAILABLE));
               this.mImagePathForContent = DEFAULT_IMAGE_CONTENT;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_CONTENT_AVAILABLE));
               this.mImagePathForProvider = DEFAULT_IMAGE_PROVIDER;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_PROVIDER_AVAILABLE));
               this.mImagePathForRating = DEFAULT_IMAGE_RATING;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_RATING_AVAILABLE));
               this.mImagePathForLike = DEFAULT_IMAGE_LIKE;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_LIKE_AVAILABLE));
               this.mImagePathForDislike = DEFAULT_IMAGE_DISLIKE;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_DISLIKE_AVAILABLE));
               this.getStationParameters(this.mCurrentStationID);
            }
         }
         else if(resp.hasOwnProperty(dBusSignalNewContentPlaybackState))
         {
            if(resp.NewContentPlaybackState.playbackState == AhaState.PLAYBACK_STOPPED || resp.NewContentPlaybackState.playbackState == AhaState.PLAYBACK_PAUSED)
            {
               this.playbackState = AhaState.PLAYBACK_PAUSED;
            }
            else if(resp.NewContentPlaybackState.playbackState == AhaState.PLAYBACK_BUFFERING || resp.NewContentPlaybackState.playbackState == AhaState.PLAYBACK_PLAYING)
            {
               this.playbackState = AhaState.PLAYBACK_PLAYING;
               if(this.mCurrentContentID != resp.NewContentPlaybackState.contentID)
               {
                  this.mCurrentContentID = resp.NewContentPlaybackState.contentID;
                  this.getContentParameters(resp.NewContentPlaybackState.contentID);
               }
            }
         }
         else if(resp.hasOwnProperty(dBusSignalStationContentSelectionState))
         {
            if(resp.playbackState.playbackState == AhaState.PLAYBACK_STOPPED || resp.playbackState.playbackState == AhaState.PLAYBACK_PAUSED)
            {
               this.playbackState = AhaState.PLAYBACK_PAUSED;
            }
            else if(resp.playbackState.playbackState == AhaState.PLAYBACK_BUFFERING || resp.playbackState.playbackState == AhaState.PLAYBACK_PLAYING)
            {
               this.playbackState = AhaState.PLAYBACK_PLAYING;
               if(this.mCurrentContentID != resp.playbackState.contentID)
               {
                  this.mCurrentContentID = resp.playbackState.contentID;
                  this.getContentParameters(resp.playbackState.contentID);
               }
               if(this.mCurrentStationID != resp.playbackState.stationID)
               {
                  this.mCurrentStationID = resp.playbackState.stationID;
                  this.getStationParameters(resp.playbackState.stationID);
               }
               if(this.mPlayTime != resp.playbackState.timeMarker)
               {
                  this.mPlayTime = resp.playbackState.timeMarker;
               }
            }
         }
         else if(resp.hasOwnProperty(dBusSignalNewContentAvailable))
         {
            if(this.mCurrentStationID == resp.NewContentAvailable.stationID)
            {
               this.getStationContent(this.mCurrentStationID);
            }
         }
         else if(resp.hasOwnProperty(dBusSignalContentDeleted))
         {
            if(this.mCurrentStationID == resp.ContentDeleted.stationID)
            {
               deletedIDs = resp.ContentDeleted.contentIds;
               while(deletedIDs.length > 0)
               {
                  id = this.checkArrayForPropertyValue(this.mContentList,"contentID",deletedIDs.pop());
                  if(id != -1)
                  {
                     this.mContentList.splice(id,1);
                  }
               }
               this.dispatchEvent(new AhaEvent(AhaEvent.CONTENT_LIST_CHANGE));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalPlaybackProgress))
         {
            if(resp.PlaybackProgress.contentID == this.mCurrentContentID)
            {
               this.mPlayTime = resp.PlaybackProgress.currentElapsedTime;
               this.mPlayDuration = resp.PlaybackProgress.totalContentLength;
               this.dispatchEvent(new AhaEvent(AhaEvent.PLAYBACK_PROGRESS));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalContentImage))
         {
            if(resp.ContentImage.contentID == this.mCurrentContentID)
            {
               this.mImagePathForContent = "file://" + resp.ContentImage.imagePath;
               this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_CONTENT_AVAILABLE));
            }
         }
         else if(resp.hasOwnProperty(dBusSignalClientStatusUpdate))
         {
            if(resp.ClientStatusUpdate.statusCode != this.mAppState)
            {
               this.appState = resp.ClientStatusUpdate.statusCode;
            }
         }
         else if(resp.hasOwnProperty(dBusApiStartPeerSession))
         {
            this.rsp_startPeerSession(resp[dBusApiStartPeerSession]);
         }
         else if(resp.hasOwnProperty(dBusApiGetStations))
         {
            if(this.checkForErrorCodes(dBusApiGetStations,resp[dBusApiGetStations]))
            {
               this.mStationRequests.shift();
            }
            else
            {
               this.rsp_getStations(resp[dBusApiGetStations]);
            }
         }
         else if(resp.hasOwnProperty(dBusApiGetStationRequest))
         {
            if(!this.checkForErrorCodes(dBusApiGetStationRequest,resp[dBusApiGetStationRequest]))
            {
               if(this.mAddStationRequest.length > 0)
               {
                  if(this.mAddStationRequest[0] == this.mAddStationRequest[this.mAddStationRequest.length - 1])
                  {
                     this.rsp_getStationRequest(resp[dBusApiGetStationRequest]);
                  }
                  this.mAddStationRequest.shift();
               }
               else
               {
                  this.rsp_getStationRequest(resp[dBusApiGetStationRequest]);
               }
            }
            else
            {
               this.client.send(this.mLastRequestedMSG);
            }
         }
         else if(resp.hasOwnProperty("fatal"))
         {
            if(resp.msg.indexOf(dBusApiGetStationRequest))
            {
               this.client.send(this.mLastRequestedMSG);
            }
            else if(resp.msg.indexOf(dBusApiGetImage))
            {
               this.rsp_getImage(resp);
            }
         }
         else
         {
            for(prop in resp)
            {
               if(!this.checkForErrorCodes(prop,resp[prop]))
               {
                  try
                  {
                     this["rsp_" + prop](resp[prop]);
                  }
                  catch(e:Error)
                  {
                     trace("[ ERROR ] *<HMIModule> Aha.messageHandler \'" + prop + "\' not recognized!");
                  }
               }
            }
         }
      }
      
      public function init() : void
      {
         if(this.mAppState != AhaState.RUNNING)
         {
            this.startPeerSession();
         }
         else if(this.mLoadingState != AhaState.LS_COMPLETE)
         {
            this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
         }
      }
      
      public function get TYPE_PRESETS() : uint
      {
         return sTYPE_PRESETS;
      }
      
      public function get TYPE_NEARBY() : uint
      {
         return sTYPE_NEARBY;
      }
      
      public function get TYPE_FEATURED() : uint
      {
         return sTYPE_FEATURED;
      }
      
      public function get TYPE_ADDSTATION() : uint
      {
         return sTYPE_ADDSTATION;
      }
      
      public function get CATEGORY_ROOT() : String
      {
         return sCATEGORY_ROOT;
      }
      
      public function set appState(_state:int) : void
      {
         if(_state == this.mAppState)
         {
            return;
         }
         switch(_state)
         {
            case AhaState.RUNNING:
               this.mAppState = _state;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
               this.loadingState = AhaState.LS_LOADING;
               break;
            case AhaState.CONNECTING:
            case AhaState.ERROR_CONNECTING:
            case AhaState.NOT_RUNNING:
            case AhaState.SERVER_CONNECTION_LOST:
            case AhaState.SERVER_DOWN_FOR_MAINTENANCE:
            case AhaState.NOT_LOGGED_IN:
            case AhaState.LOGIN_FAILED:
            case AhaState.PHONE_CONNECTION_LOST:
            case AhaState.PHONE_NOT_CONNECTED:
            case AhaState.SERVICE_CRASHED:
               this.mAppState = _state;
               this.clearPreset();
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
         }
         for(var count:int = 0; count < this.mAddStationRequest.length; count++)
         {
            this.mAddStationRequest.pop();
         }
      }
      
      public function get appState() : int
      {
         return this.mAppState;
      }
      
      public function set loadingState(_state:int) : void
      {
         if(_state == this.mLoadingState)
         {
            return;
         }
         switch(_state)
         {
            case AhaState.LS_CHANGING_STATION:
               this.mCurrentStationID = -1;
               this.mCurrentContentID = -1;
               this.mPlayTime = 0;
               this.mPlayDuration = 0;
               this.mLoadingState = AhaState.LS_CHANGING_STATION;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
               break;
            case AhaState.LS_CHANGING_CONTENT:
               this.mCurrentContentID = -1;
               this.mPlayTime = 0;
               this.mPlayDuration = 0;
               this.mLoadingState = AhaState.LS_CHANGING_CONTENT;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
               break;
            case AhaState.LS_STATION_DEACTIVATED:
               this.mLoadingState = _state;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
               break;
            case AhaState.LS_NO_CONNECTION:
               this.mLoadingState = _state;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
               break;
            case AhaState.LS_LOADING:
            case AhaState.LS_LOADING_PRESETS:
            case AhaState.LS_NO_ACTIVE_STATION:
               if(this.mPresetList.length == 0)
               {
                  this.mLoadingState = AhaState.LS_LOADING_PRESETS;
                  this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
                  this.getCurrentStationContentSelectionState();
                  this.getStations(this.TYPE_PRESETS);
                  break;
               }
               if(this.mCurrentStationID == -1)
               {
                  this.mLoadingState = AhaState.LS_NO_ACTIVE_STATION;
                  this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
                  break;
               }
            case AhaState.LS_COMPLETE:
               this.mLoadingState = AhaState.LS_COMPLETE;
               this.dispatchEvent(new AhaEvent(AhaEvent.APP_STATE));
         }
      }
      
      public function get loadingState() : int
      {
         return this.mLoadingState;
      }
      
      private function clearPreset() : void
      {
         this.mPresetList.length = 0;
      }
      
      public function set playbackState(_state:int) : void
      {
         if(_state == this.mPlaybackState)
         {
            return;
         }
         switch(_state)
         {
            case AhaState.PLAYBACK_STOPPED:
            case AhaState.PLAYBACK_PAUSED:
            case AhaState.PLAYBACK_BUFFERING:
            case AhaState.PLAYBACK_PLAYING:
               this.mPlaybackState = _state;
               this.dispatchEvent(new AhaEvent(AhaEvent.PLAYBACK_STATE));
         }
      }
      
      public function get playbackState() : int
      {
         return this.mPlaybackState;
      }
      
      public function get currentStation() : AhaStation
      {
         return this.mCurrentStationProperties;
      }
      
      public function get currentContent() : AhaContent
      {
         return this.mCurrentContentProperties;
      }
      
      public function get imagePathForStation() : String
      {
         return this.mImagePathForStation;
      }
      
      public function get imagePathForContent() : String
      {
         return this.mImagePathForContent;
      }
      
      public function get imagePathForProvider() : String
      {
         return this.mImagePathForProvider;
      }
      
      public function get imagePathForRating() : String
      {
         return this.mImagePathForRating;
      }
      
      public function get imagePathForLike() : String
      {
         return this.mImagePathForLike;
      }
      
      public function get imagePathForDislike() : String
      {
         return this.mImagePathForDislike;
      }
      
      public function get contentList() : Array
      {
         return this.mContentList;
      }
      
      public function get presetList() : Array
      {
         return this.mPresetList;
      }
      
      public function get featuredList() : Array
      {
         return this.mFeaturedList;
      }
      
      public function get nearbyList() : Array
      {
         return this.mNearbyList;
      }
      
      public function get stationList() : Array
      {
         return this.mStationList;
      }
      
      public function get lastRequest() : String
      {
         return this.mLastRequestedID;
      }
      
      public function get playDuration() : int
      {
         return this.mPlayDuration;
      }
      
      public function get playTime() : int
      {
         return this.mPlayTime;
      }
      
      public function set playTime(seconds:int) : void
      {
         this.timeShift(seconds - this.mPlayTime);
         this.mPlayTime = seconds;
      }
      
      public function get stationID() : int
      {
         return this.mCurrentStationID;
      }
      
      public function set stationID(stationID:int) : void
      {
         if(this.mCurrentStationID != stationID)
         {
            this.selectStationForPlayback(stationID);
         }
      }
      
      public function get contentID() : int
      {
         return this.mCurrentContentID;
      }
      
      public function set contentID(contentID:int) : void
      {
         this.selectContentForPlayback(contentID);
      }
      
      public function like() : void
      {
         this.performLikeAction(this.mCurrentContentID);
      }
      
      public function dislike() : void
      {
         this.performDislikeAction(this.mCurrentContentID);
      }
      
      public function play() : void
      {
         this.sendCommand(dBusApiChangeClientPlaybackStateToPlay);
      }
      
      public function pause() : void
      {
         this.sendCommand(dBusApiChangeClientPlaybackStateToPause);
      }
      
      public function seekNext() : void
      {
         this.selectContentForPlayback(SEEK_NEXT);
      }
      
      public function seekPrev() : void
      {
         this.selectContentForPlayback(SEEK_PREV);
      }
      
      private function startPeerSession() : void
      {
         var message:String = null;
         this.appState = AhaState.CONNECTING;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", " + "\"packet\": { \"" + dBusApiStartPeerSession + "\": { " + "\"sessionFlags\":0" + "}}}";
         this.client.send(message);
      }
      
      private function rsp_startPeerSession(resp:Object) : void
      {
         if(resp.hasOwnProperty("status"))
         {
            this.appState = AhaState.ERROR_CONNECTING;
         }
         else if(resp.hasOwnProperty("code"))
         {
            this.appState = resp.code;
         }
         else
         {
            this.appState = AhaState.RUNNING;
         }
         if(this.mAppState == AhaState.RUNNING)
         {
            trace("*<HMIModule> Aha.messageHandler \'rsp_" + dBusApiStartPeerSession + "\' \n" + "\'appVersion\' : " + resp.session.appVersion + "\n" + "\'deviceModel\' : " + resp.session.deviceModel + "\n" + "\'deviceSWVersion\' : " + resp.session.deviceSWVersion);
         }
      }
      
      private function getCurrentStationContentSelectionState() : void
      {
         this.sendCommand(dBusApiGetCurrentStationContentSelectionState);
      }
      
      private function rsp_getCurrentStationContentSelectionState(resp:Object) : void
      {
         this.mCurrentStationID = resp.StationContentSelectionState.stationId;
         this.getStationParameters(this.mCurrentStationID);
         this.mCurrentContentID = resp.StationContentSelectionState.contentId;
         this.getContentParameters(this.mCurrentContentID);
         this.playbackState = resp.StationContentSelectionState.playbackState;
      }
      
      public function requestStations(type:uint) : void
      {
         switch(type)
         {
            case this.TYPE_PRESETS:
            case this.TYPE_NEARBY:
            case this.TYPE_FEATURED:
               this.getStations(type);
         }
      }
      
      private function getStations(type:uint, start:uint = 0, length:uint = 0) : void
      {
         var message:String = null;
         this.mStationRequests.push(type);
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dBusApiGetStations + "\": { \"" + "stationType" + "\": " + type + "}}}";
         this.client.send(message);
      }
      
      private function rsp_getStations(resp:Object) : void
      {
         switch(this.mStationRequests.shift())
         {
            case this.TYPE_PRESETS:
               this.mPresetList = resp.stations;
               this.loadingState = AhaState.LS_LOADING;
               this.dispatchEvent(new AhaEvent(AhaEvent.PRESET_LIST_CHANGE));
               break;
            case this.TYPE_FEATURED:
               this.mFeaturedList = resp.stations;
               this.dispatchEvent(new AhaEvent(AhaEvent.FEATURED_LIST_CHANGE));
               break;
            case this.TYPE_NEARBY:
               this.mNearbyList = resp.stations;
               this.dispatchEvent(new AhaEvent(AhaEvent.NEARBY_LIST_CHANGE));
         }
      }
      
      public function requestStationsByID(categoryID:String) : void
      {
         var message:String = null;
         var _pageNumber:int = 0;
         var _retNearByStations:int = 0;
         var _includeStations:int = 2;
         var _filterByLocation:int = 0;
         var _radius:int = 0;
         var _langFilter:String = "en";
         if(this.mLastRequestedID != categoryID)
         {
            this.mLastRequestedPG = 0;
         }
         else
         {
            ++this.mLastRequestedPG;
            _pageNumber = this.mLastRequestedPG;
         }
         this.mLastRequestedID = categoryID;
         this.mAddStationRequest.push(categoryID);
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", " + "\"packet\": { \"" + dBusApiGetStationRequest + "\": { " + "\"pageSize\":" + MAX_ITEMS_TO_RETURN + "," + "\"pageNumber\":" + _pageNumber + "," + "\"categoryID\":\"" + categoryID + "\"," + "\"retNearByStations\":" + _retNearByStations + "," + "\"includeStations\":" + _includeStations + "," + "\"filterByLocation\":" + _filterByLocation + "," + "\"radius\":" + _radius + "," + "\"langFilter\":\"" + _langFilter + "\"" + " }}}";
         this.client.send(message);
         this.mLastRequestedMSG = message;
      }
      
      private function rsp_getStationRequest(resp:Object) : void
      {
         var item:Object = null;
         if(resp.hasOwnProperty("CategoryInformation"))
         {
            this.mStationList = resp.CategoryInformation;
         }
         else if(resp.hasOwnProperty("StationInformation"))
         {
            if(this.mLastRequestedPG)
            {
               for each(item in resp.StationInformation)
               {
                  this.mStationList.push(item);
               }
            }
            else
            {
               this.mStationList = resp.StationInformation;
            }
            if(resp.StationInformation.length == 20)
            {
               this.requestStationsByID(this.mLastRequestedID);
            }
         }
         this.dispatchEvent(new AhaEvent(AhaEvent.STATION_LIST_CHANGE));
      }
      
      private function getStationParameters(stationID:int) : void
      {
         this.sendCommand(dBusApiGetStationParameters,"stationID",stationID);
      }
      
      private function rsp_getStationParameters(resp:Object) : void
      {
         this.loadingState = AhaState.LS_LOADING;
         this.mCurrentStationProperties = new AhaStation(resp.stationID,resp);
         this.dispatchEvent(new AhaEvent(AhaEvent.STATION_CHANGE));
         this.getStationImage(this.mCurrentStationID);
         this.getStationContent(this.mCurrentStationID);
      }
      
      private function getContentParameters(contentID:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", " + "\"packet\": { \"" + dBusApiGetContentParameters + "\": { " + "\"contentID\":" + contentID + "," + "\"paramFlag\":0" + " }}}";
         this.client.send(message);
      }
      
      private function rsp_getContentParameters(resp:Object) : void
      {
         this.loadingState = AhaState.LS_LOADING;
         this.mCurrentContentProperties = new AhaContent(resp.contentID,resp);
         this.getCurrentContentInfo();
         this.mImagePathForContent = this.checkImagePath(this.mCurrentContentProperties.IMAGE);
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_CONTENT_AVAILABLE));
         this.getContentProviderImage();
         if(this.mCurrentStationProperties.IS_NEARBY)
         {
            this.getRatingImage();
         }
         if(this.mCurrentStationProperties.HAS_LIKE)
         {
            this.getLikeImage();
            this.getDislikeImage();
         }
         this.dispatchEvent(new AhaEvent(AhaEvent.CONTENT_CHANGE));
      }
      
      private function getCurrentContentInfo() : void
      {
         this.sendCommand(dBusApiGetCurrentContentInfo,"contentID",this.contentID);
      }
      
      private function rsp_getCurrentContentInfo(resp:Object) : void
      {
         this.mCurrentContentProperties.lines = resp;
         this.dispatchEvent(new AhaEvent(AhaEvent.CONTENT_CHANGE));
      }
      
      private function getStationContent(stationID:int) : void
      {
         this.sendCommand(dBusApiGetStationContent,"stationID",stationID);
      }
      
      private function rsp_getStationContent(resp:Object) : void
      {
         this.mContentList = resp.contents;
         this.dispatchEvent(new AhaEvent(AhaEvent.CONTENT_LIST_CHANGE));
      }
      
      private function getStationImage(stationID:int) : void
      {
         this.sendCommand(dBusApiGetStationImage,"stationID",stationID);
      }
      
      private function rsp_getStationImage(resp:Object) : void
      {
         this.mImagePathForStation = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_STATION);
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_STATION_AVAILABLE));
      }
      
      private function getContentImage(contentID:int) : void
      {
         this.sendCommand(dBusApiGetContentImage,"contentID",contentID);
      }
      
      private function rsp_getContentImage(resp:Object) : void
      {
         this.mImagePathForContent = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_CONTENT);
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_CONTENT_AVAILABLE));
      }
      
      private function getContentProviderImage() : void
      {
         this.sendCommand(dBusApiGetContentProviderImage,"contentID",this.contentID);
      }
      
      private function rsp_getContentProviderImage(resp:Object) : void
      {
         this.mImagePathForProvider = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_PROVIDER);
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_PROVIDER_AVAILABLE));
      }
      
      private function getRatingImage() : void
      {
         this.sendCommand(dBusApiGetRatingImage,"contentID",this.contentID);
      }
      
      private function rsp_getRatingImage(resp:Object) : void
      {
         this.mImagePathForRating = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_RATING);
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_RATING_AVAILABLE));
      }
      
      private function getLikeImage() : void
      {
         this.sendCommand(dBusApiGetLikeImage,"contentID",this.contentID);
      }
      
      private function rsp_getLikeImage(resp:Object) : void
      {
         if(resp.hasOwnProperty("imagePath"))
         {
            this.mImagePathForLike = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_LIKE);
         }
         else
         {
            this.mImagePathForLike = DEFAULT_IMAGE_LIKE;
         }
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_LIKE_AVAILABLE));
      }
      
      private function getDislikeImage() : void
      {
         this.sendCommand(dBusApiGetDislikeImage,"contentID",this.contentID);
      }
      
      private function rsp_getDislikeImage(resp:Object) : void
      {
         if(resp.hasOwnProperty("imagePath"))
         {
            this.mImagePathForDislike = this.checkImagePath(resp.imagePath,DEFAULT_IMAGE_DISLIKE);
         }
         else
         {
            this.mImagePathForDislike = DEFAULT_IMAGE_DISLIKE;
         }
         this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_DISLIKE_AVAILABLE));
      }
      
      private function timeShift(seconds:int) : void
      {
         if(seconds != 0)
         {
            this.sendCommand(dBusApiTimeShift,"seconds",seconds);
         }
      }
      
      private function rsp_timeShift(resp:Object) : void
      {
      }
      
      private function selectStationForPlayback(stationID:int) : void
      {
         this.loadingState = AhaState.LS_CHANGING_STATION;
         this.sendCommand(dBusApiSelectStationForPlayback,"stationID",stationID);
      }
      
      private function rsp_selectStationForPlayback(resp:Object) : void
      {
      }
      
      private function selectContentForPlayback(contentID:int) : void
      {
         this.loadingState = AhaState.LS_CHANGING_CONTENT;
         this.sendCommand(dBusApiSelectContentForPlayback,"contentID",contentID);
      }
      
      private function rsp_selectContentForPlayback(resp:Object) : void
      {
      }
      
      private function performLikeAction(contentID:int) : void
      {
         this.mCurrentContentProperties.liked = true;
         this.mCurrentContentProperties.disliked = false;
         this.dispatchEvent(new AhaEvent(AhaEvent.LIKED));
         this.sendCommand(dBusApiLike,"contentID",contentID);
      }
      
      private function rsp_like(resp:Object) : void
      {
      }
      
      private function performDislikeAction(contentID:int) : void
      {
         this.mCurrentContentProperties.liked = false;
         this.mCurrentContentProperties.disliked = true;
         this.dispatchEvent(new AhaEvent(AhaEvent.LIKED));
         this.sendCommand(dBusApiDislike,"contentID",contentID);
      }
      
      private function rsp_dislike(resp:Object) : void
      {
      }
      
      public function addStation(stationID:String) : void
      {
         this.sendCommand(dBusApiAddStation,"stationID",stationID);
      }
      
      private function rsp_addStation(resp:Object) : void
      {
         this.getStations(this.TYPE_PRESETS);
      }
      
      public function removeStation(stationID:String) : void
      {
         this.sendCommand(dBusApiRemoveStation,"stationID",stationID);
      }
      
      private function rsp_removeStation(resp:Object) : void
      {
         this.getStations(this.TYPE_PRESETS);
      }
      
      public function getImage(url:String) : void
      {
         if(url == "" || this.checkArrayForPropertyValue(this.mImageRequests,"",url) != -1)
         {
            return;
         }
         this.mImageRequests.push(url);
         if(this.mImageRequests.length > 5)
         {
            this.mImageRequests.splice(1,1);
         }
         if(this.mImageRequests.length == 1)
         {
            this.sendCommand(dBusApiGetImage,"url",url);
         }
      }
      
      private function rsp_getImage(resp:Object) : void
      {
         var _url:String = null;
         var _tmp:String = null;
         if(resp.hasOwnProperty("imagePath"))
         {
            _url = this.mImageRequests.shift();
            _tmp = this.checkImagePath(resp.imagePath);
            this.dispatchEvent(new AhaEvent(AhaEvent.IMAGE_AVAILABLE,{
               "request":_url,
               "path":_tmp
            }));
         }
         else
         {
            this.mImageRequests.shift();
         }
         if(this.mImageRequests.length != 0)
         {
            this.sendCommand(dBusApiGetImage,"url",this.mImageRequests[0]);
         }
      }
      
      public function call(contentID:int) : void
      {
         this.sendCommand(dBusApiCall,"contentID",contentID);
      }
      
      private function rsp_call(resp:Object) : void
      {
      }
      
      public function navigate(contentID:int) : void
      {
         this.sendCommand(dBusApiNavigate,"contentID",contentID);
      }
      
      private function rsp_navigate(resp:Object) : void
      {
      }
      
      protected function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String = null, value:* = null) : void
      {
         var message:String = null;
         if(value is String)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\":{ \"" + valueName + "\":\"" + value + "\" } } }";
         }
         else if(value is int)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\":{ \"" + valueName + "\":" + value + " } } }";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {} }}";
         }
         this.client.send(message);
      }
      
      private function checkArrayForPropertyValue(_array:Array, _prop:String, _value:*) : int
      {
         for(var i:int = 0; i < _array.length; i++)
         {
            if(_prop != "")
            {
               if(_array[i][_prop] == _value)
               {
                  return i;
               }
            }
            else if(_array[i] == _value)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function checkImagePath(path:String, defaultPath:String = "../../../img/default-album-art.png") : String
      {
         return path.indexOf("/tmp/ahaImages") != -1 ? "file://" + path : defaultPath;
      }
      
      private function checkForErrorCodes(name:String, resp:Object) : Boolean
      {
         if(resp.hasOwnProperty("code") && resp.code != 0)
         {
            trace("[ ERROR ] *<HMIModule> Aha.messageHandler \'rsp_" + name + "\' " + (resp.hasOwnProperty("description") == true ? resp.description : ""));
            return true;
         }
         if(resp.hasOwnProperty("status") && resp.status == "error 0x90000005")
         {
            trace("[ ERROR ] *<HMIModule> Aha.messageHandler \'rsp_" + name + "\' Timed Out!");
            return true;
         }
         if(resp.hasOwnProperty("error"))
         {
            trace("[ ERROR ] *<HMIModule> Aha.messageHandler \'rsp_" + name + "\' " + resp.description);
            return true;
         }
         return false;
      }
   }
}

