package core.locale
{
   import core.api.ILocaleResolver;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public class LocaleResolverSWF implements ILocaleResolver
   {
      
      private static const SWF_TEXT_FUNCTION:String = "getSWFTexts";
      
      private var _rootPath:String;
      
      private var _stringIds:Object;
      
      private var _callbackHandler:Function;
      
      private var _loader:Loader;
      
      private var _currentLanguage:int;
      
      public function LocaleResolverSWF(rootPath:String = null)
      {
         super();
         this._rootPath = rootPath ? rootPath : "textarchive";
         this._stringIds = new Object();
      }
      
      private function ioError(event:IOErrorEvent) : void
      {
         trace("<HMICore> [ Locale ] " + this._rootPath + "/Textarchive_" + this._currentLanguage + ".swf" + " not found!");
      }
      
      public function getTextByResID(resID:int) : String
      {
         if(Boolean(this._stringIds) && Boolean(this._stringIds[resID]))
         {
            return String(this._stringIds[resID]);
         }
         trace("<HMICore> [ Locale ] No string found for " + resID + "!");
         return "";
      }
      
      public function getLanguage() : int
      {
         return this._currentLanguage;
      }
      
      private function onLoadInit(e:Event) : void
      {
         var ldrInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         ldrInfo.removeEventListener(Event.INIT,this.onLoadInit);
         this._stringIds = this._loader.contentLoaderInfo.applicationDomain.getDefinition(SWF_TEXT_FUNCTION + "_" + this._currentLanguage)();
         this._loader.unloadAndStop();
         this._loader = null;
         this._callbackHandler();
      }
      
      public function setLanguage(variantType:int, variantID:int, callbackHandler:Function) : void
      {
         this._callbackHandler = callbackHandler;
         if(variantID == this._currentLanguage)
         {
            return;
         }
         this._currentLanguage = variantID;
         this._loader = new Loader();
         var ldrContext:LoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioError,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(Event.INIT,this.onLoadInit);
         this._loader.load(new URLRequest(this._rootPath + "/Textarchive_" + this._currentLanguage + ".swf"),ldrContext);
      }
   }
}

