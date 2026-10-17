package com.nfuzion.moduleLinkAPI
{
   public class MediaPlayerItemList
   {
      
      private var mOffset:uint;
      
      private var mList:Vector.<MediaPlayerItem>;
      
      public function MediaPlayerItemList(offset:uint, list:Vector.<MediaPlayerItem>)
      {
         super();
         this.mOffset = offset;
         this.mList = list;
      }
      
      public function get offset() : uint
      {
         return this.mOffset;
      }
      
      public function get list() : Vector.<MediaPlayerItem>
      {
         return this.mList;
      }
      
      public function toString(pad:String = "") : String
      {
         var string:String = "{\n" + pad + "  offset = " + this.offset + "\n" + pad + "  list[" + this.list.length + "] = {\n";
         for(var i:int = 0; i < this.list.length; i++)
         {
            string += pad + "    [" + i + "] = " + this.list[i].toString(pad + "      ") + "\n";
         }
         return string + (pad + "   }\n" + pad + "}");
      }
   }
}

