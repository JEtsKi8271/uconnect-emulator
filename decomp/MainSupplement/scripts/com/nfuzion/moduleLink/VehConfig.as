package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.IVehConfig;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.VehConfigEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VehConfig extends Module implements IVehConfig
   {
      
      private static var instance:VehConfig;
      
      private static const IS_TEST:Boolean = true;
      
      private static const dbusIdentifier:String = "VehicleConfig";
      
      private static const dBusNavPresent:String = "navPresent";
      
      private static const dBusAmpPresent:String = "AMP_Present";
      
      private static const dBusIcsPresent:String = "ICS_Present";
      
      private static const dBusHaLFPresent:String = "HaLF_Present";
      
      private static const dBusEPBPresent:String = "EPB_Present";
      
      private static const dBusPLGPresent:String = "PLG_Present";
      
      private static const dBusHFLGPresent:String = "handsFreeLiftGatePresent";
      
      private static const dBusRemoteStartPresent:String = "remoteStartPresent";
      
      private static const dBusEcoModePresent:String = "eModePresent";
      
      private static const dBusAutoHighBeamsPresent:String = "autoHighBeamPresent";
      
      private static const dBusSportsModePresent:String = "performancePagesPresent";
      
      private static const dBusHoldNGoPresent:String = "holdNGoPresent";
      
      private static const dBusSunShadePresent:String = "sunShadePresent";
      
      private static const dBusAutoHeadLampPresent:String = "autoHeadLampPresent";
      
      private static const dBusHeadlampDipPresent:String = "headLampDipPresent";
      
      private static const dBusTemperatureDisplayPresent:String = "displayOutsideTempPresent";
      
      private static const dBusCompassDisplayPresent:String = "displayCompassHeadingPresent";
      
      private static const dBusCompassVariancePresent:String = "compassVariancePresent";
      
      private static const dBusCompassCalibrationPresent:String = "compassCalibrationPresent";
      
      private static const dBusdigitalClockPresent:String = "digitalClockPresent";
      
      private static const dBusDispOfDigitalClock:String = "disableDisplayOfRadioClock";
      
      private static const dBusPowerOutletPresent:String = "powerInverterPresent";
      
      private static const dBusHeatedSeatsPresent:String = "heatedSeatsPresent";
      
      private static const dBusVentedSeatsPresent:String = "ventedSeatsPresent";
      
      private static const dBusHeatedSteeringWheelPresent:String = "heatedSteeringWheelPresent";
      
      private static const dBusMemorySeatModulePreset:String = "MSM_Present";
      
      private static const dBusBlindSpotModulePresent:String = "BSM_Present";
      
      private static const dBusRearCameraPresent:String = "rearCameraPresent";
      
      private static const dBusCargoCameraPresent:String = "CHMCM_Present";
      
      private static const dBusSurroundCameraPresent:String = "SVC_Present";
      
      private static const dBusHillStartAssistPresent:String = "hillStartAssistPresent";
      
      private static const dBusAFLS_Present:String = "AFLS_Present";
      
      private static const dBusDRLPresent:String = "DRL_Present";
      
      private static const dBusSoundHornWithLocks:String = "soundHornWithLocksPresent";
      
      private static const dBusPersonalSettingsAvailable:String = "personalSettingsAvailable";
      
      private static const dBusHeadRestDumpPresent:String = "headrestDumpPresent";
      
      private static const dbusAdaptiveFrontLightSystemPresent:String = "adaptiveFrontLightSystemPresent";
      
      private static const dbusGreetingLightsPresent:String = "greetingLightsPresent";
      
      private static const dbusDistanceOptionPresent:String = "distanceOptionPresent";
      
      private static const dbusCorneringLightsPresent:String = "corneringLightsPresent";
      
      private static const dBusRainSensorPresent:String = "rainSensorPresent";
      
      private static const dBusRkePresent:String = "RKEPresent";
      
      private static const dBusRKEUnlockPresent:String = "RKEUnlockPresent";
      
      private static const dBusDoorAlertPresent:String = "doorAlertPresent";
      
      private static const dBusHFSlidingDoorPresent:String = "handsFreeSlidingDoorPresent";
      
      private static const dBusFlashLightSlideDoorPresent:String = "flashLightSlideDoorPresent";
      
      private static const dBusForwardCollisionWarningPresent:String = "forwardCollisionWarningPresent";
      
      private static const dBusFrontParkAssistPresent:String = "frontParkAssistPresent";
      
      private static const dBusParkAssistPresent:String = "parkAssistPresent";
      
      private static const dBusSurroundSoundPresent:String = "surroundSoundPresent";
      
      private static const dBusPowerDoorLocksPresent:String = "powerDoorLocksPresent";
      
      private static const dBusAutoDoorLocksPresent:String = "autoDoorLockPresent";
      
      private static const dBusItbmPresent:String = "ITBM_Present";
      
      private static const dBusForwardCollisionBrakingPresent:String = "forwardCollisionBrakingPresent";
      
      private static const dBusFCWOnOffSoftKeyPresent:String = "fcwOnOffSoftKeyPresent";
      
      private static const dBusParkAssistConfiguration:String = "parkAssistConfiguration";
      
      private static const dBusPassiveEntryPresent:String = "passiveEntryPresent";
      
      private static const dBusAutoRelockPresent:String = "relockPresent";
      
      private static const dBusAmbientLightingPresent:String = "ambientLightingPresent";
      
      private static const dbusAmbientDimmerSwitchPresent:String = "ambientDimmerSwitchPresent";
      
      private static const dBusTwilightSensorPresent:String = "twilightSensorPresent";
      
      private static const dBusECMirrorPresent:String = "EC_MirrorPresent";
      
      private static const dbusDisplayOnOffSKPresent:String = "displayOnOffSKPresent";
      
      private static const dBusLaneDepartureWarningPresent:String = "laneDepartureWarningPresent";
      
      private static const dBusLSTorqueType:String = "laneSenseTorqueType";
      
      private static const dBusLSSensitivityType:String = "laneSenseSensitivityType";
      
      private static const dBusVehicleBrandConfig:String = "vehicleBrand";
      
      private static const dBusModelYearConfig:String = "modelYear";
      
      private static const dBusSteeringWheelConfig:String = "vehicleDriveConfiguration";
      
      private static const dBusVehicleLineConfig:String = "vehiclePlatform";
      
      private static const dBusTransmissionConfig:String = "driveConfiguration";
      
      private static const dBusCountryCodeConfig:String = "countryCode";
      
      private static const dBusBodyStyleConfig:String = "bodyStyle";
      
      private static const dBusSpecialPackageConfig:String = "specialPackageTheme";
      
      private static const dBusHvacConfig:String = "HVACConfiguration";
      
      private static const dBusDestinationConfig:String = "destination";
      
      private static const dBusDestinationNameConfig:String = "destinationName";
      
      private static const dBusVariantMarketConfig:String = "variant_market";
      
      private static const dBusAudioSystemType:String = "compactAudioSysType";
      
      private static const dBusExternalPortType:String = "externalPortType";
      
      private static const dbusAdditionalLanguages:String = "additionalLanguages";
      
      private static const dbusEngineTypeVariant:String = "engineTypeVariant";
      
      private static const dbusAccessoryDelayPresent:String = "accessoryDelayPresent";
      
      private static const dbusTireJackModePresent:String = "tireJackModePresent";
      
      private static const dbusAirSuspensionWarningPresent:String = "airSuspensionWarningPresent";
      
      private static const dbusAutoAeroModePresent:String = "autoAeroModePresent";
      
      private static const dbusAutoDoorUnlockPresent:String = "autoDoorUnlockPresent";
      
      private static const dbusEasySeatExitPresent:String = "easySeatExitPresent";
      
      private static const dbusHeadLampOffDelayPresent:String = "headlampOffDelayPresent";
      
      private static const dbusflashLampWithLockPresent:String = "flashLampWithLockPresent";
      
      private static const dbusIlluminatedApproachPresent:String = "illuminatedApproachPresent";
      
      private static const dbusFlashLightsWithRemoteLower:String = "flashLightsWithRemoteLowerPresent";
      
      private static const dbusNavigationTurnByTurnPresent:String = "navigationTurnByTurnPresent";
      
      private static const dbusNavigationRepetitionPresent:String = "navigationRepetitionPresent";
      
      private static const dbusHornWithRemoteLower:String = "hornWithRemoteLowerPresent";
      
      private static const dbusParkAssistBraking:String = "parkAssistBrakingPresent";
      
      private static const dbusParkAssistFrontVolumePresent:String = "parkAssistFrontVolumePresent";
      
      private static const dbusParkAssistRearVolumePresent:String = "parkAssistRearVolumePresent";
      
      private static const dbusFuelSaverPresent:String = "fuelSaverPresent";
      
      private static const dbusRearCameraDelayPresent:String = "rearCameraDelayPresent";
      
      private static const dbusTiltMirrorInReversePresent:String = "tiltMirrorInReversePresent";
      
      private static const dbusTransportModePresent:String = "transportModePresent";
      
      private static const dbusWheelAligmentPresent:String = "wheelAlignmentPresent";
      
      private static const dbusRearCameraGridlinesType:String = "rearCameraGridType";
      
      private static const dbusUnitOptionPresent:String = "USMetricPresent";
      
      private static const dbusAutoEntryExitPresent:String = "autoEntryExitPresent";
      
      private static const dbusTrailerNumberPresent:String = "trailerNumberPresent";
      
      private static const dbusTrailerTypePresent:String = "trailerTypePresent";
      
      private static const dbusTrailerNamePresent:String = "trailerNamePresent";
      
      private static const dbusAutoDriverComfortPresent:String = "autoDriverComfortPresent";
      
      private static const dbusAppButtonPresent:String = "appsButtonPresent";
      
      private static const dbusSyncTimePresent:String = "syncTimePresent";
      
      private static const dbusNavigationPresent:String = "navigationPresent";
      
      private static const dbusRadioOnPresent:String = "RadioOnPresent";
      
      private static const dbusRadioOffPresent:String = "RadioOffPresent";
      
      private static const dbusAutoOnFeatureMethod:String = "autoOnFeatureMethod";
      
      private static const dbusSideDistanceWarningPresent:String = "sideDistanceWarningPresent";
      
      private static const dbusUnitSetPresent:String = "unitSetPresent";
      
      private static const dbusPressureUnitsPresent:String = "pressureUnitsPresent";
      
      private static const dbusCapacityUnitsPresent:String = "capacityUnitsPresent";
      
      private static const dbusConsumptionUnitsPresent:String = "consumptionUnitsPresent";
      
      private static const dbusDistanceUnitsPresent:String = "distanceUnitsPresent";
      
      private static const dbusPowerUnitsPresent:String = "powerUnitsPresent";
      
      private static const dbusSpeedUnitsPresent:String = "speedUnitsPresent";
      
      private static const dbusTempUnitsPresent:String = "temperatureUnitsPresent";
      
      private static const dbusTorqueUnitsPresent:String = "torqueUnitsPresent";
      
      private static const dbusElectPowerSteeringPresent:String = "ElectPowerSteeringPresent";
      
      private static const dbusFuelType:String = "fuelType";
      
      private static const dbusSetDatePresent:String = "setDatePresent";
      
      private static const dbusClusterDisplayType:String = "clusterDisplayType";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusSwitchOffTime:String = "switchOffTime";
      
      private static const dBusAutoParkBrakePresent:String = "AutoParkBrakePresent";
      
      private static const dBusDNAFeaturePresent:String = "dnaFeaturePresent";
      
      private static const dbusDabPresent:String = "dabPresent";
      
      private static const dbusDTVShortTermPresent:String = "DTVShortTermPresent";
      
      private static const dbusFrontCameraPresent:String = "DTVFrontCameraPresent";
      
      private static const dbusSideCameraPresent:String = "DTVSideCameraPresent";
      
      private static const dbusPwrFoldMirrors:String = "PowerFoldingMirrorsPresent";
      
      private static const dbusVRMPresent:String = "vrmPresent";
      
      private static const dbusTeenKeyFeature:String = "teenKeyFeaturePresent";
      
      private static const dbusTKFCWSensitivity:String = "teenKeyFCWSensitivityPresent";
      
      private static const dbusTKFCWBraking:String = "teenKeyFCWBrakingPresent";
      
      private static const dbusTKParkAssist:String = "teenKeyParkAssistPresent";
      
      private static const dbusTKParkAssistBraking:String = "teenKeyParkAssistBrakingPresent";
      
      private static const dbusTKParkAssistFTvol:String = "teenKeyFTParkAssistVolPresent";
      
      private static const dbusTKParkAssistRRvol:String = "teenKeyRRParkAssistVolPresent";
      
      private static const dbusTKBlindSpot:String = "teenKeyBlindSpotPresent";
      
      private static const dbusTKFuelPopup:String = "teenKeyFuelPopupPresent";
      
      private static const dbusTKFuelWarning:String = "teenKeyFuelWarningPresent";
      
      private static const dbusTKPwrLiftgateChime:String = "teenKeyPwrLiftgateChimePresent";
      
      private static const dbusTKSlidingDoorAlert:String = "teenKeySlidingDoorAlertPresent";
      
      private static const dbusTKAutoWipers:String = "teenKeyRainSenseWipersPresent";
      
      private static const dbusTKHLsWithWipers:String = "teenKeyHLsWithWipersPresent";
      
      private static const dbusTKAutoHighBeams:String = "teenKeyAutoHighBeamsPresent";
      
      private static const dbusTKMaxSpeedLimit:String = "teenKeyMaxSpeedLimitPresent";
      
      private static const dbusSVCDynamicGridLines:String = "svcGridlinesPresent";
      
      private static const dbusSVCDelay:String = "svcDelayPresent";
      
      private static const dbusSVCSoftKey:String = "svcSoftKeyPresent";
      
      private static const dbusPaddlesModeStatus:String = "paddlesModePresent";
      
      private static const dbusSettingsPaddleMode:String = "settingsPaddleModePresent";
      
      private static const dbusCHMSLCameraGuidelines:String = "chmslCameraGuidelinesPresent";
      
      private static const dbusSDARTravelLinkPresent:String = "SDARTravelLinkPresent";
      
      private static const dbusCabinEQCurve:String = "cabinEQCurve";
      
      private static const dbusDriveModePresent:String = "driveModePresent";
      
      private static const dbusEngPowerDrvMdPresent:String = "engPowerDrvMdPresent";
      
      private static const dbusESCDrvMdPresent:String = "ESCDrvMdPresent";
      
      private static const dbusRedKeyPresent:String = "redKeyPresent";
      
      private static const dbusShiftIndicatorType:String = "shiftIndicatorType";
      
      private static const dbusSuperTrackPackPresent:String = "superTrackPackPresent";
      
      private static const dbusTcaseType:String = "TcaseType";
      
      private static const dbusTransEquipped:String = "transEquipped";
      
      private static const dbusTransDrvMdPresent:String = "transDrvMdPresent";
      
      private static const dbusTSBMPresent:String = "TSBMPresent";
      
      private static const dbusSRTPresent:String = "SRTPresent";
      
      private static const dbusSportModePresent:String = "sportModePresent";
      
      private static const dbusEPSPresent:String = "EPS_Present";
      
      private static const dbusADCMPresent:String = "ADCM_Present";
      
      private static const dbusRVCMPresent:String = "RVCM_Present";
      
      private static const dbusHCPPresent:String = "HCP_Present";
      
      private static const dbusReadyToDrivePresent:String = "readyToDrivePresent";
      
      private static const dbusPhoneInfoInClusterPresent:String = "phoneInfoInClusterPresent";
      
      private static const dbusECMirrorHKPresent:String = "ECMirrorHKPresent";
      
      private static const dbusRVCSoftKey:String = "rvcSoftKeyPresent";
      
      private static const dbusDriveModeVersion:String = "driveModeVersion";
      
      private static const dbusNetCfgRearHVACPresent:String = "HVAC_R_Present";
      
      private static const dbusRearDefrostBtnPresent:String = "rearDefrostBtnPresent";
      
      private static const dbusPoliceVehiclePresent:String = "policeVehiclePresent";
      
      private static const dbusPolicePassiveEntryPresent:String = "policePassiveEntryPresent";
      
      private var mNavPresent:Boolean = false;
      
      private var mAmpPresent:Boolean = false;
      
      private var mIcsPresent:Boolean = false;
      
      private var mHaLFPresent:Boolean = false;
      
      private var mEPBPresent:Boolean = false;
      
      private var mPLGPresent:Boolean = false;
      
      private var mHFLGPresent:Boolean = false;
      
      private var mRemoteStartsPresent:Boolean = false;
      
      private var mEcoModePresent:Boolean = false;
      
      private var mAutoHighBeamsPresent:Boolean = false;
      
      private var mSportsModePresent:Boolean = false;
      
      private var mHoldNGoPresent:Boolean = false;
      
      private var mSunShadePresent:Boolean = false;
      
      private var mAutoHeadLampPresent:Boolean = false;
      
      private var mHeadLampDipPresent:Boolean = false;
      
      private var mTemperatureDisplayPresent:Boolean = false;
      
      private var mCompassDisplayPresent:Boolean = false;
      
      private var mCompassCalibrationPresent:Boolean = false;
      
      private var mCompassVariancePresent:Boolean = false;
      
      private var mDigitalClockOverridePresent:Boolean = false;
      
      private var mDisableDispOfDigitalClock:Boolean = false;
      
      private var mPowerOutletPresent:Boolean = false;
      
      private var mHeatedSeatsPresent:Boolean = false;
      
      private var mVentedSeatsPresent:Boolean = false;
      
      private var mHeatedSteeringWheelPresent:Boolean = false;
      
      private var mRkePresent:Boolean = false;
      
      private var mRKEUnlockPresent:Boolean = false;
      
      private var mDoorAlertPresent:Boolean = false;
      
      private var mHFSlidingDoorPresent:Boolean = false;
      
      private var mFlashLightSlideDoorPresent:Boolean = false;
      
      private var mForwardCollisionWarningPresent:String = "absent";
      
      private var mForwardCollisionBrakingPresent:Boolean = false;
      
      private var mFCWOnOffSoftKeyPresent:Boolean = false;
      
      private var mParkAssistPresent:String = "absent";
      
      private var mFrontParkAssistPresent:Boolean = false;
      
      private var mSurroundSoundPresent:Boolean = false;
      
      private var mMemorySeatModulePresent:Boolean = false;
      
      private var mPowerDoorLocksPresent:Boolean = false;
      
      private var mAutoDoorLocksPresent:Boolean = false;
      
      private var mBlindSpotModulePresent:Boolean = false;
      
      private var mRearCameraPresent:Boolean = false;
      
      private var mCargoCameraPresent:Boolean = false;
      
      private var mSurroundCameraPresent:Boolean = false;
      
      private var mHillStartAssistPresent:Boolean = false;
      
      private var mAFLS_Present:Boolean = false;
      
      private var mDRLPresent:Boolean = false;
      
      private var mSoundHornWithLocks:Boolean = false;
      
      private var mSoundHornWithLocksType:String = "1option";
      
      private var mPersonalSettingsAvailable:Boolean = false;
      
      private var mHVACSystemATC:Boolean = false;
      
      private var mItbmPresent:Boolean = false;
      
      private var mHeadRestPresent:Boolean = false;
      
      private var mPassiveEntryPresent:Boolean = false;
      
      private var mAutoRelockPresent:Boolean = false;
      
      private var mAmbientLightingPresent:Boolean = false;
      
      private var mAmbientDimmerSwitchPresent:Boolean = false;
      
      private var mTwilightSensorPresent:Boolean = false;
      
      private var mECMirrorPresent:Boolean = false;
      
      private var mDisplayOnOffSKPresent:Boolean = false;
      
      private var mLDWarningPresent:Boolean = false;
      
      private var mLSSensitivityType:String = "";
      
      private var mLSTorqueType:String = "";
      
      private var mAdaptiveFrontLightSystemPresent:Boolean = false;
      
      private var mGreetingLightsPresent:Boolean = false;
      
      private var mDistanceOptionPresent:Boolean = false;
      
      private var mCorneringLightsPresent:Boolean = false;
      
      private var mAccessoryDelayPresent:Boolean = false;
      
      private var mTireJackModePresent:Boolean = false;
      
      private var mAirSuspensionWarningPresent:Boolean = false;
      
      private var mAutoAeroModePresent:Boolean = false;
      
      private var mAutoDoorUnlockPresent:Boolean = false;
      
      private var mEasySeatExitPresent:Boolean = false;
      
      private var mFlashLampsWithLock:Boolean = false;
      
      private var mHeadLampOffDelayPresent:Boolean = false;
      
      private var mIlluminatedApproach:Boolean = false;
      
      private var mFlashLightsWithRemoteLower:Boolean = false;
      
      private var mNavigationTurnByTurnPresent:Boolean = false;
      
      private var mNavigationRepetitionPresent:Boolean = false;
      
      private var mHornWithRemoteLower:Boolean = false;
      
      private var mParkAssistBraking:Boolean = false;
      
      private var mParkAssistFrontVolumePresent:Boolean = false;
      
      private var mParkAssistRearVolumePresent:Boolean = false;
      
      private var mFuelSaverPresent:Boolean = false;
      
      private var mRearCameraDelayPresent:Boolean = false;
      
      private var mTiltMirrorInReversePresent:Boolean = false;
      
      private var mTransportModePresent:Boolean = false;
      
      private var mWheelAligmentPresent:Boolean = false;
      
      private var mRearCameraGridlinesType:String = "absent";
      
      private var mUnitOptionPresent:Boolean = false;
      
      private var mUnitSetPresent:Boolean = false;
      
      private var mAutoEntryExitPresent:Boolean = false;
      
      private var mTrailerNumberPresent:Boolean = false;
      
      private var mTrailerTypePresent:Boolean = false;
      
      private var mTrailerNamePresent:Boolean = false;
      
      private var mAutoDriverComfortPresent:Boolean = false;
      
      private var mAppsButtonPresent:Boolean = false;
      
      private var mSyncTimePresent:Boolean = false;
      
      private var mNavigationPresent:Boolean = false;
      
      private var mRadioOnPresent:Boolean = false;
      
      private var mRadioOffPresent:Boolean = false;
      
      private var mElectPowerSteeringPresent:Boolean = false;
      
      private var mPressureUnitsPresent:Boolean = false;
      
      private var mCapacityUnitsPresent:Boolean = false;
      
      private var mDistanceUnitsPresent:Boolean = false;
      
      private var mPowerUnitsPresent:Boolean = false;
      
      private var mConsumptionUnitsPresent:Boolean = false;
      
      private var mSpeedUnitsPresent:Boolean = false;
      
      private var mTemperatureUnitsPresent:Boolean = false;
      
      private var mTorqueUnitsPresent:Boolean = false;
      
      private var mSetDatePresent:Boolean = false;
      
      private var mSideDistanceWarningPresent:Boolean = false;
      
      private var mAutoParkBrakePresent:Boolean = false;
      
      private var mDNAFeaturePresent:Boolean = false;
      
      private var mDabPresent:Boolean = false;
      
      private var mDTVShortTermPresent:Boolean = false;
      
      private var mFrontCameraPresent:Boolean = false;
      
      private var mSideCameraPresent:Boolean = false;
      
      private var mPwrFoldMirrorsPresent:Boolean = false;
      
      private var mVRMPresent:Boolean = false;
      
      private var mRainSensorType:String = "absent";
      
      private var mVehicleBrandConfig:String = "";
      
      private var mModelYearConfig:String = "";
      
      private var mSteeringWheelConfig:String = "";
      
      private var mVehicleLineConfig:String = "";
      
      private var mTransmissionConfig:String = "";
      
      private var mCountryCodeConfig:String = "";
      
      private var mBodyStyleConfig:String = "";
      
      private var mSpecialPackageConfig:String = "";
      
      private var mHvacConfig:String = "";
      
      private var mDestinationConfig:String = "";
      
      private var mDestinationNameConfig:String = "";
      
      private var mVariantMarket:String = "";
      
      private var mParkAssistConfiguration:String = "";
      
      private var mAudioSystemType:String = "";
      
      private var mExternalPortType:String = "";
      
      private var mAdditionalLanguages:Array = [];
      
      private var mEngineTypeVariant:String = "";
      
      private var mAutoOnFeatureMethod:String = "";
      
      private var mFuelType:String = "";
      
      private var mClusterDisplayType:String = "";
      
      private var mSwitchOffTime:String = "";
      
      private var firstPass:Boolean = true;
      
      private var mVehicleBrandName:String = "";
      
      private var mTeenKeyFeature:Boolean = false;
      
      private var mTKFCWSensitivity:Boolean = false;
      
      private var mTKFCWBraking:Boolean = false;
      
      private var mTKParkAssist:Boolean = false;
      
      private var mTKParkAssistBraking:Boolean = false;
      
      private var mTKParkAssistFTvol:Boolean = false;
      
      private var mTKParkAssistRRvol:Boolean = false;
      
      private var mTKBlindSpot:Boolean = false;
      
      private var mTKFuelPopup:Boolean = false;
      
      private var mTKFuelWarning:Boolean = false;
      
      private var mTKPwrLiftgateChime:Boolean = false;
      
      private var mTKSlidingDoorAlert:Boolean = false;
      
      private var mTKAutoWipers:Boolean = false;
      
      private var mTKHLsWithWipers:Boolean = false;
      
      private var mTKAutoHighBeams:Boolean = false;
      
      private var mTKMaxSpeedLimit:Boolean = false;
      
      private var mSVCDynamicGridLines:Boolean = false;
      
      private var mSVCDelay:Boolean = false;
      
      private var mSVCSoftKey:Boolean = false;
      
      private var mPaddlesModePresent:Boolean = false;
      
      private var mSettingsPaddleModePresent:Boolean = false;
      
      private var mCHMSLCameraGuidelinesPresent:Boolean = false;
      
      private var mSDARTravelLinkPresent:Boolean = false;
      
      private var mCabinEQCurve:String = "";
      
      private var mDriveModePresent:Boolean = false;
      
      private var mEngPowerDrvMdPresent:Boolean = false;
      
      private var mESCDrvMdPresent:Boolean = false;
      
      private var mRedKeyPresent:Boolean = false;
      
      private var mshiftIndicatorType:String = "";
      
      private var mSuperTrackPackPresent:Boolean = false;
      
      private var mTcaseType:String = "";
      
      private var mTransEquipped:String = "";
      
      private var mTransDrvMdPresent:Boolean = false;
      
      private var mTSBMPresent:Boolean = false;
      
      private var mSRTPresent:Boolean = false;
      
      private var mSportModePresent:Boolean = false;
      
      private var mEPSPresent:Boolean = false;
      
      private var mADCMPresent:Boolean = false;
      
      private var mRVCMPresent:Boolean = false;
      
      private var mHybridControlPresent:Boolean = false;
      
      private var mReadyToDrivePresent:Boolean = false;
      
      private var mphoneInfoInClusterPresent:Boolean = false;
      
      private var mECMirrorHKPresent:Boolean = false;
      
      private var mRVCSoftKey:Boolean = false;
      
      private var mDriveModeVersion:String = "";
      
      private var mNetCfgRearHVACPresent:Boolean = false;
      
      private var mRearDefrostBtnPresent:Boolean = false;
      
      private var mPoliceVehiclePresent:Boolean = false;
      
      private var mPolicePassiveEntryPresent:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mVehConfigServicePresent:Boolean = false;
      
      public function VehConfig()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_CONFIG,this.vehicleConfigMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : VehConfig
      {
         if(instance == null)
         {
            instance = new VehConfig();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var _loc2_:String = signalName;
         switch(0)
         {
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var _loc2_:String = signalName;
         switch(0)
         {
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected) && !this.firstPass;
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      public function get hasNav() : Boolean
      {
         return this.mNavPresent;
      }
      
      public function get hasAmp() : Boolean
      {
         return this.mAmpPresent;
      }
      
      public function get hasIcs() : Boolean
      {
         return this.mIcsPresent;
      }
      
      public function get hasHapticLaneFeedback() : Boolean
      {
         return this.mHaLFPresent;
      }
      
      public function get hasElectParkBrake() : Boolean
      {
         return this.mEPBPresent;
      }
      
      public function get hasSetDatePreset() : Boolean
      {
         return this.mSetDatePresent;
      }
      
      public function get hasElectPowerSteering() : Boolean
      {
         return this.mElectPowerSteeringPresent;
      }
      
      public function get fuelTypeConfig() : String
      {
         return this.mFuelType;
      }
      
      public function get clusterDisplayType() : String
      {
         return this.mClusterDisplayType;
      }
      
      public function get hasPowerLiftGate() : Boolean
      {
         return this.mPLGPresent;
      }
      
      public function get hasHFLiftGate() : Boolean
      {
         return this.mHFLGPresent;
      }
      
      public function get hasRemoteStart() : Boolean
      {
         return this.mRemoteStartsPresent;
      }
      
      public function get hasEcoMode() : Boolean
      {
         return this.mEcoModePresent;
      }
      
      public function get hasAutoHighBeams() : Boolean
      {
         return this.mAutoHighBeamsPresent;
      }
      
      public function get hasAutoHeadLamp() : Boolean
      {
         return this.mAutoHeadLampPresent;
      }
      
      public function get hasHeadLampDip() : Boolean
      {
         return this.mHeadLampDipPresent;
      }
      
      public function get hasSportsMode() : Boolean
      {
         return this.mSportsModePresent;
      }
      
      public function get hasHoldNGo() : Boolean
      {
         return this.mHoldNGoPresent;
      }
      
      public function get hasSunShade() : Boolean
      {
         return this.mSunShadePresent;
      }
      
      public function get hasTemperatureDisplay() : Boolean
      {
         return this.mTemperatureDisplayPresent;
      }
      
      public function get hasCompassDisplay() : Boolean
      {
         return this.mCompassDisplayPresent;
      }
      
      public function get hasCompassVariance() : Boolean
      {
         return this.mCompassVariancePresent;
      }
      
      public function get hasCompassCalibration() : Boolean
      {
         return this.mCompassCalibrationPresent;
      }
      
      public function get disableClockDisplay() : Boolean
      {
         return this.mDisableDispOfDigitalClock;
      }
      
      public function get hasClockDisplayOverride() : Boolean
      {
         return this.mDigitalClockOverridePresent;
      }
      
      public function get hasOutlet() : Boolean
      {
         return this.mPowerOutletPresent;
      }
      
      public function get hasHeatedSeat() : Boolean
      {
         return this.mHeatedSeatsPresent;
      }
      
      public function get hasVentedSeat() : Boolean
      {
         return this.mVentedSeatsPresent;
      }
      
      public function get hasHeatedSteeringWheel() : Boolean
      {
         return this.mHeatedSteeringWheelPresent;
      }
      
      public function get rainSensorType() : String
      {
         return this.mRainSensorType;
      }
      
      public function get hasRke() : Boolean
      {
         return this.mRkePresent;
      }
      
      public function get hasDoorAlert() : Boolean
      {
         return this.mDoorAlertPresent;
      }
      
      public function get hasHFSlidingDoor() : Boolean
      {
         return this.mHFSlidingDoorPresent;
      }
      
      public function get hasFlashLightSlideDoor() : Boolean
      {
         return this.mFlashLightSlideDoorPresent;
      }
      
      public function get ForwardCollisionWarning() : String
      {
         return this.mForwardCollisionWarningPresent;
      }
      
      public function get hasForwardCollisionBraking() : Boolean
      {
         return this.mForwardCollisionBrakingPresent;
      }
      
      public function get hasFCWOnOffSoftKey() : Boolean
      {
         return this.mFCWOnOffSoftKeyPresent;
      }
      
      public function get hasFrontParkAssist() : Boolean
      {
         return this.mFrontParkAssistPresent;
      }
      
      public function get parkAssist() : String
      {
         return this.mParkAssistPresent;
      }
      
      public function get hasPassiveEntry() : Boolean
      {
         return this.mPassiveEntryPresent;
      }
      
      public function get hasAutoRelockingPE() : Boolean
      {
         return this.mAutoRelockPresent;
      }
      
      public function get hasAmbientLighting() : Boolean
      {
         return this.mAmbientLightingPresent;
      }
      
      public function get hasAmbientDimmerSwitch() : Boolean
      {
         return this.mAmbientDimmerSwitchPresent;
      }
      
      public function get hasSurroundSound() : Boolean
      {
         return this.mSurroundSoundPresent;
      }
      
      public function get hasPowerDoorLocks() : Boolean
      {
         return this.mPowerDoorLocksPresent;
      }
      
      public function get hasAutoDoorLocks() : Boolean
      {
         return this.mAutoDoorLocksPresent;
      }
      
      public function get hasMemorySeatModule() : Boolean
      {
         return this.mMemorySeatModulePresent;
      }
      
      public function get hasBlindSpotModule() : Boolean
      {
         return this.mBlindSpotModulePresent;
      }
      
      public function get hasRearCamera() : Boolean
      {
         return this.mRearCameraPresent;
      }
      
      public function get hasCargoCamera() : Boolean
      {
         return this.mCargoCameraPresent;
      }
      
      public function get hasFrontCamera() : Boolean
      {
         return this.mFrontCameraPresent;
      }
      
      public function get hasSideCamera() : Boolean
      {
         return this.mSideCameraPresent;
      }
      
      public function get hasSurroundCamera() : Boolean
      {
         return this.mSurroundCameraPresent;
      }
      
      public function get hasHillStartAssist() : Boolean
      {
         return this.mHillStartAssistPresent;
      }
      
      public function get hasAdvancedFrontLightSystem() : Boolean
      {
         return this.mAFLS_Present;
      }
      
      public function get hasAdaptiveFrontLightSystem() : Boolean
      {
         return this.mAdaptiveFrontLightSystemPresent;
      }
      
      public function get hasDayTimeRunningLights() : Boolean
      {
         return this.mDRLPresent;
      }
      
      public function get hasHeadRest() : Boolean
      {
         return this.mHeadRestPresent;
      }
      
      public function get hasECMirror() : Boolean
      {
         return this.mECMirrorPresent;
      }
      
      public function get hasDisplayOnOffSK() : Boolean
      {
         return this.mDisplayOnOffSKPresent;
      }
      
      public function get soundHornWithLocks() : Boolean
      {
         return this.mSoundHornWithLocks;
      }
      
      public function get soundHornWithLocksType() : String
      {
         return this.mSoundHornWithLocksType;
      }
      
      public function get personalSettingsAvailable() : Boolean
      {
         return this.mPersonalSettingsAvailable;
      }
      
      public function get hvacSystemAutomatic() : Boolean
      {
         return this.mHVACSystemATC;
      }
      
      public function get hasTrailerBrakesModule() : Boolean
      {
         return this.mItbmPresent;
      }
      
      public function get hasHeadlightSensitivityLevelPresent() : Boolean
      {
         return this.mTwilightSensorPresent;
      }
      
      public function get hasLaneDepartureWarningPresent() : Boolean
      {
         return this.mLDWarningPresent;
      }
      
      public function get laneSenseSensitivityType() : String
      {
         return this.mLSSensitivityType;
      }
      
      public function get laneSenseTorqueType() : String
      {
         return this.mLSTorqueType;
      }
      
      public function get hasGreetingLights() : Boolean
      {
         return this.mGreetingLightsPresent;
      }
      
      public function get hasDistanceOption() : Boolean
      {
         return this.mDistanceOptionPresent;
      }
      
      public function get hasCorneringLights() : Boolean
      {
         return this.mCorneringLightsPresent;
      }
      
      public function get hasAccessoryDelay() : Boolean
      {
         return this.mAccessoryDelayPresent;
      }
      
      public function get hasTireJackMode() : Boolean
      {
         return this.mTireJackModePresent;
      }
      
      public function get hasAirSuspensionWarning() : Boolean
      {
         return this.mAirSuspensionWarningPresent;
      }
      
      public function get hasAutoAeroMode() : Boolean
      {
         return this.mAutoAeroModePresent;
      }
      
      public function get hasAutoDoorUnlock() : Boolean
      {
         return this.mAutoDoorUnlockPresent;
      }
      
      public function get hasEasySeatExit() : Boolean
      {
         return this.mEasySeatExitPresent;
      }
      
      public function get hasFlashLampsWithLock() : Boolean
      {
         return this.mFlashLampsWithLock;
      }
      
      public function get hasHeadlampOffDelay() : Boolean
      {
         return this.mHeadLampOffDelayPresent;
      }
      
      public function get hasIlluminatedApproach() : Boolean
      {
         return this.mIlluminatedApproach;
      }
      
      public function get hasFlashLightsWithRemoteLower() : Boolean
      {
         return this.mFlashLightsWithRemoteLower;
      }
      
      public function get hasNavigationTurnByTurn() : Boolean
      {
         return this.mNavigationTurnByTurnPresent;
      }
      
      public function get hasNavigationRepetition() : Boolean
      {
         return this.mNavigationRepetitionPresent;
      }
      
      public function get hasHornWithRemoteLower() : Boolean
      {
         return this.mHornWithRemoteLower;
      }
      
      public function get hasParkAssistBraking() : Boolean
      {
         return this.mParkAssistBraking;
      }
      
      public function get hasParkAssistFrontVolume() : Boolean
      {
         return this.mParkAssistFrontVolumePresent;
      }
      
      public function get hasParkAssistRearVolume() : Boolean
      {
         return this.mParkAssistRearVolumePresent;
      }
      
      public function get hasFuelSaver() : Boolean
      {
         return this.mFuelSaverPresent;
      }
      
      public function get hasRearCameraDelay() : Boolean
      {
         return this.mRearCameraDelayPresent;
      }
      
      public function get hasTiltMirrorInReverse() : Boolean
      {
         return this.mTiltMirrorInReversePresent;
      }
      
      public function get hasTransportMode() : Boolean
      {
         return this.mTransportModePresent;
      }
      
      public function get hasWheelAligment() : Boolean
      {
         return this.mWheelAligmentPresent;
      }
      
      public function get hasUnitOption() : Boolean
      {
         return this.mUnitOptionPresent;
      }
      
      public function get hasUnitSet() : Boolean
      {
         return this.mUnitSetPresent;
      }
      
      public function get hasAutoEntryExit() : Boolean
      {
         return this.mAutoEntryExitPresent;
      }
      
      public function get hasRKEUnlock() : Boolean
      {
         return this.mRKEUnlockPresent;
      }
      
      public function get hasTrailerNumber() : Boolean
      {
         return this.mTrailerNumberPresent;
      }
      
      public function get hasTrailerType() : Boolean
      {
         return this.mTrailerTypePresent;
      }
      
      public function get hasTrailerName() : Boolean
      {
         return this.mTrailerNamePresent;
      }
      
      public function get hasAutoDriverComfort() : Boolean
      {
         return this.mAutoDriverComfortPresent;
      }
      
      public function get hasAppsButton() : Boolean
      {
         return this.mAppsButtonPresent;
      }
      
      public function get hasSyncTime() : Boolean
      {
         return this.mSyncTimePresent;
      }
      
      public function get hasNavigation520() : Boolean
      {
         return this.mNavigationPresent;
      }
      
      public function get hasRadioOn() : Boolean
      {
         return this.mRadioOnPresent;
      }
      
      public function get hasRadioOff() : Boolean
      {
         return this.mRadioOffPresent;
      }
      
      public function get sideDistanceWarningPresent() : Boolean
      {
         return this.mSideDistanceWarningPresent;
      }
      
      public function get pressureUnitsPresent() : Boolean
      {
         return this.mPressureUnitsPresent;
      }
      
      public function get capacityUnitsPresent() : Boolean
      {
         return this.mCapacityUnitsPresent;
      }
      
      public function get hasConsumptionUnits() : Boolean
      {
         return this.mConsumptionUnitsPresent;
      }
      
      public function get consumptionUnitsPresent() : Boolean
      {
         return this.mConsumptionUnitsPresent;
      }
      
      public function get distanceUnitsPresent() : Boolean
      {
         return this.mDistanceUnitsPresent;
      }
      
      public function get powerUnitsPresent() : Boolean
      {
         return this.mPowerUnitsPresent;
      }
      
      public function get speedUnitsPresent() : Boolean
      {
         return this.mSpeedUnitsPresent;
      }
      
      public function get temperatureUnitsPresent() : Boolean
      {
         return this.mTemperatureUnitsPresent;
      }
      
      public function get torqueUnitsPresent() : Boolean
      {
         return this.mTorqueUnitsPresent;
      }
      
      public function get hasAutoParkBrake() : Boolean
      {
         return this.mAutoParkBrakePresent;
      }
      
      public function get hasDNAFeature() : Boolean
      {
         return this.mDNAFeaturePresent;
      }
      
      public function get dabPresent() : Boolean
      {
         return this.mDabPresent;
      }
      
      public function get dtvShortTermPresent() : Boolean
      {
         return this.mDTVShortTermPresent;
      }
      
      public function get hasPwrFoldingMirrors() : Boolean
      {
         return this.mPwrFoldMirrorsPresent;
      }
      
      public function get hasRearMedia() : Boolean
      {
         return this.mVRMPresent;
      }
      
      public function get autoOnFeatureMethod() : String
      {
         return this.mAutoOnFeatureMethod;
      }
      
      public function get vehicleBrand() : String
      {
         return this.mVehicleBrandConfig;
      }
      
      public function get vehicleBrandName() : String
      {
         return this.mVehicleBrandName;
      }
      
      public function get modelYear() : String
      {
         return this.mModelYearConfig;
      }
      
      public function get steeringWheelConfig() : String
      {
         return this.mSteeringWheelConfig;
      }
      
      public function get vehicleLine() : String
      {
         return this.mVehicleLineConfig;
      }
      
      public function get transmissionConfig() : String
      {
         return this.mTransmissionConfig;
      }
      
      public function get countryCode() : String
      {
         return this.mCountryCodeConfig;
      }
      
      public function get bodyStyle() : String
      {
         return this.mBodyStyleConfig;
      }
      
      public function get specialPackageConfig() : String
      {
         return this.mSpecialPackageConfig;
      }
      
      public function get hvacConfig() : String
      {
         return this.mHvacConfig;
      }
      
      public function get vehicleDestination() : String
      {
         return this.mDestinationConfig;
      }
      
      public function get vehicleDestinationName() : String
      {
         return this.mDestinationNameConfig;
      }
      
      public function get variantMarket() : String
      {
         return this.mVariantMarket;
      }
      
      public function get parkAssistConfiguration() : String
      {
         return this.mParkAssistConfiguration;
      }
      
      public function get audioSystemType() : String
      {
         return this.mAudioSystemType;
      }
      
      public function get externalPortType() : String
      {
         return this.mExternalPortType;
      }
      
      public function get additionalLanguages() : Array
      {
         return this.mAdditionalLanguages;
      }
      
      public function get engineTypeVariant() : String
      {
         return this.mEngineTypeVariant;
      }
      
      public function get rearCameraGridlinesType() : String
      {
         return this.mRearCameraGridlinesType;
      }
      
      public function get SwitchOffTime() : String
      {
         return this.mSwitchOffTime;
      }
      
      public function get hasTeenKeyFeature() : Boolean
      {
         return this.mTeenKeyFeature;
      }
      
      public function get hasTKFCWSensitivity() : Boolean
      {
         return this.mTKFCWSensitivity;
      }
      
      public function get hasTKFCWBraking() : Boolean
      {
         return this.mTKFCWBraking;
      }
      
      public function get hasTKParkAssist() : Boolean
      {
         return this.mTKParkAssist;
      }
      
      public function get hasTKParkAssistBraking() : Boolean
      {
         return this.mTKParkAssistBraking;
      }
      
      public function get hasTKParkAssistFTvol() : Boolean
      {
         return this.mTKParkAssistFTvol;
      }
      
      public function get hasTKParkAssistRRvol() : Boolean
      {
         return this.mTKParkAssistRRvol;
      }
      
      public function get hasTKBlindSpot() : Boolean
      {
         return this.mTKBlindSpot;
      }
      
      public function get hasTKFuelPopup() : Boolean
      {
         return this.mTKFuelPopup;
      }
      
      public function get hasTKEarlyFuelWarning() : Boolean
      {
         return this.mTKFuelWarning;
      }
      
      public function get hasTKPwrLiftgateChime() : Boolean
      {
         return this.mTKPwrLiftgateChime;
      }
      
      public function get hasTKSlidingDoorAlert() : Boolean
      {
         return this.mTKSlidingDoorAlert;
      }
      
      public function get hasTKAutoWipers() : Boolean
      {
         return this.mTKAutoWipers;
      }
      
      public function get hasTKHLsWithWipers() : Boolean
      {
         return this.mTKHLsWithWipers;
      }
      
      public function get hasTKAutoHighBeams() : Boolean
      {
         return this.mTKAutoHighBeams;
      }
      
      public function get hasTKMaxSpeedLimit() : Boolean
      {
         return this.mTKMaxSpeedLimit;
      }
      
      public function get hasSVCDynamicGridLines() : Boolean
      {
         return this.mSVCDynamicGridLines;
      }
      
      public function get hasSVCDelay() : Boolean
      {
         return this.mSVCDelay;
      }
      
      public function get hasSVCSoftKey() : Boolean
      {
         return this.mSVCSoftKey;
      }
      
      public function get hasPaddlesMode() : Boolean
      {
         return this.mPaddlesModePresent;
      }
      
      public function get hasSettingsPaddleMode() : Boolean
      {
         return this.mSettingsPaddleModePresent;
      }
      
      public function get hasCHMSLCameraGuidelines() : Boolean
      {
         return this.mCHMSLCameraGuidelinesPresent;
      }
      
      public function get hasSDARTravelLink() : Boolean
      {
         return this.mSDARTravelLinkPresent;
      }
      
      public function get cabinEQCurve() : String
      {
         return this.mCabinEQCurve;
      }
      
      public function get hasDriveModePresent() : Boolean
      {
         return this.mDriveModePresent;
      }
      
      public function get hasEngPowerDrvMdPresent() : Boolean
      {
         return this.mEngPowerDrvMdPresent;
      }
      
      public function get hasESCDrvMdPresent() : Boolean
      {
         return this.mESCDrvMdPresent;
      }
      
      public function get hasRedKeyPresent() : Boolean
      {
         return this.mRedKeyPresent;
      }
      
      public function get shiftIndicatorType() : String
      {
         return this.mshiftIndicatorType;
      }
      
      public function get hasSuperTrackPackPresent() : Boolean
      {
         return this.mSuperTrackPackPresent;
      }
      
      public function get TcaseType() : String
      {
         return this.mTcaseType;
      }
      
      public function get transEquipped() : String
      {
         return this.mTransEquipped;
      }
      
      public function get hasTransDrvMdPresent() : Boolean
      {
         return this.mTransDrvMdPresent;
      }
      
      public function get hasTSBMPresent() : Boolean
      {
         return this.mTSBMPresent;
      }
      
      public function get hasSRTPresent() : Boolean
      {
         return this.mSRTPresent;
      }
      
      public function get hasSportModePresent() : Boolean
      {
         return this.mSportModePresent;
      }
      
      public function get hasEPSPresent() : Boolean
      {
         return this.mEPSPresent;
      }
      
      public function get hasADCMPresent() : Boolean
      {
         return this.mADCMPresent;
      }
      
      public function get hasRVCMPresent() : Boolean
      {
         return this.mRVCMPresent;
      }
      
      public function get hasHybridControlModule() : Boolean
      {
         return this.mHybridControlPresent;
      }
      
      public function get hasReadyToDrivePresent() : Boolean
      {
         return this.mReadyToDrivePresent;
      }
      
      public function get hasPhoneInfoInClusterPresent() : Boolean
      {
         return this.mphoneInfoInClusterPresent;
      }
      
      public function get hasECMirrorHKPresent() : Boolean
      {
         return this.mECMirrorHKPresent;
      }
      
      public function get hasRVCSoftKey() : Boolean
      {
         return this.mRVCSoftKey;
      }
      
      public function get driveModeVersion() : String
      {
         return this.mDriveModeVersion;
      }
      
      public function get hasNetCfgRearHVACPresent() : Boolean
      {
         return this.mNetCfgRearHVACPresent;
      }
      
      public function get hasRearDefrostButton() : Boolean
      {
         return this.mRearDefrostBtnPresent;
      }
      
      public function get hasPoliceVehiclePresent() : Boolean
      {
         return this.mPoliceVehiclePresent;
      }
      
      public function get hasPolicePassiveEntry() : Boolean
      {
         return this.mPolicePassiveEntryPresent;
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.sendSubscribe(dBusAmpPresent);
            this.firstPass = true;
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String = null) : void
      {
         var message:String = null;
         if(value == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String, alternateDbusIdentifer:String = null) : void
      {
         var message:String = null;
         var dbusString:String = null;
         if(alternateDbusIdentifer != null)
         {
            dbusString = alternateDbusIdentifer;
         }
         else
         {
            dbusString = dbusIdentifier;
         }
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusString + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String, alternateDbusIdentifer:String = null) : void
      {
         var message:String = null;
         var dbusString:String = null;
         if(alternateDbusIdentifer != null)
         {
            dbusString = alternateDbusIdentifer;
         }
         else
         {
            dbusString = dbusIdentifier;
         }
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusString + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function clearAll() : void
      {
         this.mNavPresent = false;
         this.mAmpPresent = false;
         this.mIcsPresent = false;
         this.mHaLFPresent = false;
         this.mEPBPresent = false;
         this.mPLGPresent = false;
         this.mHFLGPresent = false;
         this.mRemoteStartsPresent = false;
         this.mEcoModePresent = false;
         this.mAutoHighBeamsPresent = false;
         this.mSportsModePresent = false;
         this.mHoldNGoPresent = false;
         this.mSunShadePresent = false;
         this.mAutoHeadLampPresent = false;
         this.mHeadLampDipPresent = false;
         this.mTemperatureDisplayPresent = false;
         this.mCompassDisplayPresent = false;
         this.mCompassCalibrationPresent = false;
         this.mCompassVariancePresent = false;
         this.mDigitalClockOverridePresent = false;
         this.mDisableDispOfDigitalClock = false;
         this.mPowerOutletPresent = false;
         this.mHeatedSeatsPresent = false;
         this.mVentedSeatsPresent = false;
         this.mHeatedSteeringWheelPresent = false;
         this.mRkePresent = false;
         this.mRKEUnlockPresent = false;
         this.mDoorAlertPresent = false;
         this.mHFSlidingDoorPresent = false;
         this.mFlashLightSlideDoorPresent = false;
         this.mForwardCollisionWarningPresent = "absent";
         this.mForwardCollisionBrakingPresent = false;
         this.mFCWOnOffSoftKeyPresent = false;
         this.mParkAssistPresent = "absent";
         this.mPassiveEntryPresent = false;
         this.mAutoRelockPresent = false;
         this.mAmbientLightingPresent = false;
         this.mAmbientDimmerSwitchPresent = false;
         this.mFrontParkAssistPresent = false;
         this.mSurroundSoundPresent = false;
         this.mMemorySeatModulePresent = false;
         this.mPowerDoorLocksPresent = false;
         this.mAutoDoorLocksPresent = false;
         this.mBlindSpotModulePresent = false;
         this.mRearCameraPresent = false;
         this.mCargoCameraPresent = false;
         this.mSurroundCameraPresent = false;
         this.mHillStartAssistPresent = false;
         this.mAFLS_Present = false;
         this.mDRLPresent = false;
         this.mSoundHornWithLocks = false;
         this.mPersonalSettingsAvailable = false;
         this.mHVACSystemATC = false;
         this.mItbmPresent = false;
         this.mECMirrorPresent = false;
         this.mDisplayOnOffSKPresent = false;
         this.mLDWarningPresent = false;
         this.mLSSensitivityType = "";
         this.mLSTorqueType = "";
         this.mAdaptiveFrontLightSystemPresent = false;
         this.mGreetingLightsPresent = false;
         this.mDistanceOptionPresent = false;
         this.mCorneringLightsPresent = false;
         this.mDistanceOptionPresent = false;
         this.mAccessoryDelayPresent = false;
         this.mTireJackModePresent = false;
         this.mAirSuspensionWarningPresent = false;
         this.mAutoAeroModePresent = false;
         this.mAutoDoorUnlockPresent = false;
         this.mEasySeatExitPresent = false;
         this.mFlashLampsWithLock = false;
         this.mHeadLampOffDelayPresent = false;
         this.mIlluminatedApproach = false;
         this.mFlashLightsWithRemoteLower = false;
         this.mHornWithRemoteLower = false;
         this.mParkAssistBraking = false;
         this.mParkAssistFrontVolumePresent = false;
         this.mParkAssistRearVolumePresent = false;
         this.mFuelSaverPresent = false;
         this.mAppsButtonPresent = false;
         this.mSyncTimePresent = false;
         this.mNavigationPresent = false;
         this.mRadioOnPresent = false;
         this.mRadioOffPresent = false;
         this.mSideDistanceWarningPresent = false;
         this.mUnitSetPresent = false;
         this.mPressureUnitsPresent = false;
         this.mCapacityUnitsPresent = false;
         this.mConsumptionUnitsPresent = false;
         this.mDistanceUnitsPresent = false;
         this.mPowerUnitsPresent = false;
         this.mSpeedUnitsPresent = false;
         this.mTemperatureUnitsPresent = false;
         this.mTorqueUnitsPresent = false;
         this.mSetDatePresent = false;
         this.mAutoParkBrakePresent = false;
         this.mDNAFeaturePresent = false;
         this.mDabPresent = false;
         this.mDTVShortTermPresent = false;
         this.mFrontCameraPresent = false;
         this.mSideCameraPresent = false;
         this.mPwrFoldMirrorsPresent = false;
         this.mAutoOnFeatureMethod = "";
         this.mElectPowerSteeringPresent = false;
         this.mRainSensorType = "absent";
         this.mVehicleBrandConfig = "";
         this.mModelYearConfig = "";
         this.mSteeringWheelConfig = "";
         this.mVehicleLineConfig = "";
         this.mTransmissionConfig = "";
         this.mCountryCodeConfig = "";
         this.mBodyStyleConfig = "";
         this.mSpecialPackageConfig = "";
         this.mHvacConfig = "";
         this.mDestinationConfig = "";
         this.mDestinationNameConfig = "";
         this.mVariantMarket = "";
         this.mParkAssistConfiguration = "";
         this.mAudioSystemType = "";
         this.mExternalPortType = "";
         this.mAdditionalLanguages = [];
         this.mEngineTypeVariant = "";
         this.mFuelType = "";
         this.mClusterDisplayType = "";
         this.mSwitchOffTime = "";
         this.mVehicleBrandName = "";
         this.mTeenKeyFeature = false;
         this.mTKFCWSensitivity = false;
         this.mTKFCWBraking = false;
         this.mTKParkAssist = false;
         this.mTKParkAssistBraking = false;
         this.mTKParkAssistFTvol = false;
         this.mTKParkAssistRRvol = false;
         this.mTKBlindSpot = false;
         this.mTKFuelPopup = false;
         this.mTKFuelWarning = false;
         this.mTKPwrLiftgateChime = false;
         this.mTKSlidingDoorAlert = false;
         this.mTKAutoWipers = false;
         this.mTKHLsWithWipers = false;
         this.mTKAutoHighBeams = false;
         this.mTKMaxSpeedLimit = false;
         this.mSVCDynamicGridLines = false;
         this.mSVCDelay = false;
         this.mSVCSoftKey = false;
         this.mPaddlesModePresent = false;
         this.mSettingsPaddleModePresent = false;
         this.mCHMSLCameraGuidelinesPresent = false;
         this.mSDARTravelLinkPresent = false;
         this.mCabinEQCurve = "";
         this.mDriveModePresent = false;
         this.mEngPowerDrvMdPresent = false;
         this.mESCDrvMdPresent = false;
         this.mRedKeyPresent = false;
         this.mshiftIndicatorType = "";
         this.mSuperTrackPackPresent = false;
         this.mTcaseType = "";
         this.mTransEquipped = "";
         this.mTransDrvMdPresent = false;
         this.mTSBMPresent = false;
         this.mSRTPresent = false;
         this.mSportModePresent = false;
         this.mEPSPresent = false;
         this.mADCMPresent = false;
         this.mRVCMPresent = false;
         this.mHybridControlPresent = false;
         this.mReadyToDrivePresent = false;
         this.mphoneInfoInClusterPresent = false;
         this.mECMirrorHKPresent = false;
         this.mRVCSoftKey = false;
         this.mDriveModeVersion = "";
         this.mRearDefrostBtnPresent = false;
         this.mPoliceVehiclePresent = false;
         this.mPolicePassiveEntryPresent = false;
      }
      
      private function vehicleConfigMessageHandler(e:ConnectionEvent) : void
      {
         var vehicleConfig:Object = e.data;
         if(vehicleConfig.hasOwnProperty("dBusServiceAvailable"))
         {
            if(vehicleConfig.dBusServiceAvailable == "true" && this.mVehConfigServicePresent == false)
            {
               this.mVehConfigServicePresent = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
            }
            else if(vehicleConfig.dBusServiceAvailable == "false")
            {
               this.mVehConfigServicePresent = false;
            }
         }
         if(vehicleConfig.hasOwnProperty(dBusApiGetProperties))
         {
            this.handlePropertyMessage(vehicleConfig.getProperties);
         }
         if(vehicleConfig.hasOwnProperty(dBusApiGetAllProperties))
         {
            this.clearAll();
            this.handlePropertyMessage(vehicleConfig.getAllProperties);
            if(this.firstPass)
            {
               this.firstPass = false;
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            }
         }
      }
      
      public function handlePropertyMessage(msg:Object) : void
      {
         if(msg.hasOwnProperty(dBusVariantMarketConfig))
         {
            this.mVariantMarket = msg.variant_market;
            dispatchEvent(new VehConfigEvent(VehConfigEvent.VARIANT_MARKET,msg.variant_market));
         }
         if(msg.hasOwnProperty(dBusPersonalSettingsAvailable))
         {
            this.mPersonalSettingsAvailable = msg[dBusPersonalSettingsAvailable] == "true";
         }
         if(msg.hasOwnProperty(dBusSoundHornWithLocks))
         {
            this.mSoundHornWithLocks = msg[dBusSoundHornWithLocks] == "1option" || msg[dBusSoundHornWithLocks] == "3option";
            this.mSoundHornWithLocksType = msg[dBusSoundHornWithLocks];
         }
         if(msg.hasOwnProperty(dBusDRLPresent))
         {
            this.mDRLPresent = msg[dBusDRLPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAFLS_Present))
         {
            this.mAFLS_Present = msg[dBusAFLS_Present] == "true";
         }
         if(msg.hasOwnProperty(dbusAdaptiveFrontLightSystemPresent))
         {
            this.mAdaptiveFrontLightSystemPresent = msg[dbusAdaptiveFrontLightSystemPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHillStartAssistPresent))
         {
            this.mHillStartAssistPresent = msg[dBusHillStartAssistPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusRearCameraPresent))
         {
            this.mRearCameraPresent = msg[dBusRearCameraPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusCargoCameraPresent))
         {
            this.mCargoCameraPresent = msg[dBusCargoCameraPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusSurroundCameraPresent))
         {
            this.mSurroundCameraPresent = msg[dBusSurroundCameraPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusBlindSpotModulePresent))
         {
            this.mBlindSpotModulePresent = msg[dBusBlindSpotModulePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusMemorySeatModulePreset))
         {
            this.mMemorySeatModulePresent = msg[dBusMemorySeatModulePreset] == "true";
         }
         if(msg.hasOwnProperty(dBusNavPresent))
         {
            this.mNavPresent = msg[dBusNavPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAmpPresent))
         {
            this.mAmpPresent = msg[dBusAmpPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusIcsPresent))
         {
            this.mIcsPresent = msg[dBusIcsPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHaLFPresent))
         {
            this.mHaLFPresent = msg[dBusHaLFPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusEPBPresent))
         {
            this.mEPBPresent = msg[dBusEPBPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusElectPowerSteeringPresent))
         {
            this.mElectPowerSteeringPresent = msg[dbusElectPowerSteeringPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusFuelType))
         {
            this.mFuelType = msg[dbusFuelType];
         }
         if(msg.hasOwnProperty(dbusSetDatePresent))
         {
            this.mSetDatePresent = msg[dbusSetDatePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusClusterDisplayType))
         {
            this.mClusterDisplayType = msg[dbusClusterDisplayType];
         }
         if(msg.hasOwnProperty(dBusSwitchOffTime))
         {
            this.mSwitchOffTime = msg[dBusSwitchOffTime];
         }
         if(msg.hasOwnProperty(dBusPLGPresent))
         {
            this.mPLGPresent = msg[dBusPLGPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHFLGPresent))
         {
            this.mHFLGPresent = msg[dBusHFLGPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusRemoteStartPresent))
         {
            this.mRemoteStartsPresent = msg[dBusRemoteStartPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusEcoModePresent))
         {
            this.mEcoModePresent = msg[dBusEcoModePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAutoHighBeamsPresent))
         {
            this.mAutoHighBeamsPresent = msg[dBusAutoHighBeamsPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusSportsModePresent))
         {
            this.mSportsModePresent = msg[dBusSportsModePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHoldNGoPresent))
         {
            this.mHoldNGoPresent = msg[dBusHoldNGoPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusSunShadePresent))
         {
            this.mSunShadePresent = msg[dBusSunShadePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAutoHeadLampPresent))
         {
            this.mAutoHeadLampPresent = msg[dBusAutoHeadLampPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHeadlampDipPresent))
         {
            this.mHeadLampDipPresent = msg[dBusHeadlampDipPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusTemperatureDisplayPresent))
         {
            this.mTemperatureDisplayPresent = msg[dBusTemperatureDisplayPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusCompassDisplayPresent))
         {
            this.mCompassDisplayPresent = msg[dBusCompassDisplayPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusCompassCalibrationPresent))
         {
            this.mCompassCalibrationPresent = msg[dBusCompassCalibrationPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusCompassVariancePresent))
         {
            this.mCompassVariancePresent = msg[dBusCompassVariancePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusdigitalClockPresent))
         {
            this.mDigitalClockOverridePresent = msg[dBusdigitalClockPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusDispOfDigitalClock))
         {
            this.mDisableDispOfDigitalClock = msg[dBusDispOfDigitalClock] == "true";
         }
         if(msg.hasOwnProperty(dBusPowerOutletPresent))
         {
            this.mPowerOutletPresent = msg[dBusPowerOutletPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHeatedSeatsPresent))
         {
            this.mHeatedSeatsPresent = msg[dBusHeatedSeatsPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusVentedSeatsPresent))
         {
            this.mVentedSeatsPresent = msg[dBusVentedSeatsPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHeatedSteeringWheelPresent))
         {
            this.mHeatedSteeringWheelPresent = msg[dBusHeatedSteeringWheelPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusRainSensorPresent))
         {
            this.mRainSensorType = msg[dBusRainSensorPresent];
         }
         if(msg.hasOwnProperty(dBusRkePresent))
         {
            this.mRkePresent = msg[dBusRkePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusRKEUnlockPresent))
         {
            this.mRKEUnlockPresent = msg[dBusRKEUnlockPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusDoorAlertPresent))
         {
            this.mDoorAlertPresent = msg[dBusDoorAlertPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusHFSlidingDoorPresent))
         {
            this.mHFSlidingDoorPresent = msg[dBusHFSlidingDoorPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusFlashLightSlideDoorPresent))
         {
            this.mFlashLightSlideDoorPresent = msg[dBusFlashLightSlideDoorPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusForwardCollisionWarningPresent))
         {
            this.mForwardCollisionWarningPresent = msg[dBusForwardCollisionWarningPresent];
         }
         if(msg.hasOwnProperty(dBusForwardCollisionBrakingPresent))
         {
            this.mForwardCollisionBrakingPresent = msg[dBusForwardCollisionBrakingPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusFCWOnOffSoftKeyPresent))
         {
            this.mFCWOnOffSoftKeyPresent = msg[dBusFCWOnOffSoftKeyPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusParkAssistPresent))
         {
            this.mParkAssistPresent = msg[dBusParkAssistPresent];
         }
         if(msg.hasOwnProperty(dBusPassiveEntryPresent))
         {
            this.mPassiveEntryPresent = msg[dBusPassiveEntryPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAutoRelockPresent))
         {
            this.mAutoRelockPresent = msg[dBusAutoRelockPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAmbientLightingPresent))
         {
            this.mAmbientLightingPresent = msg[dBusAmbientLightingPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAmbientDimmerSwitchPresent))
         {
            this.mAmbientDimmerSwitchPresent = msg[dbusAmbientDimmerSwitchPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusFrontParkAssistPresent))
         {
            this.mFrontParkAssistPresent = msg[dBusFrontParkAssistPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusSurroundSoundPresent))
         {
            this.mSurroundSoundPresent = msg[dBusSurroundSoundPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusPowerDoorLocksPresent))
         {
            this.mPowerDoorLocksPresent = msg[dBusPowerDoorLocksPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAutoDoorLocksPresent))
         {
            this.mAutoDoorLocksPresent = msg[dBusAutoDoorLocksPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusItbmPresent))
         {
            this.mItbmPresent = msg[dBusItbmPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusTwilightSensorPresent))
         {
            this.mTwilightSensorPresent = msg[dBusTwilightSensorPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusECMirrorPresent))
         {
            this.mECMirrorPresent = msg[dBusECMirrorPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusDisplayOnOffSKPresent))
         {
            this.mDisplayOnOffSKPresent = msg[dbusDisplayOnOffSKPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusLaneDepartureWarningPresent))
         {
            this.mLDWarningPresent = msg[dBusLaneDepartureWarningPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusLSSensitivityType))
         {
            this.mLSSensitivityType = msg[dBusLSSensitivityType];
         }
         if(msg.hasOwnProperty(dBusLSTorqueType))
         {
            this.mLSTorqueType = msg[dBusLSTorqueType];
         }
         if(msg.hasOwnProperty(dbusAdaptiveFrontLightSystemPresent))
         {
            this.mAdaptiveFrontLightSystemPresent = msg[dbusAdaptiveFrontLightSystemPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusGreetingLightsPresent))
         {
            this.mGreetingLightsPresent = msg[dbusGreetingLightsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusCorneringLightsPresent))
         {
            this.mCorneringLightsPresent = msg[dbusCorneringLightsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusDistanceOptionPresent))
         {
            this.mDistanceOptionPresent = msg[dbusDistanceOptionPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAccessoryDelayPresent))
         {
            this.mAccessoryDelayPresent = msg[dbusAccessoryDelayPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTireJackModePresent))
         {
            this.mTireJackModePresent = msg[dbusTireJackModePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAirSuspensionWarningPresent))
         {
            this.mAirSuspensionWarningPresent = msg[dbusAirSuspensionWarningPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAutoAeroModePresent))
         {
            this.mAutoAeroModePresent = msg[dbusAutoAeroModePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAutoDoorUnlockPresent))
         {
            this.mAutoDoorUnlockPresent = msg[dbusAutoDoorUnlockPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusEasySeatExitPresent))
         {
            this.mEasySeatExitPresent = msg[dbusEasySeatExitPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusflashLampWithLockPresent))
         {
            this.mFlashLampsWithLock = msg[dbusflashLampWithLockPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusHeadLampOffDelayPresent))
         {
            this.mHeadLampOffDelayPresent = msg[dbusHeadLampOffDelayPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusIlluminatedApproachPresent))
         {
            this.mIlluminatedApproach = msg[dbusIlluminatedApproachPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusFlashLightsWithRemoteLower))
         {
            this.mFlashLightsWithRemoteLower = msg[dbusFlashLightsWithRemoteLower] == "true";
         }
         if(msg.hasOwnProperty(dbusNavigationTurnByTurnPresent))
         {
            this.mNavigationTurnByTurnPresent = msg[dbusNavigationTurnByTurnPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusNavigationRepetitionPresent))
         {
            this.mNavigationRepetitionPresent = msg[dbusNavigationRepetitionPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusHornWithRemoteLower))
         {
            this.mHornWithRemoteLower = msg[dbusHornWithRemoteLower] == "true";
         }
         if(msg.hasOwnProperty(dbusParkAssistBraking))
         {
            this.mParkAssistBraking = msg[dbusParkAssistBraking] == "true";
         }
         if(msg.hasOwnProperty(dbusParkAssistFrontVolumePresent))
         {
            this.mParkAssistFrontVolumePresent = msg[dbusParkAssistFrontVolumePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusParkAssistRearVolumePresent))
         {
            this.mParkAssistRearVolumePresent = msg[dbusParkAssistRearVolumePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusFuelSaverPresent))
         {
            this.mFuelSaverPresent = msg[dbusFuelSaverPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRearCameraDelayPresent))
         {
            this.mRearCameraDelayPresent = msg[dbusRearCameraDelayPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTiltMirrorInReversePresent))
         {
            this.mTiltMirrorInReversePresent = msg[dbusTiltMirrorInReversePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTransportModePresent))
         {
            this.mTransportModePresent = msg[dbusTransportModePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusWheelAligmentPresent))
         {
            this.mWheelAligmentPresent = msg[dbusWheelAligmentPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusUnitOptionPresent))
         {
            this.mUnitOptionPresent = msg[dbusUnitOptionPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusUnitSetPresent))
         {
            this.mUnitSetPresent = msg[dbusUnitSetPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAutoEntryExitPresent))
         {
            this.mAutoEntryExitPresent = msg[dbusAutoEntryExitPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTrailerNumberPresent))
         {
            this.mTrailerNumberPresent = msg[dbusTrailerNumberPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTrailerTypePresent))
         {
            this.mTrailerTypePresent = msg[dbusTrailerTypePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTrailerNamePresent))
         {
            this.mTrailerNamePresent = msg[dbusTrailerNamePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAutoDriverComfortPresent))
         {
            this.mAutoDriverComfortPresent = msg[dbusAutoDriverComfortPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAppButtonPresent))
         {
            this.mAppsButtonPresent = msg[dbusAppButtonPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSyncTimePresent))
         {
            this.mSyncTimePresent = msg[dbusSyncTimePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusNavigationPresent))
         {
            this.mNavigationPresent = msg[dbusNavigationPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRadioOnPresent))
         {
            this.mRadioOnPresent = msg[dbusRadioOnPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRadioOffPresent))
         {
            this.mRadioOffPresent = msg[dbusRadioOffPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusAutoParkBrakePresent))
         {
            this.mAutoParkBrakePresent = msg[dBusAutoParkBrakePresent] == "true";
         }
         if(msg.hasOwnProperty(dBusDNAFeaturePresent))
         {
            this.mDNAFeaturePresent = msg[dBusDNAFeaturePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusAutoOnFeatureMethod))
         {
            this.mAutoOnFeatureMethod = msg[dbusAutoOnFeatureMethod];
         }
         if(msg.hasOwnProperty(dBusVehicleBrandConfig))
         {
            this.mVehicleBrandConfig = msg[dBusVehicleBrandConfig];
            this.vehicleBrandNameInfo();
         }
         if(msg.hasOwnProperty(dBusVehicleLineConfig))
         {
            this.mVehicleLineConfig = msg[dBusVehicleLineConfig];
         }
         if(msg.hasOwnProperty(dBusModelYearConfig))
         {
            this.mModelYearConfig = msg[dBusModelYearConfig];
         }
         if(msg.hasOwnProperty(dBusSteeringWheelConfig))
         {
            this.mSteeringWheelConfig = msg[dBusSteeringWheelConfig];
         }
         if(msg.hasOwnProperty(dBusTransmissionConfig))
         {
            this.mTransmissionConfig = msg[dBusTransmissionConfig];
         }
         if(msg.hasOwnProperty(dBusCountryCodeConfig))
         {
            this.mCountryCodeConfig = msg[dBusCountryCodeConfig];
         }
         if(msg.hasOwnProperty(dBusBodyStyleConfig))
         {
            this.mBodyStyleConfig = msg[dBusBodyStyleConfig];
         }
         if(msg.hasOwnProperty(dBusSpecialPackageConfig))
         {
            this.mSpecialPackageConfig = msg[dBusSpecialPackageConfig];
         }
         if(msg.hasOwnProperty(dBusHvacConfig))
         {
            this.mHvacConfig = msg[dBusHvacConfig];
            if(this.mHvacConfig == "2" || this.mHvacConfig == "4" || this.mHvacConfig == "5")
            {
               this.mHVACSystemATC = true;
            }
         }
         if(msg.hasOwnProperty(dBusDestinationConfig))
         {
            this.mDestinationConfig = msg[dBusDestinationConfig];
         }
         if(msg.hasOwnProperty(dBusDestinationNameConfig))
         {
            this.mDestinationNameConfig = msg[dBusDestinationNameConfig];
         }
         if(msg.hasOwnProperty(dBusHeadRestDumpPresent))
         {
            this.mHeadRestPresent = msg[dBusHeadRestDumpPresent] == "true";
         }
         if(msg.hasOwnProperty(dBusParkAssistConfiguration))
         {
            this.mParkAssistConfiguration = msg[dBusParkAssistConfiguration];
         }
         if(msg.hasOwnProperty(dBusAudioSystemType))
         {
            this.mAudioSystemType = msg[dBusAudioSystemType];
         }
         if(msg.hasOwnProperty(dBusExternalPortType))
         {
            this.mExternalPortType = msg[dBusExternalPortType];
         }
         if(msg.hasOwnProperty(dbusAdditionalLanguages))
         {
            if(msg[dbusAdditionalLanguages] is Array)
            {
               this.mAdditionalLanguages = msg[dbusAdditionalLanguages];
            }
         }
         if(msg.hasOwnProperty(dbusPressureUnitsPresent))
         {
            this.mPressureUnitsPresent = msg[dbusPressureUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusCapacityUnitsPresent))
         {
            this.mCapacityUnitsPresent = msg[dbusCapacityUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusConsumptionUnitsPresent))
         {
            this.mConsumptionUnitsPresent = msg[dbusConsumptionUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusDistanceUnitsPresent))
         {
            this.mDistanceUnitsPresent = msg[dbusDistanceUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusPowerUnitsPresent))
         {
            this.mPowerUnitsPresent = msg[dbusPowerUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSpeedUnitsPresent))
         {
            this.mSpeedUnitsPresent = msg[dbusSpeedUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTempUnitsPresent))
         {
            this.mTemperatureUnitsPresent = msg[dbusTempUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTorqueUnitsPresent))
         {
            this.mTorqueUnitsPresent = msg[dbusTorqueUnitsPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSideDistanceWarningPresent))
         {
            this.mSideDistanceWarningPresent = msg[dbusSideDistanceWarningPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusEngineTypeVariant))
         {
            this.mEngineTypeVariant = msg[dbusEngineTypeVariant];
         }
         if(msg.hasOwnProperty(dbusRearCameraGridlinesType))
         {
            this.mRearCameraGridlinesType = msg[dbusRearCameraGridlinesType];
         }
         if(msg.hasOwnProperty(dbusDabPresent))
         {
            this.mDabPresent = msg[dbusDabPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusDTVShortTermPresent))
         {
            this.mDTVShortTermPresent = msg[dbusDTVShortTermPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusFrontCameraPresent))
         {
            this.mFrontCameraPresent = msg[dbusFrontCameraPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSideCameraPresent))
         {
            this.mSideCameraPresent = msg[dbusSideCameraPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusPwrFoldMirrors))
         {
            this.mPwrFoldMirrorsPresent = msg[dbusPwrFoldMirrors] == "true";
         }
         if(msg.hasOwnProperty(dbusVRMPresent))
         {
            this.mVRMPresent = msg[dbusVRMPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTeenKeyFeature))
         {
            this.mTeenKeyFeature = msg[dbusTeenKeyFeature] == "true";
         }
         if(msg.hasOwnProperty(dbusTKFCWSensitivity))
         {
            this.mTKFCWSensitivity = msg[dbusTKFCWSensitivity] == "true";
         }
         if(msg.hasOwnProperty(dbusTKFCWBraking))
         {
            this.mTKFCWBraking = msg[dbusTKFCWBraking] == "true";
         }
         if(msg.hasOwnProperty(dbusTKParkAssist))
         {
            this.mTKParkAssist = msg[dbusTKParkAssist] == "true";
         }
         if(msg.hasOwnProperty(dbusTKParkAssistBraking))
         {
            this.mTKParkAssistBraking = msg[dbusTKParkAssistBraking] == "true";
         }
         if(msg.hasOwnProperty(dbusTKParkAssistFTvol))
         {
            this.mTKParkAssistFTvol = msg[dbusTKParkAssistFTvol] == "true";
         }
         if(msg.hasOwnProperty(dbusTKParkAssistRRvol))
         {
            this.mTKParkAssistRRvol = msg[dbusTKParkAssistRRvol] == "true";
         }
         if(msg.hasOwnProperty(dbusTKBlindSpot))
         {
            this.mTKBlindSpot = msg[dbusTKBlindSpot] == "true";
         }
         if(msg.hasOwnProperty(dbusTKFuelPopup))
         {
            this.mTKFuelPopup = msg[dbusTKFuelPopup] == "true";
         }
         if(msg.hasOwnProperty(dbusTKFuelWarning))
         {
            this.mTKFuelWarning = msg[dbusTKFuelWarning] == "true";
         }
         if(msg.hasOwnProperty(dbusTKPwrLiftgateChime))
         {
            this.mTKPwrLiftgateChime = msg[dbusTKPwrLiftgateChime] == "true";
         }
         if(msg.hasOwnProperty(dbusTKSlidingDoorAlert))
         {
            this.mTKSlidingDoorAlert = msg[dbusTKSlidingDoorAlert] == "true";
         }
         if(msg.hasOwnProperty(dbusTKAutoWipers))
         {
            this.mTKAutoWipers = msg[dbusTKAutoWipers] == "true";
         }
         if(msg.hasOwnProperty(dbusTKHLsWithWipers))
         {
            this.mTKHLsWithWipers = msg[dbusTKHLsWithWipers] == "true";
         }
         if(msg.hasOwnProperty(dbusTKAutoHighBeams))
         {
            this.mTKAutoHighBeams = msg[dbusTKAutoHighBeams] == "true";
         }
         if(msg.hasOwnProperty(dbusTKMaxSpeedLimit))
         {
            this.mTKMaxSpeedLimit = msg[dbusTKMaxSpeedLimit] == "true";
         }
         if(msg.hasOwnProperty(dbusSVCDynamicGridLines))
         {
            this.mSVCDynamicGridLines = msg[dbusSVCDynamicGridLines] == "true";
         }
         if(msg.hasOwnProperty(dbusSVCDelay))
         {
            this.mSVCDelay = msg[dbusSVCDelay] == "true";
         }
         if(msg.hasOwnProperty(dbusSVCSoftKey))
         {
            this.mSVCSoftKey = msg[dbusSVCSoftKey] == "true";
         }
         if(msg.hasOwnProperty(dbusPaddlesModeStatus))
         {
            this.mPaddlesModePresent = msg[dbusPaddlesModeStatus] == "true";
         }
         if(msg.hasOwnProperty(dbusSettingsPaddleMode))
         {
            this.mSettingsPaddleModePresent = msg[dbusSettingsPaddleMode] == "true";
         }
         if(msg.hasOwnProperty(dbusCHMSLCameraGuidelines))
         {
            this.mCHMSLCameraGuidelinesPresent = msg[dbusCHMSLCameraGuidelines] == "true";
         }
         if(msg.hasOwnProperty(dbusSDARTravelLinkPresent))
         {
            this.mSDARTravelLinkPresent = msg[dbusSDARTravelLinkPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusCabinEQCurve))
         {
            this.mCabinEQCurve = msg[dbusCabinEQCurve];
         }
         if(msg.hasOwnProperty(dbusDriveModePresent))
         {
            this.mDriveModePresent = msg[dbusDriveModePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusEngPowerDrvMdPresent))
         {
            this.mEngPowerDrvMdPresent = msg[dbusEngPowerDrvMdPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusESCDrvMdPresent))
         {
            this.mESCDrvMdPresent = msg[dbusESCDrvMdPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRedKeyPresent))
         {
            this.mRedKeyPresent = msg[dbusRedKeyPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusShiftIndicatorType))
         {
            this.mshiftIndicatorType = msg[dbusShiftIndicatorType];
         }
         if(msg.hasOwnProperty(dbusSuperTrackPackPresent))
         {
            this.mSuperTrackPackPresent = msg[dbusSuperTrackPackPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTcaseType))
         {
            this.mTcaseType = msg[dbusTcaseType];
         }
         if(msg.hasOwnProperty(dbusTransEquipped))
         {
            this.mTransEquipped = msg[dbusTransEquipped];
         }
         if(msg.hasOwnProperty(dbusTransDrvMdPresent))
         {
            this.mTransDrvMdPresent = msg[dbusTransDrvMdPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusTSBMPresent))
         {
            this.mTSBMPresent = msg[dbusTSBMPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSRTPresent))
         {
            this.mSRTPresent = msg[dbusSRTPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusSportModePresent))
         {
            this.mSportModePresent = msg[dbusSportModePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusEPSPresent))
         {
            this.mEPSPresent = msg[dbusEPSPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusADCMPresent))
         {
            this.mADCMPresent = msg[dbusADCMPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRVCMPresent))
         {
            this.mRVCMPresent = msg[dbusRVCMPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusHCPPresent))
         {
            this.mHybridControlPresent = msg[dbusHCPPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusReadyToDrivePresent))
         {
            this.mReadyToDrivePresent = msg[dbusReadyToDrivePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusPhoneInfoInClusterPresent))
         {
            this.mphoneInfoInClusterPresent = msg[dbusPhoneInfoInClusterPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusECMirrorHKPresent))
         {
            this.mECMirrorHKPresent = msg[dbusECMirrorHKPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRVCSoftKey))
         {
            this.mRVCSoftKey = msg[dbusRVCSoftKey] == "true";
         }
         if(msg.hasOwnProperty(dbusDriveModeVersion))
         {
            this.mDriveModeVersion = msg[dbusDriveModeVersion];
         }
         if(msg.hasOwnProperty(dbusNetCfgRearHVACPresent))
         {
            this.mNetCfgRearHVACPresent = msg[dbusNetCfgRearHVACPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusRearDefrostBtnPresent))
         {
            this.mRearDefrostBtnPresent = msg[dbusRearDefrostBtnPresent] == "true";
         }
         if(msg.hasOwnProperty(dbusPoliceVehiclePresent))
         {
            this.mPoliceVehiclePresent = msg[dbusPoliceVehiclePresent] == "true";
         }
         if(msg.hasOwnProperty(dbusPolicePassiveEntryPresent))
         {
            this.mPolicePassiveEntryPresent = msg[dbusPolicePassiveEntryPresent] == "true";
         }
         dispatchEvent(new VehConfigEvent(VehConfigEvent.AVAILABLE,null));
      }
      
      public function isImperialDestination() : Boolean
      {
         switch(this.mDestinationNameConfig)
         {
            case "usa":
            case "canada":
            case "mexico":
            case "puerto rico":
            case "liberia":
            case "belize":
            case "colombia":
            case "dominican republic":
            case "ecuador":
            case "el salvador":
            case "grenada":
            case "guatemala":
            case "haiti":
            case "honduras":
            case "burma":
            case "nicaragua":
            case "panama":
            case "peru":
               return false;
            default:
               return true;
         }
      }
      
      public function isNorthAmericanVehicle() : Boolean
      {
         if(this.mDestinationNameConfig == "usa" || this.mDestinationNameConfig == "canada" || this.mDestinationNameConfig == "mexico" || this.mDestinationNameConfig == "puerto rico")
         {
            return true;
         }
         return false;
      }
      
      public function isLatinAmericanVehicle() : Boolean
      {
         switch(this.mDestinationNameConfig)
         {
            case "argentina":
            case "belize":
            case "bolivia":
            case "brazil":
            case "chile":
            case "colombia":
            case "costa rica":
            case "cuba":
            case "dominican republic":
            case "ecuador":
            case "el salvador":
            case "equatorial guinea":
            case "faukland islands":
            case "french guiana":
            case "french polynesia / tahiti":
            case "guadeloupe":
            case "guatemala":
            case "guinea":
            case "guyana":
            case "haiti":
            case "honduras":
            case "jamacia":
            case "nicaragua":
            case "panama":
            case "paraguay":
            case "peru":
            case "suriname":
            case "trinidad & tobago":
            case "uruguay":
            case "venezuela":
               return true;
            default:
               return false;
         }
      }
      
      private function vehicleBrandNameInfo() : void
      {
         this.mVehicleBrandName = "";
         switch(this.mVehicleBrandConfig)
         {
            case "1":
               this.mVehicleBrandName = "Chrysler";
               break;
            case "2":
               this.mVehicleBrandName = "Dodge";
               break;
            case "3":
               this.mVehicleBrandName = "Jeep";
               break;
            case "4":
               this.mVehicleBrandName = "Mercedes Benz";
               break;
            case "5":
               this.mVehicleBrandName = "Mitsubishi";
               break;
            case "6":
               this.mVehicleBrandName = "Volkswagen";
               break;
            case "7":
               this.mVehicleBrandName = "Freightliner";
               break;
            case "8":
               this.mVehicleBrandName = "Alfa Romeo";
               break;
            case "9":
               this.mVehicleBrandName = "Fiat";
               break;
            case "10":
               this.mVehicleBrandName = "Lancia";
               break;
            case "11":
               this.mVehicleBrandName = "Maserati";
               break;
            case "12":
               this.mVehicleBrandName = "Ram";
         }
         if(this.mVehicleBrandName == "Maserati")
         {
            return;
         }
         if("" != this.mVehicleBrandName)
         {
            if("Maserati" == this.mVehicleBrandName)
            {
               this.mVehicleBrandName += " MTC+";
            }
            else
            {
               this.mVehicleBrandName += " Uconnect";
            }
         }
         else
         {
            this.mVehicleBrandName = "Uconnect";
         }
      }
      
      public function get isTruckPlatform() : Boolean
      {
         if(this.mVehicleLineConfig == "DS" || this.mVehicleLineConfig == "DX" || this.mVehicleLineConfig == "DP" || this.mVehicleLineConfig == "D2" || this.mVehicleLineConfig == "DJ" || this.mVehicleLineConfig == "DD" || this.mVehicleLineConfig == "DF")
         {
            return true;
         }
         return false;
      }
      
      public function get hasEcoAppBtn() : Boolean
      {
         var mPermitBtn:Boolean = false;
         if(Number(this.mModelYearConfig) > 15 && (this.mVehicleLineConfig != "LA" && this.mVehicleLineConfig != "LX" && this.mVehicleLineConfig != "LD" && this.mVehicleLineConfig != "WK" && this.mVehicleLineConfig != "WD"))
         {
            mPermitBtn = true;
         }
         else
         {
            mPermitBtn = false;
         }
         return this.mEcoModePresent && mPermitBtn;
      }
   }
}

