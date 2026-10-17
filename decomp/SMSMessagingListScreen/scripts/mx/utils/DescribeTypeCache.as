package mx.utils
{
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.binding.BindabilityInfo;
   
   public class DescribeTypeCache
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.1.0.16076";
      
      private static var typeCache:Object = {};
      
      private static var cacheHandlers:Object = {};
      
      registerCacheHandler("bindabilityInfo",bindabilityInfoHandler);
      
      public function DescribeTypeCache()
      {
         super();
      }
      
      public static function describeType(o:*) : DescribeTypeCacheRecord
      {
         var className:String = null;
         var cacheKey:String = null;
         var typeDescription:XML = null;
         var record:DescribeTypeCacheRecord = null;
         if(o is String)
         {
            cacheKey = className = o;
         }
         else
         {
            cacheKey = className = getQualifiedClassName(o);
         }
         if(o is Class)
         {
            cacheKey += "$";
         }
         if(cacheKey in typeCache)
         {
            return typeCache[cacheKey];
         }
         if(o is String)
         {
            o = getDefinitionByName(o);
         }
         typeDescription = flash.utils.describeType(o);
         record = new DescribeTypeCacheRecord();
         record.typeDescription = typeDescription;
         record.typeName = className;
         typeCache[cacheKey] = record;
         return record;
      }
      
      public static function registerCacheHandler(valueName:String, handler:Function) : void
      {
         cacheHandlers[valueName] = handler;
      }
      
      internal static function extractValue(valueName:String, record:DescribeTypeCacheRecord) : *
      {
         if(valueName in cacheHandlers)
         {
            return cacheHandlers[valueName](record);
         }
         return undefined;
      }
      
      private static function bindabilityInfoHandler(record:DescribeTypeCacheRecord) : *
      {
         return new BindabilityInfo(record.typeDescription);
      }
   }
}

