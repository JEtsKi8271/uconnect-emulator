package core.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class LoadXML extends EventDispatcher
   {
      
      protected var mXmlURL:URLRequest;
      
      protected var mXmlLoader:URLLoader;
      
      protected var mUrl:String;
      
      protected var mXml:XML;
      
      public function LoadXML(url:String)
      {
         super();
         this.mUrl = url;
         this.mXmlURL = new URLRequest(this.mUrl);
         this.mXmlLoader = new URLLoader(this.mXmlURL);
         this.mXmlLoader.addEventListener(Event.COMPLETE,this.onComplete);
         this.mXmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      protected function onComplete(event:Event) : void
      {
         this.mXmlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mXmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.mXml = new XML(this.mXmlLoader.data);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onError(event:IOErrorEvent) : void
      {
         this.mXmlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
         this.mXmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
         trace("<HMICore> [ IO ERROR LoadXML ] Error loading XML");
      }
      
      public function get xml() : XML
      {
         return this.mXml;
      }
      
      public function cleanup() : void
      {
         this.mXmlURL = null;
         this.mXmlLoader = null;
         this.mUrl = null;
         this.mXml = null;
      }
   }
}

