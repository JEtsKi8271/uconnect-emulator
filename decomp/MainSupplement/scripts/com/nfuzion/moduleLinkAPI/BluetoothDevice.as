package com.nfuzion.moduleLinkAPI
{
   public class BluetoothDevice
   {
      
      private var mDevName:String;
      
      private var mDevAddress:String;
      
      private var mDataEnabled:Boolean;
      
      private var mProfiles:Vector.<BluetoothProfile> = new Vector.<BluetoothProfile>();
      
      private var mDevCod:int;
      
      private var mDunAvailable:Boolean;
      
      private var mDunConnected:Boolean;
      
      private var mDunPriority:int;
      
      private var mDunTime:int;
      
      private var mPanAvailable:Boolean;
      
      private var mPanConnected:Boolean;
      
      private var mPanPriority:int;
      
      private var mPanTime:int;
      
      private var mHfpAvailable:Boolean;
      
      private var mHfpConnected:Boolean;
      
      private var mHfpPriority:int;
      
      private var mHfpTime:int;
      
      private var mA2dpAvailable:Boolean;
      
      private var mA2dpConnected:Boolean;
      
      private var mA2dpPriority:int;
      
      private var mA2dpTime:int;
      
      public function BluetoothDevice()
      {
         super();
         this.mDevName = "";
         this.mDevAddress = "";
         this.mDataEnabled = false;
         this.mDevCod = -1;
         this.mDunAvailable = false;
         this.mDunConnected = false;
         this.mDunPriority = 0;
         this.mPanAvailable = false;
         this.mPanConnected = false;
         this.mPanPriority = 0;
         this.mHfpAvailable = false;
         this.mHfpConnected = false;
         this.mHfpPriority = 0;
         this.mA2dpAvailable = false;
         this.mA2dpConnected = false;
         this.mA2dpPriority = 0;
      }
      
      public function get DevName() : String
      {
         return this.mDevName;
      }
      
      public function set DevName(s:String) : void
      {
         this.mDevName = s;
      }
      
      public function get DataEnabled() : Boolean
      {
         return this.mDataEnabled;
      }
      
      public function set DataEnabled(b:Boolean) : void
      {
         this.mDataEnabled = b;
      }
      
      public function get DevAddress() : String
      {
         return this.mDevAddress;
      }
      
      public function set DevAddress(s:String) : void
      {
         this.mDevAddress = s;
      }
      
      public function addProfile(bluetoothProfile:BluetoothProfile) : void
      {
         if(bluetoothProfile.profile == "HFP")
         {
            this.mHfpAvailable = true;
         }
         else if(bluetoothProfile.profile == "A2DP")
         {
            this.mA2dpAvailable = true;
         }
         else if(bluetoothProfile.profile == "DUN")
         {
            this.mDunAvailable = true;
         }
         else if(bluetoothProfile.profile == "PAN")
         {
            this.mPanAvailable = true;
         }
         this.mProfiles.push(bluetoothProfile);
      }
      
      public function getProfileAt(index:int) : BluetoothProfile
      {
         if(index < this.mProfiles.length)
         {
            return this.mProfiles[index];
         }
         return null;
      }
      
      public function get DevCod() : int
      {
         return this.mDevCod;
      }
      
      public function set DevCod(i:int) : void
      {
         this.mDevCod = i;
      }
      
      public function get DunAvailable() : Boolean
      {
         return this.mDunAvailable;
      }
      
      public function set DunAvailable(b:Boolean) : void
      {
         this.mDunAvailable = b;
      }
      
      public function get DunConnected() : Boolean
      {
         return this.mDunConnected;
      }
      
      public function set DunConnected(b:Boolean) : void
      {
         var now:Date = new Date();
         this.mDunConnected = b;
         if(b)
         {
            this.mDunTime = now.valueOf() / 1000;
         }
      }
      
      public function get DunPriority() : int
      {
         return this.mDunPriority;
      }
      
      public function set DunPriority(p:int) : void
      {
         this.mDunPriority = p;
      }
      
      public function get PanAvailable() : Boolean
      {
         return this.mPanAvailable;
      }
      
      public function set PanAvailable(b:Boolean) : void
      {
         this.mPanAvailable = b;
      }
      
      public function get PanConnected() : Boolean
      {
         return this.mPanConnected;
      }
      
      public function set PanConnected(b:Boolean) : void
      {
         var now:Date = new Date();
         this.mPanConnected = b;
         if(b)
         {
            this.mPanTime = now.valueOf() / 1000;
         }
      }
      
      public function get PanPriority() : int
      {
         return this.mPanPriority;
      }
      
      public function set PanPriority(p:int) : void
      {
         this.mPanPriority = p;
      }
      
      public function get HfpAvailable() : Boolean
      {
         return this.mHfpAvailable;
      }
      
      public function set HfpAvailable(b:Boolean) : void
      {
         this.mHfpAvailable = b;
      }
      
      public function get HfpConnected() : Boolean
      {
         return this.mHfpConnected;
      }
      
      public function set HfpConnected(b:Boolean) : void
      {
         var now:Date = new Date();
         this.mHfpConnected = b;
         if(b)
         {
            this.mHfpTime = now.valueOf() / 1000;
         }
      }
      
      public function get HfpPriority() : int
      {
         return this.mHfpPriority;
      }
      
      public function set HfpPriority(p:int) : void
      {
         this.mHfpPriority = p;
      }
      
      public function get A2dpAvailable() : Boolean
      {
         return this.mA2dpAvailable;
      }
      
      public function set A2dpAvailable(b:Boolean) : void
      {
         this.mA2dpAvailable = b;
      }
      
      public function get A2dpConnected() : Boolean
      {
         return this.mA2dpConnected;
      }
      
      public function set A2dpConnected(b:Boolean) : void
      {
         var now:Date = new Date();
         this.mA2dpConnected = b;
         if(b)
         {
            this.mA2dpTime = now.valueOf() / 1000;
         }
      }
      
      public function get A2dpPriority() : int
      {
         return this.mA2dpPriority;
      }
      
      public function set A2dpPriority(p:int) : void
      {
         this.mA2dpPriority = p;
      }
      
      public function get a2dpTime() : int
      {
         return this.mA2dpTime;
      }
      
      public function set a2dpTime(t:int) : void
      {
         this.mA2dpTime = t;
      }
      
      public function get dunTime() : int
      {
         return this.mDunTime;
      }
      
      public function set dunTime(t:int) : void
      {
         this.mDunTime = t;
      }
      
      public function get panTime() : int
      {
         return this.mPanTime;
      }
      
      public function set panTime(t:int) : void
      {
         this.mPanTime = t;
      }
      
      public function get hfpTime() : int
      {
         return this.mHfpTime;
      }
      
      public function set hfpTime(t:int) : void
      {
         this.mHfpTime = t;
      }
      
      public function clearProfileList() : void
      {
         var profile:BluetoothProfile = null;
         while(this.mProfiles.length > 0)
         {
            profile = this.mProfiles.pop();
            profile = null;
         }
         this.mA2dpAvailable = false;
         this.mDunAvailable = false;
         this.mHfpAvailable = false;
         this.mA2dpConnected = false;
         this.mDunConnected = false;
         this.mHfpConnected = false;
      }
   }
}

