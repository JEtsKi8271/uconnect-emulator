package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.FrameworkEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LayerManager
   {
      
      private var mStatusbarTimeout:Timer = new Timer(3000,1);
      
      public function LayerManager()
      {
         Framework.screens.addEventListener(FrameworkEvent.IDLE,this.onScreenChange,false,0,true);
         Peripheral.audioSettings.addEventListener(AudioEvent.VOLUME,this.onVolume,false,0,true);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE_MUTE,this.onMute,false,0,true);
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_LAYER_CHANGE,this.onLayerChange,false,0,true);
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_VISIBILITY_CHANGE,this.onLayerVisibility,false,0,true);
         this.mStatusbarTimeout.addEventListener(TimerEvent.TIMER,this.onStatusbarTimer,false,0,true);
         if(Peripheral.displayManager.RearCameraStatus && Peripheral.vehConfig.hasRearCamera)
         {
            Framework.popupManager.show(DynamicPopupNames.CAMERAS,Screens.POPUP_CAMERAS,{"type":PopupType.CAMERA});
         }
         super();
      }
      
      private function onScreenChange(e:FrameworkEvent) : void
      {
         this.checkLayering();
      }
      
      private function onVolume(e:AudioEvent) : void
      {
         if(this.mStatusbarTimeout.running)
         {
            this.mStatusbarTimeout.reset();
            this.mStatusbarTimeout.start();
         }
         else
         {
            this.mStatusbarTimeout.start();
            this.checkLayering();
         }
      }
      
      private function onMute(e:AudioEvent) : void
      {
         if(this.mStatusbarTimeout.running)
         {
            this.mStatusbarTimeout.reset();
            this.mStatusbarTimeout.start();
         }
         else
         {
            this.mStatusbarTimeout.start();
            this.checkLayering();
         }
      }
      
      private function onLayerChange(e:DisplayManagerEvent) : void
      {
         if(e.mData == DisplayManagerLayers.LAYER_CAMERA_BACKUP || e.mData == DisplayManagerLayers.LAYER_CAMERA_CARGO || e.mData == DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE)
         {
            if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_CAMERA_BACKUP) || Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_CAMERA_CARGO))
            {
               Framework.popupManager.show(DynamicPopupNames.CAMERAS,Screens.POPUP_CAMERAS,{"type":PopupType.CAMERA});
            }
            else if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_CAMERA_FRONTSIDE))
            {
               if(Framework.popupManager.active == DynamicPopupNames.CONTROLS)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
               }
               Framework.popupManager.show(DynamicPopupNames.CAMERAS,Screens.POPUP_CAMERAS,{"type":PopupType.DTV_CAMERA});
               Framework.structure.goto(Screens.SCREEN_CAMERA);
            }
            else
            {
               Framework.popupManager.dequeue(DynamicPopupNames.CAMERAS);
               if(Framework.structure.currentBranch == Screens.SCREEN_CAMERA)
               {
                  Framework.structure.back();
               }
               Framework.structure.removeFromStack(Screens.SCREEN_CAMERA);
            }
         }
         this.checkLayering();
      }
      
      private function onLayerVisibility(e:DisplayManagerEvent) : void
      {
         this.checkLayering();
      }
      
      private function onStatusbarTimer(e:TimerEvent) : void
      {
         this.mStatusbarTimeout.reset();
         this.checkLayering();
      }
      
      private function checkLayering() : void
      {
         if(Framework.popupManager.currentBranch == Screens.GLOBAL_DISCLAIMER || Framework.popupManager.currentBranch == Screens.GLOBAL_ECALL_ERROR || Framework.popupManager.currentBranch == Screens.GLOBAL_FULLSCREEN || Framework.popupManager.currentBranch == Screens.POPUP_HYBRID_ELECTRIC_PAGES_CHARGE_NOW)
         {
            Framework.screens.show(Layers.STATUS);
            Framework.screens.show(Layers.BOTTOM);
            Framework.screens.hide(Layers.PROMPT);
            Framework.screens.hide(Layers.TASKBAR);
            Framework.screens.show(Layers.MIDDLE);
         }
         else if(Framework.popupManager.currentBranch == Screens.POPUP_CAMERAS || Framework.mapping.getAddress(Framework.popupManager.currentBranch) == Screens.POPUP_INCOMINGCALL && Boolean(Framework.popupManager.check(DynamicPopupNames.CAMERAS)))
         {
            Framework.screens.hide(Layers.STATUS);
            Framework.screens.hide(Layers.BOTTOM);
            Framework.screens.hide(Layers.PROMPT);
            Framework.screens.hide(Layers.TASKBAR);
            Framework.screens.hide(Layers.MIDDLE);
         }
         else if(Framework.popupManager.currentBranch == Screens.DRIVEMODE_WKCUSTOM_POPUP || Framework.popupManager.currentBranch == Screens.DRIVEMODE_IGNITION)
         {
            Framework.screens.show(Layers.STATUS);
            Framework.screens.show(Layers.BOTTOM);
            Framework.screens.hide(Layers.PROMPT);
            Framework.screens.show(Layers.TASKBAR);
            Framework.screens.hide(Layers.MIDDLE);
         }
         else
         {
            switch(Framework.structure.currentBranch)
            {
               case Screens.DISPLAY_OFF:
                  Framework.screens.hide(Layers.STATUS);
                  Framework.screens.show(Layers.BOTTOM);
                  Framework.screens.hide(Layers.PROMPT);
                  Framework.screens.hide(Layers.TASKBAR);
                  Framework.screens.show(Layers.MIDDLE);
                  break;
               case Screens.MAIN_DMB:
                  if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_DMBSPLIT))
                  {
                     Framework.screens.show(Layers.STATUS);
                     Framework.screens.show(Layers.BOTTOM);
                     Framework.screens.show(Layers.PROMPT);
                     Framework.screens.show(Layers.TASKBAR);
                     Framework.screens.show(Layers.MIDDLE);
                  }
                  else if(Peripheral.displayManager.getLayerVisibility(DisplayManagerLayers.LAYER_DMBFULL))
                  {
                     Framework.screens.hide(Layers.STATUS);
                     Framework.screens.show(Layers.BOTTOM);
                     Framework.screens.show(Layers.PROMPT);
                     Framework.screens.hide(Layers.TASKBAR);
                     Framework.screens.show(Layers.MIDDLE);
                  }
                  break;
               case Screens.REAR_MEDIA_VES:
               case Screens.REAR_MEDIA_VRM:
               case Screens.DTV_FULL_SCREEN:
                  if(this.mStatusbarTimeout.running)
                  {
                     Framework.screens.show(Layers.STATUS);
                  }
                  else
                  {
                     Framework.screens.hide(Layers.STATUS);
                  }
                  Framework.screens.hide(Layers.BOTTOM);
                  Framework.screens.hide(Layers.PROMPT);
                  Framework.screens.hide(Layers.TASKBAR);
                  Framework.screens.show(Layers.MIDDLE);
                  break;
               case Screens.DEVICE_PROJECTION:
                  Framework.screens.show(Layers.STATUS);
                  Framework.screens.hide(Layers.BOTTOM);
                  Framework.screens.hide(Layers.PROMPT);
                  Framework.screens.hide(Layers.TASKBAR);
                  Framework.screens.show(Layers.MIDDLE);
                  break;
               default:
                  Framework.screens.show(Layers.STATUS);
                  Framework.screens.show(Layers.BOTTOM);
                  Framework.screens.show(Layers.PROMPT);
                  Framework.screens.show(Layers.TASKBAR);
                  Framework.screens.show(Layers.MIDDLE);
            }
         }
      }
   }
}

