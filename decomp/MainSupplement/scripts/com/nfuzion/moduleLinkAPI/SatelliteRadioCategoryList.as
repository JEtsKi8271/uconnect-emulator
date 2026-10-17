package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioCategoryList
   {
      
      private var mOffset:uint;
      
      private var mList:Vector.<SatelliteRadioCategory>;
      
      public function SatelliteRadioCategoryList(offset:uint, list:Vector.<SatelliteRadioCategory>)
      {
         super();
         this.mOffset = offset;
         this.mList = list;
      }
      
      public function get offset() : uint
      {
         return this.mOffset;
      }
      
      public function get list() : Vector.<SatelliteRadioCategory>
      {
         return this.mList;
      }
      
      public function get length() : int
      {
         return this.mList.length;
      }
   }
}

