package com.harman.navigation.Controller.Persistence
{
   import flash.events.Event;
   
   public class PersistenceEvent extends Event
   {
      
      public static const PERS_ALL_DATA_PERSISTED:String = "PERS_All_Data_Persisted";
      
      public static const PERS_DATA_LOADED:String = "PERS_Data_Loaded";
      
      public static const PERS_IS_BUSY:String = "PERS_Is_Busy";
      
      public static const PERS_REQUEST_TO_PERSIST:String = "PERS_Request_to_Persist";
      
      public function PersistenceEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

