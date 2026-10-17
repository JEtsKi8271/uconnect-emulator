package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VoiceRecognitionEvent extends Event
   {
      
      public static const VOICE_PROMPT:String = "voicePrompt";
      
      public static const VOICE_PROMPT_REMOVE:String = "voicePromptRemove";
      
      public static const SHOW_LIST:String = "showList";
      
      public static const HIDE_LIST:String = "hideList";
      
      public static const VR_INDEX:String = "voiceRecognitionScrollIndex";
      
      public static const VR_INDEX_REQUEST:String = "voiceRecognitionIndexRequest";
      
      public static const VR_PAGE_UP:String = "voiceRecognitionPageUp";
      
      public static const VR_PAGE_DOWN:String = "voiceRecognitionPageDown";
      
      public static const VR_GOTO:String = "voiceRecognitionGoto";
      
      public static const SHOW_CONTACT:String = "VRShowContact";
      
      public static const VR_MEDIAFILTERLISTSHOW:String = "voiceRecognitionMediaFilterListShow";
      
      public static const VR_AUDIOUPDATE:String = "vrAudioUpdate";
      
      public static const VR_DIALOG_ACTIVE_MESSAGE:String = "vrDialogActive";
      
      public static const VR_SESSION_TYPE:String = "vrSessionType";
      
      public static const VR_AVAILABLE:String = "vrAvailable";
      
      public static const VR_BUSY_PROCESSING:String = "vrBusyProcessing";
      
      public static const VR_VOICE_RECOGNITION:String = "voiceRecognition";
      
      public static const VR_RESULT:String = "vrResult";
      
      public static const SMS_DICTATION_ABORTED:String = "smsDictationAborted";
      
      public static const REMOVE_SMS_POPUP:String = "removeSMSPopup";
      
      public static const DTMF_TONE_INFO:String = "VrDtmfToneInfo";
      
      public static const DND_STATUS:String = "dndStatus";
      
      public static const SMS_MESSAGE_PLAY:String = "VRSmsMessagePlay";
      
      public static const SMS_MESSAGE_SHOW:String = "VRSmsMessageShow";
      
      public static const SMS_MESSAGE_SEND:String = "VRSmsMessageSend";
      
      public static const SMS_CHECK_NUMBER:String = "VRSmsCheckNumber";
      
      public static const SMS_GET_DETAILS:String = "VRSmsGetDetails";
      
      public static const SMS_SEND_INDEXED_SMS_TO_NUMBER:String = "VRSendIndexedSmsToNumber";
      
      public static const SMS_SHOW_MESSAGE:String = "VRShowMessage";
      
      public static const SMS_REMOVE_POPUP:String = "VRSmsRemovePopup";
      
      public var mData:Object = null;
      
      public function VoiceRecognitionEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

