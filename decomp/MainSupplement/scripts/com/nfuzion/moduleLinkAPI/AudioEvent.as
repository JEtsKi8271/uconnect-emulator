package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AudioEvent extends Event
   {
      
      public static const VOLUME:String = "volume";
      
      public static const VOLUME_LIMIT_REACHED:String = "volumeLimitReached";
      
      public static const INTERRUPT_MUTE:String = "interruptMute";
      
      public static const SOURCE_MUTE:String = "sourceMute";
      
      public static const SEATBELT_MUTE:String = "seatbeltMute";
      
      public static const DEVICES_ON_USB_HUB:String = "devicesOnUSBHub";
      
      public static const BALANCEFADE:String = "balanceFade";
      
      public static const EQUALIZER:String = "equalizer";
      
      public static const SPEED:String = "speed";
      
      public static const SURROUNDSOUNDAVAILABLE:String = "surroundSoundAvailable";
      
      public static const SURROUNDSOUNDSTATUS:String = "surroundSoundStatus";
      
      public static const AUTOPLAYSTATUS:String = "autoPlayStatus";
      
      public static const HFMIC:String = "hfmic";
      
      public static const LOUDNESS:String = "loudness";
      
      public static const SOURCE:String = "source";
      
      public static const AVAILABILITY:String = "availability";
      
      public static const ACTIVEAUDIOSOURCE:String = "activeAudioSrc";
      
      public static const INFORMATION_REQUEST_GRANTED:String = "informationRequestGranted";
      
      public static const INTERRUPT_STATUS:String = "interruptStatus";
      
      public static const SOURCE_ERROR:String = "sourceError";
      
      public static const SOURCE_REFRESH:String = "sourceRefresh";
      
      public function AudioEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

