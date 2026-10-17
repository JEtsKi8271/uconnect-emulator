package com.harman.framework.template
{
   import core.utils.Text;
   import events.HardControlEvent;
   import events.LocaleEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import peripheral.InspectionManager;
   import peripheral.Peripheral;
   
   public class ScreenEnhanced extends ScreenGeneric
   {
      
      protected static const TRUNCATE_WORDS:int = 0;
      
      protected static const TRUNCATE_CHARACTERS:int = 1;
      
      protected static const TRUNCATE_NONE:int = 2;
      
      protected var mView:MovieClip;
      
      private var mIsCached:Boolean = false;
      
      private var mTranslatables:Array = new Array();
      
      private var mDebounceTime:int = 0;
      
      private var mDebounceTimer:Timer = null;
      
      public function ScreenEnhanced()
      {
         view = this.mView as MovieClip;
         super();
      }
      
      public function get cached() : Boolean
      {
         return this.mIsCached;
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
         if(!this.mIsCached)
         {
            this.initView();
         }
         if(this.mDebounceTime != 0)
         {
            this.startDebounce();
         }
         this.addListeners();
         this.initScreen();
         this.changeLocale(null);
         this.mIsCached = true;
         screenInComplete();
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
         this.cancelDebounceTimer();
         this.removeListeners();
         screenOutComplete();
      }
      
      protected function addListeners() : void
      {
         Peripheral.localeEngine.addEventListener(LocaleEvent.CHANGE,this.changeLocale,false,0,true);
         Peripheral.hardControls.addEventListener(HardControlEvent.BACK,this.back,false,0,true);
      }
      
      protected function removeListeners() : void
      {
         Peripheral.localeEngine.removeEventListener(LocaleEvent.CHANGE,this.changeLocale);
         Peripheral.hardControls.removeEventListener(HardControlEvent.BACK,this.back);
      }
      
      protected function initView() : void
      {
      }
      
      protected function initScreen() : void
      {
      }
      
      override public function cleanup() : void
      {
         this.mTranslatables = null;
         super.cleanup();
      }
      
      public function t(target:TextField, composition:* = null, truncationType:int = 1, ellipsis:String = "…") : void
      {
         var translatable:Object = null;
         var i:int = 0;
         if(!composition)
         {
            composition = "";
         }
         while(i < this.mTranslatables.length)
         {
            if(this.mTranslatables[i].target == target)
            {
               this.mTranslatables[i].composition = composition;
               this.mTranslatables[i].truncationType = truncationType;
               this.mTranslatables[i].ellipsis = ellipsis;
               translatable = this.mTranslatables[i];
               break;
            }
            i++;
         }
         if(!translatable)
         {
            translatable = {
               "target":target,
               "composition":composition,
               "truncationType":truncationType,
               "ellipsis":ellipsis
            };
            this.mTranslatables.push(translatable);
         }
         Text.format(target,composition,truncationType != TRUNCATE_NONE);
         InspectionManager.checkSTRBusage(target,composition);
      }
      
      public function get translatables() : Array
      {
         return this.mTranslatables;
      }
      
      protected function changeLocale(e:LocaleEvent) : void
      {
         var translatable:Object = null;
         for each(translatable in this.mTranslatables)
         {
            Text.format(translatable.target,translatable.composition,translatable.truncationType != TRUNCATE_NONE);
         }
      }
      
      protected function compose(composition:*) : String
      {
         return Text.getText(composition);
      }
      
      protected function back(e:Event = null) : void
      {
      }
      
      public function startDebounce() : void
      {
         if(!this.mDebounceTimer)
         {
            this.mDebounceTimer = new Timer(this.mDebounceTime,1);
         }
         if(this.mDebounceTimer)
         {
            this.cancelDebounceTimer();
            this.mDebounceTimer.addEventListener(TimerEvent.TIMER,this.onDebounceTimerComplete);
            this.mDebounceTimer.delay = this.mDebounceTime;
            this.mDebounceTimer.start();
         }
      }
      
      private function cancelDebounceTimer() : void
      {
         if(Boolean(this.mDebounceTimer) && this.mDebounceTimer.running)
         {
            if(this.mDebounceTimer.hasEventListener(TimerEvent.TIMER))
            {
               this.mDebounceTimer.removeEventListener(TimerEvent.TIMER,this.onDebounceTimerComplete);
            }
            this.mDebounceTimer.stop();
         }
      }
      
      private function onDebounceTimerComplete(evt:TimerEvent) : void
      {
         this.cancelDebounceTimer();
         this.debounceHandler();
      }
      
      protected function debounceHandler() : void
      {
      }
      
      public function setDebounce(milliseconds:int) : void
      {
         this.mDebounceTime = milliseconds;
      }
      
      public function isDebounceTimerRunning() : Boolean
      {
         if(Boolean(this.mDebounceTimer) && this.mDebounceTimer.running)
         {
            return true;
         }
         return false;
      }
   }
}

