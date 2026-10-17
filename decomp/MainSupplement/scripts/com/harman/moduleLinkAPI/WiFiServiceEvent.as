package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class WiFiServiceEvent extends Event
   {
      
      public static const WLAN_STATECHANGED:String = "Wlan_EV_stateChanged";
      
      public static const WLAN_CLIENTJOINED:String = "Wlan_EV_clientJoin";
      
      public static const WLAN_CLIENTLEAVE:String = "Wlan_EV_clientLeave";
      
      public static const WLAN_WPASUCCESS:String = "Wlan_EV_WPASuccess";
      
      public static const WLAN_CURRENT_ROLE:String = "Wlan_Current_Role";
      
      public static const WLAN_RF_ACTIVE:String = "Wlan_RFActive";
      
      public static const WLAN_TEST_MODE:String = "Wlan_Test_Mode";
      
      public static const WLAN_SET_TEST_MODE_RESULT:String = "Wlan_Set_Test_Mode_Result";
      
      public static const WLAN_GET_CLIENT_LIST_RESULT:String = "Wlan_Get_Client_List_Result";
      
      public static const WLAN_GET_AP_PROFILE:String = "Wlan_Get_AP_Profile";
      
      public static const WLAN_GET_WLAN_STATE:String = "Wlan_Get_WLAN_State";
      
      public static const WLAN_GET_SCAN_NETWORK_RESULT:String = "Wlan_Get_Scan_Network_Result";
      
      public static const WLAN_GET_CLIENT_STATUS:String = "Wlan_Get_Client_Status";
      
      public static const WLAN_JOINED_NETWORK:String = "Wlan_Joined_Network";
      
      public static const WLAN_JOIN_NETWORK_FAILURE:String = "Wlan_Join_Network_Failure";
      
      public static const WLAN_LEFT_NETWORK:String = "Wlan_Left_Network";
      
      public static const WLAN_ADD_TO_KNOWN_NETWORKS_RESULT:String = "Wlan_add_to_known_networks_result";
      
      public static const WLAN_DELETE_FROM_KNOWN_NETWORKS_RESULT:String = "Wlan_delete_from_known_networks_result";
      
      public static const WLAN_KNOWN_NETWORKS:String = "Wlan_known_networks";
      
      public static const WLAN_SET_FAVORITE_NETWORK_RESULT:String = "Wlan_set_favorite_network_result";
      
      public static const WLAN_SET_PROFILE_WEP_PASSPHASE_NOT_13:String = "Wlan_set_profile_WEP_passphase_not_13";
      
      public static const WLAN_SET_PROFILE_FAILURE:String = "Wlan_Set_Profile_Failure";
      
      public static const WIFI_READY:String = "WiFi_Ready";
      
      public var mData:Object = null;
      
      public function WiFiServiceEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

