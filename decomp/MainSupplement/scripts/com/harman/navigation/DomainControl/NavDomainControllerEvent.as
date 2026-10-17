package com.harman.navigation.DomainControl
{
   import flash.events.Event;
   
   public class NavDomainControllerEvent extends Event
   {
      
      public static const NAV_IS_OPERABLE:String = "NAV_IsOperable";
      
      public static const NAV_IS_ACTIVE:String = "NAV_IsActive";
      
      public static const NAV_ACTIVE_MENU:String = "NAV_ActiveMenu";
      
      public static const NAV_MEDIA_MAP:String = "NAV_MediaMap";
      
      public static const NAV_DESTINATION_ACCEPTED:String = "NAV_Destination_Accepted";
      
      public static const NAV_DESTINATION_REFUSED:String = "NAV_Destination_Refused";
      
      public static const NAV_EXTERNAL_FORCED_DOMAIN_CHANGE:String = "NAV_External_Forced_Domain_Change";
      
      public static const NAV_INTERNAL_SCREEN_CHANGE_TO_NAV_MAIN_MENU:String = "NAV_Internal_Screen_Change_To_Nav_Main_Menu";
      
      public var mData:Object;
      
      public function NavDomainControllerEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

