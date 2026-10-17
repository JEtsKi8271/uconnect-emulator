package com.harman.navigation.voiceGuidance
{
   import com.harman.moduleLinkAPI.AudioMixerManagerEvent;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.Language;
   import com.harman.navigation.enums.UnitSystem;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceEventDispatcherEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.TextToSpeechEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class VoiceGuidanceManager
   {
      
      private static const LANGUAGE_CHANGE_TIME:int = 3000;
      
      private static const ADA_REPEAT_BURST_COOLDOWN:int = 1000;
      
      private var mNavService:Navigation;
      
      private var mSpeaking:Boolean = false;
      
      private var mTriggerRepeatWhenTtsAvailable:Boolean = false;
      
      private var mActiveAudioSource:int = 0;
      
      private var localAdaEnabled:Boolean = true;
      
      private var localSpeedWarningsEnabled:Boolean = false;
      
      private var localSpeedWarningsSpeed:Number = 0;
      
      private var localMetricSystem:int = -1;
      
      private var localSafetyCameraMode:int = 0;
      
      private var localLanguageCurrent:int = 0;
      
      private var localLanguageRequested:int = -1;
      
      private var localLanguageRequestedPending:int = -1;
      
      private var localLanguageChangeInProgress:Boolean = false;
      
      private var localTempLanguageChangeTimer:Timer = null;
      
      private var localAdaRepeatBurstCooldown:Boolean = false;
      
      private var localAdaRepeatBurstTimer:Timer = null;
      
      public function VoiceGuidanceManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.init();
      }
      
      private function init() : void
      {
         this.mNavService.sendSubscribe("\"ADA_PromptReady\"");
         this.mNavService.sendSubscribe("\"ADA_ActiveAudioSource\"");
         this.mNavService.sendSubscribe("\"ADA_IsEnabled\"");
         this.mNavService.sendSubscribe("\"ETC_LanguageInfo\"");
         this.localTempLanguageChangeTimer = new Timer(LANGUAGE_CHANGE_TIME,1);
         this.localTempLanguageChangeTimer.addEventListener(TimerEvent.TIMER,this.onLanguageChangeTrigger,false,0,true);
         this.localAdaRepeatBurstTimer = new Timer(ADA_REPEAT_BURST_COOLDOWN,1);
         this.localAdaRepeatBurstTimer.addEventListener(TimerEvent.TIMER,this.onAdaRepeatBurstTimerTrigger,false,0,true);
         NavigationPackage.peripheral.audioMixerManager.addEventListener(AudioMixerManagerEvent.AMM_INFORMATION_REQUEST_GRANTED,this.onAudioGranted,false,0,true);
         NavigationPackage.peripheral.audioMixerManager.addEventListener(AudioMixerManagerEvent.AMM_ABORT_NAV_AUDIO_INTERUPT,this.onAudioInterupt,false,0,true);
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.addEventListener(VServiceEventDispatcherEvent.GLOBAL_UNIT_SYSTEM,this.onUnitChange,false,0,true);
         VServiceGlobalSettings.getUnitSystem();
         NavigationPackage.peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.LANGUAGE,this.onSystemLanguageChange,false,0,true);
         NavigationPackage.peripheral.vehicleStatus.getLanguage();
         NavigationPackage.peripheral.textToSpeach.addEventListener(TextToSpeechEvent.AVAILABLE_STATE,this.onTtsAvailable,false,0,true);
         NavigationPackage.peripheral.textToSpeach.requestAvailable();
      }
      
      public function onPromptReady(resp:Object) : void
      {
         if(resp.hasOwnProperty("ADA_PromptReady"))
         {
            if(resp.ADA_PromptReady.hasOwnProperty("source"))
            {
               this.mActiveAudioSource = int(resp.ADA_PromptReady.source);
            }
            if(!this.mSpeaking)
            {
               if(NavigationPackage.peripheral.textToSpeach.available == true)
               {
                  Framework.Trace("VoiceGuidanceManager.requestInformationSource");
                  NavigationPackage.peripheral.audioMixerManager.requestInformationSource("nav",true);
               }
               else
               {
                  Framework.Trace("VoiceGuidanceManager.requestInformationSource blocked due to TTS available=" + NavigationPackage.peripheral.textToSpeach.available);
                  this.mTriggerRepeatWhenTtsAvailable = true;
               }
            }
         }
         else if(resp.hasOwnProperty("ADA_ActiveAudioSource"))
         {
            this.mActiveAudioSource = resp.ADA_ActiveAudioSource.audioSource;
            if(resp.ADA_ActiveAudioSource.audioSource == 0)
            {
               this.mSpeaking = false;
               NavigationPackage.peripheral.audioMixerManager.releaseInformationSource("nav");
            }
         }
         else if(resp.hasOwnProperty("ADA_IsEnabled"))
         {
         }
      }
      
      private function onTtsAvailable(e:TextToSpeechEvent) : void
      {
         if(this.mTriggerRepeatWhenTtsAvailable && Boolean(NavigationPackage.peripheral.textToSpeach.available))
         {
            Framework.Trace("VoiceGuidanceManager.onTtsAvailable() -> repeat()");
            this.mTriggerRepeatWhenTtsAvailable = false;
            this.sendAdaRepeat();
         }
         if(NavigationPackage.peripheral.textToSpeach.available)
         {
            NavigationPackage.peripheral.textToSpeach.setTTsDomainParams(NavigationPackage.peripheral.vehicleStatus.language);
         }
      }
      
      private function onAudioGranted(e:AudioMixerManagerEvent) : void
      {
         if(!this.mSpeaking)
         {
            this.mSpeaking = true;
            this.mNavService.sendCommand("\"ADA_PromptReady\":{\"source\":" + this.mActiveAudioSource + "}");
         }
      }
      
      private function onAudioInterupt(e:AudioMixerManagerEvent) : void
      {
         if(this.mSpeaking)
         {
            this.mSpeaking = false;
         }
         this.mNavService.sendCommand("\"ADA_PromptCancel\":{}");
         NavigationPackage.peripheral.audioMixerManager.releaseInformationSource("nav");
      }
      
      public function onUnitChange(e:VServiceEventDispatcherEvent) : void
      {
         if(this.localMetricSystem != VServiceGlobalSettings.distanceUnits)
         {
            this.localMetricSystem = VServiceGlobalSettings.distanceUnits;
            this.sendUnitChange();
         }
      }
      
      public function sendUnitChange() : void
      {
         switch(VServiceGlobalSettings.distanceUnits)
         {
            case VServiceGlobalSettings.UNIT_SYSTEM_IMPERIAL:
               this.mNavService.sendCommand("\"ETC_SetMetricSystem\":{ \"metricSystem\":" + UnitSystem.IMPERIAL + "}");
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_METRIC:
               this.mNavService.sendCommand("\"ETC_SetMetricSystem\":{ \"metricSystem\":" + UnitSystem.METRIC + "}");
               break;
            case VServiceGlobalSettings.UNIT_SYSTEM_US:
            default:
               this.mNavService.sendCommand("\"ETC_SetMetricSystem\":{ \"metricSystem\":" + UnitSystem.US + "}");
         }
      }
      
      public function adaRepeat() : void
      {
         if(!this.localAdaRepeatBurstCooldown)
         {
            this.sendAdaRepeat();
            this.localAdaRepeatBurstCooldown = true;
            this.localAdaRepeatBurstTimer.reset();
            this.localAdaRepeatBurstTimer.start();
         }
      }
      
      private function onAdaRepeatBurstTimerTrigger(e:TimerEvent) : void
      {
         this.localAdaRepeatBurstCooldown = false;
      }
      
      private function sendAdaRepeat() : void
      {
         if(!this.localLanguageChangeInProgress)
         {
            if(this.adaGetState() && NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
            {
               this.mNavService.sendCommand("\"ADA_Repeat\":{}");
            }
         }
         else
         {
            Framework.Trace("Nav.VoiceGuidanceManager.sendAdaRepeat() blocked due to pending language change!");
         }
      }
      
      public function getAdaState() : void
      {
         this.mNavService.sendEvent(NavigationEvent.NAV_ADA_ENABLED);
      }
      
      public function adaGetState() : Boolean
      {
         return this.localAdaEnabled;
      }
      
      public function setAdaState(enable:Boolean, saveToPersistence:Boolean = true) : void
      {
         var message:String = null;
         this.localAdaEnabled = enable;
         Framework.Trace("Navigation: setADA_SetEnabled: " + enable.toString());
         this.mNavService.sendCommand("\"ADA_SetEnabled\":{\"enable\":" + this.localAdaEnabled.toString() + "}");
         if(saveToPersistence)
         {
            this.mNavService.savePersistence();
         }
         this.mNavService.sendEvent(NavigationEvent.NAV_ADA_ENABLED);
      }
      
      public function adaGetSpeaking() : Boolean
      {
         return this.mSpeaking;
      }
      
      public function adaPlayPrompt(prompt:int) : void
      {
         this.mNavService.sendCommand("\"ADA_PlayPrompt\":{\"prompt\":" + prompt + "}");
      }
      
      public function get languageChangeInProgress() : Boolean
      {
         return this.localLanguageChangeInProgress;
      }
      
      public function navGetSpeedWarningEnabled() : void
      {
         this.mNavService.sendEvent(NavigationEvent.NAV_SPEED_WARNINGS);
      }
      
      public function get navSpeedWarningEnabled() : Boolean
      {
         return this.localSpeedWarningsEnabled;
      }
      
      public function get navSpeedWarningSpeedLimit() : Number
      {
         return this.localSpeedWarningsSpeed;
      }
      
      public function setSpeedWarningsEnabled(enable:Boolean) : void
      {
         this.localSpeedWarningsEnabled = enable;
         this.updateWarningSetting();
         this.mNavService.savePersistence();
      }
      
      public function setSpeedWarningsSpeedLimit(kmh:Number) : void
      {
         this.localSpeedWarningsSpeed = kmh;
         this.updateWarningSetting();
         this.mNavService.savePersistence();
      }
      
      public function setSpeedWarningsSettings(enable:Boolean, kmh:Number, saveToPersistence:Boolean = true) : void
      {
         this.localSpeedWarningsEnabled = enable;
         this.localSpeedWarningsSpeed = kmh;
         this.updateWarningSetting();
         if(saveToPersistence)
         {
            this.mNavService.savePersistence();
         }
      }
      
      private function updateWarningSetting() : void
      {
         this.mNavService.sendCommand("\"ETC_SetVehicleSpeedWarningMode\":{\"mode\":" + (this.localSpeedWarningsEnabled == true ? "1" : "0") + ", \"speed\":" + int(this.localSpeedWarningsSpeed) + "}");
         this.mNavService.sendEvent(NavigationEvent.NAV_SPEED_WARNINGS);
      }
      
      public function get currentLanguage() : int
      {
         return this.localLanguageCurrent;
      }
      
      private function onSystemLanguageChange(e:VehicleStatusEvent) : void
      {
         Framework.Trace("Nav.VoiceGuidanceManager.onSystemLanguageChange( " + NavigationPackage.peripheral.vehicleStatus.language + " )");
         switch(NavigationPackage.peripheral.vehicleStatus.language)
         {
            case "ar_AE":
               this.sendLanguage(Language.LangArabic);
               break;
            case "it_IT":
               this.sendLanguage(Language.LangItalian);
               break;
            case "fr_FR":
               this.sendLanguage(Language.LangFrench);
               break;
            case "en_GB":
               this.sendLanguage(Language.LangEngGB);
               break;
            case "es_ES":
               this.sendLanguage(Language.LangSpanish);
               break;
            case "pt_PT":
               this.sendLanguage(Language.LangPortuguese);
               break;
            case "de_DE":
               this.sendLanguage(Language.LangGerman);
               break;
            case "nl_NL":
               this.sendLanguage(Language.LangNetherlands);
               break;
            case "pt_BR":
               if(NavigationPackage.peripheral.vehConfig.variantMarket == "ROW")
               {
                  this.sendLanguage(Language.LangBrazilianPortuguese);
               }
               else
               {
                  this.sendLanguage(Language.LangPortuguese);
               }
               break;
            case "pl_PL":
               this.sendLanguage(Language.LangPolish);
               break;
            case "tr_TR":
               this.sendLanguage(Language.LangTurkish);
               break;
            case "ru_RU":
               this.sendLanguage(Language.LangRussian);
               break;
            case "en_US":
               this.sendLanguage(Language.LangEngUS);
               break;
            case "es_MX":
               this.sendLanguage(Language.LangSpanishUS);
               break;
            case "fr_CA":
               this.sendLanguage(Language.LangFrenchCanadian);
               break;
            case "ja_JP":
               this.sendLanguage(Language.LangJapanese);
               break;
            case "ko_KR":
               this.sendLanguage(Language.LangKorean);
               break;
            case "zh_CN":
               this.sendLanguage(Language.LangChineseSimple);
               break;
            default:
               this.sendLanguage(Language.LangEngUS);
         }
      }
      
      private function sendLanguage(id:int) : void
      {
         if(this.localLanguageChangeInProgress)
         {
            Framework.Trace("VoiceGuidanceManager.sendLanguage( overwrite pending request (" + Language.toString(this.localLanguageRequestedPending) + " -> " + Language.toString(id) + ")");
            this.localLanguageRequestedPending = id;
         }
         else if(this.localLanguageCurrent != id)
         {
            Framework.Trace("VoiceGuidanceManager.sendLanguage( " + Language.toString(this.localLanguageCurrent) + " -> " + Language.toString(id) + " )");
            this.localLanguageRequested = id;
            this.sendLanguageChangeEvent(true);
            if(this.mSpeaking)
            {
               this.mSpeaking = false;
               this.mNavService.sendCommand("\"ADA_PromptCancel\":{}");
               this.localTempLanguageChangeTimer.reset();
               this.localTempLanguageChangeTimer.start();
            }
            else
            {
               this.requestLanguage();
            }
         }
         else
         {
            Framework.Trace(" -Sending language blocked, due to no change! (" + Language.toString(this.localLanguageCurrent) + "->" + Language.toString(id) + ")");
         }
      }
      
      private function onLanguageChangeTrigger(e:TimerEvent) : void
      {
         if(this.localLanguageRequested != -1)
         {
            this.requestLanguage();
         }
      }
      
      private function requestLanguage() : void
      {
         this.sendLanguageChangeEvent(true);
         Framework.Trace("VoiceGuidanceManager.requestLanguage (" + this.localLanguageRequested + ")");
         this.mNavService.sendCommand("\"ETC_SetLanguage\":{ \"language\":" + this.localLanguageRequested + "}");
      }
      
      public function onLanguageInfo(resp:Object) : void
      {
         if(resp.hasOwnProperty("lang"))
         {
            Framework.Trace("VoiceGuidanceManager.onLanguageInfo( " + resp.lang + " ) curr:" + this.localLanguageCurrent + " req:" + this.localLanguageRequested + " reqP:" + this.localLanguageRequestedPending);
            this.localLanguageCurrent = resp.lang;
            if(this.localLanguageCurrent != Language.LangUndef)
            {
               if(this.localLanguageCurrent == this.localLanguageRequested)
               {
                  if(this.localLanguageRequestedPending != -1)
                  {
                     this.localLanguageRequested = this.localLanguageRequestedPending;
                     this.localLanguageRequestedPending = -1;
                     this.sendLanguageChangeEvent(false);
                     this.sendLanguage(this.localLanguageRequested);
                  }
                  else
                  {
                     this.sendLanguageChangeEvent(false);
                  }
               }
               else
               {
                  Framework.Trace(" -New language does not request language! Curr:" + this.localLanguageCurrent + " Req:" + this.localLanguageRequested);
                  this.localLanguageRequestedPending = -1;
                  this.localLanguageChangeInProgress = false;
                  this.sendLanguage(this.localLanguageRequested);
               }
            }
         }
         else
         {
            Framework.Trace("VoiceGuidanceManager.onLanguageInfo( ERROR )");
         }
      }
      
      public function onSetLanguage(resp:Object) : void
      {
         if(resp.hasOwnProperty("language"))
         {
            Framework.Trace("VoiceGuidanceManager.onSetLanguage( " + resp.language + " )");
         }
         else
         {
            Framework.Trace("VoiceGuidanceManager.onSetLanguage( ERROR )");
         }
      }
      
      private function sendLanguageChangeEvent(changeInProgress:Boolean) : void
      {
         if(changeInProgress != this.localLanguageChangeInProgress)
         {
            this.localLanguageChangeInProgress = changeInProgress;
            this.mNavService.sendEvent(NavigationEvent.NAV_LANGUAGE_CHANGED);
         }
      }
      
      public function getSafetyCameraMode() : void
      {
         this.mNavService.sendEvent(NavigationEvent.NAV_SAFETY_CAMERA_MODE);
      }
      
      public function get safetyCameraMode() : int
      {
         return this.localSafetyCameraMode;
      }
      
      public function navSetSafetyCameraMode(mode:int, saveToPersistence:Boolean = true) : void
      {
         this.localSafetyCameraMode = mode;
         this.mNavService.sendCommand("\"ETC_SetSafetyCameraMode\":{\"safetyWarningMode\":" + this.localSafetyCameraMode + "}");
         this.mNavService.sendEvent(NavigationEvent.NAV_SAFETY_CAMERA_MODE);
         if(saveToPersistence)
         {
            this.mNavService.savePersistence();
         }
      }
      
      public function informSafetyCameraMode(resp:Object) : void
      {
         if(int(resp.safetyWarningMode) != this.localSafetyCameraMode)
         {
            Framework.Trace("VoiceGuidanceManager.informSafetyCameraMode() Result mismatch! (" + resp.safetyWarningMode + " / " + this.localSafetyCameraMode + ")");
         }
      }
   }
}

