package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import com.harman.framework.template.ScreenEnhanced;
   import com.harman.moduleLinkAPI.DriveModeEvent;
   import com.harman.moduleLinkAPI.DriveModeTypes;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import core.utils.Text;
   import events.GlobalEvent;
   import events.LocaleEvent;
   import events.WidgetEvent;
   import extensions.drivemode.DriveModeNonSRTDetailSetup;
   import extensions.drivemode.DriveModeSRTDetailSetup;
   import extensions.drivemode.DriveModeWKDetailSetup;
   import extensions.drivemode.IDriveModeDetailSetupExtension;
   import flash.events.Event;
   import flash.text.TextField;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class DriveModeSetUpDetailScreen extends ScreenEnhanced
   {
      
      private static const TAGS:Array = [{
         "start":"<r>",
         "end":"</r>",
         "color":RED_COLOR
      },{
         "start":"<g>",
         "end":"</g>",
         "color":GREEN_COLOR
      },{
         "start":"<o>",
         "end":"</o>",
         "color":ORANGE_COLOR
      },{
         "start":"<y>",
         "end":"</y>",
         "color":YELLOW_COLOR
      },{
         "start":"<bl>",
         "end":"</bl>",
         "color":BLUE_COLOR
      },{
         "start":"<lb>",
         "end":"</lb>",
         "color":LIGHT_BLUE_COLOR
      }];
      
      private static const RED_COLOR:String = "0xFF0000";
      
      private static const GREEN_COLOR:String = "0x00FF00";
      
      private static const BLUE_COLOR:String = "0x0000FF";
      
      private static const LIGHT_BLUE_COLOR:String = "0x569EFF";
      
      private static const ORANGE_COLOR:String = "0xFF8B02";
      
      private static const YELLOW_COLOR:String = "0xFDFE00";
      
      private const MAIN:String = "Main";
      
      private var assets:C_DriveModeSetUpDetail = new C_DriveModeSetUpDetail();
      
      private var mExtension:IDriveModeDetailSetupExtension;
      
      private var mSetMode:String;
      
      private var mLayOut:Array = [];
      
      public function DriveModeSetUpDetailScreen()
      {
         mView = this.assets;
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this.initExtension();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.mExtension.addListeners();
         this.assets.back_button.addEventListener(WidgetEvent.CLICK,this.onBack,false,0,true);
         this.assets.previous_button.addEventListener(WidgetEvent.CLICK,this.onPrevious,false,0,true);
         this.assets.next_button.addEventListener(WidgetEvent.CLICK,this.onNext,false,0,true);
         mView.option_3Buttons_group.addEventListener(GlobalEvent.ITEM,this.onSet,false,0,true);
         mView.option_4Buttons_group.addEventListener(GlobalEvent.ITEM,this.onSet,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdate,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.SET_UP_UPDATE,this.onUpdate,false,0,true);
         Peripheral.driveMode.addEventListener(DriveModeEvent.TERRAIN_MODE,this.onUpdate,false,0,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout,false,0,true);
      }
      
      override protected function changeLocale(e:LocaleEvent) : void
      {
         this.showSetByName(this.mSetMode);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         var _driveMode:String = "";
         if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("globalSetMode")))
         {
            _driveMode = screenVars.globalSetMode;
         }
         this.mExtension.initScreen(_driveMode);
         this.mSetMode = "Main";
         if(Boolean(screenVars) && Boolean(screenVars.hasOwnProperty("entry")))
         {
            this.mSetMode = screenVars.entry;
         }
         this.showSetByName(this.mSetMode);
         this.onSpeedLockout(null);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         this.mExtension.removeListeners();
         this.assets.back_button.removeEventListener(WidgetEvent.CLICK,this.onBack);
         this.assets.previous_button.removeEventListener(WidgetEvent.CLICK,this.onPrevious);
         this.assets.next_button.removeEventListener(WidgetEvent.CLICK,this.onNext);
         mView.option_3Buttons_group.addEventListener(GlobalEvent.ITEM,this.onSet);
         mView.option_4Buttons_group.addEventListener(GlobalEvent.ITEM,this.onSet);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SCREEN_UPDATE,this.onUpdate);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.SET_UP_UPDATE,this.onUpdate);
         Peripheral.driveMode.removeEventListener(DriveModeEvent.TERRAIN_MODE,this.onUpdate);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
         Framework.popupManager.dequeue(DynamicPopupNames.DRIVEMODE_FUNCTION_POPUP);
      }
      
      override protected function back(e:Event = null) : void
      {
         this.onBack(null);
      }
      
      public function pushItemLayout(item:String) : void
      {
         this.mLayOut.push(item);
      }
      
      public function colorTag(_textField:TextField, _text:String) : void
      {
         Text.colorTag(_textField,_text,TAGS);
      }
      
      private function onBack(evt:WidgetEvent) : void
      {
         Framework.structure.back();
      }
      
      private function onPrevious(evt:WidgetEvent) : void
      {
         var newIndex:* = this.mLayOut.indexOf(this.mSetMode);
         if(newIndex == 0)
         {
            newIndex = int(this.mLayOut.length);
         }
         newIndex--;
         this.showSetByName(this.mLayOut[newIndex]);
      }
      
      private function onNext(evt:WidgetEvent) : void
      {
         var newIndex:int = this.mLayOut.indexOf(this.mSetMode);
         if(newIndex == this.mLayOut.length - 1)
         {
            newIndex = -1;
         }
         newIndex++;
         this.showSetByName(this.mLayOut[newIndex]);
      }
      
      private function onSet(evt:GlobalEvent) : void
      {
         if(this.mExtension.showPopup(evt.data))
         {
            return;
         }
         evt.data.parent.select = evt.data.label.text;
         switch(this.mSetMode)
         {
            case DriveModeTypes.HORSE_POWER:
               this.mExtension.sendEngine(evt.data.label.text);
               break;
            case DriveModeTypes.ALL_WHEEL_DRIVE:
               Peripheral.driveMode.TerrainModeRequest = evt.data.label.text;
               break;
            case DriveModeTypes.TRANSMISSION:
               Peripheral.driveMode.TransmissionModeRequest = evt.data.label.text;
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               Peripheral.driveMode.PaddleShifterRequest = evt.data.label.text;
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               Peripheral.driveMode.StabilityRequest = evt.data.label.text;
               break;
            case DriveModeTypes.SUSPENSION:
               Peripheral.driveMode.SuspensionRequest = evt.data.label.text;
               break;
            case DriveModeTypes.STEERING:
               Peripheral.driveMode.SteeringRequest = evt.data.label.text;
         }
      }
      
      private function onUpdate(evt:DriveModeEvent) : void
      {
         this.showSetByName(this.mSetMode);
      }
      
      private function onSpeedLockout(evt:VehicleStatusEvent) : void
      {
         if(!Peripheral.driveModeManager.checkSpeedLockout(false))
         {
            Framework.popupManager.dequeue(DynamicPopupNames.DRIVEMODE_FUNCTION_POPUP);
         }
      }
      
      private function initExtension() : void
      {
         if(this.mExtension != null)
         {
            this.mExtension = null;
         }
         if(Boolean(Peripheral.vehConfig.hasDriveModePresent) && Boolean(Peripheral.vehConfig.hasSRTPresent) && Boolean(Peripheral.vehConfig.hasTSBMPresent))
         {
            this.mExtension = new DriveModeWKDetailSetup(this);
         }
         else if(Boolean(Peripheral.vehConfig.hasDriveModePresent) && Boolean(Peripheral.vehConfig.hasSRTPresent))
         {
            this.mExtension = new DriveModeSRTDetailSetup(this);
         }
         else
         {
            this.mExtension = new DriveModeNonSRTDetailSetup(this);
         }
      }
      
      private function showSetByName(value:String) : void
      {
         this.mSetMode = value;
         this.mExtension.setTitleBar(value);
         mView.all_wheel_infor.visible = value == DriveModeTypes.ALL_WHEEL_DRIVE;
         mView.content.visible = value != this.MAIN;
         mView.horsepower_info.visible = value == DriveModeTypes.HORSE_POWER;
         mView.option_3Buttons_group.visible = value != this.MAIN && value != DriveModeTypes.ALL_WHEEL_DRIVE;
         mView.option_4Buttons_group.visible = value == DriveModeTypes.ALL_WHEEL_DRIVE;
         mView.paddle_info.visible = value == DriveModeTypes.PADDLE_SHIFTER;
         mView.steering_info.visible = value == DriveModeTypes.STEERING;
         mView.suspension_infor.visible = value == DriveModeTypes.SUSPENSION;
         mView.traction_infor.visible = value == DriveModeTypes.STABILITY_CONTROL;
         mView.transmission_infor.visible = value == DriveModeTypes.TRANSMISSION;
         mView.type_infor.visible = value == this.MAIN;
         mView.warning.visible = false;
         mView.line1.visible = !Peripheral.vehConfig.hasTSBMPresent;
         mView.line2.visible = Peripheral.vehConfig.hasTSBMPresent;
         switch(value)
         {
            case DriveModeTypes.ALL_WHEEL_DRIVE:
               this.mExtension.setAWDState();
               break;
            case DriveModeTypes.HORSE_POWER:
               this.mExtension.setEngineState();
               break;
            case DriveModeTypes.PADDLE_SHIFTER:
               this.mExtension.setPaddleShifterState();
               break;
            case DriveModeTypes.STABILITY_CONTROL:
               this.mExtension.setStabilityControlState();
               break;
            case DriveModeTypes.STEERING:
               this.mExtension.setSteeringState();
               break;
            case DriveModeTypes.SUSPENSION:
               this.mExtension.setSuspensionState();
               break;
            case DriveModeTypes.TRANSMISSION:
               this.mExtension.setTransState();
               break;
            default:
               this.mExtension.setMainState();
         }
      }
   }
}

