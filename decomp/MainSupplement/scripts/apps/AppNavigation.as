package apps
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.LocationEvent;
   import com.harman.navigation.Controller.NDR.NDRControlEvent;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import core.enums.Market;
   import core.events.StructureEvent;
   import core.utils.Text;
   import flash.display.MovieClip;
   import flash.events.Event;
   import locale.T;
   import peripheral.Peripheral;
   
   public class AppNavigation extends App
   {
      
      private const COMPASS:Array = [T.STRB_GEO_NORTH,T.STRB_GEO_NORTH_EAST,T.STRB_GEO_EAST,T.STRB_GEO_SOUTH_EAST,T.STRB_GEO_SOUTH,T.STRB_GEO_SOUTH_WEST,T.STRB_GEO_WEST,T.STRB_GEO_NORTH_WEST];
      
      public function AppNavigation()
      {
         super();
         id = ID.NAVIGATION;
      }
      
      override public function get cp() : IApp
      {
         return new AppNavigation();
      }
      
      override public function get id() : String
      {
         return ID.NAVIGATION;
      }
      
      override public function get label() : String
      {
         if(favorite)
         {
            return Text.getText(T.STRB_MENU_NAV);
         }
         return Text.getText(T.STRB_MENU_NAV);
      }
      
      override public function get button() : MovieClip
      {
         if(super.button == null)
         {
            button = new C_Button_Navigation();
         }
         return mButton;
      }
      
      override public function set wave(_visible:Boolean) : void
      {
         mButton.wave.visible = _visible && favorite && Global.market != Market.CHINA && Global.market != Market.JAPAN && Global.market != Market.KOREA;
      }
      
      override public function set favorite(_favorite:Boolean) : void
      {
         super.favorite = _favorite;
         super.adjustLabel(this.button.label);
      }
      
      override public function addListeners() : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         Peripheral.location.addEventListener(LocationEvent.COMPASS_HEADING,this.onCompassHeading,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.NAV_IS_READY,this.onNavIsReady,false,0,true);
         this.onNavIsReady(null);
         super.addListeners();
      }
      
      override public function removeListeners() : void
      {
         Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
         Peripheral.location.removeEventListener(LocationEvent.COMPASS_HEADING,this.onCompassHeading);
         Peripheral.antiTheft.removeEventListener(AntiTheftEvent.ANTI_THEFT_IGNITION_STATE,this.onIgnitionState);
         Peripheral.navigation.removeEventListener(NavigationEvent.NAV_IS_READY,this.onNavIsReady);
         super.removeListeners();
      }
      
      override public function press() : void
      {
         if(Framework.popupManager.active != DynamicPopupNames.DISCLAIMER)
         {
            Framework.popupManager.exit();
         }
         Peripheral.navigation.navDomainControl.onNavDomainButton();
      }
      
      override public function refresh() : void
      {
         this.updateLocale();
         this.updateHighlight();
      }
      
      override public function updateLocale() : void
      {
         if(favorite)
         {
            Text.format(this.button.label,T.STRB_MENU_NAV);
         }
         else
         {
            Text.format(this.button.label,T.STRB_MENU_NAV);
         }
         this.updateCompassText();
      }
      
      override public function updateHighlight() : void
      {
         this.button.setHighlight(Framework.mapping.getDomain(Framework.structure.currentBranch) == Screens.DOMAIN_NAVIGATION);
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         this.refresh();
      }
      
      private function onCompassHeading(e:Event) : void
      {
         this.refresh();
      }
      
      private function onIgnitionState(e:AntiTheftEvent) : void
      {
         this.refresh();
      }
      
      private function onNavIsReady(e:NavigationEvent) : void
      {
         if(Peripheral.navigation.navigation.navIsReady && Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            Peripheral.navigation.navNDR.addEventListener(NDRControlEvent.NDR_HEADING,this.onCompassHeading,false,0,true);
            Peripheral.navigation.navNDR.enableHeadingUpdates(true);
            this.onCompassHeading(null);
         }
      }
      
      private function updateCompassText() : void
      {
         if(Peripheral.vehConfig.hasCompassDisplay && Peripheral.antiTheft.ignitionState != "accessory")
         {
            this.button.value.visible = true;
            if(Peripheral.location.compassHeading < this.COMPASS.length && Peripheral.location.compassHeading >= 0)
            {
               this.button.value.text = Text.getText(this.COMPASS[Peripheral.location.compassHeading]);
            }
            else
            {
               this.button.value.text = "--";
            }
         }
         else if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "MP4")
         {
            this.button.value.visible = true;
            if(Peripheral.navigation.navigation.navIsReady)
            {
               Text.format(this.button.value,Peripheral.navigation.navVServices.hmiUtils.getCompassTextBundle(Peripheral.navigation.navNDR.GpsInfo.mCompassHeading));
            }
            else
            {
               this.button.value.text = "--";
            }
         }
         else
         {
            this.button.value.visible = false;
         }
      }
   }
}

