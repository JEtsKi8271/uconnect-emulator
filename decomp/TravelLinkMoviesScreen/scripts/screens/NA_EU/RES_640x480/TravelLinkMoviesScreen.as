package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.harman.navigation.NavigationApi;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Direction;
   import com.nfuzion.geographic.Distance;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.MessageEvent;
   import core.events.PopupManagerEvent;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextFormat;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class TravelLinkMoviesScreen extends TravelLinkGenericScreen
   {
      
      private static const TLM_VIEW_NO_DATA:int = 0;
      
      private static const TLM_VIEW_THEATER_BROWSE:int = 1;
      
      private static const TLM_VIEW_THEATER_BROWSE_FAV:int = 2;
      
      private static const TLM_VIEW_MOVIE_BROWSE:int = 3;
      
      private static const TLM_VIEW_MOVIE_LISTING:int = 4;
      
      private static const TLM_VIEW_SHOW_TIMES:int = 5;
      
      private static const TLM_VIEW_MOVIE_INFO:int = 6;
      
      private static const TLM_VIEW_THEATER_INFO:int = 7;
      
      private var mTLMView:int = 1;
      
      private var mLastView:Vector.<int> = new Vector.<int>();
      
      private var mCurrentView:MovieClip;
      
      private var mClosestTheaters:TravelLinkMoviesTheaterList = new TravelLinkMoviesTheaterList();
      
      private var mTheaterDetails:TravelLinkMoviesTheaterDetails = new TravelLinkMoviesTheaterDetails();
      
      private var mClosestMovies:TravelLinkMoviesMovieList = new TravelLinkMoviesMovieList();
      
      private var mMovieDetails:TravelLinkMoviesMovieDetails = new TravelLinkMoviesMovieDetails();
      
      private var mMovieListing:TravelLinkMoviesMovieListing = new TravelLinkMoviesMovieListing();
      
      private var mShowtimeIndex:uint = 0;
      
      private var mLastTheaterListPosition:uint = 0;
      
      private var mLastMovieListPosition:uint = 0;
      
      private var mLastMovieListingPosition:uint = 0;
      
      private var mTheaterForMovieFlag:Boolean = false;
      
      private var mshowTimes_labelSavedHeight:int = 0;
      
      private var mshowTimes_labelSavedVPos:int = 0;
      
      private var mshowTimes_labelFontSize:Object = 0;
      
      private var mCoordinates:Coordinates = new Coordinates();
      
      private var mTimeBtnPressed:Boolean = false;
      
      public function TravelLinkMoviesScreen()
      {
         mView = new C_TravelLinkMovieScreenView();
         cache = true;
         super();
      }
      
      override public function cleanup() : void
      {
         this.mCoordinates = null;
         this.mshowTimes_labelFontSize = null;
         this.mLastView = null;
         this.mCurrentView = null;
         this.mClosestTheaters = null;
         this.mTheaterDetails = null;
         this.mClosestMovies = null;
         this.mMovieDetails = null;
         this.mMovieListing = null;
         super.cleanup();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Framework.messenger.onSend(this.onMessage);
         attachListener(mView.back_button,MouseEvent.CLICK,this.onBackBtnClick);
         attachListener(mView.travelLink_button,MouseEvent.CLICK,goTravelLink);
         attachListener(mView.viewButtons_group,WidgetEvent.CLICK,this.onViewButtonGrpClick);
         attachListener(mView.refresh_button,MouseEvent.CLICK,this.onRefreshBtnClick);
         attachListener(mView.views_group.theaterBrowse_group.sortButtons_group,WidgetEvent.SELECT,this.onHighlightButton);
         if(Peripheral.travelLink.movies.serviceStatus == "READY")
         {
            this.onServiceStatus(null);
         }
         else
         {
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.MOVIES_SERVICE_STATUS,this.onServiceStatus);
         }
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_CONNECTED,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onPhoneStateChange);
         Framework.popupManager.addEventListener(GlobalEvent.SPEED_LOCKOUT_POPUP_USERCLOSED,this.onSpeedLimitPopupClosed);
         attachListener(Framework.popupManager,PopupManagerEvent.TIMEOUT,this.onSpeedLimitPopupTimeout);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         removeEventListener(PopupManagerEvent.TIMEOUT,this.onSpeedLimitPopupTimeout);
         Framework.popupManager.removeEventListener(GlobalEvent.SPEED_LOCKOUT_POPUP_USERCLOSED,this.onSpeedLimitPopupClosed);
      }
      
      private function onSpeedLimitPopupClosed(e:GlobalEvent) : void
      {
         Framework.echo("onSpeedLockUserClosed, back");
         goTravelLink();
      }
      
      private function onSpeedLimitPopupTimeout(e:PopupManagerEvent) : void
      {
         if(e != null && e.vars != null && e.vars.id == DynamicPopupNames.ERROR_ALERT)
         {
            Framework.echo("onSpeedLockUserClosed, back");
            goTravelLink();
         }
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.views_group.hideChildren();
         mView.itemsInList_label.visible = false;
         this.mCoordinates = Peripheral.travelLink.movies.coordinates;
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setRequireSelection(true);
         mView.views_group.theaterBrowse_group.columnHighlights_group.setExclusiveChildren(true);
         mView.views_group.theaterBrowse_group.sortButtons_group.setRadioButtons(true);
         mView.views_group.theaterBrowse_group.sortButtons_group.setRequireSelection(true);
         mView.views_group.theaterBrowse_group.sortButtons_group.setSelection("distance_button",false);
         mView.views_group.theaterBrowse_group.columnHighlights_group.distance_simple.show();
         var showTimesView:MovieClip = mView.views_group.showTimes_group.showTimes;
         this.mshowTimes_labelSavedHeight = showTimesView.showTimes_label.height;
         this.mshowTimes_labelSavedVPos = showTimesView.showTimes_label.y;
         var displayFormat:TextFormat = showTimesView.showTimes_label.getTextFormat();
         this.mshowTimes_labelFontSize = displayFormat.size;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mLastView = new Vector.<int>();
         this.mLastTheaterListPosition = 0;
         this.mLastMovieListPosition = 0;
         this.mLastMovieListingPosition = 0;
         this.mTheaterForMovieFlag = false;
         switch(screenVars.favoriteData)
         {
            case "favoriteDetails":
               t(mView.viewButtons_group.favorites_button.value_label,T.STRB_FAVOURITES);
               Peripheral.travelLink.movies.requestTheaterDetails(Peripheral.travelLink.movies.favoriteTheaterIdList[0]);
               break;
            default:
               Peripheral.travelLink.movies.requestServiceStatus();
               if(this.mClosestTheaters.length == 0)
               {
                  startWaiting();
               }
               Peripheral.travelLink.movies.requestClosestTheathers();
               this.switchView(TLM_VIEW_THEATER_BROWSE);
         }
         this.setListHeadingBar(true);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.viewButtons_group.theaterSearch_button,mView.viewButtons_group.movieSearch_button,mView.viewButtons_group.favorites_button,mView.refresh_button]));
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
      }
      
      private function setScreenState() : void
      {
         mView.views_group.hideChildren();
         this.mCurrentView.show();
         if(Peripheral.vehicleStatus.speedLockOut == true)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            Framework.popupManager.dequeue(DynamicPopupNames.ERROR_ALERT);
         }
      }
      
      private function setListHeadingBar(enabled:Boolean) : void
      {
         if(enabled)
         {
            Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.views_group.theaterBrowse_group.sortButtons_group.name_button,mView.views_group.theaterBrowse_group.sortButtons_group.distance_button,mView.views_group.movieBrowse_group.sortButton_group.sort_button,mView.views_group.movieListingNone_group.sortButtons_group.name_button,mView.views_group.movieListingNone_group.sortButtons_group.distance_button]));
         }
         else
         {
            Framework.focusManager.setFocus(FocusPriority.REGULAR);
            Framework.focusManager.delFocus(Framework.focusManager.getFocus());
         }
      }
      
      private function saveCurrentView() : void
      {
         this.mLastView.push(this.mTLMView);
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_TRAVEL_LINK_BREADCRUMB,Breadcrumb.FUNCTION,goTravelLink));
      }
      
      private function TimeTo12HourFormat(time24:String) : String
      {
         var timeArray:Array = null;
         var hourValue:Number = NaN;
         var amPM:String = null;
         var time12:String = "";
         if(time24 != null)
         {
            timeArray = time24.split(":");
            if(timeArray.length >= 2)
            {
               hourValue = Number(timeArray[0]);
               amPM = new String("PM");
               if(hourValue < 12)
               {
                  amPM = "AM";
                  if(hourValue < 1)
                  {
                     hourValue += 12;
                  }
               }
               else if(hourValue > 12)
               {
                  hourValue -= 12;
               }
               time12 = String(hourValue + ":" + timeArray[1] + amPM);
            }
         }
         return time12;
      }
      
      private function setNoDataView() : void
      {
         this.mCurrentView = mView.views_group.movieListingNone_group;
         switch(mView.viewButtons_group.getSelection())
         {
            case "theaterSearch_button":
            case "favorites_button":
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_MOVIE_LISTINGS_BREADCRUMB));
               break;
            case "movieSearch_button":
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_MOVIES_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_SEARCH_BREADCRUMB));
         }
         mView.itemsInList_label.visible = false;
         mView.list_scroller.setHideIfUseless(false);
         mView.list_scroller.setValue(0);
         mView.list_scroller.setVMaximum(0);
         this.setListHeadingBar(true);
         Framework.focusManager.setFocus(FocusPriority.REGULAR);
      }
      
      private function setTheaterView(showFavorite:Boolean) : void
      {
         this.mCurrentView = mView.views_group.theaterBrowse_group;
         if(this.mTheaterForMovieFlag == true)
         {
            mView.viewButtons_group.setSelection("movieSearch_button",false);
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_MOVIES_BREADCRUMB));
            pushBreadcrumb(new Breadcrumb(T.STRB_SEARCH_BREADCRUMB));
         }
         else
         {
            if(isFromTLFavScreen)
            {
               mView.viewButtons_group.setSelection("favorites_button",false);
            }
            else
            {
               mView.viewButtons_group.setSelection("theaterSearch_button",false);
            }
            this.initBreadcrumbs();
            pushBreadcrumb(new Breadcrumb(T.STRB_MOVIE_LISTINGS_BREADCRUMB));
         }
         var sortBy:String = this.mCurrentView.sortButtons_group.getSelection();
         if(sortBy == "name_button")
         {
            this.mClosestTheaters.sort("ascendingName");
         }
         else
         {
            this.mClosestTheaters.sort("ascendingDistance");
         }
         attachListener(this.mCurrentView.theater_list,WidgetEvent.SELECT,this.onTheaterSelect);
         this.mCurrentView.theater_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.theaterBrowse_group.theater_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.theaterBrowse_group.theater_list.selectEventHandler);
         this.mCurrentView.theater_list.setRowUpdater(this.initTheaterBrowseRow);
         this.mCurrentView.theater_list.update();
         this.mCurrentView.theater_list.setRowUpdater(this.updateTheaterBrowseRow);
         this.mCurrentView.theater_list.setDataRequester(this.requestTheaterBrowseData);
         this.mCurrentView.theater_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.theater_list.setLength(this.mClosestTheaters.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mClosestTheaters.length));
         mView.itemsInList_label.visible = true;
         this.mCurrentView.theater_list.setCursor(this.mLastTheaterListPosition);
         this.mCurrentView.theater_list.requestData();
         this.mCurrentView.theater_list.update();
         this.setListHeadingBar(true);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.theaterBrowse_group.theater_list.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function exitTheaterView() : void
      {
         if(this.mCurrentView == mView.views_group.theaterBrowse_group)
         {
            detachListener(this.mCurrentView.theater_list,WidgetEvent.SELECT,this.onMovieSelect);
            this.mCurrentView.theater_list.detachScroller();
            mView.list_scroller.setHideIfUseless(false);
            mView.list_scroller.setValue(0);
            mView.list_scroller.setVMaximum(0);
            this.mLastTheaterListPosition = this.mCurrentView.theater_list.getCursor();
         }
      }
      
      private function setMovieView() : void
      {
         this.mCurrentView = mView.views_group.movieBrowse_group;
         t(this.mCurrentView.sortButton_group.sort_button.value_label,T.STRB_ALPHAJUMP_TRAVELLINK);
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MOVIES_BREADCRUMB));
         pushBreadcrumb(new Breadcrumb(T.STRB_SEARCH_BREADCRUMB));
         mView.viewButtons_group.setSelection("movieSearch_button",false);
         attachListener(this.mCurrentView.sortButton_group,MouseEvent.CLICK,this.onAlphaJumpBtnClick);
         attachListener(this.mCurrentView.movie_list,WidgetEvent.SELECT,this.onMovieSelect);
         this.mCurrentView.movie_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.movieBrowse_group.movie_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.movieBrowse_group.movie_list.selectEventHandler);
         this.mCurrentView.movie_list.setRowUpdater(this.initMovieBrowseRow);
         this.mCurrentView.movie_list.update();
         this.mCurrentView.movie_list.setRowUpdater(this.updateMovieBrowseRow);
         this.mCurrentView.movie_list.setDataRequester(this.requestMovieBrowseData);
         this.mCurrentView.movie_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.movie_list.setLength(this.mClosestMovies.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mClosestMovies.length));
         mView.itemsInList_label.visible = true;
         this.mCurrentView.movie_list.setCursor(this.mLastMovieListPosition);
         this.mCurrentView.movie_list.update();
         this.setListHeadingBar(true);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.movieBrowse_group.movie_list.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.refresh_button.value_label,T.STRB_REFRESH_DATA);
         t(mView.viewButtons_group.theaterSearch_button.value_label,T.STRB_THEATRE_SEARCH);
         t(mView.viewButtons_group.movieSearch_button.value_label,T.STRB_MOVIE_SEARCH);
         t(mView.viewButtons_group.favorites_button.value_label,T.STRB_FAVOURITES);
         t(mView.views_group.theaterInfo_group.goNow_button.value_label,T.STRB_GO_NOW_TRAVELLINK);
         t(mView.views_group.theaterInfo_group.addToFavorites_button.value_label,T.STRB_ADD);
         t(mView.views_group.theaterInfo_group.call_button.value_label,T.STRB_CALL_TRAVELLINK);
         t(mView.views_group.theaterInfo_group.movieListing_button.value_label,T.STRB_MOVIE_LISTINGS);
         t(mView.views_group.movieListingNone_group.sortButtons_group.name_button.value_label,T.STRB_NAME);
         t(mView.views_group.movieListingNone_group.label_translate,T.STRB_NO_DATA_AVAILABLE);
         t(mView.views_group.movieListingNone_group.sortButtons_group.distance_button.value_label,T.STRB_DISTANCE_TRAVELLINKMOVIE);
         t(mView.views_group.theaterBrowse_group.sortButtons_group.name_button.value_label,T.STRB_NAME);
         t(mView.views_group.theaterBrowse_group.sortButtons_group.distance_button.value_label,T.STRB_DISTANCE_TRAVELLINKMOVIE);
         t(mView.views_group.showTimes_group.showTimes.info_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.movieListing_group.movie_list.row_0_group.info_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.movieListing_group.movie_list.row_1_group.info_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.theaterBrowse_group.theater_list.row_0_group.time_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.theaterBrowse_group.theater_list.row_1_group.time_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.theaterBrowse_group.theater_list.row_2_group.time_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.theaterBrowse_group.theater_list.row_3_group.time_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.theaterBrowse_group.theater_list.row_4_group.time_button.value_label,T.STRB_INFO_TRAVELLINK);
         t(mView.views_group.movieBrowse_group.sortButton_group.sort_button.value_label,T.STRB_ALPHAJUMP_TRAVELLINK);
         t(mView.views_group.message_group.message_label,T.STRB_FUNCTION_NOT_AVAILABLE);
         if(this.mCurrentView == mView.views_group.movieListing_group)
         {
            this.mCurrentView.movie_list.update();
         }
      }
      
      private function exitMovieView() : void
      {
         if(this.mCurrentView == mView.views_group.movieBrowse_group)
         {
            detachListener(this.mCurrentView.sortButton_group,MouseEvent.CLICK,this.onAlphaJumpBtnClick);
            detachListener(this.mCurrentView.movie_list,WidgetEvent.SELECT,this.onMovieSelect);
            this.mCurrentView.movie_list.detachScroller();
            mView.list_scroller.setHideIfUseless(false);
            mView.list_scroller.setValue(0);
            mView.list_scroller.setVMaximum(0);
            this.mLastMovieListPosition = this.mCurrentView.movie_list.getCursor();
         }
      }
      
      private function setMovieListingView() : void
      {
         this.mCurrentView = mView.views_group.movieListing_group;
         mView.refresh_button.visible = false;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MOVIE_LISTINGS_BREADCRUMB));
         t(this.mCurrentView.titleBar.theater_label,this.mMovieListing.theaterName);
         t(this.mCurrentView.titleBar.date_label,this.mMovieListing.date);
         attachListener(this.mCurrentView.movie_list,WidgetEvent.SELECT,this.onMovieListingSelect);
         this.mCurrentView.movie_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.movieListing_group.movie_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.movieListing_group.movie_list.selectEventHandler);
         this.mCurrentView.movie_list.setRowUpdater(this.initMovieListingRow);
         this.mCurrentView.movie_list.update();
         this.mCurrentView.movie_list.setRowUpdater(this.updateMovieListingRow);
         this.mCurrentView.movie_list.setDataRequester(this.requestMovieListingData);
         this.mCurrentView.movie_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.movie_list.setLength(this.mMovieListing.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mMovieListing.length));
         mView.itemsInList_label.visible = true;
         this.mCurrentView.movie_list.setCursor(this.mLastMovieListingPosition);
         this.mCurrentView.movie_list.update();
         this.setListHeadingBar(false);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.movieListing_group.movie_list.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function exitMovieListingView() : void
      {
         if(this.mCurrentView == mView.views_group.movieListing_group)
         {
            detachListener(this.mCurrentView.movie_list,WidgetEvent.SELECT,this.onMovieSelect);
            this.mCurrentView.movie_list.detachScroller();
            mView.list_scroller.setHideIfUseless(false);
            mView.list_scroller.setValue(0);
            mView.list_scroller.setVMaximum(0);
            this.mLastMovieListingPosition = this.mCurrentView.movie_list.getCursor();
         }
      }
      
      private function setShowTimeView() : void
      {
         var movieTimes:String = null;
         var i:int = 0;
         var j:int = 0;
         var time12:String = null;
         var fSize:* = 0;
         this.mCurrentView = mView.views_group.showTimes_group;
         mView.refresh_button.visible = false;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MOVIE_LISTINGS_BREADCRUMB));
         attachListener(this.mCurrentView.showTimes.info_button,MouseEvent.CLICK,this.onShowTimesInfoSelect);
         var movieShowtime:TravelLinkMoviesShowTimes = this.mMovieListing.getListingByIndex(this.mShowtimeIndex);
         var showTimeVector:Vector.<String> = new Vector.<String>();
         var time24:String = new String();
         if(Peripheral.clock.twelveHourTimeFormat == true)
         {
            for(j = 0; j < movieShowtime.numberOfShowTimes; j++)
            {
               time24 = movieShowtime.showTimes[j];
               time12 = this.TimeTo12HourFormat(time24);
               showTimeVector.push(time12);
            }
         }
         else
         {
            for each(time24 in movieShowtime.showTimes)
            {
               showTimeVector.push(time24);
            }
         }
         movieTimes = showTimeVector[0];
         for(i = 1; i < showTimeVector.length; i++)
         {
            movieTimes = movieTimes + ", " + showTimeVector[i];
         }
         this.mCurrentView.showTimes.showTimes_label.y = this.mshowTimes_labelSavedVPos;
         this.mCurrentView.showTimes.showTimes_label.height = this.mCurrentView.showTimes.height - this.mCurrentView.showTimes.showTimes_label.y + 5;
         t(this.mCurrentView.titleBar.theater_label,this.mMovieListing.theaterName);
         t(this.mCurrentView.titleBar.date_label,this.mMovieListing.date);
         t(this.mCurrentView.showTimes.movie_label,movieShowtime.movieTitle);
         t(this.mCurrentView.showTimes.showTimes_label,movieTimes);
         mView.itemsInList_label.visible = false;
         mView.list_scroller.setHideIfUseless(false);
         mView.list_scroller.setValue(0);
         mView.list_scroller.setVMaximum(0);
         var displayFormat:TextFormat = this.mCurrentView.showTimes.showTimes_label.getTextFormat();
         displayFormat.size = this.mshowTimes_labelFontSize;
         this.mCurrentView.showTimes.showTimes_label.setTextFormat(displayFormat);
         if(this.mCurrentView.showTimes.showTimes_label.numLines > this.mCurrentView.showTimes.showTimes_label.bottomScrollV)
         {
            this.mCurrentView.showTimes.showTimes_label.y = this.mshowTimes_labelSavedVPos - 10;
            while(this.mCurrentView.showTimes.showTimes_label.textHeight > this.mCurrentView.showTimes.showTimes_label.height - 6)
            {
               fSize = int(displayFormat.size);
               if(fSize < 9)
               {
                  break;
               }
               fSize--;
               displayFormat.size = fSize;
               this.mCurrentView.showTimes.showTimes_label.setTextFormat(displayFormat);
            }
         }
      }
      
      private function exitShowTimeView() : void
      {
         if(this.mCurrentView == mView.views_group.showTimes_group)
         {
            if(this.mshowTimes_labelSavedHeight > 0)
            {
               this.mCurrentView.showTimes.showTimes_label.height = this.mshowTimes_labelSavedHeight;
            }
            detachListener(this.mCurrentView.showTimes.info_button,MouseEvent.CLICK,this.onShowTimesInfoSelect);
         }
      }
      
      private function setMovieInfoView() : void
      {
         stopWaiting();
         this.mCurrentView = mView.views_group.movieInfo_group;
         mView.refresh_button.visible = false;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_MOVIE_LISTINGS_BREADCRUMB));
         t(this.mCurrentView.titleBar.movie_label,this.mMovieDetails.title);
         if(this.mMovieListing.date != null)
         {
            t(this.mCurrentView.titleBar.date_label,this.mMovieListing.date);
            this.mCurrentView.titleBar.date_label.visible = true;
         }
         else
         {
            this.mCurrentView.titleBar.date_label.visible = false;
         }
         t(this.mCurrentView.synopsisInfo.description_label,[T.STRB_ACTORS,": ",this.mMovieDetails.actors,"\n",T.STRB_DURATION,": ",this.mMovieDetails.runTime.toString(),T.STRB_MIN,"\n",T.STRB_RATING,": ",this.mMovieDetails.rating,"\n",T.STRB_SYNOPSIS,": ",this.mMovieDetails.synopsis],TRUNCATE_WORDS);
         mView.itemsInList_label.visible = false;
         this.setListHeadingBar(false);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.movieInfo_group.synopsisInfo.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function setTheaterInfoView(showFavorite:Boolean) : void
      {
         this.mCurrentView = mView.views_group.theaterInfo_group;
         mView.refresh_button.visible = false;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_THEATRE_INFORMATION_BREADCRUMB));
         var theaterName:String = this.mTheaterDetails.description;
         attachListener(this.mCurrentView.movieListing_button,MouseEvent.CLICK,this.onTheaterInfoMovieListingClick);
         attachListener(this.mCurrentView.addToFavorites_button,MouseEvent.CLICK,this.onTheaterInfoAddToFavClick);
         attachListener(this.mCurrentView.call_button,MouseEvent.CLICK,this.onTheaterInfoCallClick);
         attachListener(this.mCurrentView.goNow_button,MouseEvent.CLICK,this.onGoNowClick);
         mView.list_scroller.visible = false;
         mView.itemsInList_label.visible = false;
         t(this.mCurrentView.name_label,theaterName);
         t(this.mCurrentView.address_label,this.mTheaterDetails.street + "\n" + this.mTheaterDetails.city + ", " + this.mTheaterDetails.state + " " + this.mTheaterDetails.zip);
         t(this.mCurrentView.phone_label,this.mTheaterDetails.phone);
         this.mCurrentView.favorite_icon.visible = this.mTheaterDetails.isFavorite;
         this.mCurrentView.addToFavorites_button.setEnabled(!this.mTheaterDetails.isFavorite);
         this.mCurrentView.addToFavorites_button.setInteractive(!this.mTheaterDetails.isFavorite);
         this.mCurrentView.call_button.setEnabled(phoneAvailable);
         this.mCurrentView.call_button.setInteractive(true);
         this.setListHeadingBar(false);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.theaterInfo_group.movieListing_button,mView.views_group.theaterInfo_group.call_button,mView.views_group.theaterInfo_group.goNow_button,mView.views_group.theaterInfo_group.addToFavorites_button]));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function exitTheaterInfoView() : void
      {
         if(this.mCurrentView == mView.views_group.theaterInfo_group)
         {
            detachListener(this.mCurrentView.movieListing_button,MouseEvent.CLICK,this.onTheaterInfoMovieListingClick);
            detachListener(this.mCurrentView.addToFavorites_button,MouseEvent.CLICK,this.onTheaterInfoAddToFavClick);
            detachListener(this.mCurrentView.call_button,MouseEvent.CLICK,this.onTheaterInfoCallClick);
            detachListener(this.mCurrentView.goNow_button,MouseEvent.CLICK,this.onGoNowClick);
         }
      }
      
      private function switchView(view:int, save:Boolean = true) : void
      {
         if(view == this.mTLMView)
         {
            save = false;
         }
         if(save)
         {
            if(!screenVars.favoriteData)
            {
               this.saveCurrentView();
            }
         }
         if(view == TLM_VIEW_THEATER_BROWSE || view == TLM_VIEW_THEATER_BROWSE_FAV || view == TLM_VIEW_MOVIE_BROWSE)
         {
            if(this.mTimeBtnPressed)
            {
               this.mTimeBtnPressed = false;
            }
            else
            {
               this.mLastView.length = 0;
            }
         }
         mView.list_scroller.visible = true;
         mView.refresh_button.visible = true;
         switch(this.mTLMView)
         {
            case TLM_VIEW_NO_DATA:
               break;
            case TLM_VIEW_THEATER_BROWSE:
               this.exitTheaterView();
               break;
            case TLM_VIEW_THEATER_BROWSE_FAV:
               Peripheral.travelLink.movies.requestClosestTheathers();
               break;
            case TLM_VIEW_MOVIE_BROWSE:
               this.exitMovieView();
               break;
            case TLM_VIEW_MOVIE_LISTING:
               this.exitMovieListingView();
               break;
            case TLM_VIEW_SHOW_TIMES:
               this.exitShowTimeView();
               break;
            case TLM_VIEW_MOVIE_INFO:
            case TLM_VIEW_THEATER_INFO:
         }
         this.mTLMView = view;
         switch(view)
         {
            case TLM_VIEW_NO_DATA:
               this.setNoDataView();
               break;
            case TLM_VIEW_THEATER_BROWSE:
               this.setTheaterView(false);
               break;
            case TLM_VIEW_THEATER_BROWSE_FAV:
               this.mClosestTheaters.filterFavoritesOnly();
               this.setTheaterView(true);
               break;
            case TLM_VIEW_MOVIE_BROWSE:
               this.setMovieView();
               break;
            case TLM_VIEW_MOVIE_LISTING:
               this.setMovieListingView();
               break;
            case TLM_VIEW_SHOW_TIMES:
               this.setShowTimeView();
               break;
            case TLM_VIEW_MOVIE_INFO:
               this.setMovieInfoView();
               break;
            case TLM_VIEW_THEATER_INFO:
               this.setTheaterInfoView(true);
         }
         this.setScreenState();
      }
      
      private function get getView() : int
      {
         return this.mTLMView;
      }
      
      private function initTheaterBrowseRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesTheater, dataIndex:int) : void
      {
         row.theater_button.name_label.visible = false;
         row.theater_button.distance_label.visible = false;
         row.theater_button.direction_icon.visible = false;
         row.theater_button.favorite_icon.gotoAndStop("fav");
         row.theater_button.favorite_icon.visible = false;
         row.time_button.visible = false;
      }
      
      private function updateTheaterBrowseRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesTheater, dataIndex:int) : void
      {
         var theaterDistance:Distance = null;
         var displayDistance:String = null;
         if(data)
         {
            t(row.theater_button.name_label,data.description);
            theaterDistance = new Distance();
            theaterDistance.miles = data.distance;
            if(isNaN(theaterDistance.meters))
            {
               displayDistance = compose(T.STRB_NA);
            }
            else if(useUSDistanceUnits())
            {
               displayDistance = compose([theaterDistance.miles.toFixed(1),T.STRB_MI]);
            }
            else
            {
               displayDistance = compose([theaterDistance.kilometers.toFixed(1),T.STRB_KM]);
            }
            t(row.theater_button.distance_label,displayDistance);
            if(!isNaN(data.bearing))
            {
               row.theater_button.direction_icon.visible = true;
               row.theater_button.direction_icon.gotoAndStop(data.direction);
            }
            else
            {
               row.theater_button.direction_icon.visible = false;
            }
            if(data.isFavorite)
            {
               row.theater_button.favorite_icon.gotoAndStop("fav");
               row.theater_button.favorite_icon.visible = true;
            }
            else
            {
               row.theater_button.favorite_icon.visible = false;
            }
            row.theater_button.name_label.visible = true;
            row.theater_button.distance_label.visible = true;
            row.theater_button.direction_icon.visible = true;
            row.time_button.visible = true;
         }
         else
         {
            row.theater_button.name_label.visible = false;
            row.theater_button.distance_label.visible = false;
            row.theater_button.direction_icon.visible = false;
            row.theater_button.favorite_icon.visible = false;
            row.time_button.visible = false;
         }
      }
      
      private function requestTheaterBrowseData(start:int, end:int) : void
      {
         if(this.mTLMView == TLM_VIEW_THEATER_BROWSE || this.mTLMView == TLM_VIEW_THEATER_BROWSE_FAV)
         {
            this.mCurrentView.theater_list.setData({
               "offset":start,
               "list":this.mClosestTheaters.getTheaterByRange(start,end)
            });
         }
      }
      
      private function initMovieBrowseRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesMovie, dataIndex:int) : void
      {
         row.movie_button.title_label.visible = false;
         row.time_button.visible = false;
      }
      
      private function updateMovieBrowseRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesMovie, dataIndex:int) : void
      {
         if(data)
         {
            t(row.movie_button.title_label,data.title);
            row.movie_button.title_label.visible = true;
            row.time_button.visible = true;
         }
         else
         {
            row.movie_button.title_label.visible = false;
            row.time_button.visible = false;
         }
      }
      
      private function requestMovieBrowseData(start:int, end:int) : void
      {
         if(this.mTLMView == TLM_VIEW_MOVIE_BROWSE)
         {
            this.mCurrentView.movie_list.setData({
               "offset":start,
               "list":this.mClosestMovies.getMovieByRange(start,end)
            });
         }
      }
      
      private function initMovieListingRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesShowTimes, dataIndex:int) : void
      {
         row.showTime_button.title_label.visible = false;
         row.showTime_button.showTime_label.visible = false;
         row.info_button.visible = false;
      }
      
      private function updateMovieListingRow(row:MovieClip, rowNumber:int, data:TravelLinkMoviesShowTimes, dataIndex:int) : void
      {
         var movieTimes:String = null;
         var i:int = 0;
         var time12:String = null;
         if(data)
         {
            t(row.showTime_button.title_label,data.movieTitle);
            if(data.numberOfShowTimes > 0)
            {
               if(Peripheral.clock.twelveHourTimeFormat == true)
               {
                  time12 = this.TimeTo12HourFormat(data.showTimes[0]);
                  movieTimes = compose([T.STRB_SHOW_TIMES,": ",time12]);
                  for(i = 1; i < data.numberOfShowTimes; i++)
                  {
                     movieTimes = movieTimes + ", " + this.TimeTo12HourFormat(data.showTimes[i]);
                  }
               }
               else
               {
                  movieTimes = compose([T.STRB_SHOW_TIMES,": ",data.showTimes[0]]);
                  for(i = 1; i < data.numberOfShowTimes; i++)
                  {
                     movieTimes = movieTimes + ", " + data.showTimes[i];
                  }
               }
               t(row.showTime_button.showTime_label,movieTimes);
               row.showTime_button.showTime_label.visible = true;
            }
            else
            {
               row.showTime_button.showTime_label.visible = false;
            }
            row.showTime_button.title_label.visible = true;
            row.info_button.visible = true;
         }
         else
         {
            row.showTime_button.title_label.visible = false;
            row.showTime_button.showTime_label.visible = false;
            row.info_button.visible = false;
         }
      }
      
      private function requestMovieListingData(start:int, end:int) : void
      {
         if(this.mTLMView == TLM_VIEW_MOVIE_LISTING)
         {
            this.mCurrentView.movie_list.setData({
               "offset":start,
               "list":this.mMovieListing.getListingByRange(start,end)
            });
         }
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         (row.getChildAt(0) as MovieClip).setSelected(selected);
      }
      
      private function onServiceStatus(e:TravelLinkMoviesEvent) : void
      {
         if(Peripheral.travelLink.movies.serviceStatus == "READY")
         {
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.CLOSEST_THEATER_LIST,this.procClosestTheaterListChange);
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.MOVIE_LOCATION_LIST,this.procTheaterForMovieListChange);
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.DETAILED_THEATHER_INFO,this.procTheaterDetails);
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.MOVIE_SCHEDULE_LIST,this.procTheaterListing);
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.CLOSEST_MOVIE_LIST,this.procClosestMovieListChange);
            attachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.DETAILED_MOVIE_INFO,this.procMovieDetails);
            detachListener(Peripheral.travelLink.movies,TravelLinkMoviesEvent.MOVIES_SERVICE_STATUS,this.onServiceStatus);
            this.mClosestTheaters = Peripheral.travelLink.movies.getClosestTheathers("");
            if(this.mClosestTheaters.length == 0)
            {
               Peripheral.travelLink.movies.requestClosestTheathers();
            }
            this.mCoordinates = Peripheral.travelLink.movies.coordinates;
            stopWaiting();
         }
         else
         {
            Peripheral.travelLink.movies.requestServiceStatus();
         }
      }
      
      override protected function onFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
         if(fromTLFavScreen)
         {
            mView.viewButtons_group.setSelection(FAVORITES_BUTTON);
         }
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBackBtnClick();
      }
      
      private function onBackBtnClick(e:Event = null) : void
      {
         if(!isBackAfterJustAddedFavorite())
         {
            if(this.mLastView.length == 0)
            {
               super.back();
            }
            else
            {
               this.switchView(this.mLastView.pop(),false);
            }
         }
      }
      
      private function onAlphaJumpBtnClick(e:Event) : void
      {
         Framework.popupManager.show(DynamicPopupNames.ALPHA_JUMP,Screens.POPUP_ALPHAJUMP,{
            "type":PopupType.SPELLER,
            "availableCharacters":this.mClosestMovies.startCharactersAvailable()
         });
      }
      
      private function onMessage(evt:MessageEvent) : void
      {
         var i:int = 0;
         var tempMovie:TravelLinkMoviesMovie = null;
         var alphaNumber:String = null;
         if(evt.message.type == "alpha number")
         {
            alphaNumber = evt.message.value;
            for(i = 0; i < this.mClosestMovies.length; i++)
            {
               tempMovie = this.mClosestMovies.getMovieByIndex(i);
               if(alphaNumber == tempMovie.title.charAt(0))
               {
                  break;
               }
            }
            this.mCurrentView.movie_list.setPosition(i);
            this.mCurrentView.movie_list.setCursor(i);
            this.mCurrentView.movie_list.update();
         }
      }
      
      private function onViewButtonGrpClick(e:WidgetEvent) : void
      {
         var button:String = String(e.data.name);
         this.mLastTheaterListPosition = 0;
         this.mLastMovieListPosition = 0;
         this.mLastMovieListingPosition = 0;
         JustAddedFavorite = false;
         switch(button)
         {
            case "theaterSearch_button":
               if(this.mTheaterForMovieFlag == true)
               {
                  Peripheral.travelLink.movies.requestClosestTheathers();
               }
               else
               {
                  this.switchView(TLM_VIEW_THEATER_BROWSE,true);
                  Peripheral.travelLink.movies.requestClosestTheathers();
                  if(this.mClosestTheaters.length == 0)
                  {
                     startWaiting();
                  }
               }
               this.mTheaterForMovieFlag = false;
               isFromTLFavScreen = false;
               break;
            case "movieSearch_button":
               this.switchView(TLM_VIEW_MOVIE_BROWSE,true);
               Peripheral.travelLink.movies.requestClosestMovies();
               isFromTLFavScreen = false;
               if(this.mClosestMovies.length == 0)
               {
                  startWaiting();
               }
               break;
            case "favorites_button":
               goFavorite();
         }
      }
      
      private function onHighlightButton(e:WidgetEvent = null) : void
      {
         var highlights:MovieClip = mView.views_group.theaterBrowse_group.columnHighlights_group;
         Peripheral.travelLink.movies.requestClosestTheathers();
         switch(e.data.targetName)
         {
            case "name_button":
               highlights.name_simple.show();
               this.mClosestTheaters.sort("ascendingName");
               break;
            case "distance_button":
               highlights.distance_simple.show();
               this.mClosestTheaters.sort("ascendingDistance");
         }
         this.mCurrentView.theater_list.setPosition(0);
         this.mCurrentView.theater_list.requestData();
         this.mCurrentView.theater_list.update();
      }
      
      private function onRefreshBtnClick(e:Event) : void
      {
         var viewButtonName:String = mView.viewButtons_group.getSelection();
         this.mLastTheaterListPosition = 0;
         this.mLastMovieListPosition = 0;
         this.mLastMovieListingPosition = 0;
         startWaiting();
         if(viewButtonName == "theaterSearch_button")
         {
            this.mLastMovieListPosition = 0;
            Peripheral.travelLink.movies.requestClosestTheathers();
         }
         else if(viewButtonName == "movieSearch_button")
         {
            this.mLastTheaterListPosition = 0;
            Peripheral.travelLink.movies.requestClosestMovies();
         }
      }
      
      private function onTheaterSelect(e:WidgetEvent) : void
      {
         var theaterId:int = int(e.data.data.theaterId);
         var targetName:String = e.data.targetName;
         Framework.Trace(targetName);
         startWaiting();
         if(targetName == "theater_button")
         {
            Peripheral.travelLink.movies.requestMovieListings(theaterId);
         }
         else
         {
            if(targetName == "time_button")
            {
               this.mTimeBtnPressed = true;
            }
            Peripheral.travelLink.movies.requestTheaterDetails(theaterId);
         }
      }
      
      private function onTheaterInfoMovieListingClick(e:Event) : void
      {
         startWaiting();
         Peripheral.travelLink.movies.requestMovieListings(this.mTheaterDetails.theaterId);
      }
      
      private function onTheaterInfoAddToFavClick(e:Event) : void
      {
         var cityStateZip:String = this.mTheaterDetails.city + ", " + this.mTheaterDetails.state + " " + this.mTheaterDetails.zip;
         var favAction:String = Peripheral.travelLink.movies.favoriteTheaterIdList.length >= 1 ? Peripheral.travelLink.replaceFavorite : Peripheral.travelLink.addFavorite;
         var favObj:Object = {
            "line1":this.mTheaterDetails.description,
            "line2":this.mTheaterDetails.street,
            "line3":cityStateZip,
            "line4":this.mTheaterDetails.phone,
            "action":favAction,
            "service":Peripheral.travelLink.TLMovies
         };
         addToFavoritesPopup(favObj);
      }
      
      override protected function onConfirmedAddToFavorites() : void
      {
         Peripheral.travelLink.movies.setFavoriteTheater(this.mTheaterDetails.theaterId);
         mView.views_group.theaterInfo_group.favorite_icon.visible = true;
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         this.mCurrentView.addToFavorites_button.setEnabled(false);
         this.mCurrentView.addToFavorites_button.setInteractive(false);
         JustAddedFavorite = true;
      }
      
      private function onTheaterInfoCallClick(e:MouseEvent) : void
      {
         if(phoneAvailable)
         {
            dial(this.mTheaterDetails.phone);
         }
         else if(!Peripheral.vehicleStatus.speedLockOut)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "status":"no phone paired",
               "timeout":30000
            });
         }
      }
      
      private function onGoNowClick(e:MouseEvent) : void
      {
         var addressArray:Array = this.mTheaterDetails.street.split(" ");
         var houseNumber:String = addressArray[0];
         addressArray.shift();
         var street:String = addressArray.join(" ");
         var navString:String = "<GEO>" + this.mTheaterDetails.longitude.toFixed(6) + " " + this.mTheaterDetails.latitude.toFixed(6) + "<*>" + "<CTR>United States<*>" + "<CUSTOM_NAME>" + this.mTheaterDetails.description + "<*>" + "<TEL>" + this.mTheaterDetails.phone + "<*>" + "<ZIP>" + this.mTheaterDetails.zip + "<*>" + "<CTY>" + this.mTheaterDetails.city + "<*>" + "<HNO>" + houseNumber + "<*>" + "<STR>" + street + "<*>";
         Peripheral.navigation.navDomainControl.setExternalDestination(navString,"mainbackground/menu/travellinkmoviesscreen");
      }
      
      private function onMovieSelect(e:WidgetEvent) : void
      {
         var movieId:int = int(e.data.data.movieId);
         var targetName:String = e.data.targetName;
         startWaiting();
         if(targetName == "movie_button")
         {
            Peripheral.travelLink.movies.requestMovieDetails(movieId);
         }
         else
         {
            if(targetName == "time_button")
            {
               this.mTimeBtnPressed = true;
            }
            this.mLastTheaterListPosition = 0;
            Peripheral.travelLink.movies.requestTheathersForMovie(movieId);
         }
      }
      
      private function onMovieListingSelect(e:WidgetEvent) : void
      {
         var movieId:int = int(e.data.data.movieId);
         var targetName:String = e.data.targetName;
         Framework.Trace(targetName);
         if(targetName == "info_button")
         {
            startWaiting();
            Peripheral.travelLink.movies.requestMovieDetails(movieId);
         }
         else if(e.data.data.showTimes.length > 0)
         {
            this.mShowtimeIndex = e.data.dataIndex;
            this.switchView(TLM_VIEW_SHOW_TIMES);
         }
      }
      
      private function onShowTimesInfoSelect(e:Event) : void
      {
         var movieShowtime:TravelLinkMoviesShowTimes = this.mMovieListing.getListingByIndex(this.mShowtimeIndex);
         startWaiting();
         Peripheral.travelLink.movies.requestMovieDetails(movieShowtime.movieId);
      }
      
      override protected function onWaitingTimeout() : void
      {
         Framework.Trace("TLM: Please wait 4min timeout");
         this.switchView(TLM_VIEW_NO_DATA,false);
      }
      
      override protected function positionUpdate(coordinates:Coordinates) : void
      {
         var tempDistance:Distance = null;
         var tempDirection:Direction = null;
         var bearing:Direction = null;
         var tempCoordinates:Coordinates = null;
         var currentDirection:Number = NaN;
         var i:uint = 0;
         if(coordinates.latitude == 0 && coordinates.longitude == 0)
         {
            this.mCoordinates = Peripheral.travelLink.movies.coordinates;
         }
         else
         {
            this.mCoordinates = coordinates;
         }
         if(this.mCurrentView == mView.views_group.theaterBrowse_group)
         {
            tempDistance = new Distance();
            tempDirection = new Direction();
            bearing = new Direction();
            tempCoordinates = new Coordinates();
            currentDirection = 360 - Number(NavigationApi.api.posPositionInformation.getType("<DIR>")) / 255 * 360;
            for(i = 0; i < this.mClosestTheaters.length; i++)
            {
               tempCoordinates.latitude = this.mClosestTheaters.getLatitude(i);
               tempCoordinates.longitude = this.mClosestTheaters.getLongitude(i);
               tempDistance = this.mCoordinates.distanceTo(tempCoordinates);
               this.mClosestTheaters.setDistance(i,tempDistance.miles);
               bearing = this.mCoordinates.bearingTo(tempCoordinates);
               tempDirection.degrees = bearing.degrees - currentDirection;
               if(tempDirection.degrees < 0)
               {
                  tempDirection.degrees = (tempDirection.degrees + 360) % 360;
               }
               this.mClosestTheaters.setBearing(i,tempDirection.degrees);
            }
            this.mCurrentView.theater_list.update();
         }
      }
      
      private function procClosestTheaterListChange(e:TravelLinkMoviesEvent) : void
      {
         var haveDirection:Boolean;
         var i:uint;
         var currentDirection:Number = NaN;
         var tempDistance:Distance = new Distance();
         var tempDirection:Direction = new Direction();
         var bearing:Direction = new Direction();
         var tempCoordinates:Coordinates = new Coordinates();
         this.mCoordinates = Peripheral.travelLink.movies.coordinates;
         haveDirection = true;
         try
         {
            currentDirection = 360 - Number(NavigationApi.api.posPositionInformation.getType("<DIR>")) / 255 * 360;
         }
         catch(err:Error)
         {
            haveDirection = false;
         }
         this.mClosestTheaters = Peripheral.travelLink.movies.getClosestTheathers(null);
         for(i = 0; i < this.mClosestTheaters.length; i++)
         {
            tempCoordinates.latitude = this.mClosestTheaters.getLatitude(i);
            tempCoordinates.longitude = this.mClosestTheaters.getLongitude(i);
            tempDistance = this.mCoordinates.distanceTo(tempCoordinates);
            this.mClosestTheaters.setDistance(i,tempDistance.miles);
            if(haveDirection)
            {
               bearing = this.mCoordinates.bearingTo(tempCoordinates);
               tempDirection.degrees = bearing.degrees - currentDirection;
               if(tempDirection.degrees < 0)
               {
                  tempDirection.degrees = (tempDirection.degrees + 360) % 360;
               }
               this.mClosestTheaters.setBearing(i,tempDirection.degrees);
            }
            else
            {
               this.mClosestTheaters.setBearing(i,currentDirection);
            }
         }
         stopWaiting();
         if(this.mTLMView == TLM_VIEW_THEATER_BROWSE || this.mTLMView == TLM_VIEW_NO_DATA || this.mTheaterForMovieFlag == true)
         {
            if(this.mClosestTheaters.length != 0)
            {
               this.switchView(TLM_VIEW_THEATER_BROWSE);
            }
            else
            {
               this.switchView(TLM_VIEW_NO_DATA,false);
            }
         }
      }
      
      private function procTheaterForMovieListChange(e:TravelLinkMoviesEvent) : void
      {
         this.mTheaterForMovieFlag = true;
         this.procClosestTheaterListChange(e);
      }
      
      private function procTheaterDetails(e:TravelLinkMoviesEvent) : void
      {
         this.mTheaterDetails = Peripheral.travelLink.movies.getTheaterDetails();
         stopWaiting();
         this.switchView(TLM_VIEW_THEATER_INFO);
      }
      
      private function procTheaterListing(e:TravelLinkMoviesEvent) : void
      {
         this.mMovieListing = Peripheral.travelLink.movies.getMovieListings(null);
         stopWaiting();
         this.switchView(TLM_VIEW_MOVIE_LISTING);
      }
      
      private function procClosestMovieListChange(e:TravelLinkMoviesEvent) : void
      {
         this.mClosestMovies = Peripheral.travelLink.movies.getClosestMovies(null);
         stopWaiting();
         if(this.mClosestMovies.length != 0)
         {
            this.switchView(TLM_VIEW_MOVIE_BROWSE);
         }
         else
         {
            this.switchView(TLM_VIEW_NO_DATA,false);
         }
      }
      
      private function procMovieDetails(e:TravelLinkMoviesEvent) : void
      {
         this.mMovieDetails = Peripheral.travelLink.movies.getMovieDetails();
         stopWaiting();
         this.switchView(TLM_VIEW_MOVIE_INFO);
      }
      
      private function onPhoneStateChange(e:BluetoothEvent) : void
      {
         if(this.mCurrentView == mView.views_group.theaterInfo_group)
         {
            this.mCurrentView.call_button.setEnabled(phoneAvailable);
         }
      }
      
      override protected function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         super.onSpeedLockout(e);
         this.setScreenState();
      }
   }
}

