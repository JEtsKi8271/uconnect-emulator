package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import com.harman.moduleLink.SoftwareUpdateDatabase;
   import com.harman.moduleLinkAPI.SoftwareUpdateEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import flash.events.EventDispatcher;
   
   public class SoftwareUpdateManager extends EventDispatcher
   {
      
      private const SW_UPDATE_STATE_ERROR:String = "error";
      
      private const SW_UPDATE_STATE_READY:String = "ready";
      
      private const SW_UPDATE_STATE_WAIT:String = "waiting";
      
      private const SW_UPDATE_STATE_EJECT:String = "ejected";
      
      private const SW_UPDATE_STATE_DETECTED:String = "detected";
      
      private const SW_UPDATE_STATE_NOT_READY:String = "not ready";
      
      private const SW_UPDATE_STATE_CANCELLED:String = "cancelled";
      
      public function SoftwareUpdateManager()
      {
         super();
         Peripheral.softwareUpdate.addEventListener(SoftwareUpdateEvent.SW_UPDATE_STATUS,this.onSoftwareUpdate,false,0,true);
         Peripheral.softwareUpdate.addEventListener(SoftwareUpdateEvent.NAV_DB_UPDATE_STATE,this.onSoftwareUpdateDatabase,false,0,true);
         Peripheral.softwareUpdate.addEventListener(SoftwareUpdateEvent.NAV_DB_ACTIVATION_CODE_ACCEPT,this.onActivationCodeAccept,false,0,true);
         Peripheral.softwareUpdate.getStatus();
      }
      
      private function onSoftwareUpdate(e:SoftwareUpdateEvent) : void
      {
         var updateState:String = Peripheral.softwareUpdate.swUpdateState;
         if(updateState != null)
         {
            if(this.SW_UPDATE_STATE_DETECTED == updateState)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.SOFTWARE_UPDATE);
               Ancillary.definedDynamicPopups.popup(DynamicPopupNames.TWOITEM_SW_UPDATE_USB_DETECTED);
            }
            else if(this.SW_UPDATE_STATE_WAIT == updateState || this.SW_UPDATE_STATE_EJECT == updateState || this.SW_UPDATE_STATE_CANCELLED == updateState || this.SW_UPDATE_STATE_NOT_READY == updateState)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.SOFTWARE_UPDATE);
            }
            else if(this.SW_UPDATE_STATE_READY == updateState || this.SW_UPDATE_STATE_ERROR == updateState)
            {
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE,"softwareupdate",{"type":PopupType.PRIMARY});
            }
         }
      }
      
      private function onSoftwareUpdateDatabase(e:SoftwareUpdateEvent) : void
      {
         switch(Peripheral.softwareUpdate.updateDBState["state"])
         {
            case SoftwareUpdateDatabase.c_IDENTIFYING:
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE,"softwaredatabaseupdate",{"type":PopupType.PRIMARY});
               break;
            case SoftwareUpdateDatabase.c_UPDATE_MEDIA_NOT_AVAILABLE:
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE,"softwaredatabaseupdate",{"type":PopupType.PRIMARY});
               break;
            case SoftwareUpdateDatabase.c_UPDATE_MEDIA_AVAILABLE:
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE,"softwaredatabaseupdate",{"type":PopupType.PRIMARY});
               break;
            case SoftwareUpdateDatabase.c_UPDATE_DONE:
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE,"softwaredatabaseupdate",{"type":PopupType.PRIMARY});
               break;
            case SoftwareUpdateDatabase.c_NO_MEDIA:
            case SoftwareUpdateDatabase.c_UPDATING:
         }
      }
      
      private function onActivationCodeAccept(e:SoftwareUpdateEvent) : void
      {
         switch(Peripheral.softwareUpdate.updateDBActivationCodeAcceptanceState)
         {
            case SoftwareUpdateDatabase.c_ACTIVATION_REQUESTING:
               Framework.popupManager.show(DynamicPopupNames.PLEASE_WAIT,"pleasewaitpopup");
               break;
            case SoftwareUpdateDatabase.c_ACTIVATION_ACCEPTED:
            case SoftwareUpdateDatabase.c_ACTIVATION_DECLINED:
               Framework.popupManager.dequeue(DynamicPopupNames.PLEASE_WAIT);
               Framework.popupManager.show(DynamicPopupNames.SOFTWARE_UPDATE_NAV_DATABASE,"softwaredatabaseupdate",{"type":PopupType.PRIMARY});
               break;
            case SoftwareUpdateDatabase.c_ACTIVATION_UNKNOWN:
         }
      }
   }
}

