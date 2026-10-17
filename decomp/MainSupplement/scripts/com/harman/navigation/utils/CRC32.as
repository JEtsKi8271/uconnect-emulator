package com.harman.navigation.utils
{
   import flash.utils.ByteArray;
   
   public class CRC32
   {
      
      private static var crcTable:Array = makeCrcTable();
      
      private var crc:uint;
      
      public function CRC32()
      {
         super();
      }
      
      private static function makeCrcTable() : Array
      {
         var c:uint = 0;
         var k:int = 0;
         var crcTable:Array = new Array(256);
         for(var n:int = 0; n < 256; n++)
         {
            c = uint(n);
            for(k = 8; --k >= 0; )
            {
               if((c & 1) != 0)
               {
                  c = uint(0xEDB88320 ^ c >>> 1);
               }
               else
               {
                  c >>>= 1;
               }
            }
            crcTable[n] = c;
         }
         return crcTable;
      }
      
      public function getValue() : uint
      {
         return this.crc & 0xFFFFFFFF;
      }
      
      public function reset() : void
      {
         this.crc = 0;
      }
      
      public function update(buf:ByteArray) : void
      {
         var off:uint = 0;
         var len:uint = buf.length;
         var c:uint = uint(~this.crc);
         while(--len >= 0)
         {
            c = uint(crcTable[(c ^ buf[off++]) & 0xFF] ^ c >>> 8);
         }
         this.crc = ~c;
      }
      
      public function getCrcFromObject(obj:Object) : uint
      {
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeObject(obj);
         this.reset();
         this.update(byteArray);
         return this.getValue();
      }
   }
}

