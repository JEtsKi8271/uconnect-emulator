package com.nfuzion.moduleLinkAPI
{
   public class PhoneCallListEntry
   {
      
      public static const RECEIVED:String = "RC";
      
      public static const DIALED:String = "DC";
      
      public static const MISSED:String = "MC";
      
      private var mIndex:uint;
      
      private var mCallType:String;
      
      private var mFirstName:String = "";
      
      private var mLastName:String = "";
      
      private var mPhoneNumber:String = "";
      
      private var mAddress:String = "";
      
      private var mTimeStamp:String = "";
      
      private var mStorageType:String = "";
      
      public function PhoneCallListEntry(data:Object, index:uint, list:String)
      {
         super();
         this.mIndex = index;
         this.mCallType = list;
         if(data.hasOwnProperty("lastName"))
         {
            this.mLastName = data.lastName;
         }
         if(data.hasOwnProperty("givenName"))
         {
            this.mFirstName = data.givenName;
         }
         if(data.hasOwnProperty("telephoneNumber"))
         {
            this.mPhoneNumber = data.telephoneNumber;
         }
         if(data.hasOwnProperty("StorageType"))
         {
            this.mStorageType = data.StorageType;
         }
         else
         {
            switch(this.mCallType)
            {
               case PhoneCallListEvent.DIALED_CALLS_LIST:
                  this.mStorageType = DIALED;
                  break;
               case PhoneCallListEvent.RECEIVED_CALLS_LIST:
                  this.mStorageType = RECEIVED;
                  break;
               case PhoneCallListEvent.MISSED_CALLS_LIST:
                  this.mStorageType = MISSED;
            }
         }
         if(data.hasOwnProperty("timeStamp"))
         {
            this.mTimeStamp = data.timeStamp;
         }
         if(data.hasOwnProperty("numberType"))
         {
            this.mCallType = data.numberType;
         }
      }
      
      public function get index() : uint
      {
         return this.mIndex;
      }
      
      public function get firstName() : String
      {
         return this.mFirstName;
      }
      
      public function get lastName() : String
      {
         return this.mLastName;
      }
      
      public function get phoneNumber() : String
      {
         return this.mPhoneNumber;
      }
      
      public function get Address() : String
      {
         return this.mAddress;
      }
      
      public function get timeStamp() : String
      {
         return this.mTimeStamp;
      }
      
      public function get callType() : String
      {
         return this.mCallType;
      }
      
      public function get StorageType() : String
      {
         return this.mStorageType;
      }
   }
}

