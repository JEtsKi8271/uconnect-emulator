package core.api
{
   import com.nfuzion.framework.global.Framework;
   import core.enums.Layers;
   import core.events.FrameworkEvent;
   import core.events.StructureEvent;
   import core.template.ScreenContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ScreenModel extends EventDispatcher
   {
      
      private const MEMORY_LIMIT:Number = 20971520;
      
      private var mWatchDog:Timer = new Timer(5000);
      
      private var LAYERS:Dictionary = new Dictionary();
      
      private var mStage:Sprite;
      
      private var mLayer:Sprite;
      
      private var mBottom:Sprite = new Sprite();
      
      private var mMiddle:Sprite = new Sprite();
      
      private var mTaskBar:Sprite = new Sprite();
      
      private var mPopups:Sprite = new Sprite();
      
      private var mStatus:Sprite = new Sprite();
      
      private var mPrompt:Sprite = new Sprite();
      
      private var mScreen:ScreenContainer;
      
      private var mScreenContainerSet:Object = new Object();
      
      private var mScreenDictionary:Dictionary = new Dictionary(true);
      
      private var mSkinName:String;
      
      private var mRefresh:int = 0;
      
      private var mBusy:Boolean = false;
      
      private var mGarbage:Boolean = false;
      
      private var mQueue:Vector.<ScreenContainer> = new Vector.<ScreenContainer>();
      
      public function ScreenModel(param1:Sprite)
      {
         super();
         this.mStage = param1;
         this.mBottom.name = Layers.BOTTOM;
         this.mMiddle.name = Layers.MIDDLE;
         this.mTaskBar.name = Layers.TASKBAR;
         this.mPopups.name = Layers.POPUPS;
         this.mStatus.name = Layers.STATUS;
         this.mPrompt.name = Layers.PROMPT;
         this.mStage.addChild(this.mBottom);
         this.mStage.addChild(this.mMiddle);
         if(Framework.resolution == Framework.RES_800_480)
         {
            this.mStage.addChild(this.mStatus);
            this.mStage.addChild(this.mTaskBar);
            this.mStage.addChild(this.mMiddle);
            this.mStage.addChild(this.mPopups);
            this.mStage.addChild(this.mPrompt);
         }
         else
         {
            this.mStage.addChild(this.mStatus);
            this.mStage.addChild(this.mPopups);
            this.mStage.addChild(this.mTaskBar);
            this.mStage.addChild(this.mPrompt);
         }
         this.LAYERS[Layers.BOTTOM] = this.mBottom;
         this.LAYERS[Layers.MIDDLE] = this.mMiddle;
         this.LAYERS[Layers.TASKBAR] = this.mTaskBar;
         this.LAYERS[Layers.POPUPS] = this.mPopups;
         this.LAYERS[Layers.STATUS] = this.mStatus;
         this.LAYERS[Layers.PROMPT] = this.mPrompt;
         this.mWatchDog.addEventListener(TimerEvent.TIMER,this.onWatchDog,false,0,true);
      }
      
      public function set skinName(param1:String) : void
      {
         this.mSkinName = param1;
      }
      
      public function goto(param1:String, param2:String, param3:Object = null) : void
      {
         var _loc6_:ScreenContainer = null;
         var _loc7_:int = 0;
         Framework.echo("<HMICore> [ GOTO ]( " + param2 + " : " + param1 + " )");
         var _loc4_:String = this.getAddress(param1);
         var _loc5_:File = File.applicationDirectory.resolvePath(_loc4_);
         if(!_loc5_.exists)
         {
            this.writeError("path:" + _loc4_ + " does not exist on file system...");
            return;
         }
         if(!this.mWatchDog.running)
         {
            this.mWatchDog.start();
         }
         if(this.mScreenDictionary[param1] == null)
         {
            _loc6_ = new ScreenContainer();
            this.mScreenDictionary[param1] = _loc6_;
            _loc6_.address = _loc4_;
            _loc6_.mOnScreenReady = this.onScreenReady;
            _loc6_.mOnScreenInComplete = this.onScreenInComplete;
            _loc6_.mOnScreenOutComplete = this.onScreenOutComplete;
         }
         else
         {
            _loc6_ = this.mScreenDictionary[param1];
         }
         _loc6_.domain = param2;
         _loc6_.variables = param3;
         if(!this.mBusy)
         {
            this.loadScreen(_loc6_);
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < this.mQueue.length)
            {
               if(this.mQueue[_loc7_].address == param1)
               {
                  return;
               }
               if(this.mQueue[_loc7_].domain == param2)
               {
                  this.mQueue[_loc7_] = _loc6_;
                  return;
               }
               _loc7_++;
            }
            this.mQueue.push(_loc6_);
         }
         if(_loc6_.domain == Layers.MIDDLE)
         {
            Framework.structure.dispatchEvent(new StructureEvent(StructureEvent.GOTO,param1));
         }
      }
      
      public function getAddress(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1.lastIndexOf(".swf") != -1)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = Framework.mapping.getAddress(param1);
         }
         return String("skins/" + this.mSkinName + "/swf/" + _loc2_);
      }
      
      public function loadScreen(param1:ScreenContainer) : void
      {
         var _screen:ScreenContainer = param1;
         Framework.echo("<HMICore> [ LOAD ]( " + _screen.domain + " : " + _screen.address + " )");
         if(!this.mBusy)
         {
            this.mBusy = true;
            Framework.echo("<HMICore> [ BUSY ]");
         }
         Framework.focusManager.deleteLayer(_screen.domain);
         if(!this.mWatchDog.running)
         {
            this.mWatchDog.start();
         }
         if(_screen.domain == Layers.MIDDLE)
         {
            if(this.mScreen != null && this.mScreen.screen != null)
            {
               if(Framework.enableCatch)
               {
                  try
                  {
                     this.mScreen.screen.screenOut();
                  }
                  catch(err:Error)
                  {
                     Framework.screens.onError("screenOut",mScreen.address,err.message,mScreen.domain);
                  }
               }
               else
               {
                  this.mScreen.screen.screenOut();
               }
            }
            this.mScreen = _screen;
         }
         this.mScreenContainerSet[_screen.domain] = _screen;
         _screen.load();
      }
      
      public function onScreenReady(param1:ScreenContainer) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         Framework.echo("<HMICore> [ SCREEN LOADED ]( " + param1.domain + " : " + param1.address + " )");
         while(this.LAYERS[param1.domain].numChildren > 0)
         {
            this.LAYERS[param1.domain].removeChildAt(0);
         }
         if(Framework.resolution == Framework.RES_800_480)
         {
            if(!param1.screen.view.ignore)
            {
               if(this.LAYERS[Layers.POPUPS].numChildren != 0 && param1.domain != Layers.POPUPS)
               {
                  _loc2_ = this.LAYERS[Layers.POPUPS].getChildAt(0);
                  if(!_loc2_.ignore)
                  {
                     this.LAYERS[Layers.STATUS].visible = _loc2_.status == null ? true : _loc2_.status;
                     this.LAYERS[Layers.MIDDLE].visible = _loc2_.middle == null ? true : _loc2_.middle;
                  }
               }
               else
               {
                  if(param1.screen.view.status != null)
                  {
                     this.LAYERS[Layers.STATUS].visible = param1.screen.view.status;
                  }
                  else
                  {
                     this.LAYERS[Layers.STATUS].visible = true;
                  }
                  if(param1.screen.view.middle != null)
                  {
                     this.LAYERS[Layers.MIDDLE].visible = param1.screen.view.middle;
                  }
                  else
                  {
                     this.LAYERS[Layers.MIDDLE].visible = true;
                  }
               }
            }
            else if(this.LAYERS[Layers.MIDDLE].numChildren != 0)
            {
               _loc3_ = this.LAYERS[Layers.MIDDLE].getChildAt(0);
               this.LAYERS[Layers.STATUS].visible = _loc3_.status == null ? true : _loc3_.status;
               this.LAYERS[Layers.MIDDLE].visible = _loc3_.middle == null ? true : _loc3_.middle;
            }
         }
         param1.addToStageListener();
         this.LAYERS[param1.domain].addChild(param1.screen.view);
      }
      
      public function onScreenInComplete(param1:ScreenContainer) : void
      {
         if(param1.domain == Layers.MIDDLE)
         {
            Framework.structure.dispatchEvent(new StructureEvent(StructureEvent.AFTER_GOTO,param1.address));
         }
         Framework.echo("<HMICore> [ SCREEN IN COMPLETE ]( " + param1.domain + " : " + param1.address + " )");
         this.mWatchDog.reset();
         if(this.mQueue.length != 0)
         {
            this.loadScreen(this.mQueue.shift());
         }
         else
         {
            this.freeMemory();
         }
         switch(param1.domain)
         {
            case Layers.MIDDLE:
               Framework.structure.taskComplete(param1.address);
               break;
            case Layers.POPUPS:
               Framework.popupManager.taskComplete(param1.address);
         }
      }
      
      public function onScreenOutComplete(param1:ScreenContainer) : void
      {
         Framework.echo("<HMICore> [ SCREEN OUT COMPLETE ]( " + param1.domain + " : " + param1.address + " )");
         if(!this.mBusy)
         {
            Framework.echo("<HMICore> [ IDLE ]");
            this.dispatchEvent(new FrameworkEvent(FrameworkEvent.IDLE));
         }
      }
      
      public function onError(param1:String, param2:String, param3:String, param4:String) : void
      {
         Framework.echo("<HMICore> [ ERROR " + param1 + " ] " + param2 + " " + param3);
         this.writeError("ADDRESS : " + param2 + ", PROCESS : " + param1 + ", ERROR : " + param3);
         this.mWatchDog.reset();
         this.close(param4);
         if(param4 == Layers.POPUPS)
         {
            Framework.popupManager.error(param2);
         }
         if(param1 != "screenOut")
         {
            if(param4 == Layers.MIDDLE)
            {
               this.mQueue.length = 0;
               this.close(Layers.POPUPS);
               Framework.structure.gotolastScreen();
            }
            else if(param4 == Layers.TASKBAR)
            {
               Framework.screens.goto("TaskBar.swf",Layers.TASKBAR);
            }
            else if(param4 == Layers.STATUS)
            {
               Framework.screens.goto("StatusBar.swf",Layers.STATUS);
            }
            else if(this.mQueue.length != 0)
            {
               this.loadScreen(this.mQueue.shift());
            }
         }
      }
      
      private function onWatchDog(param1:TimerEvent) : void
      {
         Framework.echo("<HMICore> [ ERROR WatchDog ]");
         this.writeError("ADDRESS : " + (this.mScreen != null ? this.mScreen.address : "NULL") + ", PROCESS : WatchDog, ERROR : Screen Timed Out...");
         this.mWatchDog.reset();
         if(this.mScreen == null)
         {
            return;
         }
         this.close(this.mScreen.domain);
         if(this.mScreen.domain == Layers.MIDDLE)
         {
            this.mQueue.length = 0;
            this.close(Layers.POPUPS);
            Framework.structure.gotolastScreen();
         }
         else if(this.mScreen.domain == Layers.POPUPS)
         {
            Framework.popupManager.error(this.mScreen.address);
         }
         else if(this.mScreen.domain == Layers.TASKBAR)
         {
            Framework.screens.goto("TaskBar.swf",Layers.TASKBAR);
         }
         else if(this.mScreen.domain == Layers.STATUS)
         {
            Framework.screens.goto("StatusBar.swf",Layers.STATUS);
         }
         else if(this.mQueue.length != 0)
         {
            this.loadScreen(this.mQueue.shift());
         }
      }
      
      public function close(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         Framework.echo("<HMICore> [ CLOSE ]( " + param1 + " )");
         Framework.focusManager.deleteLayer(param1);
         this.mLayer = this.LAYERS[param1];
         if(this.mLayer.numChildren > 0)
         {
            this.mLayer.removeChildAt(0);
            this.mScreenContainerSet[param1] = null;
         }
         if(Framework.resolution == Framework.RES_800_480)
         {
            if(param1 == Layers.POPUPS && this.LAYERS[Layers.MIDDLE].numChildren > 0)
            {
               _loc2_ = this.LAYERS[Layers.MIDDLE].getChildAt(0);
               this.LAYERS[Layers.STATUS].visible = _loc2_.status == null ? true : _loc2_.status;
               this.LAYERS[Layers.MIDDLE].visible = _loc2_.middle == null ? true : _loc2_.middle;
            }
         }
      }
      
      public function hide(param1:String) : void
      {
         this.LAYERS[param1].visible = false;
      }
      
      public function show(param1:String) : void
      {
         this.LAYERS[param1].visible = true;
      }
      
      private function freeMemory() : void
      {
         var _screen:ScreenContainer = null;
         for each(_screen in this.mScreenDictionary)
         {
            if(System.totalMemory > this.MEMORY_LIMIT)
            {
               if(_screen != null)
               {
                  try
                  {
                     if(_screen.slay())
                     {
                        Framework.echo("<HMICore> [ FREE MEMORY ] Slayed : " + _screen.address);
                        if(!this.mGarbage)
                        {
                           this.mGarbage = true;
                        }
                     }
                  }
                  catch(err:Error)
                  {
                     Framework.echo("<HMICore> [ FREE MEMORY ] Error Slaying : " + _screen.address);
                     continue;
                  }
               }
            }
         }
         if(this.mGarbage)
         {
            System.gc();
            this.mGarbage = false;
         }
         this.mBusy = false;
         Framework.echo("<HMICore> [ IDLE ]");
         this.dispatchEvent(new FrameworkEvent(FrameworkEvent.IDLE));
      }
      
      private function writeError(param1:String) : void
      {
         Framework.echo("<HMICore> [ CAUGHT ERROR ] " + param1);
         var _loc2_:File = new File("file:///fs/etfs/hmierror.txt");
         var _loc3_:FileStream = new FileStream();
         try
         {
            _loc3_.open(_loc2_,FileMode.WRITE);
            _loc3_.writeObject(param1);
            _loc3_.close();
         }
         catch(err:Error)
         {
         }
      }
      
      private function formatBytes(param1:Number) : String
      {
         var _loc2_:Array = [" b"," Kb"," MB"," GB"];
         var _loc3_:uint = Math.floor(Math.log(param1) / Math.log(1024));
         return (param1 / Math.pow(1024,_loc3_)).toFixed(0) + _loc2_[_loc3_];
      }
      
      public function isActive(param1:String) : Boolean
      {
         return Sprite(this.LAYERS[param1]).numChildren != 0;
      }
      
      public function get isBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function get autoTestView() : Object
      {
         return this.LAYERS;
      }
      
      public function getScreenContainer(param1:String) : ScreenContainer
      {
         if(this.mScreenContainerSet[param1] != null)
         {
            return this.mScreenContainerSet[param1] as ScreenContainer;
         }
         return null;
      }
   }
}

