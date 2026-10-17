package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PhoneBookEvent extends Event
   {
      
      public static const AVAILABILITY:String = "availability";
      
      public static const CONTACT:String = "contact";
      
      public static const CONTACT_LIST:String = "contactList";
      
      public static const COUNT:String = "count";
      
      public static const FAVORITES_LIST:String = "favoritesList";
      
      public static const CALLER_ID:String = "callerID";
      
      public static const FAVORITE_UPDATED:String = "favoriteUpdated";
      
      public static const PB_INIT:String = "phonebookInitialized";
      
      public static const EMERGENCY_NUMBER:String = "emergencyNumber";
      
      public static const TOWING_ASSISTANCE_NUMBER:String = "towingAssistanceNumber";
      
      public static const PHONEBOOK_SYNC_UPDATED:String = "phonebookSyncUpdated";
      
      public static const PHONEBOOK_SYNC_STATUS:String = "phonebookSyncStatus";
      
      public static const NEXT_VALID_CHAR:String = "nextValidChar";
      
      public var m_data:Object = null;
      
      public function PhoneBookEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.m_data = data;
      }
   }
}

