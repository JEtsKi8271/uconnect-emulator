package com.harman.navigation.Controller.FavoriteDestinations
{
   import flash.events.Event;
   
   public class FavoriteDestinationsEvent extends Event
   {
      
      public static const FD_LIST_UPDATE:String = "FD_List_Update";
      
      public static const FD_POSITION_UPDATE:String = "FD_Position_Update";
      
      public static const FD_GET_POSITION:String = "FD_Get_Position";
      
      public function FavoriteDestinationsEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

