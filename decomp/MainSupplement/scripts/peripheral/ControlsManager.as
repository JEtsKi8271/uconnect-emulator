package peripheral
{
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.CameraEvent;
   import com.harman.moduleLinkAPI.RemoteStartEvent;
   import com.nfuzion.framework.global.Framework;
   import events.ControlsManagerEvent;
   import events.StartupEvent;
   import flash.events.Event;
   
   public class ControlsManager
   {
      
      private static var instance:ControlsManager;
      
      public function ControlsManager()
      {
         super();
         Framework.messenger.addEventListener(ControlsManagerEvent.STARTUP_INFO,this.onStartUpInfo);
         Framework.messenger.addEventListener(ControlsManagerEvent.LEFT_SEAT_HEAT,this.onLeftSeatHeat);
         Framework.messenger.addEventListener(ControlsManagerEvent.LEFT_SEAT_VENT,this.onLeftSeatVent);
         Framework.messenger.addEventListener(ControlsManagerEvent.RIGHT_SEAT_HEAT,this.onRightSeatHeat);
         Framework.messenger.addEventListener(ControlsManagerEvent.RIGHT_SEAT_VENT,this.onRightSeatVent);
         Framework.messenger.addEventListener(ControlsManagerEvent.STEERING_WHEEL_HEAT,this.onSteeringWheelHeat);
         Framework.messenger.addEventListener(ControlsManagerEvent.DRIVE_MODE_STATUS,this.onDriveModeStatus);
         Framework.messenger.addEventListener(ControlsManagerEvent.CLOSE,this.onClose);
         Framework.messenger.dispatchEvent(new StartupEvent(StartupEvent.UNLOCK));
         Peripheral.Camera.addEventListener(CameraEvent.PRND_CANCEL,this.onResetTimer);
         Peripheral.Camera.addEventListener(CameraEvent.CAMERA_UPDATE,this.onStopTimer);
         Peripheral.remoteStart.addEventListener(RemoteStartEvent.REMOTE_START_ACTIVE,this.onRemoteStartActive,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_POWER_MODE_STATE,this.onPowerModeState,false,0,true);
         Global.ignitionState = Peripheral.antiTheft.ignitionState;
         Global.lastAwakeMode = Peripheral.antiTheft.powerModeState;
         Peripheral.antiTheft.reqIgnitionState();
         Peripheral.antiTheft.reqPowerModeState();
         if(Peripheral.antiTheft.ignitionState != "on" && Peripheral.antiTheft.ignitionState != "accessory")
         {
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.STOP_DISCLAIMER));
         }
      }
      
      public static function getInstance() : ControlsManager
      {
         if(instance == null)
         {
            instance = new ControlsManager();
         }
         return instance;
      }
      
      private function onStartUpInfo(e:ControlsManagerEvent) : void
      {
         Peripheral.Camera.requestStartUpStatus();
         Peripheral.remoteStart.requestRemoteStartActive();
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         Global.ignitionState = Peripheral.antiTheft.ignitionState;
         this.startUpCheck();
      }
      
      private function onPowerModeState(e:AntiTheftEvent) : void
      {
         Global.lastAwakeMode = Peripheral.antiTheft.powerModeState;
         this.startUpCheck();
      }
      
      private function onResetTimer(e:Event) : void
      {
         Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.RESUME_DISCLAIMER));
      }
      
      private function onStopTimer(e:Event) : void
      {
         Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.STOP_DISCLAIMER));
      }
      
      private function onRemoteStartActive(e:Event) : void
      {
         if(Peripheral.remoteStart.remoteStartActive)
         {
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.STOP_DISCLAIMER));
         }
         else
         {
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.RESUME_DISCLAIMER));
         }
      }
      
      private function onLeftSeatHeat(e:ControlsManagerEvent) : void
      {
         Peripheral.vehSettings.setHeatedSeat("frontLeft",e.value);
      }
      
      private function onLeftSeatVent(e:ControlsManagerEvent) : void
      {
         Peripheral.vehSettings.setVentedSeat("frontLeft",e.value);
      }
      
      private function onRightSeatHeat(e:ControlsManagerEvent) : void
      {
         Peripheral.vehSettings.setHeatedSeat("frontRight",e.value);
      }
      
      private function onRightSeatVent(e:ControlsManagerEvent) : void
      {
         Peripheral.vehSettings.setVentedSeat("frontRight",e.value);
      }
      
      private function onSteeringWheelHeat(e:ControlsManagerEvent) : void
      {
         Peripheral.vehSettings.setHeatedSteeringWheel(e.value);
      }
      
      private function onDriveModeStatus(e:ControlsManagerEvent) : void
      {
         Peripheral.driveMode.GlobalDriveModeRequest = e.value;
      }
      
      private function onClose(e:ControlsManagerEvent) : void
      {
         Framework.messenger.removeEventListener(ControlsManagerEvent.LEFT_SEAT_HEAT,this.onLeftSeatHeat);
         Framework.messenger.removeEventListener(ControlsManagerEvent.LEFT_SEAT_VENT,this.onLeftSeatHeat);
         Framework.messenger.removeEventListener(ControlsManagerEvent.RIGHT_SEAT_HEAT,this.onLeftSeatHeat);
         Framework.messenger.removeEventListener(ControlsManagerEvent.RIGHT_SEAT_VENT,this.onLeftSeatHeat);
         Framework.messenger.removeEventListener(ControlsManagerEvent.STEERING_WHEEL_HEAT,this.onLeftSeatHeat);
         Framework.messenger.removeEventListener(ControlsManagerEvent.DRIVE_MODE_STATUS,this.onDriveModeStatus);
         Framework.messenger.removeEventListener(ControlsManagerEvent.CLOSE,this.onClose);
         Peripheral.controlsManager = null;
         this.removeListeners();
      }
      
      private function removeListeners() : void
      {
         Peripheral.Camera.removeEventListener(CameraEvent.PRND_CANCEL,this.onResetTimer);
         Peripheral.Camera.removeEventListener(CameraEvent.CAMERA_UPDATE,this.onStopTimer);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         Peripheral.remoteStart.removeEventListener(RemoteStartEvent.REMOTE_START_ACTIVE,this.onRemoteStartActive);
      }
      
      private function startUpCheck() : void
      {
         if(Peripheral.Camera.getgearStatus() != "1" && (Peripheral.antiTheft.ignitionState == "on" || Peripheral.antiTheft.ignitionState == "accessory") && (Peripheral.antiTheft.powerModeState == "full_operation" || Peripheral.antiTheft.powerModeState == "timed"))
         {
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.STOP_DISCLAIMER));
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.RESUME_DISCLAIMER));
         }
         else
         {
            Framework.messenger.dispatchEvent(new ControlsManagerEvent(ControlsManagerEvent.STOP_DISCLAIMER));
         }
      }
   }
}

