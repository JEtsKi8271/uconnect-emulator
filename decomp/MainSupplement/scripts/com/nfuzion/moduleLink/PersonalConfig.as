package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.IPersonalConfig;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.span.Client;
   
   public class PersonalConfig extends Module implements IPersonalConfig
   {
      
      private static var instance:PersonalConfig;
      
      private static const dBusSetProperties:String = "setProperties";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiGetCustomUnitProperties:String = "getCustomUnitProperties";
      
      private static const dBusApiscreenTurnedOff:String = "screenTurnedOff";
      
      private const dbusIdentifier:String = "PersonalConfig";
      
      private const dbusDisplayMode:String = "displayMode";
      
      private const dbusDisplayModeSetting:String = "displayModeSetting";
      
      private const dbusMaxDisplayBrigthnessLevel:String = "maxDisplayBrightnessLevel";
      
      private const dbusDisplayBrightHlOn:String = "brightnessHeadlightsOn";
      
      private const dbusDisplayBrightHlOff:String = "brightnessHeadlightsOff";
      
      private const dbusDisplayColor:String = "color";
      
      private const dbusDisplayLang:String = "lang";
      
      private const dbusDisplayVoiceResLen:String = "voiceResLen";
      
      private const dbusDisplayTouchScreenBeep:String = "touchScreenBeep";
      
      private const dbusDisplayNavCluster:String = "navCluster";
      
      private const dbusDisplayFuelSaver:String = "fuelSaveDisp";
      
      private const dbusControlsTimeoutEnabled:String = "controlsTimeoutEnabled";
      
      private const dbusReadyToDriveStatus:String = "readyToDriveStatus";
      
      private const dbusEnablePhoneRepetition:String = "enablePhoneRepetition";
      
      private const dbusUnits:String = "units";
      
      private const dbusSpeedUnits:String = "speedUnits";
      
      private const dbusDistanceUnits:String = "distanceUnits";
      
      private const dbusFuelConsumpUnits:String = "fuelConsumpUnits";
      
      private const dbusCapacityUnits:String = "capacityUnits";
      
      private const dbusPressureUnits:String = "pressureUnits";
      
      private const dbusTemperatureUnits:String = "temperatureUnits";
      
      private const dbusHorsePowerUnits:String = "horsepowerUnits";
      
      private const dbusTorqueUnits:String = "torqueUnits";
      
      private const dbusCustomSpeedUnits:String = "CustomSpeedUnits";
      
      private const dbusCustomDistanceUnits:String = "CustomDistanceUnits";
      
      private const dbusCustomFuelConsumpUnits:String = "CustomFuelConsumpUnits";
      
      private const dbusCustomCapacityUnits:String = "CustomCapacityUnits";
      
      private const dbusCustomPressureUnits:String = "CustomPressureUnits";
      
      private const dbusCustomTemperatureUnits:String = "CustomTemperatureUnits";
      
      private const dbusCustomHorsePowerUnits:String = "CustomHorsePowerUnits";
      
      private const dbusCustomTorqueUnits:String = "CustomTorqueUnits";
      
      private const dbusTeleprompterMode:String = "teleprompterMode";
      
      private const dbusSafeFwdCollision:String = "collisionSens";
      
      private const dbusSafeFcwBrakeStatus:String = "fcwBrakeStatus";
      
      private const dbusSafeFcwSensitivitySetting:String = "fcwSensitivitySetting";
      
      private const dbusSafeFcwOnOffState:String = "fcwOnOffState";
      
      private const dbusSafeParkAssist:String = "parkAssist";
      
      private const dbusSafeFrontSensorsActiveDrive:String = "frontSensorsActiveDrive";
      
      private const dbusFrontParkAssistChimeVolume:String = "frontParkAssistChimeVol";
      
      private const dbusRearParkAssistChimeVolume:String = "rearParkAssistChimeVol";
      
      private const dbusRearParkAssistBraking:String = "rearParkAssistBraking";
      
      private const dbusSafeTiltMirror:String = "tilt";
      
      private const dbusSafeBlindSpot:String = "blindSpotAlert";
      
      private const dbusSafeBackUpCamera:String = "parkviewCam";
      
      private const dbusSafeBackUpCameraDelay:String = "parkviewCamDelay";
      
      private const dbusSafeSurroundCameraLock:String = "surroundCamLock";
      
      private const dbusSafeCamDynamicGridLines:String = "parkviewDynamicGridLines";
      
      private const dbusSafeCamStaticGridLines:String = "parkviewStaticGridLines";
      
      private const dbusSafeAutoWiper:String = "rainWipers";
      
      private const dbusSafeHillStartAssist:String = "hillAssist";
      
      private const dbusSideDistanceWarning:String = "sideDistanceWarning";
      
      private const dbusSideDistanceWarningChimeVolume:String = "sideDistanceWarningChimeVolume";
      
      private const dbusHeadLightOffDelay:String = "headlightOff";
      
      private const dbusHeadLightIllumination:String = "headlightIllum";
      
      private const dbusHeadLightsWipers:String = "headlightWiper";
      
      private const dbusAutoDimHighBeams:String = "autoDimHiBeam";
      
      private const dbusDayTimeRunningLights:String = "daytimeLights";
      
      private const dbusSteeringDirectedLights:String = "steeringLights";
      
      private const dbusHeadLightDip:String = "headlightDip";
      
      private const dbusFlashHeadLightsWithLock:String = "flashHeadlightLock";
      
      private const dbusMoodLightingInts:String = "moodLightingInts";
      
      private const dbusAmbientLightLevel:String = "ambientLightingLevel";
      
      private const dbusAutoDoorLock:String = "autoLock";
      
      private const dbusAutoUnlockOnExit:String = "autoUnlock";
      
      private const dbusFlashHlWithLock:String = "flashHeadlightLock";
      
      private const dbusSoundHornWithLock:String = "soundHornLock";
      
      private const dbusSoundHornWithLock1st2nd:String = "soundHornLock1st2nd";
      
      private const dbusSoundHornWithRemoteLock:String = "hornRemoteStart";
      
      private const dbusFirstPresskeyFob:String = "keyUnlock";
      
      private const dbusPassiveEntry:String = "passiveEntry";
      
      private const dbusPersonalSettingsFob:String = "personalSettingsLinked";
      
      private const dbusSlidingDoorAlert:String = "slidingDoorAlert";
      
      private const dbusHFSlidingDoorStatus:String = "slidingDoorStatus";
      
      private const dbusFlashLightSlideDoorStatus:String = "flashLightSlideDoorStatus";
      
      private const dbusAutoRelockPE:String = "autoRelock";
      
      private const dbusHornWithRemoteStart:String = "hornRemoteStart";
      
      private const dbusAutoOnDCS:String = "autoOnDCS";
      
      private const dbusEasyExitSeat:String = "exitSeat";
      
      private const dbusEngineOffPowerDelay:String = "engineOffDelay";
      
      private const dbusPwrOffWithDoorOpen:String = "offWithDoorOpen";
      
      private const dbusCompassVariance:String = "compassVariance";
      
      private const dbusAeroMode:String = "aeroMode";
      
      private const dbusWheelAlignment:String = "wheelAlignment";
      
      private const dbusTransportMode:String = "transportMode";
      
      private const dbusSuspensionMessagesDisplay:String = "suspensionMessages";
      
      private const dbusTireJackMode:String = "tireJackMode";
      
      private const dbusSoundHornWithRemoteLower:String = "soundHornRemoteLower";
      
      private const dbusFlashLightWithLower:String = "flashLightLower";
      
      private const dbusSuspensionEasyExit:String = "easyExitSuspension";
      
      private const dbusTrailerNum:String = "trlrNum";
      
      private const dbusBrakeStyle:String = "itbmBrkStyle";
      
      private const dbusBrakeStyle1:String = "trlr1BrkStyle";
      
      private const dbusBrakeStyle2:String = "trlr2BrkStyle";
      
      private const dbusBrakeStyle3:String = "trlr3BrkStyle";
      
      private const dbusBrakeStyle4:String = "trlr4BrkStyle";
      
      private const dbusTrailerName:String = "trlrStyle";
      
      private const dbusTrailer1Name:String = "trlr1Style";
      
      private const dbusTrailer2Name:String = "trlr2Style";
      
      private const dbusTrailer3Name:String = "trlr3Style";
      
      private const dbusTrailer4Name:String = "trlr4Style";
      
      private const dbusPwrLiftgateChime:String = "pwrLiftgateChime";
      
      private const dbusPwrLiftgateStatus:String = "pwrLiftgateStatus";
      
      private const dbusAutoParkBrake:String = "autoParkBrakeStatus";
      
      private const dbusAutoBrakeHold:String = "autoBrakeHoldStatus";
      
      private const dbusLaneDepartureWarnSetting:String = "laneDepartureWarnSetting";
      
      private const dbusLsWarnSensitivity:String = "laneSenseWarnSensitivity";
      
      private const dbusLsWarnTorgueIntensity:String = "laneSenseTorqueIntensity";
      
      private const dbusBrakeServiceStatus:String = "brakeServiceStatus";
      
      private const dbusBrakeServiceTextDisplay:String = "brakeServiceTextDisplay";
      
      private const dbusResetTripA:String = "resetTripA";
      
      private const dbusResetTripB:String = "resetTripB";
      
      private const dbusPowerSteeringMode:String = "powerSteeringMode";
      
      private const dbusPowerFoldingMirrors:String = "powerFoldingMirrors";
      
      private const dbusNavigationRepetitionEnabled:String = "navRepetitionEnabled";
      
      private const dbusHeadlightSensitivityLevel:String = "externalLightSensorLevel";
      
      private const dbusCorneringEnable:String = "corneringEnable";
      
      private const dbusGreetingLightsEnable:String = "greetingLightsEnable";
      
      private const dbusTKFCWSensitivity:String = "teenKeyFCWSensitivitySetting";
      
      private const dbusTKFCWBrakingAssist:String = "teenKeyFCWBrakingAssistStatus";
      
      private const dbusTKPTSConfiguration:String = "teenKeyPTS_ConfigStatus";
      
      private const dbusTKPTSBrakingAssist:String = "teenKeyPTS_BrakingAssistStatus";
      
      private const dbusTKPTSFrontVolume:String = "teenKeyPTS_FrontVolume";
      
      private const dbusTKPTSRearVolume:String = "teenKeyPTS_RearVolume";
      
      private const dbusTKBSMConfiguration:String = "teenKeyBSM_ConfigStatus";
      
      private const dbusTKFuelPopupStat:String = "teenKeyFuelPopupStatus";
      
      private const dbusTKFuelWarningStat:String = "teenKeyEarlyFuelWarningStatus";
      
      private const dbusTKPwrLiftgateChime:String = "teenKeyPwrLiftgateChimeStatus";
      
      private const dbusTKSlidingDoorAlert:String = "teenKeySlidingDoorAlertStatus";
      
      private const dbusTKAutoWiperStat:String = "teenKeyAutoWiperStatus";
      
      private const dbusTKHLsWithWipers:String = "teenKeyHLsWithWiperStatus";
      
      private const dbusTKAutoHighBeams:String = "teenKeyAutoHighBeamsStatus";
      
      private const dbusTKMaxSpeedLimit:String = "teenKeyMaxSpeedLimit";
      
      private const dbusSVCDynamicGridLines:String = "svcDynamicGridLines";
      
      private const dbusSVCDelay:String = "svcDelay";
      
      private const dbusPaddlesModeStatus:String = "paddlesModeStatus";
      
      private const dbusCHMSLCameraGuidelines:String = "chmslCameraGuidelines";
      
      private const dBusDnaEnable:String = "dnaEnable";
      
      private const dbusAutoSwitch:String = "autoSwitch";
      
      private const dBusScreenOff:String = "screenOff";
      
      private const dbusVideoReadBack:String = "videoReadBack";
      
      private var mDisplayMode:String = "day";
      
      private var mDisplayModeSetting:String = "auto";
      
      private var mBrightHlOn:int = 5;
      
      private var mBrightHlOff:int = 10;
      
      private var mColor:String = "bold";
      
      private var mLang:String = "english";
      
      private var mVoiceRes:String = "brief";
      
      private var mTouchScreenBeep:Boolean = false;
      
      private var mNavCluster:Boolean = false;
      
      private var mFuelSaver:Boolean = false;
      
      private var mControlsTimeoutEnabled:Boolean = true;
      
      private var mReadyToDriveStatus:Boolean = true;
      
      private var mEnablePhoneRepetition:Boolean = false;
      
      private var mTeleprompterMode:String = "always";
      
      private var mUnit:String = "us";
      
      private var mSpeedUnits:String = "mph";
      
      private var mDistanceUnits:String = "miles";
      
      private var mFuelConsumptionUnits:String = "mpg_us";
      
      private var mCapacityUnits:String = "gal_us";
      
      private var mPressureUnits:String = "psi";
      
      private var mTemperatureUnits:String = "US";
      
      private var mHorsePowerUnits:String = "hp_us";
      
      private var mTorqueUnits:String = "lb-ft";
      
      private var mCustomSpeedUnits:String = "kph";
      
      private var mCustomDistanceUnits:String = "km";
      
      private var mCustomFuelConsumpUnits:String = "kmpL";
      
      private var mCustomCapacityUnits:String = "Liters";
      
      private var mCustomPressureUnits:String = "kPa";
      
      private var mCustomTemperatureUnits:String = "METRIC";
      
      private var mCustomHorsePowerUnits:String = "kW";
      
      private var mCustomTorqueUnits:String = "Nm";
      
      private var mBrightnessMin:int = 1;
      
      private var mBrightnessMax:int = 10;
      
      private var mSafeFwdCollision:String;
      
      private var mSafeFcwSensitivitySetting:String = "off";
      
      private var mSafeFcwOnOffState:String = "off";
      
      private var mSafeFcwBrakeStatus:String;
      
      private var mSafeParkAssist:String;
      
      private var mSafeFrontSensorsActiveDrive:String = "off";
      
      private var mFrontParkAssistChimeVolume:String = "low";
      
      private var mRearParkAssistChimeVolume:String = "low";
      
      private var mRearParkAssistBraking:Boolean = false;
      
      private var mSafeTiltMirror:Boolean;
      
      private var mSafeBlindSpot:String;
      
      private var mSafeBackUpCamera:Boolean;
      
      private var mSafeBackUpCameraDelay:Boolean = false;
      
      private var mSafeCamDynamicGridLines:Boolean = true;
      
      private var mSafeCamStaticGridLines:Boolean = true;
      
      private var mSafeSurroundCameraLock:Boolean = false;
      
      private var mSafeAutoWiper:Boolean;
      
      private var mSafeHillStartAssist:Boolean;
      
      private var mPowerSteeringMode:String = "Normal";
      
      private var mPowerFoldingMirrors:Boolean = false;
      
      private var mSideDistanceWarning:String = "off";
      
      private var mSideDistanceWarningVolume:String = "low";
      
      private var mHeadLightOffDelay:int = 0;
      
      private var mHeadLightIllumination:int;
      
      private var mHeadLightsWiper:Boolean;
      
      private var mAutoDimHighBeams:Boolean;
      
      private var mDayTimeRunningLights:Boolean;
      
      private var mSteeringDirectedLights:Boolean;
      
      private var mHeadLightDip:Boolean;
      
      private var mFlashHeadLightsWithLock:Boolean;
      
      private var mMoodLightingInts:String = "off";
      
      private var mAmbientLightLevel:String = "1";
      
      private var mAutoDoorLock:Boolean;
      
      private var mAutoUnlockOnExit:Boolean;
      
      private var mFlashHlWithLock:Boolean;
      
      private var mSoundHornWithLock:Boolean;
      
      private var mSoundHornWithLock1st2nd:String = "off";
      
      private var mSoundHornWithRemoteLock:Boolean;
      
      private var mFirstPresskeyFob:String;
      
      private var mPassiveEntry:Boolean;
      
      private var mPersonalSettingsFob:Boolean;
      
      private var mSlidingDoorAlert:Boolean;
      
      private var mSlidingDoorStatus:Boolean;
      
      private var mFlashLightSlideDoorStatus:Boolean;
      
      private var mAutoRelockPE:Boolean;
      
      private var mHornWithRemoteStart:Boolean;
      
      private var mAutoOnDCS:String = "off";
      
      private var mEasyExitSeat:Boolean;
      
      private var mEngineOffPowerDelay:int = 0;
      
      private var mPwrOffWithDoorOpen:Boolean;
      
      private var mCompassVariance:int = 1;
      
      private var mTrailerSelected:int = 0;
      
      private var mBrakeType:int = -1;
      
      private var mTrailer1BrakeType:int = -1;
      
      private var mTrailer2BrakeType:int = -1;
      
      private var mTrailer3BrakeType:int = -1;
      
      private var mTrailer4BrakeType:int = -1;
      
      private var mTrailerName:String = "none";
      
      private var mTrailer1Name:String = "none";
      
      private var mTrailer2Name:String = "none";
      
      private var mTrailer3Name:String = "none";
      
      private var mTrailer4Name:String = "none";
      
      private var mAeroMode:Boolean;
      
      private var mWheelAlignment:Boolean;
      
      private var mTransportMode:Boolean;
      
      private var mSuspensionMessagesDisplay:Boolean;
      
      private var mTireJackMode:Boolean;
      
      private var mSoundHornWithRemoteLower:Boolean;
      
      private var mFlashLightWithLower:Boolean;
      
      private var mSuspensionEasyExit:Boolean;
      
      private var mPwrLiftgateChime:Boolean;
      
      private var mPwrLiftgateStatus:Boolean;
      
      private var mAutoParkBrakeStatus:String;
      
      private var mAutoBrakeHoldStatus:String;
      
      private var mLaneDepartureWarnSetting:Boolean = false;
      
      private var mLaneSenseWarnSensitivity:String;
      
      private var mLaneSenseTorqueIntensity:String;
      
      private var mBrakeServiceStatus:Boolean = false;
      
      private var mBrakeServiceTextDisplay:String = "0";
      
      private var mTripComputerAStatus:String = "noAck";
      
      private var mTripComputerBStatus:String = "noAck";
      
      private var mNavigationRepetitionEnabled:Boolean = false;
      
      private var mHeadlightSensitivityLevel:int = 0;
      
      private var mCorneringEnable:Boolean = false;
      
      private var mGreetingLightsEnable:Boolean = false;
      
      private var mDnaEnable:Boolean = false;
      
      private var mTKFCWSensitivity:String = "off";
      
      private var mTKFCWBrakingAssist:String = "off";
      
      private var mTKPTSConfiguration:String = "off";
      
      private var mTKPTSBrakingAssist:Boolean = false;
      
      private var mTKPTSFrontVolume:String = "medium";
      
      private var mTKPTSRearVolume:String = "medium";
      
      private var mTKBSMConfiguration:String = "off";
      
      private var mTKFuelPopupStat:Boolean = false;
      
      private var mTKFuelWarningStat:Boolean = false;
      
      private var mTKPwrLiftgateChime:Boolean = false;
      
      private var mTKSlidingDoorAlert:Boolean = false;
      
      private var mTKAutoWiperStat:Boolean = false;
      
      private var mTKHLsWithWipers:Boolean = false;
      
      private var mTKAutoHighBeams:Boolean = false;
      
      private var mTKMaxSpeedLimit:String = "not_set";
      
      private var mSVCDynamicGridLines:Boolean;
      
      private var mSVCDelay:Boolean;
      
      private var mPaddlesModeStatus:String = "none";
      
      private var mCHMSLCameraGuidelines:Boolean = false;
      
      private var mAutoSwitch:String = "recall_last";
      
      private var mVideoReadBack:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mPersonalConfigServiceAvailable:Boolean = false;
      
      public function PersonalConfig()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.connection.addEventListener(ConnectionEvent.PERSONALCONFIG,this.PersonalConfigMessageHandler,false,0,true);
         this.start();
      }
      
      public static function getInstance() : PersonalConfig
      {
         if(instance == null)
         {
            instance = new PersonalConfig();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case PersonalConfigEvent.DISPLAYMODE:
               this.sendSubscribe(this.dbusDisplayMode);
               break;
            case PersonalConfigEvent.DISPLAYMODESETTING:
               this.sendSubscribe(this.dbusDisplayModeSetting);
               break;
            case PersonalConfigEvent.BRIGHTHLON:
               this.sendSubscribe(this.dbusDisplayBrightHlOn);
               break;
            case PersonalConfigEvent.SIDEDISTANCEWARNING:
               this.sendSubscribe(this.dbusSideDistanceWarning);
               break;
            case PersonalConfigEvent.SIDEDISTANCEWARNINGVOL:
               this.sendSubscribe(this.dbusSideDistanceWarningChimeVolume);
               break;
            case PersonalConfigEvent.BRIGHTHLOFF:
               this.sendSubscribe(this.dbusDisplayBrightHlOff);
               break;
            case PersonalConfigEvent.COLOR:
               this.sendSubscribe(this.dbusDisplayColor);
               break;
            case PersonalConfigEvent.LANG:
               this.sendSubscribe(this.dbusDisplayLang);
               break;
            case PersonalConfigEvent.VOICERESLEN:
               this.sendSubscribe(this.dbusDisplayVoiceResLen);
               break;
            case PersonalConfigEvent.TELEPROMPTERMODE:
               this.sendSubscribe(this.dbusTeleprompterMode);
               break;
            case PersonalConfigEvent.TOUCHSCREENBEEP:
               this.sendSubscribe(this.dbusDisplayTouchScreenBeep);
               break;
            case PersonalConfigEvent.NAVCLUSTER:
               this.sendSubscribe(this.dbusDisplayNavCluster);
               break;
            case PersonalConfigEvent.FUELSAVER:
               this.sendSubscribe(this.dbusDisplayFuelSaver);
               break;
            case PersonalConfigEvent.CONTROLSTIMEOUTENABLED:
               this.sendSubscribe(this.dbusControlsTimeoutEnabled);
               break;
            case PersonalConfigEvent.RDYTODRVSTATUS:
               this.sendSubscribe(this.dbusReadyToDriveStatus);
               break;
            case PersonalConfigEvent.ENBLPHONEREP:
               this.sendSubscribe(this.dbusEnablePhoneRepetition);
               break;
            case PersonalConfigEvent.SAFEFWDCOLLISION:
               this.sendSubscribe(this.dbusSafeFwdCollision);
               break;
            case PersonalConfigEvent.SAFEFCWSENSITIVITY:
               this.sendSubscribe(this.dbusSafeFcwSensitivitySetting);
               break;
            case PersonalConfigEvent.SAFEFCWONOFFSTATE:
               this.sendSubscribe(this.dbusSafeFcwOnOffState);
               break;
            case PersonalConfigEvent.SAFEFCWBRAKESTAT:
               this.sendSubscribe(this.dbusSafeFcwBrakeStatus);
               break;
            case PersonalConfigEvent.PARKASSIST:
               this.sendSubscribe(this.dbusSafeParkAssist);
               break;
            case PersonalConfigEvent.FTSENSACTDRV:
               this.sendSubscribe(this.dbusSafeFrontSensorsActiveDrive);
               break;
            case PersonalConfigEvent.PARKASSISTALERTVOL:
               this.sendSubscribe(this.dbusFrontParkAssistChimeVolume);
               this.sendSubscribe(this.dbusRearParkAssistChimeVolume);
               break;
            case PersonalConfigEvent.PARKASSISTBRAKING:
               this.sendSubscribe(this.dbusRearParkAssistBraking);
               break;
            case PersonalConfigEvent.TILTMIRROR:
               this.sendSubscribe(this.dbusSafeTiltMirror);
               break;
            case PersonalConfigEvent.BLINDSPOT:
               this.sendSubscribe(this.dbusSafeBlindSpot);
               break;
            case PersonalConfigEvent.BACKUPCAMERA:
               this.sendSubscribe(this.dbusSafeBackUpCamera);
               break;
            case PersonalConfigEvent.BACKUPCAMERADELAY:
               this.sendSubscribe(this.dbusSafeBackUpCameraDelay);
               break;
            case PersonalConfigEvent.CAMERADYNAMICGRIDLINES:
               this.sendSubscribe(this.dbusSafeCamDynamicGridLines);
               break;
            case PersonalConfigEvent.CAMERASTATICGRIDLINES:
               this.sendSubscribe(this.dbusSafeCamStaticGridLines);
               break;
            case PersonalConfigEvent.SURROUNDCAMERALOCK:
               this.sendSubscribe(this.dbusSafeSurroundCameraLock);
               break;
            case PersonalConfigEvent.SAFEAUTOWIPER:
               this.sendSubscribe(this.dbusSafeAutoWiper);
               break;
            case PersonalConfigEvent.SAFEHILLSTARTASSIST:
               this.sendSubscribe(this.dbusSafeHillStartAssist);
               break;
            case PersonalConfigEvent.POWERSTEERINGMODE:
               this.sendSubscribe(this.dbusPowerSteeringMode);
               break;
            case PersonalConfigEvent.POWERFOLDINGMIRRORS:
               this.sendSubscribe(this.dbusPowerFoldingMirrors);
               break;
            case PersonalConfigEvent.HLOFFDELAY:
               this.sendSubscribe(this.dbusHeadLightOffDelay);
               break;
            case PersonalConfigEvent.HLILLUMINATION:
               this.sendSubscribe(this.dbusHeadLightIllumination);
               break;
            case PersonalConfigEvent.HLWIPER:
               this.sendSubscribe(this.dbusHeadLightsWipers);
               break;
            case PersonalConfigEvent.AUTODIMHIGHBEAM:
               this.sendSubscribe(this.dbusAutoDimHighBeams);
               break;
            case PersonalConfigEvent.DAYTIMERUNNINGLIGHTS:
               this.sendSubscribe(this.dbusDayTimeRunningLights);
               break;
            case PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT:
               this.sendSubscribe(this.dbusSteeringDirectedLights);
               break;
            case PersonalConfigEvent.HEADLIGHTDIP:
               this.sendSubscribe(this.dbusHeadLightDip);
               break;
            case PersonalConfigEvent.FLASHHLWITHLOCK:
               this.sendSubscribe(this.dbusFlashHeadLightsWithLock);
               break;
            case PersonalConfigEvent.MOODLGTINTS:
               this.sendSubscribe(this.dbusMoodLightingInts);
               break;
            case PersonalConfigEvent.AMBIENTLIGHTINGLEVEL:
               this.sendSubscribe(this.dbusAmbientLightLevel);
               break;
            case PersonalConfigEvent.AUTODOORLOCK:
               this.sendSubscribe(this.dbusAutoDoorLock);
               break;
            case PersonalConfigEvent.AUTOUNLOCKEXIT:
               this.sendSubscribe(this.dbusAutoUnlockOnExit);
               break;
            case PersonalConfigEvent.FLASHHLWITHLOCK:
               this.sendSubscribe(this.dbusFlashHlWithLock);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHLOCK:
               this.sendSubscribe(this.dbusSoundHornWithLock);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHLOCK1ST2ND:
               this.sendSubscribe(this.dbusSoundHornWithLock1st2nd);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHREMOTELOCK:
               this.sendSubscribe(this.dbusSoundHornWithRemoteLock);
               break;
            case PersonalConfigEvent.FIRSTPRESSKEYFOB:
               this.sendSubscribe(this.dbusFirstPresskeyFob);
               break;
            case PersonalConfigEvent.PASSIVEENTRY:
               this.sendSubscribe(this.dbusPassiveEntry);
               break;
            case PersonalConfigEvent.PERSONALSETTINGSFOB:
               this.sendSubscribe(this.dbusPersonalSettingsFob);
               break;
            case PersonalConfigEvent.SLIDINGDOORALERT:
               this.sendSubscribe(this.dbusSlidingDoorAlert);
               break;
            case PersonalConfigEvent.HFSLIDINGDOORSTAT:
               this.sendSubscribe(this.dbusHFSlidingDoorStatus);
               break;
            case PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT:
               this.sendSubscribe(this.dbusFlashLightSlideDoorStatus);
               break;
            case PersonalConfigEvent.AUTORELOCKPE:
               this.sendSubscribe(this.dbusAutoRelockPE);
               break;
            case PersonalConfigEvent.HORNREMOTESTART:
               this.sendSubscribe(this.dbusHornWithRemoteStart);
               break;
            case PersonalConfigEvent.AUTOONDCS:
               this.sendSubscribe(this.dbusAutoOnDCS);
               break;
            case PersonalConfigEvent.EXITSEAT:
               this.sendSubscribe(this.dbusEasyExitSeat);
               break;
            case PersonalConfigEvent.ENGINEOFFDELAY:
               this.sendSubscribe(this.dbusEngineOffPowerDelay);
               break;
            case PersonalConfigEvent.PWROFFWITHDOOROPEN:
               this.sendSubscribe(this.dbusPwrOffWithDoorOpen);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHREMOTELOWER:
               this.sendSubscribe(this.dbusSoundHornWithRemoteLower);
               break;
            case PersonalConfigEvent.FLASHLIGHTWITHLOWER:
               this.sendSubscribe(this.dbusFlashLightWithLower);
               break;
            case PersonalConfigEvent.TIREJACKMODE:
               this.sendSubscribe(this.dbusTireJackMode);
               break;
            case PersonalConfigEvent.SUSPENSIONMSGDISP:
               this.sendSubscribe(this.dbusSuspensionMessagesDisplay);
               break;
            case PersonalConfigEvent.TRANSPORTMODE:
               this.sendSubscribe(this.dbusTransportMode);
               break;
            case PersonalConfigEvent.WHEELALIGNMENT:
               this.sendSubscribe(this.dbusWheelAlignment);
               break;
            case PersonalConfigEvent.AEROMODE:
               this.sendSubscribe(this.dbusAeroMode);
               break;
            case PersonalConfigEvent.SUSPENSIONEASYEXIT:
               this.sendSubscribe(this.dbusSuspensionEasyExit);
               break;
            case PersonalConfigEvent.TRAILERSELECTED:
               this.sendSubscribe(this.dbusTrailerNum);
               break;
            case PersonalConfigEvent.TRAILERBRAKETYPE:
               this.sendSubscribe(this.dbusBrakeStyle);
               break;
            case PersonalConfigEvent.TRAILERNAME:
               this.sendSubscribe(this.dbusTrailerName);
               break;
            case PersonalConfigEvent.PWRLIFTGATECHIME:
               this.sendSubscribe(this.dbusPwrLiftgateChime);
               break;
            case PersonalConfigEvent.HANDSFREELIFTGATE:
               this.sendSubscribe(this.dbusPwrLiftgateStatus);
               break;
            case PersonalConfigEvent.AUTOPARKBRAKE:
               this.sendSubscribe(this.dbusAutoParkBrake);
               break;
            case PersonalConfigEvent.AUTOHOLDBRAKE:
               this.sendSubscribe(this.dbusAutoBrakeHold);
               break;
            case PersonalConfigEvent.LDWARNSETTING:
               this.sendSubscribe(this.dbusLaneDepartureWarnSetting);
               break;
            case PersonalConfigEvent.LSWARNSENSITIVITY:
               this.sendSubscribe(this.dbusLsWarnSensitivity);
               break;
            case PersonalConfigEvent.LSTORQUEINTENSITY:
               this.sendSubscribe(this.dbusLsWarnTorgueIntensity);
               break;
            case PersonalConfigEvent.BRAKESERVICESTATUS:
               this.sendSubscribe(this.dbusBrakeServiceStatus);
               break;
            case PersonalConfigEvent.BRAKESERVICETEXTDISPLAY:
               this.sendSubscribe(this.dbusBrakeServiceTextDisplay);
               break;
            case PersonalConfigEvent.TRIP_COMPUTER_A:
               this.sendSubscribe(this.dbusResetTripA);
               break;
            case PersonalConfigEvent.TRIP_COMPUTER_B:
               this.sendSubscribe(this.dbusResetTripB);
               break;
            case PersonalConfigEvent.NAV_REPETITION_ENABLE:
               this.sendSubscribe(this.dbusNavigationRepetitionEnabled);
               break;
            case PersonalConfigEvent.HEADLIGHTSENSITIVITY:
               this.sendSubscribe(this.dbusHeadlightSensitivityLevel);
               break;
            case PersonalConfigEvent.CORNERINGENABLE:
               this.sendSubscribe(this.dbusCorneringEnable);
               break;
            case PersonalConfigEvent.GREETINGLIGHTSENABLE:
               this.sendSubscribe(this.dbusGreetingLightsEnable);
               break;
            case PersonalConfigEvent.DNAENABLE:
               this.sendSubscribe(this.dBusDnaEnable);
               break;
            case PersonalConfigEvent.TKFCWSENSITIVITY:
               this.sendSubscribe(this.dbusTKFCWSensitivity);
               break;
            case PersonalConfigEvent.TKFCWBRAKEASSIST:
               this.sendSubscribe(this.dbusTKFCWBrakingAssist);
               break;
            case PersonalConfigEvent.TKPARKASSISTCONFIG:
               this.sendSubscribe(this.dbusTKPTSConfiguration);
               break;
            case PersonalConfigEvent.TKPARKASSISTBRAKING:
               this.sendSubscribe(this.dbusTKPTSBrakingAssist);
               break;
            case PersonalConfigEvent.TKPARKASSISTFTVOLUME:
               this.sendSubscribe(this.dbusTKPTSFrontVolume);
               break;
            case PersonalConfigEvent.TKPARKASSISTRRVOLUME:
               this.sendSubscribe(this.dbusTKPTSRearVolume);
               break;
            case PersonalConfigEvent.TKBSMCONFIGURATION:
               this.sendSubscribe(this.dbusTKBSMConfiguration);
               break;
            case PersonalConfigEvent.TKFUELPOPUP:
               this.sendSubscribe(this.dbusTKFuelPopupStat);
               break;
            case PersonalConfigEvent.TKEARLYFUELWARNING:
               this.sendSubscribe(this.dbusTKFuelWarningStat);
               break;
            case PersonalConfigEvent.TKPWRLIFTGATECHIME:
               this.sendSubscribe(this.dbusTKPwrLiftgateChime);
               break;
            case PersonalConfigEvent.TKSLIDINGDOORALERT:
               this.sendSubscribe(this.dbusTKSlidingDoorAlert);
               break;
            case PersonalConfigEvent.TKAUTOWIPERS:
               this.sendSubscribe(this.dbusTKAutoWiperStat);
               break;
            case PersonalConfigEvent.TKHLSWITHWIPERS:
               this.sendSubscribe(this.dbusTKHLsWithWipers);
               break;
            case PersonalConfigEvent.TKAUTOHIGHBEAMS:
               this.sendSubscribe(this.dbusTKAutoHighBeams);
               break;
            case PersonalConfigEvent.TKMAXSPEEDLIMIT:
               this.sendSubscribe(this.dbusTKMaxSpeedLimit);
               break;
            case PersonalConfigEvent.SVCDYNAMICGIRDLINES:
               this.sendSubscribe(this.dbusSVCDynamicGridLines);
               break;
            case PersonalConfigEvent.SVCDELAY:
               this.sendSubscribe(this.dbusSVCDelay);
               break;
            case PersonalConfigEvent.PADDLESMODESTATUS:
               this.sendSubscribe(this.dbusPaddlesModeStatus);
               break;
            case PersonalConfigEvent.CHMSLCAMERAGUIDELINES:
               this.sendSubscribe(this.dbusCHMSLCameraGuidelines);
               break;
            case PersonalConfigEvent.AUTOSWITCH:
               this.sendSubscribe(this.dbusAutoSwitch);
               break;
            case PersonalConfigEvent.VIDEOREADBACK:
               this.sendSubscribe(this.dbusVideoReadBack);
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case PersonalConfigEvent.DISPLAYMODE:
               this.sendUnSubscribe(this.dbusDisplayMode);
               break;
            case PersonalConfigEvent.DISPLAYMODESETTING:
               this.sendUnSubscribe(this.dbusDisplayModeSetting);
               break;
            case PersonalConfigEvent.BRIGHTHLON:
               this.sendUnSubscribe(this.dbusDisplayBrightHlOn);
               break;
            case PersonalConfigEvent.SIDEDISTANCEWARNING:
               this.sendUnSubscribe(this.dbusSideDistanceWarning);
               break;
            case PersonalConfigEvent.SIDEDISTANCEWARNINGVOL:
               this.sendUnSubscribe(this.dbusSideDistanceWarningChimeVolume);
               break;
            case PersonalConfigEvent.BRIGHTHLOFF:
               this.sendUnSubscribe(this.dbusDisplayBrightHlOff);
               break;
            case PersonalConfigEvent.COLOR:
               this.sendUnSubscribe(this.dbusDisplayColor);
               break;
            case PersonalConfigEvent.LANG:
               this.sendUnSubscribe(this.dbusDisplayLang);
               break;
            case PersonalConfigEvent.VOICERESLEN:
               this.sendUnSubscribe(this.dbusDisplayVoiceResLen);
               break;
            case PersonalConfigEvent.TELEPROMPTERMODE:
               this.sendUnSubscribe(this.dbusTeleprompterMode);
               break;
            case PersonalConfigEvent.TOUCHSCREENBEEP:
               this.sendUnSubscribe(this.dbusDisplayTouchScreenBeep);
               break;
            case PersonalConfigEvent.NAVCLUSTER:
               this.sendUnSubscribe(this.dbusDisplayNavCluster);
               break;
            case PersonalConfigEvent.FUELSAVER:
               this.sendUnSubscribe(this.dbusDisplayFuelSaver);
               break;
            case PersonalConfigEvent.CONTROLSTIMEOUTENABLED:
               this.sendUnSubscribe(this.dbusControlsTimeoutEnabled);
               break;
            case PersonalConfigEvent.RDYTODRVSTATUS:
               this.sendUnSubscribe(this.dbusReadyToDriveStatus);
               break;
            case PersonalConfigEvent.ENBLPHONEREP:
               this.sendUnSubscribe(this.dbusEnablePhoneRepetition);
               break;
            case PersonalConfigEvent.SAFEFWDCOLLISION:
               this.sendUnSubscribe(this.dbusSafeFwdCollision);
               break;
            case PersonalConfigEvent.SAFEFCWSENSITIVITY:
               this.sendUnSubscribe(this.dbusSafeFcwSensitivitySetting);
               break;
            case PersonalConfigEvent.SAFEFCWONOFFSTATE:
               this.sendUnSubscribe(this.dbusSafeFcwOnOffState);
               break;
            case PersonalConfigEvent.SAFEFCWBRAKESTAT:
               this.sendUnSubscribe(this.dbusSafeFcwBrakeStatus);
               break;
            case PersonalConfigEvent.PARKASSIST:
               this.sendUnSubscribe(this.dbusSafeParkAssist);
               break;
            case PersonalConfigEvent.FTSENSACTDRV:
               this.sendUnSubscribe(this.dbusSafeFrontSensorsActiveDrive);
               break;
            case PersonalConfigEvent.PARKASSISTALERTVOL:
               this.sendUnSubscribe(this.dbusFrontParkAssistChimeVolume);
               this.sendUnSubscribe(this.dbusRearParkAssistChimeVolume);
               break;
            case PersonalConfigEvent.PARKASSISTBRAKING:
               this.sendUnSubscribe(this.dbusRearParkAssistBraking);
               break;
            case PersonalConfigEvent.TILTMIRROR:
               this.sendUnSubscribe(this.dbusSafeTiltMirror);
               break;
            case PersonalConfigEvent.BLINDSPOT:
               this.sendUnSubscribe(this.dbusSafeBlindSpot);
               break;
            case PersonalConfigEvent.BACKUPCAMERA:
               this.sendUnSubscribe(this.dbusSafeBackUpCamera);
               break;
            case PersonalConfigEvent.BACKUPCAMERADELAY:
               this.sendUnSubscribe(this.dbusSafeBackUpCameraDelay);
               break;
            case PersonalConfigEvent.CAMERADYNAMICGRIDLINES:
               this.sendUnSubscribe(this.dbusSafeCamDynamicGridLines);
               break;
            case PersonalConfigEvent.CAMERASTATICGRIDLINES:
               this.sendUnSubscribe(this.dbusSafeCamStaticGridLines);
               break;
            case PersonalConfigEvent.SURROUNDCAMERALOCK:
               this.sendUnSubscribe(this.dbusSafeSurroundCameraLock);
               break;
            case PersonalConfigEvent.SAFEAUTOWIPER:
               this.sendUnSubscribe(this.dbusSafeAutoWiper);
               break;
            case PersonalConfigEvent.SAFEHILLSTARTASSIST:
               this.sendUnSubscribe(this.dbusSafeHillStartAssist);
               break;
            case PersonalConfigEvent.POWERSTEERINGMODE:
               this.sendUnSubscribe(this.dbusPowerSteeringMode);
               break;
            case PersonalConfigEvent.POWERFOLDINGMIRRORS:
               this.sendUnSubscribe(this.dbusPowerFoldingMirrors);
               break;
            case PersonalConfigEvent.HLOFFDELAY:
               this.sendUnSubscribe(this.dbusHeadLightOffDelay);
               break;
            case PersonalConfigEvent.HLILLUMINATION:
               this.sendUnSubscribe(this.dbusHeadLightIllumination);
               break;
            case PersonalConfigEvent.HLWIPER:
               this.sendUnSubscribe(this.dbusHeadLightsWipers);
               break;
            case PersonalConfigEvent.AUTODIMHIGHBEAM:
               this.sendUnSubscribe(this.dbusAutoDimHighBeams);
               break;
            case PersonalConfigEvent.DAYTIMERUNNINGLIGHTS:
               this.sendUnSubscribe(this.dbusDayTimeRunningLights);
               break;
            case PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT:
               this.sendUnSubscribe(this.dbusSteeringDirectedLights);
               break;
            case PersonalConfigEvent.HEADLIGHTDIP:
               this.sendUnSubscribe(this.dbusHeadLightDip);
               break;
            case PersonalConfigEvent.FLASHHLWITHLOCK:
               this.sendUnSubscribe(this.dbusFlashHeadLightsWithLock);
               break;
            case PersonalConfigEvent.MOODLGTINTS:
               this.sendUnSubscribe(this.dbusMoodLightingInts);
               break;
            case PersonalConfigEvent.AMBIENTLIGHTINGLEVEL:
               this.sendUnSubscribe(this.dbusAmbientLightLevel);
               break;
            case PersonalConfigEvent.AUTODOORLOCK:
               this.sendUnSubscribe(this.dbusAutoDoorLock);
               break;
            case PersonalConfigEvent.AUTOUNLOCKEXIT:
               this.sendUnSubscribe(this.dbusAutoUnlockOnExit);
               break;
            case PersonalConfigEvent.FLASHHLWITHLOCK:
               this.sendUnSubscribe(this.dbusFlashHlWithLock);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHLOCK:
               this.sendUnSubscribe(this.dbusSoundHornWithLock);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHLOCK1ST2ND:
               this.sendUnSubscribe(this.dbusSoundHornWithLock1st2nd);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHREMOTELOCK:
               this.sendUnSubscribe(this.dbusSoundHornWithRemoteLock);
               break;
            case PersonalConfigEvent.FIRSTPRESSKEYFOB:
               this.sendUnSubscribe(this.dbusFirstPresskeyFob);
               break;
            case PersonalConfigEvent.PASSIVEENTRY:
               this.sendUnSubscribe(this.dbusPassiveEntry);
               break;
            case PersonalConfigEvent.PERSONALSETTINGSFOB:
               this.sendUnSubscribe(this.dbusPersonalSettingsFob);
               break;
            case PersonalConfigEvent.SLIDINGDOORALERT:
               this.sendUnSubscribe(this.dbusSlidingDoorAlert);
               break;
            case PersonalConfigEvent.HFSLIDINGDOORSTAT:
               this.sendUnSubscribe(this.dbusHFSlidingDoorStatus);
               break;
            case PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT:
               this.sendUnSubscribe(this.dbusFlashLightSlideDoorStatus);
               break;
            case PersonalConfigEvent.AUTORELOCKPE:
               this.sendUnSubscribe(this.dbusAutoRelockPE);
               break;
            case PersonalConfigEvent.HORNREMOTESTART:
               this.sendUnSubscribe(this.dbusHornWithRemoteStart);
               break;
            case PersonalConfigEvent.AUTOONDCS:
               this.sendUnSubscribe(this.dbusAutoOnDCS);
               break;
            case PersonalConfigEvent.EXITSEAT:
               this.sendUnSubscribe(this.dbusEasyExitSeat);
               break;
            case PersonalConfigEvent.ENGINEOFFDELAY:
               this.sendUnSubscribe(this.dbusEngineOffPowerDelay);
               break;
            case PersonalConfigEvent.PWROFFWITHDOOROPEN:
               this.sendUnSubscribe(this.dbusPwrOffWithDoorOpen);
               break;
            case PersonalConfigEvent.SOUNDHORNWITHREMOTELOWER:
               this.sendUnSubscribe(this.dbusSoundHornWithRemoteLower);
               break;
            case PersonalConfigEvent.FLASHLIGHTWITHLOWER:
               this.sendUnSubscribe(this.dbusFlashLightWithLower);
               break;
            case PersonalConfigEvent.TIREJACKMODE:
               this.sendUnSubscribe(this.dbusTireJackMode);
               break;
            case PersonalConfigEvent.SUSPENSIONMSGDISP:
               this.sendUnSubscribe(this.dbusSuspensionMessagesDisplay);
               break;
            case PersonalConfigEvent.TRANSPORTMODE:
               this.sendUnSubscribe(this.dbusTransportMode);
               break;
            case PersonalConfigEvent.WHEELALIGNMENT:
               this.sendUnSubscribe(this.dbusWheelAlignment);
               break;
            case PersonalConfigEvent.AEROMODE:
               this.sendUnSubscribe(this.dbusAeroMode);
               break;
            case PersonalConfigEvent.SUSPENSIONEASYEXIT:
               this.sendUnSubscribe(this.dbusSuspensionEasyExit);
               break;
            case PersonalConfigEvent.TRAILERSELECTED:
               this.sendUnSubscribe(this.dbusTrailerNum);
               break;
            case PersonalConfigEvent.TRAILERBRAKETYPE:
               this.sendUnSubscribe(this.dbusBrakeStyle);
               break;
            case PersonalConfigEvent.TRAILERNAME:
               this.sendUnSubscribe(this.dbusTrailerName);
               break;
            case PersonalConfigEvent.PWRLIFTGATECHIME:
               this.sendUnSubscribe(this.dbusPwrLiftgateChime);
               break;
            case PersonalConfigEvent.HANDSFREELIFTGATE:
               this.sendUnSubscribe(this.dbusPwrLiftgateStatus);
               break;
            case PersonalConfigEvent.AUTOPARKBRAKE:
               this.sendUnSubscribe(this.dbusAutoParkBrake);
               break;
            case PersonalConfigEvent.AUTOHOLDBRAKE:
               this.sendUnSubscribe(this.dbusAutoBrakeHold);
               break;
            case PersonalConfigEvent.LDWARNSETTING:
               this.sendUnSubscribe(this.dbusLaneDepartureWarnSetting);
               break;
            case PersonalConfigEvent.LSWARNSENSITIVITY:
               this.sendUnSubscribe(this.dbusLsWarnSensitivity);
               break;
            case PersonalConfigEvent.LSTORQUEINTENSITY:
               this.sendUnSubscribe(this.dbusLsWarnTorgueIntensity);
               break;
            case PersonalConfigEvent.BRAKESERVICESTATUS:
               this.sendUnSubscribe(this.dbusBrakeServiceStatus);
               break;
            case PersonalConfigEvent.BRAKESERVICETEXTDISPLAY:
               this.sendUnSubscribe(this.dbusBrakeServiceTextDisplay);
               break;
            case PersonalConfigEvent.TRIP_COMPUTER_A:
               this.sendUnSubscribe(this.dbusResetTripA);
               break;
            case PersonalConfigEvent.TRIP_COMPUTER_B:
               this.sendUnSubscribe(this.dbusResetTripB);
               break;
            case PersonalConfigEvent.NAV_REPETITION_ENABLE:
               this.sendUnSubscribe(this.dbusNavigationRepetitionEnabled);
               break;
            case PersonalConfigEvent.HEADLIGHTSENSITIVITY:
               this.sendUnSubscribe(this.dbusHeadlightSensitivityLevel);
               break;
            case PersonalConfigEvent.CORNERINGENABLE:
               this.sendUnSubscribe(this.dbusCorneringEnable);
               break;
            case PersonalConfigEvent.GREETINGLIGHTSENABLE:
               this.sendUnSubscribe(this.dbusGreetingLightsEnable);
               break;
            case PersonalConfigEvent.DNAENABLE:
               this.sendUnSubscribe(this.dBusDnaEnable);
               break;
            case PersonalConfigEvent.TKFCWSENSITIVITY:
               this.sendUnSubscribe(this.dbusTKFCWSensitivity);
               break;
            case PersonalConfigEvent.TKFCWBRAKEASSIST:
               this.sendUnSubscribe(this.dbusTKFCWBrakingAssist);
               break;
            case PersonalConfigEvent.TKPARKASSISTCONFIG:
               this.sendUnSubscribe(this.dbusTKPTSConfiguration);
               break;
            case PersonalConfigEvent.TKPARKASSISTBRAKING:
               this.sendUnSubscribe(this.dbusTKPTSBrakingAssist);
               break;
            case PersonalConfigEvent.TKPARKASSISTFTVOLUME:
               this.sendUnSubscribe(this.dbusTKPTSFrontVolume);
               break;
            case PersonalConfigEvent.TKPARKASSISTRRVOLUME:
               this.sendUnSubscribe(this.dbusTKPTSRearVolume);
               break;
            case PersonalConfigEvent.TKBSMCONFIGURATION:
               this.sendUnSubscribe(this.dbusTKBSMConfiguration);
               break;
            case PersonalConfigEvent.TKFUELPOPUP:
               this.sendUnSubscribe(this.dbusTKFuelPopupStat);
               break;
            case PersonalConfigEvent.TKEARLYFUELWARNING:
               this.sendUnSubscribe(this.dbusTKFuelWarningStat);
               break;
            case PersonalConfigEvent.TKPWRLIFTGATECHIME:
               this.sendUnSubscribe(this.dbusTKPwrLiftgateChime);
               break;
            case PersonalConfigEvent.TKSLIDINGDOORALERT:
               this.sendUnSubscribe(this.dbusTKSlidingDoorAlert);
               break;
            case PersonalConfigEvent.TKAUTOWIPERS:
               this.sendUnSubscribe(this.dbusTKAutoWiperStat);
               break;
            case PersonalConfigEvent.TKHLSWITHWIPERS:
               this.sendUnSubscribe(this.dbusTKHLsWithWipers);
               break;
            case PersonalConfigEvent.TKAUTOHIGHBEAMS:
               this.sendUnSubscribe(this.dbusTKAutoHighBeams);
               break;
            case PersonalConfigEvent.TKMAXSPEEDLIMIT:
               this.sendUnSubscribe(this.dbusTKMaxSpeedLimit);
               break;
            case PersonalConfigEvent.SVCDYNAMICGIRDLINES:
               this.sendUnSubscribe(this.dbusSVCDynamicGridLines);
               break;
            case PersonalConfigEvent.SVCDELAY:
               this.sendUnSubscribe(this.dbusSVCDelay);
               break;
            case PersonalConfigEvent.PADDLESMODESTATUS:
               this.sendUnSubscribe(this.dbusPaddlesModeStatus);
               break;
            case PersonalConfigEvent.CHMSLCAMERAGUIDELINES:
               this.sendUnSubscribe(this.dbusCHMSLCameraGuidelines);
               break;
            case PersonalConfigEvent.AUTOSWITCH:
               this.sendUnSubscribe(this.dbusAutoSwitch);
               break;
            case PersonalConfigEvent.VIDEOREADBACK:
               this.sendUnSubscribe(this.dbusVideoReadBack);
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      private function getValue(valueName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      private function sendStringValue(commandName:String, valueName:String, value:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendNumericValue(commandName:String, valueName:String, value:int) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendBooleanProperty(commandName:String, valueName:String, value:Boolean) : void
      {
         var message:String = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"props\": {\"" + valueName + "\":true}}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"props\": { \"" + valueName + "\":false}}}}";
         }
         this.client.send(message);
      }
      
      private function getProperties(... properties) : void
      {
         var property:String = null;
         var message:Object = {
            "Type":"Command",
            "Dest":this.dbusIdentifier,
            "packet":{"getProperties":{"props":[]}}
         };
         for each(property in properties)
         {
            message.packet.getProperties.props.push(property);
         }
         this.connection.send(message);
      }
      
      public function getAllSuspensionProps() : void
      {
         this.getProperties(this.dbusSoundHornWithRemoteLower,this.dbusFlashLightWithLower,this.dbusSuspensionMessagesDisplay,this.dbusAeroMode,this.dbusTransportMode,this.dbusTireJackMode,this.dbusWheelAlignment);
      }
      
      public function getDisplayMode() : void
      {
         this.getValue(this.dbusDisplayMode);
      }
      
      public function getDisplayModeSetting() : void
      {
         this.getValue(this.dbusDisplayModeSetting);
      }
      
      public function get displayMode() : String
      {
         return this.mDisplayMode;
      }
      
      public function get displayModeSetting() : String
      {
         return this.mDisplayModeSetting;
      }
      
      public function setDisplayModeSetting(mode:String) : void
      {
         this.mDisplayModeSetting = mode;
         this.sendStringValue(dBusSetProperties,this.dbusDisplayModeSetting,mode);
      }
      
      public function get brightnessMin() : int
      {
         return this.mBrightnessMin;
      }
      
      public function set brightnessMin(brightnessMin:int) : void
      {
         this.mBrightnessMin = brightnessMin;
      }
      
      public function get brightnessMax() : int
      {
         return this.mBrightnessMax;
      }
      
      public function set brightnessMax(brightnessMax:int) : void
      {
         this.mBrightnessMax = brightnessMax;
      }
      
      public function getdisplayBrightHlOn() : void
      {
         this.getValue(this.dbusDisplayBrightHlOn);
      }
      
      public function get displayBrightHlOn() : int
      {
         return this.mBrightHlOn;
      }
      
      public function setDisplayBrightHlOn(brightness:int) : void
      {
         if(brightness >= this.mBrightnessMax)
         {
            brightness = this.mBrightnessMax;
         }
         else if(brightness <= this.mBrightnessMin)
         {
            brightness = this.mBrightnessMin;
         }
         this.mBrightHlOn = brightness;
         this.sendNumericValue(dBusSetProperties,this.dbusDisplayBrightHlOn,brightness);
      }
      
      public function getDisplayBrightHlOff() : void
      {
         this.getValue(this.dbusDisplayBrightHlOff);
      }
      
      public function get displayBrightHlOff() : int
      {
         return this.mBrightHlOff;
      }
      
      public function setDisplayBrightHlOff(brightness:int) : void
      {
         if(brightness >= this.mBrightnessMax)
         {
            brightness = this.mBrightnessMax;
         }
         else if(brightness <= this.mBrightnessMin)
         {
            brightness = this.mBrightnessMin;
         }
         this.mBrightHlOff = brightness;
         this.sendNumericValue(dBusSetProperties,this.dbusDisplayBrightHlOff,brightness);
      }
      
      public function getDisplayColor() : void
      {
         this.getValue(this.dbusDisplayColor);
      }
      
      public function get displayColor() : String
      {
         return this.mColor;
      }
      
      public function setDisplayColor(color:String) : void
      {
         this.mColor = color;
         this.sendStringValue(dBusSetProperties,this.dbusDisplayColor,color);
      }
      
      public function getDisplayLang() : void
      {
         this.getValue(this.dbusDisplayLang);
      }
      
      public function get displayLang() : String
      {
         return this.mLang;
      }
      
      public function setDisplayLang(lang:String) : void
      {
         this.mLang = lang;
         this.sendStringValue(dBusSetProperties,this.dbusDisplayLang,lang);
      }
      
      public function getDisplayUnits() : void
      {
         this.getValue(this.dbusUnits);
      }
      
      public function get displayUnits() : String
      {
         return this.mUnit;
      }
      
      public function setDisplayUnits(units:String) : void
      {
         this.mUnit = units;
         this.sendStringValue(dBusSetProperties,this.dbusUnits,units);
      }
      
      public function get speedUnits() : String
      {
         return this.mSpeedUnits;
      }
      
      public function set speedUnits(_speedUnits:String) : void
      {
         this.mSpeedUnits = _speedUnits;
         this.sendStringValue(dBusSetProperties,this.dbusSpeedUnits,_speedUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomSpeedUnits = _speedUnits;
         }
      }
      
      public function get distanceUnits() : String
      {
         return this.mDistanceUnits;
      }
      
      public function set distanceUnits(_distanceUnits:String) : void
      {
         this.mDistanceUnits = _distanceUnits;
         this.sendStringValue(dBusSetProperties,this.dbusDistanceUnits,_distanceUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomDistanceUnits = _distanceUnits;
         }
      }
      
      public function get fuelConsumptionUnits() : String
      {
         return this.mFuelConsumptionUnits;
      }
      
      public function set fuelConsumptionUnits(_fuelConsumptionUnits:String) : void
      {
         this.mFuelConsumptionUnits = _fuelConsumptionUnits;
         this.sendStringValue(dBusSetProperties,this.dbusFuelConsumpUnits,_fuelConsumptionUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomFuelConsumpUnits = _fuelConsumptionUnits;
         }
      }
      
      public function get capacityUnits() : String
      {
         return this.mCapacityUnits;
      }
      
      public function set capacityUnits(_capacityUnits:String) : void
      {
         this.mCapacityUnits = _capacityUnits;
         this.sendStringValue(dBusSetProperties,this.dbusCapacityUnits,_capacityUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomCapacityUnits = _capacityUnits;
         }
      }
      
      public function get pressureUnits() : String
      {
         return this.mPressureUnits;
      }
      
      public function set pressureUnits(_pressureUnits:String) : void
      {
         this.mPressureUnits = _pressureUnits;
         this.sendStringValue(dBusSetProperties,this.dbusPressureUnits,_pressureUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomPressureUnits = _pressureUnits;
         }
      }
      
      public function get temperatureUnits() : String
      {
         return this.mTemperatureUnits;
      }
      
      public function set temperatureUnits(_temperatureUnits:String) : void
      {
         this.mTemperatureUnits = _temperatureUnits;
         this.sendStringValue(dBusSetProperties,this.dbusTemperatureUnits,_temperatureUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomTemperatureUnits = _temperatureUnits;
         }
      }
      
      public function get horsePowerUnits() : String
      {
         return this.mHorsePowerUnits;
      }
      
      public function set horsePowerUnits(_horsePowerUnits:String) : void
      {
         this.mHorsePowerUnits = _horsePowerUnits;
         this.sendStringValue(dBusSetProperties,this.dbusHorsePowerUnits,_horsePowerUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomHorsePowerUnits = _horsePowerUnits;
         }
      }
      
      public function get torqueUnits() : String
      {
         return this.mTorqueUnits;
      }
      
      public function set torqueUnits(_torqueUnits:String) : void
      {
         this.mTorqueUnits = _torqueUnits;
         this.sendStringValue(dBusSetProperties,this.dbusTorqueUnits,_torqueUnits);
         if(this.mUnit == "custom")
         {
            this.mCustomTorqueUnits = _torqueUnits;
         }
      }
      
      public function get customSpeedUnits() : String
      {
         return this.mCustomSpeedUnits;
      }
      
      public function get customDistanceUnits() : String
      {
         return this.mCustomDistanceUnits;
      }
      
      public function get customFuelConsumpUnits() : String
      {
         return this.mCustomFuelConsumpUnits;
      }
      
      public function get customCapacityUnits() : String
      {
         return this.mCustomCapacityUnits;
      }
      
      public function get customPressureUnits() : String
      {
         return this.mCustomPressureUnits;
      }
      
      public function get customTemperatureUnits() : String
      {
         return this.mCustomTemperatureUnits;
      }
      
      public function get customHorsePowerUnits() : String
      {
         return this.mCustomHorsePowerUnits;
      }
      
      public function get customTorqueUnits() : String
      {
         return this.mCustomTorqueUnits;
      }
      
      public function getCustomUnitSettings() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getCustomUnitProperties\": {}}}");
      }
      
      public function getDisplayVoiceRes() : void
      {
         this.getValue(this.dbusDisplayVoiceResLen);
      }
      
      public function get displayVoiceRes() : String
      {
         return this.mVoiceRes;
      }
      
      public function setDisplayVoiceRes(resLen:String) : void
      {
         this.mVoiceRes = resLen;
         this.sendStringValue(dBusSetProperties,this.dbusDisplayVoiceResLen,resLen);
      }
      
      public function getTeleprompterMode() : void
      {
         this.getValue(this.dbusTeleprompterMode);
      }
      
      public function get teleprompterMode() : String
      {
         return this.mTeleprompterMode;
      }
      
      public function setTeleprompterMode(status:String) : void
      {
         this.mTeleprompterMode = status;
         this.sendStringValue(dBusSetProperties,this.dbusTeleprompterMode,status);
      }
      
      public function getDisplayTouchScreenBeep() : void
      {
         this.getValue(this.dbusDisplayTouchScreenBeep);
      }
      
      public function get displayTouchScreenBeep() : Boolean
      {
         return this.mTouchScreenBeep;
      }
      
      public function setDisplayTouchScreenBeep(status:Boolean) : void
      {
         this.mTouchScreenBeep = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusDisplayTouchScreenBeep,status);
      }
      
      public function getDisplayNavCluster() : void
      {
         this.getValue(this.dbusDisplayNavCluster);
      }
      
      public function get displayNavCluster() : Boolean
      {
         return this.mNavCluster;
      }
      
      public function setDisplayNavCluster(status:Boolean) : void
      {
         this.mNavCluster = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusDisplayNavCluster,status);
      }
      
      public function getDisplayFuelSaver() : void
      {
         this.getValue(this.dbusDisplayFuelSaver);
      }
      
      public function get displayFuelSaver() : Boolean
      {
         return this.mFuelSaver;
      }
      
      public function setDisplayFuelSaver(status:Boolean) : void
      {
         this.mFuelSaver = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusDisplayFuelSaver,status);
      }
      
      public function getControlsTimeoutEnabled() : void
      {
         this.getValue(this.dbusControlsTimeoutEnabled);
      }
      
      public function get controlsTimeoutEnabled() : Boolean
      {
         return this.mControlsTimeoutEnabled;
      }
      
      public function setControlsTimeoutEnabled(isEnabled:Boolean) : void
      {
         this.mControlsTimeoutEnabled = isEnabled;
         this.sendBooleanProperty(dBusSetProperties,this.dbusControlsTimeoutEnabled,isEnabled);
      }
      
      public function getReadyToDriveStatus() : void
      {
         this.getValue(this.dbusReadyToDriveStatus);
      }
      
      public function get readyToDriveStatus() : Boolean
      {
         return this.mReadyToDriveStatus;
      }
      
      public function set readyToDriveStatus(state:Boolean) : void
      {
         this.mReadyToDriveStatus = state;
         this.sendBooleanProperty(dBusSetProperties,this.dbusReadyToDriveStatus,state);
      }
      
      public function getEnablePhoneRepetition() : void
      {
         this.getValue(this.dbusEnablePhoneRepetition);
      }
      
      public function get enablePhoneRepetition() : Boolean
      {
         return this.mEnablePhoneRepetition;
      }
      
      public function set enablePhoneRepetition(state:Boolean) : void
      {
         this.mEnablePhoneRepetition = state;
         this.sendBooleanProperty(dBusSetProperties,this.dbusEnablePhoneRepetition,state);
      }
      
      public function getForwardCollisionWarning() : void
      {
         this.getValue(this.dbusSafeFcwBrakeStatus);
      }
      
      public function get forwardCollisionWarning() : String
      {
         return this.mSafeFcwBrakeStatus;
      }
      
      public function setForwardCollisionWarning(status:String) : void
      {
         this.mSafeFcwBrakeStatus = status;
         this.sendStringValue(dBusSetProperties,this.dbusSafeFcwBrakeStatus,this.mSafeFcwBrakeStatus);
      }
      
      public function getSafeFwdCollision() : void
      {
         this.getValue(this.dbusSafeFwdCollision);
      }
      
      public function get safeFwdCollision() : String
      {
         return this.mSafeFwdCollision;
      }
      
      public function setSafeFwdCollision(sensitivity:String) : void
      {
         this.mSafeFwdCollision = sensitivity;
         this.sendStringValue(dBusSetProperties,this.dbusSafeFwdCollision,sensitivity);
      }
      
      public function getSafeFcwSensitivitySetting() : void
      {
         this.getValue(this.dbusSafeFcwSensitivitySetting);
      }
      
      public function get safeFcwSensitivitySetting() : String
      {
         return this.mSafeFcwSensitivitySetting;
      }
      
      public function setSafeFcwSensitivitySetting(sensitivity:String) : void
      {
         this.mSafeFcwSensitivitySetting = sensitivity;
         this.sendStringValue(dBusSetProperties,this.dbusSafeFcwSensitivitySetting,sensitivity);
      }
      
      public function getSafeFcwOnOffState() : void
      {
         this.getValue(this.dbusSafeFcwOnOffState);
      }
      
      public function get safeFcwOnOffState() : String
      {
         return this.mSafeFcwOnOffState;
      }
      
      public function setSafeFcwOnOffState(status:Boolean) : void
      {
         this.mSafeFcwOnOffState = status ? "on" : "off";
         this.sendStringValue(dBusSetProperties,this.dbusSafeFcwOnOffState,this.mSafeFcwOnOffState);
      }
      
      public function getSafeFcwBrakeStat() : void
      {
         this.getValue(this.dbusSafeFcwBrakeStatus);
      }
      
      public function get safeFcwBrakeStat() : String
      {
         return this.mSafeFcwBrakeStatus;
      }
      
      public function setSafeFcwBrakeStat(status:Boolean) : void
      {
         this.mSafeFcwBrakeStatus = status ? "on" : "off";
         this.sendStringValue(dBusSetProperties,this.dbusSafeFcwBrakeStatus,this.mSafeFcwBrakeStatus);
      }
      
      public function getSafeParkAssist() : void
      {
         this.getValue(this.dbusSafeParkAssist);
      }
      
      public function get safeParkAssist() : String
      {
         return this.mSafeParkAssist;
      }
      
      public function setSafeParkAssist(parkAssist:String) : void
      {
         this.mSafeParkAssist = parkAssist;
         this.sendStringValue(dBusSetProperties,this.dbusSafeParkAssist,parkAssist);
      }
      
      public function getSafeFrontSensorsActiveDrive() : void
      {
         this.getValue(this.dbusSafeFrontSensorsActiveDrive);
      }
      
      public function get safeFrontSensorsActiveDrive() : String
      {
         return this.mSafeFrontSensorsActiveDrive;
      }
      
      public function setSafeFrontSensorsActiveDrive(frontSensorsActiveDrive:String) : void
      {
         this.mSafeFrontSensorsActiveDrive = frontSensorsActiveDrive;
         this.sendStringValue(dBusSetProperties,this.dbusSafeFrontSensorsActiveDrive,frontSensorsActiveDrive);
      }
      
      public function getFrontParkAssistChimeVolume() : void
      {
         this.getValue(this.dbusFrontParkAssistChimeVolume);
      }
      
      public function get frontParkAssistChimeVolume() : String
      {
         return this.mFrontParkAssistChimeVolume;
      }
      
      public function setFrontParkAssistChimeVolume(frontParkAssistChimeVolume:String) : void
      {
         this.mFrontParkAssistChimeVolume = frontParkAssistChimeVolume;
         this.sendStringValue(dBusSetProperties,this.dbusFrontParkAssistChimeVolume,frontParkAssistChimeVolume);
      }
      
      public function getRearParkAssistChimeVolume() : void
      {
         this.getValue(this.dbusRearParkAssistChimeVolume);
      }
      
      public function get rearParkAssistChimeVolume() : String
      {
         return this.mRearParkAssistChimeVolume;
      }
      
      public function setRearParkAssistChimeVolume(rearParkAssistChimeVolume:String) : void
      {
         this.mRearParkAssistChimeVolume = rearParkAssistChimeVolume;
         this.sendStringValue(dBusSetProperties,this.dbusRearParkAssistChimeVolume,rearParkAssistChimeVolume);
      }
      
      public function getRearParkAssistBraking() : void
      {
         this.getValue(this.dbusRearParkAssistBraking);
      }
      
      public function get rearParkAssistBraking() : Boolean
      {
         return this.mRearParkAssistBraking;
      }
      
      public function setRearParkAssistBraking(status:Boolean) : void
      {
         this.mRearParkAssistBraking = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusRearParkAssistBraking,status);
      }
      
      public function getSafeTiltMirror() : void
      {
         this.getValue(this.dbusSafeTiltMirror);
      }
      
      public function get safeTiltMirror() : Boolean
      {
         return this.mSafeTiltMirror;
      }
      
      public function setSafeTiltMirror(status:Boolean) : void
      {
         this.mSafeTiltMirror = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeTiltMirror,status);
      }
      
      public function getSafeBlindSpot() : void
      {
         this.getValue(this.dbusSafeBlindSpot);
      }
      
      public function get safeBlindSpot() : String
      {
         return this.mSafeBlindSpot;
      }
      
      public function setSafeBlindSpot(blindSpot:String) : void
      {
         this.mSafeBlindSpot = blindSpot;
         this.sendStringValue(dBusSetProperties,this.dbusSafeBlindSpot,blindSpot);
      }
      
      public function getSideDistanceWarning() : void
      {
         this.getValue(this.dbusSideDistanceWarning);
      }
      
      public function get sideDistanceWarning() : String
      {
         return this.mSideDistanceWarning;
      }
      
      public function setSideDistanceWarning(sideDistanceWarning:String) : void
      {
         this.mSideDistanceWarning = sideDistanceWarning;
         this.sendStringValue(dBusSetProperties,this.dbusSideDistanceWarning,sideDistanceWarning);
      }
      
      public function getSideDistanceWarningVolume() : void
      {
         this.getValue(this.dbusSideDistanceWarningChimeVolume);
      }
      
      public function get sideDistanceWarningVolume() : String
      {
         return this.mSideDistanceWarningVolume;
      }
      
      public function setSideDistanceWarningVolume(sideDistanceWarningVolume:String) : void
      {
         this.mSideDistanceWarningVolume = sideDistanceWarningVolume;
         this.sendStringValue(dBusSetProperties,this.dbusSideDistanceWarningChimeVolume,sideDistanceWarningVolume);
      }
      
      public function getSafeBackUpCamera() : void
      {
         this.getValue(this.dbusSafeBackUpCamera);
      }
      
      public function get safeBackUpCamera() : Boolean
      {
         return this.mSafeBackUpCamera;
      }
      
      public function get safeBackUpCameraDelay() : Boolean
      {
         return this.mSafeBackUpCameraDelay;
      }
      
      public function setSafeBackUpCamera(status:Boolean) : void
      {
         this.mSafeBackUpCamera = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeBackUpCamera,status);
      }
      
      public function setSafeBackUpCameraDelay(status:Boolean) : void
      {
         this.mSafeBackUpCameraDelay = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeBackUpCameraDelay,status);
      }
      
      public function getSafeCameraDynamicGridLines() : void
      {
         this.getValue(this.dbusSafeCamDynamicGridLines);
      }
      
      public function get safeCameraDynamicGridLines() : Boolean
      {
         return this.mSafeCamDynamicGridLines;
      }
      
      public function setSafeCameraDynamicGridLines(status:Boolean) : void
      {
         this.mSafeCamDynamicGridLines = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeCamDynamicGridLines,status);
      }
      
      public function getSafeCameraStaticGridLines() : void
      {
         this.getValue(this.dbusSafeCamStaticGridLines);
      }
      
      public function get safeCameraStaticGridLines() : Boolean
      {
         return this.mSafeCamStaticGridLines;
      }
      
      public function setSafeCameraStaticGridLines(status:Boolean) : void
      {
         this.mSafeCamStaticGridLines = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeCamStaticGridLines,status);
      }
      
      public function getSafeSurroundCameraLock() : void
      {
         this.getValue(this.dbusSafeSurroundCameraLock);
      }
      
      public function get safeSurroundCameraLock() : Boolean
      {
         return this.mSafeSurroundCameraLock;
      }
      
      public function setSafeSurroundCameraLock(status:Boolean) : void
      {
         this.mSafeSurroundCameraLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeSurroundCameraLock,status);
      }
      
      public function getSafeAutoWiper() : void
      {
         this.getValue(this.dbusSafeAutoWiper);
      }
      
      public function get safeAutoWiper() : Boolean
      {
         return this.mSafeAutoWiper;
      }
      
      public function setSafeAutoWiper(status:Boolean) : void
      {
         this.mSafeAutoWiper = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeAutoWiper,status);
      }
      
      public function getSafeHillStartAssist() : void
      {
         this.getValue(this.dbusSafeHillStartAssist);
      }
      
      public function get safeHillStartAssist() : Boolean
      {
         return this.mSafeHillStartAssist;
      }
      
      public function setSafeHillStartAssist(status:Boolean) : void
      {
         this.mSafeHillStartAssist = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSafeHillStartAssist,status);
      }
      
      public function getHeadLightOffDelay() : void
      {
         this.getValue(this.dbusHeadLightOffDelay);
      }
      
      public function get headLightOffDelay() : int
      {
         return this.mHeadLightOffDelay;
      }
      
      public function setHeadLightOffDelay(delay:int) : void
      {
         this.mHeadLightOffDelay = delay;
         this.sendNumericValue(dBusSetProperties,this.dbusHeadLightOffDelay,delay);
      }
      
      public function getHeadLightIllumination() : void
      {
         this.getValue(this.dbusHeadLightIllumination);
      }
      
      public function get headLightIllumination() : int
      {
         return this.mHeadLightIllumination;
      }
      
      public function setHeadLightIllumination(illumination:int) : void
      {
         this.mHeadLightIllumination = illumination;
         this.sendNumericValue(dBusSetProperties,this.dbusHeadLightIllumination,illumination);
      }
      
      public function getHeadLightsWiper() : void
      {
         this.getValue(this.dbusHeadLightsWipers);
      }
      
      public function get headLightsWiper() : Boolean
      {
         return this.mHeadLightsWiper;
      }
      
      public function setHeadLightsWiper(status:Boolean) : void
      {
         this.mHeadLightsWiper = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusHeadLightsWipers,status);
      }
      
      public function getAutoDimHighBeams() : void
      {
         this.getValue(this.dbusAutoDimHighBeams);
      }
      
      public function get autoDimHighBeams() : Boolean
      {
         return this.mAutoDimHighBeams;
      }
      
      public function setAutoDimHighBeams(status:Boolean) : void
      {
         this.mAutoDimHighBeams = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusAutoDimHighBeams,status);
      }
      
      public function getDayTimeRunningLights() : void
      {
         this.getValue(this.dbusDayTimeRunningLights);
      }
      
      public function get dayTimeRunningLights() : Boolean
      {
         return this.mDayTimeRunningLights;
      }
      
      public function setDayTimeRunningLights(status:Boolean) : void
      {
         this.mDayTimeRunningLights = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusDayTimeRunningLights,status);
      }
      
      public function getSteeringDirectedLights() : void
      {
         this.getValue(this.dbusSteeringDirectedLights);
      }
      
      public function get steeringDirectedLights() : Boolean
      {
         return this.mSteeringDirectedLights;
      }
      
      public function setSteeringDirectedLights(status:Boolean) : void
      {
         this.mSteeringDirectedLights = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSteeringDirectedLights,status);
      }
      
      public function getHeadLightDip() : void
      {
         this.getValue(this.dbusHeadLightDip);
      }
      
      public function get headLightDip() : Boolean
      {
         return this.mHeadLightDip;
      }
      
      public function setHeadLightDip(status:Boolean) : void
      {
         this.mHeadLightDip = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusHeadLightDip,status);
      }
      
      public function getFlashHeadLightsWithLock() : void
      {
         this.getValue(this.dbusFlashHeadLightsWithLock);
      }
      
      public function get flashHeadLightsWithLock() : Boolean
      {
         return this.mFlashHeadLightsWithLock;
      }
      
      public function setFlashHeadLightsWithLock(status:Boolean) : void
      {
         this.mFlashHeadLightsWithLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusFlashHeadLightsWithLock,status);
      }
      
      public function getMoodLightingInts() : void
      {
         this.getValue(this.dbusMoodLightingInts);
      }
      
      public function get moodLightingInts() : String
      {
         return this.mMoodLightingInts;
      }
      
      public function setMoodLightingInts(intensity:String) : void
      {
         this.mMoodLightingInts = intensity;
         this.sendStringValue(dBusSetProperties,this.dbusMoodLightingInts,intensity);
      }
      
      public function getAmbientLightingLevel() : void
      {
         this.getValue(this.dbusAmbientLightLevel);
      }
      
      public function get ambientLightingLevel() : String
      {
         return this.mAmbientLightLevel;
      }
      
      public function setAmbientLightingLevel(intensity:String) : void
      {
         this.mAmbientLightLevel = intensity;
         this.sendStringValue(dBusSetProperties,this.dbusAmbientLightLevel,intensity);
      }
      
      public function getAutoDoorLock() : void
      {
         this.getValue(this.dbusAutoDoorLock);
      }
      
      public function get autoDoorLock() : Boolean
      {
         return this.mAutoDoorLock;
      }
      
      public function setAutoDoorLock(status:Boolean) : void
      {
         this.mAutoDoorLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusAutoDoorLock,status);
      }
      
      public function getAutoUnlockOnExit() : void
      {
         this.getValue(this.dbusAutoUnlockOnExit);
      }
      
      public function get autoUnlockOnExit() : Boolean
      {
         return this.mAutoUnlockOnExit;
      }
      
      public function setAutoUnlockOnExit(status:Boolean) : void
      {
         this.mAutoUnlockOnExit = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusAutoUnlockOnExit,status);
      }
      
      public function getFlashHlWithLock() : void
      {
         this.getValue(this.dbusFlashHlWithLock);
      }
      
      public function get flashHlWithLock() : Boolean
      {
         return this.mFlashHlWithLock;
      }
      
      public function setFlashHlWithLock(status:Boolean) : void
      {
         this.mFlashHlWithLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusFlashHlWithLock,status);
      }
      
      public function getSoundHornWithLock() : void
      {
         this.getValue(this.dbusSoundHornWithLock);
      }
      
      public function get soundHornWithLock() : Boolean
      {
         return this.mSoundHornWithLock;
      }
      
      public function setSoundHornWithLock(status:Boolean) : void
      {
         this.mSoundHornWithLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSoundHornWithLock,status);
      }
      
      public function getSoundHornWithLock1st2nd() : void
      {
         this.getValue(this.dbusSoundHornWithLock1st2nd);
      }
      
      public function get soundHornWithLock1st2nd() : String
      {
         return this.mSoundHornWithLock1st2nd;
      }
      
      public function setSoundHornWithLock1st2nd(status:String) : void
      {
         this.mSoundHornWithLock1st2nd = status;
         this.sendStringValue(dBusSetProperties,this.dbusSoundHornWithLock1st2nd,status);
      }
      
      public function getSoundHornWithRemoteLock() : void
      {
         this.getValue(this.dbusSoundHornWithRemoteLock);
      }
      
      public function get soundHornWithRemoteLock() : Boolean
      {
         return this.mSoundHornWithRemoteLock;
      }
      
      public function setSoundHornWithRemoteLock(status:Boolean) : void
      {
         this.mSoundHornWithRemoteLock = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSoundHornWithRemoteLock,status);
      }
      
      public function getFirstPresskeyFob() : void
      {
         this.getValue(this.dbusFirstPresskeyFob);
      }
      
      public function get firstPresskeyFob() : String
      {
         return this.mFirstPresskeyFob;
      }
      
      public function setFirstPresskeyFob(doorType:String) : void
      {
         this.mFirstPresskeyFob = doorType;
         this.sendStringValue(dBusSetProperties,this.dbusFirstPresskeyFob,doorType);
      }
      
      public function getPassiveEntry() : void
      {
         this.getValue(this.dbusPassiveEntry);
      }
      
      public function get passiveEntry() : Boolean
      {
         return this.mPassiveEntry;
      }
      
      public function setPassiveEntry(status:Boolean) : void
      {
         this.mPassiveEntry = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPassiveEntry,status);
      }
      
      public function getPersonalSettingsFob() : void
      {
         this.getValue(this.dbusPersonalSettingsFob);
      }
      
      public function get personalSettingsFob() : Boolean
      {
         return this.mPersonalSettingsFob;
      }
      
      public function setPersonalSettingsFob(status:Boolean) : void
      {
         this.mPersonalSettingsFob = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPersonalSettingsFob,status);
      }
      
      public function getSlidingDoorAlert() : void
      {
         this.getValue(this.dbusSlidingDoorAlert);
      }
      
      public function get slidingDoorAlert() : Boolean
      {
         return this.mSlidingDoorAlert;
      }
      
      public function setSlidingDoorAlert(status:Boolean) : void
      {
         this.mSlidingDoorAlert = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSlidingDoorAlert,status);
      }
      
      public function getHFSlidingDoorStatus() : void
      {
         this.getValue(this.dbusHFSlidingDoorStatus);
      }
      
      public function get handsFreeSlidingDoorStatus() : Boolean
      {
         return this.mSlidingDoorStatus;
      }
      
      public function setHFSlidingDoorStatus(status:Boolean) : void
      {
         this.mSlidingDoorStatus = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusHFSlidingDoorStatus,status);
      }
      
      public function getFlashLightSlideDoorStatus() : void
      {
         this.getValue(this.dbusFlashLightSlideDoorStatus);
      }
      
      public function get flashLightSlideDoorStatus() : Boolean
      {
         return this.mFlashLightSlideDoorStatus;
      }
      
      public function setFlashLightSlideDoorStatus(status:Boolean) : void
      {
         this.mFlashLightSlideDoorStatus = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusFlashLightSlideDoorStatus,status);
      }
      
      public function getAutoRelockPE() : void
      {
         this.getValue(this.dbusAutoRelockPE);
      }
      
      public function get autoRelockPE() : Boolean
      {
         return this.mAutoRelockPE;
      }
      
      public function setAutoRelockPE(status:Boolean) : void
      {
         this.mAutoRelockPE = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusAutoRelockPE,status);
      }
      
      public function getHornWithRemoteStart() : void
      {
         this.getValue(this.dbusHornWithRemoteStart);
      }
      
      public function get hornWithRemoteStart() : Boolean
      {
         return this.mHornWithRemoteStart;
      }
      
      public function setHornWithRemoteStart(status:Boolean) : void
      {
         this.mHornWithRemoteStart = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusHornWithRemoteStart,status);
      }
      
      public function getAutoOnDCS() : void
      {
         this.getValue(this.dbusAutoOnDCS);
      }
      
      public function get autoOnDCS() : String
      {
         return this.mAutoOnDCS;
      }
      
      public function setAutoOnDCS(status:String) : void
      {
         this.mAutoOnDCS = status;
         this.sendStringValue(dBusSetProperties,this.dbusAutoOnDCS,status);
      }
      
      public function getEasyExitSeat() : void
      {
         this.getValue(this.dbusEasyExitSeat);
      }
      
      public function get easyExitSeat() : Boolean
      {
         return this.mEasyExitSeat;
      }
      
      public function setEasyExitSeat(status:Boolean) : void
      {
         this.mEasyExitSeat = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusEasyExitSeat,status);
      }
      
      public function getEngineOffPowerDelay() : void
      {
         this.getValue(this.dbusEngineOffPowerDelay);
      }
      
      public function get engineOffPowerDelay() : int
      {
         return this.mEngineOffPowerDelay;
      }
      
      public function setEngineOffPowerDelay(delay:int) : void
      {
         this.mEngineOffPowerDelay = delay;
         this.sendNumericValue(dBusSetProperties,this.dbusEngineOffPowerDelay,delay);
      }
      
      public function getPwrOffWithDoorOpen() : void
      {
         this.getValue(this.dbusPwrOffWithDoorOpen);
      }
      
      public function get pwrOffWithDoorOpen() : Boolean
      {
         return this.mPwrOffWithDoorOpen;
      }
      
      public function setPwrOffWithDoorOpen(status:Boolean) : void
      {
         this.mPwrOffWithDoorOpen = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPwrOffWithDoorOpen,status);
      }
      
      public function getCompassVariance() : void
      {
         this.getValue(this.dbusCompassVariance);
      }
      
      public function get compassVariance() : int
      {
         return this.mCompassVariance;
      }
      
      public function setCompassVariance(variance:int) : void
      {
         this.mCompassVariance = variance;
         this.sendNumericValue(dBusSetProperties,this.dbusCompassVariance,variance);
      }
      
      public function getSelectedTrailer() : void
      {
         this.getValue(this.dbusTrailerNum);
      }
      
      public function get selectedTrailer() : int
      {
         return this.mTrailerSelected;
      }
      
      public function setSelectedTrailer(trailer:int) : void
      {
         this.mTrailerSelected = trailer;
         this.sendNumericValue(dBusSetProperties,this.dbusTrailerNum,trailer);
         this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERSELECTED));
      }
      
      public function getBrakeType() : void
      {
         this.getValue(this.dbusBrakeStyle);
      }
      
      public function get brakeType() : int
      {
         return this.mBrakeType;
      }
      
      public function setBrakeType(brakeType:int) : void
      {
         this.mBrakeType = brakeType;
         if(this.mBrakeType != -1)
         {
            this.sendNumericValue(dBusSetProperties,this.dbusBrakeStyle,brakeType);
         }
         this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERBRAKETYPE));
      }
      
      public function getTrailerXsBrkType(trailerNum:int) : void
      {
         switch(trailerNum)
         {
            case 1:
               this.getValue(this.dbusBrakeStyle1);
               break;
            case 2:
               this.getValue(this.dbusBrakeStyle2);
               break;
            case 3:
               this.getValue(this.dbusBrakeStyle3);
               break;
            case 4:
               this.getValue(this.dbusBrakeStyle4);
         }
      }
      
      public function get trailer1BrkType() : int
      {
         return this.mTrailer1BrakeType;
      }
      
      public function get trailer2BrkType() : int
      {
         return this.mTrailer2BrakeType;
      }
      
      public function get trailer3BrkType() : int
      {
         return this.mTrailer3BrakeType;
      }
      
      public function get trailer4BrkType() : int
      {
         return this.mTrailer4BrakeType;
      }
      
      public function getTrailerName() : void
      {
         this.getValue(this.dbusTrailerName);
      }
      
      public function get trailerName() : String
      {
         return this.mTrailerName;
      }
      
      public function setTrailerName(trailerName:String) : void
      {
         this.mTrailerName = trailerName;
         this.sendStringValue(dBusSetProperties,this.dbusTrailerName,trailerName);
         this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERNAME));
      }
      
      public function getTrailerXsName(trailerNum:int) : void
      {
         switch(trailerNum)
         {
            case 1:
               this.getValue(this.dbusTrailer1Name);
               break;
            case 2:
               this.getValue(this.dbusTrailer2Name);
               break;
            case 3:
               this.getValue(this.dbusTrailer3Name);
               break;
            case 4:
               this.getValue(this.dbusTrailer4Name);
         }
      }
      
      public function get trailer1Name() : String
      {
         return this.mTrailer1Name;
      }
      
      public function get trailer2Name() : String
      {
         return this.mTrailer2Name;
      }
      
      public function get trailer3Name() : String
      {
         return this.mTrailer3Name;
      }
      
      public function get trailer4Name() : String
      {
         return this.mTrailer4Name;
      }
      
      public function getSoundHornWithRemoteLower() : void
      {
         this.getValue(this.dbusSoundHornWithRemoteLower);
      }
      
      public function get soundHornWithRemoteLower() : Boolean
      {
         return this.mSoundHornWithRemoteLower;
      }
      
      public function setSoundHornWithRemoteLower(status:Boolean) : void
      {
         this.mSoundHornWithRemoteLower = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSoundHornWithRemoteLower,status);
      }
      
      public function getFlashLightWithLower() : void
      {
         this.getValue(this.dbusFlashLightWithLower);
      }
      
      public function get flashLightWithLower() : Boolean
      {
         return this.mFlashLightWithLower;
      }
      
      public function setFlashLightWithLower(status:Boolean) : void
      {
         this.mFlashLightWithLower = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusFlashLightWithLower,status);
      }
      
      public function getTireJackMode() : void
      {
         this.getValue(this.dbusTireJackMode);
      }
      
      public function get tireJackMode() : Boolean
      {
         return this.mTireJackMode;
      }
      
      public function setTireJackMode(status:Boolean) : void
      {
         this.mTireJackMode = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTireJackMode,status);
      }
      
      public function getSuspensionMessagesDisplay() : void
      {
         this.getValue(this.dbusSuspensionMessagesDisplay);
      }
      
      public function get suspensionMessagesDisplay() : Boolean
      {
         return this.mSuspensionMessagesDisplay;
      }
      
      public function setsuspensionMessagesDisplay(status:Boolean) : void
      {
         this.mSuspensionMessagesDisplay = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSuspensionMessagesDisplay,status);
      }
      
      public function getTransportMode() : void
      {
         this.getValue(this.dbusTransportMode);
      }
      
      public function get transportMode() : Boolean
      {
         return this.mTransportMode;
      }
      
      public function setTransportMode(status:Boolean) : void
      {
         this.mTransportMode = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTransportMode,status);
      }
      
      public function getWheelAlignment() : void
      {
         this.getValue(this.dbusWheelAlignment);
      }
      
      public function get wheelAlignment() : Boolean
      {
         return this.mWheelAlignment;
      }
      
      public function setWheelAlignment(status:Boolean) : void
      {
         this.mWheelAlignment = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusWheelAlignment,status);
      }
      
      public function getAeroMode() : void
      {
         this.getValue(this.dbusAeroMode);
      }
      
      public function get aeroMode() : Boolean
      {
         return this.mAeroMode;
      }
      
      public function setAeroMode(status:Boolean) : void
      {
         this.mAeroMode = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusAeroMode,status);
      }
      
      public function getSuspensionEasyExit() : void
      {
         this.getValue(this.dbusSuspensionEasyExit);
      }
      
      public function get SuspensionEasyExit() : Boolean
      {
         return this.mSuspensionEasyExit;
      }
      
      public function setSuspensionEasyExit(status:Boolean) : void
      {
         this.mSuspensionEasyExit = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSuspensionEasyExit,status);
      }
      
      public function getPwrLiftgateChime() : void
      {
         this.getValue(this.dbusPwrLiftgateChime);
      }
      
      public function get PwrLiftgateChime() : Boolean
      {
         return this.mPwrLiftgateChime;
      }
      
      public function setPwrLiftgateChime(status:Boolean) : void
      {
         this.mPwrLiftgateChime = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPwrLiftgateChime,status);
      }
      
      public function getHFLiftgateStatus() : void
      {
         this.getValue(this.dbusPwrLiftgateStatus);
      }
      
      public function get HFLiftgateStatus() : Boolean
      {
         return this.mPwrLiftgateStatus;
      }
      
      public function setHFLiftgateStatus(status:Boolean) : void
      {
         this.mPwrLiftgateStatus = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPwrLiftgateStatus,status);
      }
      
      public function getAutoParkBrake() : void
      {
         this.getValue(this.dbusAutoParkBrake);
      }
      
      public function get autoParkBrake() : String
      {
         return this.mAutoParkBrakeStatus;
      }
      
      public function setAutoParkBrake(status:String) : void
      {
         this.mAutoParkBrakeStatus = status;
         this.sendStringValue(dBusSetProperties,this.dbusAutoParkBrake,status);
      }
      
      public function getAutoBrakeHoldStatus() : void
      {
         this.getValue(this.dbusAutoBrakeHold);
      }
      
      public function get autoBrakeHoldStatus() : String
      {
         return this.mAutoBrakeHoldStatus;
      }
      
      public function setAutoBrakeHoldStatus(status:String) : void
      {
         this.mAutoBrakeHoldStatus = status;
         this.sendStringValue(dBusSetProperties,this.dbusAutoBrakeHold,status);
      }
      
      public function getLaneDepartureWarnSetting() : void
      {
         this.getValue(this.dbusLaneDepartureWarnSetting);
      }
      
      public function get laneDepartureWarnSetting() : Boolean
      {
         return this.mLaneDepartureWarnSetting;
      }
      
      public function setLaneDepartureWarnSetting(status:Boolean) : void
      {
         this.mLaneDepartureWarnSetting = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusLaneDepartureWarnSetting,status);
      }
      
      public function getLaneSenseWarnSensitivity() : void
      {
         this.getValue(this.dbusLsWarnSensitivity);
      }
      
      public function get laneSenseWarnSensitivity() : String
      {
         return this.mLaneSenseWarnSensitivity;
      }
      
      public function setLaneSenseWarnSensitivity(sensitivity:String) : void
      {
         this.mLaneSenseWarnSensitivity = sensitivity;
         this.sendStringValue(dBusSetProperties,this.dbusLsWarnSensitivity,sensitivity);
      }
      
      public function getLaneSenseTorqueIntensity() : void
      {
         this.getValue(this.dbusLsWarnTorgueIntensity);
      }
      
      public function get laneSenseTorqueIntensity() : String
      {
         return this.mLaneSenseTorqueIntensity;
      }
      
      public function setLaneSenseTorqueIntensity(intensity:String) : void
      {
         this.mLaneSenseTorqueIntensity = intensity;
         this.sendStringValue(dBusSetProperties,this.dbusLsWarnTorgueIntensity,intensity);
      }
      
      public function get brakeServiceStatus() : Boolean
      {
         return this.mBrakeServiceStatus;
      }
      
      public function get brakeServiceTextDisplay() : String
      {
         return this.mBrakeServiceTextDisplay;
      }
      
      public function setBrakeServiceStatus(status:Boolean) : void
      {
         this.sendBooleanProperty(dBusSetProperties,this.dbusBrakeServiceStatus,status);
      }
      
      public function resetTripComputerA() : void
      {
         this.sendBooleanProperty(dBusSetProperties,this.dbusResetTripA,true);
      }
      
      public function get tripComputerAStatus() : String
      {
         return this.mTripComputerAStatus;
      }
      
      public function resetTripComputerB() : void
      {
         this.sendBooleanProperty(dBusSetProperties,this.dbusResetTripB,true);
      }
      
      public function get tripComputerBStatus() : String
      {
         return this.mTripComputerBStatus;
      }
      
      public function getPowerSteeringMode() : void
      {
         this.getValue(this.dbusPowerSteeringMode);
      }
      
      public function get powerSteeringMode() : String
      {
         return this.mPowerSteeringMode;
      }
      
      public function setPowerSteeringMode(mode:String) : void
      {
         this.mPowerSteeringMode = mode;
         this.sendStringValue(dBusSetProperties,this.dbusPowerSteeringMode,mode);
      }
      
      public function getPowerFoldingMirrors() : void
      {
         this.getValue(this.dbusPowerFoldingMirrors);
      }
      
      public function get powerFoldingMirrors() : Boolean
      {
         return this.mPowerFoldingMirrors;
      }
      
      public function setPowerFoldingMirrors(status:Boolean) : void
      {
         this.mPowerFoldingMirrors = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusPowerFoldingMirrors,status);
      }
      
      public function getNavigationRepetitionEnabled() : void
      {
         this.getValue(this.dbusNavigationRepetitionEnabled);
      }
      
      public function get navigationRepetitionEnabled() : Boolean
      {
         return this.mNavigationRepetitionEnabled;
      }
      
      public function setNavigationRepetitionEnabled(enabled:Boolean) : void
      {
         this.mNavigationRepetitionEnabled = enabled;
         this.sendBooleanProperty(dBusSetProperties,this.dbusNavigationRepetitionEnabled,enabled);
      }
      
      public function get headlightSensitivityLevel() : int
      {
         return this.mHeadlightSensitivityLevel;
      }
      
      public function set headlightSensitivityLevel(unit:int) : void
      {
         this.mHeadlightSensitivityLevel = unit;
         this.sendStringValue(dBusSetProperties,this.dbusHeadlightSensitivityLevel,unit.toString());
      }
      
      public function getTKFCWSensitivity() : void
      {
         this.getValue(this.dbusTKFCWSensitivity);
      }
      
      public function get TKFCWSensitivity() : String
      {
         return this.mTKFCWSensitivity;
      }
      
      public function setTKFCWSensitivity(level:String) : void
      {
         this.mTKFCWSensitivity = level;
         this.sendStringValue(dBusSetProperties,this.dbusTKFCWSensitivity,level);
      }
      
      public function getTKFCWBrakeAssist() : void
      {
         this.getValue(this.dbusTKFCWBrakingAssist);
      }
      
      public function get TKFCWBrakeAssist() : String
      {
         return this.mTKFCWBrakingAssist;
      }
      
      public function setTKFCWBrakeAssist(status:String) : void
      {
         this.mTKFCWBrakingAssist = status;
         this.sendStringValue(dBusSetProperties,this.dbusTKFCWBrakingAssist,status);
      }
      
      public function getTKPTS_ConfigStatus() : void
      {
         this.getValue(this.dbusTKPTSConfiguration);
      }
      
      public function get TKPTS_ConfigStatus() : String
      {
         return this.mTKPTSConfiguration;
      }
      
      public function setTKPTS_ConfigStatus(setting:String) : void
      {
         this.mTKPTSConfiguration = setting;
         this.sendStringValue(dBusSetProperties,this.dbusTKPTSConfiguration,setting);
      }
      
      public function getTKPTSBrakingAssist() : void
      {
         this.getValue(this.dbusTKPTSBrakingAssist);
      }
      
      public function get TKPTSBrakingAssist() : Boolean
      {
         return this.mTKPTSBrakingAssist;
      }
      
      public function setTKPTSBrakingAssist(status:Boolean) : void
      {
         this.mTKPTSBrakingAssist = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKPTSBrakingAssist,status);
      }
      
      public function getTKPTSFrontVolume() : void
      {
         this.getValue(this.dbusTKPTSFrontVolume);
      }
      
      public function get TKPTSFrontVolume() : String
      {
         return this.mTKPTSFrontVolume;
      }
      
      public function setTKPTSFrontVolume(level:String) : void
      {
         this.mTKPTSFrontVolume = level;
         this.sendStringValue(dBusSetProperties,this.dbusTKPTSFrontVolume,level);
      }
      
      public function getTKPTSRearVolume() : void
      {
         this.getValue(this.dbusTKPTSRearVolume);
      }
      
      public function get TKPTSRearVolume() : String
      {
         return this.mTKPTSRearVolume;
      }
      
      public function setTKPTSRearVolume(level:String) : void
      {
         this.mTKPTSRearVolume = level;
         this.sendStringValue(dBusSetProperties,this.dbusTKPTSRearVolume,level);
      }
      
      public function getTKBSM_ConfigStatus() : void
      {
         this.getValue(this.dbusTKBSMConfiguration);
      }
      
      public function get TKBSM_ConfigStatus() : String
      {
         return this.mTKBSMConfiguration;
      }
      
      public function setTKBSM_ConfigStatus(setting:String) : void
      {
         this.mTKBSMConfiguration = setting;
         this.sendStringValue(dBusSetProperties,this.dbusTKBSMConfiguration,setting);
      }
      
      public function getTKFuelPopup() : void
      {
         this.getValue(this.dbusTKFuelPopupStat);
      }
      
      public function get TKFuelPopup() : Boolean
      {
         return this.mTKFuelPopupStat;
      }
      
      public function setTKFuelPopup(status:Boolean) : void
      {
         this.mTKFuelPopupStat = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKFuelPopupStat,status);
      }
      
      public function getTKEarlyFuelWarning() : void
      {
         this.getValue(this.dbusTKFuelWarningStat);
      }
      
      public function get TKEarlyFuelWarning() : Boolean
      {
         return this.mTKFuelWarningStat;
      }
      
      public function setTKEarlyFuelWarning(status:Boolean) : void
      {
         this.mTKFuelWarningStat = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKFuelWarningStat,status);
      }
      
      public function getTKPWRLiftgateChime() : void
      {
         this.getValue(this.dbusTKPwrLiftgateChime);
      }
      
      public function get TKPWRLiftgateChime() : Boolean
      {
         return this.mTKPwrLiftgateChime;
      }
      
      public function setTKPWRLiftgateChime(status:Boolean) : void
      {
         this.mTKPwrLiftgateChime = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKPwrLiftgateChime,status);
      }
      
      public function getTKSlidingDoorAlert() : void
      {
         this.getValue(this.dbusTKSlidingDoorAlert);
      }
      
      public function get TKSlidingDoorAlert() : Boolean
      {
         return this.mTKSlidingDoorAlert;
      }
      
      public function setTKSlidingDoorAlert(status:Boolean) : void
      {
         this.mTKSlidingDoorAlert = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKSlidingDoorAlert,status);
      }
      
      public function getTKAutoWipers() : void
      {
         this.getValue(this.dbusTKAutoWiperStat);
      }
      
      public function get TKAutoWipers() : Boolean
      {
         return this.mTKAutoWiperStat;
      }
      
      public function setTKAutoWipers(status:Boolean) : void
      {
         this.mTKAutoWiperStat = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKAutoWiperStat,status);
      }
      
      public function getTKHLsWithWipers() : void
      {
         this.getValue(this.dbusTKHLsWithWipers);
      }
      
      public function get TKHLsWithWipers() : Boolean
      {
         return this.mTKHLsWithWipers;
      }
      
      public function setTKHLsWithWipers(status:Boolean) : void
      {
         this.mTKHLsWithWipers = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKHLsWithWipers,status);
      }
      
      public function getTKAutoHighBeams() : void
      {
         this.getValue(this.dbusTKAutoHighBeams);
      }
      
      public function get TKAutoHighBeams() : Boolean
      {
         return this.mTKAutoHighBeams;
      }
      
      public function setTKAutoHighBeams(status:Boolean) : void
      {
         this.mTKAutoHighBeams = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusTKAutoHighBeams,status);
      }
      
      public function getTKMaxSpeedLimit() : void
      {
         this.getValue(this.dbusTKMaxSpeedLimit);
      }
      
      public function get TKMaxSpeedLimit() : String
      {
         return this.mTKMaxSpeedLimit;
      }
      
      public function setTKMaxSpeedLimit(level:String) : void
      {
         this.mTKMaxSpeedLimit = level;
         this.sendStringValue(dBusSetProperties,this.dbusTKMaxSpeedLimit,level);
      }
      
      public function getSVCDynamicGridLines() : void
      {
         this.getValue(this.dbusSVCDynamicGridLines);
      }
      
      public function get SVCDyanmicGridLines() : Boolean
      {
         return this.mSVCDynamicGridLines;
      }
      
      public function setSVCDyanmicGridLines(status:Boolean) : void
      {
         this.mSVCDynamicGridLines = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSVCDynamicGridLines,status);
      }
      
      public function getSVCDelay() : void
      {
         this.getValue(this.dbusSVCDelay);
      }
      
      public function get SVCDelay() : Boolean
      {
         return this.mSVCDelay;
      }
      
      public function setSVCDelay(status:Boolean) : void
      {
         this.mSVCDelay = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusSVCDelay,status);
      }
      
      public function getCorneringEnable() : void
      {
         this.getValue(this.dbusCorneringEnable);
      }
      
      public function get corneringEnable() : Boolean
      {
         return this.mCorneringEnable;
      }
      
      public function setCorneringEnable(status:Boolean) : void
      {
         this.mCorneringEnable = status;
         this.sendBooleanProperty("setProperties",this.dbusCorneringEnable,status);
      }
      
      public function getGreetingLightsEnable() : void
      {
         this.getValue(this.dbusGreetingLightsEnable);
      }
      
      public function get greetingLightsEnable() : Boolean
      {
         return this.mGreetingLightsEnable;
      }
      
      public function setGreetingLightsEnable(status:Boolean) : void
      {
         this.mGreetingLightsEnable = status;
         this.sendBooleanProperty("setProperties",this.dbusGreetingLightsEnable,status);
      }
      
      public function getPaddlesModeStatus() : void
      {
         this.getValue(this.dbusPaddlesModeStatus);
      }
      
      public function get PaddlesModeStatus() : String
      {
         return this.mPaddlesModeStatus;
      }
      
      public function getDnaEnable() : void
      {
         this.getValue(this.dBusDnaEnable);
      }
      
      public function get dnaEnable() : Boolean
      {
         return this.mDnaEnable;
      }
      
      public function setDnaEnable(status:Boolean) : void
      {
         this.mDnaEnable = status;
         this.sendBooleanProperty(dBusSetProperties,this.dBusDnaEnable,status);
      }
      
      public function setPaddlesModeStatus(status:String) : void
      {
         this.mPaddlesModeStatus = status;
         this.sendStringValue(dBusSetProperties,this.dbusPaddlesModeStatus,status);
      }
      
      public function getCHMSLCameraGuidelines() : void
      {
         this.getValue(this.dbusCHMSLCameraGuidelines);
      }
      
      public function get CHMSLCameraGuidelines() : Boolean
      {
         return this.mCHMSLCameraGuidelines;
      }
      
      public function setCHMSLCameraGuidelines(status:Boolean) : void
      {
         this.mCHMSLCameraGuidelines = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusCHMSLCameraGuidelines,status);
      }
      
      public function getAutoSwitch() : void
      {
         this.getValue(this.dbusAutoSwitch);
      }
      
      public function get autoSwitch() : String
      {
         return this.mAutoSwitch;
      }
      
      public function setAutoSwitch(status:String) : void
      {
         this.mAutoSwitch = status;
         this.sendStringValue(dBusSetProperties,this.dbusAutoSwitch,status);
      }
      
      public function getVideoReadBack() : void
      {
         this.getValue(this.dbusVideoReadBack);
      }
      
      public function get videoReadBack() : Boolean
      {
         return this.mVideoReadBack;
      }
      
      public function setVideoReadBack(status:Boolean) : void
      {
         this.mVideoReadBack = status;
         this.sendBooleanProperty(dBusSetProperties,this.dbusVideoReadBack,status);
      }
      
      public function setScreenTurnedOffStatus(status:Boolean) : void
      {
         var message:String = null;
         if(status)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + dBusApiscreenTurnedOff + "\": { \"" + this.dBusScreenOff + "\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + dBusApiscreenTurnedOff + "\": { \"" + this.dBusScreenOff + "\":false}}}";
         }
         this.client.send(message);
      }
      
      private function start() : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.sendMultiSubscribe([this.dbusDisplayMode,this.dbusDisplayModeSetting,this.dbusDisplayBrightHlOn,this.dbusDisplayBrightHlOff,this.dbusDisplayColor,this.dbusDisplayLang,this.dbusUnits,this.dbusSpeedUnits,this.dbusDistanceUnits,this.dbusFuelConsumpUnits,this.dbusCapacityUnits,this.dbusPressureUnits,this.dbusTemperatureUnits,this.dbusHorsePowerUnits,this.dbusTorqueUnits,this.dbusDisplayVoiceResLen,this.dbusTeleprompterMode,this.dbusDisplayTouchScreenBeep,this.dbusDisplayNavCluster,this.dbusDisplayFuelSaver,this.dbusControlsTimeoutEnabled,this.dbusReadyToDriveStatus,this.dbusEnablePhoneRepetition,this.dbusSafeFwdCollision,this.dbusSafeFcwBrakeStatus,this.dbusSafeParkAssist,this.dbusSafeFrontSensorsActiveDrive,this.dbusRearParkAssistBraking,this.dbusSafeTiltMirror,this.dbusSafeBlindSpot,this.dbusSafeBackUpCamera,this.dbusSafeBackUpCameraDelay,this.dbusSafeCamDynamicGridLines,this.dbusSafeCamStaticGridLines,this.dbusSafeSurroundCameraLock,this.dbusSafeAutoWiper,this.dbusSafeHillStartAssist
            ,this.dbusHeadLightOffDelay,this.dbusHeadLightIllumination,this.dbusSideDistanceWarning,this.dbusSideDistanceWarningChimeVolume,this.dbusHeadLightsWipers,this.dbusAutoDimHighBeams,this.dbusDayTimeRunningLights,this.dbusSteeringDirectedLights,this.dbusHeadLightDip,this.dbusFlashHeadLightsWithLock,this.dbusAutoDoorLock,this.dbusAutoUnlockOnExit,this.dbusFlashHlWithLock,this.dbusSoundHornWithLock,this.dbusSoundHornWithLock1st2nd,this.dbusSoundHornWithRemoteLock,this.dbusFirstPresskeyFob,this.dbusPassiveEntry,this.dbusPersonalSettingsFob,this.dbusSlidingDoorAlert,this.dbusHFSlidingDoorStatus,this.dbusFlashLightSlideDoorStatus,this.dbusAutoRelockPE,this.dbusHornWithRemoteStart,this.dbusAutoOnDCS,this.dbusEasyExitSeat,this.dbusEngineOffPowerDelay,this.dbusPwrOffWithDoorOpen,this.dbusCompassVariance,this.dbusSoundHornWithRemoteLower,this.dbusFlashLightWithLower,this.dbusTireJackMode,this.dbusTransportMode,this.dbusWheelAlignment,this.dbusSuspensionMessagesDisplay,this.dbusAeroMode,this.dbusSuspensionEasyExit
            ,this.dbusTrailerNum,this.dbusBrakeStyle,this.dbusBrakeStyle1,this.dbusBrakeStyle2,this.dbusBrakeStyle3,this.dbusBrakeStyle4,this.dbusTrailerName,this.dbusTrailer1Name,this.dbusTrailer2Name,this.dbusTrailer3Name,this.dbusTrailer4Name,this.dbusPwrLiftgateChime,this.dbusPwrLiftgateStatus,this.dbusMoodLightingInts,this.dbusAmbientLightLevel,this.dbusAutoParkBrake,this.dbusLaneDepartureWarnSetting,this.dbusLsWarnSensitivity,this.dbusLsWarnTorgueIntensity,this.dbusAutoBrakeHold,this.dbusBrakeServiceStatus,this.dbusBrakeServiceTextDisplay,this.dbusResetTripA,this.dbusResetTripB,this.dbusPowerSteeringMode,this.dbusPowerFoldingMirrors,this.dbusNavigationRepetitionEnabled,this.dbusCorneringEnable,this.dbusGreetingLightsEnable,this.dBusDnaEnable,this.dbusTKFCWSensitivity,this.dbusTKFCWBrakingAssist,this.dbusTKPTSConfiguration,this.dbusTKPTSBrakingAssist,this.dbusTKPTSFrontVolume,this.dbusTKPTSRearVolume,this.dbusTKBSMConfiguration,this.dbusTKFuelPopupStat,this.dbusTKFuelWarningStat,this.dbusTKPwrLiftgateChime
            ,this.dbusTKSlidingDoorAlert,this.dbusTKAutoWiperStat,this.dbusTKHLsWithWipers,this.dbusTKAutoHighBeams,this.dbusTKMaxSpeedLimit,this.dbusSVCDynamicGridLines,this.dbusSVCDelay,this.dbusPaddlesModeStatus,this.dbusCHMSLCameraGuidelines,this.dbusCustomSpeedUnits,this.dbusCustomDistanceUnits,this.dbusCustomFuelConsumpUnits,this.dbusCustomPressureUnits,this.dbusCustomCapacityUnits,this.dbusCustomTemperatureUnits,this.dbusCustomHorsePowerUnits,this.dbusCustomTorqueUnits,this.dbusMaxDisplayBrigthnessLevel,this.dbusAutoSwitch,this.dbusVideoReadBack]);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      private function sendUnSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function PersonalConfigMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mPersonalConfigServiceAvailable == false)
            {
               this.mPersonalConfigServiceAvailable = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"getCustomUnitProperties\": {}}}");
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mPersonalConfigServiceAvailable = false;
            }
         }
         if(resp.hasOwnProperty(dBusApiGetProperties))
         {
            this.handlePropertyMessage(resp.getProperties);
         }
         else if(resp.hasOwnProperty(dBusApiGetAllProperties))
         {
            this.handlePropertyMessage(resp.getAllProperties);
         }
         else if(resp.hasOwnProperty(dBusApiGetCustomUnitProperties))
         {
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusSpeedUnits))
            {
               this.mCustomSpeedUnits = resp[dBusApiGetCustomUnitProperties][this.dbusSpeedUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusDistanceUnits))
            {
               this.mCustomDistanceUnits = resp[dBusApiGetCustomUnitProperties][this.dbusDistanceUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusFuelConsumpUnits))
            {
               this.mCustomFuelConsumpUnits = resp[dBusApiGetCustomUnitProperties][this.dbusFuelConsumpUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusCapacityUnits))
            {
               this.mCustomCapacityUnits = resp[dBusApiGetCustomUnitProperties][this.dbusCapacityUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusPressureUnits))
            {
               this.mCustomPressureUnits = resp[dBusApiGetCustomUnitProperties][this.dbusPressureUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusTemperatureUnits))
            {
               this.mCustomTemperatureUnits = resp[dBusApiGetCustomUnitProperties][this.dbusTemperatureUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusHorsePowerUnits))
            {
               this.mCustomHorsePowerUnits = resp[dBusApiGetCustomUnitProperties][this.dbusHorsePowerUnits];
            }
            if(resp[dBusApiGetCustomUnitProperties].hasOwnProperty(this.dbusTorqueUnits))
            {
               this.mCustomTorqueUnits = resp[dBusApiGetCustomUnitProperties][this.dbusTorqueUnits];
            }
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusDisplayMode))
         {
            if(resp.displayMode.hasOwnProperty(this.dbusDisplayMode))
            {
               this.mDisplayMode = resp.displayMode.displayMode;
            }
            else
            {
               this.mDisplayMode = resp.displayMode;
            }
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISPLAYMODE));
         }
         if(resp.hasOwnProperty(this.dbusDisplayModeSetting))
         {
            this.mDisplayModeSetting = resp.displayModeSetting.displayModeSetting;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISPLAYMODESETTING));
         }
         if(resp.hasOwnProperty(this.dbusDisplayBrightHlOn))
         {
            this.mBrightHlOn = resp.brightnessHeadlightsOn.brightnessHeadlightsOn;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRIGHTHLON));
         }
         if(resp.hasOwnProperty(this.dbusDisplayBrightHlOff))
         {
            this.mBrightHlOff = resp.brightnessHeadlightsOff.brightnessHeadlightsOff;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRIGHTHLOFF));
         }
         if(resp.hasOwnProperty(this.dbusDisplayColor))
         {
            this.mColor = resp.color.color;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.COLOR));
         }
         if(resp.hasOwnProperty(this.dbusDisplayLang))
         {
            this.mLang = resp.lang.lang;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LANG));
         }
         if(resp.hasOwnProperty(this.dbusUnits))
         {
            this.mUnit = resp.units.units;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.UNIT));
         }
         if(resp.hasOwnProperty(this.dbusDisplayVoiceResLen))
         {
            this.mVoiceRes = resp.voiceResLen.voiceResLen;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.VOICERESLEN));
         }
         if(resp.hasOwnProperty(this.dbusDisplayTouchScreenBeep))
         {
            this.mTouchScreenBeep = resp.touchScreenBeep.touchScreenBeep;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TOUCHSCREENBEEP));
         }
         if(resp.hasOwnProperty(this.dbusDisplayNavCluster))
         {
            this.mNavCluster = resp.navCluster.navCluster;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.NAVCLUSTER));
         }
         if(resp.hasOwnProperty(this.dbusDisplayFuelSaver))
         {
            this.mFuelSaver = resp.fuelSaveDisp.fuelSaveDisp;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FUELSAVER));
         }
         if(resp.hasOwnProperty(this.dbusControlsTimeoutEnabled))
         {
            this.mControlsTimeoutEnabled = resp.controlsTimeoutEnabled.controlsTimeoutEnabled;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CONTROLSTIMEOUTENABLED));
         }
         if(resp.hasOwnProperty(this.dbusReadyToDriveStatus))
         {
            this.mReadyToDriveStatus = resp.readyToDriveStatus.readyToDriveStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.RDYTODRVSTATUS));
         }
         if(resp.hasOwnProperty(this.dbusEnablePhoneRepetition))
         {
            this.mEnablePhoneRepetition = resp.enablePhoneRepetition.enablePhoneRepetition;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.ENBLPHONEREP));
         }
         if(resp.hasOwnProperty(this.dbusSpeedUnits))
         {
            this.mSpeedUnits = resp.speedUnits.speedUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPEED_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusDistanceUnits))
         {
            this.mDistanceUnits = resp.distanceUnits.distanceUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISTANCE_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusFuelConsumpUnits))
         {
            this.mFuelConsumptionUnits = resp.fuelConsumpUnits.fuelConsumpUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FUELCONSUMP_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCapacityUnits))
         {
            this.mCapacityUnits = resp.capacityUnits.capacityUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAPACITY_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusPressureUnits))
         {
            this.mPressureUnits = resp.pressureUnits.pressureUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PRESSURE_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusTemperatureUnits))
         {
            this.mTemperatureUnits = resp.temperatureUnits.temperatureUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TEMPERATURE_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusHorsePowerUnits))
         {
            this.mHorsePowerUnits = resp.horsepowerUnits.horsepowerUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HORSEPOWER_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusTorqueUnits))
         {
            this.mTorqueUnits = resp.torqueUnits.torqueUnits;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TORQUE_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusTeleprompterMode))
         {
            this.mTeleprompterMode = resp.teleprompterMode.teleprompterMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TELEPROMPTERMODE));
         }
         if(resp.hasOwnProperty(this.dbusSafeFwdCollision))
         {
            this.mSafeFwdCollision = resp.collisionSens.collisionSens;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFWDCOLLISION));
         }
         if(resp.hasOwnProperty(this.dbusSafeFcwSensitivitySetting))
         {
            this.mSafeFcwSensitivitySetting = resp[this.dbusSafeFcwSensitivitySetting][this.dbusSafeFcwSensitivitySetting];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWSENSITIVITY));
         }
         if(resp.hasOwnProperty(this.dbusSafeFcwOnOffState))
         {
            this.mSafeFcwOnOffState = resp[this.dbusSafeFcwOnOffState][this.dbusSafeFcwOnOffState];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWONOFFSTATE));
         }
         if(resp.hasOwnProperty(this.dbusSafeFcwBrakeStatus))
         {
            this.mSafeFcwBrakeStatus = resp.fcwBrakeStatus.fcwBrakeStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWBRAKESTAT));
         }
         if(resp.hasOwnProperty(this.dbusSafeParkAssist))
         {
            this.mSafeParkAssist = resp.parkAssist.parkAssist;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSIST));
         }
         if(resp.hasOwnProperty(this.dbusSafeFrontSensorsActiveDrive))
         {
            this.mSafeFrontSensorsActiveDrive = resp.frontSensorsActiveDrive.frontSensorsActiveDrive;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FTSENSACTDRV));
         }
         if(resp.hasOwnProperty(this.dbusSideDistanceWarning))
         {
            this.mSideDistanceWarning = resp[this.dbusSideDistanceWarning][this.dbusSideDistanceWarning];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SIDEDISTANCEWARNING));
         }
         if(resp.hasOwnProperty(this.dbusSideDistanceWarningChimeVolume))
         {
            this.mSideDistanceWarningVolume = resp[this.dbusSideDistanceWarningChimeVolume][this.dbusSideDistanceWarningChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SIDEDISTANCEWARNINGVOL));
         }
         if(resp.hasOwnProperty(this.dbusFrontParkAssistChimeVolume))
         {
            this.mFrontParkAssistChimeVolume = resp[this.dbusFrontParkAssistChimeVolume][this.dbusFrontParkAssistChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTALERTVOL));
         }
         if(resp.hasOwnProperty(this.dbusRearParkAssistChimeVolume))
         {
            this.mRearParkAssistChimeVolume = resp[this.dbusRearParkAssistChimeVolume][this.dbusRearParkAssistChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTALERTVOL));
         }
         if(resp.hasOwnProperty(this.dbusRearParkAssistBraking))
         {
            this.mRearParkAssistBraking = resp.rearParkAssistBraking.rearParkAssistBraking;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTBRAKING));
         }
         if(resp.hasOwnProperty(this.dbusSafeTiltMirror))
         {
            this.mSafeTiltMirror = resp.tilt.tilt;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TILTMIRROR));
         }
         if(resp.hasOwnProperty(this.dbusSafeBlindSpot))
         {
            this.mSafeBlindSpot = resp.blindSpotAlert.blindSpotAlert;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BLINDSPOT));
         }
         if(resp.hasOwnProperty(this.dbusSafeBackUpCamera))
         {
            this.mSafeBackUpCamera = resp.parkviewCam.parkviewCam;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BACKUPCAMERA));
         }
         if(resp.hasOwnProperty(this.dbusSafeBackUpCameraDelay))
         {
            this.mSafeBackUpCameraDelay = resp.parkviewCamDelay.parkviewCamDelay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BACKUPCAMERADELAY));
         }
         if(resp.hasOwnProperty(this.dbusSafeCamDynamicGridLines))
         {
            this.mSafeCamDynamicGridLines = resp.parkviewDynamicGridLines.parkviewDynamicGridLines;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAMERADYNAMICGRIDLINES));
         }
         if(resp.hasOwnProperty(this.dbusSafeCamStaticGridLines))
         {
            this.mSafeCamStaticGridLines = resp.parkviewStaticGridLines.parkviewStaticGridLines;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAMERASTATICGRIDLINES));
         }
         if(resp.hasOwnProperty(this.dbusSafeSurroundCameraLock))
         {
            this.mSafeSurroundCameraLock = resp.surroundCamLock.surroundCamLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SURROUNDCAMERALOCK));
         }
         if(resp.hasOwnProperty(this.dbusSafeAutoWiper))
         {
            this.mSafeAutoWiper = resp.rainWipers.rainWipers;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEAUTOWIPER));
         }
         if(resp.hasOwnProperty(this.dbusSafeHillStartAssist))
         {
            this.mSafeHillStartAssist = resp.hillAssist.hillAssist;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEHILLSTARTASSIST));
         }
         if(resp.hasOwnProperty(this.dbusPowerSteeringMode))
         {
            this.mPowerSteeringMode = resp.powerSteeringMode.powerSteeringMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.POWERSTEERINGMODE));
         }
         if(resp.hasOwnProperty(this.dbusPowerFoldingMirrors))
         {
            this.mPowerFoldingMirrors = resp.powerFoldingMirrors.powerFoldingMirrors;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.POWERFOLDINGMIRRORS));
         }
         if(resp.hasOwnProperty(this.dbusHeadLightOffDelay))
         {
            this.mHeadLightOffDelay = resp.headlightOff.headlightOff;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLOFFDELAY));
         }
         if(resp.hasOwnProperty(this.dbusHeadLightIllumination))
         {
            this.mHeadLightIllumination = resp.headlightIllum.headlightIllum;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLILLUMINATION));
         }
         if(resp.hasOwnProperty(this.dbusHeadLightsWipers))
         {
            this.mHeadLightsWiper = resp.headlightWiper.headlightWiper;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLWIPER));
         }
         if(resp.hasOwnProperty(this.dbusAutoDimHighBeams))
         {
            this.mAutoDimHighBeams = resp.autoDimHiBeam.autoDimHiBeam;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTODIMHIGHBEAM));
         }
         if(resp.hasOwnProperty(this.dbusDayTimeRunningLights))
         {
            this.mDayTimeRunningLights = resp.daytimeLights.daytimeLights;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DAYTIMERUNNINGLIGHTS));
         }
         if(resp.hasOwnProperty(this.dbusSteeringDirectedLights))
         {
            this.mSteeringDirectedLights = resp.steeringLights.steeringLights;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT));
         }
         if(resp.hasOwnProperty(this.dbusHeadLightDip))
         {
            this.mHeadLightDip = resp.headlightDip.headlightDip;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HEADLIGHTDIP));
         }
         if(resp.hasOwnProperty(this.dbusFlashHeadLightsWithLock))
         {
            this.mFlashHeadLightsWithLock = resp.flashHeadlightLock.flashHeadlightLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHHLWITHLOCK));
         }
         if(resp.hasOwnProperty(this.dbusMoodLightingInts))
         {
            this.mMoodLightingInts = resp.moodLightingInts.moodLightingInts;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.MOODLGTINTS));
         }
         if(resp.hasOwnProperty(this.dbusAmbientLightLevel))
         {
            this.mAmbientLightLevel = resp.ambientLightingLevel.ambientLightingLevel;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AMBIENTLIGHTINGLEVEL));
         }
         if(resp.hasOwnProperty(this.dbusAutoDoorLock))
         {
            this.mAutoDoorLock = resp.autoLock.autoLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTODOORLOCK));
         }
         if(resp.hasOwnProperty(this.dbusAutoUnlockOnExit))
         {
            this.mAutoUnlockOnExit = resp.autoUnlock.autoUnlock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOUNLOCKEXIT));
         }
         if(resp.hasOwnProperty(this.dbusFlashHlWithLock))
         {
            this.mFlashHlWithLock = resp.flashHeadlightLock.flashHeadlightLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHHLWITHLOCK));
         }
         if(resp.hasOwnProperty(this.dbusSoundHornWithLock))
         {
            this.mSoundHornWithLock = resp.soundHornLock.soundHornLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHLOCK));
         }
         if(resp.hasOwnProperty(this.dbusSoundHornWithLock1st2nd))
         {
            this.mSoundHornWithLock1st2nd = resp.soundHornLock1st2nd.soundHornLock1st2nd;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHLOCK));
         }
         if(resp.hasOwnProperty(this.dbusSoundHornWithRemoteLock))
         {
            this.mSoundHornWithRemoteLock = resp.hornRemoteStart.hornRemoteStart;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHREMOTELOCK));
         }
         if(resp.hasOwnProperty(this.dbusFirstPresskeyFob))
         {
            this.mFirstPresskeyFob = resp.keyUnlock.keyUnlock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FIRSTPRESSKEYFOB));
         }
         if(resp.hasOwnProperty(this.dbusPassiveEntry))
         {
            this.mPassiveEntry = resp.passiveEntry.passiveEntry;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PASSIVEENTRY));
         }
         if(resp.hasOwnProperty(this.dbusPersonalSettingsFob))
         {
            this.mPersonalSettingsFob = resp.personalSettingsLinked.personalSettingsLinked;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PERSONALSETTINGSFOB));
         }
         if(resp.hasOwnProperty(this.dbusSlidingDoorAlert))
         {
            this.mSlidingDoorAlert = resp.slidingDoorAlert.slidingDoorAlert;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SLIDINGDOORALERT));
         }
         if(resp.hasOwnProperty(this.dbusHFSlidingDoorStatus))
         {
            this.mSlidingDoorStatus = resp.slidingDoorStatus.slidingDoorStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HFSLIDINGDOORSTAT));
         }
         if(resp.hasOwnProperty(this.dbusFlashLightSlideDoorStatus))
         {
            this.mFlashLightSlideDoorStatus = resp.flashLightSlideDoorStatus.flashLightSlideDoorStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT));
         }
         if(resp.hasOwnProperty(this.dbusAutoRelockPE))
         {
            this.mAutoRelockPE = resp.autoRelock.autoRelock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTORELOCKPE));
         }
         if(resp.hasOwnProperty(this.dbusHornWithRemoteStart))
         {
            this.mHornWithRemoteStart = resp.hornRemoteStart.hornRemoteStart;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HORNREMOTESTART));
         }
         if(resp.hasOwnProperty(this.dbusAutoOnDCS))
         {
            this.mAutoOnDCS = resp.autoOnDCS.autoOnDCS;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOONDCS));
         }
         if(resp.hasOwnProperty(this.dbusEasyExitSeat))
         {
            this.mEasyExitSeat = resp.exitSeat.exitSeat;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.EXITSEAT));
         }
         if(resp.hasOwnProperty(this.dbusEngineOffPowerDelay))
         {
            this.mEngineOffPowerDelay = resp.engineOffDelay.engineOffDelay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.ENGINEOFFDELAY));
         }
         if(resp.hasOwnProperty(this.dbusPwrOffWithDoorOpen))
         {
            this.mPwrOffWithDoorOpen = resp[this.dbusPwrOffWithDoorOpen][this.dbusPwrOffWithDoorOpen];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PWROFFWITHDOOROPEN));
         }
         if(resp.hasOwnProperty(this.dbusCompassVariance))
         {
            this.mCompassVariance = resp.compassVariance.compassVariance;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.COMPASSVARIANCE));
         }
         if(resp.hasOwnProperty(this.dbusSoundHornWithRemoteLower))
         {
            this.mSoundHornWithRemoteLower = resp.soundHornRemoteLower.soundHornRemoteLower;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHREMOTELOWER));
         }
         if(resp.hasOwnProperty(this.dbusFlashLightWithLower))
         {
            this.mFlashLightWithLower = resp.flashLightLower.flashLightLower;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHLIGHTWITHLOWER));
         }
         if(resp.hasOwnProperty(this.dbusSuspensionMessagesDisplay))
         {
            this.mSuspensionMessagesDisplay = resp.suspensionMessages.suspensionMessages;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SUSPENSIONMSGDISP));
         }
         if(resp.hasOwnProperty(this.dbusTireJackMode))
         {
            this.mTireJackMode = resp.tireJackMode.tireJackMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TIREJACKMODE));
         }
         if(resp.hasOwnProperty(this.dbusTransportMode))
         {
            this.mTransportMode = resp.transportMode.transportMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRANSPORTMODE));
         }
         if(resp.hasOwnProperty(this.dbusAeroMode))
         {
            this.mAeroMode = resp.aeroMode.aeroMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AEROMODE));
         }
         if(resp.hasOwnProperty(this.dbusWheelAlignment))
         {
            this.mWheelAlignment = resp.wheelAlignment.wheelAlignment;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.WHEELALIGNMENT));
         }
         if(resp.hasOwnProperty(this.dbusSuspensionEasyExit))
         {
            this.mSuspensionEasyExit = resp.easyExitSuspension.easyExitSuspension;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SUSPENSIONEASYEXIT));
         }
         if(resp.hasOwnProperty(this.dbusTrailerNum))
         {
            this.mTrailerSelected = resp.trlrNum.trlrNum;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERSELECTED));
         }
         if(resp.hasOwnProperty(this.dbusBrakeStyle))
         {
            this.mBrakeType = resp.itbmBrkStyle.itbmBrkStyle;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERBRAKETYPE));
         }
         if(resp.hasOwnProperty(this.dbusBrakeStyle1))
         {
            this.mTrailer1BrakeType = resp.trlr1BrkStyle.trlr1BrkStyle;
         }
         if(resp.hasOwnProperty(this.dbusBrakeStyle2))
         {
            this.mTrailer2BrakeType = resp.trlr2BrkStyle.trlr2BrkStyle;
         }
         if(resp.hasOwnProperty(this.dbusBrakeStyle3))
         {
            this.mTrailer3BrakeType = resp.trlr3BrkStyle.trlr3BrkStyle;
         }
         if(resp.hasOwnProperty(this.dbusBrakeStyle4))
         {
            this.mTrailer4BrakeType = resp.trlr4BrkStyle.trlr4BrkStyle;
         }
         if(resp.hasOwnProperty(this.dbusTrailerName))
         {
            this.mTrailerName = resp.trlrStyle.trlrStyle;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERNAME));
         }
         if(resp.hasOwnProperty(this.dbusTrailer1Name))
         {
            this.mTrailer1Name = resp.trlr1Style.trlr1Style;
         }
         if(resp.hasOwnProperty(this.dbusTrailer2Name))
         {
            this.mTrailer2Name = resp.trlr2Style.trlr2Style;
         }
         if(resp.hasOwnProperty(this.dbusTrailer3Name))
         {
            this.mTrailer3Name = resp.trlr3Style.trlr3Style;
         }
         if(resp.hasOwnProperty(this.dbusTrailer4Name))
         {
            this.mTrailer4Name = resp.trlr4Style.trlr4Style;
         }
         if(resp.hasOwnProperty(this.dbusPwrLiftgateChime))
         {
            this.mPwrLiftgateChime = resp.pwrLiftgateChime.pwrLiftgateChime;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PWRLIFTGATECHIME));
         }
         if(resp.hasOwnProperty(this.dbusPwrLiftgateStatus))
         {
            this.mPwrLiftgateStatus = resp.pwrLiftgateStatus.pwrLiftgateStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HANDSFREELIFTGATE));
         }
         if(resp.hasOwnProperty(this.dbusAutoParkBrake))
         {
            this.mAutoParkBrakeStatus = resp.autoParkBrakeStatus.autoParkBrakeStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOPARKBRAKE));
         }
         if(resp.hasOwnProperty(this.dbusAutoBrakeHold))
         {
            this.mAutoBrakeHoldStatus = resp.autoBrakeHoldStatus.autoBrakeHoldStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOHOLDBRAKE));
         }
         if(resp.hasOwnProperty(this.dbusLaneDepartureWarnSetting))
         {
            this.mLaneDepartureWarnSetting = resp.laneDepartureWarnSetting.laneDepartureWarnSetting;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LDWARNSETTING));
         }
         if(resp.hasOwnProperty(this.dbusLsWarnSensitivity))
         {
            this.mLaneSenseWarnSensitivity = resp.laneSenseWarnSensitivity.laneSenseWarnSensitivity;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LSWARNSENSITIVITY));
         }
         if(resp.hasOwnProperty(this.dbusLsWarnTorgueIntensity))
         {
            this.mLaneSenseTorqueIntensity = resp.laneSenseTorqueIntensity.laneSenseTorqueIntensity;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LSTORQUEINTENSITY));
         }
         if(resp.hasOwnProperty(this.dbusBrakeServiceStatus) && this.mBrakeServiceStatus != resp.brakeServiceStatus.brakeServiceStatus)
         {
            this.mBrakeServiceStatus = resp.brakeServiceStatus.brakeServiceStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRAKESERVICESTATUS));
         }
         if(resp.hasOwnProperty(this.dbusBrakeServiceTextDisplay) && this.mBrakeServiceTextDisplay != resp.brakeServiceTextDisplay.brakeServiceTextDisplay)
         {
            this.mBrakeServiceTextDisplay = resp.brakeServiceTextDisplay.brakeServiceTextDisplay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRAKESERVICETEXTDISPLAY,""));
         }
         if(resp.hasOwnProperty(this.dbusResetTripA))
         {
            this.mTripComputerAStatus = resp.resetTripA.resetTripA;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRIP_COMPUTER_A));
         }
         if(resp.hasOwnProperty(this.dbusResetTripB))
         {
            this.mTripComputerBStatus = resp.resetTripB.resetTripB;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRIP_COMPUTER_B));
         }
         if(resp.hasOwnProperty(this.dbusNavigationRepetitionEnabled))
         {
            this.mNavigationRepetitionEnabled = resp[this.dbusNavigationRepetitionEnabled][this.dbusNavigationRepetitionEnabled];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.NAV_REPETITION_ENABLE));
         }
         if(resp.hasOwnProperty(this.dbusHeadlightSensitivityLevel))
         {
            this.mHeadlightSensitivityLevel = resp[this.dbusHeadlightSensitivityLevel][this.dbusHeadlightSensitivityLevel];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HEADLIGHTSENSITIVITY));
         }
         if(resp.hasOwnProperty(this.dbusCorneringEnable))
         {
            this.mCorneringEnable = resp[this.dbusCorneringEnable][this.dbusCorneringEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CORNERINGENABLE));
         }
         if(resp.hasOwnProperty(this.dbusGreetingLightsEnable))
         {
            this.mGreetingLightsEnable = resp[this.dbusGreetingLightsEnable][this.dbusGreetingLightsEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.GREETINGLIGHTSENABLE));
         }
         if(resp.hasOwnProperty(this.dBusDnaEnable))
         {
            this.mDnaEnable = resp[this.dBusDnaEnable][this.dBusDnaEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DNAENABLE));
         }
         if(resp.hasOwnProperty(this.dbusTKFCWSensitivity))
         {
            this.mTKFCWSensitivity = resp[this.dbusTKFCWSensitivity][this.dbusTKFCWSensitivity];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFCWSENSITIVITY));
         }
         if(resp.hasOwnProperty(this.dbusTKFCWBrakingAssist))
         {
            this.mTKFCWBrakingAssist = resp[this.dbusTKFCWBrakingAssist][this.dbusTKFCWBrakingAssist];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFCWBRAKEASSIST));
         }
         if(resp.hasOwnProperty(this.dbusTKPTSConfiguration))
         {
            this.mTKPTSConfiguration = resp[this.dbusTKPTSConfiguration][this.dbusTKPTSConfiguration];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTCONFIG));
         }
         if(resp.hasOwnProperty(this.dbusTKPTSBrakingAssist))
         {
            this.mTKPTSBrakingAssist = resp[this.dbusTKPTSBrakingAssist][this.dbusTKPTSBrakingAssist] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTBRAKING));
         }
         if(resp.hasOwnProperty(this.dbusTKPTSFrontVolume))
         {
            this.mTKPTSFrontVolume = resp[this.dbusTKPTSFrontVolume][this.dbusTKPTSFrontVolume];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTFTVOLUME));
         }
         if(resp.hasOwnProperty(this.dbusTKPTSRearVolume))
         {
            this.mTKPTSRearVolume = resp[this.dbusTKPTSRearVolume][this.dbusTKPTSRearVolume];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTRRVOLUME));
         }
         if(resp.hasOwnProperty(this.dbusTKBSMConfiguration))
         {
            this.mTKBSMConfiguration = resp[this.dbusTKBSMConfiguration][this.dbusTKBSMConfiguration];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKBSMCONFIGURATION));
         }
         if(resp.hasOwnProperty(this.dbusTKFuelPopupStat))
         {
            this.mTKFuelPopupStat = resp[this.dbusTKFuelPopupStat][this.dbusTKFuelPopupStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFUELPOPUP));
         }
         if(resp.hasOwnProperty(this.dbusTKFuelWarningStat))
         {
            this.mTKFuelWarningStat = resp[this.dbusTKFuelWarningStat][this.dbusTKFuelWarningStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKEARLYFUELWARNING));
         }
         if(resp.hasOwnProperty(this.dbusTKPwrLiftgateChime))
         {
            this.mTKPwrLiftgateChime = resp[this.dbusTKPwrLiftgateChime][this.dbusTKPwrLiftgateChime] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPWRLIFTGATECHIME));
         }
         if(resp.hasOwnProperty(this.dbusTKSlidingDoorAlert))
         {
            this.mTKSlidingDoorAlert = resp[this.dbusTKSlidingDoorAlert][this.dbusTKSlidingDoorAlert] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKSLIDINGDOORALERT));
         }
         if(resp.hasOwnProperty(this.dbusTKAutoWiperStat))
         {
            this.mTKAutoWiperStat = resp[this.dbusTKAutoWiperStat][this.dbusTKAutoWiperStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKAUTOWIPERS));
         }
         if(resp.hasOwnProperty(this.dbusTKHLsWithWipers))
         {
            this.mTKHLsWithWipers = resp[this.dbusTKHLsWithWipers][this.dbusTKHLsWithWipers] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKHLSWITHWIPERS));
         }
         if(resp.hasOwnProperty(this.dbusTKAutoHighBeams))
         {
            this.mTKAutoHighBeams = resp[this.dbusTKAutoHighBeams][this.dbusTKAutoHighBeams] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKAUTOHIGHBEAMS));
         }
         if(resp.hasOwnProperty(this.dbusTKMaxSpeedLimit))
         {
            this.mTKMaxSpeedLimit = resp[this.dbusTKMaxSpeedLimit][this.dbusTKMaxSpeedLimit];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKMAXSPEEDLIMIT));
         }
         if(resp.hasOwnProperty(this.dbusSVCDynamicGridLines))
         {
            this.mSVCDynamicGridLines = resp[this.dbusSVCDynamicGridLines][this.dbusSVCDynamicGridLines];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SVCDYNAMICGIRDLINES));
         }
         if(resp.hasOwnProperty(this.dbusSVCDelay))
         {
            this.mSVCDelay = resp[this.dbusSVCDelay][this.dbusSVCDelay];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SVCDELAY));
         }
         if(resp.hasOwnProperty(this.dbusPaddlesModeStatus))
         {
            this.mPaddlesModeStatus = resp[this.dbusPaddlesModeStatus][this.dbusPaddlesModeStatus];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PADDLESMODESTATUS));
         }
         if(resp.hasOwnProperty(this.dbusCHMSLCameraGuidelines))
         {
            this.mCHMSLCameraGuidelines = resp[this.dbusCHMSLCameraGuidelines][this.dbusCHMSLCameraGuidelines];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CHMSLCAMERAGUIDELINES));
         }
         if(resp.hasOwnProperty(this.dbusCustomSpeedUnits))
         {
            this.mCustomSpeedUnits = resp[this.dbusCustomSpeedUnits][this.dbusCustomSpeedUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomDistanceUnits))
         {
            this.mCustomDistanceUnits = resp[this.dbusCustomDistanceUnits][this.dbusCustomDistanceUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomFuelConsumpUnits))
         {
            this.mCustomFuelConsumpUnits = resp[this.dbusCustomFuelConsumpUnits][this.dbusCustomFuelConsumpUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomCapacityUnits))
         {
            this.mCustomCapacityUnits = resp[this.dbusCustomCapacityUnits][this.dbusCustomCapacityUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomPressureUnits))
         {
            this.mCustomPressureUnits = resp[this.dbusCustomPressureUnits][this.dbusCustomPressureUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomTemperatureUnits))
         {
            this.mCustomTemperatureUnits = resp[this.dbusCustomTemperatureUnits][this.dbusCustomTemperatureUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomHorsePowerUnits))
         {
            this.mCustomHorsePowerUnits = resp[this.dbusCustomHorsePowerUnits][this.dbusCustomHorsePowerUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusCustomTorqueUnits))
         {
            this.mCustomTorqueUnits = resp[this.dbusCustomTorqueUnits][this.dbusCustomTorqueUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CUSTOM_UNITS));
         }
         if(resp.hasOwnProperty(this.dbusAutoSwitch))
         {
            this.mAutoSwitch = resp[this.dbusAutoSwitch][this.dbusAutoSwitch];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOSWITCH));
         }
         if(resp.hasOwnProperty(this.dbusVideoReadBack))
         {
            this.mVideoReadBack = resp[this.dbusVideoReadBack][this.dbusVideoReadBack];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.VIDEOREADBACK));
         }
      }
      
      public function handlePropertyMessage(msg:Object) : void
      {
         if(msg.hasOwnProperty(this.dbusDisplayMode))
         {
            this.mDisplayMode = msg.displayMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISPLAYMODE));
         }
         if(msg.hasOwnProperty(this.dbusDisplayModeSetting))
         {
            this.mDisplayModeSetting = msg.displayModeSetting;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISPLAYMODESETTING));
         }
         if(msg.hasOwnProperty(this.dbusDisplayBrightHlOn))
         {
            this.mBrightHlOn = msg.brightnessHeadlightsOn;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRIGHTHLON));
         }
         if(msg.hasOwnProperty(this.dbusDisplayBrightHlOff))
         {
            this.mBrightHlOff = msg.brightnessHeadlightsOff;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRIGHTHLOFF));
         }
         if(msg.hasOwnProperty(this.dbusMaxDisplayBrigthnessLevel))
         {
            this.mBrightnessMax = msg.maxDisplayBrightnessLevel;
         }
         if(msg.hasOwnProperty(this.dbusDisplayColor))
         {
            this.mColor = msg.color;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.COLOR));
         }
         if(msg.hasOwnProperty(this.dbusDisplayLang))
         {
            this.mLang = msg.lang;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LANG));
         }
         if(msg.hasOwnProperty(this.dbusUnits))
         {
            this.mUnit = msg.units;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.UNIT));
         }
         if(msg.hasOwnProperty(this.dbusDisplayVoiceResLen))
         {
            this.mVoiceRes = msg.voiceResLen;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.VOICERESLEN));
         }
         if(msg.hasOwnProperty(this.dbusDisplayTouchScreenBeep))
         {
            this.mTouchScreenBeep = msg.touchScreenBeep;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TOUCHSCREENBEEP));
         }
         if(msg.hasOwnProperty(this.dbusDisplayNavCluster))
         {
            this.mNavCluster = msg.navCluster;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.NAVCLUSTER));
         }
         if(msg.hasOwnProperty(this.dbusDisplayFuelSaver))
         {
            this.mFuelSaver = msg.fuelSaveDisp;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FUELSAVER));
         }
         if(msg.hasOwnProperty(this.dbusControlsTimeoutEnabled))
         {
            this.mControlsTimeoutEnabled = msg.controlsTimeoutEnabled;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CONTROLSTIMEOUTENABLED));
         }
         if(msg.hasOwnProperty(this.dbusReadyToDriveStatus))
         {
            this.mReadyToDriveStatus = msg.readyToDriveStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.RDYTODRVSTATUS));
         }
         if(msg.hasOwnProperty(this.dbusEnablePhoneRepetition))
         {
            this.mEnablePhoneRepetition = msg.enablePhoneRepetition;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.ENBLPHONEREP));
         }
         if(msg.hasOwnProperty(this.dbusSpeedUnits))
         {
            this.mSpeedUnits = msg[this.dbusSpeedUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SPEED_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusDistanceUnits))
         {
            this.mDistanceUnits = msg[this.dbusDistanceUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DISTANCE_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusFuelConsumpUnits))
         {
            this.mFuelConsumptionUnits = msg[this.dbusFuelConsumpUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FUELCONSUMP_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusCapacityUnits))
         {
            this.mCapacityUnits = msg[this.dbusCapacityUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAPACITY_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusPressureUnits))
         {
            this.mPressureUnits = msg[this.dbusPressureUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PRESSURE_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusTemperatureUnits))
         {
            this.mTemperatureUnits = msg[this.dbusTemperatureUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TEMPERATURE_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusHorsePowerUnits))
         {
            this.mHorsePowerUnits = msg[this.dbusHorsePowerUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HORSEPOWER_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusTorqueUnits))
         {
            this.mTorqueUnits = msg[this.dbusTorqueUnits];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TORQUE_UNITS));
         }
         if(msg.hasOwnProperty(this.dbusTeleprompterMode))
         {
            this.mTeleprompterMode = msg.teleprompterMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TELEPROMPTERMODE));
         }
         if(msg.hasOwnProperty(this.dbusSafeFwdCollision))
         {
            this.mSafeFwdCollision = msg.collisionSens;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFWDCOLLISION));
         }
         if(msg.hasOwnProperty(this.dbusSafeFcwSensitivitySetting))
         {
            this.mSafeFcwSensitivitySetting = msg[this.dbusSafeFcwSensitivitySetting];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWSENSITIVITY));
         }
         if(msg.hasOwnProperty(this.dbusSafeFcwOnOffState))
         {
            this.mSafeFcwOnOffState = msg[this.dbusSafeFcwOnOffState];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWONOFFSTATE));
         }
         if(msg.hasOwnProperty(this.dbusSafeFcwBrakeStatus))
         {
            this.mSafeFcwBrakeStatus = msg.fcwBrakeStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEFCWBRAKESTAT));
         }
         if(msg.hasOwnProperty(this.dbusSafeParkAssist))
         {
            this.mSafeParkAssist = msg.parkAssist;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSIST));
         }
         if(msg.hasOwnProperty(this.dbusSafeFrontSensorsActiveDrive))
         {
            this.mSafeFrontSensorsActiveDrive = msg.frontSensorsActiveDrive;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FTSENSACTDRV));
         }
         if(msg.hasOwnProperty(this.dbusFrontParkAssistChimeVolume))
         {
            this.mFrontParkAssistChimeVolume = msg[this.dbusFrontParkAssistChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTALERTVOL));
         }
         if(msg.hasOwnProperty(this.dbusSideDistanceWarning))
         {
            this.mSideDistanceWarning = msg[this.dbusSideDistanceWarning];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SIDEDISTANCEWARNING));
         }
         if(msg.hasOwnProperty(this.dbusSideDistanceWarningChimeVolume))
         {
            this.mSideDistanceWarningVolume = msg[this.dbusSideDistanceWarningChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SIDEDISTANCEWARNINGVOL));
         }
         if(msg.hasOwnProperty(this.dbusRearParkAssistChimeVolume))
         {
            this.mRearParkAssistChimeVolume = msg[this.dbusRearParkAssistChimeVolume];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTALERTVOL));
         }
         if(msg.hasOwnProperty(this.dbusRearParkAssistBraking))
         {
            this.mRearParkAssistBraking = msg.rearParkAssistBraking;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PARKASSISTBRAKING));
         }
         if(msg.hasOwnProperty(this.dbusSafeTiltMirror))
         {
            this.mSafeTiltMirror = msg.tilt;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TILTMIRROR));
         }
         if(msg.hasOwnProperty(this.dbusSafeBlindSpot))
         {
            this.mSafeBlindSpot = msg.blindSpotAlert;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BLINDSPOT));
         }
         if(msg.hasOwnProperty(this.dbusSafeBackUpCamera))
         {
            this.mSafeBackUpCamera = msg.parkviewCam;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BACKUPCAMERA));
         }
         if(msg.hasOwnProperty(this.dbusSafeBackUpCameraDelay))
         {
            this.mSafeBackUpCameraDelay = msg.parkviewCamDelay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BACKUPCAMERADELAY));
         }
         if(msg.hasOwnProperty(this.dbusSafeCamDynamicGridLines))
         {
            this.mSafeCamDynamicGridLines = msg.parkviewDynamicGridLines;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAMERADYNAMICGRIDLINES));
         }
         if(msg.hasOwnProperty(this.dbusSafeCamStaticGridLines))
         {
            this.mSafeCamStaticGridLines = msg.parkviewStaticGridLines;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CAMERASTATICGRIDLINES));
         }
         if(msg.hasOwnProperty(this.dbusSafeSurroundCameraLock))
         {
            this.mSafeSurroundCameraLock = msg.surroundCamLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SURROUNDCAMERALOCK));
         }
         if(msg.hasOwnProperty(this.dbusSafeAutoWiper))
         {
            this.mSafeAutoWiper = msg.rainWipers;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEAUTOWIPER));
         }
         if(msg.hasOwnProperty(this.dbusSafeHillStartAssist))
         {
            this.mSafeHillStartAssist = msg.hillAssist;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SAFEHILLSTARTASSIST));
         }
         if(msg.hasOwnProperty(this.dbusPowerSteeringMode))
         {
            this.mPowerSteeringMode = msg.powerSteeringMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.POWERSTEERINGMODE));
         }
         if(msg.hasOwnProperty(this.dbusPowerFoldingMirrors))
         {
            this.mPowerFoldingMirrors = msg.powerFoldingMirrors;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.POWERFOLDINGMIRRORS));
         }
         if(msg.hasOwnProperty(this.dbusHeadLightOffDelay))
         {
            this.mHeadLightOffDelay = msg.headlightOff;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLOFFDELAY));
         }
         if(msg.hasOwnProperty(this.dbusHeadLightIllumination))
         {
            this.mHeadLightIllumination = msg.headlightIllum;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLILLUMINATION));
         }
         if(msg.hasOwnProperty(this.dbusHeadLightsWipers))
         {
            this.mHeadLightsWiper = msg.headlightWiper;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HLWIPER));
         }
         if(msg.hasOwnProperty(this.dbusAutoDimHighBeams))
         {
            this.mAutoDimHighBeams = msg.autoDimHiBeam;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTODIMHIGHBEAM));
         }
         if(msg.hasOwnProperty(this.dbusDayTimeRunningLights))
         {
            this.mDayTimeRunningLights = msg.daytimeLights;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DAYTIMERUNNINGLIGHTS));
         }
         if(msg.hasOwnProperty(this.dbusSteeringDirectedLights))
         {
            this.mSteeringDirectedLights = msg.steeringLights;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.STEERINGWHEELDIRECTEDLIGHT));
         }
         if(msg.hasOwnProperty(this.dbusHeadLightDip))
         {
            this.mHeadLightDip = msg.headlightDip;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HEADLIGHTDIP));
         }
         if(msg.hasOwnProperty(this.dbusFlashHeadLightsWithLock))
         {
            this.mFlashHeadLightsWithLock = msg.headlightsLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHHLWITHLOCK));
         }
         if(msg.hasOwnProperty(this.dbusMoodLightingInts))
         {
            this.mMoodLightingInts = msg.moodLightingInts;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.MOODLGTINTS));
         }
         if(msg.hasOwnProperty(this.dbusAmbientLightLevel))
         {
            this.mAmbientLightLevel = msg.ambientLightingLevel;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AMBIENTLIGHTINGLEVEL));
         }
         if(msg.hasOwnProperty(this.dbusAutoDoorLock))
         {
            this.mAutoDoorLock = msg.autoLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTODOORLOCK));
         }
         if(msg.hasOwnProperty(this.dbusAutoUnlockOnExit))
         {
            this.mAutoUnlockOnExit = msg.autoUnlock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOUNLOCKEXIT));
         }
         if(msg.hasOwnProperty(this.dbusFlashHlWithLock))
         {
            this.mFlashHeadLightsWithLock = msg.flashHeadlightLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHHLWITHLOCK));
         }
         if(msg.hasOwnProperty(this.dbusSoundHornWithLock))
         {
            this.mSoundHornWithLock = msg.soundHornLock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHLOCK));
         }
         if(msg.hasOwnProperty(this.dbusSoundHornWithLock1st2nd))
         {
            this.mSoundHornWithLock1st2nd = msg.soundHornLock1st2nd;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHLOCK));
         }
         if(msg.hasOwnProperty(this.dbusSoundHornWithRemoteLock))
         {
            this.mSoundHornWithRemoteLock = msg.soundHornRemote;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHREMOTELOCK));
         }
         if(msg.hasOwnProperty(this.dbusFirstPresskeyFob))
         {
            this.mFirstPresskeyFob = msg.keyUnlock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FIRSTPRESSKEYFOB));
         }
         if(msg.hasOwnProperty(this.dbusPassiveEntry))
         {
            this.mPassiveEntry = msg.passiveEntry;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PASSIVEENTRY));
         }
         if(msg.hasOwnProperty(this.dbusPersonalSettingsFob))
         {
            this.mPersonalSettingsFob = msg.personalSettingsLinked;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PERSONALSETTINGSFOB));
         }
         if(msg.hasOwnProperty(this.dbusSlidingDoorAlert))
         {
            this.mSlidingDoorAlert = msg.slidingDoorAlert;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SLIDINGDOORALERT));
         }
         if(msg.hasOwnProperty(this.dbusHFSlidingDoorStatus))
         {
            this.mSlidingDoorStatus = msg.slidingDoorStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HFSLIDINGDOORSTAT));
         }
         if(msg.hasOwnProperty(this.dbusFlashLightSlideDoorStatus))
         {
            this.mFlashLightSlideDoorStatus = msg.flashLightSlideDoorStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLSHLGHTSLIDEDOORSTAT));
         }
         if(msg.hasOwnProperty(this.dbusAutoRelockPE))
         {
            this.mAutoRelockPE = msg.autoRelock;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTORELOCKPE));
         }
         if(msg.hasOwnProperty(this.dbusHornWithRemoteStart))
         {
            this.mHornWithRemoteStart = msg.hornRemoteStart;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HORNREMOTESTART));
         }
         if(msg.hasOwnProperty(this.dbusAutoOnDCS))
         {
            this.mAutoOnDCS = msg.autoOnDCS;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOONDCS));
         }
         if(msg.hasOwnProperty(this.dbusEasyExitSeat))
         {
            this.mEasyExitSeat = msg.exitSeat;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.EXITSEAT));
         }
         if(msg.hasOwnProperty(this.dbusEngineOffPowerDelay))
         {
            this.mEngineOffPowerDelay = msg.engineOffDelay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.ENGINEOFFDELAY));
         }
         if(msg.hasOwnProperty(this.dbusPwrOffWithDoorOpen))
         {
            this.mPwrOffWithDoorOpen = msg[this.dbusPwrOffWithDoorOpen];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PWROFFWITHDOOROPEN));
         }
         if(msg.hasOwnProperty(this.dbusCompassVariance))
         {
            this.mCompassVariance = msg.compassVariance;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.COMPASSVARIANCE));
         }
         if(msg.hasOwnProperty(this.dbusSoundHornWithRemoteLower))
         {
            this.mSoundHornWithRemoteLower = msg.soundHornRemoteLower;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SOUNDHORNWITHREMOTELOWER));
         }
         if(msg.hasOwnProperty(this.dbusFlashLightWithLower))
         {
            this.mFlashLightWithLower = msg.flashLightLower;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.FLASHLIGHTWITHLOWER));
         }
         if(msg.hasOwnProperty(this.dbusSuspensionMessagesDisplay))
         {
            this.mSuspensionMessagesDisplay = msg.suspensionMessages;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SUSPENSIONMSGDISP));
         }
         if(msg.hasOwnProperty(this.dbusTireJackMode))
         {
            this.mTireJackMode = msg.tireJackMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TIREJACKMODE));
         }
         if(msg.hasOwnProperty(this.dbusTransportMode))
         {
            this.mTransportMode = msg.transportMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRANSPORTMODE));
         }
         if(msg.hasOwnProperty(this.dbusAeroMode))
         {
            this.mAeroMode = msg.aeroMode;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AEROMODE));
         }
         if(msg.hasOwnProperty(this.dbusSuspensionEasyExit))
         {
            this.mSuspensionEasyExit = msg.easyExitSuspension;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SUSPENSIONEASYEXIT));
         }
         if(msg.hasOwnProperty(this.dbusWheelAlignment))
         {
            this.mWheelAlignment = msg.wheelAlignment;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.WHEELALIGNMENT));
         }
         if(msg.hasOwnProperty(this.dbusTrailerNum))
         {
            this.mTrailerSelected = msg.trlrNum;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERSELECTED));
         }
         if(msg.hasOwnProperty(this.dbusBrakeStyle))
         {
            this.mBrakeType = msg.itbmBrkStyle;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERBRAKETYPE));
         }
         if(msg.hasOwnProperty(this.dbusBrakeStyle1))
         {
            this.mTrailer1BrakeType = msg.trlr1BrkStyle;
         }
         if(msg.hasOwnProperty(this.dbusBrakeStyle2))
         {
            this.mTrailer2BrakeType = msg.trlr2BrkStyle;
         }
         if(msg.hasOwnProperty(this.dbusBrakeStyle3))
         {
            this.mTrailer3BrakeType = msg.trlr3BrkStyle;
         }
         if(msg.hasOwnProperty(this.dbusBrakeStyle4))
         {
            this.mTrailer4BrakeType = msg.trlr4BrkStyle;
         }
         if(msg.hasOwnProperty(this.dbusTrailerName))
         {
            this.mTrailerName = msg.trlrStyle;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRAILERNAME));
         }
         if(msg.hasOwnProperty(this.dbusTrailer1Name))
         {
            this.mTrailer1Name = msg.trlr1Style;
         }
         if(msg.hasOwnProperty(this.dbusTrailer2Name))
         {
            this.mTrailer2Name = msg.trlr2Style;
         }
         if(msg.hasOwnProperty(this.dbusTrailer3Name))
         {
            this.mTrailer3Name = msg.trlr3Style;
         }
         if(msg.hasOwnProperty(this.dbusTrailer4Name))
         {
            this.mTrailer4Name = msg.trlr4Style;
         }
         if(msg.hasOwnProperty(this.dbusPwrLiftgateChime))
         {
            this.mPwrLiftgateChime = msg.pwrLiftgateChime;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PWRLIFTGATECHIME));
         }
         if(msg.hasOwnProperty(this.dbusPwrLiftgateStatus))
         {
            this.mPwrLiftgateStatus = msg.pwrLiftgateStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HANDSFREELIFTGATE));
         }
         if(msg.hasOwnProperty(this.dbusAutoParkBrake))
         {
            this.mAutoParkBrakeStatus = msg.autoParkBrakeStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOPARKBRAKE));
         }
         if(msg.hasOwnProperty(this.dbusAutoBrakeHold))
         {
            this.mAutoBrakeHoldStatus = msg.autoBrakeHoldStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOHOLDBRAKE));
         }
         if(msg.hasOwnProperty(this.dbusLaneDepartureWarnSetting))
         {
            this.mLaneDepartureWarnSetting = msg.laneDepartureWarnSetting;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LDWARNSETTING));
         }
         if(msg.hasOwnProperty(this.dbusLsWarnSensitivity))
         {
            this.mLaneSenseWarnSensitivity = msg.laneSenseWarnSensitivity;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LSWARNSENSITIVITY));
         }
         if(msg.hasOwnProperty(this.dbusLsWarnTorgueIntensity))
         {
            this.mLaneSenseTorqueIntensity = msg.laneSenseTorqueIntensity;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.LSTORQUEINTENSITY));
         }
         if(msg.hasOwnProperty(this.dbusBrakeServiceStatus) && this.mBrakeServiceStatus != msg.brakeServiceStatus)
         {
            this.mBrakeServiceStatus = msg.brakeServiceStatus;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRAKESERVICESTATUS));
         }
         if(msg.hasOwnProperty(this.dbusBrakeServiceTextDisplay) && this.mBrakeServiceTextDisplay != msg.brakeServiceTextDisplay)
         {
            this.mBrakeServiceTextDisplay = msg.brakeServiceTextDisplay;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.BRAKESERVICETEXTDISPLAY,""));
         }
         if(msg.hasOwnProperty(this.dbusResetTripA))
         {
            this.mTripComputerAStatus = msg.resetTripA;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRIP_COMPUTER_A));
         }
         if(msg.hasOwnProperty(this.dbusResetTripB))
         {
            this.mTripComputerBStatus = msg.resetTripB;
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TRIP_COMPUTER_B));
         }
         if(msg.hasOwnProperty(this.dbusNavigationRepetitionEnabled))
         {
            this.mNavigationRepetitionEnabled = msg[this.dbusNavigationRepetitionEnabled];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.NAV_REPETITION_ENABLE));
         }
         if(msg.hasOwnProperty(this.dbusHeadlightSensitivityLevel))
         {
            this.mHeadlightSensitivityLevel = msg[this.dbusHeadlightSensitivityLevel];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.HEADLIGHTSENSITIVITY));
         }
         if(msg.hasOwnProperty(this.dbusCorneringEnable))
         {
            this.mCorneringEnable = msg[this.dbusCorneringEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CORNERINGENABLE));
         }
         if(msg.hasOwnProperty(this.dbusGreetingLightsEnable))
         {
            this.mGreetingLightsEnable = msg[this.dbusGreetingLightsEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.GREETINGLIGHTSENABLE));
         }
         if(msg.hasOwnProperty(this.dbusTKFCWSensitivity))
         {
            this.mTKFCWSensitivity = msg[this.dbusTKFCWSensitivity];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFCWSENSITIVITY));
         }
         if(msg.hasOwnProperty(this.dbusTKFCWBrakingAssist))
         {
            this.mTKFCWBrakingAssist = msg[this.dbusTKFCWBrakingAssist];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFCWBRAKEASSIST));
         }
         if(msg.hasOwnProperty(this.dbusTKPTSConfiguration))
         {
            this.mTKPTSConfiguration = msg[this.dbusTKPTSConfiguration];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTCONFIG));
         }
         if(msg.hasOwnProperty(this.dbusTKPTSBrakingAssist))
         {
            this.mTKPTSBrakingAssist = msg[this.dbusTKPTSBrakingAssist] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTBRAKING));
         }
         if(msg.hasOwnProperty(this.dbusTKPTSFrontVolume))
         {
            this.mTKPTSFrontVolume = msg[this.dbusTKPTSFrontVolume];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTFTVOLUME));
         }
         if(msg.hasOwnProperty(this.dbusTKPTSRearVolume))
         {
            this.mTKPTSRearVolume = msg[this.dbusTKPTSRearVolume];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPARKASSISTRRVOLUME));
         }
         if(msg.hasOwnProperty(this.dbusTKBSMConfiguration))
         {
            this.mTKBSMConfiguration = msg[this.dbusTKBSMConfiguration];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKBSMCONFIGURATION));
         }
         if(msg.hasOwnProperty(this.dbusTKFuelPopupStat))
         {
            this.mTKFuelPopupStat = msg[this.dbusTKFuelPopupStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKFUELPOPUP));
         }
         if(msg.hasOwnProperty(this.dbusTKFuelWarningStat))
         {
            this.mTKFuelWarningStat = msg[this.dbusTKFuelWarningStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKEARLYFUELWARNING));
         }
         if(msg.hasOwnProperty(this.dbusTKPwrLiftgateChime))
         {
            this.mTKPwrLiftgateChime = msg[this.dbusTKPwrLiftgateChime] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKPWRLIFTGATECHIME));
         }
         if(msg.hasOwnProperty(this.dbusTKSlidingDoorAlert))
         {
            this.mTKSlidingDoorAlert = msg[this.dbusTKSlidingDoorAlert] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKSLIDINGDOORALERT));
         }
         if(msg.hasOwnProperty(this.dbusTKAutoWiperStat))
         {
            this.mTKAutoWiperStat = msg[this.dbusTKAutoWiperStat] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKAUTOWIPERS));
         }
         if(msg.hasOwnProperty(this.dbusTKHLsWithWipers))
         {
            this.mTKHLsWithWipers = msg[this.dbusTKHLsWithWipers] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKHLSWITHWIPERS));
         }
         if(msg.hasOwnProperty(this.dbusTKAutoHighBeams))
         {
            this.mTKAutoHighBeams = msg[this.dbusTKAutoHighBeams] == "true";
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKAUTOHIGHBEAMS));
         }
         if(msg.hasOwnProperty(this.dbusTKMaxSpeedLimit))
         {
            this.mTKMaxSpeedLimit = msg[this.dbusTKMaxSpeedLimit];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.TKMAXSPEEDLIMIT));
         }
         if(msg.hasOwnProperty(this.dbusSVCDynamicGridLines))
         {
            this.mSVCDynamicGridLines = msg[this.dbusSVCDynamicGridLines];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SVCDYNAMICGIRDLINES));
         }
         if(msg.hasOwnProperty(this.dbusSVCDelay))
         {
            this.mSVCDelay = msg[this.dbusSVCDelay];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.SVCDELAY));
         }
         if(msg.hasOwnProperty(this.dbusPaddlesModeStatus))
         {
            this.mPaddlesModeStatus = msg[this.dbusPaddlesModeStatus];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.PADDLESMODESTATUS));
         }
         if(msg.hasOwnProperty(this.dbusCHMSLCameraGuidelines))
         {
            this.mCHMSLCameraGuidelines = msg[this.dbusCHMSLCameraGuidelines];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.CHMSLCAMERAGUIDELINES));
         }
         if(msg.hasOwnProperty(this.dBusDnaEnable))
         {
            this.mDnaEnable = msg[this.dBusDnaEnable];
            dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.DNAENABLE));
         }
         if(msg.hasOwnProperty(this.dbusAutoSwitch))
         {
            this.mAutoSwitch = msg[this.dbusAutoSwitch];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.AUTOSWITCH));
         }
         if(msg.hasOwnProperty(this.dbusVideoReadBack))
         {
            this.mVideoReadBack = msg[this.dbusVideoReadBack];
            this.dispatchEvent(new PersonalConfigEvent(PersonalConfigEvent.VIDEOREADBACK));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + this.dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

