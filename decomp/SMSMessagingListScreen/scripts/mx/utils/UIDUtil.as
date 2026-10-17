package mx.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.IUIComponent;
   import mx.core.IUID;
   
   public class UIDUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.1.0.16076";
      
      private static const ALPHA_CHAR_CODES:Array = [48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70];
      
      private static var uidDictionary:Dictionary = new Dictionary(true);
      
      public function UIDUtil()
      {
         super();
      }
      
      public static function createUID() : String
      {
         var i:int = 0;
         var j:int = 0;
         var uid:Array = new Array(36);
         var index:* = 0;
         for(i = 0; i < 8; i++)
         {
            var _loc7_:Number;
            uid[_loc7_ = index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
         }
         for(i = 0; i < 3; i++)
         {
            uid[_loc7_ = index++] = 45;
            for(j = 0; j < 4; j++)
            {
               var _loc8_:Number;
               uid[_loc8_ = index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
            }
         }
         uid[_loc7_ = index++] = 45;
         var time:Number = new Date().getTime();
         var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
         for(i = 0; i < 8; i++)
         {
            uid[_loc8_ = index++] = timeString.charCodeAt(i);
         }
         for(i = 0; i < 4; i++)
         {
            uid[_loc8_ = index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
         }
         return String.fromCharCode.apply(null,uid);
      }
      
      public static function fromByteArray(ba:ByteArray) : String
      {
         var chars:Array = null;
         var index:uint = 0;
         var i:uint = 0;
         var b:int = 0;
         if(ba != null && ba.length >= 16 && ba.bytesAvailable >= 16)
         {
            chars = new Array(36);
            index = 0;
            for(i = 0; i < 16; i++)
            {
               if(i == 4 || i == 6 || i == 8 || i == 10)
               {
                  var _loc6_:uint;
                  chars[_loc6_ = index++] = 45;
               }
               b = ba.readByte();
               chars[_loc6_ = index++] = ALPHA_CHAR_CODES[(b & 0xF0) >>> 4];
               var _loc7_:uint;
               chars[_loc7_ = index++] = ALPHA_CHAR_CODES[b & 0x0F];
            }
            return String.fromCharCode.apply(null,chars);
         }
         return null;
      }
      
      public static function isUID(uid:String) : Boolean
      {
         var i:uint = 0;
         var c:Number = NaN;
         if(uid != null && uid.length == 36)
         {
            for(i = 0; i < 36; i++)
            {
               c = uid.charCodeAt(i);
               if(i == 8 || i == 13 || i == 18 || i == 23)
               {
                  if(c != 45)
                  {
                     return false;
                  }
               }
               else if(c < 48 || c > 70 || c > 57 && c < 65)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public static function toByteArray(uid:String) : ByteArray
      {
         var result:ByteArray = null;
         var i:uint = 0;
         var c:String = null;
         var h1:uint = 0;
         var h2:uint = 0;
         if(isUID(uid))
         {
            result = new ByteArray();
            for(i = 0; i < uid.length; i++)
            {
               c = uid.charAt(i);
               if(c != "-")
               {
                  h1 = getDigit(c);
                  i++;
                  h2 = getDigit(uid.charAt(i));
                  result.writeByte((h1 << 4 | h2) & 0xFF);
               }
            }
            result.position = 0;
            return result;
         }
         return null;
      }
      
      public static function getUID(item:Object) : String
      {
         var result:String = null;
         var xitem:XML = null;
         var nodeKind:String = null;
         var notificationFunction:Function = null;
         result = null;
         if(item == null)
         {
            return result;
         }
         if(item is IUID)
         {
            result = IUID(item).uid;
            if(result == null || result.length == 0)
            {
               result = createUID();
               IUID(item).uid = result;
            }
         }
         else if(item is IPropertyChangeNotifier && !(item is IUIComponent))
         {
            result = IPropertyChangeNotifier(item).uid;
            if(result == null || result.length == 0)
            {
               result = createUID();
               IPropertyChangeNotifier(item).uid = result;
            }
         }
         else
         {
            if(item is String)
            {
               return item as String;
            }
            try
            {
               if(item is XMLList && item.length == 1)
               {
                  item = item[0];
               }
               if(item is XML)
               {
                  xitem = XML(item);
                  nodeKind = xitem.nodeKind();
                  if(nodeKind == "text" || nodeKind == "attribute")
                  {
                     return xitem.toString();
                  }
                  notificationFunction = xitem.notification();
                  if(!(notificationFunction is Function))
                  {
                     notificationFunction = XMLNotifier.initializeXMLForNotification();
                     xitem.setNotification(notificationFunction);
                  }
                  if(notificationFunction["uid"] == undefined)
                  {
                     result = notificationFunction["uid"] = createUID();
                  }
                  result = notificationFunction["uid"];
               }
               else
               {
                  if("mx_internal_uid" in item)
                  {
                     return item.mx_internal_uid;
                  }
                  if("uid" in item)
                  {
                     return item.uid;
                  }
                  result = uidDictionary[item];
                  if(!result)
                  {
                     result = createUID();
                     try
                     {
                        item.mx_internal_uid = result;
                     }
                     catch(e:Error)
                     {
                        uidDictionary[item] = result;
                     }
                  }
               }
            }
            catch(e:Error)
            {
               result = item.toString();
            }
         }
         return result;
      }
      
      private static function getDigit(hex:String) : uint
      {
         switch(hex)
         {
            case "A":
            case "a":
               return 10;
            case "B":
            case "b":
               return 11;
            case "C":
            case "c":
               return 12;
            case "D":
            case "d":
               return 13;
            case "E":
            case "e":
               return 14;
            case "F":
            case "f":
               return 15;
            default:
               return new uint(hex);
         }
      }
   }
}

