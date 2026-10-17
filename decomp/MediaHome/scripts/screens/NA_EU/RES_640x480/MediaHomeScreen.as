package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.*;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.MediaErrorCodes;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.Market;
   import core.enums.PopupType;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import events.HardControlEvent;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import flash.display.Bitmap;
   import flash.display.GradientType;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class MediaHomeScreen extends ScreenEnhanced
   {
      
      private static const ARROW:String = "arrow";
      
      private static const ARROWUP:String = "arrowup";
      
      private static const SCROLL_DEFAULT_REPORT_PERIOD:int = 500;
      
      private static const SCROLL_DRAGGING_REPORT_PERIOD:int = 50;
      
      private var assets:C_MediaHomeScreen = new C_MediaHomeScreen();
      
      private var mScreenFocusObject:FocusObject = null;
      
      private var mTrackListFocusObject:FocusObject = null;
      
      private var mArtLoader:Loader = new Loader();
      
      private var mArtPath:String = "";
      
      private var mArtPathDefault:String = "../../../img/default-album-art.png";
      
      private var mArtScaled:Bitmap;
      
      private var mArtReflection:Bitmap;
      
      private var mArtGradientMask:Sprite;
      
      private var mIndexSource:int;
      
      private var mNumSrcPerWindow:int;
      
      private var mTracksManual:Boolean;
      
      private var mTracksTimer:Timer = new Timer(10000);
      
      private var mSourcesTimer:Timer = new Timer(10000);
      
      public var mCurrentSource:String;
      
      private var mRdc2ModeInTransition:Boolean = false;
      
      private var mRestoreRdc2Video:Boolean = false;
      
      private var mMediaErrorSource:String;
      
      private var mAudioSource:String;
      
      private var mMediaErrorSourceMSId:int = -1;
      
      private var mSourceSelect:Boolean = false;
      
      private var mAutoPlayOff:Boolean = false;
      
      private var mReadBackPhraseMap:Object = new Object();
      
      private function mRearMedia():void
      {
      }
      private function mRearMediaReadBackPhrase():void
      {
      }
      public function MediaHomeScreen()
      {
         mView = this.assets;
         this.assets.tracks_group.visible = false;
         cache = true;
         super();
      }
      
      override public function screenOut() : void
      {
         this.closeArtLoader();
         this.mTracksTimer.reset();
         this.mSourcesTimer.reset();
         if(!this.mRdc2ModeInTransition)
         {
            Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_DTV);
         }
         this.mRestoreRdc2Video = false;
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.mArtLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAlbumArtLoaded,false,0,true);
         this.mArtLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onAlbumArtIOError,false,0,true);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource,false,0,true);
         Peripheral.audioManager.addEventListener(AudioEvent.AVAILABILITY,this.onSources,false,0,true);
         Peripheral.audioMixerManager.addEventListener(AudioMixerManagerEvent.AMM_INTERRUPT_SRC,this.onAudioInterruptSource,false,0,true);
         Peripheral.hardControls.addEventListener(HardControlEvent.SELECT,this.onICSSelectBrowse,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.CURRENT_TRACK,this.onCurrentTrack,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.CURRENT_ALBUM_ART_PATH,this.onCurrentAlbumArtPath,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.CURRENT_TRACK_INFO,this.onTrackInfo,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.DEVICE_READY_TO_BROWSE,this.onDeviceReadyToBrowse,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.MEDIA_ERROR,this.onMediaError,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.MEDIA_UNPLAYABLE,this.onMediaUnplayable,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.PLAY_ITEMS,this.onPlayItems,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.PLAY_TIME,this.onPlayTime,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.DEVICE_ACTIVE,this.onDeviceActive,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.PLAY_PATH,this.onPlayPath,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.RANDOM_MODE,this.onRandomMode,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.REPEAT_MODE,this.onRepeatMode,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.TRANSPORT_ACTION,this.onTransportChange,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.DEVICE_CAPABILITY,this.onDeviceCapability,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.SYNC_STATE,this.onSyncState,false,0,true);
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavIsOperable,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.RSE_STATUS,this.onRseModuleReady,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.ACTIVATE_BROWSE_BUTTON,this.onRSEActivateBrowse,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.BROWSE_ITEMS,this.onRSEBrowseItems,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.RSE_CURRENT_TRACK,this.onRSECurrentTrack,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.CURRENT_TRACK_INFO,this.onRSETrackInfo,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.CURRENT_TRACK_LENGTH,this.onRSECurrentTrackLength,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.DVD_DISC_STAT,this.onRSEDiscStat,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.DVD_OUT_STAT,this.onRSEDVDOutState,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.FULL_SCREEN_BUTTON_STATUS,this.onRSEFullScreenButtonStatus,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.PLAY_TIME,this.onRSEPlayTime,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.REPEAT_STATUS,this.onRSERepeatStatus,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.SHUFFLE_STATUS,this.onRSEShuffleStatus,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.START_DISC_PLAY_STATUS,this.onRSEStartDiscPlayStatus,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.VIDEO_LOCKOUT_STATUS,this.onRSEVideoLockoutStatus,false,0,true);
         Peripheral.rse.addEventListener(RseEvent.RDC2_MODE_STARTED,this.onRdc2Mode,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOut,false,0,true);
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_REARCAMERA_STATUS,this.onRearCameraStatus,false,0,true);
         Peripheral.shortTermDTVManager.addEventListener(Event.CHANGE,this.onDTVAvailable,false,0,true);
         this.assets.browse_button.addEventListener(WidgetEvent.CLICK,this.onBrowseClick,false,0,true);
         this.assets.repeatlg_button.addEventListener(WidgetEvent.CLICK,this.onRepeatClick,false,0,true);
         this.assets.repeatsm_button.addEventListener(WidgetEvent.CLICK,this.onRepeatClick,false,0,true);
         this.assets.shufflelg_button.addEventListener(WidgetEvent.CLICK,this.onShuffleClick,false,0,true);
         this.assets.shufflesm_button.addEventListener(WidgetEvent.CLICK,this.onShuffleClick,false,0,true);
         this.assets.seekbackward_button.addEventListener(WidgetEvent.RELEASE,this.onSeekBackwardStop,false,0,true);
         this.assets.seekforward_button.addEventListener(WidgetEvent.RELEASE,this.onSeekForwardStop,false,0,true);
         if(Boolean(Peripheral.personalConfig.videoReadBack) && Global.market == Market.NORTH_AMERICA)
         {
            this.assets.seekbackward_button.addEventListener(WidgetEvent.CLICK,this.onReadBackSeekBackwardClick,false,0,true);
            this.assets.seekbackward_button.addEventListener(WidgetEvent.LONG_PRESS,this.onReadBackSeekBackwardLongPress,false,0,true);
            this.assets.seekforward_button.addEventListener(WidgetEvent.CLICK,this.onReadBackSeekForwardClick,false,0,true);
            this.assets.seekforward_button.addEventListener(WidgetEvent.LONG_PRESS,this.onReadBackSeekForwardLongPress,false,0,true);
            this.assets.stop_button.addEventListener(WidgetEvent.CLICK,this.onReadBackStopClick,false,0,true);
            this.assets.playpause_button.addEventListener(WidgetEvent.CLICK,this.onReadBackPlayPauseClick,false,0,true);
            this.assets.sources.addEventListener(WidgetEvent.CLICK,this.onReadBackSourceClick,false,0,true);
            this.assets.splitview.addEventListener(WidgetEvent.CLICK,this.onReadBackSplitViewClick,false,0,true);
            this.assets.rse_button.addEventListener(WidgetEvent.CLICK,this.onRSEVideoReadBackClick,false,0,true);
         }
         else
         {
            this.assets.seekbackward_button.addEventListener(WidgetEvent.CLICK,this.onSeekBackwardClick,false,0,true);
            this.assets.seekbackward_button.addEventListener(WidgetEvent.LONG_PRESS,this.onSeekBackwardLongPress,false,0,true);
            this.assets.seekforward_button.addEventListener(WidgetEvent.CLICK,this.onSeekForwardClick,false,0,true);
            this.assets.seekforward_button.addEventListener(WidgetEvent.LONG_PRESS,this.onSeekForwardLongPress,false,0,true);
            this.assets.stop_button.addEventListener(WidgetEvent.CLICK,this.onStopClick,false,0,true);
            this.assets.playpause_button.addEventListener(WidgetEvent.CLICK,this.onPlayPauseClick,false,0,true);
            this.assets.sources.addEventListener(WidgetEvent.CLICK,this.onSourceClick,false,0,true);
            this.assets.splitview.addEventListener(WidgetEvent.CLICK,this.onSplitViewClick,false,0,true);
            this.assets.rse_button.addEventListener(WidgetEvent.CLICK,this.onRSEClick,false,0,true);
         }
         this.assets.audio_button.addEventListener(WidgetEvent.CLICK,this.onAudioClick,false,0,true);
         this.assets.tracks_group.tracks_list.addEventListener(WidgetEvent.SELECT,this.onTrackListSelect,false,0,true);
         this.assets.tracks_group.tracks_scroller.addEventListener(WidgetEvent.POSITION,this.onTracksListPosition,false,0,true);
         this.assets.track_group.playhead_scroller.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackMouseDown,false,0,true);
         this.assets.track_group.playhead_scroller.addEventListener(WidgetEvent.RELEASE,this.onTrackRelease,false,0,true);
         this.assets.tracks_group.tracks_list.attachScroller(this.assets.tracks_group.tracks_scroller);
         this.mTracksTimer.addEventListener(TimerEvent.TIMER,this.onTracksTimer,false,0,true);
         this.mSourcesTimer.addEventListener(TimerEvent.TIMER,this.onSourcesTimer,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         this.mArtLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onAlbumArtLoaded);
         this.mArtLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onAlbumArtIOError);
         Peripheral.audioManager.removeEventListener(AudioEvent.SOURCE,this.onSource);
         Peripheral.audioManager.removeEventListener(AudioEvent.AVAILABILITY,this.onSources);
         Peripheral.audioMixerManager.removeEventListener(AudioMixerManagerEvent.AMM_INTERRUPT_SRC,this.onAudioInterruptSource);
         Peripheral.hardControls.removeEventListener(HardControlEvent.SELECT,this.onICSSelectBrowse);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.CURRENT_TRACK,this.onCurrentTrack);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.CURRENT_ALBUM_ART_PATH,this.onCurrentAlbumArtPath);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.CURRENT_TRACK_INFO,this.onTrackInfo);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.DEVICE_READY_TO_BROWSE,this.onDeviceReadyToBrowse);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.MEDIA_ERROR,this.onMediaError);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.MEDIA_UNPLAYABLE,this.onMediaUnplayable);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.PLAY_ITEMS,this.onPlayItems);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.PLAY_TIME,this.onPlayTime);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.DEVICE_ACTIVE,this.onDeviceActive);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.PLAY_PATH,this.onPlayPath);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.RANDOM_MODE,this.onRandomMode);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.REPEAT_MODE,this.onRepeatMode);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.TRANSPORT_ACTION,this.onTransportChange);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.DEVICE_CAPABILITY,this.onDeviceCapability);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.SYNC_STATE,this.onSyncState);
         Peripheral.navigation.navDomainControl.removeEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavIsOperable);
         Peripheral.rse.removeEventListener(RseEvent.ACTIVATE_BROWSE_BUTTON,this.onRSEActivateBrowse);
         Peripheral.rse.removeEventListener(RseEvent.BROWSE_ITEMS,this.onRSEBrowseItems);
         Peripheral.rse.removeEventListener(RseEvent.RSE_CURRENT_TRACK,this.onRSECurrentTrack);
         Peripheral.rse.removeEventListener(RseEvent.CURRENT_TRACK_INFO,this.onRSETrackInfo);
         Peripheral.rse.removeEventListener(RseEvent.CURRENT_TRACK_LENGTH,this.onRSECurrentTrackLength);
         Peripheral.rse.removeEventListener(RseEvent.DVD_DISC_STAT,this.onRSEDiscStat);
         Peripheral.rse.removeEventListener(RseEvent.DVD_OUT_STAT,this.onRSEDVDOutState);
         Peripheral.rse.removeEventListener(RseEvent.FULL_SCREEN_BUTTON_STATUS,this.onRSEFullScreenButtonStatus);
         Peripheral.rse.removeEventListener(RseEvent.PLAY_TIME,this.onRSEPlayTime);
         Peripheral.rse.removeEventListener(RseEvent.REPEAT_STATUS,this.onRSERepeatStatus);
         Peripheral.rse.removeEventListener(RseEvent.SHUFFLE_STATUS,this.onRSEShuffleStatus);
         Peripheral.rse.removeEventListener(RseEvent.START_DISC_PLAY_STATUS,this.onRSEStartDiscPlayStatus);
         Peripheral.rse.removeEventListener(RseEvent.VIDEO_LOCKOUT_STATUS,this.onRSEVideoLockoutStatus);
         Peripheral.rse.removeEventListener(RseEvent.RDC2_MODE_STARTED,this.onRdc2Mode);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOut);
         Peripheral.displayManager.removeEventListener(DisplayManagerEvent.DISPLAY_REARCAMERA_STATUS,this.onRearCameraStatus);
         Peripheral.shortTermDTVManager.removeEventListener(Event.CHANGE,this.onDTVAvailable);
         this.assets.browse_button.removeEventListener(WidgetEvent.CLICK,this.onBrowseClick);
         this.assets.repeatlg_button.removeEventListener(WidgetEvent.CLICK,this.onRepeatClick);
         this.assets.repeatsm_button.removeEventListener(WidgetEvent.CLICK,this.onRepeatClick);
         this.assets.shufflelg_button.removeEventListener(WidgetEvent.CLICK,this.onShuffleClick);
         this.assets.shufflesm_button.removeEventListener(WidgetEvent.CLICK,this.onShuffleClick);
         this.assets.seekforward_button.removeEventListener(WidgetEvent.RELEASE,this.onSeekForwardStop);
         this.assets.seekbackward_button.removeEventListener(WidgetEvent.RELEASE,this.onSeekBackwardStop);
         if(Boolean(Peripheral.personalConfig.videoReadBack) && Global.market == Market.NORTH_AMERICA)
         {
            this.assets.stop_button.removeEventListener(WidgetEvent.CLICK,this.onReadBackStopClick);
            this.assets.seekbackward_button.removeEventListener(WidgetEvent.CLICK,this.onReadBackSeekBackwardClick);
            this.assets.seekbackward_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onReadBackSeekBackwardLongPress);
            this.assets.seekforward_button.removeEventListener(WidgetEvent.CLICK,this.onReadBackSeekForwardClick);
            this.assets.seekforward_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onReadBackSeekForwardLongPress);
            this.assets.playpause_button.removeEventListener(WidgetEvent.CLICK,this.onReadBackPlayPauseClick);
            this.assets.sources.removeEventListener(WidgetEvent.CLICK,this.onReadBackSourceClick);
            this.assets.splitview.removeEventListener(WidgetEvent.CLICK,this.onReadBackSplitViewClick);
            this.assets.rse_button.removeEventListener(WidgetEvent.CLICK,this.onRSEVideoReadBackClick);
         }
         else
         {
            this.assets.stop_button.removeEventListener(WidgetEvent.CLICK,this.onStopClick);
            this.assets.seekbackward_button.removeEventListener(WidgetEvent.CLICK,this.onSeekBackwardClick);
            this.assets.seekbackward_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onSeekBackwardLongPress);
            this.assets.seekforward_button.removeEventListener(WidgetEvent.CLICK,this.onSeekForwardClick);
            this.assets.seekforward_button.removeEventListener(WidgetEvent.LONG_PRESS,this.onSeekForwardLongPress);
            this.assets.playpause_button.removeEventListener(WidgetEvent.CLICK,this.onPlayPauseClick);
            this.assets.sources.removeEventListener(WidgetEvent.CLICK,this.onSourceClick);
            this.assets.splitview.removeEventListener(WidgetEvent.CLICK,this.onSplitViewClick);
            this.assets.rse_button.removeEventListener(WidgetEvent.CLICK,this.onRSEClick);
         }
         this.assets.rse_button.removeEventListener(WidgetEvent.CLICK,this.onRSEClick);
         this.assets.audio_button.removeEventListener(WidgetEvent.CLICK,this.onAudioClick);
         this.assets.tracks_group.tracks_list.removeEventListener(WidgetEvent.SELECT,this.onTrackListSelect);
         this.assets.tracks_group.tracks_scroller.removeEventListener(WidgetEvent.POSITION,this.onTracksListPosition);
         this.assets.track_group.playhead_scroller.thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackMouseDown);
         this.assets.track_group.playhead_scroller.removeEventListener(WidgetEvent.RELEASE,this.onTrackRelease);
         this.assets.tracks_group.tracks_list.detachScroller();
         this.mTracksTimer.removeEventListener(TimerEvent.TIMER,this.onTracksTimer);
         this.mSourcesTimer.removeEventListener(TimerEvent.TIMER,this.onSourcesTimer);
         if(this.assets.tracks_group.visible)
         {
            this.assets.tracks_group.visible = false;
            Peripheral.hardControls.removeEventListener(HardControlEvent.SELECT,this.assets.tracks_group.tracks_list.selectEventHandler);
            Peripheral.hardControls.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.assets.tracks_group.tracks_list.scrollEventHandler);
         }
         super.removeListeners();
      }
      
      override protected function initView() : void
      {
         super.initView();
         Framework.autoAssigner.assignChildren(this.assets.tracks_group);
         Framework.autoAssigner.assignChildren(this.assets.track_group);
         this.mScreenFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[this.assets.repeatsm_button,this.assets.shufflesm_button,this.assets.repeatlg_button,this.assets.shufflelg_button,this.assets.rse_button,this.assets.splitview.map_button,this.assets.splitview.info_button,this.assets.splitview.tracks_button,this.assets.splitview.setup_button,this.assets.splitview.fullscreen_button,this.assets.audio_button,this.assets.seekforward_button,this.assets.playpause_button,this.assets.seekbackward_button,this.assets.browse_button,this.assets.stop_button,this.assets.sources.item_3_button,this.assets.sources.item_2_button,this.assets.sources.item_1_button,this.assets.sources.item_0_button]);
         this.mTrackListFocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.assets.tracks_group.tracks_list.onFocusCallBack);
         this.assets.track_group.playhead_scroller.setPageSize(0);
         this.assets.tracks_group.tracks_list.setSelectionChanger(this.changeSelection);
         Peripheral.mediaPlayer.setSkipThreshold(Style.PlayerHomeScreen.SKIP_THRESHOLD);
         this.assets.seekbackward_button.longPressDelay = Style.PlayerHomeScreen.PLAYER_LONG_PRESS_DELAY;
         this.assets.seekforward_button.longPressDelay = Style.PlayerHomeScreen.PLAYER_LONG_PRESS_DELAY;
         this.checkRearAuxPresent();
         this.assets.splitview.map_button.visible = Global.navActivated;
         this.resetFunctionality();
         this.onSources(null);
      }
      
      override protected function initScreen() : void
      {
         var _sources:Vector.<String> = null;
         var isSourceConnected:Boolean = false;
         var i:int = 0;
         super.initScreen();
         this.removeOldArtwork();
         this.clearMetaDataFields();
         this.checkRearAuxPresent();
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DTV)
         {
            this.onRdc2Mode(null);
         }
         if(Framework.structure.historyIndexOf(Screens.REAR_MEDIA_VES) == 1 && Peripheral.vehicleStatus.speedLockOut == true)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         Framework.structure.setExit();
         if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
         {
            this.onSource(null);
         }
         else if(Peripheral.audioManager.source != "poweroff" && Boolean(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.lastMediaSource)))
         {
            Peripheral.audioManager.setSource(Peripheral.audioManager.lastMediaSource);
         }
         else if(Peripheral.audioManager.source != "poweroff")
         {
            _sources = Peripheral.audioManager.mediaSources;
            isSourceConnected = false;
            for(i = 0; i < _sources.length; i++)
            {
               if(Peripheral.audioManager.isSourceAvailable(_sources[i]))
               {
                  Peripheral.audioManager.setSource(_sources[i]);
                  isSourceConnected = true;
                  break;
               }
            }
            if(!isSourceConnected)
            {
               if(Peripheral.audioManager.isHardwareAvailable(Peripheral.audioManager.SOURCE_CD))
               {
                  Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_CD);
               }
               else if(Peripheral.audioManager.isHardwareAvailable(Peripheral.audioManager.SOURCE_USB1))
               {
                  Peripheral.audioManager.setSource(Peripheral.audioManager.SOURCE_USB1);
               }
            }
            isSourceConnected = false;
         }
         this.onAudioInterruptSource(null);
         this.assets.tracks_group.tracks_list.setDataRequester(this.getPlayItems);
         this.assets.tracks_group.tracks_list.setRowUpdater(this.updateRow);
         this.assets.tracks_group.tracks_list.setBufferSize(Style.PlayerHomeScreen.LIST_BUFFER_SIZE);
         this.showSplitScreen();
         Peripheral.appStateManager.recordSplitScreen();
         Framework.focusManager.addFocus(this.mScreenFocusObject);
         this.mReadBackPhraseMap.RU = new Object();
         this.mReadBackPhraseMap.NRU = new Object();
         this.mReadBackPhraseMap.RU[false] = "Uconnect Theater, button";
         this.mReadBackPhraseMap.RU[true] = "Uconnect Theater, button selected";
         this.mReadBackPhraseMap.NRU[false] = "Rear Media, button";
         this.mReadBackPhraseMap.NRU[true] = "Rear Media,button selected";
         this.mReadBackPhraseMap.seekforward_button = new Object();
         this.mReadBackPhraseMap.seekbackward_button = new Object();
         this.mReadBackPhraseMap.play_button = new Object();
         this.mReadBackPhraseMap.pause_button = new Object();
         this.mReadBackPhraseMap.stop_button = new Object();
         this.mReadBackPhraseMap.disc_button = new Object();
         this.mReadBackPhraseMap.fullscreen_button = new Object();
         this.mReadBackPhraseMap.usb_button = new Object();
         this.mReadBackPhraseMap.seekforward_button[false] = "Forward Press to Skip Hold to Scan, button";
         this.mReadBackPhraseMap.seekforward_button[true] = "Forward, button selected";
         this.mReadBackPhraseMap.seekbackward_button[false] = "Rewind Press to Skip Hold to Scan, button";
         this.mReadBackPhraseMap.seekbackward_button[true] = "Rewind, button selected";
         this.mReadBackPhraseMap.play_button[false] = "Play, button";
         this.mReadBackPhraseMap.play_button[true] = "Play, button selected";
         this.mReadBackPhraseMap.pause_button[false] = "Pause, button";
         this.mReadBackPhraseMap.pause_button[true] = "Pause, button selected";
         this.mReadBackPhraseMap.stop_button[false] = "Stop, button";
         this.mReadBackPhraseMap.stop_button[true] = "Stop, button selected";
         this.mReadBackPhraseMap.disc_button[false] = "Disc Source, button";
         this.mReadBackPhraseMap.disc_button[true] = "Disc Source, button selected";
         this.mReadBackPhraseMap.fullscreen_button[false] = "Full Screen Movie, button";
         this.mReadBackPhraseMap.fullscreen_button[true] = "Full Screen Movie, button selected";
         this.mReadBackPhraseMap.usb_button[false] = "USB Source, button";
         this.mReadBackPhraseMap.usb_button[true] = "USB Source, button selected";
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         Text.format(this.assets.repeatsm_button.label,T.STRB_REPEAT);
         Text.format(this.assets.shufflesm_button.label,T.STRB_SHUFFLE_SHORT);
         Text.format(this.assets.repeatlg_button.label,T.STRB_REPEAT);
         Text.format(this.assets.shufflelg_button.label,T.STRB_SHUFFLE);
         if(Peripheral.vehConfig.vehicleLine != "RU")
         {
            Text.format(this.assets.rse_button.label,T.STRB_REAR_MEDIA);
         }
         Text.format(this.assets.splitview.map_button.label,T.STRB_MAP);
         Text.format(this.assets.splitview.info_button.label,T.STRB_INFO,false);
         Text.resizeToFitByFontSize(this.assets.splitview.info_button.label,false,true);
         Text.format(this.assets.splitview.tracks_button.label,T.STRB_TRKS,false);
         Text.resizeToFitByFontSize(this.assets.splitview.tracks_button.label,false,true);
         Text.format(this.assets.splitview.setup_button.label,T.STRB_SETUP);
         Text.format(this.assets.splitview.fullscreen_button.label,T.STRB_FULL);
         Text.format(this.assets.browse_button.label,T.STRB_BROWSE);
         Text.format(this.assets.audio_button.label,T.STRB_AUDIO);
         Text.format(this.assets.info.track,T.STRB_TRACK);
         Text.format(this.assets.info.artist,T.STRB_ARTIST);
         Text.format(this.assets.info.title,T.STRB_TITLE);
         Text.format(this.assets.info.album,T.STRB_ALBUM);
         Text.format(this.assets.info.composer,T.STRB_COMPOSER);
         Text.format(this.assets.info.genre,T.STRB_GENRE);
         Text.format(this.assets.info.year,T.STRB_YEAR);
      }
      
      private function onRepeatClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.repeatstatus == "on")
            {
               Peripheral.rse.setRepeatState("off");
            }
            else if(Peripheral.rse.repeatstatus == "off")
            {
               Peripheral.rse.setRepeatState("on");
            }
         }
         else if(Peripheral.mediaPlayer.repeatMode != MediaPlayerRepeatMode.SONG)
         {
            Peripheral.mediaPlayer.setRepeatMode(MediaPlayerRepeatMode.SONG);
         }
         else
         {
            Peripheral.mediaPlayer.setRepeatMode(MediaPlayerRepeatMode.ALL);
         }
      }
      
      private function onShuffleClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.shufflestatus == "on")
            {
               Peripheral.rse.setShuffleState("off");
            }
            else if(Peripheral.rse.shufflestatus == "off")
            {
               Peripheral.rse.setShuffleState("on");
            }
         }
         else if(Peripheral.mediaPlayer.randomMode == MediaPlayerRandomMode.OFF)
         {
            Peripheral.mediaPlayer.setRandomMode(MediaPlayerRandomMode.ALL);
         }
         else if(Peripheral.mediaPlayer.randomMode == MediaPlayerRandomMode.ALL)
         {
            Peripheral.mediaPlayer.setRandomMode(MediaPlayerRandomMode.OFF);
         }
      }
      
      private function onTrackMouseDown(e:MouseEvent) : void
      {
         Peripheral.mediaPlayer.setTrackSlidingStatus(true);
         this.assets.track_group.playhead_scroller.setReportingPeriod(SCROLL_DRAGGING_REPORT_PERIOD);
         this.assets.track_group.playhead_scroller.addEventListener(WidgetEvent.POSITION,this.onTrackPosition,false,0,true);
         this.assets.track_group.playhead_scroller.setMaximum(Peripheral.mediaPlayer.playDuration);
         Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PAUSE);
      }
      
      private function onTrackRelease(e:WidgetEvent) : void
      {
         this.assets.track_group.playhead_scroller.setReportingPeriod(SCROLL_DEFAULT_REPORT_PERIOD);
         this.assets.track_group.playhead_scroller.removeEventListener(WidgetEvent.POSITION,this.onTrackPosition);
         Peripheral.mediaPlayer.setPlayTime(mView.track_group.playhead_scroller.getValue());
      }
      
      private function onTrackPosition(e:WidgetEvent) : void
      {
         this.assets.track_group.playhead_scroller.setProgress(mView.track_group.playhead_scroller.getValue());
      }
      
      private function onRSEClick(e:WidgetEvent) : void
      {
         if(Peripheral.vehConfig.vehicleLine == "RU")
         {
            Framework.structure.goto(Screens.REAR_MEDIA);
         }
         else
         {
            Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onRequestDisplayResponse,false,0,true);
            Peripheral.displayManager.requestDisplay(DisplayManagerLayers.LAYER_MAP,false);
         }
      }
      
      private function onRequestDisplayResponse(e:DisplayManagerEvent) : void
      {
         Peripheral.displayManager.removeEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onRequestDisplayResponse);
         Peripheral.rse.startRdc2Video("parentalControlsRequest");
         Framework.structure.goto(Screens.PARENTALCONTROLS);
      }
      
      private function onBrowseClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && Peripheral.rse.dvdDiscStatValue != RSEConstants.DVD_MD_DVD_VIDEO && Peripheral.rse.dvdDiscStatValue != RSEConstants.DISC_MD_BD_VIDEO)
         {
            Framework.structure.goto(Screens.BROWSE_DISC);
         }
         else if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.mediaBrowser.clearAvailableViews();
            Framework.structure.goto(Screens.BROWSE_MEDIA);
         }
      }
      
      private function onStopClick(e:WidgetEvent) : void
      {
         Peripheral.rse.discstop();
         this.setScrollerProgress(Peripheral.rse.rseplaytime);
      }
      
      private function onSeekBackwardClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD || Boolean(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source)))
         {
            Peripheral.rse.seekback();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PREVIOUS);
         }
      }
      
      private function onSeekForwardClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD || Boolean(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source)))
         {
            Peripheral.rse.seeknext();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.SKIP_FORWARD);
         }
      }
      
      private function onSeekBackwardLongPress(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.rse.fastrewind();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.FAST_REVERSE);
         }
      }
      
      private function onSeekForwardLongPress(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.rse.fastforward();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.FAST_FORWARD);
         }
      }
      
      private function onSeekBackwardStop(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.rse.buttonRelease();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.RESUME);
         }
      }
      
      private function onSeekForwardStop(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.rse.buttonRelease();
         }
         else
         {
            Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.RESUME);
         }
      }
      
      private function onPlayPauseClick(e:WidgetEvent) : void
      {
         if(Peripheral.bluetoothPhone.isBluetoothCallActive() == false)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD || Boolean(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source)))
            {
               if(Peripheral.rse.dvdoutstatstatus == "play")
               {
                  Peripheral.rse.setdvdoutstat("pause");
               }
               else if(Peripheral.rse.dvdoutstatstatus == "pause" || Peripheral.rse.dvdoutstatstatus == "stop")
               {
                  Peripheral.rse.setdvdoutstat("play");
               }
            }
            else if(Peripheral.mediaPlayer.transportAction == MediaPlayerTransportAction.PLAY)
            {
               Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PAUSE);
            }
            else if(Peripheral.mediaPlayer.transportAction == MediaPlayerTransportAction.PAUSE)
            {
               Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.RESUME);
            }
            else
            {
               Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PLAY);
            }
         }
      }
      
      private function onAudioClick(e:WidgetEvent) : void
      {
         Framework.structure.goto(Screens.SETTINGS_AUDIO);
      }
      
      private function onSplitViewClick(e:WidgetEvent) : void
      {
         switch(e.data.name)
         {
            case "map_button":
               Peripheral.appStateManager.splitScreenSource = Peripheral.appStateManager.splitScreenSource == "map" ? "none" : "map";
               this.showSplitScreen();
               break;
            case "info_button":
               Peripheral.appStateManager.splitScreenSource = Peripheral.appStateManager.splitScreenSource == "info" ? "none" : "info";
               this.showSplitScreen();
               break;
            case "tracks_button":
               Peripheral.appStateManager.splitScreenSource = Peripheral.appStateManager.splitScreenSource == "tracks" ? "none" : "tracks";
               this.showSplitScreen();
               break;
            case "fullscreen_button":
               if(Peripheral.vehicleStatus.speedLockOut == true)
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
               }
               else
               {
                  Peripheral.rse.startRdc2Video("fullScreenRequest");
               }
               break;
            case "setup_button":
               Framework.structure.goto(Screens.SETTINGS_BLUETOOTH,{"source":"audio"});
         }
      }
      
      private function onSourceClick(e:WidgetEvent) : void
      {
         this.mSourcesTimer.reset();
         switch(e.data.type)
         {
            case ARROW:
               this.mIndexSource += 3;
               this.mSourcesTimer.start();
               this.updateSources();
               break;
            case Peripheral.audioManager.SOURCE_CD:
            case Peripheral.audioManager.SOURCE_AUX:
            case Peripheral.audioManager.SOURCE_DTV:
            case Peripheral.audioManager.SOURCE_REAR_AUX1:
            case Peripheral.audioManager.SOURCE_REAR_AUX2:
            case Peripheral.audioManager.SOURCE_REAR_HDMI1:
            case Peripheral.audioManager.SOURCE_REAR_HDMI2:
               Peripheral.audioManager.setSource(e.data.type);
               break;
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               if(!Peripheral.vehicleStatus.speedLockOut && (Peripheral.bluetooth.currentA2DPDevice == null || !Peripheral.bluetooth.currentA2DPDevice.A2dpConnected))
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"no phone paired",
                     "screen":"audio"
                  });
               }
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               if(Peripheral.audioManager.source != e.data.type)
               {
                  this.clearMetaDataFields();
                  this.mSourceSelect = true;
               }
            default:
               Peripheral.audioManager.setSource(e.data.type);
         }
      }
      
      private function onSource(e:AudioEvent) : void
      {
         if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
         {
            if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_AUX)
            {
               Peripheral.mediaPlayer.checkDevicePlayable(Peripheral.audioManager.source);
            }
            if(this.mSourceSelect == true)
            {
               this.assets.browse_button.setEnabled(false);
            }
            this.setCurrentSourceIndex();
            this.onSources(null);
            this.showCurrentSource();
            this.mSourceSelect = false;
            this.mAudioSource = Peripheral.audioManager.source;
            if(this.mAudioSource == Peripheral.audioManager.SOURCE_AUX || this.mAudioSource == Peripheral.audioManager.SOURCE_CD || this.mAudioSource == Peripheral.audioManager.SOURCE_DTV || this.mAudioSource == Peripheral.audioManager.SOURCE_REAR_AUX1 || this.mAudioSource == Peripheral.audioManager.SOURCE_REAR_AUX2 || this.mAudioSource == Peripheral.audioManager.SOURCE_REAR_HDMI1 || this.mAudioSource == Peripheral.audioManager.SOURCE_REAR_HDMI2)
            {
               Peripheral.mediaPlayer.deSelectActiveDevice();
            }
         }
      }
      
      private function onSources(e:AudioEvent) : void
      {
         this.updateSources();
         this.checkRearAuxPresent();
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            this.assets.track_group.playhead_scroller.thumb.visible = false;
         }
      }
      
      private function onSourcesTimer(e:TimerEvent) : void
      {
         this.mSourcesTimer.reset();
         this.setCurrentSourceIndex();
         this.updateSources();
      }
      
      private function updateSources() : void
      {
         var _sources:Vector.<String> = Peripheral.audioManager.mediaSources;
         if(this.mIndexSource > _sources.length - 1)
         {
            this.mIndexSource = 0;
         }
         if(_sources.length > this.assets.sources.numChildren)
         {
            this.mNumSrcPerWindow = this.assets.sources.numChildren - 1;
            this.assets.sources.item_3_button.type = ARROW;
            if(this.mIndexSource >= 3 && _sources.length <= 6)
            {
               this.assets.sources.item_3_button.icon.gotoAndStop(ARROWUP);
            }
            else
            {
               this.assets.sources.item_3_button.icon.gotoAndStop(ARROW);
            }
            this.assets.sources.item_3_button.label.text = "";
            this.assets.sources.item_3_button.setEnabled(true);
            this.assets.sources.item_3_button.visible = true;
         }
         else
         {
            this.mNumSrcPerWindow = this.assets.sources.numChildren;
         }
         for(var i:int = 0; i < this.mNumSrcPerWindow; i++)
         {
            if(this.mIndexSource + i < _sources.length)
            {
               this.updateSourceButton(this.assets.sources["item_" + i + "_button"],_sources[this.mIndexSource + i]);
            }
            else
            {
               this.assets.sources["item_" + i + "_button"].visible = false;
            }
         }
         Framework.focusManager.refresh();
      }
      
      private function updateSourceButton(_button:MovieClip, _type:String) : void
      {
         var iconName:String = null;
         var sourceName:String = null;
         _button.visible = true;
         switch(_type)
         {
            case Peripheral.audioManager.SOURCE_AUX:
               iconName = "aux";
               sourceName = "Aux";
               break;
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               iconName = "bluetooth";
               sourceName = "";
               break;
            case Peripheral.audioManager.SOURCE_CD:
               iconName = "disc";
               sourceName = "Disc";
               break;
            case Peripheral.audioManager.SOURCE_USB1:
               if(Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB1))
               {
                  iconName = "ipod";
                  sourceName = "iPod";
               }
               else if(Peripheral.audioManager.isSourceCarPlay(Peripheral.audioManager.SOURCE_USB1))
               {
                  iconName = "carplay";
                  sourceName = "";
               }
               else if(Peripheral.audioManager.isSourceGAL(Peripheral.audioManager.SOURCE_USB1))
               {
                  iconName = "gal";
                  sourceName = "";
               }
               else
               {
                  iconName = "usb";
                  sourceName = "USB";
               }
               break;
            case Peripheral.audioManager.SOURCE_USB2:
               iconName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB2) ? "ipod" : "usb";
               sourceName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB2) ? "iPod" : "USB";
               break;
            case Peripheral.audioManager.SOURCE_USB3:
               iconName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB3) ? "ipod" : "usb";
               sourceName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB3) ? "iPod" : "USB";
               break;
            case Peripheral.audioManager.SOURCE_USB4:
               iconName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB4) ? "ipod" : "usb";
               sourceName = Peripheral.audioManager.isSourceIPod(Peripheral.audioManager.SOURCE_USB4) ? "iPod" : "USB";
               break;
            case Peripheral.audioManager.SOURCE_REAR_AUX1:
               iconName = "av";
               sourceName = "AV1";
               break;
            case Peripheral.audioManager.SOURCE_REAR_AUX2:
               iconName = "av";
               sourceName = "AV2";
               break;
            case Peripheral.audioManager.SOURCE_REAR_HDMI1:
               iconName = "hdmi";
               sourceName = "1";
               break;
            case Peripheral.audioManager.SOURCE_REAR_HDMI2:
               iconName = "hdmi";
               sourceName = "2";
               break;
            case Peripheral.audioManager.SOURCE_SDCARD:
               iconName = "sd";
               sourceName = "SD";
               break;
            case Peripheral.audioManager.SOURCE_DTV:
               iconName = "av";
               sourceName = "DTV";
         }
         _button.type = _type;
         _button.icon.gotoAndStop(iconName);
         _button.label.text = sourceName;
         _button.icon.visible = iconName != null;
         _button.label.visible = sourceName != null;
         _button.setEnabled(_type == Peripheral.audioManager.SOURCE_DTV ? Peripheral.shortTermDTVManager.DTVAvailable : _type == Peripheral.audioManager.SOURCE_BLUETOOTH || Peripheral.audioManager.isSourceAvailable(_type));
         _button.setHighlight(Peripheral.audioManager.source == _type);
      }
      
      private function onAudioInterruptSource(e:AudioMixerManagerEvent) : void
      {
         if(Peripheral.audioMixerManager.interruptSource != Peripheral.audioMixerManager.AMM_SOURCE_SIGNAL && Boolean(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source)) && Peripheral.mediaPlayer.mediaErrorCode() == 0)
         {
            this.assets.audio_button.setEnabled(true);
         }
         else
         {
            this.assets.audio_button.setEnabled(false);
         }
      }
      
      private function checkRearAuxPresent() : void
      {
         if(Peripheral.audioManager.isRearAuxAvailable)
         {
            this.assets.rse_button.visible = true;
            this.assets.shufflesm_button.visible = true;
            this.assets.repeatsm_button.visible = true;
            this.assets.shufflelg_button.visible = false;
            this.assets.repeatlg_button.visible = false;
         }
         else
         {
            this.assets.rse_button.visible = false;
            this.assets.shufflesm_button.visible = false;
            this.assets.repeatsm_button.visible = false;
            this.assets.shufflelg_button.visible = true;
            this.assets.repeatlg_button.visible = true;
         }
         Framework.focusManager.refresh();
      }
      
      private function onNavIsOperable(e:NavDomainControllerEvent) : void
      {
         this.assets.splitview.map_button.visible = true;
      }
      
      private function onRseModuleReady(e:RseEvent) : void
      {
         if(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source))
         {
            this.showCurrentSource();
         }
      }
      
      private function onRdc2Mode(e:RseEvent) : void
      {
         if(Peripheral.rse.rdc2Mode == RSEConstants.DTV_FULL)
         {
            this.mRdc2ModeInTransition = true;
            Framework.structure.goto(Screens.DTV_FULL_SCREEN);
         }
         else if(Peripheral.rse.rdc2Mode == RSEConstants.DTV_CAMERA)
         {
            this.mRdc2ModeInTransition = true;
         }
         else if(Peripheral.rse.rdc2Mode == RSEConstants.DISP_OFF || Peripheral.rse.rdc2Mode == RSEConstants.DTV_NORMAL)
         {
            this.mRdc2ModeInTransition = false;
         }
         if(Peripheral.rse.rdc2Mode == RSEConstants.RSE_FRONT_FULL)
         {
            Framework.structure.goto(Screens.REAR_MEDIA_VES);
         }
      }
      
      private function showCurrentSource() : void
      {
         var mPreviousSplitSource:String = null;
         var _info:Boolean = false;
         var _tracks:Boolean = false;
         if(this.mCurrentSource != Peripheral.audioManager.source)
         {
            this.mCurrentSource = Peripheral.audioManager.source;
            this.assets.tracks_group.tracks_list.setLength(0);
         }
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_USB1 && Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_USB2)
         {
            if(!Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DTV && !Peripheral.shortTermDTVManager.DTVAvailable)
            {
               this.showFullScreen(true);
               this.resetFunctionality();
               this.assets.audio_button.setEnabled(false);
               this.showNotAvailableMessage();
               this.assets.splitview.setup_button.visible = Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH;
               Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_DTV);
               return;
            }
            this.assets.audio_button.setEnabled(true);
            this.resetFunctionality();
         }
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_DTV)
         {
            Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_DTV);
         }
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_CD:
               this.showFullScreen(true);
               Peripheral.rse.getstartDiscPlayValue();
               Peripheral.rse.getdvdDiscStatValue();
               this.clearMetaDataFields();
               this.assets.textFull.hdmi.visible = false;
               this.assets.track_group.songnumber.visible = Peripheral.rse.startDiscPlayStatus;
               this.assets.track_group.timeduration.visible = Peripheral.rse.startDiscPlayStatus;
               this.assets.track_group.playhead_scroller.visible = Peripheral.rse.startDiscPlayStatus;
               this.assets.track_group.playhead_scroller.thumb.visible = false;
               this.assets.splitview.info_button.visible = Peripheral.rse.startDiscPlayStatus;
               this.assets.splitview.tracks_button.visible = Peripheral.rse.startDiscPlayStatus;
               this.assets.splitview.setup_button.visible = false;
               Peripheral.rse.setBrowsePath({
                  "path":"/songs",
                  "type":""
               });
               this.assets.splitview.fullscreen_button.visible = Peripheral.rse.fullScreenButtonPresent;
               this.assets.stop_button.visible = Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_DVD_VIDEO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_MD_BD_VIDEO;
               this.assets.browse_button.visible = !this.assets.stop_button.visible || Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_CD_AUDIO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_MP3;
               _info = Peripheral.rse.dvdDiscStatValue != RSEConstants.DVD_MD_DVD_VIDEO && Peripheral.rse.dvdDiscStatValue != RSEConstants.DISC_MD_BD_VIDEO && Peripheral.rse.dvdDiscStatValue != RSEConstants.MECH_NP;
               this.assets.splitview.info_button.setEnabled(_info);
               _tracks = Boolean(Peripheral.rse.listSyncStatus) && Peripheral.rse.dvdoutstatstatus != RSEConstants.MD_STOP;
               this.assets.splitview.tracks_button.setEnabled(_tracks);
               this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut && !Peripheral.rse.getVideoLockoutStatus);
               this.assets.repeatsm_button.setEnabled(Peripheral.rse.isShuffleRepeatAvailable);
               this.assets.shufflesm_button.setEnabled(Peripheral.rse.isShuffleRepeatAvailable);
               this.assets.repeatlg_button.setEnabled(Peripheral.rse.isShuffleRepeatAvailable);
               this.assets.shufflelg_button.setEnabled(Peripheral.rse.isShuffleRepeatAvailable);
               this.assets.stop_button.setEnabled(false);
               this.assets.browse_button.setEnabled(false);
               this.assets.playpause_button.setEnabled(Peripheral.rse.startDiscPlayStatus);
               this.assets.seekbackward_button.setEnabled(Peripheral.rse.startDiscPlayStatus);
               this.assets.seekforward_button.setEnabled(Peripheral.rse.startDiscPlayStatus);
               this.onAlbumArt(this.mArtPathDefault);
               if(this.onRSEDiscError())
               {
                  return;
               }
               if(!Peripheral.rse.startDiscPlayStatus)
               {
                  switch(Peripheral.rse.dvdoutstatstatus)
                  {
                     case RSEConstants.MD_LOAD:
                        this.clearMetaDataFields();
                        this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_LOADING_MEDIA));
                        break;
                     case RSEConstants.MD_READ:
                        this.clearMetaDataFields();
                        this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_READING_MEDIA));
                        break;
                     case RSEConstants.MD_STOP:
                        this.clearMetaDataFields();
                        this.showRSEStop();
                        break;
                     case RSEConstants.MD_EJECT:
                        this.clearMetaDataFields();
                        this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_EJECTING_MEDIA));
                  }
                  return;
               }
               Peripheral.rse.getFullScreenButtonStat(Peripheral.audioManager.source);
               Peripheral.rse.getRepeatShuffleStatus();
               Peripheral.rse.getListSyncStatus();
               Peripheral.rse.getCurrentTrackInfo();
               this.onRSECurrentTrack(null);
               this.onRSEPlayTime(null);
               this.onRSEActivateBrowse(null);
               break;
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
               this.showFullScreen(true);
               if(this.onDisableForAutoPlayOff() == true)
               {
                  mPreviousSplitSource = Peripheral.appStateManager.splitScreenSource;
                  this.mAutoPlayOff = true;
                  this.resetFunctionalityForAutoplayOff();
                  Peripheral.appStateManager.splitScreenSource = mPreviousSplitSource;
               }
               else
               {
                  this.assets.textFull.hdmi.visible = false;
                  this.assets.track_group.songnumber.visible = false;
                  if(Peripheral.mediaPlayer.playTime >= 0 && Boolean(Peripheral.mediaPlayer.playDuration))
                  {
                     this.assets.track_group.timeduration.visible = true;
                     this.assets.track_group.playhead_scroller.visible = true;
                  }
                  this.assets.track_group.playhead_scroller.thumb.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
                  this.assets.splitview.info_button.visible = true;
                  this.assets.splitview.tracks_button.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
                  this.assets.splitview.setup_button.visible = Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH;
                  this.assets.splitview.fullscreen_button.visible = false;
                  this.assets.stop_button.visible = false;
                  this.assets.browse_button.visible = true;
                  this.assets.splitview.info_button.setEnabled(true);
                  this.assets.splitview.tracks_button.setEnabled(true);
                  this.assets.repeatsm_button.setEnabled(true);
                  this.assets.shufflesm_button.setEnabled(true);
                  this.assets.repeatlg_button.setEnabled(true);
                  this.assets.shufflelg_button.setEnabled(true);
                  if(Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
                  {
                     this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
                  }
                  this.assets.playpause_button.setEnabled(true);
                  this.assets.seekbackward_button.setEnabled(true);
                  this.assets.seekforward_button.setEnabled(true);
                  this.assets.repeatsm_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
                  this.assets.shufflesm_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
                  this.assets.repeatlg_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
                  this.assets.shufflelg_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
                  this.onCurrentTrack(null);
                  this.onCurrentAlbumArtPath(null);
                  this.onPlayTime(null);
                  this.onTransportChange(null);
                  this.onDeviceCapability(null);
               }
               if(Peripheral.mediaPlayer.mediaErrorCode() != 0 && Peripheral.mediaPlayer.mediaErrorMSID() == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  this.onMediaError(null);
               }
               if(!Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source))
               {
                  this.showFullScreen(true);
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.showNotAvailableMessage();
                  Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_DTV);
                  return;
               }
               this.assets.audio_button.setEnabled(true);
               break;
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
            case Peripheral.audioManager.SOURCE_SDCARD:
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               this.showFullScreen(true);
               this.assets.textFull.hdmi.visible = false;
               this.assets.track_group.songnumber.visible = false;
               if(Peripheral.mediaPlayer.playTime >= 0 && Boolean(Peripheral.mediaPlayer.playDuration))
               {
                  this.assets.track_group.timeduration.visible = true;
                  this.assets.track_group.playhead_scroller.visible = true;
               }
               this.assets.track_group.playhead_scroller.thumb.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.info_button.visible = true;
               this.assets.splitview.tracks_button.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.setup_button.visible = Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.fullscreen_button.visible = false;
               this.assets.stop_button.visible = false;
               this.assets.browse_button.visible = true;
               if(Peripheral.mediaPlayer.readyToBrowse)
               {
                  this.assets.splitview.info_button.setEnabled(true);
                  this.assets.splitview.tracks_button.setEnabled(true);
                  this.assets.playpause_button.setEnabled(true);
                  this.assets.seekbackward_button.setEnabled(true);
                  this.assets.seekforward_button.setEnabled(true);
               }
               if(Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
               }
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH && (!Peripheral.mediaPlayer.RepeatDeviceSupport && !Peripheral.mediaPlayer.RandomDeviceSupport))
               {
                  this.assets.repeatsm_button.setEnabled(false);
                  this.assets.shufflesm_button.setEnabled(false);
                  this.assets.repeatlg_button.setEnabled(false);
                  this.assets.shufflelg_button.setEnabled(false);
               }
               else
               {
                  this.assets.repeatsm_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
                  this.assets.shufflesm_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
                  this.assets.repeatlg_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
                  this.assets.shufflelg_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
               }
               this.assets.repeatsm_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflesm_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.assets.repeatlg_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflelg_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.onCurrentTrack(null);
               this.onCurrentAlbumArtPath(null);
               this.onPlayTime(null);
               this.onTransportChange(null);
               this.onDeviceCapability(null);
               if(Peripheral.mediaPlayer.mediaErrorCode() != 0 && Peripheral.mediaPlayer.mediaErrorMSID() == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  this.onMediaError(null);
               }
               break;
            case Peripheral.audioManager.SOURCE_AUX:
               this.showFullScreen(true);
               this.resetFunctionality();
               this.setMetaData("",Peripheral.localeEngine.getText(T.STRB_AUX_INPUT));
               break;
            case Peripheral.audioManager.SOURCE_REAR_AUX1:
            case Peripheral.audioManager.SOURCE_REAR_AUX2:
            case Peripheral.audioManager.SOURCE_REAR_HDMI1:
            case Peripheral.audioManager.SOURCE_REAR_HDMI2:
               this.showFullScreen(true);
               this.resetFunctionality();
               switch(Peripheral.audioManager.source)
               {
                  case Peripheral.audioManager.SOURCE_REAR_AUX1:
                     this.setMetaData("","AV1");
                     break;
                  case Peripheral.audioManager.SOURCE_REAR_AUX2:
                     this.setMetaData("","AV2");
                     break;
                  case Peripheral.audioManager.SOURCE_REAR_HDMI1:
                     this.setMetaData("","HDMI1");
                     break;
                  case Peripheral.audioManager.SOURCE_REAR_HDMI2:
                     this.setMetaData("","HDMI2");
               }
               Peripheral.rse.getFullScreenButtonStat(Peripheral.audioManager.source);
               break;
            case Peripheral.audioManager.SOURCE_DTV:
               if(Peripheral.displayManager.RearCameraStatus)
               {
                  this.mRestoreRdc2Video = true;
                  this.showFullScreen(false);
               }
               else if(Framework.structure.historyIndexOf(Screens.DTV_FULL_SCREEN) != 1 && Peripheral.rse.prevRdc2Mode == RSEConstants.DTV_FULL || Peripheral.rse.prevRdc2Mode != RSEConstants.DTV_FULL || Peripheral.rse.rdc2Mode == RSEConstants.DISP_OFF)
               {
                  Peripheral.rse.startRdc2Video("dtvNormal");
                  this.showFullScreen(false);
               }
               break;
            default:
               this.resetFunctionality();
         }
         Framework.focusManager.refresh();
      }
      
      private function onRepeatMode(e:MediaPlayerEvent) : void
      {
         var RepeatSupport:Boolean = Boolean(e.data);
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_AUX && Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH && Peripheral.mediaPlayer.RepeatDeviceSupport == true && !RepeatSupport)
            {
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.FUNCTION_CURR_NOT_AVAIL);
            }
            else
            {
               this.assets.repeatsm_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.repeatlg_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
            }
         }
      }
      
      private function onRandomMode(e:MediaPlayerEvent) : void
      {
         var RandomSupport:Boolean = Boolean(e.data);
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH && Peripheral.mediaPlayer.RandomDeviceSupport == true && !RandomSupport)
            {
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.FUNCTION_CURR_NOT_AVAIL);
            }
            else
            {
               this.assets.shufflesm_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.assets.shufflelg_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.assets.tracks_group.tracks_list.setLength(0);
               this.setupTrackList();
            }
         }
      }
      
      private function onDeviceReadyToBrowse(e:MediaPlayerEvent) : void
      {
         if(this.assets.browse_button.visible == false)
         {
            this.assets.browse_button.visible = true;
         }
         if(Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
         {
            this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
         }
         if(Boolean(Peripheral.mediaPlayer.readyToBrowse) && Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source) && !this.mAutoPlayOff)
         {
            Peripheral.mediaPlayer.getCurrentTrackInfo();
            this.enableFunctionality();
         }
      }
      
      private function onTransportChange(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.transportAction == MediaPlayerTransportAction.PLAY)
         {
            this.mAutoPlayOff = false;
            if(Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source) == Peripheral.mediaPlayer.activeDeviceMSID())
            {
               this.enableFunctionality();
            }
         }
         if(Boolean(Peripheral.mediaPlayer.transportAction) && Peripheral.mediaPlayer.transportAction != MediaPlayerTransportAction.STOP)
         {
            if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD && !this.mAutoPlayOff)
            {
               this.assets.playpause_button.icon.gotoAndStop(Peripheral.mediaPlayer.transportAction);
            }
         }
      }
      
      private function clearPlayTimeInfo() : void
      {
         this.assets.track_group.timeduration.text = "";
         this.assets.track_group.playhead_scroller.visible = false;
      }
      
      private function onPlayTime(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.isTrackSliding)
         {
            return;
         }
         var playTimeMsid:int = -1;
         if(e)
         {
            playTimeMsid = int(e.data);
         }
         if(Peripheral.mediaPlayer.mediaErrorCode() != 0 && Peripheral.mediaPlayer.mediaErrorMSID() != playTimeMsid && Peripheral.mediaPlayer.activeDeviceMsid() != playTimeMsid || playTimeMsid != Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
         {
            return;
         }
         if(Boolean(Peripheral.audioManager.isSourceMediaService()) && Boolean(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source)))
         {
            if(Peripheral.mediaPlayer.playTime >= 0 && Boolean(Peripheral.mediaPlayer.playDuration))
            {
               if(Peripheral.mediaPlayer.playDuration != mView.track_group.playhead_scroller.getMaximum())
               {
                  this.assets.track_group.playhead_scroller.setMaximum(Peripheral.mediaPlayer.playDuration);
               }
               this.assets.track_group.timeduration.text = Format.timeDelta(Peripheral.mediaPlayer.playTime) + " / " + Format.timeDelta(Peripheral.mediaPlayer.playDuration);
               this.assets.track_group.playhead_scroller.thumb.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.setScrollerProgress(Peripheral.mediaPlayer.playTime);
               this.assets.track_group.playhead_scroller.visible = true;
               this.assets.track_group.timeduration.visible = true;
            }
            else
            {
               this.clearPlayTimeInfo();
            }
         }
      }
      
      private function onDeviceActive(e:MediaPlayerEvent) : void
      {
         this.clearPlayTimeInfo();
         this.assets.playpause_button.setEnabled(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_AUX);
      }
      
      private function onCurrentTrack(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.currentTrackMsid != Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
         {
            return;
         }
         if(Boolean(Peripheral.audioManager.isSourceMediaService()) && Boolean(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source)))
         {
            if(Peripheral.mediaPlayer.currentTrack > 0 && Peripheral.mediaPlayer.playPath.itemCount > 0)
            {
               if(Boolean(Peripheral.audioManager.isSourceUSB()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SDCARD)
               {
                  t(this.assets.track_group.songnumber,[T.STRB_X_OF_Y,Peripheral.mediaPlayer.currentTrack.toString(),Peripheral.mediaPlayer.playPath.itemCount.toString()]);
                  this.assets.track_group.songnumber.visible = true;
               }
               else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
               {
                  if(Peripheral.mediaPlayer.playPath.itemCount > 0)
                  {
                     t(this.assets.track_group.songnumber,[T.STRB_X_OF_Y,Peripheral.mediaPlayer.currentTrack.toString(),Peripheral.mediaPlayer.playPath.itemCount.toString()]);
                     this.assets.track_group.songnumber.visible = true;
                  }
               }
            }
            else
            {
               this.assets.track_group.songnumber.visible = false;
               this.clearPlayTimeInfo();
            }
            this.onTrackInfo(null);
            this.onTracksTimer(null);
         }
      }
      
      private function onTrackInfo(e:MediaPlayerEvent) : void
      {
         var artist:String = null;
         var title:String = null;
         var album:String = null;
         var composer:String = null;
         var genre:String = null;
         var year:String = null;
         if(Boolean(Peripheral.audioManager.isSourceMediaService()) && Boolean(Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source)))
         {
            artist = "";
            title = "";
            album = "";
            composer = "";
            genre = "";
            year = "";
            if(Peripheral.mediaPlayer.currentTrack >= 1)
            {
               t(this.assets.info.trackvalue,[T.STRB_X_OF_Y,Peripheral.mediaPlayer.currentTrack.toString(),Peripheral.mediaPlayer.playPath.itemCount.toString()],TRUNCATE_WORDS);
            }
            else
            {
               t(this.assets.info.trackvalue,T.STRB_UNKNOWN);
            }
            if(Peripheral.mediaPlayer.currentTrackInfo)
            {
               if(Peripheral.mediaPlayer.currentTrackInfo.msid != Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  return;
               }
               if(e != null && this.assets.splitview.info_button.visible == false || this.onEnableForAutoPlayOff() == true)
               {
                  this.enableFunctionality();
                  this.mAutoPlayOff = false;
                  this.showSplitScreen();
               }
               artist = Peripheral.mediaPlayer.currentTrackInfo.artist;
               album = Peripheral.mediaPlayer.currentTrackInfo.album;
               composer = Peripheral.mediaPlayer.currentTrackInfo.composer;
               genre = Peripheral.mediaPlayer.currentTrackInfo.genre;
               artist = artist == MediaPlayerTrackInfo.WILDCARD_UNKNOWN || artist == "" ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : artist;
               album = album == MediaPlayerTrackInfo.WILDCARD_UNKNOWN || album == "" ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : album;
               composer = composer == MediaPlayerTrackInfo.WILDCARD_UNKNOWN || composer == "" ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : composer;
               genre = genre == MediaPlayerTrackInfo.WILDCARD_UNKNOWN || genre == "" ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : genre;
               year = Peripheral.mediaPlayer.currentTrackInfo.year <= 0 ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : Peripheral.mediaPlayer.currentTrackInfo.year.toString();
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
               {
                  if(Peripheral.mediaPlayer.currentDevice != null)
                  {
                     if(Peripheral.mediaPlayer.currentTrackInfo.title == "Bluetooth" || Peripheral.mediaPlayer.currentTrackInfo.title == "")
                     {
                        title = Peripheral.mediaPlayer.currentDevice.name == "" ? Peripheral.localeEngine.getText(T.STRB_BLUETOOTH_BREADCRUMB) : Peripheral.mediaPlayer.currentDevice.name;
                     }
                     else
                     {
                        title = Peripheral.mediaPlayer.currentTrackInfo.title;
                     }
                  }
               }
               else if(Peripheral.mediaPlayer.currentTrackInfo.title == "" || Peripheral.mediaPlayer.currentTrackInfo.title == MediaPlayerTrackInfo.WILDCARD_UNKNOWN)
               {
                  title = this.removeFileTypeFromString(Peripheral.mediaPlayer.currentTrackInfo.filename);
               }
               else
               {
                  title = Peripheral.mediaPlayer.currentTrackInfo.title;
               }
            }
            else
            {
               artist = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
               title = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
               album = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
               composer = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
               genre = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
               year = Peripheral.localeEngine.getText(T.STRB_UNKNOWN);
            }
            if(title == "" || Boolean(Peripheral.audioManager.getSourceType() && Peripheral.mediaPlayer.currentDevice) && Boolean(Peripheral.audioManager.getSourceType() != Peripheral.mediaPlayer.currentDevice.type))
            {
               return;
            }
            this.setMetaData(album,title,artist);
            this.assets.info.artistvalue.text = artist;
            this.assets.info.titlevalue.text = title;
            this.assets.info.albumvalue.text = album;
            this.assets.info.composervalue.text = composer;
            this.assets.info.genrevalue.text = genre;
            this.assets.info.yearvalue.text = year;
            Format.truncateCharactersForMediaBrowse(this.assets.info.artistvalue);
            Format.truncateCharactersForMediaBrowse(this.assets.info.titlevalue);
            Format.truncateCharactersForMediaBrowse(this.assets.info.albumvalue);
            Format.truncateCharactersForMediaBrowse(this.assets.info.composervalue);
            Format.truncateCharactersForMediaBrowse(this.assets.info.genrevalue);
            Format.truncateCharactersForMediaBrowse(this.assets.info.yearvalue);
         }
      }
      
      private function onCurrentAlbumArtPath(e:MediaPlayerEvent) : void
      {
         var currentAlbumArtPath:String = Peripheral.mediaPlayer.currentAlbumArtPath;
         if(Peripheral.mediaPlayer.currentAlbumArtMSID != Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
         {
            currentAlbumArtPath = null;
         }
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_AUX)
         {
            this.onAlbumArt(currentAlbumArtPath);
         }
      }
      
      private function onMediaUnplayable(e:MediaPlayerEvent) : void
      {
         this.resetFunctionality();
         this.onMediaError(null);
         Peripheral.mediaPlayer.deSelectActiveDevice();
      }
      
      private function onMediaError(e:MediaPlayerEvent) : void
      {
         this.mMediaErrorSource = Peripheral.audioManager.source;
         this.mMediaErrorSourceMSId = Peripheral.audioManager.getMSIdForSource(this.mMediaErrorSource);
         if(this.mMediaErrorSourceMSId != -1 && Peripheral.mediaPlayer.mediaErrorMSID() != this.mMediaErrorSourceMSId)
         {
            return;
         }
         if(Peripheral.mediaPlayer.mediaErrorMSID() == this.mMediaErrorSourceMSId)
         {
            switch(Peripheral.mediaPlayer.mediaErrorCode())
            {
               case MediaErrorCodes.MEDIA_DEVICE_UNPLAYABLE:
               case MediaErrorCodes.MEDIA_FILES_CORRUPTED:
               case MediaErrorCodes.MEDIA_DEVICE_EMPTY:
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DEVICE_UNPLAYABLE));
                  Peripheral.mediaPlayer.deSelectActiveDevice();
                  break;
               case MediaErrorCodes.MEDIA_FILES_NOT_SUPPORTED:
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.setError(Peripheral.localeEngine.getText(T.STRB_FILES_NOT_SUPPORTED_1L));
                  Peripheral.mediaPlayer.deSelectActiveDevice();
                  break;
               case MediaErrorCodes.TRACK_SESSION_UNPLAYABLE:
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.assets.browse_button.setEnabled(true);
                  this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_TRACK_UNPLAYABLE));
                  break;
               case MediaErrorCodes.UNEXPECTED_STOP_WITH_ERROR:
                  this.clearMetaDataFields();
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.assets.browse_button.setEnabled(true);
                  this.setError(Peripheral.localeEngine.getText(T.STRB_MEDIA_FILE_READING_ERROR));
                  break;
               case MediaErrorCodes.UNEXPECTED_STOP:
                  this.clearMetaDataFields();
                  this.resetFunctionality();
                  this.assets.audio_button.setEnabled(false);
                  this.assets.browse_button.setEnabled(true);
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYBACK_STOPPED));
            }
            return;
         }
      }
      
      private function onPlayItems(e:MediaPlayerEvent) : void
      {
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            this.assets.tracks_group.tracks_list.setData(e.data);
         }
      }
      
      private function onPlayPath(e:MediaPlayerEvent) : void
      {
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            if(this.assets.tracks_group.tracks_list.getLength() != Peripheral.mediaPlayer.playPath.itemCount || Peripheral.mediaPlayer.playPath.itemCount == 0)
            {
               this.assets.tracks_group.tracks_list.setLength(0);
               this.showSplitScreen();
            }
         }
      }
      
      private function onRSERepeatStatus(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.repeatstatus == "off")
            {
               this.assets.repeatsm_button.setHighlight(false);
               this.assets.repeatlg_button.setHighlight(false);
            }
            else if(Peripheral.rse.repeatstatus == "on")
            {
               this.assets.repeatsm_button.setHighlight(true);
               this.assets.repeatlg_button.setHighlight(true);
            }
         }
      }
      
      private function onRSEShuffleStatus(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.shufflestatus == "off")
            {
               this.assets.shufflesm_button.setHighlight(false);
               this.assets.shufflelg_button.setHighlight(false);
            }
            else if(Peripheral.rse.shufflestatus == "on")
            {
               this.assets.shufflesm_button.setEnabled(true);
               this.assets.shufflelg_button.setEnabled(true);
               this.assets.shufflesm_button.setHighlight(true);
               this.assets.shufflelg_button.setHighlight(true);
            }
         }
      }
      
      private function onRSEPlayTime(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.startDiscPlayStatus)
            {
               if(Peripheral.rse.rseplaytime <= Peripheral.rse.rseplayduration)
               {
                  if(Peripheral.rse.rseplayduration != mView.track_group.playhead_scroller.getMaximum())
                  {
                     this.assets.track_group.playhead_scroller.setMaximum(Peripheral.rse.rseplayduration);
                  }
                  this.assets.track_group.timeduration.text = Format.timeDelta(Peripheral.rse.rseplaytime) + " / " + Format.timeDelta(Peripheral.rse.rseplayduration);
                  this.setScrollerProgress(Peripheral.rse.rseplaytime);
                  this.assets.track_group.timeduration.visible = true;
               }
            }
         }
      }
      
      private function onRSEActivateBrowse(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Boolean(Peripheral.rse.listSyncStatus) && Peripheral.rse.dvdoutstatstatus != RSEConstants.MD_STOP)
            {
               this.assets.browse_button.setEnabled(true);
               this.assets.splitview.tracks_button.setEnabled(true);
               this.showSplitScreen();
            }
            else
            {
               this.assets.browse_button.setEnabled(false);
               this.assets.splitview.tracks_button.setEnabled(false);
               this.showSplitScreen();
            }
         }
      }
      
      private function onRSECurrentTrack(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && !this.onRSEDiscError())
         {
            if(Peripheral.rse.startDiscPlayStatus)
            {
               if(Peripheral.rse.no_of_records <= 0 && int(Peripheral.rse.rseCurrentTrackNumber) != 0)
               {
                  t(this.assets.track_group.songnumber,Peripheral.rse.rseCurrentTrackNumber);
               }
               else
               {
                  t(this.assets.track_group.songnumber,[T.STRB_X_OF_Y,Peripheral.rse.rseCurrentTrackNumber,Peripheral.rse.no_of_records.toString()]);
               }
               this.assets.track_group.songnumber.visible = true;
               this.onRSETrackInfo(null);
               this.updateTracksView();
            }
         }
      }
      
      private function onRSETrackInfo(e:RseEvent) : void
      {
         var artist:String = null;
         var title:String = null;
         var album:String = null;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && !this.onRSEDiscError())
         {
            if(Peripheral.rse.no_of_records == 0 && int(Peripheral.rse.rseCurrentTrackNumber) != 0)
            {
               this.assets.info.trackvalue.text = Peripheral.rse.rseCurrentTrackNumber;
            }
            else
            {
               t(this.assets.info.trackvalue,[T.STRB_X_OF_Y,Peripheral.rse.rseCurrentTrackNumber,Peripheral.rse.no_of_records.toString()],TRUNCATE_WORDS);
            }
            artist = Peripheral.rse.rseCurrentArtist == "" || Peripheral.rse.rseCurrentArtist == null ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : Peripheral.rse.rseCurrentArtist;
            title = Peripheral.rse.rseCurrentTrackName == "" || Peripheral.rse.rseCurrentTrackName == null ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : Peripheral.rse.rseCurrentTrackName;
            album = Peripheral.rse.rseCurrentAlbum == "" || Peripheral.rse.rseCurrentAlbum == null ? Peripheral.localeEngine.getText(T.STRB_UNKNOWN) : Peripheral.rse.rseCurrentAlbum;
            this.setMetaData(album,title,artist);
            Format.truncateCharacters(this.assets.info.albumvalue,album);
            Format.truncateCharacters(this.assets.info.artistvalue,artist);
            Format.truncateCharacters(this.assets.info.titlevalue,title);
            Format.truncateCharacters(this.assets.info.composervalue,Peripheral.localeEngine.getText(T.STRB_UNKNOWN));
            Format.truncateCharacters(this.assets.info.genrevalue,Peripheral.localeEngine.getText(T.STRB_UNKNOWN));
            Format.truncateCharacters(this.assets.info.yearvalue,Peripheral.localeEngine.getText(T.STRB_UNKNOWN));
         }
      }
      
      private function onRSEFullScreenButtonStatus(e:RseEvent) : void
      {
         if(Boolean(Peripheral.audioManager.isSourceRSE()) || Boolean(Peripheral.rse.startDiscPlayStatus))
         {
            if(Peripheral.rse.rearSource == Peripheral.audioManager.source)
            {
               if(Peripheral.rse.fullScreenButtonPresent)
               {
                  this.assets.splitview.fullscreen_button.visible = true;
                  this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut && !Peripheral.rse.getVideoLockoutStatus);
                  this.assets.repeatsm_button.setEnabled(false);
                  this.assets.shufflesm_button.setEnabled(false);
               }
               else
               {
                  this.assets.splitview.fullscreen_button.visible = false;
               }
            }
         }
         Framework.focusManager.refresh();
      }
      
      private function onRSEVideoLockoutStatus(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.getVideoLockoutStatus == true)
            {
               this.assets.splitview.fullscreen_button.setEnabled(false);
            }
            else
            {
               this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut);
            }
         }
      }
      
      private function onRSECurrentTrackLength(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(this.assets.track_group.playhead_scroller.getMaximum() != Peripheral.rse.rsecurrentTrackLength)
            {
               this.assets.track_group.playhead_scroller.setMaximum(Peripheral.rse.rsecurrentTrackLength);
            }
         }
      }
      
      private function onRSEDiscError() : Boolean
      {
         var returnVal:Boolean = false;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_ERROR)
            {
               switch(Peripheral.rse.dvdDiscStatValue)
               {
                  case RSEConstants.DISC_HOT_ERROR:
                     this.setError(Text.compose([T.STRB_ERROR_MEDIA_COOL_DOWN,"\n",T.STRB_ERROR_MEDIA_DISC_HOT]));
                     returnVal = true;
                     break;
                  case RSEConstants.DISC_CANNOT_READ_ERROR:
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_CANNOT_READ));
                     returnVal = true;
                     break;
                  case RSEConstants.DISC_READ_ERROR:
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_READ_ERROR));
                     returnVal = true;
                     break;
                  case RSEConstants.DISC_GENERIC_ERROR:
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DISC_ERROR));
                     returnVal = true;
                     break;
                  case RSEConstants.DVD_MD_UNKNOWN:
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DISC_ERROR));
                     returnVal = true;
                     break;
                  case RSEConstants.DISC_REGION_CODE_MISMATCH:
                     this.setError("DVD Region Code Mismatch");
                     returnVal = true;
                     break;
                  case RSEConstants.DISC_REGION_CODE_NOT_PROGRAMMED:
                     this.setError("DVD Region Code Not Programmed");
                     returnVal = true;
                     break;
                  default:
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DISC_ERROR));
                     returnVal = true;
               }
            }
            else
            {
               returnVal = false;
            }
         }
         return returnVal;
      }
      
      private function onRSEDiscStat(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_CD_AUDIO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_MP3)
            {
               this.assets.splitview.fullscreen_button.visible = false;
            }
            else if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_DVD_VIDEO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_MD_BD_VIDEO || Peripheral.rse.dvdDiscStatValue == RSEConstants.MECH_NP)
            {
               this.assets.splitview.info_button.setEnabled(false);
               this.showSplitScreen();
            }
            if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_EJECT)
            {
               if(Peripheral.audioManager.lastMediaSource == Peripheral.audioManager.SOURCE_CD)
               {
                  this.resetFunctionality();
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_INSERT_DISC));
               }
            }
            this.onRSEDiscError();
         }
         Framework.focusManager.refresh();
      }
      
      private function onRSEDVDOutState(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_LOAD)
            {
               this.resetFunctionality();
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_LOADING_MEDIA));
               Peripheral.rse.resetDiscCurrentTrackName();
            }
            else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_READ)
            {
               this.resetFunctionality();
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_READING_MEDIA));
            }
            else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_ERROR)
            {
               this.onRSEDiscError();
            }
            else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_EJECT)
            {
               this.resetFunctionality();
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_EJECTING_MEDIA));
               Peripheral.rse.setstartDiscPlayStatus(false);
            }
            if(Peripheral.rse.dvdoutstatstatus == RSEConstants.DISC_PAUSED || Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_PAUSE)
            {
               this.assets.playpause_button.icon.gotoAndStop("pause");
               this.onAlbumArt(this.mArtPathDefault);
            }
            else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.DISC_PLAYING || Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_PLAY)
            {
               mView.playpause_button.setEnabled(true);
               mView.seekbackward_button.setEnabled(true);
               mView.seekforward_button.setEnabled(true);
               if(Boolean(Peripheral.audioManager.isSourceUSB(Peripheral.audioManager.source)) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SDCARD || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
               {
                  this.assets.splitview.tracks_button.visible = true;
                  this.assets.splitview.info_button.visible = true;
                  if(!Peripheral.rse.fullScreenButtonPresent)
                  {
                     this.assets.repeatsm_button.setEnabled(true);
                     this.assets.shufflesm_button.setEnabled(true);
                  }
                  this.assets.repeatlg_button.setEnabled(true);
                  this.assets.shufflelg_button.setEnabled(true);
               }
               if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_DVD_VIDEO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_MD_BD_VIDEO)
               {
                  this.assets.browse_button.visible = false;
                  this.assets.stop_button.visible = true;
                  this.assets.stop_button.setEnabled(true);
                  this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut);
                  this.assets.splitview.tracks_button.setEnabled(Peripheral.rse.listSyncStatus);
                  this.assets.track_group.playhead_scroller.visible = true;
               }
               this.assets.playpause_button.icon.gotoAndStop("play");
               if(Peripheral.rse.rseCurrentTrackName.length == 0 && Peripheral.rse.rseCurrentArtist.length == 0 && Peripheral.rse.rseCurrentAlbum.length == 0)
               {
                  this.onAlbumArt(this.mArtPathDefault);
                  this.setMetaData();
               }
            }
            else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_STOP)
            {
               this.assets.playpause_button.icon.gotoAndStop("pause");
               this.showRSEStop();
            }
         }
         Framework.focusManager.refresh();
      }
      
      private function onRSEStartDiscPlayStatus(e:RseEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            this.clearMetaDataFields();
            this.assets.splitview.fullscreen_button.visible = Peripheral.rse.fullScreenButtonPresent;
            this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut && !Peripheral.rse.getVideoLockoutStatus);
            this.assets.playpause_button.setEnabled(true);
            this.assets.seekbackward_button.setEnabled(true);
            this.assets.seekforward_button.setEnabled(true);
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD && (Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_DVD_VIDEO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_MD_BD_VIDEO))
            {
               this.assets.splitview.info_button.setEnabled(false);
               this.showSplitScreen();
            }
            else
            {
               this.assets.splitview.info_button.setEnabled(true);
               this.showSplitScreen();
            }
            if(!this.onRSEDiscError())
            {
               Peripheral.rse.getCurrentTrackInfo();
            }
            if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_CD_AUDIO || Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_MP3 || Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_WMA)
            {
               this.assets.repeatsm_button.setEnabled(true);
               this.assets.shufflesm_button.setEnabled(true);
               this.assets.repeatlg_button.setEnabled(true);
               this.assets.shufflelg_button.setEnabled(true);
            }
            this.onRSEActivateBrowse(null);
         }
      }
      
      private function onRSEBrowseItems(e:RseEvent) : void
      {
         var _list:MediaPlayerItemList = null;
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            _list = MediaPlayerItemList(Peripheral.rse.browseListData);
            this.assets.tracks_group.tracks_list.setData(_list);
         }
      }
      
      private function setupTrackList() : void
      {
         var _length:int = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD ? int(Peripheral.mediaPlayer.playPath.itemCount) : int(Peripheral.rse.no_of_records);
         this.assets.tracks_group.tracks_scroller.setMaximum(_length);
         this.assets.tracks_group.tracks_list.setLength(_length);
         this.onTracksTimer(null);
      }
      
      private function onTracksListPosition(e:WidgetEvent) : void
      {
         this.mTracksManual = true;
         this.mTracksTimer.reset();
         this.mTracksTimer.start();
      }
      
      private function onTracksTimer(e:TimerEvent) : void
      {
         this.mTracksTimer.reset();
         this.mTracksManual = false;
         this.updateTracksView();
      }
      
      private function onTrackListSelect(e:WidgetEvent) : void
      {
         var data:MediaPlayerPath = null;
         Peripheral.mediaPlayer.setRepeatMode(MediaPlayerRepeatMode.ALL);
         var _item:MediaPlayerItem = e.data.data;
         if(Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD)
         {
            data = new MediaPlayerPath();
            data.path = MediaPlayerPath.ITEM + _item.id;
            data.type = _item.type;
            Peripheral.mediaPlayer.setBrowsePath(data);
            Peripheral.appStateManager.splitScreenSource = "none";
            this.showSplitScreen();
         }
         else
         {
            Peripheral.rse.playItem(_item.id);
            Peripheral.appStateManager.splitScreenSource = "none";
            this.showSplitScreen();
         }
      }
      
      private function getPlayItems(start:int, end:int) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Peripheral.rse.getBrowseItems(start,end);
         }
         else
         {
            Peripheral.mediaPlayer.getPlayItems(start,++end - start);
         }
      }
      
      protected function changeSelection(_row:MovieClip, _highlighted:Boolean) : void
      {
         _row.row_button.setSelected(_highlighted);
      }
      
      private function updateTracksView() : void
      {
         var _firstItem:int = 0;
         if(!this.mTracksManual)
         {
            if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
            {
               _firstItem = Number(Peripheral.rse.rseCurrentTrackNumber) - 2;
            }
            else
            {
               _firstItem = Peripheral.mediaPlayer.currentTrack - 2;
            }
            if(_firstItem < 0)
            {
               this.assets.tracks_group.tracks_list.setPosition(0);
               this.assets.tracks_group.tracks_list.setCursor(0);
            }
            else
            {
               this.assets.tracks_group.tracks_list.setPosition(_firstItem);
               this.assets.tracks_group.tracks_list.setCursor(_firstItem + 1);
            }
            this.assets.tracks_group.tracks_list.update();
         }
      }
      
      private function updateRow(row:MovieClip, rowIndex:int, data:MediaPlayerItem, dataIndex:int) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(data != null)
            {
               row.visible = true;
               if(LocaleArchive.getInstance().isMirrored())
               {
                  Text.format(row.row_button.name_label,Text.rightToLeft(data.name) ? dataIndex + 1 + ". " + data.name : data.name + " ." + (dataIndex + 1));
               }
               else
               {
                  Text.format(row.row_button.name_label,Text.rightToLeft(data.name) ? data.name + " ." + (dataIndex + 1) : dataIndex + 1 + ". " + data.name);
               }
               row.id = data.id;
               row.type = "song";
               row.itemName = data.name;
               row.row_button.playIcon.visible = dataIndex == Number(Peripheral.rse.rseCurrentTrackNumber) - 1;
            }
            else if(rowIndex >= this.assets.tracks_group.tracks_list.getLength())
            {
               row.visible = false;
            }
         }
         else if(data != null)
         {
            row.visible = true;
            if(LocaleArchive.getInstance().isMirrored())
            {
               Text.format(row.row_button.name_label,Text.rightToLeft(data.name) ? dataIndex + 1 + ". " + data.name : data.name + " ." + (dataIndex + 1));
            }
            else
            {
               Text.format(row.row_button.name_label,Text.rightToLeft(data.name) ? data.name + " ." + (dataIndex + 1) : dataIndex + 1 + ". " + data.name);
            }
            row.id = data.id;
            row.type = data.type;
            row.itemName = data.name;
            row.row_button.playIcon.visible = dataIndex == Peripheral.mediaPlayer.currentTrack - 1;
         }
         else if(rowIndex >= this.assets.tracks_group.tracks_list.getLength())
         {
            row.visible = false;
         }
      }
      
      private function onAlbumArt(_path:String) : void
      {
         this.closeArtLoader();
         if(System.freeMemory < 1500000)
         {
            System.gc();
         }
         this.mArtPath = _path ? _path : this.mArtPathDefault;
         try
         {
            this.mArtLoader.load(new URLRequest(this.mArtPath));
         }
         catch(err:Error)
         {
         }
      }
      
      private function onAlbumArtLoaded(e:Event) : void
      {
         var matrix:Matrix = null;
         if(!this.isAlbumArtAccurate(e.currentTarget.url))
         {
            return;
         }
         this.removeOldArtwork();
         if(this.mArtReflection)
         {
            this.mArtReflection.bitmapData.dispose();
            this.mArtScaled.bitmapData.dispose();
            this.mArtReflection = null;
            this.mArtScaled = null;
         }
         var mArtReflectionY:int = 0;
         this.mArtScaled = new Bitmap(e.target.content.bitmapData);
         this.mArtScaled.width = this.assets.ALBUM_ART_WIDTH;
         this.mArtScaled.scaleY = this.mArtScaled.scaleX;
         this.mArtScaled.y = this.assets.ALBUM_ART_HEIGHT - this.mArtScaled.height;
         this.mArtScaled.smoothing = true;
         this.mArtLoader.unloadAndStop(true);
         mArtReflectionY = this.mArtScaled.y + this.mArtScaled.height + 5;
         this.mArtReflection = new Bitmap(this.mArtScaled.bitmapData.clone());
         this.mArtReflection.width = this.assets.ALBUM_ART_WIDTH;
         this.mArtReflection.scaleY = -this.mArtScaled.scaleY;
         this.mArtReflection.y = mArtReflectionY + this.mArtReflection.height;
         if(!this.mArtGradientMask)
         {
            this.mArtGradientMask = new Sprite();
            matrix = new Matrix();
            matrix.createGradientBox(this.assets.ALBUM_ART_WIDTH,this.mArtReflection.height,90 / 180 * Math.PI,0,0);
            this.mArtGradientMask.graphics.beginGradientFill(GradientType.LINEAR,[16777215,16777215],[0.3,0],[0,100],matrix);
            this.mArtGradientMask.graphics.drawRect(0,0,this.assets.ALBUM_ART_WIDTH,this.mArtReflection.height);
            this.mArtGradientMask.y = mArtReflectionY;
         }
         this.mArtScaled.cacheAsBitmap = true;
         this.mArtGradientMask.cacheAsBitmap = true;
         this.mArtReflection.cacheAsBitmap = true;
         this.assets.textFull.artwork.addChild(this.mArtScaled);
         this.assets.textFull.artwork.addChild(this.mArtReflection);
         this.assets.textFull.artwork.addChild(this.mArtGradientMask);
         this.mArtReflection.mask = this.mArtGradientMask;
         this.assets.textFull.artwork.visible = true;
      }
      
      private function onAlbumArtIOError(e:IOErrorEvent) : void
      {
         if(this.mArtPath == this.mArtPathDefault)
         {
            this.removeOldArtwork();
         }
         else
         {
            try
            {
               this.mArtPath = this.mArtPathDefault;
               this.mArtLoader.load(new URLRequest(this.mArtPath));
            }
            catch(err:Error)
            {
            }
         }
      }
      
      private function onSpeedLockOut(e:VehicleStatusEvent) : void
      {
         this.assets.splitview.fullscreen_button.setEnabled(!Peripheral.vehicleStatus.speedLockOut && !Peripheral.rse.getVideoLockoutStatus);
      }
      
      public function onICSSelectBrowse(e:HardControlEvent) : void
      {
         if(!this.assets.tracks_group.visible && Peripheral.bluetoothPhone.getRingingCall() == null)
         {
            e.stopImmediatePropagation();
            if(Boolean(this.assets.browse_button.visible) && Boolean(this.assets.browse_button.mEnabled))
            {
               this.onBrowseClick(null);
            }
         }
      }
      
      private function setMetaData(_album:String = "", _title:String = "", _artist:String = "") : void
      {
         this.assets.textFull.error.text = "";
         this.assets.textFull.album.text = _album;
         this.assets.textFull.title.text = _title;
         this.assets.textFull.artist.text = _artist;
         this.assets.textSplit.album.text = _album;
         this.assets.textSplit.title.text = _title;
         this.assets.textSplit.artist.text = _artist;
         Format.truncateCharactersForMediaBrowse(this.assets.textFull.album);
         Format.truncateCharactersForMediaBrowse(this.assets.textFull.title);
         Format.truncateCharactersForMediaBrowse(this.assets.textFull.artist);
         Format.truncateCharactersForMediaBrowse(this.assets.textSplit.album);
         Format.truncateCharactersForMediaBrowse(this.assets.textSplit.title);
         Format.truncateCharactersForMediaBrowse(this.assets.textSplit.artist);
      }
      
      private function setError(_text:String) : void
      {
         Text.format(this.assets.textFull.error,_text);
         Text.format(this.assets.textSplit.title,_text);
         if(this.assets.textFull.error.numLines > 1)
         {
            this.assets.textFull.error.y = this.assets.TWOLINE_ERROR;
         }
         else
         {
            this.assets.textFull.error.y = this.assets.ONELINE_ERROR;
         }
      }
      
      private function removeOldArtwork() : void
      {
         while(this.assets.textFull.artwork.numChildren > 0)
         {
            this.assets.textFull.artwork.removeChildAt(0);
         }
      }
      
      private function isAlbumArtAccurate(_path:String) : Boolean
      {
         var _loadedPath:String = _path.substring(_path.lastIndexOf("/"));
         var _correctPath:String = Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source) ? this.mArtPath : this.mArtPathDefault;
         _correctPath = _correctPath.substring(_correctPath.lastIndexOf("/"));
         return _loadedPath == _correctPath;
      }
      
      private function closeArtLoader() : void
      {
         try
         {
            this.mArtLoader.close();
         }
         catch(err:Error)
         {
         }
      }
      
      private function removeFileTypeFromString(fileName:String) : String
      {
         var dotLocation:int = fileName.lastIndexOf(".");
         if(dotLocation > 0)
         {
            return fileName.substring(0,dotLocation);
         }
         return fileName;
      }
      
      private function setCurrentSourceIndex() : void
      {
         var i:int = 0;
         var _index:int = 0;
         var _page:int = this.assets.sources.numChildren - 1;
         var _sources:Vector.<String> = Peripheral.audioManager.mediaSources;
         if(_sources.length > this.assets.sources.numChildren)
         {
            for(i = 0; i < _sources.length; i++)
            {
               if(Peripheral.audioManager.lastMediaSource == _sources[i])
               {
                  this.mIndexSource = i - i % _page;
                  return;
               }
            }
         }
         else
         {
            this.mIndexSource = 0;
         }
      }
      
      private function clearMetaDataFields() : void
      {
         this.onAlbumArt(this.mArtPathDefault);
         this.assets.textFull.album.text = "";
         this.assets.textFull.title.text = "";
         this.assets.textFull.artist.text = "";
         this.assets.textFull.error.text = "";
         this.assets.textSplit.album.text = "";
         this.assets.textSplit.title.text = "";
         this.assets.textSplit.artist.text = "";
      }
      
      private function resetFunctionality() : void
      {
         this.onAlbumArt(this.mArtPathDefault);
         this.assets.stop_button.visible = false;
         this.assets.browse_button.visible = true;
         this.assets.textFull.hdmi.visible = false;
         this.assets.splitview.info_button.visible = false;
         this.assets.splitview.tracks_button.visible = false;
         this.assets.splitview.fullscreen_button.visible = false;
         this.assets.splitview.setup_button.visible = false;
         this.assets.track_group.songnumber.visible = false;
         this.assets.track_group.timeduration.visible = false;
         this.assets.track_group.playhead_scroller.visible = false;
         this.disableFunctionality();
         Framework.focusManager.refresh();
      }
      
      private function resetFunctionalityForAutoplayOff() : void
      {
         this.onAlbumArt(this.mArtPathDefault);
         this.assets.stop_button.visible = false;
         this.assets.browse_button.visible = true;
         this.assets.textFull.hdmi.visible = false;
         this.assets.splitview.info_button.visible = true;
         this.assets.splitview.tracks_button.visible = true;
         this.assets.splitview.fullscreen_button.visible = false;
         this.assets.splitview.setup_button.visible = false;
         this.assets.track_group.songnumber.visible = false;
         this.assets.track_group.timeduration.visible = false;
         this.assets.track_group.playhead_scroller.thumb.visible = false;
         this.clearPlayTimeInfo();
         this.disableFunctionalityForAutoplayOff();
         Framework.focusManager.refresh();
      }
      
      private function disableFunctionalityForAutoplayOff() : void
      {
         this.clearMetaDataFields();
         this.assets.splitview.info_button.setEnabled(false);
         this.assets.splitview.tracks_button.setEnabled(false);
         this.assets.splitview.fullscreen_button.setEnabled(false);
         this.assets.repeatsm_button.setEnabled(false);
         this.assets.shufflesm_button.setEnabled(false);
         this.assets.repeatlg_button.setEnabled(false);
         this.assets.shufflelg_button.setEnabled(false);
         this.assets.seekbackward_button.setEnabled(false);
         this.assets.seekforward_button.setEnabled(false);
         this.assets.stop_button.setEnabled(false);
         this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
         this.assets.audio_button.setEnabled(true);
         if(this.mAutoPlayOff)
         {
            this.assets.playpause_button.icon.gotoAndStop("pause");
            this.assets.playpause_button.setEnabled(true);
         }
         else
         {
            this.assets.playpause_button.setEnabled(false);
         }
         if(Peripheral.appStateManager.splitScreenSource != "map" && Peripheral.audioSettings.audioAutoPlayStatus == "off")
         {
            Peripheral.appStateManager.splitScreenSource = "none";
         }
         this.showSplitScreen();
      }
      
      private function disableFunctionality() : void
      {
         this.clearMetaDataFields();
         this.assets.splitview.info_button.setEnabled(false);
         this.assets.splitview.tracks_button.setEnabled(false);
         this.assets.splitview.fullscreen_button.setEnabled(false);
         this.assets.repeatsm_button.setEnabled(false);
         this.assets.shufflesm_button.setEnabled(false);
         this.assets.repeatlg_button.setEnabled(false);
         this.assets.shufflelg_button.setEnabled(false);
         this.assets.playpause_button.setEnabled(false);
         this.assets.seekbackward_button.setEnabled(false);
         this.assets.seekforward_button.setEnabled(false);
         this.assets.stop_button.setEnabled(false);
         this.assets.browse_button.setEnabled(false);
         this.showSplitScreen();
      }
      
      private function enableFunctionality() : void
      {
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
               this.assets.track_group.songnumber.visible = true;
               if(Peripheral.mediaPlayer.playTime >= 0 && Boolean(Peripheral.mediaPlayer.playDuration))
               {
                  this.assets.track_group.timeduration.visible = true;
                  this.assets.track_group.playhead_scroller.visible = true;
               }
               this.assets.splitview.info_button.visible = true;
               this.assets.splitview.tracks_button.visible = true;
               this.assets.splitview.setup_button.visible = false;
               this.assets.splitview.info_button.setEnabled(true);
               if(!this.mAutoPlayOff)
               {
                  this.assets.audio_button.setEnabled(true);
               }
               this.assets.splitview.tracks_button.setEnabled(true);
               this.assets.repeatsm_button.setEnabled(true);
               this.assets.shufflesm_button.setEnabled(true);
               this.assets.repeatlg_button.setEnabled(true);
               this.assets.shufflelg_button.setEnabled(true);
               if(Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
               }
               this.assets.playpause_button.setEnabled(true);
               this.assets.seekbackward_button.setEnabled(true);
               this.assets.seekforward_button.setEnabled(true);
               this.assets.repeatsm_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflesm_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.assets.repeatlg_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflelg_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               break;
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
            case Peripheral.audioManager.SOURCE_SDCARD:
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               if(Peripheral.mediaPlayer.playPath.itemCount > 0)
               {
                  this.assets.track_group.songnumber.visible = true;
               }
               if(Peripheral.mediaPlayer.playTime >= 0 && Boolean(Peripheral.mediaPlayer.playDuration))
               {
                  this.assets.track_group.timeduration.visible = true;
                  this.assets.track_group.playhead_scroller.visible = true;
               }
               this.assets.track_group.playhead_scroller.thumb.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.info_button.visible = true;
               this.assets.splitview.tracks_button.visible = Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.setup_button.visible = Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH;
               this.assets.splitview.fullscreen_button.visible = false;
               this.assets.stop_button.visible = false;
               this.assets.splitview.info_button.setEnabled(true);
               this.assets.audio_button.setEnabled(true);
               this.assets.splitview.tracks_button.setEnabled(true);
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH && (!Peripheral.mediaPlayer.RepeatDeviceSupport && !Peripheral.mediaPlayer.RandomDeviceSupport))
               {
                  this.assets.repeatsm_button.setEnabled(false);
                  this.assets.shufflesm_button.setEnabled(false);
                  this.assets.repeatlg_button.setEnabled(false);
                  this.assets.shufflelg_button.setEnabled(false);
               }
               else
               {
                  this.assets.repeatsm_button.setEnabled(true);
                  this.assets.shufflesm_button.setEnabled(true);
                  this.assets.repeatlg_button.setEnabled(true);
                  this.assets.shufflelg_button.setEnabled(true);
               }
               if(Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source))
               {
                  this.assets.browse_button.setEnabled(Peripheral.mediaPlayer.readyToBrowse);
               }
               this.assets.playpause_button.setEnabled(true);
               this.assets.seekbackward_button.setEnabled(true);
               this.assets.seekforward_button.setEnabled(true);
               this.assets.repeatsm_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflesm_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.assets.repeatlg_button.setHighlight(Peripheral.mediaPlayer.repeatMode == MediaPlayerRepeatMode.SONG);
               this.assets.shufflelg_button.setHighlight(Peripheral.mediaPlayer.randomMode != MediaPlayerRandomMode.OFF);
               this.onDeviceCapability(null);
         }
      }
      
      private function showNotAvailableMessage() : void
      {
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_CD:
               if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_LOAD)
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_LOADING_MEDIA));
               }
               else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_READ)
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_READING_MEDIA));
               }
               else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_ERROR)
               {
                  if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_HOT_ERROR)
                  {
                     this.setError(Text.compose([T.STRB_ERROR_MEDIA_COOL_DOWN,"\n",T.STRB_ERROR_MEDIA_DISC_HOT]));
                  }
                  else if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_CANNOT_READ_ERROR)
                  {
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_CANNOT_READ));
                  }
                  else if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_READ_ERROR)
                  {
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_READ_ERROR));
                  }
                  else if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_GENERIC_ERROR)
                  {
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DISC_ERROR));
                  }
                  else if(Peripheral.rse.dvdDiscStatValue == RSEConstants.DVD_MD_UNKNOWN)
                  {
                     this.setError(Peripheral.localeEngine.getText(T.STRB_ERROR_MEDIA_DISC_ERROR));
                  }
               }
               else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_NONE && Peripheral.rse.dvdDiscStatValue == RSEConstants.DISC_EJECT)
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_INSERT_DISC));
               }
               else if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_EJECT)
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_EJECTING_MEDIA));
               }
               else
               {
                  Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_NONE;
               }
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_INSERT_DISC));
               break;
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_CONNECT_DEVICE));
               break;
            case Peripheral.audioManager.SOURCE_SDCARD:
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_INSERT_SD_CARD));
               break;
            case Peripheral.audioManager.SOURCE_AUX:
            case Peripheral.audioManager.SOURCE_REAR_AUX1:
            case Peripheral.audioManager.SOURCE_REAR_AUX2:
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_CONNECT_DEVICE));
               break;
            case Peripheral.audioManager.SOURCE_REAR_HDMI1:
            case Peripheral.audioManager.SOURCE_REAR_HDMI2:
               this.assets.textFull.hdmi.visible = true;
               break;
            case Peripheral.audioManager.SOURCE_DTV:
               this.setError("Loading DTV...");
               break;
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               if(this.mSourceSelect)
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_NO_BLUETOOTH_AUDIO_DEVICE_CONNECTED));
               }
               else
               {
                  this.setError(Peripheral.localeEngine.getText(T.STRB_CONNECT_BLUETOOTH_AUDIO_DEVICE));
               }
               break;
            default:
               this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_CONNECT_DEVICE));
         }
      }
      
      private function showRSEStop() : void
      {
         if(Peripheral.rse.dvdoutstatstatus == RSEConstants.MD_STOP)
         {
            this.disableFunctionality();
            this.assets.splitview.fullscreen_button.visible = true;
            this.assets.playpause_button.setEnabled(true);
            this.setError(Peripheral.localeEngine.getText(T.STRB_PLAYER_STOPPED));
            this.clearPlayTimeInfo();
            this.assets.track_group.songnumber.visible = false;
         }
      }
      
      private function showFullScreen(_visible:Boolean) : void
      {
         var _alpha:int = 0;
         if(this.assets.div1.visible != _visible)
         {
            _alpha = _visible ? 1 : 0;
            this.assets.textFull.alpha = _alpha;
            this.assets.textSplit.alpha = _alpha;
            this.assets.map.alpha = _alpha;
            this.assets.info.alpha = _alpha;
            this.assets.tracks_group.alpha = _alpha;
            this.assets.div1.visible = _visible;
            this.assets.div2.visible = _visible;
            this.assets.div3.visible = _visible;
            this.assets.div4.visible = _visible;
            this.assets.track_group.visible = _visible;
            this.assets.splitview.visible = _visible;
            this.assets.repeatsm_button.alpha = _alpha;
            this.assets.shufflesm_button.alpha = _alpha;
            this.assets.repeatlg_button.alpha = _alpha;
            this.assets.shufflelg_button.alpha = _alpha;
            this.assets.rse_button.alpha = _alpha;
            this.assets.stop_button.alpha = _alpha;
            this.assets.browse_button.alpha = _alpha;
            this.assets.seekbackward_button.visible = _visible;
            this.assets.playpause_button.visible = _visible;
            this.assets.seekforward_button.visible = _visible;
            this.assets.audio_button.visible = _visible;
         }
      }
      
      private function showSplitScreen() : void
      {
         var splitScreen:String = Peripheral.appStateManager.splitScreenSource;
         if(!Peripheral.audioManager.isSourceAvailable(Peripheral.audioManager.source) || Boolean(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source)) && Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_CD || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AUX)
         {
            if(splitScreen != "map")
            {
               splitScreen = "none";
            }
         }
         switch(Peripheral.appStateManager.splitScreenSource)
         {
            case "map":
               if(!this.assets.splitview.map_button.mEnabled || !this.assets.splitview.map_button.visible)
               {
                  splitScreen = "none";
               }
               break;
            case "info":
               if(!this.assets.splitview.info_button.mEnabled || !this.assets.splitview.info_button.visible)
               {
                  splitScreen = "none";
               }
               break;
            case "tracks":
               if(!this.assets.splitview.tracks_button.mEnabled || !this.assets.splitview.tracks_button.visible)
               {
                  splitScreen = "none";
               }
         }
         if(this.assets.tracks_group.visible)
         {
            Peripheral.hardControls.removeEventListener(HardControlEvent.SELECT,this.assets.tracks_group.tracks_list.selectEventHandler);
            Peripheral.hardControls.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.assets.tracks_group.tracks_list.scrollEventHandler);
            Framework.focusManager.delFocus(this.mTrackListFocusObject);
         }
         this.assets.textSplit.visible = splitScreen != "none";
         this.assets.textFull.visible = !this.assets.textSplit.visible;
         this.assets.map.visible = false;
         this.assets.info.visible = false;
         this.assets.tracks_group.visible = false;
         this.assets.splitview.map_button.setHighlight(false);
         this.assets.splitview.info_button.setHighlight(false);
         this.assets.splitview.tracks_button.setHighlight(false);
         Peripheral.personalConfig.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPLITSCREEN,{"mode":"NORMAL"}));
         switch(splitScreen)
         {
            case "map":
               this.assets.map.visible = true;
               this.assets.splitview.map_button.setHighlight(true);
               Peripheral.personalConfig.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPLITSCREEN,{"mode":"SPLIT"}));
               break;
            case "info":
               this.assets.info.visible = true;
               this.assets.splitview.info_button.setHighlight(true);
               break;
            case "tracks":
               if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
               {
                  Peripheral.rse.setBrowsePath({
                     "path":"/songs",
                     "type":""
                  });
               }
               this.mTracksManual = false;
               this.assets.tracks_group.visible = true;
               this.assets.splitview.tracks_button.setHighlight(true);
               Peripheral.hardControls.addEventListener(HardControlEvent.SELECT,this.assets.tracks_group.tracks_list.selectEventHandler,false,0,true);
               Peripheral.hardControls.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.assets.tracks_group.tracks_list.scrollEventHandler,false,0,true);
               this.setupTrackList();
               Framework.focusManager.addFocus(this.mTrackListFocusObject);
         }
      }
      
      private function setScrollerProgress(progress:uint) : void
      {
         if(this.assets.track_group.playhead_scroller.thumb.visible)
         {
            this.assets.track_group.playhead_scroller.setValue(progress);
         }
         else
         {
            this.assets.track_group.playhead_scroller.setProgress(progress);
         }
      }
      
      private function onDisableForAutoPlayOff() : Boolean
      {
         var dev:MediaPlayerDevice = null;
         for each(dev in Peripheral.mediaPlayer.devicesForAutoPlayOff)
         {
            if(dev.id == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source) && dev.autoplayOff == 1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onEnableForAutoPlayOff() : Boolean
      {
         var dev:MediaPlayerDevice = null;
         for each(dev in Peripheral.mediaPlayer.devicesForAutoPlayOff)
         {
            if(dev.id == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source) && dev.autoplayOff == 2)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onRearCameraStatus(e:DisplayManagerEvent) : void
      {
         if(!(Boolean(Peripheral.displayManager.RearCameraStatus) && Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DTV && !this.mRestoreRdc2Video))
         {
            if(!Peripheral.displayManager.RearCameraStatus && Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DTV && this.mRestoreRdc2Video)
            {
               Peripheral.rse.startRdc2Video("dtvNormal");
               this.mRestoreRdc2Video = false;
            }
         }
      }
      
      private function onDTVAvailable(e:Event) : void
      {
         this.showCurrentSource();
      }
      
      private function onSyncState(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.syncState == MediaPlayerSyncState.METADATA)
         {
            this.assets.tracks_group.tracks_list.requestData();
         }
      }
      
      private function onDeviceCapability(e:MediaPlayerEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
         {
            if(!Peripheral.mediaPlayer.RepeatDeviceSupport && !Peripheral.mediaPlayer.RandomDeviceSupport)
            {
               this.assets.repeatsm_button.setEnabled(false);
               this.assets.repeatlg_button.setEnabled(false);
               this.assets.shufflesm_button.setEnabled(false);
               this.assets.shufflelg_button.setEnabled(false);
            }
         }
      }
      
      private function onRSEVideoReadBackClick(e:WidgetEvent) : void
      {
         this.mRearMedia = this.onRSEClick;
         this.mRearMediaReadBackPhrase = this.getReadBackPhrase;
         Peripheral.readBackManager.registerCallBack("rse_button",this.mRearMedia,this.mRearMediaReadBackPhrase);
         Peripheral.readBackManager.videoReadBack();
      }
      
      private function onReadBackStopClick(e:WidgetEvent) : void
      {
         this.registerReadBacks("stop_button",this.onStopClick,this.getReadBackPhraseForFrontMedia);
      }
      
      private function onReadBackSeekBackwardClick(e:WidgetEvent) : void
      {
         this.registerReadBacks("seekbackward_button",this.onSeekBackwardClick,this.getReadBackPhraseForFrontMedia);
      }
      
      private function onReadBackSeekForwardClick(e:WidgetEvent) : void
      {
         this.registerReadBacks("seekforward_button",this.onSeekForwardClick,this.getReadBackPhraseForFrontMedia);
      }
      
      private function onReadBackSeekBackwardLongPress(e:WidgetEvent) : void
      {
         this.registerReadBacks("seekbackward_button",this.onSeekBackwardLongPress,this.getReadBackPhraseForFrontMedia);
      }
      
      private function onReadBackSeekForwardLongPress(e:WidgetEvent) : void
      {
         this.registerReadBacks("seekforward_button",this.onSeekForwardLongPress,this.getReadBackPhraseForFrontMedia);
      }
      
      private function onReadBackPlayPauseClick(e:WidgetEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD || Boolean(Peripheral.audioManager.isSourceRSE(Peripheral.audioManager.source)))
         {
            if(Peripheral.rse.dvdoutstatstatus == "play")
            {
               this.registerReadBacks("pause_button",this.onPlayPauseClick,this.getReadBackPhraseForFrontMedia);
            }
            else
            {
               this.registerReadBacks("play_button",this.onPlayPauseClick,this.getReadBackPhraseForFrontMedia);
            }
         }
         else if(Peripheral.mediaPlayer.transportAction == MediaPlayerTransportAction.PLAY)
         {
            this.registerReadBacks("pause_button",this.onPlayPauseClick,this.getReadBackPhraseForFrontMedia);
         }
         else
         {
            this.registerReadBacks("play_button",this.onPlayPauseClick,this.getReadBackPhraseForFrontMedia);
         }
      }
      
      private function onReadBackSourceClick(e:WidgetEvent) : void
      {
         if(e != null && e.data.type == "cd")
         {
            Peripheral.readBackManager.updateObjVars("disc_button",e);
            this.registerReadBacks("disc_button",this.onSourceClick,this.getReadBackPhraseForFrontMedia);
         }
         else if(e != null && (e.data.type == "usb1" || e.data.type == "usb2"))
         {
            Peripheral.readBackManager.updateObjVars("usb_button",e);
            this.registerReadBacks("usb_button",this.onSourceClick,this.getReadBackPhraseForFrontMedia);
         }
         else
         {
            this.onSourceClick(e);
         }
      }
      
      private function onReadBackSplitViewClick(e:WidgetEvent) : void
      {
         if(e.data.name == "fullscreen_button")
         {
            Peripheral.readBackManager.updateObjVars("fullscreen_button",e);
            this.registerReadBacks("fullscreen_button",this.onSplitViewClick,this.getReadBackPhraseForFrontMedia);
         }
         else
         {
            this.onSplitViewClick(e);
         }
      }
      
      private function registerReadBacks(receiver:String, action:Function, readBackPhrase:Function) : void
      {
         Peripheral.readBackManager.registerCallBack(receiver,action,readBackPhrase);
         Peripheral.readBackManager.videoReadBack();
      }
      
      private function getReadBackPhraseForFrontMedia(actorName:String, _press:Boolean) : String
      {
         return this.mReadBackPhraseMap[actorName][_press];
      }
      
      private function getReadBackPhrase(vehLine:String, _press:Boolean) : String
      {
         vehLine = vehLine == "RU" ? "RU" : "NRU";
         return this.mReadBackPhraseMap[vehLine][_press];
      }
   }
}

