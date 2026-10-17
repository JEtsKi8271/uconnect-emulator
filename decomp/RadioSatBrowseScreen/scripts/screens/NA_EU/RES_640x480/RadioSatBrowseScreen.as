package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.GameZoneFavoriteTeam;
   import com.nfuzion.moduleLinkAPI.GameZoneLeagues;
   import com.nfuzion.moduleLinkAPI.GameZoneScoreAlert;
   import com.nfuzion.moduleLinkAPI.Preset;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioActiveFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioChannel;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFeaturedFavorite;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioFeaturedFavoriteBand;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioTrafficChannel;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class RadioSatBrowseScreen extends GenericScreen
   {
      
      private static const FEATURED_FAV_LIST:String = "List";
      
      private static const FEATURED_FAV:String = "fav";
      
      private const STATE_ALL_CHANNELS:String = "all channels";
      
      private const STATE_PRESETS:String = "presets";
      
      private const STATE_FAVORITES_ON_AIR:String = "favorites on air";
      
      private const STATE_FAVORITES_REMOVE:String = "favorites remove";
      
      private const STATE_FAVORITES_ALERT_SETTINGS:String = "favorites alert settings";
      
      private const STATE_GAMEZONE_ON_AIR:String = "gamezone on air";
      
      private const STATE_GAMEZONE_SELECT_CATEGORY:String = "gamezone select category";
      
      private const STATE_GAMEZONE_SELECT_TEAM:String = "gamezone select team";
      
      private const STATE_GAMEZONE_REMOVE:String = "gamezone remove selection";
      
      private const STATE_GAMEZONE_ALERT_SETTINGS:String = "gamezone alert settings";
      
      private const STATE_JUMP:String = "jump";
      
      private const STATE_FEATURED:String = "featured";
      
      private const LIST_DATA_LENGTH_PRESETS:int = 12;
      
      private var mGroupSideButtons:MovieClip;
      
      private var mGroupMain:MovieClip;
      
      private var mGroupAllChannels:MovieClip;
      
      private var mGroupPresets:MovieClip;
      
      private var mGroupFavorites:MovieClip;
      
      private var mGroupFavoritesOnAir:MovieClip;
      
      private var mGroupFavoritesRemove:MovieClip;
      
      private var mGroupFavoritesAlertSettings:MovieClip;
      
      private var mGroupGameZone:MovieClip;
      
      private var mGroupGameZoneOnAir:MovieClip;
      
      private var mGroupGameZoneSelectCategory:MovieClip;
      
      private var mGroupGameZoneSelectTeam:MovieClip;
      
      private var mGroupGameZoneRemove:MovieClip;
      
      private var mGroupGameZoneAlertSettings:MovieClip;
      
      private var mGroupJump:MovieClip;
      
      private var mGroupFeatured:MovieClip;
      
      private var mChannelListData:Vector.<SatelliteRadioChannel> = Vector.<SatelliteRadioChannel>([]);
      
      private var mPresetsListVector:Vector.<Preset> = Vector.<Preset>([]);
      
      private var mFavoritesOnAirListData:Vector.<SatelliteRadioActiveFavorite> = Vector.<SatelliteRadioActiveFavorite>([]);
      
      private var mFavoritesRemoveData:Vector.<SatelliteRadioFavorite> = Vector.<SatelliteRadioFavorite>([]);
      
      private var mGameZoneOnAirListData:Vector.<GameZoneScoreAlert> = Vector.<GameZoneScoreAlert>([]);
      
      private var mGameZoneLeagueData:Vector.<GameZoneLeagues> = Vector.<GameZoneLeagues>([]);
      
      private var mGameZoneTeamsData:Vector.<GameZoneFavoriteTeam> = Vector.<GameZoneFavoriteTeam>([]);
      
      private var mGameZoneRemoveData:Vector.<GameZoneFavoriteTeam> = Vector.<GameZoneFavoriteTeam>([]);
      
      private var mJumpListData:Vector.<SatelliteRadioTrafficChannel> = Vector.<SatelliteRadioTrafficChannel>([]);
      
      private var mFeaturedListData:Vector.<SatelliteRadioFeaturedFavoriteBand> = Vector.<SatelliteRadioFeaturedFavoriteBand>([]);
      
      private var mFeaturedData:Vector.<SatelliteRadioFeaturedFavorite> = Vector.<SatelliteRadioFeaturedFavorite>([]);
      
      private var mGameZoneAlertSettingsData:Vector.<Object> = Vector.<Object>([{
         "name":T.STRB_ALERT_ON_AIR_UPON_START,
         "id":"alertUponStart"
      },{
         "name":T.STRB_ALERT_UPON_SCORE_UPDATE,
         "id":"alertUponScore"
      }]);
      
      private var mFavoritesAlertSettingsData:Vector.<Object> = Vector.<Object>([{
         "name":T.STRB_VISUAL_ALERT,
         "id":"visualAlert"
      },{
         "name":T.STRB_AUDIBLE_VISUAL_ALERT,
         "id":"audioVisualAlert"
      }]);
      
      public var mAllChannelsListIndex:int = 0;
      
      public var mGameFav:int = 0;
      
      private var mCurrentChannel:SatelliteRadioChannel;
      
      public var mCurrentState:String = "all channels";
      
      private var mPreviousState:String = "";
      
      public var mAllChannelsSort:String = Peripheral.satelliteRadio.SORT_CHANNEL_ASCENDING;
      
      private var mChannelSortPressed:Boolean = false;
      
      public var mChosenLeague:GameZoneLeagues = new GameZoneLeagues();
      
      private var mHasPositionedAllChannelsListToCurrentChannel:Boolean = false;
      
      private var mFeaturedState:String = "List";
      
      private var mSelectedFeaturedFavoriteBand:SatelliteRadioFeaturedFavoriteBand = null;
      
      public var mHistory:Vector.<String> = new Vector.<String>();
      
      public var mGoingBack:Boolean = false;
      
      public var mSourceChanges:int = 0;
      
      private var noFavItemsLabelHeight:int = -1;
      
      private var noGameItemsLabelHeight:int = -1;
      
      private var handlingLongPress:Boolean = false;
      
      public function RadioSatBrowseScreen()
      {
         mView = new C_RadioSatBrowseScreenView();
         super();
      }
      
      override protected function get persistentProperties() : Array
      {
         return ["mCurrentState","mAllChannelsSort","mChosenLeague","mAllChannelsListIndex","listCursor","listPosition","mSourceChanges"];
      }
      
      public function get listCursor() : uint
      {
         switch(this.mCurrentState)
         {
            case this.STATE_ALL_CHANNELS:
               return this.mGroupAllChannels.browse_list.getCursor();
            case this.STATE_FAVORITES_ALERT_SETTINGS:
               return this.mGroupFavoritesAlertSettings.browse_list.getCursor();
            case this.STATE_FAVORITES_ON_AIR:
               return this.mGroupFavoritesOnAir.browse_list.getCursor();
            case this.STATE_FAVORITES_REMOVE:
               return this.mGroupFavoritesRemove.browse_list.getCursor();
            case this.STATE_GAMEZONE_ALERT_SETTINGS:
               return this.mGroupGameZoneAlertSettings.browse_list.getCursor();
            case this.STATE_GAMEZONE_ON_AIR:
               return this.mGroupGameZoneOnAir.browse_list.getCursor();
            case this.STATE_GAMEZONE_REMOVE:
               return this.mGroupGameZoneRemove.browse_list.getCursor();
            case this.STATE_GAMEZONE_SELECT_CATEGORY:
               return this.mGroupGameZoneSelectCategory.browse_list.getCursor();
            case this.STATE_GAMEZONE_SELECT_TEAM:
               return this.mGroupGameZoneSelectTeam.browse_list.getCursor();
            case this.STATE_JUMP:
               return this.mGroupJump.browse_list.getCursor();
            case this.STATE_PRESETS:
               return this.mGroupPresets.browse_list.getCursor();
            case this.STATE_FEATURED:
               return this.mGroupFeatured.browse_list.getCursor();
            default:
               return 0;
         }
      }
      
      public function set listCursor(index:uint) : void
      {
         switch(this.mCurrentState)
         {
            case this.STATE_ALL_CHANNELS:
               this.mGroupAllChannels.browse_list.setCursor(index);
               break;
            case this.STATE_FAVORITES_ALERT_SETTINGS:
               this.mGroupFavoritesAlertSettings.browse_list.setCursor(index);
               break;
            case this.STATE_FAVORITES_ON_AIR:
               this.mGroupFavoritesOnAir.browse_list.setCursor(index);
               break;
            case this.STATE_FAVORITES_REMOVE:
               this.mGroupFavoritesRemove.browse_list.setCursor(index);
               break;
            case this.STATE_GAMEZONE_ALERT_SETTINGS:
               this.mGroupGameZoneAlertSettings.browse_list.setCursor(index);
               break;
            case this.STATE_GAMEZONE_ON_AIR:
               this.mGroupGameZoneOnAir.browse_list.setCursor(index);
               break;
            case this.STATE_GAMEZONE_REMOVE:
               this.mGroupGameZoneRemove.browse_list.setCursor(index);
               break;
            case this.STATE_GAMEZONE_SELECT_CATEGORY:
               this.mGroupGameZoneSelectCategory.browse_list.setCursor(index);
               break;
            case this.STATE_GAMEZONE_SELECT_TEAM:
               this.mGroupGameZoneSelectTeam.browse_list.setCursor(index);
               break;
            case this.STATE_JUMP:
               this.mGroupJump.browse_list.setCursor(index);
               break;
            case this.STATE_PRESETS:
               this.mGroupPresets.browse_list.setCursor(index);
               break;
            case this.STATE_FEATURED:
               this.mGroupFeatured.browse_list.setCursor(index);
         }
      }
      
      public function get listPosition() : uint
      {
         switch(this.mCurrentState)
         {
            case this.STATE_ALL_CHANNELS:
               return this.mGroupAllChannels.browse_list.getPosition();
            case this.STATE_FAVORITES_ALERT_SETTINGS:
               return this.mGroupFavoritesAlertSettings.browse_list.getPosition();
            case this.STATE_FAVORITES_ON_AIR:
               return this.mGroupFavoritesOnAir.browse_list.getPosition();
            case this.STATE_FAVORITES_REMOVE:
               return this.mGroupFavoritesRemove.browse_list.getPosition();
            case this.STATE_GAMEZONE_ALERT_SETTINGS:
               return this.mGroupGameZoneAlertSettings.browse_list.getPosition();
            case this.STATE_GAMEZONE_ON_AIR:
               return this.mGroupGameZoneOnAir.browse_list.getPosition();
            case this.STATE_GAMEZONE_REMOVE:
               return this.mGroupGameZoneRemove.browse_list.getPosition();
            case this.STATE_GAMEZONE_SELECT_CATEGORY:
               return this.mGroupGameZoneSelectCategory.browse_list.getPosition();
            case this.STATE_GAMEZONE_SELECT_TEAM:
               return this.mGroupGameZoneSelectTeam.browse_list.getPosition();
            case this.STATE_JUMP:
               return this.mGroupJump.browse_list.getPosition();
            case this.STATE_PRESETS:
               return this.mGroupPresets.browse_list.getPosition();
            case this.STATE_FEATURED:
               return this.mGroupFeatured.browse_list.getPosition();
            default:
               return 0;
         }
      }
      
      public function set listPosition(index:uint) : void
      {
         switch(this.mCurrentState)
         {
            case this.STATE_ALL_CHANNELS:
               this.mGroupAllChannels.browse_list.setPosition(index);
               break;
            case this.STATE_FAVORITES_ALERT_SETTINGS:
               this.mGroupFavoritesAlertSettings.browse_list.setPosition(index);
               break;
            case this.STATE_FAVORITES_ON_AIR:
               this.mGroupFavoritesOnAir.browse_list.setPosition(index);
               break;
            case this.STATE_FAVORITES_REMOVE:
               this.mGroupFavoritesRemove.browse_list.setPosition(index);
               break;
            case this.STATE_GAMEZONE_ALERT_SETTINGS:
               this.mGroupGameZoneAlertSettings.browse_list.setPosition(index);
               break;
            case this.STATE_GAMEZONE_ON_AIR:
               this.mGroupGameZoneOnAir.browse_list.setPosition(index);
               break;
            case this.STATE_GAMEZONE_REMOVE:
               this.mGroupGameZoneRemove.browse_list.setPosition(index);
               break;
            case this.STATE_GAMEZONE_SELECT_CATEGORY:
               this.mGroupGameZoneSelectCategory.browse_list.setPosition(index);
               break;
            case this.STATE_GAMEZONE_SELECT_TEAM:
               this.mGroupGameZoneSelectTeam.browse_list.setPosition(index);
               break;
            case this.STATE_JUMP:
               this.mGroupJump.browse_list.setPosition(index);
               break;
            case this.STATE_PRESETS:
               this.mGroupPresets.browse_list.setPosition(index);
               break;
            case this.STATE_PRESETS:
               this.mGroupFeatured.browse_list.setPosition(index);
         }
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.mGroupSideButtons = mView.sideButtons_group;
         this.mGroupMain = mView.displays_group;
         this.mGroupAllChannels = mView.displays_group.allChannels_group;
         this.mGroupPresets = mView.displays_group.presets_group;
         this.mGroupFavorites = mView.displays_group.favorites_group;
         this.mGroupFavoritesOnAir = mView.displays_group.favorites_group.displays_group.onAir_group;
         this.mGroupFavoritesRemove = mView.displays_group.favorites_group.displays_group.removeFavorites_group;
         this.mGroupFavoritesAlertSettings = mView.displays_group.favorites_group.displays_group.alertSettings_group;
         this.mGroupGameZone = mView.displays_group.gameZone_group;
         this.mGroupGameZoneOnAir = mView.displays_group.gameZone_group.displays_group.onAir_group;
         this.mGroupGameZoneSelectCategory = mView.displays_group.gameZone_group.displays_group.selectCategory_group;
         this.mGroupGameZoneSelectTeam = mView.displays_group.gameZone_group.displays_group.selectTeam_group;
         this.mGroupGameZoneRemove = mView.displays_group.gameZone_group.displays_group.removeSelection_group;
         this.mGroupGameZoneAlertSettings = mView.displays_group.gameZone_group.displays_group.alertSettings_group;
         this.mGroupJump = mView.displays_group.jump_group;
         this.mGroupFeatured = mView.displays_group.featured_group;
         this.mGroupSideButtons.all_button.state = this.STATE_ALL_CHANNELS;
         this.mGroupSideButtons.presets_button.state = this.STATE_PRESETS;
         this.mGroupSideButtons.favorites_button.state = this.STATE_FAVORITES_ON_AIR;
         this.mGroupSideButtons.gameZone_button.state = this.STATE_GAMEZONE_ON_AIR;
         this.mGroupSideButtons.jump_button.state = this.STATE_JUMP;
         this.mGroupSideButtons.featured_button.state = this.STATE_FEATURED;
         this.mGroupFavorites.header_group.onAir_button.state = this.STATE_FAVORITES_ON_AIR;
         this.mGroupFavorites.header_group.removeFavorites_button.state = this.STATE_FAVORITES_REMOVE;
         this.mGroupFavorites.header_group.alertSettings_button.state = this.STATE_FAVORITES_ALERT_SETTINGS;
         this.mGroupGameZone.header_group.onAir_button.state = this.STATE_GAMEZONE_ON_AIR;
         this.mGroupGameZone.header_group.selectTeams_button.state = this.STATE_GAMEZONE_SELECT_CATEGORY;
         this.mGroupGameZone.header_group.removeSelection_button.state = this.STATE_GAMEZONE_REMOVE;
         this.mGroupGameZone.header_group.alertSettings_button.state = this.STATE_GAMEZONE_ALERT_SETTINGS;
         this.mGroupMain.setExclusiveChildren(true);
         this.mGroupMain.hideChildren();
         this.mGroupSideButtons.setRadioButtons(true);
         this.mGroupSideButtons.setRequireSelection(true);
         this.mGroupFavorites.header_group.setRadioButtons(true);
         this.mGroupFavorites.header_group.setRequireSelection(true);
         this.mGroupAllChannels.header_group.setRadioButtons(true);
         this.mGroupAllChannels.header_group.setRequireSelection(true);
         this.mGroupFavorites.displays_group.setExclusiveChildren(true);
         this.mGroupFavorites.displays_group.hideChildren();
         this.mGroupGameZone.displays_group.setExclusiveChildren(true);
         this.mGroupGameZone.displays_group.hideChildren();
         this.mGroupGameZone.header_group.setRadioButtons(true);
         this.mGroupGameZone.header_group.setRequireSelection(true);
      }
      
      override protected function initScreen() : void
      {
         var enterState:String = null;
         super.initScreen();
         this.handlingLongPress = false;
         this.configureListAndScroller(this.mGroupAllChannels.browse_list,this.mGroupAllChannels.browse_scroller,null,this.allChannelsBrowseListRowUpdater,this.allChannelsBrowseListDataRequester,this.allChannelsBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupPresets.browse_list,this.mGroupPresets.browse_scroller,null,this.presetListRowUpdater,this.presetListDataRequester,this.presetListSelectionChanger,this.LIST_DATA_LENGTH_PRESETS);
         this.configureListAndScroller(this.mGroupFavoritesOnAir.browse_list,this.mGroupFavoritesOnAir.browse_scroller,null,this.favoritesOnAirBrowseListRowUpdater,this.favoritesOnAirBrowseListDataRequester,this.favoritesOnAirBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupFavoritesRemove.browse_list,this.mGroupFavoritesRemove.browse_scroller,this.initFavoritesRemoveBrowseListRowUpdater,this.favoritesRemoveBrowseListRowUpdater,this.favoritesRemoveBrowseListDataRequester,this.favoritesRemoveBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupFavoritesAlertSettings.browse_list,this.mGroupFavoritesAlertSettings.browse_scroller,null,this.favoritesAlertSettingsListRowUpdater,this.favoritesAlertSettingsListDataRequester,this.favoritesAlertSettingsListSelectionChanger,this.mFavoritesAlertSettingsData.length);
         this.configureListAndScroller(this.mGroupGameZoneOnAir.browse_list,this.mGroupGameZoneOnAir.browse_scroller,null,this.gameZoneOnAirBrowseListRowUpdater,this.gameZoneOnAirBrowseListDataRequester,this.gameZoneOnAirBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupGameZoneSelectCategory.browse_list,this.mGroupGameZoneSelectCategory.browse_scroller,null,this.gameZoneSelectCategoryBrowseListRowUpdater,this.gameZoneSelectCategoryBrowseListDataRequester,this.gameZoneSelectCategoryBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupGameZoneSelectTeam.browse_list,this.mGroupGameZoneSelectTeam.browse_scroller,null,this.gameZoneSelectTeamBrowseListRowUpdater,this.gameZoneSelectTeamBrowseListDataRequester,this.gameZoneSelectTeamBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupGameZoneRemove.browse_list,this.mGroupGameZoneRemove.browse_scroller,this.initGameZoneRemoveBrowseListRowUpdater,this.gameZoneRemoveBrowseListRowUpdater,this.gameZoneRemoveBrowseListDataRequester,this.gameZoneRemoveBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupGameZoneAlertSettings.browse_list,this.mGroupGameZoneAlertSettings.browse_scroller,null,this.gameZoneAlertSettingsListRowUpdater,this.gameZoneAlertSettingsListDataRequester,this.gameZoneAlertSettingsListSelectionChanger,this.mGameZoneAlertSettingsData.length);
         this.configureListAndScroller(this.mGroupJump.browse_list,this.mGroupJump.browse_scroller,null,this.jumpBrowseListRowUpdater,this.jumpBrowseListDataRequester,this.jumpBrowseListSelectionChanger,0);
         this.configureListAndScroller(this.mGroupFeatured.browse_list,this.mGroupFeatured.browse_scroller,null,this.featuredBrowseListRowUpdater,this.featuredBrowseListDataRequester,this.featuredBrowseListSelectionChanger,0);
         this.mHasPositionedAllChannelsListToCurrentChannel = false;
         this.mChannelSortPressed = false;
         var curSrcChanges:int = int(Peripheral.audioManager.sourceChanges);
         if(this.mSourceChanges != curSrcChanges)
         {
            this.mSourceChanges = curSrcChanges;
            this.mCurrentState = this.STATE_ALL_CHANNELS;
            this.mAllChannelsSort = Peripheral.satelliteRadio.SORT_CHANNEL_ASCENDING;
            this.mChosenLeague = new GameZoneLeagues();
            this.mAllChannelsListIndex = 0;
            this.listCursor = 0;
            this.listPosition = 0;
         }
         if(screenVars != null && screenVars.state != null)
         {
            enterState = screenVars.state;
            if(enterState == "jumpchannels")
            {
               this.mCurrentState = this.STATE_JUMP;
            }
            else if(enterState == "removeFavorites")
            {
               this.mCurrentState = this.STATE_FAVORITES_REMOVE;
            }
            else if(enterState == "onAirFavorites")
            {
               this.mCurrentState = this.STATE_FAVORITES_ON_AIR;
            }
            else
            {
               this.mCurrentState = enterState;
            }
         }
         this.setScreenViewState(this.mCurrentState);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[this.mGroupSideButtons.all_button,this.mGroupSideButtons.jump_button,this.mGroupSideButtons.presets_button,this.mGroupSideButtons.featured_button,this.mGroupSideButtons.favorites_button,this.mGroupSideButtons.gameZone_button,mView.arrow_button]));
      }
      
      private function enableTopRowCursoring(enabled:Boolean) : void
      {
         if(enabled)
         {
            Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[this.mGroupAllChannels.header_group.channel_button,this.mGroupAllChannels.header_group.genre_button,this.mGroupFavorites.header_group.onAir_button,this.mGroupFavorites.header_group.removeFavorites_button,this.mGroupFavorites.header_group.alertSettings_button,this.mGroupGameZone.header_group.onAir_button,this.mGroupGameZone.header_group.selectTeams_button,this.mGroupGameZone.header_group.removeSelection_button,this.mGroupGameZone.header_group.alertSettings_button]));
         }
         else
         {
            Framework.focusManager.setFocus(FocusPriority.REGULAR);
            Framework.focusManager.delFocus(Framework.focusManager.getFocus());
            Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
         }
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_SAT_BROWSE);
         Peripheral.satelliteRadio.suppressFavOnAirNotifications = false;
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.back_button,MouseEvent.CLICK,this.back,false,0,true);
         attachListener(mView.close_button,MouseEvent.CLICK,this.onCloseButtonClick,false,0,true);
         attachListener(mView.arrow_button,WidgetEvent.CLICK,this.onSideButtonsArrow,false,0,true);
         attachListener(this.mGroupSideButtons,WidgetEvent.SELECT,this.onSideButtonsGroupSelect,false,0,true);
         attachListener(this.mGroupAllChannels.header_group,WidgetEvent.SELECT,this.onAllChannelsHeaderButtonGroupSelect,false,0,true);
         attachListener(this.mGroupFavorites.header_group,WidgetEvent.SELECT,this.onFavoritesGroupHeaderButtonsSelect,false,0,true);
         attachListener(this.mGroupGameZone.header_group,WidgetEvent.SELECT,this.onGameZoneGroupHeaderButtonsSelect,false,0,true);
         attachListener(this.mGroupAllChannels.browse_list,WidgetEvent.SELECT,this.onAllChannelsBrowseListSelect,false,0,true);
         attachListener(this.mGroupPresets.browse_list,WidgetEvent.SELECT,this.onPresetRowButtonSelect);
         attachListener(this.mGroupPresets.browse_list,WidgetEvent.LONG_PRESS,this.onPresetRowButtonLongPress);
         attachListener(this.mGroupFavoritesOnAir.browse_list,WidgetEvent.SELECT,this.onFavoritesOnAirBrowseListSelect,false,0,true);
         attachListener(this.mGroupFavoritesRemove.browse_list,WidgetEvent.SELECT,this.onFavoritesRemoveBrowseListSelect,false,0,true);
         attachListener(this.mGroupFavoritesAlertSettings.browse_list,WidgetEvent.SELECT,this.onFavoritesAlertSettingsBrowseListSelect,false,0,true);
         attachListener(this.mGroupGameZoneOnAir.browse_list,WidgetEvent.SELECT,this.onGameZoneOnAirBrowseListSelect,false,0,true);
         attachListener(this.mGroupGameZoneSelectCategory.browse_list,WidgetEvent.SELECT,this.onGameZoneSelectCategoryBrowseListSelect,false,0,true);
         attachListener(this.mGroupGameZoneSelectTeam.browse_list,WidgetEvent.SELECT,this.onGameZoneSelectTeamBrowseListSelect,false,0,true);
         attachListener(this.mGroupGameZoneRemove.browse_list,WidgetEvent.SELECT,this.onGameZoneRemoveBrowseListSelect,false,0,true);
         attachListener(this.mGroupGameZoneAlertSettings.browse_list,WidgetEvent.SELECT,this.onGameZoneAlertSettingsSelect,false,0,true);
         attachListener(this.mGroupJump.browse_list,WidgetEvent.SELECT,this.onJumpBrowseListSelect,false,0,true);
         attachListener(this.mGroupFeatured.browse_list,WidgetEvent.SELECT,this.onFeaturedFavoritesBrowseListSelect,false,0,true);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.APP_STATUS,this.onSatAppStatus);
         attachListener(Framework.structure,StructureEvent.REFRESH_STRUCTURE,this.onRefreshStructure);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.displays_group.allChannels_group.header_group.channel_button.value_label,T.STRB_CHANNELS_SATBROWSE);
         t(mView.displays_group.allChannels_group.header_group.genre_button.value_label,T.STRB_GENRE_SATBROWSE);
         t(mView.displays_group.favorites_group.header_group.onAir_button.value_label,T.STRB_ON_AIR_FAV_SATBROWSE);
         t(mView.displays_group.favorites_group.header_group.removeFavorites_button.value_label,T.STRB_REMOVE_FAV_SATBROWSE);
         t(mView.displays_group.favorites_group.header_group.alertSettings_button.value_label,T.STRB_ALERT_SETTINGS_FAV);
         t(mView.displays_group.gameZone_group.header_group.onAir_button.value_label,T.STRB_ON_AIR_GAMEZONE_SATBROWSE);
         t(mView.displays_group.gameZone_group.header_group.removeSelection_button.value_label,T.STRB_REMOVE_SELECTION_SATBROWSE);
         t(mView.displays_group.gameZone_group.header_group.alertSettings_button.value_label,T.STRB_ALERT_SETTINGS_GAMEZONE);
         t(mView.displays_group.gameZone_group.header_group.selectTeams_button.value_label,T.STRB_SELECT_TEAM_SATBROWSE);
         t(mView.sideButtons_group.presets_button.value_label,T.STRB_PRESETS_SATBROWSE);
         t(mView.sideButtons_group.all_button.value_label,T.STRB_ALL_SATBROWSE);
         t(mView.sideButtons_group.favorites_button.value_label,T.STRB_FAV_SATBROWSE);
         t(mView.sideButtons_group.gameZone_button.value_label,T.STRB_GAME_ZONE_SATBROWSE);
         t(mView.sideButtons_group.jump_button.value_label,T.STRB_TRAFFIC_AND_WEATHER_SATBROWSE);
         t(mView.sideButtons_group.featured_button.value_label,T.STRB_FEATURED);
         t(mView.displays_group.jump_group.header_label.value_label,T.STRB_SELECT_CITY_FOR_TRAFFIC_AND_WEATHER_REPORT);
         this.mGroupFavoritesOnAir.browse_list.update();
         this.mGroupFavoritesRemove.browse_list.update();
         this.mGroupGameZoneOnAir.browse_list.update();
         this.mGroupGameZoneSelectTeam.browse_list.update();
         this.mGroupGameZoneRemove.browse_list.update();
         this.mGroupJump.browse_list.update();
         this.mGroupPresets.browse_list.update();
         this.mGroupFavoritesAlertSettings.browse_list.update();
         this.mGroupGameZoneAlertSettings.browse_list.update();
      }
      
      private function presetInitRowUpdater(row:MovieClip, rowIndex:int, data:Preset, dataIndex:int) : void
      {
         attachListener(row.delete_button,MouseEvent.CLICK,this.onDeleteButtonClick,false,0,true);
      }
      
      private function addRemoveAPIListenersBasedOnState(doAdd:Boolean = true) : void
      {
         if(this.mPreviousState != "")
         {
            switch(this.mPreviousState)
            {
               case this.STATE_ALL_CHANNELS:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.CHANNELS,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.AVAILABLE_CHANNELS,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.CHANNELS_UPDATED,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_FAVORITES_ALERT_SETTINGS:
                  break;
               case this.STATE_FAVORITES_ON_AIR:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_AUDIO_FAVORITES,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_FAVORITES_REMOVE:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ALL_AUDIO_FAVORITES,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_GAMEZONE_ALERT_SETTINGS:
                  break;
               case this.STATE_GAMEZONE_ON_AIR:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_GAME,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.SCORE_ALERT,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_SCORES,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_GAMEZONE_REMOVE:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FAVORITE_TEAMS,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_GAMEZONE_SELECT_CATEGORY:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.LEAGUES,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_GAMEZONE_SELECT_TEAM:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.TEAMS,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_JUMP:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.JUMP_CHANNELS,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.JUMP_MARKET,this.onSatelliteRadioEvent);
                  break;
               case this.STATE_FEATURED:
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FEATURED_FAVORITE_LIST,this.onSatelliteRadioEvent);
                  detachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FEATURED_FAVORITE,this.onSatelliteRadioEvent);
            }
         }
         if(doAdd == true)
         {
            switch(this.mCurrentState)
            {
               case this.STATE_ALL_CHANNELS:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.CHANNELS,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.AVAILABLE_CHANNELS,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.CHANNELS_UPDATED,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupAllChannels.browse_list.onFocusCallBack));
                  break;
               case this.STATE_FAVORITES_ALERT_SETTINGS:
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesAlertSettings.browse_list.onFocusCallBack));
                  break;
               case this.STATE_FAVORITES_ON_AIR:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_AUDIO_FAVORITES,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesOnAir.browse_list.onFocusCallBack));
                  break;
               case this.STATE_FAVORITES_REMOVE:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ALL_AUDIO_FAVORITES,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesRemove.browse_list.onFocusCallBack));
                  break;
               case this.STATE_GAMEZONE_ALERT_SETTINGS:
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneAlertSettings.browse_list.onFocusCallBack));
                  break;
               case this.STATE_GAMEZONE_ON_AIR:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_GAME,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.SCORE_ALERT,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ACTIVE_SCORES,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneOnAir.browse_list.onFocusCallBack));
                  break;
               case this.STATE_GAMEZONE_REMOVE:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FAVORITE_TEAMS,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneRemove.browse_list.onFocusCallBack));
                  break;
               case this.STATE_GAMEZONE_SELECT_CATEGORY:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.LEAGUES,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneSelectCategory.browse_list.onFocusCallBack));
                  break;
               case this.STATE_GAMEZONE_SELECT_TEAM:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.TEAMS,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneSelectTeam.browse_list.onFocusCallBack));
                  break;
               case this.STATE_JUMP:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.JUMP_CHANNELS,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.JUMP_MARKET,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupJump.browse_list.onFocusCallBack));
                  break;
               case this.STATE_FEATURED:
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FEATURED_FAVORITE_LIST,this.onSatelliteRadioEvent,false,0,true);
                  attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.FEATURED_FAVORITE,this.onSatelliteRadioEvent,false,0,true);
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFeatured.browse_list.onFocusCallBack));
                  break;
               case this.STATE_PRESETS:
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupPresets.browse_list.onFocusCallBack));
            }
         }
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SAT_BREADCRUMB,Breadcrumb.PAGE,Screens.MAIN_SAT));
      }
      
      private function setScreenViewState(state:String) : void
      {
         this.mCurrentState = state;
         mSavedVars.mCurrentState = this.mCurrentState;
         this.updateItemsInListText(0);
         this.addRemoveAPIListenersBasedOnState();
         this.setListItemsBeepEnabled(true);
         Peripheral.satelliteRadio.suppressFavOnAirNotifications = state == this.STATE_FAVORITES_ON_AIR ? true : false;
         switch(state)
         {
            case this.STATE_ALL_CHANNELS:
               this.mHasPositionedAllChannelsListToCurrentChannel = false;
               this.mGroupAllChannels.show();
               this.mGroupSideButtons.setSelection("all_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_ALL_CHANNELS_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupAllChannels.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupAllChannels.browse_list.selectEventHandler);
               this.setAllChannelsLength();
               if(this.mAllChannelsSort == Peripheral.satelliteRadio.SORT_CATEGORY_ASCENDING)
               {
                  this.mGroupAllChannels.header_group.setSelection("genre_button",false);
               }
               this.mGroupAllChannels.browse_list.requestData();
               Peripheral.satelliteRadio.requestCurrentStationInfo();
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupAllChannels.browse_list.onFocusCallBack));
               break;
            case this.STATE_FAVORITES_ALERT_SETTINGS:
               this.mGroupFavorites.show();
               this.mGroupFavoritesAlertSettings.show();
               this.mGroupSideButtons.setSelection("favorites_button",false);
               this.mGroupFavorites.header_group.setSelection("alertSettings_button",false);
               this.clearAndRefreshListData(this.mGroupFavoritesAlertSettings.browse_list);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_FAVOURITES_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_ALERT_SETTINGS_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupFavoritesAlertSettings.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupFavoritesAlertSettings.browse_list.selectEventHandler);
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesAlertSettings.browse_list.onFocusCallBack));
               break;
            case this.STATE_FAVORITES_ON_AIR:
               this.mGroupFavorites.show();
               this.mGroupFavoritesOnAir.show();
               this.mGroupSideButtons.setSelection("favorites_button",false);
               this.mGroupFavorites.header_group.setSelection("onAir_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_FAVOURITES_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_ON_AIR_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupFavoritesOnAir.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupFavoritesOnAir.browse_list.selectEventHandler);
               Peripheral.satelliteRadio.requestActiveFavorites();
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               if(Peripheral.satelliteRadio.activeFavoriteList.length != 0)
               {
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesOnAir.browse_list.onFocusCallBack));
               }
               else
               {
                  Framework.focusManager.setFocus(FocusPriority.REGULAR);
               }
               break;
            case this.STATE_FAVORITES_REMOVE:
               this.mGroupFavorites.show();
               this.mGroupFavoritesRemove.show();
               this.mGroupSideButtons.setSelection("favorites_button",false);
               this.mGroupFavorites.header_group.setSelection("removeFavorites_button",false);
               this.clearAndRefreshListData(this.mGroupFavoritesRemove.browse_list);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_FAVOURITES_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_REMOVE_FAVOURITES_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupFavoritesRemove.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupFavoritesRemove.browse_list.selectEventHandler);
               Peripheral.satelliteRadio.requestFavorites();
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               if(Peripheral.satelliteRadio.currentFavoriteList.length != 0)
               {
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFavoritesRemove.browse_list.onFocusCallBack));
               }
               else
               {
                  Framework.focusManager.setFocus(FocusPriority.REGULAR);
               }
               break;
            case this.STATE_GAMEZONE_ALERT_SETTINGS:
               this.mGroupGameZone.show();
               this.mGroupGameZoneAlertSettings.show();
               this.mGroupSideButtons.setSelection("gameZone_button",false);
               this.mGroupGameZone.header_group.setSelection("alertSettings_button",false);
               this.clearAndRefreshListData(this.mGroupGameZoneAlertSettings.browse_list);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_FAVOURITES_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_ALERT_SETTINGS_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupGameZoneAlertSettings.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupGameZoneAlertSettings.browse_list.selectEventHandler);
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneAlertSettings.browse_list.onFocusCallBack));
               break;
            case this.STATE_GAMEZONE_ON_AIR:
               this.mGroupGameZone.show();
               this.mGroupGameZoneOnAir.show();
               this.mGroupSideButtons.setSelection("gameZone_button",false);
               this.mGroupGameZone.header_group.setSelection("onAir_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_GAME_ZONE_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_ON_AIR_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupGameZoneOnAir.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupGameZoneOnAir.browse_list.selectEventHandler);
               Peripheral.satelliteRadio.requestActiveScores();
               this.mGroupGameZoneOnAir.browse_list.setLength(this.mGameZoneOnAirListData.length);
               this.mGroupGameZoneOnAir.browse_list.setPosition(0);
               this.mGroupGameZoneOnAir.browse_list.setCursor(0);
               this.mGroupGameZoneOnAir.browse_list.requestData();
               this.updateItemsInListText(this.mGameZoneOnAirListData.length);
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               if(this.mGameZoneOnAirListData.length != 0)
               {
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneOnAir.browse_list.onFocusCallBack));
               }
               else
               {
                  Framework.focusManager.setFocus(FocusPriority.REGULAR);
               }
               break;
            case this.STATE_GAMEZONE_REMOVE:
               this.mGroupGameZone.show();
               this.mGroupGameZoneRemove.show();
               this.mGroupSideButtons.setSelection("gameZone_button",false);
               this.mGroupGameZone.header_group.setSelection("removeSelection_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_GAME_ZONE_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_REMOVE_SELECTION_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupGameZoneRemove.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupGameZoneRemove.browse_list.selectEventHandler);
               this.mGroupGameZoneRemove.browse_list.setLength(0);
               Peripheral.satelliteRadio.requestFavoriteTeamsList();
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               if(Peripheral.satelliteRadio.favoriteTeamsList.length != 0)
               {
                  Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneRemove.browse_list.onFocusCallBack));
               }
               else
               {
                  Framework.focusManager.setFocus(FocusPriority.REGULAR);
               }
               break;
            case this.STATE_GAMEZONE_SELECT_CATEGORY:
               this.mGroupGameZone.show();
               this.mGroupGameZoneSelectCategory.show();
               this.mGroupSideButtons.setSelection("gameZone_button",false);
               this.mGroupGameZone.header_group.setSelection("selectTeams_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_GAME_ZONE_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_SELECT_TEAMS_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupGameZoneSelectCategory.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupGameZoneSelectCategory.browse_list.selectEventHandler);
               if(this.mGoingBack == false)
               {
                  this.mGroupGameZoneSelectCategory.browse_list.setLength(0);
               }
               Peripheral.satelliteRadio.requestLeagueList();
               Framework.Trace("GAMEZONE: League list requested");
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneSelectCategory.browse_list.onFocusCallBack));
               break;
            case this.STATE_GAMEZONE_SELECT_TEAM:
               this.mGroupGameZone.show();
               this.mGroupGameZoneSelectTeam.show();
               this.mGroupSideButtons.setSelection("gameZone_button",false);
               this.mGroupGameZone.header_group.setSelection("selectTeams_button",false);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_GAME_ZONE_BREADCRUMB));
               pushBreadcrumb(new Breadcrumb(T.STRB_SELECT_TEAMS_BREADCRUMB,Breadcrumb.FUNCTION,this.callbackForGameZoneSelectCategoryBreadCrumb));
               pushBreadcrumb(new Breadcrumb(this.mChosenLeague.abbrev));
               this.mHistory.push(this.STATE_GAMEZONE_SELECT_CATEGORY);
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupGameZoneSelectTeam.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupGameZoneSelectTeam.browse_list.selectEventHandler);
               Peripheral.satelliteRadio.requestFavoriteTeamsList();
               this.mGroupGameZoneSelectTeam.browse_list.setLength(0);
               Peripheral.satelliteRadio.requestTeamList(this.mChosenLeague.contentDescriptor);
               Framework.Trace("GAMEZONE: Team list requested");
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(true);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupGameZoneSelectTeam.browse_list.onFocusCallBack));
               break;
            case this.STATE_JUMP:
               this.mGroupJump.show();
               this.mGroupSideButtons.setSelection("jump_button",false);
               this.clearAndRefreshListData(this.mGroupJump.browse_list);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_JUMP_BREADCRUMB));
               this.mHistory.length = 0;
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupJump.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupJump.browse_list.selectEventHandler);
               Peripheral.satelliteRadio.requestWeatherTrafficChannels();
               this.changeSideButtonsPage(2);
               this.enableTopRowCursoring(false);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupJump.browse_list.onFocusCallBack));
               break;
            case this.STATE_PRESETS:
               this.mGroupPresets.browse_list.setRowUpdater(this.presetInitRowUpdater);
               this.mGroupPresets.browse_list.update();
               this.mGroupPresets.browse_list.setRowUpdater(this.presetListRowUpdater);
               this.mGroupPresets.show();
               this.mGroupSideButtons.setSelection("presets_button",false);
               this.clearAndRefreshListData(this.mGroupPresets.browse_list);
               this.mHistory.length = 0;
               this.highlightPreset();
               t(mView.itemsInList_label,Format.itemsInList(this.mPresetsListVector.length));
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_PRESET_BREADCRUMB));
               this.setListItemsBeepEnabled(false);
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupPresets.browse_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupPresets.browse_list.selectEventHandler);
               attachListener(Peripheral.hardControls,HardControlEvent.SELECT_2SEC_PRESS,this.mGroupPresets.browse_list.select2SecondPressEventHandler);
               this.changeSideButtonsPage(1);
               this.enableTopRowCursoring(false);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupPresets.browse_list.onFocusCallBack));
               break;
            case this.STATE_FEATURED:
               switch(this.mFeaturedState)
               {
                  case FEATURED_FAV_LIST:
                     this.mGroupFeatured.show();
                     this.mGroupSideButtons.setSelection("featured_button",false);
                     this.mFeaturedData.length = 0;
                     this.mGroupFeatured.browse_list.setLength(0);
                     this.clearAndRefreshListData(this.mGroupFeatured.browse_list);
                     Peripheral.satelliteRadio.requestFeaturedFavoritesList();
                     this.initBreadcrumbs();
                     pushBreadcrumb(new Breadcrumb(T.STRB_FEATURED_FAVORITES));
                     this.mHistory.length = 0;
                     swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupFeatured.browse_list.scrollEventHandler);
                     swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupFeatured.browse_list.selectEventHandler);
                     this.changeSideButtonsPage(2);
                     break;
                  case FEATURED_FAV:
                     this.mGroupFeatured.show();
                     this.mGroupSideButtons.setSelection("featured_button",false);
                     this.clearAndRefreshListData(this.mGroupFeatured.browse_list);
                     Peripheral.satelliteRadio.requestFeaturedFavorites(this.mSelectedFeaturedFavoriteBand.bandId);
                     this.initBreadcrumbs();
                     pushBreadcrumb(new Breadcrumb(T.STRB_FEATURED_FAVORITES,Breadcrumb.FUNCTION,this.callbackForFeaturedFavoriteCallBack));
                     if(this.mSelectedFeaturedFavoriteBand)
                     {
                        pushBreadcrumb(new Breadcrumb(this.mSelectedFeaturedFavoriteBand.verboseName));
                     }
                     this.mHistory.length = 0;
                     swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.mGroupFeatured.browse_list.scrollEventHandler);
                     swapListener(Peripheral.hardControls,HardControlEvent.SELECT,this.mGroupFeatured.browse_list.selectEventHandler);
                     this.changeSideButtonsPage(2);
               }
               this.enableTopRowCursoring(false);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,this.mGroupFeatured.browse_list.onFocusCallBack));
         }
         this.mPreviousState = state;
         this.mGoingBack = false;
      }
      
      private function allChannelsBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:SatelliteRadioChannel, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         if(data)
         {
            t(rowButton.channelNumber_label,String(data.number));
            t(rowButton.name_label,data.name);
            t(rowButton.genre_label,data.category);
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function allChannelsBrowseListDataRequester(start:int, end:int) : void
      {
         this.mAllChannelsListIndex = start;
         var length:int = end - start + 1;
         Peripheral.satelliteRadio.requestChannels(start,length,this.mAllChannelsSort);
      }
      
      private function allChannelsBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function presetListRowUpdater(row:MovieClip, rowIndex:int, data:Preset, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         var deleteButton:MovieClip = row.delete_button;
         row.data = data;
         t(rowButton.hold_label,T.STRB_HOLD_TO_SET_FMBROWSE);
         if(data)
         {
            row.show();
            t(rowButton.number_label,String(data.Position + 1));
            if(data.Active)
            {
               rowButton.hold_label.visible = false;
               rowButton.channelNumber_label.visible = true;
               rowButton.name_label.visible = true;
               t(rowButton.channelNumber_label,String(data.Freq_Channel));
               t(rowButton.name_label,data.StationName);
               deleteButton.setEnabled(true);
            }
            else
            {
               rowButton.hold_label.visible = true;
               rowButton.channelNumber_label.visible = false;
               rowButton.name_label.visible = false;
               deleteButton.setEnabled(false);
            }
         }
         else
         {
            row.hide();
         }
      }
      
      private function presetListDataRequester(start:int, end:int) : void
      {
         this.mPresetsListVector = Peripheral.presetPersistencyManager.getFilteredPresets(Peripheral.audioManager.SOURCE_SAT,0,this.LIST_DATA_LENGTH_PRESETS);
         this.listDataRequestHelper(this.mGroupPresets.browse_list,this.mPresetsListVector,this.LIST_DATA_LENGTH_PRESETS,start,end);
      }
      
      private function presetListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function favoritesOnAirBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:SatelliteRadioActiveFavorite, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         if(data)
         {
            t(rowButton.noItems_label,"");
            t(rowButton.channelNumber_label,String(data.channelNumber));
            t(rowButton.channelInfo_label,data.currentArtist + " - " + data.currentSong,TRUNCATE_WORDS);
            rowButton.setInteractive(true);
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            if(this.noFavItemsLabelHeight == -1)
            {
               this.noFavItemsLabelHeight = rowButton.noItems_label.height;
            }
            rowButton.noItems_label.height = 4 * this.noFavItemsLabelHeight;
            t(rowButton.noItems_label,T.STRB_NO_FAVORITES);
            t(rowButton.channelNumber_label,"");
            t(rowButton.channelInfo_label,"");
            rowButton.setInteractive(false);
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function favoritesOnAirBrowseListDataRequester(start:int, end:int) : void
      {
         Framework.Trace(start + " " + length);
         this.listDataRequestHelper(this.mGroupFavoritesOnAir.browse_list,this.mFavoritesOnAirListData,this.mFavoritesOnAirListData.length,start,end);
      }
      
      private function favoritesOnAirBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function initFavoritesRemoveBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:SatelliteRadioFavorite, dataIndex:int) : void
      {
         attachListener(row.delete_button,MouseEvent.CLICK,this.onFavoritesRemoveDeleteButtonClick,false,0,true);
      }
      
      private function favoritesRemoveBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:SatelliteRadioFavorite, dataIndex:int) : void
      {
         var labelText:String = null;
         var rowButton:MovieClip = row.row_button;
         var deleteButton:MovieClip = row.delete_button;
         if(data)
         {
            row.data = data;
            labelText = "";
            if(data.type == SatelliteRadioFavorite.ARTIST)
            {
               labelText = data.artist;
            }
            else if(data.type == SatelliteRadioFavorite.SONG)
            {
               labelText = data.artist + " - " + data.song;
            }
            else if(data.type == "deleteall")
            {
               labelText = compose(T.STRB_DELETE_ALL);
            }
            else if(Boolean(data.artist) && Boolean(data.song))
            {
               labelText = data.artist + " - " + data.song;
            }
            t(rowButton.noItems_label,"");
            t(rowButton.value_label,labelText,TRUNCATE_WORDS,"...");
            deleteButton.show();
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            t(rowButton.noItems_label,T.STRB_NO_ITEMS);
            t(rowButton.value_label,"");
            deleteButton.hide();
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function favoritesRemoveBrowseListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupFavoritesRemove.browse_list,this.mFavoritesRemoveData,this.mFavoritesRemoveData.length,start,end);
      }
      
      private function favoritesRemoveBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function favoritesAlertSettingsListRowUpdater(row:MovieClip, rowIndex:int, data:Object, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         var checkBoxButton:MovieClip = row.checkBox_button;
         if(data)
         {
            t(rowButton.value_label,data.name);
            if(data.id == "visualAlert")
            {
               checkBoxButton.setSelected(Peripheral.satelliteRadio.favoriteAlertType == SatelliteRadioFavorite.VISUAL_ONLY);
            }
            else if(data.id == "audioVisualAlert")
            {
               checkBoxButton.setSelected(Peripheral.satelliteRadio.favoriteAlertType == SatelliteRadioFavorite.AUDIO_VISUAL);
            }
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function favoritesAlertSettingsListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupFavoritesAlertSettings.browse_list,this.mFavoritesAlertSettingsData,this.mFavoritesAlertSettingsData.length,start,end);
         this.mGroupFavoritesAlertSettings.browse_list.setLength(this.mFavoritesAlertSettingsData.length);
         this.mGroupFavoritesAlertSettings.browse_list.update();
         this.updateItemsInListText(this.mFavoritesAlertSettingsData.length);
      }
      
      private function favoritesAlertSettingsListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function gameZoneOnAirBrowseListRowUpdater(row:MovieClip, rowIndex:int, gameScore:GameZoneScoreAlert, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         if(gameScore)
         {
            t(rowButton.noItems_label,"");
            t(rowButton.info_label,gameScore.channel + "  " + gameScore.gameTitle + "  " + gameScore.gameArtist);
            rowButton.setInteractive(true);
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            if(this.noGameItemsLabelHeight == -1)
            {
               this.noGameItemsLabelHeight = rowButton.noItems_label.height;
            }
            rowButton.noItems_label.height = 4 * this.noGameItemsLabelHeight;
            t(rowButton.noItems_label,T.STRB_NO_GAMES);
            t(rowButton.info_label,"");
            rowButton.setInteractive(false);
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function gameZoneOnAirBrowseListDataRequester(start:int, end:int) : void
      {
         this.mGameZoneOnAirListData = Peripheral.satelliteRadio.activeScores;
         this.listDataRequestHelper(this.mGroupGameZoneOnAir.browse_list,this.mGameZoneOnAirListData,this.mGameZoneOnAirListData.length,start,end);
      }
      
      private function gameZoneOnAirBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function gameZoneSelectCategoryBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:GameZoneLeagues, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         if(data)
         {
            t(rowButton.name_label,data.abbrev);
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function gameZoneSelectCategoryBrowseListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupGameZoneSelectCategory.browse_list,this.mGameZoneLeagueData,this.mGameZoneLeagueData.length,start,end);
      }
      
      private function gameZoneSelectCategoryBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function gameZoneSelectTeamBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:GameZoneFavoriteTeam, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         var checkBoxButton:MovieClip = row.checkBox_button;
         if(data)
         {
            t(rowButton.noItems_label,"");
            t(rowButton.name_label,data.teamName + " " + data.teamNick);
            if(data.isFavorite)
            {
               Framework.Trace("!!!!!!!!!!!!!FAV   !!!");
            }
            checkBoxButton.setSelected(data.isFavorite);
            checkBoxButton.show();
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            t(rowButton.noItems_label,T.STRB_NO_ITEMS);
            t(rowButton.name_label,"");
            checkBoxButton.hide();
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function gameZoneSelectTeamBrowseListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupGameZoneSelectTeam.browse_list,this.mGameZoneTeamsData,this.mGameZoneTeamsData.length,start,end);
      }
      
      private function gameZoneSelectTeamBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function initGameZoneRemoveBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:GameZoneFavoriteTeam, dataIndex:int) : void
      {
         attachListener(row.delete_button,MouseEvent.CLICK,this.onGameZoneRemoveDeleteButtonClick,false,0,true);
      }
      
      private function gameZoneRemoveBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:GameZoneFavoriteTeam, dataIndex:int) : void
      {
         var labelText:String = null;
         var rowButton:MovieClip = row.row_button;
         var deleteButton:MovieClip = row.delete_button;
         if(data)
         {
            row.data = data;
            labelText = "";
            if(data.teamName == "deleteall")
            {
               labelText = compose(T.STRB_DELETE_ALL);
            }
            else
            {
               labelText = data.teamName + " " + data.teamNick;
            }
            t(rowButton.noItems_label,"");
            t(rowButton.name_label,labelText);
            deleteButton.show();
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            t(rowButton.noItems_label,T.STRB_NO_ITEMS);
            t(rowButton.name_label,"");
            deleteButton.hide();
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function gameZoneRemoveBrowseListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupGameZoneRemove.browse_list,this.mGameZoneRemoveData,this.mGameZoneRemoveData.length,start,end);
      }
      
      private function gameZoneRemoveBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function gameZoneAlertSettingsListRowUpdater(row:MovieClip, rowIndex:int, data:Object, dataIndex:int) : void
      {
         var alertStatus:Boolean = false;
         var rowButton:MovieClip = row.row_button;
         var checkBoxButton:MovieClip = row.checkBox_button;
         if(data)
         {
            row.data = data;
            t(rowButton.value_label,data.name);
            if(data.id == "alertUponStart")
            {
               alertStatus = Boolean(Peripheral.satelliteRadio.startOfGameAlertStatus);
               checkBoxButton.setSelected(alertStatus);
            }
            else if(data.id == "alertUponScore")
            {
               alertStatus = Boolean(Peripheral.satelliteRadio.scoreChangeAlertStatus);
               checkBoxButton.setSelected(alertStatus);
            }
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function gameZoneAlertSettingsListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupGameZoneAlertSettings.browse_list,this.mGameZoneAlertSettingsData,this.mGameZoneAlertSettingsData.length,start,end);
         this.mGroupGameZoneAlertSettings.browse_list.setLength(this.mGameZoneAlertSettingsData.length);
         this.mGroupGameZoneAlertSettings.browse_list.update();
         this.updateItemsInListText(this.mGameZoneAlertSettingsData.length);
      }
      
      private function gameZoneAlertSettingsListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function jumpBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:SatelliteRadioChannel, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         var checkBoxButton:MovieClip = row.checkBox_button;
         if(data)
         {
            checkBoxButton.setSelected(null != Peripheral.satelliteRadio.jumpChannel && data.name == Peripheral.satelliteRadio.jumpChannel.name);
            if(data.number != 65535)
            {
               t(rowButton.channelNumber_label,String(data.number));
            }
            else
            {
               t(rowButton.channelNumber_label,"");
            }
            t(rowButton.noItems_label,"");
            t(rowButton.location_label,data.name);
            checkBoxButton.show();
            row.show();
         }
         else if(row.name == "row_0_group")
         {
            t(rowButton.noItems_label,T.STRB_NO_ITEMS);
            t(rowButton.location_label,"");
            t(rowButton.channelNumber_label,"");
            checkBoxButton.hide();
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function jumpBrowseListDataRequester(start:int, end:int) : void
      {
         this.listDataRequestHelper(this.mGroupJump.browse_list,this.mJumpListData,this.mJumpListData.length,start,end);
      }
      
      private function jumpBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function featuredBrowseListRowUpdater(row:MovieClip, rowIndex:int, data:Object, dataIndex:int) : void
      {
         var rowButton:MovieClip = row.row_button;
         if(data)
         {
            switch(this.mFeaturedState)
            {
               case FEATURED_FAV_LIST:
                  t(rowButton.value_label,data.verboseName);
                  break;
               case FEATURED_FAV:
                  t(rowButton.value_label,data.name);
            }
            row.show();
         }
         else
         {
            row.hide();
         }
      }
      
      private function featuredBrowseListDataRequester(start:int, end:int) : void
      {
         switch(this.mFeaturedState)
         {
            case FEATURED_FAV_LIST:
               this.listDataRequestHelper(this.mGroupFeatured.browse_list,this.mFeaturedListData,this.mFeaturedListData.length,start,end);
               break;
            case FEATURED_FAV:
               this.listDataRequestHelper(this.mGroupFeatured.browse_list,this.mFeaturedData,this.mFeaturedData.length,start,end);
               this.mHistory.push(this.STATE_FEATURED);
         }
      }
      
      private function featuredBrowseListSelectionChanger(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function configureListAndScroller(browseList:MovieClip, browseScroller:MovieClip, initRowUpdater:Function = null, rowUpdater:Function = null, dataRequester:Function = null, selectionChanger:Function = null, listLength:int = 0) : void
      {
         browseList.attachScroller(browseScroller);
         if(initRowUpdater != null)
         {
            browseList.setRowUpdater(initRowUpdater);
            browseList.update();
         }
         if(rowUpdater != null)
         {
            browseList.setRowUpdater(rowUpdater);
         }
         if(dataRequester != null)
         {
            browseList.setDataRequester(dataRequester);
         }
         if(selectionChanger != null)
         {
            browseList.setSelectionChanger(selectionChanger);
         }
         browseList.setLength(listLength);
         browseScroller.setReportingPeriod(500);
         browseScroller.setValue(0);
      }
      
      private function listDataRequestHelper(listMC:MovieClip, data:Object, dataLength:int, start:int, end:int) : void
      {
         var list:Array = new Array();
         for(var i:int = start; i <= end; i++)
         {
            list.push(data[i]);
         }
         listMC.setData({
            "offset":start,
            "list":list
         });
      }
      
      private function clearAndRefreshListData(listMC:MovieClip) : void
      {
         listMC.setData(null);
         listMC.update();
         listMC.requestData();
      }
      
      private function restoreListPositionAndCursor(movieClip:MovieClip, defaultPosition:uint = 0, defaultCursor:uint = 0) : void
      {
         var position:uint = defaultPosition;
         var cursor:uint = defaultCursor;
         if(Boolean(mSavedVars.hasOwnProperty("listPosition")) && Boolean(mSavedVars.hasOwnProperty("listCursor")))
         {
            position = uint(mSavedVars.listPosition);
            cursor = uint(mSavedVars.listCursor);
         }
         movieClip.setPosition(position);
         movieClip.setCursor(cursor);
      }
      
      private function updateRemoveFavoritesListContent(newFavRemoveData:Vector.<SatelliteRadioFavorite>) : void
      {
         this.clearAndRefreshListData(this.mGroupFavoritesRemove.browse_list);
         this.mFavoritesRemoveData = newFavRemoveData;
         this.mGroupFavoritesRemove.browse_list.setLength(this.mFavoritesRemoveData.length);
         this.mGroupFavoritesRemove.browse_list.setPosition(0);
         this.mGroupFavoritesRemove.browse_list.setCursor(0);
      }
      
      private function highlightPreset() : void
      {
         var targetIndex:int = 0;
         var presetPos:int = int(Peripheral.satelliteRadio.currentChannel.presetNum);
         if(presetPos != -1)
         {
            targetIndex = presetPos;
         }
         this.mGroupPresets.browse_list.update();
         var position:int = int(this.mGroupPresets.browse_list.getPosition());
         this.mGroupPresets.browse_list.setPosition(targetIndex > 0 ? targetIndex - 1 : targetIndex);
         this.mGroupPresets.browse_list.setCursor(targetIndex);
      }
      
      private function updateItemsInListText(itemAmount:int = 0) : void
      {
         if(itemAmount < 0)
         {
            itemAmount = 0;
         }
         t(mView.itemsInList_label,Format.itemsInList(itemAmount));
      }
      
      private function setAllChannelsLength() : void
      {
         var length:int = int(Peripheral.satelliteRadio.channelListLength);
         this.mGroupAllChannels.browse_list.setLength(length);
         this.updateItemsInListText(length);
      }
      
      private function callbackForGameZoneSelectCategoryBreadCrumb(goingBack:Boolean = false) : void
      {
         this.mGoingBack = goingBack;
         this.setScreenViewState(this.STATE_GAMEZONE_SELECT_CATEGORY);
      }
      
      private function callbackForFeaturedFavoriteCallBack(goingBack:Boolean = false) : void
      {
         this.mGoingBack = goingBack;
         this.mFeaturedState = FEATURED_FAV_LIST;
         Peripheral.satelliteRadio.requestFeaturedFavoritesList();
      }
      
      override protected function back(e:Event = null) : void
      {
         if(this.mHistory.length > 0)
         {
            if(this.mFeaturedState == "fav")
            {
               this.mFeaturedState = "List";
            }
            this.mGoingBack = true;
            this.setScreenViewState(this.mHistory.pop());
         }
         else
         {
            super.back();
         }
      }
      
      private function onCloseButtonClick(evt:MouseEvent) : void
      {
         Framework.structure.exit();
      }
      
      private function onStateSettingButtonClick(evt:MouseEvent) : void
      {
         this.mFeaturedState = FEATURED_FAV_LIST;
         this.setScreenViewState(evt.currentTarget.state);
      }
      
      private function onSideButtonsArrow(e:WidgetEvent) : void
      {
         this.changeSideButtonsPage(mView.arrow_button.icon.currentFrame == 1 ? 2 : 1);
      }
      
      private function changeSideButtonsPage(page:int) : void
      {
         if(page == 2)
         {
            this.mGroupSideButtons.jump_button.visible = true;
            this.mGroupSideButtons.featured_button.visible = true;
            this.mGroupSideButtons.all_button.visible = false;
            this.mGroupSideButtons.presets_button.visible = false;
            this.mGroupSideButtons.favorites_button.visible = false;
            this.mGroupSideButtons.gameZone_button.visible = false;
            mView.arrow_button.icon.gotoAndStop(2);
         }
         else
         {
            this.mGroupSideButtons.jump_button.visible = false;
            this.mGroupSideButtons.featured_button.visible = false;
            this.mGroupSideButtons.all_button.visible = true;
            this.mGroupSideButtons.presets_button.visible = true;
            this.mGroupSideButtons.favorites_button.visible = true;
            this.mGroupSideButtons.gameZone_button.visible = true;
            mView.arrow_button.icon.gotoAndStop(1);
         }
      }
      
      private function onSideButtonsGroupSelect(evt:WidgetEvent) : void
      {
         if(this.mGroupSideButtons[evt.data.targetName].state == this.STATE_FEATURED)
         {
            this.mFeaturedState = FEATURED_FAV_LIST;
         }
         this.setScreenViewState(this.mGroupSideButtons[evt.data.targetName].state);
      }
      
      private function onFavoritesGroupHeaderButtonsSelect(evt:WidgetEvent) : void
      {
         this.setScreenViewState(this.mGroupFavorites.header_group[evt.data.targetName].state);
      }
      
      private function onGameZoneGroupHeaderButtonsSelect(evt:WidgetEvent) : void
      {
         this.setScreenViewState(this.mGroupGameZone.header_group[evt.data.targetName].state);
      }
      
      private function onAllChannelsHeaderButtonGroupSelect(evt:WidgetEvent) : void
      {
         switch(evt.data.targetName)
         {
            case "channel_button":
               this.mAllChannelsSort = Peripheral.satelliteRadio.SORT_CHANNEL_ASCENDING;
               break;
            case "genre_button":
               this.mAllChannelsSort = Peripheral.satelliteRadio.SORT_CATEGORY_ASCENDING;
         }
         this.mChannelSortPressed = true;
         this.mGroupAllChannels.browse_list.requestData();
         Peripheral.satelliteRadio.requestCurrentStationInfo();
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function onPresetRowButtonSelect(e:WidgetEvent) : void
      {
         var preset:Preset = null;
         var index:int = 0;
         if(this.handlingLongPress)
         {
            this.handlingLongPress = false;
         }
         else
         {
            preset = e.data.visual.data;
            if(Framework.focusManager.cursorActive)
            {
               if(!preset.Active)
               {
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_SAT_BROWSE,Screens.POPUP_OPTIONS,{
                     "type":PopupType.OPTIONS,
                     "title":T.STRB_OPTIONS,
                     "labels":[T.STRB_PLAY,T.STRB_DELETE],
                     "enabled":[true,true],
                     "highlight":[false,false],
                     "callBack":this.onOptionsCallBack
                  });
               }
            }
            else if(e.data.targetName != "delete_button")
            {
               if(preset.Active)
               {
                  index = int(Peripheral.satelliteRadio.skippedChannels.indexOf(preset.Freq_Channel));
                  if(-1 == index)
                  {
                     Peripheral.satelliteRadio.presetRecall(preset.Position);
                     Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
                     this.onCloseButtonClick(null);
                  }
                  else
                  {
                     Ancillary.definedDynamicPopups.show(DynamicPopupNames.SIRIUS_AUDIO_SKIPPED_CHANNEL);
                  }
               }
               else
               {
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               }
            }
         }
      }
      
      private function onDeleteButtonClick(e:MouseEvent) : void
      {
         var preset:Preset = e.currentTarget.parent.data as Preset;
         if(e.currentTarget.getEnabled())
         {
            Peripheral.presetManager.deletePreset(Peripheral.audioManager.SOURCE_SAT,preset.Position);
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
            this.mGroupPresets.browse_list.requestData();
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
      }
      
      private function onPresetRowButtonLongPress(evt:WidgetEvent) : void
      {
         var preset:Preset = null;
         if(evt.data.targetName != "delete_button")
         {
            preset = evt.data.data;
            this.handlingLongPress = !evt.data.isICSpress;
            if(preset != null)
            {
               Peripheral.presetManager.storeCurrentChannelAsPreset(preset.Position);
               this.mGroupPresets.browse_list.requestData();
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
            }
         }
      }
      
      private function onAllChannelsBrowseListSelect(evt:WidgetEvent) : void
      {
         var data:SatelliteRadioChannel = evt.data.data;
         Peripheral.satelliteRadio.setCurrentChannelByNumber(data.number);
         this.onCloseButtonClick(null);
      }
      
      private function onFavoritesOnAirBrowseListSelect(evt:WidgetEvent) : void
      {
         var favorite:SatelliteRadioActiveFavorite = evt.data.data;
         Peripheral.satelliteRadio.setCurrentChannelByNumber(favorite.channelNumber);
         Framework.structure.goto(Screens.MAIN_SAT);
         this.onCloseButtonClick(null);
      }
      
      private function onFavoritesRemoveDeleteButtonClick(evt:MouseEvent) : void
      {
         var favorite:SatelliteRadioFavorite = evt.currentTarget.parent.data;
         if(favorite.type != "deleteall")
         {
            Peripheral.satelliteRadio.deleteFavorite(favorite);
            Peripheral.satelliteRadio.requestFavorites();
         }
         else
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.DELETE_ALL_AUDIO_FAVORITES);
         }
      }
      
      private function onFavoritesRemoveBrowseListSelect(evt:WidgetEvent) : void
      {
      }
      
      private function onFavoritesAlertSettingsBrowseListSelect(evt:WidgetEvent) : void
      {
         if(evt.data.data.id == "visualAlert")
         {
            if(SatelliteRadioFavorite.VISUAL_ONLY == Peripheral.satelliteRadio.favoriteAlertType)
            {
               Peripheral.satelliteRadio.favoriteAlertType = SatelliteRadioFavorite.ALERT_OFF;
            }
            else
            {
               Peripheral.satelliteRadio.favoriteAlertType = SatelliteRadioFavorite.VISUAL_ONLY;
            }
         }
         else if(evt.data.data.id == "audioVisualAlert")
         {
            if(SatelliteRadioFavorite.AUDIO_VISUAL == Peripheral.satelliteRadio.favoriteAlertType)
            {
               Peripheral.satelliteRadio.favoriteAlertType = SatelliteRadioFavorite.ALERT_OFF;
            }
            else
            {
               Peripheral.satelliteRadio.favoriteAlertType = SatelliteRadioFavorite.AUDIO_VISUAL;
            }
         }
         this.clearAndRefreshListData(this.mGroupFavoritesAlertSettings.browse_list);
      }
      
      private function onGameZoneOnAirBrowseListSelect(evt:WidgetEvent) : void
      {
         var game:GameZoneScoreAlert = evt.data.data;
         Peripheral.satelliteRadio.setCurrentChannelByNumber(game.channel);
         this.onCloseButtonClick(null);
      }
      
      private function onGameZoneSelectCategoryBrowseListSelect(evt:WidgetEvent) : void
      {
         this.mChosenLeague = evt.data.data;
         this.setScreenViewState(this.STATE_GAMEZONE_SELECT_TEAM);
      }
      
      private function onGameZoneSelectTeamBrowseListSelect(evt:WidgetEvent) : void
      {
         var isFavoritesNotFull:Boolean = false;
         var index:uint = uint(evt.data.dataIndex);
         var team:GameZoneFavoriteTeam = this.mGameZoneTeamsData[index];
         if(team.isFavorite)
         {
            Peripheral.satelliteRadio.removeFavoriteTeam(this.mChosenLeague.contentDescriptor,team.teamID);
         }
         else
         {
            isFavoritesNotFull = Boolean(Peripheral.satelliteRadio.addFavoriteTeam(this.mChosenLeague.contentDescriptor,team.teamID,team.alertType));
            if(isFavoritesNotFull)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
            }
            else
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.FAVORITE_TEAMS_LIST_FULL);
            }
         }
      }
      
      private function onGameZoneRemoveBrowseListSelect(evt:WidgetEvent) : void
      {
      }
      
      private function onGameZoneAlertSettingsSelect(evt:WidgetEvent) : void
      {
         if(evt.data.data.id == "alertUponStart")
         {
            Peripheral.satelliteRadio.enableStartOfGameAlert(!Peripheral.satelliteRadio.startOfGameAlertStatus);
         }
         else if(evt.data.data.id == "alertUponScore")
         {
            Peripheral.satelliteRadio.enableScoreChangeAlert(!Peripheral.satelliteRadio.scoreChangeAlertStatus);
         }
         this.clearAndRefreshListData(this.mGroupGameZoneAlertSettings.browse_list);
      }
      
      private function onGameZoneRemoveDeleteButtonClick(evt:MouseEvent) : void
      {
         var team:GameZoneFavoriteTeam = evt.currentTarget.parent.data;
         if(team.teamName != "deleteall")
         {
            Peripheral.satelliteRadio.removeFavoriteTeam(team.league,team.teamID);
         }
         else
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.DELETE_ALL_TEAM_FAVORITES);
         }
      }
      
      private function onJumpBrowseListSelect(evt:WidgetEvent) : void
      {
         var channel:SatelliteRadioTrafficChannel = evt.data.data;
         if(null != Peripheral.satelliteRadio.jumpChannel && channel.name == Peripheral.satelliteRadio.jumpChannel.name)
         {
            Peripheral.satelliteRadio.deselectTrafficMarket();
         }
         else
         {
            Peripheral.satelliteRadio.setJumpChannel(channel);
         }
         this.mGroupJump.browse_list.requestData();
      }
      
      private function onFeaturedFavoritesBrowseListSelect(evt:WidgetEvent) : void
      {
         switch(this.mFeaturedState)
         {
            case FEATURED_FAV_LIST:
               this.mSelectedFeaturedFavoriteBand = evt.data.data;
               this.mFeaturedState = FEATURED_FAV;
               Peripheral.satelliteRadio.requestFeaturedFavorites(this.mSelectedFeaturedFavoriteBand.bandId);
               break;
            case FEATURED_FAV:
               Peripheral.satelliteRadio.setCurrentChannelByNumber(evt.data.data.channelId);
               Framework.structure.goto(Screens.MAIN_SAT);
         }
      }
      
      private function onSatAppStatus(e:SatelliteRadioEvent) : void
      {
         Framework.Trace("RadioSatBrowseScreen: AppStatus is now " + e.data);
         if(e.data == "READY")
         {
            this.setScreenViewState(this.mCurrentState);
         }
         else
         {
            this.onCloseButtonClick(null);
         }
      }
      
      private function onSatelliteRadioEvent(evt:SatelliteRadioEvent) : void
      {
         var tempFavRemoveData:Vector.<SatelliteRadioFavorite> = null;
         var targetIndex:int = 0;
         var ListTargetIndex:int = 0;
         var tempFav:SatelliteRadioFavorite = null;
         var tempGame:GameZoneFavoriteTeam = null;
         switch(evt.type)
         {
            case SatelliteRadioEvent.CHANNELS:
               this.mGroupAllChannels.browse_list.setData({
                  "offset":this.mAllChannelsListIndex,
                  "list":Peripheral.satelliteRadio.channelList
               });
               this.mGroupAllChannels.browse_list.update();
               this.setAllChannelsLength();
               if(!this.mHasPositionedAllChannelsListToCurrentChannel)
               {
                  this.mHasPositionedAllChannelsListToCurrentChannel = true;
                  targetIndex = int(Peripheral.satelliteRadio.currentChannelIndex);
                  this.mGroupAllChannels.browse_list.setPosition(targetIndex > 0 ? targetIndex - 1 : targetIndex);
                  this.mGroupAllChannels.browse_list.setCursor(targetIndex);
               }
               else if(this.mChannelSortPressed)
               {
                  this.mChannelSortPressed = false;
                  ListTargetIndex = int(Peripheral.satelliteRadio.currentChannelIndex);
                  this.mGroupAllChannels.browse_list.setPosition(ListTargetIndex > 0 ? ListTargetIndex - 1 : ListTargetIndex);
                  this.mGroupAllChannels.browse_list.setCursor(ListTargetIndex);
               }
               break;
            case SatelliteRadioEvent.CHANNELS_UPDATED:
               this.mGroupAllChannels.browse_list.requestData();
               this.mGroupAllChannels.browse_list.update();
               this.setAllChannelsLength();
               break;
            case SatelliteRadioEvent.AVAILABLE_CHANNELS:
               break;
            case SatelliteRadioEvent.ACTIVE_AUDIO_FAVORITES:
               this.mFavoritesOnAirListData = Peripheral.satelliteRadio.activeFavoriteList;
               this.mGroupFavoritesOnAir.browse_list.setLength(this.mFavoritesOnAirListData.length);
               this.mGroupFavoritesOnAir.browse_list.requestData();
               this.updateItemsInListText(this.mFavoritesOnAirListData.length);
               break;
            case SatelliteRadioEvent.ALL_AUDIO_FAVORITES:
               tempFavRemoveData = Peripheral.satelliteRadio.currentFavoriteList.slice();
               if(tempFavRemoveData.length > 0)
               {
                  tempFav = new SatelliteRadioFavorite();
                  tempFav.type = "deleteall";
                  tempFavRemoveData.unshift(tempFav);
               }
               this.updateRemoveFavoritesListContent(tempFavRemoveData);
               this.updateItemsInListText(this.mFavoritesRemoveData.length - 1);
               this.mGroupFavoritesRemove.browse_list.requestData();
               break;
            case SatelliteRadioEvent.ACTIVE_GAME:
            case SatelliteRadioEvent.SCORE_ALERT:
               Peripheral.satelliteRadio.requestActiveScores();
               break;
            case SatelliteRadioEvent.ACTIVE_SCORES:
               this.mGameZoneOnAirListData = Peripheral.satelliteRadio.activeScores;
               this.mGroupGameZoneOnAir.browse_list.setLength(this.mGameZoneOnAirListData.length);
               this.mGroupGameZoneOnAir.browse_list.setPosition(0);
               this.mGroupGameZoneOnAir.browse_list.setCursor(0);
               this.mGroupGameZoneOnAir.browse_list.requestData();
               this.updateItemsInListText(this.mGameZoneOnAirListData.length);
               break;
            case SatelliteRadioEvent.LEAGUES:
               Framework.Trace("GAMEZONE: LEAGUES event caught");
               this.mGameZoneLeagueData = Peripheral.satelliteRadio.leagueList;
               this.mGroupGameZoneSelectCategory.browse_list.setLength(this.mGameZoneLeagueData.length);
               this.mGroupGameZoneSelectCategory.browse_list.setPosition(0);
               this.mGroupGameZoneSelectCategory.browse_list.setCursor(0);
               this.mGroupGameZoneSelectCategory.browse_list.requestData();
               this.updateItemsInListText(this.mGameZoneLeagueData.length);
               break;
            case SatelliteRadioEvent.TEAMS:
               this.mGameZoneTeamsData = Peripheral.satelliteRadio.getTeamList(this.mChosenLeague);
               this.mGroupGameZoneSelectTeam.browse_list.setLength(this.mGameZoneTeamsData.length);
               this.mGroupGameZoneSelectTeam.browse_list.requestData();
               this.updateItemsInListText(this.mGameZoneTeamsData.length);
               break;
            case SatelliteRadioEvent.FAVORITE_TEAMS:
               this.mGameZoneRemoveData = Peripheral.satelliteRadio.favoriteTeamsList;
               if(this.mGameZoneRemoveData.length > 0)
               {
                  tempGame = new GameZoneFavoriteTeam();
                  tempGame.teamName = "deleteall";
                  this.mGameZoneRemoveData.unshift(tempGame);
               }
               this.mGroupGameZoneRemove.browse_list.setLength(this.mGameZoneRemoveData.length);
               this.mGroupGameZoneRemove.browse_list.setPosition(0);
               this.mGroupGameZoneRemove.browse_list.setCursor(0);
               this.mGroupGameZoneRemove.browse_list.requestData();
               this.updateItemsInListText(this.mGameZoneRemoveData.length - 1);
               break;
            case SatelliteRadioEvent.JUMP_CHANNELS:
               this.clearAndRefreshListData(this.mGroupJump.browse_list);
               this.mJumpListData = Peripheral.satelliteRadio.weatherTrafficChannelList;
               this.mGroupJump.browse_list.setLength(this.mJumpListData.length);
               this.mGroupJump.browse_list.setPosition(0);
               this.mGroupJump.browse_list.setCursor(0);
               this.mGroupJump.browse_list.requestData();
               this.updateItemsInListText(this.mJumpListData.length);
               break;
            case SatelliteRadioEvent.JUMP_MARKET:
               this.mJumpListData = Peripheral.satelliteRadio.weatherTrafficChannelList;
               this.mGroupJump.browse_list.requestData();
               break;
            case SatelliteRadioEvent.FEATURED_FAVORITE_LIST:
               if(this.mFeaturedState == FEATURED_FAV_LIST)
               {
                  this.mFeaturedListData = Peripheral.satelliteRadio.featuredFavoritesList;
                  this.mGroupFeatured.browse_list.setLength(this.mFeaturedListData.length);
                  this.mGroupFeatured.browse_list.setPosition(0);
                  this.mGroupFeatured.browse_list.setCursor(0);
                  this.mGroupFeatured.browse_list.requestData();
                  this.updateItemsInListText(this.mFeaturedListData.length);
                  this.initBreadcrumbs();
                  pushBreadcrumb(new Breadcrumb(T.STRB_FEATURED_FAVORITES));
               }
               break;
            case SatelliteRadioEvent.FEATURED_FAVORITE:
               if(this.mFeaturedState == FEATURED_FAV)
               {
                  this.mFeaturedData = Peripheral.satelliteRadio.featuredFavorites;
                  this.mGroupFeatured.browse_list.setLength(this.mFeaturedData.length);
                  this.mGroupFeatured.browse_list.setPosition(0);
                  this.mGroupFeatured.browse_list.setCursor(0);
                  this.mGroupFeatured.browse_list.requestData();
                  this.updateItemsInListText(this.mFeaturedData.length);
                  this.initBreadcrumbs();
                  pushBreadcrumb(new Breadcrumb(T.STRB_FEATURED_FAVORITES,Breadcrumb.FUNCTION,this.callbackForFeaturedFavoriteCallBack));
                  if(this.mSelectedFeaturedFavoriteBand)
                  {
                     pushBreadcrumb(new Breadcrumb(this.mSelectedFeaturedFavoriteBand.verboseName));
                  }
               }
         }
      }
      
      private function onRefreshStructure(e:StructureEvent) : void
      {
         if(e.branch == Screens.BROWSE_SAT)
         {
            screenVars = e.vars;
            this.initScreen();
         }
      }
      
      private function setListItemsBeepEnabled(isEnabled:Boolean) : void
      {
         this.mGroupPresets.browse_list.row_0_group.row_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_1_group.row_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_2_group.row_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_3_group.row_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_4_group.row_button.setBeepEnabled(isEnabled);
         if(this.mGroupPresets.browse_list.row_5_group)
         {
            this.mGroupPresets.browse_list.row_5_group.row_button.setBeepEnabled(isEnabled);
         }
         this.mGroupPresets.browse_list.row_0_group.delete_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_1_group.delete_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_2_group.delete_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_3_group.delete_button.setBeepEnabled(isEnabled);
         this.mGroupPresets.browse_list.row_4_group.delete_button.setBeepEnabled(isEnabled);
         if(this.mGroupPresets.browse_list.row_5_group)
         {
            this.mGroupPresets.browse_list.row_5_group.delete_button.setBeepEnabled(isEnabled);
         }
      }
      
      private function onOptionsCallBack(o:Object) : void
      {
         var preset:Preset = null;
         var index:int = 0;
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_SAT_BROWSE);
         preset = this.mGroupPresets.browse_list.getSelectedData() as Preset;
         switch(o.id)
         {
            case 0:
               index = int(Peripheral.satelliteRadio.skippedChannels.indexOf(preset.Freq_Channel));
               if(-1 == index)
               {
                  Peripheral.satelliteRadio.presetRecall(preset.Position);
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
                  this.onCloseButtonClick(null);
               }
               else
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SIRIUS_AUDIO_SKIPPED_CHANNEL);
               }
               break;
            case 1:
               Peripheral.presetManager.deletePreset(Peripheral.audioManager.SOURCE_SAT,preset.Position);
               this.mGroupPresets.browse_list.requestData();
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         }
      }
   }
}

