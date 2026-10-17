package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenListComponent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import core.utils.Text;
   import events.GlobalEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SettingsLightsScreen extends ScreenListComponent
   {
      
      private static const MAX_AMBIENT_LIGHT_LEVEL:uint = 6;
      
      private static const MIN_AMBIENT_LIGHT_LEVEL:uint = 0;
      
      private static const MAX_HEADLIGHT_SENSITIVITY:uint = 3;
      
      private static const MIN_HEADLIGHT_SENSITIVITY:uint = 1;
      
      private const VARIANT_PRODUCT:String;
      
      private const MP4_VARIANT:String = "MP4";
      
      public function SettingsLightsScreen()
      {
         this.VARIANT_PRODUCT = Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT;
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HLOFFDELAY,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HLILLUMINATION,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HLWIPER,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AUTODIMHIGHBEAM,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.DAYTIMERUNNINGLIGHTS,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HEADLIGHTDIP,refresh,false,0,true);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.FLASHHLWITHLOCK,refresh,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh,false,0,true);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKHLSWITHWIPERS,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TKAUTOHIGHBEAMS,refresh,false,0,true);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.GREETINGLIGHTSENABLE,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.CORNERINGENABLE,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.AMBIENTLIGHTINGLEVEL,refresh,false,0,true);
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.HEADLIGHTSENSITIVITY,refresh,false,0,true);
         }
         else
         {
            Peripheral.personalConfig.addEventListener(PersonalConfigEvent.MOODLGTINTS,refresh,false,0,true);
         }
      }
      
      override protected function removeListeners() : void
      {
         Peripheral.listController.bookmark = "SettingsLightsScreen";
         super.removeListeners();
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HLOFFDELAY,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HLILLUMINATION,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HLWIPER,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AUTODIMHIGHBEAM,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.DAYTIMERUNNINGLIGHTS,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HEADLIGHTDIP,refresh);
         Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.FLASHHLWITHLOCK,refresh);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.TEEN_KEY_PRESENT,refresh);
         if(Peripheral.vehConfig.hasTeenKeyFeature)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKHLSWITHWIPERS,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.TKAUTOHIGHBEAMS,refresh);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.GREETINGLIGHTSENABLE,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.CORNERINGENABLE,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.AMBIENTLIGHTINGLEVEL,refresh);
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.HEADLIGHTSENSITIVITY,refresh);
         }
         else
         {
            Peripheral.personalConfig.removeEventListener(PersonalConfigEvent.MOODLGTINTS,refresh);
         }
      }
      
      override protected function initScreen() : void
      {
         Peripheral.listController.length = LENGTH;
         Peripheral.listController.selectedMax = LENGTH;
         Peripheral.listController.bookmark = "SettingsLightsScreen";
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
         pushBreadcrumb(new Breadcrumb(T.STRB_LIGHTS_BREADCRUMB,Breadcrumb.INERT));
         this.populate();
         super.initScreen();
      }
      
      override protected function populate() : void
      {
         contents.length = 0;
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            if(Boolean(Peripheral.vehConfig.hasAmbientLighting) && !Peripheral.vehConfig.hasAmbientDimmerSwitch)
            {
               contents.push(T.STRB_SETTINGS_AMBIENT_LIGHTING);
            }
         }
         else if(Peripheral.vehConfig.hasAmbientLighting)
         {
            contents.push(T.STRB_SETTINGS_AMBIENT_LIGHTING);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT && Boolean(Peripheral.vehConfig.hasHeadlightSensitivityLevelPresent))
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_SENSITIVITY);
         }
         if(Boolean(Peripheral.vehConfig.hasHeadlampOffDelay) || this.VARIANT_PRODUCT == this.MP4_VARIANT)
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_DELAY);
         }
         if(Peripheral.vehConfig.hasIlluminatedApproach)
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_APPROACH);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT && Boolean(Peripheral.vehConfig.hasGreetingLights))
         {
            contents.push(T.STRB_SETTINGS_GREETING_LIGHTS);
         }
         if(Peripheral.vehConfig.hasAutoHeadLamp)
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_WIPERS);
         }
         if(Peripheral.vehConfig.hasAutoHighBeams)
         {
            contents.push(T.STRB_SETTINGS_AUTO_HIGH_BEAMS);
         }
         if(Peripheral.vehConfig.hasDayTimeRunningLights)
         {
            contents.push(T.STRB_SETTINGS_RUNNING_LIGHTS);
         }
         if(Peripheral.vehConfig.hasAdvancedFrontLightSystem)
         {
            contents.push(T.STRB_SETTINGS_DIRECTED_HEADLIGHTS);
         }
         if(this.VARIANT_PRODUCT == this.MP4_VARIANT && Boolean(Peripheral.vehConfig.hasCorneringLights))
         {
            contents.push(T.STRB_SETTINGS_CORNERING_LIGHTS);
         }
         if(Peripheral.vehConfig.hasHeadLampDip)
         {
            contents.push(T.STRB_SETTINGS_HEADLIGHT_DIL);
         }
         if(Peripheral.vehConfig.hasFlashLampsWithLock)
         {
            contents.push(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK);
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
               case T.STRB_SETTINGS_AMBIENT_LIGHTING:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_AMBIENT_LIGHTING;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AMBIENT_LIGHTING));
                  if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
                  {
                     label(item.incrementer.label,Peripheral.personalConfig.ambientLightingLevel);
                     item.incrementer.positive.setEnabled(this.itemEnablePermitted && Number(Peripheral.personalConfig.ambientLightingLevel) < MAX_AMBIENT_LIGHT_LEVEL);
                     item.incrementer.negative.setEnabled(this.itemEnablePermitted && Number(Peripheral.personalConfig.ambientLightingLevel) > MIN_AMBIENT_LIGHT_LEVEL);
                  }
                  else
                  {
                     label(item.incrementer.label,Peripheral.personalConfig.moodLightingInts == "off" ? "0" : Peripheral.personalConfig.moodLightingInts);
                     item.incrementer.positive.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.moodLightingInts != "6");
                     item.incrementer.negative.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.moodLightingInts != "off");
                  }
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_SENSITIVITY:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_HEADLIGHT_SENSITIVITY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_SENSITIVITY));
                  label(item.incrementer.label,Peripheral.personalConfig.headlightSensitivityLevel.toString());
                  item.incrementer.positive.setEnabled(this.itemEnablePermitted && uint(Peripheral.personalConfig.headlightSensitivityLevel) < MAX_HEADLIGHT_SENSITIVITY);
                  item.incrementer.negative.setEnabled(this.itemEnablePermitted && uint(Peripheral.personalConfig.headlightSensitivityLevel) > MIN_HEADLIGHT_SENSITIVITY);
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_DELAY:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_HEADLIGHT_DELAY;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_DELAY));
                  label(item.incrementer.label,Text.compose([Peripheral.personalConfig.headLightOffDelay + "\n",T.STRB_SECOND_ABBREVIATION]));
                  item.incrementer.positive.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.headLightOffDelay != 90);
                  item.incrementer.negative.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.headLightOffDelay != 0);
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_APPROACH:
                  configure(item,TYPE_INCREMENT);
                  item.id = T.STRB_SETTINGS_HEADLIGHT_APPROACH;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_APPROACH));
                  label(item.incrementer.label,Text.compose([Peripheral.personalConfig.headLightIllumination + "\n",T.STRB_SECOND_ABBREVIATION]));
                  item.incrementer.positive.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.headLightIllumination != 90);
                  item.incrementer.negative.setEnabled(this.itemEnablePermitted && Peripheral.personalConfig.headLightIllumination != 0);
                  break;
               case T.STRB_SETTINGS_GREETING_LIGHTS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_GREETING_LIGHTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_GREETING_LIGHTS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.greetingLightsEnable);
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_WIPERS:
                  configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKHLsWithWipers) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_HEADLIGHT_WIPERS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_WIPERS));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKHLsWithWipers))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.TKHLsWithWipers);
                  }
                  else
                  {
                     item.setEnabled(this.itemEnablePermitted);
                     item.checkbox0.setEnabled(this.itemEnablePermitted);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.headLightsWiper);
                  }
                  break;
               case T.STRB_SETTINGS_AUTO_HIGH_BEAMS:
                  configure(item,TYPE_CHECK1,Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKAutoHighBeams) ? "keysense" : "");
                  item.id = T.STRB_SETTINGS_AUTO_HIGH_BEAMS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_AUTO_HIGH_BEAMS));
                  if(Boolean(Peripheral.vehicleStatus.TeenKeyIsPresent) && Boolean(Peripheral.vehConfig.hasTKAutoHighBeams))
                  {
                     item.setEnabled(false);
                     item.checkbox0.setEnabled(false);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.TKAutoHighBeams);
                  }
                  else
                  {
                     item.setEnabled(this.itemEnablePermitted);
                     item.checkbox0.setEnabled(this.itemEnablePermitted);
                     item.checkbox0.setHighlight(Peripheral.personalConfig.autoDimHighBeams);
                  }
                  break;
               case T.STRB_SETTINGS_RUNNING_LIGHTS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_RUNNING_LIGHTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_RUNNING_LIGHTS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.dayTimeRunningLights);
                  break;
               case T.STRB_SETTINGS_DIRECTED_HEADLIGHTS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_DIRECTED_HEADLIGHTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_DIRECTED_HEADLIGHTS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.steeringDirectedLights);
                  break;
               case T.STRB_SETTINGS_CORNERING_LIGHTS:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_CORNERING_LIGHTS;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_CORNERING_LIGHTS));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.corneringEnable);
                  break;
               case T.STRB_SETTINGS_HEADLIGHT_DIL:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_HEADLIGHT_DIL;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_HEADLIGHT_DIL));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.headLightDip);
                  break;
               case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK:
                  configure(item,TYPE_CHECK1);
                  item.id = T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK;
                  label(item.label,Peripheral.localeEngine.getText(T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK));
                  item.checkbox0.setHighlight(Peripheral.personalConfig.flashHeadLightsWithLock);
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
            case T.STRB_SETTINGS_AMBIENT_LIGHTING:
               if(this.VARIANT_PRODUCT == this.MP4_VARIANT)
               {
                  switch(e.data.name)
                  {
                     case "negative":
                        this.setInteriorAmbientLightDelta(-1);
                        break;
                     case "positive":
                        this.setInteriorAmbientLightDelta(1);
                        break;
                     case "haptic":
                        Peripheral.listController.petrify(e.data);
                  }
                  refresh();
               }
               else
               {
                  switch(e.data.name)
                  {
                     case "negative":
                        this.setInteriorLightingDelta(-1);
                        break;
                     case "positive":
                        this.setInteriorLightingDelta(1);
                        break;
                     case "haptic":
                        Peripheral.listController.petrify(e.data);
                  }
               }
               break;
            case T.STRB_SETTINGS_HEADLIGHT_SENSITIVITY:
               switch(e.data.name)
               {
                  case "negative":
                     this.setHeadLightSensitivityDelta(-1);
                     break;
                  case "positive":
                     this.setHeadLightSensitivityDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               refresh();
               break;
            case T.STRB_SETTINGS_HEADLIGHT_DELAY:
               switch(e.data.name)
               {
                  case "negative":
                     this.setHLOffDelayDelta(-1);
                     break;
                  case "positive":
                     this.setHLOffDelayDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_HEADLIGHT_APPROACH:
               switch(e.data.name)
               {
                  case "negative":
                     this.setHeadlightApproachDelta(-1);
                     break;
                  case "positive":
                     this.setHeadlightApproachDelta(1);
                     break;
                  case "haptic":
                     Peripheral.listController.petrify(e.data);
               }
               break;
            case T.STRB_SETTINGS_GREETING_LIGHTS:
               Peripheral.personalConfig.setGreetingLightsEnable(!Peripheral.personalConfig.greetingLightsEnable);
               refresh();
               break;
            case T.STRB_SETTINGS_HEADLIGHT_WIPERS:
               Peripheral.personalConfig.setHeadLightsWiper(!Peripheral.personalConfig.headLightsWiper);
               refresh();
               break;
            case T.STRB_SETTINGS_AUTO_HIGH_BEAMS:
               Peripheral.personalConfig.setAutoDimHighBeams(!Peripheral.personalConfig.autoDimHighBeams);
               refresh();
               break;
            case T.STRB_SETTINGS_RUNNING_LIGHTS:
               Peripheral.personalConfig.setDayTimeRunningLights(!Peripheral.personalConfig.dayTimeRunningLights);
               refresh();
               break;
            case T.STRB_SETTINGS_DIRECTED_HEADLIGHTS:
               Peripheral.personalConfig.setSteeringDirectedLights(!Peripheral.personalConfig.steeringDirectedLights);
               refresh();
               break;
            case T.STRB_SETTINGS_CORNERING_LIGHTS:
               Peripheral.personalConfig.setCorneringEnable(!Peripheral.personalConfig.corneringEnable);
               refresh();
               break;
            case T.STRB_SETTINGS_HEADLIGHT_DIL:
               Peripheral.personalConfig.setHeadLightDip(!Peripheral.personalConfig.headLightDip);
               refresh();
               break;
            case T.STRB_SETTINGS_FLASH_LIGHTS_WITH_LOCK:
               Peripheral.personalConfig.setFlashHeadLightsWithLock(!Peripheral.personalConfig.flashHeadLightsWithLock);
               refresh();
         }
      }
      
      private function setInteriorLightingDelta(delta:int) : void
      {
         var intensity:String = Peripheral.personalConfig.moodLightingInts;
         switch(intensity)
         {
            case "off":
               if(delta == 1)
               {
                  intensity = "1";
               }
               break;
            case "1":
               if(delta == 1)
               {
                  intensity = "2";
               }
               else
               {
                  intensity = "off";
               }
               break;
            case "2":
               if(delta == 1)
               {
                  intensity = "3";
               }
               else
               {
                  intensity = "1";
               }
               break;
            case "3":
               if(delta == 1)
               {
                  intensity = "4";
               }
               else
               {
                  intensity = "2";
               }
               break;
            case "4":
               if(delta == 1)
               {
                  intensity = "5";
               }
               else
               {
                  intensity = "3";
               }
               break;
            case "5":
               if(delta == 1)
               {
                  intensity = "6";
               }
               else
               {
                  intensity = "4";
               }
               break;
            case "6":
               if(delta == -1)
               {
                  intensity = "5";
               }
         }
         Peripheral.personalConfig.setMoodLightingInts(intensity);
      }
      
      private function setInteriorAmbientLightDelta(delta:int) : void
      {
         var level:int = Number(Peripheral.personalConfig.ambientLightingLevel);
         if(level + delta < MAX_AMBIENT_LIGHT_LEVEL || level + delta > MIN_AMBIENT_LIGHT_LEVEL)
         {
            level += delta;
            Peripheral.personalConfig.setAmbientLightingLevel(String(level));
         }
      }
      
      private function setHLOffDelayDelta(delta:int) : void
      {
         var delay:int = int(Peripheral.personalConfig.headLightOffDelay);
         delay += delta * 30;
         if(delay < 0)
         {
            delay += 120 * 1000;
         }
         delay %= 120;
         Peripheral.personalConfig.setHeadLightOffDelay(delay);
      }
      
      private function setHeadlightApproachDelta(delta:int) : void
      {
         var delay:int = int(Peripheral.personalConfig.headLightIllumination);
         delay += delta * 30;
         if(delay < 0)
         {
            delay += 120 * 1000;
         }
         delay %= 120;
         Peripheral.personalConfig.setHeadLightIllumination(delay);
      }
      
      private function setHeadLightSensitivityDelta(delta:int) : void
      {
         var level:int = int(Peripheral.personalConfig.headlightSensitivityLevel);
         level += delta;
         Peripheral.personalConfig.headlightSensitivityLevel = level;
      }
      
      private function get itemEnablePermitted() : Boolean
      {
         return !(this.VARIANT_PRODUCT == this.MP4_VARIANT && Peripheral.antiTheft.powerModeState == "timed" || Peripheral.antiTheft.ignitionState == "accessory");
      }
   }
}

