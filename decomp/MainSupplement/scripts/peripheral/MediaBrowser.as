package peripheral
{
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerItemList;
   import com.nfuzion.moduleLinkAPI.MediaPlayerPath;
   import com.nfuzion.moduleLinkAPI.MediaPlayerSyncState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MediaBrowser extends EventDispatcher
   {
      
      private static var instance:MediaBrowser;
      
      private var mViews:MediaPlayerItemList = null;
      
      private var mCurrentSource:String;
      
      private var mTargetPath:MediaPlayerPath = null;
      
      public function MediaBrowser()
      {
         super();
      }
      
      public static function getInstance() : MediaBrowser
      {
         if(instance == null)
         {
            instance = new MediaBrowser();
         }
         return instance;
      }
      
      public function init() : void
      {
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource);
         this.processCurrentAudioSource();
      }
      
      private function onSource(e:AudioEvent) : void
      {
         this.processCurrentAudioSource();
      }
      
      private function processCurrentAudioSource() : void
      {
         if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
         {
            if(this.mCurrentSource != Peripheral.audioManager.source)
            {
               this.startBrowserProcess();
            }
         }
         else
         {
            this.mViews = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
         this.mCurrentSource = Peripheral.audioManager.source;
      }
      
      public function resetBrowser() : void
      {
         if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
         {
            this.startBrowserProcess();
         }
      }
      
      public function startBrowserProcess() : void
      {
         if(!this.isABrowseSource(Peripheral.audioManager.source))
         {
            return;
         }
         this.mViews = null;
         Peripheral.mediaPlayer.browsePath = new MediaPlayerPath();
         Peripheral.mediaPlayer.browsePath.path = "";
         dispatchEvent(new Event(Event.CLOSE));
         Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.BROWSE_PATH,this.onBrowsePath);
         if(!Peripheral.audioManager.isSourceIPod())
         {
            Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.SYNC_STATE,this.onSyncState);
         }
      }
      
      private function processSyncState() : void
      {
         var data:MediaPlayerPath = new MediaPlayerPath();
         Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.BROWSE_PATH,this.onBrowsePath);
         data.path = MediaPlayerPath.METADATA_ROOT;
         data.type = null;
         Peripheral.mediaPlayer.setBrowsePath(data);
      }
      
      private function isABrowseSource(source:String) : Boolean
      {
         return Peripheral.audioManager.isSourceUSB(source) || source == Peripheral.audioManager.SOURCE_SDCARD || source == Peripheral.audioManager.SOURCE_BLUETOOTH;
      }
      
      private function onSyncState(e:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.syncState == MediaPlayerSyncState.METADATA)
         {
            Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.SYNC_STATE,this.onSyncState);
            if(Framework.structure.currentBranch == Screens.BROWSE_MEDIA)
            {
               Peripheral.mediaPlayer.getPlaylistCount();
            }
            this.clearAvailableViews();
         }
      }
      
      public function setBrowsePath(data:MediaPlayerPath) : void
      {
         if(data.path == Peripheral.mediaPlayer.browsePath.path)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         else
         {
            Peripheral.mediaPlayer.setBrowsePath(data);
            this.mTargetPath = data;
         }
      }
      
      protected function onBrowsePath(evt:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.browsePath.path == MediaPlayerPath.METADATA_ROOT)
         {
            Peripheral.mediaPlayer.addEventListener(MediaPlayerEvent.BROWSE_ITEMS,this.onBrowseItems);
            Peripheral.mediaPlayer.getBrowseItems();
         }
         else
         {
            this.mTargetPath = null;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      protected function onBrowseItems(evt:MediaPlayerEvent) : void
      {
         if(Peripheral.mediaPlayer.browsePath.path == MediaPlayerPath.METADATA_ROOT)
         {
            Peripheral.mediaPlayer.removeEventListener(MediaPlayerEvent.BROWSE_ITEMS,this.onBrowseItems);
            this.mViews = evt.data;
            if(this.mTargetPath != null)
            {
               if(this.mTargetPath.path != MediaPlayerPath.METADATA_ROOT)
               {
                  this.setBrowsePath(this.mTargetPath);
               }
            }
            else
            {
               dispatchEvent(new Event(Event.OPEN));
            }
         }
      }
      
      public function reportStatus() : void
      {
         if(this.mViews == null)
         {
            dispatchEvent(new Event(Event.CLOSE));
            this.processSyncState();
         }
         else
         {
            dispatchEvent(new Event(Event.OPEN));
            if(this.mTargetPath == null)
            {
            }
         }
      }
      
      public function get availableView() : MediaPlayerItemList
      {
         return this.mViews;
      }
      
      public function clearAvailableViews() : void
      {
         this.mViews = null;
         this.mTargetPath = null;
      }
   }
}

