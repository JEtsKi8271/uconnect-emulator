package com.harman.moduleLinkAPI
{
   public class VicsFMInterButton
   {
      
      public var PREV_PAGE_AVAILABLE:Boolean = false;
      
      public var NEXT_PAGE_AVAILABLE:Boolean = false;
      
      public function VicsFMInterButton()
      {
         super();
      }
      
      public function copyVICSFMInterButton(value:Object) : VicsFMInterButton
      {
         this.PREV_PAGE_AVAILABLE = value.prevPageAvailable;
         this.NEXT_PAGE_AVAILABLE = value.nextPageAvailable;
         return this;
      }
   }
}

