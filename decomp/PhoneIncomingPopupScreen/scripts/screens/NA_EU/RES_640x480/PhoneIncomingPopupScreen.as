package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.harman.moduleLinkAPI.RSEConstants;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.utils.Text;
   import events.WidgetEvent;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PhoneIncomingPopupScreen extends GenericScreen
   {
      
      public function PhoneIncomingPopupScreen()
      {
         mView = new C_PhoneIncomingPopupScreenView();
         super();
         setDebounce(750);
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.displayPrimaryPhone.type.visible = true;
         mView.displayPrimaryPhone.labelRoaming.visible = false;
         mView.displayPrimaryPhone.labelCallTime.visible = false;
         t(mView.displayPrimaryPhone.labelAction,T.STRB_INCOMING_CALL);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         Text.format(mView.displayPrimaryPhone.labelPhoneName,Peripheral.bluetooth.currentHFPDevice.DevName);
         this.updateBatteryCharge(Peripheral.bluetoothPhone.bluetoothHFP.batteryCharge);
         this.updateSignalQuality(Peripheral.bluetoothPhone.bluetoothHFP.HFPSignalQuality);
         this.updateCallerID();
         if(isDebounceTimerRunning())
         {
            mView.btnAnswer_button.setInteractive(false);
            mView.btnIgnore_button.setInteractive(false);
            mView.btnTransfer_button.setInteractive(false);
            mView.btnMute_button.setInteractive(false);
         }
         this.changeLocale();
         mView.btnMute_button.setHighlight(false);
         Framework.focusManager.addFocus(new FocusObject(Layers.POPUPS,FocusPriority.REGULAR,[mView.btnAnswer_button,mView.btnIgnore_button,mView.btnMute_button,mView.btnTransfer_button]));
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onBTServiceDisconnected,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.BATTERY_CHARGE,this.onBatteryCharge,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALLER_ID_INFO,this.onCallerID,false,0,true);
         attachListener(Peripheral.audioMixerManager,AudioEvent.INTERRUPT_MUTE,this.onMuteStatusEvent,false,0,false);
         attachListener(mView.btnAnswer_button,WidgetEvent.CLICK,this.answerScreenEvent,false,0,true);
         attachListener(mView.btnIgnore_button,WidgetEvent.CLICK,this.ignoreScreenEvent,false,0,true);
         attachListener(mView.btnTransfer_button,WidgetEvent.CLICK,this.transferScreenEvent,false,0,true);
         attachListener(mView.btnMute_button,WidgetEvent.CLICK,this.muteScreenEvent,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onBTServiceDisconnected);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.SIGNAL_QUALITY,this.onSignalQuality);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.BATTERY_CHARGE,this.onBatteryCharge);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALLER_ID_INFO,this.onCallerID);
         detachListener(mView.btnAnswer_button,WidgetEvent.CLICK,this.answerScreenEvent);
         detachListener(mView.btnIgnore_button,WidgetEvent.CLICK,this.ignoreScreenEvent);
         detachListener(mView.btnTransfer_button,WidgetEvent.CLICK,this.transferScreenEvent);
         detachListener(mView.btnMute_button,WidgetEvent.CLICK,this.muteScreenEvent);
         super.removeListeners();
      }
      
      override protected function debounceHandler() : void
      {
         mView.btnAnswer_button.setInteractive(true);
         mView.btnIgnore_button.setInteractive(true);
         mView.btnTransfer_button.setInteractive(true);
         mView.btnMute_button.setInteractive(true);
         attachListener(mView.displayPrimaryPhone,MouseEvent.CLICK,this.answerScreenEvent,false,0,true);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.btnAnswer_button.value_label,T.STRB_ANSWER);
         t(mView.btnIgnore_button.value_label,T.STRB_IGNORE);
         t(mView.btnTransfer_button.value_label,T.STRB_TRANSFER);
         t(mView.btnMute_button.value_label,T.STRB_MUTE_PHONE);
         mView.updateTransferButtonLabel();
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
         Peripheral.audioMixerManager.sendPhoneMute(false);
      }
      
      protected function onBTServiceDisconnected(evt:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
         }
      }
      
      private function answerScreenEvent(e:Event) : void
      {
         Peripheral.bluetoothPhone.acceptIncomingCall();
         Peripheral.audioMixerManager.sendPhoneMute(false);
         mView.btnMute_button.setHighlight(false);
         Peripheral.audioSettings.setSHFMicMute(false);
         if(Framework.structure.currentBranch == Screens.DISPLAY_OFF)
         {
            Peripheral.versionInfo.setDisplayStatus(true);
            Peripheral.appStateManager.screenOnDisplay();
            Framework.popupManager.dequeue(DynamicPopupNames.SCREEN_OFF);
         }
         if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE))
         {
            Peripheral.rse.requestExitFullScreen(RSEConstants.RDC_CAM);
         }
         Framework.popupManager.exit();
      }
      
      private function ignoreScreenEvent(e:Event) : void
      {
         Peripheral.audioMixerManager.sendPhoneMute(false);
         mView.btnMute_button.setHighlight(false);
         Peripheral.bluetoothPhone.rejectIncomingCall();
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
      }
      
      private function transferScreenEvent(e:Event) : void
      {
         Peripheral.bluetoothPhone.acceptIncomingCall(true);
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
         if(Framework.structure.currentBranch == Screens.DTV_FULL_SCREEN)
         {
            Framework.structure.back();
         }
      }
      
      private function muteScreenEvent(e:Event) : void
      {
         Peripheral.audioMixerManager.sendPhoneMute(!Peripheral.audioMixerManager.phoneMuteStatus);
      }
      
      private function onBatteryCharge(evt:BluetoothEvent) : void
      {
         this.updateBatteryCharge(Peripheral.bluetoothPhone.bluetoothHFP.batteryCharge);
      }
      
      private function updateBatteryCharge(batteryCharge:int) : void
      {
         switch(batteryCharge)
         {
            case -1:
            case 0:
            case 1:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("low");
               break;
            case 2:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("one");
               break;
            case 3:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("two");
               break;
            case 4:
            case 5:
               mView.displayPrimaryPhone.displayBatteryStatus.gotoAndStop("three");
         }
      }
      
      private function onSignalQuality(evt:BluetoothEvent) : void
      {
         var signalQuality:Object = evt.data;
         this.updateSignalQuality(signalQuality);
      }
      
      private function updateSignalQuality(signalQuality:Object) : void
      {
         if(Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_HOME" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_ROAMING" && Peripheral.bluetoothPhone.bluetoothHFP.networkRegistrationState != "PHONE_REGSTATE_UNKNOWN")
         {
            signalQuality = 0;
         }
         if(signalQuality == 0)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("low");
         }
         else if(signalQuality > 0 && signalQuality <= 5)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("one");
         }
         else if(signalQuality > 5 && signalQuality <= 9)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("two");
         }
         else if(signalQuality > 9 && signalQuality <= 16)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("three");
         }
         else if(signalQuality > 16 && signalQuality <= 21)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("four");
         }
         else if(signalQuality > 21)
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("five");
         }
         else
         {
            mView.displayPrimaryPhone.displaySignalStrength.gotoAndStop("low");
         }
      }
      
      private function onCallerID(evt:BluetoothEvent) : void
      {
         this.updateCallerID();
      }
      
      private function onCallStateChange(evt:BluetoothEvent) : void
      {
         if(Peripheral.bluetoothPhone.getRingingCall() != null || Peripheral.bluetoothPhone.getWaitingCall() != null)
         {
            this.updateCallerID();
         }
      }
      
      private function updateCallerID() : void
      {
         var incomingCall:BluetoothCall = null;
         incomingCall = Peripheral.bluetoothPhone.getRingingCall();
         if(incomingCall == null)
         {
            incomingCall = Peripheral.bluetoothPhone.getWaitingCall();
         }
         if(incomingCall)
         {
            if(incomingCall.callerID != null && incomingCall.callerID != "")
            {
               Format.truncateCharacters(mView.displayPrimaryPhone.labelStatus,incomingCall.callerID);
            }
            else if(incomingCall.number == "")
            {
               t(mView.displayPrimaryPhone.labelStatus,T.STRB_PHONE_PRIVATE_NUMBER_2);
            }
            else
            {
               Format.truncateCharacters(mView.displayPrimaryPhone.labelStatus,Format.phoneNumber(incomingCall.number));
            }
            switch(incomingCall.numberType)
            {
               case "workNumber":
                  mView.displayPrimaryPhone.type.gotoAndStop("work");
                  break;
               case "mobileNumber":
                  mView.displayPrimaryPhone.type.gotoAndStop("mobile");
                  break;
               case "homeNumber":
                  mView.displayPrimaryPhone.type.gotoAndStop("home");
                  break;
               case "otherNumber":
                  mView.displayPrimaryPhone.type.gotoAndStop("circle");
                  break;
               default:
                  mView.displayPrimaryPhone.type.gotoAndStop("contact");
            }
         }
         else
         {
            mView.displayPrimaryPhone.labelStatus.text = "";
         }
      }
      
      private function onMuteStatusEvent(e:Event) : void
      {
         mView.btnMute_button.setHighlight(Peripheral.audioMixerManager.phoneMuteStatus);
      }
      
      private function disconnectPhoneEvent(e:Event) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.PHONE_INCOMING_CALL);
         }
      }
   }
}

