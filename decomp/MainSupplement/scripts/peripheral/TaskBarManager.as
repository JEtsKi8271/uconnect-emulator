package peripheral
{
   import apps.AppAppManager;
   import apps.AppApps;
   import apps.AppBackupCam;
   import apps.AppCargoCam;
   import apps.AppClimate;
   import apps.AppControls;
   import apps.AppDriveModes;
   import apps.AppDriverHeatedSeat;
   import apps.AppDriverVentedSeat;
   import apps.AppECO;
   import apps.AppFrontSideCamera;
   import apps.AppHeadrestFold;
   import apps.AppHeatedSteeringWheel;
   import apps.AppHybridElectricPages;
   import apps.AppKeySense;
   import apps.AppMedia;
   import apps.AppMirrorDimmer;
   import apps.AppNavigation;
   import apps.AppPassHeatedSeat;
   import apps.AppPassVentedSeat;
   import apps.AppPhone;
   import apps.AppRadio;
   import apps.AppRearMedia;
   import apps.AppRearSunshade;
   import apps.AppScreenOff;
   import apps.AppSettings;
   import apps.AppSurroundView;
   import apps.AppTravelLink;
   import apps.AppWiFiHotspot;
   import apps.AppXlet;
   import apps.IApp;
   import apps.ID;
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.Applet;
   import com.harman.moduleLinkAPI.DriverABEvent;
   import com.harman.moduleLinkAPI.PersistencyEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.LoadBMP;
   import events.StartupEvent;
   import events.TaskBarManagerEvent;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class TaskBarManager extends EventDispatcher
   {
      
      private const TRAY_MAX:int = 6;
      
      private const TRAY_MIN:int = 1;
      
      private var TRAY_DRIVER_A:Dictionary = new Dictionary();
      
      private var TRAY_DRIVER_B:Dictionary = new Dictionary();
      
      private var FEATURES:Dictionary = new Dictionary();
      
      private var IGNORE:Dictionary = new Dictionary();
      
      private var mFeatures:Array = new Array();
      
      private var mXlets:Array = new Array();
      
      private var mAll:Array = new Array();
      
      private var mBMPLoader:LoadBMP = new LoadBMP();
      
      private var mDisclaimerReady:Boolean = false;
      
      private var mPersistenceReady:Boolean = false;
      
      private var mXletsPath:String = "";
      
      public function TaskBarManager()
      {
         super();
      }
      
      public function init() : void
      {
         var appApps:AppApps = new AppApps();
         this.TRAY_DRIVER_A[0] = appApps;
         this.TRAY_DRIVER_B[0] = appApps;
         Framework.messenger.addEventListener(StartupEvent.ACCEPT,this.onAccept,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.APPLIST,this.onAppList,false,0,true);
         Peripheral.appManager.addEventListener(AppManagerEvent.GET_XLETS_DIR,this.onXletDirectory,false,0,true);
         Peripheral.driverAB.addEventListener(DriverABEvent.SAVE,this.onDriverABSave,false,0,true);
         Peripheral.driverAB.addEventListener(DriverABEvent.RECALL,this.onDriverABRecall,false,0,true);
         Peripheral.persistency.addEventListener(PersistencyKeys.KEY_TASKBAR,this.onPersistency,false,0,true);
         Peripheral.persistency.addEventListener(PersistencyKeys.KEY_XLET_DIR,this.onXletPersistency,false,0,true);
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavigationOperable,false,1000,true);
         this.FEATURES[ID.APPMANAGER] = new AppAppManager();
         this.FEATURES[ID.BACKUPCAM] = new AppBackupCam();
         this.FEATURES[ID.CARGOCAM] = new AppCargoCam();
         this.FEATURES[ID.CLIMATE] = new AppClimate();
         this.FEATURES[ID.CONTROLS] = new AppControls();
         this.FEATURES[ID.DRIVEMODES] = new AppDriveModes();
         this.FEATURES[ID.DRIVERHEATEDSEAT] = new AppDriverHeatedSeat();
         this.FEATURES[ID.DRIVERVENTEDSEAT] = new AppDriverVentedSeat();
         this.FEATURES[ID.ECO] = new AppECO();
         this.FEATURES[ID.FRONTSIDECAMERA] = new AppFrontSideCamera();
         this.FEATURES[ID.HEADRESTFOLD] = new AppHeadrestFold();
         this.FEATURES[ID.HEATEDSTEERINGWHEEL] = new AppHeatedSteeringWheel();
         this.FEATURES[ID.HYBRIDELECTRICPAGES] = new AppHybridElectricPages();
         this.FEATURES[ID.KEYSENSE] = new AppKeySense();
         this.FEATURES[ID.MEDIA] = new AppMedia();
         this.FEATURES[ID.MIRROR_DIMMER] = new AppMirrorDimmer();
         this.FEATURES[ID.NAVIGATION] = new AppNavigation();
         this.FEATURES[ID.PASSHEATEDSEAT] = new AppPassHeatedSeat();
         this.FEATURES[ID.PASSVENTEDSEAT] = new AppPassVentedSeat();
         this.FEATURES[ID.PHONE] = new AppPhone();
         this.FEATURES[ID.RADIO] = new AppRadio();
         this.FEATURES[ID.REARMEDIA] = new AppRearMedia();
         this.FEATURES[ID.REARSUNSHADE] = new AppRearSunshade();
         this.FEATURES[ID.SCREENOFF] = new AppScreenOff();
         this.FEATURES[ID.SETTINGS] = new AppSettings();
         this.FEATURES[ID.SURROUNDVIEW] = new AppSurroundView();
         this.FEATURES[ID.TRAVELLINK] = new AppTravelLink();
         this.FEATURES[ID.WIFIHOTSPOT] = new AppWiFiHotspot();
         this.IGNORE["Drive Modes"] = true;
         this.IGNORE["engineering"] = true;
         this.IGNORE["HybridElectricPages"] = true;
         this.IGNORE["keysense"] = true;
         this.IGNORE["rearmedia"] = true;
         this.IGNORE["settings"] = true;
         this.IGNORE["travellink"] = true;
         this.IGNORE["WIFIAP"] = true;
         this.IGNORE["uconntheater"] = true;
         this.populateVehicleFeatures();
         this.populateXlets();
         Peripheral.persistency.read(PersistencyKeys.KEY_XLET_DIR);
         Peripheral.persistency.read(PersistencyKeys.KEY_TASKBAR);
      }
      
      public function xletImage(_request:String, _window:MovieClip) : void
      {
         this.mBMPLoader.addImage(_request,_window);
      }
      
      public function get ready() : Boolean
      {
         return this.mDisclaimerReady && this.mPersistenceReady;
      }
      
      public function get tray() : Dictionary
      {
         if(Peripheral.driverAB.driver == 1)
         {
            return this.TRAY_DRIVER_A;
         }
         return this.TRAY_DRIVER_B;
      }
      
      public function get all() : Array
      {
         return this.mAll;
      }
      
      public function get xletDir() : String
      {
         return this.mXletsPath;
      }
      
      private function onAppList(e:AppManagerEvent) : void
      {
         this.populateXlets();
      }
      
      private function onXletDirectory(e:AppManagerEvent) : void
      {
         Peripheral.appManager.removeEventListener(AppManagerEvent.GET_XLETS_DIR,this.onXletDirectory);
         Peripheral.persistency.write(PersistencyKeys.KEY_XLET_DIR,{"XletDir":Peripheral.appManager.getXletsDir()});
      }
      
      private function populateVehicleFeatures() : void
      {
         this.mFeatures.push(this.FEATURES[ID.CLIMATE]);
         this.mFeatures.push(this.FEATURES[ID.MEDIA]);
         this.mFeatures.push(this.FEATURES[ID.PHONE]);
         this.mFeatures.push(this.FEATURES[ID.RADIO]);
         this.mFeatures.push(this.FEATURES[ID.SETTINGS]);
         if(Peripheral.appManager.getAppsExist() == "true")
         {
            this.mFeatures.push(this.FEATURES[ID.APPMANAGER]);
         }
         if(Peripheral.vehConfig.hasRVCMPresent && (!Peripheral.vehConfig.hasSurroundCamera && !Peripheral.vehConfig.hasSVCSoftKey) && (Peripheral.vehConfig.modelYear == "16" && Peripheral.vehConfig.isTruckPlatform || Peripheral.vehConfig.hasRVCSoftKey && int(Peripheral.vehConfig.modelYear) >= 17 && Peripheral.vehConfig.vehicleLine != "RU"))
         {
            this.mFeatures.push(this.FEATURES[ID.BACKUPCAM]);
         }
         if(Peripheral.vehConfig.hasCargoCamera && (!Peripheral.vehConfig.hasSurroundCamera && !Peripheral.vehConfig.hasSVCSoftKey))
         {
            this.mFeatures.push(this.FEATURES[ID.CARGOCAM]);
         }
         if(Peripheral.controlsPopupManager.hasControls)
         {
            this.mFeatures.push(this.FEATURES[ID.CONTROLS]);
         }
         if(Peripheral.driveModeManager.hasDriveMode)
         {
            this.mFeatures.push(this.FEATURES[ID.DRIVEMODES]);
         }
         if(Peripheral.vehConfig.hasHeatedSeat)
         {
            this.mFeatures.push(this.FEATURES[ID.DRIVERHEATEDSEAT]);
         }
         if(Peripheral.vehConfig.hasVentedSeat)
         {
            this.mFeatures.push(this.FEATURES[ID.DRIVERVENTEDSEAT]);
         }
         if(Peripheral.vehConfig.hasEcoAppBtn)
         {
            this.mFeatures.push(this.FEATURES[ID.ECO]);
         }
         if(Peripheral.vehConfig.hasFrontCamera || Peripheral.vehConfig.hasSideCamera)
         {
            this.mFeatures.push(this.FEATURES[ID.FRONTSIDECAMERA]);
         }
         if(Peripheral.vehConfig.hasHeadRest)
         {
            this.mFeatures.push(this.FEATURES[ID.HEADRESTFOLD]);
         }
         if(Peripheral.vehConfig.hasHeatedSteeringWheel)
         {
            this.mFeatures.push(this.FEATURES[ID.HEATEDSTEERINGWHEEL]);
         }
         if(Peripheral.vehConfig.hasHybridControlModule && Peripheral.vehConfig.vehicleLine == "RU")
         {
            this.mFeatures.push(this.FEATURES[ID.HYBRIDELECTRICPAGES]);
         }
         if(Peripheral.vehConfig.hasTeenKeyFeature && (Peripheral.vehConfig.hasTKFCWSensitivity || Peripheral.vehConfig.hasTKFCWBraking || Peripheral.vehConfig.hasTKParkAssist || Peripheral.vehConfig.hasTKParkAssistBraking || Peripheral.vehConfig.hasTKParkAssistFTvol || Peripheral.vehConfig.hasTKParkAssistRRvol || Peripheral.vehConfig.hasTKBlindSpot || Peripheral.vehConfig.hasTKFuelPopup || Peripheral.vehConfig.hasTKEarlyFuelWarning || Peripheral.vehConfig.hasTKAutoWipers || Peripheral.vehConfig.hasTKHLsWithWipers || Peripheral.vehConfig.hasTKAutoHighBeams || Peripheral.vehConfig.hasTKMaxSpeedLimit))
         {
            this.mFeatures.push(this.FEATURES[ID.KEYSENSE]);
         }
         if(Peripheral.vehConfig.hasECMirror && !Peripheral.vehConfig.hasECMirrorHKPresent)
         {
            this.mFeatures.push(this.FEATURES[ID.MIRROR_DIMMER]);
         }
         if(Global.navActivated)
         {
            this.mFeatures.push(this.FEATURES[ID.NAVIGATION]);
         }
         if(Peripheral.vehConfig.hasHeatedSeat)
         {
            this.mFeatures.push(this.FEATURES[ID.PASSHEATEDSEAT]);
         }
         if(Peripheral.vehConfig.hasVentedSeat)
         {
            this.mFeatures.push(this.FEATURES[ID.PASSVENTEDSEAT]);
         }
         if(Peripheral.vehConfig.hasRearMedia)
         {
            this.mFeatures.push(this.FEATURES[ID.REARMEDIA]);
         }
         if(Peripheral.vehConfig.hasSunShade)
         {
            this.mFeatures.push(this.FEATURES[ID.REARSUNSHADE]);
         }
         if(Peripheral.travelLink.isAvailable)
         {
            this.mFeatures.push(this.FEATURES[ID.TRAVELLINK]);
         }
         this.mFeatures.push(this.FEATURES[ID.SCREENOFF]);
         if(Peripheral.vehConfig.hasSurroundCamera && Peripheral.vehConfig.hasSVCSoftKey)
         {
            this.mFeatures.push(this.FEATURES[ID.SURROUNDVIEW]);
         }
         if(Peripheral.versionInfo.productVariantID.VARIANT_ECELL == "YES")
         {
            this.mFeatures.push(this.FEATURES[ID.WIFIHOTSPOT]);
         }
      }
      
      private function onNavigationOperable(e:NavDomainControllerEvent) : void
      {
         if(Peripheral.navigation.navDomainControl.navIsOperable)
         {
            if(!Global.navActivated)
            {
               this.mFeatures.push(this.FEATURES[ID.NAVIGATION]);
               this.sortFeatures();
            }
         }
      }
      
      private function populateXlets() : void
      {
         var _result:int = 0;
         var xlet:AppXlet = null;
         var _xlets:Array = Peripheral.appManager.getAllApplications().slice(0,Peripheral.appManager.getAllApplications().length);
         for(var i:int = 0; i < this.mXlets.length; i++)
         {
            _result = this.checkForAppID(this.mXlets[i].id,_xlets);
            if(_result == -1)
            {
               this.mXlets.splice(i,1);
            }
            else
            {
               this.mXlets[i].label = _xlets[0].mediumNameString;
               this.mXlets[i].labelShort = _xlets[_result].shortNameString;
               this.mXlets[i].labelMedium = _xlets[_result].mediumNameString;
               _xlets.splice(_result,1);
            }
         }
         while(_xlets.length > 0)
         {
            if(this.IGNORE[Applet(_xlets[0]).appId] == null)
            {
               if(this.FEATURES[Applet(_xlets[0]).appId] != null)
               {
                  this.mXlets.push(this.FEATURES[_xlets[0].appId]);
               }
               else
               {
                  xlet = new AppXlet();
                  xlet.id = _xlets[0].appId;
                  xlet.label = _xlets[0].mediumNameString;
                  xlet.labelShort = _xlets[0].shortNameString;
                  xlet.labelMedium = _xlets[0].mediumNameString;
                  this.mXlets.push(xlet);
               }
               _xlets.shift();
            }
            else
            {
               _xlets.shift();
            }
         }
         _xlets = null;
         this.sortFeatures();
      }
      
      public function checkForAppID(_id:String, _xlets:Array) : int
      {
         for(var i:int = 0; i < _xlets.length; i++)
         {
            if(_xlets[i].appId == _id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function sortFeatures() : void
      {
         this.mAll = null;
         this.mAll = new Array();
         this.mAll = this.mAll.concat(this.mFeatures,this.mXlets);
         this.mAll.sortOn("label",Array.CASEINSENSITIVE);
         this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.UPDATE));
      }
      
      public function saveTaskBar() : void
      {
         var _taskBar:Object = new Object();
         _taskBar.driverA = this.createPersistencyDriverObject(this.TRAY_DRIVER_A);
         _taskBar.driverB = this.createPersistencyDriverObject(this.TRAY_DRIVER_B);
         Peripheral.persistency.write(PersistencyKeys.KEY_TASKBAR,_taskBar);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
      }
      
      private function createPersistencyDriverObject(_driver:Dictionary) : Object
      {
         var shortcut:Object = null;
         var driver:Object = new Object();
         for(var i:int = this.TRAY_MIN; i <= this.TRAY_MAX; i++)
         {
            shortcut = new Object();
            shortcut.id = _driver[i].id;
            shortcut.label = _driver[i].embedded ? _driver[i].labelShort : _driver[i].label;
            driver["slot" + i] = shortcut;
         }
         return driver;
      }
      
      private function onRetError() : void
      {
         this.TRAY_DRIVER_A[1] = new AppRadio();
         this.TRAY_DRIVER_A[2] = new AppMedia();
         this.TRAY_DRIVER_A[3] = Peripheral.controlsPopupManager.hasControls ? new AppControls() : new AppSettings();
         this.TRAY_DRIVER_A[4] = new AppClimate();
         this.TRAY_DRIVER_A[5] = Global.navActivated ? new AppNavigation() : new AppScreenOff();
         this.TRAY_DRIVER_A[6] = new AppPhone();
         this.TRAY_DRIVER_B[1] = new AppRadio();
         this.TRAY_DRIVER_B[2] = new AppMedia();
         this.TRAY_DRIVER_B[3] = Peripheral.controlsPopupManager.hasControls ? new AppControls() : new AppSettings();
         this.TRAY_DRIVER_B[4] = new AppClimate();
         this.TRAY_DRIVER_B[5] = Global.navActivated ? new AppNavigation() : new AppScreenOff();
         this.TRAY_DRIVER_B[6] = new AppPhone();
         this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.PERSISTENCY));
         this.mPersistenceReady = true;
         if(this.ready)
         {
            this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.READY));
         }
      }
      
      private function onDriverABSave(e:DriverABEvent) : void
      {
         this.saveTaskBar();
      }
      
      private function onDriverABRecall(e:DriverABEvent) : void
      {
         this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.PERSISTENCY));
      }
      
      private function onPersistency(e:PersistencyEvent) : void
      {
         var persistence:Object = e.value;
         if(persistence.hasOwnProperty("err"))
         {
            this.onRetError();
            return;
         }
         try
         {
            this.cacheDriver(this.TRAY_DRIVER_A,persistence.driverA);
            this.cacheDriver(this.TRAY_DRIVER_B,persistence.driverB);
         }
         catch(ex:Error)
         {
            onRetError();
            return;
         }
         this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.PERSISTENCY));
         this.mPersistenceReady = true;
         if(this.ready)
         {
            this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.READY));
         }
      }
      
      private function onXletPersistency(e:PersistencyEvent) : void
      {
         if(e.value.hasOwnProperty("err"))
         {
            return;
         }
         this.mXletsPath = e.value.XletDir;
      }
      
      private function cacheDriver(_driver:Dictionary, _persistence:Object) : void
      {
         var xlet:AppXlet = null;
         for(var i:int = this.TRAY_MIN; i <= this.TRAY_MAX; i++)
         {
            if(this.FEATURES[_persistence["slot" + i].id] != null)
            {
               _driver[i] = this.FEATURES[_persistence["slot" + i].id].cp;
            }
            else
            {
               xlet = new AppXlet();
               xlet.id = _persistence["slot" + i].id;
               xlet.labelShort = _persistence["slot" + i].label;
               _driver[i] = xlet;
            }
         }
      }
      
      private function onAccept(e:StartupEvent) : void
      {
         this.mDisclaimerReady = true;
         if(this.ready)
         {
            this.dispatchEvent(new TaskBarManagerEvent(TaskBarManagerEvent.READY));
         }
      }
      
      public function isFavorite(id:String) : Boolean
      {
         var app:IApp = null;
         for each(app in this.tray)
         {
            if(app.id == id)
            {
               return true;
            }
         }
         return false;
      }
   }
}

