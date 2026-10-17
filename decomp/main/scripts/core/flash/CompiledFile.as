package core.flash
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.*;
   
   public class CompiledFile extends EventDispatcher
   {
      
      private var mFileAttemptLevel:int = 0;
      
      private var mUrl:String = null;
      
      protected var mLibraryLoader:Loader;
      
      public var classNames:Array = new Array();
      
      private var mRealUrl:String = null;
      
      public function CompiledFile(url:String)
      {
         super();
         this.mUrl = url;
         this.mRealUrl = url;
         this.load(url);
      }
      
      public function get url() : String
      {
         return this.mRealUrl;
      }
      
      protected function load(url:String) : void
      {
      }
      
      public function getClass(className:String) : Class
      {
         return this.mLibraryLoader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
      }
      
      public function classExtends(inputClass:Class, compareClass:Class) : Boolean
      {
         var extended:String = null;
         var classDef:Object = null;
         var inheritanceData:XML = describeType(inputClass);
         var extendsList:XMLList = inheritanceData..factory.child("extendsClass").@*;
         for each(extended in extendsList)
         {
            try
            {
               classDef = getDefinitionByName(extended);
               if(classDef == compareClass)
               {
                  return true;
               }
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      public function classImplements(inputClass:Class, compareClass:Class) : Boolean
      {
         var extended:String = null;
         var classDef:Object = null;
         var inheritanceData:XML = describeType(inputClass);
         var extendsList:XMLList = inheritanceData..factory.child("implementsInterface").@*;
         for each(extended in extendsList)
         {
            try
            {
               classDef = getDefinitionByName(extended);
               if(classDef == compareClass)
               {
                  return true;
               }
            }
            catch(e:Error)
            {
            }
         }
         return false;
      }
      
      protected function ioError(e:IOErrorEvent) : void
      {
         switch(this.mFileAttemptLevel)
         {
            case 0:
               this.mFileAttemptLevel = 1;
               this.mRealUrl = "file://" + this.mUrl;
               this.load(this.mRealUrl);
               break;
            default:
               trace("<HMICore> [ IO ERROR CompiledFile ] Error accessing file.");
         }
      }
      
      protected function otherError(e:Event) : void
      {
         trace("<HMICore> [ ERROR CompiledFile ] Error accessing or parsing file.  Error type is \"" + e.type + ".\"");
      }
   }
}

