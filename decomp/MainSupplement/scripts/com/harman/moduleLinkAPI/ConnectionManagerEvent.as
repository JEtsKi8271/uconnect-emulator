package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ConnectionManagerEvent extends Event
   {
      
      public static const CONNECT_INTERNET:String = "connectInternet";
      
      public static const DISCONNECT_INTERNET:String = "disconnectInternet";
      
      public static const DISCONNECT_INTERNET_IMMEDIATELY:String = "disconnectInternetImmediately";
      
      public static const INTERNET_CONNECTED:String = "internetConnected";
      
      public static const INTERNET_DISCONNECTED:String = "internetDisconnected";
      
      public static const INTERNET_CONNECT_ERROR:String = "internetConnectError";
      
      public static const SET_ACCESS_POINT:String = "setAccessPoint";
      
      public static const GET_ACCESS_POINT:String = "getAccessPoint";
      
      public static const PRECEDENCE_LIST:String = "getInternetPrecedence";
      
      public static const IP_ADDRESS_CONFLICT:String = "ipAddressConflict";
      
      public static const SWITCH_USAGE:String = "switchEmbeddedPhoneUsage";
      
      public var mData:Object = null;
      
      public function ConnectionManagerEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

