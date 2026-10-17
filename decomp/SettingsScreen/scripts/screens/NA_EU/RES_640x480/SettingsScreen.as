package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import core.enums.Market;
   import core.enums.PopupType;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsScreen extends ScreenListComponent
   {
      
      private static const MASERATI_VEH_BRAND:String = "11";
      
      public function SettingsScreen()
      {
         Peripheral.rse.getAccessibilitySupportStatus();
         super();
      }
      
      override protected function addListeners() : void
      {
         Framework.popupManager.addEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick,false,0,true);
         super.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.TWOITEM_POPUP_LEFT_CLICK,this.onTwoItemPopupLeftClick);
         Peripheral.listController.bookmark = "SettingsScreen";
         super.removeListeners();
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Boolean(Peripheral.vehConfig.hasTeenKeyFeature) && (Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) || Boolean(Peripheral.vehConfig.hasTKFCWBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssist) || Boolean(Peripheral.vehConfig.hasTKParkAssistBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssistFTvol) || Boolean(Peripheral.vehConfig.hasTKParkAssistRRvol) || Boolean(Peripheral.vehConfig.hasTKBlindSpot) || Boolean(Peripheral.vehConfig.hasTKFuelPopup) || Boolean(Peripheral.vehConfig.hasTKEarlyFuelWarning) || Boolean(Peripheral.vehConfig.hasTKAutoWipers) || Boolean(Peripheral.vehConfig.hasTKHLsWithWipers) || Boolean(Peripheral.vehConfig.hasTKAutoHighBeams) || Boolean(Peripheral.vehConfig.hasTKMaxSpeedLimit)))
         {
            contents.push(T.STRB_KEYSENSE);
         }
         contents.push(T.STRB_DISPLAY_BREADCRUMB);
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Boolean(Peripheral.vehConfig.hasUnitSet))
         {
            contents.push(T.STRB_SETTINGS_UNITS);
         }
         else if(!Peripheral.vehConfig.hasUnitOption && (Boolean(Peripheral.vehConfig.speedUnitsPresent) || Boolean(Peripheral.vehConfig.capacityUnitsPresent) || Boolean(Peripheral.vehConfig.consumptionUnitsPresent) || Boolean(Peripheral.vehConfig.distanceUnitsPresent) || Boolean(Peripheral.vehConfig.powerUnitsPresent) || Boolean(Peripheral.vehConfig.pressureUnitsPresent) || Boolean(Peripheral.vehConfig.temperatureUnitsPresent) || Boolean(Peripheral.vehConfig.torqueUnitsPresent)))
         {
            contents.push(T.STRB_SETTINGS_UNITS);
         }
         contents.push(T.STRB_VOICE);
         contents.push(T.STRB_CLOCK_BREADCRUMB);
         if(Peripheral.vehConfig.ForwardCollisionWarning != "absent" || Boolean(Peripheral.vehConfig.hasForwardCollisionBraking) || Peripheral.vehConfig.laneSenseSensitivityType != "absent" || Peripheral.vehConfig.laneSenseTorqueType != "absent" || (Peripheral.vehConfig.parkAssist == "1option" || Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND && Peripheral.vehConfig.parkAssist == "3option") || Boolean(Peripheral.vehConfig.hasTiltMirrorInReverse) || Boolean(Peripheral.vehConfig.hasPwrFoldingMirrors) || Boolean(Peripheral.vehConfig.hasBlindSpotModule) || Peripheral.vehConfig.rearCameraGridlinesType != "absent" || Boolean(Peripheral.vehConfig.hasRearCameraDelay) || Peripheral.vehConfig.rainSensorType != "absent" || Boolean(Peripheral.vehConfig.hasDoorAlert) || Boolean(Peripheral.vehConfig.hasHillStartAssist) || Boolean(Peripheral.vehConfig.hasElectPowerSteering) || Boolean(Peripheral.vehConfig.hasTeenKeyFeature) && (Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) || Boolean(Peripheral.vehConfig
         .hasTKFCWBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssist) || Boolean(Peripheral.vehConfig.hasTKParkAssistBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssistFTvol) || Boolean(Peripheral.vehConfig.hasTKParkAssistRRvol) || Boolean(Peripheral.vehConfig.hasTKBlindSpot) || Boolean(Peripheral.vehConfig.hasTKFuelPopup) || Boolean(Peripheral.vehConfig.hasTKEarlyFuelWarning) || Boolean(Peripheral.vehConfig.hasTKAutoWipers) || Boolean(Peripheral.vehConfig.hasTKHLsWithWipers) || Boolean(Peripheral.vehConfig.hasTKAutoHighBeams) || Boolean(Peripheral.vehConfig.hasTKMaxSpeedLimit)))
         {
            contents.push(T.STRB_SAFETY_BREADCRUMB);
         }
         if(Boolean(Peripheral.vehConfig.hasElectParkBrake) || Boolean(Peripheral.vehConfig.hasAutoParkBrake) || Boolean(Peripheral.vehConfig.hasHoldNGo))
         {
            contents.push(T.STRB_SETTINGS_BRAKES);
         }
         if(Boolean(Peripheral.vehConfig.hasAmbientLighting) || Boolean(Peripheral.vehConfig.hasHeadlampOffDelay) || Boolean(Peripheral.vehConfig.hasIlluminatedApproach) || Boolean(Peripheral.vehConfig.hasAutoHeadLamp) || Boolean(Peripheral.vehConfig.hasAutoHighBeams) || Boolean(Peripheral.vehConfig.hasDayTimeRunningLights) || Boolean(Peripheral.vehConfig.hasAdvancedFrontLightSystem) || Boolean(Peripheral.vehConfig.hasHeadLampDip) || Boolean(Peripheral.vehConfig.hasFlashLampsWithLock) || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && (Boolean(Peripheral.vehConfig.hasCorneringLights) || Boolean(Peripheral.vehConfig.hasGreetingLights)))
         {
            contents.push(T.STRB_LIGHTS_BREADCRUMB);
         }
         if(Boolean(Peripheral.vehConfig.hasAutoDoorLocks) || Boolean(Peripheral.vehConfig.hasAutoDoorUnlock) || Boolean(Peripheral.vehConfig.hasFlashLampsWithLock) || Boolean(Peripheral.vehConfig.soundHornWithLocks) || Boolean(Peripheral.vehConfig.hasRemoteStart) || Boolean(Peripheral.vehConfig.hasRKEUnlock) || Boolean(Peripheral.vehConfig.hasPassiveEntry) || Boolean(Peripheral.vehConfig.personalSettingsAvailable) || Boolean(Peripheral.vehConfig.hasDoorAlert) || Boolean(Peripheral.vehConfig.hasPowerLiftGate) || Boolean(Peripheral.vehConfig.hasFlashLightSlideDoor) || Boolean(Peripheral.vehConfig.hasHFLiftGate) || Boolean(Peripheral.vehConfig.hasHFSlidingDoor) || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && (Boolean(Peripheral.vehConfig.hasPowerDoorLocks) || Boolean(Peripheral.vehConfig.hasAutoRelockingPE)) || Peripheral.vehConfig.vehicleLine == "LD" && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent) && Boolean(Peripheral.vehConfig.hasPolicePassiveEntry))
         {
            contents.push(T.STRB_DOORS_BREADCRUMB);
         }
         if(Boolean(Peripheral.vehConfig.hasAutoDriverComfort) && Boolean(Peripheral.vehConfig.hasHeatedSeat))
         {
            contents.push(T.STRB_COMFORT_BREADCRUMB);
         }
         if(Boolean(Peripheral.vehConfig.hasEasySeatExit) || Boolean(Peripheral.vehConfig.hasAccessoryDelay) || Boolean(Peripheral.vehConfig.hasHeadlampOffDelay) || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            contents.push(T.STRB_ENGINE_BREADCRUMB);
         }
         if(Boolean(Peripheral.vehConfig.hasFlashLightsWithRemoteLower) || Boolean(Peripheral.vehConfig.hasHornWithRemoteLower) || Boolean(Peripheral.vehConfig.hasAutoEntryExit) || Boolean(Peripheral.vehConfig.hasAirSuspensionWarning) || Boolean(Peripheral.vehConfig.hasAutoAeroMode) || Boolean(Peripheral.vehConfig.hasTireJackMode) || Boolean(Peripheral.vehConfig.hasTransportMode) || Boolean(Peripheral.vehConfig.hasWheelAligment))
         {
            contents.push(T.STRB_SETTINGS_SUSPENSION);
         }
         if(Peripheral.vehConfig.hasTrailerBrakesModule)
         {
            contents.push(T.STRB_SETTINGS_TRAILER_BRAKE);
         }
         contents.push(T.STRB_AUDIO_BREADCRUMB);
         contents.push(T.STRB_PHONE_BREADCRUMB);
         if(Peripheral.satelliteRadio.isAvailable)
         {
            contents.push(T.STRB_SIRIUS_BREADCRUMB);
         }
         if(Global.market == TunerRegion.EUROPE || Global.market == TunerRegion.SOUTH_AMERICA || Global.market == TunerRegion.AUSTRALIA || Peripheral.vehConfig.dabPresent == true && Global.market != TunerRegion.KOREA)
         {
            contents.push(T.STRB_SETTINGS_RADIO_SETUP);
         }
         if(Global.market == TunerRegion.CHINA)
         {
            contents.push(T.STRB_RESTORE_APPS);
         }
         if(Global.market == Market.NORTH_AMERICA && Boolean(Peripheral.rse.accessibilityAvailable))
         {
            contents.push(T.STRB_SETTINGS_ACCESSIBILITY);
         }
         contents.push(T.STRB_RESTORE_SETTINGS);
         contents.push(T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA);
         if(Global.market == TunerRegion.CHINA)
         {
            contents.push(T.STRB_MAP_INFORMATION);
         }
         contents.push(T.STRB_SYSTEM_INFORMATION);
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         t(assets.total,Format.itemsInList(contents.length));
      }
      
      override public function set index(index:int) : void
      {
         var item:MovieClip = null;
         super.index = index;
         for(var i:int = 0; i < LENGTH; i++)
         {
            item = assets.window["item" + i + "_button"];
            switch(contents.length > index + i ? contents[index + i] : -1)
            {
               case T.STRB_KEYSENSE:
                  configure(item,TYPE_SELECT,"keysense");
                  item.id = T.STRB_KEYSENSE;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_KEYSENSE));
                  break;
               case T.STRB_DISPLAY_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_DISPLAY_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_DISPLAY_BREADCRUMB));
                  break;
               case T.STRB_SETTINGS_ACCESSIBILITY:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_ACCESSIBILITY;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_ACCESSIBILITY));
                  break;
               case T.STRB_SETTINGS_UNITS:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_UNITS;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_UNITS));
                  break;
               case T.STRB_VOICE:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_VOICE;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_VOICE));
                  break;
               case T.STRB_CLOCK_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_CLOCK_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_CLOCK_BREADCRUMB));
                  break;
               case T.STRB_SAFETY_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SAFETY_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SAFETY_BREADCRUMB));
                  break;
               case T.STRB_LIGHTS_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_LIGHTS_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_LIGHTS_BREADCRUMB));
                  break;
               case T.STRB_DOORS_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_DOORS_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_DOORS_BREADCRUMB));
                  break;
               case T.STRB_COMFORT_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_COMFORT_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_COMFORT_BREADCRUMB));
                  break;
               case T.STRB_ENGINE_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_ENGINE_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_ENGINE_BREADCRUMB));
                  break;
               case T.STRB_SETTINGS_SUSPENSION:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_SUSPENSION;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SUSPENSION));
                  break;
               case T.STRB_SETTINGS_TRAILER_BRAKE:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_TRAILER_BRAKE;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_TRAILER_BRAKE));
                  break;
               case T.STRB_AUDIO_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_AUDIO_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_AUDIO_BREADCRUMB));
                  break;
               case T.STRB_PHONE_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_PHONE_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_PHONE_BREADCRUMB));
                  break;
               case T.STRB_SIRIUS_BREADCRUMB:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SIRIUS_BREADCRUMB;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SIRIUS_BREADCRUMB));
                  break;
               case T.STRB_SETTINGS_RADIO_SETUP:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_RADIO_SETUP;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_RADIO_SETUP));
                  break;
               case T.STRB_MAP_INFORMATION:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_MAP_INFORMATION;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_MAP_INFORMATION));
                  break;
               case T.STRB_SYSTEM_INFORMATION:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SYSTEM_INFORMATION;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SYSTEM_INFORMATION));
                  break;
               case T.STRB_RESTORE_APPS:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_RESTORE_APPS;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_RESTORE_APPS));
                  break;
               case T.STRB_RESTORE_SETTINGS:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_RESTORE_SETTINGS;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_RESTORE_SETTINGS));
                  break;
               case T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA));
                  break;
               case T.STRB_SETTINGS_BRAKES:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_SETTINGS_BRAKES;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_BRAKES));
                  break;
               default:
                  configure(item,TYPE_EMPTY);
            }
         }
      }
      
      override protected function onItem(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case T.STRB_KEYSENSE:
               Peripheral.keySensePinManager.KeySenseActivation();
               break;
            case T.STRB_DISPLAY_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_DISPLAY);
               break;
            case T.STRB_SETTINGS_ACCESSIBILITY:
               Framework.structure.goto(Screens.SETTINGS_ACCESSIBILITY);
               break;
            case T.STRB_SETTINGS_UNITS:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" || Boolean(Peripheral.vehConfig.hasUnitSet))
               {
                  Framework.structure.goto(Screens.SETTINGS_UNITS);
               }
               else if(!Peripheral.vehConfig.hasUnitOption)
               {
                  Framework.structure.goto(Screens.SETTINGS_UNITS_CUSTOM);
               }
               break;
            case T.STRB_VOICE:
               Framework.structure.goto(Screens.SETTINGS_VOICE);
               break;
            case T.STRB_CLOCK_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_CLOCK);
               break;
            case T.STRB_SAFETY_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_SAFETY);
               break;
            case T.STRB_LIGHTS_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_LIGHTS);
               break;
            case T.STRB_DOORS_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_DOORS);
               break;
            case T.STRB_COMFORT_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_COMFORT);
               break;
            case T.STRB_ENGINE_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_ENGINE);
               break;
            case T.STRB_SETTINGS_SUSPENSION:
               Framework.structure.goto(Screens.SETTINGS_SUSPENSION);
               break;
            case T.STRB_SETTINGS_TRAILER_BRAKE:
               Framework.structure.goto(Screens.SETTINGS_TRAILER_TYPES);
               break;
            case T.STRB_AUDIO_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_AUDIO);
               break;
            case T.STRB_PHONE_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_PHONE_BLUETOOTH);
               break;
            case T.STRB_SIRIUS_BREADCRUMB:
               Framework.structure.goto(Screens.SETTINGS_SIRIUS);
               break;
            case T.STRB_SETTINGS_RADIO_SETUP:
               Framework.structure.goto(Screens.SETTINGS_RADIO_SETUP);
               break;
            case T.STRB_MAP_INFORMATION:
               Framework.structure.goto(Screens.SETTINGS_SYSTEM_CENSOR);
               break;
            case T.STRB_SYSTEM_INFORMATION:
               Framework.structure.goto(Screens.SETTINGS_SYSTEM_INFO);
               break;
            case T.STRB_RESTORE_APPS:
               if(Peripheral.vehicleStatus.speedLockOut)
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
               }
               else
               {
                  Framework.structure.goto(Screens.SETTINGS_RESTORE_APPS);
               }
               break;
            case T.STRB_RESTORE_SETTINGS:
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_RESET_YOUR_SETTINGS_TO_DEFAULT,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_POPUP_TITLE_RESTORE_SETTINGS_DEFAULTS,
                  "message":T.STRB_POPUP_BODY_RESTORE_SETTINGS_DEFAULTS,
                  "caption1":T.STRB_OK,
                  "caption2":T.STRB_CANCEL,
                  "showClose":true
               });
               break;
            case T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA:
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_CLEAR_PERSONAL_DATA,"popup2item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA,
                  "message":T.STRB_POPUP_BODY_CLEAR_PERSONAL_DATA,
                  "caption1":T.STRB_OK,
                  "caption2":T.STRB_CANCEL,
                  "showClose":true
               });
               break;
            case T.STRB_SETTINGS_BRAKES:
               Framework.structure.goto(Screens.SETTINGS_ELECT_BRAKE);
         }
      }
      
      private function onTwoItemPopupLeftClick(e:GlobalEvent) : void
      {
         switch(e.data.id)
         {
            case DynamicPopupNames.TWOITEM_RESET_YOUR_SETTINGS_TO_DEFAULT:
               Framework.popupManager.show(DynamicPopupNames.ONEITEM_SETTINGS_RESTORED_TO_DEFAULT,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_POPUP_TITLE_RESTORE_SETTINGS_DEFAULTS,
                  "message":T.STRB_POPUP_BODY_SETTINGS_RESTORED,
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               Peripheral.versionInfo.restoreDefaultSettings();
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_RESET_YOUR_SETTINGS_TO_DEFAULT);
               break;
            case DynamicPopupNames.TWOITEM_CLEAR_PERSONAL_DATA:
               Framework.popupManager.show(DynamicPopupNames.ONEITEM_PERSONAL_DATA_CLEARED,"popup1item",{
                  "timeout":0,
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_POPUP_TITLE_CLEAR_PERSONAL_DATA,
                  "message":T.STRB_POPUP_BODY_PERSONAL_DATA_CLEARED,
                  "caption1":T.STRB_OK,
                  "showClose":true
               });
               Peripheral.versionInfo.clearPersonalData();
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_RESET_YOUR_SETTINGS_TO_DEFAULT);
         }
      }
   }
}

