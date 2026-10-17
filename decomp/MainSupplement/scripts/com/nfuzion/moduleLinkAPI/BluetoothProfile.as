package com.nfuzion.moduleLinkAPI
{
   public class BluetoothProfile
   {
      
      private var mProfile:String = "";
      
      private var mMajorVersion:int = 0;
      
      private var mMinorVersion:int = 0;
      
      public function BluetoothProfile()
      {
         super();
      }
      
      public function get profile() : String
      {
         return this.mProfile;
      }
      
      public function set profile(s:String) : void
      {
         this.mProfile = s;
      }
      
      public function get majorVersion() : int
      {
         return this.mMajorVersion;
      }
      
      public function set majorVersion(mv:int) : void
      {
         this.mMajorVersion = mv;
      }
      
      public function get minorVersion() : int
      {
         return this.mMinorVersion;
      }
      
      public function set minorVersion(mv:int) : void
      {
         this.mMinorVersion = mv;
      }
   }
}

