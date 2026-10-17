package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsDoorsScreen extends ScreenListComponent
   {
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      public function SettingsDoorsScreen()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AUTODOORLOCK,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AUTOUNLOCKEXIT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FLASHHLWITHLOCK,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SOUNDHORNWITHLOCK,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HORNREMOTESTART,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FIRSTPRESSKEYFOB,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PASSIVEENTRY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PERSONALSETTINGSFOB,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SLIDINGDOORALERT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PWRLIFTGATECHIME,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HANDSFREELIFTGATE,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HFSLIDINGDOORSTAT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT,refresh,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh,false,0,true);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKSLIDINGDOORALERT,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKPWRLIFTGATECHIME,refresh,false,0,true);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AUTORELOCKPE,refresh,false,0,true);
         }
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsDoorsScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AUTODOORLOCK,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AUTOUNLOCKEXIT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FLASHHLWITHLOCK,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SOUNDHORNWITHLOCK,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HORNREMOTESTART,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FIRSTPRESSKEYFOB,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PASSIVEENTRY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PERSONALSETTINGSFOB,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SLIDINGDOORALERT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PWRLIFTGATECHIME,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HANDSFREELIFTGATE,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HFSLIDINGDOORSTAT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT,refresh);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKSLIDINGDOORALERT,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKPWRLIFTGATECHIME,refresh);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AUTORELOCKPE,refresh);
         }
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getAll();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsDoorsScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_DOORS_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Boolean(Peripheral.vehConfig.hasAutoDoorLocks) || this.VARIANT_PRODUCT == this.MP4_VARIANT && Boolean(Peripheral.vehConfig.hasPowerDoorLocks))
         {
            contents.push(T.STRB_SETTINGS_AUTO_LOCKS);
         }
         if(Peripheral.vehConfig.hasAutoDoorUnlock)
         {
            contents.push(T.STRB_SETTINGS_AUTO_UNLOCKS);
         }
         if(Peripheral.vehConfig.hasFlashLampsWithLock)
         {
            contents.push(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK);
         }
         if(Peripheral.vehConfig.soundHornWithLocks)
         {
            contents.push(T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK);
         }
         if(Peripheral.vehConfig.hasRemoteStart)
         {
            contents.push(T.STRB_SETTINGS_SOUND_HORN_WITH_START);
         }
         if(Peripheral.vehConfig.hasRKEUnlock)
         {
            contents.push(T.STRB_SETTINGS_PRESS_KEY_FOB);
         }
         if(Boolean(Peripheral.vehConfig.hasPassiveEntry) || Peripheral.vehConfig.vehicleLine == "LD" && Boolean(Peripheral.vehConfig.hasPoliceVehiclePresent) && Boolean(Peripheral.vehConfig.hasPolicePassiveEntry))
         {
            contents.push(T.STRB_SETTINGS_PASSIVE_ENTRY);
         }
         if(Peripheral.vehConfig.personalSettingsAvailable)
         {
            contents.push(T.STRB_SETTINGS_PERSONALIZED);
         }
         if(Peripheral.vehConfig.hasAutoRelockingPE)
         {
            contents.push(T.STRB_SETTINGS_AUTO_RELOCK_PASSIVE_ENTRY);
         }
         if(Peripheral.vehConfig.hasPowerLiftGate)
         {
            contents.push(T.STRB_SETTINGS_POWER_LIFTGATE_CHIME);
         }
         if(Peripheral.vehConfig.hasDoorAlert)
         {
            contents.push(T.STRB_SETTINGS_DOOR_ALERT);
         }
         if(Peripheral.vehConfig.hasFlashLightSlideDoor)
         {
            contents.push(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_SL);
         }
         if(Peripheral.vehConfig.hasHFLiftGate)
         {
            contents.push(T.STRB_SETTINGS_POWER_LIFTGATE);
         }
         if(Peripheral.vehConfig.hasHFSlidingDoor)
         {
            contents.push(T.STRB_SETTINGS_SLIDING_DOOR);
         }
         Peripheral.listController.total = contents.length;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.invalidate();
         t(assets.total,Format.itemsInList(contents.length));
      }
      
      override public function set index(index:int) : void
      {
         var item:MovieClip = null;
         for(var i:int = 0; i < LENGTH; i++)
         {
            item = assets.window["item" + i + "_button"];
            switch(contents.length > index + i ? contents[index + i] : -1)
            {
               case T.STRB_SETTINGS_AUTO_LOCKS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_AUTO_LOCKS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_LOCKS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.autoDoorLock);
                  break;
               case T.STRB_SETTINGS_AUTO_UNLOCKS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_AUTO_UNLOCKS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_UNLOCKS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.autoUnlockOnExit);
                  break;
               case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.flashHlWithLock);
                  break;
               case T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK:
                  if(Peripheral.vehConfig.soundHornWithLocksType == "3option")
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_2ND_PRESS));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_1ST_PRESS));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                     switch(Peripheral.personalConfig.soundHornWithLock1st2nd)
                     {
                        case "second":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "first":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "off":
                        default:
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK1);
                     item.id = T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK));
                     item.checkbox0.setHighlight(Peripheral.personalConfig.soundHornWithLock);
                  }
                  break;
               case T.STRB_SETTINGS_SOUND_HORN_WITH_START:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_SOUND_HORN_WITH_START;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND_HORN_WITH_START));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.hornWithRemoteStart);
                  break;
               case T.STRB_SETTINGS_PRESS_KEY_FOB:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETTINGS_PRESS_KEY_FOB;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PRESS_KEY_FOB));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_ALL_DOORS));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DRIVEP_DOOR));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.firstPresskeyFob == "alldoor");
                  item.checkbox1.setHighlight(Peripheral.personalConfig.firstPresskeyFob == "driverdoor");
                  break;
               case T.STRB_SETTINGS_PASSIVE_ENTRY:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_PASSIVE_ENTRY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PASSIVE_ENTRY));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.passiveEntry);
                  break;
               case T.STRB_SETTINGS_PERSONALIZED:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_PERSONALIZED;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PERSONALIZED));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.personalSettingsFob);
                  break;
               case T.STRB_SETTINGS_AUTO_RELOCK_PASSIVE_ENTRY:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_AUTO_RELOCK_PASSIVE_ENTRY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_RELOCK_PASSIVE_ENTRY));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.autoRelockPE);
                  break;
               case T.STRB_SETTINGS_DOOR_ALERT:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_DOOR_ALERT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DOOR_ALERT));
                  item.setEnabled(this.itemEnablePermitted);
                  item.checkbox0.setEnabled(this.itemEnablePermitted);
                  item.checkbox0.setHighlight(Peripheral.personalConfig.slidingDoorAlert);
                  break;
               case T.STRB_SETTINGS_POWER_LIFTGATE_CHIME:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_POWER_LIFTGATE_CHIME;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_POWER_LIFTGATE_CHIME));
                  item.setEnabled(this.itemEnablePermitted);
                  item.checkbox0.setEnabled(this.itemEnablePermitted);
                  item.checkbox0.setHighlight(Peripheral.personalConfig.PwrLiftgateChime);
                  break;
               case T.STRB_SETTINGS_POWER_LIFTGATE:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_POWER_LIFTGATE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_POWER_LIFTGATE));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.HFLiftgateStatus);
                  break;
               case T.STRB_SETTINGS_SLIDING_DOOR:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_SLIDING_DOOR;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SLIDING_DOOR));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.handsFreeSlidingDoorStatus);
                  break;
               case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_SL:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_FLASH_LIGHTS_WITH_SL;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_SL));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.flashLightSlideDoorStatus);
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
            case T.STRB_SETTINGS_AUTO_LOCKS:
               Peripheral.personalConfig.setAutoDoorLock(!Peripheral.personalConfig.autoDoorLock);
               break;
            case T.STRB_SETTINGS_AUTO_UNLOCKS:
               Peripheral.personalConfig.setAutoUnlockOnExit(!Peripheral.personalConfig.autoUnlockOnExit);
               break;
            case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK:
               Peripheral.personalConfig.setFlashHlWithLock(!Peripheral.personalConfig.flashHlWithLock);
               break;
            case T.STRB_SETTINGS_SOUND_HORN_WITH_LOCK:
               if(Peripheral.vehConfig.soundHornWithLocksType == "3option")
               {
                  switch(e.data.name)
                  {
                     case "checkbox2":
                        Peripheral.personalConfig.setSoundHornWithLock1st2nd("off");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setSoundHornWithLock1st2nd("first");
                        break;
                     case "checkbox0":
                        Peripheral.personalConfig.setSoundHornWithLock1st2nd("second");
                        break;
                     default:
                        switch(Peripheral.personalConfig.soundHornWithLock1st2nd)
                        {
                           case "second":
                              Peripheral.personalConfig.setSoundHornWithLock1st2nd("off");
                              break;
                           case "first":
                              Peripheral.personalConfig.setSoundHornWithLock1st2nd("second");
                              break;
                           case "off":
                              Peripheral.personalConfig.setSoundHornWithLock1st2nd("first");
                        }
                  }
               }
               else
               {
                  Peripheral.personalConfig.setSoundHornWithLock(!Peripheral.personalConfig.soundHornWithLock);
               }
               break;
            case T.STRB_SETTINGS_SOUND_HORN_WITH_START:
               Peripheral.personalConfig.setHornWithRemoteStart(!Peripheral.personalConfig.hornWithRemoteStart);
               break;
            case T.STRB_SETTINGS_PRESS_KEY_FOB:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setFirstPresskeyFob("alldoor");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setFirstPresskeyFob("driverdoor");
                     break;
                  default:
                     switch(Peripheral.personalConfig.firstPresskeyFob)
                     {
                        case "driverdoor":
                           Peripheral.personalConfig.setFirstPresskeyFob("alldoor");
                           break;
                        case "alldoor":
                           Peripheral.personalConfig.setFirstPresskeyFob("driverdoor");
                     }
               }
               break;
            case T.STRB_SETTINGS_PASSIVE_ENTRY:
               Peripheral.personalConfig.setPassiveEntry(!Peripheral.personalConfig.passiveEntry);
               break;
            case T.STRB_SETTINGS_PERSONALIZED:
               Peripheral.personalConfig.setPersonalSettingsFob(!Peripheral.personalConfig.personalSettingsFob);
               break;
            case T.STRB_SETTINGS_AUTO_RELOCK_PASSIVE_ENTRY:
               Peripheral.personalConfig.setAutoRelockPE(!Peripheral.personalConfig.autoRelockPE);
               break;
            case T.STRB_SETTINGS_DOOR_ALERT:
               Peripheral.personalConfig.setSlidingDoorAlert(!Peripheral.personalConfig.slidingDoorAlert);
               break;
            case T.STRB_SETTINGS_POWER_LIFTGATE_CHIME:
               Peripheral.personalConfig.setPwrLiftgateChime(!Peripheral.personalConfig.PwrLiftgateChime);
               break;
            case T.STRB_SETTINGS_POWER_LIFTGATE:
               Peripheral.personalConfig.setHFLiftgateStatus(!Peripheral.personalConfig.HFLiftgateStatus);
               break;
            case T.STRB_SETTINGS_SLIDING_DOOR:
               Peripheral.personalConfig.setHFSlidingDoorStatus(!Peripheral.personalConfig.handsFreeSlidingDoorStatus);
               break;
            case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_SL:
               Peripheral.personalConfig.setFlashLightSlideDoorStatus(!Peripheral.personalConfig.flashLightSlideDoorStatus);
         }
         refresh();
      }
      
      private function get itemEnablePermitted() : Boolean
      {
         return !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed" || Peripheral.antiTheft.ignitionState == "accessory");
      }
   }
}

