package com.harman.navigation.global.vServices
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class VServiceScreenHelper
   {
      
      public static const SCROLLING_ENTRY_MAP:int = 0;
      
      public static const SCROLLING_ENTRY_MAP_REENTRY:int = 1;
      
      public static const SCROLLING_ENTRY_ADVANCED:int = 2;
      
      public static const SCROLLING_ENTRY_ADVANCED_REENTRY:int = 3;
      
      public static const SCROLLING_ENTRY_FAV:int = 4;
      
      public static const SCROLLING_ENTRY_FAV_POSITION_CHANGED:int = 5;
      
      private var mMyDestinationsListReset:Boolean = false;
      
      private var mFavoriteDestinationsListReset:Boolean = false;
      
      private var mFavoriteDestinationsListShowAddButton:Boolean = false;
      
      private var mFavoriteDestinationsDestinationMode:int = -1;
      
      private var mFavoriteDestinationsData:Object = new Object();
      
      private var mMapAppearanceListReset:Boolean = false;
      
      private var mRouteAvoidanceListReset:Boolean = false;
      
      private var mRouteAvoidInRouteListReset:Boolean = false;
      
      private var mWhereAmIGPSReset:Boolean = false;
      
      private var mEmergencyLocationPopupShow:Boolean = false;
      
      private var mConfirmDestinationReorderInfoIndex:int = 0;
      
      private var mConfirmDestinationDestinationInfoIndex:int = 0;
      
      private var mNavListDestinationsOrderReorderDestinationsAvoid:Boolean = false;
      
      private var mNavListDestinationsOrderReorderDestinations:Array = new Array();
      
      private var mNavMapScrollingEntryCondition:int = 0;
      
      private var mNavMapScrollingEntryCoordinate_X:int = -1;
      
      private var mNavMapScrollingEntryCoordinate_Y:int = -1;
      
      private var mNavMapScrollingLastCenteredPosition:LocationDescription = new LocationDescription();
      
      private var mShowTurnRouteInfo:Array = new Array();
      
      private var mTripsAllTripsListReset:Boolean = false;
      
      private var mTripsDestinationsListReset:Boolean = false;
      
      private var mPoiSearchPopupComposition:Array = new Array();
      
      private var mEmergencyConfirmed:Boolean = false;
      
      private var mNavListDestinationPreOrderPage:int = 1;
      
      private var mNavListDestinationPreOrderPosition:int = 1;
      
      private var mAddContactToFavoriteDestinationsPhoneNumber:String = "";
      
      private var mAddContactToFavoriteDestinationsName:String = "";
      
      private var mTmcEventListIndex:int = -1;
      
      private var mTmcEventEventID:int = -1;
      
      private var mTmcExternalEntry:Boolean = false;
      
      private var mTmcEventListTypeInZoomList:int = -1;
      
      private var mTrailRenameIndex:int = -1;
      
      private var mEasterEggPidinMemCounter:int = 0;
      
      private var mTmcByMapInfo:String = "";
      
      private var mNavReadyActivationCodePrefill:Boolean = false;
      
      private var mNavWhereToExtensionListPosition:Object = new Object();
      
      private var mNavDemoModePositionRenameSource:String = "";
      
      private var mPleaseWaitPopupTimer:Timer = null;
      
      public function VServiceScreenHelper()
      {
         super();
      }
      
      public function resetMyDestinationsWindowIndex() : void
      {
         this.mMyDestinationsListReset = true;
      }
      
      public function get myDestinationsWindowIndexReset() : Boolean
      {
         if(this.mMyDestinationsListReset)
         {
            this.mMyDestinationsListReset = false;
            return true;
         }
         return this.mMyDestinationsListReset;
      }
      
      public function resetFavoriteDestinationsListResetIndex() : void
      {
         this.mMyDestinationsListReset = true;
      }
      
      public function get favoriteDestinationsListReset() : Boolean
      {
         if(this.mFavoriteDestinationsListReset)
         {
            this.mFavoriteDestinationsListReset = false;
            return true;
         }
         return this.mFavoriteDestinationsListReset;
      }
      
      public function setFavoriteDestinationsListShowAddButton(show:Boolean) : void
      {
         this.mFavoriteDestinationsListShowAddButton = show;
      }
      
      public function get favoriteDestinationsListShowAddButton() : Boolean
      {
         return this.mFavoriteDestinationsListShowAddButton;
      }
      
      public function setFavoriteDestinationsDestinationMode(mode:int) : void
      {
         this.mFavoriteDestinationsDestinationMode = mode;
      }
      
      public function get favoriteDestinationsDestinationMode() : int
      {
         return this.mFavoriteDestinationsDestinationMode;
      }
      
      public function setFavoriteDestinationsListInfo(data:Object) : void
      {
         this.mFavoriteDestinationsData = data;
      }
      
      public function get FavoriteDestinationsListInfo() : Object
      {
         return this.mFavoriteDestinationsData;
      }
      
      public function resetMapAppearanceWindowIndex() : void
      {
         this.mMapAppearanceListReset = true;
      }
      
      public function get mapAppearanceWindowIndexReset() : Boolean
      {
         if(this.mMapAppearanceListReset)
         {
            this.mMapAppearanceListReset = false;
            return true;
         }
         return this.mMapAppearanceListReset;
      }
      
      public function resetRouteAvoidanceWindowIndex() : void
      {
         this.mRouteAvoidanceListReset = true;
      }
      
      public function get routeAvoidanceWindowIndexReset() : Boolean
      {
         if(this.mRouteAvoidanceListReset)
         {
            this.mRouteAvoidanceListReset = false;
            return true;
         }
         return this.mRouteAvoidanceListReset;
      }
      
      public function resetRouteAvoidInRouteListIndex() : void
      {
         this.mRouteAvoidInRouteListReset = true;
      }
      
      public function get routeAvoidInRouteWindowIndexReset() : Boolean
      {
         if(this.mRouteAvoidInRouteListReset)
         {
            this.mRouteAvoidInRouteListReset = false;
            return true;
         }
         return this.mRouteAvoidInRouteListReset;
      }
      
      public function resetWhereAmIGPSPopup() : void
      {
         this.mWhereAmIGPSReset = true;
      }
      
      public function get whereAmIGPSPopupReset() : Boolean
      {
         if(this.mWhereAmIGPSReset)
         {
            this.mWhereAmIGPSReset = false;
            return true;
         }
         return this.mWhereAmIGPSReset;
      }
      
      public function showEmergencyGPSPopup(show:Boolean) : void
      {
         this.mEmergencyLocationPopupShow = show;
      }
      
      public function get emergencyGPSPopupsShow() : Boolean
      {
         return this.mEmergencyLocationPopupShow;
      }
      
      public function setConfirmDestinationReorderInfoIndex(index:int) : void
      {
         this.mConfirmDestinationReorderInfoIndex = index;
      }
      
      public function get confirmDestinationReorderInfoIndex() : int
      {
         return this.mConfirmDestinationReorderInfoIndex;
      }
      
      public function setConfirmDestinationDestinationInfoIndex(index:int) : void
      {
         this.mConfirmDestinationDestinationInfoIndex = index;
      }
      
      public function get confirmDestinationDestinationInfoIndex() : int
      {
         return this.mConfirmDestinationDestinationInfoIndex;
      }
      
      public function setNavListDestinationsOrderReorderDestinationsAvoid() : void
      {
         this.mNavListDestinationsOrderReorderDestinationsAvoid = true;
      }
      
      public function get navListDestinationsOrderReorderDestinationsAvoid() : Boolean
      {
         if(this.mNavListDestinationsOrderReorderDestinationsAvoid)
         {
            this.mNavListDestinationsOrderReorderDestinationsAvoid = false;
            return true;
         }
         return this.mNavListDestinationsOrderReorderDestinationsAvoid;
      }
      
      public function setNavListDestinationsOrderReorderDestinations(destinations:Array) : void
      {
         this.mNavListDestinationsOrderReorderDestinations = destinations;
      }
      
      public function get navListDestinationsOrderReorderDestinations() : Array
      {
         return this.mNavListDestinationsOrderReorderDestinations;
      }
      
      public function setMapScrollingEntryCondition(entryCondition:int) : void
      {
         this.mNavMapScrollingEntryCondition = entryCondition;
      }
      
      public function get mapScrollingEntryCondition() : int
      {
         return this.mNavMapScrollingEntryCondition;
      }
      
      public function setMapScrollingEntryCoordinate(x:int, y:int) : void
      {
         this.mNavMapScrollingEntryCoordinate_X = x;
         this.mNavMapScrollingEntryCoordinate_Y = y;
      }
      
      public function get mapScrollingEntryCoordinate_X() : int
      {
         return this.mNavMapScrollingEntryCoordinate_X;
      }
      
      public function get mapScrollingEntryCoordinate_Y() : int
      {
         return this.mNavMapScrollingEntryCoordinate_Y;
      }
      
      public function set mapScrollingLastCenteredPosition(loc:LocationDescription) : void
      {
         this.mapScrollingLastCenteredPosition = loc;
      }
      
      public function get mapScrollingLastCenteredPosition() : LocationDescription
      {
         return this.mNavMapScrollingLastCenteredPosition;
      }
      
      public function setShowTurnScreenRouteInfo(handle:int, segment:int) : void
      {
         this.mShowTurnRouteInfo[0] = handle;
         this.mShowTurnRouteInfo[1] = segment;
      }
      
      public function get showTurnRouteInfo() : Array
      {
         return this.mShowTurnRouteInfo;
      }
      
      public function resetTripsAllTripsWindowIndex() : void
      {
         this.mTripsAllTripsListReset = true;
      }
      
      public function get tripsAllTripsWindowIndexReset() : Boolean
      {
         if(this.mTripsAllTripsListReset)
         {
            this.mTripsAllTripsListReset = false;
            return true;
         }
         return this.mTripsAllTripsListReset;
      }
      
      public function resetTripsDestinationsWindowIndex() : void
      {
         this.mTripsDestinationsListReset = true;
      }
      
      public function get tripsDestinationsWindowIndexReset() : Boolean
      {
         if(this.mTripsDestinationsListReset)
         {
            this.mTripsDestinationsListReset = false;
            return true;
         }
         return this.mTripsDestinationsListReset;
      }
      
      public function set poiSearchPopupText(composition:Array) : void
      {
         this.mPoiSearchPopupComposition = composition.slice(0,composition.length);
      }
      
      public function get poiSearchPopupText() : Array
      {
         return this.mPoiSearchPopupComposition;
      }
      
      public function setEmergencyScreenPopupConfirmed() : void
      {
         this.mEmergencyConfirmed = true;
      }
      
      public function get emergencyScreenPopupConfirmed() : Boolean
      {
         return this.mEmergencyConfirmed;
      }
      
      public function setDestinationPreOrderPage(index:int) : void
      {
         this.mNavListDestinationPreOrderPage = index;
      }
      
      public function get destinationPreOrderPage() : int
      {
         return this.mNavListDestinationPreOrderPage;
      }
      
      public function setDestinationPreOrderPosition(index:int) : void
      {
         this.mNavListDestinationPreOrderPosition = index;
      }
      
      public function get destinationPreOrderPosition() : int
      {
         return this.mNavListDestinationPreOrderPosition;
      }
      
      public function setAddContactToFavoriteDestinationsPhoneNumber(phoneNumber:String) : void
      {
         this.mAddContactToFavoriteDestinationsPhoneNumber = phoneNumber;
      }
      
      public function get addContactToFavoriteDestinationsPhoneNumber() : String
      {
         return this.mAddContactToFavoriteDestinationsPhoneNumber;
      }
      
      public function setAddContactToFavoriteDestinationsName(name:String) : void
      {
         this.mAddContactToFavoriteDestinationsName = name;
      }
      
      public function get addContactToFavoriteDestinationsName() : String
      {
         return this.mAddContactToFavoriteDestinationsName;
      }
      
      public function setTmcEventListIndex(index:int) : void
      {
         this.mTmcEventListIndex = index;
      }
      
      public function get TmcEventListIndex() : int
      {
         return this.mTmcEventListIndex;
      }
      
      public function setTmcEventEventID(eventID:int) : void
      {
         this.mTmcEventEventID = eventID;
      }
      
      public function get TmcEventEventID() : int
      {
         return this.mTmcEventEventID;
      }
      
      public function setTmcExternalEntry(fromExternal:Boolean) : void
      {
         this.mTmcExternalEntry = fromExternal;
      }
      
      public function get TmcExternalEntry() : Boolean
      {
         return this.mTmcExternalEntry;
      }
      
      public function setTmcEventListTypeInZoomList(type:int) : void
      {
         this.mTmcEventListTypeInZoomList = type;
      }
      
      public function get tmcEventListTypeInZoomList() : int
      {
         return this.mTmcEventListTypeInZoomList;
      }
      
      public function setTrailRenameIndex(index:int) : void
      {
         this.mTrailRenameIndex = index;
      }
      
      public function get TrailRenameIndex() : int
      {
         return this.mTrailRenameIndex;
      }
      
      public function raiseEasterEggPidinMemCounter() : void
      {
         this.mEasterEggPidinMemCounter += 1;
      }
      
      public function get EasterEggPidinMemCounter() : int
      {
         return this.mEasterEggPidinMemCounter;
      }
      
      public function setTmcByMapInfo(info:String) : void
      {
         this.mTmcByMapInfo = info;
      }
      
      public function setVICSParkingByMapInfo(info:String) : void
      {
      }
      
      public function get tmcByMapInfo() : String
      {
         return this.mTmcByMapInfo;
      }
      
      public function setNavReadyActivationCodePrefill(enable:Boolean) : void
      {
         this.mNavReadyActivationCodePrefill = enable;
      }
      
      public function get navReadyActivationCodePrefill() : Boolean
      {
         return this.mNavReadyActivationCodePrefill;
      }
      
      public function getNavWhereToExtensionListPosition(menuID:int) : int
      {
         if(this.mNavWhereToExtensionListPosition[menuID] != null)
         {
            return int(this.mNavWhereToExtensionListPosition[menuID]);
         }
         return 0;
      }
      
      public function setNavWhereToExtensionListPosition(menuID:int, position:int) : void
      {
         this.mNavWhereToExtensionListPosition[menuID] = position;
      }
      
      public function setNavDemoModePositionRenameSource(coordinate:String) : void
      {
         this.mNavDemoModePositionRenameSource = coordinate;
      }
      
      public function get navDemoModePositionRenameSource() : String
      {
         return this.mNavDemoModePositionRenameSource;
      }
      
      public function pleaseWaitPopupShow(timeOut:int) : void
      {
         if(timeOut > 0)
         {
            if(!Framework.popupManager.check(NavigationPackage.dynamicPopupNames.PLEASE_WAIT))
            {
               Framework.popupManager.show(NavigationPackage.dynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
            }
            this.createPleaseWaitTimer(timeOut);
         }
      }
      
      public function pleaseWaitPopupHide() : void
      {
         if(this.mPleaseWaitPopupTimer != null)
         {
            this.mPleaseWaitPopupTimer.stop();
            this.disablePleaseWaitPopup();
         }
      }
      
      private function onPleaseWaitPopupTimer(e:TimerEvent) : void
      {
         this.disablePleaseWaitPopup();
      }
      
      private function disablePleaseWaitPopup() : void
      {
         if(Framework.popupManager.check(NavigationPackage.dynamicPopupNames.PLEASE_WAIT))
         {
            Framework.popupManager.dequeue(NavigationPackage.dynamicPopupNames.PLEASE_WAIT);
         }
      }
      
      private function createPleaseWaitTimer(timeOut:int) : void
      {
         if(this.mPleaseWaitPopupTimer != null)
         {
            this.mPleaseWaitPopupTimer.removeEventListener(TimerEvent.TIMER,this.onPleaseWaitPopupTimer);
            this.mPleaseWaitPopupTimer = null;
         }
         this.mPleaseWaitPopupTimer = new Timer(timeOut,1);
         this.mPleaseWaitPopupTimer.addEventListener(TimerEvent.TIMER,this.onPleaseWaitPopupTimer,false,0,true);
         this.mPleaseWaitPopupTimer.start();
      }
   }
}

