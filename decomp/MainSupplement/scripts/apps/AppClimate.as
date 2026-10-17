package apps
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.HvacEvent;
   import core.events.PopupManagerEvent;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppClimate extends App
   {
      
      private var mLastFanSpeed:String = "off";
      
      public function AppClimate()
      {
         super();
         id = ID.CLIMATE;
      }
      
      override public function get cp() : IApp
      {
         return new AppClimate();
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_CLIMATE);
         }
         return Text.getText(T.STRB_CLIMATE_ML);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Climate();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
         mButton.wave.visible = _visible && favorite;
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.ACTIVE,this.onPopupManagerActive,false,0,true);
         Framework.popupManager.addEventListener(PopupManagerEvent.CLOSE,this.onPopupManagerClose,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_F_CLIMATE_STATE,this.onClimateStateChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_F_FAN_SPEED,this.onFanSpeedChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_AUTO_STATE,this.onAutoStateChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_VENT_MODE,this.onVentStateChange,false,0,true);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Framework.popupManager.removeEventListener(PopupManagerEvent.ACTIVE,this.onPopupManagerActive);
         Framework.popupManager.removeEventListener(PopupManagerEvent.CLOSE,this.onPopupManagerClose);
         Peripheral.hvac.removeEventListener(HvacEvent.HVAC_F_CLIMATE_STATE,this.onClimateStateChange);
         Peripheral.hvac.removeEventListener(HvacEvent.HVAC_F_FAN_SPEED,this.onFanSpeedChange);
         Peripheral.hvac.removeEventListener(HvacEvent.HVAC_AUTO_STATE,this.onAutoStateChange);
         Peripheral.hvac.removeEventListener(HvacEvent.HVAC_VENT_MODE,this.onVentStateChange);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         Framework.popupManager.exit();
         Framework.structure.goto(Screens.MAIN_HVAC);
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         if(Framework.resolution != Framework.RES_800_600)
         {
            this.button.tab.visible = Framework.popupManager.active == DynamicPopupNames.FAN_SPEED || Framework.popupManager.active == DynamicPopupNames.AIR_FLOW;
         }
         else
         {
            this.button.tab.visible = false;
         }
         if(!Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT))
         {
            this.mLastFanSpeed = "off";
            this.button.fan.gotoAndStop("fan0");
            this.button.vents.gotoAndStop("off");
         }
         else
         {
            this.updateFanSpeed();
            this.updateVentState();
         }
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         Text.format(this.button.label,T.STRB_MENU_CLIMATE);
         Text.format(this.button.vents.off,T.STRB_HVAC_OFF);
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.MAIN_HVAC || Framework.mapping.getAddress(Framework.structure.currentBranch) == Screens.REAR_HVAC);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.updateHighlight();
      }
      
      private function onPopupManagerActive(e:PopupManagerEvent) : void
      {
         if(Framework.resolution != Framework.RES_800_600)
         {
            this.button.tab.visible = favorite && (Framework.popupManager.active == DynamicPopupNames.FAN_SPEED || Framework.popupManager.active == DynamicPopupNames.AIR_FLOW);
         }
      }
      
      private function onPopupManagerClose(e:PopupManagerEvent) : void
      {
         if(e.vars.id == DynamicPopupNames.FAN_SPEED || e.vars.id == DynamicPopupNames.AIR_FLOW)
         {
            this.button.tab.visible = false;
         }
      }
      
      private function onClimateStateChange(e:HvacEvent) : void
      {
         this.refresh();
      }
      
      private function onAutoStateChange(e:HvacEvent) : void
      {
         this.refresh();
      }
      
      private function onFanSpeedChange(e:HvacEvent) : void
      {
         this.updateFanSpeed(true);
      }
      
      private function onVentStateChange(e:HvacEvent) : void
      {
         this.updateVentState();
      }
      
      private function updateFanSpeed(eventTriggered:Boolean = false) : void
      {
         var fanSpeed:String = Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT);
         this.button.fan.visible = true;
         if(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT))
         {
            switch(fanSpeed)
            {
               case Peripheral.hvac.FAN_AUTO:
                  this.button.fan.gotoAndStop("fan0");
                  return;
               case Peripheral.hvac.FAN_OFF:
                  this.button.fan.gotoAndStop("fan0");
                  return;
               case "1":
                  this.button.fan.gotoAndStop("fan1");
                  return;
               case "2":
                  this.button.fan.gotoAndStop("fan2");
                  return;
               case "3":
                  this.button.fan.gotoAndStop("fan3");
                  return;
               case "4":
                  this.button.fan.gotoAndStop("fan4");
                  return;
               case "5":
                  this.button.fan.gotoAndStop("fan5");
                  return;
               case "6":
                  this.button.fan.gotoAndStop("fan6");
                  return;
               case "7":
                  this.button.fan.gotoAndStop("fan7");
                  return;
            }
         }
      }
      
      private function updateVentState() : void
      {
         this.button.vents.visible = true;
         if(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT))
         {
            if(Peripheral.hvac.autoState(Peripheral.hvac.ZONE_FRONT) == Peripheral.hvac.AUTO_ON)
            {
               this.button.vents.gotoAndStop("auto");
            }
            else
            {
               switch(Peripheral.hvac.ventMode(Peripheral.hvac.ZONE_FRONT))
               {
                  case Peripheral.hvac.VENT_DASH:
                     this.button.vents.gotoAndStop("panel");
                     return;
                  case Peripheral.hvac.VENT_FLOOR:
                     this.button.vents.gotoAndStop("floor");
                     return;
                  case Peripheral.hvac.VENT_MIX:
                     this.button.vents.gotoAndStop("bilevel");
                     return;
                  case Peripheral.hvac.VENT_DEFROSTER_MIX:
                     this.button.vents.gotoAndStop("defrostFloor");
                     return;
                  case Peripheral.hvac.VENT_DEFROSTER:
                     this.button.vents.gotoAndStop("defrost");
                     return;
                  case Peripheral.hvac.VENT_OFF:
                     this.button.vents.gotoAndStop("off");
                     return;
               }
            }
         }
      }
   }
}

