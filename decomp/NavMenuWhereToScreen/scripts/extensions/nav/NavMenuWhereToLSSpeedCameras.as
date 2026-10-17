package extensions.nav
{
   import com.harman.navigation.Controller.LiveServices.AuthenticationTypes;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.OpenNavUtilities;
   import com.nfuzion.framework.global.Framework;
   import locale.T;
   import peripheral.Peripheral;
   
   public class NavMenuWhereToLSSpeedCameras implements INavMenuWhereToExtension
   {
      
      private var mParent:*;
      
      private var mIsDangerZoneCountry:Boolean = false;
      
      public function NavMenuWhereToLSSpeedCameras(parent:*)
      {
         super();
         this.mParent = parent;
         this.setParentTitle();
         this.update();
      }
      
      public function update() : void
      {
         this.mParent.clearList();
         if(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_SPEEDCAM_FEEDBACK))
         {
            if(this.mIsDangerZoneCountry)
            {
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_REPORT_DANGER_ZONE_ML),
                  "id":NavMenuWhereToConstants.LS_SPEED_CAMERA_REPORT
               });
            }
            else
            {
               this.mParent.pushItem({
                  "label":Peripheral.localeEngine.getText(T.STRB_REPORT_SPEED_CAMERA_ML),
                  "id":NavMenuWhereToConstants.LS_SPEED_CAMERA_REPORT
               });
            }
         }
         if(Peripheral.navigation.navLiveServices.ttlsServiceAvailable(AuthenticationTypes.SUBS_TYPE_SPEEDCAM_INFO))
         {
            this.mParent.pushItem({
               "label":Peripheral.localeEngine.getText(T.STRB_ALERT_SETTINGS_1),
               "id":NavMenuWhereToConstants.LS_SPEED_CAMERA_SET_ALERT
            });
         }
         this.mParent.setWindowIndex(Peripheral.navigation.navVServices.screenHelper.getNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS));
         this.mParent.revalidate();
      }
      
      private function getCountry(str:String) : String
      {
         return OpenNavUtilities.getValueOfType(str,OpenNavUtilities.c_EIS_CAB);
      }
      
      private function onPositionInfo(e:NavigationEvent) : void
      {
         var oldDangerZone:Boolean = this.mIsDangerZoneCountry;
         var country:String = this.getCountry(Peripheral.navigation.navigation.posPositionInformationString);
         this.mIsDangerZoneCountry = VServiceGlobalSettings.isSupportedDangerZoneCountry(country);
         if(this.mIsDangerZoneCountry != oldDangerZone)
         {
            this.setParentTitle();
            this.update();
         }
      }
      
      private function setParentTitle() : void
      {
         if(this.mIsDangerZoneCountry)
         {
            this.mParent.title = T.STRB_DANGER_ZONE;
         }
         else
         {
            this.mParent.title = T.STRB_SPEED_CAMERAS;
         }
      }
      
      public function addListeners() : void
      {
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo,false,0,true);
         Peripheral.navigation.navigation.posGetPositionInformation();
      }
      
      public function removeListeners() : void
      {
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionInfo);
      }
      
      public function onBack() : void
      {
         Peripheral.navigation.navDomainControl.onBackButtonPress();
      }
      
      public function onCancel() : void
      {
         Peripheral.navigation.navDomainControl.onCancelButtonPress();
      }
      
      public function onBtn(id:int) : void
      {
         Framework.Trace("NavMenuWhereToLSSpeedCameras.onBtn( " + id + " )");
         Peripheral.navigation.navVServices.screenHelper.setNavWhereToExtensionListPosition(NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAMERAS,this.mParent.getWindowIndex());
         switch(id)
         {
            case NavMenuWhereToConstants.LS_SPEED_CAMERA_REPORT:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_REPORT_SPEED_CAM_LIST);
               break;
            case NavMenuWhereToConstants.LS_SPEED_CAMERA_SET_ALERT:
               Peripheral.navigation.navDomainControl.switchToMenu(NavMenus.MENU_LIVE_SERVICES_LS_SPEED_CAM_ALERT_SETTINGS);
               break;
            default:
               Framework.Trace("NavMenuWhereToLSSpeedCameras.onBtn( " + id + " ) has no function yet!");
         }
      }
   }
}

