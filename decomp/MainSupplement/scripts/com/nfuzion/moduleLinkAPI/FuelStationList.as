package com.nfuzion.moduleLinkAPI
{
   public class FuelStationList
   {
      
      private var mOffset:int;
      
      private var mList:Vector.<FuelStation>;
      
      public function FuelStationList(offset:int, data:Vector.<FuelStation>)
      {
         super();
         this.mOffset = offset;
         this.mList = data;
      }
      
      public function get offset() : int
      {
         return this.mOffset;
      }
      
      public function get list() : Vector.<FuelStation>
      {
         return this.mList;
      }
   }
}

