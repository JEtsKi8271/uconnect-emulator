package mx.modules
{
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ModuleManager
   {
      
      mx_internal static const VERSION:String = "4.1.0.16076";
      
      public function ModuleManager()
      {
         super();
      }
      
      public static function getModule(url:String) : IModuleInfo
      {
         return getSingleton().getModule(url);
      }
      
      public static function getAssociatedFactory(object:Object) : IFlexModuleFactory
      {
         return getSingleton().getAssociatedFactory(object);
      }
      
      private static function getSingleton() : Object
      {
         if(!ModuleManagerGlobals.managerSingleton)
         {
            ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
         }
         return ModuleManagerGlobals.managerSingleton;
      }
   }
}

import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import mx.core.IFlexModuleFactory;
import mx.events.ModuleEvent;
import mx.events.Request;
import mx.modules.IModuleInfo;

class ModuleManagerImpl extends EventDispatcher
{
   
   private var moduleList:Object = {};
   
   public function ModuleManagerImpl()
   {
      super();
   }
   
   public function getAssociatedFactory(object:Object) : IFlexModuleFactory
   {
      var m:Object = null;
      var info:ModuleInfo = null;
      var domain:ApplicationDomain = null;
      var cls:Class = null;
      var className:String = getQualifiedClassName(object);
      for each(m in this.moduleList)
      {
         info = m as ModuleInfo;
         if(info.ready)
         {
            domain = info.applicationDomain;
            try
            {
               cls = Class(domain.getDefinition(className));
               if(object is cls)
               {
                  return info.factory;
               }
            }
            catch(error:Error)
            {
               continue;
            }
         }
      }
      return null;
   }
   
   public function getModule(url:String) : IModuleInfo
   {
      var info:ModuleInfo = this.moduleList[url] as ModuleInfo;
      if(!info)
      {
         info = new ModuleInfo(url);
         this.moduleList[url] = info;
      }
      return new ModuleInfoProxy(info);
   }
}

class ModuleInfo extends EventDispatcher
{
   
   private var factoryInfo:FactoryInfo;
   
   private var limbo:Dictionary;
   
   private var loader:Loader;
   
   private var numReferences:int = 0;
   
   private var parentModuleFactory:IFlexModuleFactory;
   
   private var _error:Boolean = false;
   
   private var _loaded:Boolean = false;
   
   private var _ready:Boolean = false;
   
   private var _setup:Boolean = false;
   
   private var _url:String;
   
   public function ModuleInfo(url:String)
   {
      super();
      this._url = url;
   }
   
   public function get applicationDomain() : ApplicationDomain
   {
      return !this.limbo && Boolean(this.factoryInfo) ? this.factoryInfo.applicationDomain : null;
   }
   
   public function get error() : Boolean
   {
      return !this.limbo ? Boolean(this._error) : false;
   }
   
   public function get factory() : IFlexModuleFactory
   {
      return !this.limbo && Boolean(this.factoryInfo) ? this.factoryInfo.factory : null;
   }
   
   public function get loaded() : Boolean
   {
      return !this.limbo ? Boolean(this._loaded) : false;
   }
   
   public function get ready() : Boolean
   {
      return !this.limbo ? Boolean(this._ready) : false;
   }
   
   public function get setup() : Boolean
   {
      return !this.limbo ? Boolean(this._setup) : false;
   }
   
   public function get size() : int
   {
      return !this.limbo && Boolean(this.factoryInfo) ? int(this.factoryInfo.bytesTotal) : 0;
   }
   
   public function get url() : String
   {
      return this._url;
   }
   
   public function load(applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null, bytes:ByteArray = null, moduleFactory:IFlexModuleFactory = null) : void
   {
      if(this._loaded)
      {
         return;
      }
      this._loaded = true;
      this.limbo = null;
      this.parentModuleFactory = moduleFactory;
      if(bytes)
      {
         this.loadBytes(applicationDomain,bytes);
         return;
      }
      if(this._url.indexOf("published://") == 0)
      {
         return;
      }
      var r:URLRequest = new URLRequest(this._url);
      var c:LoaderContext = new LoaderContext();
      c.applicationDomain = applicationDomain ? applicationDomain : new ApplicationDomain(ApplicationDomain.currentDomain);
      c.securityDomain = securityDomain;
      if(securityDomain == null && Security.sandboxType == Security.REMOTE)
      {
         c.securityDomain = SecurityDomain.currentDomain;
      }
      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initHandler);
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
      this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      this.loader.load(r,c);
   }
   
   private function loadBytes(applicationDomain:ApplicationDomain, bytes:ByteArray) : void
   {
      var c:LoaderContext = new LoaderContext();
      c.applicationDomain = applicationDomain ? applicationDomain : new ApplicationDomain(ApplicationDomain.currentDomain);
      if("allowLoadBytesCodeExecution" in c)
      {
         c["allowLoadBytesCodeExecution"] = true;
      }
      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initHandler);
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
      this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      this.loader.loadBytes(bytes,c);
   }
   
   public function resurrect() : void
   {
      var f:Object = null;
      if(!this._ready)
      {
         return;
      }
      if(!this.factoryInfo && Boolean(this.limbo))
      {
         var _loc2_:int = 0;
         var _loc3_:* = this.limbo;
         for(f in _loc3_)
         {
            this.factoryInfo = f as FactoryInfo;
         }
         this.limbo = null;
      }
      if(!this.factoryInfo)
      {
         if(this._loaded)
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
         }
         this.loader = null;
         this._loaded = false;
         this._setup = false;
         this._ready = false;
         this._error = false;
      }
   }
   
   public function release() : void
   {
      if(Boolean(this._ready) && !this.limbo)
      {
         this.limbo = new Dictionary(true);
         this.limbo[this.factoryInfo] = 1;
         this.factoryInfo = null;
      }
      else
      {
         this.unload();
      }
   }
   
   private function clearLoader() : void
   {
      if(this.loader)
      {
         if(this.loader.contentLoaderInfo)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initHandler);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
         }
         try
         {
            if(this.loader.content)
            {
               this.loader.content.removeEventListener("ready",this.readyHandler);
               this.loader.content.removeEventListener("error",this.moduleErrorHandler);
               this.loader.content.removeEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.getFlexModuleFactoryRequestHandler);
            }
         }
         catch(error:Error)
         {
         }
         if(this._loaded)
         {
            try
            {
               this.loader.close();
            }
            catch(error:Error)
            {
            }
         }
         try
         {
            this.loader.unload();
         }
         catch(error:Error)
         {
         }
         this.loader = null;
      }
   }
   
   public function unload() : void
   {
      this.clearLoader();
      if(this._loaded)
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
      }
      this.limbo = null;
      this.factoryInfo = null;
      this.parentModuleFactory = null;
      this._loaded = false;
      this._setup = false;
      this._ready = false;
      this._error = false;
   }
   
   public function publish(factory:IFlexModuleFactory) : void
   {
      if(this.factoryInfo)
      {
         return;
      }
      if(this._url.indexOf("published://") != 0)
      {
         return;
      }
      this.factoryInfo = new FactoryInfo();
      this.factoryInfo.factory = factory;
      this._loaded = true;
      this._setup = true;
      this._ready = true;
      this._error = false;
      dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
      dispatchEvent(new ModuleEvent(ModuleEvent.PROGRESS));
      dispatchEvent(new ModuleEvent(ModuleEvent.READY));
   }
   
   public function addReference() : void
   {
      ++this.numReferences;
   }
   
   public function removeReference() : void
   {
      --this.numReferences;
      if(this.numReferences == 0)
      {
         this.release();
      }
   }
   
   public function initHandler(event:Event) : void
   {
      var moduleEvent:ModuleEvent = null;
      this.factoryInfo = new FactoryInfo();
      try
      {
         this.factoryInfo.factory = this.loader.content as IFlexModuleFactory;
      }
      catch(error:Error)
      {
      }
      if(!this.factoryInfo.factory)
      {
         moduleEvent = new ModuleEvent(ModuleEvent.ERROR,event.bubbles,event.cancelable);
         moduleEvent.bytesLoaded = 0;
         moduleEvent.bytesTotal = 0;
         moduleEvent.errorText = "SWF is not a loadable module";
         dispatchEvent(moduleEvent);
         return;
      }
      this.loader.content.addEventListener("ready",this.readyHandler);
      this.loader.content.addEventListener("error",this.moduleErrorHandler);
      this.loader.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.getFlexModuleFactoryRequestHandler);
      try
      {
         this.factoryInfo.applicationDomain = this.loader.contentLoaderInfo.applicationDomain;
      }
      catch(error:Error)
      {
      }
      this._setup = true;
      dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
   }
   
   public function progressHandler(event:ProgressEvent) : void
   {
      var moduleEvent:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS,event.bubbles,event.cancelable);
      moduleEvent.bytesLoaded = event.bytesLoaded;
      moduleEvent.bytesTotal = event.bytesTotal;
      dispatchEvent(moduleEvent);
   }
   
   public function completeHandler(event:Event) : void
   {
      var moduleEvent:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS,event.bubbles,event.cancelable);
      moduleEvent.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
      moduleEvent.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      dispatchEvent(moduleEvent);
   }
   
   public function errorHandler(event:ErrorEvent) : void
   {
      this._error = true;
      var moduleEvent:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR,event.bubbles,event.cancelable);
      moduleEvent.bytesLoaded = 0;
      moduleEvent.bytesTotal = 0;
      moduleEvent.errorText = event.text;
      dispatchEvent(moduleEvent);
   }
   
   public function getFlexModuleFactoryRequestHandler(request:Request) : void
   {
      request.value = this.parentModuleFactory;
   }
   
   public function readyHandler(event:Event) : void
   {
      this._ready = true;
      this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      var moduleEvent:ModuleEvent = new ModuleEvent(ModuleEvent.READY);
      moduleEvent.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
      moduleEvent.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      this.clearLoader();
      dispatchEvent(moduleEvent);
   }
   
   public function moduleErrorHandler(event:Event) : void
   {
      var errorEvent:ModuleEvent = null;
      this._ready = true;
      this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      this.clearLoader();
      if(event is ModuleEvent)
      {
         errorEvent = ModuleEvent(event);
      }
      else
      {
         errorEvent = new ModuleEvent(ModuleEvent.ERROR);
      }
      dispatchEvent(errorEvent);
   }
}

class FactoryInfo
{
   
   public var factory:IFlexModuleFactory;
   
   public var applicationDomain:ApplicationDomain;
   
   public var bytesTotal:int = 0;
   
   public function FactoryInfo()
   {
      super();
   }
}

class ModuleInfoProxy extends EventDispatcher implements IModuleInfo
{
   
   private var info:ModuleInfo;
   
   private var referenced:Boolean = false;
   
   private var _data:Object;
   
   public function ModuleInfoProxy(info:ModuleInfo)
   {
      super();
      this.info = info;
      info.addEventListener(ModuleEvent.SETUP,this.moduleEventHandler,false,0,true);
      info.addEventListener(ModuleEvent.PROGRESS,this.moduleEventHandler,false,0,true);
      info.addEventListener(ModuleEvent.READY,this.moduleEventHandler,false,0,true);
      info.addEventListener(ModuleEvent.ERROR,this.moduleEventHandler,false,0,true);
      info.addEventListener(ModuleEvent.UNLOAD,this.moduleEventHandler,false,0,true);
   }
   
   public function get data() : Object
   {
      return this._data;
   }
   
   public function set data(value:Object) : void
   {
      this._data = value;
   }
   
   public function get error() : Boolean
   {
      return this.info.error;
   }
   
   public function get factory() : IFlexModuleFactory
   {
      return this.info.factory;
   }
   
   public function get loaded() : Boolean
   {
      return this.info.loaded;
   }
   
   public function get ready() : Boolean
   {
      return this.info.ready;
   }
   
   public function get setup() : Boolean
   {
      return this.info.setup;
   }
   
   public function get url() : String
   {
      return this.info.url;
   }
   
   public function publish(factory:IFlexModuleFactory) : void
   {
      this.info.publish(factory);
   }
   
   public function load(applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null, bytes:ByteArray = null, moduleFactory:IFlexModuleFactory = null) : void
   {
      var moduleEvent:ModuleEvent = null;
      this.info.resurrect();
      if(!this.referenced)
      {
         this.info.addReference();
         this.referenced = true;
      }
      if(this.info.error)
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
      }
      else if(this.info.loaded)
      {
         if(this.info.setup)
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
            if(this.info.ready)
            {
               moduleEvent = new ModuleEvent(ModuleEvent.PROGRESS);
               moduleEvent.bytesLoaded = this.info.size;
               moduleEvent.bytesTotal = this.info.size;
               dispatchEvent(moduleEvent);
               dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            }
         }
      }
      else
      {
         this.info.load(applicationDomain,securityDomain,bytes,moduleFactory);
      }
   }
   
   public function release() : void
   {
      if(this.referenced)
      {
         this.info.removeReference();
         this.referenced = false;
      }
   }
   
   public function unload() : void
   {
      this.info.unload();
      this.info.removeEventListener(ModuleEvent.SETUP,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.PROGRESS,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.READY,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.ERROR,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.UNLOAD,this.moduleEventHandler);
   }
   
   private function moduleEventHandler(event:ModuleEvent) : void
   {
      dispatchEvent(event);
   }
}
