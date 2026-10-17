package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AudioMixerManagerEvent extends Event
   {
      
      public static const AMM_BUSY:String = "AMM_busy";
      
      public static const AMM_INFORMATION_REQUEST_GRANTED:String = "AMM_InformationRequestGranted";
      
      public static const AMM_NAV_PROMPT_VOLUME_CHANGE:String = "AMM_NavPromptVolumeChange";
      
      public static const AMM_ABORT_NAV_AUDIO_INTERUPT:String = "AMM_AbortNavAudioInterupt";
      
      public static const AMM_DAB_TO_FM_FOLLOWING:String = "AAM_dabfmFollowingActive";
      
      public static const AMM_INTERRUPT_SRC:String = "AMM_interruptSrc";
      
      public static const AMM_AUX_VOLUME_OFFSET:String = "AMM_AuxVolumeOffset";
      
      public function AudioMixerManagerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

