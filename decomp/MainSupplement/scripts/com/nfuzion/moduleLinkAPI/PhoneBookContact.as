package com.nfuzion.moduleLinkAPI
{
   public class PhoneBookContact
   {
      
      public var id:uint;
      
      public var index:uint;
      
      public var firstName:String = "";
      
      public var lastName:String = "";
      
      public var homeNumber:String = "";
      
      public var workNumber:String = "";
      
      public var mobileNumber:String = "";
      
      public var otherNumber:String = "";
      
      public var favIndex:uint = 0;
      
      public var formattedName:String = "";
      
      public function PhoneBookContact(data:Object = null, index:uint = 0)
      {
         super();
         this.index = index;
         if(null != data)
         {
            if(data.hasOwnProperty("contactsId"))
            {
               this.id = data.contactsId;
            }
            if(data.hasOwnProperty("familyName"))
            {
               this.lastName = data.familyName;
            }
            if(data.hasOwnProperty("givenName"))
            {
               this.firstName = data.givenName;
            }
            if(data.hasOwnProperty("homeNumber"))
            {
               this.homeNumber = data.homeNumber;
            }
            if(data.hasOwnProperty("workNumber"))
            {
               this.workNumber = data.workNumber;
            }
            if(data.hasOwnProperty("mobileNumber"))
            {
               this.mobileNumber = data.mobileNumber;
            }
            if(data.hasOwnProperty("otherNumber"))
            {
               this.otherNumber = data.otherNumber;
            }
            if(data.hasOwnProperty("favIndex"))
            {
               this.favIndex = data.favIndex;
            }
            if(data.hasOwnProperty("firstName"))
            {
               this.firstName = data.firstName;
            }
            if(data.hasOwnProperty("lastName"))
            {
               this.lastName = data.lastName;
            }
            if(data.hasOwnProperty("id"))
            {
               this.id = data.id;
            }
            if(data.hasOwnProperty("formattedName"))
            {
               this.formattedName = data.formattedName;
            }
         }
      }
      
      public function importantNumber() : String
      {
         if(this.homeNumber != "")
         {
            return this.homeNumber;
         }
         if(this.workNumber != "")
         {
            return this.workNumber;
         }
         if(this.mobileNumber != "")
         {
            return this.mobileNumber;
         }
         if(this.otherNumber != "")
         {
            return this.otherNumber;
         }
         return this.homeNumber;
      }
   }
}

