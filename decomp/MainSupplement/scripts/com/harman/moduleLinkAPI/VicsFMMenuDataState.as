package com.harman.moduleLinkAPI
{
   public class VicsFMMenuDataState
   {
      
      public var TEXT_AVAILABLE:Boolean = false;
      
      public var DIAG_AVAILABLE:Boolean = false;
      
      public function VicsFMMenuDataState()
      {
         super();
      }
      
      public function copyVICSFMMenuDataState(value:Object) : VicsFMMenuDataState
      {
         if(value != null)
         {
            this.TEXT_AVAILABLE = value.textAvailable;
            this.DIAG_AVAILABLE = value.diagAvailable;
         }
         return this;
      }
   }
}

