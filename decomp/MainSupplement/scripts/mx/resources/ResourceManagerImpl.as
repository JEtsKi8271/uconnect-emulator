package mx.resources
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.SecurityDomain;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ModuleEvent;
   import mx.events.ResourceEvent;
   import mx.managers.SystemManagerGlobals;
   import mx.modules.IModuleInfo;
   import mx.modules.ModuleManager;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class ResourceManagerImpl extends EventDispatcher implements IResourceManager
   {
      
      private static var instance:IResourceManager;
      
      mx_internal static const VERSION:String = "4.1.0.16076";
      
      private var localeMap:Object = {};
      
      private var resourceModules:Object = {};
      
      private var initializedForNonFrameworkApp:Boolean = false;
      
      private var _localeChain:Array;
      
      public function ResourceManagerImpl()
      {
         super();
         var info:Object = SystemManagerGlobals.info;
         if(info)
         {
            this.processInfo(info);
         }
         if(SystemManagerGlobals.topLevelSystemManagers.length)
         {
            SystemManagerGlobals.topLevelSystemManagers[0].addEventListener(FlexEvent.NEW_CHILD_APPLICATION,this.newChildApplicationHandler);
         }
      }
      
      public static function getInstance() : IResourceManager
      {
         if(!instance)
         {
            instance = new ResourceManagerImpl();
         }
         return instance;
      }
      
      public function get localeChain() : Array
      {
         return this._localeChain;
      }
      
      public function set localeChain(value:Array) : void
      {
         this._localeChain = value;
         this.update();
      }
      
      public function installCompiledResourceBundles(applicationDomain:ApplicationDomain, locales:Array, bundleNames:Array) : void
      {
         var locale:String = null;
         var j:int = 0;
         var bundleName:String = null;
         var n:int = locales ? int(locales.length) : 0;
         var m:int = bundleNames ? int(bundleNames.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            locale = locales[i];
            for(j = 0; j < m; j++)
            {
               bundleName = bundleNames[j];
               this.installCompiledResourceBundle(applicationDomain,locale,bundleName);
            }
         }
      }
      
      private function installCompiledResourceBundle(applicationDomain:ApplicationDomain, locale:String, bundleName:String) : void
      {
         var packageName:String = null;
         var localName:String = bundleName;
         var colonIndex:int = bundleName.indexOf(":");
         if(colonIndex != -1)
         {
            packageName = bundleName.substring(0,colonIndex);
            localName = bundleName.substring(colonIndex + 1);
         }
         if(this.getResourceBundle(locale,bundleName))
         {
            return;
         }
         var resourceBundleClassName:String = locale + "$" + localName + "_properties";
         if(packageName != null)
         {
            resourceBundleClassName = packageName + "." + resourceBundleClassName;
         }
         var bundleClass:Class = null;
         if(applicationDomain.hasDefinition(resourceBundleClassName))
         {
            bundleClass = Class(applicationDomain.getDefinition(resourceBundleClassName));
         }
         if(!bundleClass)
         {
            resourceBundleClassName = bundleName;
            if(applicationDomain.hasDefinition(resourceBundleClassName))
            {
               bundleClass = Class(applicationDomain.getDefinition(resourceBundleClassName));
            }
         }
         if(!bundleClass)
         {
            resourceBundleClassName = bundleName + "_properties";
            if(applicationDomain.hasDefinition(resourceBundleClassName))
            {
               bundleClass = Class(applicationDomain.getDefinition(resourceBundleClassName));
            }
         }
         if(!bundleClass)
         {
            throw new Error("Could not find compiled resource bundle \'" + bundleName + "\' for locale \'" + locale + "\'.");
         }
         var resourceBundle:ResourceBundle = ResourceBundle(new bundleClass());
         resourceBundle._locale = locale;
         resourceBundle._bundleName = bundleName;
         this.addResourceBundle(resourceBundle);
      }
      
      private function newChildApplicationHandler(event:FocusEvent) : void
      {
         var info:Object = event.relatedObject["info"]();
         this.processInfo(info);
      }
      
      private function processInfo(info:Object) : void
      {
         var compiledLocales:Array = info["compiledLocales"];
         ResourceBundle.locale = compiledLocales != null && compiledLocales.length > 0 ? compiledLocales[0] : "en_US";
         var localeChainList:String = SystemManagerGlobals.parameters["localeChain"];
         if(localeChainList != null && localeChainList != "")
         {
            this.localeChain = localeChainList.split(",");
         }
         var applicationDomain:ApplicationDomain = info["currentDomain"];
         var compiledResourceBundleNames:Array = info["compiledResourceBundleNames"];
         this.installCompiledResourceBundles(applicationDomain,compiledLocales,compiledResourceBundleNames);
         if(!this.localeChain)
         {
            this.initializeLocaleChain(compiledLocales);
         }
      }
      
      public function initializeLocaleChain(compiledLocales:Array) : void
      {
         this.localeChain = LocaleSorter.sortLocalesByPreference(compiledLocales,this.getSystemPreferredLocales(),null,true);
      }
      
      public function loadResourceModule(url:String, updateFlag:Boolean = true, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) : IEventDispatcher
      {
         var errorHandler:Function;
         var moduleInfo:IModuleInfo = null;
         var resourceEventDispatcher:ResourceEventDispatcher = null;
         var timer:Timer = null;
         var timerHandler:Function = null;
         moduleInfo = ModuleManager.getModule(url);
         resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
         var readyHandler:Function = function(event:ModuleEvent):void
         {
            var resourceModule:* = event.module.factory.create();
            resourceModules[event.module.url].resourceModule = resourceModule;
            if(updateFlag)
            {
               update();
            }
         };
         moduleInfo.addEventListener(ModuleEvent.READY,readyHandler,false,0,true);
         errorHandler = function(event:ModuleEvent):void
         {
            var resourceEvent:ResourceEvent = null;
            var message:String = "Unable to load resource module from " + url;
            if(resourceEventDispatcher.willTrigger(ResourceEvent.ERROR))
            {
               resourceEvent = new ResourceEvent(ResourceEvent.ERROR,event.bubbles,event.cancelable);
               resourceEvent.bytesLoaded = 0;
               resourceEvent.bytesTotal = 0;
               resourceEvent.errorText = message;
               resourceEventDispatcher.dispatchEvent(resourceEvent);
               return;
            }
            throw new Error(message);
         };
         moduleInfo.addEventListener(ModuleEvent.ERROR,errorHandler,false,0,true);
         this.resourceModules[url] = new ResourceModuleInfo(moduleInfo,readyHandler,errorHandler);
         timer = new Timer(0);
         timerHandler = function(event:TimerEvent):void
         {
            timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            timer.stop();
            moduleInfo.load(applicationDomain,securityDomain);
         };
         timer.addEventListener(TimerEvent.TIMER,timerHandler,false,0,true);
         timer.start();
         return resourceEventDispatcher;
      }
      
      public function unloadResourceModule(url:String, update:Boolean = true) : void
      {
         var bundles:Array = null;
         var n:int = 0;
         var i:int = 0;
         var locale:String = null;
         var bundleName:String = null;
         var rmi:ResourceModuleInfo = this.resourceModules[url];
         if(!rmi)
         {
            return;
         }
         if(rmi.resourceModule)
         {
            bundles = rmi.resourceModule.resourceBundles;
            if(bundles)
            {
               n = int(bundles.length);
               for(i = 0; i < n; i++)
               {
                  locale = bundles[i].locale;
                  bundleName = bundles[i].bundleName;
                  this.removeResourceBundle(locale,bundleName);
               }
            }
         }
         this.resourceModules[url] = null;
         delete this.resourceModules[url];
         rmi.moduleInfo.unload();
         if(update)
         {
            this.update();
         }
      }
      
      public function addResourceBundle(resourceBundle:IResourceBundle) : void
      {
         var locale:String = resourceBundle.locale;
         var bundleName:String = resourceBundle.bundleName;
         if(!this.localeMap[locale])
         {
            this.localeMap[locale] = {};
         }
         this.localeMap[locale][bundleName] = resourceBundle;
      }
      
      public function getResourceBundle(locale:String, bundleName:String) : IResourceBundle
      {
         var bundleMap:Object = this.localeMap[locale];
         if(!bundleMap)
         {
            return null;
         }
         return bundleMap[bundleName];
      }
      
      public function removeResourceBundle(locale:String, bundleName:String) : void
      {
         delete this.localeMap[locale][bundleName];
         if(this.getBundleNamesForLocale(locale).length == 0)
         {
            delete this.localeMap[locale];
         }
      }
      
      public function removeResourceBundlesForLocale(locale:String) : void
      {
         delete this.localeMap[locale];
      }
      
      public function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getLocales() : Array
      {
         var p:String = null;
         var locales:Array = [];
         for(p in this.localeMap)
         {
            locales.push(p);
         }
         return locales;
      }
      
      public function getPreferredLocaleChain() : Array
      {
         return LocaleSorter.sortLocalesByPreference(this.getLocales(),this.getSystemPreferredLocales(),null,true);
      }
      
      public function getBundleNamesForLocale(locale:String) : Array
      {
         var p:String = null;
         var bundleNames:Array = [];
         for(p in this.localeMap[locale])
         {
            bundleNames.push(p);
         }
         return bundleNames;
      }
      
      public function findResourceBundleWithResource(bundleName:String, resourceName:String) : IResourceBundle
      {
         var locale:String = null;
         var bundleMap:Object = null;
         var bundle:IResourceBundle = null;
         if(!this._localeChain)
         {
            return null;
         }
         var n:int = int(this._localeChain.length);
         for(var i:int = 0; i < n; i++)
         {
            locale = this.localeChain[i];
            bundleMap = this.localeMap[locale];
            if(bundleMap)
            {
               bundle = bundleMap[bundleName];
               if(bundle)
               {
                  if(resourceName in bundle.content)
                  {
                     return bundle;
                  }
               }
            }
         }
         return null;
      }
      
      [Bindable("change")]
      public function getObject(bundleName:String, resourceName:String, locale:String = null) : *
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return undefined;
         }
         return resourceBundle.content[resourceName];
      }
      
      [Bindable("change")]
      public function getString(bundleName:String, resourceName:String, parameters:Array = null, locale:String = null) : String
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return null;
         }
         var value:String = String(resourceBundle.content[resourceName]);
         if(parameters)
         {
            value = StringUtil.substitute(value,parameters);
         }
         return value;
      }
      
      [Bindable("change")]
      public function getStringArray(bundleName:String, resourceName:String, locale:String = null) : Array
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return null;
         }
         var value:* = resourceBundle.content[resourceName];
         var array:Array = String(value).split(",");
         var n:int = int(array.length);
         for(var i:int = 0; i < n; i++)
         {
            array[i] = StringUtil.trim(array[i]);
         }
         return array;
      }
      
      [Bindable("change")]
      public function getNumber(bundleName:String, resourceName:String, locale:String = null) : Number
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return NaN;
         }
         var value:* = resourceBundle.content[resourceName];
         return Number(value);
      }
      
      [Bindable("change")]
      public function getInt(bundleName:String, resourceName:String, locale:String = null) : int
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return 0;
         }
         var value:* = resourceBundle.content[resourceName];
         return int(value);
      }
      
      [Bindable("change")]
      public function getUint(bundleName:String, resourceName:String, locale:String = null) : uint
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return 0;
         }
         var value:* = resourceBundle.content[resourceName];
         return uint(value);
      }
      
      [Bindable("change")]
      public function getBoolean(bundleName:String, resourceName:String, locale:String = null) : Boolean
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return false;
         }
         var value:* = resourceBundle.content[resourceName];
         return String(value).toLowerCase() == "true";
      }
      
      [Bindable("change")]
      public function getClass(bundleName:String, resourceName:String, locale:String = null) : Class
      {
         var resourceBundle:IResourceBundle = this.findBundle(bundleName,resourceName,locale);
         if(!resourceBundle)
         {
            return null;
         }
         var value:* = resourceBundle.content[resourceName];
         return value as Class;
      }
      
      private function findBundle(bundleName:String, resourceName:String, locale:String) : IResourceBundle
      {
         this.supportNonFrameworkApps();
         return locale != null ? this.getResourceBundle(locale,bundleName) : this.findResourceBundleWithResource(bundleName,resourceName);
      }
      
      private function supportNonFrameworkApps() : void
      {
         if(this.initializedForNonFrameworkApp)
         {
            return;
         }
         this.initializedForNonFrameworkApp = true;
         if(this.getLocales().length > 0)
         {
            return;
         }
         var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(!applicationDomain.hasDefinition("_CompiledResourceBundleInfo"))
         {
            return;
         }
         var c:Class = Class(applicationDomain.getDefinition("_CompiledResourceBundleInfo"));
         var locales:Array = c.compiledLocales;
         var bundleNames:Array = c.compiledResourceBundleNames;
         this.installCompiledResourceBundles(applicationDomain,locales,bundleNames);
         this.localeChain = locales;
      }
      
      private function getSystemPreferredLocales() : Array
      {
         var systemPreferences:Array = null;
         if(Capabilities["languages"])
         {
            systemPreferences = Capabilities["languages"];
         }
         else
         {
            systemPreferences = [Capabilities.language];
         }
         return systemPreferences;
      }
      
      private function dumpResourceModule(resourceModule:*) : void
      {
         var bundle:ResourceBundle = null;
         var p:String = null;
         for each(bundle in resourceModule.resourceBundles)
         {
            trace(bundle.locale,bundle.bundleName);
            for(p in bundle.content)
            {
            }
         }
      }
   }
}

import flash.events.EventDispatcher;
import mx.events.ModuleEvent;
import mx.events.ResourceEvent;
import mx.modules.IModuleInfo;
import mx.resources.IResourceModule;

class ResourceModuleInfo
{
   
   public var errorHandler:Function;
   
   public var moduleInfo:IModuleInfo;
   
   public var readyHandler:Function;
   
   public var resourceModule:IResourceModule;
   
   public function ResourceModuleInfo(moduleInfo:IModuleInfo, readyHandler:Function, errorHandler:Function)
   {
      super();
      this.moduleInfo = moduleInfo;
      this.readyHandler = readyHandler;
      this.errorHandler = errorHandler;
   }
}

class ResourceEventDispatcher extends EventDispatcher
{
   
   public function ResourceEventDispatcher(moduleInfo:IModuleInfo)
   {
      super();
      moduleInfo.addEventListener(ModuleEvent.ERROR,this.moduleInfo_errorHandler,false,0,true);
      moduleInfo.addEventListener(ModuleEvent.PROGRESS,this.moduleInfo_progressHandler,false,0,true);
      moduleInfo.addEventListener(ModuleEvent.READY,this.moduleInfo_readyHandler,false,0,true);
   }
   
   private function moduleInfo_errorHandler(event:ModuleEvent) : void
   {
      var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.ERROR,event.bubbles,event.cancelable);
      resourceEvent.bytesLoaded = event.bytesLoaded;
      resourceEvent.bytesTotal = event.bytesTotal;
      resourceEvent.errorText = event.errorText;
      dispatchEvent(resourceEvent);
   }
   
   private function moduleInfo_progressHandler(event:ModuleEvent) : void
   {
      var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.PROGRESS,event.bubbles,event.cancelable);
      resourceEvent.bytesLoaded = event.bytesLoaded;
      resourceEvent.bytesTotal = event.bytesTotal;
      dispatchEvent(resourceEvent);
   }
   
   private function moduleInfo_readyHandler(event:ModuleEvent) : void
   {
      var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.COMPLETE);
      dispatchEvent(resourceEvent);
   }
}
