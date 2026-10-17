package core.template
{
   import com.nfuzion.framework.global.Framework;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.URLRequest;
   
   public class ScreenContainer
   {
      
      private var mLoader:Loader = null;
      
      private var mLoaded:Boolean = false;
      
      private var mActive:Boolean = false;
      
      private var mCached:Boolean = false;
      
      private var mScreen:MovieClip;
      
      private var mAddress:String = "";
      
      private var mDomain:String = "";
      
      private var mVariables:Object;
      
      public function mOnScreenReady():void
      {
      }
      public function mOnScreenInComplete():void
      {
      }
      public function mOnScreenOutComplete():void
      {
      }
      public function ScreenContainer()
      {
         super();
      }
      
      public function get screen() : MovieClip
      {
         return this.mScreen;
      }
      
      public function get active() : Boolean
      {
         return this.mActive;
      }
      
      public function get address() : String
      {
         return this.mAddress;
      }
      
      public function set address(param1:String) : void
      {
         this.mAddress = param1;
      }
      
      public function set domain(param1:String) : void
      {
         this.mDomain = param1;
      }
      
      public function get domain() : String
      {
         return this.mDomain;
      }
      
      public function set variables(param1:Object) : void
      {
         this.mVariables = param1;
      }
      
      public function get variables() : Object
      {
         return this.mVariables;
      }
      
      public function load() : void
      {
         if(!this.mLoaded || !this.mScreen)
         {
            this.mLoader = new Loader();
            this.mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete,false,1000,true);
            if(Framework.enableCatch)
            {
               this.mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,1000,true);
               this.mLoader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtErrors,false,1000,true);
               try
               {
                  this.mLoader.load(new URLRequest(this.mAddress));
               }
               catch(error:Error)
               {
                  Framework.screens.onError("load",mAddress,error.message,mDomain);
               }
            }
            else
            {
               this.mLoader.load(new URLRequest(this.mAddress));
            }
         }
         else
         {
            this.mScreen.screenVars = this.mVariables;
            this.mOnScreenReady(this);
         }
      }
      
      private function onUncaughtErrors(param1:UncaughtErrorEvent) : void
      {
         param1.preventDefault();
         this.mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         Framework.screens.onError(this.mLoaded ? "execution of a method" : "load",this.mAddress,param1.error,this.mDomain);
      }
      
      private function onIOError(param1:Event) : void
      {
         param1.preventDefault();
         this.mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mLoader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtErrors);
         Framework.screens.onError("IOERROR\n ",this.mAddress,"",this.mDomain);
      }
      
      private function onComplete(param1:Event) : void
      {
         this.mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.mScreen = this.mLoader.content as MovieClip;
         this.mScreen.screenVars = this.mVariables;
         this.mScreen.onScreenInComplete = this.onScreenInComplete;
         this.mScreen.onScreenOutComplete = this.onScreenOutComplete;
         this.mOnScreenReady(this);
         this.mLoaded = true;
      }
      
      public function addToStageListener() : void
      {
         this.mScreen.view.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
      }
      
      public function onAddedToStage(param1:Event) : void
      {
         var e:Event = param1;
         this.mCached = this.mScreen.cache;
         this.mScreen.view.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.mScreen.view.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
         if(Framework.enableCatch)
         {
            try
            {
               this.mScreen.screenIn();
            }
            catch(err:Error)
            {
               Framework.screens.onError("screenIn",mAddress,err.message,mDomain);
            }
         }
         else
         {
            this.mScreen.screenIn();
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var e:Event = param1;
         this.mScreen.view.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(this.mDomain != "MIDDLE")
         {
            if(Framework.enableCatch)
            {
               try
               {
                  this.mScreen.screenOut();
               }
               catch(err:Error)
               {
                  Framework.screens.onError("screenOut",mAddress,err.message,mDomain);
               }
            }
            else
            {
               this.mScreen.screenOut();
            }
         }
      }
      
      public function slay() : Boolean
      {
         if(Boolean(this.mLoaded && !this.mCached && !this.mActive) && Boolean(this.mScreen) && !this.mScreen.view.parent)
         {
            try
            {
               this.mScreen.cleanup();
               this.mScreen = null;
               this.mLoader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtErrors);
               this.mLoader.unloadAndStop(true);
               this.mLoader = null;
               this.mLoaded = false;
            }
            catch(err:Error)
            {
               Framework.screens.onError("Slay",mAddress,err.message + " " + err.getStackTrace(),mDomain);
            }
            return true;
         }
         return false;
      }
      
      private function onScreenInComplete() : void
      {
         this.mActive = true;
         this.mOnScreenInComplete(this);
      }
      
      private function onScreenOutComplete() : void
      {
         this.mActive = false;
         this.mCached = this.mScreen.cache;
         this.mOnScreenOutComplete(this);
      }
   }
}

