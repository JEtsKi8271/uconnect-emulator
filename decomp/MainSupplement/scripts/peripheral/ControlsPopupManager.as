package peripheral
{
   import ancillary.DynamicPopupNames;
   import com.harman.moduleLinkAPI.CameraEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import events.GlobalEvent;
   import flash.events.EventDispatcher;
   
   public class ControlsPopupManager extends EventDispatcher
   {
      
      private var mVFM:VehicleFeatureManager = new VehicleFeatureManager();
      
      private var modelyear:int = Number(Peripheral.vehConfig.modelYear);
      
      public function ControlsPopupManager()
      {
         super();
         Peripheral.Camera.addEventListener(CameraEvent.CAMERA_UPDATE,this.onCameraUpdate);
      }
      
      public function get hasControls() : Boolean
      {
         return Peripheral.vehConfig.hasHeatedSeat || Peripheral.vehConfig.hasVentedSeat || Peripheral.vehConfig.hasHeatedSteeringWheel || Peripheral.vehConfig.hasECMirror && !Peripheral.vehConfig.hasECMirrorHKPresent || Peripheral.vehConfig.hasCargoCamera || Peripheral.vehConfig.hasEcoAppBtn || Peripheral.vehConfig.hasHeadRest || Peripheral.vehConfig.hasSunShade || Peripheral.vehConfig.hasDisplayOnOffSK || Peripheral.vehConfig.dtvShortTermPresent && Peripheral.vehConfig.vehicleLine != "LX" || Peripheral.vehConfig.hasFrontCamera || Peripheral.vehConfig.hasSideCamera || Peripheral.vehConfig.hasSurroundCamera && Peripheral.vehConfig.hasSVCSoftKey || Peripheral.vehConfig.hasRVCMPresent && (this.modelyear == 16 && Peripheral.vehConfig.isTruckPlatform || this.modelyear >= 17 && Peripheral.vehConfig.hasRVCSoftKey && Peripheral.vehConfig.vehicleLine != "RU");
      }
      
      public function showControlsPopup() : void
      {
         var vars:Object = {
            "type":PopupType.CONTROLS,
            "timeout":0,
            "VFM":this.mVFM.vehicleFeatureSet
         };
         if(Peripheral.personalConfig.controlsTimeoutEnabled)
         {
            vars.timeout = 20000;
         }
         var _middleFeatureCount:int = 1;
         var _outsideFeatureCount:int = 0;
         if(Peripheral.vehConfig.hasHeatedSeat)
         {
            _outsideFeatureCount++;
         }
         if(Peripheral.vehConfig.hasVentedSeat)
         {
            _outsideFeatureCount++;
         }
         if(Peripheral.vehConfig.hasHeatedSteeringWheel)
         {
            _outsideFeatureCount++;
         }
         if(Peripheral.vehConfig.hasECMirror && !Peripheral.vehConfig.hasECMirrorHKPresent)
         {
            _middleFeatureCount++;
         }
         if(Peripheral.vehConfig.hasSurroundCamera && Peripheral.vehConfig.hasSVCSoftKey)
         {
            _middleFeatureCount++;
         }
         else
         {
            if(Peripheral.vehConfig.hasCargoCamera)
            {
               _middleFeatureCount++;
            }
            if(Peripheral.vehConfig.hasRVCMPresent && (this.modelyear == 16 && Peripheral.vehConfig.isTruckPlatform || this.modelyear >= 17))
            {
               _middleFeatureCount++;
            }
         }
         if(Peripheral.vehConfig.hasFrontCamera || Peripheral.vehConfig.hasSideCamera || Peripheral.vehConfig.dtvShortTermPresent && Peripheral.vehConfig.vehicleLine != "LX")
         {
            _middleFeatureCount++;
         }
         if(Peripheral.vehConfig.hasHeadRest)
         {
            _middleFeatureCount++;
         }
         if(Peripheral.vehConfig.hasDisplayOnOffSK)
         {
            _middleFeatureCount++;
         }
         if(Peripheral.vehConfig.hasSunShade)
         {
            _middleFeatureCount++;
         }
         if(Peripheral.vehConfig.hasEcoAppBtn)
         {
            _middleFeatureCount++;
         }
         if(!(_middleFeatureCount == 1 && _outsideFeatureCount == 0))
         {
            if(_middleFeatureCount < 2 && _outsideFeatureCount < 2)
            {
               Framework.popupManager.show(DynamicPopupNames.CONTROLS,"popupvehsmall",vars);
            }
            else if(_middleFeatureCount < 3 && _outsideFeatureCount < 3)
            {
               Framework.popupManager.show(DynamicPopupNames.CONTROLS,"popupvehmedium",vars);
            }
            else if(_middleFeatureCount > 2 || _outsideFeatureCount > 2)
            {
               Framework.popupManager.show(DynamicPopupNames.CONTROLS,"popupvehlarge",vars);
            }
         }
      }
      
      public function hideControlsPopup() : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.CONTROLS)
         {
            Framework.popupManager.close(GlobalEvent.CONTROLS_POPUP_CLOSED);
         }
      }
      
      private function onCameraUpdate(e:CameraEvent) : void
      {
         this.hideControlsPopup();
      }
   }
}

