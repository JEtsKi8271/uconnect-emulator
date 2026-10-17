package com.harman.navigation.authentication
{
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.moduleLink.ConnectionEvent;
   
   public class AuthenticationServiceManager
   {
      
      private var mParent:Navigation;
      
      private var mDeviceID:String = "";
      
      private var mProductID:String = "";
      
      public function AuthenticationServiceManager(parent:Navigation)
      {
         super();
         this.mParent = parent;
      }
      
      public function getProductDeviceID() : void
      {
         this.mParent.sendServiceCommand(Navigation.dbusAuthenticationIdentifier,"\"deviceID\":{}");
      }
      
      public function get productDeviceID() : String
      {
         return this.mDeviceID;
      }
      
      public function getProductID() : void
      {
         this.mParent.sendServiceCommand(Navigation.dbusAuthenticationIdentifier,"\"productID\":{}");
      }
      
      public function get productID() : String
      {
         return this.mProductID;
      }
      
      public function isProduct(id:String) : Boolean
      {
         if(this.mProductID.indexOf(id) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function authenticationMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("deviceID"))
         {
            if(resp.deviceID.hasOwnProperty("deviceID"))
            {
               this.mDeviceID = resp.deviceID.deviceID;
               this.mParent.sendEvent(NavigationEvent.PRODUCT_DEVICE_ID);
            }
         }
         if(resp.hasOwnProperty("productID"))
         {
            if(resp.productID.hasOwnProperty("productID"))
            {
               this.mProductID = resp.productID.productID;
               this.mParent.sendEvent(NavigationEvent.PRODUCT_ID);
            }
         }
      }
   }
}

