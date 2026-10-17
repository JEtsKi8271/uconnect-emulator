package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.IBluetooth;
   import com.nfuzion.moduleLinkAPI.ISWCEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import core.enums.PopupType;
   import events.VRSessionEvent;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import locale.T;
   
   public class VRSession extends EventDispatcher
   {
      
      private var mVROverride:Boolean = false;
      
      private var mVRActive:Boolean = false;
      
      private var mVRAvailableState:Boolean = false;
      
      private var mVRContext:String = "";
      
      private var mBranch:String = "";
      
      private var bFirsttimeVRAvaible:Boolean = false;
      
      private var bMessagePlay:Boolean = false;
      
      public function VRSession()
      {
         super();
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_AVAILABLE,this.onVRStateAvailable,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_SESSION_TYPE,this.onVRSessionType,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_AUDIOUPDATE,this.onVRAudioUpdate,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VOICE_PROMPT,this.onVRVoicePrompt,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_DICTATION_ABORTED,this.onSMSDictationAborted,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SHOW_LIST,this.onShowList,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.HIDE_LIST,this.onHideList,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.REMOVE_SMS_POPUP,this.onRemoveSMSPopup,false,0,true);
         Peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.SMS_REMOVE_POPUP,this.onVRSmsRemovePopup,false,0,false);
         Peripheral.bluetoothPhone.addEventListener(BluetoothEvent.SIRI_STATUS,this.onSiriStatus,false,0,true);
         this.mVRActive = Peripheral.voiceRecognition.VRSessionInProgress;
         this.mVRAvailableState = Peripheral.voiceRecognition.isVRAvailable;
         Peripheral.swc.addEventListener(ISWCEvent.PTT_PRESS,this.onPTTSwcEvent,false,0,true);
         Peripheral.swc.addEventListener(ISWCEvent.PHONE_PRESS,this.onPhoneSwcEvent,false,0,true);
         if(this.mVRActive)
         {
            this.addEventListeners();
         }
      }
      
      private function onRemoveSMSPopup(e:VoiceRecognitionEvent) : void
      {
         Peripheral.smsMessaging.clearIncomingMessage(true);
         Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
         Framework.popupManager.dequeue(DynamicPopupNames.SMS_MESSAGE_FULL);
         Peripheral.voiceRecognition.emitVRResponse(e.mData.context,e.mData.methodName,true);
      }
      
      private function onVRSmsRemovePopup(evt:VoiceRecognitionEvent) : void
      {
         var status:String = "failure";
         if(DynamicPopupNames.SMS_INCOMING_MESSAGE == Framework.popupManager.active)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.SMS_INCOMING_MESSAGE);
            status = "success";
         }
         Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,status,null,null);
      }
      
      public function setVRContext(vrContext:String = "", branch:String = "") : void
      {
         if(vrContext != "")
         {
            this.mVRContext = vrContext;
         }
         if(branch != "")
         {
            this.mBranch = branch;
         }
      }
      
      private function doCancel(bSilentMode:Boolean) : void
      {
         Framework.Trace("VRsession cancel VR " + bSilentMode);
         Peripheral.voiceRecognition.cancel(bSilentMode);
         this.doStatusbarEvent(VRSessionEvent.VR_HIDE_VOICE_BAR);
      }
      
      private function doStatusbarEvent(eventName:String) : void
      {
         Framework.messenger.dispatchEvent(new VRSessionEvent(eventName));
      }
      
      public function cancelVRSession(bSilentMode:Boolean = false) : Boolean
      {
         if(this.mVRActive == true)
         {
            this.doCancel(bSilentMode);
            return true;
         }
         return false;
      }
      
      private function addEventListeners() : void
      {
         Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         Framework.messenger.addEventListener(VRSessionEvent.VR_SESSION_OVERRIDE_ON,this.onOverrideEvent);
         Framework.messenger.addEventListener(VRSessionEvent.VR_SESSION_OVERRIDE_OFF,this.onOverrideEvent);
         Peripheral.swc.addEventListener(ISWCEvent.PRESET_ADVANCE,this.onSwcEvent,false,0,true);
         Peripheral.swc.addEventListener(ISWCEvent.MODE_ADVANCE,this.onSwcEvent,false,0,true);
         Peripheral.swc.addEventListener(ISWCEvent.SEEK_PLUS,this.onSwcEvent,false,0,true);
         Peripheral.swc.addEventListener(ISWCEvent.SEEK_MINUS,this.onSwcEvent,false,0,true);
      }
      
      private function removeEventListeners() : void
      {
         Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         Framework.messenger.removeEventListener(VRSessionEvent.VR_SESSION_OVERRIDE_ON,this.onOverrideEvent);
         Framework.messenger.removeEventListener(VRSessionEvent.VR_SESSION_OVERRIDE_OFF,this.onOverrideEvent);
         Peripheral.swc.removeEventListener(ISWCEvent.PRESET_ADVANCE,this.onSwcEvent);
         Peripheral.swc.removeEventListener(ISWCEvent.MODE_ADVANCE,this.onSwcEvent);
         Peripheral.swc.removeEventListener(ISWCEvent.SEEK_PLUS,this.onSwcEvent);
         Peripheral.swc.removeEventListener(ISWCEvent.SEEK_MINUS,this.onSwcEvent);
      }
      
      private function onSwcEvent(evt:ISWCEvent) : void
      {
         if(evt != null && evt.type != "")
         {
            switch(evt.type)
            {
               case ISWCEvent.PRESET_ADVANCE:
               case ISWCEvent.MODE_ADVANCE:
               case ISWCEvent.SEEK_PLUS:
               case ISWCEvent.SEEK_MINUS:
                  this.doCancel(false);
            }
         }
      }
      
      private function onShowList(e:VoiceRecognitionEvent) : void
      {
         this.vrDialogWaves();
         if(Peripheral.voiceRecognition.listType == Peripheral.voiceRecognition.LIST_TYPE_FIND_NEAREST)
         {
            Framework.popupManager.show(DynamicPopupNames.VOICE_PICK_LIST,Screens.POPUP_FINDNEAREST,{"type":PopupType.VR});
         }
         else
         {
            Framework.popupManager.show(DynamicPopupNames.VOICE_PICK_LIST,Screens.POPUP_PICKLIST,{"type":PopupType.VR});
         }
      }
      
      private function onHideList(e:VoiceRecognitionEvent) : void
      {
         this.dispatchEvent(new VRSessionEvent(VRSessionEvent.VR_WAVES_HIDE));
         Framework.popupManager.dequeue(DynamicPopupNames.VOICE_PICK_LIST);
      }
      
      private function onPTTSwcEvent(evt:ISWCEvent) : void
      {
         Framework.Trace("got PTT event press event");
         if("long" == evt.data)
         {
            Peripheral.bluetoothPhone.getSiriStatus();
         }
         else if(Peripheral.emergencyCallState.getInEmergency() == true)
         {
            Framework.Trace("ecall going. throw popup");
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ECALL);
         }
         else if(Peripheral.appStateManager.isAssistAppRunningInBkgd() == true)
         {
            Framework.Trace("assist call going. throw popup");
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ASSIST_CALL);
         }
         else
         {
            this.updateVoiceBar(evt);
         }
      }
      
      private function onPhoneSwcEvent(evt:ISWCEvent) : void
      {
         var bt:IBluetooth = null;
         var isDeviceConnected:Boolean = false;
         var isA2DPDeviceConnected:Boolean = false;
         if(Peripheral.emergencyCallState.getInEmergency() == true)
         {
            Peripheral.appStateManager.handleECallScreen(true);
         }
         else if(Peripheral.appStateManager.isAssistAppRunningInBkgd() == false)
         {
            bt = Peripheral.bluetooth;
            isDeviceConnected = Peripheral.bluetooth.currentHFPDevice != null && Peripheral.bluetooth.currentHFPDevice.HfpConnected;
            isA2DPDeviceConnected = Peripheral.bluetooth.currentA2DPDevice != null && Peripheral.bluetooth.currentA2DPDevice.A2dpConnected;
            if(false == isDeviceConnected && Peripheral.bluetooth.serviceDisconnectedReason != "" && Peripheral.audioManager.SOURCE_BLUETOOTH == Peripheral.audioManager.source && isA2DPDeviceConnected == true)
            {
               Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"a2dp connected"
               });
            }
            else if((!bt.currentHFPDevice || !bt.currentHFPDevice.HfpAvailable) && Framework.popupManager.active != DynamicPopupNames.SCREEN_OFF)
            {
               if(!Peripheral.vehicleStatus.speedLockOut)
               {
                  Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"no phone paired"
                  });
               }
            }
            this.updateVoiceBar(evt);
         }
      }
      
      private function updateVoiceBar(evt:ISWCEvent) : void
      {
         var str:String = null;
         if(this.mVRAvailableState == false)
         {
            str = Peripheral.localeEngine.getText(T.STRB_HF_SYSTEM_LOADING) + "... " + Peripheral.localeEngine.getText(T.STRB_ERROR_BODY_PLEASE_WAIT);
            Peripheral.voiceRecognition.updateHFMVoiceBarPopup(str);
         }
      }
      
      private function onVRStateAvailable(evt:VoiceRecognitionEvent) : void
      {
         var newState:Boolean = false;
         if(evt != null && evt.mData != null)
         {
            newState = evt.mData as Boolean;
            if(newState != this.mVRAvailableState)
            {
               this.mVRAvailableState = evt.mData as Boolean;
               if(this.mVRAvailableState)
               {
                  this.doStatusbarEvent(VRSessionEvent.VR_HIDE_VOICE_BAR);
                  if(this.bFirsttimeVRAvaible == false)
                  {
                     this.bFirsttimeVRAvaible = true;
                     Peripheral.voiceRecognition.updateHFMVoiceBarPopup(Peripheral.localeEngine.getText(T.STRB_HF_SYSTEM_AVAILABLE));
                  }
               }
               else
               {
                  this.removeEventListeners();
               }
            }
         }
      }
      
      private function onVRDialogActiveMsg(evt:VoiceRecognitionEvent) : void
      {
         if(evt != null && evt.mData != null && evt.mData.vrDialogActive.state != null)
         {
            this.mVRActive = evt.mData.vrDialogActive.state;
            this.vrDialogWaves();
            if(this.mVRActive)
            {
               this.addEventListeners();
            }
            else
            {
               this.removeEventListeners();
               Framework.popupManager.dequeue(DynamicPopupNames.VOICE_PICK_LIST);
            }
         }
      }
      
      private function onVRSessionType(e:VoiceRecognitionEvent) : void
      {
         this.vrDialogWaves();
      }
      
      private function onVRVoicePrompt(e:VoiceRecognitionEvent) : void
      {
         this.vrDialogWaves();
      }
      
      private function vrDialogWaves() : void
      {
         if(this.mVRActive && Peripheral.voiceRecognition.sessionType == Peripheral.voiceRecognition.SESSION_TYPE_REGULAR && Peripheral.voiceRecognition.promptType != Peripheral.voiceRecognition.TYPE_PAUSE)
         {
            this.dispatchEvent(new VRSessionEvent(VRSessionEvent.VR_WAVES_SHOW));
         }
         else
         {
            this.dispatchEvent(new VRSessionEvent(VRSessionEvent.VR_WAVES_HIDE));
         }
      }
      
      private function onMouseEvent(e:MouseEvent) : void
      {
         if(this.mVRActive)
         {
            if(this.mVROverride == false)
            {
               this.doCancel(false);
            }
         }
      }
      
      private function onOverrideEvent(e:VRSessionEvent) : void
      {
         switch(e.type)
         {
            case VRSessionEvent.VR_SESSION_OVERRIDE_OFF:
               this.mVROverride = false;
               break;
            case VRSessionEvent.VR_SESSION_OVERRIDE_ON:
               this.mVROverride = true;
         }
      }
      
      private function onSMSDictationAborted(e:VoiceRecognitionEvent) : void
      {
         Ancillary.definedDynamicPopups.popup(DynamicPopupNames.SMS_DICTATION_ABORTED);
      }
      
      private function onVRAudioUpdate(evt:VoiceRecognitionEvent) : void
      {
         if(Framework.structure.currentBranch == Screens.BROWSE_MEDIA)
         {
            Framework.structure.goto(Screens.MAIN_MEDIA);
         }
      }
      
      private function onSiriStatus(evt:BluetoothEvent) : void
      {
         var announcement:String = null;
         if(Peripheral.emergencyCallState.getInEmergency() == true)
         {
            Framework.Trace("ecall going. throw popup");
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ECALL);
         }
         else if(Peripheral.appStateManager.isAssistAppRunningInBkgd() == true)
         {
            Framework.Trace("assist call going. throw popup");
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.INFO_VR_NOT_AVAILABLE_DURING_ASSIST_CALL);
         }
         else
         {
            announcement = Peripheral.localeEngine.getText(T.STRB_SIRI_IS_TURNED_OFF_VR);
            Peripheral.textToSpeach.readout(Peripheral.textToSpeach.READOUT_TYPE_PMSG,announcement);
            Peripheral.voiceRecognition.updateHFMVoiceBarPopup(Peripheral.localeEngine.getText(T.STRB_SIRI_NOT_AVAIL));
         }
      }
   }
}

