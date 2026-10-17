package com.nfuzion.moduleLinkAPI
{
   public class BluetoothNetworkOperator
   {
      
      private var mCode:String;
      
      private var mLongName:String;
      
      private var mShortName:String;
      
      private var mMode:String;
      
      private var mACCTech:String;
      
      public function BluetoothNetworkOperator()
      {
         super();
      }
      
      public function get code() : String
      {
         return this.mCode;
      }
      
      public function set code(c:String) : void
      {
         this.mCode = c;
      }
      
      public function get longName() : String
      {
         return this.mLongName;
      }
      
      public function set longName(ln:String) : void
      {
         this.mLongName = ln;
      }
      
      public function get shortName() : String
      {
         return this.mShortName;
      }
      
      public function set shortName(sn:String) : void
      {
         this.mShortName = sn;
      }
      
      public function get mode() : String
      {
         return this.mMode;
      }
      
      public function set mode(m:String) : void
      {
         this.mMode = m;
      }
      
      public function get ACCTech() : String
      {
         return this.mACCTech;
      }
      
      public function set ACCTech(acct:String) : void
      {
         this.mACCTech = acct;
      }
   }
}

