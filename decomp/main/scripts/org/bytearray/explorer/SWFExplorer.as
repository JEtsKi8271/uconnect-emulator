package org.bytearray.explorer
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import org.bytearray.explorer.events.SWFExplorerErrorEvent;
   import org.bytearray.explorer.events.SWFExplorerEvent;
   
   public final class SWFExplorer extends URLLoader
   {
      
      private static const NOT_COMPRESSED:int = 70;
      
      private static const COMPRESSED:int = 67;
      
      private static const FULL:int = 63;
      
      private static const SYMBOLCLASS:int = 76;
      
      private static const FILEATTRIBUTES:int = 69;
      
      public static const CLASSES:String = "classes";
      
      public static const ACCELERATION:String = "acceleration";
      
      public static const NONE:int = 0;
      
      public static const DIRECT:int = 1;
      
      public static const GPU:int = 2;
      
      private var stream:ByteArray;
      
      private var compressed:int;
      
      private var nBits:int;
      
      private var version:int;
      
      private var length:int;
      
      private var swf:ByteArray;
      
      private var frameRate:int;
      
      private var frameCount:int;
      
      private var dictionary:Array;
      
      private var arrayClasses:Array;
      
      private var accelerationType:int;
      
      private var criteria:int;
      
      private var currentByte:int;
      
      private var bitPosition:int;
      
      private var buffer:uint = 0;
      
      private var pointer:uint = 0;
      
      private var source:uint;
      
      public function SWFExplorer()
      {
         super();
         this.arrayClasses = new Array();
         dataFormat = URLLoaderDataFormat.BINARY;
         addEventListener(Event.COMPLETE,this.complete);
      }
      
      private function complete(e:Event) : void
      {
         this.parse(data);
      }
      
      public function parse(bytes:ByteArray, type:String = "classes") : Array
      {
         var symbolClasses:Array = null;
         var i:int = 0;
         var count:int = 0;
         var char:int = 0;
         var name:String = null;
         var symbolClass:TagInfos = null;
         var newChar:String = null;
         this.stream = bytes;
         this.arrayClasses = new Array();
         this.stream.position = 0;
         this.compressed = this.stream.readUnsignedByte();
         this.stream.position += 2;
         this.version = this.stream.readUnsignedByte();
         this.stream.endian = Endian.LITTLE_ENDIAN;
         this.length = this.stream.readUnsignedInt();
         this.stream.endian = Endian.BIG_ENDIAN;
         this.swf = new ByteArray();
         this.stream.readBytes(this.swf,0);
         if(this.compressed == SWFExplorer.COMPRESSED)
         {
            this.swf.uncompress();
         }
         var firstBRect:uint = this.swf.readUnsignedByte();
         var size:uint = uint(firstBRect >> 3);
         var offset:uint = size - 3;
         var threeBits:uint = uint(firstBRect & 7);
         this.source = this.swf.readUnsignedByte();
         var xMin:uint = uint(this.readBits(offset) | (threeBits << offset) / 20);
         var yMin:uint = this.readBits(size) / 20;
         var wMin:uint = this.readBits(size) / 20;
         var hMin:uint = this.readBits(size) / 20;
         var frameRate:uint = uint(this.swf.readShort() & 0xFF);
         var numFrames:uint = uint(this.swf.readShort());
         var frameCount:uint = uint(numFrames >> 8 & 0xFF | (numFrames & 0xFF) << 8);
         this.swf.endian = Endian.LITTLE_ENDIAN;
         this.dictionary = this.browseTables();
         if(type == SWFExplorer.CLASSES)
         {
            this.criteria = SWFExplorer.SYMBOLCLASS;
            this.criteria = 82;
            symbolClasses = this.dictionary.filter(this.filter);
            if(symbolClasses.length > 0)
            {
               for each(symbolClass in symbolClasses)
               {
                  this.swf.position = symbolClass.offset;
                  count = int(this.swf.readUnsignedShort());
                  for(i = 0; i < count; i++)
                  {
                     this.swf.readUnsignedShort();
                     char = this.swf.readByte();
                     name = new String();
                     while(char != 0)
                     {
                        newChar = String.fromCharCode(char);
                        if(newChar == "/")
                        {
                           name += ".";
                        }
                        else
                        {
                           name += newChar;
                        }
                        char = this.swf.readByte();
                     }
                     this.arrayClasses.push(name);
                  }
               }
            }
            else
            {
               dispatchEvent(new SWFExplorerErrorEvent(SWFExplorerErrorEvent.NO_DEFINITIONS));
            }
            dispatchEvent(new SWFExplorerEvent(SWFExplorerEvent.COMPLETE,this.arrayClasses));
         }
         else if(type == SWFExplorer.ACCELERATION)
         {
            this.criteria = SWFExplorer.FILEATTRIBUTES;
            symbolClasses = this.dictionary.filter(this.filter);
            if(symbolClasses.length > 0)
            {
               this.swf.position = symbolClasses[0].offset;
               this.accelerationType = (this.swf.readByte() & 0xE0) >> 5;
            }
         }
         return this.arrayClasses;
      }
      
      private function readBits(numBits:uint) : uint
      {
         var currentMask:uint = 0;
         var bitState:uint = 0;
         this.buffer = 0;
         for(var i:uint = 0; i < numBits; i++)
         {
            currentMask = uint(1 << 7 >> this.pointer++);
            bitState = uint((this.source & currentMask) != 0);
            this.buffer |= bitState << numBits - 1 - i;
            if(this.pointer == 8)
            {
               this.source = this.swf.readUnsignedByte();
               this.pointer = 0;
            }
         }
         return this.buffer;
      }
      
      private function filter(element:TagInfos, index:int, array:Array) : Boolean
      {
         return element.tag == this.criteria;
      }
      
      private function browseTables() : Array
      {
         var currentTag:int = 0;
         var step:int = 0;
         var infos:TagInfos = null;
         var dictionary:Array = new Array();
         while(true)
         {
            currentTag = this.swf.readShort() >> 6 & 0x03FF;
            if(!currentTag)
            {
               break;
            }
            infos = new TagInfos();
            infos.tag = currentTag;
            infos.offset = this.swf.position;
            this.swf.position -= 2;
            step = this.swf.readShort() & 0x3F;
            if(step < SWFExplorer.FULL)
            {
               this.swf.position += step;
            }
            else
            {
               step = int(this.swf.readUnsignedInt());
               infos.offset = this.swf.position;
               this.swf.position += step;
            }
            infos.endOffset = this.swf.position;
            dictionary.push(infos);
         }
         return dictionary;
      }
      
      public function getDefinitions() : Array
      {
         return this.arrayClasses;
      }
      
      public function getTotalDefinitions() : uint
      {
         return this.arrayClasses.length;
      }
      
      public function get acceleration() : int
      {
         return this.accelerationType;
      }
   }
}

final class TagInfos
{
   
   public var offset:int;
   
   public var endOffset:int;
   
   public var tag:int;
   
   public function TagInfos()
   {
      super();
   }
}
