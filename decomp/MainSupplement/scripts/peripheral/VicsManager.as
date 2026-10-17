package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.BeaconDSRCHMIEvent;
   import com.harman.moduleLinkAPI.BeaconDSRCID;
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerLayers;
   import com.harman.moduleLinkAPI.EtcID;
   import com.harman.moduleLinkAPI.VicsEtcHMIEvent;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   
   public class VicsManager
   {
      
      private var mPriority:int = 2;
      
      private var mVICSScreenType:String = "";
      
      public function VicsManager()
      {
         super();
         Peripheral.vicsEtcHMI.addEventListener(VicsEtcHMIEvent.ETC_STATE,this.onETCStatus,false,0,true);
         Peripheral.beaconDSRC.addEventListener(BeaconDSRCHMIEvent.EVENT_START_INTERRUPT,this.onInformationVICSInterrupt,false,0,true);
         Peripheral.beaconDSRC.addEventListener(BeaconDSRCHMIEvent.DRAW_INTER_TOP_PAGE,this.onResponseDrawInterTopPage,false,0,true);
      }
      
      private function onInformationVICSInterrupt(e:BeaconDSRCHMIEvent) : void
      {
         this.mPriority = e.mData.priority;
         switch(this.mPriority)
         {
            case BeaconDSRCID.INTERPRIO_GENERAL:
               if(Framework.structure.currentBranch == "mainbackground/menu/navmapmainscreen" && !Peripheral.navigation.navMapControl.junctionViewActive)
               {
                  Peripheral.beaconDSRC.requestDrawInterTopPage();
               }
               else
               {
                  Peripheral.beaconDSRC.requestFinishInterupt();
               }
               break;
            case BeaconDSRCID.INTERPRIO_HIGH:
               if(Framework.structure.currentBranch == "mainbackground/menu/navmapmainscreen" && !Peripheral.navigation.navMapControl.junctionViewActive)
               {
                  Peripheral.beaconDSRC.requestDrawInterTopPage();
               }
               else
               {
                  Peripheral.beaconDSRC.requestFinishInterupt();
               }
               break;
            case BeaconDSRCID.INTERPRIO_HIGHEST:
               if(-1 != Framework.structure.currentBranch.search("nav"))
               {
                  Peripheral.beaconDSRC.requestDrawInterTopPage();
               }
               else
               {
                  Peripheral.beaconDSRC.requestFinishInterupt();
               }
               break;
            default:
               Peripheral.beaconDSRC.requestFinishInterupt();
         }
      }
      
      public function get priority() : uint
      {
         return this.mPriority;
      }
      
      private function onResponseDrawInterTopPage(e:BeaconDSRCHMIEvent) : void
      {
         if(e.mData.requestDrawInterTopPage.drawn)
         {
            switch(this.mPriority)
            {
               case BeaconDSRCID.INTERPRIO_GENERAL:
                  if(Framework.structure.currentBranch == "mainbackground/menu/navmapmainscreen" && !Peripheral.navigation.navMapControl.junctionViewActive && -1 == Framework.popupManager.active)
                  {
                     this.displayChange();
                  }
                  else
                  {
                     Peripheral.beaconDSRC.requestFinishInterupt();
                  }
                  break;
               case BeaconDSRCID.INTERPRIO_HIGH:
                  if(Framework.structure.currentBranch == "mainbackground/menu/navmapmainscreen" && !Peripheral.navigation.navMapControl.junctionViewActive && -1 == Framework.popupManager.active)
                  {
                     this.displayChange();
                  }
                  else
                  {
                     Peripheral.beaconDSRC.requestFinishInterupt();
                  }
                  break;
               case BeaconDSRCID.INTERPRIO_HIGHEST:
                  if(-1 != Framework.structure.currentBranch.search("nav"))
                  {
                     if(Framework.structure.currentBranch != "mainbackground/menu/navmapmainscreen")
                     {
                        Framework.structure.goto("mainbackground/menu/navmapmainscreen");
                     }
                     this.displayChange();
                  }
                  else
                  {
                     Peripheral.beaconDSRC.requestFinishInterupt();
                  }
                  break;
               default:
                  Peripheral.beaconDSRC.requestFinishInterupt();
            }
         }
      }
      
      private function displayChange() : void
      {
         this.mVICSScreenType = "Interrupt";
         Peripheral.displayManager.addEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onDisplayChanged,false,0,true);
         Peripheral.displayManager.requestDisplay(DisplayManagerLayers.LAYER_VICS,true);
      }
      
      private function onDisplayChanged(e:DisplayManagerEvent) : void
      {
         Peripheral.displayManager.removeEventListener(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,this.onDisplayChanged);
         if(this.mVICSScreenType == "Interrupt")
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_VICS_INTSCREEN);
         }
      }
      
      public function set VicsMenuActive(type:String) : void
      {
         this.mVICSScreenType = type;
      }
      
      public function get VicsMenuActive() : String
      {
         return this.mVICSScreenType;
      }
      
      private function onETCStatus(evt:VicsEtcHMIEvent) : void
      {
         var Status:uint = Peripheral.vicsEtcHMI.EtcState.STATUS;
         var RemainingDays:uint = Peripheral.vicsEtcHMI.CardExpirationDate.REMAINING_DAYS;
         var ExpirationDays:uint = Peripheral.vicsEtcHMI.CardExpirationDate.EXPIRATION_YEAR + Peripheral.vicsEtcHMI.CardExpirationDate.EXPIRATION_MONTH + Peripheral.vicsEtcHMI.CardExpirationDate.EXPIRATION_DAY;
         if(Peripheral.vicsEtcHMI.WarningMessage == true && Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_NAVIGATION)
         {
            if(Status == EtcID.NO_CARD_INSERTED)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"NO_CARD_INSERTED"
               });
            }
            else if(Status == EtcID.CARD_AVAILABLE)
            {
               if(RemainingDays > 10)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
                  Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"CARD_AVAILABLE"
                  });
               }
               else if(ExpirationDays != 0 && RemainingDays == 0)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
                  Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"CARD_HAS_EXPIRED"
                  });
               }
               else if(RemainingDays >= 1 && RemainingDays <= 10)
               {
                  Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
                  Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"CARD_WILL_EXPIRE"
                  });
               }
            }
            else if(Status == EtcID.DEVICE_ERROR)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"DEVICE_ERROR"
               });
            }
            else if(Status == EtcID.CARD_INSERT_ERROR)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"CARD_INSERT_ERROR"
               });
            }
            else if(Status == EtcID.CARD_READWRITE_ERROR)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"CARD_READWRITE_ERROR"
               });
            }
            else if(Status == EtcID.COMMUNICATION_ERROR)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"COMMUNICATION_ERROR"
               });
            }
            else if(Status == EtcID.DEVICE_UNREGISTERED)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"DEVICE_UNREGISTERED"
               });
            }
            else if(Status == EtcID.DEVICE_REGISTRATION_INVALID)
            {
               Framework.popupManager.dequeue(DynamicPopupNames.VICS_ETC_DSRC_ERROR);
               Framework.popupManager.show(DynamicPopupNames.VICS_ETC_DSRC_ERROR,"vicsetcdsrcerrorpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"DEVICE_REGISTRATION_INVALID"
               });
            }
         }
      }
   }
}

