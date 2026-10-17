package apps
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.PhoneProjectionEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import core.utils.Text;
   import events.EmergencyCallStateEvent;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppPhone extends App
   {
      
      public function AppPhone()
      {
         super();
         id = ID.PHONE;
      }
      
      override public function get cp() : IApp
      {
         return new AppPhone();
      }
      
      override public function get label() : String
      {
         switch(Peripheral.emergencyCallState.getEmergencyCallState())
         {
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY:
               return "9-1-1";
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END:
               if(Peripheral.emergencyCallState.getECallType() == "emergency_callback")
               {
                  return Text.getText(T.STRB_CALL);
               }
               return "9-1-1";
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK:
               return Text.getText(T.STRB_CALL);
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
         }
         if(Peripheral.phoneProjection.sessionActive)
         {
            if(Peripheral.phoneProjection.TYPE_CARPLAY == Peripheral.phoneProjection.sessionType)
            {
               if(favorite)
               {
                  return "CarPlay";
               }
               return "Apple\nCarPlay";
            }
            if(Peripheral.phoneProjection.TYPE_GAL == Peripheral.phoneProjection.sessionType)
            {
               if(favorite)
               {
                  return "AutoLink";
               }
               return "Auto\nLink";
            }
            return "";
         }
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_PHONE);
         }
         return Text.getText(T.STRB_PHONE_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Phone();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
         mButton.wave.visible = _visible && favorite;
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         Peripheral.bluetooth.addEventListener(BluetoothEvent.BLUETOOTH_STATUS,this.onBluetoothStatus,false,0,true);
         Peripheral.bluetooth.addEventListener(BluetoothEvent.DEVICE_CONNECT_OK,this.onBluetoothStatus,false,0,true);
         Peripheral.bluetooth.addEventListener(BluetoothEvent.SERVICE_DISCONNECTED,this.onBluetoothStatus,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality,false,0,true);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.NETWORK_REGISTRATION_STATE,this.onNetworkRegistrationState,false,0,true);
         Peripheral.emergencyCallState.addEventListener(EmergencyCallStateEvent.EMERGENCY_CALLSTATE,this.onEmergencyCallState,false,0,true);
         Peripheral.phoneProjection.addEventListener(PhoneProjectionEvent.PROJECTION_STATUS,this.onPhoneProjectionStatus,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.bluetooth.removeEventListener(BluetoothEvent.BLUETOOTH_STATUS,this.onBluetoothStatus);
         Peripheral.bluetooth.removeEventListener(BluetoothEvent.DEVICE_CONNECT_OK,this.onBluetoothStatus);
         Peripheral.bluetooth.removeEventListener(BluetoothEvent.SERVICE_DISCONNECTED,this.onBluetoothStatus);
         Peripheral.bluetoothPhone.removeEventListener(BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality);
         Peripheral.bluetoothPhone.removeEventListener(BluetoothEvent.NETWORK_REGISTRATION_STATE,this.onNetworkRegistrationState);
         Peripheral.emergencyCallState.removeEventListener(EmergencyCallStateEvent.EMERGENCY_CALLSTATE,this.onEmergencyCallState);
         Peripheral.phoneProjection.removeEventListener(PhoneProjectionEvent.PROJECTION_STATUS,this.onPhoneProjectionStatus);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         var isDeviceConnected:Boolean = false;
         Framework.popupManager.exit();
         if(Peripheral.phoneProjection.BacktoCar)
         {
            Peripheral.appStateManager.callStartProjection(Peripheral.appStateManager.activePpId);
         }
         if(this.isEmergencyCall())
         {
            Framework.structure.goto("mainbackground/menu/emergencycall");
         }
         else if(Peripheral.appStateManager.isAssistAppRunningInBkgd())
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_PHONE_NOT_AVAILABLE_DURING_ASSIST_CALL);
         }
         else if(Peripheral.phoneProjection.sessionActive)
         {
            Framework.structure.goto(Screens.DEVICE_PROJECTION);
         }
         else
         {
            if(Framework.structure.currentBranch != Screens.MAIN_PHONE && Framework.structure.currentBranch != Screens.SETTINGS_BLUETOOTH)
            {
               isDeviceConnected = Peripheral.bluetooth.currentHFPDevice != null && Peripheral.bluetooth.currentHFPDevice.HfpConnected;
               if(false == isDeviceConnected && Peripheral.bluetooth.serviceDisconnectedReason != "" && Peripheral.audioManager.SOURCE_BLUETOOTH == Peripheral.audioManager.source && Peripheral.bluetooth.currentA2DPDevice != null && Peripheral.bluetooth.currentA2DPDevice.A2dpConnected == true)
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"a2dp connected"
                  });
               }
               else if(false == isDeviceConnected && Peripheral.appStateManager.isAssistAppRunningInBkgd() == false)
               {
                  if(!Peripheral.vehicleStatus.speedLockOut)
                  {
                     if(Peripheral.bluetooth.BT_Status == true)
                     {
                        Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                           "type":PopupType.PRIMARY,
                           "status":"no phone paired"
                        });
                     }
                  }
               }
            }
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      override public function refresh() : void
      {
         this.updateIcon();
         this.updateLocale();
         this.updateHighlight();
         this.updateBluetooth();
         this.updateSignalQuality();
      }
      
      override public function updateIcon() : void
      {
         if(this.isEmergencyCall())
         {
            this.button.bluetooth.alpha = 1;
            this.button.signalStrength.alpha = 1;
            this.button.icon.gotoAndStop(2);
         }
         else if(Peripheral.phoneProjection.sessionActive)
         {
            if(Peripheral.phoneProjection.TYPE_CARPLAY == Peripheral.phoneProjection.sessionType)
            {
               this.button.bluetooth.alpha = 0;
               this.button.signalStrength.alpha = 0;
               this.button.icon.gotoAndStop(3);
            }
            else if(Peripheral.phoneProjection.TYPE_GAL == Peripheral.phoneProjection.sessionType)
            {
               this.button.bluetooth.alpha = 0;
               this.button.signalStrength.alpha = 0;
               this.button.icon.gotoAndStop(4);
            }
         }
         else
         {
            this.button.bluetooth.alpha = 1;
            this.button.signalStrength.alpha = 1;
            this.button.icon.gotoAndStop(1);
         }
      }
      
      override public function updateLocale() : void
      {
         switch(Peripheral.emergencyCallState.getEmergencyCallState())
         {
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY:
               Text.format(this.button.label,"9-1-1");
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END:
               if(Peripheral.emergencyCallState.getECallType() == "emergency_callback")
               {
                  Text.format(this.button.label,T.STRB_CALL);
               }
               else
               {
                  Text.format(this.button.label,"9-1-1");
               }
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK:
               Text.format(this.button.label,T.STRB_CALL);
               break;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
            default:
               if(Peripheral.phoneProjection.sessionActive)
               {
                  if(Peripheral.phoneProjection.TYPE_CARPLAY == Peripheral.phoneProjection.sessionType)
                  {
                     if(favorite)
                     {
                        Text.format(this.button.label,"CarPlay");
                     }
                     else
                     {
                        Text.format(this.button.label,"Apple\nCarPlay");
                     }
                  }
                  else if(Peripheral.phoneProjection.TYPE_GAL == Peripheral.phoneProjection.sessionType)
                  {
                     if(favorite)
                     {
                        Text.format(this.button.label,"AutoLink");
                     }
                     else
                     {
                        Text.format(this.button.label,"Auto\nLink");
                     }
                  }
               }
               else if(favorite)
               {
                  Text.format(this.button.label,T.STRB_MENU_PHONE);
               }
               else
               {
                  Text.format(this.button.label,T.STRB_PHONE_ML);
               }
         }
      }
      
      override public function updateHighlight() : void
      {
         if(this.isEmergencyCall())
         {
            this.button.setHighlight(Framework.structure.currentBranch == "mainbackground/menu/emergencycall");
         }
         else if(Framework.structure.currentBranch == Screens.DEVICE_PROJECTION || Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_PHONE)
         {
            this.button.setHighlight(true);
         }
         else
         {
            this.button.setHighlight(false);
         }
      }
      
      private function updateBluetooth() : void
      {
         if(this.isEmergencyCall())
         {
            this.button.bluetooth.visible = false;
            this.button.signalStrength.visible = false;
         }
         else if(Peripheral.bluetooth.currentHFPDevice != null && Peripheral.bluetooth.currentHFPDevice.HfpConnected)
         {
            this.button.bluetooth.visible = true;
         }
         else
         {
            this.button.bluetooth.visible = false;
            this.button.signalStrength.visible = false;
         }
      }
      
      private function updateSignalQuality() : void
      {
         if(this.isEmergencyCall())
         {
            return;
         }
         var signalQuality:int = Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality;
         if(Peripheral.bluetooth.currentHFPDevice != null && Peripheral.bluetooth.currentHFPDevice.HfpConnected)
         {
            if(Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_HOME" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_ROAMING" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_UNKNOWN")
            {
               signalQuality = 0;
            }
            this.button.signalStrength.visible = true;
            if(signalQuality == 0)
            {
               this.button.signalStrength.gotoAndStop(1);
            }
            else if(signalQuality > 0 && signalQuality <= 5)
            {
               this.button.signalStrength.gotoAndStop(2);
            }
            else if(signalQuality > 5 && signalQuality <= 9)
            {
               this.button.signalStrength.gotoAndStop(3);
            }
            else if(signalQuality > 9 && signalQuality <= 16)
            {
               this.button.signalStrength.gotoAndStop(4);
            }
            else if(signalQuality > 16 && signalQuality <= 21)
            {
               this.button.signalStrength.gotoAndStop(5);
            }
            else if(signalQuality > 21)
            {
               this.button.signalStrength.gotoAndStop(6);
            }
            else
            {
               this.button.signalStrength.gotoAndStop(1);
            }
         }
         else
         {
            this.button.signalStrength.visible = false;
         }
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
      
      private function onBluetoothStatus(e:BluetoothEvent) : void
      {
         this.updateBluetooth();
      }
      
      private function onNetworkRegistrationState(e:BluetoothEvent) : void
      {
         this.updateSignalQuality();
      }
      
      private function onSignalQuality(e:BluetoothEvent) : void
      {
         this.updateSignalQuality();
      }
      
      private function onEmergencyCallState(e:EmergencyCallStateEvent) : void
      {
         this.updateEmergencyState();
      }
      
      private function updateEmergencyState() : void
      {
         this.refresh();
      }
      
      private function isEmergencyCall() : Boolean
      {
         switch(Peripheral.emergencyCallState.getEmergencyCallState())
         {
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_STARTING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_DIALING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RING:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ACTIVE:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_END:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_RETRY:
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_ECALLBACK:
               return true;
            case EmergencyCallStateEvent.EMERGENCY_CALLSTATE_IDLE:
         }
         return false;
      }
      
      private function onPhoneProjectionStatus(e:PhoneProjectionEvent) : void
      {
         this.refresh();
      }
   }
}

