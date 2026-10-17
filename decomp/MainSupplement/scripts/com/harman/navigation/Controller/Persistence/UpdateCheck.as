package com.harman.navigation.Controller.Persistence
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestinationsEvent;
   import com.harman.navigation.Controller.RecentDestinations.RecentDestinationsEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class UpdateCheck
   {
      
      private var mPersistence:PersistenceController;
      
      private var mDBPersistenceVersion:String = "";
      
      private var mNaviServerPersistanceVersion:String = "";
      
      private var mPersistenceLoaded:Boolean = false;
      
      private var mSavedDestinationsReadyTimer:Timer;
      
      private var mCurrentDBVersion:String = "";
      
      private var mCurrentNaviServerVersion:String = "";
      
      private var mNaviServerLoaded:Boolean = false;
      
      private var mUpdateCheckInterval:uint = 0;
      
      public function UpdateCheck(persistence:PersistenceController)
      {
         super();
         this.mSavedDestinationsReadyTimer = new Timer(5000,0);
         this.mSavedDestinationsReadyTimer.addEventListener(TimerEvent.TIMER,this.updateStoredNavigationEntries,false,0,true);
         this.mPersistence = persistence;
         this.mPersistence.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistenceEvent,false,0,true);
         this.mPersistence.loadData(PersistenceKeys.DATABASE_VERSION);
         this.mUpdateCheckInterval = setInterval(this.onVersionRequestExpired,NavGlobalSettings.DATABASE_UPDATE_CHECK_TIMEOUT);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.navGetIsReady();
      }
      
      public function onNavStartupState(e:NavigationEvent) : void
      {
         if(NavigationApi.api.navStartupState >= StartupState.CONNECTED)
         {
            NavigationApi.api.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState);
            NavigationApi.api.addEventListener(NavigationEvent.NAV_VERSIONS,this.onNaviServerEvent,false,0,true);
            NavigationApi.api.navGetNavVersions();
         }
      }
      
      private function onVersionRequestExpired() : void
      {
         Framework.Trace("UpdateCheck.onVersionRequestExpired()");
         this.mPersistence.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistenceEvent);
         clearInterval(this.mUpdateCheckInterval);
         this.mPersistenceLoaded = true;
         this.compareVersions();
      }
      
      private function onNaviServerEvent(e:NavigationEvent) : void
      {
         this.mCurrentDBVersion = String(NavigationApi.api.navVersions.ETC_DatabaseVersion);
         this.mCurrentNaviServerVersion = String(NavigationApi.api.navVersions.ETC_SoftwareVersion);
         if(this.mCurrentDBVersion != "" && this.mCurrentNaviServerVersion != "")
         {
            this.mNaviServerLoaded = true;
            Framework.Trace("UpdateCheck.onNaviServerEvent( " + this.mCurrentDBVersion + " )");
            if(this.mPersistenceLoaded == true)
            {
               this.compareVersions();
            }
         }
         else
         {
            Framework.Trace("UpdateCheck NaviServerVersion is empty -> retry");
            NavigationApi.api.navGetNavVersions();
         }
      }
      
      private function onPersistenceEvent(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var i:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.DATABASE_VERSION)
         {
            clearInterval(this.mUpdateCheckInterval);
            this.mPersistenceLoaded = true;
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.DATABASE_VERSION,true);
            if(res != null)
            {
               for(i in res)
               {
                  if(i == "DB")
                  {
                     this.mDBPersistenceVersion = res[i];
                  }
                  if(i == "NavServ")
                  {
                     this.mNaviServerPersistanceVersion = res[i];
                  }
               }
               Framework.Trace("UpdateCheck.onPersistenceEvent( " + this.mDBPersistenceVersion + ", " + this.mNaviServerPersistanceVersion + " )");
               if(this.mNaviServerLoaded == true)
               {
                  this.compareVersions();
               }
            }
         }
      }
      
      private function compareVersions() : void
      {
         if(this.mDBPersistenceVersion == this.mCurrentDBVersion && this.mNaviServerPersistanceVersion == this.mCurrentNaviServerVersion)
         {
            Framework.Trace("Nav.Database.UpdateCheck: Pers:\'" + this.mDBPersistenceVersion + "\' Curr:\'" + this.mCurrentDBVersion + "\' -> ok");
            Framework.Trace("Nav.Database.UpdateCheck: Pers:\'" + this.mNaviServerPersistanceVersion + "\' Curr:\'" + this.mCurrentNaviServerVersion + "\' -> ok");
            this.mPersistence.indicateNoDatabaseUpdate();
         }
         else
         {
            Framework.Trace("Nav.Database.UpdateCheck: Pers:\'" + this.mDBPersistenceVersion + "\' Curr:\'" + this.mCurrentDBVersion + "\' -> erase");
            Framework.Trace("Nav.Database.UpdateCheck: Pers:\'" + this.mNaviServerPersistanceVersion + "\' Curr:\'" + this.mCurrentNaviServerVersion + "\' -> erase");
            this.mPersistence.indicateDatabaseUpdate();
            this.updateStoredNavigationEntries(undefined);
         }
         var obj:Object = new Object();
         obj["DB"] = this.mCurrentDBVersion;
         obj["NavServ"] = this.mCurrentNaviServerVersion;
         PersistenceApi.api.saveData(PersistenceKeys.DATABASE_VERSION,obj);
         NavigationApi.api.removeEventListener(NavigationEvent.NAV_VERSIONS,this.onNaviServerEvent);
         this.mPersistence.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistenceEvent);
      }
      
      private function updateStoredNavigationEntries(e:TimerEvent) : void
      {
         Framework.Trace("updateStoredNavigationEntries");
         Framework.Trace("NavigationPackage.peripheral.navigation.navFavoriteDestinations is null " + (NavigationPackage.peripheral.navigation.navFavoriteDestinations == null));
         if(NavigationPackage.peripheral.navigation.navFavoriteDestinations != null)
         {
            Framework.Trace("NavigationPackage.peripheral.navigation.navFavoriteDestinations.isReady() " + NavigationPackage.peripheral.navigation.navFavoriteDestinations.isReady());
         }
         Framework.Trace("NavigationPackage.peripheral.navigation.navFavoriteDestinations is null " + (NavigationPackage.peripheral.navigation.navRecentDestinations == null));
         if(NavigationPackage.peripheral.navigation.navRecentDestinations != null)
         {
            Framework.Trace("NavigationPackage.peripheral.navigation.navFavoriteDestinations.isReady() " + NavigationPackage.peripheral.navigation.navRecentDestinations.isReady());
         }
         if(Boolean(NavigationPackage.peripheral.navigation.navFavoriteDestinations != null && NavigationPackage.peripheral.navigation.navFavoriteDestinations.isReady()) && Boolean(NavigationPackage.peripheral.navigation.navRecentDestinations != null) && Boolean(NavigationPackage.peripheral.navigation.navRecentDestinations.isReady()))
         {
            this.mSavedDestinationsReadyTimer.stop();
            Framework.Trace("updatecheck starting to get lists");
            NavigationPackage.peripheral.navigation.navFavoriteDestinations.addEventListener(FavoriteDestinationsEvent.FD_LIST_UPDATE,this.onFavoritesListUpdate,false,0,true);
            NavigationPackage.peripheral.navigation.navFavoriteDestinations.getList();
            NavigationPackage.peripheral.navigation.navRecentDestinations.addEventListener(RecentDestinationsEvent.RD_DESTINATIONS_CHANGED,this.onRecentsListUpdate,false,0,true);
            NavigationPackage.peripheral.navigation.navRecentDestinations.getList();
         }
         else
         {
            this.mSavedDestinationsReadyTimer.start();
         }
      }
      
      private function onFavoritesListUpdate(e:FavoriteDestinationsEvent) : void
      {
         Framework.Trace("updatecheck onFavoritesListUpdate");
         NavigationPackage.peripheral.navigation.navFavoriteDestinations.removeEventListener(FavoriteDestinationsEvent.FD_LIST_UPDATE,this.onFavoritesListUpdate);
         Framework.Trace("updatecheck favorite list length = " + NavigationPackage.peripheral.navigation.navFavoriteDestinations.list.length);
         for(var i:int = 0; i < NavigationPackage.peripheral.navigation.navFavoriteDestinations.list.length; i++)
         {
            NavigationPackage.peripheral.navigation.navFavoriteDestinations.changeDestinationSecondaryLocation(i,this.removeDatabaseDependentFields(NavigationPackage.peripheral.navigation.navFavoriteDestinations.list[i].location.getSecondaryLocation()));
         }
      }
      
      private function onRecentsListUpdate(e:RecentDestinationsEvent) : void
      {
         Framework.Trace("updatecheck onRecentsListUpdate");
         NavigationPackage.peripheral.navigation.navRecentDestinations.removeEventListener(RecentDestinationsEvent.RD_DESTINATIONS_CHANGED,this.onRecentsListUpdate);
         Framework.Trace("updatecheck recent list length = " + NavigationPackage.peripheral.navigation.navRecentDestinations.list.length);
         for(var i:int = 0; i < NavigationPackage.peripheral.navigation.navRecentDestinations.list.length; i++)
         {
            NavigationPackage.peripheral.navigation.navRecentDestinations.changeDestinationSecondaryLocation(i,this.removeDatabaseDependentFields(NavigationPackage.peripheral.navigation.navRecentDestinations.list[i].location.getSecondaryLocation()));
         }
      }
      
      private function removeDatabaseDependentFields(loc:LocationDetails) : LocationDetails
      {
         var databaseDependentTags:Array = ["<POI_NNG>","<CAT_NNG>","<CTY_NNG>","<STA_NNG>","<ORD1_NNG>","<ORD2_NNG>","<ORD3_NNG>","<BLK_NNG>","<HNO_NNG>","<STR_NNG>","<ITR_NNG>","<ITRN_NNG>","<ITRL_NNG>","<CTR_NNG>","<HNO_NNG>"];
         for(var i:int = 0; i < databaseDependentTags.length; i++)
         {
            loc.eraseEisType(databaseDependentTags[i]);
         }
         return loc;
      }
   }
}

