package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import extensions.drivemode.DriveModeNonSRTSetup;
   import extensions.drivemode.DriveModeSRTSetup;
   import extensions.drivemode.DriveModeWKSetup;
   import extensions.drivemode.IDriveModeSetupExtension;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeSetUpScreen extends ScreenEnhanced
   {
      
      private var assets:C_DriveModeSetUp = new C_DriveModeSetUp();
      
      private var mContents:Array = [];
      
      private var mExtension:IDriveModeSetupExtension;
      
      public function DriveModeSetUpScreen()
      {
         mView = this.assets;
         super();
      }
      
      override protected function addListeners() : void
      {
         mView.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         mView.info_button.addEventListener(WidgetEvent.CLICK,this.onSetDetail,false,0,true);
         mView.buttonGroups.option_Buttons_group1.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group2.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group3.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group4.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group5.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group6.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         mView.buttonGroups.option_Buttons_group7.addEventListener(GlobalEvent.ITEM,this.onItem,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SCREEN_UPDATE,this.onModeChanged,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SET_UP_UPDATE,this.onSetUpUpdate,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onLockOut,false,0,true);
         this.mExtension.addListeners();
         super.addListeners();
      }
      
      override protected function removeListeners() : void
      {
         mView.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         mView.info_button.removeEventListener(WidgetEvent.CLICK,this.onSetDetail);
         mView.buttonGroups.option_Buttons_group1.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group2.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group3.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group4.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group5.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group6.removeEventListener(GlobalEvent.ITEM,this.onItem);
         mView.buttonGroups.option_Buttons_group7.removeEventListener(GlobalEvent.ITEM,this.onItem);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SCREEN_UPDATE,this.onModeChanged);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SET_UP_UPDATE,this.onSetUpUpdate);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onLockOut);
         this.mExtension.removeListeners();
         super.removeListeners();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.initExtension();
         this.mExtension.initView();
         mView.info_button.alwaysClick = true;
      }
      
      override protected function initScreen() : void
      {
         var setupArg:String = "";
         super.initScreen();
         mView.info_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
         setupArg = Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("driveModeType")) ? screenVars.driveModeType : "";
         this.mExtension.initScreen(setupArg);
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         super.changeLocale(e);
         Text.format(mView.info_button.label,T.STRB_DM_INFO,false);
         Text.resizeToFitByFontSize(mView.info_button.label,false,true);
         this.mExtension.setTitleBar();
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBack(null);
      }
      
      private function onBack(evt:WidgetEvent) : void
      {
         Framework.structure.back();
      }
      
      private function onItem(evt:GlobalEvent) : void
      {
         if(evt.data.name == "setUp_type_button")
         {
            if(!Peripheral.driveModeManager.checkSpeedLockout())
            {
               if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("driveModeType")))
               {
                  Framework.structure.goto(Screens.DRIVEMODE_SETUPDETAIL,{
                     "entry":this.toTypeFromId(evt.data.parent.id),
                     "globalSetMode":screenVars.driveModeType
                  });
               }
               else
               {
                  Framework.structure.goto(Screens.DRIVEMODE_SETUPDETAIL,{"entry":this.toTypeFromId(evt.data.parent.id)});
               }
            }
         }
         else if(!this.mExtension.showPopup(evt.data))
         {
            evt.data.parent.select = evt.data.label.text;
            switch(evt.data.parent.id)
            {
               case T.STRB_ENGINE_TRANS:
                  Peripheral.driveMode.TransmissionModeRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_ENGINE:
                  Peripheral.driveMode.EngineModeRequest = evt.data.label.text;
                  break;
               case T.STRB_POWER:
                  Peripheral.driveMode.HorsepowerModeRequest = evt.data.label.text;
                  break;
               case T.STRB_VEHICLE_AWD:
                  Peripheral.driveMode.TerrainModeRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_TRANS_SETUP:
                  Peripheral.driveMode.TransmissionModeRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_PADDLES_SETUP:
                  Peripheral.driveMode.PaddleShifterRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_STABILITY_SETUP:
               case T.STRB_DM_TRACTION_SETUP:
               case T.STRB_DM_TRACTION_CONTROL:
                  Peripheral.driveMode.StabilityRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_SUSPENSION_SETUP:
                  Peripheral.driveMode.SuspensionRequest = evt.data.label.text;
                  break;
               case T.STRB_DM_STEERING_SETUP:
                  Peripheral.driveMode.SteeringRequest = evt.data.label.text;
                  break;
               default:
                  Framework.Trace("onWKItem: Unknown Item ID!!!");
            }
         }
      }
      
      private function onSetDetail(evt:WidgetEvent) : void
      {
         if(Peripheral.driveModeManager.speedLockOut)
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.DRIVEMODE_ONE_ITEM_POPUP,{
               "body":T.STRB_ERROR_BODY_SPEED_LOCKOUT,
               "closeButton":false
            });
         }
         else if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("driveModeType")))
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUPDETAIL,{"globalSetMode":screenVars.driveModeType});
         }
         else
         {
            Framework.structure.goto(Screens.DRIVEMODE_SETUPDETAIL);
         }
      }
      
      private function onModeChanged(evt:DriveModeEvent) : void
      {
         this.mExtension.modeChanged(evt);
         this.mExtension.setTitleBar();
      }
      
      private function onSetUpUpdate(evt:DriveModeEvent) : void
      {
         this.mExtension.modeChanged(evt);
      }
      
      private function onLockOut(evt:VehicleStatusEvent) : void
      {
         mView.info_button.setEnabled(!Peripheral.driveModeManager.speedLockOut);
         this.mExtension.modeChanged(null);
         this.updateGroups();
      }
      
      public function clearDataItems() : void
      {
         this.mContents.length = 0;
      }
      
      public function pushDataItems(item:Object) : void
      {
         this.mContents.push(item);
      }
      
      public function updateGroups() : void
      {
         mView.buttonGroups.items = this.mContents;
      }
      
      private function initExtension() : void
      {
         if(this.mExtension != null)
         {
            this.mExtension.removeListeners();
            this.mExtension = null;
         }
         if(Boolean(Peripheral.vehConfig.hasDriveModePresent) && Boolean(Peripheral.vehConfig.hasSRTPresent))
         {
            if(Peripheral.vehConfig.hasTSBMPresent)
            {
               this.mExtension = new DriveModeWKSetup(this);
            }
            else
            {
               this.mExtension = new DriveModeSRTSetup(this);
            }
         }
         else
         {
            this.mExtension = new DriveModeNonSRTSetup(this);
         }
      }
      
      private function toTypeFromId(id:uint) : String
      {
         switch(id)
         {
            case T.STRB_ENGINE_TRANS:
            case T.STRB_DM_ENGINE:
            case T.STRB_POWER:
               return DriveModeTypes.HORSE_POWER;
            case T.STRB_VEHICLE_AWD:
               return DriveModeTypes.ALL_WHEEL_DRIVE;
            case T.STRB_DM_TRANS_SETUP:
               return DriveModeTypes.TRANSMISSION;
            case T.STRB_DM_PADDLES_SETUP:
               return DriveModeTypes.PADDLE_SHIFTER;
            case T.STRB_DM_STABILITY_SETUP:
            case T.STRB_DM_TRACTION_CONTROL:
            case T.STRB_DM_TRACTION_SETUP:
               return DriveModeTypes.STABILITY_CONTROL;
            case T.STRB_DM_SUSPENSION_SETUP:
               return DriveModeTypes.SUSPENSION;
            case T.STRB_DM_STEERING_SETUP:
               return DriveModeTypes.STEERING;
            default:
               Framework.Trace("onWKItem: Unknown Item ID!!!");
               return "";
         }
      }
   }
}

