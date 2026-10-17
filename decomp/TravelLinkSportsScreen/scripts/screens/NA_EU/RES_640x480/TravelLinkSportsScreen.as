package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class TravelLinkSportsScreen extends TravelLinkGenericScreen
   {
      
      private static const TLS_VIEW_NO_DATA:int = 0;
      
      private static const TLS_VIEW_SPORTS_LIST:int = 1;
      
      private static const TLS_VIEW_SPORTS_SCORE:int = 2;
      
      private static const TLS_VIEW_GAME_DETAIL:int = 3;
      
      private static const TLS_VIEW_TEAM_DETAIL:int = 4;
      
      private static const TLS_VIEW_HEADLINE_DETAIL:int = 5;
      
      private static const TLS_VIEW_TABULAR_LIST:int = 6;
      
      private static const TLS_VIEW_RANKED_LIST_4:int = 7;
      
      private static const TLS_VIEW_RANKED_LIST_3:int = 8;
      
      private static const TLS_VIEW_MORE_INFO:int = 9;
      
      private static const BACK_XM_HISTORY:int = 1;
      
      private static const BACK_XM_CURRENT:int = 2;
      
      private static const BACK_FRAMEWORK:int = 3;
      
      private static const BROWSESPORTS_BUTTON:String = "browseSports_button";
      
      private static const LEAGUE_BUTTON:String = "league_button";
      
      private static const FAVORITES_BUTTON:String = "favorites_button";
      
      private var mTLSView:int = 1;
      
      private var mLastView:Vector.<Object> = new Vector.<Object>();
      
      private var mCurrentView:MovieClip;
      
      private var mCurrentList:TravelLinkSportsGenericList = new TravelLinkSportsGenericList();
      
      private var mCurrentGameList:TravelLinkSportsGameList = new TravelLinkSportsGameList();
      
      private var mCurrentGame:TravelLinkSportsGameListItem = new TravelLinkSportsGameListItem();
      
      private var mCurrentTeam:Object = new Object();
      
      private var mCurrentTeamId:int;
      
      private var mCurrentHeadline:TravelLinkSportsNewsItem = new TravelLinkSportsNewsItem();
      
      private var mHeadlineList:Boolean = false;
      
      private var mCurrentTable:TravelLinkSportsTable = new TravelLinkSportsTable();
      
      private var mScrollingTableHeaders:Array = new Array();
      
      private var mCurrentHeader:int;
      
      private var tableAnchor:String;
      
      private var tableFloater:String;
      
      private var mSelectedInfoList:Object = new Object();
      
      private var mMoreInfoRows:Array = new Array();
      
      private var mBackMethod:int = 3;
      
      private var mGoingBack:Boolean = false;
      
      private var mBackOverride:Boolean = false;
      
      private var mCursor:Object = {
         "cursor":int,
         "position":int
      };
      
      private var mEnteringScreen:Boolean = false;
      
      public function TravelLinkSportsScreen()
      {
         mView = new C_TravelLinkSportsDefaultScreenView();
         cache = true;
         super();
      }
      
      override public function cleanup() : void
      {
         this.mCursor = null;
         this.mScrollingTableHeaders = null;
         this.mSelectedInfoList = null;
         this.mMoreInfoRows = null;
         this.mCurrentTable = null;
         this.mCurrentHeadline = null;
         this.mCurrentTeam = null;
         this.mCurrentGame = null;
         this.mCurrentGameList = null;
         this.mCurrentList = null;
         this.mLastView = null;
         this.mCurrentView = null;
         super.cleanup();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.back_button,MouseEvent.CLICK,this.onBackBtnClick);
         attachListener(mView.travelLink_button,MouseEvent.CLICK,goTravelLink);
         attachListener(mView.viewButtons_group,WidgetEvent.CLICK,this.onViewButtonGrpClick);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_LIST,this.onSportsList);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_GAMES_LIST,this.onSportsScore);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_GAME_SCORE,this.onSportsGameInfo);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_LEAGUE_HEADLINES,this.onNewsItem);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_TEAM_INFO,this.onTeamInfo);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_TABULAR_LIST,this.onTable);
         attachListener(Peripheral.travelLink.sports,TravelLinkSportsEvent.SPORTS_ERROR,this.onError);
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
         mView.viewButtons_group.league_button.value_label.visible = false;
         mView.viewButtons_group.league_button.visible = false;
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setRequireSelection(true);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.mBackMethod = BACK_FRAMEWORK;
         this.mLastView.length = 0;
         if(Peripheral.vehicleStatus.speedLockOut == true)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            startWaiting();
         }
         if(screenVars.favoriteData != null && screenVars.favoriteData.sportID != null)
         {
            Peripheral.travelLink.sports.requestTeamInformation(screenVars.favoriteData.sportID,screenVars.favoriteData.leagueID,screenVars.favoriteData.teamID);
         }
         else
         {
            Peripheral.travelLink.sports.requestLeagueList();
         }
         this.mEnteringScreen = true;
         Peripheral.travelLink.sports.requestServiceStatus();
         setViewSelection(mView.viewButtons_group,BROWSESPORTS_BUTTON,false);
         this.mGoingBack = false;
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.viewButtons_group.browseSports_button,mView.viewButtons_group.league_button,mView.viewButtons_group.favorites_button]));
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.views_group.message_group.message_label,T.STRB_FUNCTION_NOT_AVAILABLE);
         t(mView.viewButtons_group.favorites_button.value_label,T.STRB_FAVORITES);
         t(mView.viewButtons_group.browseSports_button.value_label,T.STRB_BROWSE_SPORTS);
         t(mView.views_group.noData_group.label_translate,T.STRB_NO_DATA_AVAILABLE);
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
      }
      
      override protected function onWaitingTimeout() : void
      {
         this.switchView(TLS_VIEW_NO_DATA);
      }
      
      private function formatTime(time24:String) : String
      {
         var formattedTime:String = null;
         var timeArray:Array = null;
         var hourValue:Number = NaN;
         var amPM:String = null;
         if(time24 == null)
         {
            return "";
         }
         if(Peripheral.clock.twelveHourTimeFormat == true)
         {
            timeArray = time24.split(":");
            if(timeArray.length < 2)
            {
               return "";
            }
            hourValue = Number(timeArray[0]);
            amPM = new String(" PM");
            if(hourValue < 12)
            {
               amPM = " AM";
               if(hourValue < 1)
               {
                  hourValue += 12;
               }
            }
            else if(hourValue > 12)
            {
               hourValue -= 12;
            }
            formattedTime = String(hourValue + ":" + timeArray[1] + amPM);
         }
         else
         {
            formattedTime = time24;
         }
         return formattedTime;
      }
      
      private function setScreenState() : void
      {
         mView.views_group.hideChildren();
         mView.list_scroller.thumb.popup_simple.visible = false;
         this.mCurrentView.show();
         if(Peripheral.vehicleStatus.speedLockOut == true)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
      }
      
      private function saveCurrentView() : void
      {
         var viewObj:Object = new Object();
         viewObj.viewId = this.mTLSView;
         this.mLastView.push(viewObj);
      }
      
      private function deleteViewHistory() : void
      {
         while(this.mLastView.length > 0)
         {
            this.mLastView.pop();
         }
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb([T.STRB_TRAVEL_LINK_BREADCRUMB],Breadcrumb.FUNCTION,goTravelLink));
         pushBreadcrumb(new Breadcrumb([T.STRB_SPORTS],Breadcrumb.FUNCTION,this.goSports));
      }
      
      private function setNoDataView() : void
      {
         this.mCurrentView = mView.views_group.noData_group;
         this.mCurrentView.titleBar.value_label.text = this.mCurrentList.description;
         this.mCurrentView.titleBar.date_label.text = this.mCurrentList.date;
      }
      
      private function exitNoDataView() : void
      {
      }
      
      private function setSportsListView() : void
      {
         this.mCurrentView = mView.views_group.defaultBrowse_group;
         this.mCurrentView.speller_button.visible = false;
         this.initBreadcrumbs();
         if(this.mCurrentList.leagueAbbrev == "")
         {
            pushBreadcrumb(new Breadcrumb("Browse"));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(this.mCurrentList.leagueAbbrev));
         }
         if(this.mCurrentList.description == "Headlines")
         {
            this.mHeadlineList = true;
         }
         attachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onSportsListSelect);
         this.mCurrentView.browse_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mCurrentView.browse_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mCurrentView.browse_list.selectEventHandler);
         this.mCurrentView.browse_list.setRowUpdater(this.initSportsListRow);
         this.mCurrentView.browse_list.update();
         this.mCurrentView.browse_list.setLength(0);
         this.mCurrentView.browse_list.setDataRequester(this.requestSportsListData);
         this.mCurrentView.browse_list.setRowUpdater(this.updateSportsListRow);
         this.mCurrentView.browse_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.browse_list.setLength(this.mCurrentList.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mCurrentList.length));
         mView.itemsInList_label.visible = true;
         t(this.mCurrentView.header.value_label,this.mCurrentList.header);
         t(this.mCurrentView.header.date_label,"");
         this.mCurrentView.header.date_label.visible = false;
         this.restoreListPosition();
         this.mCurrentView.browse_list.requestData();
         this.mCurrentView.browse_list.update();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mCurrentView.browse_list.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function exitSportsListView() : void
      {
         if(this.mCurrentView == mView.views_group.defaultBrowse_group)
         {
            detachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onSportsListSelect);
            this.mCurrentView.browse_list.detachScroller();
            mView.list_scroller.setHideIfUseless(false);
            mView.list_scroller.setValue(0);
            mView.list_scroller.setVMaximum(0);
            this.mHeadlineList = false;
         }
      }
      
      private function setSportsScoreView() : void
      {
         this.mCurrentView = mView.views_group.scoresBrowse_group;
         this.initBreadcrumbs();
         if(this.mCurrentGameList.leagueAbbrev == "")
         {
            pushBreadcrumb(new Breadcrumb("Browse"));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(this.mCurrentGameList.leagueAbbrev));
         }
         attachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onSportsScoreSelect);
         this.mCurrentView.browse_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mCurrentView.browse_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mCurrentView.browse_list.selectEventHandler);
         this.mCurrentView.browse_list.setRowUpdater(this.initSportsScoreRow);
         this.mCurrentView.browse_list.update();
         this.mCurrentView.browse_list.setLength(0);
         this.mCurrentView.browse_list.setRowUpdater(this.updateSportsScoreRow);
         this.mCurrentView.browse_list.setDataRequester(this.requestSportsScoreData);
         this.mCurrentView.browse_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.browse_list.setLength(this.mCurrentGameList.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mCurrentGameList.length));
         mView.itemsInList_label.visible = true;
         t(this.mCurrentView.header.value_label,this.mCurrentGameList.header);
         t(this.mCurrentView.header.date_label,this.mCurrentGameList.date);
         this.restoreListPosition();
         this.mCurrentView.browse_list.requestData();
         this.mCurrentView.browse_list.update();
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mCurrentView.browse_list.onFocusCallBack));
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function exitSportsScoreView() : void
      {
         if(this.mCurrentView == mView.views_group.scoresBrowse_group)
         {
            detachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onSportsScoreSelect);
            this.mCurrentView.browse_list.detachScroller();
            mView.list_scroller.setHideIfUseless(false);
            mView.list_scroller.setValue(0);
            mView.list_scroller.setVMaximum(0);
         }
      }
      
      private function setGameDetailView() : void
      {
         this.mCurrentView = mView.views_group.gameInfo_group;
         this.mCurrentView.header.favorite_icon.visible = false;
         this.mCurrentView.favoriteTeam1_icon.visible = false;
         this.mCurrentView.favoriteTeam2_icon.visible = false;
         this.mCurrentView.inning_label.visible = false;
         this.mCurrentView.time_label.visible = false;
         mView.list_scroller.visible = false;
         t(this.mCurrentView.header.value_label,"Game Information");
         t(this.mCurrentView.header.date_label,this.mCurrentGameList.date);
         t(this.mCurrentView.team1_label,this.mCurrentGame.homeTeam.name);
         t(this.mCurrentView.team2_label,this.mCurrentGame.awayTeam.name);
         this.mCurrentView.favoriteTeam1_icon.visible = this.mCurrentGame.homeTeam.isFavorite;
         this.mCurrentView.favoriteTeam2_icon.visible = this.mCurrentGame.awayTeam.isFavorite;
         t(this.mCurrentView.score1_label,this.mCurrentGame.homeTeam.score);
         t(this.mCurrentView.score2_label,this.mCurrentGame.awayTeam.score);
         if(this.mCurrentGame.status == "Scheduled" || this.mCurrentGame.status == "Pregame")
         {
            t(this.mCurrentView.status_label,this.formatTime(this.mCurrentGame.date));
         }
         else if(this.mCurrentGame.status == "F")
         {
            t(this.mCurrentView.status_label,"Final");
         }
         else if(this.mCurrentGame.status == "FOT")
         {
            t(this.mCurrentView.status_label,"Final OT");
         }
         else
         {
            t(this.mCurrentView.status_label,this.mCurrentGame.status);
         }
         t(this.mCurrentView.team1Info_button.team_label,this.mCurrentGame.homeTeam.shortName);
         t(this.mCurrentView.team2Info_button.team_label,this.mCurrentGame.awayTeam.shortName);
         if(this.mCurrentGame.winner == "homeTeam")
         {
            this.mCurrentView.team1_label.textColor = 16777011;
            this.mCurrentView.score1_label.textColor = 16777011;
            this.mCurrentView.team2_label.textColor = 16777215;
            this.mCurrentView.score2_label.textColor = 16777215;
         }
         else if(this.mCurrentGame.winner == "awayTeam")
         {
            this.mCurrentView.team2_label.textColor = 16777011;
            this.mCurrentView.score2_label.textColor = 16777011;
            this.mCurrentView.team1_label.textColor = 16777215;
            this.mCurrentView.score1_label.textColor = 16777215;
         }
         else if(this.mCurrentGame.status == "Scheduled" || this.mCurrentGame.status == "Pregame" || this.mCurrentGame.status == "Delayed")
         {
            this.mCurrentView.team1_label.textColor = 16777215;
            this.mCurrentView.score1_label.textColor = 16777215;
            this.mCurrentView.team2_label.textColor = 16777215;
            this.mCurrentView.score2_label.textColor = 16777215;
         }
         else
         {
            this.mCurrentView.team1_label.textColor = 16777011;
            this.mCurrentView.score1_label.textColor = 16777011;
            this.mCurrentView.team2_label.textColor = 16777011;
            this.mCurrentView.score2_label.textColor = 16777011;
         }
         attachListener(this.mCurrentView.team1Info_button,MouseEvent.CLICK,this.onTeamInfoClick);
         attachListener(this.mCurrentView.team2Info_button,MouseEvent.CLICK,this.onTeamInfoClick);
         this.mCurrentView.team1Info_button.setEnabled(this.mCurrentGame.homeTeam.isPressable);
         this.mCurrentView.team1Info_button.setInteractive(this.mCurrentGame.homeTeam.isPressable);
         this.mCurrentView.team2Info_button.setEnabled(this.mCurrentGame.awayTeam.isPressable);
         this.mCurrentView.team2Info_button.setInteractive(this.mCurrentGame.awayTeam.isPressable);
         if(this.mCurrentGame.channel > 1 || this.mCurrentGame.homeTeam.channel > 1 || this.mCurrentGame.awayTeam.channel > 1)
         {
            attachListener(this.mCurrentView.listenNow_button,MouseEvent.CLICK,this.onHeadToHeadListenNowClick);
            this.mCurrentView.listenNow_button.setEnabled(true);
         }
         else
         {
            this.mCurrentView.listenNow_button.setEnabled(false);
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.gameInfo_group.team1Info_button,mView.views_group.gameInfo_group.team2Info_button,mView.views_group.gameInfo_group.listenNow_button]));
      }
      
      private function exitGameDetailView() : void
      {
         if(this.mCurrentView == mView.views_group.gameInfo_group)
         {
            detachListener(this.mCurrentView.team1Info_button,MouseEvent.CLICK,this.onTeamInfoClick);
            detachListener(this.mCurrentView.team2Info_button,MouseEvent.CLICK,this.onTeamInfoClick);
            detachListener(this.mCurrentView.listenNow_button,MouseEvent.CLICK,this.onHeadToHeadListenNowClick);
         }
      }
      
      private function setTeamDetailView() : void
      {
         var prevDateArray:Array = null;
         var nextDateArray:Array = null;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(this.mCurrentTeam.description || "Team Info"));
         this.mCurrentView = mView.views_group.teamInfo_group;
         mView.itemsInList_label.visible = false;
         if(this.mCurrentTeam.isFavorite == true)
         {
            this.mCurrentView.addFavorite_button.setEnabled(false);
            this.mCurrentView.addFavorite_button.setInteractive(false);
            this.mCurrentView.header.favorite_icon.visible = true;
         }
         else
         {
            this.mCurrentView.addFavorite_button.setEnabled(true);
            this.mCurrentView.addFavorite_button.setInteractive(true);
            attachListener(this.mCurrentView.addFavorite_button,MouseEvent.CLICK,this.onSetFavClick);
            this.mCurrentView.header.favorite_icon.visible = false;
         }
         this.mCurrentView.schedule_button.visible = true;
         attachListener(this.mCurrentView.schedule_button,MouseEvent.CLICK,this.onScheduleButtonClick);
         this.mCurrentView.header.visible = true;
         this.mCurrentView.header.date_label.visible = false;
         mView.list_scroller.visible = false;
         this.mCurrentView.row3column1_label.visible = true;
         this.mCurrentView.row3column2_label.visible = true;
         this.mCurrentView.row3column3_label.visible = true;
         this.mCurrentView.row5column1_label.visible = true;
         this.mCurrentView.row5column2_label.visible = true;
         this.mCurrentView.row5column3_label.visible = true;
         this.mCurrentView.row6column1_label.visible = true;
         this.mCurrentView.row6column2_label.visible = true;
         this.mCurrentView.row6column3_label.visible = true;
         t(this.mCurrentView.header.value_label,"      " + this.mCurrentTeam.listHeader || "");
         t(this.mCurrentView.row1column1_label,"League");
         t(this.mCurrentView.row2column1_label,"Last Game");
         t(this.mCurrentView.row3column1_label,"Opponent");
         t(this.mCurrentView.row4column1_label,"Next Game");
         t(this.mCurrentView.row5column1_label,"Opponent");
         t(this.mCurrentView.row6column1_label,"Time");
         var previousDate:String = "Unavailable";
         var nextDate:String = "Unavailable";
         var time:String = "";
         if(this.mCurrentTeam.hasOwnProperty("previousDate"))
         {
            prevDateArray = this.mCurrentTeam.previousDate.split(" ");
            if(prevDateArray.length > 2)
            {
               previousDate = prevDateArray[0] + " " + prevDateArray[1] + " " + prevDateArray[2];
            }
            else
            {
               previousDate = this.mCurrentTeam.previousDate;
            }
         }
         if(this.mCurrentTeam.hasOwnProperty("nextDate"))
         {
            nextDateArray = this.mCurrentTeam.nextDate.split(" ");
            if(nextDateArray.length > 3)
            {
               time = this.formatTime(nextDateArray[3]);
               nextDate = nextDateArray[0] + " " + nextDateArray[1] + " " + nextDateArray[2];
            }
            else
            {
               nextDate = this.mCurrentTeam.nextDate;
            }
         }
         t(this.mCurrentView.row1column3_label,this.mCurrentTeam.description || "");
         t(this.mCurrentView.row2column3_label,previousDate);
         if(this.mCurrentView.row2column3_label.text != "Unavailable")
         {
            t(this.mCurrentView.row3column3_label,this.mCurrentTeam.previousOpponent + ", " + this.mCurrentTeam.previousStatus + "  " + this.mCurrentTeam.previousScore);
         }
         else
         {
            this.mCurrentView.row3column1_label.visible = false;
            this.mCurrentView.row3column2_label.visible = false;
            this.mCurrentView.row3column3_label.visible = false;
         }
         t(this.mCurrentView.row4column3_label,nextDate);
         if(this.mCurrentView.row4column3_label.text != "Unavailable")
         {
            t(this.mCurrentView.row5column3_label,this.mCurrentTeam.nextOpponent || "");
            t(this.mCurrentView.row6column3_label,time);
         }
         else
         {
            this.mCurrentView.row5column1_label.visible = false;
            this.mCurrentView.row5column2_label.visible = false;
            this.mCurrentView.row5column3_label.visible = false;
            this.mCurrentView.row6column1_label.visible = false;
            this.mCurrentView.row6column2_label.visible = false;
            this.mCurrentView.row6column3_label.visible = false;
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.teamInfo_group.addFavorite_button,mView.views_group.teamInfo_group.schedule_button]));
      }
      
      private function exitTeamDetailView() : void
      {
         detachListener(this.mCurrentView.addFavorite_button,MouseEvent.CLICK,this.onSetFavClick);
         detachListener(this.mCurrentView.schedule_button,MouseEvent.CLICK,this.onScheduleButtonClick);
      }
      
      private function setHeadlineDetailView() : void
      {
         this.mCurrentView = mView.views_group.headlineDetails_group;
         t(this.mCurrentView.titleBar.value_label,this.mCurrentHeadline.header);
         t(this.mCurrentView.headlineDetails.description_label,this.mCurrentHeadline.description);
         t(this.mCurrentView.titleBar.date_label,"");
         this.mCurrentView.titleBar.date_label.visible = false;
      }
      
      private function exitHeadlineDetailView() : void
      {
      }
      
      private function setTableView() : void
      {
         this.mCurrentView = mView.views_group.sideScroll_group;
         this.initBreadcrumbs();
         if(this.mCurrentTable.leagueAbbrev == "")
         {
            pushBreadcrumb(new Breadcrumb("Browse"));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(this.mCurrentTable.leagueAbbrev));
         }
         this.mScrollingTableHeaders = new Array();
         attachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onTableListSelect);
         attachListener(this.mCurrentView.scroll_button,MouseEvent.CLICK,this.onHorizontalScroll);
         this.mCurrentView.browse_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mCurrentView.browse_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mCurrentView.browse_list.selectEventHandler);
         t(this.mCurrentView.header.value_label,this.mCurrentTable.description);
         this.mCurrentView.header.date_label.visible = false;
         for(var i:int = 0; i < this.mCurrentTable.headers.length; i++)
         {
            if(this.mCurrentTable.headers[i].id == 0)
            {
               this.tableAnchor = this.mCurrentTable.headers[i].name;
               this.tableFloater = this.mCurrentTable.headers[i + 1].name;
            }
            else
            {
               this.mScrollingTableHeaders.push(this.mCurrentTable.headers[i]);
            }
         }
         this.mCurrentHeader = 0;
         t(this.mCurrentView.columnTitles_group.value1_label,this.tableAnchor);
         t(this.mCurrentView.columnTitles_group.value2_label,this.tableFloater);
         this.mCurrentView.browse_list.setRowUpdater(this.initTableListRow);
         this.mCurrentView.browse_list.update();
         this.mCurrentView.browse_list.setLength(0);
         this.mCurrentView.browse_list.setDataRequester(this.requestTableListData);
         this.mCurrentView.browse_list.setRowUpdater(this.updateTableListRow);
         this.mCurrentView.browse_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.browse_list.setLength(this.mCurrentTable.rows.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mCurrentTable.rows.length));
         mView.itemsInList_label.visible = true;
         this.restoreListPosition();
         this.mCurrentView.browse_list.requestData();
         this.mCurrentView.browse_list.update();
      }
      
      private function initTableListRow(row:MovieClip, rowNumber:int, data:Object, dataIndex:int) : void
      {
         row.browse_button.visible = false;
         row.info_button.visible = false;
         row.listenNow_button.visible = false;
      }
      
      private function updateTableListRow(row:MovieClip, rowNumber:int, data:Object, dataIndex:int) : void
      {
         if(null != data)
         {
            if(this.tableFloater == "Channel")
            {
               if(data.Channel > 0)
               {
                  t(row.browse_button.value2_label,"");
                  row.listenNow_button.visible = true;
               }
               else
               {
                  t(row.browse_button.value2_label,"No Audio");
                  row.listenNow_button.visible = false;
               }
            }
            else
            {
               if(this.tableFloater == "Start Time")
               {
                  t(row.browse_button.value2_label,this.formatTime(data[this.tableFloater]));
               }
               else
               {
                  t(row.browse_button.value2_label,data[this.tableFloater]);
               }
               row.listenNow_button.visible = false;
            }
            t(row.browse_button.value1_label,data[this.tableAnchor]);
            row.info_button.visible = true;
            row.browse_button.visible = true;
         }
      }
      
      private function requestTableListData(start:int, end:int) : void
      {
         this.mCurrentView.browse_list.setData({
            "offset":start,
            "list":this.mCurrentTable.getItemByRange(start,end)
         });
      }
      
      private function updateTableHeaders() : void
      {
         t(this.mCurrentView.columnTitles_group.value1_label,this.tableAnchor);
         t(this.mCurrentView.columnTitles_group.value2_label,this.tableFloater);
         this.mCurrentView.browse_list.update();
      }
      
      private function exitTableView() : void
      {
         detachListener(this.mCurrentView.browse_list,WidgetEvent.SELECT,this.onTableListSelect);
         detachListener(this.mCurrentView.scroll_button,MouseEvent.CLICK,this.onHorizontalScroll);
         this.mCurrentView.browse_list.detachScroller();
         mView.list_scroller.setHideIfUseless(false);
         mView.list_scroller.setValue(0);
         mView.list_scroller.setVMaximum(0);
      }
      
      private function setMoreInfoView() : void
      {
         var obj:Object = null;
         var rowInfo:String = null;
         var rowItem:String = null;
         this.mCurrentView = mView.views_group.headlinesBrowse_group;
         this.initBreadcrumbs();
         if(this.mCurrentTable.leagueAbbrev == "")
         {
            pushBreadcrumb(new Breadcrumb("Browse"));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(this.mCurrentTable.leagueAbbrev));
         }
         this.mCurrentView.header.date_label.visible = true;
         this.mCurrentView.listenNow_button.visible = false;
         t(this.mCurrentView.header.date_label,this.mCurrentTable.date || "");
         t(this.mCurrentView.header.value_label,this.mCurrentTable.description);
         this.mMoreInfoRows = new Array();
         this.mMoreInfoRows.push(this.tableAnchor + " : " + this.mSelectedInfoList[this.tableAnchor]);
         for each(obj in this.mScrollingTableHeaders)
         {
            if(obj.name == "Channel")
            {
               if(this.mSelectedInfoList[obj.name] > 0)
               {
                  this.mCurrentView.header.date_label.visible = false;
                  this.mCurrentView.listenNow_button.visible = true;
                  attachListener(this.mCurrentView.listenNow_button,MouseEvent.CLICK,this.onTableListenNowClick);
               }
            }
            else
            {
               if(obj.name == "Start Time")
               {
                  rowInfo = this.formatTime(this.mSelectedInfoList[obj.name]);
               }
               else
               {
                  rowInfo = this.mSelectedInfoList[obj.name];
               }
               rowItem = obj.name + " : " + rowInfo;
               this.mMoreInfoRows.push(rowItem);
            }
         }
         this.mCurrentView.browse_list.attachScroller(mView.list_scroller);
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mCurrentView.browse_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mCurrentView.browse_list.selectEventHandler);
         this.mCurrentView.browse_list.setLength(5);
         this.mCurrentView.browse_list.setRowUpdater(this.initMoreInfoRow);
         this.mCurrentView.browse_list.update();
         this.mCurrentView.browse_list.setRowUpdater(this.updateMoreInfoRow);
         this.mCurrentView.browse_list.setDataRequester(this.requestMoreInfoData);
         this.mCurrentView.browse_list.setSelectionChanger(this.changeSelection);
         this.mCurrentView.browse_list.setLength(this.mMoreInfoRows.length);
         t(mView.itemsInList_label,Format.itemsInList(this.mMoreInfoRows.length));
         mView.itemsInList_label.visible = true;
         this.mCurrentView.browse_list.requestData();
         this.mCurrentView.browse_list.update();
      }
      
      private function initMoreInfoRow(row:MovieClip, rowNumber:int, data:Object, dataIndex:int) : void
      {
         row.browse_button.visible = false;
      }
      
      private function updateMoreInfoRow(row:MovieClip, rowNumber:int, data:String, dataIndex:int) : void
      {
         if(data)
         {
            row.browse_button.visible = true;
            t(row.browse_button.browseHeadlineRow,data);
         }
      }
      
      private function requestMoreInfoData(start:int, end:int) : void
      {
         var i:int = 0;
         var requestedList:Vector.<String> = new Vector.<String>();
         if(end >= this.mMoreInfoRows.length)
         {
            end = this.mMoreInfoRows.length - 1;
         }
         if(start < this.mMoreInfoRows.length)
         {
            for(i = start; i <= end; i++)
            {
               requestedList.push(this.mMoreInfoRows[i]);
            }
         }
         this.mCurrentView.browse_list.setData({
            "offset":start,
            "list":requestedList
         });
      }
      
      private function exitMoreInfoView() : void
      {
         detachListener(this.mCurrentView.listenNow_button,MouseEvent.CLICK,this.onTableListenNowClick);
         this.mCurrentView.browse_list.detachScroller();
         mView.list_scroller.setHideIfUseless(false);
         mView.list_scroller.setValue(0);
         mView.list_scroller.setVMaximum(0);
      }
      
      private function switchView(view:int, back:int = 1) : void
      {
         var viewObj:Object = null;
         this.mBackMethod = back;
         mView.list_scroller.visible = true;
         if(!this.mGoingBack)
         {
            viewObj = new Object();
            if(this.mEnteringScreen || this.mLastView.length == 0)
            {
               viewObj.viewId = BACK_FRAMEWORK;
               this.mLastView.push(viewObj);
               this.mEnteringScreen = false;
            }
            else
            {
               viewObj.viewId = BACK_XM_HISTORY;
               this.mLastView.push(viewObj);
            }
         }
         switch(this.mTLSView)
         {
            case TLS_VIEW_NO_DATA:
               this.exitNoDataView();
               break;
            case TLS_VIEW_SPORTS_LIST:
               this.exitSportsListView();
               break;
            case TLS_VIEW_SPORTS_SCORE:
               this.exitSportsScoreView();
               break;
            case TLS_VIEW_GAME_DETAIL:
               this.exitGameDetailView();
               break;
            case TLS_VIEW_TEAM_DETAIL:
               this.exitTeamDetailView();
               break;
            case TLS_VIEW_HEADLINE_DETAIL:
               this.exitHeadlineDetailView();
               break;
            case TLS_VIEW_TABULAR_LIST:
               this.exitTableView();
               break;
            case TLS_VIEW_MORE_INFO:
               this.exitMoreInfoView();
         }
         this.mTLSView = view;
         switch(this.mTLSView)
         {
            case TLS_VIEW_NO_DATA:
               this.mBackMethod = BACK_XM_CURRENT;
               this.setNoDataView();
               break;
            case TLS_VIEW_SPORTS_LIST:
               this.setSportsListView();
               break;
            case TLS_VIEW_SPORTS_SCORE:
               this.setSportsScoreView();
               break;
            case TLS_VIEW_GAME_DETAIL:
               this.setGameDetailView();
               break;
            case TLS_VIEW_TEAM_DETAIL:
               this.setTeamDetailView();
               break;
            case TLS_VIEW_HEADLINE_DETAIL:
               this.setHeadlineDetailView();
               break;
            case TLS_VIEW_TABULAR_LIST:
               this.setTableView();
               break;
            case TLS_VIEW_MORE_INFO:
               this.mBackMethod = BACK_XM_CURRENT;
               this.setMoreInfoView();
         }
         this.mGoingBack = false;
         this.setScreenState();
      }
      
      private function get getView() : int
      {
         return this.mTLSView;
      }
      
      private function initSportsListRow(row:MovieClip, rowNumber:int, data:TravelLinkSportsGenericListItem, dataIndex:int) : void
      {
         row.browse_button.value_label.visible = false;
         row.browse_button.next_icon.visible = false;
         row.browse_button.favorite_icon.visible = false;
      }
      
      private function updateSportsListRow(row:MovieClip, rowNumber:int, data:TravelLinkSportsGenericListItem, dataIndex:int) : void
      {
         if(data)
         {
            if(data.isPressable)
            {
               if(this.mHeadlineList)
               {
                  t(row.browse_button.value_label,data.description,TRUNCATE_NONE);
                  if(row.browse_button.value_label.textWidth > row.browse_button.value_label.width - 4)
                  {
                     row.browse_button.next_icon.visible = true;
                  }
                  else
                  {
                     row.browse_button.next_icon.visible = false;
                     data.isPressable = false;
                  }
               }
               else
               {
                  row.browse_button.next_icon.visible = true;
               }
            }
            else
            {
               row.browse_button.next_icon.visible = false;
            }
            t(row.browse_button.value_label,data.description);
            row.browse_button.value_label.visible = true;
            if(data.isFavorite)
            {
               row.browse_button.favorite_icon.visible = true;
            }
            else
            {
               row.browse_button.favorite_icon.visible = false;
            }
         }
         else
         {
            row.browse_button.value_label.visible = false;
            row.browse_button.next_icon.visible = false;
            row.browse_button.favorite_icon.visible = false;
         }
      }
      
      private function requestSportsListData(start:int, end:int) : void
      {
         this.mCurrentView.browse_list.setData({
            "offset":start,
            "list":this.mCurrentList.getItemByRange(start,end)
         });
      }
      
      private function initSportsScoreRow(row:MovieClip, rowNumber:int, data:TravelLinkSportsGameListItem, dataIndex:int) : void
      {
         row.browse_button.team1_label.visible = false;
         row.browse_button.team2_label.visible = false;
         row.browse_button.team1Score_label.visible = false;
         row.browse_button.team2Score_label.visible = false;
         row.browse_button.favorite1_icon.visible = false;
         row.browse_button.favorite2_icon.visible = false;
         row.browse_button.inning_label.visible = false;
         row.browse_button.status_label.visible = false;
         row.listenNow_button.visible = false;
         row.browse_button.team1_label.textColor = 16777215;
         row.browse_button.team1Score_label.textColor = 16777215;
         row.browse_button.team2_label.textColor = 16777215;
         row.browse_button.team2Score_label.textColor = 16777215;
         row.browse_button.listenNow_button.visible = false;
      }
      
      private function updateSportsScoreRow(row:MovieClip, rowNumber:int, data:TravelLinkSportsGameListItem, dataIndex:int) : void
      {
         if(data)
         {
            t(row.browse_button.team1_label,data.homeTeam.shortName);
            t(row.browse_button.team2_label,data.awayTeam.shortName);
            row.browse_button.favorite1_icon.visible = data.homeTeam.isFavorite;
            row.browse_button.favorite2_icon.visible = data.awayTeam.isFavorite;
            t(row.browse_button.team1Score_label,data.homeTeam.score);
            t(row.browse_button.team2Score_label,data.awayTeam.score);
            if(data.status == "Scheduled" || data.status == "Pregame")
            {
               t(row.browse_button.inning_label,this.formatTime(data.date));
            }
            else if(data.status == "Delayed")
            {
               t(row.browse_button.inning_label,"Delay");
            }
            else if(data.status == "F")
            {
               t(row.browse_button.inning_label,"Final");
            }
            else if(data.status == "FOT")
            {
               t(row.browse_button.inning_label,"Final OT");
            }
            else
            {
               t(row.browse_button.inning_label,data.status);
            }
            if(data.winner == "homeTeam")
            {
               row.browse_button.team1_label.textColor = 16777011;
               row.browse_button.team1Score_label.textColor = 16777011;
               row.browse_button.team2_label.textColor = 16777215;
               row.browse_button.team2Score_label.textColor = 16777215;
            }
            else if(data.winner == "awayTeam")
            {
               row.browse_button.team2_label.textColor = 16777011;
               row.browse_button.team2Score_label.textColor = 16777011;
               row.browse_button.team1_label.textColor = 16777215;
               row.browse_button.team1Score_label.textColor = 16777215;
            }
            else if(data.status == "Scheduled" || data.status == "Pregame" || data.status == "Delayed")
            {
               row.browse_button.team1_label.textColor = 16777215;
               row.browse_button.team1Score_label.textColor = 16777215;
               row.browse_button.team2_label.textColor = 16777215;
               row.browse_button.team2Score_label.textColor = 16777215;
            }
            else
            {
               row.browse_button.team1_label.textColor = 16777011;
               row.browse_button.team1Score_label.textColor = 16777011;
               row.browse_button.team2_label.textColor = 16777011;
               row.browse_button.team2Score_label.textColor = 16777011;
            }
            if(data.channel > 1 || data.homeTeam.channel > 1 || data.awayTeam.channel > 1)
            {
               row.listenNow_button.visible = true;
            }
            row.browse_button.team1_label.visible = true;
            row.browse_button.team2_label.visible = true;
            row.browse_button.team1Score_label.visible = true;
            row.browse_button.team2Score_label.visible = true;
            row.browse_button.inning_label.visible = true;
            row.browse_button.status_label.visible = false;
         }
         else
         {
            row.browse_button.team1_label.visible = false;
            row.browse_button.team2_label.visible = false;
            row.browse_button.team1Score_label.visible = false;
            row.browse_button.team2Score_label.visible = false;
            row.browse_button.favorite1_icon.visible = false;
            row.browse_button.favorite2_icon.visible = false;
            row.browse_button.inning_label.visible = false;
            row.browse_button.status_label.visible = false;
            row.listenNow_button.visible = false;
         }
      }
      
      private function requestSportsScoreData(start:int, end:int) : void
      {
         this.mCurrentView.browse_list.setData({
            "offset":start,
            "list":this.mCurrentGameList.getItemByRange(start,end)
         });
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         (row.getChildAt(0) as MovieClip).setSelected(selected);
      }
      
      override protected function onFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
         if(fromTLFavScreen)
         {
            mView.viewButtons_group.setSelection(FAVORITES_BUTTON);
         }
      }
      
      private function onError(e:TravelLinkSportsEvent) : void
      {
         stopWaiting();
         if(e.data.errCode)
         {
            switch(e.data.errCode)
            {
               case "eNoData":
                  this.switchView(TLS_VIEW_NO_DATA);
                  break;
               case "eSportsFavoriteBufferFull":
            }
         }
      }
      
      private function onServiceStatus(e:TravelLinkMoviesEvent) : void
      {
      }
      
      private function onSportsList(e:TravelLinkSportsEvent) : void
      {
         Framework.Trace("TLS: List received");
         stopWaiting();
         this.mCurrentList = Peripheral.travelLink.sports.currentList;
         this.switchView(TLS_VIEW_SPORTS_LIST);
      }
      
      private function onSportsScore(e:TravelLinkSportsEvent) : void
      {
         Framework.Trace("TLS: Scores received");
         stopWaiting();
         this.mCurrentGameList = Peripheral.travelLink.sports.currentGameList;
         this.switchView(TLS_VIEW_SPORTS_SCORE);
      }
      
      private function onSportsGameInfo(e:TravelLinkSportsEvent) : void
      {
         stopWaiting();
         this.mCurrentGame = e.data as TravelLinkSportsGameListItem;
         this.switchView(TLS_VIEW_GAME_DETAIL);
      }
      
      private function onNewsItem(e:TravelLinkSportsEvent) : void
      {
         Framework.Trace("TLS: NewsItem Recieved");
         stopWaiting();
         this.mCurrentHeadline = new TravelLinkSportsNewsItem(e.data);
         this.switchView(TLS_VIEW_HEADLINE_DETAIL);
      }
      
      private function onTable(e:TravelLinkSportsEvent) : void
      {
         stopWaiting();
         this.mCurrentTable = Peripheral.travelLink.sports.table;
         this.switchView(TLS_VIEW_TABULAR_LIST);
      }
      
      private function goSports() : void
      {
         Peripheral.travelLink.sports.requestLeagueList();
         this.mLastView = new Vector.<Object>();
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBackBtnClick();
      }
      
      private function onBackBtnClick(e:Event = null) : void
      {
         var viewObj:Object = null;
         var viewId:int = 0;
         if(!isBackAfterJustAddedFavorite())
         {
            this.mGoingBack = true;
            viewObj = this.mLastView.pop();
            if(viewObj != null)
            {
               viewId = int(viewObj.viewId);
               if(viewId == BACK_FRAMEWORK)
               {
                  this.mBackMethod = viewId;
               }
            }
            else
            {
               this.mBackMethod = BACK_FRAMEWORK;
            }
            switch(this.mBackMethod)
            {
               case BACK_XM_HISTORY:
                  Peripheral.travelLink.sports.requestPreviousList();
                  break;
               case BACK_XM_CURRENT:
                  Peripheral.travelLink.sports.requestCurrentScreen();
                  break;
               case BACK_FRAMEWORK:
               default:
                  super.back();
            }
         }
      }
      
      private function onHorizontalScroll(e:MouseEvent) : void
      {
         ++this.mCurrentHeader;
         if(this.mCurrentHeader >= this.mScrollingTableHeaders.length)
         {
            this.mCurrentHeader = 0;
         }
         this.tableFloater = this.mScrollingTableHeaders[this.mCurrentHeader].name;
         this.updateTableHeaders();
      }
      
      private function onViewButtonGrpClick(e:WidgetEvent) : void
      {
         var button:String = String(e.data.name);
         Framework.Trace("TLS: View button: " + button);
         switch(button)
         {
            case "browseSports_button":
               isFromTLFavScreen = false;
               JustAddedFavorite = false;
               Peripheral.travelLink.sports.requestLeagueList();
               startWaiting();
               setViewSelection(mView.viewButtons_group,FAVORITES_BUTTON,true);
               break;
            case "league_button":
               break;
            case "favorites_button":
               goFavorite();
         }
      }
      
      private function onSportsListSelect(e:WidgetEvent) : void
      {
         var pressable:Boolean = Boolean(e.data.data.isPressable);
         var itemId:uint = uint(e.data.data.id);
         Framework.Trace("TLS: Item selected, id: " + itemId);
         if(pressable == true)
         {
            this.recordPosition(e.data);
            Peripheral.travelLink.sports.requestListById(itemId);
            startWaiting();
         }
      }
      
      private function onSportsScoreSelect(e:WidgetEvent) : void
      {
         var itemId:uint = uint(e.data.data.id);
         if(e.data.targetName == "listenNow_button")
         {
            this.mCurrentGame = new TravelLinkSportsGameListItem(e.data.data);
            this.onHeadToHeadListenNowClick();
         }
         else
         {
            this.recordPosition(e.data);
            Peripheral.travelLink.sports.requestListById(itemId);
            startWaiting();
         }
      }
      
      private function onTableListSelect(e:WidgetEvent) : void
      {
         var pressable:Boolean = Boolean(e.data.data.isPressable);
         var itemId:uint = uint(e.data.data.tableID);
         if(e.data.targetName == "info_button")
         {
            this.mSelectedInfoList = e.data.data;
            this.switchView(TLS_VIEW_MORE_INFO);
         }
         else if(e.data.targetName == "listenNow_button")
         {
            this.mSelectedInfoList = e.data.data;
            this.onTableListenNowClick();
         }
         else if(pressable)
         {
            this.recordPosition(e.data);
            Peripheral.travelLink.sports.requestLeaderboard(itemId);
            startWaiting();
         }
      }
      
      private function recordPosition(posData:Object) : void
      {
         var lastViewLastIndex:int = 0;
         if(posData != null)
         {
            lastViewLastIndex = this.mLastView.length - 1;
            if(lastViewLastIndex >= 0)
            {
               this.mLastView[lastViewLastIndex].posData = posData;
            }
         }
      }
      
      private function restoreListPosition() : void
      {
         var lastViewLastIndex:int = 0;
         var posData:Object = null;
         if(this.mGoingBack)
         {
            lastViewLastIndex = this.mLastView.length - 1;
            if(lastViewLastIndex >= 0)
            {
               posData = this.mLastView[lastViewLastIndex].posData;
               if(posData != null)
               {
                  this.mCurrentView.browse_list.setPosition(posData.dataIndex - posData.visualIndex);
                  this.mCurrentView.browse_list.setCursor(posData.dataIndex);
               }
            }
         }
      }
      
      private function onTeamInfo(e:TravelLinkSportsEvent) : void
      {
         Framework.Trace("TLS: Team info received");
         stopWaiting();
         this.mCurrentTeam = e.data;
         this.switchView(TLS_VIEW_TEAM_DETAIL);
      }
      
      private function onTeamInfoClick(e:Event) : void
      {
         if(e.currentTarget.name == "team1Info_button")
         {
            Peripheral.travelLink.sports.requestTeamInformation(this.mCurrentGame.sportId,this.mCurrentGame.leagueId,this.mCurrentGame.homeTeam.id);
            this.mCurrentTeamId = this.mCurrentGame.homeTeam.id;
            startWaiting();
         }
         if(e.currentTarget.name == "team2Info_button")
         {
            Peripheral.travelLink.sports.requestTeamInformation(this.mCurrentGame.sportId,this.mCurrentGame.leagueId,this.mCurrentGame.awayTeam.id);
            startWaiting();
            this.mCurrentTeamId = this.mCurrentGame.awayTeam.id;
         }
      }
      
      private function onScheduleButtonClick(e:MouseEvent) : void
      {
         startWaiting();
         JustAddedFavorite = false;
         Peripheral.travelLink.sports.requestTeamSchedule(this.mCurrentTeam.leagueID,this.mCurrentTeam.sportID,this.mCurrentTeam.teamID);
      }
      
      private function onHeadToHeadListenNowClick(e:MouseEvent = null) : void
      {
         var vars:Object = {
            "headToHead":true,
            "homeChannel":this.mCurrentGame.homeTeam.channel,
            "homeTeam":this.mCurrentGame.homeTeam.nickname,
            "awayChannel":this.mCurrentGame.awayTeam.channel,
            "awayTeam":this.mCurrentGame.awayTeam.nickname,
            "nationalChannel":this.mCurrentGame.channel
         };
         this.showListenNowPopup(vars);
      }
      
      protected function showListenNowPopup(vars:Object) : void
      {
         if(!vars.type)
         {
            vars.type = PopupType.CONTROLS;
         }
         Framework.popupManager.show(DynamicPopupNames.LISTEN_NOW,"listennowpopup",vars);
      }
      
      private function onTableListenNowClick(e:MouseEvent = null) : void
      {
         var vars:Object = {
            "headToHead":false,
            "name":"selected",
            "channel":this.mSelectedInfoList.Channel
         };
         this.showListenNowPopup(vars);
      }
      
      private function onSetFavClick(e:MouseEvent) : void
      {
         var favAction:String = Peripheral.travelLink.sports.favorites.length > 9 ? Peripheral.travelLink.reportFavoritesFull : Peripheral.travelLink.addFavorite;
         var vars:Object = {
            "line1":this.mCurrentTeam.teamName + " " + this.mCurrentTeam.teamNick,
            "action":favAction,
            "service":Peripheral.travelLink.TLSports
         };
         addToFavoritesPopup(vars);
      }
      
      override protected function onConfirmedAddToFavorites() : void
      {
         this.mCurrentView.header.favorite_icon.visible = true;
         this.mCurrentView.addFavorite_button.setEnabled(false);
         this.mCurrentView.addFavorite_button.setInteractive(false);
         Peripheral.travelLink.sports.setFavoriteTeam(this.mCurrentGame.sportId,this.mCurrentTeam.lid,this.mCurrentTeamId,-1);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         Peripheral.travelLink.sports.requestFavoritesList();
         JustAddedFavorite = true;
      }
      
      override protected function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         super.onSpeedLockout(e);
         this.setScreenState();
      }
   }
}

