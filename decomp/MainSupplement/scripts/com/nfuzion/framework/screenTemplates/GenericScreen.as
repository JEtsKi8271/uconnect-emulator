package com.nfuzion.framework.screenTemplates
{
   import ancillary.Breadcrumb;
   import com.nfuzion.framework.global.Framework;
   import core.locale.LocaleArchive;
   import core.utils.Text;
   import events.HardControlEvent;
   import events.LocaleEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import peripheral.AppStateManager;
   import peripheral.InspectionManager;
   import peripheral.Peripheral;
   import skin.Skin;
   
   public class GenericScreen extends AbstractScreen
   {
      
      protected static const TRUNCATE_WORDS:int = 0;
      
      protected static const TRUNCATE_CHARACTERS:int = 1;
      
      protected static const TRUNCATE_NONE:int = 2;
      
      protected var mView:MovieClip;
      
      protected var mIsCached:Boolean = false;
      
      private var mListenersList:Array = new Array();
      
      private var mBreadcrumbs:Array;
      
      private var mBreadcrumbTextField:TextField = null;
      
      protected var mSavedVarsKey:String = null;
      
      protected var mSavedVars:Object;
      
      protected var mTranslatables:Array = new Array();
      
      private var mDebounceTime:int = 0;
      
      private var mDebounceTimer:Timer = null;
      
      public function GenericScreen()
      {
         view = this.mView as MovieClip;
         super();
         this.createScreenVariable(this.persistentProperties);
      }
      
      override public function screenIn() : void
      {
         super.screenIn();
         if(!this.mIsCached)
         {
            if(this.mView.doNotDecorate == null || this.mView.doNotDecorate == false)
            {
               Framework.autoAssigner.assignChildren(this.mView);
            }
            this.initView();
         }
         this.readScreenVariables();
         if(this.mDebounceTime != 0)
         {
            this.startDebounce();
         }
         this.addListeners();
         this.initScreen();
         this.changeLocale();
         this.mIsCached = true;
         screenInComplete();
      }
      
      override public function screenOut() : void
      {
         this.cancelDebounceTimer();
         super.screenOut();
         this.storeScreenVariables();
         this.removeListeners();
         screenOutComplete();
      }
      
      override public function cleanup() : void
      {
         this.mListenersList = null;
         this.mBreadcrumbs = null;
         this.mBreadcrumbTextField = null;
         this.mSavedVars = null;
         this.mTranslatables = null;
         if(this.mDebounceTimer != null)
         {
            this.mDebounceTimer.stop();
            this.mDebounceTimer = null;
         }
         super.cleanup();
      }
      
      protected function addListeners() : void
      {
         if(this.mBreadcrumbTextField)
         {
            this.attachListener(this.mBreadcrumbTextField,MouseEvent.CLICK,this.onBreadcrumbClick);
         }
         this.attachListener(Peripheral.hardControls,HardControlEvent.BACK,back);
         this.attachListener(Peripheral.hardControls,HardControlEvent.EXIT,close);
         this.attachListener(Peripheral.localeEngine,LocaleEvent.CHANGE,this.changeLocale);
      }
      
      protected function removeListeners() : void
      {
         var listener:Object = null;
         var dispatcher:IEventDispatcher = null;
         for each(listener in this.mListenersList)
         {
            dispatcher = listener.dispatcher;
            dispatcher.removeEventListener(listener.type,listener.listener,listener.useCapture);
         }
         this.mListenersList = new Array();
      }
      
      protected function initView() : void
      {
         if(this.mView.getChildByName("displayTitle"))
         {
            if(this.mView.displayTitle.getChildByName("labelValue"))
            {
               this.mBreadcrumbTextField = this.mView.displayTitle.labelValue;
            }
         }
         else if(this.mView.getChildByName("title_label"))
         {
            this.mBreadcrumbTextField = this.mView.title_label;
         }
         if(this.mBreadcrumbTextField)
         {
            this.mBreadcrumbs = new Array();
         }
         this.updateBreadcrumbs();
      }
      
      protected function attachListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var i:int = 0;
         var listenerItem:Object = null;
         if(dispatcher != null)
         {
            for(i = 0; i < this.mListenersList.length; i++)
            {
               listenerItem = this.mListenersList[i];
               if(listenerItem.dispatcher == dispatcher && listenerItem.type == type && listenerItem.listener == listener && listenerItem.useCapture == useCapture)
               {
                  return;
               }
            }
            this.mListenersList.push({
               "dispatcher":dispatcher,
               "type":type,
               "listener":listener,
               "useCapture":useCapture
            });
            dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
         }
         else
         {
            Framework.Trace("ERROR: Attempted to add a listener to a null EventDispatcher.");
         }
      }
      
      protected function detachListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var listenerItem:Object = null;
         for(var i:int = 0; i < this.mListenersList.length; i++)
         {
            listenerItem = this.mListenersList[i];
            if(listenerItem.dispatcher == dispatcher && listenerItem.type == type && listenerItem.listener == listener && listenerItem.useCapture == useCapture)
            {
               dispatcher = listenerItem.dispatcher;
               dispatcher.removeEventListener(listenerItem.type,listenerItem.listener,listenerItem.useCapture);
               this.mListenersList.splice(i,1);
               break;
            }
         }
      }
      
      protected function swapListener(dispatcher:IEventDispatcher, type:String, listener:Function = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var listenerItem:Object = null;
         for(var i:int = 0; i < this.mListenersList.length; i++)
         {
            listenerItem = this.mListenersList[i];
            if(listenerItem.dispatcher == dispatcher && listenerItem.type == type && listenerItem.useCapture == useCapture)
            {
               dispatcher = listenerItem.dispatcher;
               dispatcher.removeEventListener(listenerItem.type,listenerItem.listener,listenerItem.useCapture);
               this.mListenersList.splice(i,1);
            }
         }
         if(listener != null)
         {
            this.attachListener(dispatcher,type,listener,useCapture,priority,useWeakReference);
         }
      }
      
      protected function initScreen() : void
      {
      }
      
      protected function pushBreadcrumb(breadcrumb:Breadcrumb) : void
      {
         this.mBreadcrumbs.push(breadcrumb);
         this.updateBreadcrumbs();
      }
      
      protected function popBreadcrumb() : void
      {
         this.mBreadcrumbs.pop();
         this.updateBreadcrumbs();
      }
      
      protected function clearBreadcrumbs() : void
      {
         this.mBreadcrumbs = new Array();
      }
      
      protected function updateBreadcrumbs() : void
      {
         if(this.mBreadcrumbTextField)
         {
            Text.formatBreadcrumb(this.mBreadcrumbTextField,Text.getBreadcrumb(this.mBreadcrumbs),Skin.style.currentTheme.titleText.color.hexValue);
         }
      }
      
      protected function onBreadcrumbClick(e:MouseEvent) : void
      {
         var text:String = this.mBreadcrumbTextField.text;
         var index:int = this.mBreadcrumbTextField.getCharIndexAtPoint(e.localX,e.localY);
         var offset:int = text.length - 1;
         var delta:* = int(this.mBreadcrumbs.length - 1);
         var separator:String = ">";
         if(LocaleArchive.getInstance().isMirrored())
         {
            index = text.length - index;
            separator = "<";
            text = text.split("").reverse().join("");
         }
         while(offset > index && offset > 0)
         {
            offset = text.lastIndexOf(separator,offset - 1);
            if(offset > index)
            {
               delta--;
            }
         }
         this.igniteBreadcrumb(this.mBreadcrumbs[delta],delta);
      }
      
      public function igniteBreadcrumb(breadcrumb:Breadcrumb, delta:int) : void
      {
         var callback:Function = null;
         var branch:String = null;
         var historyIndex:int = 0;
         if(breadcrumb)
         {
            switch(breadcrumb.type)
            {
               case Breadcrumb.DELTA_FUNCTION:
                  callback = breadcrumb.args.shift() as Function;
                  if(breadcrumb.args.length == 0)
                  {
                     callback(delta);
                  }
                  else
                  {
                     callback(delta,breadcrumb.args);
                  }
                  breadcrumb.args.unshift(callback);
                  break;
               case Breadcrumb.FUNCTION:
                  callback = breadcrumb.args.shift() as Function;
                  if(breadcrumb.args.length == 0)
                  {
                     callback();
                  }
                  else
                  {
                     callback(breadcrumb.args);
                  }
                  breadcrumb.args.unshift(callback);
                  this.mBreadcrumbs.splice(delta + 1);
                  this.updateBreadcrumbs();
                  break;
               case Breadcrumb.INERT:
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
                  break;
               case Breadcrumb.PAGE:
                  branch = breadcrumb.args[0] as String;
                  historyIndex = int(Framework.structure.historyIndexOf(branch));
                  if(historyIndex > 0 && historyIndex == this.mBreadcrumbs.length - 1 - delta)
                  {
                     Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_NORMAL);
                     Framework.structure.returnTo(branch);
                  }
                  else
                  {
                     Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
                  }
            }
         }
      }
      
      protected function get breadcrumbCount() : int
      {
         return this.mBreadcrumbs.length;
      }
      
      protected function set breadcrumbTextField(textField:TextField) : void
      {
         this.mBreadcrumbTextField = textField;
         this.updateBreadcrumbs();
      }
      
      protected function get persistentProperties() : Array
      {
         return null;
      }
      
      protected function createScreenVariable(vars:Array) : void
      {
         var obj:String = null;
         if(null == vars)
         {
            return;
         }
         if(null == this.mSavedVarsKey)
         {
            this.mSavedVarsKey = getQualifiedClassName(this);
         }
         if(!this.readScreenVariables())
         {
            if(null == this.mSavedVars)
            {
               this.mSavedVars = new Object();
            }
            this.mSavedVars.varNames = vars;
            for each(obj in vars)
            {
               try
               {
                  this.mSavedVars[obj] = this[obj];
               }
               catch(e:Error)
               {
                  Framework.Trace("error caught when trying to set " + obj + " error: " + e);
               }
            }
         }
      }
      
      protected function readScreenVariables() : Boolean
      {
         var savedVars:Object;
         var obj:String = null;
         if(null == this.mSavedVarsKey)
         {
            return false;
         }
         savedVars = null;
         savedVars = Peripheral.appStateManager.retrieveScreenVariables(this.mSavedVarsKey);
         if(null != savedVars)
         {
            this.mSavedVars = savedVars;
            for each(obj in this.mSavedVars.varNames)
            {
               try
               {
                  this[obj] = this.mSavedVars[obj];
               }
               catch(e:Error)
               {
                  Framework.Trace("error caught when trying to set " + obj + " error: " + e);
               }
            }
            return true;
         }
         return false;
      }
      
      protected function storeScreenVariables() : void
      {
         var obj:String = null;
         if(null == this.mSavedVars)
         {
            return;
         }
         for each(obj in this.mSavedVars.varNames)
         {
            try
            {
               this.mSavedVars[obj] = this[obj];
            }
            catch(e:Error)
            {
               Framework.Trace("error caught when trying to set " + obj + " error: " + e);
            }
         }
         Peripheral.appStateManager.saveScreenVariables(this.mSavedVarsKey,this.mSavedVars);
      }
      
      protected function t(target:TextField, composition:* = null, truncationType:int = 1, ellipsis:String = "…") : void
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
      
      protected function changeLocale(e:Event = null) : void
      {
         var translatable:Object = null;
         this.updateBreadcrumbs();
         for each(translatable in this.mTranslatables)
         {
            Text.format(translatable.target,translatable.composition,translatable.truncationType != TRUNCATE_NONE);
         }
      }
      
      protected function compose(composition:*) : String
      {
         return Text.getText(composition);
      }
      
      protected function get appStateManager() : AppStateManager
      {
         return Peripheral.appStateManager;
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
            this.mDebounceTimer.addEventListener(TimerEvent.TIMER,this.onDebounceTimerComplete,false,0,true);
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

