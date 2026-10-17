package com.nfuzion.moduleLinkAPI
{
   public class BluetoothConnectionHistory
   {
      
      private var mAddress:String;
      
      private var mHFPTime:int = 0;
      
      private var mA2DPTime:int = 0;
      
      private var mDUNTime:int = 0;
      
      public function BluetoothConnectionHistory()
      {
         super();
      }
      
      public function get address() : String
      {
         return this.mAddress;
      }
      
      public function set address(a:String) : void
      {
         this.mAddress = a;
      }
      
      public function get HFPTime() : int
      {
         return this.mHFPTime;
      }
      
      public function set HFPTime(t:int) : void
      {
         this.mHFPTime = t;
      }
      
      public function get DUNTime() : int
      {
         return this.mDUNTime;
      }
      
      public function set DUNTime(t:int) : void
      {
         this.mDUNTime = t;
      }
      
      public function get A2DPTime() : int
      {
         return this.mA2DPTime;
      }
      
      public function set A2DPTime(t:int) : void
      {
         this.mA2DPTime = t;
      }
   }
}

