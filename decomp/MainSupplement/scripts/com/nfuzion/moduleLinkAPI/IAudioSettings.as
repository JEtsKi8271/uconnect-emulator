package com.nfuzion.moduleLinkAPI
{
   public interface IAudioSettings extends IModule
   {
      
      function get volumeRaw() : Number;
      
      function set volumeRaw(param1:Number) : void;
      
      function set HWVolumeRelative(param1:int) : void;
      
      function set volumeConfirmationValue(param1:Number) : void;
      
      function set volumePopupIsActive(param1:Boolean) : void;
      
      function setSHFMicMute(param1:Boolean) : void;
      
      function get SHFMicMute() : Boolean;
      
      function get seatbeltMute() : Boolean;
      
      function get teenKeyVolumeCap() : Boolean;
      
      function setBalanceFade(param1:Number, param2:Number) : void;
      
      function setBalance(param1:Number) : void;
      
      function get balance() : Number;
      
      function setFade(param1:Number) : void;
      
      function get fade() : Number;
      
      function setBass(param1:Number) : void;
      
      function get bass() : Number;
      
      function setTreble(param1:Number) : void;
      
      function get treble() : Number;
      
      function setMid(param1:Number) : void;
      
      function get mid() : Number;
      
      function setSpeedVolume(param1:Number) : void;
      
      function get speedVolume() : Number;
      
      function setSurroundSoundAvailable(param1:Boolean) : void;
      
      function setSurroundSoundStatus(param1:Boolean) : void;
      
      function get surroundSoundAvailable() : Boolean;
      
      function get surroundSoundStatus() : Boolean;
      
      function setLoudness(param1:Boolean) : void;
      
      function get Loudness() : Boolean;
      
      function get twoChannelMode() : Boolean;
      
      function get boosterAmpPresent() : Boolean;
      
      function get interruptStatus() : Boolean;
      
      function set audioAutoPlayStatus(param1:String) : void;
      
      function get audioAutoPlayStatus() : String;
   }
}

