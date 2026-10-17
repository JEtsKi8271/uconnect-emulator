package core.flash
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import org.bytearray.explorer.SWFExplorer;
   
   public class Swf extends CompiledFile
   {
      
      public static const FILE_EXTENSION:String = "swf";
      
      private var targetSwf:URLLoader = new URLLoader();
      
      private var mFileAttemptLevel:int = 0;
      
      private var catalog:XML;
      
      private var mGlobal:Boolean = false;
      
      public function Swf(url:String, global:Boolean = false)
      {
         this.mGlobal = global;
         this.targetSwf.dataFormat = URLLoaderDataFormat.BINARY;
         this.targetSwf.addEventListener(Event.COMPLETE,this.SwfLoaded);
         this.targetSwf.addEventListener(IOErrorEvent.IO_ERROR,ioError);
         this.targetSwf.addEventListener(SecurityErrorEvent.SECURITY_ERROR,otherError);
         super(url);
      }
      
      override protected function load(url:String) : void
      {
         super.load(url);
         var urlRequest:URLRequest = new URLRequest(url);
         this.targetSwf.load(urlRequest);
      }
      
      private function SwfLoaded(e:Event) : void
      {
         var loaderContext:LoaderContext;
         this.targetSwf.removeEventListener(Event.COMPLETE,this.SwfLoaded);
         mLibraryLoader = new Loader();
         loaderContext = new LoaderContext();
         try
         {
            loaderContext["allowCodeImport"] = true;
         }
         catch(e:Error)
         {
            trace("<HMICore> [ ERROR Swf ] loader context problem " + e);
         }
         if(this.mGlobal)
         {
            loaderContext.applicationDomain = ApplicationDomain.currentDomain;
         }
         mLibraryLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.libraryLoaded);
         mLibraryLoader.loadBytes(this.targetSwf.data,loaderContext);
      }
      
      private function libraryLoaded(e:Event) : void
      {
         mLibraryLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.libraryLoaded);
         var explorer:SWFExplorer = new SWFExplorer();
         classNames = explorer.parse(this.targetSwf.data);
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

