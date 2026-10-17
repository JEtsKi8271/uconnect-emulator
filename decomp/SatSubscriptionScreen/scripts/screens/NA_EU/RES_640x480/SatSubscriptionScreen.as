package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VersionInfoEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.BluetoothDevice;
   import com.nfuzion.moduleLinkAPI.DataServicesSubscriptionStatus;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.VehConfigEvent;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class SatSubscriptionScreen extends GenericScreen
   {
      
      private static var mPhoneSubscribeSiriusXM:String = "1-866-635-2349";
      
      private static var mDisplaySubscribeSiriusXM:String = "(866) 635-2349";
      
      public function SatSubscriptionScreen()
      {
         mView = new C_SatSubscriptionView();
         view = mView as MovieClip;
         super();
      }
      
      override protected function initScreen() : void
      {
         clearBreadcrumbs();
         if(screenVars.fromTravelLink)
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_TRAVEL_LINK_BREADCRUMB,Breadcrumb.FUNCTION,close));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_BREADCRUMB,Breadcrumb.PAGE,Screens.SETTINGS_SCREEN));
            pushBreadcrumb(new Breadcrumb(T.STRB_SETTINGS_SUBSCRIPTION,Breadcrumb.PAGE,Screens.SETTINGS_SIRIUS));
         }
         pushBreadcrumb(new Breadcrumb(T.STRB_SIRIUSXM_SUBSCRIPTION_BREADCRUMB,Breadcrumb.INERT));
         Peripheral.satelliteRadio.requestESN();
         Peripheral.satelliteRadio.requestSubscribed();
         mView.SiriusBackseatIDDesc_translate.visible = false;
         mView.SiriusBackseatID_translate.visible = false;
         this.showHideTravelLink();
         mView.sub_BackseatTV_translate.visible = false;
         mView.SiriusBackseatTvDescription_translate.visible = false;
         if(0 == Peripheral.satelliteRadio.totalInterest(SatelliteRadioEvent.ESN))
         {
            Peripheral.satelliteRadio.addInterest(SatelliteRadioEvent.ESN);
         }
         if(0 == Peripheral.satelliteRadio.totalInterest(SatelliteRadioEvent.SUBSCRIBED))
         {
            Peripheral.satelliteRadio.addInterest(SatelliteRadioEvent.SUBSCRIBED);
         }
         if(0 == Peripheral.satelliteRadio.totalInterest(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS))
         {
            Peripheral.satelliteRadio.addInterest(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS);
         }
         this.setButtonActions();
         this.onIdEvent(null);
         this.onSubscriptionEvent(null);
         if(null != Peripheral.bluetooth.currentHFPDevice)
         {
            mView.btnCall_button.setEnabled(true);
            mView.btnCall_button.setInteractive(true);
         }
         else
         {
            mView.btnCall_button.setEnabled(false);
            mView.btnCall_button.setInteractive(true);
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.btnCall_button]));
      }
      
      override protected function initView() : void
      {
         super.initView();
         Framework.autoAssigner.assignChildren(mView);
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         breadcrumbTextField = mView.titleBar_group.displayTitle.labelValue;
         super.addListeners();
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.SUBSCRIBED,this.onSubscriptionEvent);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS,this.onSubscriptionEvent);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ESN,this.onIdEvent);
         attachListener(Peripheral.vehConfig,VehConfigEvent.AVAILABLE,this.onVehicleConfigAvailable);
         attachListener(Peripheral.versionInfo,VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Peripheral.satelliteRadio.removeEventListener(SatelliteRadioEvent.SUBSCRIBED,this.onSubscriptionEvent);
         Peripheral.satelliteRadio.removeEventListener(SatelliteRadioEvent.ESN,this.onIdEvent);
         Peripheral.satelliteRadio.removeEventListener(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS,this.onSubscriptionEvent);
         Peripheral.vehConfig.removeEventListener(VehConfigEvent.AVAILABLE,this.onVehicleConfigAvailable);
         detachListener(Peripheral.versionInfo,VersionInfoEvent.PRODUCT_VARIANT_ID,this.onProductIDUpdate);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.btnCall_button.value_label,T.STRB_CALL_SUBSCRIPTION);
         t(mView.SubscriptionStatusTitle_translate,T.STRB_SIRIUS_SUBSCRIPTION_STATUS);
         t(mView.CallSiriusNumber_translate,[T.STRB_CALL_SERVICE,mDisplaySubscribeSiriusXM]);
         t(mView.SiriusIDDesc_translate,T.STRB_SIRIUSXM_ID);
         t(mView.SiriusBackseatIDDesc_translate,T.STRB_SIRIUSXM_BACKSEAT_TV_ID);
         t(mView.SiriusServicesDescription_translate,T.STRB_SIRIUSXM_SATELLITE_RADIO);
         t(mView.SiriusRealTimeTrafficDescription_translate,T.STRB_SIRIUSXM_REALTIME_TRAFFIC);
         t(mView.SiriusTravelLinkDescription_translate,T.STRB_SIRIUSXM_TRAVELLINK);
         t(mView.SiriusBackseatTvDescription_translate,T.STRB_SIRIUSXM_BACKSEAT_TV);
      }
      
      private function setButtonActions() : void
      {
         mView.titleBar_group.btnBack_button.addEventListener(MouseEvent.CLICK,this.goBack);
         mView.titleBar_group.btnClose_button.addEventListener(MouseEvent.CLICK,close);
         mView.btnCall_button.addEventListener(MouseEvent.CLICK,this.callEvent);
      }
      
      private function removeButtonActions() : void
      {
         mView.titleBar_group.btnBack_button.removeEventListener(MouseEvent.CLICK,this.goBack);
         mView.titleBar_group.btnClose_button.removeEventListener(MouseEvent.CLICK,close);
         mView.btnCall_button.removeEventListener(MouseEvent.CLICK,this.callEvent);
      }
      
      private function showHideTravelLink() : void
      {
         var isAvailableTL:Boolean = Boolean(Peripheral.travelLink.isAvailable);
         mView.sub_RealTimeTraffic_translate.visible = isAvailableTL;
         mView.SiriusRealTimeTrafficDescription_translate.visible = isAvailableTL;
         mView.sub_TravelLink_translate.visible = isAvailableTL;
         mView.SiriusTravelLinkDescription_translate.visible = isAvailableTL;
      }
      
      private function goBack(e:Event = null) : void
      {
         if(screenVars.fromTravelLink)
         {
            Framework.structure.exit();
         }
         else
         {
            back();
         }
      }
      
      private function callEvent(e:Event) : void
      {
         if(this.phoneAvailable)
         {
            this.dial(mPhoneSubscribeSiriusXM);
         }
         else if(!Peripheral.vehicleStatus.speedLockOut)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "status":"no phone paired",
               "timeout":30000
            });
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
      }
      
      private function onIdEvent(event:SatelliteRadioEvent) : void
      {
         mView.SiriusID_translate.text = Peripheral.satelliteRadio.SatESN;
      }
      
      private function onSubscriptionEvent(event:SatelliteRadioEvent) : void
      {
         this.showSubscriptionStatus(mView.sub_SatRadio_translate,Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_AUDIO));
         this.showSubscriptionStatus(mView.sub_TravelLink_translate,Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_TRAVELLINK));
         this.showSubscriptionStatus(mView.sub_RealTimeTraffic_translate,Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_TRAFFIC));
      }
      
      private function onVehicleConfigAvailable(e:VehConfigEvent) : void
      {
         this.showHideTravelLink();
      }
      
      private function onProductIDUpdate(e:VersionInfoEvent) : void
      {
         this.showHideTravelLink();
      }
      
      private function showSubscriptionStatus(target:TextField, subStatus:int) : void
      {
         var subStatusStringId:uint = 0;
         switch(subStatus)
         {
            case DataServicesSubscriptionStatus.subscribedYes:
               subStatusStringId = uint(T.STRB_SUBSCRIBED);
               break;
            case DataServicesSubscriptionStatus.subscribedNo:
               subStatusStringId = uint(T.STRB_NOT_SUBSCRIBED);
               break;
            case DataServicesSubscriptionStatus.subscribedUnknown:
            default:
               subStatusStringId = uint(T.STRB_PLEASE_WAIT);
         }
         t(target,subStatusStringId);
      }
      
      protected function get phoneAvailable() : Boolean
      {
         var phoneList:Vector.<BluetoothDevice> = Peripheral.bluetooth.getPairedDeviceListWithService("HFP");
         var hasPhone:Boolean = false;
         var phoneConnected:Boolean = false;
         for(var i:uint = 0; i < phoneList.length; i++)
         {
            if(phoneList[i].HfpAvailable == true)
            {
               hasPhone = true;
               break;
            }
         }
         if(null != Peripheral.bluetooth.currentHFPDevice)
         {
            phoneConnected = true;
         }
         return hasPhone && phoneConnected;
      }
      
      protected function dial(number:String) : void
      {
         if(this.phoneAvailable)
         {
            Peripheral.bluetoothPhone.dial(number);
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
   }
}

