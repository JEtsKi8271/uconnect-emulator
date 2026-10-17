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
   public class SettingsSafetyScreen extends ScreenListComponent
   {
      
      private static const FCW_WITH_MEDIUM:int = 1;
      
      private static const FCW_FOR_520:int = 2;
      
      private static const SDWV_OPTIONS:int = 3;
      
      private static const MASERATI_VEH_BRAND:String = "11";
      
      private static const STRB_SETTINGS_LANEDEPARTURE_WARNING_PRESENT:String = "LaneSense";
      
      private static const SETTINGS_LANEDEPARTURE_WARNING_PRESENT:int = 4;
      
      public function SettingsSafetyScreen()
      {
         super();
      }
      
      private function hasFCWWithMedium() : Boolean
      {
         return Peripheral.vehConfig.ForwardCollisionWarning == "3option";
      }
      
      private function hasFCWWithSoftKeys() : Boolean
      {
         return Peripheral.vehConfig.hasFCWOnOffSoftKey;
      }
      
      private function hasFCW_On_Off() : Boolean
      {
         return Peripheral.vehConfig.hasFCWOnOffSoftKey;
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEFWDCOLLISION,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEFCWSENSITIVITY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEFCWONOFFSTATE,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEFCWBRAKESTAT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PARKASSIST,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FTSENSACTDRV,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PARKASSISTALERTVOL,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PARKASSISTBRAKING,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TILTMIRROR,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BLINDSPOT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BACKUPCAMERA,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.BACKUPCAMERADELAY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CAMERADYNAMICGRIDLINES,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CAMERASTATICGRIDLINES,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEAUTOWIPER,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SAFEHILLSTARTASSIST,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SLIDINGDOORALERT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.LDWARNSETTING,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.LSWARNSENSITIVITY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.LSTORQUEINTENSITY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.POWERSTEERINGMODE,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.POWERFOLDINGMIRRORS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SURROUNDCAMERALOCK,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.PADDLESMODESTATUS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SVCDELAY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SVCDYNAMICGIRDLINES,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CHMSLCAMERAGUIDELINES,refresh,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SIDEDISTANCEWARNING,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.SIDEDISTANCEWARNINGVOL,refresh,false,0,true);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKFCWSENSITIVITY,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKFCWBRAKEASSIST,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKPARKASSISTCONFIG,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKPARKASSISTBRAKING,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKPARKASSISTFTVOLUME,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKPARKASSISTRRVOLUME,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKBSMCONFIGURATION,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKAUTOWIPERS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKSLIDINGDOORALERT,refresh,false,0,true);
         }
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsSafetyScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEFWDCOLLISION,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEFCWSENSITIVITY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEFCWONOFFSTATE,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEFCWBRAKESTAT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PARKASSIST,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FTSENSACTDRV,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PARKASSISTALERTVOL,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PARKASSISTBRAKING,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TILTMIRROR,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.BLINDSPOT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.BACKUPCAMERA,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.BACKUPCAMERADELAY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CAMERADYNAMICGRIDLINES,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CAMERASTATICGRIDLINES,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEAUTOWIPER,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SAFEHILLSTARTASSIST,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SLIDINGDOORALERT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.LDWARNSETTING,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.LSWARNSENSITIVITY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.LSTORQUEINTENSITY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.POWERSTEERINGMODE,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.POWERFOLDINGMIRRORS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SURROUNDCAMERALOCK,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.PADDLESMODESTATUS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SVCDELAY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SVCDYNAMICGIRDLINES,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CHMSLCAMERAGUIDELINES,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SIDEDISTANCEWARNING,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.SIDEDISTANCEWARNINGVOL,refresh);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKFCWSENSITIVITY,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKFCWBRAKEASSIST,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKPARKASSISTCONFIG,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKPARKASSISTBRAKING,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKPARKASSISTFTVOLUME,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKPARKASSISTRRVOLUME,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKBSMCONFIGURATION,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKAUTOWIPERS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKSLIDINGDOORALERT,refresh);
         }
      }
      
      override protected function initScreen() : void
      {
         Peripheral.personalConfig.getAll();
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsSafetyScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_SAFETY_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.ForwardCollisionWarning == "1option")
         {
            contents.push(T.STRB_SETTINGS_COLLISION_WARNING_LONG);
            contents.push(FCW_FOR_520);
            contents.push(T.STRB_SETTINGS_COLLISION_SENSITIVITY_L);
            contents.push(FCW_WITH_MEDIUM);
         }
         else if(Peripheral.vehConfig.ForwardCollisionWarning != "absent" && !this.hasFCWWithSoftKeys())
         {
            contents.push(T.STRB_SETTINGS_COLLISION_WARNING_LONG);
            if(this.hasFCWWithMedium())
            {
               contents.push(FCW_WITH_MEDIUM);
            }
         }
         else if(Peripheral.vehConfig.ForwardCollisionWarning != "absent" && this.hasFCWWithSoftKeys())
         {
            contents.push(T.STRB_SETTINGS_COLLISION_WARNING_LONG);
            contents.push(T.STRB_SETTINGS_COLLISION_SENSITIVITY_L);
            if(this.hasFCWWithMedium())
            {
               contents.push(FCW_WITH_MEDIUM);
            }
         }
         if(Peripheral.vehConfig.hasForwardCollisionBraking)
         {
            contents.push(T.STRB_SETTINGS_COLLISION_ACTIVE_BRAKING);
         }
         if(Peripheral.vehConfig.hasLaneDepartureWarningPresent)
         {
            contents.push(SETTINGS_LANEDEPARTURE_WARNING_PRESENT);
         }
         if(Peripheral.vehConfig.laneSenseSensitivityType == "3option" || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseSensitivityType == "1option")
         {
            contents.push(T.STRB_SETTINGS_LANESENSE_WARNING);
         }
         if(Peripheral.vehConfig.laneSenseTorqueType == "3option" || Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseTorqueType == "1option")
         {
            contents.push(T.STRB_SETTINGS_LANESENSE_STRENGTH);
         }
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Boolean(Peripheral.vehConfig.sideDistanceWarningPresent))
         {
            contents.push(T.STRB_SIDE_DISTANCE_WARNING_520);
            contents.push(T.STRB_SIDE_DISTANCE_WARNING_VOLUME_520);
            contents.push(SDWV_OPTIONS);
         }
         if(Peripheral.vehConfig.hasElectPowerSteering)
         {
            contents.push(T.STRB_SETTINGS_POWER_STEERING);
         }
         if(Peripheral.vehConfig.parkAssist == "1option" || Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND && Peripheral.vehConfig.parkAssist == "3option")
         {
            contents.push(T.STRB_SETTINGS_PARKSENSE_ALERTS);
            if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND)
            {
               contents.push(T.STRB_SETTINGS_FRONT_SENSORS_ACTIVE_DRIVE);
            }
            if(Peripheral.vehConfig.hasParkAssistFrontVolume)
            {
               contents.push(T.STRB_SETTINGS_FRNT_PARKSENSE_VOL);
            }
            if(Peripheral.vehConfig.hasParkAssistRearVolume)
            {
               contents.push(T.STRB_SETTINGS_REAR_PARKSENSE_VOL);
            }
            if(Peripheral.vehConfig.hasParkAssistBraking)
            {
               contents.push(T.STRB_SETTINGS_PARKSENSE_BRAKING_ASSIST);
            }
         }
         if(Peripheral.vehConfig.hasTiltMirrorInReverse)
         {
            contents.push(T.STRB_SETTINGS_TILT_MIRRORS_IN_REVERSE);
         }
         if(Peripheral.vehConfig.hasPwrFoldingMirrors)
         {
            contents.push(T.STRB_AUTO_FOLDING_SIDE_MIR);
         }
         if(Peripheral.vehConfig.hasSettingsPaddleMode)
         {
            contents.push(T.STRB_SETUP_PADDLE_SHIFTERS);
         }
         if(Peripheral.vehConfig.hasBlindSpotModule)
         {
            contents.push(T.STRB_SETTINGS_BLIND_SPOT_ALERT);
         }
         if(Peripheral.vehConfig.hasSVCDelay)
         {
            contents.push(T.STRB_SURROUND_VIEW_CAMERA_D);
         }
         if(Peripheral.vehConfig.hasSVCDynamicGridLines)
         {
            contents.push(T.STRB_SURROUND_VIEW_CAMERA_G);
         }
         if(Peripheral.vehConfig.rearCameraGridlinesType == "both")
         {
            contents.push(T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES);
            contents.push(T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES);
         }
         else if(Peripheral.vehConfig.rearCameraGridlinesType == "dynamic")
         {
            contents.push(T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES);
         }
         else if(Peripheral.vehConfig.rearCameraGridlinesType == "static")
         {
            contents.push(T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES);
         }
         if(Peripheral.vehConfig.hasRearCameraDelay)
         {
            contents.push(T.STRB_SETTINGS_BACKUP_CAMERA_DELAY);
         }
         if(Peripheral.vehConfig.hasCHMSLCameraGuidelines)
         {
            contents.push(T.STRB_SETTINGS_CARGO_CAMERA_GRIDLINES);
         }
         if(Peripheral.vehConfig.rainSensorType != "absent")
         {
            contents.push(T.STRB_SETTINGS_RAIN_SENSING);
         }
         if(Peripheral.vehConfig.hasDoorAlert)
         {
            contents.push(T.STRB_SETTINGS_DOOR_ALERT);
         }
         if(Peripheral.vehConfig.hasHillStartAssist)
         {
            contents.push(T.STRB_SETTINGS_HILL_ASSIST);
         }
         if(Boolean(Peripheral.vehConfig.hasTeenKeyFeature) && (Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) || Boolean(Peripheral.vehConfig.hasTKFCWBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssist) || Boolean(Peripheral.vehConfig.hasTKParkAssistBraking) || Boolean(Peripheral.vehConfig.hasTKParkAssistFTvol) || Boolean(Peripheral.vehConfig.hasTKParkAssistRRvol) || Boolean(Peripheral.vehConfig.hasTKBlindSpot) || Boolean(Peripheral.vehConfig.hasTKFuelPopup) || Boolean(Peripheral.vehConfig.hasTKEarlyFuelWarning) || Boolean(Peripheral.vehConfig.hasTKAutoWipers) || Boolean(Peripheral.vehConfig.hasTKHLsWithWipers) || Boolean(Peripheral.vehConfig.hasTKAutoHighBeams) || Boolean(Peripheral.vehConfig.hasTKMaxSpeedLimit)))
         {
            contents.push(T.STRB_KEYSENSE);
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
               case T.STRB_SETTINGS_COLLISION_WARNING_LONG:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     configure(item,TYPE_SIMPLE);
                     item.id = T.STRB_SETTINGS_COLLISION_WARNING_LONG;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_WARNING_LONG));
                  }
                  else if(this.hasFCWWithSoftKeys())
                  {
                     configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = T.STRB_SETTINGS_COLLISION_WARNING_LONG;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_WARNING_LONG));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                        item.checkbox0.setEnabled(false);
                        item.checkbox0.setHighlight(Peripheral.personalConfig.safeFcwOnOffState == "on");
                     }
                     else
                     {
                        item.checkbox0.setHighlight(Peripheral.personalConfig.safeFcwOnOffState == "on");
                     }
                  }
                  else if(this.hasFCWWithMedium())
                  {
                     configure(item,TYPE_SIMPLE,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = T.STRB_SETTINGS_COLLISION_WARNING_LONG;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_WARNING_LONG));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK2,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = T.STRB_SETTINGS_COLLISION_WARNING_LONG;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_WARNING_LONG));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NEAR));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                        item.checkbox0.setEnabled(false);
                        item.checkbox1.setEnabled(false);
                        item.checkbox0.setHighlight(Peripheral.personalConfig.TKFCWSensitivity == "far");
                        item.checkbox1.setHighlight(Peripheral.personalConfig.TKFCWSensitivity == "near");
                     }
                     else
                     {
                        item.checkbox0.setHighlight(Peripheral.personalConfig.safeFwdCollision == "far");
                        item.checkbox1.setHighlight(Peripheral.personalConfig.safeFwdCollision == "near");
                     }
                  }
                  break;
               case T.STRB_SETTINGS_COLLISION_SENSITIVITY_L:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     configure(item,TYPE_SIMPLE);
                     item.id = T.STRB_SETTINGS_COLLISION_SENSITIVITY_L;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_SENSITIVITY_L));
                  }
                  else if(this.hasFCWWithMedium())
                  {
                     configure(item,TYPE_SIMPLE,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = T.STRB_SETTINGS_COLLISION_SENSITIVITY_L;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_SENSITIVITY_L));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK2,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = T.STRB_SETTINGS_COLLISION_SENSITIVITY_L;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_SENSITIVITY_L));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NEAR));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                        item.checkbox0.setEnabled(false);
                        item.checkbox1.setEnabled(false);
                        item.checkbox0.setHighlight(Peripheral.personalConfig.TKFCWSensitivity == "far");
                        item.checkbox1.setHighlight(Peripheral.personalConfig.TKFCWSensitivity == "near");
                     }
                     else
                     {
                        item.checkbox0.setHighlight(Peripheral.personalConfig.safeFwdCollision == "far");
                        item.checkbox1.setHighlight(Peripheral.personalConfig.safeFwdCollision == "near");
                     }
                  }
                  break;
               case FCW_WITH_MEDIUM:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = FCW_WITH_MEDIUM;
                     label(item.label,"");
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NEAR));
                     switch(Peripheral.personalConfig.safeFwdCollision)
                     {
                        case "near":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                           break;
                        case "med":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "far":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        default:
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK3,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity) ? "keysense" : "");
                     item.id = FCW_WITH_MEDIUM;
                     label(item.label,"");
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FAR));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NEAR));
                     if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWSensitivity))
                     {
                        item.setEnabled(false);
                        item.checkbox0.setEnabled(false);
                        item.checkbox1.setEnabled(false);
                        item.checkbox2.setEnabled(false);
                        switch(Peripheral.personalConfig.TKFCWSensitivity)
                        {
                           case "near":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(true);
                              break;
                           case "med":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "far":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                              break;
                           default:
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                        }
                     }
                     else
                     {
                        switch(Peripheral.personalConfig.safeFcwSensitivitySetting)
                        {
                           case "near":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(true);
                              break;
                           case "med":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "far":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                              break;
                           default:
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                        }
                     }
                  }
                  break;
               case FCW_FOR_520:
                  configure(item,TYPE_CHECK3);
                  item.id = FCW_FOR_520;
                  label(item.label,"");
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FWD_COLLISION_AUDIO_BRAKE));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FWD_COLLISION_AUDIO));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                  switch(Peripheral.personalConfig.forwardCollisionWarning)
                  {
                     case "audio_brake":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "audio":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "off":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
                        break;
                     default:
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                  }
                  break;
               case T.STRB_SETTINGS_COLLISION_ACTIVE_BRAKING:
                  configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWBraking) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_COLLISION_ACTIVE_BRAKING;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COLLISION_ACTIVE_BRAKING));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKFCWBraking))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.TKFCWBrakeAssist == "on");
                  }
                  else
                  {
                     item.checkbox0.setHighlight(Peripheral.personalConfig.safeFcwBrakeStat == "on");
                  }
                  break;
               case SETTINGS_LANEDEPARTURE_WARNING_PRESENT:
                  configure(item,TYPE_CHECK1);
                  item.id = SETTINGS_LANEDEPARTURE_WARNING_PRESENT;
                  label(item.label,STRB_SETTINGS_LANEDEPARTURE_WARNING_PRESENT);
                  item.checkbox0.setHighlight(Peripheral.personalConfig.laneDepartureWarnSetting);
                  break;
               case T.STRB_SETTINGS_LANESENSE_WARNING:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseSensitivityType == "1option")
                  {
                     configure(item,TYPE_CHECK2);
                     item.id = T.STRB_SETTINGS_LANESENSE_WARNING;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LANESENSE_WARNING));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LATE));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_EARLY));
                     switch(Peripheral.personalConfig.laneSenseWarnSensitivity)
                     {
                        case "Late":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           break;
                        case "Early":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = T.STRB_SETTINGS_LANESENSE_WARNING;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LANESENSE_WARNING));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LATE));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_EARLY));
                     switch(Peripheral.personalConfig.laneSenseWarnSensitivity)
                     {
                        case "Late":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "Med":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "Early":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                           break;
                        case "off":
                        case "SNA":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                     }
                  }
                  break;
               case T.STRB_SETTINGS_LANESENSE_STRENGTH:
                  if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseTorqueType == "1option")
                  {
                     configure(item,TYPE_CHECK2);
                     item.id = T.STRB_SETTINGS_LANESENSE_STRENGTH;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LANESENSE_STRENGTH));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HIGH_2));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LOW_2));
                     switch(Peripheral.personalConfig.laneSenseTorqueIntensity)
                     {
                        case "High":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           break;
                        case "Low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                     }
                  }
                  else
                  {
                     configure(item,TYPE_CHECK3);
                     item.id = T.STRB_SETTINGS_LANESENSE_STRENGTH;
                     label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LANESENSE_STRENGTH));
                     label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HIGH_2));
                     label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LOW_2));
                     switch(Peripheral.personalConfig.laneSenseTorqueIntensity)
                     {
                        case "High":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "Med":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "Low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                           break;
                        case "off":
                        case "SNA":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                     }
                  }
                  break;
               case T.STRB_SIDE_DISTANCE_WARNING_520:
                  configure(item,TYPE_CHECK3);
                  item.id = T.STRB_SIDE_DISTANCE_WARNING_520;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SIDE_DISTANCE_WARNING_520));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND_AND_DISPLAY));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                  switch(Peripheral.personalConfig.sideDistanceWarning)
                  {
                     case "sounddisplay":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "sound":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "off":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
                  }
                  break;
               case T.STRB_SIDE_DISTANCE_WARNING_VOLUME_520:
                  configure(item,TYPE_SIMPLE);
                  item.id = T.STRB_SIDE_DISTANCE_WARNING_VOLUME_520;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SIDE_DISTANCE_WARNING_VOLUME_520));
                  break;
               case SDWV_OPTIONS:
                  configure(item,TYPE_CHECK3);
                  item.id = SDWV_OPTIONS;
                  label(item.label,"");
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HIGH_2));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LOW_2));
                  switch(Peripheral.personalConfig.sideDistanceWarningVolume)
                  {
                     case "high":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "medium":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "low":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
                  }
                  break;
               case T.STRB_SETTINGS_POWER_STEERING:
                  configure(item,TYPE_CHECK3);
                  item.id = T.STRB_SETTINGS_POWER_STEERING;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_POWER_STEERING));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_COMFORT));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SPORT));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_NORMAL));
                  switch(Peripheral.personalConfig.powerSteeringMode)
                  {
                     case "Comfort":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "Sport":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        item.checkbox2.setHighlight(false);
                        break;
                     case "Normal":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(true);
                        break;
                     default:
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                        item.checkbox2.setHighlight(false);
                  }
                  break;
               case T.STRB_SETTINGS_PARKSENSE_ALERTS:
                  if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND && Peripheral.vehConfig.parkAssist == "3option")
                  {
                     configure(item,TYPE_CHECK3,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssist) ? "keysense" : "");
                     label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                  }
                  else
                  {
                     configure(item,TYPE_CHECK2,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssist) ? "keysense" : "");
                  }
                  item.id = T.STRB_SETTINGS_PARKSENSE_ALERTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PARKSENSE_ALERTS));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND_AND_DISPLAY));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_SOUND));
                  if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND)
                  {
                     if(Peripheral.vehConfig.parkAssist == "3option")
                     {
                        switch(Peripheral.personalConfig.safeParkAssist)
                        {
                           case "sounddisplay":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "sound":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              item.checkbox2.setHighlight(false);
                              break;
                           case "off":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(true);
                              break;
                           case "SNA":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                              item.checkbox2.setHighlight(false);
                        }
                     }
                     else
                     {
                        switch(Peripheral.personalConfig.safeParkAssist)
                        {
                           case "sounddisplay":
                              item.checkbox0.setHighlight(true);
                              item.checkbox1.setHighlight(false);
                              break;
                           case "sound":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(true);
                              break;
                           case "off":
                           case "SNA":
                              item.checkbox0.setHighlight(false);
                              item.checkbox1.setHighlight(false);
                        }
                     }
                  }
                  else if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssist))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     switch(Peripheral.personalConfig.TKPTS_ConfigStatus)
                     {
                        case "sounddisplay":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           break;
                        case "sound":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           break;
                        case "off":
                        case "SNA":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                     }
                  }
                  else
                  {
                     switch(Peripheral.personalConfig.safeParkAssist)
                     {
                        case "sounddisplay":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           break;
                        case "sound":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           break;
                        case "off":
                        case "SNA":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                     }
                  }
                  break;
               case T.STRB_SETTINGS_FRONT_SENSORS_ACTIVE_DRIVE:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_FRONT_SENSORS_ACTIVE_DRIVE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FRONT_SENSORS_ACTIVE_DRIVE));
                  if(Peripheral.personalConfig.safeParkAssist == "off")
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                  }
                  else
                  {
                     switch(Peripheral.personalConfig.safeFrontSensorsActiveDrive)
                     {
                        case "on":
                           item.checkbox0.setHighlight(true);
                           break;
                        case "off":
                           item.checkbox0.setHighlight(false);
                           break;
                        case "SNA":
                     }
                  }
                  break;
               case T.STRB_SETTINGS_FRNT_PARKSENSE_VOL:
                  configure(item,TYPE_CHECK3,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistFTvol) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_FRNT_PARKSENSE_VOL;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FRNT_PARKSENSE_VOL));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HIGH_2));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LOW_2));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistFTvol))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     item.checkbox2.setEnabled(false);
                     switch(Peripheral.personalConfig.TKPTSFrontVolume)
                     {
                        case "high":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "medium":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  else
                  {
                     switch(Peripheral.personalConfig.frontParkAssistChimeVolume)
                     {
                        case "high":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "medium":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  break;
               case T.STRB_SETTINGS_REAR_PARKSENSE_VOL:
                  configure(item,TYPE_CHECK3,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistRRvol) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_REAR_PARKSENSE_VOL;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_REAR_PARKSENSE_VOL));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HIGH_2));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_MED_2));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LOW_2));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistRRvol))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     item.checkbox2.setEnabled(false);
                     switch(Peripheral.personalConfig.TKPTSRearVolume)
                     {
                        case "high":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "medium":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  else
                  {
                     switch(Peripheral.personalConfig.rearParkAssistChimeVolume)
                     {
                        case "high":
                           item.checkbox0.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "medium":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox2.setHighlight(false);
                           break;
                        case "low":
                           item.checkbox0.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox2.setHighlight(true);
                     }
                  }
                  break;
               case T.STRB_SETTINGS_PARKSENSE_BRAKING_ASSIST:
                  configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistBraking) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_PARKSENSE_BRAKING_ASSIST;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_PARKSENSE_BRAKING_ASSIST));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKParkAssistBraking))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.TKPTSBrakingAssist);
                  }
                  else
                  {
                     item.checkbox0.setHighlight(Peripheral.personalConfig.rearParkAssistBraking);
                  }
                  break;
               case T.STRB_SETTINGS_TILT_MIRRORS_IN_REVERSE:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_TILT_MIRRORS_IN_REVERSE;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_TILT_MIRRORS_IN_REVERSE));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeTiltMirror);
                  break;
               case T.STRB_AUTO_FOLDING_SIDE_MIR:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_AUTO_FOLDING_SIDE_MIR;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_AUTO_FOLDING_SIDE_MIR));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.powerFoldingMirrors);
                  break;
               case T.STRB_SETUP_PADDLE_SHIFTERS:
                  configure(item,TYPE_CHECK2);
                  item.id = T.STRB_SETUP_PADDLE_SHIFTERS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETUP_PADDLE_SHIFTERS));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_ENABLE));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_DISABLE));
                  switch(Peripheral.personalConfig.PaddlesModeStatus)
                  {
                     case "enable":
                        item.checkbox0.setHighlight(true);
                        item.checkbox1.setHighlight(false);
                        break;
                     case "disable":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(true);
                        break;
                     case "none":
                     case "sna":
                        item.checkbox0.setHighlight(false);
                        item.checkbox1.setHighlight(false);
                  }
                  break;
               case T.STRB_SETTINGS_BLIND_SPOT_ALERT:
                  configure(item,TYPE_CHECK3,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKBlindSpot) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_BLIND_SPOT_ALERT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_BLIND_SPOT_ALERT));
                  label(item.check0,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LIGHTS_AND_CHIME));
                  label(item.check1,Peripheral.localeEngine.getText(T.STRB_SETTINGS_LIGHTS));
                  label(item.check2,Peripheral.localeEngine.getText(T.STRB_SETTINGS_OFF));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKBlindSpot))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox1.setEnabled(false);
                     item.checkbox2.setEnabled(false);
                     switch(Peripheral.personalConfig.TKBSM_ConfigStatus)
                     {
                        case "lights":
                           item.checkbox2.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox0.setHighlight(false);
                           break;
                        case "lightschime":
                           item.checkbox2.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox0.setHighlight(true);
                           break;
                        case "off":
                        default:
                           item.checkbox2.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox0.setHighlight(false);
                     }
                  }
                  else
                  {
                     switch(Peripheral.personalConfig.safeBlindSpot)
                     {
                        case "lights":
                           item.checkbox2.setHighlight(false);
                           item.checkbox1.setHighlight(true);
                           item.checkbox0.setHighlight(false);
                           break;
                        case "lightschime":
                           item.checkbox2.setHighlight(false);
                           item.checkbox1.setHighlight(false);
                           item.checkbox0.setHighlight(true);
                           break;
                        case "off":
                        default:
                           item.checkbox2.setHighlight(true);
                           item.checkbox1.setHighlight(false);
                           item.checkbox0.setHighlight(false);
                     }
                  }
                  break;
               case T.STRB_REAR_CAMERA_LOCK:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_REAR_CAMERA_LOCK;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_REAR_CAMERA_LOCK));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeSurroundCameraLock);
                  break;
               case T.STRB_SURROUND_VIEW_CAMERA_D:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SURROUND_VIEW_CAMERA_D;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SURROUND_VIEW_CAMERA_D));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.SVCDelay);
                  break;
               case T.STRB_SURROUND_VIEW_CAMERA_G:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SURROUND_VIEW_CAMERA_G;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SURROUND_VIEW_CAMERA_G));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.SVCDyanmicGridLines);
                  break;
               case T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeCameraDynamicGridLines);
                  break;
               case T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeCameraStaticGridLines);
                  break;
               case T.STRB_SETTINGS_BACKUP_CAMERA_DELAY:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_BACKUP_CAMERA_DELAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_BACKUP_CAMERA_DELAY));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeBackUpCameraDelay);
                  break;
               case T.STRB_SETTINGS_CARGO_CAMERA_GRIDLINES:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_CARGO_CAMERA_GRIDLINES;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_CARGO_CAMERA_GRIDLINES));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.CHMSLCameraGuidelines);
                  break;
               case T.STRB_SETTINGS_RAIN_SENSING:
                  configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKAutoWipers) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_RAIN_SENSING;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_RAIN_SENSING));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKAutoWipers))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.TKAutoWipers);
                  }
                  else
                  {
                     item.checkbox0.setHighlight(Peripheral.personalConfig.safeAutoWiper);
                  }
                  break;
               case T.STRB_SETTINGS_DOOR_ALERT:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_DOOR_ALERT;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DOOR_ALERT));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.slidingDoorAlert);
                  break;
               case T.STRB_SETTINGS_HILL_ASSIST:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_HILL_ASSIST;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HILL_ASSIST));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.safeHillStartAssist);
                  break;
               case T.STRB_KEYSENSE:
                  configure(item,TYPE_SELECT);
                  item.id = T.STRB_KEYSENSE;
                  item.value.text = "";
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_KEYSENSE));
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
            case T.STRB_SETTINGS_COLLISION_WARNING_LONG:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT != "MP4")
               {
                  if(!this.hasFCWWithSoftKeys())
                  {
                     switch(e.data.name)
                     {
                        case "checkbox0":
                           Peripheral.personalConfig.setSafeFwdCollision("far");
                           break;
                        case "checkbox1":
                           Peripheral.personalConfig.setSafeFwdCollision("near");
                           break;
                        default:
                           switch(Peripheral.personalConfig.safeFwdCollision)
                           {
                              case "far":
                                 Peripheral.personalConfig.setSafeFwdCollision("near");
                                 break;
                              case "near":
                                 Peripheral.personalConfig.setSafeFwdCollision("far");
                           }
                     }
                  }
                  else
                  {
                     Peripheral.personalConfig.setSafeFcwOnOffState(Peripheral.personalConfig.safeFcwOnOffState != "on");
                  }
               }
               break;
            case T.STRB_SETTINGS_COLLISION_SENSITIVITY_L:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT != "MP4")
               {
                  if(this.hasFCWWithSoftKeys() && !this.hasFCWWithMedium())
                  {
                     switch(e.data.name)
                     {
                        case "checkbox0":
                           Peripheral.personalConfig.setSafeFwdCollision("far");
                           break;
                        case "checkbox1":
                           Peripheral.personalConfig.setSafeFwdCollision("near");
                           break;
                        default:
                           switch(Peripheral.personalConfig.safeFwdCollision)
                           {
                              case "far":
                                 Peripheral.personalConfig.setSafeFwdCollision("near");
                                 break;
                              case "near":
                                 Peripheral.personalConfig.setSafeFwdCollision("far");
                           }
                     }
                  }
               }
               break;
            case FCW_WITH_MEDIUM:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setSafeFwdCollision("far");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setSafeFwdCollision("med");
                        break;
                     case "checkbox2":
                        Peripheral.personalConfig.setSafeFwdCollision("near");
                        break;
                     default:
                        switch(Peripheral.personalConfig.safeFwdCollision)
                        {
                           case "off":
                           case "far":
                              Peripheral.personalConfig.setSafeFwdCollision("near");
                              break;
                           case "med":
                              Peripheral.personalConfig.setSafeFwdCollision("far");
                              break;
                           default:
                              Peripheral.personalConfig.setSafeFwdCollision("med");
                        }
                  }
               }
               else
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setSafeFcwSensitivitySetting("far");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setSafeFcwSensitivitySetting("med");
                        break;
                     case "checkbox2":
                        Peripheral.personalConfig.setSafeFcwSensitivitySetting("near");
                        break;
                     default:
                        switch(Peripheral.personalConfig.safeFcwSensitivitySetting)
                        {
                           case "off":
                           case "far":
                              Peripheral.personalConfig.setSafeFcwSensitivitySetting("near");
                              break;
                           case "med":
                              Peripheral.personalConfig.setSafeFcwSensitivitySetting("far");
                              break;
                           default:
                              Peripheral.personalConfig.setSafeFcwSensitivitySetting("med");
                        }
                  }
               }
               break;
            case FCW_FOR_520:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setForwardCollisionWarning("audio_brake");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setForwardCollisionWarning("audio");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setForwardCollisionWarning("off");
                     break;
                  default:
                     switch(Peripheral.personalConfig.forwardCollisionWarning)
                     {
                        case "off":
                           Peripheral.personalConfig.setForwardCollisionWarning("audio");
                           break;
                        case "audio":
                           Peripheral.personalConfig.setForwardCollisionWarning("audio_brake");
                           break;
                        default:
                           Peripheral.personalConfig.setForwardCollisionWarning("off");
                     }
               }
               break;
            case T.STRB_SETTINGS_COLLISION_ACTIVE_BRAKING:
               Peripheral.personalConfig.setSafeFcwBrakeStat(Peripheral.personalConfig.safeFcwBrakeStat != "on");
               break;
            case SETTINGS_LANEDEPARTURE_WARNING_PRESENT:
               Peripheral.personalConfig.setLaneDepartureWarnSetting(!Peripheral.personalConfig.laneDepartureWarnSetting);
               break;
            case T.STRB_SETTINGS_LANESENSE_WARNING:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseSensitivityType == "1option")
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setLaneSenseWarnSensitivity("Late");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setLaneSenseWarnSensitivity("Early");
                        break;
                     default:
                        switch(Peripheral.personalConfig.laneSenseWarnSensitivity)
                        {
                           case "Early":
                              Peripheral.personalConfig.setLaneSenseWarnSensitivity("Late");
                              break;
                           case "Late":
                              Peripheral.personalConfig.setLaneSenseWarnSensitivity("Early");
                        }
                  }
               }
               else
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setLaneSenseWarnSensitivity("Late");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setLaneSenseWarnSensitivity("Med");
                        break;
                     case "checkbox2":
                        Peripheral.personalConfig.setLaneSenseWarnSensitivity("Early");
                        break;
                     default:
                        switch(Peripheral.personalConfig.laneSenseWarnSensitivity)
                        {
                           case "Early":
                              Peripheral.personalConfig.setLaneSenseWarnSensitivity("Med");
                              break;
                           case "Med":
                              Peripheral.personalConfig.setLaneSenseWarnSensitivity("Late");
                              break;
                           case "Late":
                              Peripheral.personalConfig.setLaneSenseWarnSensitivity("Early");
                        }
                  }
               }
               break;
            case T.STRB_SETTINGS_LANESENSE_STRENGTH:
               if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4" && Peripheral.vehConfig.laneSenseTorqueType == "1option")
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setLaneSenseTorqueIntensity("High");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setLaneSenseTorqueIntensity("Low");
                        break;
                     default:
                        switch(Peripheral.personalConfig.laneSenseTorqueIntensity)
                        {
                           case "High":
                              Peripheral.personalConfig.setLaneSenseTorqueIntensity("Low");
                              break;
                           case "Low":
                              Peripheral.personalConfig.setLaneSenseTorqueIntensity("High");
                        }
                  }
               }
               else
               {
                  switch(e.data.name)
                  {
                     case "checkbox0":
                        Peripheral.personalConfig.setLaneSenseTorqueIntensity("High");
                        break;
                     case "checkbox1":
                        Peripheral.personalConfig.setLaneSenseTorqueIntensity("Med");
                        break;
                     case "checkbox2":
                        Peripheral.personalConfig.setLaneSenseTorqueIntensity("Low");
                        break;
                     default:
                        switch(Peripheral.personalConfig.laneSenseTorqueIntensity)
                        {
                           case "Low":
                              Peripheral.personalConfig.setLaneSenseTorqueIntensity("Med");
                              break;
                           case "Med":
                              Peripheral.personalConfig.setLaneSenseTorqueIntensity("High");
                              break;
                           case "High":
                              Peripheral.personalConfig.setLaneSenseTorqueIntensity("Low");
                        }
                  }
               }
               break;
            case T.STRB_SIDE_DISTANCE_WARNING_520:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setSideDistanceWarning("sounddisplay");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setSideDistanceWarning("sound");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setSideDistanceWarning("off");
                     break;
                  default:
                     switch(Peripheral.personalConfig.sideDistanceWarning)
                     {
                        case "off":
                           Peripheral.personalConfig.setSideDistanceWarning("sound");
                           break;
                        case "sound":
                           Peripheral.personalConfig.setSideDistanceWarning("sounddisplay");
                           break;
                        case "sounddisplay":
                           Peripheral.personalConfig.setSideDistanceWarning("off");
                     }
               }
               break;
            case SDWV_OPTIONS:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setSideDistanceWarningVolume("high");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setSideDistanceWarningVolume("medium");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setSideDistanceWarningVolume("low");
                     break;
                  default:
                     switch(Peripheral.personalConfig.sideDistanceWarningVolume)
                     {
                        case "low":
                           Peripheral.personalConfig.setSideDistanceWarningVolume("medium");
                           break;
                        case "medium":
                           Peripheral.personalConfig.setSideDistanceWarningVolume("high");
                           break;
                        case "high":
                           Peripheral.personalConfig.setSideDistanceWarningVolume("low");
                     }
               }
               break;
            case T.STRB_SETTINGS_POWER_STEERING:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setPowerSteeringMode("Comfort");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setPowerSteeringMode("Sport");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setPowerSteeringMode("Normal");
                     break;
                  default:
                     switch(Peripheral.personalConfig.powerSteeringMode)
                     {
                        case "Normal":
                           Peripheral.personalConfig.setPowerSteeringMode("Sport");
                           break;
                        case "Sport":
                           Peripheral.personalConfig.setPowerSteeringMode("Comfort");
                           break;
                        case "Comfort":
                           Peripheral.personalConfig.setPowerSteeringMode("Normal");
                     }
               }
               break;
            case T.STRB_SETTINGS_PARKSENSE_ALERTS:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setSafeParkAssist("sounddisplay");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setSafeParkAssist("sound");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setSafeParkAssist("off");
                     break;
                  default:
                     if(Peripheral.vehConfig.vehicleBrand == MASERATI_VEH_BRAND && Peripheral.vehConfig.parkAssist == "3option")
                     {
                        switch(Peripheral.personalConfig.safeParkAssist)
                        {
                           case "off":
                              Peripheral.personalConfig.setSafeParkAssist("sound");
                              break;
                           case "sound":
                              Peripheral.personalConfig.setSafeParkAssist("sounddisplay");
                              break;
                           case "sounddisplay":
                              Peripheral.personalConfig.setSafeParkAssist("off");
                        }
                     }
                     else
                     {
                        Peripheral.personalConfig.setSafeParkAssist(Peripheral.personalConfig.safeParkAssist == "sound" ? "sounddisplay" : "sound");
                     }
               }
               break;
            case T.STRB_SETTINGS_FRONT_SENSORS_ACTIVE_DRIVE:
               switch(Peripheral.personalConfig.safeFrontSensorsActiveDrive)
               {
                  case "off":
                     Peripheral.personalConfig.setSafeFrontSensorsActiveDrive("on");
                     break;
                  case "on":
                     Peripheral.personalConfig.setSafeFrontSensorsActiveDrive("off");
               }
               break;
            case T.STRB_SETTINGS_FRNT_PARKSENSE_VOL:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setFrontParkAssistChimeVolume("high");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setFrontParkAssistChimeVolume("medium");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setFrontParkAssistChimeVolume("low");
                     break;
                  default:
                     switch(Peripheral.personalConfig.frontParkAssistChimeVolume)
                     {
                        case "low":
                           Peripheral.personalConfig.setFrontParkAssistChimeVolume("medium");
                           break;
                        case "medium":
                           Peripheral.personalConfig.setFrontParkAssistChimeVolume("high");
                           break;
                        case "high":
                           Peripheral.personalConfig.setFrontParkAssistChimeVolume("low");
                     }
               }
               break;
            case T.STRB_SETTINGS_REAR_PARKSENSE_VOL:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setRearParkAssistChimeVolume("high");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setRearParkAssistChimeVolume("medium");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setRearParkAssistChimeVolume("low");
                     break;
                  default:
                     switch(Peripheral.personalConfig.rearParkAssistChimeVolume)
                     {
                        case "low":
                           Peripheral.personalConfig.setRearParkAssistChimeVolume("medium");
                           break;
                        case "medium":
                           Peripheral.personalConfig.setRearParkAssistChimeVolume("high");
                           break;
                        case "high":
                           Peripheral.personalConfig.setRearParkAssistChimeVolume("low");
                     }
               }
               break;
            case T.STRB_SETTINGS_PARKSENSE_BRAKING_ASSIST:
               Peripheral.personalConfig.setRearParkAssistBraking(!Peripheral.personalConfig.rearParkAssistBraking);
               break;
            case T.STRB_SETTINGS_TILT_MIRRORS_IN_REVERSE:
               Peripheral.personalConfig.setSafeTiltMirror(!Peripheral.personalConfig.safeTiltMirror);
               break;
            case T.STRB_AUTO_FOLDING_SIDE_MIR:
               Peripheral.personalConfig.setPowerFoldingMirrors(!Peripheral.personalConfig.powerFoldingMirrors);
               break;
            case T.STRB_SETUP_PADDLE_SHIFTERS:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setPaddlesModeStatus("enable");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setPaddlesModeStatus("disable");
                     break;
                  default:
                     switch(Peripheral.personalConfig.PaddlesModeStatus)
                     {
                        case "enable":
                           Peripheral.personalConfig.setPaddlesModeStatus("disable");
                           break;
                        case "disable":
                           Peripheral.personalConfig.setPaddlesModeStatus("enable");
                     }
               }
               break;
            case T.STRB_SETTINGS_BLIND_SPOT_ALERT:
               switch(e.data.name)
               {
                  case "checkbox0":
                     Peripheral.personalConfig.setSafeBlindSpot("lightschime");
                     break;
                  case "checkbox1":
                     Peripheral.personalConfig.setSafeBlindSpot("lights");
                     break;
                  case "checkbox2":
                     Peripheral.personalConfig.setSafeBlindSpot("off");
                     break;
                  default:
                     switch(Peripheral.personalConfig.safeBlindSpot)
                     {
                        case "off":
                           Peripheral.personalConfig.setSafeBlindSpot("lights");
                           break;
                        case "lights":
                           Peripheral.personalConfig.setSafeBlindSpot("lightschime");
                           break;
                        case "lightschime":
                           Peripheral.personalConfig.setSafeBlindSpot("off");
                     }
               }
               break;
            case T.STRB_REAR_CAMERA_LOCK:
               Peripheral.personalConfig.setSafeSurroundCameraLock(!Peripheral.personalConfig.safeSurroundCameraLock);
               break;
            case T.STRB_SURROUND_VIEW_CAMERA_D:
               Peripheral.personalConfig.setSVCDelay(!Peripheral.personalConfig.SVCDelay);
               break;
            case T.STRB_SURROUND_VIEW_CAMERA_G:
               Peripheral.personalConfig.setSVCDyanmicGridLines(!Peripheral.personalConfig.SVCDyanmicGridLines);
               break;
            case T.STRB_SETTINGS_BACKUP_CAMERA_ACTIVE_GRIDLINES:
               Peripheral.personalConfig.setSafeCameraDynamicGridLines(!Peripheral.personalConfig.safeCameraDynamicGridLines);
               break;
            case T.STRB_SETTINGS_BACKUP_CAMERA_FIXED_GRIDLINES:
               Peripheral.personalConfig.setSafeCameraStaticGridLines(!Peripheral.personalConfig.safeCameraStaticGridLines);
               break;
            case T.STRB_SETTINGS_BACKUP_CAMERA_DELAY:
               Peripheral.personalConfig.setSafeBackUpCameraDelay(!Peripheral.personalConfig.safeBackUpCameraDelay);
               break;
            case T.STRB_SETTINGS_CARGO_CAMERA_GRIDLINES:
               Peripheral.personalConfig.setCHMSLCameraGuidelines(!Peripheral.personalConfig.CHMSLCameraGuidelines);
               break;
            case T.STRB_SETTINGS_RAIN_SENSING:
               Peripheral.personalConfig.setSafeAutoWiper(!Peripheral.personalConfig.safeAutoWiper);
               break;
            case T.STRB_SETTINGS_DOOR_ALERT:
               Peripheral.personalConfig.setSlidingDoorAlert(!Peripheral.personalConfig.slidingDoorAlert);
               break;
            case T.STRB_SETTINGS_HILL_ASSIST:
               Peripheral.personalConfig.setSafeHillStartAssist(!Peripheral.personalConfig.safeHillStartAssist);
               break;
            case T.STRB_KEYSENSE:
               Peripheral.keySensePinManager.KeySenseActivation();
               return;
         }
         refresh();
      }
   }
}

