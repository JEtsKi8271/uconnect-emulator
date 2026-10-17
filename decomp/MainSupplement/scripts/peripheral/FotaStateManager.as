package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.OtaEvent;
   import com.harman.moduleLinkAPI.PersistencyKeys;
   import com.harman.moduleLinkAPI.Time;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import core.utils.LoadXML;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import locale.T;
   
   public class FotaStateManager extends EventDispatcher
   {
      
      private var mHandleAntiTheft:Boolean = false;
      
      private var m_scheduledTime:Time = new Time();
      
      private var mLoadXML:LoadXML;
      
      private var m_rnXml:String = "";
      
      public function FotaStateManager()
      {
         super();
         Peripheral.otaService.addEventListener(OtaEvent.OTA_INSTALL_CONFIRM,this.OnOtaInstallConfirm,false,0,true);
         Peripheral.otaService.addEventListener(OtaEvent.OTA_INSTALL_DONE,this.OnOtaInstallDone,false,0,true);
         Peripheral.otaService.addEventListener(OtaEvent.OTA_DISMISS_POPUP,this.OnOtaPopupDismiss,false,0,true);
      }
      
      public function OnOtaPopupDismiss(e:OtaEvent) : void
      {
         this.otaPopupDismiss();
      }
      
      public function OnOtaInstallDone(e:OtaEvent) : void
      {
         if(Peripheral.otaService.whatsNew.search("http") != -1)
         {
            this.mLoadXML = new LoadXML(Peripheral.otaService.whatsNew);
            this.mLoadXML.addEventListener(Event.COMPLETE,this.onXMLLoaded);
         }
         if(Peripheral.otaService.installSuccess)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
            Framework.popupManager.show(DynamicPopupNames.FOTA_WHATS_NEW,Screens.WHATS_NEWDETAILS);
         }
         else
         {
            Framework.popupManager.show(-1,"popup1item",{
               "timeout":0,
               "type":PopupType.PRIMARY,
               "title":T.STRB_SOFTWARE_UPDATE,
               "message":[Peripheral.localeEngine.getText(T.STRB_FOTA_UPDATE_FAILED) + "\n\n" + Peripheral.localeEngine.getText(T.STRB_FOTA_CONTACT_DEALER)],
               "caption1":T.STRB_OK,
               "showClose":true
            });
         }
      }
      
      public function OnOtaInstallConfirm(e:OtaEvent) : void
      {
         this.otaInstallConfirm();
      }
      
      public function DismissPopup(popupId:int) : void
      {
         this.mHandleAntiTheft = false;
         Framework.popupManager.dequeue(popupId);
      }
      
      public function ScheduleUpdateTime() : void
      {
         Peripheral.otaService.scheduledUpdateTime(this.m_scheduledTime);
      }
      
      public function set scheduledTime(stime:Time) : void
      {
         this.m_scheduledTime = stime;
      }
      
      public function confirmScheduleUpdateTime(confirmationDetails:Object) : void
      {
         Framework.popupManager.show(DynamicPopupNames.FOTA_SCHEDULE_UPDATE_CONFIRM,Screens.SCHEDULE_UPDATE_CONFIRMATION,{
            "timeout":0,
            "type":PopupType.ANTITHEFT,
            "title":T.STRB_FOTA_WITHIN_24HRS,
            "message":[T.STRB_FOTA_SCHEDULE_UPDATE_CONFIRMATION,confirmationDetails.Hrs,confirmationDetails.Mins,confirmationDetails.AmPm],
            "caption1":T.STRB_OK,
            "showClose":true
         });
      }
      
      public function otaPopupDismiss() : void
      {
         if(Boolean(Framework.popupManager.check(DynamicPopupNames.FOTA_FORCED_UPDATE_AVAILABLE)) && !Peripheral.otaService.installType)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FOTA_FORCED_UPDATE_AVAILABLE);
         }
         if(Boolean(Framework.popupManager.check(DynamicPopupNames.FOTA_SCHEDULE_UPDATE)) && !Peripheral.otaService.installType)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FOTA_SCHEDULE_UPDATE);
         }
         if(Boolean(Framework.popupManager.check(DynamicPopupNames.FOTA_SCHEDULE_UPDATE_CONFIRM)) && !Peripheral.otaService.installType)
         {
            Framework.popupManager.dequeue(DynamicPopupNames.FOTA_SCHEDULE_UPDATE_CONFIRM);
         }
      }
      
      public function otaInstallConfirm(obj:Object = null) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.CONTROLS);
         this.mHandleAntiTheft = true;
         if(!obj)
         {
            obj = new Object();
         }
         obj["type"] = PopupType.ANTITHEFT;
         Framework.popupManager.show(DynamicPopupNames.FOTA_FORCED_UPDATE_AVAILABLE,Screens.FORCE_UPDATE_AVAIL,obj);
      }
      
      private function onXMLLoaded(evt:Event) : void
      {
         this.m_rnXml = evt.currentTarget.xml.toString();
         this.mLoadXML.removeEventListener(Event.COMPLETE,this.onXMLLoaded);
         this.mLoadXML.cleanup();
         this.mLoadXML = null;
         var rnStartTag:String = "<RN>";
         var rnEndTag:String = "</RN>";
         this.m_rnXml = this.m_rnXml.substr(this.m_rnXml.search(rnStartTag) + rnStartTag.length,this.m_rnXml.search(rnEndTag) - this.m_rnXml.search(rnStartTag) - rnStartTag.length);
         Peripheral.persistency.write(PersistencyKeys.KEY_FOTA_WHATS_NEW_MESSAGE,{"value":this.m_rnXml});
      }
      
      public function get relaseNoteXml() : String
      {
         return this.m_rnXml;
      }
   }
}

