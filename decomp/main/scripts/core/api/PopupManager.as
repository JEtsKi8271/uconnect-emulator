package core.api
{
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import core.events.PopupManagerEvent;
   import events.GlobalEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class PopupManager extends EventDispatcher implements IPopupManager
   {
      
      private var DOMAIN:String = "POPUPS";
      
      private var PRIORITY:Dictionary = new Dictionary();
      
      private var ACTIVE:Boolean = false;
      
      private var mBusy:Boolean = false;
      
      private var mMinExpired:Boolean = false;
      
      private var mActionTaken:Boolean = false;
      
      private var mPopupActive:int = -1;
      
      private var mPopupType:int = -1;
      
      private var mPopupBranch:String = "";
      
      private var mPopupVars:Object = null;
      
      private var mMinimumTimer:Timer = new Timer(2000);
      
      private var mTimeoutTimer:Timer = new Timer(5000);
      
      private var mPopupQueue:Vector.<Object> = new Vector.<Object>();
      
      public function PopupManager()
      {
         super();
         this.PRIORITY[PopupType.CONTROLS] = [0,1,2,2,2,2,3,2,2,2,3,2,3,3,3,3,3];
         this.PRIORITY[PopupType.CLIMATE] = [2,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3];
         this.PRIORITY[PopupType.OPTIONS] = [2,1,1,1,2,2,3,1,1,3,3,1,3,3,3,3,3];
         this.PRIORITY[PopupType.TUNE] = [2,1,2,2,2,2,3,1,1,3,3,2,3,3,3,3,3];
         this.PRIORITY[PopupType.SPELLER] = [1,1,1,1,2,2,4,1,1,3,3,1,3,3,3,3,3];
         this.PRIORITY[PopupType.PRIMARY] = [2,1,1,1,2,2,3,1,2,3,3,1,3,3,3,3,3];
         this.PRIORITY[PopupType.IMPORTANT] = [2,1,2,2,2,2,2,2,2,3,3,2,3,3,3,3,3];
         this.PRIORITY[PopupType.SECONDARY] = [1,1,1,1,1,2,1,1,1,3,1,1,3,3,3,3,3];
         this.PRIORITY[PopupType.SCREENOFF] = [1,1,1,1,1,1,1,1,1,2,1,1,3,3,3,3,3];
         this.PRIORITY[PopupType.ANTITHEFT] = [3,1,1,1,1,1,1,1,2,1,1,1,3,3,3,3,3];
         this.PRIORITY[PopupType.PHONE] = [1,1,1,1,1,1,2,1,2,2,1,1,3,3,3,2,2];
         this.PRIORITY[PopupType.VR] = [1,1,1,1,1,2,4,1,2,3,3,1,3,3,3,3,3];
         this.PRIORITY[PopupType.EMERGENCY] = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3];
         this.PRIORITY[PopupType.DISCLAIMER] = [2,2,2,2,2,2,2,2,2,2,2,2,3,2,3,3,3];
         this.PRIORITY[PopupType.CAMERA] = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3];
         this.PRIORITY[PopupType.DTV_CAMERA] = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3];
         this.PRIORITY[PopupType.CHARGE_NOW] = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3];
      }
      
      public function get currentBranch() : String
      {
         return this.mPopupBranch;
      }
      
      public function get active() : int
      {
         return this.mPopupActive;
      }
      
      public function get type() : int
      {
         return this.mPopupType;
      }
      
      public function get variables() : Object
      {
         return this.mPopupVars;
      }
      
      public function show(identifier:int, branch:String, variables:Object = null) : void
      {
         var i:int = 0;
         trace("<HMICore> PopupManager [ SHOW ]( id: " + identifier + ", branch: " + branch + " )");
         if(variables == null)
         {
            variables = new Object();
         }
         if(this.ACTIVE)
         {
            if(this.mPopupActive == identifier)
            {
               this.mPopupVars = variables;
               this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.REFRESH,branch,variables));
            }
            else if(!this.check(identifier))
            {
               if(variables == null)
               {
                  variables = {"type":PopupType.SECONDARY};
               }
               this.enqueue({
                  "id":identifier,
                  "address":branch,
                  "vars":variables
               });
            }
            else
            {
               for(i = 0; i < this.mPopupQueue.length; i++)
               {
                  if(this.mPopupQueue[i].id == identifier)
                  {
                     if(variables != null && variables.type != null)
                     {
                        this.mPopupQueue[i].vars = variables;
                     }
                  }
               }
            }
         }
         else
         {
            this.ACTIVE = true;
            this.queue({
               "id":identifier,
               "address":branch,
               "vars":variables
            });
         }
      }
      
      public function close(reason:String = "unknown", variables:Object = null) : void
      {
         if(variables == null)
         {
            variables = new Object();
         }
         if(reason != "Dequeued" && (this.mPopupType == PopupType.ANTITHEFT || this.mPopupType == PopupType.DISCLAIMER || this.mPopupType == PopupType.CAMERA && this.mPopupType == PopupType.CHARGE_NOW))
         {
            trace("<PopupManager> Why are you trying to randomly close popups? You don\'t know what you are closing... This could be anti theft information, emergency information or legal disclaimers");
            return;
         }
         if(!this.mBusy)
         {
            this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.CLOSE,this.mPopupBranch,{"id":this.mPopupActive}));
            if(this.mPopupQueue.length == 0)
            {
               this.mPopupActive = -1;
               this.mPopupType = -1;
               this.mPopupBranch = "";
               Framework.screens.close(this.DOMAIN);
               this.ACTIVE = false;
               this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.EMPTY));
            }
            else
            {
               this.ACTIVE = true;
               this.mPopupActive = -1;
               this.mPopupType = -1;
               this.queue(this.mPopupQueue.shift());
            }
            if(reason != "unknown")
            {
               this.dispatch(reason,variables);
            }
         }
         else
         {
            this.mActionTaken = true;
         }
      }
      
      public function exit() : void
      {
         var i:int = 0;
         if(this.checkForType(PopupType.ANTITHEFT) || this.checkForType(PopupType.CAMERA) || this.checkForType(PopupType.EMERGENCY) || this.checkForType(PopupType.DISCLAIMER) || this.checkForType(PopupType.CHARGE_NOW))
         {
            i = 0;
            while(i < this.mPopupQueue.length)
            {
               if(this.mPopupQueue[i].vars.type != PopupType.ANTITHEFT && this.mPopupQueue[i].vars.type != PopupType.CAMERA && this.mPopupQueue[i].vars.type != PopupType.EMERGENCY && this.mPopupQueue[i].vars.type != PopupType.DISCLAIMER && this.mPopupQueue[i].vars.type != PopupType.CHARGE_NOW)
               {
                  this.mPopupQueue.splice(i,1);
               }
               else
               {
                  i++;
               }
            }
            if(this.mPopupType != PopupType.ANTITHEFT && this.mPopupType != PopupType.CAMERA && this.mPopupType != PopupType.EMERGENCY && this.mPopupType != PopupType.DISCLAIMER && this.mPopupType != PopupType.CHARGE_NOW)
            {
               this.close();
            }
         }
         else
         {
            this.mPopupQueue.length = 0;
            this.close();
         }
      }
      
      public function dispatch(event:String, variables:Object = null) : void
      {
         this.dispatchEvent(new GlobalEvent(event,variables));
      }
      
      private function queue(popup:Object) : void
      {
         this.mBusy = true;
         this.mActionTaken = false;
         this.mMinExpired = false;
         this.getMinimumTime(popup);
         this.cancelTimeout();
         this.getTimeout(popup);
         if(this.mPopupBranch == popup.address)
         {
            this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.REFRESH,this.mPopupBranch,popup.vars));
         }
         this.mPopupActive = popup.id;
         this.mPopupType = popup.vars != null && Boolean(popup.vars.hasOwnProperty("type")) ? int(popup.vars.type) : PopupType.SECONDARY;
         this.mPopupBranch = popup.address;
         this.mPopupVars = popup.vars;
         Framework.screens.goto(popup.address,this.DOMAIN,popup.vars);
      }
      
      private function enqueue(popup:Object) : void
      {
         switch(this.PRIORITY[popup.vars.type == null ? PopupType.PRIMARY : popup.vars.type][this.mPopupType])
         {
            case 1:
               if(this.mMinExpired)
               {
                  this.queue(popup);
               }
               else
               {
                  this.mPopupQueue.unshift(popup);
               }
               break;
            case 2:
               if(this.mMinExpired)
               {
                  this.mPopupQueue.unshift({
                     "id":this.mPopupActive,
                     "address":this.mPopupBranch,
                     "vars":this.mPopupVars
                  });
                  this.queue(popup);
               }
               else
               {
                  this.mPopupQueue.unshift(popup);
                  this.mActionTaken = true;
               }
               break;
            case 3:
               this.mPopupQueue.push(popup);
               break;
            case 4:
               this.mPopupQueue.push(popup);
               break;
            case 5:
               this.queue(popup);
         }
      }
      
      public function dequeue(identifier:int) : void
      {
         if(this.mPopupActive == identifier)
         {
            if(this.mMinExpired)
            {
               this.close("Dequeued");
            }
            else
            {
               this.mActionTaken = true;
            }
            return;
         }
         for(var i:int = 0; i < this.mPopupQueue.length; i++)
         {
            if(this.mPopupQueue[i].id == identifier)
            {
               this.mPopupQueue.splice(i,1);
               return;
            }
         }
      }
      
      public function check(identifier:int) : Boolean
      {
         if(this.mPopupActive == identifier)
         {
            return true;
         }
         for(var i:int = 0; i < this.mPopupQueue.length; i++)
         {
            if(this.mPopupQueue[i].id == identifier)
            {
               return true;
            }
         }
         return false;
      }
      
      public function checkForType(type:int) : Boolean
      {
         if(this.mPopupType == type)
         {
            return true;
         }
         for(var i:int = 0; i < this.mPopupQueue.length; i++)
         {
            if(this.mPopupQueue[i].vars.type == type)
            {
               return true;
            }
         }
         return false;
      }
      
      public function resetTimeout(milliseconds:int = 0) : void
      {
         if(this.mTimeoutTimer.hasEventListener(TimerEvent.TIMER))
         {
            if(milliseconds != 0)
            {
               this.mTimeoutTimer.delay = milliseconds;
            }
            this.mTimeoutTimer.reset();
            this.mTimeoutTimer.start();
         }
      }
      
      private function getTimeout(popup:Object) : void
      {
         if(Boolean(popup.vars != null) && Boolean(popup.vars.hasOwnProperty("timeout")) && popup.vars.timeout != 0)
         {
            this.setTimeout(popup.vars.timeout);
         }
      }
      
      public function setTimeout(milliseconds:int) : void
      {
         if(milliseconds != 0)
         {
            this.mTimeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
            this.mTimeoutTimer.delay = milliseconds;
            this.mTimeoutTimer.reset();
            this.mTimeoutTimer.start();
         }
         else
         {
            this.cancelTimeout();
         }
      }
      
      private function cancelTimeout() : void
      {
         if(this.mTimeoutTimer.running)
         {
            if(this.mTimeoutTimer.hasEventListener(TimerEvent.TIMER))
            {
               this.mTimeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
               this.mTimeoutTimer.reset();
            }
         }
      }
      
      private function onTimeout(evt:TimerEvent) : void
      {
         this.cancelTimeout();
         var activePopupId:int = this.mPopupActive;
         if(this.mPopupType != PopupType.CHARGE_NOW)
         {
            this.close("timeout");
         }
         dispatchEvent(new PopupManagerEvent(PopupManagerEvent.TIMEOUT,this.mPopupBranch,{"id":activePopupId}));
      }
      
      private function getMinimumTime(popup:Object) : void
      {
         if(popup.vars != null && Boolean(popup.vars.hasOwnProperty("minimum")))
         {
            this.setMinimumTime(popup.vars.minimum);
         }
         else
         {
            this.mMinExpired = true;
         }
      }
      
      private function setMinimumTime(milliseconds:int) : void
      {
         this.mMinimumTimer.addEventListener(TimerEvent.TIMER,this.onMinimumExpired);
         this.mMinimumTimer.delay = milliseconds;
         this.mMinimumTimer.reset();
         this.mMinimumTimer.start();
      }
      
      private function onMinimumExpired(evt:TimerEvent) : void
      {
         this.mMinExpired = true;
         this.mMinimumTimer.reset();
         if(this.mActionTaken)
         {
            this.close("Dequeued");
         }
      }
      
      public function error(_address:String) : void
      {
         trace("<PopupManager> onError() < " + _address + " >");
         this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.CLOSE,this.mPopupBranch,{"id":this.mPopupActive}));
         this.ACTIVE = false;
         this.mPopupQueue.length = 0;
         this.mPopupActive = -1;
         this.mPopupType = -1;
         this.mPopupBranch = "";
         Framework.screens.close(this.DOMAIN);
         this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.EMPTY));
      }
      
      public function taskComplete(_address:String) : void
      {
         this.mBusy = false;
         var activePopupId:int = this.mPopupActive;
         if(this.mActionTaken)
         {
            this.close("Dequeued");
         }
         this.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.ACTIVE,this.mPopupBranch,{"id":activePopupId}));
      }
   }
}

