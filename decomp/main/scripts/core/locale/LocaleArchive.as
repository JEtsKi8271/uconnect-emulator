package core.locale
{
   import core.api.ILocaleResolver;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LocaleArchive extends EventDispatcher
   {
      
      private static var _instance:LocaleArchive;
      
      private var _resolver:ILocaleResolver;
      
      private var _initialized:Boolean;
      
      private var _language:int;
      
      public function LocaleArchive(resolver:ILocaleResolver)
      {
         super();
         this._language = -1;
         this._resolver = resolver;
         this._initialized = false;
      }
      
      public static function create(resolver:ILocaleResolver) : LocaleArchive
      {
         if(_instance == null)
         {
            _instance = new LocaleArchive(resolver);
         }
         return _instance;
      }
      
      public static function getInstance() : LocaleArchive
      {
         if(_instance != null)
         {
            return _instance;
         }
         return null;
      }
      
      public function getTextByResID(resID:int) : String
      {
         if(resID <= 0)
         {
            return "";
         }
         return this._resolver.getTextByResID(resID);
      }
      
      public function EVT_LANGUAGE_CHANGED() : String
      {
         return "languageChanged";
      }
      
      private function onLanguageSet() : void
      {
         this._initialized = true;
         dispatchEvent(new Event(this.EVT_LANGUAGE_CHANGED()));
      }
      
      public function getTextByResIDParam(resID:int, replacementDataList:Vector.<LocaleData>) : String
      {
         var strTemp:String = this._resolver.getTextByResID(resID);
         return this.getTextByStrParam(strTemp,replacementDataList);
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function getTextByStrParam(text:String, replacementDataList:Vector.<LocaleData>) : String
      {
         var strRepText:String = null;
         var i:uint = 0;
         var strTemp:String = text;
         var nCount:uint = replacementDataList.length;
         while(i < nCount)
         {
            strRepText = replacementDataList[i].repText;
            if(replacementDataList[i].repResId > 0)
            {
               strRepText = this._resolver.getTextByResID(replacementDataList[i].repResId);
            }
            strTemp = strTemp.split(replacementDataList[i].repTag).join(strRepText);
            i++;
         }
         return strTemp;
      }
      
      public function isMirrored() : Boolean
      {
         return LocaleArchive.getInstance().getLanguage() == 19;
      }
      
      public function setLanguage(variantType:uint, variantID:uint) : void
      {
         if(this._language != variantID)
         {
            this._language = variantID;
            this._resolver.setLanguage(variantType,variantID,this.onLanguageSet);
         }
      }
      
      public function getLanguage() : int
      {
         return this._language;
      }
   }
}

