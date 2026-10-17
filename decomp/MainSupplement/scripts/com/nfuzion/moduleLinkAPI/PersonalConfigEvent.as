package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PersonalConfigEvent extends Event
   {
      
      public static const DISPLAYMODE:String = "displayMode";
      
      public static const DISPLAYMODESETTING:String = "displayModeSetting";
      
      public static const BRIGHTHLON:String = "brightnessHeadlightsOn";
      
      public static const BRIGHTHLOFF:String = "brightnessHeadlightsOff";
      
      public static const COLOR:String = "color";
      
      public static const LANG:String = "lang";
      
      public static const UNIT:String = "units";
      
      public static const SPEED_UNITS:String = "speedUnits";
      
      public static const DISTANCE_UNITS:String = "DistanceUnits";
      
      public static const FUELCONSUMP_UNITS:String = "fuelConsumpUnits";
      
      public static const CAPACITY_UNITS:String = "capacityUnits";
      
      public static const PRESSURE_UNITS:String = "pressureUnits";
      
      public static const TEMPERATURE_UNITS:String = "temperatureUnits";
      
      public static const HORSEPOWER_UNITS:String = "horsePowerUnits";
      
      public static const TORQUE_UNITS:String = "torqueUnits";
      
      public static const CUSTOM_UNITS:String = "CustomUnitsUpdated";
      
      public static const VOICERESLEN:String = "voiceResLen";
      
      public static const TELEPROMPTERMODE:String = "teleprompterMode";
      
      public static const TOUCHSCREENBEEP:String = "touchScreenBeep";
      
      public static const NAVCLUSTER:String = "navCluster";
      
      public static const FUELSAVER:String = "fuelSaveDisp";
      
      public static const CONTROLSTIMEOUTENABLED:String = "controlsTimeoutEnabled";
      
      public static const SPLITSCREEN:String = "splitScreen";
      
      public static const SAFEFWDCOLLISION:String = "collisionSens";
      
      public static const SAFEFCWSENSITIVITY:String = "fcwSensitivitySetting";
      
      public static const SAFEFCWONOFFSTATE:String = "fcwOnOffState";
      
      public static const SAFEFCWBRAKESTAT:String = "fcwBrakeStatus";
      
      public static const PARKASSIST:String = "parkAssist";
      
      public static const FTSENSACTDRV:String = "frontSensorsActiveDrive";
      
      public static const PARKASSISTALERTVOL:String = "parkAssistAlertVol";
      
      public static const PARKASSISTBRAKING:String = "parkAssistBraking";
      
      public static const SIDEDISTANCEWARNING:String = "sideDistanceWarning";
      
      public static const SIDEDISTANCEWARNINGVOL:String = "sideDistanceWarningChimeVolume";
      
      public static const TILTMIRROR:String = "tilt";
      
      public static const BLINDSPOT:String = "blindSpotAlert";
      
      public static const BACKUPCAMERA:String = "parkviewCam";
      
      public static const BACKUPCAMERADELAY:String = "parkviewCamDelay";
      
      public static const CAMERADYNAMICGRIDLINES:String = "dynamicGridLines";
      
      public static const CAMERASTATICGRIDLINES:String = "staticGridLines";
      
      public static const SURROUNDCAMERALOCK:String = "surroundCamLock";
      
      public static const SAFEAUTOWIPER:String = "rainWiPersonal";
      
      public static const SAFEHILLSTARTASSIST:String = "hillAssist";
      
      public static const HLOFFDELAY:String = "headlightOff";
      
      public static const HLILLUMINATION:String = "headlightIllum";
      
      public static const HLWIPER:String = "headlightWiper";
      
      public static const AUTODIMHIGHBEAM:String = "autoDimHiBeam";
      
      public static const DAYTIMERUNNINGLIGHTS:String = "daytimeLights";
      
      public static const STEERINGWHEELDIRECTEDLIGHT:String = "steeringLights";
      
      public static const HEADLIGHTDIP:String = "headlightDip";
      
      public static const FLASHWITHLOCK:String = "headlightsLock";
      
      public static const AUTODOORLOCK:String = "autoLock";
      
      public static const AUTOUNLOCKEXIT:String = "autoUnlock";
      
      public static const FLASHHLWITHLOCK:String = "flashHeadlightLock";
      
      public static const SOUNDHORNWITHLOCK:String = "soundHornLock";
      
      public static const SOUNDHORNWITHLOCK1ST2ND:String = "soundHornLock1st2nd";
      
      public static const SOUNDHORNWITHREMOTELOCK:String = "soundHornRemote";
      
      public static const FIRSTPRESSKEYFOB:String = "keyUnlock";
      
      public static const PASSIVEENTRY:String = "passiveEntry";
      
      public static const PERSONALSETTINGSFOB:String = "PersonalSettingsLinked";
      
      public static const SLIDINGDOORALERT:String = "slidingDoorAlert";
      
      public static const HFSLIDINGDOORSTAT:String = "handsFreeSlidingDoorStatus";
      
      public static const FLSHLGHTSLIDEDOORSTAT:String = "flashLightSlideDoorStatus";
      
      public static const AUTORELOCKPE:String = "autoRelockPE";
      
      public static const HORNREMOTESTART:String = "hornRemoteStart";
      
      public static const AUTOONDCS:String = "autoOnDCS";
      
      public static const EXITSEAT:String = "exitSeat";
      
      public static const ENGINEOFFDELAY:String = "engineOffDelay";
      
      public static const COMPASSVARIANCE:String = "compassVariance";
      
      public static const PERFORMCOMPASSCALIB:String = "performCompassCalib";
      
      public static const SOUNDHORNWITHREMOTELOWER:String = "soundHornWithRemoteLower";
      
      public static const FLASHLIGHTWITHLOWER:String = "flashLightWithLower";
      
      public static const TIREJACKMODE:String = "tireJackMode";
      
      public static const SUSPENSIONMSGDISP:String = "suspensionMsgDisp";
      
      public static const TRANSPORTMODE:String = "transportMode";
      
      public static const WHEELALIGNMENT:String = "wheelAlignment";
      
      public static const AEROMODE:String = "aeroMode";
      
      public static const TRAILERSELECTED:String = "trailerSelected";
      
      public static const TRAILERBRAKETYPE:String = "trailerBrakeType";
      
      public static const TRAILERNAME:String = "trailerName";
      
      public static const SUSPENSIONEASYEXIT:String = "easyExitSuspension";
      
      public static const PWRLIFTGATECHIME:String = "pwrLiftgateChime";
      
      public static const HANDSFREELIFTGATE:String = "pwrLiftgateStatus";
      
      public static const MOODLGTINTS:String = "moodLightingInts";
      
      public static const AUTOPARKBRAKE:String = "autoParkBrakeStatus";
      
      public static const AUTOHOLDBRAKE:String = "autoBrakeHoldStatus";
      
      public static const LDWARNSETTING:String = "laneDepartureWarnSetting";
      
      public static const LSWARNSENSITIVITY:String = "laneSenseWarnSensitivity";
      
      public static const LSTORQUEINTENSITY:String = "laneSenseTorqueIntensity";
      
      public static const BRAKESERVICESTATUS:String = "brakeServiceStatus";
      
      public static const BRAKESERVICETEXTDISPLAY:String = "brakeServiceTextDisplay";
      
      public static const TRIP_COMPUTER_A:String = "tripComputerA";
      
      public static const TRIP_COMPUTER_B:String = "tripComputerB";
      
      public static const POWERSTEERINGMODE:String = "powerSteeringMode";
      
      public static const AMBIENTLIGHTINGLEVEL:String = "ambientLightingLevel";
      
      public static const NAV_REPETITION_ENABLE:String = "navRepetitionEnabled";
      
      public static const HEADLIGHTSENSITIVITY:String = "headlightSensitivityLevel";
      
      public static const POWERFOLDINGMIRRORS:String = "powerFoldingMirrors";
      
      public static const TKFCWSENSITIVITY:String = "tkFCWSensitivity";
      
      public static const TKFCWBRAKEASSIST:String = "tkFCWBrakeAssist";
      
      public static const TKPARKASSISTCONFIG:String = "tkPTS_ConfigStatus";
      
      public static const TKPARKASSISTBRAKING:String = "tkPTSBrakingAssist";
      
      public static const TKPARKASSISTFTVOLUME:String = "tkPTSFrontVolume";
      
      public static const TKPARKASSISTRRVOLUME:String = "tkPTSRearVolume";
      
      public static const TKBSMCONFIGURATION:String = "tkBSM_ConfigStatus";
      
      public static const TKFUELPOPUP:String = "tkFuelPopup";
      
      public static const TKEARLYFUELWARNING:String = "tkEarlyFuelWarning";
      
      public static const TKPWRLIFTGATECHIME:String = "tkPWRLiftgateChime";
      
      public static const TKSLIDINGDOORALERT:String = "tkSlidingDoorAlert";
      
      public static const TKAUTOWIPERS:String = "tkAutoWipers";
      
      public static const TKHLSWITHWIPERS:String = "tkHLsWithWipers";
      
      public static const TKAUTOHIGHBEAMS:String = "tkAutoHighBeams";
      
      public static const TKMAXSPEEDLIMIT:String = "tkMaxSpeedLimit";
      
      public static const SVCDYNAMICGIRDLINES:String = "svcDynamicGridLines";
      
      public static const SVCDELAY:String = "svcDelay";
      
      public static const CORNERINGENABLE:String = "corneringEnable";
      
      public static const GREETINGLIGHTSENABLE:String = "greetingLightsEnable";
      
      public static const DNAENABLE:String = "dnaEnable";
      
      public static const PADDLESMODESTATUS:String = "paddlesModeStatus";
      
      public static const CHMSLCAMERAGUIDELINES:String = "chmslCameraGuidelines";
      
      public static const PWROFFWITHDOOROPEN:String = "pwrOffWithDoorOpen";
      
      public static const RDYTODRVSTATUS:String = "rdyToDrvStatus";
      
      public static const ENBLPHONEREP:String = "enblPhoneRep";
      
      public static const AUTOSWITCH:String = "autoSwitch";
      
      public static const VIDEOREADBACK:String = "videoReadBack";
      
      public var mData:Object = null;
      
      public function PersonalConfigEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

