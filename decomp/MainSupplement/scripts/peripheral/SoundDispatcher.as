package peripheral
{
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import events.SoundEvent;
   
   public class SoundDispatcher
   {
      
      private static var instance:SoundDispatcher;
      
      public function SoundDispatcher()
      {
         super();
         Global.stage.addEventListener(SoundEvent.CLICK,this.onSoundEvent);
         Global.stage.addEventListener(SoundEvent.REJECT,this.onSoundEvent);
         Global.stage.addEventListener(SoundEvent.TOGGLE,this.onSoundEvent);
         Global.stage.addEventListener(SoundEvent.SET,this.onSoundEvent);
         Framework.messenger.addEventListener(SoundEvent.CLICK,this.onSoundEvent);
         Framework.messenger.addEventListener(SoundEvent.REJECT,this.onSoundEvent);
         Framework.messenger.addEventListener(SoundEvent.TOGGLE,this.onSoundEvent);
         Framework.messenger.addEventListener(SoundEvent.SET,this.onSoundEvent);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TOUCHSCREENBEEP,this.setTouchScreenEnableAMM);
         this.setTouchScreenEnableAMM(null);
      }
      
      public static function getInstance() : SoundDispatcher
      {
         if(instance == null)
         {
            instance = new SoundDispatcher();
         }
         return instance;
      }
      
      private function setTouchScreenEnableAMM(e:PersonalConfigEvent) : void
      {
         Peripheral.audioMixerManager.setTouchScreenEnable(Peripheral.personalConfig.displayTouchScreenBeep);
      }
      
      private function onSoundEvent(e:SoundEvent) : void
      {
         switch(e.type)
         {
            case SoundEvent.CLICK:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
               break;
            case SoundEvent.REJECT:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               break;
            case SoundEvent.TOGGLE:
               Peripheral.audioManager.sendAudioBeep();
               break;
            case SoundEvent.SET:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         }
      }
   }
}

