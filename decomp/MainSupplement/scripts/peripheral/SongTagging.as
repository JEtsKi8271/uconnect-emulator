package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.moduleLinkAPI.IPodTaggerEvent;
   import com.nfuzion.framework.global.Framework;
   
   public class SongTagging
   {
      
      private static var instance:SongTagging;
      
      public function SongTagging()
      {
         super();
      }
      
      public static function getInstance() : SongTagging
      {
         if(instance == null)
         {
            instance = new SongTagging();
         }
         return instance;
      }
      
      public function init() : void
      {
         Peripheral.ipodTagger.addEventListener(IPodTaggerEvent.TRANSFER_RESULT,this.onTagTransfer);
      }
      
      private function onTagTransfer(e:IPodTaggerEvent) : void
      {
         if(e == null && e.eventdata != null)
         {
            return;
         }
         var tagResult:int = e.eventdata.Value as int;
         switch(tagResult)
         {
            case IPodTaggerEvent.TagStoredLocal:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_SONG_TAGGED);
               break;
            case IPodTaggerEvent.TagLocalStorageFull:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_QUEUE_FULL);
               break;
            case IPodTaggerEvent.TagStoredToTarget:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_TRANSFER);
               break;
            case IPodTaggerEvent.TagsTransferSucceeded:
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_TRANSFER);
               break;
            case IPodTaggerEvent.TagTargetFull:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_IPOD_FULL);
               break;
            case IPodTaggerEvent.TagTransferFailed:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_TRANSFER_ERROR);
               break;
            case IPodTaggerEvent.TagStoredLocalIPodIncompatible:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_SONG_TAGGED_IPOD_INCOMPATIBLE);
               break;
            case IPodTaggerEvent.TagLocalFullIPodIncompatible:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_QUEUE_FULL_IPOD_INCOMPATIBLE);
               break;
            case IPodTaggerEvent.TagErrorMultipleIPods:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_TWO_IPODS);
               break;
            case IPodTaggerEvent.TagNewIPodIncompatible:
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_IPOD_INCOMPATIBLE);
               break;
            case IPodTaggerEvent.TagError:
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.TAGGING_TRANSFER_ERROR);
               break;
            case IPodTaggerEvent.TagOK:
               break;
            default:
               Framework.Trace("Unknown Tagging result: " + tagResult);
         }
      }
   }
}

