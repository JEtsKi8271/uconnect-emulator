package com.harman.navigation.Controller.NDR
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.navigation.Controller.NDR.util.GPSInfo;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class NDRControl extends Module implements INDRControl
   {
      
      private static const dbusIdentifier:String = "NDR";
      
      private static const UPDATE_FREQUENCY_ALL:int = 1000;
      
      private static const UPDATE_FREQUENCY_HEADING:int = 1500;
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mBusy:Boolean = false;
      
      private var mConnected:Boolean = false;
      
      private var mIsSubscribed:Boolean = false;
      
      private var mHeadingIsSubscribed:Boolean = false;
      
      private var mGPSInfo:GPSInfo = new GPSInfo();
      
      private var mSatelliteInfo:Object = new Object();
      
      private var mIntervalAll:uint = 0;
      
      private var mIntervalHeading:uint = 0;
      
      private var mTripComputerData:Object = null;
      
      private var mVehSpeed:int = 0;
      
      private var calMessage:Boolean = false;
      
      private var mIntervalCal:uint = 0;
      
      private var mSubscribedCal:Boolean = false;
      
      public function NDRControl()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mBusy = true;
         this.mIsSubscribed = false;
         this.mSubscribedCal = false;
         this.connection = Connection.share();
         this.client = this.connection.span;
         if(this.client.connected)
         {
            this.isConnected();
         }
         else
         {
            this.client.addEventListener(Event.CONNECT,this.connected);
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.NDR,this.ndrMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.enableCalibrationSubscriptions(true);
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.isConnected();
      }
      
      private function isConnected() : void
      {
         if(this.connection.configured)
         {
            if(Boolean(this.client.connected) && !this.mConnected)
            {
               this.mConnected = true;
               this.mBusy = false;
               this.sendEvent(NDRControlEvent.NDR_BUSY);
               if(NavigationPackage.peripheral.antiTheft != null)
               {
                  NavigationPackage.peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_BATTERY_DISCONNECT,this.onBatteryDisconnect,false,0,true);
                  NavigationPackage.peripheral.antiTheft.reqBatteryConnectState();
               }
               this.getProperty("\"POS_Position\",\"POS_CalibrationLevel\"");
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         Framework.Trace("Navigation.NDRControl.disconnected()");
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new NDRControlEvent(eventType));
      }
      
      public function sendSubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signal + "\"}";
         this.client.send(message);
      }
      
      public function sendUnSubscribe(signal:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"NDR\", \"Signal\":\"" + signal + "\"}";
         this.client.send(message);
      }
      
      public function getProperty(prop:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"NDR\",\"packet\":{\"JSON_GetProperties\":{\"inprop\":[" + prop + "]}}}";
         this.client.send(message);
      }
      
      public function onInterval() : void
      {
         this.getProperty("\"POS_Position\",\"SEN_GPSSatInfo\",\"SEN_GPSInfo\",\"SEN_ReverseGear\",\"POS_CalibrationLevel\"");
      }
      
      public function onIntervalHeading() : void
      {
         this.getProperty("\"POS_Position\"");
      }
      
      private function onIntervalCal() : void
      {
         this.getProperty("\"POS_CalibrationLevel\"");
      }
      
      public function sendPOS_resetCalibration() : void
      {
         var message:String = null;
         Framework.Trace("NDRManager.sendPOS_resetCalibration()");
         message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\":{\"POS_resetCalibration\":\"\"}}";
         this.client.send(message);
      }
      
      private function onBatteryDisconnect(e:AntiTheftEvent) : void
      {
         if(NavigationPackage.peripheral.antiTheft.batteryDisconnectState == "batt")
         {
            Framework.Trace("NDRManager.onBatteryDisconnect()");
            this.sendPOS_resetCalibration();
         }
      }
      
      public function enableSubscriptions(enable:Boolean) : void
      {
         if(enable && !this.mIsSubscribed)
         {
            this.mIsSubscribed = true;
            this.sendSubscribe("SEN_GPSSatInfo");
            this.sendSubscribe("SEN_GPSInfo");
            this.sendSubscribe("SEN_ReverseGear");
            this.sendSubscribe("POS_CalibrationLevel");
            this.getProperty("\"POS_Position\",\"SEN_GPSSatInfo\",\"SEN_GPSInfo\",\"SEN_ReverseGear\",\"POS_CalibrationLevel\"");
            this.mIntervalAll = setInterval(this.onInterval,UPDATE_FREQUENCY_ALL);
         }
         else if(this.mIsSubscribed && !enable)
         {
            this.mIsSubscribed = false;
            this.sendUnSubscribe("SEN_GPSSatInfo");
            this.sendUnSubscribe("SEN_GPSInfo");
            this.sendUnSubscribe("SEN_ReverseGear");
            this.sendUnSubscribe("POS_CalibrationLevel");
            clearInterval(this.mIntervalAll);
         }
      }
      
      private function enableCalibrationSubscriptions(enable:Boolean) : void
      {
         if(enable && !this.mSubscribedCal)
         {
            this.mSubscribedCal = true;
            this.sendSubscribe("POS_CalibrationLevel");
            this.getProperty("\"POS_CalibrationLevel\"");
            this.mIntervalCal = setInterval(this.onIntervalCal,3000);
         }
         else if(this.mSubscribedCal && !enable)
         {
            this.mSubscribedCal = false;
            this.sendUnSubscribe("POS_CalibrationLevel");
            clearInterval(this.mIntervalCal);
         }
      }
      
      public function enableHeadingUpdates(enable:Boolean) : void
      {
         if(enable && !this.mHeadingIsSubscribed)
         {
            this.mHeadingIsSubscribed = true;
            this.sendSubscribe("POS_Position");
            this.mIntervalHeading = setInterval(this.onIntervalHeading,UPDATE_FREQUENCY_HEADING);
         }
         else if(this.mIsSubscribed && !enable)
         {
            this.mHeadingIsSubscribed = false;
            this.sendUnSubscribe("POS_Position");
            clearInterval(this.mIntervalHeading);
         }
      }
      
      public function getGPSInfo() : void
      {
         this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
      }
      
      public function get GpsInfo() : GPSInfo
      {
         return this.mGPSInfo;
      }
      
      public function getSatelliteInfo() : void
      {
         this.sendEvent(NDRControlEvent.NDR_SATELLITE_INFO);
      }
      
      public function get SatelliteInfo() : Object
      {
         return this.mSatelliteInfo;
      }
      
      public function ndrMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("JSON_GetProperties"))
         {
            if(resp.JSON_GetProperties.hasOwnProperty("outprop"))
            {
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("SEN_GyroSum"))
               {
                  this.mGPSInfo.updateGyroSum(resp.JSON_GetProperties.outprop.SEN_GyroSum);
                  this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("SEN_GPSInfo"))
               {
                  this.mGPSInfo.updateInfo(resp.JSON_GetProperties.outprop.SEN_GPSInfo);
                  this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("SEN_GPSSatInfo"))
               {
                  this.mSatelliteInfo = resp.JSON_GetProperties.outprop.SEN_GPSSatInfo;
                  this.sendEvent(NDRControlEvent.NDR_SATELLITE_INFO);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("POS_CalibrationLevel"))
               {
                  this.mGPSInfo.updateCalibrationLevel(resp.JSON_GetProperties.outprop.POS_CalibrationLevel);
                  this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
                  this.setCalibrationMessage(resp.JSON_GetProperties.outprop.POS_CalibrationLevel.level);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("SEN_ReverseGear"))
               {
                  this.mGPSInfo.updateSEN_ReverseGear(resp.JSON_GetProperties.outprop.SEN_ReverseGear);
                  this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("POS_VehicleSpeed"))
               {
                  this.mVehSpeed = resp.JSON_GetProperties.outprop.POS_VehicleSpeed.vehicleSpeed;
                  this.sendEvent(NDRControlEvent.NDR_VEHICLE_SPEED);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("POS_Position"))
               {
                  if(this.mGPSInfo.updatePOS_Position(resp.JSON_GetProperties.outprop.POS_Position))
                  {
                     this.sendEvent(NDRControlEvent.NDR_HEADING);
                  }
                  this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
               }
               if(resp.JSON_GetProperties.outprop.hasOwnProperty("ETC_TripComputer"))
               {
                  this.mTripComputerData = resp.JSON_GetProperties.outprop.ETC_TripComputer;
                  this.sendEvent(NDRControlEvent.NDR_TRIP_COMPUTER_DATA);
               }
            }
         }
         else if(resp.hasOwnProperty("SEN_GPSInfo"))
         {
            this.mGPSInfo.updateInfo(resp.SEN_GPSInfo);
            this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
         }
         else if(resp.hasOwnProperty("SEN_GPSSatInfo"))
         {
            this.mSatelliteInfo = resp.SEN_GPSSatInfo;
            this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
         }
         else if(resp.hasOwnProperty("POS_VehicleSpeed"))
         {
            this.mVehSpeed = resp.POS_VehicleSpeed.vehicleSpeed;
            this.sendEvent(NDRControlEvent.NDR_VEHICLE_SPEED);
         }
         else if(resp.hasOwnProperty("POS_Position"))
         {
            if(this.mGPSInfo.updatePOS_Position(resp.POS_Position))
            {
               this.sendEvent(NDRControlEvent.NDR_HEADING);
            }
            this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
         }
         else if(resp.hasOwnProperty("ETC_TripComputer"))
         {
            this.mTripComputerData = resp.ETC_TripComputer;
            this.sendEvent(NDRControlEvent.NDR_TRIP_COMPUTER_DATA);
         }
         else if(resp.hasOwnProperty("POS_CalibrationLevel"))
         {
            this.mGPSInfo.updateCalibrationLevel(resp.POS_CalibrationLevel);
            this.sendEvent(NDRControlEvent.NDR_GPS_INFO);
            this.setCalibrationMessage(resp.POS_CalibrationLevel.level);
         }
         else if(resp.hasOwnProperty("JSON_enableSignalOutput"))
         {
            if(resp.JSON_enableSignalOutput.hasOwnProperty("outSendSignals"))
            {
               Framework.Trace("NDRControl.JSON_enableSignalOutput.outSendSignals = \'" + resp.JSON_enableSignalOutput.outSendSignals + "\'");
               if(resp.JSON_enableSignalOutput.outSendSignals == true)
               {
                  this.subScribeETC_TripComputer(true);
               }
               else
               {
                  this.subScribeETC_TripComputer(false);
               }
            }
         }
      }
      
      public function tripComputerStart() : void
      {
         var message:String = null;
         Framework.Trace("NDRManager.tripComputerStart()");
         message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\":{\"ETC_requestTripStart\":\"\"}}";
         this.client.send(message);
      }
      
      public function tripComputerStop() : void
      {
         var message:String = null;
         Framework.Trace("NDRManager.tripComputerStop()");
         message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\":{\"ETC_requestTripStop\":\"\"}}";
         this.client.send(message);
      }
      
      public function tripComputerReset() : void
      {
         var message:String = null;
         Framework.Trace("NDRManager.tripComputerReset()");
         message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\":{\"ETC_requestTripReset\":\"\"}}";
         this.client.send(message);
      }
      
      public function enableTripComputerSignals(enable:Boolean) : void
      {
         var message:String = null;
         if(enable)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\": {\"JSON_enableSignalOutput\":{\"inSendSignals\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"NDR\", \"packet\": {\"JSON_enableSignalOutput\":{\"inSendSignals\":false}}}";
            this.mTripComputerData = null;
         }
         this.client.send(message);
      }
      
      public function getTripComputerData() : void
      {
         this.sendEvent(NDRControlEvent.NDR_TRIP_COMPUTER_DATA);
      }
      
      public function get tripComputerData() : Object
      {
         return this.mTripComputerData;
      }
      
      public function getVehSpeed() : void
      {
         this.sendEvent(NDRControlEvent.NDR_SATELLITE_INFO);
      }
      
      public function get vehicleSpeed() : int
      {
         return this.mVehSpeed;
      }
      
      private function subScribeETC_TripComputer(subscribe:Boolean) : void
      {
         if(subscribe)
         {
            this.sendSubscribe("ETC_TripComputer");
            this.sendSubscribe("POS_VehicleSpeed");
            this.getProperty("\"ETC_TripComputer\"");
            this.getProperty("\"POS_VehicleSpeed\"");
         }
         else
         {
            this.sendUnSubscribe("ETC_TripComputer");
            this.sendUnSubscribe("POS_VehicleSpeed");
         }
      }
      
      private function setCalibrationMessage(level:int) : void
      {
         var tmpCalMessage:Boolean = this.calMessage;
         if(level < 3)
         {
            this.calMessage = true;
         }
         else
         {
            this.calMessage = false;
            this.enableCalibrationSubscriptions(false);
         }
         if(tmpCalMessage != this.calMessage)
         {
            this.getCalibrationMessage();
         }
      }
      
      public function get calibrationMessage() : Boolean
      {
         return this.calMessage;
      }
      
      public function getCalibrationMessage() : void
      {
         this.sendEvent(NDRControlEvent.NAV_LOW_CALIBRATION);
      }
   }
}

