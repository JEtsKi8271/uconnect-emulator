package com.nfuzion.moduleLink
{
   import flash.events.Event;
   
   public class ConnectionEvent extends Event
   {
      
      public static const CONFIGURED:String = "configured";
      
      public static const READY:String = "ConnectionEvent.ready";
      
      public static const ALL:String = "all";
      
      public static const AHA:String = "AhaConnect";
      
      public static const TUNER:String = "Tuner";
      
      public static const ANNOUNCEMENT_MASTER:String = "AnnouncementMaster";
      
      public static const MEDIA_PLAYER:String = "Media";
      
      public static const PRESET_PERSISTENCE_MANAGER:String = "PresetManager";
      
      public static const APP_PERSISTENCE_MANAGER:String = "AppPersistenceManager";
      
      public static const CLOCK:String = "Clock";
      
      public static const PERSONALCONFIG:String = "PersonalConfig";
      
      public static const FIAT330:String = "S330";
      
      public static const AUDIO:String = "Audio";
      
      public static const AUDIOPAL:String = "AudioPAL";
      
      public static const AUDIOSETTINGS:String = "AudioSettings";
      
      public static const AUDIOMIXERMANAGER:String = "AudioMixerManager";
      
      public static const BLUETOOTH_MANAGER:String = "BluetoothGAP";
      
      public static const BLUETOOTH_MANAGER_PERSISTENCY:String = "BluetoothGAPPersistency";
      
      public static const BLUETOOTH_HFP:String = "BluetoothHFP";
      
      public static const BLUETOOTH_HFP_PERSISTENCY:String = "BluetoothHFPPersistency";
      
      public static const NAVIGATION:String = "navigation";
      
      public static const NAVIGATION_PERSISTENCY:String = "NavigationPersistency";
      
      public static const NAVIGATION_CLUSTER:String = "NavigationCluster";
      
      public static const GRAPHICAL_WEATHER:String = "graphicalWeather";
      
      public static const NAVIGATION_DB_SERVICE:String = "NavigationDBService";
      
      public static const NAVIGATION_AUTHENTICATION:String = "Authentication";
      
      public static const NDR:String = "ndr";
      
      public static const NAV_TRAIL_INFO:String = "NavTrailInfo";
      
      public static const UCONNECT_ACN:String = "UConnectACN";
      
      public static const TOMTOM_LIVE_SERVICE:String = "ttls";
      
      public static const PPS:String = "readPPS";
      
      public static const ICS:String = "ICS";
      
      public static const CLIMATE:String = "Climate";
      
      public static const HVAC:String = "HVAC";
      
      public static const PHONEBOOK:String = "PhoneBook";
      
      public static const PHONE_CALL_LIST:String = "PhoneCallList";
      
      public static const PIM_SERVICE:String = "PimService";
      
      public static const CVPDEMO:String = "CVPDemo";
      
      public static const AMS:String = "AMS";
      
      public static const SOFTWARE_UPDATE:String = "SoftwareUpdate";
      
      public static const SOFTWARE_INSTALLER:String = "SoftwareInstaller";
      
      public static const AMS_FILE_INFO:String = "AmsFileInfo";
      
      public static const VERSION_INFO:String = "VersionInfo";
      
      public static const IPADDRESS_INFO:String = "IPAddressInfo";
      
      public static const PERFORMANCE_INFO:String = "PerformanceInfo";
      
      public static const CAMERA_UPDATE:String = "Camera";
      
      public static const TRAVELLINK_FUEL:String = "XMFuel";
      
      public static const TRAVELLINK_SPORTS:String = "XMSports";
      
      public static const TRAVELLINK_LANDWEATHER:String = "XMLandWeather";
      
      public static const TRAVELLINK_MOVIES:String = "XMMovies";
      
      public static const SATELLITE_RADIO_INSTANT_REPLAY:String = "XMInstantReplay";
      
      public static const SATELLITE_RADIO:String = "XMApp";
      
      public static const SATELLITE_GAMEZONE:String = "XMGameZone";
      
      public static const SATELLITE_PERSISTENCY:String = "XMPersistency";
      
      public static const SATELLITE_FAVORITES:String = "XMFavorites";
      
      public static const SATELLITE_PRESETS:String = "XMPresets";
      
      public static const SATELLITE_TRAFFIC_JUMP:String = "XMTrafficJump";
      
      public static const VEHICLE_SETTINGS:String = "VehSetting";
      
      public static const DRIVE_MODE:String = "DriveMode";
      
      public static const HEV:String = "HEV";
      
      public static const LOCATION:String = "Location";
      
      public static const VEHICLE_CONFIG:String = "VehicleConfig";
      
      public static const CONNECTION_MANAGER:String = "ConnectionManager";
      
      public static const DISPLAY_MANAGER:String = "DisplayManager";
      
      public static const SIERRA_UPDATE:String = "SierraUpdate";
      
      public static const RSE:String = "Rse";
      
      public static const ANTI_THEFT:String = "AntiTheft";
      
      public static const OMAP_TEMP:String = "OmapTemp";
      
      public static const HMI_REQUEST:String = "HMIRequest";
      
      public static const DAB_TUNER_CONTROL:String = "DABTunerControl";
      
      public static const DAB_TUNER_FOLLOW_MASTER:String = "DABTunerFollowMaster";
      
      public static const DAB_TUNER_STATION:String = "DABTunerStation";
      
      public static const DAB_TUNER_APP:String = "DABApp";
      
      public static const WIFI_SERVICE:String = "WiFiService";
      
      public static const WIFI_PERSISTENCY:String = "WiFiPersistency";
      
      public static const TEXT_TO_SPEECH:String = "TextToSpeech";
      
      public static const VOICE_RECOGNITION:String = "VoiceRecognition";
      
      public static const UI_SPEECH_SERVICE:String = "UISpeechService";
      
      public static const DBUS_TRACE_MONITOR:String = "DBusTraceMonitor";
      
      public static const VEHICLE_STATUS:String = "VehicleStatus";
      
      public static const DIAGNOSTICS:String = "XMDiagnostics";
      
      public static const APP_MANAGER:String = "AppManager";
      
      public static const PHONE_PROJECTION:String = "phoneProjectionService";
      
      public static const PLATFORM:String = "platform";
      
      public static const DRIVER_AB:String = "DriverAB";
      
      public static const SWC:String = "SWC";
      
      public static const ECALLSVC:String = "ECallSvc";
      
      public static const PERSISTENCY:String = "Persistency";
      
      public static const TAGGING_SERVICE:String = "TaggingService";
      
      public static const BEACONHMI:String = "DNAVNTG5JpnBeaconDsrcHmi.NavCtrl_Driver";
      
      public static const FMHMI:String = "DNAVNTG5JpnVicsFmHmi.NavCtrl_Driver";
      
      public static const VICSTUNERHMI:String = "DNAVNTG5JpnTunerHmi.NavCtrl_Driver";
      
      public static const VICSDSRCETCDIAGHMI:String = "DNAVNTG5JpnDsrcVicsEtcDiag.NavCtrl_Driver";
      
      public static const VICSETCHMI:String = "DNAVNTG5JpnEtcHmi.NavCtrl_Driver";
      
      public static const VICSDIAGENGMENUHMI:String = "DNAVNTG5JpnDiagEngMenu.JpnDiagEngMenu";
      
      public static const KANAKANJI:String = "KanaKanJi";
      
      public static const PINYIN:String = "PinYin";
      
      public static const HWR:String = "hwr";
      
      public static const DMBAPP:String = "dmbApp";
      
      public static const DMB_PERSISTENCY:String = "DMBPersistency";
      
      public static const DCM:String = "DeviceConnectionManager";
      
      public static const REMOTESTART:String = "RemoteStart";
      
      public static const OTA_SERVICE:String = "OtaService";
      
      public var data:Object;
      
      public function ConnectionEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.data = data;
         super(type,bubbles,cancelable);
      }
   }
}

