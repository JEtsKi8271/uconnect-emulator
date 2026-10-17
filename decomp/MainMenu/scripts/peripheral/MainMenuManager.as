package peripheral
{
   import com.harman.navigation.DomainControl.NavDomainControllerEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import events.VRSessionEvent;
   import flash.display.MovieClip;
   
   public class MainMenuManager
   {
      
      private static const WIDTH:int = 640;
      
      private static const BUTTON:int = 90;
      
      private static const RADIO:int = 0;
      
      private static const MEDIA:int = 1;
      
      private static const PHONE:int = 2;
      
      private static const MORE:int = 3;
      
      private static const APPS:int = 4;
      
      private static const NAV:int = 5;
      
      private static const CLIMATE:int = 6;
      
      private static const CONTROLS:int = 7;
      
      private static const SETTINGS:int = 8;
      
      private static const ECALL:int = 9;
      
      private var mMenuRaw:Vector.<MovieClip>;
      
      private var mMenuNew:Array = new Array();
      
      private var mPadding:int = 2;
      
      private var mAppsExist:Boolean = false;
      
      public function MainMenuManager()
      {
         super();
         Peripheral.vrSession.addEventListener(VRSessionEvent.VR_WAVES_HIDE,this.onVRWavesHide,false,0,true);
         Peripheral.vrSession.addEventListener(VRSessionEvent.VR_WAVES_SHOW,this.onVRWavesShow,false,0,true);
         Peripheral.navigation.navDomainControl.addEventListener(NavDomainControllerEvent.NAV_IS_OPERABLE,this.onNavigationOperable,false,0,true);
      }
      
      private function onVRWavesHide(e:VRSessionEvent) : void
      {
         this.vrDialogWaves = false;
      }
      
      private function onVRWavesShow(e:VRSessionEvent) : void
      {
         this.vrDialogWaves = true;
      }
      
      private function onNavigationOperable(e:NavDomainControllerEvent) : void
      {
         Global.navActivated = true;
         this.configure();
      }
      
      public function set menu(menu:Vector.<MovieClip>) : void
      {
         this.mMenuRaw = menu;
         this.configure();
      }
      
      private function set vrDialogWaves(_active:Boolean) : void
      {
         if(this.mMenuRaw == null)
         {
            return;
         }
         this.mMenuRaw[RADIO].wave.visible = _active;
         this.mMenuRaw[MEDIA].wave.visible = _active;
         this.mMenuRaw[PHONE].wave.visible = _active;
         this.mMenuRaw[MORE].wave.visible = _active;
         this.mMenuRaw[APPS].wave.visible = _active;
         this.mMenuRaw[NAV].wave.visible = Global.market != TunerRegion.CHINA && Global.market != TunerRegion.JAPAN && Global.market != TunerRegion.KOREA && _active;
         this.mMenuRaw[CLIMATE].wave.visible = _active;
         this.mMenuRaw[CONTROLS].wave.visible = _active;
         this.mMenuRaw[SETTINGS].wave.visible = _active;
         this.mMenuRaw[ECALL].wave.visible = _active;
      }
      
      public function configure() : void
      {
         if(this.mMenuRaw == null)
         {
            return;
         }
         this.mMenuRaw[SETTINGS].visible = false;
         this.mMenuNew.length = 0;
         this.mMenuNew.push(RADIO);
         this.mMenuNew.push(MEDIA);
         if(this.mMenuRaw[CONTROLS].visible == true)
         {
            this.mMenuNew.push(CONTROLS);
         }
         this.mMenuNew.push(CLIMATE);
         if(Global.navActivated)
         {
            this.mMenuNew.push(NAV);
            this.mMenuRaw[NAV].visible = true;
         }
         else
         {
            this.mMenuRaw[NAV].visible = false;
         }
         this.mMenuNew.push([PHONE,ECALL]);
         this.mAppsExist = Peripheral.appManager.getAppsExist() == "true";
         if(this.mMenuRaw[CONTROLS].visible == false || !this.mAppsExist)
         {
            this.mMenuNew.push(SETTINGS);
            this.mMenuRaw[SETTINGS].visible = true;
         }
         if(this.mAppsExist)
         {
            if(Global.SRTpackagePrsnt)
            {
               this.mMenuRaw[APPS].icon.gotoAndStop(2);
               this.mMenuRaw[APPS].glow.gotoAndStop(2);
               this.mMenuRaw[APPS].shadow.gotoAndStop(2);
            }
            else
            {
               this.mMenuRaw[APPS].icon.gotoAndStop(1);
               this.mMenuRaw[APPS].glow.gotoAndStop(1);
               this.mMenuRaw[APPS].shadow.gotoAndStop(1);
            }
            this.mMenuNew.push(APPS);
            this.mMenuRaw[APPS].visible = true;
            this.mMenuRaw[MORE].visible = false;
         }
         else
         {
            this.mMenuRaw[APPS].visible = false;
            this.mMenuRaw[MORE].visible = false;
         }
         this.move();
      }
      
      private function move() : void
      {
         var t:int = 0;
         this.mPadding = Math.floor((WIDTH - this.mMenuNew.length * BUTTON) / (this.mMenuNew.length + 1));
         for(var i:int = 0; i < this.mMenuNew.length; i++)
         {
            if(this.mMenuNew[i] is Array)
            {
               for(t = 0; t < this.mMenuNew[i].length; t++)
               {
                  if(i == 0)
                  {
                     this.mMenuRaw[this.mMenuNew[i][t]].x = this.mPadding;
                  }
                  else
                  {
                     this.mMenuRaw[this.mMenuNew[i][t]].x = this.mPadding + (BUTTON + this.mPadding) * i;
                  }
               }
            }
            else if(i == 0)
            {
               this.mMenuRaw[this.mMenuNew[i]].x = this.mPadding;
            }
            else
            {
               this.mMenuRaw[this.mMenuNew[i]].x = this.mPadding + (BUTTON + this.mPadding) * i;
            }
         }
      }
   }
}

