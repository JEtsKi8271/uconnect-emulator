package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.moduleLinkAPI.*;
   import com.harman.navigation.global.vServices.*;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.MessageEvent;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.AppStateManager;
   import peripheral.MediaBrowser;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PlayerBrowseScreen extends GenericScreen
   {
      
      private var mMenuState:int = 0;
      
      private var mListPosition:int = 0;
      
      private var mListVector:Vector.<MediaPlayerPath>;
      
      private var mArtistsAvailable:Boolean;
      
      private var mPlaylistsAvailable:Boolean;
      
      private var mSongsAvailable:Boolean;
      
      private var mAlbumsAvailable:Boolean;
      
      private var mGenresAvailable:Boolean;
      
      private var mPodcastsAvailable:Boolean;
      
      private var mAudiobooksAvailable:Boolean;
      
      private var mFoldersAvailable:Boolean;
      
      private var mCurrentView:String;
      
      private var mAlphaNumber:String = "";
      
      private var mAlphaSearch:Boolean = false;
      
      private var categoryItems:Array;
      
      private var mLocalPrevTrack:uint = 0;
      
      private var mRequestData:Boolean = false;
      
      private var mCurrentSource:String;
      
      private var waitingTimer:Timer = new Timer(Style.PlayerBrowseScreen.DATA_DELAY_WARNING_THRESHOLD);
      
      private var mListeningForItems:Boolean = false;
      
      private var mBlindNavigation:Boolean = false;
      
      private var mHistory:Vector.<Object> = new Vector.<Object>();
      
      private var mGoingBack:Boolean = false;
      
      private var mStateManager:AppStateManager = AppStateManager.create();
      
      private var mPosition:uint = 0;
      
      private var mCursor:uint = 0;
      
      private var madditionalPaddingRequired:uint = 28;
      
      private var mBrowser:MediaBrowser = null;
      
      private var mBrowseItemsRequestProcessing:Boolean = false;
      
      private var mPossibleBrowseButtons:Array = new Array();
      
      private var mCurrentListItemType:String = "";
      
      private var checkVrView:Boolean = true;
      
      private var vrPath:String = "";
      
      private var specialCharText:String = "!#;";
      
      private var currentBrowsepath:String = "";
      
      private var mSearchActive:Boolean;
      
      private var mAlphaJumpRequested:Boolean = false;
      
      public function PlayerBrowseScreen()
      {
         mView = new C_PlayerBrowseScreenView();
         super();
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
         if(this.mHistory.length == 0)
         {
            Peripheral.appStateManager.browseHistory.cur = mView.browse_list.getCursor();
            Peripheral.appStateManager.browseHistory.pos = mView.browse_list.getPosition();
         }
         else
         {
            Peripheral.appStateManager.browseHistory.cur = this.mHistory[0].cursor;
            Peripheral.appStateManager.browseHistory.pos = this.mHistory[0].position;
         }
         this.mVRData = null;
         Peripheral.mediaPlayer.SetmBrowseItemsRequestProcessing(false);
         Framework.popupManager.dequeue(DynamicPopupNames.ALPHA_JUMP);
         Framework.popupManager.dequeue(DynamicPopupNames.MEDIA_SEARCH_SPELLER);
         this.cancelSearchRequest();
         if(mView.searchDescription.visible)
         {
            mView.searchDescription.visible = false;
            mView.btnClearResults_button.visible = false;
            mView.btnSearch_button.visible = true;
         }
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.mMenuState = 0;
         this.createBrowseButtonsList();
         this.configureViewButtons();
         mView.browse_scroller.setReportingPeriod(Style.PlayerBrowseScreen.SCROLLER_REPORTING_PERIOD);
         mView.browse_scroller.setPopupUpdater(this.updateScrollerPopup);
         mView.browse_list.attachScroller(mView.browse_scroller);
         mView.browse_list.setBufferSize(Style.PlayerBrowseScreen.LIST_BUFFER_SIZE);
         mView.browse_list.setRowUpdater(this.updateRow);
         mView.browse_list.setDataRequester(this.getBrowseItems);
         mView.displayTitle.labelValue.text = "";
         this.mCurrentView = null;
         this.updateAlphaButton(true);
         this.switchToSearchView(false);
         t(mView.btnClearResults_button.value_label,T.STRB_SEARCH_CLEAR_RESULTS);
         mView.browse_list.setSelectionChanger(this.changeSelection);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.hideTheAlphaJumpButton();
         this.mListeningForItems = false;
         this.startWaiting();
         this.mCurrentSource = Peripheral.audioManager.source;
         this.clearList();
         clearBreadcrumbs();
         this.currentBrowsepath = Peripheral.mediaPlayer.browsePath.path;
         Peripheral.mediaBrowser.reportStatus();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.browse_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.btnAlphaJump_button,mView.btnSearch_button,mView.btnClearResults_button]));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.cat0_button,mView.cat1_button,mView.cat2_button,mView.cat3_button,mView.btnArrow_button]));
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.browse_list.scrollEventHandler);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.browse_list.selectEventHandler);
         attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.PLAYLIST_COUNT,this.onPlaylistCount);
         attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.PLAY_PATH,this.onPlayPath);
         attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.SEARCH_COUNT,this.onSearchCount);
         attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.VR_COUNT,this.onVRCount);
         Framework.popupManager.addEventListener(GlobalEvent.SPELLER_POPUP_OK,this.onSpellerPopupOk,false,0,true);
         attachListener(this.waitingTimer,TimerEvent.TIMER,this.onWaitingTooLong);
         this.mBrowser = Peripheral.mediaBrowser;
         attachListener(this.mBrowser,Event.CHANGE,this.onBrowsePath);
         attachListener(this.mBrowser,Event.CLOSE,this.onClose);
         attachListener(this.mBrowser,Event.OPEN,this.onOpen);
         attachListener(Peripheral.audioManager,AudioEvent.SOURCE,this.onSource);
         attachListener(Framework.messenger,MessageEvent.MESSAGE,this.onMessage);
         attachListener(mView.browse_list,WidgetEvent.SELECT,this.onListSelect);
         mView.browse_list.attachScroller(mView.browse_scroller);
         attachListener(mView.btnBack_button,WidgetEvent.CLICK,this.back);
         attachListener(mView.btnClose_button,MouseEvent.CLICK,this.close);
         attachListener(mView.btnArrow_button,MouseEvent.CLICK,this.toggleViewEvent);
         attachListener(mView.btnAlphaJump_button,MouseEvent.CLICK,this.goToAlphaJumpScreen);
         attachListener(mView.btnSearch_button,MouseEvent.CLICK,this.goToSearchScreen);
         attachListener(mView.btnClearResults_button,MouseEvent.CLICK,this.clearSearchResults);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOut,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.CURRENT_TRACK_INFO,this.onTrackInfo,false,0,true);
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.CURRENT_TRACK,this.onCurrentTrack,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Framework.popupManager.removeEventListener(GlobalEvent.SPELLER_POPUP_OK,this.onSpellerPopupOk);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOut);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.CURRENT_TRACK_INFO,this.onTrackInfo);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.CURRENT_TRACK,this.onCurrentTrack);
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.VR_COUNT,this.onVRCount);
         mView.browse_list.detachScroller();
         this.stopWaiting();
         this.stopAlphaJump();
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         this.hideTheAlphaJumpButton();
         this.configureViewButtons();
         t(mView.btnAlphaJump_button.value_label,T.STRB_ALPHA_PLAYERBROWSE);
         t(mView.btnSearch_button.value_label,T.STRB_SEARCH_PLAYERBROWSE);
         mView.browse_list.update();
      }
      
      private function createBrowseButtonsList() : void
      {
         this.mPossibleBrowseButtons = new Array();
         this.mPossibleBrowseButtons.push(mView.cat0_button);
         this.mPossibleBrowseButtons.push(mView.cat1_button);
         this.mPossibleBrowseButtons.push(mView.cat2_button);
         this.mPossibleBrowseButtons.push(mView.cat3_button);
         this.mPossibleBrowseButtons.push(mView.cat0_button);
         this.mPossibleBrowseButtons.push(mView.cat1_button);
         this.mPossibleBrowseButtons.push(mView.cat2_button);
         this.mPossibleBrowseButtons.push(mView.cat3_button);
      }
      
      private function configureViewButtons() : void
      {
         var i:int = 0;
         var j:int = 0;
         mView.btnArrow_button.icon.gotoAndStop(this.mMenuState == 0 ? 1 : 2);
         this.categoryItems = new Array();
         this.categoryItems[0] = new Array(T.STRB_FOLDERS_PLAYERBROWSE,5,MediaPlayerPath.FOLDERS,this.mFoldersAvailable,this.foldersBtnClickEvent);
         this.categoryItems[1] = new Array(T.STRB_ARTISTS_PLAYERBROWSE,3,MediaPlayerPath.ARTISTS,this.mArtistsAvailable,this.artistBtnClickEvent);
         this.categoryItems[2] = new Array(T.STRB_PLAYLISTS_PLAYERBROWSE,7,MediaPlayerPath.PLAYLISTS,this.mPlaylistsAvailable,this.playlistBtnClickEvent);
         this.categoryItems[3] = new Array(T.STRB_SONGS_PLAYERBROWSE,9,MediaPlayerPath.SONGS,this.mSongsAvailable,this.songBtnClickEvent);
         this.categoryItems[4] = new Array(T.STRB_ALBUMS_PLAYERBROWSE,2,MediaPlayerPath.ALBUMS,this.mAlbumsAvailable,this.albumBtnClickEvent);
         this.categoryItems[5] = new Array(T.STRB_GENRES_PLAYERBROWSE,6,MediaPlayerPath.GENRES,this.mGenresAvailable,this.genreBtnClickEvent);
         this.categoryItems[6] = new Array(T.STRB_PODCASTS_PLAYERBROWSE,8,MediaPlayerPath.PODCASTS,this.mPodcastsAvailable,this.podcastBtnClickEvent);
         this.categoryItems[7] = new Array(T.STRB_AUDIOBOOKS_PLAYERBROWSE,4,MediaPlayerPath.AUDIOBOOKS,this.mAudiobooksAvailable,this.audioBooksBtnClickEvent);
         if(Boolean(Peripheral.audioManager.isSourceIPod()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
         {
            this.categoryItems = this.categoryItems.slice(1,this.categoryItems.length);
         }
         else
         {
            this.categoryItems = this.categoryItems.slice(0,this.categoryItems.length - 2);
         }
         if(this.mMenuState == 0)
         {
            for(i = 0; i < 4; i++)
            {
               t(this.mPossibleBrowseButtons[i].value_label,this.categoryItems[i][0]);
               this.mPossibleBrowseButtons[i].icon.gotoAndStop(this.categoryItems[i][1]);
               this.mPossibleBrowseButtons[i].setHighlight(this.mCurrentView == this.categoryItems[i][2]);
               this.mPossibleBrowseButtons[i].setInteractive(this.categoryItems[i][3]);
               this.mPossibleBrowseButtons[i].setEnabled(this.categoryItems[i][3]);
               this.mPossibleBrowseButtons[i].visible = true;
               if(this.categoryItems.length > i + 4)
               {
                  detachListener(this.mPossibleBrowseButtons[i + 4],MouseEvent.CLICK,this.categoryItems[i + 4][4]);
               }
               attachListener(this.mPossibleBrowseButtons[i],MouseEvent.CLICK,this.categoryItems[i][4]);
            }
         }
         else
         {
            for(j = 4; j < 8; j++)
            {
               if(j < this.categoryItems.length)
               {
                  t(this.mPossibleBrowseButtons[j].value_label,this.categoryItems[j][0]);
                  this.mPossibleBrowseButtons[j].icon.gotoAndStop(this.categoryItems[j][1]);
                  this.mPossibleBrowseButtons[j].setHighlight(this.mCurrentView == this.categoryItems[j][2]);
                  this.mPossibleBrowseButtons[j].setInteractive(this.categoryItems[j][3]);
                  this.mPossibleBrowseButtons[j].setEnabled(this.categoryItems[j][3]);
                  this.mPossibleBrowseButtons[j].visible = true;
                  detachListener(this.mPossibleBrowseButtons[j - 4],MouseEvent.CLICK,this.categoryItems[j - 4][4]);
                  attachListener(this.mPossibleBrowseButtons[j],MouseEvent.CLICK,this.categoryItems[j][4]);
               }
               else
               {
                  this.mPossibleBrowseButtons[j].visible = false;
               }
            }
         }
      }
      
      private function clearList() : void
      {
         mView.labelItemsInList.text = "";
         mView.browse_list.setLength(0);
      }
      
      private function findAvailableViews() : void
      {
         var item:MediaPlayerItem = null;
         this.mArtistsAvailable = false;
         this.mPlaylistsAvailable = false;
         this.mSongsAvailable = false;
         this.mAlbumsAvailable = false;
         this.mGenresAvailable = false;
         this.mPodcastsAvailable = false;
         this.mAudiobooksAvailable = false;
         this.mFoldersAvailable = false;
         for each(item in this.mBrowser.availableView.list)
         {
            switch(item.name)
            {
               case MediaPlayerPath.ARTISTS:
                  this.mArtistsAvailable = true;
                  break;
               case MediaPlayerPath.PLAYLISTS:
                  this.mPlaylistsAvailable = true;
                  break;
               case MediaPlayerPath.SONGS:
                  this.mSongsAvailable = true;
                  break;
               case MediaPlayerPath.ALBUMS:
                  this.mAlbumsAvailable = true;
                  break;
               case MediaPlayerPath.GENRES:
                  this.mGenresAvailable = true;
                  break;
               case MediaPlayerPath.PODCASTS:
                  this.mPodcastsAvailable = true;
                  break;
               case MediaPlayerPath.AUDIOBOOKS:
                  this.mAudiobooksAvailable = true;
                  break;
               case MediaPlayerPath.FOLDERS:
                  this.mFoldersAvailable = true;
            }
         }
      }
      
      private function setInitialView() : void
      {
         var elements:Array = null;
         var callback:Function = null;
         this.mVRData = null;
         var found:Boolean = false;
         var browsePath:String = "";
         if(screenVars.path)
         {
            browsePath = screenVars.path.toString();
         }
         else
         {
            browsePath = this.currentBrowsepath;
         }
         if(browsePath != null)
         {
            elements = browsePath.split("/");
            if(elements.length == 2)
            {
               switch(elements[1])
               {
                  case MediaPlayerPath.ARTISTS:
                     this.viewAllArtists();
                     found = true;
                     break;
                  case MediaPlayerPath.PLAYLISTS:
                     this.viewAllPlaylists();
                     found = true;
                     break;
                  case MediaPlayerPath.SONGS:
                     this.viewAllSongs();
                     found = true;
                     break;
                  case MediaPlayerPath.ALBUMS:
                     this.viewAllAlbums();
                     found = true;
                     break;
                  case MediaPlayerPath.GENRES:
                     this.viewAllGenres();
                     found = true;
                     break;
                  case MediaPlayerPath.PODCASTS:
                     this.viewAllPodcasts();
                     found = true;
                     break;
                  case MediaPlayerPath.AUDIOBOOKS:
                     this.viewAllAudiobooks();
                     found = true;
                     break;
                  case MediaPlayerPath.FOLDERS:
                     this.viewAllfolders();
                     found = true;
               }
            }
            if(elements.length > 2)
            {
               found = this.setViewToDeepLevel(browsePath,elements);
            }
         }
         if(!found)
         {
            this.mMenuState = 0;
            callback = this.categoryItems[0][4] as Function;
            callback();
         }
      }
      
      private function onPlaylistCount(e:MediaPlayerEvent) : void
      {
         var currPlaylistAvailability:Boolean = this.mPlaylistsAvailable;
         this.mPlaylistsAvailable = Peripheral.mediaPlayer.playlistCount > 0 ? true : false;
         if(this.mPlaylistsAvailable != currPlaylistAvailability)
         {
            this.configureViewButtons();
         }
      }
      
      private function onPlayPath(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.SearchText != "" && mView.browse_list.getData() == null)
         {
            return;
         }
         mView.browse_list.update();
      }
      
      private function onCurrentTrack(e:MediaPlayerEvent) : void
      {
         if(this.mLocalPrevTrack != Peripheral.mediaPlayer.currentTrack)
         {
            this.mRequestData = true;
         }
         this.mLocalPrevTrack = Peripheral.mediaPlayer.currentTrack;
      }
      
      private function onTrackInfo(e:MediaPlayerEvent) : void
      {
         if(this.mRequestData)
         {
            mView.browse_list.requestData();
            this.mRequestData = false;
         }
         if(Peripheral.mediaPlayer.browsePath.itemCount == 0)
         {
            mView.browse_list.row_0_button.visible = true;
            mView.browse_list.row_0_button.type.visible = false;
            Text.format(mView.browse_list.row_0_button.labelText,T.STRB_NO_ITEMS);
         }
      }
      
      private function updateAlphaButton(display:Boolean) : void
      {
         var alphaFlag:Boolean = this.determineAlphaJump();
         mView.btnAlphaJump_button.setEnabled(alphaFlag);
         mView.btnAlphaJump_button.setInteractive(alphaFlag);
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(this.convertTypeToDisplayName(Peripheral.audioManager.source),Breadcrumb.INERT,this.close));
      }
      
      private function setView(view:String) : void
      {
         switch(view)
         {
            case MediaPlayerPath.ALBUMS:
               this.viewAllAlbums();
               break;
            case MediaPlayerPath.ARTISTS:
               this.viewAllArtists();
               break;
            case MediaPlayerPath.AUDIOBOOKS:
               this.viewAllAudiobooks();
               break;
            case MediaPlayerPath.GENRES:
               this.viewAllGenres();
               break;
            case MediaPlayerPath.PODCASTS:
               this.viewAllPodcasts();
               break;
            case MediaPlayerPath.PLAYLISTS:
               this.viewAllPlaylists();
               break;
            case MediaPlayerPath.SONGS:
               this.viewAllSongs();
               break;
            case MediaPlayerPath.FOLDERS:
               this.viewAllfolders();
         }
      }
      
      private function viewAllArtists(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ARTISTS;
         data.type = null;
         this.mListVector = null;
         if(this.mArtistsAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_ARTISTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllArtists,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllPlaylists(goingBack:Boolean = false) : void
      {
         var callback:Function = null;
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PLAYLISTS;
         data.type = null;
         this.mListVector = null;
         if(this.mPlaylistsAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_PLAYLISTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllPlaylists,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
         else
         {
            callback = this.categoryItems[0][4] as Function;
            callback();
         }
      }
      
      private function viewAllSongs(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.SONGS;
         data.type = null;
         this.mListVector = null;
         if(this.mSongsAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_SONGS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllSongs,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllAlbums(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ALBUMS;
         data.type = null;
         this.mListVector = null;
         if(this.mAlbumsAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllAlbums,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllGenres(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.GENRES;
         data.type = null;
         this.mListVector = null;
         if(this.mGenresAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_GENRES_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllGenres,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllPodcasts(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PODCASTS;
         data.type = null;
         this.mListVector = null;
         if(this.mPodcastsAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_PODCASTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllPodcasts,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllAudiobooks(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.AUDIOBOOKS;
         data.type = null;
         this.mListVector = null;
         if(this.mAudiobooksAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_AUDIOBOOKS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllAudiobooks,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function viewAllfolders(goingBack:Boolean = false) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.FOLDERS;
         data.type = null;
         this.mListVector = null;
         if(this.mFoldersAvailable)
         {
            if(screenVars.path)
            {
               this.mGoingBack = true;
            }
            else
            {
               this.mGoingBack = goingBack;
            }
            if(goingBack == true || Boolean(screenVars.path))
            {
               this.mHistory = this.mHistory.slice(0,1);
            }
            this.clearList();
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_FOLDERS_PLAYERBROWSE,Breadcrumb.FUNCTION,this.viewAllfolders,true));
            this.updateAlphaButton(true);
            if(screenVars.path)
            {
               this.setBrowsePath(data,true,goingBack);
            }
            else
            {
               this.setBrowsePath(data,false,!goingBack);
            }
         }
      }
      
      private function updateViewButtons() : void
      {
         this.configureViewButtons();
      }
      
      private function toggleViewButtons(btn:MovieClip = null) : void
      {
         if(this.mMenuState == 0)
         {
            this.mMenuState = 1;
         }
         else
         {
            this.mMenuState = 0;
         }
         this.configureViewButtons();
      }
      
      private function cancelSearchRequest() : void
      {
         if(Peripheral.mediaPlayer.SearchText != "")
         {
            Peripheral.mediaPlayer.cancelSearch();
         }
         Peripheral.mediaPlayer.SetmBrowseItemsRequestProcessing(false);
         Peripheral.mediaPlayer.SearchText = "";
      }
      
      override protected function close(e:Event = null) : void
      {
         super.close();
      }
      
      override protected function back(e:Event = null) : void
      {
         var data:MediaPlayerPath = null;
         if(Peripheral.mediaPlayer.SearchText != "")
         {
            this.clearSearchResults(null);
            return;
         }
         if(Framework.popupManager.active == DynamicPopupNames.MEDIA_SEARCH_SPELLER)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.MEDIA_SEARCH_SPELLER);
            return;
         }
         if(Framework.popupManager.active == DynamicPopupNames.ALPHA_JUMP)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.ALPHA_JUMP);
            return;
         }
         if(breadcrumbCount > 2)
         {
            data = new MediaPlayerPath();
            data.path = MediaPlayerPath.UP;
            data.type = null;
            if(breadcrumbCount == 3)
            {
               data.path = MediaPlayerPath.METADATA_ROOT + "/" + this.mCurrentView;
               data.type = null;
            }
            this.mGoingBack = true;
            this.updateAlphaButton(true);
            popBreadcrumb();
            this.setBrowsePath(data,false,false);
            if(this.mListVector != null)
            {
               this.mListVector.pop();
               if(this.mListVector.length == 0)
               {
                  this.mListVector = null;
                  Peripheral.mediaPlayer.setBrowselistLevel(this.mListVector);
               }
            }
         }
         else
         {
            super.back();
         }
      }
      
      private function setBrowsePath(path:MediaPlayerPath, storeHistory:Boolean = false, eraseHistory:Boolean = true) : void
      {
         this.mVRData = null;
         if(storeHistory)
         {
            if(screenVars.path)
            {
               screenVars.path = null;
               this.mCursor = Peripheral.appStateManager.browseHistory.cur;
               this.mPosition = Peripheral.appStateManager.browseHistory.pos;
               this.mHistory.push({
                  "position":this.mPosition,
                  "cursor":this.mCursor
               });
               Peripheral.appStateManager.browseHistory = {
                  "cur":0,
                  "pos":0
               };
            }
            else if(Peripheral.mediaPlayer.SearchText == "")
            {
               this.mHistory.push({
                  "position":mView.browse_list.getPosition(),
                  "cursor":mView.browse_list.getCursor()
               });
            }
         }
         else if(eraseHistory)
         {
            this.mHistory = new Vector.<Object>();
         }
         this.stopAlphaJump();
         this.clearList();
         this.switchToSearchView(false);
         this.startWaiting();
         this.mBrowser.setBrowsePath(path);
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function addBrowseItemListeners() : void
      {
         if(!this.mListeningForItems)
         {
            this.mListeningForItems = true;
            attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.BROWSE_ITEMS,this.onBrowseItems);
         }
      }
      
      private function removeBrowseItemListeners() : void
      {
         this.mListeningForItems = false;
         detachListener(Peripheral.mediaPlayer,MediaPlayerEvent.BROWSE_ITEMS,this.onBrowseItems);
      }
      
      private function stopAlphaJump() : void
      {
         var alphaFlag:Boolean = this.determineAlphaJump();
         if(this.mAlphaJumpRequested)
         {
            Peripheral.mediaPlayer.cancelAlphaJump();
            this.mAlphaJumpRequested = false;
         }
         this.stopWaiting();
         mView.btnAlphaJump_button.setEnabled(alphaFlag);
         mView.btnAlphaJump_button.setInteractive(alphaFlag);
         detachListener(Peripheral.mediaPlayer,MediaPlayerEvent.BROWSE_CHARLIST,this.onAlphaBrowseCharItems);
      }
      
      private function onListSelect(e:WidgetEvent) : void
      {
         var mediaPlayerItem:MediaPlayerItem = e.data.data;
         var row:MovieClip = e.data.visual;
         var nameString:String = new String();
         Peripheral.appStateManager.browseHistory.cur = row.row;
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = MediaPlayerPath.ITEM + mediaPlayerItem.id;
         data.type = mediaPlayerItem.type;
         data.name = mediaPlayerItem.name;
         data.id = mediaPlayerItem.id;
         this.pushDataToVector(data);
         this.popBreadcrumbSearch();
         this.updateAlphaButton(true);
         this.setBrowsePath(data,true);
         if(mediaPlayerItem.playable)
         {
            Peripheral.mediaPlayer.setRepeatMode(MediaPlayerRepeatMode.ALL);
            Peripheral.mediaPlayer.setRandomMode(MediaPlayerRandomMode.OFF);
            this.close();
         }
         else
         {
            switch(mediaPlayerItem.type)
            {
               case MediaPlayerItem.ALBUM:
                  nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                  break;
               case MediaPlayerItem.ARTIST:
                  if(mediaPlayerItem.name == MediaPlayerItem.WILDCARD_UNKNOWN)
                  {
                     nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                  }
                  else
                  {
                     nameString = Peripheral.localeEngine.getText(T.STRB_ALBUMS_BREADCRUMB);
                  }
                  break;
               case MediaPlayerItem.GENRE:
                  if(mediaPlayerItem.name == MediaPlayerItem.WILDCARD_UNKNOWN)
                  {
                     nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                  }
                  else
                  {
                     nameString = Peripheral.localeEngine.getText(T.STRB_ARTISTS_BREADCRUMB);
                  }
                  break;
               case MediaPlayerItem.FOLDER:
                  nameString = Peripheral.localeEngine.getText(T.STRB_FOLDERS_PLAYERBROWSE);
                  break;
               case MediaPlayerItem.PLAYLIST:
                  nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                  break;
               case MediaPlayerItem.DIRECTORY:
                  nameString = mediaPlayerItem.name;
                  break;
               case MediaPlayerTrackInfo.WILDCARD_ALL:
                  nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                  break;
               case MediaPlayerItem.PODCAST:
                  nameString = Peripheral.localeEngine.getText(T.STRB_MEDIA_EPISODES_BREADCRUMB);
                  break;
               case MediaPlayerItem.AUDIOBOOK:
                  nameString = Peripheral.localeEngine.getText(T.STRB_MEDIA_CHAPTERS_BREADCRUMB);
                  break;
               default:
                  nameString = mediaPlayerItem.type;
            }
            pushBreadcrumb(new Breadcrumb(nameString,Breadcrumb.DELTA_FUNCTION,this.deltaBack,Peripheral.mediaPlayer.browsePath.path));
         }
      }
      
      private function deltaBack(delta:int, path:String) : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         data.path = path;
         data.type = null;
         if(delta < 0)
         {
            this.mVRData = null;
            if(-delta >= 2)
            {
               this.mHistory = this.mHistory.slice(0,this.mHistory.length + delta + 1);
            }
            this.mGoingBack = true;
            while(delta < 0)
            {
               popBreadcrumb();
               delta++;
            }
            this.setBrowsePath(data,false,false);
         }
      }
      
      private function updateScrollerPopupOnEnterFrame(evt:Event) : void
      {
         var text:String = null;
         var splitString:Array = null;
         if(mView.browse_list.row_0_button.visible)
         {
            text = mView.browse_list.row_0_button.labelText.text;
            if(text.substring(0,4).toUpperCase() == "THE ")
            {
               text = text.charAt(4);
            }
            else
            {
               if(this.mCurrentListItemType == MediaPlayerItem.SONG && text != "")
               {
                  splitString = mView.browse_list.row_0_button.labelText.text.split(". ");
                  if(splitString.length > 1)
                  {
                     text = splitString[1];
                  }
               }
               text = text.charAt(0);
            }
            if(text != "")
            {
               MovieClip(evt.target).value_label.text = text.toUpperCase();
               MovieClip(evt.target).removeEventListener(Event.ENTER_FRAME,this.updateScrollerPopupOnEnterFrame);
            }
         }
         else
         {
            MovieClip(evt.target).removeEventListener(Event.ENTER_FRAME,this.updateScrollerPopupOnEnterFrame);
         }
      }
      
      private function updateScrollerPopup(popup:MovieClip) : void
      {
         var text:String = null;
         var splitString:Array = null;
         if(mView.browse_list.row_0_button.visible)
         {
            text = mView.browse_list.row_0_button.labelText.text;
            if(text.substring(0,4).toUpperCase() == "THE ")
            {
               text = text.charAt(4);
            }
            else
            {
               if(this.mCurrentListItemType == MediaPlayerItem.SONG && text != "")
               {
                  splitString = mView.browse_list.row_0_button.labelText.text.split(". ");
                  if(splitString.length > 1)
                  {
                     text = splitString[1];
                  }
               }
               text = text.charAt(0);
            }
            if(text == "")
            {
               popup.addEventListener(Event.ENTER_FRAME,this.updateScrollerPopupOnEnterFrame);
            }
            else
            {
               if(this.checkSpecialChar(text) != -1)
               {
                  text = this.specialCharText;
               }
               popup.value_label.text = text.toUpperCase();
            }
         }
         else
         {
            popup.value_label.text = "";
         }
      }
      
      private function onSource(e:AudioEvent) : void
      {
         if(this.mCurrentSource != Peripheral.audioManager.source || this.mCurrentSource == Peripheral.audioManager.SOURCE_BLUETOOTH)
         {
            this.close();
         }
      }
      
      protected function onBrowsePath(e:Event) : void
      {
         var callback:Function = null;
         var length:int = 0;
         var last:Object = null;
         var pathArray:Array = Peripheral.mediaPlayer.browsePath.path.split("/");
         if(pathArray.length > 1 && this.isView(pathArray[1]))
         {
            this.mCurrentView = pathArray[1];
         }
         else
         {
            this.mCurrentView = null;
         }
         if(this.mCurrentView != null)
         {
            if(this.mCurrentView == MediaPlayerPath.FOLDERS || this.mCurrentView == MediaPlayerPath.ARTISTS || this.mCurrentView == MediaPlayerPath.PLAYLISTS || this.mCurrentView == MediaPlayerPath.SONGS || this.mCurrentView == MediaPlayerPath.ALBUMS && (Boolean(Peripheral.audioManager.isSourceIPod()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH))
            {
               this.mMenuState = 0;
            }
            else
            {
               this.mMenuState = 1;
            }
         }
         else
         {
            this.mMenuState = 0;
         }
         this.updateViewButtons();
         if(this.mBlindNavigation)
         {
            pushBreadcrumb(new Breadcrumb(Peripheral.mediaPlayer.browsePath.name,Breadcrumb.DELTA_FUNCTION,Peripheral.mediaPlayer.browsePath.path));
            this.mBlindNavigation = false;
         }
         else if(!screenVars.path)
         {
         }
         if(!this.mCurrentView)
         {
            this.mMenuState = 0;
            callback = this.categoryItems[0][4] as Function;
            callback();
         }
         else
         {
            this.addBrowseItemListeners();
            this.mListPosition = 0;
            if(this.mGotoRootComplete && this.mVRData != null)
            {
               length = int(this.mVRData.list.length);
            }
            else
            {
               length = int(Peripheral.mediaPlayer.browsePath.itemCount);
            }
            if(length > 0)
            {
               mView.browse_list.setLength(length);
               if(this.mGoingBack)
               {
                  last = this.mHistory.pop();
                  if(last == null)
                  {
                     mView.browse_list.setPosition(0);
                     mView.browse_list.setCursor(0);
                     this.mGoingBack = false;
                  }
                  else
                  {
                     mView.browse_list.setPosition(last.position);
                     mView.browse_list.setCursor(last.cursor);
                     this.mGoingBack = false;
                  }
               }
               t(mView.labelItemsInList,Format.itemsInList(length));
            }
            else
            {
               Peripheral.mediaPlayer.SetmBrowseItemsRequestProcessing(false);
               this.stopWaiting();
               mView.browse_list.row_0_button.visible = true;
               mView.browse_list.row_0_button.type.visible = false;
               Text.format(mView.browse_list.row_0_button.labelText,T.STRB_NO_ITEMS);
            }
         }
      }
      
      private function isView(view:String) : Boolean
      {
         if([MediaPlayerPath.ALBUMS,MediaPlayerPath.ARTISTS,MediaPlayerPath.AUDIOBOOKS,MediaPlayerPath.GENRES,MediaPlayerPath.PODCASTS,MediaPlayerPath.PLAYLISTS,MediaPlayerPath.SONGS,MediaPlayerPath.FOLDERS].indexOf(view) > -1)
         {
            return true;
         }
         return false;
      }
      
      private function processScreenVars() : void
      {
         var view:String = null;
         var data:MediaPlayerPath = new MediaPlayerPath();
         var targetArray:Array = screenVars.path.split("/");
         if(targetArray.length >= 2 && [MediaPlayerPath.FILE_ROOT,MediaPlayerPath.METADATA_ROOT].indexOf(targetArray[0]) > -1 && this.isView(targetArray[1]))
         {
            view = targetArray[1];
            targetArray.shift();
            targetArray.shift();
            screenVars.path = targetArray.join("/");
            if(screenVars.path == "")
            {
               screenVars.path = null;
            }
            this.setView(view);
         }
         else if(targetArray.length >= 1)
         {
            data.path = targetArray[0];
            data.type = null;
            targetArray.shift();
            screenVars.path = targetArray.join("/");
            if(screenVars.path == "")
            {
               screenVars.path = null;
            }
            this.setBrowsePath(data);
            this.mBlindNavigation = true;
         }
      }
      
      protected function onBrowseItems(evt:MediaPlayerEvent) : void
      {
         var data:MediaPlayerItemList = evt.data;
         if(evt.data != null && evt.data.list.length != 0)
         {
            this.mCurrentListItemType = evt.data.list[0].type;
         }
         mView.browse_list.setData(evt.data);
      }
      
      private function updateRow(row:MovieClip, rowIndex:int, data:MediaPlayerItem, dataIndex:int) : void
      {
         if(data != null)
         {
            row.visible = true;
            row.underline.visible = false;
            row.setInteractive(true);
            row.icon.visible = false;
            row.type.visible = false;
            row.labelText.x = mView.labelTextstartX;
            row.labelText.width = mView.labelTextstartWidth;
            if(data.name.length > 48)
            {
               data.name = data.name.slice(0,48);
            }
            this.stopWaiting();
            if(!(Boolean(Peripheral.audioManager.isSourceIPod()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH))
            {
               switch(data.id)
               {
                  case MediaPlayerTrackInfo.WILDCARD_ALL_ID:
                     switch(data.type)
                     {
                        case MediaPlayerItem.SONG:
                           Text.format(row.labelText,data.name);
                           break;
                        case MediaPlayerItem.ALBUM:
                        case MediaPlayerTrackInfo.WILDCARD_ALL:
                           Text.format(row.labelText,T.STRB_ALL_SONGS_BREADCRUMB);
                           break;
                        case MediaPlayerItem.ARTIST:
                           Text.format(row.labelText,T.STRB_ALL_ALBUMS_BREADCRUMB);
                           break;
                        case MediaPlayerItem.GENRE:
                           Text.format(row.labelText,T.STRB_ALL_ARTISTS_BREADCRUMB);
                           break;
                        default:
                           if(data.name == "All Songs" && data.id == 0)
                           {
                              Text.format(row.labelText,T.STRB_ALL_SONGS_BREADCRUMB);
                           }
                           else
                           {
                              Text.format(row.labelText,data.name);
                           }
                     }
                     break;
                  case MediaPlayerTrackInfo.WILDCARD_UNKNOWN_ID:
                     switch(data.type)
                     {
                        case MediaPlayerItem.SONG:
                        case MediaPlayerItem.PLAYLIST:
                        case MediaPlayerItem.AUDIOBOOK:
                        case MediaPlayerItem.PODCAST:
                           Text.format(row.labelText,data.name);
                           break;
                        default:
                           Text.format(row.labelText,T.STRB_UNKNOWN);
                     }
                     break;
                  default:
                     if(data.type == MediaPlayerItem.SONG)
                     {
                        if(LocaleArchive.getInstance().isMirrored())
                        {
                           Text.format(row.labelText,Text.rightToLeft(data.name) ? dataIndex + 1 + ". " + data.name : data.name + " ." + (dataIndex + 1));
                        }
                        else
                        {
                           Text.format(row.labelText,Text.rightToLeft(data.name) ? data.name + " ." + (dataIndex + 1) : dataIndex + 1 + ". " + data.name);
                        }
                     }
                     else if(data.type == MediaPlayerItem.FILE)
                     {
                        row.type.visible = true;
                        row.type.gotoAndStop(2);
                        row.labelText.x = mView.labelTextX;
                        row.labelText.width = mView.labelTextWidth;
                        Text.format(row.labelText,data.name);
                     }
                     else if(data.type == MediaPlayerItem.DIRECTORY)
                     {
                        row.type.visible = true;
                        row.type.gotoAndStop(1);
                        row.labelText.x = mView.labelTextX;
                        row.labelText.width = mView.labelTextWidth;
                        Text.format(row.labelText,data.name);
                     }
                     else
                     {
                        Text.format(row.labelText,data.name);
                     }
               }
            }
            else if(data.id == MediaPlayerTrackInfo.WILDCARD_ALL_ID && Peripheral.audioManager.source != Peripheral.audioManager.SOURCE_BLUETOOTH)
            {
               switch(data.type)
               {
                  case MediaPlayerItem.SONG:
                     if(LocaleArchive.getInstance().isMirrored())
                     {
                        Text.format(row.labelText,Text.rightToLeft(data.name) ? dataIndex + 1 + ". " + data.name : data.name + " ." + (dataIndex + 1));
                     }
                     else
                     {
                        Text.format(row.labelText,Text.rightToLeft(data.name) ? data.name + " ." + (dataIndex + 1) : dataIndex + 1 + ". " + data.name);
                     }
                     break;
                  case MediaPlayerItem.ALBUM:
                     Format.truncateWords(row.labelText,Text.getText(T.STRB_ALL_SONGS_BREADCRUMB));
                     break;
                  case MediaPlayerItem.ARTIST:
                     Format.truncateWords(row.labelText,Text.getText(T.STRB_ALL_ALBUMS_BREADCRUMB));
                     break;
                  case MediaPlayerItem.GENRE:
                     Format.truncateWords(row.labelText,Text.getText(T.STRB_ALL_ARTISTS_BREADCRUMB));
                     break;
                  default:
                     Format.truncateWords(row.labelText,data.name);
               }
            }
            else if(data.type == MediaPlayerItem.SONG)
            {
               if(LocaleArchive.getInstance().isMirrored())
               {
                  Text.format(row.labelText,Text.rightToLeft(data.name) ? dataIndex + 1 + ". " + data.name : data.name + " ." + (dataIndex + 1));
               }
               else
               {
                  Text.format(row.labelText,Text.rightToLeft(data.name) ? data.name + " ." + (dataIndex + 1) : dataIndex + 1 + ". " + data.name);
               }
            }
            else
            {
               Text.format(row.labelText,data.name);
            }
            row.displayMore.visible = !data.playable;
            if(rowIndex == 0)
            {
               this.updateScrollerPopup(mView.browse_scroller.decoration.popup);
            }
            if(this.mSearchActive)
            {
               Format.underline(row.underline,row.labelText,Peripheral.mediaPlayer.SearchText);
            }
            if(data.nowPlaying)
            {
               row.icon.visible = true;
            }
         }
         else
         {
            row.visible = false;
            row.setInteractive(false);
            row.labelText.text = "";
            row.displayMore.visible = false;
         }
      }
      
      private function get mGotoRootComplete() : Boolean
      {
         var GotoRootComplete:Boolean = false;
         return this.mAlbumsAvailable || this.mArtistsAvailable || this.mAudiobooksAvailable || this.mFoldersAvailable || this.mGenresAvailable || this.mPlaylistsAvailable || this.mPodcastsAvailable || this.mSongsAvailable;
      }
      
      private function getBrowseItems(firstItemIndex:int, lastItemIndex:int) : void
      {
         Peripheral.mediaPlayer.getBrowseItems(firstItemIndex,lastItemIndex - firstItemIndex + 1);
      }
      
      private function startWaiting(e:Event = null) : void
      {
         mView.btnAlphaJump_button.setEnabled(false);
         mView.btnAlphaJump_button.setInteractive(false);
         mView.btnSearch_button.setEnabled(false);
         mView.btnSearch_button.setInteractive(false);
         if(Boolean(this.mVRData) && this.mVRData.count == 0)
         {
            return;
         }
         this.waitingTimer.start();
      }
      
      private function stopWaiting(e:Event = null) : void
      {
         var alphaFlag:Boolean = this.determineAlphaJump();
         this.waitingTimer.reset();
         Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
         mView.btnAlphaJump_button.setEnabled(alphaFlag);
         mView.btnAlphaJump_button.setInteractive(alphaFlag);
         this.updateSearchButton();
      }
      
      private function onWaitingTooLong(e:TimerEvent) : void
      {
         this.waitingTimer.reset();
         Framework.popupManager.show(DynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
         Framework.Trace("INFO: Opened popup.");
      }
      
      private function onOpen(e:Event) : void
      {
         this.startWaiting();
         this.findAvailableViews();
         this.updateViewButtons();
         if(Peripheral.mediaPlayer.mediaFilterListShowErrorCode == 0 && (Peripheral.mediaPlayer.vrGenreFilterId > 0 || Peripheral.mediaPlayer.vrArtistFilterId > 0 || Peripheral.mediaPlayer.vrAlbumFilterId > 0 || Peripheral.mediaPlayer.vrPlaylistFilterId > -1 || Peripheral.mediaPlayer.vrPodcastFilterId > -1))
         {
            this.showVrListData();
         }
         else
         {
            this.setInitialView();
         }
      }
      
      private function onClose(e:Event = null) : void
      {
         Peripheral.mediaPlayer.SetmBrowseItemsRequestProcessing(false);
         this.removeBrowseItemListeners();
         this.startWaiting();
      }
      
      private function onMessage(evt:MessageEvent) : void
      {
         var offset:int = 0;
         if(evt.message.type == "alpha number")
         {
            this.mAlphaNumber = evt.message.value;
            this.mAlphaSearch = true;
            offset = int(Peripheral.mediaPlayer.indexFromStartCharacter(this.mAlphaNumber));
            mView.browse_scroller.setValue(offset);
            mView.browse_list.setPosition(offset);
            mView.browse_list.setCursor(offset);
         }
         else if(evt.message.type == "screen transition")
         {
            if(Peripheral.mediaPlayer.vrGenreFilterId > 0 || Peripheral.mediaPlayer.vrArtistFilterId > 0 || Peripheral.mediaPlayer.vrAlbumFilterId > 0 || Peripheral.mediaPlayer.vrPlaylistFilterId > -1 || Peripheral.mediaPlayer.vrPodcastFilterId > -1)
            {
               this.showVrListData();
            }
            else
            {
               this.setView(evt.message.value);
            }
         }
      }
      
      private function showVrListData() : void
      {
         var data:MediaPlayerPath = null;
         this.vrPath = "";
         this.initBreadcrumbs();
         if(Peripheral.mediaPlayer.vrPlaylistFilterId > -1)
         {
            this.mMenuState = 0;
            this.mCurrentView = MediaPlayerPath.PLAYLISTS;
            this.vrPath = this.vrPath + MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PLAYLISTS;
            pushBreadcrumb(new Breadcrumb(T.STRB_PLAYLISTS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
         }
         if(Peripheral.mediaPlayer.vrPodcastFilterId > -1)
         {
            this.mMenuState = 1;
            this.mCurrentView = MediaPlayerPath.PODCASTS;
            this.vrPath = this.vrPath + MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.PODCASTS;
            pushBreadcrumb(new Breadcrumb(T.STRB_PODCASTS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
         }
         if(Peripheral.mediaPlayer.vrGenreFilterId > 0)
         {
            this.mMenuState = 1;
            this.mCurrentView = MediaPlayerPath.GENRES;
            this.vrPath = this.vrPath + MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.GENRES;
            pushBreadcrumb(new Breadcrumb(T.STRB_GENRES_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
         }
         if(Peripheral.mediaPlayer.vrArtistFilterId > 0)
         {
            this.checkVrView = this.checkVrFilterIds(MediaPlayerPath.ARTISTS);
            if(this.checkVrView)
            {
               this.mMenuState = 0;
               this.mCurrentView = MediaPlayerPath.ARTISTS;
               this.vrPath = this.vrPath + MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ARTISTS;
               pushBreadcrumb(new Breadcrumb(T.STRB_ARTISTS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
               this.checkVrView = false;
            }
            else
            {
               this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrGenreFilterId;
               pushBreadcrumb(new Breadcrumb(T.STRB_ARTISTS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
            }
         }
         if(Peripheral.mediaPlayer.vrAlbumFilterId > 0)
         {
            this.checkVrView = this.checkVrFilterIds(MediaPlayerPath.ALBUMS);
            if(this.checkVrView)
            {
               if(Boolean(Peripheral.audioManager.isSourceIPod()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH)
               {
                  this.mMenuState = 0;
               }
               else
               {
                  this.mMenuState = 1;
               }
               this.mCurrentView = MediaPlayerPath.ALBUMS;
               this.vrPath = this.vrPath + MediaPlayerPath.METADATA_ROOT + "/" + MediaPlayerPath.ALBUMS;
               pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
            }
            else
            {
               this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrArtistFilterId;
               pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
            }
         }
         if(Peripheral.mediaPlayer.vrGenreFilterId > 0 || Peripheral.mediaPlayer.vrArtistFilterId > 0 || Peripheral.mediaPlayer.vrAlbumFilterId > 0 || Peripheral.mediaPlayer.vrPlaylistFilterId > -1 || Peripheral.mediaPlayer.vrPodcastFilterId > -1)
         {
            switch(Peripheral.mediaPlayer.vrMediaType)
            {
               case "title":
                  if(Peripheral.mediaPlayer.vrAlbumFilterId > 0)
                  {
                     this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrAlbumFilterId;
                     pushBreadcrumb(new Breadcrumb(T.STRB_SONGS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
                  }
                  else if(Peripheral.mediaPlayer.vrPodcastFilterId > -1)
                  {
                     this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrPodcastFilterId;
                     pushBreadcrumb(new Breadcrumb(T.STRB_MEDIA_EPISODES_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
                  }
                  else if(Peripheral.mediaPlayer.vrPlaylistFilterId > -1)
                  {
                     this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrPlaylistFilterId;
                     pushBreadcrumb(new Breadcrumb(T.STRB_SONGS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
                  }
                  break;
               case "album":
                  this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrArtistFilterId;
                  pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
                  break;
               case "artist":
                  this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrGenreFilterId;
                  pushBreadcrumb(new Breadcrumb(T.STRB_ARTISTS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
                  break;
               case "playlist":
                  this.vrPath = this.vrPath + "/" + MediaPlayerPath.ITEM + Peripheral.mediaPlayer.vrPlaylistFilterId;
                  pushBreadcrumb(new Breadcrumb(T.STRB_SONGS_BREADCRUMB,Breadcrumb.DELTA_FUNCTION,this.deltaBack,this.vrPath));
            }
            this.configureViewButtons();
            this.startWaiting();
            this.addBrowseItemListeners();
            this.clearList();
            mView.browse_list.setLength(this.mVRData.count);
            data = new MediaPlayerPath();
            data.path = this.vrPath;
            data.type = null;
            Peripheral.mediaPlayer.browsePath = data;
            t(mView.labelItemsInList,Format.itemsInList(this.mVRData.count));
         }
         this.checkVrView = true;
      }
      
      private function checkVrFilterIds(type:String) : Boolean
      {
         switch(type)
         {
            case MediaPlayerPath.PLAYLISTS:
               return false;
            case MediaPlayerPath.GENRES:
               return false;
            case MediaPlayerPath.ARTISTS:
               if(Peripheral.mediaPlayer.vrGenreFilterId == -1)
               {
                  return true;
               }
               return false;
               break;
            case MediaPlayerPath.ALBUMS:
               if(Peripheral.mediaPlayer.vrGenreFilterId == -1 && Peripheral.mediaPlayer.vrArtistFilterId == -1)
               {
                  return true;
               }
               return false;
               break;
            case MediaPlayerPath.SONGS:
               if(Peripheral.mediaPlayer.vrGenreFilterId == -1 && Peripheral.mediaPlayer.vrArtistFilterId == -1 && Peripheral.mediaPlayer.vrAlbumFilterId == -1)
               {
                  return true;
               }
               return false;
               break;
            default:
               return true;
         }
      }
      
      private function determineAlphaJump() : Boolean
      {
         var flag:Boolean = false;
         if(Peripheral.mediaPlayer.browsePath != null && Peripheral.mediaPlayer.browsePath.itemCount != 0)
         {
            flag = Boolean(Peripheral.mediaPlayer.browsePath.alphaJumpAvailable);
         }
         if(Boolean(this.mVRData) && (this.mVRData.alphaJumpAvailable == true || this.mVRData.alphaJumpAvailable == "true"))
         {
            flag = true;
         }
         return flag;
      }
      
      private function artistBtnClickEvent(e:Event = null) : void
      {
         if(this.mMenuState == 0)
         {
            this.viewAllArtists();
         }
      }
      
      private function playlistBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 0)
         {
            this.viewAllPlaylists();
         }
      }
      
      private function songBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 0)
         {
            this.viewAllSongs();
         }
      }
      
      private function albumBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 1 || this.mMenuState == 0 && (Boolean(Peripheral.audioManager.isSourceIPod()) || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_BLUETOOTH))
         {
            this.viewAllAlbums();
         }
      }
      
      private function genreBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 1)
         {
            this.viewAllGenres();
         }
      }
      
      private function podcastBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 1)
         {
            this.viewAllPodcasts();
         }
      }
      
      private function audioBooksBtnClickEvent(e:Event) : void
      {
         if(this.mMenuState == 1)
         {
            this.viewAllAudiobooks();
         }
      }
      
      private function foldersBtnClickEvent(e:Event = null) : void
      {
         if(this.mMenuState == 0)
         {
            this.viewAllfolders();
         }
      }
      
      private function toggleViewEvent(e:Event) : void
      {
         this.toggleViewButtons();
      }
      
      private function goToAlphaJumpScreen(e:Event) : void
      {
         this.startWaiting();
         mView.btnAlphaJump_button.setInteractive(false);
         mView.btnAlphaJump_button.setEnabled(false);
         attachListener(Peripheral.mediaPlayer,MediaPlayerEvent.BROWSE_CHARLIST,this.onAlphaBrowseCharItems);
         this.mAlphaJumpRequested = true;
         Peripheral.mediaPlayer.getAlphaJumpTable();
      }
      
      private function onAlphaBrowseCharItems(e:MediaPlayerEvent) : void
      {
         this.stopAlphaJump();
         Framework.popupManager.show(DynamicPopupNames.ALPHA_JUMP,Screens.POPUP_ALPHAJUMP,{
            "type":PopupType.SPELLER,
            "availableCharacters":Peripheral.mediaPlayer.startCharactersAvailable()
         });
      }
      
      protected function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         row.setSelected(selected);
      }
      
      private function convertTypeToDisplayName(type:String) : String
      {
         var displayName:String = null;
         switch(type)
         {
            case Peripheral.audioManager.SOURCE_AUX:
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
               displayName = "Bluetooth";
               break;
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               if(Peripheral.audioManager.isSourceIPod())
               {
                  displayName = "iPod";
               }
               else
               {
                  displayName = "USB";
               }
               break;
            case Peripheral.audioManager.SOURCE_SDCARD:
               displayName = compose(T.STRB_SD_CARD);
               break;
            default:
               displayName = compose(T.STRB_OTHER);
         }
         return displayName;
      }
      
      private function get mVRData() : Object
      {
         return Peripheral.mediaPlayer.VRData;
      }
      
      private function set mVRData(Value:Object) : void
      {
         Peripheral.mediaPlayer.VRData = Value;
         if(Value == null)
         {
            Peripheral.mediaPlayer.setvrIdValues(-1);
         }
      }
      
      private function checkSpecialChar(text:String) : int
      {
         var mSpecialChars:String = "!@#$%^&*()";
         var text1:String = text.charAt(0);
         return mSpecialChars.indexOf(text1);
      }
      
      private function goToSearchScreen(e:Event) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else if(Peripheral.mediaPlayer.browsePath.itemCount != 0 || Boolean(this.mVRData) && Boolean(this.mVRData.count != 0))
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.MEDIA_SEARCH_SPELLER,{"screen":DynamicPopupNames.MEDIA_SEARCH_SPELLER});
         }
      }
      
      private function onSpeedLockOut(e:VehicleStatusEvent) : void
      {
         this.updateSearchButton();
      }
      
      private function onSpellerPopupOk(e:GlobalEvent) : void
      {
         if(e.data.type == DynamicPopupNames.MEDIA_SEARCH_SPELLER)
         {
            this.mHistory.push({
               "position":mView.browse_list.getPosition(),
               "cursor":mView.browse_list.getCursor()
            });
            pushBreadcrumb(new Breadcrumb(T.STRB_SEARCH_RESULTS_BREADCRUMB,Breadcrumb.INERT));
            this.startWaiting();
            this.clearList();
            Peripheral.mediaPlayer.SearchText = e.data.input;
            Peripheral.mediaPlayer.getItemsFilterText(1);
         }
      }
      
      private function onVRCount(evt:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.SearchText != "")
         {
            this.switchToSearchView(false);
            Peripheral.mediaPlayer.SearchText = "";
         }
      }
      
      private function onSearchCount(evt:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.SearchText == "")
         {
            return;
         }
         this.switchToSearchView(true);
         if(evt.data != 0)
         {
            mView.browse_list.setLength(0);
            Peripheral.mediaPlayer.SetmBrowseItemsRequestProcessing(false);
            mView.browse_list.setLength(evt.data);
            t(mView.labelItemsInList,Format.itemsInList(evt.data));
         }
         else
         {
            this.clearList();
            this.stopWaiting();
            mView.browse_list.row_0_button.visible = true;
            mView.browse_list.row_0_button.icon.visible = false;
            t(mView.browse_list.row_0_button.labelText,T.STRB_SEARCH_NO_RESULTS_FOUND);
         }
      }
      
      private function switchToSearchView(search:Boolean) : void
      {
         this.mSearchActive = search;
         mView.btnClearResults_button.visible = search;
         mView.searchDescription.visible = search;
         mView.btnSearch_button.visible = !search;
         this.hideTheAlphaJumpButton(!search);
         mView.searchDescription.text = compose([T.STRB_SEARCH_RESULTS_FOR,Peripheral.mediaPlayer.SearchText]);
         if(search == false)
         {
            this.cancelSearchRequest();
            t(mView.browse_list.row_0_button.labelText,"");
         }
      }
      
      private function popBreadcrumbSearch() : void
      {
         if(Peripheral.mediaPlayer.SearchText != "")
         {
            popBreadcrumb();
         }
      }
      
      private function clearSearchResults(evt:MouseEvent) : void
      {
         this.mGoingBack = true;
         mView.browse_list.setLength(0);
         this.popBreadcrumbSearch();
         if(Boolean(this.mVRData) && this.mVRData.count != 0)
         {
            Peripheral.mediaPlayer.browsePath.itemCount = this.mVRData.count;
         }
         this.setBrowsePath(Peripheral.mediaPlayer.browsePath,false,false);
      }
      
      private function updateSearchButton() : void
      {
         var enable:Boolean = false;
         if(this.mCurrentView != null)
         {
            if(!Peripheral.vehicleStatus.speedLockOut)
            {
               if(Peripheral.mediaPlayer.browsePath.itemCount != 0 || Boolean(this.mVRData) && Boolean(this.mVRData.count != 0))
               {
                  enable = true;
                  mView.btnSearch_button.setInteractive(true);
               }
            }
            else
            {
               mView.btnSearch_button.setInteractive(true);
            }
         }
         mView.btnSearch_button.setEnabled(enable);
      }
      
      private function hideTheAlphaJumpButton(isShowAlpha:Boolean = true) : void
      {
         if(Global.region == TunerRegion.CHINA || Global.region == TunerRegion.JAPAN || Global.region == TunerRegion.KOREA)
         {
            mView.btnAlphaJump_button.visible = false;
            mView.btnSearch_button.x = mView.btnAlphaJump_button.x;
         }
         else
         {
            mView.btnAlphaJump_button.visible = isShowAlpha && !this.mSearchActive;
         }
      }
      
      private function pushDataToVector(dataItem:MediaPlayerPath) : void
      {
         if(this.mListVector == null)
         {
            this.mListVector = new Vector.<MediaPlayerPath>();
            this.mListVector.push(dataItem);
         }
         else
         {
            this.mListVector.push(dataItem);
         }
         Peripheral.mediaPlayer.setBrowselistLevel(this.mListVector);
      }
      
      private function setViewToDeepLevel(browsePath:String, elements:Array) : Boolean
      {
         var nameString:String = null;
         var newPath:MediaPlayerPath = new MediaPlayerPath();
         newPath.path = browsePath;
         this.mListVector = Peripheral.mediaPlayer.BrowselistLevelData;
         if(this.mListVector)
         {
            newPath.type = this.mListVector[this.mListVector.length - 1].type;
         }
         if(newPath.path != Peripheral.mediaPlayer.browsePath.path)
         {
            return false;
         }
         this.setBrowsePath(newPath,true);
         this.initBreadcrumbs();
         this.updateAlphaButton(true);
         switch(elements[1])
         {
            case MediaPlayerPath.ARTISTS:
               pushBreadcrumb(new Breadcrumb(T.STRB_ARTISTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllArtists,true));
               break;
            case MediaPlayerPath.PLAYLISTS:
               pushBreadcrumb(new Breadcrumb(T.STRB_PLAYLISTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllPlaylists,true));
               break;
            case MediaPlayerPath.SONGS:
               pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllAlbums,true));
               break;
            case MediaPlayerPath.ALBUMS:
               pushBreadcrumb(new Breadcrumb(T.STRB_ALBUMS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllAlbums,true));
               break;
            case MediaPlayerPath.GENRES:
               pushBreadcrumb(new Breadcrumb(T.STRB_GENRES_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllGenres,true));
               break;
            case MediaPlayerPath.PODCASTS:
               pushBreadcrumb(new Breadcrumb(T.STRB_PODCASTS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllPodcasts,true));
               break;
            case MediaPlayerPath.AUDIOBOOKS:
               pushBreadcrumb(new Breadcrumb(T.STRB_AUDIOBOOKS_BREADCRUMB,Breadcrumb.FUNCTION,this.viewAllAudiobooks,true));
               break;
            case MediaPlayerPath.FOLDERS:
               pushBreadcrumb(new Breadcrumb(T.STRB_FOLDERS_PLAYERBROWSE,Breadcrumb.FUNCTION,this.viewAllfolders,true));
         }
         this.popBreadcrumbSearch();
         for(var count:int = 0; count < this.mListVector.length; count++)
         {
            nameString = new String();
            if(this.mListVector[count].type != null)
            {
               switch(this.mListVector[count].type)
               {
                  case MediaPlayerItem.ALBUM:
                     nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                     break;
                  case MediaPlayerItem.ARTIST:
                     nameString = Peripheral.localeEngine.getText(T.STRB_ALBUMS_BREADCRUMB);
                     break;
                  case MediaPlayerItem.GENRE:
                     nameString = Peripheral.localeEngine.getText(T.STRB_ARTISTS_BREADCRUMB);
                     break;
                  case MediaPlayerItem.FOLDER:
                     nameString = Peripheral.localeEngine.getText(T.STRB_FOLDERS_PLAYERBROWSE);
                     break;
                  case MediaPlayerItem.PLAYLIST:
                     nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                     break;
                  case MediaPlayerItem.DIRECTORY:
                     nameString = this.mListVector[count].name;
                     break;
                  case MediaPlayerTrackInfo.WILDCARD_ALL:
                     nameString = Peripheral.localeEngine.getText(T.STRB_SONGS_BREADCRUMB);
                     break;
                  case MediaPlayerItem.PODCAST:
                     nameString = Peripheral.localeEngine.getText(T.STRB_MEDIA_EPISODES_BREADCRUMB);
                     break;
                  case MediaPlayerItem.AUDIOBOOK:
                     nameString = Peripheral.localeEngine.getText(T.STRB_MEDIA_CHAPTERS_BREADCRUMB);
                     break;
                  default:
                     nameString = this.mListVector[count].type;
               }
               pushBreadcrumb(new Breadcrumb(nameString,Breadcrumb.DELTA_FUNCTION,this.deltaBack,Peripheral.mediaPlayer.browsePath.path));
            }
         }
         return true;
      }
   }
}

