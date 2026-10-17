package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import events.HardControlEvent;
   import flash.events.EventDispatcher;
   
   public class BrowseManager extends EventDispatcher
   {
      
      public function BrowseManager()
      {
         super();
         Peripheral.hardControls.addEventListener(HardControlEvent.BROWSE,this.onBrowse);
      }
      
      private function onBrowse(e:HardControlEvent) : void
      {
         var _domain:String = Framework.mapping.getDomain(Framework.structure.currentBranch);
         switch(_domain)
         {
            case Screens.DOMAIN_ANTITHEFT:
            case Screens.DOMAIN_ECALL:
            case Screens.DOMAIN_DRIVEMODES:
            case Screens.DOMAIN_NONE:
            case Screens.DOMAIN_APPS:
            case Screens.DOMAIN_TRAVELLINK:
            case Screens.DOMAIN_CONTROLS:
            case Screens.DOMAIN_CLIMATE:
               break;
            case Screens.DOMAIN_SETTINGS:
               if(Framework.structure.currentBranch == Screens.SETTINGS_AUDIO)
               {
                  if(Peripheral.audioManager.isSourceRadio(Peripheral.audioManager.source))
                  {
                     this.onRadioBrowse();
                  }
                  else if(Peripheral.audioManager.isSourceMedia(Peripheral.audioManager.source))
                  {
                     this.onMediaBrowse();
                  }
               }
               break;
            case Screens.DOMAIN_TUNER:
               this.onRadioBrowse();
               break;
            case Screens.DOMAIN_USB:
            case Screens.DOMAIN_MEDIA:
               this.onMediaBrowse();
               break;
            case Screens.DOMAIN_PHONE:
               this.onPhoneBrowse();
               break;
            case Screens.DOMAIN_NAVIGATION:
               this.onNavBrowse();
         }
      }
      
      private function onNavBrowse() : void
      {
         if(Peripheral.navigation.navDomainControl.navIsOperable)
         {
            Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_FAVORITE_DESTINATIONS_LIST);
         }
         else
         {
            this.onBrowseError("Please wait for navigation to be activated.");
         }
      }
      
      private function onPhoneBrowse() : void
      {
         if(Peripheral.bluetooth.getPairedDeviceListWithService("HFP").length == 0)
         {
            this.onBrowseError("Please connect a phone.");
         }
         else if(Peripheral.phonebook.isPhoneBookReady())
         {
            Framework.structure.goto(Screens.PHONE_PHONEBOOK);
         }
         else
         {
            this.onBrowseError("Please wait while the phonebook is downloaded.");
         }
      }
      
      private function onRadioBrowse() : void
      {
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_AHA:
               Framework.structure.goto(Screens.AHA_BROWSE);
               break;
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_FM:
            case Peripheral.audioManager.SOURCE_MW:
            case Peripheral.audioManager.SOURCE_LW:
               Framework.structure.goto(Screens.BROWSE_FM);
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               Framework.structure.goto(Screens.BROWSE_DAB);
               break;
            case Peripheral.audioManager.SOURCE_DMB:
               Framework.structure.goto(Screens.BROWSE_DMB);
               break;
            case Peripheral.audioManager.SOURCE_SAT:
               Framework.structure.goto(Screens.BROWSE_SAT);
         }
      }
      
      private function onMediaBrowse() : void
      {
         if(!(Peripheral.mediaPlayer.readyToBrowse && Peripheral.mediaPlayer.readyToBrowseSrcMsid == Peripheral.audioManager.getMSIdForSource(Peripheral.audioManager.source)))
         {
            this.onBrowseError("Browse is not currently available.");
         }
         else if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            Framework.structure.goto(Screens.BROWSE_DISC);
         }
         else
         {
            Peripheral.mediaBrowser.clearAvailableViews();
            Framework.structure.goto(Screens.BROWSE_MEDIA);
         }
      }
      
      private function onBrowseError(_errorMessage:String) : void
      {
         Framework.popupManager.show(DynamicPopupNames.MASERATI_BROWSE_ERROR,Screens.POPUP_ERROR,{
            "timeout":Style.DEFAULT_POPUP_TIMEOUT,
            "type":PopupType.SECONDARY,
            "title":"",
            "body":_errorMessage
         });
      }
   }
}

